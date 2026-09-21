import '../extraction/test_case_schema.dart';
import 'hard_checks.dart';

class CoverageStats {
  const CoverageStats({
    required this.readUseCases,
    required this.coveredUseCases,
    required this.unknownModules,
    required this.passed,
    required this.failed,
    required this.untested,
    required this.wordingCounts,
    required this.severityCounts,
  });

  final List<String> readUseCases;
  final List<String> coveredUseCases;
  final List<String> unknownModules;
  final int passed;
  final int failed;
  final int untested;
  final Map<String, int> wordingCounts;
  final Map<String, int> severityCounts;

  double get coverage => coverageRatio(
        coveredReadUseCases: coveredUseCases.length,
        readUseCases: readUseCases.length,
      );

  String toMarkdown() {
    final pct = (coverage * 100).toStringAsFixed(1);
    final buf = StringBuffer()
      ..writeln('## Số liệu (do code đếm)')
      ..writeln()
      ..writeln(
        '- % phủ = UC có ca khớp / UC đã đọc = ${coveredUseCases.length}/${readUseCases.length} = **$pct%**',
      );
    if (unknownModules.isNotEmpty) {
      buf.writeln(
        '- UNKNOWN (không vào mẫu): ${unknownModules.join('; ')}',
      );
    }
    buf
      ..writeln('- PASSED: $passed')
      ..writeln('- FAILED: $failed')
      ..writeln('- Untested/Not Run/N/A: $untested');
    for (final e in wordingCounts.entries) {
      buf.writeln('- Diễn đạt ${e.key}: ${e.value}');
    }
    return buf.toString();
  }
}

CoverageStats computeCoverage({
  String? srsText,
  required List<TestCaseRecord> records,
  required List<String> unknownModules,
  List<String>? featureList,
}) {
  final read = <String>[];
  if (featureList != null && featureList.isNotEmpty) {
    for (final f in featureList) {
      final trimmed = f.trim();
      if (trimmed.isNotEmpty && !read.contains(trimmed) && !unknownModules.contains(trimmed)) {
        read.add(trimmed);
      }
    }
  } else if (srsText != null && srsText.isNotEmpty) {
    // Mechanical markdown section headings (0% regex keyword guessing)
    for (final line in srsText.split('\n')) {
      final t = line.trim();
      if (t.startsWith('# ') ||
          t.startsWith('## ') ||
          t.startsWith('### ') ||
          t.startsWith('#### ')) {
        final name = t.replaceFirst(RegExp(r'^#+\s*'), '').trim();
        if (name.isEmpty) continue;
        if (unknownModules.contains(name)) continue;
        if (_isGenericMetaHeading(name)) continue;
        if (!read.contains(name)) read.add(name);
      }
    }
  }
  final covered = <String>[];
  for (final uc in read) {
    if (records.any((r) => _covers(uc, r))) covered.add(uc);
  }

  var passed = 0, failed = 0, untested = 0;
  final wording = <String, int>{};
  final severity = <String, int>{'high': 0, 'medium': 0, 'low': 0};
  for (final rec in records) {
    final status = normalizeStatus(rec.status);
    if (status == 'PASSED') {
      passed++;
    } else if (status == 'FAILED') {
      failed++;
    } else {
      untested++;
    }
    final w = scoreWording(rec);
    wording[w] = (wording[w] ?? 0) + 1;
    if (w == 'thiếu' || rec.expected.isEmpty) {
      severity['high'] = severity['high']! + 1;
    } else if (w == 'mơ hồ' || w == 'trộn nhiều ý') {
      severity['medium'] = severity['medium']! + 1;
    } else if (w != 'đạt') {
      severity['low'] = severity['low']! + 1;
    }
  }

  return CoverageStats(
    readUseCases: read,
    coveredUseCases: covered,
    unknownModules: unknownModules,
    passed: passed,
    failed: failed,
    untested: untested,
    wordingCounts: wording,
    severityCounts: severity,
  );
}

String cleanModuleName(String raw) {
  var s = raw.replaceAll(RegExp(r'^[IVXLCDM\d\.\-\s_]+'), ' ');
  s = s.replaceAll(RegExp(r'^m\d+[_\-\s]*', caseSensitive: false), ' ');
  return canonicalizePhrase(s);
}

bool _covers(String module, TestCaseRecord rec) {
  final cleanModule = cleanModuleName(module);
  if (cleanModule.isEmpty) return false;

  final cleanSheet = cleanModuleName(rec.sheet);
  final desc = rec.canonicalDescription;

  if (cleanSheet.isNotEmpty &&
      (cleanSheet.contains(cleanModule) || cleanModule.contains(cleanSheet))) {
    return true;
  }
  if (desc.isNotEmpty &&
      (desc.contains(cleanModule) || cleanModule.contains(desc))) {
    return true;
  }

  final modTokens = cleanModule
      .split(RegExp(r'\s+'))
      .where((t) => t.length >= 4)
      .toSet();
  if (modTokens.isNotEmpty) {
    final sheetTokens = cleanSheet
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 4)
        .toSet();
    if (modTokens.intersection(sheetTokens).isNotEmpty) {
      return true;
    }
  }

  return false;
}

String classifyGapTaxonomy(String description) {
  final f = foldHeader(description);
  if (f.contains('required') || f.contains('bat buoc') || f.contains('trong')) {
    return 'Required field';
  }
  if (f.contains('exception') || f.contains('ngoai le') || f.contains('error')) {
    return 'Exception case';
  }
  if (f.contains('invalid') ||
      f.contains('sai') ||
      f.contains('fail') ||
      f.contains('unhappy')) {
    return 'Unhappy case';
  }
  return 'Happy case';
}

bool _isGenericMetaHeading(String name) {
  final lower = name.toLowerCase().trim();
  const stopWords = {
    'from',
    'to',
    'and',
    'or',
    'the',
    'in',
    'on',
    'at',
    'for',
    'with',
    'by',
    'of',
    'an',
    'a',
    'n/a',
    'none',
  };
  if (stopWords.contains(lower)) return true;

  return lower.contains('record of changes') ||
      lower.contains('lịch sử thay đổi') ||
      lower.contains('mục lục') ||
      lower.contains('table of contents') ||
      lower.contains('thông tin bìa') ||
      lower.contains('scope of testing') ||
      lower.contains('test strategy') ||
      lower.contains('test plan') ||
      lower.contains('human resources') ||
      lower.contains('test environment') ||
      lower.contains('test milestones');
}
