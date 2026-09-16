import 'package:flutter/material.dart';
import '../../../../core/models/test_case_suggestion.dart';
import '../../../../core/services/excel_export_service.dart';

/// Dialog hiển thị toàn bộ test case gợi ý bổ sung
class SuggestionDialog extends StatefulWidget {
  final List<TestCaseSuggestion> suggestions;

  const SuggestionDialog({super.key, required this.suggestions});

  @override
  State<SuggestionDialog> createState() => _SuggestionDialogState();
}

class _SuggestionDialogState extends State<SuggestionDialog> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_fix_high, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Test Case Gợi Ý Bổ Sung — Chuẩn IEEE 829 / ISO 29119',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Export Excel button
                  _isExporting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : ElevatedButton.icon(
                          onPressed: _exportExcel,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Tải về Excel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.suggestions.length,
                itemBuilder: (context, index) {
                  final s = widget.suggestions[index];
                  return _suggestionCard(s, index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionCard(TestCaseSuggestion s, int index) {
    final typeColor = Color(s.typeColorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: typeColor.withOpacity(0.1),
          child: Text('$index', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: typeColor)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(s.type, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: typeColor)),
            ),
            const SizedBox(width: 8),
            Text(s.testCaseId, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        children: [
          _detailRow('📋 REQ ID', s.reqId),
          _detailRow('⚙️ Tiền điều kiện', s.preconditions),
          _detailRow('🔢 Dữ liệu thử', s.testData),
          _detailRow('📝 Các bước thao tác', s.steps),
          _detailRow('✅ Kết quả kỳ vọng', s.expected),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, style: const TextStyle(fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      final service = ExcelExportService();
      final path = await service.exportSuggestionsToExcel(widget.suggestions);
      if (!mounted) return;
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xuất Excel thành công tại:\n$path'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xuất Excel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
