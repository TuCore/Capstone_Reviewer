import 'package:flutter/material.dart';

import '../../../core/services/excel_export_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../review_bundle.dart';
import 'widgets/detailed_test_cases_tab.dart';
import 'widgets/full_report_tab.dart';
import 'widgets/integrity_tab.dart';
import 'widgets/overview_tab.dart';
import 'widgets/reconciliation_tab.dart';
import 'widgets/verified_findings_tab.dart';

class ReviewScreen extends StatefulWidget {
  final ReviewBundle bundle;
  final bool isEmbedded;
  final int selectedTab;

  const ReviewScreen({
    super.key,
    required this.bundle,
    this.isEmbedded = false,
    this.selectedTab = 0,
  });

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
        caseReviews: widget.bundle.caseReviews,
        crossCheck: widget.bundle.crossCheck,
        verifiedFindings: widget.bundle.verifiedFindings,
        registrationContext: widget.bundle.registrationContext,
        projectInfo: widget.bundle.projectInfo,
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
          await PdfExportService().exportReportToPdf(widget.bundle);
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
    final bundle = widget.bundle;

    if (widget.isEmbedded) {
      // Embedded mode: no TabBar, just show the selected tab content
      return _buildTabContent(widget.selectedTab, bundle);
    }

    // Standalone mode (fallback, not normally used with new sidebar layout)
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Báo cáo Phản biện Đồ án Capstone'),
          elevation: 1,
          actions: [
            TextButton.icon(
              onPressed: isExporting ? null : _exportPdf,
              icon: isExporting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Xuất PDF'),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: isExporting ? null : _exportExcel,
                icon: const Icon(Icons.table_view),
                label: const Text('Xuất Excel'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Chi tiết Test Case'),
                Tab(text: 'Tổng quan'),
                Tab(text: 'Đối chiếu 3 nguồn'),
                Tab(text: 'Lỗi & Toàn vẹn'),
                Tab(text: 'Nhận định xác minh'),
                Tab(text: 'Báo cáo đầy đủ'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DetailedTestCasesTab(caseReviews: bundle.caseReviews),
                  OverviewTab(
                    stats: bundle.stats,
                    crossCheck: bundle.crossCheck,
                    totalRecordsCount: bundle.records.length,
                    projectInfo: bundle.projectInfo,
                    registrationContext: bundle.registrationContext,
                  ),
                  ReconciliationTab(crossCheck: bundle.crossCheck),
                  IntegrityTab(
                    hardChecks: bundle.checks,
                    crossCheck: bundle.crossCheck,
                  ),
                  VerifiedFindingsTab(
                    verifiedFindings: bundle.verifiedFindings,
                  ),
                  FullReportTab(markdown: bundle.markdown),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int index, ReviewBundle bundle) {
    switch (index) {
      case 0:
        return DetailedTestCasesTab(caseReviews: bundle.caseReviews);
      case 1:
        return OverviewTab(
          stats: bundle.stats,
          crossCheck: bundle.crossCheck,
          totalRecordsCount: bundle.records.length,
          projectInfo: bundle.projectInfo,
          registrationContext: bundle.registrationContext,
        );
      case 2:
        return ReconciliationTab(crossCheck: bundle.crossCheck);
      case 3:
        return IntegrityTab(
          hardChecks: bundle.checks,
          crossCheck: bundle.crossCheck,
        );
      case 4:
        return VerifiedFindingsTab(
          verifiedFindings: bundle.verifiedFindings,
        );
      case 5:
        return FullReportTab(markdown: bundle.markdown);
      default:
        return const Center(child: Text('Tab không tồn tại'));
    }
  }
}
