import '../../core/extraction/test_case_schema.dart';
import '../../core/services/coverage_stats.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/cross_check_engine.dart';
import '../../core/services/hard_checks.dart';
import '../../core/services/test_case_review_engine.dart';

class ReviewBundle {
  const ReviewBundle({
    required this.markdown,
    required this.stats,
    required this.checks,
    required this.records,
    required this.caseReviews,
    this.crossCheck,
    this.verifiedFindings = const [],
  });

  final String markdown;
  final CoverageStats stats;
  final List<HardCheckFinding> checks;
  final List<TestCaseRecord> records;
  final List<TestCaseReview> caseReviews;
  final CrossCheckResult? crossCheck;
  final List<VerifiedFinding> verifiedFindings;
}
