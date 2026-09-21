import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/registration_pii.dart';
import 'package:capstone_reviewer/core/services/review_report_composer.dart';
import 'package:capstone_reviewer/features/review/review_bundle.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('ReviewReportComposer', () {
    test('composes dynamic report with provided registration topic and description', () {
      final bundle = ReviewBundle(
        markdown: '',
        stats: computeCoverage(srsText: '', records: const [], unknownModules: const []),
        checks: const [],
        records: const [],
        caseReviews: const [],
        registrationContext: const RegistrationContext(
          topic: 'Smart Home IoT Hub',
          description: 'Hệ thống quản lý thiết bị nhà thông minh',
        ),
      );

      final report = ReviewReportComposer.compose(bundle);

      expect(report, contains('Smart Home IoT Hub'));
      expect(report, contains('Hệ thống quản lý thiết bị nhà thông minh'));
      expect(report, isNot(contains('SU26SE017')));
      expect(report, isNot(contains('Report5')));
      expect(report, isNot(contains('CDE System for BIM')));
    });

    test('renders Chưa xác định when registration context is missing or empty', () {
      final bundle = ReviewBundle(
        markdown: '',
        stats: computeCoverage(srsText: '', records: const [], unknownModules: const []),
        checks: const [],
        records: const [],
        caseReviews: const [],
      );

      final report = ReviewReportComposer.compose(bundle);

      expect(report, contains('Tên đề tài:** Chưa xác định'));
      expect(report, isNot(contains('SU26SE017')));
      expect(report, isNot(contains('Report5')));
    });

    test('generates dynamic recommendations from actual cross-check findings', () {
      final records = [
        const TestCaseRecord(
          sheet: 'M01',
          id: 'TC01',
          status: 'Failed',
          description: 'Login test',
        ),
      ];

      final crossCheck = CrossCheckEngine.run(
        records: records,
        wordText: 'Total Test Cases: 100\nFailed: 0',
      );

      final bundle = ReviewBundle(
        markdown: '',
        stats: computeCoverage(srsText: '', records: records, unknownModules: const []),
        checks: const [],
        records: records,
        caseReviews: const [],
        crossCheck: crossCheck,
      );

      final report = ReviewReportComposer.compose(bundle);

      expect(report, contains('Khắc phục ca FAILED'));
      expect(report, contains('Đồng nhất số liệu tổng'));
      expect(report, isNot(contains('thiếu 18 ca ở M04')));
    });

    test('composes report using projectInfo from AI and overrides Chưa xác định', () {
      final bundle = ReviewBundle(
        markdown: '',
        stats: computeCoverage(srsText: '', records: const [], unknownModules: const []),
        checks: const [],
        records: const [],
        caseReviews: const [],
        projectInfo: const ProjectInfo(
          topic: 'AI Capstone Evaluator',
          description: 'Hệ thống tự động thẩm định đồ án tốt nghiệp',
          techStack: ['Flutter', 'Dart', 'Gemini'],
        ),
      );

      final report = ReviewReportComposer.compose(bundle);

      expect(report, contains('AI Capstone Evaluator'));
      expect(report, contains('Hệ thống tự động thẩm định đồ án tốt nghiệp'));
      expect(report, contains('Flutter, Dart, Gemini'));
      expect(report, isNot(contains('Chưa xác định')));
    });

    test('composes 6-axis verified findings in report', () {
      final bundle = ReviewBundle(
        markdown: '',
        stats: computeCoverage(srsText: '', records: const [], unknownModules: const []),
        checks: const [],
        records: const [],
        caseReviews: const [],
        verifiedFindings: const [
          VerifiedFinding(
            id: '1',
            axis: 'Tech Mismatch',
            module: 'Database',
            claim: 'SRS ghi Viettel Cloud nhưng Excel test Azure SQL',
            isVerified: true,
            quote: 'Viettel Cloud IDC',
            explanation: 'Mâu thuẫn hạ tầng triển khai thực tế',
          ),
        ],
      );

      final report = ReviewReportComposer.compose(bundle);

      expect(report, contains('Phát hiện từ AI Trục 1 - Tech Mismatch'));
      expect(report, contains('SRS ghi Viettel Cloud nhưng Excel test Azure SQL'));
      expect(report, contains('Viettel Cloud IDC'));
      expect(report, contains('*[Tech Mismatch]*'));
    });
  });
}
