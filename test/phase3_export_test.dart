import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';
import 'package:capstone_reviewer/core/services/excel_export_service.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:capstone_reviewer/core/services/pdf_export_service.dart';
import 'package:capstone_reviewer/core/services/registration_pii.dart';
import 'package:capstone_reviewer/core/services/test_case_review_engine.dart';
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
        registrationContext: const RegistrationContext(
          topic: 'Custom Capstone Project',
          description: 'Custom Description',
        ),
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
      expect(tqRows, contains('Custom Capstone Project'));
      expect(tqRows, isNot(contains('SU26SE017')));

      // Check Sheet Doi_chieu_so_lieu (Part 2)
      final dcRows = excel.tables['Doi_chieu_so_lieu']!.rows.map((r) => r.map((c) => c?.value?.toString() ?? '').join(' ')).join('\n');
      expect(dcRows, contains('BẢNG ĐỐI CHIẾU SỐ LIỆU 3 NGUỒN'));
      expect(dcRows, isNot(contains('Report5')));
      expect(dcRows, contains('Đếm Thực Tế'));
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

    test('ExcelExportService includes detailed test case review columns when caseReviews are provided', () {
      final records = [
        testRec(sheet: 'M01', id: 'TC01', status: 'Passed'),
        const TestCaseRecord(
          sheet: 'M01',
          id: '',
          description: '',
          steps: '',
          expected: '',
        ),
      ];

      final caseReviews = TestCaseReviewEngine.reviewAll(records: records);
      final bytes = ExcelExportService().buildWorkbook(
        stats: computeCoverage(srsText: '', records: records, unknownModules: const []),
        checks: const [],
        records: records,
        caseReviews: caseReviews,
        reviewMarkdown: '# Review',
      );

      final excel = Excel.decodeBytes(bytes);
      expect(excel.tables.containsKey('Test_cases'), isTrue);
      final tcSheet = excel.tables['Test_cases']!;

      // Check header columns
      final headers = tcSheet.rows.first.map((c) => c?.value?.toString() ?? '').toList();
      expect(headers, contains('Đánh giá chất lượng'));
      expect(headers, contains('Số lỗi'));
      expect(headers, contains('Mã lỗi phát hiện'));
      expect(headers, contains('Trường vi phạm'));
      expect(headers, contains('Chi tiết lỗi & Hướng khắc phục'));

      // Row 1 (TC01 - clean or info)
      final row1 = tcSheet.rows[1].map((c) => c?.value?.toString() ?? '').toList();
      expect(row1[0], equals('M01'));
      expect(row1[1], equals('TC01'));

      // Row 2 (incomplete - critical)
      final row2 = tcSheet.rows[2].map((c) => c?.value?.toString() ?? '').toList();
      expect(row2[6], equals('Lỗi nghiêm trọng'));
      expect(row2[8], contains('missing-id'));
    });

    test('PdfExportService sanitizes emojis and renders inline markdown without crashing', () async {
      const markdown = '''
# BÁO CÁO ĐÁNH GIÁ ĐỒ ÁN CAPSTONE: SRS ⟷ TEST REPORT

## 📋 PHẦN 1: THÔNG TIN BÌA & THIẾT LẬP MÔI TRƯỜNG
- **Tên đề tài:** Design & Implementation of a CDE System for BIM
- **Mã dự án:** SU26SE017 (GSU10)
- **Cơ sở dữ liệu:** Azure SQL Database (Excel) vs PostgreSQL (Word)

## 🔬 KẾT QUẢ ĐỐI CHIẾU SỐ HỌC & TÍNH NHẤT QUÁN (DETERMINISTIC CODE ENGINE)
*Toàn bộ kết quả tính toán 100% bằng code thuần, không qua AI.*

| Chỉ Số | SRS (Word) | Khai Báo (Excel) | Đếm Thực (Excel) | Lệch (SRS vs Thực) | Lệch (Khai báo vs Thực) |
|---|---|---|---|---|---|
| **Tổng số ca** | 320 | N/A | 338 | 18 | N/A |
| **Passed** | N/A | N/A | 304 | N/A | N/A |
| `TC-NOT-UI-05` | M07, M08 | M07: **PASSED**<br>M08: **PASSED** | Đồng nhất | N/A | N/A |
''';

      // Sanitizer check
      final sanitizedHeader = PdfExportService.sanitizeText('## 📋 PHẦN 1: THÔNG TIN BÌA \x07 & THIẾT LẬP MÔI TRƯỜNG');
      expect(sanitizedHeader.contains('📋'), isFalse);
      expect(sanitizedHeader.contains('\x07'), isFalse);
      expect(sanitizedHeader, contains('PHẦN 1: THÔNG TIN BÌA'));

      // Document build check
      final pdf = PdfExportService.buildPdfDocument(markdown);
      final bytes = await pdf.save();
      expect(bytes.isNotEmpty, isTrue);
      expect(String.fromCharCodes(bytes.take(5)), equals('%PDF-'));
    });
    test('ExcelExportService prevents formula injection by emitting TextCellValue for leading =, +, -, @', () {
      final records = [
        testRec(sheet: 'M01', id: 'TC01', status: '=1+1'),
        testRec(sheet: 'M01', id: 'TC02', status: '+cmd|/C calc'),
        testRec(sheet: 'M01', id: 'TC03', status: '-10'),
        testRec(sheet: 'M01', id: 'TC04', status: '@SUM(1,2)'),
      ];

      final bytes = ExcelExportService().buildWorkbook(
        stats: computeCoverage(srsText: '', records: records, unknownModules: const []),
        checks: const [],
        records: records,
        reviewMarkdown: '# Safe Markdown',
      );

      final excel = Excel.decodeBytes(bytes);
      final tcSheet = excel.tables['Test_cases']!;

      for (final row in tcSheet.rows) {
        for (final cell in row) {
          if (cell?.value != null) {
            expect(cell!.value, isA<TextCellValue>());
            expect(cell.value, isNot(isA<FormulaCellValue>()));
          }
        }
      }
    });
  });
}
