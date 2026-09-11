import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_to_text/docx_to_text.dart';

class DocumentService {
  /// Extracts text from PDF or DOCX using isolates
  Future<String> extractText(String filePath) async {
    return await compute(_extractContent, filePath);
  }

  static String _extractContent(String filePath) {
    try {
      if (filePath.toLowerCase().endsWith('.pdf')) {
        return _extractPdfContent(filePath);
      } else if (filePath.toLowerCase().endsWith('.docx') || filePath.toLowerCase().endsWith('.doc')) {
        return _extractDocxContent(filePath);
      } else {
        throw Exception('Định dạng file không được hỗ trợ. Vui lòng chọn .pdf hoặc .docx');
      }
    } catch (e) {
      throw Exception('Lỗi khi đọc file tài liệu: $e');
    }
  }

  static String _extractPdfContent(String filePath) {
    final List<int> bytes = File(filePath).readAsBytesSync();
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    
    return text;
  }

  static String _extractDocxContent(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    final text = docxToText(bytes);
    return text;
  }
}
