import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../models/test_case_suggestion.dart';

/// Service xuất test case gợi ý ra file Excel (.xlsx)
class ExcelExportService {
  Future<String> exportSuggestionsToExcel(List<TestCaseSuggestion> suggestions) async {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Test Cases Gợi Ý');
    final sheet = excel['Test Cases Gợi Ý'];

    // Header row with styling
    final headers = [
      'Mã Test Case',
      'REQ ID',
      'Tiêu đề',
      'Phân loại',
      'Tiền điều kiện',
      'Dữ liệu thử nghiệm',
      'Các bước thao tác',
      'Kết quả kỳ vọng',
    ];

    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#2563EB'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Data rows
    for (int r = 0; r < suggestions.length; r++) {
      final s = suggestions[r];
      final rowIndex = r + 1;
      final values = [
        s.testCaseId,
        s.reqId,
        s.title,
        s.type,
        s.preconditions,
        s.testData,
        s.steps,
        s.expected,
      ];

      // Type badge coloring
      ExcelColor? bgColor;
      switch (s.type.toLowerCase()) {
        case 'positive':
          bgColor = ExcelColor.fromHexString('#DCFCE7');
          break;
        case 'negative':
          bgColor = ExcelColor.fromHexString('#FEE2E2');
          break;
        case 'boundary':
          bgColor = ExcelColor.fromHexString('#FEF9C3');
          break;
        case 'security':
          bgColor = ExcelColor.fromHexString('#EDE9FE');
          break;
      }

      for (int c = 0; c < values.length; c++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: rowIndex));
        cell.value = TextCellValue(values[c]);
        if (c == 3 && bgColor != null) {
          cell.cellStyle = CellStyle(backgroundColorHex: bgColor);
        }
      }
    }

    // Set column widths
    sheet.setColumnWidth(0, 18);  // Mã TC
    sheet.setColumnWidth(1, 12);  // REQ ID
    sheet.setColumnWidth(2, 40);  // Tiêu đề
    sheet.setColumnWidth(3, 12);  // Phân loại
    sheet.setColumnWidth(4, 35);  // Tiền điều kiện
    sheet.setColumnWidth(5, 30);  // Dữ liệu thử
    sheet.setColumnWidth(6, 50);  // Các bước
    sheet.setColumnWidth(7, 50);  // Kết quả kỳ vọng

    // Save via file_picker dialog
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Không thể tạo file Excel.');

    final result = await FilePicker.saveFile(
      dialogTitle: 'Lưu file Test Cases gợi ý',
      fileName: 'Test_Cases_Goi_Y_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: Uint8List.fromList(bytes),
    );

    if (result == null) throw Exception('Người dùng đã hủy lưu file.');

    return result.toFilePath();
  }
}
