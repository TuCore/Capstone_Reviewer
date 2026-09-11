import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

enum AIProvider { gemini, chatgpt, claude }

class AIService {
  final String apiKey;
  final AIProvider provider;

  AIService({required this.apiKey, required this.provider});

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
