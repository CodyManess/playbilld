// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shows_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reference date used to determine whether a run is now playing, upcoming, or closed.

@ProviderFor(currentDate)
final currentDateProvider = CurrentDateProvider._();

/// Reference date used to determine whether a run is now playing, upcoming, or closed.

final class CurrentDateProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// Reference date used to determine whether a run is now playing, upcoming, or closed.
  CurrentDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDateHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return currentDate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentDateHash() => r'47eb6f7c6298cdca8b6f56e5781d8cbd6672a4cd';

/// Provides the full catalog of shows.

@ProviderFor(shows)
final showsProvider = ShowsProvider._();

/// Provides the full catalog of shows.

final class ShowsProvider
    extends $FunctionalProvider<List<Show>, List<Show>, List<Show>>
    with $Provider<List<Show>> {
  /// Provides the full catalog of shows.
  ShowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showsHash();

  @$internal
  @override
  $ProviderElement<List<Show>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Show> create(Ref ref) {
    return shows(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Show> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Show>>(value),
    );
  }
}

String _$showsHash() => r'1e090f829f2dc950a4e53812aa953cd514917efd';

/// Looks up a single [Show] by its route [id], returning `null` if not found.

@ProviderFor(showById)
final showByIdProvider = ShowByIdFamily._();

/// Looks up a single [Show] by its route [id], returning `null` if not found.

final class ShowByIdProvider extends $FunctionalProvider<Show?, Show?, Show?>
    with $Provider<Show?> {
  /// Looks up a single [Show] by its route [id], returning `null` if not found.
  ShowByIdProvider._({
    required ShowByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'showByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$showByIdHash();

  @override
  String toString() {
    return r'showByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Show?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Show? create(Ref ref) {
    final argument = this.argument as String;
    return showById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Show? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Show?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShowByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$showByIdHash() => r'c2317e4b8d50a57ccdf43b0b354a546d75f6476f';

/// Looks up a single [Show] by its route [id], returning `null` if not found.

final class ShowByIdFamily extends $Family
    with $FunctionalFamilyOverride<Show?, String> {
  ShowByIdFamily._()
    : super(
        retry: null,
        name: r'showByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Looks up a single [Show] by its route [id], returning `null` if not found.

  ShowByIdProvider call(String id) =>
      ShowByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'showByIdProvider';
}

/// Shows that currently have an active run.

@ProviderFor(nowPlayingShows)
final nowPlayingShowsProvider = NowPlayingShowsProvider._();

/// Shows that currently have an active run.

final class NowPlayingShowsProvider
    extends $FunctionalProvider<List<Show>, List<Show>, List<Show>>
    with $Provider<List<Show>> {
  /// Shows that currently have an active run.
  NowPlayingShowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowPlayingShowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowPlayingShowsHash();

  @$internal
  @override
  $ProviderElement<List<Show>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Show> create(Ref ref) {
    return nowPlayingShows(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Show> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Show>>(value),
    );
  }
}

String _$nowPlayingShowsHash() => r'41d76bd8e0ea6a78796d12f58e0a87a9119609da';

/// Shows with upcoming runs that have not yet opened.

@ProviderFor(upcomingShows)
final upcomingShowsProvider = UpcomingShowsProvider._();

/// Shows with upcoming runs that have not yet opened.

final class UpcomingShowsProvider
    extends $FunctionalProvider<List<Show>, List<Show>, List<Show>>
    with $Provider<List<Show>> {
  /// Shows with upcoming runs that have not yet opened.
  UpcomingShowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingShowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingShowsHash();

  @$internal
  @override
  $ProviderElement<List<Show>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Show> create(Ref ref) {
    return upcomingShows(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Show> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Show>>(value),
    );
  }
}

String _$upcomingShowsHash() => r'a99653ef0a2d07fb65959ee35498593445e29fb8';

/// Shows sorted by community rating descending (for spotlight / acclaim).

@ProviderFor(topRatedShows)
final topRatedShowsProvider = TopRatedShowsProvider._();

/// Shows sorted by community rating descending (for spotlight / acclaim).

final class TopRatedShowsProvider
    extends $FunctionalProvider<List<Show>, List<Show>, List<Show>>
    with $Provider<List<Show>> {
  /// Shows sorted by community rating descending (for spotlight / acclaim).
  TopRatedShowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topRatedShowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topRatedShowsHash();

  @$internal
  @override
  $ProviderElement<List<Show>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Show> create(Ref ref) {
    return topRatedShows(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Show> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Show>>(value),
    );
  }
}

String _$topRatedShowsHash() => r'994c891e0589d9574a98d32e9e3725d97c8480ed';

@ProviderFor(BrowseFilterNotifier)
final browseFilterProvider = BrowseFilterNotifierProvider._();

final class BrowseFilterNotifierProvider
    extends $NotifierProvider<BrowseFilterNotifier, BrowseFilterState> {
  BrowseFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseFilterNotifierHash();

  @$internal
  @override
  BrowseFilterNotifier create() => BrowseFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseFilterState>(value),
    );
  }
}

String _$browseFilterNotifierHash() =>
    r'3394ed858af7d8878906880d530b6b49cbcadf9a';

abstract class _$BrowseFilterNotifier extends $Notifier<BrowseFilterState> {
  BrowseFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BrowseFilterState, BrowseFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrowseFilterState, BrowseFilterState>,
              BrowseFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Filtered catalog derived from [browseFilterProvider].

@ProviderFor(filteredShows)
final filteredShowsProvider = FilteredShowsProvider._();

/// Filtered catalog derived from [browseFilterProvider].

final class FilteredShowsProvider
    extends $FunctionalProvider<List<Show>, List<Show>, List<Show>>
    with $Provider<List<Show>> {
  /// Filtered catalog derived from [browseFilterProvider].
  FilteredShowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredShowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredShowsHash();

  @$internal
  @override
  $ProviderElement<List<Show>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Show> create(Ref ref) {
    return filteredShows(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Show> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Show>>(value),
    );
  }
}

String _$filteredShowsHash() => r'244f899632f6a08556919b481dadf61b75670628';
