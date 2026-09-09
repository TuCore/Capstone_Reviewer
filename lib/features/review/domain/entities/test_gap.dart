enum GapStatus { missing, inadequate, ok }

class TestGap {
  final String featureName;
  final String srsReference;
  final int testCaseCount;
  final GapStatus status;
  final String aiSuggestion;

  TestGap({
    required this.featureName,
    required this.srsReference,
    required this.testCaseCount,
    required this.status,
    required this.aiSuggestion,
  });
}
