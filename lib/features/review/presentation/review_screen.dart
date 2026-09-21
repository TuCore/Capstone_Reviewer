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
    final bundle = widget.bundle;
    final issuesCount =
        bundle.caseReviews.where((r) => r.hasIssues).length;
    final verifiedCount = bundle.verifiedFindings.length;

    return DefaultTabController(
      length: 6,
      initialIndex: 0, // Detailed Test Cases tab as DEFAULT!
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
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                icon: const Icon(Icons.fact_check_outlined),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Chi tiết Test Case'),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: issuesCount > 0
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${bundle.caseReviews.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: issuesCount > 0
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Tab(
                icon: Icon(Icons.dashboard_outlined),
                text: 'Tổng quan',
              ),
              const Tab(
                icon: Icon(Icons.compare_arrows_outlined),
                text: 'Đối chiếu 3 nguồn',
              ),
              Tab(
                icon: const Icon(Icons.warning_amber_rounded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Lỗi & Toàn vẹn'),
                    if (bundle.checks.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${bundle.checks.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                icon: const Icon(Icons.verified_outlined),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Nhận định đã xác minh'),
                    if (verifiedCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$verifiedCount',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(
                icon: Icon(Icons.description_outlined),
                text: 'Báo cáo đầy đủ',
              ),
            ],
          ),
        ),
        body: TabBarView(
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
    );
  }
}
