import 'package:archive/archive.dart';
import 'package:capstone_reviewer/core/extraction/extraction_result.dart';
import 'package:capstone_reviewer/core/extraction/heading_docx.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/docx_fixture.dart';

void main() {
  test('reads Heading1-4 styles as a heading tree', () {
    final bytes = buildDocxBytes(
      styledParas: [
        ('Heading1', 'II. Software Requirement Specification'),
        ('Heading2', '3. Functional Requirements'),
        ('Heading3', '3.2 Authentication'),
        ('Heading4', '3.2.1 Login'),
        ('Normal', 'User can sign in with email.'),
      ],
    );
    final archive = ZipDecoder().decodeBytes(bytes);
    final result = extractDocxArchive(archive);
    expect(result.text, contains('# II. Software Requirement Specification'));
    expect(result.text, contains('## 3. Functional Requirements'));
    expect(result.text, contains('### 3.2 Authentication'));
    expect(result.text, contains('#### 3.2.1 Login'));
    expect(result.text, contains('User can sign in with email.'));
    expect(result.truncated, isFalse);
  });

  test('keeps tables while numbering fallback works without styles', () {
    final bytes = buildDocxBytes(
      includeStyles: false,
      paragraphs: [
        '1. Product Overview',
        'Overview body',
        '1.1 Scope',
      ],
      table: [
        ['Use Case', 'Actor'],
        ['UC-Login', 'PM'],
      ],
    );
    final archive = ZipDecoder().decodeBytes(bytes);
    final result = extractDocxArchive(archive);
    expect(result.text, contains('# 1. Product Overview'));
    expect(result.text, contains('## 1.1 Scope'));
    expect(result.text, contains('[TABLE]'));
    expect(result.text, contains('UC-Login | PM'));
  });

  test('structure cut keeps headings, drops long body, marks UNKNOWN', () {
    final long = 'mô tả ' * 80;
    final blocks = [
      const DocBlock(kind: DocBlockKind.heading, text: 'Auth', level: 2),
      DocBlock(kind: DocBlockKind.paragraph, text: long),
      const DocBlock(kind: DocBlockKind.table, text: 'UC-1 | Login'),
      const DocBlock(kind: DocBlockKind.heading, text: 'Payment', level: 2),
      DocBlock(kind: DocBlockKind.paragraph, text: long),
      const DocBlock(kind: DocBlockKind.heading, text: 'Report', level: 2),
      DocBlock(kind: DocBlockKind.paragraph, text: long),
    ];
    final cut = cutByStructure(blocks, budgetChars: 20);
    expect(cut.truncated, isTrue);
    expect(cut.unknownModules, isNotEmpty);
    expect(cut.unknownModules, contains('Report'));
    final rendered = renderBlocks(cut.kept);
    expect(rendered, contains('Auth'));
    expect(rendered.contains('100%'), isFalse);
  });
}
