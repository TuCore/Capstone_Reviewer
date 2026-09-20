import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:capstone_reviewer/core/services/test_case_review_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestCaseReviewEngine - Invariants & Rules', () {
    test('enforces exact 1-to-1 mapping on empty and multiple records', () {
      expect(TestCaseReviewEngine.reviewAll(records: []), isEmpty);

      final records = [
        const TestCaseRecord(
          sheet: 'M01',
          id: 'TC01',
          description: 'Kiểm thử đăng nhập hợp lệ',
          steps: '1. Nhập email\n2. Nhập mật khẩu\n3. Bấm Đăng nhập',
          expected: 'Hệ thống chuyển hướng vào trang chủ Dashboard thành công',
          status: 'Passed',
          testDate: '2026-09-18',
        ),
        const TestCaseRecord(
          sheet: 'M02',
          id: 'TC02',
          description: 'Kiểm thử quên mật khẩu',
          steps: '1. Nhập email\n2. Bấm Gửi mã',
          expected: 'Hệ thống gửi mã OTP 6 số qua email thành công',
          status: 'Passed',
          testDate: '2026-09-18',
        ),
      ];

      final reviews = TestCaseReviewEngine.reviewAll(records: records);
      expect(reviews.length, equals(records.length));
      expect(reviews[0].record, equals(records[0]));
      expect(reviews[1].record, equals(records[1]));
    });

    test('clean record has no issues and correct default verdict', () {
      const cleanRecord = TestCaseRecord(
        sheet: 'M01',
        id: 'TC_LOGIN_01',
        description: 'Kiểm tra đăng nhập thành công với tài khoản quản trị viên',
        preCondition: 'Tài khoản admin đã được kích hoạt trong hệ thống',
        steps: '1. Nhập email admin@domain.com\n2. Nhập mật khẩu hợp lệ\n3. Nhấn Đăng nhập',
        testData: 'admin@domain.com / Secret123@',
        expected: 'Hệ thống hiển thị màn hình Dashboard quản trị viên và lưu phiên',
        status: 'Passed',
        testDate: '2026-09-18',
      );

      final review = TestCaseReviewEngine.reviewRecord(cleanRecord);
      expect(review.hasIssues, isFalse);
      expect(review.issues, isEmpty);
      expect(review.highestSeverity, isNull);
      expect(
        review.verdictLabel,
        equals('Không phát hiện lỗi theo rule deterministic'),
      );
    });

    test('missing required fields generates critical/high issues', () {
      const incompleteRecord = TestCaseRecord(
        sheet: 'M01',
        id: '',
        description: '',
        steps: '',
        expected: '',
      );

      final review = TestCaseReviewEngine.reviewRecord(incompleteRecord);
      expect(review.hasIssues, isTrue);

      final issueCodes = review.issues.map((i) => i.code).toList();
      expect(issueCodes, contains('missing-id'));
      expect(issueCodes, contains('missing-description'));
      expect(issueCodes, contains('empty-procedure'));

      final idIssue = review.issues.firstWhere((i) => i.code == 'missing-id');
      expect(idIssue.severity, equals(TestCaseIssueSeverity.critical));
      expect(idIssue.field, equals(ReviewedField.id));

      final descIssue =
          review.issues.firstWhere((i) => i.code == 'missing-description');
      expect(descIssue.severity, equals(TestCaseIssueSeverity.high));
      expect(descIssue.field, equals(ReviewedField.description));
    });

    test('steps without expected generates missing-expected (critical)', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Mô tả hợp lệ',
        steps: '1. Bấm nút A',
        expected: '',
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      final issue =
          review.issues.firstWhere((i) => i.code == 'missing-expected');
      expect(issue.severity, equals(TestCaseIssueSeverity.critical));
      expect(issue.field, equals(ReviewedField.expected));
    });

    test('expected without steps generates missing-steps (high)', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Mô tả hợp lệ',
        steps: '',
        expected: 'Hệ thống hiển thị thông báo lỗi',
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      final issue =
          review.issues.firstWhere((i) => i.code == 'missing-steps');
      expect(issue.severity, equals(TestCaseIssueSeverity.high));
      expect(issue.field, equals(ReviewedField.steps));
    });

    test('vague expected result generates high severity issue', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Kiểm thử đăng nhập',
        steps: '1. Nhập thông tin',
        expected: 'hợp lệ',
        status: 'Passed',
        testDate: '2026-09-18',
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      final issue =
          review.issues.firstWhere((i) => i.code == 'vague-expected');
      expect(issue.severity, equals(TestCaseIssueSeverity.high));
      expect(issue.field, equals(ReviewedField.expected));
      expect(issue.evidence, contains('hợp lệ'));
    });

    test('failed test case without bug/note generates failed-missing-bug', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Kiểm thử đăng ký',
        steps: '1. Bấm đăng ký',
        expected: 'Hệ thống tạo tài khoản thành công',
        status: 'Failed',
        bug: '',
        note: '',
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      final issue =
          review.issues.firstWhere((i) => i.code == 'failed-missing-bug');
      expect(issue.severity, equals(TestCaseIssueSeverity.medium));
      expect(issue.field, equals(ReviewedField.bug));
    });

    test('unknown status generates unknown-status issue', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Kiểm thử',
        steps: '1. Bấm',
        expected: 'Màn hình mở',
        status: 'Chưa rõ kết quả gì đó',
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      final issue =
          review.issues.firstWhere((i) => i.code == 'unknown-status');
      expect(issue.severity, equals(TestCaseIssueSeverity.low));
      expect(issue.field, equals(ReviewedField.status));
    });

    test('attaches hard checks and duplicate findings accurately', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'TC01',
        description: 'Kiểm thử',
        steps: '1. Bấm',
        expected: 'Màn hình mở',
        status: 'Passed',
        testDate: '2026-09-18',
      );

      const duplicateFinding = DuplicateIdFinding(
        testId: 'TC01',
        sheets: ['M01', 'M02'],
        statusBySheet: {'M01': 'Passed', 'M02': 'Failed'},
        hasStatusConflict: true,
        message: 'Mâu thuẫn trạng thái giữa M01 và M02',
      );

      final review = TestCaseReviewEngine.reviewRecord(
        record,
        duplicateFinding: duplicateFinding,
      );

      final issue =
          review.issues.firstWhere((i) => i.code == 'duplicate-id-conflict');
      expect(issue.severity, equals(TestCaseIssueSeverity.critical));
      expect(issue.field, equals(ReviewedField.id));
      expect(review.highestSeverity, equals(TestCaseIssueSeverity.critical));
      expect(review.verdictLabel, equals('Lỗi nghiêm trọng'));
    });

    test('issues are always sorted by severity (critical first)', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: '', // critical: missing-id
        description: '', // high: missing-description
        status: 'UnknownValue', // low: unknown-status
        steps: 'Bấm',
        expected: 'ok', // high: vague-expected
      );

      final review = TestCaseReviewEngine.reviewRecord(record);
      for (var i = 0; i < review.issues.length - 1; i++) {
        expect(
          review.issues[i].severity.index <=
              review.issues[i + 1].severity.index,
          isTrue,
        );
      }
    });

    test('status normalization canonicalizes skipped, skip, blocked, untested to Untested', () {
      expect(TestCaseReviewEngine.normalizeStatus('skipped'), equals('Untested'));
      expect(TestCaseReviewEngine.normalizeStatus('skip'), equals('Untested'));
      expect(TestCaseReviewEngine.normalizeStatus('Blocked'), equals('Untested'));
      expect(TestCaseReviewEngine.normalizeStatus('Pending'), equals('Untested'));
      expect(TestCaseReviewEngine.normalizeStatus('Untested'), equals('Untested'));
      expect(TestCaseReviewEngine.normalizeStatus('pass'), equals('PASSED'));
      expect(TestCaseReviewEngine.normalizeStatus('Passed'), equals('PASSED'));
      expect(TestCaseReviewEngine.normalizeStatus('fail'), equals('FAILED'));
      expect(TestCaseReviewEngine.normalizeStatus('Failed'), equals('FAILED'));
      expect(TestCaseReviewEngine.normalizeStatus('not run'), equals('Not Run'));
      expect(TestCaseReviewEngine.normalizeStatus('n/a'), equals('N/A'));

      expect(TestCaseReviewEngine.isKnownStatus('PASSED'), isTrue);
      expect(TestCaseReviewEngine.isKnownStatus('FAILED'), isTrue);
      expect(TestCaseReviewEngine.isKnownStatus('Not Run'), isTrue);
      expect(TestCaseReviewEngine.isKnownStatus('Untested'), isTrue);
      expect(TestCaseReviewEngine.isKnownStatus('N/A'), isTrue);
      expect(TestCaseReviewEngine.isKnownStatus('RandomValue'), isFalse);
    });

    test('case-insensitive failed status check requires bug note', () {
      const recordUpper = TestCaseRecord(
        sheet: 'M01',
        id: 'TC_FAIL_01',
        description: 'Đăng nhập',
        steps: '1. Nhập sai',
        expected: 'Báo lỗi tài khoản không tồn tại',
        status: 'FAILED',
        testDate: '2026-09-18',
      );

      final reviewUpper = TestCaseReviewEngine.reviewRecord(recordUpper);
      expect(reviewUpper.issues.any((i) => i.code == 'failed-missing-bug'), isTrue);

      const recordWithBug = TestCaseRecord(
        sheet: 'M01',
        id: 'TC_FAIL_02',
        description: 'Đăng nhập',
        steps: '1. Nhập sai',
        expected: 'Báo lỗi tài khoản không tồn tại',
        status: 'FAILED',
        bug: 'BUG-101: Server trả về mã 500 thay vì 400',
        testDate: '2026-09-18',
      );
      final reviewWithBug = TestCaseReviewEngine.reviewRecord(recordWithBug);
      expect(reviewWithBug.issues.any((i) => i.code == 'failed-missing-bug'), isFalse);
    });

    test('attaches hard check findings for naming, empty, and wording', () {
      const record = TestCaseRecord(
        sheet: 'M01',
        id: 'tc01', // Lowercase
        description: 'Mô tả hợp lệ cho chức năng đăng nhập',
        steps: '1. Bước 1\n2. Bước 2',
        expected: 'Kết quả kỳ vọng chi tiết hiển thị đầy đủ thông tin trên màn hình chính',
        status: 'Passed',
        testDate: '2026-09-18',
      );

      final hardChecks = [
        const HardCheckFinding(
          code: 'naming',
          message: 'Mã test case không tuân thủ định dạng TC_XXX: tc01',
        ),
        const HardCheckFinding(
          code: 'wording',
          message: 'Mô tả chứa placeholder hoặc copy-paste',
        ),
      ];

      final review = TestCaseReviewEngine.reviewRecord(
        record,
        attachedHardChecks: hardChecks,
      );
      expect(review.issues.any((i) => i.code == 'naming-inconsistent'), isTrue);
      expect(review.issues.any((i) => i.code == 'hard-check-wording'), isTrue);
    });
  });
}
