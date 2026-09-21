import 'package:capstone_reviewer/core/extraction/extraction_result.dart';
import 'package:capstone_reviewer/core/extraction/workbook_snapshot.dart';
import 'package:capstone_reviewer/core/services/cross_check_models.dart';
import 'package:capstone_reviewer/core/services/excel_service.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkbookSnapshot & Typed Cells', () {
    test('preserves cell types and coordinates through encode/decode', () {
      final excel = ex.Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
          ex.TextCellValue('Test ID');
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
          ex.IntCellValue(100);
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
          ex.DoubleCellValue(99.5);
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
          ex.BoolCellValue(true);
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
          ex.DateCellValue(year: 2026, month: 8, day: 25);
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
          ex.FormulaCellValue('SUM(A1:A5)');

      // Leave row 1 empty, add row 2
      sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2)).value =
          ex.TextCellValue('Row 3 Data');

      final bytes = excel.encode()!;
      final decoded = ex.Excel.decodeBytes(bytes);

      final result = extractExcelSyncFromBytes(decoded);
      final snapshot = result.workbook;
      expect(snapshot.containsSheet('Sheet1'), isTrue);

      final wbSheet = snapshot.sheetNamed('Sheet1')!;
      final row0 = wbSheet.rowAt(0);
      expect(row0, isNotNull);
      expect(row0!.rowIndex, 0);

      // Check cell kinds
      expect(row0.cell(0)!.kind, CellValueKind.text);
      expect(row0.cell(0)!.text, 'Test ID');
      expect(row0.cell(0)!.address, 'A1');

      expect(row0.cell(1)!.kind, CellValueKind.intVal);
      expect(row0.cell(1)!.text, '100');
      expect(row0.cell(1)!.address, 'B1');

      expect(row0.cell(2)!.kind, CellValueKind.doubleVal);
      expect(row0.cell(2)!.address, 'C1');

      expect(row0.cell(3)!.kind, CellValueKind.boolVal);
      expect(row0.cell(3)!.address, 'D1');

      expect(row0.cell(4)!.kind, CellValueKind.dateVal);
      expect(row0.cell(4)!.text, '2026-08-25');
      expect(row0.cell(4)!.address, 'E1');

      expect(row0.cell(5)!.kind, CellValueKind.formulaVal);
      expect(row0.cell(5)!.formula, 'SUM(A1:A5)');
      expect(row0.cell(5)!.address, 'F1');

      // Check that row 2 preserved its rowIndex = 2 even though row 1 was empty
      final row2 = wbSheet.rowAt(2);
      expect(row2, isNotNull);
      expect(row2!.rowIndex, 2);
      expect(row2.cell(0)!.address, 'A3');
      expect(row2.cell(0)!.text, 'Row 3 Data');
    });
  });

  group('Deterministic Record Set vs Prompt Truncation', () {
    test('retains all records in ExtractionResult.records even when prompt text is truncated', () {
      final rows = <List<String>>[
        ['Test ID', 'Description', 'Steps', 'Expected Output', 'Status'],
      ];
      for (var i = 1; i <= 50; i++) {
        rows.add([
          'TC-$i',
          'A very long description for test case number $i that consumes prompt budget characters repeatedly.',
          'Step 1\nStep 2\nStep 3',
          'System should behave as expected without errors or crashes.',
          'Passed',
        ]);
      }

      final result = extractExcelFromRows(
        {'M01_Module': rows},
        budgetChars: 500, // Very small budget to force prompt truncation
      );

      // Prompt text must be truncated
      expect(result.truncated, isTrue);
      expect(result.availability.isPartial, isTrue);
      expect(result.availability.code, 'PROMPT_BUDGET_TRUNCATED');

      // But deterministic records must NOT be truncated!
      expect(result.records.length, 50);
      expect(result.records.first.id, 'TC-1');
      expect(result.records.last.id, 'TC-50');
      expect(result.records.first.sourceRow, 2); // Row 2 in Excel (1-based)
    });
  });

  group('MetricValue derivation truth table', () {
    test('diff requires both operands to be available', () {
      const a = MetricValue.available(100);
      const b = MetricValue.available(80);
      const unavail = MetricValue<int>.unavailable();

      final diffValid = MetricValue.diff(a, b);
      expect(diffValid.isAvailable, isTrue);
      expect(diffValid.value, 20);

      final diffUnavail = MetricValue.diff(a, unavail);
      expect(diffUnavail.isAvailable, isFalse);
    });

    test('percentage requires both operands and denominator > 0', () {
      const num = MetricValue.available(50);
      const den = MetricValue.available(100);
      const zeroDen = MetricValue.available(0);
      const unavail = MetricValue<int>.unavailable();

      final pctValid = MetricValue.percentage(num, den);
      expect(pctValid.isAvailable, isTrue);
      expect(pctValid.value, 50.0);

      final pctZero = MetricValue.percentage(num, zeroDen);
      expect(pctZero.isAvailable, isFalse);

      final pctUnavail = MetricValue.percentage(unavail, den);
      expect(pctUnavail.isAvailable, isFalse);
    });
  });
}

// Helper for testing
ExtractionResult extractExcelSyncFromBytes(ex.Excel excel) {
  final sheets = <WorkbookSheet>[];
  for (final name in excel.tables.keys) {
    final sheet = excel.tables[name];
    if (sheet == null) continue;
    final rows = <WorkbookRow>[];
    for (var r = 0; r < sheet.maxRows; r++) {
      final excelRow = sheet.row(r);
      final cells = <WorkbookCell>[];
      for (var c = 0; c < excelRow.length; c++) {
        cells.add(WorkbookCell.fromExcelData(excelRow[c], rowIndex: r, columnIndex: c));
      }
      final row = WorkbookRow(rowIndex: r, cells: cells);
      if (row.hasContent) {
        rows.add(row);
      }
    }
    sheets.add(WorkbookSheet(name: name, rows: rows));
  }
  final wb = WorkbookSnapshot(sheets: sheets);
  return extractExcelFromWorkbook(wb);
}
