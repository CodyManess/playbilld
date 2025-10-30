import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';

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

  testWidgets('ShowDetailView displays show details correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ShowDetailView(show: mockShow),
    ));

    // Verify AppBar title
    expect(find.widgetWithText(AppBar, 'Awesome Musical'), findsOneWidget);

    // Verify description
    expect(find.text('A truly awesome musical.'), findsOneWidget);

    // Verify genre in ListTile
    expect(find.widgetWithText(ListTile, 'Musical Theatre'), findsOneWidget);

    // Verify cast in ListTile
    expect(find.widgetWithText(ListTile, 'Actor A, Actress B'), findsOneWidget);

    // Verify dates in ListTile
    expect(find.widgetWithText(ListTile, '2024-01-01 - 2024-12-31'), findsOneWidget);

    // Verify rating in ListTile
    expect(find.widgetWithText(ListTile, '9.5/10'), findsOneWidget);

    // Verify Image.network
    expect(find.byType(Image), findsOneWidget); // Checks for Image widget
    final Image image = tester.widget(find.byType(Image));
    expect(image.image, isA<NetworkImage>());
    expect((image.image as NetworkImage).url, 'http://example.com/poster.jpg');

  });
}
