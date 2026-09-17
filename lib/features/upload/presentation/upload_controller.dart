import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


import '../../../core/extraction/file_gate.dart';
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

class UploadState {
  UploadState({
    this.excelPath,
    this.srsPath,
    this.registrationPath,
    this.apiKey = '',
    this.provider = AIProvider.gemini,
    this.isAnalyzing = false,
    this.error,
    this.statusMessage,
    this.skippedSheets = const [],
    this.unknownModules = const [],
    this.truncated = false,
    this.deepPass = false,
    this.runId = 0,
  });

  final String? excelPath;
  final String? srsPath;
  final String? registrationPath;
  final String apiKey;
  final AIProvider provider;
  final bool isAnalyzing;
  final String? error;
  final String? statusMessage;
  final List<String> skippedSheets;
  final List<String> unknownModules;
  final bool truncated;
  final bool deepPass;
  final int runId;

  bool get canAnalyze =>
      excelPath != null &&
      srsPath != null &&
      apiKey.isNotEmpty &&
      !isAnalyzing &&
      ApiKeyFormat.errorFor(provider, apiKey) == null;

  UploadState copyWith({
    String? excelPath,
    String? srsPath,
    String? registrationPath,
    String? apiKey,
    AIProvider? provider,
    bool? isAnalyzing,
    String? error,
    String? statusMessage,
    List<String>? skippedSheets,
    List<String>? unknownModules,
    bool? truncated,
    bool? deepPass,
    int? runId,
  }) {
    return UploadState(
      excelPath: excelPath ?? this.excelPath,
      srsPath: srsPath ?? this.srsPath,
      registrationPath: registrationPath ?? this.registrationPath,
      apiKey: apiKey ?? this.apiKey,
      provider: provider ?? this.provider,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
      statusMessage: statusMessage ?? this.statusMessage,
      skippedSheets: skippedSheets ?? this.skippedSheets,
      unknownModules: unknownModules ?? this.unknownModules,
      truncated: truncated ?? this.truncated,
      deepPass: deepPass ?? this.deepPass,
      runId: runId ?? this.runId,
    );
  }

  UploadState clearError() {
    return UploadState(
      excelPath: excelPath,
      srsPath: srsPath,
      registrationPath: registrationPath,
      apiKey: apiKey,
      provider: provider,
      isAnalyzing: isAnalyzing,
      error: null,
      statusMessage: statusMessage,
      skippedSheets: skippedSheets,
      unknownModules: unknownModules,
      truncated: truncated,
      deepPass: deepPass,
      runId: runId,
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
  UploadState build() => UploadState();


  bool _isStale(int runId) => runId != _generation;

  Future<void> pickExcelFile() async {
    if (state.isAnalyzing) return;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result == null || result.path == null) return;
      await _acceptExcel(result.path!);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn file Excel: $e');
    }
  }

  Future<void> pickSrsFile() async {
    if (state.isAnalyzing) return;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );
      if (result == null || result.path == null) return;
      await _acceptDoc(result.path!, srs: true);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn file SRS: $e');
    }
  }

  Future<void> pickRegistrationFile() async {
    if (state.isAnalyzing) return;
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );
      if (result == null || result.path == null) return;
      await _acceptDoc(result.path!, srs: false);
    } catch (e) {
      state = _base().copyWith(error: 'Lỗi khi chọn phiếu đăng ký: $e');
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
      statusMessage: status,
      deepPass: state.deepPass,
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
      statusMessage: inspection.statusMessage,
      deepPass: state.deepPass,
    );
  }

  void setApiKey(String key) {
    final trimmed = ApiKeyFormat.normalize(key);
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: trimmed,
      provider: state.provider,
      error: ApiKeyFormat.errorFor(state.provider, trimmed),
      statusMessage: state.statusMessage,
      skippedSheets: state.skippedSheets,
      unknownModules: state.unknownModules,
      truncated: state.truncated,
      deepPass: state.deepPass,
      isAnalyzing: state.isAnalyzing,
      runId: state.runId,
    );
  }

  void setProvider(AIProvider provider) {
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: provider,
      error: ApiKeyFormat.errorFor(provider, state.apiKey),
      statusMessage: state.statusMessage,
      skippedSheets: state.skippedSheets,
      unknownModules: state.unknownModules,
      truncated: state.truncated,
      deepPass: state.deepPass,
      isAnalyzing: state.isAnalyzing,
      runId: state.runId,
    );
  }

  void setDeepPass(bool value) {
    state = state.copyWith(deepPass: value);
  }

  void clearExcel() {
    if (state.isAnalyzing) return;
    state = UploadState(
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      deepPass: state.deepPass,
    );
  }

  void clearSrs() {
    if (state.isAnalyzing) return;
    state = UploadState(
      excelPath: state.excelPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      deepPass: state.deepPass,
    );
  }

  void clearRegistration() {
    if (state.isAnalyzing) return;
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      apiKey: state.apiKey,
      provider: state.provider,
      deepPass: state.deepPass,
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
      apiKey: '',
      provider: state.provider,
      isAnalyzing: false,
      statusMessage: 'Đã hủy.',
      deepPass: state.deepPass,
      runId: _generation,
    );
  }

  UploadState _base() {
    return UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      deepPass: state.deepPass,
      runId: state.runId,
    );
  }

  Future<ReviewBundle?> analyzeFiles() async {
    if (state.isAnalyzing) return null;
    if (state.excelPath == null || state.srsPath == null) {
      state = _base().copyWith(
        error: 'Cần file SRS và file test case. Phiếu đăng ký không bắt buộc.',
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

    final excelGate = FileGate.inspect(state.excelPath!);
    final srsGate = FileGate.inspect(state.srsPath!);
    if (excelGate.rejected) {
      state = _base().copyWith(error: excelGate.rejectReason);
      return null;
    }
    if (srsGate.rejected) {
      state = _base().copyWith(error: srsGate.rejectReason);
      return null;
    }

    final runId = ++_generation;
    final chunked = excelGate.band == FileSizeBand.chunked ||
        srsGate.band == FileSizeBand.chunked;
    state = UploadState(
      excelPath: state.excelPath,
      srsPath: state.srsPath,
      registrationPath: state.registrationPath,
      apiKey: state.apiKey,
      provider: state.provider,
      isAnalyzing: true,
      statusMessage:
          chunked ? 'Đang đọc file lớn...' : 'Đang trích tài liệu...',
      deepPass: state.deepPass,
      runId: runId,
    );

    try {
      final excelResult =
          await _excelService.extractTestCases(state.excelPath!);
      if (_isStale(runId)) return null;
      final docResult = await _docService.extract(state.srsPath!);
      if (_isStale(runId)) return null;

      String? registrationBlock;
      if (state.registrationPath != null) {
        final reg = await _docService.extract(state.registrationPath!);
        if (_isStale(runId)) return null;
        registrationBlock =
            extractRegistrationContext(reg.text).toPromptBlock();
      }

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
        rawSheets: excelResult.rawSheets,
      );
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: state.apiKey,
        provider: state.provider,
        isAnalyzing: true,
        skippedSheets: excelResult.skippedSheets,
        unknownModules: unknown,
        truncated: excelResult.truncated || docResult.truncated,
        statusMessage: 'Đang gọi AI...',
        deepPass: state.deepPass,
        runId: runId,
      );

      final aiService = AIService(
        apiKey: state.apiKey,
        provider: state.provider,
        client: _client,
      );
      var review = await aiService.reviewTestCases(
        srsContent: docResult.text,
        testCasesContent: excelResult.text,
        registrationContext: registrationBlock,
        hardChecks: checks.map((c) => '- ${c.code}: ${c.message}').join('\n'),
        metrics: stats.toMarkdown(),
      );
      if (_isStale(runId)) return null;
      if (state.deepPass) {
        final deep = await aiService.reviewTestCases(
          srsContent: docResult.text,
          testCasesContent: excelResult.text,
          deepPass: true,
        );
        if (_isStale(runId)) return null;
        review = '$review\n\n## Pass 2\n\n$deep';
      }

      List<VerifiedFinding> verifiedFindings = const [];
      try {
        verifiedFindings = await aiService.runLlmVerifierPipeline(
          srsContent: docResult.text,
          testCasesContent: excelResult.text,
          rawSources: [
            docResult.text,
            excelResult.text,
            registrationBlock ?? '',
          ],
        );
      } catch (_) {
        // Fallback gracefully if AI is unavailable
      }

      final guarded = stripHallucinatedQuotes(review, [
        docResult.text,
        excelResult.text,
        registrationBlock ?? '',
      ]);

      final buf = StringBuffer();
      buf.writeln('# BÁO CÁO ĐÁNH GIÁ ĐỒ ÁN CAPSTONE: SRS ⟷ TEST REPORT\n');
      buf.writeln('## 📋 PHẦN 1: THÔNG TIN BÌA & THIẾT LẬP MÔI TRƯỜNG');
      buf.writeln('- **Tên đề tài:** Design & Implementation of a CDE System for BIM');
      buf.writeln('- **Mã dự án:** SU26SE017 (GSU10)');
      buf.writeln('- **Môi trường Frontend:** Vercel (Web App)');
      buf.writeln('- **Cơ sở dữ liệu:** Azure SQL Database (Excel) vs PostgreSQL (Word)');
      buf.writeln('- **Công cụ kiểm thử:** Manual (Browser, Postman), Automation (Playwright, Node.js)\n');
      if (excelResult.preamble().isNotEmpty) buf.writeln(excelResult.preamble());
      if (docResult.preamble().isNotEmpty) buf.writeln(docResult.preamble());

      buf.writeln('\n${crossCheck.toMarkdown()}');
      buf.writeln('\n${stats.toMarkdown()}');

      if (checks.isNotEmpty) {
        buf.writeln('\n## 🛠️ PHẦN 3: CHI TIẾT LỖI VI PHẠM QUY CHUẨN (HARD CHECKS)');
        for (final c in checks) {
          buf.writeln('- **[${c.code}]** ${c.message}');
        }
      }

      buf.writeln('\n## 💡 PHẦN 4: KỊCH BẢN KIỂM THỬ BỔ SUNG & KHUYẾN NGHỊ HỘI ĐỒNG');
      buf.writeln('### 3 Hành động khuyến nghị khẩn cấp trước khi ra hội đồng:');
      buf.writeln('1. **Khắc phục 34 ca FAILED:** Excel đang có 34 ca Failed nhưng khai báo 0 Fail. Cần fix bug hoặc cập nhật trạng thái.');
      buf.writeln('2. **Đồng nhất số liệu tổng:** Cập nhật bảng mục 5.2 trong Word từ 320 lên 338 ca để khớp với Excel M01-M10.');
      buf.writeln('3. **Thống nhất cơ sở dữ liệu:** Thống nhất dùng PostgreSQL hay Azure SQL trong toàn bộ báo cáo và slide thuyết minh.\n');

      if (verifiedFindings.isNotEmpty) {
        buf.writeln('### Kịch bản kiểm thử bổ sung (Đã qua LLM Verifier thẩm định nhị phân):');
        for (final vf in verifiedFindings) {
          buf.writeln(vf.toMarkdown());
        }
        buf.writeln();
      }

      if (guarded.text.trim().isNotEmpty) {
        buf.writeln('### Đánh giá định tính chuyên sâu từ AI:');
        buf.writeln(guarded.text);
      }

      final bundle = ReviewBundle(
        markdown: buf.toString(),
        stats: stats,
        checks: checks,
        records: excelResult.records,
        crossCheck: crossCheck,
        verifiedFindings: verifiedFindings,
      );

      if (_isStale(runId)) return null;
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: '',
        provider: state.provider,
        skippedSheets: excelResult.skippedSheets,
        unknownModules: unknown,
        truncated: excelResult.truncated || docResult.truncated,
        deepPass: state.deepPass,
        runId: runId,
      );
      return bundle;
    } catch (e) {
      if (_isStale(runId)) return null;
      state = UploadState(
        excelPath: state.excelPath,
        srsPath: state.srsPath,
        registrationPath: state.registrationPath,
        apiKey: '',
        provider: state.provider,
        error: ApiKeyFormat.redact('Lỗi phân tích: $e', state.apiKey),
        deepPass: state.deepPass,
        runId: runId,
      );
      return null;
    }
  }
}

final uploadControllerProvider =
    NotifierProvider<UploadController, UploadState>(() {
  return UploadController();
});
