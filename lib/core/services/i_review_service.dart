import '../../features/review/domain/entities/review_result.dart';

abstract class IReviewService {
  /// Phân tích toàn diện 2 file và trả về kết quả
  Future<ReviewResult> analyzeDocuments({
    required String excelPath,
    required String srsPath,
    required String geminiApiKey,
  });
}
