import '../extraction/test_case_schema.dart';
import 'cross_check_engine.dart';
import 'hard_checks.dart';

enum TestCaseIssueSeverity {
  critical,
  high,
  medium,
  low,
  info,
}

enum ReviewedField {
  id,
  description,
  preCondition,
  steps,
  testData,
  expected,
  status,
  testDate,
  note,
  bug,
  record,
}

class TestCaseIssue {
  final String code;
  final ReviewedField field;
  final TestCaseIssueSeverity severity;
  final String message;
  final String evidence;
  final String correction;

  const TestCaseIssue({
    required this.code,
    required this.field,
    required this.severity,
    required this.message,
    required this.evidence,
    required this.correction,
  });
}

class TestCaseReview {
  final TestCaseRecord record;
  final List<TestCaseIssue> issues;

  const TestCaseReview({
    required this.record,
    required this.issues,
  });

  bool get hasIssues => issues.isNotEmpty;

  TestCaseIssueSeverity? get highestSeverity {
    if (issues.isEmpty) return null;
    var highest = TestCaseIssueSeverity.info;
    for (final issue in issues) {
      if (issue.severity.index < highest.index) {
        highest = issue.severity;
      }
    }
    return highest;
  }

  String get verdictLabel {
    final s = highestSeverity;
    if (s == null) return 'Không phát hiện lỗi theo rule deterministic';
    switch (s) {
      case TestCaseIssueSeverity.critical:
        return 'Lỗi nghiêm trọng';
      case TestCaseIssueSeverity.high:
        return 'Cần sửa đổi';
      case TestCaseIssueSeverity.medium:
        return 'Cần xem lại';
      case TestCaseIssueSeverity.low:
        return 'Góp ý hoàn thiện';
      case TestCaseIssueSeverity.info:
        return 'Thông tin bổ sung';
    }
  }
}

class TestCaseReviewEngine {
  /// Evaluates every record deterministically, preserving exact 1-to-1 mapping and order.
  static List<TestCaseReview> reviewAll({
    required List<TestCaseRecord> records,
    List<HardCheckFinding> hardChecks = const [],
    List<DuplicateIdFinding> duplicateFindings = const [],
  }) {
    // Index hard checks by identity for fast lookup
    final hardCheckMap = <String, List<HardCheckFinding>>{};
    for (final hc in hardChecks) {
      if (hc.identity.isNotEmpty) {
        hardCheckMap.putIfAbsent(hc.identity, () => []).add(hc);
      }
    }

    // Index duplicate findings by normalized/canonical ID
    final duplicateMap = <String, DuplicateIdFinding>{};
    for (final df in duplicateFindings) {
      final key = normalizeCode(df.testId);
      if (key.isNotEmpty) {
        duplicateMap[key] = df;
      }
    }

    return records.map((record) {
      return reviewRecord(
        record,
        attachedHardChecks: hardCheckMap[caseIdentity(record)] ?? const [],
        duplicateFinding: duplicateMap[record.canonicalId.isNotEmpty
                ? record.canonicalId
                : normalizeCode(record.id)],
      );
    }).toList();
  }

  static TestCaseReview reviewRecord(
    TestCaseRecord record, {
    List<HardCheckFinding> attachedHardChecks = const [],
    DuplicateIdFinding? duplicateFinding,
  }) {
    final issues = <TestCaseIssue>[];

    // -------------------------------------------------------------
    // 1. Required / Completeness Rules
    // -------------------------------------------------------------
    final idTrimmed = record.id.trim();
    if (idTrimmed.isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'missing-id',
        field: ReviewedField.id,
        severity: TestCaseIssueSeverity.critical,
        message: 'Thiếu mã Test Case ID',
        evidence: 'id=""',
        correction: 'Bổ sung mã định danh duy nhất (ví dụ: TC01, TC_LOGIN_01) cho ca kiểm thử',
      ));
    }

    final descTrimmed = record.description.trim();
    if (descTrimmed.isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'missing-description',
        field: ReviewedField.description,
        severity: TestCaseIssueSeverity.high,
        message: 'Thiếu mô tả test case',
        evidence: 'description=""',
        correction: 'Mô tả rõ ràng hành vi hoặc kịch bản cần kiểm thử',
      ));
    }

    final stepsTrimmed = record.steps.trim();
    final expectedTrimmed = record.expected.trim();

    if (stepsTrimmed.isEmpty && expectedTrimmed.isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'empty-procedure',
        field: ReviewedField.record,
        severity: TestCaseIssueSeverity.critical,
        message: 'Thiếu cả các bước thực hiện và kết quả mong đợi (Test case rỗng)',
        evidence: 'steps="", expected=""',
        correction: 'Bổ sung đầy đủ các bước thực hiện và kết quả kỳ vọng tương ứng',
      ));
    } else if (stepsTrimmed.isEmpty && expectedTrimmed.isNotEmpty) {
      issues.add(const TestCaseIssue(
        code: 'missing-steps',
        field: ReviewedField.steps,
        severity: TestCaseIssueSeverity.high,
        message: 'Có kết quả mong đợi nhưng không có các bước thực hiện',
        evidence: 'steps=""',
        correction: 'Bổ sung các bước thao tác cụ thể (Step 1, Step 2,...) để kiểm thử viên có thể tái hiện',
      ));
    } else if (stepsTrimmed.isNotEmpty && expectedTrimmed.isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'missing-expected',
        field: ReviewedField.expected,
        severity: TestCaseIssueSeverity.critical,
        message: 'Có các bước thực hiện nhưng thiếu kết quả mong đợi',
        evidence: 'expected=""',
        correction: 'Ghi rõ kết quả hệ thống phải trả về để làm căn cứ xác định Pass/Fail',
      ));
    }

    // Optional field guidance (info-level unless template strictly requires)
    if (record.preCondition.trim().isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'info-precondition',
        field: ReviewedField.preCondition,
        severity: TestCaseIssueSeverity.info,
        message: 'Chưa khai báo điều kiện tiên quyết (Pre-condition)',
        evidence: 'preCondition=""',
        correction: 'Nên ghi rõ trạng thái hệ thống hoặc quyền tài khoản cần có trước khi thực hiện',
      ));
    }

    if (record.testData.trim().isEmpty) {
      issues.add(const TestCaseIssue(
        code: 'info-testdata',
        field: ReviewedField.testData,
        severity: TestCaseIssueSeverity.info,
        message: 'Chưa khai báo dữ liệu kiểm thử (Test Data)',
        evidence: 'testData=""',
        correction: 'Nên cung cấp dữ liệu đầu vào mẫu (chuỗi, số, tài khoản, file mẫu...)',
      ));
    }

    // -------------------------------------------------------------
    // 2. Clarity / Testability Rules
    // -------------------------------------------------------------
    if (descTrimmed.isNotEmpty && expectedTrimmed.isNotEmpty) {
      final wordingScore = scoreWording(record);
      switch (wordingScore) {
        case 'mơ hồ':
          issues.add(TestCaseIssue(
            code: 'vague-expected',
            field: ReviewedField.expected,
            severity: TestCaseIssueSeverity.high,
            message: 'Kết quả mong đợi mơ hồ, dùng từ chung chung (đúng/tốt/hợp lệ/ok)',
            evidence: record.expected,
            correction: 'Thay bằng tiêu chí đo lường cụ thể: mã HTTP, thông báo trên UI, hoặc trạng thái bản ghi DB',
          ));
          break;
        case 'trộn nhiều ý':
          issues.add(TestCaseIssue(
            code: 'mixed-expected',
            field: ReviewedField.expected,
            severity: TestCaseIssueSeverity.medium,
            message: 'Kết quả mong đợi gộp quá nhiều ý hoặc quá dài (>160 ký tự kèm "và")',
            evidence: record.expected,
            correction: 'Nên tách thành các test case độc lập tương ứng với từng kết quả kỳ vọng',
          ));
          break;
        case 'kết luận thiếu bằng chứng':
          issues.add(TestCaseIssue(
            code: 'insufficient-evidence',
            field: ReviewedField.expected,
            severity: TestCaseIssueSeverity.medium,
            message: 'Kết quả mong đợi quá ngắn (<8 ký tự), thiếu tiêu chí kiểm chứng',
            evidence: record.expected,
            correction: 'Mô tả rõ ràng kết quả quan sát được thay vì chỉ ghi kết luận cộc lốc',
          ));
          break;
      }
    }

    // -------------------------------------------------------------
    // 3. Identity & Hard Check Findings Attachment
    // -------------------------------------------------------------
    for (final hc in attachedHardChecks) {
      switch (hc.code) {
        case 'sheet-type':
          issues.add(TestCaseIssue(
            code: 'unit-test-type',
            field: ReviewedField.record,
            severity: TestCaseIssueSeverity.high,
            message: hc.message,
            evidence: 'ID: ${record.id}, Sheet: ${record.sheet}',
            correction: 'Chuyển ca kiểm thử này sang tài liệu Unit Test hoặc đổi mã định danh phù hợp với System Test',
          ));
          break;
        case 'duplicate':
          issues.add(TestCaseIssue(
            code: 'exact-duplicate',
            field: ReviewedField.record,
            severity: TestCaseIssueSeverity.critical,
            message: hc.message,
            evidence: '${record.sheet}:${record.id}',
            correction: 'Loại bỏ hoặc hợp nhất dòng test case trùng lặp nguyên văn để tránh sai lệch số liệu',
          ));
          break;
        case 'naming':
          issues.add(TestCaseIssue(
            code: 'naming-inconsistent',
            field: ReviewedField.description,
            severity: TestCaseIssueSeverity.medium,
            message: hc.message,
            evidence: record.description,
            correction: 'Chuẩn hóa thống nhất tên gọi và thuật ngữ giữa các tài liệu',
          ));
          break;
      }
    }

    if (duplicateFinding != null) {
      if (duplicateFinding.hasStatusConflict) {
        issues.add(TestCaseIssue(
          code: 'duplicate-id-conflict',
          field: ReviewedField.id,
          severity: TestCaseIssueSeverity.critical,
          message: 'Trùng mã ID giữa các sheet với trạng thái đối nghịch: ${duplicateFinding.message}',
          evidence: 'ID: ${duplicateFinding.testId}, Sheet: ${record.sheet}, Status: ${record.status}',
          correction: 'Đổi mã ID riêng biệt hoặc đồng nhất trạng thái thực thi giữa các sheet',
        ));
      } else {
        issues.add(TestCaseIssue(
          code: 'duplicate-id',
          field: ReviewedField.id,
          severity: TestCaseIssueSeverity.high,
          message: 'Trùng lặp mã Test Case ID ở nhiều vị trí: ${duplicateFinding.message}',
          evidence: 'ID: ${duplicateFinding.testId}, Sheet: ${record.sheet}',
          correction: 'Gán mã Test Case ID duy nhất cho mỗi ca kiểm thử trong toàn bộ dự án',
        ));
      }
    }

    // -------------------------------------------------------------
    // 4. Execution Metadata Consistency
    // -------------------------------------------------------------
    final statusTrimmed = record.status.trim();
    if (statusTrimmed.isNotEmpty) {
      final normalizedSt = normalizeStatus(statusTrimmed);

      // Failed test case without defect reference
      if (normalizedSt == 'failed' || statusTrimmed.toLowerCase().contains('fail')) {
        if (record.bug.trim().isEmpty && record.note.trim().isEmpty) {
          issues.add(TestCaseIssue(
            code: 'failed-missing-bug',
            field: ReviewedField.bug,
            severity: TestCaseIssueSeverity.medium,
            message: 'Test case có trạng thái FAILED nhưng chưa ghi nhận mã Bug/Defect hoặc ghi chú lỗi',
            evidence: 'status="$statusTrimmed", bug="", note=""',
            correction: 'Bổ sung mã Bug (Defect ID trên Jira/GitHub Issues) hoặc mô tả lỗi phát sinh vào cột Bug/Note',
          ));
        }
      }

      // Unknown or non-canonical execution status
      const standardStatuses = {'PASSED', 'FAILED', 'Not Run', 'Untested', 'N/A'};
      if (!standardStatuses.contains(normalizedSt)) {
        issues.add(TestCaseIssue(
          code: 'unknown-status',
          field: ReviewedField.status,
          severity: TestCaseIssueSeverity.low,
          message: 'Trạng thái kiểm thử không theo chuẩn quy ước (Passed/Failed/Untested/Blocked/Skipped): "$statusTrimmed"',
          evidence: statusTrimmed,
          correction: 'Chuẩn hóa giá trị trạng thái về Passed, Failed, Untested, Blocked hoặc Skipped',
        ));
      }

      // Executed test case missing execution date
      final isExecuted = normalizedSt == 'passed' ||
          normalizedSt == 'failed' ||
          statusTrimmed.toLowerCase().contains('pass') ||
          statusTrimmed.toLowerCase().contains('fail');
      if (isExecuted && record.testDate.trim().isEmpty) {
        issues.add(TestCaseIssue(
          code: 'executed-missing-date',
          field: ReviewedField.testDate,
          severity: TestCaseIssueSeverity.info,
          message: 'Ca kiểm thử đã thực thi nhưng chưa ghi nhận ngày kiểm thử (Test Date)',
          evidence: 'status="$statusTrimmed", testDate=""',
          correction: 'Ghi rõ ngày thực thi kiểm thử để theo dõi tiến độ và đối soát mốc thời gian',
        ));
      }
    }

    // Sort issues by severity: critical (0) first, then high, medium, low, info
    issues.sort((a, b) => a.severity.index.compareTo(b.severity.index));

    return TestCaseReview(
      record: record,
      issues: List.unmodifiable(issues),
    );
  }
}
