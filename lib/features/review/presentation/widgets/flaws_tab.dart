import 'package:flutter/material.dart';
import '../../../../core/models/review_audit_result.dart';
import '../../../../core/models/anti_pattern.dart';
import 'suggestion_dialog.dart';

/// Tab 3: Chi tiết Lỗ hổng & Gợi ý Test Case Bổ sung
class FlawsTab extends StatelessWidget {
  final ReviewAuditResult result;

  const FlawsTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Anti-pattern Detection ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bug_report, color: Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      const Text(
                        'BỘ LỌC "VẠCH LÁ TÌM SÂU" — ANTI-PATTERN DETECTION',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${result.antiPatterns.length} lỗi phát hiện',
                          style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (result.antiPatterns.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF22C55E)),
                          SizedBox(width: 8),
                          Text('Không phát hiện anti-pattern nào! 🎉', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  else
                    ...result.antiPatterns.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ap = entry.value;
                      return _antiPatternCard(ap, index + 1);
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Gợi ý Test Case Bổ sung ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_fix_high, color: Color(0xFF8B5CF6)),
                      const SizedBox(width: 8),
                      const Text(
                        'GỢI Ý TEST CASE BỔ SUNG — CHUẨN CÔNG NGHIỆP',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${result.missingSuggestions.length} gợi ý',
                          style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (result.missingSuggestions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF22C55E)),
                          SizedBox(width: 8),
                          Text('Bộ test cases đã bao phủ đầy đủ!', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  else ...[
                    // Quick preview
                    ...result.missingSuggestions.take(3).map((s) => _suggestionPreview(s)),
                    if (result.missingSuggestions.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '... và ${result.missingSuggestions.length - 3} gợi ý khác',
                          style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _showSuggestionsDialog(context),
                        icon: const Icon(Icons.bolt),
                        label: const Text('⚡ Xem Toàn Bộ Test Case Gợi Ý'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _antiPatternCard(AntiPattern ap, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ap.severityColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ap.severityColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ap.severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(ap.typeIcon, color: ap.severityColor, size: 20),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#$index — ${ap.typeLabel}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ap.severityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ap.severity,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ap.severityColor),
                      ),
                    ),
                    const Spacer(),
                    if (ap.testCaseId.isNotEmpty)
                      Text(
                        ap.testCaseId,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontFamily: 'monospace'),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(ap.description, style: const TextStyle(fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionPreview(s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(s.typeColorValue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              s.type,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(s.typeColorValue)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.testCaseId, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                Text(s.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuggestionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SuggestionDialog(suggestions: result.missingSuggestions),
    );
  }
}
