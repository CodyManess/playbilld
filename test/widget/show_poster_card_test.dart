import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/playbill_card.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final mockShow = Show(
    title: 'Awesome Musical',
    description: 'A truly awesome musical.',
    genre: 'Musical Theatre',
    cast: ['Actor A', 'Actress B'],
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 12, 31),
    averageRating: 9.5,
    posterImageUrl: 'http://example.com/poster.jpg',
  );

  testWidgets('ShowPosterCard displays image and handles tap for navigation', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(body: ShowPosterCard(show: mockShow)),
        ),
        GoRoute(
          path: '/show_details',
          builder: (context, state) {
            final show = state.extra as Show;
            return Scaffold(body: Text('Show Details: ${show.title}'));
          },
        ),
      ],
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));

      // Verify GestureDetector
      expect(find.byType(GestureDetector), findsOneWidget);

      // Simulate tap
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify navigation occurred
      expect(find.text('Show Details: ${mockShow.title}'), findsOneWidget);
    });
  });
}
