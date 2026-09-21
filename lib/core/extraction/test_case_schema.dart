enum CanonicalField {
  id,
  description,
  preCondition,
  steps,
  testData,
  expected,
  status,
  testDate,
  note,
  bug,
}

class TestCaseRecord {
  const TestCaseRecord({
    required this.sheet,
    required this.id,
    required this.description,
    this.preCondition = '',
    this.steps = '',
    this.testData = '',
    this.expected = '',
    this.status = '',
    this.testDate = '',
    this.note = '',
    this.bug = '',
    this.canonicalId = '',
    this.canonicalDescription = '',
    this.sourceRow,
  });

  final String sheet;
  final String id;
  final String description;
  final String preCondition;
  final String steps;
  final String testData;
  final String expected;
  final String status;
  final String testDate;
  final String note;
  final String bug;
  final String canonicalId;
  final String canonicalDescription;
  final int? sourceRow;
  Map<String, String> toGolden() => {
        'sheet': sheet,
        'id': canonicalId.isEmpty ? normalizeCode(id) : canonicalId,
        'description': description,
        'canonicalDescription': canonicalDescription,
        'preCondition': preCondition,
        'steps': steps,
        'testData': testData,
        'expected': expected,
        'status': status,
      };
}

/// Coverage = (use case đã đọc có ≥1 ca khớp) / (use case đã đọc).
/// UNKNOWN không vào tử, không vào mẫu. Cấm lấy 100% khi còn module chưa đọc.
double coverageRatio({
  required int coveredReadUseCases,
  required int readUseCases,
}) {
  if (readUseCases <= 0) return 0;
  return coveredReadUseCases / readUseCases;
}

const _aliasTable = <CanonicalField, List<String>>{
  CanonicalField.id: [
    'test case id',
    'test id',
    'testcaseid',
    'tc id',
    'tcid',
    'utcid',
    'test case no',
    'test-case no',
    'ma test case',
    'ma tc',
    'id',
    'ma',
  ],
  CanonicalField.description: [
    'test case description',
    'testcase description',
    'mo ta ngan',
    'mo ta',
    'description',
  ],
  CanonicalField.preCondition: [
    'pre condition',
    'preconditions',
    'precondition',
    'dieu kien tien quyet',
    'dieu kien',
  ],
  CanonicalField.steps: [
    'test case procedure steps',
    'test case procedure',
    'test case steps',
    'test steps',
    'cac buoc',
    'procedure',
    'steps',
  ],
  CanonicalField.testData: [
    'test data',
    'du lieu',
    'input',
  ],
  CanonicalField.expected: [
    'expected output',
    'expected results',
    'expected result',
    'ket qua mong doi',
    'expected',
  ],
  CanonicalField.status: [
    'final status',
    'final result',
    'ket qua cuoi',
    'trang thai cuoi',
    'round 1 (pass/fail)',
    'round 2 (pass/fail)',
    'round 3 (pass/fail)',
    'round 1',
    'round 2',
    'round 3',
    'passed failed',
    'actual result',
    'execution result',
    'test result',
    'ket qua thuc te',
    'ket qua test',
    'ket qua',
    'result',
    'status',
  ],
  CanonicalField.testDate: [
    'executed date',
    'test date',
    'ngay test',
    'ngay',
  ],
  CanonicalField.note: [
    'ghi chu',
    'notes',
    'note',
  ],
  CanonicalField.bug: [
    'defect id',
    'bug#',
    'bug',
  ],
};

final List<(CanonicalField, String)> _aliasesLongestFirst = () {
  final rows = <(CanonicalField, String)>[];
  for (final entry in _aliasTable.entries) {
    for (final alias in entry.value) {
      rows.add((entry.key, alias));
    }
  }
  rows.sort((a, b) => b.$2.length.compareTo(a.$2.length));
  return rows;
}();

const _viMap = {
  'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a',
  'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a',
  'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
  'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e',
  'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
  'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
  'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o',
  'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o',
  'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
  'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u',
  'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
  'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
  'đ': 'd',
};

const _synonymGroups = <List<String>>[
  ['dang nhap', 'log in', 'sign in', 'signin', 'login'],
  ['dang ky', 'sign up', 'signup', 'register'],
  ['mat khau', 'password', 'passwd', 'pwd'],
  ['quen mat khau', 'forgot password', 'reset password'],
  ['dang xuat', 'log out', 'sign out', 'logout'],
  ['trang chu', 'home page', 'homepage', 'home'],
  ['tim kiem', 'search'],
  ['email', 'e mail', 'thu dien tu'],
];

String foldVi(String raw) {
  final buf = StringBuffer();
  for (final rune in raw.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    buf.write(_viMap[ch] ?? ch);
  }
  return buf.toString();
}

String foldHeader(String raw) {
  final folded = foldVi(raw);
  return folded
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

String normalizeCode(String raw) {
  var s = raw.trim().toUpperCase();
  s = s.replaceAll(RegExp(r'[\s_]+'), '-');
  s = s.replaceAll(RegExp(r'-{2,}'), '-');
  return s;
}

String canonicalizePhrase(String raw) {
  var s = foldHeader(raw);
  if (s.isEmpty) return s;
  final groups = [..._synonymGroups]
    ..sort((a, b) {
      final al = a.map((e) => e.length).reduce((x, y) => x > y ? x : y);
      final bl = b.map((e) => e.length).reduce((x, y) => x > y ? x : y);
      return bl.compareTo(al);
    });
  for (final group in groups) {
    final canonical = group.last;
    for (final term in group) {
      if (term == canonical) continue;
      s = s.replaceAll(term, canonical);
    }
  }
  return s.replaceAll(RegExp(r'\s+'), ' ').trim();
}

CanonicalField? matchHeader(String raw) {
  final folded = foldHeader(raw);
  if (folded.isEmpty) return null;
  for (final row in _aliasesLongestFirst) {
    final alias = row.$2;
    if (folded == alias) return row.$1;
    if (folded.startsWith('$alias ')) return row.$1;
  }
  return null;
}
int _statusHeaderPriority(String header) {
  final folded = foldHeader(header);
  if (folded.contains('final') ||
      folded.contains('cuoi') ||
      folded.contains('actual result') ||
      folded.contains('ket qua thuc te')) {
    return 1000;
  }
  final roundMatch = RegExp(r'round\s*(\d+)', caseSensitive: false).firstMatch(folded);
  if (roundMatch != null) {
    final roundNum = int.tryParse(roundMatch.group(1)!) ?? 1;
    return 100 + roundNum;
  }
  if (folded == 'status' ||
      folded == 'ket qua test' ||
      folded == 'result' ||
      folded == 'test result') {
    return 50;
  }
  return 10;
}

Map<CanonicalField, int> mapHeaders(List<String> headers) {
  final mapped = <CanonicalField, int>{};
  for (var i = 0; i < headers.length; i++) {
    final field = matchHeader(headers[i]);
    if (field == null) continue;

    if (field == CanonicalField.status) {
      final existingIdx = mapped[field];
      if (existingIdx == null) {
        mapped[field] = i;
      } else {
        final existingPriority = _statusHeaderPriority(headers[existingIdx]);
        final currentPriority = _statusHeaderPriority(headers[i]);
        if (currentPriority > existingPriority) {
          mapped[field] = i;
        }
      }
    } else {
      mapped.putIfAbsent(field, () => i);
    }
  }
  return mapped;
}
