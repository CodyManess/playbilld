import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:playbilld/src/app.dart';
import 'package:playbilld/src/settings/settings_controller.dart';
import 'package:playbilld/src/shared/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpApp(
  WidgetTester tester,
  Future<void> Function(ProviderContainer container) body,
) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  await mockNetworkImagesFor(() async {
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();
    await body(container);
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'AppShell navigates across Discover, Browse, Diary, and Profile',
    (WidgetTester tester) async {
      await _pumpApp(tester, (container) async {
        expect(find.text('Playbilld'), findsOneWidget);
        expect(find.text('Now Playing'), findsOneWidget);
        expect(find.text('Top Rated Theater'), findsOneWidget);

        await tester.tap(find.text('Browse').last);
        await tester.pumpAndSettle();
        expect(find.text('Browse Theater'), findsOneWidget);

        await tester.tap(find.text('Play').first);
        await tester.pumpAndSettle();
        expect(find.text('Oh, Mary!'), findsOneWidget);
        expect(find.text('Wicked'), findsNothing);

        await tester.tap(find.text('Diary').last);
        await tester.pumpAndSettle();
        expect(find.text('Your Playbilld diary is empty'), findsOneWidget);

        await tester.tap(find.text('Profile').last);
        await tester.pumpAndSettle();
        expect(find.text('Profile & Lists'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
        expect(find.text('Settings'), findsOneWidget);

        await tester.tap(find.text('Dark'));
        await tester.pumpAndSettle();
        expect(container.read(themeModeProvider), ThemeMode.dark);
      });
    },
  );

  testWidgets('Logging a review from ShowDetailView appears in Diary', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester, (container) async {
      unawaited(container.read(goRouterProvider).push('/shows/wicked'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Wicked'), findsOneWidget);

      await tester.tap(find.text('Log / Review'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        'Unforgettable vocals at the Gershwin.',
      );
      await tester.tap(find.text('Save Log'));
      await tester.pumpAndSettle();

      expect(
        find.text('Unforgettable vocals at the Gershwin.'),
        findsOneWidget,
      );
      expect(find.text('Edit Your Log'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Diary').last);
      await tester.pumpAndSettle();

      expect(
        find.text('Unforgettable vocals at the Gershwin.'),
        findsOneWidget,
      );
    });
  });

  testWidgets(
    'Deep link /shows/:id resolves show, navigates home, and unknown ID shows fallback',
    (WidgetTester tester) async {
      await _pumpApp(tester, (container) async {
        container.read(goRouterProvider).go('/shows/wicked');
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Wicked'), findsOneWidget);
        expect(find.byTooltip('Back to Discover'), findsOneWidget);

        await tester.tap(find.byTooltip('Back to Discover'));
        await tester.pumpAndSettle();
        expect(find.text('Playbilld'), findsOneWidget);

        container.read(goRouterProvider).go('/shows/does-not-exist');
        await tester.pumpAndSettle();
        expect(find.text('Page Not Found'), findsOneWidget);
        expect(find.text('Go Home'), findsOneWidget);
      });
    },
  );
}
