import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FullReportTab extends StatelessWidget {
  final String markdown;

  const FullReportTab({super.key, required this.markdown});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32.0),
        child: Markdown(
          data: markdown,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            h1: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
            h2: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
            h3: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            blockquoteDecoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: const Border(
                left: BorderSide(color: Color(0xFF2563EB), width: 4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
