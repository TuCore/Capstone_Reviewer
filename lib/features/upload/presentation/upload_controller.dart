import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/services/excel_service.dart';
import '../../../core/services/document_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/local_storage_service.dart';

class UploadState {
  final String? excelPath;
  final String? pdfPath;
  final String? proposalPath; // Phiếu đăng ký đồ án (BẮT BUỘC)
  final String apiKey;
  final AIProvider provider;
  final bool isAnalyzing;
  final String? error;

  UploadState({
    this.excelPath,
    this.pdfPath,
    this.proposalPath,
    this.apiKey = '',
    this.provider = AIProvider.gemini,
    this.isAnalyzing = false,
    this.error,
  });

  UploadState copyWith({
    String? excelPath,
    String? pdfPath,
    String? proposalPath,
    String? apiKey,
    AIProvider? provider,
    bool? isAnalyzing,
    String? error,
  }) {
    return UploadState(
      excelPath: excelPath ?? this.excelPath,
      pdfPath: pdfPath ?? this.pdfPath,
      proposalPath: proposalPath ?? this.proposalPath,
      apiKey: apiKey ?? this.apiKey,
      provider: provider ?? this.provider,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
    );
  }
}

class UploadController extends Notifier<UploadState> {
  @override
  UploadState build() {
    // Load saved settings on init
    _loadSavedSettings();
    return UploadState();
  }

  Future<void> _loadSavedSettings() async {
    try {
      final storage = LocalStorageService();
      final settings = await storage.loadSettings();
      if (settings != null) {
        final savedKey = settings['apiKey'] as String? ?? '';
        final savedProvider = AIProvider.values.firstWhere(
          (p) => p.name == (settings['provider'] as String? ?? 'gemini'),
          orElse: () => AIProvider.gemini,
        );
        if (savedKey.isNotEmpty) {
          state = state.copyWith(
            apiKey: savedKey, 
            provider: savedProvider
          );
        }
      }
    } catch (_) {}
  }

  Future<void> pickExcelFile() async {
    try {
      PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.path != null) {
        state = state.copyWith(excelPath: result.path, error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Lỗi khi chọn file Excel: $e');
    }
  }

  Future<void> pickPdfFile() async {
    try {
      PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );

      if (result != null && result.path != null) {
        state = state.copyWith(pdfPath: result.path, error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Lỗi khi chọn file SRS: $e');
    }
  }

  Future<void> pickProposalFile() async {
    try {
      PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );

      if (result != null && result.path != null) {
        state = state.copyWith(proposalPath: result.path, error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Lỗi khi chọn Phiếu đăng ký: $e');
    }
  }

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key.trim());
    _saveSettings();
  }

  void setProvider(AIProvider provider) {
    state = state.copyWith(provider: provider);
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final storage = LocalStorageService();
      await storage.saveSettings(
        apiKey: state.apiKey,
        provider: state.provider,
      );
    } catch (_) {}
  }

  void clearExcel() {
    state = state.copyWith(excelPath: null);
  }

  void clearPdf() {
    state = state.copyWith(pdfPath: null);
  }

  void clearProposal() {
    state = state.copyWith(proposalPath: null);
  }

  Future<String?> analyzeFiles() async {
    if (state.excelPath == null || state.pdfPath == null || state.proposalPath == null || state.apiKey.isEmpty) {
      state = state.copyWith(error: 'Vui lòng cung cấp đủ 3 file (Test Cases, SRS, Phiếu Đăng Ký) và API Key.');
      return null;
    }

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // 1. Extract data
      final excelService = ExcelService();
      final testCasesContent = await excelService.extractTestCases(state.excelPath!);

      final docService = DocumentService();
      final srsContent = await docService.extractText(state.pdfPath!);

      // 2. Extract proposal content (BẮT BUỘC)
      final proposalContent = await docService.extractText(state.proposalPath!);

      // 3. Call AI with structured JSON prompt
      final aiService = AIService(apiKey: state.apiKey, provider: state.provider);
      final reviewResult = await aiService.reviewTestCasesStructured(
        srsContent: srsContent,
        testCasesContent: testCasesContent,
        proposalContent: proposalContent,
      );

      state = state.copyWith(isAnalyzing: false);
      return reviewResult;
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: 'Lỗi phân tích: $e');
      return null;
    }
  }
}

final uploadControllerProvider = NotifierProvider<UploadController, UploadState>(() {
  return UploadController();
});
