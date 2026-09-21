enum ExtractionAvailabilityKind {
  complete,
  partial,
  unsupported,
}

class ExtractionAvailability {
  const ExtractionAvailability({
    required this.kind,
    this.code,
    required this.message,
  });

  const ExtractionAvailability.complete([String msg = 'Trích xuất hoàn tất.'])
      : kind = ExtractionAvailabilityKind.complete,
        code = 'COMPLETE',
        message = msg;

  const ExtractionAvailability.partial({String? code, required this.message})
      : kind = ExtractionAvailabilityKind.partial,
        code = code ?? 'PARTIAL';

  const ExtractionAvailability.unsupported({String? code, required this.message})
      : kind = ExtractionAvailabilityKind.unsupported,
        code = code ?? 'UNSUPPORTED';
  final ExtractionAvailabilityKind kind;
  final String? code;
  final String message;

  bool get isComplete => kind == ExtractionAvailabilityKind.complete;
  bool get isPartial => kind == ExtractionAvailabilityKind.partial;
  bool get isUnsupported => kind == ExtractionAvailabilityKind.unsupported;
}

class SourceEvidence {
  const SourceEvidence({
    required this.locator,
    this.header,
    required this.value,
    this.rule,
  });

  final String locator;
  final String? header;
  final String value;
  final String? rule;

  @override
  String toString() => locator.isNotEmpty ? '$locator ($value)' : value;
}

class SafeEvidenceExcerpt {
  SafeEvidenceExcerpt._();

  static String sanitize(String raw, {int maxLen = 120}) {
    var cleaned = raw
        .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.length > maxLen) {
      cleaned = '${cleaned.substring(0, maxLen)}...';
    }
    return cleaned;
  }
}

enum MetricStatus {
  available,
  partial,
  unavailable,
}

class MetricValue<T> {
  const MetricValue({
    this.value,
    required this.status,
    this.evidence,
    this.unavailableReason,
  });

  const MetricValue.available(T val, {this.evidence})
      : value = val,
        status = MetricStatus.available,
        unavailableReason = null;

  const MetricValue.partial(T val, {this.evidence, String? reason})
      : value = val,
        status = MetricStatus.partial,
        unavailableReason = reason;

  const MetricValue.unavailable({String? reason, this.evidence})
      : value = null,
        status = MetricStatus.unavailable,
        unavailableReason = reason;
  final T? value;
  final MetricStatus status;
  final SourceEvidence? evidence;
  final String? unavailableReason;

  bool get isAvailable => status == MetricStatus.available;
  bool get isPartial => status == MetricStatus.partial;
  bool get isUnavailable => status == MetricStatus.unavailable;

  String get displayValue {
    if (isUnavailable) return 'N/A';
    if (isPartial) return '$value* (bán phần)';
    return value?.toString() ?? 'N/A';
  }

  static MetricValue<int> diff(MetricValue<int> a, MetricValue<int> b) {
    if (!a.isAvailable || !b.isAvailable || a.value == null || b.value == null) {
      return const MetricValue.unavailable(reason: 'Thiếu một hoặc cả hai nguồn dữ liệu');
    }
    return MetricValue.available((a.value! - b.value!).abs());
  }

  static MetricValue<double> percentage(MetricValue<int> num, MetricValue<int> den) {
    if (!num.isAvailable || !den.isAvailable || num.value == null || den.value == null || den.value! <= 0) {
      return const MetricValue.unavailable(reason: 'Không đủ dữ liệu hoặc mẫu số bằng 0');
    }
    return MetricValue.available((num.value! / den.value!) * 100.0);
  }
}

enum RuleOutcomeKind {
  checkedClean,
  checkedWithFindings,
  notApplicable,
  unsupported,
}

class RuleOutcome<T> {
  const RuleOutcome({
    required this.ruleId,
    required this.kind,
    this.findings = const [],
    this.message = '',
    this.evidence,
  });

  final String ruleId;
  final RuleOutcomeKind kind;
  final List<T> findings;
  final String message;
  final SourceEvidence? evidence;

  bool get isClean => kind == RuleOutcomeKind.checkedClean;
  bool get hasFindings => kind == RuleOutcomeKind.checkedWithFindings;
  bool get isNotApplicable => kind == RuleOutcomeKind.notApplicable;
  bool get isUnsupported => kind == RuleOutcomeKind.unsupported;
}

class DuplicateIdFinding {
  const DuplicateIdFinding({
    required this.testId,
    required this.sheets,
    required this.statusBySheet,
    required this.hasStatusConflict,
    required this.message,
    this.evidence,
  });

  final String testId;
  final List<String> sheets;
  final Map<String, String> statusBySheet;
  final bool hasStatusConflict;
  final String message;
  final SourceEvidence? evidence;
}

class ThreeWayMetricsComparison {
  const ThreeWayMetricsComparison({
    required this.wordTotal,
    required this.wordAuto,
    required this.wordManual,
    required this.wordFailed,
    required this.excelDeclaredTotal,
    required this.excelDeclaredPassed,
    required this.excelDeclaredFailed,
    required this.actualTotal,
    required this.actualPassed,
    required this.actualFailed,
    required this.actualManual,
    required this.actualAuto,
    required this.totalDiscrepancy,
    required this.concealedFails,
    required this.manualDiscrepancy,
    required this.findings,
  });

  final MetricValue<int> wordTotal;
  final MetricValue<int> wordAuto;
  final MetricValue<int> wordManual;
  final MetricValue<int> wordFailed;

  final MetricValue<int> excelDeclaredTotal;
  final MetricValue<int> excelDeclaredPassed;
  final MetricValue<int> excelDeclaredFailed;

  final MetricValue<int> actualTotal;
  final MetricValue<int> actualPassed;
  final MetricValue<int> actualFailed;
  final MetricValue<int> actualManual;
  final MetricValue<int> actualAuto;

  final MetricValue<int> totalDiscrepancy;
  final MetricValue<int> concealedFails;
  final MetricValue<int> manualDiscrepancy;
  final List<String> findings;

  // Convenient legacy getters for display
  int get wordTotalVal => wordTotal.value ?? 0;
  int get wordAutoVal => wordAuto.value ?? 0;
  int get wordManualVal => wordManual.value ?? 0;
  int get wordFailedVal => wordFailed.value ?? 0;

  int get excelDeclaredTotalVal => excelDeclaredTotal.value ?? 0;
  int get excelDeclaredPassedVal => excelDeclaredPassed.value ?? 0;
  int get excelDeclaredFailedVal => excelDeclaredFailed.value ?? 0;

  int get actualTotalVal => actualTotal.value ?? 0;
  int get actualPassedVal => actualPassed.value ?? 0;
  int get actualFailedVal => actualFailed.value ?? 0;
  int get actualManualVal => actualManual.value ?? 0;
  int get actualAutoVal => actualAuto.value ?? 0;

  int get totalDiscrepancyVal => totalDiscrepancy.value ?? 0;
  int get concealedFailsVal => concealedFails.value ?? 0;
  int get manualDiscrepancyVal => manualDiscrepancy.value ?? 0;
}

class EnvironmentMismatchFinding {
  const EnvironmentMismatchFinding({
    required this.category,
    required this.wordValue,
    required this.excelValue,
    this.registrationValue,
    required this.description,
    this.evidence,
  });

  final String category;
  final String wordValue;
  final String excelValue;
  final String? registrationValue;
  final String description;
  final SourceEvidence? evidence;
}

class TimelineConflictFinding {
  const TimelineConflictFinding({
    required this.milestoneName,
    required this.milestoneDeadline,
    required this.testExecutionDate,
    required this.isViolated,
    required this.description,
    this.evidence,
  });

  final String milestoneName;
  final String milestoneDeadline;
  final String testExecutionDate;
  final bool isViolated;
  final String description;
  final SourceEvidence? evidence;
}

class IntegrityFinding {
  const IntegrityFinding({
    required this.code,
    required this.severity,
    required this.location,
    required this.message,
    this.evidence,
  });

  final String code;
  final String severity; // CRITICAL, HIGH, MEDIUM, LOW
  final String location;
  final String message;
  final SourceEvidence? evidence;
}

class CrossCheckResult {
  const CrossCheckResult({
    required this.duplicateIds,
    required this.metricsComparison,
    required this.environmentMismatches,
    required this.timelineConflicts,
    required this.integrityFindings,
    this.ruleOutcomes = const {},
  });

  final List<DuplicateIdFinding> duplicateIds;
  final ThreeWayMetricsComparison metricsComparison;
  final List<EnvironmentMismatchFinding> environmentMismatches;
  final List<TimelineConflictFinding> timelineConflicts;
  final List<IntegrityFinding> integrityFindings;
  final Map<String, RuleOutcome> ruleOutcomes;

  String toMarkdown() {
    final buf = StringBuffer();
    buf.writeln('## KẾT QUẢ ĐỐI CHIẾU DỮ LIỆU ĐỘC LẬP (DETERMINISTIC CROSS-CHECK)\n');

    // 1. So sánh số liệu
    buf.writeln('### 1. Bảng Đối Chiếu Số Liệu 3 Nguồn (Word SRS vs Excel Khai Báo vs Excel Đếm Thực)');
    buf.writeln('| Chỉ Số | SRS (Word) | Khai Báo (Excel) | Đếm Thực (Excel) | Lệch (SRS vs Thực) | Lệch (Khai báo vs Thực) |');
    buf.writeln('| :--- | :--- | :--- | :--- | :--- | :--- |');

    final wordT = metricsComparison.wordTotal.displayValue;
    final decT = metricsComparison.excelDeclaredTotal.displayValue;
    final actT = metricsComparison.actualTotal.displayValue;
    final totalDisc = metricsComparison.totalDiscrepancy.displayValue;
    buf.writeln('| **Tổng số ca** | $wordT | $decT | $actT | $totalDisc | N/A |');

    final wordP = 'N/A';
    final decP = metricsComparison.excelDeclaredPassed.displayValue;
    final actP = metricsComparison.actualPassed.displayValue;
    buf.writeln('| **Passed** | $wordP | $decP | $actP | N/A | N/A |');

    final wordF = metricsComparison.wordFailed.displayValue;
    final decF = metricsComparison.excelDeclaredFailed.displayValue;
    final actF = metricsComparison.actualFailed.displayValue;
    final concealed = metricsComparison.concealedFails.displayValue;
    buf.writeln('| **Failed** | $wordF | $decF | $actF | $concealed | N/A |');

    final wordM = metricsComparison.wordManual.displayValue;
    final decM = 'N/A';
    final actM = metricsComparison.actualManual.displayValue;
    final manDisc = metricsComparison.manualDiscrepancy.displayValue;
    buf.writeln('| **Manual** | $wordM | $decM | $actM | $manDisc | N/A |');

    final wordA = metricsComparison.wordAuto.displayValue;
    final decA = 'N/A';
    final actA = metricsComparison.actualAuto.displayValue;
    buf.writeln('| **Automation** | $wordA | $decA | $actA | N/A | N/A |');

    if (metricsComparison.findings.isNotEmpty) {
      buf.writeln('\n**Phát hiện sai lệch số liệu:**');
      for (final f in metricsComparison.findings) {
        buf.writeln('- $f');
      }
    }

    // 2. Trùng lặp ID
    buf.writeln('\n### 2. Quét Trùng Lặp ID & Mâu Thuẫn Pass/Fail Liên Sheet');
    if (duplicateIds.isEmpty) {
      buf.writeln('Không phát hiện trùng lặp ID liên sheet.');
    } else {
      buf.writeln('| Test Case ID | Các Sheet Xuất Hiện | Kết Quả Từng Sheet | Mâu thuẫn Pass/Fail |');
      buf.writeln('| :--- | :--- | :--- | :--- |');
      for (final d in duplicateIds) {
        final occurrences = d.statusBySheet.entries.map((e) => '${e.key}: **${e.value}**').join('<br>');
        final conflict = d.hasStatusConflict
            ? '**[Mâu thuẫn]** (Vừa Pass vừa Fail)'
            : 'Đồng nhất';
        buf.writeln('| `${d.testId}` | ${d.sheets.join(', ')} | $occurrences | $conflict |');
      }
    }

    // 3. Môi trường
    buf.writeln('\n### 3. Đối Chiếu Môi Trường & Cơ Sở Dữ Liệu');
    if (environmentMismatches.isEmpty) {
      buf.writeln('Không phát hiện mâu thuẫn thông tin môi trường giữa các tài liệu.');
    } else {
      buf.writeln('| Thành Phần | SRS (Word) | Test Report (Excel) | Đăng Ký Đề Tài | Đánh Giá |');
      buf.writeln('| :--- | :--- | :--- | :--- | :--- |');
      for (final e in environmentMismatches) {
        final reg = e.registrationValue ?? 'N/A';
        buf.writeln('| **${e.category}** | ${e.wordValue} | ${e.excelValue} | $reg | ${e.description} |');
      }
    }

    // 4. Mốc thời gian
    buf.writeln('\n### 4. Đối Chiếu Mốc Thời Gian & Ngày Kiểm Thử');
    if (timelineConflicts.isEmpty) {
      buf.writeln('Không phát hiện xung đột mốc thời gian kiểm thử.');
    } else {
      for (final t in timelineConflicts) {
        final status = t.isViolated ? '⚠️ **[Vi Phạm]**' : 'ℹ️ [Thông tin]';
        buf.writeln('- $status Mốc **${t.milestoneName}** (Hạn: ${t.milestoneDeadline}): Ngày test thực tế ghi nhận **${t.testExecutionDate}**. ${t.description}');
      }
    }

    // 5. Toàn vẹn dữ liệu
    buf.writeln('\n### 5. Kiểm Tra Tính Toàn Vẹn Tài Liệu & Lỗi Hành Chính');
    if (integrityFindings.isEmpty) {
      buf.writeln('Không phát hiện lỗi toàn vẹn cấu trúc file.');
    } else {
      buf.writeln('| Mức độ | Vị trí | Vấn đề |');
      buf.writeln('| :--- | :--- | :--- |');
      for (final inf in integrityFindings) {
        buf.writeln('| **[${inf.severity}]** | ${inf.location} | ${inf.message} |');
      }
    }

    return buf.toString();
  }
}

class CanonicalPresentationProjection {
  const CanonicalPresentationProjection({
    required this.totalTestCasesLabel,
    required this.passedCountLabel,
    required this.failedCountLabel,
    required this.passPercentageLabel,
    required this.totalDiscrepancyLabel,
    required this.concealedFailsLabel,
    required this.statusCounts,
    required this.hasDiscrepancy,
    required this.hasConcealedFails,
    required this.ruleStatuses,
  });

  factory CanonicalPresentationProjection.from({
    required ThreeWayMetricsComparison metrics,
    Map<String, RuleOutcome> ruleOutcomes = const {},
  }) {
    final totalLabel = metrics.actualTotal.displayValue;
    final passLabel = metrics.actualPassed.displayValue;
    final failLabel = metrics.actualFailed.displayValue;

    final passPct = MetricValue.percentage(metrics.actualPassed, metrics.actualTotal);
    final passPctLabel = passPct.isAvailable
        ? '${passPct.value!.toStringAsFixed(1)}%'
        : 'N/A';

    final totalDiscLabel = metrics.totalDiscrepancy.displayValue;
    final concealedLabel = metrics.concealedFails.displayValue;

    final hasDisc = metrics.totalDiscrepancy.isAvailable && metrics.totalDiscrepancy.value != 0;
    final hasConcealed = metrics.concealedFails.isAvailable && metrics.concealedFails.value! > 0;

    final statusCounts = <RuleOutcomeKind, int>{
      RuleOutcomeKind.checkedClean: 0,
      RuleOutcomeKind.checkedWithFindings: 0,
      RuleOutcomeKind.notApplicable: 0,
      RuleOutcomeKind.unsupported: 0,
    };

    final ruleStatuses = <String, String>{};
    for (final entry in ruleOutcomes.entries) {
      statusCounts[entry.value.kind] = (statusCounts[entry.value.kind] ?? 0) + 1;
      switch (entry.value.kind) {
        case RuleOutcomeKind.checkedClean:
          ruleStatuses[entry.key] = 'Đạt (Clean)';
          break;
        case RuleOutcomeKind.checkedWithFindings:
          ruleStatuses[entry.key] = 'Có vi phạm (${entry.value.findings.length})';
          break;
        case RuleOutcomeKind.notApplicable:
          ruleStatuses[entry.key] = 'Không áp dụng (N/A)';
          break;
        case RuleOutcomeKind.unsupported:
          ruleStatuses[entry.key] = 'Chưa hỗ trợ định dạng';
          break;
      }
    }

    return CanonicalPresentationProjection(
      totalTestCasesLabel: totalLabel,
      passedCountLabel: passLabel,
      failedCountLabel: failLabel,
      passPercentageLabel: passPctLabel,
      totalDiscrepancyLabel: totalDiscLabel,
      concealedFailsLabel: concealedLabel,
      statusCounts: statusCounts,
      hasDiscrepancy: hasDisc,
      hasConcealedFails: hasConcealed,
      ruleStatuses: ruleStatuses,
    );
  }

  final String totalTestCasesLabel;
  final String passedCountLabel;
  final String failedCountLabel;
  final String passPercentageLabel;
  final String totalDiscrepancyLabel;
  final String concealedFailsLabel;
  final Map<RuleOutcomeKind, int> statusCounts;
  final bool hasDiscrepancy;
  final bool hasConcealedFails;
  final Map<String, String> ruleStatuses;
}
