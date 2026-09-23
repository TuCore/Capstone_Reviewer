import 'dart:convert';
import 'package:capstone_reviewer/core/services/context_extractor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/extraction/file_gate.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/api_key_format.dart';
import '../../../core/services/coverage_stats.dart';
import '../../../core/services/document_service.dart';
import '../../../core/services/excel_service.dart';
import '../../../core/services/hard_checks.dart';
import '../../../core/services/quote_guard.dart';
import '../../../core/services/registration_pii.dart';
import '../../review/review_bundle.dart';
import '../../../core/services/cross_check_engine.dart';
import '../../../core/services/review_report_composer.dart';
import '../../../core/services/test_case_review_engine.dart';
class UploadState {
  UploadState({
    this.excelPath,
    this.srsPath,
    this.registrationPath,
    this.apiKey = '',
    this.modelName = 'gemini-2.5-flash',
    this.provider = AIProvider.gemini,
    this.isAnalyzing = false,
    this.error,
    this.statusMessage,
    this.skippedSheets = const [],
    this.unknownModules = const [],
    this.truncated = false,
    this.runId = 0,
    this.reviewBundle,
  });

  final String? excelPath;
  final String? srsPath;
  final String? registrationPath;
  final String apiKey;
  final String modelName;
  final AIProvider provider;
  final bool isAnalyzing;
  final String? error;
  final String? statusMessage;
  final List<String> skippedSheets;
  final List<String> unknownModules;
  final bool truncated;
  final int runId;
  final ReviewBundle? reviewBundle;

  bool get canAnalyze =>
      registrationPath != null &&
      srsPath != null &&
      excelPath != null &&
      apiKey.isNotEmpty &&
      !isAnalyzing &&
      ApiKeyFormat.errorFor(provider, apiKey) == null;

  List<String> get missingInputs {
    final list = <String>[];
    if (registrationPath == null) list.add('Phiếu đăng ký');
    if (srsPath == null) list.add('SRS');
    if (excelPath == null) list.add('Excel Test Cases');
    if (apiKey.isEmpty) {
      list.add('API Key');
    } else if (ApiKeyFormat.errorFor(provider, apiKey) != null) {
      list.add('API Key hợp lệ');
    }
    return list;
  }
  UploadState copyWith({
    String? excelPath,
    String? srsPath,
    String? registrationPath,
    String? apiKey,
    String? modelName,
    AIProvider? provider,
    bool? isAnalyzing,
    String? error,
    String? statusMessage,
    List<String>? skippedSheets,
    List<String>? unknownModules,
    bool? truncated,
    int? runId,
    ReviewBundle? reviewBundle,
  }) {
    return UploadState(
      excelPath: excelPath ?? this.excelPath,
      srsPath: srsPath ?? this.srsPath,
      registrationPath: registrationPath ?? this.registrationPath,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
      provider: provider ?? this.provider,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
      statusMessage: statusMessage ?? this.statusMessage,
      skippedSheets: skippedSheets ?? this.skippedSheets,
      unknownModules: unknownModules ?? this.unknownModules,
      truncated: truncated ?? this.truncated,
      runId: runId ?? this.runId,
      reviewBundle: reviewBundle ?? this.reviewBundle,
    );
  }

  UploadState clearError() {
    return UploadState(
      excelPath: excelPath,
      srsPath: srsPath,
      registrationPath: registrationPath,
      apiKey: apiKey,
      modelName: modelName,
      provider: provider,
      isAnalyzing: isAnalyzing,
      error: null,
      statusMessage: statusMessage,
      skippedSheets: skippedSheets,
      unknownModules: unknownModules,
      truncated: truncated,
      runId: runId,
      reviewBundle: reviewBundle,
    );
  }
}

class UploadController extends Notifier<UploadState> {
  final _excelService = ExcelService();
  final _docService = DocumentService();
  http.Client? _http;
  int _generation = 0;

  http.Client get _client => _http ??= http.Client();

  @override
  UploadState build() {
    final settings = ref.watch(settingsServiceProvider);
    return UploadState(
      provider: settings.getProvider(),
      apiKey: settings.getApiKey(),
      modelName: settings.getModelName(),
    );
  }

  void refreshSettings() {
    final settings = ref.read(settingsServiceProvider);
    state = state.copyWith(
      provider: settings.getProvider(),
      apiKey: settings.getApiKey(),
      modelName: settings.getModelName(),
      error: null, // Clear error when settings change
    );
  }

  bool _isStale(int runId) => runId != _generation;

  bool _isPicking = false;

  Future<void> pickExcelFile() async {
    if (state.isAnalyzing || _isPicking) return;
    _isPicking = true;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        windowsOptions: const WindowsOptions(lockParentWindow: true),
      );
      if (result == null || result.path == null) return;
      await _acceptExcel(result.path!);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn file Excel: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> pickSrsFile() async {
    if (state.isAnalyzing || _isPicking) return;
    _isPicking = true;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
        windowsOptions: const WindowsOptions(lockParentWindow: true),
      );
      if (result == null || result.path == null) return;
      await _acceptDoc(result.path!, srs: true);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn file SRS: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> pickRegistrationFile() async {
    if (state.isAnalyzing || _isPicking) return;
    _isPicking = true;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
        windowsOptions: const WindowsOptions(lockParentWindow: true),
      );
      if (result == null || result.path == null) return;
      await _acceptDoc(result.path!, srs: false);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn phiếu đăng ký: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _acceptExcel(String path) async {
    final inspection = FileGate.inspect(path);
    if (inspection.rejected) {
      state = _base().copyWith(error: inspection.rejectReason);
      return;
    }
    String? status = inspection.statusMessage;
    if (inspection.band == FileSizeBand.direct &&
        inspection.kind == DetectedKind.xlsx) {
      try {
        final peek = await compute(peekExcelSync, path);
        status =
            'Excel: ${peek.sheetCount} sheet, ${peek.rowCount} dòng${status == null ? '' : ' — $status'}';
      } on FileRejectedException catch (e) {
        state = _base().copyWith(error: e.message);
        return;
      }
    }
    state = UploadState(
      excelPath: path,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      statusMessage: status,
    );
  }

  Future<void> _acceptDoc(String path, {required bool srs}) async {
    final inspection = FileGate.inspect(path);
    if (inspection.rejected) {
      state = _base().copyWith(error: inspection.rejectReason);
      return;
    }
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: srs ? path : state.srsPath,
      registrationPath: srs ? state.registrationPath : path,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      statusMessage: inspection.statusMessage,
    );
  }

  void setApiKey(String key) {
    final trimmed = ApiKeyFormat.normalize(key);
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: trimmed,
      modelName: state.modelName,
      provider: state.provider,
      error: ApiKeyFormat.errorFor(state.provider, trimmed),
      statusMessage: state.statusMessage,
      skippedSheets: state.skippedSheets,
      unknownModules: state.unknownModules,
      truncated: state.truncated,
      isAnalyzing: state.isAnalyzing,
      runId: state.runId,
      reviewBundle: state.reviewBundle,
    );
  }

  void setProvider(AIProvider provider, {String? modelName}) {
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      modelName: modelName ?? state.modelName,
      provider: provider,
      error: ApiKeyFormat.errorFor(provider, state.apiKey),
      statusMessage: state.statusMessage,
      skippedSheets: state.skippedSheets,
      unknownModules: state.unknownModules,
      truncated: state.truncated,
      isAnalyzing: state.isAnalyzing,
      runId: state.runId,
      reviewBundle: state.reviewBundle,
    );
  }

  void clearExcel() {
    if (state.isAnalyzing) return;
    state = UploadState(
      excelPath: null,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      reviewBundle: state.reviewBundle,
      runId: state.runId,
    );
  }

  void clearSrs() {
    if (state.isAnalyzing) return;
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: null,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      reviewBundle: state.reviewBundle,
      runId: state.runId,
    );
  }

  void clearRegistration() {
    if (state.isAnalyzing) return;
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: null,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      reviewBundle: state.reviewBundle,
      runId: state.runId,
    );
  }

  void cancelAnalyze() {
    _generation++;
    _http?.close();
    _http = http.Client();
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      isAnalyzing: false,
      statusMessage: 'Đã hủy.',
      runId: _generation,
      reviewBundle: state.reviewBundle,
    );
  }

  UploadState _base() {
    return UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      runId: state.runId,
      reviewBundle: state.reviewBundle,
    );
  }

  Future<ReviewBundle?> analyzeFiles() async {
    if (state.isAnalyzing) return null;
    if (state.registrationPath == null ||
        state.srsPath == null ||
        state.excelPath == null) {
      state = _base().copyWith(
        error:
            'Cần đủ 3 tài liệu: Phiếu đăng ký đề tài, SRS và file test case Excel.',
      );
      return null;
    }
    if (state.apiKey.isEmpty) {
      state = _base().copyWith(error: 'Vui lòng nhập API Key.');
      return null;
    }
    final formatError = ApiKeyFormat.errorFor(state.provider, state.apiKey);
    if (formatError != null) {
      state = _base().copyWith(error: formatError);
      return null;
    }

    final regGate = FileGate.inspect(state.registrationPath!);
    final srsGate = FileGate.inspect(state.srsPath!);
    final excelGate = FileGate.inspect(state.excelPath!);
    if (regGate.rejected) {
      state = _base().copyWith(error: regGate.rejectReason);
      return null;
    }
    if (srsGate.rejected) {
      state = _base().copyWith(error: srsGate.rejectReason);
      return null;
    }
    if (excelGate.rejected) {
      state = _base().copyWith(error: excelGate.rejectReason);
      return null;
    }

    final runId = ++_generation;
    final chunked = regGate.band == FileSizeBand.chunked ||
        srsGate.band == FileSizeBand.chunked ||
        excelGate.band == FileSizeBand.chunked;
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      modelName: state.modelName,
      isAnalyzing: true,
      statusMessage:
          chunked ? 'Đang đọc file lớn...' : 'Đang trích tài liệu...',
      runId: runId,
    );

    try {
      final regDoc = await _docService.extract(state.registrationPath!);
      if (_isStale(runId)) return null;
      final regContext = extractRegistrationContext(regDoc.text);
      final registrationBlock = regContext.toPromptBlock();

      final excelResult =
          await _excelService.extractTestCases(state.excelPath!);
      if (_isStale(runId)) return null;
      final docResult = await _docService.extract(state.srsPath!);
      if (_isStale(runId)) return null;

      final unknown = [
        ...excelResult.unknownModules,
        ...docResult.unknownModules,
      ];
      final checks = runHardChecks(
        records: excelResult.records,
        skippedSheets: excelResult.skippedSheets,
      );
      final stats = computeCoverage(
        srsText: docResult.text,
        records: excelResult.records,
        unknownModules: unknown,
      );

      final crossCheck = CrossCheckEngine.run(
        records: excelResult.records,
        wordText: docResult.text,
        excelText: excelResult.text,
        registrationText: registrationBlock,
        workbook: excelResult.workbook,
        excelAvailability: excelResult.availability,
        wordAvailability: docResult.availability,
      );
      final caseReviews = TestCaseReviewEngine.reviewAll(
        records: excelResult.records,
        hardChecks: checks,
        duplicateFindings: crossCheck.duplicateIds,
      );
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: state.apiKey,
        provider: state.provider,
        modelName: state.modelName,
        isAnalyzing: true,
        skippedSheets: excelResult.skippedSheets,
        unknownModules: unknown,
        truncated: excelResult.truncated || docResult.truncated,
        runId: runId,
      );

      final aiService = AIService(
        apiKey: state.apiKey,
        provider: state.provider,
        modelName: state.modelName,
        client: _client,
      );

      // --- PHASE 0: CONTEXT EXTRACTION ---
      final contextExtractor = ContextExtractor(aiService);
      final srsBible = await contextExtractor.extractFromSrs(docResult.text);
      if (_isStale(runId)) return null;

      final testCasesJsonString = jsonEncode(excelResult.records.map((r) => r.toJson()).toList());

      // --- PHASE 1: GENERATOR & REVIEWER ---

      LlmVerifierResult verifierResult = const LlmVerifierResult();
      try {
        verifierResult = await aiService.runLlmVerifierPipeline(
          srsBible: srsBible,
          testCasesJson: testCasesJsonString,
          registrationContext: registrationBlock,
          rawSources: [
            docResult.text,
            excelResult.text,
            registrationBlock,
          ],
        );
      } catch (e, stack) {
        debugPrint('⚠️ Lỗi pipeline LLM Verifier: $e\n$stack');
        // Fallback gracefully if AI is unavailable
      }

      final verifiedFindings = verifierResult.verifiedFindings;
      final projectInfo = verifierResult.projectInfo;
      
      // Recompute stats using AI extracted features if available
      final aiFeatures = srsBible.features
          .map((f) => f['name'] ?? '')
          .where((n) => n.isNotEmpty)
          .toList();
          
      final effectiveStats = aiFeatures.isNotEmpty 
          ? computeCoverage(
              srsText: docResult.text,
              records: excelResult.records,
              unknownModules: unknown,
              featureList: aiFeatures,
            )
          : stats;

      final guarded = stripHallucinatedQuotes(verifierResult.generalReview, [
        docResult.text,
        excelResult.text,
        registrationBlock,
      ]);

      final initialBundle = ReviewBundle(
        markdown: '',
        stats: effectiveStats,
        checks: checks,
        records: excelResult.records,
        caseReviews: caseReviews,
        crossCheck: crossCheck,
        verifiedFindings: verifiedFindings,
        registrationContext: regContext,
        projectInfo: projectInfo,
        excelAvailability: excelResult.availability,
        docAvailability: docResult.availability,
      );

      var markdownReport = ReviewReportComposer.compose(
        initialBundle,
        excelPreamble: excelResult.preamble(),
        docPreamble: docResult.preamble(),
      );

      if (guarded.text.trim().isNotEmpty) {
        markdownReport = '$markdownReport\n### Đánh giá định tính chuyên sâu từ AI:\n${guarded.text}\n';
      }

      final bundle = ReviewBundle(
        markdown: markdownReport,
        stats: effectiveStats,
        checks: checks,
        records: excelResult.records,
        caseReviews: caseReviews,
        crossCheck: crossCheck,
        verifiedFindings: verifiedFindings,
        registrationContext: regContext,
        projectInfo: projectInfo,
        excelAvailability: excelResult.availability,
        docAvailability: docResult.availability,
      );

      if (_isStale(runId)) return null;
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: state.apiKey,
        provider: state.provider,
        modelName: state.modelName,
        skippedSheets: excelResult.skippedSheets,
        unknownModules: unknown,
        truncated: excelResult.truncated || docResult.truncated,
        runId: runId,
        reviewBundle: bundle,
      );
      return bundle;
    } catch (e) {
      if (_isStale(runId)) return null;
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: state.apiKey,
        provider: state.provider,
        modelName: state.modelName,
        runId: runId,
        reviewBundle: state.reviewBundle,
        error: 'Lỗi khi phân tích: $e',
      );
      return null;
    }
  }
}

final uploadControllerProvider =
    NotifierProvider<UploadController, UploadState>(() {
  return UploadController();
});
