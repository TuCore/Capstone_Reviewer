/// Các chỉ số tổng quan về bộ test cases
class ReviewMetrics {
  final int totalRequirements;
  final int coveredRequirements;
  final int totalTestCases;
  final int happyPathCount;
  final int negativePathCount;
  final int edgeCaseCount;
  final int securityTestCount;

  const ReviewMetrics({
    required this.totalRequirements,
    required this.coveredRequirements,
    required this.totalTestCases,
    required this.happyPathCount,
    required this.negativePathCount,
    required this.edgeCaseCount,
    required this.securityTestCount,
  });

  double get coveragePercent =>
      totalRequirements > 0 ? (coveredRequirements / totalRequirements * 100) : 0;

  double get happyPathPercent =>
      totalTestCases > 0 ? (happyPathCount / totalTestCases * 100) : 0;

  double get negativePercent =>
      totalTestCases > 0 ? (negativePathCount / totalTestCases * 100) : 0;

  double get edgeCasePercent =>
      totalTestCases > 0 ? (edgeCaseCount / totalTestCases * 100) : 0;

  double get securityPercent =>
      totalTestCases > 0 ? (securityTestCount / totalTestCases * 100) : 0;

  factory ReviewMetrics.fromJson(Map<String, dynamic> json) {
    return ReviewMetrics(
      totalRequirements: (json['totalRequirements'] as num?)?.toInt() ?? 0,
      coveredRequirements: (json['coveredRequirements'] as num?)?.toInt() ?? 0,
      totalTestCases: (json['totalTestCases'] as num?)?.toInt() ?? 0,
      happyPathCount: (json['happyPathCount'] as num?)?.toInt() ?? 0,
      negativePathCount: (json['negativePathCount'] as num?)?.toInt() ?? 0,
      edgeCaseCount: (json['edgeCaseCount'] as num?)?.toInt() ?? 0,
      securityTestCount: (json['securityTestCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalRequirements': totalRequirements,
        'coveredRequirements': coveredRequirements,
        'totalTestCases': totalTestCases,
        'happyPathCount': happyPathCount,
        'negativePathCount': negativePathCount,
        'edgeCaseCount': edgeCaseCount,
        'securityTestCount': securityTestCount,
      };
}
