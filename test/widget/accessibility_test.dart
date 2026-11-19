import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:playbilld/src/app.dart';
import 'package:playbilld/src/shared/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _verifyAccessibilityGuidelines(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

Future<void> _pumpWithScale(
  WidgetTester tester,
  Future<void> Function(ProviderContainer container) body, {
  double textScale = 1.0,
}) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  await mockNetworkImagesFor(() async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          textScaler: TextScaler.linear(textScale),
        ),
        child: UncontrolledProviderScope(
          container: container,
          child: const MyApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await body(container);
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('All primary views satisfy Flutter accessibility guidelines', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    try {
      await _pumpWithScale(tester, (container) async {
        // Discover (HomeView)
        await _verifyAccessibilityGuidelines(tester);

        // Browse
        await tester.tap(find.text('Browse').last);
        await tester.pumpAndSettle();
        await _verifyAccessibilityGuidelines(tester);

        // Diary
        await tester.tap(find.text('Diary').last);
        await tester.pumpAndSettle();
        await _verifyAccessibilityGuidelines(tester);

        // Profile
        await tester.tap(find.text('Profile').last);
        await tester.pumpAndSettle();
        await _verifyAccessibilityGuidelines(tester);

        // ShowDetailView
        container.read(goRouterProvider).go('/shows/wicked');
        await tester.pumpAndSettle();
        await _verifyAccessibilityGuidelines(tester);

        // SettingsView
        container.read(goRouterProvider).go('/settings');
        await tester.pumpAndSettle();
        await _verifyAccessibilityGuidelines(tester);
      });
    } finally {
      handle.dispose();
    }
  });

  testWidgets('App layouts render without overflow at 1.5x text scale', (
    WidgetTester tester,
  ) async {
    await _pumpWithScale(tester, (container) async {
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Browse').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      container.read(goRouterProvider).go('/shows/wicked');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }, textScale: 1.5);
  });
}
