import 'package:flutter/foundation.dart';

import '../extraction/extraction_result.dart';
import '../extraction/file_gate.dart';
import '../extraction/sheet_classifier.dart';
import '../extraction/test_case_schema.dart';
import '../extraction/workbook_snapshot.dart';
import 'cross_check_models.dart';
import 'xlsx_reader.dart';

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
    // Use custom XlsxReader instead of `excel` package to avoid numFmtId bug
    final reader = XlsxReader.readFile(filePath);
    final workbook = _snapshotFromXlsxReader(reader);
    return extractExcelFromWorkbook(workbook, sizeBytes: inspection.sizeBytes);
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
  final workbook = _snapshotFromTextSheets(sheets);
  return extractExcelFromWorkbook(
    workbook,
    budgetChars: budgetChars,
    sizeBytes: sizeBytes,
  );
}

ExtractionResult extractExcelFromWorkbook(
  WorkbookSnapshot workbook, {
  int budgetChars = FileGate.promptBudgetChars,
  int sizeBytes = 0,
}) {
  final sheetNames = workbook.sheetNames.map((s) => s.toLowerCase().trim()).toList();
  final hasFunctions = sheetNames.contains('functions');
  final fPrefixCount = workbook.sheetNames
      .where((s) => RegExp(r'^f\d+', caseSensitive: false).hasMatch(s))
      .length;
  if (hasFunctions || fPrefixCount >= 3) {
    throw FileRejectedException(
      'File này là Unit Test (kiểm thử hàm). Vui lòng chọn file Test Report đồ án (System/Module Test như M01, M02...).',
    );
  }

  final skipped = <String>[];
  final kept = <String, List<TestCaseRecord>>{};

  for (final sheet in workbook.sheets) {
    final textRows = sheet.toTextRows();
    final verdict = classifySheet(name: sheet.name, rows: textRows);
    if (!verdict.keep) {
      skipped.add('${sheet.name} (${verdict.skipReason})');
      continue;
    }
    final records = <TestCaseRecord>[];
    for (var i = verdict.headerRowIndex + 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      if (!row.hasContent) continue;
      final rec = recordFromRow(
        sheet: sheet.name,
        row: row.toTextList(),
        columns: verdict.columns,
        sourceRow: row.rowIndex + 1,
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
      skipped.add('${sheet.name} (không có dòng dữ liệu)');
      continue;
    }
    kept[sheet.name] = records;
  }

  return _cutSheets(
    kept,
    workbook: workbook,
    skipped: skipped,
    budgetChars: budgetChars,
    sizeBytes: sizeBytes,
    sheetCount: workbook.sheets.length,
    rowCount: workbook.sheets.fold<int>(0, (n, s) => n + s.rows.length),
  );
}

WorkbookSnapshot _snapshotFromXlsxReader(XlsxReader reader) {
  final sheets = <WorkbookSheet>[];
  for (final name in reader.sheetNames) {
    final textRows = reader.rows(name);
    final rows = <WorkbookRow>[];
    var emptyStreak = 0;
    for (var r = 0; r < textRows.length; r++) {
      final textRow = textRows[r];
      final cells = <WorkbookCell>[];
      for (var c = 0; c < textRow.length; c++) {
        cells.add(WorkbookCell(
          rowIndex: r,
          columnIndex: c,
          address: '${String.fromCharCode(65 + (c % 26))}${r + 1}',
          kind: CellValueKind.text,
          text: textRow[c],
          rawValue: textRow[c],
        ));
      }
      final row = WorkbookRow(rowIndex: r, cells: cells);
      if (!row.hasContent) {
        emptyStreak++;
        if (emptyStreak >= 50) break;
        continue;
      }
      emptyStreak = 0;
      rows.add(row);
    }
    sheets.add(WorkbookSheet(name: name, rows: rows));
  }
  return WorkbookSnapshot(sheets: sheets);
}

WorkbookSnapshot _snapshotFromTextSheets(Map<String, List<List<String>>> sheets) {
  final wbSheets = <WorkbookSheet>[];
  for (final entry in sheets.entries) {
    final rows = <WorkbookRow>[];
    for (var r = 0; r < entry.value.length; r++) {
      final textRow = entry.value[r];
      final cells = <WorkbookCell>[];
      for (var c = 0; c < textRow.length; c++) {
        cells.add(WorkbookCell(
          rowIndex: r,
          columnIndex: c,
          address: '${String.fromCharCode(65 + (c % 26))}${r + 1}',
          kind: CellValueKind.text,
          text: textRow[c],
          rawValue: textRow[c],
        ));
      }
      rows.add(WorkbookRow(rowIndex: r, cells: cells));
    }
    wbSheets.add(WorkbookSheet(name: entry.key, rows: rows));
  }
  return WorkbookSnapshot(sheets: wbSheets);
}


ExtractionResult _cutSheets(
  Map<String, List<TestCaseRecord>> kept, {
  required WorkbookSnapshot workbook,
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
  final promptCopies = {
    for (final name in names) name: List<TestCaseRecord>.from(kept[name]!),
  };
  var truncated = false;
  final unknown = <String>[];

  String render() => _renderSheets(promptCopies);

  while (render().length > cap && promptCopies.isNotEmpty) {
    truncated = true;
    final last = promptCopies.keys.last;
    final list = promptCopies[last]!;
    if (list.isNotEmpty) {
      list.removeLast();
      if (list.isEmpty) {
        promptCopies.remove(last);
        unknown.insert(0, last);
      }
    } else {
      promptCopies.remove(last);
      unknown.insert(0, last);
    }
  }

  // Preserve the FULL deterministic record set
  final allRecords = kept.values.expand((e) => e).toList();

  final text = [
    render(),
    ...unknown.map((m) => 'UNKNOWN: $m'),
  ].where((s) => s.trim().isNotEmpty).join('\n\n');

  final availability = truncated
      ? const ExtractionAvailability.partial(
          code: 'PROMPT_BUDGET_TRUNCATED',
          message: 'Dữ liệu văn bản cho AI bị cắt giảm do vượt giới hạn ký tự.',
        )
      : const ExtractionAvailability.complete();

  return ExtractionResult(
    text: text,
    skippedSheets: skipped,
    unknownModules: unknown,
    truncated: truncated,
    sizeBytes: sizeBytes,
    sheetCount: sheetCount,
    rowCount: rowCount,
    records: allRecords,
    workbook: workbook,
    availability: availability,
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
