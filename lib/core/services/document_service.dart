import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../extraction/extraction_result.dart';
import '../extraction/file_gate.dart';
import '../extraction/heading_docx.dart';

class DocumentService {
  Future<ExtractionResult> extract(String filePath) async {
    final inspection = FileGate.inspect(filePath);
    if (inspection.rejected) {
      throw FileRejectedException(
        inspection.rejectReason ?? 'File không hợp lệ.',
      );
    }
    return compute(extractDocumentSync, filePath);
  }
}

ExtractionResult extractDocumentSync(String filePath) {
  final inspection = FileGate.inspect(filePath);
  if (inspection.rejected) {
    throw FileRejectedException(
      inspection.rejectReason ?? 'File không hợp lệ.',
    );
  }
  try {
    switch (inspection.kind) {
      case DetectedKind.pdf:
        return _extractPdf(filePath, inspection.sizeBytes);
      case DetectedKind.docx:
        return _extractDocx(filePath, inspection.sizeBytes);
      default:
        throw FileRejectedException(
          'Định dạng file không được hỗ trợ. Vui lòng chọn .pdf hoặc .docx',
        );
    }
  } on FileRejectedException {
    rethrow;
  } catch (e) {
    throw FileRejectedException('Lỗi khi đọc file tài liệu: $e');
  }
}

ExtractionResult _extractPdf(String filePath, int sizeBytes) {
  final bytes = File(filePath).readAsBytesSync();
  final document = PdfDocument(inputBytes: bytes);
  try {
    final text = PdfTextExtractor(document).extractText();
    return extractPlainDocument(text, sizeBytes: sizeBytes);
  } finally {
    document.dispose();
  }
}

ExtractionResult _extractDocx(String filePath, int sizeBytes) {
  final bytes = File(filePath).readAsBytesSync();
  Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes);
  } catch (_) {
    throw FileRejectedException('File đội lốt .docx (không giải nén được).');
  }
  if (!looksLikeDocx(archive)) {
    throw FileRejectedException(
      'File đội lốt .docx (không có word/document.xml).',
    );
  }
  return extractDocxArchive(archive, sizeBytes: sizeBytes);
}
