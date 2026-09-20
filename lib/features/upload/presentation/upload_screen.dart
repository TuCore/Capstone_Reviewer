import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/ai_service.dart';
import '../../review/presentation/review_screen.dart';
import 'upload_controller.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadControllerProvider);
    final controller = ref.read(uploadControllerProvider.notifier);
    final locked = state.isAnalyzing;

    String apiKeyLabel;
    switch (state.provider) {
      case AIProvider.gemini:
        apiKeyLabel = 'Gemini API Key (Bắt buộc)';
        break;
      case AIProvider.chatgpt:
        apiKeyLabel = 'OpenAI API Key (Bắt buộc)';
        break;
      case AIProvider.claude:
        apiKeyLabel = 'Anthropic API Key (Bắt buộc)';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capstone Reviewer - Tải lên tài liệu'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final dropHeight = (constraints.maxHeight - 340).clamp(200.0, 480.0);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<AIProvider>(
                          decoration: const InputDecoration(
                            labelText: 'Chọn AI Provider',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: state.provider,
                          items: const [
                            DropdownMenuItem(
                              value: AIProvider.gemini,
                              child: Text('Google Gemini'),
                            ),
                            DropdownMenuItem(
                              value: AIProvider.chatgpt,
                              child: Text('OpenAI ChatGPT'),
                            ),
                            DropdownMenuItem(
                              value: AIProvider.claude,
                              child: Text('Anthropic Claude'),
                            ),
                          ],
                          onChanged: locked
                              ? null
                              : (val) {
                                  if (val != null) controller.setProvider(val);
                                },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          enabled: !locked,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: apiKeyLabel,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.key),
                          ),
                          onChanged: controller.setApiKey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Soi sâu từng use case (pass 2, chậm hơn)',
                    ),
                    value: state.deepPass,
                    onChanged: locked
                        ? null
                        : (v) => controller.setDeepPass(v ?? false),
                  ),
                  if (state.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.red.shade100,
                      child: Text(
                        state.error!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  if (state.statusMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.orange.shade50,
                      child: Text(state.statusMessage!),
                    ),
                  if (state.unknownModules.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'UNKNOWN: ${state.unknownModules.join('; ')}',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  SizedBox(
                    height: dropHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: _FileDropZone(
                            title: 'Phiếu Đăng Ký Đề Tài',
                            subtitle: 'Bắt buộc • .pdf, .docx',
                            icon: Icons.assignment,
                            color: Colors.orange.shade800,
                            filePath: state.registrationPath,
                            enabled: !locked,
                            onSelect: controller.pickRegistrationFile,
                            onClear: controller.clearRegistration,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _FileDropZone(
                            title: 'File SRS (Đặc tả dự án)',
                            subtitle: 'Bắt buộc • .pdf, .docx',
                            icon: Icons.description,
                            color: Colors.deepPurple,
                            filePath: state.srsPath,
                            enabled: !locked,
                            onSelect: controller.pickSrsFile,
                            onClear: controller.clearSrs,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _FileDropZone(
                            title: 'File Test Report (Excel)',
                            subtitle: 'Bắt buộc • .xlsx, .xls',
                            icon: Icons.table_chart,
                            color: Colors.green,
                            filePath: state.excelPath,
                            enabled: !locked,
                            onSelect: controller.pickExcelFile,
                            onClear: controller.clearExcel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: state.canAnalyze
                                ? () async {
                                    final result =
                                        await controller.analyzeFiles();
                                    if (result != null && context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ReviewScreen(bundle: result),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: state.isAnalyzing
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          state.statusMessage ??
                                              'Đang phân tích...',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text('BẮT ĐẦU PHÂN TÍCH (REVIEW)'),
                          ),
                        ),
                      ),
                      if (state.isAnalyzing) ...[
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: controller.cancelAnalyze,
                            child: const Text('HỦY'),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!state.canAnalyze && !state.isAnalyzing) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Chưa sẵn sàng: thiếu ${state.missingInputs.join(', ')}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      );
  }
}

class _FileDropZone extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? filePath;
  final bool enabled;
  final VoidCallback onSelect;
  final VoidCallback onClear;

  const _FileDropZone({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.filePath,
    required this.enabled,
    required this.onSelect,
    required this.onClear,
  });
  @override
  Widget build(BuildContext context) {
    final bool hasFile = filePath != null;
    final String fileName =
        hasFile ? filePath!.split(RegExp(r'[/\\]')).last : '';

    return InkWell(
      onTap: !enabled || hasFile ? null : onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: hasFile ? color : Colors.grey.shade300,
            width: 2,
            style: hasFile ? BorderStyle.solid : BorderStyle.none,
          ),
          color: hasFile ? color.withValues(alpha: 0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: hasFile
              ? Stack(
                  children: [
                    _scaledColumn(
                      children: [
                        Icon(icon, size: 48, color: color),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Đã chọn file:',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            fileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (enabled)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: onClear,
                          tooltip: 'Xóa file',
                        ),
                      ),
                  ],
                )
              : _scaledColumn(
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nhấn để chọn file',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _scaledColumn({required List<Widget> children}) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
