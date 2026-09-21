class RegistrationContext {
  const RegistrationContext({
    this.topic = '',
    this.description = '',
    this.rawContent = '',
  });

  final String topic;
  final String description;
  final String rawContent;

  bool get isEmpty => topic.isEmpty && description.isEmpty && rawContent.isEmpty;

  RegistrationContext copyWith({
    String? topic,
    String? description,
    String? rawContent,
  }) {
    return RegistrationContext(
      topic: topic ?? this.topic,
      description: description ?? this.description,
      rawContent: rawContent ?? this.rawContent,
    );
  }

  String toPromptBlock() {
    final lines = <String>[];
    if (topic.isNotEmpty) lines.add('Tên đề tài: $topic');
    if (description.isNotEmpty) lines.add('Mô tả: $description');
    if (rawContent.isNotEmpty) {
      if (lines.isNotEmpty) lines.add('---');
      lines.add(rawContent);
    }
    return lines.join('\n');
  }
}

final _email = RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+');
final _mssv = RegExp(r'\b(?:SE|CS|HE|QE|SS|SA)\d{5,}\b', caseSensitive: false);
final _phone = RegExp(r'\b0\d{8,10}\b');

String stripStudentPii(String raw) {
  return raw
      .replaceAll(_email, '')
      .replaceAll(_mssv, '')
      .replaceAll(_phone, '');
}

RegistrationContext extractRegistrationContext(String raw) {
  var cleaned = stripStudentPii(raw);
  // Strip non-printable ASCII control characters except newline and tab
  cleaned = cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), ' ');

  String topic = '';
  String description = '';

  // 1. Check for Capstone multi-field name (English / Vietnamese / Abbr)
  final mCapstone = RegExp(
    r'(?:capstone\s+project\s+name|tên\s+đề\s+tài|tên\s+dự\s+án|project\s+name)[\s:*-]+([\s\S]+?)(?=(?:\s*(?:[a-z0-9]\.|\n\s*\n|Context|Bối\s*cảnh|Mục\s*tiêu|Description|Nội\s*dung|Phạm\s*vi|Scope|Objective)|$))',
    caseSensitive: false,
  ).firstMatch(cleaned);

  if (mCapstone != null) {
    final rawBlock = mCapstone.group(1)!.trim();
    final engMatch = RegExp(
      r'(?:English|Tiếng Anh)[\s:*-]+([^\n\r]+?)(?=(?:Vietnamese|Tiếng Việt|Abbreviation|Mã đề tài|Tên viết tắt|$))',
      caseSensitive: false,
    ).firstMatch(rawBlock);
    final vnMatch = RegExp(
      r'(?:Vietnamese|Tiếng Việt)[\s:*-]+([^\n\r]+?)(?=(?:English|Tiếng Anh|Abbreviation|Mã đề tài|Tên viết tắt|$))',
      caseSensitive: false,
    ).firstMatch(rawBlock);
    final abbrMatch = RegExp(
      r'(?:Abbreviation|Mã đề tài|Tên viết tắt)[\s:*-]+([^\n\r\s]+)',
      caseSensitive: false,
    ).firstMatch(rawBlock);

    if (engMatch != null || vnMatch != null) {
      final parts = <String>[];
      if (engMatch != null) parts.add(engMatch.group(1)!.trim());
      if (vnMatch != null) parts.add(vnMatch.group(1)!.trim());
      topic = parts.join(' - ');
      if (abbrMatch != null) topic += ' (${abbrMatch.group(1)!.trim()})';
    } else {
      final firstLine = rawBlock.split(RegExp(r'\r?\n')).first.trim();
      topic = firstLine.replaceFirst(RegExp(r'^[:\-\s]+'), '').trim();
    }
  }
  // 2. Targeted description extraction without arbitrary truncation
  final descMatch = RegExp(
    r'(?:(?:Context|Bối\s*cảnh|Mô\s*tả|Description|Mục\s*tiêu|Objective|Nội\s*dung\s*đề\s*tài|Nội\s*dung\s*nghiên\s*cứu)[\s:*-]+)([\s\S]+?)(?=(?:\n\s*\n|\b(?:Supervisor|Student|Giảng\s*viên|Sinh\s*viên|Ký\s*tên|Signature|4\.|IV\.)\b|$))',
    caseSensitive: false,
  ).firstMatch(cleaned);

  if (descMatch != null) {
    description = descMatch.group(1)!.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  return RegistrationContext(
    topic: topic,
    description: description,
    rawContent: cleaned,
  );
}
