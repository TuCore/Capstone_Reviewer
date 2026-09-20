import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/features/upload/presentation/upload_controller.dart';
import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/test_case_review_engine.dart';
import 'package:capstone_reviewer/features/review/presentation/review_screen.dart';
import 'package:capstone_reviewer/features/review/review_bundle.dart';
import 'package:capstone_reviewer/features/upload/presentation/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UploadScreen shows three slots in order and locked analyze', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: UploadScreen()),
      ),
    );

    final regFinder = find.text('Phiếu Đăng Ký Đề Tài');
    final srsFinder = find.text('File SRS (Đặc tả dự án)');
    final excelFinder = find.text('File Test Report (Excel)');

    expect(regFinder, findsOneWidget);
    expect(srsFinder, findsOneWidget);
    expect(excelFinder, findsOneWidget);
    expect(find.text('BẮT ĐẦU PHÂN TÍCH (REVIEW)'), findsOneWidget);
    expect(find.textContaining('Chưa sẵn sàng: thiếu'), findsOneWidget);
    expect(find.text('HỦY'), findsNothing);

    // Card order: Registration (leftmost) -> SRS (middle) -> Excel (rightmost)
    final regX = tester.getTopLeft(regFinder).dx;
    final srsX = tester.getTopLeft(srsFinder).dx;
    final excelX = tester.getTopLeft(excelFinder).dx;
    expect(regX < srsX, isTrue);
    expect(srsX < excelX, isTrue);

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


  test('registration is mandatory for canAnalyze; wrong vendor key errors immediately', () {
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

    // Verify canAnalyze strictly requires registrationPath
    final stateWithoutReg = UploadState(
      excelPath: 'test.xlsx',
      srsPath: 'test.docx',
      registrationPath: null,
      apiKey: 'AIzaSyValidGeminiKeyFormat123456789012345',
      provider: AIProvider.gemini,
    );
    expect(stateWithoutReg.canAnalyze, isFalse);
    expect(stateWithoutReg.missingInputs, contains('Phiếu đăng ký'));

    final stateWithAllThree = stateWithoutReg.copyWith(
      registrationPath: 'registration.docx',
    );
    expect(stateWithAllThree.canAnalyze, isTrue);
    expect(stateWithAllThree.missingInputs, isEmpty);
  });
  test('clearError drops previous error', () {
    final state = UploadState(error: 'cũ');
    expect(state.clearError().error, isNull);
    expect(state.error, 'cũ');
  });

  testWidgets('ReviewScreen renders 6 tabs with Detailed Test Cases default', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const rec1 = TestCaseRecord(
      sheet: 'M01',
      id: 'TC_LOGIN_01',
      description: 'Kiểm thử đăng nhập admin',
      preCondition: 'Đã có tài khoản admin',
      steps: '1. Nhập thông tin',
      testData: 'admin/123',
      expected: 'Đăng nhập thành công vào Dashboard',
      status: 'Passed',
      testDate: '2026-09-18',
    );

    final caseReviews = TestCaseReviewEngine.reviewAll(records: [rec1]);

    final bundle = ReviewBundle(
      markdown: '# Báo cáo',
      stats: computeCoverage(srsText: '', records: [rec1], unknownModules: const []),
      checks: const [],
      records: const [rec1],
      caseReviews: caseReviews,
    );

    await tester.pumpWidget(
      MaterialApp(home: ReviewScreen(bundle: bundle)),
    );
    await tester.pumpAndSettle();

    // Check that 6 tab labels exist
    expect(find.text('Chi tiết Test Case'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('Đối chiếu 3 nguồn'), findsOneWidget);
    expect(find.text('Lỗi & Toàn vẹn'), findsOneWidget);
    expect(find.text('Nhận định đã xác minh'), findsOneWidget);
    expect(find.text('Báo cáo đầy đủ'), findsOneWidget);

    // Default active tab is Detailed Test Cases, so TC_LOGIN_01 is visible
    expect(find.text('TC_LOGIN_01'), findsOneWidget);
    expect(find.text('Kiểm thử đăng nhập admin'), findsOneWidget);

    // Tap on row opens detail dialog
    await tester.tap(find.text('TC_LOGIN_01'));
    await tester.pumpAndSettle();

    expect(find.text('KẾT QUẢ ĐÁNH GIÁ CHẤT LƯỢNG (0 vấn đề)'), findsOneWidget);
    expect(find.text('Mô tả kiểm thử (Description)'), findsOneWidget);
  });
}
