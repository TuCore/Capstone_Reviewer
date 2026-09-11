import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/services/pdf_export_service.dart';

class ReviewScreen extends StatefulWidget {
  final String reviewContent;

  const ReviewScreen({super.key, required this.reviewContent});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isExporting = false;
  String? exportPath;

  Future<void> _exportPdf() async {
    setState(() {
      isExporting = true;
      exportPath = null;
    });

    try {
      final service = PdfExportService();
      final path = await service.exportReportToPdf(widget.reviewContent);
      
      if (!mounted) return;
      setState(() {
        isExporting = false;
        exportPath = path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xuất PDF thành công tại:\n$path'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e, st) {
      if (!mounted) return;
      setState(() {
        isExporting = false;
      });
      print('Pdf Export Error: $e');
      print('Stacktrace: $st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xuất PDF: $e\n$st'),
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: isExporting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Xuất PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Markdown(
            data: widget.reviewContent,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(color: Colors.blueAccent, fontSize: 28, fontWeight: FontWeight.bold),
              h2: const TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
              p: const TextStyle(fontSize: 16, height: 1.5),
              listBullet: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
