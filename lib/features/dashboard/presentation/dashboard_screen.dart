import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../upload/presentation/upload_controller.dart';
import '../../upload/presentation/widgets/settings_dialog.dart';
import '../../review/presentation/review_screen.dart';
import '../../review/review_bundle.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/services/excel_export_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedTab = 0;
  bool _sidebarCollapsed = false;
  bool _isSidebarPinned = true;
  bool _isExportingPdf = false;
  bool _isExportingExcel = false;

  static const _sidebarWidth = 240.0;
  static const _sidebarCollapsedWidth = 64.0;

  static const _navItems = <_NavItem>[
    _NavItem(Icons.fact_check_outlined, 'Chi tiết Test Case'),
    _NavItem(Icons.dashboard_outlined, 'Tổng quan'),
    _NavItem(Icons.compare_arrows_outlined, 'Đối chiếu 3 nguồn'),
    _NavItem(Icons.warning_amber_rounded, 'Lỗi & Toàn vẹn'),
    _NavItem(Icons.verified_outlined, 'Nhận định xác minh'),
    _NavItem(Icons.description_outlined, 'Báo cáo đầy đủ'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadControllerProvider);
    final controller = ref.read(uploadControllerProvider.notifier);
    final locked = state.isAnalyzing;
    final hasReport = state.reviewBundle != null;
    final theme = Theme.of(context);
    final width = _sidebarCollapsed ? _sidebarCollapsedWidth : _sidebarWidth;

    return Scaffold(
      body: Column(
        children: [
          // ── Top App Bar ──
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B365D),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.assessment_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Capstone Reviewer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (state.isAnalyzing) ...[
                  const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.statusMessage ?? 'Đang phân tích...',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: controller.cancelAnalyze,
                    child: const Text('HỦY', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
                  onPressed: locked
                      ? null
                      : () => showDialog(
                            context: context,
                            builder: (_) => const SettingsDialog(),
                          ),
                  tooltip: 'Cài đặt API Key & Model',
                ),
              ],
            ),
          ),

          // ── Error Banner ──
          if (state.error != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: theme.colorScheme.errorContainer,
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: theme.colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: TextStyle(color: theme.colorScheme.onErrorContainer, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => ref.read(uploadControllerProvider.notifier).refreshSettings(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

          // ── Main Body: Sidebar + Content ──
          Expanded(
            child: Row(
              children: [
                // ── SIDEBAR ──
                MouseRegion(
                  onEnter: (_) {
                    if (!_isSidebarPinned) setState(() => _sidebarCollapsed = false);
                  },
                  onExit: (_) {
                    if (!_isSidebarPinned) setState(() => _sidebarCollapsed = true);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      children: [
                      // ── Upload Section ──
                      Padding(
                        padding: EdgeInsets.all(_sidebarCollapsed ? 8 : 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!_sidebarCollapsed)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TÀI LIỆU',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isSidebarPinned = !_isSidebarPinned;
                                          if (!_isSidebarPinned) _sidebarCollapsed = false;
                                        });
                                      },
                                      child: Icon(
                                        _isSidebarPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                        size: 16,
                                        color: _isSidebarPinned ? const Color(0xFF1B365D) : Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            _SidebarFilePicker(
                              icon: Icons.assignment_outlined,
                              label: 'Phiếu Đăng Ký',
                              filePath: state.registrationPath,
                              enabled: !locked,
                              collapsed: _sidebarCollapsed,
                              onSelect: controller.pickRegistrationFile,
                              onClear: controller.clearRegistration,
                            ),
                            const SizedBox(height: 4),
                            _SidebarFilePicker(
                              icon: Icons.article_outlined,
                              label: 'SRS',
                              filePath: state.srsPath,
                              enabled: !locked,
                              collapsed: _sidebarCollapsed,
                              onSelect: controller.pickSrsFile,
                              onClear: controller.clearSrs,
                            ),
                            const SizedBox(height: 4),
                            _SidebarFilePicker(
                              icon: Icons.table_chart_outlined,
                              label: 'Test Cases',
                              filePath: state.excelPath,
                              enabled: !locked,
                              collapsed: _sidebarCollapsed,
                              onSelect: controller.pickExcelFile,
                              onClear: controller.clearExcel,
                            ),
                            const SizedBox(height: 8),
                            // Analyze button
                            _sidebarCollapsed
                                ? IconButton(
                                    onPressed: state.canAnalyze && !locked
                                        ? () => controller.analyzeFiles()
                                        : null,
                                    icon: locked
                                        ? const SizedBox(
                                            width: 18, height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.play_arrow_rounded),
                                    tooltip: 'Phân tích',
                                    style: IconButton.styleFrom(
                                      backgroundColor: state.canAnalyze
                                          ? const Color(0xFF1B365D)
                                          : Colors.grey.shade300,
                                      foregroundColor: Colors.white,
                                    ),
                                  )
                                : SizedBox(
                                    height: 36,
                                    child: FilledButton.icon(
                                      onPressed: state.canAnalyze && !locked
                                          ? () => controller.analyzeFiles()
                                          : null,
                                      icon: locked
                                          ? const SizedBox(
                                              width: 16, height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2, color: Colors.white70),
                                            )
                                          : const Icon(Icons.analytics, size: 18),
                                      label: Text(locked ? 'ĐANG PHÂN TÍCH...' : 'PHÂN TÍCH',
                                          style: const TextStyle(fontSize: 13)),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF1B365D),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: Colors.grey.shade300),

                      // ── Navigation Section ──
                      if (hasReport) ...[
                        if (!_sidebarCollapsed)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                            child: Text(
                              'BÁO CÁO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: _sidebarCollapsed ? 8 : 8,
                              vertical: 4,
                            ),
                            itemCount: _navItems.length,
                            itemBuilder: (context, index) {
                              final item = _navItems[index];
                              final selected = _selectedTab == index;
                              final badge = _badgeFor(index, state.reviewBundle!);

                              if (_sidebarCollapsed) {
                                return Tooltip(
                                  message: item.label,
                                  preferBelow: false,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF1B365D).withValues(alpha: 0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Badge(
                                        isLabelVisible: badge != null,
                                        label: badge != null ? Text(badge, style: const TextStyle(fontSize: 9)) : null,
                                        backgroundColor: _badgeColor(index),
                                        child: Icon(
                                          item.icon,
                                          color: selected ? const Color(0xFF1B365D) : Colors.grey.shade600,
                                          size: 22,
                                        ),
                                      ),
                                      onPressed: () => setState(() => _selectedTab = index),
                                    ),
                                  ),
                                );
                              }

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedTab = index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xFF1B365D).withValues(alpha: 0.08)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              item.icon,
                                              size: 20,
                                              color: selected ? const Color(0xFF1B365D) : Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                item.label,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                                  color: selected ? const Color(0xFF1B365D) : Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                            if (badge != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _badgeColor(index),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  badge,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),

                        Divider(height: 1, color: Colors.grey.shade300),

                        // Export buttons
                        Padding(
                          padding: EdgeInsets.all(_sidebarCollapsed ? 8 : 12),
                          child: _sidebarCollapsed
                              ? Column(
                                  children: [
                                    IconButton(
                                      icon: _isExportingPdf ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.picture_as_pdf_outlined, size: 20),
                                      tooltip: 'Xuất PDF',
                                      onPressed: (_isExportingPdf || _isExportingExcel) ? null : () => _exportPdf(state.reviewBundle!),
                                    ),
                                    IconButton(
                                      icon: _isExportingExcel ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.table_view, size: 20),
                                      tooltip: 'Xuất Excel',
                                      onPressed: (_isExportingPdf || _isExportingExcel) ? null : () => _exportExcel(state.reviewBundle!),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 32,
                                      child: OutlinedButton.icon(
                                        onPressed: (_isExportingPdf || _isExportingExcel) ? null : () => _exportPdf(state.reviewBundle!),
                                        icon: _isExportingPdf ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.picture_as_pdf_outlined, size: 16),
                                        label: const Text('Xuất PDF', style: TextStyle(fontSize: 12)),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      height: 32,
                                      child: OutlinedButton.icon(
                                        onPressed: (_isExportingPdf || _isExportingExcel) ? null : () => _exportExcel(state.reviewBundle!),
                                        icon: _isExportingExcel ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.table_view, size: 16),
                                        label: const Text('Xuất Excel', style: TextStyle(fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ] else
                        // No report: show empty nav placeholder
                        const Expanded(
                          child: SizedBox.shrink(),
                        ),
                    ],
                  ),
                ),
                ),

                // ── CONTENT AREA ──
                Expanded(
                  child: hasReport
                      ? ReviewScreen(
                          bundle: state.reviewBundle!,
                          selectedTab: _selectedTab,
                          isEmbedded: true,
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.upload_file_outlined, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'Vui lòng tải lên tài liệu và nhấn Phân Tích.',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                              ),
                              if (!state.canAnalyze && state.missingInputs.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Còn thiếu: ${state.missingInputs.join(", ")}',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf(ReviewBundle bundle) async {
    setState(() => _isExportingPdf = true);
    try {
      await PdfExportService().exportReportToPdf(bundle);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi xuất PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExportingPdf = false);
    }
  }

  Future<void> _exportExcel(ReviewBundle bundle) async {
    setState(() => _isExportingExcel = true);
    try {
      await ExcelExportService().export(
        stats: bundle.stats,
        checks: bundle.checks,
        records: bundle.records,
        reviewMarkdown: bundle.markdown,
        caseReviews: bundle.caseReviews,
        verifiedFindings: bundle.verifiedFindings,
        crossCheck: bundle.crossCheck,
        registrationContext: bundle.registrationContext,
        projectInfo: bundle.projectInfo,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi xuất Excel: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExportingExcel = false);
    }
  }

  String? _badgeFor(int index, ReviewBundle bundle) {
    switch (index) {
      case 0:
        return '${bundle.caseReviews.length}';
      case 3:
        final count = bundle.checks.length +
            (bundle.crossCheck?.duplicateIds.length ?? 0) +
            (bundle.crossCheck?.integrityFindings.length ?? 0);
        return count > 0 ? '$count' : null;
      case 4:
        return bundle.verifiedFindings.isNotEmpty
            ? '${bundle.verifiedFindings.length}'
            : null;
      default:
        return null;
    }
  }

  Color _badgeColor(int index) {
    switch (index) {
      case 0:
        return Colors.blueGrey;
      case 3:
        return Colors.orange.shade700;
      case 4:
        return Colors.green.shade700;
      default:
        return Colors.blueGrey;
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _SidebarFilePicker extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? filePath;
  final bool enabled;
  final bool collapsed;
  final VoidCallback onSelect;
  final VoidCallback onClear;

  const _SidebarFilePicker({
    required this.icon,
    required this.label,
    this.filePath,
    required this.enabled,
    required this.collapsed,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = filePath != null;
    final fileName = hasFile ? filePath!.split(RegExp(r'[/\\]')).last : null;

    if (collapsed) {
      return Tooltip(
        message: hasFile ? '$label: $fileName' : '$label: Chưa chọn',
        child: IconButton(
          onPressed: !enabled ? null : (hasFile ? onClear : onSelect),
          icon: Icon(
            hasFile ? Icons.check_circle : icon,
            color: hasFile ? Colors.green.shade600 : Colors.grey.shade500,
            size: 22,
          ),
          style: IconButton.styleFrom(
            backgroundColor: hasFile
                ? Colors.green.shade50
                : Colors.grey.shade100,
          ),
        ),
      );
    }

    return InkWell(
      onTap: !enabled ? null : (hasFile ? null : onSelect),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: hasFile ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasFile ? Colors.green.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle : icon,
              size: 18,
              color: hasFile ? Colors.green.shade600 : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    hasFile ? fileName! : 'Chưa chọn',
                    style: TextStyle(
                      fontSize: 12,
                      color: hasFile ? Colors.grey.shade800 : Colors.grey.shade400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (hasFile && enabled)
              InkWell(
                onTap: onClear,
                child: Icon(Icons.close, size: 16, color: Colors.red.shade400),
              ),
          ],
        ),
      ),
    );
  }
}
