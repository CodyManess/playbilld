import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

void main() {
  final mockShow = Show(
    id: 'awesome-musical',
    title: 'Awesome Musical',
    description: 'A truly awesome musical.',
    form: TheaterForm.musical,
    genre: 'Musical Theatre',
    cast: const ['Actor A', 'Actress B'],
    runs: [
      TheaterRun(
        id: 'awesome-broadway',
        productionName: 'Original Broadway Run',
        venue: 'Majestic Theatre',
        city: 'New York',
        startDate: DateTime(2024, 1, 1),
      ),
    ],
    averageRating: 4.5,
    reviewCount: 12,
    posterImageUrl: 'http://example.com/poster.jpg',
  );

  testWidgets('ShowPosterCard displays title, venue, and handles tap', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              Scaffold(body: ShowPosterCard(show: mockShow)),
        ),
        GoRoute(
          path: '/shows/:id',
          builder: (context, state) {
            final show = state.extra as Show;
            return Scaffold(
              body: Text(
                'Show Details: ${show.title} (${state.pathParameters['id']})',
              ),
            );
          },
        ),
      ],
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      expect(find.text('Awesome Musical'), findsOneWidget);
      expect(find.text('Majestic Theatre'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(
        find.text('Show Details: ${mockShow.title} (${mockShow.id})'),
        findsOneWidget,
      );
    });
  });
}
