import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/services/excel_service.dart';
import '../../../core/services/document_service.dart';
import '../../../core/services/ai_service.dart';

class UploadState {
  final String? excelPath;
  final String? pdfPath;
  final String apiKey;
  final AIProvider provider;
  final bool isAnalyzing;
  final String? error;

  UploadState({
    this.excelPath,
    this.pdfPath,
    this.apiKey = '',
    this.provider = AIProvider.gemini,
    this.isAnalyzing = false,
    this.error,
  });

  UploadState copyWith({
    String? excelPath,
    String? pdfPath,
    String? apiKey,
    AIProvider? provider,
    bool? isAnalyzing,
    String? error,
  }) {
    return UploadState(
      excelPath: excelPath ?? this.excelPath,
      pdfPath: pdfPath ?? this.pdfPath,
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
    return UploadState();
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
      state = state.copyWith(error: 'Lỗi khi chọn file PDF: $e');
    }
  }

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key.trim());
  }

  void setProvider(AIProvider provider) {
    state = state.copyWith(provider: provider);
  }

  void clearExcel() {
    state = UploadState(
      excelPath: null,
      pdfPath: state.pdfPath,
      apiKey: state.apiKey,
      provider: state.provider,
      isAnalyzing: state.isAnalyzing,
      error: state.error,
    );
  }

  void clearPdf() {
    state = UploadState(
      excelPath: state.excelPath,
      pdfPath: null,
      apiKey: state.apiKey,
      provider: state.provider,
      isAnalyzing: state.isAnalyzing,
      error: state.error,
    );
  }

  Future<String?> analyzeFiles() async {
    if (state.excelPath == null || state.pdfPath == null || state.apiKey.isEmpty) {
      state = state.copyWith(error: 'Vui lòng cung cấp đủ file và API Key.');
      return null;
    }

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // 1. Extract data
      final excelService = ExcelService();
      final testCasesContent = await excelService.extractTestCases(state.excelPath!);

      final docService = DocumentService();
      final srsContent = await docService.extractText(state.pdfPath!);

      // 2. Call AI
      final aiService = AIService(apiKey: state.apiKey, provider: state.provider);
      final reviewResult = await aiService.reviewTestCases(
        srsContent: srsContent,
        testCasesContent: testCasesContent,
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
