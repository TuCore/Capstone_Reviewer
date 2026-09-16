/// Bảng điểm & xếp loại chất lượng Test Case
class Scorecard {
  final double totalScore;
  final String grade;
  final double coverageRate;
  final double depthScore;
  final double qualityScore;
  final double traceabilityScore;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;

  const Scorecard({
    required this.totalScore,
    required this.grade,
    required this.coverageRate,
    required this.depthScore,
    required this.qualityScore,
    required this.traceabilityScore,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
  });

  factory Scorecard.fromJson(Map<String, dynamic> json) {
    return Scorecard(
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 0.0,
      grade: json['grade'] as String? ?? 'Chưa xếp loại',
      coverageRate: (json['coverageRate'] as num?)?.toDouble() ?? 0.0,
      depthScore: (json['depthScore'] as num?)?.toDouble() ?? 0.0,
      qualityScore: (json['qualityScore'] as num?)?.toDouble() ?? 0.0,
      traceabilityScore: (json['traceabilityScore'] as num?)?.toDouble() ?? 0.0,
      summary: json['summary'] as String? ?? '',
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      weaknesses: (json['weaknesses'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'totalScore': totalScore,
        'grade': grade,
        'coverageRate': coverageRate,
        'depthScore': depthScore,
        'qualityScore': qualityScore,
        'traceabilityScore': traceabilityScore,
        'summary': summary,
        'strengths': strengths,
        'weaknesses': weaknesses,
      };
}
