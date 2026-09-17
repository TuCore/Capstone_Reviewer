import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('header aliases map ID / TC ID / TestCaseId to the same field', () {
    expect(matchHeader('ID'), CanonicalField.id);
    expect(matchHeader('TC ID'), CanonicalField.id);
    expect(matchHeader('TestCaseId'), CanonicalField.id);
    expect(matchHeader('Test Case ID'), CanonicalField.id);
  });

  test('normalizeCode folds case, space, underscore', () {
    expect(normalizeCode('tc_001'), 'TC-001');
    expect(normalizeCode(' tc 001 '), 'TC-001');
    expect(normalizeCode('TC-001'), 'TC-001');
  });

  test('dang nhap and login canonicalize to login token', () {
    expect(
      canonicalizePhrase('Xac minh PM co the dang nhap'),
      contains('login'),
    );
    expect(canonicalizePhrase('Verify PM can log in'), contains('login'));
    expect(
      canonicalizePhrase('Xác minh PM có thể đăng nhập'),
      contains('login'),
    );
  });

  test('coverage excludes unread modules and is 0 when nothing was read', () {
    expect(coverageRatio(coveredReadUseCases: 4, readUseCases: 8), 0.5);
    expect(coverageRatio(coveredReadUseCases: 0, readUseCases: 0), 0);
    expect(coverageRatio(coveredReadUseCases: 8, readUseCases: 8), 1);
  });
}
