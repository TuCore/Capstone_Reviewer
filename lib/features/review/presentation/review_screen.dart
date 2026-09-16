import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/models/review_audit_result.dart';
import '../../../core/services/pdf_export_service.dart';
import 'review_controller.dart';
import 'widgets/metric_card.dart';
import 'widgets/scorecard_tab.dart';
import 'widgets/rtm_tab.dart';
import 'widgets/flaws_tab.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final String reviewContent;

  const ReviewScreen({
    super.key, 
    required this.reviewContent,
  });

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Parse AI response on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewControllerProvider.notifier).parseResult(
        widget.reviewContent,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportPdf(ReviewAuditResult? result) async {
    setState(() => isExporting = true);
    try {
      final service = PdfExportService();
      String path;
      if (result != null) {
        path = await service.exportAuditReportToPdf(result);
      } else {
        path = await service.exportReportToPdf(widget.reviewContent);
      }
      if (!mounted) return;
      setState(() => isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xuất PDF thành công tại:\n$path'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e, st) {
      if (!mounted) return;
      setState(() => isExporting = false);
      print('Pdf Export Error: $e');
      print('Stacktrace: $st');
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
    final reviewState = ref.watch(reviewControllerProvider);
    final result = reviewState.result;

    // Fallback: if JSON parse failed, show raw markdown
    if (result == null) {
      return _buildFallbackView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả Thẩm Định Chất Lượng Kiểm Thử'),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: isExporting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: () => _exportPdf(result),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Xuất PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Metric Cards Row ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Tổng Yêu Cầu (SRS)',
                      value: '${result.metrics.totalRequirements}',
                      icon: Icons.assignment,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                  child: MetricCard(
                    label: 'Tổng Test Cases',
                    value: '${result.metrics.totalTestCases}',
                    icon: Icons.checklist,
                    color: const Color(0xFF22C55E),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MetricCard(
                    label: 'Tỷ lệ Coverage',
                    value: '${result.metrics.coveragePercent.toStringAsFixed(0)}%',
                    icon: Icons.pie_chart,
                    color: const Color(0xFFEAB308),
                    subtitle: '${result.metrics.coveredRequirements}/${result.metrics.totalRequirements} yêu cầu',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MetricCard(
                    label: 'Điểm Tổng Kết',
                    value: '${result.scorecard.totalScore.toStringAsFixed(1)}/10',
                    icon: Icons.star,
                    color: _scoreColor(result.scorecard.totalScore),
                    subtitle: result.scorecard.grade,
                  ),
                ),
              ],
            ),
          ),
        ),

          // --- Tab Bar ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.blue.shade800,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [
                Tab(text: '📊 Tổng quan & Điểm số'),
                Tab(text: '🗺️ Ma trận RTM'),
                Tab(text: '🕵️ Lỗ hổng & Gợi ý'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // --- Tab Content ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ScorecardTab(result: result),
                RtmTab(result: result),
                FlawsTab(result: result),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback view when JSON parse fails — shows raw markdown like before
  Widget _buildFallbackView() {
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
                    onPressed: () => _exportPdf(null),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Xuất PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
          ),
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
              ),
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

  Color _scoreColor(double score) {
    if (score >= 8.5) return const Color(0xFF22C55E);
    if (score >= 7.0) return const Color(0xFF3B82F6);
    if (score >= 5.0) return const Color(0xFFEAB308);
    return const Color(0xFFEF4444);
  }
}
