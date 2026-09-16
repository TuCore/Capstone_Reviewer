import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'ai_service.dart';

/// Service lưu/đọc API Key và settings từ local file
class LocalStorageService {
  static const _fileName = 'capstone_reviewer_settings.json';

  Future<File> _getSettingsFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> saveSettings({
    required String apiKey,
    required AIProvider provider,
  }) async {
    final file = await _getSettingsFile();
    final data = {
      'apiKey': apiKey,
      'provider': provider.name,
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    return null;
  }

  Future<void> clearSettings() async {
    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error clearing settings: $e');
    }
  }
}
