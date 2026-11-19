import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:playbilld/src/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
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
    final reviews = _decodeReviews(rawReviews);
    final watchlist = prefs.getStringList(_watchlistKey) ?? const [];
    final likes = prefs.getStringList(_likesKey) ?? const [];

    return TheaterLogSnapshot(
      userReviews: reviews,
      watchlistIds: watchlist.toSet(),
      likedShowIds: likes.toSet(),
    );
  }

  List<ShowReview> _decodeReviews(String? rawReviews) {
    if (rawReviews == null || rawReviews.isEmpty) {
      return const [];
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(rawReviews);
    } on FormatException {
      return const [];
    }

    if (decoded is! List<Object?>) {
      return const [];
    }

    final reviews = <ShowReview>[];
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      try {
        reviews.add(ShowReview.fromJson(item));
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return reviews;
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
