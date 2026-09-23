
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/review/review_bundle.dart';

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

  Future<String?> exportReportToPdf(ReviewBundle bundle) async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final fontDataBold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final ttfBold = pw.Font.ttf(fontDataBold);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttf,
        bold: ttfBold,
        italic: ttf,
        boldItalic: ttfBold,
      ),
    );

    // Title Page / Summary
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('BÁO CÁO ĐÁNH GIÁ KIỂM THỬ', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
              pw.SizedBox(height: 8),
              if (bundle.projectInfo?.topic.isNotEmpty == true)
                pw.Text('Đề tài: ${bundle.projectInfo?.topic}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 24),
              pw.Text('Thống kê tổng quan:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Tổng số Test Cases: ${bundle.stats.passed + bundle.stats.failed + bundle.stats.untested}'),
              pw.Text('Số lỗi phát hiện: ${bundle.verifiedFindings.length}'),
              pw.SizedBox(height: 24),
              pw.Text('Danh sách Test Cases có vấn đề:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    // Filter to issues only (or all?) Let's show all but highlight issues
    final tableHeaders = ['ID', 'Module', 'Trạng thái', 'Lỗi (AI)'];

    final tableData = bundle.records.map((rec) {
      final rev = bundle.caseReviews.where((r) => r.record.canonicalId == rec.canonicalId).firstOrNull;
      final issuesText = rev?.issues.map((e) => '- ${e.message}').join('\n') ?? '';
      // Strip markdown hashes from issues text for the simple table
      final cleanIssues = issuesText.replaceAll(RegExp(r'#{1,6}\s*'), '');
      return [
        rec.id.isNotEmpty ? rec.id : rec.canonicalId,
        rec.sheet,
        rec.status,
        cleanIssues,
      ];
    }).toList();

    // AI Review Page
    if (bundle.markdown.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Text('ĐÁNH GIÁ TỔNG QUAN', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
              pw.SizedBox(height: 16),
              ..._widgets(bundle.markdown.split('\n')),
            ];
          },
        ),
      );
    }

    // Table Pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Text('CHI TIẾT LỖI TEST CASES', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellPadding: const pw.EdgeInsets.all(6),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(2.5),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(4.5),
              },
            ),
          ];
        },
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
    final headerMatch = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(sanitized);
    if (headerMatch != null) {
      final level = headerMatch.group(1)!.length - 1; // # -> 0, ## -> 1
      final text = headerMatch.group(2)!;
      final size = 22.0 - (level * 3.0);
      out.add(pw.Header(
        level: level.clamp(0, 5),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold),
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
