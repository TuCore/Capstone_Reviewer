/// Gợi ý test case bổ sung theo tiêu chuẩn IEEE 829 / ISO 29119
class TestCaseSuggestion {
  final String reqId;
  final String testCaseId;
  final String title;
  final String type; // Positive / Negative / Boundary / Security
  final String preconditions;
  final String testData;
  final String steps;
  final String expected;

  const TestCaseSuggestion({
    required this.reqId,
    required this.testCaseId,
    required this.title,
    required this.type,
    required this.preconditions,
    required this.testData,
    required this.steps,
    required this.expected,
  });

  factory TestCaseSuggestion.fromJson(Map<String, dynamic> json) {
    return TestCaseSuggestion(
      reqId: json['reqId'] as String? ?? '',
      testCaseId: json['testCaseId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'Negative',
      preconditions: json['preconditions'] as String? ?? '',
      testData: json['testData'] as String? ?? '',
      steps: json['steps'] as String? ?? '',
      expected: json['expected'] as String? ?? '',
    );
  }

  /// Màu badge cho loại test case
  int get typeColorValue {
    switch (type.toLowerCase()) {
      case 'positive':
        return 0xFF22C55E;
      case 'negative':
        return 0xFFEF4444;
      case 'boundary':
        return 0xFFEAB308;
      case 'security':
        return 0xFF8B5CF6;
      default:
        return 0xFF6B7280;
    }
  }

  Map<String, dynamic> toJson() => {
        'reqId': reqId,
        'testCaseId': testCaseId,
        'title': title,
        'type': type,
        'preconditions': preconditions,
        'testData': testData,
        'steps': steps,
        'expected': expected,
      };
}
