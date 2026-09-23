import 'dart:io';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// Lightweight XLSX reader that parses the raw OpenXML ZIP without
/// the `excel` package.  This bypasses the notorious
/// "custom numFmtId starts at 164" crash entirely.
class XlsxReader {
  XlsxReader._(this._sheets);

  final Map<String, List<List<String>>> _sheets;

  /// Sheet names in original order.
  List<String> get sheetNames => _sheets.keys.toList();

  /// Returns all rows of [sheetName] as `List<List<String>>`.
  List<List<String>> rows(String sheetName) => _sheets[sheetName] ?? const [];

  /// Number of sheets.
  int get sheetCount => _sheets.length;

  /// Total row count across all sheets.
  int get totalRowCount =>
      _sheets.values.fold<int>(0, (n, rows) => n + rows.length);

  // ──────────────────────────────────────────────
  //  Public factory
  // ──────────────────────────────────────────────
  static XlsxReader readFile(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return readBytes(bytes);
  }

  static XlsxReader readBytes(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);

    // 1. Parse shared strings (SST)
    final sst = _parseSharedStrings(archive);

    // 2. Discover sheet names → rIds from workbook.xml
    final sheetOrder = _parseWorkbook(archive);

    // 3. Map rIds → file paths from _rels/workbook.xml.rels
    final rIdToPath = _parseRels(archive);

    // 4. Read each sheet
    final sheets = <String, List<List<String>>>{};
    for (final entry in sheetOrder) {
      final name = entry.key;
      final rId = entry.value;
      final path = rIdToPath[rId];
      if (path == null) continue;

      final sheetFile = _findFile(archive, path);
      if (sheetFile == null) continue;

      final rows = _parseSheet(sheetFile, sst);
      sheets[name] = rows;
    }

    return XlsxReader._(sheets);
  }

  // ──────────────────────────────────────────────
  //  Shared Strings Table (SST)
  // ──────────────────────────────────────────────
  static List<String> _parseSharedStrings(Archive archive) {
    final file = _findFile(archive, 'xl/sharedStrings.xml');
    if (file == null) return const [];

    final doc = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
    final ns = doc.rootElement.name.namespaceUri ?? '';

    return doc.rootElement
        .findAllElements('si', namespace: ns.isEmpty ? '*' : ns)
        .map((si) {
      // <si> can contain <t> directly or <r><t>…</t></r> runs
      final buf = StringBuffer();
      for (final t in si.findAllElements('t', namespace: '*')) {
        buf.write(t.innerText);
      }
      return buf.toString();
    }).toList();
  }

  // ──────────────────────────────────────────────
  //  workbook.xml → ordered sheet name + rId
  // ──────────────────────────────────────────────
  static List<MapEntry<String, String>> _parseWorkbook(Archive archive) {
    final file = _findFile(archive, 'xl/workbook.xml');
    if (file == null) return const [];

    final doc = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
    final sheets = doc.rootElement.findAllElements('sheet', namespace: '*');

    return sheets.map((e) {
      final name = e.getAttribute('name') ?? '';
      // r:id is in the relationships namespace
      final rId = e.getAttribute('id', namespace: '*') ?? '';
      return MapEntry(name, rId);
    }).toList();
  }

  // ──────────────────────────────────────────────
  //  _rels/workbook.xml.rels → rId → Target path
  // ──────────────────────────────────────────────
  static Map<String, String> _parseRels(Archive archive) {
    final file = _findFile(archive, 'xl/_rels/workbook.xml.rels');
    if (file == null) return const {};

    final doc = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
    final map = <String, String>{};
    for (final rel in doc.rootElement.findAllElements('Relationship', namespace: '*')) {
      final id = rel.getAttribute('Id') ?? '';
      var target = rel.getAttribute('Target') ?? '';
      // Normalize: some files use relative paths like "worksheets/sheet1.xml"
      if (!target.startsWith('/') && !target.startsWith('xl/')) {
        target = 'xl/$target';
      }
      if (target.startsWith('/')) {
        target = target.substring(1);
      }
      map[id] = target;
    }
    return map;
  }

  // ──────────────────────────────────────────────
  //  Parse a single sheet XML → List<List<String>>
  // ──────────────────────────────────────────────
  static List<List<String>> _parseSheet(ArchiveFile file, List<String> sst) {
    final doc = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
    final sheetData = doc.rootElement.findAllElements('sheetData', namespace: '*').firstOrNull;
    if (sheetData == null) return const [];

    final rows = <List<String>>[];
    var prevRowIdx = -1;

    for (final rowEl in sheetData.findAllElements('row', namespace: '*')) {
      final rowIdxStr = rowEl.getAttribute('r');
      final rowIdx = rowIdxStr != null ? int.tryParse(rowIdxStr) ?? (prevRowIdx + 2) : prevRowIdx + 2;
      
      // Fill missing rows with empty lists (sparse rows)
      while (rows.length < rowIdx - 1) {
        rows.add([]);
      }

      final cells = <String>[];
      var maxCol = -1;
      var currentColIdx = 0; // Track sequential column index if 'r' is missing

      for (final cEl in rowEl.findAllElements('c', namespace: '*')) {
        final ref = cEl.getAttribute('r');
        final colIdx = ref != null && ref.isNotEmpty ? _colIndex(ref) : currentColIdx;
        currentColIdx = colIdx + 1; // Next cell will be right after this one

        final type = cEl.getAttribute('t') ?? '';

        // Fill gaps between columns
        while (cells.length <= colIdx) {
          cells.add('');
        }

        final vEl = cEl.findAllElements('v', namespace: '*').firstOrNull;
        final isEl = cEl.findAllElements('is', namespace: '*').firstOrNull;

        String value = '';
        if (type == 's') {
          // Shared string
          final idx = int.tryParse(vEl?.innerText ?? '');
          value = (idx != null && idx < sst.length) ? sst[idx] : '';
        } else if (type == 'inlineStr' || isEl != null) {
          // Inline string
          final tEls = (isEl ?? cEl).findAllElements('t', namespace: '*');
          final buf = StringBuffer();
          for (final t in tEls) {
            buf.write(t.innerText);
          }
          value = buf.toString();
        } else if (type == 'b') {
          // Boolean
          value = vEl?.innerText == '1' ? 'TRUE' : 'FALSE';
        } else if (type == 'e') {
          // Error
          value = vEl?.innerText ?? '#ERR';
        } else {
          // Number or date (just keep as text)
          value = vEl?.innerText ?? '';
        }

        cells[colIdx] = value;
        if (colIdx > maxCol) maxCol = colIdx;
      }

      rows.add(cells);
      prevRowIdx = rowIdx;
    }

    return rows;
  }

  // ──────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────

  /// Converts an Excel cell reference like "AB12" → column index (0-based).
  static int _colIndex(String cellRef) {
    var col = 0;
    for (var i = 0; i < cellRef.length; i++) {
      final ch = cellRef.codeUnitAt(i);
      if (ch >= 65 && ch <= 90) {
        // A-Z
        col = col * 26 + (ch - 64);
      } else if (ch >= 97 && ch <= 122) {
        // a-z
        col = col * 26 + (ch - 96);
      } else {
        break;
      }
    }
    return col - 1; // 0-based
  }

  /// Find a file in the archive by path (case-insensitive).
  static ArchiveFile? _findFile(Archive archive, String path) {
    final lower = path.toLowerCase();
    for (final f in archive.files) {
      if (f.name.toLowerCase() == lower) return f;
    }
    // Try without leading xl/ or with it
    for (final f in archive.files) {
      final fLower = f.name.toLowerCase();
      if (fLower.endsWith(lower) || lower.endsWith(fLower)) return f;
    }
    return null;
  }
}
