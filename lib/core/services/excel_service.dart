import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import '../extraction/extraction_result.dart';
import '../extraction/file_gate.dart';
import '../extraction/sheet_classifier.dart';
import '../extraction/test_case_schema.dart';

class ExcelService {
  Future<ExtractionResult> extractTestCases(String filePath) async {
    final inspection = FileGate.inspect(filePath);
    if (inspection.rejected) {
      throw FileRejectedException(
        inspection.rejectReason ?? 'File không hợp lệ.',
      );
    }
    return compute(extractExcelSync, filePath);
  }
}

class ExcelPeek {
  const ExcelPeek({required this.sheetCount, required this.rowCount});
  final int sheetCount;
  final int rowCount;
}

ExcelPeek peekExcelSync(String filePath) {
  final result = extractExcelSync(filePath);
  return ExcelPeek(sheetCount: result.sheetCount, rowCount: result.rowCount);
}

ExtractionResult extractExcelSync(String filePath) {
  final inspection = FileGate.inspect(filePath);
  if (inspection.rejected) {
    throw FileRejectedException(
      inspection.rejectReason ?? 'File không hợp lệ.',
    );
  }
  if (inspection.kind == DetectedKind.xlsOle) {
    throw FileRejectedException(
      'Không đọc được .xls (định dạng cũ). Mở Excel lưu lại .xlsx.',
    );
  }

  try {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    return _fromWorkbook(excel, sizeBytes: inspection.sizeBytes);
  } on FileRejectedException {
    rethrow;
  } catch (e) {
    throw FileRejectedException('Lỗi khi đọc file Excel: $e');
  }
}

ExtractionResult extractExcelFromRows(
  Map<String, List<List<String>>> sheets, {
  int budgetChars = FileGate.promptBudgetChars,
  int sizeBytes = 0,
}) {
  final sheetNames = sheets.keys.map((s) => s.toLowerCase().trim()).toList();
  final hasFunctions = sheetNames.contains('functions');
  final fPrefixCount = sheets.keys
      .where((s) => RegExp(r'^f\d+', caseSensitive: false).hasMatch(s))
      .length;
  if (hasFunctions || fPrefixCount >= 3) {
    throw FileRejectedException(
      'File này là Unit Test (kiểm thử hàm). Vui lòng chọn file Test Report đồ án (System/Module Test như M01, M02...).',
    );
  }

  final skipped = <String>[];
  final kept = <String, List<TestCaseRecord>>{};

  for (final entry in sheets.entries) {
    final verdict = classifySheet(name: entry.key, rows: entry.value);
    if (!verdict.keep) {
      skipped.add('${entry.key} (${verdict.skipReason})');
      continue;
    }
    final records = <TestCaseRecord>[];
    for (var i = verdict.headerRowIndex + 1; i < entry.value.length; i++) {
      final row = entry.value[i];
      if (!rowHasContent(row)) continue;
      final rec = recordFromRow(
        sheet: entry.key,
        row: row,
        columns: verdict.columns,
      );
      if (rec.id.isEmpty && rec.description.isEmpty) continue;
      if (rec.steps.isEmpty &&
          rec.expected.isEmpty &&
          (rec.id.isEmpty || rec.description.isEmpty)) {
        continue;
      }
      records.add(rec);
    }
    if (records.isEmpty) {
      skipped.add('${entry.key} (không có dòng dữ liệu)');
      continue;
    }
    kept[entry.key] = records;
  }

  return _cutSheets(
    kept,
    rawSheets: sheets,
    skipped: skipped,
    budgetChars: budgetChars,
    sizeBytes: sizeBytes,
    sheetCount: sheets.length,
    rowCount: sheets.values.fold<int>(0, (n, rows) => n + rows.length),
  );
}

ExtractionResult _fromWorkbook(Excel excel, {required int sizeBytes}) {
  final sheets = <String, List<List<String>>>{};
  for (final name in excel.tables.keys) {
    final sheet = excel.tables[name];
    if (sheet == null) continue;
    sheets[name] = _readRows(sheet);
  }
  return extractExcelFromRows(sheets, sizeBytes: sizeBytes);
}

List<List<String>> _readRows(Sheet sheet) {
  final rows = <List<String>>[];
  var emptyStreak = 0;
  for (var i = 0; i < sheet.maxRows; i++) {
    final row = sheet
        .row(i)
        .map((cell) => cell?.value?.toString().trim() ?? '')
        .toList();
    if (!rowHasContent(row)) {
      emptyStreak++;
      if (emptyStreak >= 50) break;
      continue;
    }
    emptyStreak = 0;
    rows.add(row);
  }
  return rows;
}

ExtractionResult _cutSheets(
  Map<String, List<TestCaseRecord>> kept, {
  Map<String, List<List<String>>> rawSheets = const {},
  required List<String> skipped,
  required int budgetChars,
  required int sizeBytes,
  required int sheetCount,
  required int rowCount,
}) {
  final cap = budgetChars < FileGate.maxIsolateStringBytes
      ? budgetChars
      : FileGate.maxIsolateStringBytes;
  final names = kept.keys.toList();
  final copies = {
    for (final name in names) name: List<TestCaseRecord>.from(kept[name]!),
  };
  var truncated = false;
  final unknown = <String>[];

  String render() => _renderSheets(copies);

  while (render().length > cap && copies.isNotEmpty) {
    truncated = true;
    final last = copies.keys.last;
    final list = copies[last]!;
    if (list.isNotEmpty) {
      list.removeLast();
      if (list.isEmpty) {
        copies.remove(last);
        unknown.insert(0, last);
      }
    } else {
      copies.remove(last);
      unknown.insert(0, last);
    }
  }

  final records = copies.values.expand((e) => e).toList();
  final text = [
    render(),
    ...unknown.map((m) => 'UNKNOWN: $m'),
  ].where((s) => s.trim().isNotEmpty).join('\n\n');

  return ExtractionResult(
    text: text,
    skippedSheets: skipped,
    unknownModules: unknown,
    truncated: truncated,
    sizeBytes: sizeBytes,
    sheetCount: sheetCount,
    rowCount: rowCount,
    records: records,
    rawSheets: rawSheets,
  );
}

String _renderSheets(Map<String, List<TestCaseRecord>> sheets) {
  final buf = StringBuffer();
  for (final entry in sheets.entries) {
    buf.writeln('Sheet: ${entry.key}');
    for (final rec in entry.value) {
      buf.writeln('- Test Case:');
      void line(String label, String value) {
        if (value.isNotEmpty) buf.writeln('  $label: $value');
      }

      line('ID', rec.canonicalId.isEmpty ? rec.id : rec.canonicalId);
      line('Description', rec.description);
      line('Pre-Condition', rec.preCondition);
      line('Steps', rec.steps);
      line('Test Data', rec.testData);
      line('Expected Output', rec.expected);
      line('Status', rec.status);
      line('Test date', rec.testDate);
      line('Note', rec.note);
      line('Bug', rec.bug);
    }
    buf.writeln();
  }
  return buf.toString().trim();
}
