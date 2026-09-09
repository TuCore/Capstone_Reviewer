import 'i_review_service.dart';
import '../../features/review/domain/entities/review_result.dart';
import '../../features/review/domain/entities/technical_error.dart';
import '../../features/review/domain/entities/test_gap.dart';

class MockReviewService implements IReviewService {
  @override
  Future<ReviewResult> analyzeDocuments({
    required String excelPath,
    required String srsPath,
    required String geminiApiKey,
  }) async {
    // Giả lập thời gian chờ xử lý file
    await Future.delayed(const Duration(seconds: 2));

    return ReviewResult(
      technicalErrors: [
        TechnicalError(
          row: 15,
          column: 'Test Data',
          type: ErrorType.emptyField,
          severity: ErrorSeverity.high,
          message: 'Để trống',
        ),
        TechnicalError(
          row: 23,
          column: 'Expected Res.',
          type: ErrorType.tooShort,
          severity: ErrorSeverity.medium,
          message: 'Quá sơ sài (5 ký tự)',
        ),
      ],
      testGaps: [
        TestGap(
          featureName: 'Đăng nhập / Đăng ký',
          srsReference: 'FR-01',
          testCaseCount: 8,
          status: GapStatus.ok,
          aiSuggestion: '',
        ),
        TestGap(
          featureName: 'Thanh toán online',
          srsReference: 'FR-05',
          testCaseCount: 0,
          status: GapStatus.missing,
          aiSuggestion: 'Cần bổ sung test case thanh toán VNPay',
        ),
      ],
      statistics: ReviewStatistics(
        totalErrors: 12,
        missingFeatures: 4,
        negativeTestPercentage: 0.08, // 8%
      ),
      overallAssessment: AssessmentStatus.needsFix,
      overallMessage: 'Cần sửa gấp. Tính năng thiếu test: 4/15 tính năng. Negative Test chỉ 8% (cần >= 20%)',
    );
  }
}
