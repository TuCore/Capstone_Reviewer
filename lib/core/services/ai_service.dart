import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

enum AIProvider { gemini, chatgpt, claude }

class AIService {
  final String apiKey;
  final AIProvider provider;

  AIService({required this.apiKey, required this.provider});

  /// Legacy method — trả về Markdown thuần (giữ cho backward-compatible)
  Future<String> reviewTestCases({
    required String srsContent,
    required String testCasesContent,
  }) async {
    final prompt = '''
Bạn là một chuyên gia kiểm thử phần mềm (QA/Tester) với nhiều năm kinh nghiệm, đang đóng vai trò là người phản biện (Reviewer) cho bộ tài liệu dự án.

Dưới đây là Tài liệu Đặc tả Yêu cầu (SRS):
---
$srsContent
---

Và đây là Bộ Test Cases đã được viết:
---
$testCasesContent
---

Yêu cầu:
Hãy phân tích và đối chiếu bộ Test Cases với tài liệu SRS để tìm ra các "Gap" (Lỗ hổng/thiếu sót).
Liệt kê chi tiết những trường hợp (scenarios) hoặc yêu cầu trong SRS mà Test Cases chưa bao phủ được.
Phân tích xem có Test Case nào viết sai logic hoặc không cần thiết không.
Đưa ra kết luận và báo cáo dưới dạng Markdown rõ ràng, dễ đọc.
''';

    switch (provider) {
      case AIProvider.gemini:
        return _callGemini(prompt);
      case AIProvider.chatgpt:
        return _callChatGPT(prompt);
      case AIProvider.claude:
        return _callClaude(prompt);
    }
  }

  /// New method — trả về Structured JSON cho Dashboard
  Future<String> reviewTestCasesStructured({
    required String srsContent,
    required String testCasesContent,
    required String proposalContent,
  }) async {
    final prompt = _buildStructuredPrompt(srsContent, testCasesContent, proposalContent);

    switch (provider) {
      case AIProvider.gemini:
        return _callGemini(prompt);
      case AIProvider.chatgpt:
        return _callChatGPT(prompt);
      case AIProvider.claude:
        return _callClaude(prompt);
    }
  }

  String _buildStructuredPrompt(
    String srsContent,
    String testCasesContent,
    String proposalContent,
  ) {
    return '''
Bạn là một chuyên gia kiểm thử phần mềm (QA/Tester) cấp cao với 15+ năm kinh nghiệm trong ngành, đang đóng vai trò là Giám khảo AI (AI Auditor) để thẩm định chất lượng kiểm thử của một đồ án tốt nghiệp (Capstone Project).

═══════════════════════════════════════════════════
PHIẾU ĐĂNG KÝ ĐỒ ÁN (Project Registration Form):
═══════════════════════════════════════════════════
$proposalContent

═══════════════════════════════════════════════════
TÀI LIỆU ĐẶC TẢ YÊU CẦU (SRS):
═══════════════════════════════════════════════════
$srsContent

═══════════════════════════════════════════════════
BỘ TEST CASES ĐÃ VIẾT:
═══════════════════════════════════════════════════
$testCasesContent

═══════════════════════════════════════════════════
YÊU CẦU PHÂN TÍCH:
═══════════════════════════════════════════════════

Hãy thực hiện phân tích TOÀN DIỆN và trả về KẾT QUẢ DUY NHẤT dạng JSON thuần (KHÔNG có markdown code fence, KHÔNG có giải thích thêm bên ngoài JSON).

BỘ TIÊU CHÍ ĐÁNH GIÁ (Rubric):
1. Độ bao phủ yêu cầu (Coverage - Trọng số 40%): Tỷ lệ % các yêu cầu trong SRS đã có ít nhất một Test Case tương ứng.
2. Độ sâu kiểm thử (Depth & Rigor - Trọng số 30%): Phân bổ tỷ lệ Happy Path vs Negative Cases vs Edge Cases. Cảnh báo nếu Happy Path > 80%.
3. Chất lượng mô tả (Specification Quality - Trọng số 20%): Đánh giá độ chi tiết của Preconditions, Test Steps, Test Data, Expected Results.
4. Tính truy vết (Traceability - Trọng số 10%): Khả năng liên kết chính xác giữa mã SRS (REQ_ID) và mã kiểm thử (TC_ID).

ĐIỂM TỔNG = Coverage_Score * 0.4 + Depth_Score * 0.3 + Quality_Score * 0.2 + Traceability_Score * 0.1
(Mỗi tiêu chí đều chấm trên thang 10)

XẾP LOẠI:
- 8.5–10.0: "Xuất sắc"
- 7.0–8.4: "Khá"
- 5.0–6.9: "Trung bình"
- Dưới 5.0: "Cần viết lại"

PHÁT HIỆN ANTI-PATTERN (Bắt buộc):
- VAGUE_EXPECTATION: Expected Results mơ hồ (ví dụ: "Hệ thống báo lỗi" mà không rõ lỗi gì)
- BOUNDARY_ABSENCE: Trường dữ liệu số/chuỗi mà không có kiểm thử giá trị biên (min, max, rỗng, âm)
- SECURITY_GAP: Ô nhập liệu quan trọng chưa kiểm thử SQL Injection, XSS, ký tự đặc biệt
- DUPLICATE_TEST: Test case trùng lặp hoặc quá giống nhau
- MISSING_PRECONDITION: Test case thiếu tiền điều kiện rõ ràng

THÔNG TIN PHIẾU ĐĂNG KÝ: Trích xuất tên đề tài, giảng viên hướng dẫn, thành viên nhóm từ Phiếu Đăng Ký. Đối chiếu phạm vi dự án trong Phiếu Đăng Ký với nội dung SRS.

JSON SCHEMA BẮT BUỘC (trả về đúng format này):
{
  "projectTitle": "Tên đề tài trích từ Phiếu Đăng Ký",
  "supervisor": "Tên GVHD trích từ Phiếu Đăng Ký",
  "teamMembers": "Danh sách thành viên nhóm",
  "scorecard": {
    "totalScore": 6.8,
    "grade": "Khá",
    "coverageRate": 70.0,
    "depthScore": 5.5,
    "qualityScore": 7.0,
    "traceabilityScore": 6.0,
    "summary": "Nhận xét tổng quan ngắn gọn về chất lượng bộ test cases...",
    "strengths": ["Điểm mạnh 1", "Điểm mạnh 2", "Điểm mạnh 3"],
    "weaknesses": ["Điểm yếu chí mạng 1", "Điểm yếu chí mạng 2", "Điểm yếu chí mạng 3"]
  },
  "metrics": {
    "totalRequirements": 15,
    "coveredRequirements": 10,
    "totalTestCases": 42,
    "happyPathCount": 35,
    "negativePathCount": 5,
    "edgeCaseCount": 2,
    "securityTestCount": 0
  },
  "rtm": [
    {
      "reqId": "REQ-01",
      "reqName": "Tên chức năng",
      "testCount": 5,
      "status": "PASS",
      "critique": "Nhận xét chi tiết cho chức năng này..."
    },
    {
      "reqId": "REQ-04",
      "reqName": "Thanh toán Online",
      "testCount": 0,
      "status": "MISSING",
      "critique": "Chưa có bất kỳ test case nào cho cổng thanh toán."
    }
  ],
  "antiPatterns": [
    {
      "type": "VAGUE_EXPECTATION",
      "testCaseId": "TC_03",
      "description": "Mô tả chi tiết lỗi anti-pattern...",
      "severity": "HIGH"
    }
  ],
  "missingSuggestions": [
    {
      "reqId": "REQ-04",
      "testCaseId": "TC_REQ_04_01",
      "title": "Tiêu đề test case gợi ý",
      "type": "Negative",
      "preconditions": "Tiền điều kiện cụ thể...",
      "testData": "Dữ liệu thử nghiệm mẫu...",
      "steps": "1. Bước 1...\\n2. Bước 2...\\n3. Bước 3...",
      "expected": "Kết quả kỳ vọng chi tiết, cụ thể..."
    }
  ]
}

QUAN TRỌNG:
- CHỈ trả về JSON thuần. KHÔNG bọc trong markdown code fence. KHÔNG có bất kỳ text nào trước hoặc sau JSON.
- Phải liệt kê TỪNG chức năng/yêu cầu trong SRS vào mảng "rtm", kể cả những chức năng đã có đủ test case.
- Phải gợi ý ít nhất 3-5 test cases bổ sung cho các REQ bị MISSING hoặc WARNING.
- Điểm phải hợp lý và phản ánh đúng chất lượng thực tế của bộ test cases.
- severity của antiPatterns: "HIGH" cho lỗi nghiêm trọng, "MEDIUM" cho lỗi trung bình, "LOW" cho lỗi nhẹ.
''';
  }

  // --- GEMINI LOGIC ---
  Future<String> _callGemini(String prompt) async {
    final modelName = await _getAvailableGeminiModel();
    print('Sử dụng Gemini model: $modelName');
    
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Không có kết quả trả về từ AI.';
    } catch (e) {
      throw Exception('Lỗi khi gọi Gemini API (đã dùng model $modelName): $e');
    }
  }

  Future<String> _getAvailableGeminiModel() async {
    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List<dynamic>;
        
        String? fallbackName;
        for (var model in models) {
          final supportedMethods = model['supportedGenerationMethods'] as List<dynamic>? ?? [];
          if (supportedMethods.contains('generateContent')) {
            String name = model['name'];
            if (name.startsWith('models/')) name = name.substring(7);
            
            if (name.contains('3.6-flash')) return name;
            fallbackName ??= name;
          }
        }
        if (fallbackName != null) return fallbackName;
      }
    } catch (e) {
      print('Lỗi khi tự động tìm model Gemini: $e');
    }
    return 'gemini-1.5-flash-latest';
  }

  // --- CHATGPT LOGIC ---
  Future<String> _callChatGPT(String prompt) async {
    final modelName = await _getAvailableChatGPTModel();
    print('Sử dụng ChatGPT model: $modelName');

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': modelName,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('OpenAI API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi OpenAI API (đã dùng model $modelName): $e');
    }
  }

  Future<String> _getAvailableChatGPTModel() async {
    try {
      final url = Uri.parse('https://api.openai.com/v1/models');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $apiKey',
      });
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['data'] as List<dynamic>;
        
        final modelNames = models.map((e) => e['id'] as String).toList();
        
        if (modelNames.contains('gpt-4o')) return 'gpt-4o';
        if (modelNames.contains('gpt-4o-mini')) return 'gpt-4o-mini';
        if (modelNames.contains('gpt-4-turbo')) return 'gpt-4-turbo';
        if (modelNames.contains('gpt-3.5-turbo')) return 'gpt-3.5-turbo';
        
        if (modelNames.isNotEmpty) return modelNames.first;
      }
    } catch (e) {
      print('Lỗi khi tự động tìm model ChatGPT: $e');
    }
    return 'gpt-4o-mini'; // fallback
  }

  // --- CLAUDE LOGIC ---
  Future<String> _callClaude(String prompt) async {
    final modelsToTry = [
      'claude-3-5-sonnet-20240620',
      'claude-3-haiku-20240307',
      'claude-3-opus-20240229'
    ];

    for (var modelName in modelsToTry) {
      print('Thử nghiệm Claude model: $modelName');
      try {
        final response = await http.post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
          body: jsonEncode({
            'model': modelName,
            'max_tokens': 4000,
            'messages': [
              {'role': 'user', 'content': prompt}
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          return data['content'][0]['text'];
        } else if (response.statusCode == 404 || response.statusCode == 403 || response.statusCode == 400) {
          final errorBody = response.body;
          if (errorBody.contains('not_found_error') || errorBody.contains('permission_error')) {
            print('Model $modelName thất bại, chuyển sang model dự phòng...');
            continue; 
          } else {
             throw Exception('Anthropic API Error: ${response.statusCode} - $errorBody');
          }
        } else {
          throw Exception('Anthropic API Error: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Lỗi với model $modelName: $e');
        if (modelName == modelsToTry.last) {
           throw Exception('Lỗi khi gọi Anthropic API (đã thử hết các model dự phòng): $e');
        }
      }
    }
    throw Exception('Không tìm thấy model Claude khả dụng.');
  }
}
