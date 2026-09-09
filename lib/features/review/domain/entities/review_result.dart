import 'technical_error.dart';
import 'test_gap.dart';

enum AssessmentStatus { passed, needsFix, highRisk }

class ReviewStatistics {
  final int totalErrors;
  final int missingFeatures;
  final double negativeTestPercentage;

  ReviewStatistics({
    required this.totalErrors,
    required this.missingFeatures,
    required this.negativeTestPercentage,
  });
}

class ReviewResult {
  final List<TechnicalError> technicalErrors;
  final List<TestGap> testGaps;
  final ReviewStatistics statistics;
  final AssessmentStatus overallAssessment;
  final String overallMessage;

  ReviewResult({
    required this.technicalErrors,
    required this.testGaps,
    required this.statistics,
    required this.overallAssessment,
    required this.overallMessage,
  });
}
