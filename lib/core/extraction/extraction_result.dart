import 'test_case_schema.dart';

class ExtractionResult {
  const ExtractionResult({
    required this.text,
    this.skippedSheets = const [],
    this.unknownModules = const [],
    this.truncated = false,
    this.sizeBytes = 0,
    this.sheetCount = 0,
    this.rowCount = 0,
    this.warnings = const [],
    this.records = const [],
    this.rawSheets = const {},
  });

  final String text;
  final List<String> skippedSheets;
  final List<String> unknownModules;
  final bool truncated;
  final int sizeBytes;
  final int sheetCount;
  final int rowCount;
  final List<String> warnings;
  final List<TestCaseRecord> records;
  final Map<String, List<List<String>>> rawSheets;

  String preamble() {
    final lines = <String>[];
    final abnormal = skippedSheets.where((s) {
      final lower = s.toLowerCase();
      return !lower.startsWith('cover') &&
          !lower.startsWith('test cases') &&
          !lower.startsWith('test statistics') &&
          !lower.startsWith('statistics') &&
          !lower.startsWith('functions') &&
          !lower.startsWith('history');
    }).toList();
    if (abnormal.isNotEmpty) {
      lines.add('Sheet bỏ qua: ${abnormal.join(', ')}');
    }
    if (unknownModules.isNotEmpty) {
      lines.add('UNKNOWN: ${unknownModules.join('; ')}');
    }
    if (truncated) {
      lines.add(
        'Phần trích bị cắt theo cấu trúc — % coverage chỉ tính phần đã đọc, không phải 100%.',
      );
    }
    return lines.join('\n');
  }
}

class DocBlock {
  const DocBlock({
    required this.kind,
    required this.text,
    this.level = 0,
  });

  final DocBlockKind kind;
  final String text;
  final int level;

  bool get isHeading => kind == DocBlockKind.heading;
  bool get droppable => kind == DocBlockKind.paragraph && text.length > 180;
}

enum DocBlockKind { heading, paragraph, table }

class StructureCutResult {
  const StructureCutResult({
    required this.kept,
    required this.unknownModules,
    required this.truncated,
  });

  final List<DocBlock> kept;
  final List<String> unknownModules;
  final bool truncated;
}

/// Cắt mô tả dài trước, giữ heading + bảng. Module bị bỏ ghi UNKNOWN.
StructureCutResult cutByStructure(
  List<DocBlock> blocks, {
  required int budgetChars,
}) {
  if (blocks.isEmpty) {
    return const StructureCutResult(
      kept: [],
      unknownModules: [],
      truncated: false,
    );
  }

  final sections = <_Section>[];
  _Section? current;
  for (final block in blocks) {
    if (block.isHeading) {
      current = _Section(block);
      sections.add(current);
    } else {
      current ??= _Section(null);
      if (current.heading == null && sections.isEmpty) {
        sections.add(current);
      }
      current.body.add(block);
    }
  }

  var total = _renderLength(sections);
  var truncated = total > budgetChars;
  final unknown = <String>[];

  while (total > budgetChars) {
    var si = -1;
    for (var i = sections.length - 1; i >= 0; i--) {
      if (sections[i].body.lastIndexWhere((b) => b.droppable) >= 0) {
        si = i;
        break;
      }
    }
    if (si >= 0) {
      final idx = sections[si].body.lastIndexWhere((b) => b.droppable);
      sections[si].body.removeAt(idx);
      total = _renderLength(sections);
      truncated = true;
      continue;
    }

    var droppedBody = false;
    for (var i = sections.length - 1; i >= 0; i--) {
      if (sections[i].body.isEmpty) continue;
      sections[i].body.removeLast();
      total = _renderLength(sections);
      truncated = true;
      droppedBody = true;
      break;
    }
    if (droppedBody) continue;

    if (sections.isEmpty) break;
    final removed = sections.removeLast();
    final name = removed.heading?.text.trim();
    if (name != null && name.isNotEmpty) unknown.insert(0, name);
    truncated = true;
    total = _renderLength(sections);
  }

  final kept = <DocBlock>[];
  for (final section in sections) {
    if (section.heading != null) kept.add(section.heading!);
    kept.addAll(section.body);
  }

  return StructureCutResult(
    kept: kept,
    unknownModules: unknown,
    truncated: truncated,
  );
}

class _Section {
  _Section(this.heading);
  final DocBlock? heading;
  final body = <DocBlock>[];
}

int _renderLength(List<_Section> sections) {
  var n = 0;
  for (final s in sections) {
    if (s.heading != null) n += s.heading!.text.length + 8;
    for (final b in s.body) {
      n += b.text.length + 1;
    }
  }
  return n;
}

String renderBlocks(List<DocBlock> blocks) {
  final buf = StringBuffer();
  for (final block in blocks) {
    switch (block.kind) {
      case DocBlockKind.heading:
        final marks = '#' * block.level.clamp(1, 6);
        buf.writeln('$marks ${block.text}');
      case DocBlockKind.paragraph:
        buf.writeln(block.text);
      case DocBlockKind.table:
        buf.writeln('[TABLE]');
        buf.writeln(block.text);
    }
    buf.writeln();
  }
  return buf.toString().trim();
}
