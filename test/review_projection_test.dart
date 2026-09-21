import 'package:capstone_reviewer/core/services/cross_check_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CanonicalPresentationProjection', () {
    test('formats labels for complete extraction', () {
      const metrics = ThreeWayMetricsComparison(
        wordTotal: MetricValue.available(300),
        wordAuto: MetricValue.unavailable(),
        wordManual: MetricValue.unavailable(),
        wordFailed: MetricValue.available(0),
        excelDeclaredTotal: MetricValue.available(320),
        excelDeclaredPassed: MetricValue.available(320),
        excelDeclaredFailed: MetricValue.available(0),
        actualTotal: MetricValue.available(320),
        actualPassed: MetricValue.available(300),
        actualFailed: MetricValue.available(20),
        actualManual: MetricValue.unavailable(),
        actualAuto: MetricValue.unavailable(),
        totalDiscrepancy: MetricValue.available(20),
        concealedFails: MetricValue.available(20),
        manualDiscrepancy: MetricValue.unavailable(),
        findings: ['Discrepancy found'],
      );

      final projection = CanonicalPresentationProjection.from(
        metrics: metrics,
        ruleOutcomes: {
          'rule-1': const RuleOutcome(
            ruleId: 'rule-1',
            kind: RuleOutcomeKind.checkedClean,
          ),
          'rule-2': const RuleOutcome(
            ruleId: 'rule-2',
            kind: RuleOutcomeKind.checkedWithFindings,
            findings: ['Finding 1'],
          ),
        },
      );

      expect(projection.totalTestCasesLabel, '320');
      expect(projection.passedCountLabel, '300');
      expect(projection.failedCountLabel, '20');
      expect(projection.passPercentageLabel, '93.8%');
      expect(projection.totalDiscrepancyLabel, '20');
      expect(projection.concealedFailsLabel, '20');
      expect(projection.hasDiscrepancy, isTrue);
      expect(projection.hasConcealedFails, isTrue);

      expect(projection.statusCounts[RuleOutcomeKind.checkedClean], 1);
      expect(projection.statusCounts[RuleOutcomeKind.checkedWithFindings], 1);
      expect(projection.statusCounts[RuleOutcomeKind.unsupported], 0);

      expect(projection.ruleStatuses['rule-1'], contains('Đạt'));
      expect(projection.ruleStatuses['rule-2'], contains('Có vi phạm'));
    });

    test('formats labels for partial and unavailable metrics gracefully', () {
      const metrics = ThreeWayMetricsComparison(
        wordTotal: MetricValue.unavailable(reason: 'Không tìm thấy'),
        wordAuto: MetricValue.unavailable(),
        wordManual: MetricValue.unavailable(),
        wordFailed: MetricValue.unavailable(),
        excelDeclaredTotal: MetricValue.unavailable(),
        excelDeclaredPassed: MetricValue.unavailable(),
        excelDeclaredFailed: MetricValue.unavailable(),
        actualTotal: MetricValue.partial(150, reason: 'Bán phần'),
        actualPassed: MetricValue.partial(100),
        actualFailed: MetricValue.partial(50),
        actualManual: MetricValue.unavailable(),
        actualAuto: MetricValue.unavailable(),
        totalDiscrepancy: MetricValue.unavailable(),
        concealedFails: MetricValue.unavailable(),
        manualDiscrepancy: MetricValue.unavailable(),
        findings: [],
      );

      final projection = CanonicalPresentationProjection.from(metrics: metrics);

      expect(projection.totalTestCasesLabel, contains('150* (bán phần)'));
      expect(projection.totalDiscrepancyLabel, 'N/A');
      expect(projection.hasDiscrepancy, isFalse);
      expect(projection.hasConcealedFails, isFalse);
    });
  });
}
