import 'package:flutter/material.dart';
import '../../../../core/models/review_audit_result.dart';
import 'score_gauge.dart';

/// Tab 1: Tổng quan & Điểm số (Scorecard)
class ScorecardTab extends StatelessWidget {
  final ReviewAuditResult result;

  const ScorecardTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final sc = result.scorecard;
    final m = result.metrics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Thông tin đồ án (nếu có) ---
          if (result.projectTitle != null && result.projectTitle!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📋 Thông tin Đồ Án',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                  const SizedBox(height: 8),
                  _infoRow('Đề tài:', result.projectTitle ?? ''),
                  if (result.supervisor != null) _infoRow('GVHD:', result.supervisor!),
                  if (result.teamMembers != null) _infoRow('Thành viên:', result.teamMembers!),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // --- Score Gauge + Rubric ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gauge
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('ĐIỂM TỔNG KẾT',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      ScoreGauge(score: sc.totalScore, grade: sc.grade),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Rubric progress bars
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BỘ TIÊU CHÍ ĐÁNH GIÁ (RUBRIC)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        const SizedBox(height: 20),
                        _rubricBar('Độ bao phủ yêu cầu (Coverage)', sc.coverageRate, 40, Colors.blue),
                        const SizedBox(height: 16),
                        _rubricBar('Độ sâu kiểm thử (Depth & Rigor)', sc.depthScore, 30, Colors.purple),
                        const SizedBox(height: 16),
                        _rubricBar('Chất lượng mô tả (Spec Quality)', sc.qualityScore, 20, Colors.teal),
                        const SizedBox(height: 16),
                        _rubricBar('Tính truy vết (Traceability)', sc.traceabilityScore, 10, Colors.orange),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Test type distribution ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PHÂN BỔ LOẠI TEST CASE',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  if (m.totalTestCases > 0) ...[
                    _distributionBar(m),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        _legend(const Color(0xFF22C55E), 'Happy Path: ${m.happyPathCount} (${m.happyPathPercent.toStringAsFixed(0)}%)'),
                        _legend(const Color(0xFFEF4444), 'Negative: ${m.negativePathCount} (${m.negativePercent.toStringAsFixed(0)}%)'),
                        _legend(const Color(0xFFEAB308), 'Edge Case: ${m.edgeCaseCount} (${m.edgeCasePercent.toStringAsFixed(0)}%)'),
                        _legend(const Color(0xFF8B5CF6), 'Security: ${m.securityTestCount} (${m.securityPercent.toStringAsFixed(0)}%)'),
                      ],
                    ),
                    if (m.happyPathPercent > 80) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '⚠️ Happy Path chiếm ${m.happyPathPercent.toStringAsFixed(0)}% > 80% — Thiếu nghiêm trọng Negative/Edge Cases!',
                                style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ] else
                    const Text('Không có dữ liệu test case.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Executive Summary ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NHẬN XÉT CỦA GIÁM KHẢO AI',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Text(sc.summary, style: const TextStyle(fontSize: 15, height: 1.6)),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('✅ Điểm mạnh',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700, fontSize: 15)),
                            const SizedBox(height: 8),
                            ...sc.strengths.map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(fontSize: 15)),
                                      Expanded(child: Text(s, style: const TextStyle(fontSize: 14, height: 1.4))),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('❌ Điểm yếu chí mạng',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 15)),
                            const SizedBox(height: 8),
                            ...sc.weaknesses.map((w) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(fontSize: 15)),
                                      Expanded(child: Text(w, style: const TextStyle(fontSize: 14, height: 1.4))),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _rubricBar(String label, double score, int weight, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
            Text('${score.toStringAsFixed(1)}/10', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            Text('  (${weight}%)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _distributionBar(m) {
    final total = m.totalTestCases > 0 ? m.totalTestCases : 1;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 24,
        child: Row(
          children: [
            _barSegment(m.happyPathCount / total, const Color(0xFF22C55E)),
            _barSegment(m.negativePathCount / total, const Color(0xFFEF4444)),
            _barSegment(m.edgeCaseCount / total, const Color(0xFFEAB308)),
            _barSegment(m.securityTestCount / total, const Color(0xFF8B5CF6)),
          ],
        ),
      ),
    );
  }

  Widget _barSegment(double flex, Color color) {
    if (flex <= 0) return const SizedBox.shrink();
    return Expanded(
      flex: (flex * 1000).round().clamp(1, 1000),
      child: Container(color: color),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
