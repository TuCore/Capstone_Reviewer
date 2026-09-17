import 'ai_service.dart';

class ApiKeyFormat {
  static final openAi = RegExp(r'^sk-(?!ant-)[A-Za-z0-9_-]{16,}$');
  static final anthropic = RegExp(r'^sk-ant-[A-Za-z0-9_-]{16,}$');

  static String normalize(String raw) => raw.replaceAll(RegExp(r'\s+'), '');

  static String? errorFor(AIProvider provider, String raw) {
    final key = normalize(raw);
    if (key.isEmpty) return null;
    switch (provider) {
      case AIProvider.gemini:
        if (key.startsWith('sk-')) {
          return 'Key này là OpenAI/Anthropic, không phải Gemini.';
        }
        if (key.length < 20) {
          return 'Key Gemini quá ngắn.';
        }
        return null;
      case AIProvider.chatgpt:
        if (anthropic.hasMatch(key)) {
          return 'Key này là Anthropic, không phải OpenAI (sk-...).';
        }
        if (openAi.hasMatch(key)) return null;
        return 'Key không đúng định dạng OpenAI (sk-...).';
      case AIProvider.claude:
        if (anthropic.hasMatch(key)) return null;
        return 'Key không đúng định dạng Anthropic (sk-ant-...).';
    }
  }

  static String mask(String raw) {
    final key = normalize(raw);
    if (key.length < 8) return '***';
    return '${key.substring(0, 4)}…${key.substring(key.length - 2)}';
  }

  static String redact(String message, String key) {
    if (key.isEmpty) return message;
    final normalized = normalize(key);
    return message.replaceAll(key, '***').replaceAll(normalized, '***');
  }
}
