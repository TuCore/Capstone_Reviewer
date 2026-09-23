import 'dart:convert';
import 'package:capstone_reviewer/core/extraction/project_bible.dart';
import 'package:capstone_reviewer/core/services/ai_service.dart';

class ContextExtractor {
  const ContextExtractor(this._aiService);

  final AIService _aiService;

  int get _chunkLimit {
    switch (_aiService.provider) {
      case AIProvider.gemini:
        return 2500000; // Gemini Flash 1.5 supports 1M tokens (~3.5M chars)
      case AIProvider.claude:
        return 600000; // Claude 3.5 Sonnet supports 200K tokens (~750K chars)
      case AIProvider.chatgpt:
        return 300000; // GPT-4o-mini supports 128K tokens (~450K chars)
    }
  }

  Future<ProjectBible> extractFromSrs(String srsContent) async {
    final chunks = _splitIntoChunks(srsContent, _chunkLimit);
    var finalBible = const ProjectBible();

    for (final chunk in chunks) {
      if (chunk.trim().isEmpty) continue;
      
      final prompt = '''
Bạn là chuyên gia phân tích tài liệu Đặc tả Yêu cầu Phần mềm (SRS).
Nhiệm vụ của bạn là trích xuất các thông tin sau từ đoạn văn bản được cung cấp và trả về DUY NHẤT một đối tượng JSON hợp lệ, KHÔNG chứa markdown (không chứa ```json).

YÊU CẦU ĐẦU RA JSON CÓ ĐỊNH DẠNG SAU:
{
  "actors": ["Tên Actor 1", "Tên Actor 2"],
  "features": [
    {
      "id": "Mã feature (ví dụ F01, FR01, hoặc để trống nếu không có)",
      "name": "Tên tính năng",
      "description": "Mô tả ngắn gọn tính năng"
    }
  ],
  "business_rules": [
    "Quy tắc nghiệp vụ 1",
    "Quy tắc nghiệp vụ 2"
  ]
}

ĐOẠN VĂN BẢN CẦN TRÍCH XUẤT:
$chunk
''';

      try {
        final response = await _aiService.dispatchPrompt(prompt);
        final cleanJson = _extractJson(response);
        final Map<String, dynamic> data = jsonDecode(cleanJson);
        final chunkBible = ProjectBible.fromJson(data);
        finalBible = finalBible.merge(chunkBible);
        
        // Wait 4 seconds to respect Gemini Free Tier rate limits (15 RPM)
        if (chunks.length > 1) {
          await Future.delayed(const Duration(seconds: 4));
        }
      } catch (e) {
        print('Error extracting chunk: $e');
        // Nếu là lỗi rate limit hoặc lỗi quan trọng, ném ra ngoài để UI báo lỗi thay vì treo
        rethrow;
      }
    }

    return finalBible;
  }

  List<String> _splitIntoChunks(String text, int limit) {
    if (text.length <= limit) return [text];
    
    final chunks = <String>[];
    int start = 0;
    
    while (start < text.length) {
      int end = start + limit;
      if (end >= text.length) {
        chunks.add(text.substring(start));
        break;
      }
      
      // Try to find a good breaking point (newline or double newline)
      int breakPoint = text.lastIndexOf('\n\n', end);
      if (breakPoint <= start) {
        breakPoint = text.lastIndexOf('\n', end);
      }
      if (breakPoint <= start) {
        breakPoint = end; // Force break
      } else {
        breakPoint += 1; // Include the newline
      }
      
      chunks.add(text.substring(start, breakPoint));
      start = breakPoint;
    }
    
    return chunks;
  }

  String _extractJson(String response) {
    final start = response.indexOf('{');
    final end = response.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return response.substring(start, end + 1);
    }
    return response;
  }
}
