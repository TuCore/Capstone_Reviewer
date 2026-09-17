import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExportService {
  Future<String?> exportReportToPdf(String markdownText) async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final fontDataBold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final ttfBold = pw.Font.ttf(fontDataBold);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => _widgets(markdownText.split('\n')),
      ),
    );

    final bytes = Uint8List.fromList(await pdf.save());
    final uri = await FilePicker.saveFile(
      fileName: 'capstone-review.pdf',
      bytes: bytes,
      mimeType: 'application/pdf',
      dialogTitle: 'Lưu báo cáo PDF',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (uri == null) return null;
    return uri.scheme == 'file' ? uri.toFilePath() : uri.toString();
  }
}

List<pw.Widget> _widgets(List<String> lines) {
  final out = <pw.Widget>[];
  var i = 0;
  while (i < lines.length) {
    final line = lines[i];
    if (line.trim().startsWith('|')) {
      final rows = <List<String>>[];
      while (i < lines.length && lines[i].trim().startsWith('|')) {
        final raw = lines[i].trim();
        i++;
        if (RegExp(r'^\|?\s*:?-{3,}').hasMatch(raw)) continue;
        final parts = raw.split('|');
        final startIdx = parts.first.trim().isEmpty ? 1 : 0;
        final endIdx = parts.last.trim().isEmpty ? parts.length - 1 : parts.length;
        if (startIdx < endIdx) {
          final cells = parts.sublist(startIdx, endIdx).map((s) => s.trim()).toList();
          rows.add(cells);
        }
      }
      if (rows.isNotEmpty) {
        var maxCols = 0;
        for (final r in rows) {
          if (r.length > maxCols) maxCols = r.length;
        }
        final normalizedRows = rows.map((r) {
          if (r.length < maxCols) {
            return [...r, ...List.filled(maxCols - r.length, '')];
          }
          return r;
        }).toList();
        out.add(
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              for (final row in normalizedRows)
                pw.TableRow(
                  children: [
                    for (final cell in row)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(cell, style: const pw.TextStyle(fontSize: 10)),
                      ),
                  ],
                ),
            ],
          ),
        );
        out.add(pw.SizedBox(height: 8));
      }
      continue;
    }
    if (line.startsWith('# ')) {
      out.add(pw.Header(
        level: 0,
        child: pw.Text(
          line.substring(2),
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (line.startsWith('## ')) {
      out.add(pw.Header(
        level: 1,
        child: pw.Text(
          line.substring(3),
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (line.startsWith('### ')) {
      out.add(pw.Header(
        level: 2,
        child: pw.Text(
          line.substring(4),
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (line.startsWith('- ')) {
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
          child: pw.Text('• ${line.substring(2)}', style: const pw.TextStyle(fontSize: 12)),
        ),
      );
    } else if (line.trim().isEmpty) {
      out.add(pw.SizedBox(height: 8));
    } else {
      out.add(pw.Paragraph(text: line, style: const pw.TextStyle(fontSize: 12)));
    }
    i++;
  }
  return out;
}
