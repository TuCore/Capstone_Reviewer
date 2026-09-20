import 'package:flutter/material.dart';
import '../../../../core/services/test_case_review_engine.dart';

class TestCaseDetailDialog extends StatelessWidget {
  final TestCaseReview review;

  const TestCaseDetailDialog({super.key, required this.review});

  Color _severityColor(TestCaseIssueSeverity severity) {
    switch (severity) {
      case TestCaseIssueSeverity.critical:
        return const Color(0xFFDC2626); // Red
      case TestCaseIssueSeverity.high:
        return const Color(0xFFEA580C); // Orange
      case TestCaseIssueSeverity.medium:
        return const Color(0xFFD97706); // Amber
      case TestCaseIssueSeverity.low:
        return const Color(0xFF2563EB); // Blue
      case TestCaseIssueSeverity.info:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String _severityLabel(TestCaseIssueSeverity severity) {
    switch (severity) {
      case TestCaseIssueSeverity.critical:
        return 'CRITICAL';
      case TestCaseIssueSeverity.high:
        return 'HIGH';
      case TestCaseIssueSeverity.medium:
        return 'MEDIUM';
      case TestCaseIssueSeverity.low:
        return 'LOW';
      case TestCaseIssueSeverity.info:
        return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = review.record;
    final highest = review.highestSeverity;
    final verdictColor =
        highest != null ? _severityColor(highest) : const Color(0xFF16A34A);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.sheet,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      record.id.isNotEmpty ? record.id : record.canonicalId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: verdictColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: verdictColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          highest != null
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          size: 16,
                          color: verdictColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          review.verdictLabel,
                          style: TextStyle(
                            color: verdictColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Issues (if any)
                    Text(
                      'KẾT QUẢ ĐÁNH GIÁ CHẤT LƯỢNG (${review.issues.length} vấn đề)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (review.issues.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueGrey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blueGrey.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Không phát hiện vấn đề theo các rule deterministic đã chạy; không kết luận testcase đúng.',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...review.issues.map((issue) {
                        final color = _severityColor(issue.severity);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: color.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _severityLabel(issue.severity),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Trường: ${issue.field.name}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '[${issue.code}]',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                issue.message,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              if (issue.evidence.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Bằng chứng: "${issue.evidence}"',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: Color(0xFF2563EB)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      issue.correction,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1D4ED8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                    const Divider(height: 36),

                    // Section: Raw Test Case Fields
                    Text(
                      'CHI TIẾT CÁC TRƯỜNG DỮ LIỆU GỐC (TRÍCH XUẤT TỪ EXCEL)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FieldBlock(
                      label: 'Mô tả kiểm thử (Description)',
                      value: record.description,
                      icon: Icons.subject,
                    ),
                    const SizedBox(height: 12),
                    _FieldBlock(
                      label: 'Điều kiện tiên quyết (Pre-condition)',
                      value: record.preCondition,
                      icon: Icons.login,
                    ),
                    const SizedBox(height: 12),
                    _FieldBlock(
                      label: 'Các bước thực hiện (Procedure Steps)',
                      value: record.steps,
                      icon: Icons.format_list_numbered,
                    ),
                    const SizedBox(height: 12),
                    _FieldBlock(
                      label: 'Dữ liệu đầu vào (Test Data)',
                      value: record.testData,
                      icon: Icons.input,
                    ),
                    const SizedBox(height: 12),
                    _FieldBlock(
                      label: 'Kết quả mong đợi (Expected Result)',
                      value: record.expected,
                      icon: Icons.task_alt,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FieldBlock(
                            label: 'Trạng thái thực thi (Status)',
                            value: record.status.isNotEmpty
                                ? record.status
                                : '(Trống)',
                            icon: Icons.flag_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FieldBlock(
                            label: 'Ngày kiểm thử (Test Date)',
                            value: record.testDate.isNotEmpty
                                ? record.testDate
                                : '(Trống)',
                            icon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FieldBlock(
                            label: 'Mã lỗi (Bug / Defect ID)',
                            value: record.bug.isNotEmpty
                                ? record.bug
                                : '(Không có)',
                            icon: Icons.bug_report_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FieldBlock(
                            label: 'Ghi chú (Note)',
                            value: record.note.isNotEmpty
                                ? record.note
                                : '(Không có)',
                            icon: Icons.note_outlined,
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
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FieldBlock({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.trim().isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            isEmpty ? '(Không có dữ liệu)' : value,
            style: TextStyle(
              fontSize: 13,
              color: isEmpty ? Colors.grey.shade400 : Colors.black87,
              fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
