import 'package:flutter/material.dart';

/// Loại anti-pattern phát hiện
enum AntiPatternType {
  vagueExpectation,
  boundaryAbsence,
  securityGap,
  duplicateTest,
  missingPrecondition,
}

/// Lỗi anti-pattern được phát hiện trong bộ test cases
class AntiPattern {
  final AntiPatternType type;
  final String testCaseId;
  final String description;
  final String severity; // HIGH / MEDIUM / LOW

  const AntiPattern({
    required this.type,
    required this.testCaseId,
    required this.description,
    required this.severity,
  });

  factory AntiPattern.fromJson(Map<String, dynamic> json) {
    return AntiPattern(
      type: _parseType(json['type'] as String? ?? ''),
      testCaseId: json['testCaseId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      severity: json['severity'] as String? ?? 'MEDIUM',
    );
  }

  static AntiPatternType _parseType(String value) {
    switch (value.toUpperCase()) {
      case 'VAGUE_EXPECTATION':
        return AntiPatternType.vagueExpectation;
      case 'BOUNDARY_ABSENCE':
        return AntiPatternType.boundaryAbsence;
      case 'SECURITY_GAP':
        return AntiPatternType.securityGap;
      case 'DUPLICATE_TEST':
        return AntiPatternType.duplicateTest;
      case 'MISSING_PRECONDITION':
        return AntiPatternType.missingPrecondition;
      default:
        return AntiPatternType.vagueExpectation;
    }
  }

  /// Icon cho loại anti-pattern
  IconData get typeIcon {
    switch (type) {
      case AntiPatternType.vagueExpectation:
        return Icons.help_outline;
      case AntiPatternType.boundaryAbsence:
        return Icons.unfold_more;
      case AntiPatternType.securityGap:
        return Icons.lock_open;
      case AntiPatternType.duplicateTest:
        return Icons.content_copy;
      case AntiPatternType.missingPrecondition:
        return Icons.playlist_remove;
    }
  }

  /// Label hiển thị loại anti-pattern
  String get typeLabel {
    switch (type) {
      case AntiPatternType.vagueExpectation:
        return 'Kỳ vọng mơ hồ';
      case AntiPatternType.boundaryAbsence:
        return 'Thiếu kiểm thử biên';
      case AntiPatternType.securityGap:
        return 'Thiếu kiểm thử bảo mật';
      case AntiPatternType.duplicateTest:
        return 'Test case trùng lặp';
      case AntiPatternType.missingPrecondition:
        return 'Thiếu tiền điều kiện';
    }
  }

  /// Màu sắc badge severity
  Color get severityColor {
    switch (severity.toUpperCase()) {
      case 'HIGH':
        return const Color(0xFFEF4444);
      case 'MEDIUM':
        return const Color(0xFFEAB308);
      case 'LOW':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Map<String, dynamic> toJson() => {
        'type': type.name.toUpperCase(),
        'testCaseId': testCaseId,
        'description': description,
        'severity': severity,
      };
}
