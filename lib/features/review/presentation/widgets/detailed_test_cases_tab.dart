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
    final modules = allReviews.map((r) => r.record.sheet).toSet().toList()
      ..sort();

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
    final criticalCount = allReviews
        .where((r) => r.highestSeverity == TestCaseIssueSeverity.critical)
        .length;
    final highCount = allReviews
        .where((r) => r.highestSeverity == TestCaseIssueSeverity.high)
        .length;

    // Apply filtering
    var filtered = allReviews.where((rev) {
      final rec = rev.record;
      if (_onlyWithIssues && !rev.hasIssues) return false;

      if (_selectedModule != null && rec.sheet != _selectedModule) {
        return false;
      }

      if (_selectedSeverity != null && rev.highestSeverity != _selectedSeverity) {
        return false;
      }

      if (_selectedStatus != null && rec.status.trim() != _selectedStatus) {
        return false;
      }

      if (_selectedIssueCode != null &&
          !rev.issues.any((i) => i.code == _selectedIssueCode)) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchId = rec.id.toLowerCase().contains(query) ||
            rec.canonicalId.toLowerCase().contains(query);
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
        // Summary stats bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          color: Colors.grey.shade50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatChip(
                  label: 'Tổng số test cases',
                  value: '$totalCount',
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Cần sửa đổi / xem lại',
                  value: '$issuesCount',
                  color: issuesCount > 0 ? Colors.red.shade700 : Colors.green,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Không phát hiện lỗi',
                  value: '$cleanCount',
                  color: Colors.green.shade700,
                ),
                if (criticalCount > 0) ...[
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Lỗi nghiêm trọng',
                    value: '$criticalCount',
                    color: Colors.red.shade800,
                  ),
                ],
                if (highCount > 0) ...[
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Mức cao (High)',
                    value: '$highCount',
                    color: Colors.orange.shade800,
                  ),
                ],
                const SizedBox(width: 24),
                Text(
                  'Hiển thị: ${filtered.length}/$totalCount ca',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Controls / Filters row
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm ID, mô tả, module...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [

              // Module filter
              DropdownButton<String?>(
                value: _selectedModule,
                hint: const Text('Tất cả Sheet / Module'),
                underline: const SizedBox(),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Tất cả Sheet / Module'),
                  ),
                  ...modules.map((m) => DropdownMenuItem(
                        value: m,
                        child: Text('Sheet: $m'),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedModule = val),
              ),
              const SizedBox(width: 12),

              // Severity filter
              DropdownButton<TestCaseIssueSeverity?>(
                value: _selectedSeverity,
                hint: const Text('Mọi mức độ lỗi'),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Mọi mức độ lỗi'),
                  ),
                  DropdownMenuItem(
                    value: TestCaseIssueSeverity.critical,
                    child: Text('🔴 Lỗi nghiêm trọng (Critical)'),
                  ),
                  DropdownMenuItem(
                    value: TestCaseIssueSeverity.high,
                    child: Text('🟠 Mức cao (High)'),
                  ),
                  DropdownMenuItem(
                    value: TestCaseIssueSeverity.medium,
                    child: Text('🟡 Mức trung bình (Medium)'),
                  ),
                  DropdownMenuItem(
                    value: TestCaseIssueSeverity.low,
                    child: Text('🔵 Mức thấp (Low)'),
                  ),
                  DropdownMenuItem(
                    value: TestCaseIssueSeverity.info,
                    child: Text('⚪ Thông tin (Info)'),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedSeverity = val),
              ),
              const SizedBox(width: 12),

              // Status filter
              if (statuses.isNotEmpty) ...[
                DropdownButton<String?>(
                  value: _selectedStatus,
                  hint: const Text('Trạng thái test'),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Tất cả trạng thái'),
                    ),
                    ...statuses.map((st) => DropdownMenuItem(
                          value: st,
                          child: Text('Status: $st'),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedStatus = val),
                ),
                const SizedBox(width: 12),
              ],

              // Issue code filter
              if (issueCodes.isNotEmpty) ...[
                DropdownButton<String?>(
                  value: _selectedIssueCode,
                  hint: const Text('Mã lỗi (Issue Code)'),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Tất cả mã lỗi'),
                    ),
                    ...issueCodes.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text('Mã: $c'),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedIssueCode = val),
                ),
                const SizedBox(width: 12),
              ],
              // Filter only with issues toggle
              FilterChip(
                label: const Text('Chỉ ca có lỗi'),
                selected: _onlyWithIssues,
                onSelected: (val) => setState(() => _onlyWithIssues = val),
              ),
              const SizedBox(width: 12),

              // Sort dropdown
              DropdownButton<String>(
                value: _sortBy,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'severity',
                    child: Text('Sắp xếp: Mức lỗi giảm dần'),
                  ),
                  DropdownMenuItem(
                    value: 'id',
                    child: Text('Sắp xếp: Theo ID'),
                  ),
                  DropdownMenuItem(
                    value: 'module',
                    child: Text('Sắp xếp: Theo Sheet'),
                  ),
                  DropdownMenuItem(
                    value: 'status',
                    child: Text('Sắp xếp: Theo Trạng thái'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _sortBy = val);
                },
              ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List of test cases (lazy ListView)
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Không tìm thấy test case nào phù hợp với bộ lọc.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final rev = filtered[index];
                    final rec = rev.record;
                    final highest = rev.highestSeverity;
                    final color = _severityColor(highest);

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: rev.hasIssues
                              ? color.withValues(alpha: 0.3)
                              : Colors.grey.shade200,
                        ),
                      ),
                      color: rev.hasIssues
                          ? color.withValues(alpha: 0.02)
                          : Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => TestCaseDetailDialog(review: rev),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              // Sheet badge
                              Container(
                                width: 72,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  rec.sheet,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Test Case ID
                              SizedBox(
                                width: 110,
                                child: Text(
                                  rec.id.isNotEmpty ? rec.id : rec.canonicalId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec.description.isNotEmpty
                                          ? rec.description
                                          : '(Không có mô tả)',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: rec.description.isNotEmpty
                                            ? Colors.black87
                                            : Colors.red.shade700,
                                        fontStyle: rec.description.isNotEmpty
                                            ? FontStyle.normal
                                            : FontStyle.italic,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (rev.issues.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        rev.issues
                                            .map((e) => '[${e.code}] ${e.message}')
                                            .join(' • '),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: color,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Status badge
                              if (rec.status.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _statusColor(rec.status)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rec.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _statusColor(rec.status),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],

                              // Verdict badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  rev.verdictLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Issue count chip
                              if (rev.issues.isNotEmpty)
                                CircleAvatar(
                                  radius: 11,
                                  backgroundColor: color,
                                  child: Text(
                                    '${rev.issues.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF16A34A),
                                  size: 18,
                                ),

                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right,
                                  size: 18, color: Colors.grey),
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

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
