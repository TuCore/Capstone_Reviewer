import 'dart:io';

import 'package:capstone_reviewer/core/extraction/file_gate.dart';
import 'package:capstone_reviewer/core/services/excel_service.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:flutter_test/flutter_test.dart';

String fixture(String name) => 'test/fixtures/$name';

void main() {
  test('Q3 answer parses as system test cases with stable ids', () {
    final result = extractExcelSync(fixture('SWT301_PE_Template-Q3_Answer.xlsx'));
    final ids = result.records.map((r) => r.canonicalId).toList();
    expect(result.records, isNotEmpty);
    expect(ids, contains('TC001'));
    expect(result.records.any((r) => r.description.isNotEmpty), isTrue);
    expect(
      result.skippedSheets.any((s) => s.toLowerCase().contains('microsoft.com')),
      isFalse,
    );
  });

  test('UniHome keeps function sheets and lists skipped index sheets', () {
    final result = extractExcelSync(
      fixture('UniHome - TestPlan - Renter Web App.xlsx'),
    );
    final sheets = result.records.map((r) => r.sheet).toSet();
    expect(sheets, contains('Login & Register'));
    expect(sheets, isNot(contains('Test Statistics')));
    expect(
      result.skippedSheets.join(' '),
      contains('Test Statistics'),
    );
    expect(result.records, isNotEmpty);
  });

  test('VCCS cover/report sheets are skipped, function sheets kept', () {
    final result = extractExcelSync(
      fixture('2022.Spring _ VCCS _ Capstone Project _ Test Report.xlsx'),
    );
    final skipped = result.skippedSheets.join(' | ');
    expect(skipped, contains('Cover'));
    expect(skipped, contains('Test Report'));
    expect(result.records, isNotEmpty);
  });

  test('Q1 bug-log sheet is not treated as system test cases', () {
    final result = extractExcelSync(fixture('SWT301_PE_Template-Q1_Answer.xlsx'));
    expect(result.records, isEmpty);
    expect(result.skippedSheets, isNotEmpty);
  });

  test('scenario template is skipped', () {
    final result = extractExcelSync(fixture('TestSceanrioTemplate.xlsx'));
    expect(result.records, isEmpty);
    expect(result.skippedSheets, isNotEmpty);
  });

  test('.xls OLE is rejected per file', () {
    expect(
      () => extractExcelSync(fixture('TestCaseTemplate.xls')),
      throwsA(
        isA<FileRejectedException>().having(
          (e) => e.message,
          'message',
          contains('.xls'),
        ),
      ),
    );
  });

  test('Report5 TestReport extracts M01-M10, skips Test Cases index, parses status', () {
    final reportPath = 'D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/New folder (3)/9747_HCM_SU26SE017_GSU10_HCM_Report5_TestReport.xlsx';
    if (!File(reportPath).existsSync()) return;

    final result = extractExcelSync(reportPath);
    expect(result.records.length, greaterThan(300));
    final sheets = result.records.map((r) => r.sheet).toSet();
    expect(sheets.contains('M01_Authentication'), isTrue);
    expect(sheets.contains('M10_System_Settings'), isTrue);
    expect(sheets.contains('Test Cases'), isFalse);
    expect(sheets.contains('Cover'), isFalse);

    final passed = result.records.where((r) => normalizeStatus(r.status) == 'PASSED').length;
    expect(passed, greaterThan(100));

    final failed = result.records.where((r) => normalizeStatus(r.status) == 'FAILED').length;
    expect(failed, greaterThan(0));
  });

  test('Report5 UnitTest is rejected as unit test file', () {
    final unitTestPath = 'D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/New folder (3)/9747_HCM_SU26SE017_GSU10_HCM_Report5UnitTest.xlsx';
    if (!File(unitTestPath).existsSync()) return;

    expect(
      () => extractExcelSync(unitTestPath),
      throwsA(
        isA<FileRejectedException>().having(
          (e) => e.message,
          'message',
          contains('Unit Test'),
        ),
      ),
    );
  });
}
