import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/review.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TheaterRun & Show statusAt', () {
    test('reports upcoming, nowPlaying, and closed accurately', () {
      final run = TheaterRun(
        id: 'test-run',
        productionName: 'Limited Run',
        venue: 'Test Theatre',
        city: 'New York',
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 8, 1),
      );

      expect(run.statusAt(DateTime(2026, 4, 30)), RunStatus.upcoming);
      expect(run.statusAt(DateTime(2026, 6, 15)), RunStatus.nowPlaying);
      expect(run.statusAt(DateTime(2026, 8, 2)), RunStatus.closed);
    });
  });

  group('TheaterLogNotifier & stats', () {
    test(
      'persists reviews, watchlist, and likes across container loads',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(theaterLogProvider.notifier);
        await notifier.toggleWatchlist('wicked');
        await notifier.saveReview(
          ShowReview(
            id: 'rev-1',
            showId: 'hadestown',
            runId: 'hadestown-broadway',
            runLabel: 'Broadway Production • Walter Kerr Theatre',
            authorName: 'You',
            rating: 5.0,
            liked: true,
            body: 'Stunning staging.',
            watchedDate: DateTime(2026, 11, 1),
            createdAt: DateTime(2026, 11, 1),
            isUserReview: true,
          ),
        );

        final stats = container.read(userTheaterStatsProvider);
        expect(stats.loggedCount, 1);
        expect(stats.writtenReviewCount, 1);
        expect(stats.watchlistCount, 1);
        expect(stats.likedCount, 1);
        expect(stats.averageRating, 5.0);

        final reloadedContainer = ProviderContainer();
        addTearDown(reloadedContainer.dispose);
        await reloadedContainer.read(theaterLogProvider.notifier).loadLogs();

        final reloaded = reloadedContainer.read(theaterLogProvider);
        expect(reloaded.watchlistIds, {'wicked'});
        expect(reloaded.likedShowIds, {'hadestown'});
        expect(reloaded.userReviews.length, 1);
        expect(reloaded.userReviews.first.body, 'Stunning staging.');
      },
    );

    test('browseFilterProvider filters by form, status, and query', () {
      final container = ProviderContainer(
        overrides: [
          currentDateProvider.overrideWithValue(DateTime(2026, 11, 15)),
        ],
      );
      addTearDown(container.dispose);

      final filterNotifier = container.read(browseFilterProvider.notifier);
      filterNotifier.setForm(TheaterForm.play);
      final plays = container.read(filteredShowsProvider);
      expect(plays.every((s) => s.form == TheaterForm.play), isTrue);

      filterNotifier.clearAll();
      filterNotifier.setStatus(RunStatus.upcoming);
      final upcoming = container.read(filteredShowsProvider);
      expect(
        upcoming.map((s) => s.id),
        containsAll(['swan-lake-2027', 'la-boheme-2027']),
      );

      filterNotifier.clearAll();
      filterNotifier.setQuery('Gershwin');
      final byVenue = container.read(filteredShowsProvider);
      expect(byVenue.map((s) => s.id), ['wicked']);
    });
  });
}
