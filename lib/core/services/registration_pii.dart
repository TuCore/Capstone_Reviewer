class RegistrationContext {
  const RegistrationContext({required this.topic, required this.description});

  final String topic;
  final String description;

  bool get isEmpty => topic.isEmpty && description.isEmpty;

  String toPromptBlock() {
    final lines = <String>[];
    if (topic.isNotEmpty) lines.add('Tên đề tài: $topic');
    if (description.isNotEmpty) lines.add('Mô tả: $description');
    return lines.join('\n');
  }
}

final _email = RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+');
final _mssv = RegExp(r'\b(?:SE|CS|HE|QE|SS|SA)\d{5,}\b', caseSensitive: false);
final _phone = RegExp(r'\b0\d{8,10}\b');
final _topicLine = RegExp(
  r'(?:tên đề tài|de tai|project name|đề tài)\s*[:\-]\s*(.+)',
  caseSensitive: false,
);

String stripStudentPii(String raw) {
  return raw
      .replaceAll(_email, '')
      .replaceAll(_mssv, '')
      .replaceAll(_phone, '');
}

RegistrationContext extractRegistrationContext(String raw) {
  final cleaned = stripStudentPii(raw);
  String topic = '';
  for (final line in cleaned.split(RegExp(r'\r?\n'))) {
    final m = _topicLine.firstMatch(line.trim());
    if (m != null) {
      topic = m.group(1)!.trim();
      break;
    }
  }
  var description = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (description.length > 1200) {
    description = description.substring(0, 1200);
  }
  return RegistrationContext(topic: topic, description: description);
}
