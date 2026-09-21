import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import '../services/cross_check_models.dart';
import 'extraction_result.dart';
import 'file_gate.dart';

const _wordNs = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';

final _romanHeading = RegExp(
  r'^[IVXLCDM]+[.)]\s+\S',
  caseSensitive: false,
);
final _numericHeading = RegExp(r'^(\d+(?:\.\d+)*)(?:[.)]|(?=\s))\s+\S');

ArchiveFile? archiveFile(Archive archive, String name) {
  final want = name.replaceAll('\\', '/');
  for (final file in archive.files) {
    if (file.name.replaceAll('\\', '/') == want) return file;
  }
  return null;
}

String decodeArchiveFile(ArchiveFile file) {
  final content = file.content;
  if (content is List<int>) return utf8.decode(content);
  throw FileRejectedException('Không đọc được ${file.name}.');
}

bool looksLikeDocx(Archive archive) {
  return archiveFile(archive, 'word/document.xml') != null;
}

Map<String, int> headingLevelsFromStyles(String stylesXml) {
  final xml = XmlDocument.parse(stylesXml);
  final direct = <String, int>{};
  final basedOn = <String, String>{};

  for (final style in xml.findAllElements('style', namespace: _wordNs)) {
    final id = _wVal(style, 'styleId');
    if (id == null || id.isEmpty) continue;
    final nameEl = _first(style, 'name');
    final name = nameEl == null ? '' : (_wVal(nameEl, 'val') ?? '');
    final based = _first(style, 'basedOn');
    if (based != null) {
      final parent = _wVal(based, 'val');
      if (parent != null) basedOn[id] = parent;
    }

    final headingN = RegExp(r'^(?:Heading|heading)\s*([1-6])$');
    final idMatch = headingN.firstMatch(id);
    final nameMatch = headingN.firstMatch(name);
    if (idMatch != null) {
      direct[id] = int.parse(idMatch.group(1)!);
      continue;
    }
    if (nameMatch != null) {
      direct[id] = int.parse(nameMatch.group(1)!);
      continue;
    }
    final outline = style.findAllElements('outlineLvl', namespace: _wordNs);
    if (outline.isNotEmpty) {
      final raw = _wVal(outline.first, 'val');
      final n = int.tryParse(raw ?? '');
      if (n != null && n >= 0 && n <= 5) direct[id] = n + 1;
    }
  }

  int? resolve(String id) {
    final seen = <String>{};
    var cur = id;
    while (true) {
      if (direct.containsKey(cur)) return direct[cur];
      if (!seen.add(cur)) return null;
      final next = basedOn[cur];
      if (next == null) return null;
      cur = next;
    }
  }

  final out = <String, int>{};
  for (final id in {...direct.keys, ...basedOn.keys}) {
    final level = resolve(id);
    if (level != null) out[id] = level;
  }
  return out;
}

int? numberedHeadingLevel(String text) {
  final trimmed = text.trim();
  if (_romanHeading.hasMatch(trimmed)) return 1;
  final m = _numericHeading.firstMatch(trimmed);
  if (m == null) return null;
  return m.group(1)!.split('.').length.clamp(1, 6);
}

List<DocBlock> blocksFromDocxXml({
  required String documentXml,
  Map<String, int> headingLevels = const {},
}) {
  final xml = XmlDocument.parse(documentXml);
  final body = xml.rootElement.childElements
      .where((e) => e.localName == 'body')
      .firstOrNull;
  if (body == null) return const [];

  final blocks = <DocBlock>[];
  for (final node in body.childElements) {
    if (node.localName == 'p') {
      final text = _paragraphText(node).trim();
      if (text.isEmpty) continue;
      final level = _paragraphLevel(node, headingLevels) ??
          numberedHeadingLevel(text);
      if (level != null) {
        blocks.add(DocBlock(kind: DocBlockKind.heading, text: text, level: level));
      } else {
        blocks.add(DocBlock(kind: DocBlockKind.paragraph, text: text));
      }
    } else if (node.localName == 'tbl') {
      final table = _tableText(node);
      if (table.isNotEmpty) {
        blocks.add(DocBlock(kind: DocBlockKind.table, text: table));
      }
    }
  }
  return blocks;
}

List<DocBlock> blocksFromPlainText(String text) {
  final blocks = <DocBlock>[];
  for (final raw in text.split(RegExp(r'\r?\n'))) {
    final line = raw.trim();
    if (line.isEmpty) continue;
    final level = numberedHeadingLevel(line);
    if (level != null) {
      blocks.add(DocBlock(kind: DocBlockKind.heading, text: line, level: level));
    } else {
      blocks.add(DocBlock(kind: DocBlockKind.paragraph, text: line));
    }
  }
  return blocks;
}

ExtractionResult extractDocxArchive(
  Archive archive, {
  int budgetChars = FileGate.promptBudgetChars,
  int sizeBytes = 0,
}) {
  final docFile = archiveFile(archive, 'word/document.xml');
  if (docFile == null) {
    throw FileRejectedException(
      'File đội lốt .docx (không có word/document.xml).',
    );
  }
  final stylesFile = archiveFile(archive, 'word/styles.xml');
  final levels = stylesFile == null
      ? <String, int>{}
      : headingLevelsFromStyles(decodeArchiveFile(stylesFile));
  final blocks = blocksFromDocxXml(
    documentXml: decodeArchiveFile(docFile),
    headingLevels: levels,
  );
  return _cutAndRender(blocks, budgetChars: budgetChars, sizeBytes: sizeBytes);
}

ExtractionResult extractPlainDocument(
  String text, {
  int budgetChars = FileGate.promptBudgetChars,
  int sizeBytes = 0,
}) {
  return _cutAndRender(
    blocksFromPlainText(text),
    budgetChars: budgetChars,
    sizeBytes: sizeBytes,
  );
}

ExtractionResult _cutAndRender(
  List<DocBlock> blocks, {
  required int budgetChars,
  required int sizeBytes,
}) {
  final cap = budgetChars < FileGate.maxIsolateStringBytes
      ? budgetChars
      : FileGate.maxIsolateStringBytes;
  final cut = cutByStructure(blocks, budgetChars: cap);
  final text = renderBlocks(cut.kept);
  final unknownLines = cut.unknownModules.map((m) => 'UNKNOWN: $m').join('\n');
  final combined = [
    text,
    if (unknownLines.isNotEmpty) unknownLines,
  ].where((s) => s.trim().isNotEmpty).join('\n\n');
  final ExtractionAvailability availability;
  if (combined.trim().isEmpty) {
    availability = const ExtractionAvailability.unsupported(
      code: 'EMPTY_DOCUMENT',
      message: 'Tài liệu không có nội dung văn bản (có thể là file rỗng hoặc scan/ảnh).',
    );
  } else if (cut.truncated) {
    availability = const ExtractionAvailability.partial(
      code: 'PROMPT_BUDGET_TRUNCATED',
      message: 'Tài liệu bị cắt bớt do vượt quá giới hạn ký tự.',
    );
  } else {
    availability = const ExtractionAvailability.complete();
  }

  return ExtractionResult(
    text: combined,
    unknownModules: cut.unknownModules,
    truncated: cut.truncated,
    sizeBytes: sizeBytes,
    availability: availability,
  );
}

int? _paragraphLevel(XmlElement p, Map<String, int> headingLevels) {
  final pPr = _first(p, 'pPr');
  if (pPr == null) return null;
  final style = _first(pPr, 'pStyle');
  if (style != null) {
    final id = _wVal(style, 'val');
    if (id != null && headingLevels.containsKey(id)) {
      return headingLevels[id];
    }
  }
  final outline = _first(pPr, 'outlineLvl');
  if (outline != null) {
    final n = int.tryParse(_wVal(outline, 'val') ?? '');
    if (n != null && n >= 0 && n <= 5) return n + 1;
  }
  return null;
}

String _paragraphText(XmlElement p) {
  final buf = StringBuffer();
  for (final t in p.findAllElements('t', namespace: _wordNs)) {
    buf.write(t.innerText);
  }
  return buf.toString();
}

String _tableText(XmlElement tbl) {
  final rows = <String>[];
  for (final tr in tbl.childElements) {
    if (tr.localName != 'tr') continue;
    final cells = <String>[];
    for (final tc in tr.childElements) {
      if (tc.localName != 'tc') continue;
      final buf = StringBuffer();
      for (final t in tc.findAllElements('t', namespace: _wordNs)) {
        if (buf.isNotEmpty) buf.write(' ');
        buf.write(t.innerText.trim());
      }
      cells.add(buf.toString());
    }
    if (cells.any((c) => c.isNotEmpty)) {
      rows.add(cells.join(' | '));
    }
  }
  return rows.join('\n');
}

XmlElement? _first(XmlElement parent, String local) {
  for (final child in parent.childElements) {
    if (child.localName == local) return child;
  }
  return null;
}

String? _wVal(XmlElement e, String name) {
  return e.getAttribute(name, namespace: _wordNs) ?? e.getAttribute(name);
}
