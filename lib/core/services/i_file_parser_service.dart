class ExcelData {
  // Đại diện cho data trích xuất từ Excel
  final List<Map<String, dynamic>> rows;
  ExcelData(this.rows);
}

abstract class IFileParserService {
  /// Chạy trong Isolate để parse Excel
  Future<ExcelData> parseExcel(String filePath);

  /// Chạy trong Isolate để trích xuất text từ PDF/Docx
  Future<String> extractTextFromDocument(String filePath);
}
