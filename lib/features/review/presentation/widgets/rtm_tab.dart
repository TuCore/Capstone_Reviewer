import 'package:flutter/material.dart';
import '../../../../core/models/review_audit_result.dart';
import '../../../../core/models/rtm_item.dart';
import 'rtm_detail_dialog.dart';

/// Tab 2: Ma trận Truy vết Yêu cầu Trực quan (Interactive RTM)
class RtmTab extends StatefulWidget {
  final ReviewAuditResult result;

  const RtmTab({super.key, required this.result});

  @override
  State<RtmTab> createState() => _RtmTabState();
}

class _RtmTabState extends State<RtmTab> {
  String? _filterStatus;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<RTMItem> get _filteredItems {
    var items = widget.result.rtm;
    if (_filterStatus != null) {
      items = items.where((item) {
        switch (_filterStatus) {
          case 'PASS':
            return item.status == RTMStatus.pass;
          case 'WARNING':
            return item.status == RTMStatus.warning;
          case 'MISSING':
            return item.status == RTMStatus.missing;
          default:
            return true;
        }
      }).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final r = widget.result;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Summary Row ---
          Row(
            children: [
              _statusChip('Tất cả', null, r.rtm.length),
              const SizedBox(width: 8),
              _statusChip('🟢 Đạt', 'PASS', r.passCount),
              const SizedBox(width: 8),
              _statusChip('🟡 Cảnh báo', 'WARNING', r.warningCount),
              const SizedBox(width: 8),
              _statusChip('🔴 Bỏ quên', 'MISSING', r.missingCount),
            ],
          ),
          const SizedBox(height: 16),

          // --- Data Table ---
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                columns: [
                  DataColumn(
                    label: const Text('Mã Yêu Cầu', style: TextStyle(fontWeight: FontWeight.bold)),
                    onSort: (i, asc) => _sort(i, asc),
                  ),
                  DataColumn(
                    label: const Text('Tên Chức Năng', style: TextStyle(fontWeight: FontWeight.bold)),
                    onSort: (i, asc) => _sort(i, asc),
                  ),
                  DataColumn(
                    label: const Text('Số TC', style: TextStyle(fontWeight: FontWeight.bold)),
                    numeric: true,
                    onSort: (i, asc) => _sort(i, asc),
                  ),
                  DataColumn(
                    label: const Text('Trạng Thái', style: TextStyle(fontWeight: FontWeight.bold)),
                    onSort: (i, asc) => _sort(i, asc),
                  ),
                ],
                rows: items.map((item) {
                  return DataRow(
                    onSelectChanged: (_) => _showDetail(context, item),
                    cells: [
                      DataCell(Text(item.reqId, style: const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(item.reqName, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      DataCell(Text('${item.testCount}')),
                      DataCell(_statusBadge(item)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '💡 Nhấn vào bất kỳ dòng nào để xem nhận xét chi tiết',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(RTMItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: item.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.statusColor.withOpacity(0.3)),
      ),
      child: Text(
        '${item.statusEmoji} ${item.statusLabel}',
        style: TextStyle(
          color: item.statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _statusChip(String label, String? status, int count) {
    final isSelected = _filterStatus == status;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _filterStatus = isSelected ? null : status;
        });
      },
      selectedColor: Colors.blue.shade100,
    );
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _showDetail(BuildContext context, RTMItem item) {
    showDialog(
      context: context,
      builder: (context) => RtmDetailDialog(item: item),
    );
  }
}
