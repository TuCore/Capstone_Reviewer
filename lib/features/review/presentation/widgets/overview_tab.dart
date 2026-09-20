import 'package:flutter/material.dart';
import '../../../../core/services/coverage_stats.dart';
import '../../../../core/services/cross_check_engine.dart';
import 'coverage_gauge.dart';
import 'metric_card.dart';

class OverviewTab extends StatelessWidget {
  final CoverageStats stats;
  final CrossCheckResult? crossCheck;
  final int totalRecordsCount;

  const OverviewTab({
    super.key,
    required this.stats,
    this.crossCheck,
    required this.totalRecordsCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasComparison = crossCheck?.metricsComparison != null;
    final comparison = crossCheck?.metricsComparison;
    final actualTotal = comparison?.actualTotal ?? totalRecordsCount;
    final actualPassed = comparison?.actualPassed ?? stats.passed;
    final actualFailed = comparison?.actualFailed ?? stats.failed;
    final actualOther = comparison != null
        ? (actualTotal - actualPassed - actualFailed).clamp(0, actualTotal)
        : stats.untested;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                                    comparison.concealedFails > 0
                                ? '🚨 Lệch: Báo cáo ghi nhận 0 Fail!'
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

          // Module Coverage Breakdown List
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ĐỘ PHỦ THEO MODULE / SHEET',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (stats.coveredUseCases.isEmpty)
                    const Text('Chưa có thông tin bao phủ theo use case.')
                  else
                    ...stats.coveredUseCases.map((uc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                size: 16, color: Color(0xFF16A34A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                uc,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Đã có test',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF16A34A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
