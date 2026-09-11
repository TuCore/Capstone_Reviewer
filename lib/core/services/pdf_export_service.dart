import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfExportService {
  Future<String> exportReportToPdf(String markdownText) async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final fontDataBold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final ttfBold = pw.Font.ttf(fontDataBold);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
      ),
    );

    // Break text by lines for simple formatting
    final lines = markdownText.split('\n');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return lines.map((line) {
            if (line.startsWith('# ')) {
              return pw.Header(level: 0, child: pw.Text(line.substring(2), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)));
            } else if (line.startsWith('## ')) {
              return pw.Header(level: 1, child: pw.Text(line.substring(3), style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)));
            } else if (line.startsWith('- ')) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                child: pw.Text('• ${line.substring(2)}', style: const pw.TextStyle(fontSize: 12)),
              );
            } else if (line.trim().isEmpty) {
              return pw.SizedBox(height: 8);
            } else {
              return pw.Paragraph(text: line, style: const pw.TextStyle(fontSize: 12));
            }
          }).toList();
        },
      ),
    );

    Directory? outputDir;
    try {
      outputDir = await getDownloadsDirectory();
    } catch (_) {}

    if (outputDir == null) {
      try {
        outputDir = await getApplicationDocumentsDirectory();
      } catch (_) {}
    }
    
    final dirPath = outputDir?.path ?? '.'; // Dùng thư mục hiện tại nếu không lấy được Downloads
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('$dirPath/Review_Report_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }
}
