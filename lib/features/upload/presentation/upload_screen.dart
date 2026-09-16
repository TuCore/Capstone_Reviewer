import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'upload_controller.dart';
import '../../review/presentation/review_screen.dart';
import '../../../core/services/ai_service.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadControllerProvider);
    final controller = ref.read(uploadControllerProvider.notifier);

    // Sync saved settings into text fields (chạy khi load xong file json)
    if (state.apiKey.isNotEmpty && _apiKeyController.text.isEmpty) {
      _apiKeyController.text = state.apiKey;
    }

    // BẮT BUỘC cả 3 file + API Key
    final bool canAnalyze = state.excelPath != null &&
        state.pdfPath != null &&
        state.proposalPath != null &&
        state.apiKey.isNotEmpty &&
        !state.isAnalyzing;

    String apiKeyLabel = 'Gemini API Key (Bắt buộc)';
    if (state.provider == AIProvider.chatgpt) apiKeyLabel = 'OpenAI API Key (Bắt buộc)';
    if (state.provider == AIProvider.claude) apiKeyLabel = 'Anthropic API Key (Bắt buộc)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capstone Reviewer - Tải lên tài liệu'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
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
                    value: state.provider,
                    items: const [
                      DropdownMenuItem(value: AIProvider.gemini, child: Text('Google Gemini')),
                      DropdownMenuItem(value: AIProvider.chatgpt, child: Text('OpenAI ChatGPT')),
                      DropdownMenuItem(value: AIProvider.claude, child: Text('Anthropic Claude')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.setProvider(val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: apiKeyLabel,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.key),
                    ),
                    obscureText: true,
                    onChanged: controller.setApiKey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                color: Colors.red.shade100,
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _FileDropZone(
                      title: 'File Excel (Test Cases)',
                      subtitle: 'Bắt buộc • .xlsx, .xls',
                      icon: Icons.table_chart,
                      color: Colors.green,
                      filePath: state.excelPath,
                      onSelect: controller.pickExcelFile,
                      onClear: controller.clearExcel,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FileDropZone(
                      title: 'File SRS (Đặc tả dự án)',
                      subtitle: 'Bắt buộc • .pdf, .docx, .doc',
                      icon: Icons.description,
                      color: Colors.deepPurple,
                      filePath: state.pdfPath,
                      onSelect: controller.pickPdfFile,
                      onClear: controller.clearPdf,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FileDropZone(
                      title: 'Phiếu Đăng Ký Đồ Án',
                      subtitle: 'Bắt buộc • .pdf, .docx, .doc',
                      icon: Icons.assignment,
                      color: Colors.orange,
                      filePath: state.proposalPath,
                      onSelect: controller.pickProposalFile,
                      onClear: controller.clearProposal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: canAnalyze
                    ? () async {
                        var result = await controller.analyzeFiles();
                        if (result != null) {
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                reviewContent: result,
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: state.isAnalyzing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Đang phân tích...'),
                        ],
                      )
                    : const Text('BẮT ĐẦU PHÂN TÍCH (REVIEW)'),
              ),
            ),
          ],
        ),
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
  final VoidCallback onSelect;
  final VoidCallback onClear;

  const _FileDropZone({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.filePath,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = filePath != null;
    final String fileName = hasFile ? filePath!.split(RegExp(r'[/\\]')).last : '';

    return InkWell(
      onTap: hasFile ? null : onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: hasFile ? color : Colors.grey.shade300,
            width: 2,
            style: hasFile ? BorderStyle.solid : BorderStyle.none,
          ),
          color: hasFile ? color.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: hasFile
            ? Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 64, color: color),
                        const SizedBox(height: 16),
                        Text(
                          'Đã chọn file:',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            fileName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: onClear,
                      tooltip: 'Xóa file',
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhấn để chọn file',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
