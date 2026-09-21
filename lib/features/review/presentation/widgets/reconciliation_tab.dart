import 'package:flutter/material.dart';
import '../../../../core/services/cross_check_engine.dart';

class ReconciliationTab extends StatelessWidget {
  final CrossCheckResult? crossCheck;

  const ReconciliationTab({super.key, this.crossCheck});

  @override
  Widget build(BuildContext context) {
    if (crossCheck == null) {
      return const Center(
        child: Text(
          'Không có dữ liệu đối chiếu 3 nguồn.',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
    }

    final comparison = crossCheck!.metricsComparison;
    final envs = crossCheck!.environmentMismatches;
    final timelines = crossCheck!.timelineConflicts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Three-way comparison table
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
                  Row(
                    children: [
                      const Icon(Icons.compare_arrows,
                          color: Color(0xFF2563EB)),
                      const SizedBox(width: 8),
                      const Text(
                        'BẢNG ĐỐI CHIẾU CHỈ SỐ: WORD (SRS) ⟷ EXCEL KHAI BÁO ⟷ THỰC TẾ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade100,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Chỉ số kiểm thử',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Báo cáo Word (SRS)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Khai báo Excel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Thực tế đếm được',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Độ lệch / Kết luận',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: [
                        _buildRow(
                          'Tổng số Test Cases',
                          comparison.wordTotal.displayValue,
                          comparison.excelDeclaredTotal.displayValue,
                          comparison.actualTotal.displayValue,
                          comparison.totalDiscrepancyVal > 0
                              ? 'Lệch ${comparison.totalDiscrepancyVal} ca'
                              : 'Khớp số liệu',
                          isDiscrepant: comparison.totalDiscrepancyVal > 0,
                        ),
                        _buildRow(
                          'Test Cases: PASSED',
                          'N/A',
                          comparison.excelDeclaredPassed.displayValue,
                          comparison.actualPassed.displayValue,
                          comparison.actualPassedVal == comparison.excelDeclaredPassedVal
                              ? 'Khớp số liệu'
                              : 'Lệch ${comparison.excelDeclaredPassedVal - comparison.actualPassedVal} ca',
                          isDiscrepant: comparison.actualPassedVal !=
                              comparison.excelDeclaredPassedVal,
                        ),
                        _buildRow(
                          'Test Cases: FAILED',
                          comparison.wordFailed.displayValue,
                          comparison.excelDeclaredFailed.displayValue,
                          comparison.actualFailed.displayValue,
                          comparison.concealedFailsVal > 0
                              ? '[Cảnh báo] Chưa khai báo ${comparison.concealedFailsVal} ca Fail'
                              : 'Khớp',
                          isDiscrepant: comparison.concealedFailsVal > 0,
                        ),
                        _buildRow(
                          'Test Cases: Manual',
                          comparison.wordManual.displayValue,
                          'N/A',
                          comparison.actualManual.displayValue,
                          comparison.manualDiscrepancyVal > 0
                              ? 'Lệch ${comparison.manualDiscrepancyVal} ca'
                              : 'Khớp',
                          isDiscrepant: comparison.manualDiscrepancyVal > 0,
                        ),
                        _buildRow(
                          'Test Cases: Automation',
                          comparison.wordAuto.displayValue,
                          'N/A',
                          comparison.actualAuto.displayValue,
                          'Thực tế đọc ${comparison.actualAuto.displayValue} ca',
                          isDiscrepant: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section 2: Environment Mismatches
          if (envs.isNotEmpty) ...[
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
                    Row(
                      children: [
                        const Icon(Icons.dns_outlined,
                            color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        Text(
                          'MÂU THUẪN MÔI TRƯỜNG & HẠ TẦNG (${envs.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...envs.map((env) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              env.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Word SRS: ${env.wordValue}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Excel Test Report: ${env.excelValue}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                if (env.registrationValue != null)
                                  Expanded(
                                    child: Text(
                                      'Phiếu đăng ký: ${env.registrationValue}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              env.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade900,
                                fontStyle: FontStyle.italic,
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
            const SizedBox(height: 24),
          ],

          // Section 3: Timeline Conflicts
          if (timelines.isNotEmpty) ...[
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
                    Row(
                      children: [
                        const Icon(Icons.event_busy_outlined,
                            color: Color(0xFFDC2626)),
                        const SizedBox(width: 8),
                        Text(
                          'MÂU THUẪN MỐC THỜI GIAN & TIẾN ĐỘ (${timelines.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...timelines.map((tl) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tl.isViolated
                              ? Colors.red.shade50.withValues(alpha: 0.5)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: tl.isViolated
                                ? Colors.red.shade200
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tl.isViolated
                                  ? Icons.error_outline
                                  : Icons.info_outline,
                              color: tl.isViolated
                                  ? Colors.red.shade700
                                  : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tl.milestoneName} (Hạn: ${tl.milestoneDeadline})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tl.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: tl.isViolated
                                          ? Colors.red.shade900
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }

  static DataRow _buildRow(
    String metric,
    String word,
    String excel,
    String actual,
    String verdict, {
    required bool isDiscrepant,
  }) {
    final textColor = isDiscrepant ? const Color(0xFFDC2626) : Colors.black87;
    return DataRow(
      cells: [
        DataCell(Text(metric, style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(word)),
        DataCell(Text(excel)),
        DataCell(Text(actual, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(
          Text(
            verdict,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
