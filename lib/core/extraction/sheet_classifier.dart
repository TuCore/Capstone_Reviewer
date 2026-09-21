import 'test_case_schema.dart';

class SheetVerdict {
  const SheetVerdict({
    required this.keep,
    required this.sheetName,
    this.skipReason = '',
    this.headerRowIndex = -1,
    this.columns = const {},
  });

  final bool keep;
  final String sheetName;
  final String skipReason;
  final int headerRowIndex;
  final Map<CanonicalField, int> columns;
}

SheetVerdict classifySheet({
  required String name,
  required List<List<String>> rows,
}) {
  final lowerName = name.toLowerCase().trim();
  if (lowerName.startsWith('microsoft.com:')) {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'sheet hệ thống',
    );
  }

  if (lowerName == 'cover' ||
      lowerName == 'test statistics' ||
      lowerName == 'statistics' ||
      lowerName == 'functions' ||
      lowerName == 'history' ||
      lowerName == 'revision history' ||
      lowerName == 'document history') {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'sheet thông tin chung',
    );
  }

  var bestScore = 0;
  var bestIndex = -1;
  var bestCols = <CanonicalField, int>{};
  final limit = rows.length < 20 ? rows.length : 20;
  for (var i = 0; i < limit; i++) {
    final cols = mapHeaders(rows[i]);
    if (cols.length > bestScore) {
      bestScore = cols.length;
      bestIndex = i;
      bestCols = cols;
    }
  }

  if (bestScore < 2 || bestIndex < 0) {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'không có cột test case',
    );
  }

  if (lowerName == 'test cases' && !bestCols.containsKey(CanonicalField.steps)) {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'sheet mục lục test cases',
      headerRowIndex: bestIndex,
      columns: bestCols,
    );
  }

  final hasIdentity = bestCols.containsKey(CanonicalField.id) ||
      bestCols.containsKey(CanonicalField.description);
  final hasBody = bestCols.containsKey(CanonicalField.steps) ||
      bestCols.containsKey(CanonicalField.expected);
  if (!hasIdentity || !hasBody) {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'không đủ cột test case (cần steps hoặc expected)',
      headerRowIndex: bestIndex,
      columns: bestCols,
    );
  }

  var dataRows = 0;
  for (var i = bestIndex + 1; i < rows.length; i++) {
    if (rows[i].any((c) => c.trim().isNotEmpty)) dataRows++;
  }
  if (dataRows < 1) {
    return SheetVerdict(
      keep: false,
      sheetName: name,
      skipReason: 'không có dòng dữ liệu',
      headerRowIndex: bestIndex,
      columns: bestCols,
    );
  }

  return SheetVerdict(
    keep: true,
    sheetName: name,
    headerRowIndex: bestIndex,
    columns: bestCols,
  );
}

TestCaseRecord recordFromRow({
  required String sheet,
  required List<String> row,
  required Map<CanonicalField, int> columns,
  int? sourceRow,
}) {
  String at(CanonicalField field) {
    final i = columns[field];
    if (i == null || i >= row.length) return '';
    return row[i].trim();
  }

  final id = at(CanonicalField.id);
  final description = at(CanonicalField.description);
  return TestCaseRecord(
    sheet: sheet,
    id: id,
    description: description,
    preCondition: at(CanonicalField.preCondition),
    steps: at(CanonicalField.steps),
    testData: at(CanonicalField.testData),
    expected: at(CanonicalField.expected),
    status: at(CanonicalField.status),
    testDate: at(CanonicalField.testDate),
    note: at(CanonicalField.note),
    bug: at(CanonicalField.bug),
    canonicalId: normalizeCode(id),
    canonicalDescription: canonicalizePhrase(description),
    sourceRow: sourceRow,
  );
}

bool rowHasContent(List<String> row) => row.any((c) => c.trim().isNotEmpty);
