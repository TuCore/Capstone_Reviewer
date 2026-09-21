
import 'package:capstone_reviewer/core/extraction/file_gate.dart';
import 'package:capstone_reviewer/core/services/excel_service.dart';
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

}
