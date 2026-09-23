import 'package:flutter/material.dart';
import '../../../../core/services/test_case_review_engine.dart';
import 'test_case_detail_dialog.dart';

class DetailedTestCasesTab extends StatefulWidget {
  final List<TestCaseReview> caseReviews;

  const DetailedTestCasesTab({super.key, required this.caseReviews});

  @override
  State<DetailedTestCasesTab> createState() => _DetailedTestCasesTabState();
}

class _DetailedTestCasesTabState extends State<DetailedTestCasesTab> {
  String _searchQuery = '';
  String? _selectedModule;
  TestCaseIssueSeverity? _selectedSeverity;
  String? _selectedStatus;
  String? _selectedIssueCode;
  bool _onlyWithIssues = false;
  String _sortBy = 'severity'; // 'severity', 'id', 'module', 'status'

  Color _severityColor(TestCaseIssueSeverity? severity) {
    if (severity == null) return const Color(0xFF16A34A);
    switch (severity) {
      case TestCaseIssueSeverity.critical:
        return const Color(0xFFDC2626);
      case TestCaseIssueSeverity.high:
        return const Color(0xFFEA580C);
      case TestCaseIssueSeverity.medium:
        return const Color(0xFFD97706);
      case TestCaseIssueSeverity.low:
        return const Color(0xFF2563EB);
      case TestCaseIssueSeverity.info:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allReviews = widget.caseReviews;

    // Filter modules
    final modules = allReviews.map((r) => r.record.sheet).toSet().toList()..sort();

    // Filter statuses
    final statuses = allReviews
        .map((r) => r.record.status.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    // Filter issue codes
    final issueCodes = allReviews
        .expand((r) => r.issues.map((i) => i.code))
        .toSet()
        .toList()
      ..sort();

    // Counts for stat bar
    final totalCount = allReviews.length;
    final issuesCount = allReviews.where((r) => r.hasIssues).length;
    final cleanCount = totalCount - issuesCount;

    // Apply filtering
    var filtered = allReviews.where((rev) {
      final rec = rev.record;
      if (_onlyWithIssues && !rev.hasIssues) return false;
      if (_selectedModule != null && rec.sheet != _selectedModule) return false;
      if (_selectedSeverity != null && rev.highestSeverity != _selectedSeverity) return false;
      if (_selectedStatus != null && rec.status.trim() != _selectedStatus) return false;
      if (_selectedIssueCode != null && !rev.issues.any((i) => i.code == _selectedIssueCode)) return false;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchId = rec.id.toLowerCase().contains(query) || rec.canonicalId.toLowerCase().contains(query);
        final matchDesc = rec.description.toLowerCase().contains(query);
        final matchModule = rec.sheet.toLowerCase().contains(query);
        if (!matchId && !matchDesc && !matchModule) return false;
      }
      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'severity':
          final aSev = a.highestSeverity?.index ?? 999;
          final bSev = b.highestSeverity?.index ?? 999;
          final cmp = aSev.compareTo(bSev);
          if (cmp != 0) return cmp;
          return a.record.id.compareTo(b.record.id);
        case 'id':
          return a.record.id.compareTo(b.record.id);
        case 'module':
          final cmp = a.record.sheet.compareTo(b.record.sheet);
          if (cmp != 0) return cmp;
          return a.record.id.compareTo(b.record.id);
        case 'status':
          return a.record.status.compareTo(b.record.status);
        default:
          return 0;
      }
    });

    return Column(
      children: [
        // Compact Filters Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              // Search
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm ID, mô tả...',
                      prefixIcon: const Icon(Icons.search, size: 16),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      isDense: true,
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 14),
                              onPressed: () => setState(() => _searchQuery = ''),
                              padding: EdgeInsets.zero,
                            )
                          : null,
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Module Filter
              _CompactDropdown<String?>(
                value: _selectedModule,
                hint: 'Module',
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tất cả Module')),
                  ...modules.map((m) => DropdownMenuItem(value: m, child: Text(m))),
                ],
                onChanged: (val) => setState(() => _selectedModule = val),
              ),
              const SizedBox(width: 8),

              // Severity Filter
              _CompactDropdown<TestCaseIssueSeverity?>(
                value: _selectedSeverity,
                hint: 'Mức lỗi',
                items: const [
                  DropdownMenuItem(value: null, child: Text('Tất cả mức lỗi')),
                  DropdownMenuItem(value: TestCaseIssueSeverity.critical, child: Text('Critical')),
                  DropdownMenuItem(value: TestCaseIssueSeverity.high, child: Text('High')),
                  DropdownMenuItem(value: TestCaseIssueSeverity.medium, child: Text('Medium')),
                  DropdownMenuItem(value: TestCaseIssueSeverity.low, child: Text('Low')),
                  DropdownMenuItem(value: TestCaseIssueSeverity.info, child: Text('Info')),
                ],
                onChanged: (val) => setState(() => _selectedSeverity = val),
              ),
              const SizedBox(width: 8),

              // Status Filter
              if (statuses.isNotEmpty) ...[
                _CompactDropdown<String?>(
                  value: _selectedStatus,
                  hint: 'Trạng thái',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Tất cả trạng thái')),
                    ...statuses.map((st) => DropdownMenuItem(value: st, child: Text(st))),
                  ],
                  onChanged: (val) => setState(() => _selectedStatus = val),
                ),
                const SizedBox(width: 8),
              ],

              // Issue Code Filter
              if (issueCodes.isNotEmpty) ...[
                _CompactDropdown<String?>(
                  value: _selectedIssueCode,
                  hint: 'Mã lỗi',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Tất cả mã lỗi')),
                    ...issueCodes.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                  ],
                  onChanged: (val) => setState(() => _selectedIssueCode = val),
                ),
                const SizedBox(width: 8),
              ],

              // Only issues
              FilterChip(
                label: const Text('Có lỗi', style: TextStyle(fontSize: 12)),
                selected: _onlyWithIssues,
                onSelected: (val) => setState(() => _onlyWithIssues = val),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),

              const Spacer(),

              // Sort
              _CompactDropdown<String>(
                value: _sortBy,
                hint: 'Sắp xếp',
                icon: Icons.sort,
                items: const [
                  DropdownMenuItem(value: 'severity', child: Text('Lỗi (Giảm dần)')),
                  DropdownMenuItem(value: 'id', child: Text('Theo ID')),
                  DropdownMenuItem(value: 'module', child: Text('Theo Module')),
                  DropdownMenuItem(value: 'status', child: Text('Theo Trạng thái')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _sortBy = val);
                },
              ),
            ],
          ),
        ),

        // Quick Stats row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Text('Đang xem: ${filtered.length}/$totalCount', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              const SizedBox(width: 16),
              Text('Có lỗi: $issuesCount', style: TextStyle(fontSize: 12, color: issuesCount > 0 ? Colors.red.shade700 : Colors.green)),
              const SizedBox(width: 16),
              Text('Không lỗi: $cleanCount', style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
            ],
          ),
        ),

        // List of test cases
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Không tìm thấy test case nào phù hợp với bộ lọc.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final rev = filtered[index];
                    final rec = rev.record;
                    final highest = rev.highestSeverity;
                    final color = _severityColor(highest);

                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: rev.hasIssues ? color.withValues(alpha: 0.3) : Colors.grey.shade200,
                        ),
                      ),
                      color: rev.hasIssues ? color.withValues(alpha: 0.02) : Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => TestCaseDetailDialog(review: rev),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              // Sheet badge
                              Container(
                                width: 64,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  rec.sheet,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Test Case ID
                              SizedBox(
                                width: 90,
                                child: Text(
                                  rec.id.isNotEmpty ? rec.id : rec.canonicalId,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec.description.isNotEmpty ? rec.description : '(Không có mô tả)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: rec.description.isNotEmpty ? Colors.black87 : Colors.red.shade700,
                                        fontStyle: rec.description.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (rev.issues.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        rev.issues.map((e) => '[${e.code}] ${e.message}').join(' • '),
                                        style: TextStyle(fontSize: 11, color: color),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Status badge
                              if (rec.status.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(rec.status).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    rec.status,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(rec.status)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],

                              // Verdict badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: color.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  rev.verdictLabel,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Issue count
                              if (rev.issues.isNotEmpty)
                                CircleAvatar(
                                  radius: 9,
                                  backgroundColor: color,
                                  child: Text('${rev.issues.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                )
                              else
                                const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('pass')) return const Color(0xFF16A34A);
    if (lower.contains('fail')) return const Color(0xFFDC2626);
    return Colors.grey.shade700;
  }
}

class _CompactDropdown<T> extends StatelessWidget {
  final T value;
  final String hint;
  final IconData? icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _CompactDropdown({
    required this.value,
    required this.hint,
    this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: false,
          icon: icon != null ? Icon(icon, size: 16, color: Colors.grey.shade600) : const Icon(Icons.arrow_drop_down, size: 16),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
          hint: Text(hint, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
