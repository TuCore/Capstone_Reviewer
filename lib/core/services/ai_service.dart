// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_key_format.dart';
import 'quote_guard.dart';
import '../extraction/project_bible.dart';

enum AIProvider { gemini, chatgpt, claude }


class AiCallException implements Exception {
  AiCallException(this.userMessage, {this.retryable = false});
  final String userMessage;
  final bool retryable;

  @override
  String toString() => userMessage;
}

class ProjectInfo {
  const ProjectInfo({
    this.topic = '',
    this.description = '',
    this.techStack = const [],
    this.features = const [],
  });

  final String topic;
  final String description;
  final List<String> techStack;
  final List<String> features;

  bool get isEmpty =>
      topic.isEmpty && description.isEmpty && techStack.isEmpty && features.isEmpty;

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'description': description,
        'tech_stack': techStack,
        'features': features,
      };

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      topic: json['topic']?.toString().trim() ?? '',
      description: json['description']?.toString().trim() ?? '',
      techStack: (json['tech_stack'] as List?)
              ?.map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList() ??
          const [],
      features: (json['features'] as List?)
              ?.map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList() ??
          const [],
    );
  }
}

class QualitativeHypothesis {
  const QualitativeHypothesis({
    required this.id,
    required this.module,
    required this.claim,
    this.targetRule = '',
    this.axis = '',
    this.quote = '',
  });

  final String id;
  final String module;
  final String claim;
  final String targetRule;
  final String axis;
  final String quote;

  Map<String, dynamic> toJson() => {
        'id': id,
        'module': module,
        'claim': claim,
        'target_rule': targetRule,
        'axis': axis,
        if (quote.isNotEmpty) 'quote': quote,
      };

  factory QualitativeHypothesis.fromJson(Map<String, dynamic> json) {
    return QualitativeHypothesis(
      id: json['id']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
      claim: json['claim']?.toString() ?? '',
      targetRule: json['target_rule']?.toString() ?? '',
      axis: json['axis']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
    );
  }
}

class GeneratorResult {
  const GeneratorResult({
    this.projectInfo = const ProjectInfo(),
    this.hypotheses = const [],
    this.generalReview = '',
  });

  final ProjectInfo projectInfo;
  final List<QualitativeHypothesis> hypotheses;
  final String generalReview;
}

class VerifiedFinding {
  const VerifiedFinding({
    required this.id,
    required this.module,
    required this.claim,
    required this.isVerified,
    required this.quote,
    this.explanation = '',
    this.axis = '',
    this.targetRule = '',
  });

  final String id;
  final String module;
  final String claim;
  final bool isVerified;
  final String quote;
  final String explanation;
  final String axis;
  final String targetRule;

  String toMarkdown() {
    final axisTag = axis.isNotEmpty ? ' *[$axis]*' : '';
    final exp = explanation.isNotEmpty ? '\n  - *Nhận định:* $explanation' : '';
    return '- **[$module]$axisTag $claim**\n  - *Trích dẫn chứng minh:* "$quote"$exp';
  }
}

class LlmVerifierResult extends Iterable<VerifiedFinding> {
  const LlmVerifierResult({
    this.projectInfo = const ProjectInfo(),
    this.verifiedFindings = const [],
    this.generalReview = '',
  });

  final ProjectInfo projectInfo;
  final List<VerifiedFinding> verifiedFindings;
  final String generalReview;

  @override
  Iterator<VerifiedFinding> get iterator => verifiedFindings.iterator;

  @override
  int get length => verifiedFindings.length;

  @override
  bool get isEmpty => verifiedFindings.isEmpty;

  @override
  bool get isNotEmpty => verifiedFindings.isNotEmpty;

  @override
  VerifiedFinding get first => verifiedFindings.first;

  @override
  VerifiedFinding get last => verifiedFindings.last;

  VerifiedFinding operator [](int index) => verifiedFindings[index];
}
class AIService {
  AIService({
    required this.apiKey,
    required this.provider,
    this.modelName,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String apiKey;
  final AIProvider provider;
  final String? modelName;
  final http.Client _client;

  static const connectTimeout = Duration(seconds: 10);
  static const readTimeout = Duration(seconds: 120);
  static const maxRetries = 4; // Tăng lên 4 lần thử lại khi gặp 503


  Future<String?> validateKey() async {
    final formatError = ApiKeyFormat.errorFor(provider, apiKey);
    if (formatError != null) return formatError;

    try {
      if (provider == AIProvider.gemini) {
        final effectiveModel = (modelName != null && modelName!.isNotEmpty) ? modelName : 'gemini-1.5-flash';
        final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$effectiveModel?key=$apiKey');
        final response = await _client.get(uri).timeout(const Duration(seconds: 5));
        if (response.statusCode == 404) {
          return 'Model $effectiveModel không tồn tại hoặc đã bị ngừng hỗ trợ.';
        }
        if (response.statusCode != 200) {
          return 'API Key không hợp lệ hoặc lỗi kết nối (Mã lỗi: ${response.statusCode}).';
        }
        return null; // OK
      } else if (provider == AIProvider.chatgpt) {
        final response = await _client.get(
          Uri.parse('https://api.openai.com/v1/models'),
          headers: {'Authorization': 'Bearer $apiKey'},
        ).timeout(const Duration(seconds: 5));
        if (response.statusCode != 200) {
          return 'API Key OpenAI không hợp lệ.';
        }
        return null;
      } else if (provider == AIProvider.claude) {
        final response = await _client.post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
          body: jsonEncode({
            'model': 'claude-3-5-sonnet-20240620',
            'max_tokens': 1,
            'messages': [{'role': 'user', 'content': 'hi'}]
          }),
        ).timeout(const Duration(seconds: 5));
        if (response.statusCode != 200 && response.statusCode != 400) {
           return 'API Key Claude không hợp lệ.';
        }
        return null;
      }
    } catch (_) {
      return 'Lỗi kết nối mạng khi kiểm tra API Key.';
    }
    return 'Lỗi không xác định.';
  }

  static Future<List<String>?> fetchModels(String apiKey, AIProvider provider) async {
    if (apiKey.isEmpty) return null;
    
    try {
      if (provider == AIProvider.gemini) {
        final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
        final response = await http.get(uri).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final models = data['models'] as List<dynamic>?;
          if (models != null) {
            final List<String> result = [];
            for (var m in models) {
              final name = m['name']?.toString() ?? '';
              // name has format "models/gemini-pro"
              if (name.startsWith('models/gemini-') && name.contains('flash')) {
                 result.add(name.replaceFirst('models/', ''));
              }
            }
            if (result.isNotEmpty) {
              // Add some well-known models if missing just in case
              if (!result.contains('gemini-1.5-flash')) result.add('gemini-1.5-flash');
              return result.toSet().toList(); // Unique
            }
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }


  Future<String> dispatchPrompt(String prompt) {
    return _withRetry(() => _dispatch(prompt));
  }

  Future<String> _dispatch(String prompt) {
    switch (provider) {
      case AIProvider.gemini:
        return _callGemini(prompt);
      case AIProvider.chatgpt:
        return _callChatGPT(prompt);
      case AIProvider.claude:
        return _callClaude(prompt);
    }
  }

  Future<T> _withRetry<T>(Future<T> Function() call) async {
    var attempt = 0;
    while (true) {
      try {
        return await call();
      } on AiCallException catch (e) {
        if (!e.retryable || attempt >= maxRetries) rethrow;
      } on TimeoutException {
        if (attempt >= maxRetries) {
          throw AiCallException('Lỗi mạng: hết thời gian chờ.');
        }
      }
      attempt++;
      // Thêm jitter và tăng thời gian delay (3s, 6s, 12s, 24s) để server phục hồi
      await Future<void>.delayed(Duration(seconds: 3 * (1 << (attempt - 1))));
    }
  }

  Future<String> _callGemini(String prompt) async {
    final effectiveModel = (modelName != null && modelName!.isNotEmpty) ? modelName : 'gemini-1.5-flash';
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$effectiveModel:generateContent',
    );
    final response = await _send(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
    if (text is String && text.isNotEmpty) return text;
    throw AiCallException('Lỗi parse: Gemini không trả nội dung.');
  }


  Future<String> _callChatGPT(String prompt) async {
    final response = await _send(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
      }),
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final text = data['choices']?[0]?['message']?['content'];
    if (text is String && text.isNotEmpty) return text;
    throw AiCallException('Lỗi parse: OpenAI không trả nội dung.');
  }

  Future<String> _callClaude(String prompt) async {
    final response = await _send(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-5-sonnet-20240620',
        'max_tokens': 4000,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
      }),
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final text = data['content']?[0]?['text'];
    if (text is String && text.isNotEmpty) return text;
    throw AiCallException('Lỗi parse: Claude không trả nội dung.');
  }

  Future<http.Response> _send(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) async {
    http.Response response;
    try {
      response = await _client
          .post(uri, headers: headers, body: body)
          .timeout(readTimeout);
    } on TimeoutException {
      throw AiCallException('Lỗi mạng: hết thời gian chờ.', retryable: true);
    } catch (e) {
      throw AiCallException(
        'Lỗi mạng: không kết nối được.',
        retryable: true,
      );
    }

    if (response.statusCode == 200) return response;
    throw _mapStatus(response.statusCode, response.body);
  }

  AiCallException _mapStatus(int code, String body) {
    if (code == 401 || code == 403) {
      return AiCallException('Lỗi xác thực: API key bị từ chối.');
    }
    if (code == 404) {
      return AiCallException(
        'Không tìm thấy model Gemini (404). Model cũ đã tắt.',
      );
    }
    if (code == 429) {
      return AiCallException('Lỗi hạn mức: quá nhiều yêu cầu (Vui lòng đợi 1 phút).', retryable: false);
    }
    if (code >= 500) {
      return AiCallException('Lỗi mạng: máy chủ AI lỗi $code.', retryable: true);
    }
    if (body.toLowerCase().contains('invalid') &&
        body.toLowerCase().contains('key')) {
      return AiCallException('Lỗi xác thực: API key không hợp lệ.');
    }
    return AiCallException('Lỗi máy chủ AI: HTTP $code.');
  }


  /// Pass 1 (Generator): Đề xuất danh sách 5-8 nghi vấn trên 6 trục và trích xuất Metadata đồ án
  Future<GeneratorResult> generateHypothesesAndMetadata({
    required ProjectBible srsBible,
    required String testCasesJson,
    String? registrationContext,
  }) async {
    print('\n' + '=' * 80);
    print('🤖 [PASS 1: GENERATOR] Đang phân tích 3 nguồn tài liệu theo 6 trục kiểm thử tổng quát...');
    print('=' * 80);

    final prompt = _promptGenerator(
      srsBible: srsBible,
      testCasesJson: testCasesJson,
      registrationContext: registrationContext,
    );
    final raw = await _withRetry(() => _dispatch(prompt));
    final genResult = parseGeneratorResultJson(raw);

    if (genResult.projectInfo.topic.isNotEmpty) {
      print('>> [METADATA ĐỒ ÁN ĐÃ NHẬN DIỆN]:');
      print('   - Tên đề tài: ${genResult.projectInfo.topic}');
      if (genResult.projectInfo.description.isNotEmpty) {
        print('   - Mô tả/Bối cảnh: ${genResult.projectInfo.description}');
      }
      if (genResult.projectInfo.techStack.isNotEmpty) {
        print('   - Tech Stack: ${genResult.projectInfo.techStack.join(", ")}');
      }
    }

    print('>> [GENERATOR ĐÃ TẠO RA ${genResult.hypotheses.length} GIẢ THUYẾT 6 TRỤC]:');
    for (var i = 0; i < genResult.hypotheses.length; i++) {
      final h = genResult.hypotheses[i];
      final axisTag = h.axis.isNotEmpty ? '[${h.axis}] ' : '';
      print('   [#${i + 1}] $axisTag[${h.module}] ${h.claim} (Rule: ${h.targetRule})');
    }
    return genResult;
  }

  Future<List<QualitativeHypothesis>> generateHypotheses({
    required ProjectBible srsBible,
    required String testCasesJson,
    String? registrationContext,
  }) async {
    final result = await generateHypothesesAndMetadata(
      srsBible: srsBible,
      testCasesJson: testCasesJson,
      registrationContext: registrationContext,
    );
    return result.hypotheses;
  }

  /// Pass 2 (Verifier): Thẩm định nhị phân và lọc bằng chứng
  Future<List<VerifiedFinding>> verifyHypotheses({
    required List<QualitativeHypothesis> hypotheses,
    required String sourceContent,
    required List<String> rawSources, // keep this signature for cross-checking if needed
  }) async {
    if (hypotheses.isEmpty) {
      print('>> [VERIFIER]: Không có giả thuyết nào từ Generator để thẩm định.');
      return const [];
    }

    print('\n' + '=' * 80);
    print('⚖️ [PASS 2: VERIFIER] Thẩm phán AI độc lập đang đối soát từng giả thuyết với tài liệu gốc...');
    print('=' * 80);

    final prompt = _promptVerifier(hypotheses: hypotheses, sourceContent: sourceContent);
    final raw = await _withRetry(() => _dispatch(prompt));
    final rawVerdicts = parseVerdictsJson(raw);

    print('>> [VERIFIER TRẢ VỀ ${rawVerdicts.length} PHÁN QUYẾT]:');
    for (final v in rawVerdicts) {
      final id = v['id']?.toString() ?? '';
      final isVerified = v['is_verified'] == true || v['is_verified']?.toString().toLowerCase() == 'true';
      final quote = (v['quote']?.toString() ?? '').trim();
      final explanation = v['explanation']?.toString() ?? '';
      final statusIcon = isVerified ? '🟢 TRUE (Hợp lệ)' : '🔴 FALSE (Bác bỏ/Ảo giác)';

      print('   • Ca #$id -> $statusIcon');
      if (quote.isNotEmpty) print('     - Quote: "$quote"');
      if (explanation.isNotEmpty) print('     - Lý do: $explanation');
    }

    return filterVerifiedFindings(
      hypotheses: hypotheses,
      rawVerdicts: rawVerdicts,
      sourceTexts: rawSources,
    );
  }

  Future<LlmVerifierResult> runLlmVerifierPipeline({
    required ProjectBible srsBible,
    required String testCasesJson,
    String? registrationContext,
    required List<String> rawSources, // keep for verifier source code highlighting if needed
  }) async {
    final genResult = await generateHypothesesAndMetadata(
      srsBible: srsBible,
      testCasesJson: testCasesJson,
      registrationContext: registrationContext,
    );
    final combinedSources = [
      jsonEncode(srsBible.toJson()),
      testCasesJson,
      ...?registrationContext == null ? null : [registrationContext],
    ].join('\n\n');

    final verified = await verifyHypotheses(
      hypotheses: genResult.hypotheses,
      sourceContent: combinedSources,
      rawSources: rawSources,
    );

    print('\n' + '=' * 80);
    print('🏁 [TỔNG KẾT PIPELINE LLM-AS-A-VERIFIER]:');
    print('   - Generator đề xuất: ${genResult.hypotheses.length} kịch bản');
    print('   - Vượt qua Verifier & Code Gatekeeper: ${verified.length} kịch bản');
    print('   - Bị loại bỏ do không có bằng chứng / ảo giác: ${genResult.hypotheses.length - verified.length} kịch bản');
    print('=' * 80 + '\n');

    return LlmVerifierResult(
      projectInfo: genResult.projectInfo,
      verifiedFindings: verified,
      generalReview: genResult.generalReview,
    );
  }

  String _promptGenerator({
    required ProjectBible srsBible,
    required String testCasesJson,
    String? registrationContext,
  }) {
    final srsBibleJson = jsonEncode(srsBible.toJson());
    return '''
Bạn là chuyên gia phân tích và thẩm định chất lượng kiểm thử phần mềm (Senior QA Lead / Auditor).
Nhiệm vụ: Phân tích 3 nguồn tài liệu để thực hiện 2 nhiệm vụ:

1. TRÍCH XUẤT THÔNG TIN ĐỒ ÁN (PROJECT METADATA):
   - "topic": Nhận diện chính xác Tên đề tài đồ án (kết hợp cả Tên tiếng Anh, Tiếng Việt và Mã đề tài viết tắt nếu có).
   - "description": Tóm tắt súc tích bối cảnh thực tế và mục tiêu chính của đồ án (tránh nuốt danh sách giáo viên/sinh viên).
   - "tech_stack": Liệt kê các công nghệ, framework, CSDL, Cloud/Hosting được nhắc đến trong các tài liệu.
   - "features": Liệt kê danh sách các chức năng chính / Use Case. Nếu đã có trong SRS BIBLE JSON thì lấy từ đó.

2. PHÂN TÍCH VÀ ĐỀ XUẤT NGHI VẤN / GIẢ THUYẾT VỀ LỖI NGHIÊM TRỌNG TRÊN 6 TRỤC:
   - Trục 1 (Tech Mismatch): Mâu thuẫn công nghệ giữa các tài liệu.
   - Trục 2 (Feature Omission): Tính năng có trong SRS BIBLE nhưng bị bỏ quên 0 test case trong Excel.
   - Trục 3 (RBAC): Vi phạm phân quyền, Expected Result cho phép Actor vượt quyền hạn.
   - Trục 4 (Copy-Paste): Nhận diện dấu hiệu copy dán, trùng lặp.
   - Trục 5 (Logic Violation): Expected Result cho phép hành vi vi phạm Business Rules nêu trong SRS BIBLE.
   - Trục 6 (Wording): Bước test mơ hồ, thiếu Test Data.

CẢNH BÁO QUAN TRỌNG (CHỐNG ẢO GIÁC - HALLUCINATION):
- CHỈ ĐƯỢC PHÉP tạo nghi vấn dựa trên dữ liệu có thật trong <<TESTCASES_JSON>> và <<SRS_BIBLE_JSON>>.
- TUYỆT ĐỐI KHÔNG TỰ BỊA ĐẶT (INVENT) test case, chức năng, hoặc Expected Result không có trong tài liệu.
- Bất kỳ trích dẫn nào trong "quote" PHẢI LÀ EXACT QUOTE (copy y nguyên) từ tài liệu đầu vào.
- Nếu bạn không tìm thấy lỗi nghiêm trọng nào, hãy trả về mảng "findings": [] trống. Đừng cố gắng bịa ra lỗi!
- Mỗi nghi vấn phải chỉ rõ module/vị trí và nội dung mâu thuẫn.

<<SRS_BIBLE_JSON>>
$srsBibleJson
<</SRS_BIBLE_JSON>>

<<TESTCASES_JSON>>
$testCasesJson
<</TESTCASES_JSON>>

<<CONTEXT>>
${registrationContext ?? '(không có phiếu đăng ký)'}
<</CONTEXT>>

BẮT BUỘC TRẢ VỀ ĐỊNH DẠNG JSON DUY NHẤT:
{
  "project_info": {
    "topic": "Tên đề tài đầy đủ",
    "description": "Tóm tắt bối cảnh và mục tiêu đồ án",
    "tech_stack": ["Công nghệ 1", "Công nghệ 2"],
    "features": ["Chức năng 1", "Chức năng 2"]
  },
  "general_review": "Đánh giá chung về chất lượng viết test case (ngữ pháp, trình bày, độ bao phủ, thiếu sót chung) dưới dạng Markdown string (3-4 câu).",
  "findings": [
    {
      "id": "1",
      "axis": "Tech Mismatch",
      "module": "Tên module / chức năng",
      "claim": "Mô tả nghi vấn chi tiết",
      "target_rule": "Tech Mismatch / Feature Omission / RBAC / Copy-Paste / Logic Violation / Wording",
      "quote": "đoạn trích dẫn sơ bộ (nếu có)"
    }
  ]
}
''';
  }

  String _promptVerifier({
    required List<QualitativeHypothesis> hypotheses,
    required String sourceContent,
  }) {
    final hypJson = jsonEncode(hypotheses.map((h) => h.toJson()).toList());
    return '''
Bạn là chuyên gia kiểm định dữ liệu độc lập (LLM-as-a-Verifier).
Nhiệm vụ: Thẩm định nhị phân từng nhận định/nghi vấn sau đây dựa trên tài liệu gốc.
Với mỗi nhận định:
- Nếu ĐÚNG và có bằng chứng rõ ràng trong tài liệu: đặt "is_verified": true và trích dẫn NGUYÊN VĂN (EXACT QUOTE) đoạn văn bản trong tài liệu vào "quote". TUYỆT ĐỐI KHÔNG TỰ BỊA ĐẶT HAY DIỄN GIẢI LẠI TRÍCH DẪN!
- Nếu SAI hoặc KHÔNG CÓ BẰNG CHỨNG / ẢO GIÁC: đặt "is_verified": false và để "quote": "".

<<TAI_LIEU_GOC>>
$sourceContent
<</TAI_LIEU_GOC>>

<<DANH_SACH_NGHI_VAN>>
$hypJson
<</DANH_SACH_NGHI_VAN>>

BẮT BUỘC TRẢ VỀ ĐỊNH DẠNG JSON DUY NHẤT:
{
  "verdicts": [
    {
      "id": "1",
      "is_verified": true,
      "quote": "đoạn trích dẫn nguyên văn",
      "explanation": "giải thích ngắn gọn"
    }
  ]
}
''';
  }

  static GeneratorResult parseGeneratorResultJson(String raw) {
    try {
      final clean = _extractJsonBlock(raw);
      final decoded = jsonDecode(clean);
      if (decoded is! Map) {
        if (decoded is List) {
          final list = decoded
              .whereType<Map<String, dynamic>>()
              .map(QualitativeHypothesis.fromJson)
              .toList();
          return GeneratorResult(hypotheses: list);
        }
        return const GeneratorResult();
      }

      final infoMap = decoded['project_info'] as Map<String, dynamic>?;
      final info = infoMap != null ? ProjectInfo.fromJson(infoMap) : const ProjectInfo();
      final generalReview = decoded['general_review']?.toString() ?? '';

      final list = decoded['findings'] as List?;
      final hypotheses = list != null
          ? list
              .whereType<Map<String, dynamic>>()
              .map(QualitativeHypothesis.fromJson)
              .toList()
          : <QualitativeHypothesis>[];

      return GeneratorResult(
        projectInfo: info, 
        hypotheses: hypotheses,
        generalReview: generalReview,
      );
    } catch (_) {
      return const GeneratorResult();
    }
  }

  static List<QualitativeHypothesis> parseHypothesesJson(String raw) {
    return parseGeneratorResultJson(raw).hypotheses;
  }

  static List<Map<String, dynamic>> parseVerdictsJson(String raw) {
    try {
      final clean = _extractJsonBlock(raw);
      final decoded = jsonDecode(clean);
      final list = decoded is Map ? (decoded['verdicts'] as List?) : (decoded is List ? decoded : null);
      if (list == null) return const [];
      return list.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return const [];
    }
  }

  /// Bộ lọc Gatekeeper thuần code Dart: Chỉ giữ lại các nhận định có quote thực sự tồn tại trong tài liệu gốc
  static List<VerifiedFinding> filterVerifiedFindings({
    required List<QualitativeHypothesis> hypotheses,
    required List<Map<String, dynamic>> rawVerdicts,
    required List<String> sourceTexts,
  }) {
    print('\n' + '-' * 80);
    print('🛡️ [PASS 3: CODE GATEKEEPER] Code Dart đang đối khớp trích dẫn với tài liệu gốc...');
    print('-' * 80);

    final haystack = sourceTexts.join('\n').toLowerCase();
    final hypMap = {for (final h in hypotheses) h.id: h};
    final verified = <VerifiedFinding>[];

    for (final v in rawVerdicts) {
      final id = v['id']?.toString() ?? '';
      final isVerified = v['is_verified'] == true || v['is_verified']?.toString().toLowerCase() == 'true';
      final quote = (v['quote']?.toString() ?? '').trim();
      final explanation = v['explanation']?.toString() ?? '';

      final hyp = hypMap[id];
      if (hyp == null) continue;

      if (!isVerified) {
        print('   ❌ Ca #$id [${hyp.module}]: Bị Verifier bác bỏ do thiếu căn cứ trong SRS.');
        continue;
      }

      if (quote.isEmpty) {
        print('   🚫 Ca #$id [${hyp.module}]: Bị loại do không có câu trích dẫn chứng minh.');
        continue;
      }

      if (containsLoose(haystack, quote)) {
        print('   ✅ Ca #$id [${hyp.module}]: Trích dẫn khớp thật trong tài liệu -> CHẤP THUẬN.');
        verified.add(VerifiedFinding(
          id: id,
          module: hyp.module,
          claim: hyp.claim,
          isVerified: true,
          quote: quote,
          explanation: explanation,
          axis: hyp.axis.isNotEmpty ? hyp.axis : hyp.targetRule,
          targetRule: hyp.targetRule,
        ));
      } else {
        print('   🚫 Ca #$id [${hyp.module}]: ẢO GIÁC! Câu trích dẫn "$quote" KHÔNG HỀ CÓ trong tài liệu -> LOẠI BỎ NGAY.');
      }
    }

    return verified;
  }

  static String _extractJsonBlock(String text) {
    var s = text.trim();
    if (s.startsWith('```')) {
      final start = s.indexOf('{');
      final end = s.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        return s.substring(start, end + 1);
      }
      final arrStart = s.indexOf('[');
      final arrEnd = s.lastIndexOf(']');
      if (arrStart != -1 && arrEnd != -1 && arrEnd > arrStart) {
        return s.substring(arrStart, arrEnd + 1);
      }
    }
    final firstBrace = s.indexOf('{');
    final lastBrace = s.lastIndexOf('}');
    if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
      return s.substring(firstBrace, lastBrace + 1);
    }
    return s;
  }
}
