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


}
