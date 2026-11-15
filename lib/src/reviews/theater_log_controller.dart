import 'package:playbilld/src/mock/mock_reviews.dart';
import 'package:playbilld/src/models/review.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'theater_log_service.dart';

part 'theater_log_controller.g.dart';

class TheaterLogState {
  final List<ShowReview> userReviews;
  final Set<String> watchlistIds;
  final Set<String> likedShowIds;

  const TheaterLogState({
    this.userReviews = const [],
    this.watchlistIds = const {},
    this.likedShowIds = const {},
  });

  TheaterLogState copyWith({
    List<ShowReview>? userReviews,
    Set<String>? watchlistIds,
    Set<String>? likedShowIds,
  }) {
    return TheaterLogState(
      userReviews: userReviews ?? this.userReviews,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      likedShowIds: likedShowIds ?? this.likedShowIds,
    );
  }
}

class UserTheaterStats {
  final int loggedCount;
  final int writtenReviewCount;
  final int watchlistCount;
  final int likedCount;
  final double? averageRating;

  const UserTheaterStats({
    required this.loggedCount,
    required this.writtenReviewCount,
    required this.watchlistCount,
    required this.likedCount,
    required this.averageRating,
  });
}

@Riverpod(keepAlive: true)
TheaterLogService theaterLogService(Ref ref) {
  return TheaterLogService();
}

@Riverpod(keepAlive: true)
class TheaterLogNotifier extends _$TheaterLogNotifier {
  @override
  TheaterLogState build() {
    return const TheaterLogState();
  }

  Future<void> loadLogs() async {
    final snapshot = await ref.read(theaterLogServiceProvider).load();
    state = TheaterLogState(
      userReviews: snapshot.userReviews,
      watchlistIds: snapshot.watchlistIds,
      likedShowIds: snapshot.likedShowIds,
    );
  }

  Future<void> saveReview(ShowReview review) async {
    final existingIndex = state.userReviews.indexWhere(
      (item) => item.id == review.id,
    );
    final updated = [...state.userReviews];
    if (existingIndex >= 0) {
      updated[existingIndex] = review;
    } else {
      updated.insert(0, review);
    }
    updated.sort((a, b) => b.watchedDate.compareTo(a.watchedDate));

    final updatedLikes = {...state.likedShowIds};
    if (review.liked) {
      updatedLikes.add(review.showId);
    }

    state = state.copyWith(userReviews: updated, likedShowIds: updatedLikes);

    final service = ref.read(theaterLogServiceProvider);
    await service.saveReviews(updated);
    await service.saveLikes(updatedLikes);
  }

  Future<void> deleteReview(String reviewId) async {
    final updated = state.userReviews
        .where((item) => item.id != reviewId)
        .toList();
    state = state.copyWith(userReviews: updated);
    await ref.read(theaterLogServiceProvider).saveReviews(updated);
  }

  Future<void> toggleWatchlist(String showId) async {
    final updated = {...state.watchlistIds};
    if (!updated.add(showId)) {
      updated.remove(showId);
    }
    state = state.copyWith(watchlistIds: updated);
    await ref.read(theaterLogServiceProvider).saveWatchlist(updated);
  }

  Future<void> toggleLike(String showId) async {
    final updated = {...state.likedShowIds};
    if (!updated.add(showId)) {
      updated.remove(showId);
    }
    state = state.copyWith(likedShowIds: updated);
    await ref.read(theaterLogServiceProvider).saveLikes(updated);
  }
}

/// Combines the user's reviews and community reviews for a given [showId].
@riverpod
List<ShowReview> reviewsForShow(Ref ref, String showId) {
  final userReviews = ref
      .watch(theaterLogProvider)
      .userReviews
      .where((review) => review.showId == showId);
  final community = mockCommunityReviews.where(
    (review) => review.showId == showId,
  );

  return [...userReviews, ...community]
    ..sort((a, b) => b.watchedDate.compareTo(a.watchedDate));
}

/// Computes the show's rating factoring in any user reviews logged locally.
@riverpod
({double rating, int count}) effectiveShowRating(Ref ref, Show show) {
  final userReviews = ref
      .watch(theaterLogProvider)
      .userReviews
      .where((review) => review.showId == show.id)
      .toList();

  if (userReviews.isEmpty) {
    return (rating: show.averageRating, count: show.reviewCount);
  }

  final baseTotal = show.averageRating * show.reviewCount;
  final userTotal = userReviews.fold<double>(0, (sum, r) => sum + r.rating);
  final totalCount = show.reviewCount + userReviews.length;
  final combined = (baseTotal + userTotal) / totalCount;
  return (rating: double.parse(combined.toStringAsFixed(1)), count: totalCount);
}

/// Aggregate theatergoing stats for the Profile / Diary views.
@riverpod
UserTheaterStats userTheaterStats(Ref ref) {
  final logState = ref.watch(theaterLogProvider);
  final reviews = logState.userReviews;
  final writtenCount = reviews
      .where((review) => review.body.trim().isNotEmpty)
      .length;
  final double? avg = reviews.isEmpty
      ? null
      : double.parse(
          (reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviews.length)
              .toStringAsFixed(1),
        );

  return UserTheaterStats(
    loggedCount: reviews.length,
    writtenReviewCount: writtenCount,
    watchlistCount: logState.watchlistIds.length,
    likedCount: logState.likedShowIds.length,
    averageRating: avg,
  );
}
