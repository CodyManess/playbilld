// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(theaterLogService)
final theaterLogServiceProvider = TheaterLogServiceProvider._();

final class TheaterLogServiceProvider
    extends
        $FunctionalProvider<
          TheaterLogService,
          TheaterLogService,
          TheaterLogService
        >
    with $Provider<TheaterLogService> {
  TheaterLogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'theaterLogServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$theaterLogServiceHash();

  @$internal
  @override
  $ProviderElement<TheaterLogService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TheaterLogService create(Ref ref) {
    return theaterLogService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TheaterLogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TheaterLogService>(value),
    );
  }
}

String _$theaterLogServiceHash() => r'2cb80aca19f8a0fa486096701377c22b7d2d7fa0';

@ProviderFor(TheaterLogNotifier)
final theaterLogProvider = TheaterLogNotifierProvider._();

final class TheaterLogNotifierProvider
    extends $NotifierProvider<TheaterLogNotifier, TheaterLogState> {
  TheaterLogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'theaterLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$theaterLogNotifierHash();

  @$internal
  @override
  TheaterLogNotifier create() => TheaterLogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TheaterLogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TheaterLogState>(value),
    );
  }
}

String _$theaterLogNotifierHash() =>
    r'c986088977ef947f387df6f9091cdf58ce18ab19';

abstract class _$TheaterLogNotifier extends $Notifier<TheaterLogState> {
  TheaterLogState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TheaterLogState, TheaterLogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TheaterLogState, TheaterLogState>,
              TheaterLogState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Combines the user's reviews and community reviews for a given [showId].

@ProviderFor(reviewsForShow)
final reviewsForShowProvider = ReviewsForShowFamily._();

/// Combines the user's reviews and community reviews for a given [showId].

final class ReviewsForShowProvider
    extends
        $FunctionalProvider<
          List<ShowReview>,
          List<ShowReview>,
          List<ShowReview>
        >
    with $Provider<List<ShowReview>> {
  /// Combines the user's reviews and community reviews for a given [showId].
  ReviewsForShowProvider._({
    required ReviewsForShowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reviewsForShowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewsForShowHash();

  @override
  String toString() {
    return r'reviewsForShowProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ShowReview>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ShowReview> create(Ref ref) {
    final argument = this.argument as String;
    return reviewsForShow(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ShowReview> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ShowReview>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewsForShowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewsForShowHash() => r'e24adaa532cb21e44cf049643370d119fe42a0db';

/// Combines the user's reviews and community reviews for a given [showId].

final class ReviewsForShowFamily extends $Family
    with $FunctionalFamilyOverride<List<ShowReview>, String> {
  ReviewsForShowFamily._()
    : super(
        retry: null,
        name: r'reviewsForShowProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Combines the user's reviews and community reviews for a given [showId].

  ReviewsForShowProvider call(String showId) =>
      ReviewsForShowProvider._(argument: showId, from: this);

  @override
  String toString() => r'reviewsForShowProvider';
}

/// Computes the show's rating factoring in any user reviews logged locally.

@ProviderFor(effectiveShowRating)
final effectiveShowRatingProvider = EffectiveShowRatingFamily._();

/// Computes the show's rating factoring in any user reviews logged locally.

final class EffectiveShowRatingProvider
    extends
        $FunctionalProvider<
          ({int count, double rating}),
          ({int count, double rating}),
          ({int count, double rating})
        >
    with $Provider<({int count, double rating})> {
  /// Computes the show's rating factoring in any user reviews logged locally.
  EffectiveShowRatingProvider._({
    required EffectiveShowRatingFamily super.from,
    required Show super.argument,
  }) : super(
         retry: null,
         name: r'effectiveShowRatingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$effectiveShowRatingHash();

  @override
  String toString() {
    return r'effectiveShowRatingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<({int count, double rating})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int count, double rating}) create(Ref ref) {
    final argument = this.argument as Show;
    return effectiveShowRating(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int count, double rating}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int count, double rating})>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EffectiveShowRatingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$effectiveShowRatingHash() =>
    r'de44e1de8653b2800aecc8f270d9a363846958d7';

/// Computes the show's rating factoring in any user reviews logged locally.

final class EffectiveShowRatingFamily extends $Family
    with $FunctionalFamilyOverride<({int count, double rating}), Show> {
  EffectiveShowRatingFamily._()
    : super(
        retry: null,
        name: r'effectiveShowRatingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Computes the show's rating factoring in any user reviews logged locally.

  EffectiveShowRatingProvider call(Show show) =>
      EffectiveShowRatingProvider._(argument: show, from: this);

  @override
  String toString() => r'effectiveShowRatingProvider';
}

/// Aggregate theatergoing stats for the Profile / Diary views.

@ProviderFor(userTheaterStats)
final userTheaterStatsProvider = UserTheaterStatsProvider._();

/// Aggregate theatergoing stats for the Profile / Diary views.

final class UserTheaterStatsProvider
    extends
        $FunctionalProvider<
          UserTheaterStats,
          UserTheaterStats,
          UserTheaterStats
        >
    with $Provider<UserTheaterStats> {
  /// Aggregate theatergoing stats for the Profile / Diary views.
  UserTheaterStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userTheaterStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userTheaterStatsHash();

  @$internal
  @override
  $ProviderElement<UserTheaterStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserTheaterStats create(Ref ref) {
    return userTheaterStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserTheaterStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserTheaterStats>(value),
    );
  }
}

String _$userTheaterStatsHash() => r'417af935860a9bd3bf752b3c59e8b7a8c071d8ed';
