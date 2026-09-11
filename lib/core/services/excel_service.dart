import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class ExcelService {
  /// Parses the excel file and extracts test cases in an isolate
  Future<String> extractTestCases(String filePath) async {
    return await compute(_parseExcelContent, filePath);
  }

  static String _parseExcelContent(String filePath) {
    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      StringBuffer buffer = StringBuffer();
      
      for (var table in excel.tables.keys) {
        buffer.writeln('Sheet: $table');
        var sheet = excel.tables[table];
        
        if (sheet == null) continue;

        // Determine header row assuming the first non-empty row is header
        int headerRowIndex = -1;
        for (int i = 0; i < sheet.maxRows; i++) {
          var row = sheet.row(i);
          if (row.any((cell) => cell != null && cell.value != null)) {
            headerRowIndex = i;
            break;
          }
        }

        if (headerRowIndex == -1) continue; // Empty sheet

        var headers = sheet.row(headerRowIndex).map((e) => e?.value?.toString().trim() ?? '').toList();
        
        // Extract data rows
        for (int i = headerRowIndex + 1; i < sheet.maxRows; i++) {
          var row = sheet.row(i);
          // Check if row is completely empty
          if (!row.any((cell) => cell != null && cell.value != null)) continue;

          buffer.writeln('- Test Case:');
          for (int j = 0; j < headers.length; j++) {
            if (j < row.length) {
              var header = headers[j];
              var value = row[j]?.value?.toString().trim() ?? '';
              if (header.isNotEmpty && value.isNotEmpty) {
                buffer.writeln('  $header: $value');
              }
            }
          }
        }
      }

      return buffer.toString();
    } catch (e) {
      throw Exception('Lỗi khi đọc file Excel: $e');
    }
  }
}
