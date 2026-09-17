import 'package:capstone_reviewer/core/extraction/file_gate.dart';
import 'package:capstone_reviewer/core/extraction/sheet_classifier.dart';
import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/excel_service.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps sheets with test-case columns regardless of sheet name', () {
    final verdict = classifySheet(
      name: 'M01',
      rows: [
        ['ID', 'Description', 'Steps', 'Expected Output'],
        ['TC001', 'Login success', '1. Open app', 'Home'],
      ],
    );
    expect(verdict.keep, isTrue);
    expect(verdict.columns[CanonicalField.id], 0);
  });

  test('skips cover, statistics, scenario, and unit-bug sheets', () {
    expect(
      classifySheet(
        name: 'Cover',
        rows: [
          ['Project Name', 'UniHome'],
          ['Version', '1.0'],
        ],
      ).keep,
      isFalse,
    );
    expect(
      classifySheet(
        name: 'Test Statistics',
        rows: [
          ['Module code', 'Pass', 'Fail'],
          ['M01', '10', '1'],
        ],
      ).keep,
      isFalse,
    );
    expect(
      classifySheet(
        name: 'Sheet1',
        rows: [
          ['Test Scenario #', 'Requirement ID', 'Test Scenario Description'],
          ['S1.1', 'REQ-1', 'Check login'],
        ],
      ).keep,
      isFalse,
    );
    expect(
      classifySheet(
        name: 'Q1',
        rows: [
          ['Issue No', 'Description', 'Detail'],
          ['1', 'Missing modifier', 'class should be public'],
        ],
      ).keep,
      isFalse,
    );
  });

  test('weird sheet names still classify by content', () {
    final result = extractExcelFromRows({
      '🐱 random': [
        ['hello', 'world'],
      ],
      'M01_Login': [
        ['Test Case ID', 'Test Case Description', 'Test Case Procedure', 'Expected Results'],
        ['tc_001', 'PM đăng nhập', '1. Enter password', 'Dashboard'],
      ],
    });
    expect(result.records.length, 1);
    expect(result.records.single.canonicalId, 'TC-001');
    expect(result.records.single.canonicalDescription, contains('login'));
    expect(result.skippedSheets.single, contains('🐱 random'));
  });

  test('skips index sheet Test Cases without steps/expected', () {
    final verdict = classifySheet(
      name: 'Test Cases',
      rows: [
        ['No', 'Function Name', 'Sheet Name', 'Description', 'Pre-Condition'],
        ['1', 'Login & Security', 'M01_Authentication', 'E2E scenarios covering Login', 'System deployed'],
      ],
    );
    expect(verdict.keep, isFalse);
    expect(verdict.skipReason, contains('sheet mục lục'));
  });

  test('recognizes Round 1 column as status and extracts PASSED', () {
    final result = extractExcelFromRows({
      'M01_Auth': [
        ['Test Case ID', 'Test Case Description', 'Test Case Procedure', 'Expected Results', 'Round 1'],
        ['TC_001', 'Verify login', '1. Enter credentials', 'Dashboard loaded', 'Passed'],
        ['TC_002', 'Verify wrong pass', '1. Enter wrong pass', 'Error displayed', 'Failed'],
        ['TC_003', 'Verify pending', '1. Enter email', 'OTP sent', 'Pending'],
      ],
    });
    expect(result.records.length, 3);
    expect(result.records[0].status, 'Passed');
    expect(normalizeStatus(result.records[0].status), 'PASSED');
    expect(normalizeStatus(result.records[1].status), 'FAILED');
    expect(normalizeStatus(result.records[2].status), 'Untested');
  });

  test('rejects UnitTest workbook with functions sheet or F prefix', () {
    expect(
      () => extractExcelFromRows({
        'Cover': [['Title', 'Unit Test']],
        'Functions': [['FuncID', 'Name']],
        'F01_Login': [['Test', 'Case']],
      }),
      throwsA(isA<FileRejectedException>()),
    );
  });
}
