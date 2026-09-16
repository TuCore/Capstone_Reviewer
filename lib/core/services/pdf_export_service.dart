import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/review_audit_result.dart';
import '../models/rtm_item.dart';

class PdfExportService {
  /// Legacy: xuất Markdown thuần → PDF
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

    return await _savePdf(pdf, 'Review_Report');
  }

  /// New: Xuất Biên bản Thẩm định Chất lượng Kiểm thử (Audit Report)
  Future<String> exportAuditReportToPdf(ReviewAuditResult result) async {
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

    final sc = result.scorecard;
    final m = result.metrics;

    // --- Trang 1: Bìa + Bảng điểm ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context ctx) => [
          // Tiêu đề
          pw.Center(
            child: pw.Text(
              'BIÊN BẢN THẨM ĐỊNH',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'CHẤT LƯỢNG KIỂM THỬ ĐỒ ÁN',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 16),

          // Thông tin đồ án
          if (result.projectTitle != null)
            _pdfInfoRow('Đề tài:', result.projectTitle!),
          if (result.supervisor != null)
            _pdfInfoRow('GVHD:', result.supervisor!),
          if (result.teamMembers != null)
            _pdfInfoRow('Thành viên nhóm:', result.teamMembers!),
          _pdfInfoRow('Ngày thẩm định:', _formatDate(result.reviewDate ?? DateTime.now())),
          pw.SizedBox(height: 20),

          // Tổng quan
          pw.Header(level: 1, child: pw.Text('1. TỔNG QUAN', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            cellStyle: const pw.TextStyle(fontSize: 11),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE5E7EB)),
            cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center},
            headers: ['Chỉ số', 'Giá trị'],
            data: [
              ['Tổng yêu cầu (SRS)', '${m.totalRequirements}'],
              ['Yêu cầu đã bao phủ', '${m.coveredRequirements}'],
              ['Tổng Test Cases', '${m.totalTestCases}'],
              ['Happy Path', '${m.happyPathCount} (${m.happyPathPercent.toStringAsFixed(0)}%)'],
              ['Negative Cases', '${m.negativePathCount} (${m.negativePercent.toStringAsFixed(0)}%)'],
              ['Edge Cases', '${m.edgeCaseCount} (${m.edgeCasePercent.toStringAsFixed(0)}%)'],
              ['Security Tests', '${m.securityTestCount} (${m.securityPercent.toStringAsFixed(0)}%)'],
            ],
          ),
          pw.SizedBox(height: 20),

          // Bảng điểm chi tiết
          pw.Header(level: 1, child: pw.Text('2. BẢNG ĐIỂM CHI TIẾT', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            cellStyle: const pw.TextStyle(fontSize: 11),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFDBEAFE)),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
            },
            headers: ['Tiêu chí', 'Trọng số', 'Điểm'],
            data: [
              ['Độ bao phủ yêu cầu (Coverage)', '40%', '${sc.coverageRate.toStringAsFixed(1)}/10'],
              ['Độ sâu kiểm thử (Depth & Rigor)', '30%', '${sc.depthScore.toStringAsFixed(1)}/10'],
              ['Chất lượng mô tả (Spec Quality)', '20%', '${sc.qualityScore.toStringAsFixed(1)}/10'],
              ['Tính truy vết (Traceability)', '10%', '${sc.traceabilityScore.toStringAsFixed(1)}/10'],
              ['ĐIỂM TỔNG KẾT', '100%', '${sc.totalScore.toStringAsFixed(1)}/10'],
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: _gradeColor(sc.grade),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Center(
              child: pw.Text(
                'XẾP LOẠI: ${sc.grade.toUpperCase()} (${sc.totalScore.toStringAsFixed(1)}/10)',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 16),

          // Executive Summary
          pw.Header(level: 1, child: pw.Text('3. NHẬN XÉT TỔNG QUAN', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 8),
          pw.Paragraph(text: sc.summary, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 12),
          pw.Text('Điểm mạnh:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          ...sc.strengths.map((s) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                child: pw.Text('✓ $s', style: const pw.TextStyle(fontSize: 11)),
              )),
          pw.SizedBox(height: 8),
          pw.Text('Điểm yếu:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          ...sc.weaknesses.map((w) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                child: pw.Text('✗ $w', style: const pw.TextStyle(fontSize: 11)),
              )),
        ],
      ),
    );

    // --- Trang 2: Ma trận RTM ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context ctx) => [
          pw.Header(level: 0, child: pw.Text('4. MA TRẬN TRUY VẾT YÊU CẦU (RTM)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(60),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(50),
              3: const pw.FixedColumnWidth(80),
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE5E7EB)),
                children: [
                  _tableHeaderCell('Mã YC'),
                  _tableHeaderCell('Tên Chức Năng'),
                  _tableHeaderCell('Số TC'),
                  _tableHeaderCell('Trạng Thái'),
                ],
              ),
              // Data rows
              ...result.rtm.map((item) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: _rtmRowColor(item.status),
                    ),
                    children: [
                      _tableDataCell(item.reqId),
                      _tableDataCell(item.reqName),
                      _tableDataCell('${item.testCount}', center: true),
                      _tableStatusCell(item),
                    ],
                  )),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _legendDot(PdfColor.fromInt(0xFFDCFCE7), 'Đạt (${result.passCount})'),
              _legendDot(PdfColor.fromInt(0xFFFEF9C3), 'Cảnh báo (${result.warningCount})'),
              _legendDot(PdfColor.fromInt(0xFFFEE2E2), 'Bỏ quên (${result.missingCount})'),
            ],
          ),
        ],
      ),
    );

    // --- Trang 3: Anti-patterns + Gợi ý ---
    if (result.antiPatterns.isNotEmpty || result.missingSuggestions.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context ctx) => [
            if (result.antiPatterns.isNotEmpty) ...[
              pw.Header(level: 0, child: pw.Text('5. CÁC LỖI ANTI-PATTERN PHÁT HIỆN', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 8),
              ...result.antiPatterns.asMap().entries.map((entry) {
                final i = entry.key + 1;
                final ap = entry.value;
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('#$i — ${ap.typeLabel} [${ap.severity}] ${ap.testCaseId.isNotEmpty ? "(${ap.testCaseId})" : ""}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.SizedBox(height: 4),
                      pw.Text(ap.description, style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 20),
            ],
            if (result.missingSuggestions.isNotEmpty) ...[
              pw.Header(level: 0, child: pw.Text('6. TEST CASES GỢI Ý BỔ SUNG', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFEDE9FE)),
                headers: ['Mã TC', 'REQ', 'Loại', 'Tiêu đề', 'Kết quả kỳ vọng'],
                data: result.missingSuggestions.map((s) => [
                      s.testCaseId,
                      s.reqId,
                      s.type,
                      s.title,
                      s.expected,
                    ]).toList(),
              ),
            ],
            pw.SizedBox(height: 40),
            pw.Divider(),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Hệ thống thẩm định:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text('Capstone Reviewer AI Auditor', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Ngày lập:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text(_formatDate(DateTime.now()), style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return await _savePdf(pdf, 'Audit_Report');
  }

  // --- Helpers ---

  pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
    );
  }

  pw.Widget _tableDataCell(String text, {bool center = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text,
          style: const pw.TextStyle(fontSize: 10),
          textAlign: center ? pw.TextAlign.center : pw.TextAlign.left),
    );
  }

  pw.Widget _tableStatusCell(RTMItem item) {
    String label = 'Bỏ quên';
    PdfColor bgColor = PdfColor.fromInt(0xFFEF4444);
    switch (item.status) {
      case RTMStatus.pass:
        label = 'Đạt';
        bgColor = PdfColor.fromInt(0xFF22C55E);
        break;
      case RTMStatus.warning:
        label = 'Cảnh báo';
        bgColor = PdfColor.fromInt(0xFFEAB308);
        break;
      case RTMStatus.missing:
      default:
        label = 'Bỏ quên';
        bgColor = PdfColor.fromInt(0xFFEF4444);
        break;
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Center(
          child: pw.Text(label,
              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10)),
        ),
      ),
    );
  }

  PdfColor _rtmRowColor(RTMStatus status) {
    switch (status) {
      case RTMStatus.pass:
        return PdfColor.fromInt(0xFFF0FDF4);
      case RTMStatus.warning:
        return PdfColor.fromInt(0xFFFEFCE8);
      case RTMStatus.missing:
        return PdfColor.fromInt(0xFFFEF2F2);
    }
  }

  PdfColor _gradeColor(String grade) {
    switch (grade) {
      case 'Xuất sắc':
        return PdfColor.fromInt(0xFF22C55E);
      case 'Khá':
        return PdfColor.fromInt(0xFF3B82F6);
      case 'Trung bình':
        return PdfColor.fromInt(0xFFEAB308);
      case 'Cần viết lại':
        return PdfColor.fromInt(0xFFEF4444);
      default:
        return PdfColor.fromInt(0xFF6B7280);
    }
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          ),
          pw.Expanded(child: pw.Text(value, style: const pw.TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  pw.Widget _legendDot(PdfColor color, String text) {
    return pw.Row(
      children: [
        pw.Container(width: 12, height: 12, decoration: pw.BoxDecoration(color: color, borderRadius: pw.BorderRadius.circular(2))),
        pw.SizedBox(width: 4),
        pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<String> _savePdf(pw.Document pdf, String prefix) async {
    final bytes = await pdf.save();
    final result = await FilePicker.saveFile(
      dialogTitle: 'Lưu báo cáo PDF',
      fileName: '${prefix}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: bytes,
    );

    if (result == null) {
      // Fallback to Downloads directory
      Directory? outputDir;
      try {
        outputDir = await getDownloadsDirectory();
      } catch (_) {}
      if (outputDir == null) {
        try {
          outputDir = await getApplicationDocumentsDirectory();
        } catch (_) {}
      }
      final dirPath = outputDir?.path ?? '.';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('$dirPath/${prefix}_$timestamp.pdf');
      await file.writeAsBytes(bytes);
      return file.path;
    }

    return result.toFilePath();
  }
}
