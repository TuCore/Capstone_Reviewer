import 'package:flutter/material.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/coverage_stats.dart';
import '../../../../core/services/cross_check_engine.dart';
import '../../../../core/services/registration_pii.dart';
import 'coverage_gauge.dart';
import 'metric_card.dart';

class OverviewTab extends StatelessWidget {
  final CoverageStats stats;
  final CrossCheckResult? crossCheck;
  final int totalRecordsCount;
  final ProjectInfo? projectInfo;
  final RegistrationContext? registrationContext;

  const OverviewTab({
    super.key,
    required this.stats,
    this.crossCheck,
    required this.totalRecordsCount,
    this.projectInfo,
    this.registrationContext,
  });
  @override
  Widget build(BuildContext context) {
    final hasComparison = crossCheck?.metricsComparison != null;
    final comparison = crossCheck?.metricsComparison;
    final int actualTotal = comparison?.actualTotalVal ?? totalRecordsCount;
    final int actualPassed = comparison?.actualPassedVal ?? stats.passed;
    final int actualFailed = comparison?.actualFailedVal ?? stats.failed;
    final actualOther = comparison != null
        ? (actualTotal - actualPassed - actualFailed).clamp(0, actualTotal)
        : stats.untested;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Metadata Card (Tên đề tài & Bối cảnh từ AI)
          if ((projectInfo?.topic.isNotEmpty == true) ||
              (registrationContext?.topic.isNotEmpty == true) ||
              (projectInfo?.techStack.isNotEmpty == true)) ...[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.blue.shade100),
              ),
              color: const Color(0xFFF8FAFC),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.school_outlined, color: Colors.blue.shade700, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            (projectInfo?.topic.isNotEmpty == true)
                                ? projectInfo!.topic
                                : (registrationContext?.topic.isNotEmpty == true
                                    ? registrationContext!.topic
                                    : 'Đề tài Capstone'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if ((projectInfo?.description.isNotEmpty == true) ||
                        (registrationContext?.description.isNotEmpty == true)) ...[
                      const SizedBox(height: 10),
                      Text(
                        (projectInfo?.description.isNotEmpty == true)
                            ? projectInfo!.description
                            : (registrationContext?.description ?? ''),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (projectInfo?.techStack.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: projectInfo!.techStack
                            .map(
                              (tech) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Text(
                                  tech,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (crossCheck == null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blueGrey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Đối chiếu chéo 3 nguồn chưa khả dụng. Các chỉ số hiển thị dựa trên dữ liệu trích xuất từ Excel và SRS.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Row 1: Coverage Gauge + Core KPI Cards
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coverage Gauge Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CoverageGauge(
                        coverageRatio: stats.coverage,
                        coveredCount: stats.coveredUseCases.length,
                        totalCount: stats.readUseCases.length,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Độ phủ yêu cầu (SRS)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dựa trên mapping SRS ⟷ Test Case',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // KPI Cards Grid
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'Tổng số Test Cases trích xuất',
                            value: '$actualTotal',
                            icon: Icons.table_chart_outlined,
                            color: const Color(0xFF2563EB),
                            subtitle: comparison != null
                                ? 'Khai báo: ${comparison.excelDeclaredTotal} ca'
                                : 'Đối chiếu 3 nguồn: Chưa khả dụng',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            label: 'Test Cases PASSED',
                            value: '$actualPassed',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF16A34A),
                            subtitle: comparison != null
                                ? (actualTotal > 0
                                    ? '${(actualPassed / actualTotal * 100).toStringAsFixed(1)}% tổng ca'
                                    : null)
                                : 'Trích xuất từ Excel: $actualPassed ca',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'Test Cases FAILED thực tế',
                            value: '$actualFailed',
                            icon: Icons.cancel_outlined,
                            color: actualFailed > 0
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF16A34A),
                            subtitle: comparison != null &&
                                    comparison.concealedFailsVal > 0
                                ? '[Cảnh báo] Báo cáo ghi nhận 0 Fail!'
                                : (hasComparison
                                    ? 'Số ca thực thi thất bại'
                                    : (actualFailed > 0
                                        ? 'Số ca thất bại trong Excel'
                                        : '0 ca thất bại trong Excel')),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            label: 'Chưa chạy / Untested',
                            value: '$actualOther',
                            icon: Icons.hourglass_empty_outlined,
                            color: const Color(0xFFD97706),
                            subtitle: comparison != null
                                ? 'Chưa thực hiện hoặc N/A'
                                : 'Chưa thực hiện / N/A từ Excel',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Discrepancy warnings (if comparison has discrepancies)
          if (comparison != null && comparison.findings.isNotEmpty) ...[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.amber.shade300),
              ),
              color: Colors.amber.shade50.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        Text(
                          'CẢNH BÁO ĐỐI SOÁT DỮ LIỆU TỔNG QUAN (${comparison.findings.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...comparison.findings.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309))),
                            Expanded(
                              child: Text(
                                f,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF78350F),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

        ],
      ),
    );
  }
}
