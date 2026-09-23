import 'package:capstone_reviewer/core/services/ai_service.dart';
import 'package:capstone_reviewer/core/services/settings_service.dart';
import 'package:capstone_reviewer/features/upload/presentation/upload_controller.dart';
import 'package:capstone_reviewer/core/extraction/test_case_schema.dart';
import 'package:capstone_reviewer/core/services/coverage_stats.dart';
import 'package:capstone_reviewer/core/services/test_case_review_engine.dart';
import 'package:capstone_reviewer/features/review/presentation/review_screen.dart';
import 'package:capstone_reviewer/features/review/review_bundle.dart';
import 'package:capstone_reviewer/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('DashboardScreen shows three slots in order and locked analyze', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    final regFinder = find.text('Phiếu Đăng Ký');
    final srsFinder = find.text('SRS');
    final excelFinder = find.text('Test Cases');

    expect(regFinder, findsOneWidget);
    expect(srsFinder, findsOneWidget);
    expect(excelFinder, findsOneWidget);
    expect(find.text('PHÂN TÍCH'), findsOneWidget);

    final button = tester.widget<FilledButton>(
      find.widgetWithIcon(FilledButton, Icons.analytics),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('drop zones do not overflow on short window', (tester) async {
    tester.view.physicalSize = const Size(1600, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Test Cases'), findsOneWidget);
  });


  test('registration is mandatory for canAnalyze; wrong vendor key errors immediately', () async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
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
    expect(
      find.text('Không phát hiện vấn đề theo các rule deterministic đã chạy; không kết luận testcase đúng.'),
      findsOneWidget,
    );
    expect(find.text('Mô tả kiểm thử (Description)'), findsOneWidget);

    // Close dialog
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Navigate to Tổng quan (Overview) tab when crossCheck is null
    await tester.tap(find.text('Tổng quan'));
    await tester.pumpAndSettle();

    expect(find.text('Đối chiếu 3 nguồn: Chưa khả dụng'), findsOneWidget);
    expect(find.text('Chưa thực hiện / N/A từ Excel'), findsOneWidget);

    // Navigate to Lỗi & Toàn vẹn (Integrity) tab when crossCheck is null
    await tester.tap(find.text('Lỗi & Toàn vẹn'));
    await tester.pumpAndSettle();

    expect(
      find.text('Đối chiếu chéo chưa khả dụng: Chưa thể kiểm tra trùng lặp ID và mâu thuẫn trạng thái giữa các sheet.'),
      findsOneWidget,
    );
  });

  testWidgets('DetailedTestCasesTab filters by issue code correctly', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const rec1 = TestCaseRecord(
      sheet: 'M01',
      id: '', // missing-id (critical)
      description: 'Kiểm thử 1',
      steps: 'Bước 1',
      expected: 'Kết quả rõ ràng',
      status: 'Passed',
    );

    const rec2 = TestCaseRecord(
      sheet: 'M01',
      id: 'TC02',
      description: '', // missing-description (high)
      steps: 'Bước 1',
      expected: 'Kết quả rõ ràng',
      status: 'Passed',
    );

    final caseReviews = TestCaseReviewEngine.reviewAll(records: [rec1, rec2]);

    final bundle = ReviewBundle(
      markdown: '# Báo cáo',
      stats: computeCoverage(srsText: '', records: [rec1, rec2], unknownModules: const []),
      checks: const [],
      records: const [rec1, rec2],
      caseReviews: caseReviews,
    );

    await tester.pumpWidget(
      MaterialApp(home: ReviewScreen(bundle: bundle)),
    );
    await tester.pumpAndSettle();

    // Both records displayed initially
    expect(find.text('Kiểm thử 1'), findsOneWidget);
    expect(find.text('TC02'), findsOneWidget);

    // Find issue code dropdown and select 'Mã: missing-id'
    final issueCodeDropdown = find.text('Tất cả mã lỗi');
    expect(issueCodeDropdown, findsOneWidget);
    await tester.tap(issueCodeDropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mã: missing-id').last);
    await tester.pumpAndSettle();

    // Only rec1 remains
    expect(find.text('Kiểm thử 1'), findsOneWidget);
    expect(find.text('TC02'), findsNothing);
  });
}
