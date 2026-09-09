import '../../features/review/domain/entities/review_result.dart';

abstract class IChatService {
  /// Khởi tạo phiên chat với bối cảnh tài liệu
  void initializeSession({
    required String srsTextContext,
    required String excelSummaryContext,
    required ReviewResult reviewContext,
  });

  /// Gửi câu hỏi và nhận về Stream (từng chữ một để tạo hiệu ứng gõ)
  Stream<String> sendMessageStream(String message, String apiKey);
}
