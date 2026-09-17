import 'dart:convert';

import 'package:archive/archive.dart';

const _ns = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';

String _esc(String raw) => raw
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

List<int> buildDocxBytes({
  List<(int level, String text)> headings = const [],
  List<String> paragraphs = const [],
  List<List<String>> table = const [],
  bool includeStyles = true,
  List<(String styleId, String text)> styledParas = const [],
}) {
  final body = StringBuffer();
  if (styledParas.isNotEmpty) {
    for (final para in styledParas) {
      body.writeln(_p(para.$2, styleId: para.$1));
    }
  } else {
    for (final heading in headings) {
      body.writeln(_p(heading.$2, styleId: 'Heading${heading.$1}'));
    }
    for (final para in paragraphs) {
      body.writeln(_p(para));
    }
  }
  if (table.isNotEmpty) {
    body.writeln('<w:tbl>');
    for (final row in table) {
      body.write('<w:tr>');
      for (final cell in row) {
        body.write(
          '<w:tc><w:p><w:r><w:t>${_esc(cell)}</w:t></w:r></w:p></w:tc>',
        );
      }
      body.writeln('</w:tr>');
    }
    body.writeln('</w:tbl>');
  }

  final document = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="$_ns">
  <w:body>
$body
  </w:body>
</w:document>''';

  final archive = Archive();
  _add(archive, 'word/document.xml', document);
  if (includeStyles) {
    _add(archive, 'word/styles.xml', _stylesXml());
  }
  return ZipEncoder().encode(archive)!;
}

List<int> buildZipWithoutDocument() {
  final archive = Archive();
  _add(archive, 'hello.txt', 'hello');
  return ZipEncoder().encode(archive)!;
}

void _add(Archive archive, String name, String xml) {
  final bytes = utf8.encode(xml);
  archive.addFile(ArchiveFile(name, bytes.length, bytes));
}

String _p(String text, {String? styleId}) {
  final pPr = styleId == null
      ? ''
      : '<w:pPr><w:pStyle w:val="$styleId"/></w:pPr>';
  return '<w:p>$pPr<w:r><w:t>${_esc(text)}</w:t></w:r></w:p>';
}

String _stylesXml() {
  final styles = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..writeln('<w:styles xmlns:w="$_ns">');
  for (var i = 1; i <= 6; i++) {
    styles.writeln(
      '<w:style w:type="paragraph" w:styleId="Heading$i">'
      '<w:name w:val="heading $i"/>'
      '<w:pPr><w:outlineLvl w:val="${i - 1}"/></w:pPr>'
      '</w:style>',
    );
  }
  styles.writeln('</w:styles>');
  return styles.toString();
}
