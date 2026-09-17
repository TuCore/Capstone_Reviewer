import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/services/excel_export_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../review_bundle.dart';

class ReviewScreen extends StatefulWidget {
  final ReviewBundle bundle;

  const ReviewScreen({super.key, required this.bundle});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isExporting = false;

  Future<void> _exportExcel() async {
    setState(() => isExporting = true);
    try {
      final path = await ExcelExportService().export(
        stats: widget.bundle.stats,
        checks: widget.bundle.checks,
        records: widget.bundle.records,
        reviewMarkdown: widget.bundle.markdown,
        crossCheck: widget.bundle.crossCheck,
        verifiedFindings: widget.bundle.verifiedFindings,
      );
      if (!mounted) return;
      setState(() => isExporting = false);
      if (path == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu Excel:\n$path'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xuất Excel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportPdf() async {
    setState(() => isExporting = true);
    try {
      final path =
          await PdfExportService().exportReportToPdf(widget.bundle.markdown);
      if (!mounted) return;
      setState(() => isExporting = false);
      if (path == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu PDF:\n$path'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xuất PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả Phản biện (Review)'),
        elevation: 2,
        actions: [
          if (isExporting)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            TextButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed: _exportExcel,
                icon: const Icon(Icons.table_view),
                label: const Text('Xuất Excel'),
              ),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32.0),
          child: Markdown(
            data: widget.bundle.markdown,
            selectable: true,
          ),
        ),
      ),
    );
  }
}
