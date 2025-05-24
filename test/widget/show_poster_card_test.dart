import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/src/models/show.dart';
import 'package:flutter_application/src/shared/playbill_card.dart';
import 'package:flutter_application/src/shared/show_detail_view.dart'; // For ShowDetailView.routeName

// Mock NavigatorObserver to track navigation events
class MockNavigatorObserver extends NavigatorObserver {
  String? lastPushedRoute;
  Object? lastPushedArguments;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushedRoute = route.settings.name;
    lastPushedArguments = route.settings.arguments;
    super.didPush(route, previousRoute);
  }
}

// A simple placeholder widget to use for mocked routes
class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Placeholder')));
  }
}

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
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ShowPosterCard(show: mockShow)),
      navigatorObservers: [mockObserver],
      routes: {
        ShowDetailView.routeName: (_) => const PlaceholderWidget(), // Dummy route for navigation target
      },
    ));

    // Verify Image.network
    expect(find.byType(Image), findsOneWidget);
    final Image image = tester.widget(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
    expect((image.image as NetworkImage).url, 'http://example.com/poster.jpg');

    // Verify GestureDetector
    expect(find.byType(GestureDetector), findsOneWidget);

    // Simulate tap
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify navigation
    expect(mockObserver.lastPushedRoute, ShowDetailView.routeName);
    expect(mockObserver.lastPushedArguments, isA<Show>());
    expect((mockObserver.lastPushedArguments as Show).title, mockShow.title);
  });
}
