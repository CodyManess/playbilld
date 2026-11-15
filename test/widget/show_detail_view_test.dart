import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  final mockShow = Show(
    id: 'awesome-musical',
    title: 'Awesome Musical',
    description: 'A truly awesome musical.',
    form: TheaterForm.musical,
    genre: 'Musical Theatre',
    creators: const ['Composer X'],
    cast: const ['Actor A', 'Actress B'],
    runs: [
      TheaterRun(
        id: 'awesome-broadway',
        productionName: 'Original Broadway Run',
        venue: 'Majestic Theatre',
        city: 'New York',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
      ),
    ],
    averageRating: 4.5,
    reviewCount: 20,
    posterImageUrl: 'http://example.com/poster.jpg',
  );

  testWidgets('ShowDetailView displays show, run details, and actions', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: ShowDetailView(show: mockShow)),
        ),
      );

      expect(find.widgetWithText(AppBar, 'Awesome Musical'), findsOneWidget);
      expect(find.text('A truly awesome musical.'), findsOneWidget);
      expect(find.text('Musical'), findsWidgets);
      expect(find.text('Musical Theatre'), findsOneWidget);
      expect(find.text('Composer X'), findsOneWidget);
      expect(find.text('Actor A, Actress B'), findsOneWidget);
      expect(find.text('Original Broadway Run'), findsOneWidget);
      expect(find.textContaining('Majestic Theatre, New York'), findsOneWidget);

      final dateFormat = DateFormat.yMMMd();
      expect(
        find.textContaining(
          '${dateFormat.format(DateTime(2024, 1, 1))} – ${dateFormat.format(DateTime(2024, 12, 31))}',
        ),
        findsOneWidget,
      );
      expect(find.text('4.5/5 (20)'), findsOneWidget);

      await tester.tap(find.text('Watchlist'));
      await tester.pump();
      expect(find.text('Watchlisted'), findsOneWidget);

      await tester.tap(find.text('Like'));
      await tester.pump();
      expect(find.text('Liked'), findsOneWidget);

      expect(find.byType(Image), findsOneWidget);
      final Image image = tester.widget(find.byType(Image));
      expect(image.image, isA<NetworkImage>());
      expect(
        (image.image as NetworkImage).url,
        'http://example.com/poster.jpg',
      );
    });
  });
}
