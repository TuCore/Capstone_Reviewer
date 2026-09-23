import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsService(prefs);
});

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  static const _providerKey = 'ai_provider';
  static const _apiKeyKey = 'api_key';
  static const _modelKey = 'ai_model';

  AIProvider getProvider() {
    final providerStr = _prefs.getString(_providerKey);
    if (providerStr != null) {
      try {
        return AIProvider.values.firstWhere((e) => e.name == providerStr);
      } catch (_) {}
    }
    return AIProvider.gemini;
  }

  Future<void> saveProvider(AIProvider provider) async {
    await _prefs.setString(_providerKey, provider.name);
  }

  String getApiKey() {
    return _prefs.getString(_apiKeyKey) ?? '';
  }

  Future<void> saveApiKey(String apiKey) async {
    await _prefs.setString(_apiKeyKey, apiKey);
  }

  String getModelName() {
    return _prefs.getString(_modelKey) ?? 'gemini-1.5-flash';
  }

  Future<void> saveModelName(String modelName) async {
    await _prefs.setString(_modelKey, modelName);
  }
}
