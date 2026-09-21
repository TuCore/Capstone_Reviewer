final _quoted = RegExp(r'"([^"]{12,})"');

class QuoteGuardResult {
  const QuoteGuardResult({required this.text, required this.removed});
  final String text;
  final List<String> removed;
}

QuoteGuardResult stripHallucinatedQuotes(String aiText, List<String> sources) {
  final haystack = sources.join('\n').toLowerCase();
  final removed = <String>[];
  final kept = <String>[];

  for (final line in aiText.split('\n')) {
    var drop = false;
    for (final m in _quoted.allMatches(line)) {
      final quote = m.group(1)!;
      if (!containsLoose(haystack, quote)) {
        removed.add(quote);
        drop = true;
      }
    }
    if (drop) {
      kept.add('${line.trimRight()} **[BỊA — đã loại]**');
    } else {
      kept.add(line);
    }
  }

  final cleaned = kept.where((l) => !l.contains('**[BỊA — đã loại]**')).toList();
  return QuoteGuardResult(text: cleaned.join('\n'), removed: removed);
}

bool containsLoose(String haystack, String quote) {
  final q = quote.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  if (q.isEmpty) return false;
  final h = haystack.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  return h.contains(q);
}
