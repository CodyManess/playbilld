import 'dart:convert';

import 'package:playbilld/src/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TheaterLogSnapshot {
  final List<ShowReview> userReviews;
  final Set<String> watchlistIds;
  final Set<String> likedShowIds;

  const TheaterLogSnapshot({
    this.userReviews = const [],
    this.watchlistIds = const {},
    this.likedShowIds = const {},
  });
}

/// Persists user theater logs, reviews, watchlist, and liked shows locally.
class TheaterLogService {
  static const _reviewsKey = 'user_reviews';
  static const _watchlistKey = 'watchlist_show_ids';
  static const _likesKey = 'liked_show_ids';

  Future<TheaterLogSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();

    final rawReviews = prefs.getString(_reviewsKey);
    final List<ShowReview> reviews;
    if (rawReviews == null || rawReviews.isEmpty) {
      reviews = const [];
    } else {
      final decoded = jsonDecode(rawReviews) as List<dynamic>;
      reviews = decoded
          .map((item) => ShowReview.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final watchlist = prefs.getStringList(_watchlistKey) ?? const [];
    final likes = prefs.getStringList(_likesKey) ?? const [];

    return TheaterLogSnapshot(
      userReviews: reviews,
      watchlistIds: watchlist.toSet(),
      likedShowIds: likes.toSet(),
    );
  }

  Future<void> saveReviews(List<ShowReview> reviews) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(reviews.map((r) => r.toJson()).toList());
    await prefs.setString(_reviewsKey, encoded);
  }

  Future<void> saveWatchlist(Set<String> showIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_watchlistKey, showIds.toList());
  }

  Future<void> saveLikes(Set<String> showIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likesKey, showIds.toList());
  }
}
