import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/ai_service.dart';
import '../../../../core/services/settings_service.dart';
import '../upload_controller.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  late AIProvider _selectedProvider;
  late String _selectedModel;
  late TextEditingController _keyController;
  bool _isChecking = false;
  String? _errorMessage;

  List<String> _geminiModels = [
    'gemini-3.8-flash',
    'gemini-3.7-flash',
    'gemini-3.6-flash',
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
    'gemini-3.1-flash-lite',
    'gemini-3-flash',
    'gemini-1.5-flash',
  ];

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsServiceProvider);
    _selectedProvider = settings.getProvider();
    _selectedModel = settings.getModelName();
    if (!_geminiModels.contains(_selectedModel)) {
      _selectedModel = 'gemini-1.5-flash';
    }
    _keyController = TextEditingController(text: settings.getApiKey());
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _fetchModels() async {
    final apiKey = _keyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập API Key để tải danh sách model.');
      return;
    }
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    final models = await AIService.fetchModels(apiKey, _selectedProvider);

    if (!mounted) return;
    setState(() {
      _isChecking = false;
      if (models != null && models.isNotEmpty) {
        _geminiModels = models;
        if (!_geminiModels.contains(_selectedModel)) {
           _selectedModel = _geminiModels.first;
        }
      } else {
        _errorMessage = 'Không thể tải danh sách model, kiểm tra lại API Key.';
      }
    });
  }

  Future<void> _saveAndValidate() async {
    final newKey = _keyController.text.trim();
    if (newKey.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập API Key.');
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    final aiService = AIService(
      apiKey: newKey,
      provider: _selectedProvider,
      modelName: _selectedModel,
    );
    final validationError = await aiService.validateKey();

    if (!mounted) return;

    if (validationError != null) {
      setState(() {
        _isChecking = false;
        _errorMessage = validationError;
      });
      return;
    }

    // Save and pop
    final settings = ref.read(settingsServiceProvider);
    await settings.saveProvider(_selectedProvider);
    await settings.saveModelName(_selectedModel);
    await settings.saveApiKey(newKey);
    ref.read(uploadControllerProvider.notifier).refreshSettings();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cấu hình AI Provider'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<AIProvider>(
              decoration: const InputDecoration(
                labelText: 'Chọn AI Provider',
                border: OutlineInputBorder(),
              ),
              value: _selectedProvider,
              items: const [
                DropdownMenuItem(
                  value: AIProvider.gemini,
                  child: Text('Google Gemini'),
                ),
                DropdownMenuItem(
                  value: AIProvider.chatgpt,
                  child: Text('OpenAI ChatGPT'),
                ),
                DropdownMenuItem(
                  value: AIProvider.claude,
                  child: Text('Anthropic Claude'),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedProvider = val);
                }
              },
            ),
            if (_selectedProvider == AIProvider.gemini) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Phiên bản Gemini',
                  border: OutlineInputBorder(),
                ),
                value: _selectedModel,
                items: _geminiModels
                    .map((model) => DropdownMenuItem(
                          value: model,
                          child: Text(model),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedModel = val);
                  }
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _fetchModels,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Tải danh sách Model'),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isChecking ? null : () => Navigator.of(context).pop(),
          child: const Text('HỦY'),
        ),
        FilledButton.icon(
          onPressed: _isChecking ? null : _saveAndValidate,
          icon: _isChecking
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save),
          label: const Text('LƯU'),
        ),
      ],
    );
  }
}
