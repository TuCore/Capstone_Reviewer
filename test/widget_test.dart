import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/features/upload/presentation/upload_controller.dart';
import 'package:capstone_reviewer/features/upload/presentation/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UploadScreen shows three slots and locked analyze', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: UploadScreen()),
      ),
    );

    expect(find.text('File Test Report (Excel)'), findsOneWidget);
    expect(find.text('File SRS (PDF/Word)'), findsOneWidget);
    expect(find.text('Phiếu đăng ký (không bắt buộc)'), findsOneWidget);
    expect(find.text('BẮT ĐẦU PHÂN TÍCH (REVIEW)'), findsOneWidget);
    expect(find.text('HỦY'), findsNothing);

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'BẮT ĐẦU PHÂN TÍCH (REVIEW)'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('drop zones do not overflow on short window', (tester) async {
    tester.view.physicalSize = const Size(1600, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: UploadScreen()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('File Test Report (Excel)'), findsOneWidget);
  });


  test('registration is optional; wrong vendor key errors immediately', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(uploadControllerProvider.notifier);

    notifier.setApiKey('sk-not-gemini-key-value-123456');
    expect(container.read(uploadControllerProvider).error, contains('Gemini'));

    notifier.setProvider(AIProvider.chatgpt);
    expect(container.read(uploadControllerProvider).error, isNull);
    expect(container.read(uploadControllerProvider).canAnalyze, isFalse);

    notifier.setApiKey('AIzaSyNotAnOpenAiKeyValue1234567');
    expect(container.read(uploadControllerProvider).error, contains('OpenAI'));
  });

  test('clearError drops previous error', () {
    final state = UploadState(error: 'cũ');
    expect(state.clearError().error, isNull);
    expect(state.error, 'cũ');
  });
}
