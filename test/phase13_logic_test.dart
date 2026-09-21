import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/api_key_format.dart';
import 'package:excel/excel.dart';
import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/excel_export_service.dart';
import 'package:capstone_reviewer/core/services/hard_checks.dart';
import 'package:capstone_reviewer/core/services/quote_guard.dart';
import 'package:capstone_reviewer/core/services/registration_pii.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_reviewer/core/services/cross_check_engine.dart';

TestCaseRecord rec({
  String sheet = 'Login',
  String id = 'TC-1',
  String description = 'PM đăng nhập thành công',
  String steps = '1. Open',
  String expected = 'Dashboard hiện tên PM',
  String status = 'Passed',
}) {
  return TestCaseRecord(
    sheet: sheet,
    id: id,
    description: description,
    steps: steps,
    expected: expected,
    status: status,
    canonicalId: normalizeCode(id),
    canonicalDescription: canonicalizePhrase(description),
  );
}

void main() {
  test('key format binds to provider', () {
    expect(ApiKeyFormat.errorFor(AIProvider.gemini, 'AIzaSyDummyKeyValue12345678'), isNull);
    expect(ApiKeyFormat.errorFor(AIProvider.gemini, 'AQ.AbCdEfGhIjKlMnOpQrStUv'), isNull);
    expect(ApiKeyFormat.errorFor(AIProvider.gemini, 'sk-abc'), contains('OpenAI'));
    expect(ApiKeyFormat.errorFor(AIProvider.claude, 'sk-ant-abc12345678901234'), isNull);
    expect(ApiKeyFormat.errorFor(AIProvider.chatgpt, 'sk-ant-abc'), contains('OpenAI'));
    expect(ApiKeyFormat.mask('AIzaSyDummyKeyValue12345678'), isNot(contains('Dummy')));
    expect(ApiKeyFormat.redact('bad AIzaSyDummyKeyValue12345678', 'AIzaSyDummyKeyValue12345678'), contains('***'));
  });

  test('hard checks catch duplicate and empty expected', () {
    final dup = rec();
    final empty = rec(id: 'TC-2', expected: '', steps: '');
    final findings = runHardChecks(
      records: [dup, dup, empty],
      skippedSheets: ['Q1_Unit test-case (không có cột)'],
    );
    expect(findings.any((f) => f.code == 'duplicate'), isTrue);
    expect(findings.any((f) => f.code == 'empty'), isTrue);
    expect(findings.any((f) => f.code == 'sheet-type'), isTrue);
  });

  test('identity ignores UC/TC code and merges login synonyms', () {
    final a = rec(id: 'UC01-TC01', description: 'PM đăng nhập');
    final b = rec(id: 'ZZ-99', description: 'PM login');
    expect(caseIdentity(a).split('|').last, caseIdentity(b).split('|').last);
    expect(caseIdentity(a).contains('UC01'), isFalse);
  });

  test('coverage excludes UNKNOWN from denominator and still lists them', () {
    final stats = computeCoverage(
      srsText: '## Auth\n## Payment\n',
      records: [rec(description: 'Auth login')],
      unknownModules: ['Payment'],
    );
    expect(stats.readUseCases, ['Auth']);
    expect(stats.unknownModules, ['Payment']);
    expect(stats.coverage, 1);
    expect(stats.toMarkdown(), contains('UNKNOWN'));
    expect(stats.toMarkdown(), contains('Payment'));
  });

  test('quote guard drops invented quotes', () {
    const source = 'User opens the login page and enters password.';
    const ai = 'The SRS says "teleport instantly to Mars base alpha".';
    final result = stripHallucinatedQuotes(ai, [source]);
    expect(result.text.contains('teleport instantly to Mars base alpha'), isFalse);
    expect(result.removed, isNotEmpty);
  });

  test('registration strips email MSSV phone, keeps topic', () {
    final ctx = extractRegistrationContext(
      'Tên đề tài: UniHome\nSV: SE123456 email a@b.com sdt 0912345678 mô tả thuê phòng',
    );
    expect(ctx.topic, 'UniHome');
    expect(ctx.toPromptBlock(), isNot(contains('a@b.com')));
    expect(ctx.toPromptBlock(), isNot(contains('SE123456')));
    expect(ctx.toPromptBlock(), isNot(contains('0912345678')));
  });

  test('registration extracts multi-field Capstone project name and targeted description', () {
    const raw = '''
CAPSTONE PROJECT REGISTER
Class: Duration time: from 11/05/2026 To 06/09/2026
1. Register information for supervisor (if have)
No. Fullname Phone E-Mail Title Supervisor
1 Lâm Hữu Khánh Phương
2. Register information for students (if have)
Full name Student code Phone E-mail Role in Group
1 Lê Thị Hải Hà SE160001 ha@fpt.edu.vn 0901234567 Team Leader
3. Register content of Capstone Project (*)
3.1. Capstone Project name: \x07English: Design and Implementation of a CDE System \x07Vietnamese: Thiết kế và phát triển hệ thống CDE \x07Abbreviation: SU26SE017
a. Context: In the Vietnamese civil construction sector, BIM is increasingly mandated.
b. Objectives: Build a cloud-based CDE repository.
''';
    final ctx = extractRegistrationContext(raw);
    expect(ctx.topic, equals('Design and Implementation of a CDE System - Thiết kế và phát triển hệ thống CDE (SU26SE017)'));
    expect(ctx.description, contains('In the Vietnamese civil construction sector'));
    expect(ctx.description, isNot(contains('SE160001')));
    expect(ctx.description, isNot(contains('Lâm Hữu Khánh Phương')));
  });

  test('sanitize file name strips illegal chars', () {
    expect(sanitizeFileName(r'a<>:"/\|?*.xlsx'), 'a_.xlsx');
    expect(sanitizeFileName('   '), 'capstone-review.xlsx');
  });

  test('excel workbook encodes overview and checks', () {
    final stats = computeCoverage(
      srsText: '## Auth\n',
      records: [rec()],
      unknownModules: const [],
    );
    final bytes = ExcelExportService().buildWorkbook(
      stats: stats,
      checks: [
        const HardCheckFinding(code: 'dup', message: 'trùng', identity: 'login|x'),
      ],
      records: [rec()],
      reviewMarkdown: '# Đánh giá AI\n\n## 1. Tóm tắt\n- Điểm mạnh: Đủ case\n\n| Tiêu chí | Điểm |\n|---|---|\n| Độ phủ | 85% |\n',
    );
    expect(bytes, isNotEmpty);
    expect(bytes[0], 0x50);
    expect(bytes[1], 0x4B);
    final decoded = Excel.decodeBytes(bytes);
    expect(decoded.tables.containsKey('Tong_quan'), isTrue);
    expect(decoded.tables.containsKey('Hard_checks'), isTrue);
    expect(decoded.tables.containsKey('Test_cases'), isTrue);
    expect(decoded.tables.containsKey('Danh_gia_AI'), isTrue);
  });
  test('taxonomy labels unhappy vs required', () {
    expect(classifyGapTaxonomy('invalid password'), 'Unhappy case');
    expect(classifyGapTaxonomy('required email empty'), 'Required field');
  });

  test('Gemini pinned to 2.5 flash', () {
    expect(geminiModel, 'gemini-2.5-flash');
  });

  test('computeCoverage handles feature list from AI without regex guessing', () {
    const aiFeatures = [
      'UC01: Đăng nhập hệ thống',
      'UC02: Quản lý người dùng',
      'UC03: Xuất báo cáo',
    ];
    final records = [
      rec(sheet: 'M01', description: 'Đăng nhập hệ thống'),
      rec(sheet: 'M02', description: 'Quản lý người dùng'),
    ];
    final stats = computeCoverage(
      records: records,
      unknownModules: const [],
      featureList: aiFeatures,
    );
    expect(stats.readUseCases.length, 3);
    expect(stats.coveredUseCases.length, 2);
    expect(stats.coverage, closeTo(0.66, 0.01));
  });

  test('mapHeaders resolves latest round when multiple round columns exist', () {
    final headers = [
      'Test Case ID',
      'Description',
      'Round 1 (Pass/Fail)',
      'Round 2 (Pass/Fail)',
      'Round 3 (Pass/Fail)',
    ];
    final mapped = mapHeaders(headers);
    expect(mapped[CanonicalField.status], equals(4)); // Index 4 is Round 3
  });

  test('mapHeaders prioritizes explicit Final Status over earlier rounds', () {
    final headers = [
      'Test Case ID',
      'Description',
      'Round 1',
      'Round 2',
      'Final Status',
    ];
    final mapped = mapHeaders(headers);
    expect(mapped[CanonicalField.status], equals(4)); // Index 4 is Final Status
  });

  test('computeCoverage prioritizes AI feature list over chapter headings', () {
    const srs = '''
# I. Giới thiệu tổng quan
## 1.1 Bối cảnh đề tài
## 1.2 Mục tiêu nghiên cứu
# II. Đặc tả yêu cầu chức năng
''';
    const aiFeatures = [
      'FR01: Đăng nhập hệ thống',
      'FR02: Quản lý giỏ hàng',
      'FR03: Thanh toán đơn hàng',
    ];
    final records = [
      rec(sheet: 'M01', description: 'Đăng nhập hệ thống'),
      rec(sheet: 'M02', description: 'Quản lý giỏ hàng'),
    ];
    final stats = computeCoverage(
      srsText: srs,
      records: records,
      unknownModules: const [],
      featureList: aiFeatures,
    );
    expect(stats.readUseCases, anyElement(contains('FR01')));
    expect(stats.readUseCases, anyElement(contains('FR02')));
    expect(stats.readUseCases, anyElement(contains('FR03')));
    expect(stats.readUseCases, isNot(anyElement(contains('Giới thiệu tổng quan'))));
    expect(stats.readUseCases, isNot(anyElement(contains('Bối cảnh đề tài'))));
  });

  test('checkEnvironmentMismatch delegates semantic checking to AI Axis 1 and returns clean empty list', () {
    const word = 'Table 5: Database Environment: PostgreSQL (Supabase)';
    const excel = 'Environment: Vercel (Frontend), Azure SQL Database';
    final mismatches = CrossCheckEngine.checkEnvironmentMismatch(
      wordText: word,
      excelText: excel,
    );
    expect(mismatches, isEmpty);
  });
}
