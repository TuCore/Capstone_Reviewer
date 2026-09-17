import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/excel_export_service.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

TestCaseRecord testRec({
  required String sheet,
  required String id,
  String status = 'Passed',
}) {
  return TestCaseRecord(
    sheet: sheet,
    id: id,
    status: status,
    description: 'Desc',
    steps: 'Step',
    expected: 'Expected',
    canonicalId: normalizeCode(id),
    canonicalDescription: canonicalizePhrase('Desc'),
  );
}

void main() {
  group('Dual Report Exporters - Phase 3 Unit Tests', () {
    test('ExcelExportService builds 5 sheets with 4-part structured layout', () {
      final records = [
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-05', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-05', status: 'Passed'),
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-06', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-06', status: 'Failed'),
        testRec(sheet: 'M07_Notifications', id: 'TC-NOT-UI-07', status: 'Passed'),
        testRec(sheet: 'M08_Dashboard_Reports', id: 'TC-NOT-UI-07', status: 'Passed'),
      ];

      final stats = computeCoverage(
        srsText: '## Auth\n## Project\n## Document\n',
        records: records,
        unknownModules: const [],
      );

      final crossCheck = CrossCheckEngine.run(
        records: records,
        wordText: '''
### 5.2. System Testing (E2E) Statistics:
- Total E2E Test Cases: 320
- Automated Passed: 267
- Manual Executed (Passed): 53
- Failed/Blocked: 0 (0%)
Final Test Report Approval | 03/08/2026 | 10/08/2026
Database Environment | PostgreSQL (Supabase)
''',
        excelText: '''
Test Environment: Azure SQL Database
Cover updated 2026-08-21T00:00:00.000Z
''',
      );

      final verifiedFindings = [
        const VerifiedFinding(
          id: '1',
          module: 'M03',
          claim: 'Thiếu kiểm thử WIP Isolation',
          isVerified: true,
          quote: 'Only Creator can delete files in WIP area',
          explanation: 'Quy định trong SRS mục 3.2',
        ),
      ];

      final bytes = ExcelExportService().buildWorkbook(
        stats: stats,
        checks: [
          const HardCheckFinding(code: 'empty', message: 'Thiếu bước kiểm thử', identity: 'M01|x'),
        ],
        records: records,
        reviewMarkdown: '# Báo cáo đánh giá AI\n\nNội dung chi tiết...',
        crossCheck: crossCheck,
        verifiedFindings: verifiedFindings,
      );

      expect(bytes, isNotEmpty);
      final excel = Excel.decodeBytes(bytes);

      // Verify all 5 sheets exist
      expect(excel.tables.containsKey('Tong_quan'), isTrue);
      expect(excel.tables.containsKey('Doi_chieu_so_lieu'), isTrue);
      expect(excel.tables.containsKey('Hard_checks'), isTrue);
      expect(excel.tables.containsKey('Danh_gia_AI'), isTrue);
      expect(excel.tables.containsKey('Test_cases'), isTrue);

      // Check Sheet Tong_quan (Part 1)
      final tqRows = excel.tables['Tong_quan']!.rows.map((r) => r.map((c) => c?.value?.toString() ?? '').join(' ')).join('\n');
      expect(tqRows, contains('THÔNG TIN BÌA'));
      expect(tqRows, contains('SU26SE017'));

      // Check Sheet Doi_chieu_so_lieu (Part 2)
      final dcRows = excel.tables['Doi_chieu_so_lieu']!.rows.map((r) => r.map((c) => c?.value?.toString() ?? '').join(' ')).join('\n');
      expect(dcRows, contains('BẢNG ĐỐI CHIẾU SỐ LIỆU 3 NGUỒN'));
      expect(dcRows, contains('Word (Report5 §5.2)'));
      expect(dcRows, contains('Excel (Test Statistics)'));
      expect(dcRows, contains('Đếm Thực Tế'));
      expect(dcRows, contains('PostgreSQL (Supabase)'));
      expect(dcRows, contains('Azure SQL Database'));

      // Check Sheet Hard_checks (Part 3)
      final hcRows = excel.tables['Hard_checks']!.rows.map((r) => r.map((c) => c?.value?.toString() ?? '').join(' ')).join('\n');
      expect(hcRows, contains('TC-NOT-UI-06'));
      expect(hcRows, contains('CRITICAL'));
      expect(hcRows, contains('MÂU THUẪN'));

      // Check Sheet Danh_gia_AI (Part 4)
      final aiRows = excel.tables['Danh_gia_AI']!.rows.map((r) => r.map((c) => c?.value?.toString() ?? '').join(' ')).join('\n');
      expect(aiRows, contains('HÀNH ĐỘNG KHUYẾN NGHỊ'));
      expect(aiRows, contains('1. Khắc phục'));
      expect(aiRows, contains('WIP Isolation'));
      expect(aiRows, contains('Only Creator can delete files in WIP area'));
    });
  });
}
