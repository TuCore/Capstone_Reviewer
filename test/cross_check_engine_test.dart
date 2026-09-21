import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/extraction/workbook_snapshot.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
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
  group('CrossCheckEngine - Grounded Deterministic Unit Tests', () {
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
      expect(tc06.evidence, isNotNull);
      expect(tc06.evidence!.value, 'TC-NOT-UI-06');

      final tc05 = dupes.firstWhere((d) => d.testId == 'TC-NOT-UI-05');
      expect(tc05.hasStatusConflict, isFalse);
    });

    test('compares 3-way metrics with grounded MetricValue results', () {
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

      expect(comp.wordTotalVal, 320);
      expect(comp.actualTotalVal, 338);
      expect(comp.totalDiscrepancyVal, 18);
      expect(comp.actualFailedVal, 34);
      expect(comp.concealedFailsVal, 34);
      expect(comp.findings.length, greaterThanOrEqualTo(2));
      // Ensure no BIM/M04 fabrication in findings
      expect(comp.findings.any((f) => f.contains('BIM 3D Viewer')), isFalse);
    });

    test('delegates environment mismatch to AI Axis 1 and returns clean empty list in Dart', () {
      final word = 'Cơ sở dữ liệu: PostgreSQL (Supabase)';
      final reg = 'Hạ tầng: Viettel Cloud Private Servers';

      final wbSheet = WorkbookSheet(
        name: 'Cover',
        rows: [
          WorkbookRow(
            rowIndex: 0,
            cells: [
              const WorkbookCell(rowIndex: 0, columnIndex: 0, address: 'A1', kind: CellValueKind.text, text: 'Database'),
              const WorkbookCell(rowIndex: 0, columnIndex: 1, address: 'B1', kind: CellValueKind.text, text: 'Azure SQL Database'),
            ],
          ),
        ],
      );
      final wb = WorkbookSnapshot(sheets: [wbSheet]);

      final mismatches = CrossCheckEngine.checkEnvironmentMismatch(
        wordText: word,
        registrationText: reg,
        workbook: wb,
      );

      // Dart does 0% regex keyword guessing; semantic comparison is delegated to AI Axis 1
      expect(mismatches, isEmpty);
    });

    test('detects timeline conflict between Word milestone and Excel execution date', () {
      final word = 'Final Test Report Approval | 10/08/2026';

      final wbSheet = WorkbookSheet(
        name: 'Cover',
        rows: [
          WorkbookRow(
            rowIndex: 0,
            cells: [
              const WorkbookCell(rowIndex: 0, columnIndex: 0, address: 'A1', kind: CellValueKind.text, text: 'Test Date'),
              const WorkbookCell(rowIndex: 0, columnIndex: 1, address: 'B1', kind: CellValueKind.text, text: '21/08/2026'),
            ],
          ),
        ],
      );
      final wb = WorkbookSnapshot(sheets: [wbSheet]);

      final conflicts = CrossCheckEngine.checkMilestoneDelay(
        wordText: word,
        workbook: wb,
      );

      expect(conflicts.length, 1);
      expect(conflicts.first.isViolated, isTrue);
      expect(conflicts.first.milestoneDeadline, '10/08/2026');
      expect(conflicts.first.testExecutionDate, '21/08/2026');
    });

    test('detects leftover placeholders with evidence', () {
      final records = <TestCaseRecord>[];

      final findings = CrossCheckEngine.checkAdministrativeAndIntegrity(
        records: records,
        wordText: 'Project: [Project Name] by Author Name',
      );

      expect(findings.any((f) => f.code == 'placeholder-leftover'), isTrue);
      final pFinding = findings.firstWhere((f) => f.code == 'placeholder-leftover');
      expect(pFinding.evidence, isNotNull);
    });

    test('TOC check does not misidentify description column as sheet target', () {
      // Reproduction of screenshot bug: row[2] was description 'Uploading Various Formats'
      final tcSheet = WorkbookSheet(
        name: 'Test Cases',
        rows: [
          WorkbookRow(
            rowIndex: 0,
            cells: [
              const WorkbookCell(rowIndex: 0, columnIndex: 0, address: 'A1', kind: CellValueKind.text, text: 'STT'),
              const WorkbookCell(rowIndex: 0, columnIndex: 1, address: 'B1', kind: CellValueKind.text, text: 'Tên Module'),
              const WorkbookCell(rowIndex: 0, columnIndex: 2, address: 'C1', kind: CellValueKind.text, text: 'Mô tả chi tiết'),
            ],
          ),
          WorkbookRow(
            rowIndex: 1,
            cells: [
              const WorkbookCell(rowIndex: 1, columnIndex: 0, address: 'A2', kind: CellValueKind.text, text: '1'),
              const WorkbookCell(rowIndex: 1, columnIndex: 1, address: 'B2', kind: CellValueKind.text, text: 'M01'),
              const WorkbookCell(rowIndex: 1, columnIndex: 2, address: 'C2', kind: CellValueKind.text, text: 'Uploading Various Formats'),
            ],
          ),
        ],
      );

      final wb = WorkbookSnapshot(sheets: [tcSheet]);

      final findings = CrossCheckEngine.checkAdministrativeAndIntegrity(
        records: [],
        workbook: wb,
      );

      // Must NOT create broken-sheet-link for 'Uploading Various Formats'
      expect(findings.any((f) => f.code == 'broken-sheet-link'), isFalse);
    });

    test('TOC check identifies broken sheet link when explicit Sheet Name column points to missing sheet', () {
      final tcSheet = WorkbookSheet(
        name: 'Test Cases',
        rows: [
          WorkbookRow(
            rowIndex: 0,
            cells: [
              const WorkbookCell(rowIndex: 0, columnIndex: 0, address: 'A1', kind: CellValueKind.text, text: 'STT'),
              const WorkbookCell(rowIndex: 0, columnIndex: 1, address: 'B1', kind: CellValueKind.text, text: 'Sheet Name'),
            ],
          ),
          WorkbookRow(
            rowIndex: 1,
            cells: [
              const WorkbookCell(rowIndex: 1, columnIndex: 0, address: 'A2', kind: CellValueKind.text, text: '1'),
              const WorkbookCell(rowIndex: 1, columnIndex: 1, address: 'B2', kind: CellValueKind.text, text: 'Non_Existent_Sheet'),
            ],
          ),
        ],
      );

      final wb = WorkbookSnapshot(sheets: [tcSheet]);

      final findings = CrossCheckEngine.checkAdministrativeAndIntegrity(
        records: [],
        workbook: wb,
      );

      expect(findings.any((f) => f.code == 'broken-sheet-link'), isTrue);
      final bFinding = findings.firstWhere((f) => f.code == 'broken-sheet-link');
      expect(bFinding.evidence, isNotNull);
      expect(bFinding.evidence!.value, 'Non_Existent_Sheet');
    });

    test('detects WIP isolation and Published integrity violations', () {
      final records = [
        testRec(
          sheet: 'M03',
          id: 'TC-DOC-01',
          desc: 'PM can thiệp xóa file trong WIP',
          expected: 'File bị xóa thành công',
        ),
        testRec(
          sheet: 'M03',
          id: 'TC-DOC-02',
          desc: 'User modify file trong Published',
          expected: 'File được sửa đổi thành công',
        ),
      ];

      final findings = CrossCheckEngine.checkAdministrativeAndIntegrity(
        records: records,
      );

      expect(findings.any((f) => f.code == 'wip-isolation-violation'), isTrue);
      expect(findings.any((f) => f.code == 'published-integrity-violation'), isTrue);
    });
  });
}
