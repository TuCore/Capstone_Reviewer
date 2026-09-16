import 'dart:convert';

import 'scorecard.dart';
import 'metrics.dart';
import 'rtm_item.dart';
import 'anti_pattern.dart';
import 'test_case_suggestion.dart';

/// Master model chứa toàn bộ kết quả phân tích từ AI
class ReviewAuditResult {
  final Scorecard scorecard;
  final ReviewMetrics metrics;
  final List<RTMItem> rtm;
  final List<AntiPattern> antiPatterns;
  final List<TestCaseSuggestion> missingSuggestions;

  /// Thông tin từ Phiếu Đăng Ký Đồ Án
  final String? projectTitle;
  final String? supervisor;
  final String? teamMembers;
  final DateTime? reviewDate;

  const ReviewAuditResult({
    required this.scorecard,
    required this.metrics,
    required this.rtm,
    required this.antiPatterns,
    required this.missingSuggestions,
    this.projectTitle,
    this.supervisor,
    this.teamMembers,
    this.reviewDate,
  });

  ReviewAuditResult copyWith({
    Scorecard? scorecard,
    ReviewMetrics? metrics,
    List<RTMItem>? rtm,
    List<AntiPattern>? antiPatterns,
    List<TestCaseSuggestion>? missingSuggestions,
    String? projectTitle,
    String? supervisor,
    String? teamMembers,
    DateTime? reviewDate,
  }) {
    return ReviewAuditResult(
      scorecard: scorecard ?? this.scorecard,
      metrics: metrics ?? this.metrics,
      rtm: rtm ?? this.rtm,
      antiPatterns: antiPatterns ?? this.antiPatterns,
      missingSuggestions: missingSuggestions ?? this.missingSuggestions,
      projectTitle: projectTitle ?? this.projectTitle,
      supervisor: supervisor ?? this.supervisor,
      teamMembers: teamMembers ?? this.teamMembers,
      reviewDate: reviewDate ?? this.reviewDate,
    );
  }

  factory ReviewAuditResult.fromJson(Map<String, dynamic> json) {
    return ReviewAuditResult(
      scorecard: Scorecard.fromJson(
          json['scorecard'] as Map<String, dynamic>? ?? {}),
      metrics: ReviewMetrics.fromJson(
          json['metrics'] as Map<String, dynamic>? ?? {}),
      rtm: (json['rtm'] as List<dynamic>?)
              ?.map((e) => RTMItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      antiPatterns: (json['antiPatterns'] as List<dynamic>?)
              ?.map((e) => AntiPattern.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      missingSuggestions: (json['missingSuggestions'] as List<dynamic>?)
              ?.map(
                  (e) => TestCaseSuggestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projectTitle: json['projectTitle'] as String?,
      supervisor: json['supervisor'] as String?,
      teamMembers: json['teamMembers'] as String?,
      reviewDate: DateTime.now(),
    );
  }

  /// Parse raw AI response string → ReviewAuditResult
  /// Handles JSON wrapped in markdown code fences, extra text, etc.
  static ReviewAuditResult? tryParse(String rawResponse) {
    try {
      String cleaned = rawResponse.trim();

      // Strip markdown code fences: ```json ... ```
      final codeFenceRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
      final codeFenceMatch = codeFenceRegex.firstMatch(cleaned);
      if (codeFenceMatch != null) {
        cleaned = codeFenceMatch.group(1)!.trim();
      }

      // Try to extract JSON object if there's surrounding text
      if (!cleaned.startsWith('{')) {
        final jsonStart = cleaned.indexOf('{');
        final jsonEnd = cleaned.lastIndexOf('}');
        if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
          cleaned = cleaned.substring(jsonStart, jsonEnd + 1);
        }
      }

      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return ReviewAuditResult.fromJson(json);
    } catch (e) {
      print('Error parsing ReviewAuditResult: $e');
      return null;
    }
  }

  /// Tính số lượng RTM items theo trạng thái
  int get passCount => rtm.where((r) => r.status == RTMStatus.pass).length;
  int get warningCount =>
      rtm.where((r) => r.status == RTMStatus.warning).length;
  int get missingCount =>
      rtm.where((r) => r.status == RTMStatus.missing).length;

  Map<String, dynamic> toJson() => {
        'scorecard': scorecard.toJson(),
        'metrics': metrics.toJson(),
        'rtm': rtm.map((e) => e.toJson()).toList(),
        'antiPatterns': antiPatterns.map((e) => e.toJson()).toList(),
        'missingSuggestions':
            missingSuggestions.map((e) => e.toJson()).toList(),
        'projectTitle': projectTitle,
        'supervisor': supervisor,
        'teamMembers': teamMembers,
      };
}
