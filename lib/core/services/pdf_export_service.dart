
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExportService {
  static String sanitizeText(String text) => _sanitizePdfText(text);

  static pw.Document buildPdfDocument(String markdownText, {pw.ThemeData? theme}) {
    final pdf = pw.Document(theme: theme);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => _widgets(markdownText.split('\n')),
      ),
    );
    return pdf;
  }

  Future<String?> exportReportToPdf(String markdownText) async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final fontDataBold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final ttfBold = pw.Font.ttf(fontDataBold);

    final pdf = buildPdfDocument(
      markdownText,
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
        italic: ttf,
        boldItalic: ttfBold,
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

String _sanitizePdfText(String text) {
  var s = text
      .replaceAll('📋', '')
      .replaceAll('🔬', '')
      .replaceAll('🚨', '[!] ')
      .replaceAll('⚠️', '[!] ')
      .replaceAll('✅', '[OK] ')
      .replaceAll('❌', '[FAIL] ')
      .replaceAll('ℹ️', '[i] ')
      .replaceAll('📊', '')
      .replaceAll('📌', '')
      .replaceAll('💡', '')
      .replaceAll('⟷', '<->')
      .replaceAll('↔', '<->')
      .replaceAll('→', '->')
      .replaceAll('←', '<-');
  // Strip control characters except newline and tab
  s = s.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
  // Strip any remaining emojis or symbols unsupported in standard fonts
  return s.replaceAll(
      RegExp(r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}\u{1F000}-\u{1F2FF}]', unicode: true),
      '').trim();
}

pw.Widget _styledMarkdownText(String rawText, {double fontSize = 11}) {
  final clean = _sanitizePdfText(rawText.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n'));
  final spans = <pw.InlineSpan>[];
  final regex = RegExp(r'(\*\*(.+?)\*\*|`([^`]+)`)');
  var lastIndex = 0;

  for (final match in regex.allMatches(clean)) {
    if (match.start > lastIndex) {
      spans.add(pw.TextSpan(
        text: clean.substring(lastIndex, match.start),
        style: pw.TextStyle(fontSize: fontSize),
      ));
    }
    if (match.group(2) != null) {
      spans.add(pw.TextSpan(
        text: match.group(2),
        style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
      ));
    } else if (match.group(3) != null) {
      spans.add(pw.TextSpan(
        text: match.group(3),
        style: pw.TextStyle(fontSize: fontSize, fontStyle: pw.FontStyle.italic),
      ));
    }
    lastIndex = match.end;
  }
  if (lastIndex < clean.length) {
    spans.add(pw.TextSpan(
      text: clean.substring(lastIndex),
      style: pw.TextStyle(fontSize: fontSize),
    ));
  }

  return pw.RichText(text: pw.TextSpan(children: spans));
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
          final cells = parts.sublist(startIdx, endIdx).map((s) => _sanitizePdfText(s.trim())).toList();
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
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              for (var rowIdx = 0; rowIdx < normalizedRows.length; rowIdx++)
                pw.TableRow(
                  repeat: rowIdx == 0,
                  decoration: rowIdx == 0
                      ? const pw.BoxDecoration(color: PdfColors.grey200)
                      : null,
                  children: [
                    for (final cell in normalizedRows[rowIdx])
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: _styledMarkdownText(
                          rowIdx == 0 && !cell.startsWith('**') ? '**$cell**' : cell,
                          fontSize: 8.5,
                        ),
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

    final sanitized = _sanitizePdfText(line);
    if (sanitized.startsWith('# ')) {
      out.add(pw.Header(
        level: 0,
        child: pw.Text(
          sanitized.substring(2),
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (sanitized.startsWith('## ')) {
      out.add(pw.Header(
        level: 1,
        child: pw.Text(
          sanitized.substring(3),
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (sanitized.startsWith('### ')) {
      out.add(pw.Header(
        level: 2,
        child: pw.Text(
          sanitized.substring(4),
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
      ));
    } else if (sanitized.startsWith('- ')) {
      final itemText = sanitized.substring(2);
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 12, bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('• ', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.Expanded(
                child: _styledMarkdownText(itemText, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    } else if (sanitized.trim().isEmpty) {
      out.add(pw.SizedBox(height: 6));
    } else {
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: _styledMarkdownText(sanitized, fontSize: 11),
        ),
      );
    }
    i++;
  }
  return out;
}
