import 'dart:io';
import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/document_service.dart';
import 'package:capstone_reviewer/core/services/excel_service.dart';
import 'package:flutter_test/flutter_test.dart';

TestCaseRecord testRec({
  required String sheet,
  required String id,
  String status = 'Passed',
  String desc = 'Test description',
  String steps = 'Step 1',
  String expected = 'Expected result',
}) {
  return TestCaseRecord(
    sheet: sheet,
    id: id,
    status: status,
    description: desc,
    steps: steps,
    expected: expected,
    canonicalId: normalizeCode(id),
    canonicalDescription: canonicalizePhrase(desc),
  );
}

void main() {
  group('CrossCheckEngine - Phase 1 Deterministic Unit Tests', () {
    test('catches duplicate IDs and detects Pass/Fail status conflict', () {
      final records = [
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-05', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-05', status: 'Passed'),
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-06', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-06', status: 'Failed'),
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-07', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-07', status: 'Passed'),
        testRec(sheet: 'M01_Authentication', id: 'TC-AUTH-01', status: 'Passed'),
      ];

      final dupes = CrossCheckEngine.scanDuplicateTestIds(records);
      expect(dupes.length, 3);

      final tc06 = dupes.firstWhere((d) => d.testId == 'TC-NOT-UI-06');
      expect(tc06.hasStatusConflict, isTrue);
      expect(tc06.sheets, containsAll(['M07_Notifications', 'M08_Dashboard_Reports']));
      expect(tc06.statusBySheet['M07_Notifications'], 'PASSED');
      expect(tc06.statusBySheet['M08_Dashboard_Reports'], 'FAILED');

      final tc05 = dupes.firstWhere((d) => d.testId == 'TC-NOT-UI-05');
      expect(tc05.hasStatusConflict, isFalse);
    });

    test('compares 3-way metrics and catches 18 discrepancy and 34 concealed fails', () {
      final records = <TestCaseRecord>[
        for (var i = 1; i <= 304; i++)
          testRec(sheet: 'M01', id: 'TC-$i', status: 'Passed'),
        for (var i = 305; i <= 338; i++)
          testRec(sheet: 'M02', id: 'TC-$i', status: 'Failed'),
      ];

      final wordText = '''
### 5.2. System Testing (E2E) Statistics:
- Total E2E Test Cases: 320
- Automated Passed: 267
- Manual Executed (Passed): 53
- Failed/Blocked: 0 (0%)
''';

      final comp = CrossCheckEngine.compareMetrics(
        records: records,
        wordText: wordText,
      );

      expect(comp.wordTotal, 320);
      expect(comp.actualTotal, 338);
      expect(comp.totalDiscrepancy, 18);
      expect(comp.actualFailed, 34);
      expect(comp.concealedFails, 34);
      expect(comp.actualManual, 71); // 338 - 267
      expect(comp.manualDiscrepancy, 18); // 71 - 53
      expect(comp.findings.length, greaterThanOrEqualTo(3));
    });

    test('detects environment mismatch across Word, Excel, and Registration', () {
      final word = 'Database Environment: PostgreSQL (Supabase)';
      final excel = 'Test Environment: Azure SQL Database';
      final reg = 'Infrastructure: Viettel Cloud Private Servers';

      final mismatches = CrossCheckEngine.checkEnvironmentMismatch(
        wordText: word,
        excelText: excel,
        registrationText: reg,
      );

      expect(mismatches.length, 1);
      expect(mismatches.first.category, contains('Database'));
      expect(mismatches.first.wordValue, 'PostgreSQL (Supabase)');
      expect(mismatches.first.excelValue, 'Azure SQL Database');
      expect(mismatches.first.registrationValue, contains('Viettel Cloud'));
    });

    test('detects timeline conflict between Word milestone and Excel execution date', () {
      final word = 'Final Test Report Approval | 03/08/2026 | 10/08/2026';
      final excel = 'Cover sheet updated on 2026-08-21T00:00:00.000Z version 1.0';

      final conflicts = CrossCheckEngine.checkMilestoneDelay(
        wordText: word,
        excelText: excel,
      );

      expect(conflicts.length, 1);
      expect(conflicts.first.isViolated, isTrue);
      expect(conflicts.first.milestoneDeadline, '10/08/2026');
      expect(conflicts.first.testExecutionDate, '21/08/2026');
    });

    test('detects copy-paste requirement and leftover placeholders', () {
      final records = <TestCaseRecord>[];
      final rawSheets = {
        'M08_Dashboard_Reports': [
          ['Test requirement', 'Verify that all dashboard widgets render correctly.'],
        ],
        'M09_User_Role_Permissions': [
          ['Test requirement', 'Verify that all dashboard widgets render correctly.'],
        ],
      };

      final findings = CrossCheckEngine.checkAdministrativeAndIntegrity(
        records: records,
        wordText: 'Project: [Project Name] by Author Name',
        rawSheets: rawSheets,
      );

      expect(findings.any((f) => f.code == 'copy-paste-requirement'), isTrue);
      expect(findings.any((f) => f.code == 'placeholder-leftover'), isTrue);
    });

    test('golden run on real Report5 files when available', () {
      final excelPath = 'D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/New folder (3)/9747_HCM_SU26SE017_GSU10_HCM_Report5_TestReport.xlsx';
      final docxPath = 'D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/New folder (3)/9747_HCM_SU26SE017_GSU10_HCM_Report5.docx';
      final regPath = 'D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/New folder (3)/9747_HCM_SU26SE017_GSU10_HCM_SU26SE017_GSU26SE10_Projects.pdf';

      if (!File(excelPath).existsSync() || !File(docxPath).existsSync()) return;

      final excelResult = extractExcelSync(excelPath);
      final docResult = extractDocumentSync(docxPath);
      String? regText;
      if (File(regPath).existsSync()) {
        regText = extractDocumentSync(regPath).text;
      }

      final result = CrossCheckEngine.run(
        records: excelResult.records,
        wordText: docResult.text,
        excelText: excelResult.text,
        registrationText: regText,
        rawSheets: excelResult.rawSheets,
      );

      expect(result.duplicateIds.length, greaterThanOrEqualTo(3));
      expect(result.duplicateIds.any((d) => d.testId == 'TC-NOT-UI-06' && d.hasStatusConflict), isTrue);

      expect(result.metricsComparison.totalDiscrepancy, 18);
      expect(result.metricsComparison.concealedFails, 34);

      expect(result.environmentMismatches, isNotEmpty);
      expect(result.timelineConflicts, isNotEmpty);
      expect(result.integrityFindings.any((f) => f.code == 'copy-paste-requirement'), isTrue);

      final md = result.toMarkdown();
      expect(md, contains('TC-NOT-UI-06'));
      expect(md, contains('PostgreSQL (Supabase)'));
      expect(md, contains('Azure SQL Database'));
      expect(md, contains('18 ca'));
      expect(md, contains('34 ca FAILED'));
    });
  });
}
