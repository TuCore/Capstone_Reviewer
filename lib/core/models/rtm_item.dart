import 'package:flutter/material.dart';

/// Trạng thái của một dòng trong Ma trận Truy vết Yêu cầu
enum RTMStatus { pass, warning, missing }

/// Một dòng trong Ma trận Truy vết Yêu cầu (Requirement Traceability Matrix)
class RTMItem {
  final String reqId;
  final String reqName;
  final int testCount;
  final RTMStatus status;
  final String critique;

  const RTMItem({
    required this.reqId,
    required this.reqName,
    required this.testCount,
    required this.status,
    required this.critique,
  });

  factory RTMItem.fromJson(Map<String, dynamic> json) {
    return RTMItem(
      reqId: json['reqId'] as String? ?? '',
      reqName: json['reqName'] as String? ?? '',
      testCount: (json['testCount'] as num?)?.toInt() ?? 0,
      status: _parseStatus(json['status'] as String? ?? ''),
      critique: json['critique'] as String? ?? '',
    );
  }

  static RTMStatus _parseStatus(String value) {
    switch (value.toUpperCase()) {
      case 'PASS':
        return RTMStatus.pass;
      case 'WARNING':
        return RTMStatus.warning;
      case 'MISSING':
        return RTMStatus.missing;
      default:
        return RTMStatus.missing;
    }
  }

  /// Màu sắc badge tương ứng với trạng thái
  Color get statusColor {
    switch (status) {
      case RTMStatus.pass:
        return const Color(0xFF22C55E); // Xanh lá
      case RTMStatus.warning:
        return const Color(0xFFEAB308); // Vàng
      case RTMStatus.missing:
        return const Color(0xFFEF4444); // Đỏ
    }
  }

  /// Label hiển thị trạng thái
  String get statusLabel {
    switch (status) {
      case RTMStatus.pass:
        return 'Đạt';
      case RTMStatus.warning:
        return 'Cảnh báo';
      case RTMStatus.missing:
        return 'Bỏ quên';
    }
  }

  /// Emoji icon
  String get statusEmoji {
    switch (status) {
      case RTMStatus.pass:
        return '🟢';
      case RTMStatus.warning:
        return '🟡';
      case RTMStatus.missing:
        return '🔴';
    }
  }

  Map<String, dynamic> toJson() => {
        'reqId': reqId,
        'reqName': reqName,
        'testCount': testCount,
        'status': status.name.toUpperCase(),
        'critique': critique,
      };
}
