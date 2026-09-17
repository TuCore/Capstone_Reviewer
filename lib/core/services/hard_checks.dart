import '../extraction/test_case_schema.dart';

class HardCheckFinding {
  const HardCheckFinding({
    required this.code,
    required this.message,
    this.identity = '',
  });

  final String code;
  final String message;
  final String identity;
}

String caseIdentity(TestCaseRecord record) {
  final module = foldHeader(record.sheet);
  final desc = record.canonicalDescription.isEmpty
      ? canonicalizePhrase(record.description)
      : record.canonicalDescription;
  return '$module|$desc';
}

const vagueTokens = [
  'đúng',
  'tot',
  'tốt',
  'hop le',
  'hợp lệ',
  'ok',
  'okay',
  'pass',
  'đạt',
  'fine',
  'correct',
];

List<HardCheckFinding> runHardChecks({
  required List<TestCaseRecord> records,
  required List<String> skippedSheets,
}) {
  final findings = <HardCheckFinding>[];
  final seenExact = <String, String>{};
  final seenIdentity = <String, String>{};

  for (final skip in skippedSheets) {
    final lower = skip.toLowerCase();
    if (lower.contains('unit') || lower.contains('q1_')) {
      findings.add(HardCheckFinding(
        code: 'sheet-type',
        message: 'Sheet sai loại (UnitTest): $skip',
      ));
    }
  }

  for (final rec in records) {
    final id = caseIdentity(rec);
    if (rec.id.toUpperCase().startsWith('UTCID') ||
        rec.sheet.toLowerCase().contains('unit')) {
      findings.add(HardCheckFinding(
        code: 'sheet-type',
        message: 'Ca ${rec.canonicalId.isEmpty ? rec.id : rec.canonicalId} giống UnitTest, không phải system test.',
        identity: id,
      ));
    }

    if (rec.steps.isEmpty && rec.expected.isEmpty) {
      findings.add(HardCheckFinding(
        code: 'empty',
        message: 'Thiếu bước và kết quả mong đợi (${rec.sheet}).',
        identity: id,
      ));
    }

    final blob = '${rec.description}\n${rec.steps}\n${rec.expected}';
    final prev = seenExact[blob];
    if (prev != null) {
      findings.add(HardCheckFinding(
        code: 'duplicate',
        message: 'Trùng nguyên văn với ca ở $prev.',
        identity: id,
      ));
    } else {
      seenExact[blob] = rec.sheet;
    }

    if (id.endsWith('|')) continue;
    final other = seenIdentity[id];
    if (other != null && other != rec.description) {
      findings.add(HardCheckFinding(
        code: 'naming',
        message: 'Cùng việc nhưng tên Anh/Việt khác nhau: "$other" vs "${rec.description}".',
        identity: id,
      ));
    } else {
      seenIdentity[id] = rec.description;
    }

    final quality = scoreWording(rec);
    if (quality != 'đạt') {
      findings.add(HardCheckFinding(
        code: 'wording',
        message: 'Diễn đạt $quality: ${rec.expected.isEmpty ? rec.description : rec.expected}',
        identity: id,
      ));
    }
  }

  return findings;
}

String scoreWording(TestCaseRecord rec) {
  if (rec.description.trim().isEmpty) return 'thiếu';
  final expected = rec.expected.trim();
  if (expected.isEmpty) return 'thiếu';
  final folded = foldHeader(expected);
  if (vagueTokens.contains(folded)) return 'mơ hồ';
  if (expected.contains(' và ') && expected.length > 160) return 'trộn nhiều ý';
  if (folded.length < 8) return 'kết luận thiếu bằng chứng';
  return 'đạt';
}

String normalizeStatus(String raw) {
  final folded = foldHeader(raw);
  if (folded == 'passed' || folded == 'pass' || folded == 'p' || folded == 'ok') {
    return 'PASSED';
  }
  if (folded == 'failed' || folded == 'fail' || folded == 'f' || folded == 'ng') {
    return 'FAILED';
  }
  if (folded == 'not run' || folded == 'notrun') return 'Not Run';
  if (folded == 'untested' || folded == 'pending' || folded == 'blocked') {
    return 'Untested';
  }
  if (folded == 'n a' || folded == 'na') return 'N/A';
  if (raw.trim().isEmpty) return 'Untested';
  return raw.trim();
}
