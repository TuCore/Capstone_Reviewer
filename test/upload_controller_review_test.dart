import 'package:capstone_reviewer/core/extraction/extraction_result.dart';
import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/extraction/workbook_snapshot.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/registration_pii.dart';
import 'package:capstone_reviewer/core/services/review_report_composer.dart';
import 'package:capstone_reviewer/features/review/review_bundle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UploadController Review Wiring Integration', () {
    test('produces clean ReviewBundle and Report without Report5 hardcodes', () {
      final regDoc = const RegistrationContext(
        topic: 'AI Code Reviewer Tool',
        description: 'Công cụ đánh giá đồ án tự động',
      );

      final excelResult = ExtractionResult(
        text: 'Test cases content',
        records: [
          const TestCaseRecord(
            sheet: 'M01',
            id: 'TC-01',
            status: 'Passed',
            description: 'Login test',
          ),
          const TestCaseRecord(
            sheet: 'M01',
            id: 'TC-02',
            status: 'Failed',
            description: 'Checkout test',
          ),
        ],
        workbook: WorkbookSnapshot.empty(isComplete: true),
        availability: const ExtractionAvailability.complete(),
      );

      final docResult = ExtractionResult(
        text: 'Total Test Cases: 2\nFailed: 0',
        availability: const ExtractionAvailability.complete(),
      );

      final crossCheck = CrossCheckEngine.run(
        records: excelResult.records,
        wordText: docResult.text,
        excelText: excelResult.text,
        registrationText: regDoc.toPromptBlock(),
        workbook: excelResult.workbook,
        excelAvailability: excelResult.availability,
        wordAvailability: docResult.availability,
      );

      final stats = computeCoverage(
        srsText: docResult.text,
        records: excelResult.records,
        unknownModules: const [],
      );

      final bundle = ReviewBundle(
        markdown: '',
        stats: stats,
        checks: const [],
        records: excelResult.records,
        caseReviews: const [],
        crossCheck: crossCheck,
        registrationContext: regDoc,
        excelAvailability: excelResult.availability,
        docAvailability: docResult.availability,
      );

      final markdown = ReviewReportComposer.compose(
        bundle,
        excelPreamble: excelResult.preamble(),
        docPreamble: docResult.preamble(),
      );

      expect(markdown, contains('AI Code Reviewer Tool'));
      expect(markdown, contains('Công cụ đánh giá đồ án tự động'));
      expect(markdown, contains('Khắc phục ca FAILED'));
      expect(markdown, isNot(contains('SU26SE017')));
      expect(markdown, isNot(contains('CDE System for BIM')));
      expect(markdown, isNot(contains('thiếu 18 ca ở M04')));
    });
  });
}
