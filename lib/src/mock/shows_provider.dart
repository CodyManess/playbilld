import 'package:flutter/foundation.dart';
import 'package:playbilld/src/mock/mock_shows.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shows_provider.g.dart';

/// Reference date normalized to midnight so run-status checks don't recompute
/// on sub-day timestamps across widget builds.
@Riverpod(keepAlive: true)
DateTime currentDate(Ref ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Provides the full catalog of shows.
@Riverpod(keepAlive: true)
List<Show> shows(Ref ref) {
  return mockShows;
}

/// Precomputed lowercase search index keyed by [Show.id].
@Riverpod(keepAlive: true)
Map<String, String> showSearchIndex(Ref ref) {
  final allShows = ref.watch(showsProvider);
  return {
    for (final show in allShows)
      show.id: [
        show.title,
        show.genre,
        show.form.label,
        ...show.creators,
        ...show.cast,
        ...show.runs.expand((r) => [r.productionName, r.venue, r.city]),
      ].join(' ').toLowerCase(),
  };
}

/// Looks up a single [Show] by its route [id], returning `null` if not found.
@riverpod
Show? showById(Ref ref, String id) {
  final allShows = ref.watch(showsProvider);
  for (final show in allShows) {
    if (show.id == id) {
      return show;
    }
  }
  return null;
}

/// Shows that currently have an active run.
@riverpod
List<Show> nowPlayingShows(Ref ref) {
  final now = ref.watch(currentDateProvider);
  return ref
      .watch(showsProvider)
      .where((show) => show.statusAt(now) == RunStatus.nowPlaying)
      .toList();
}

/// Shows with upcoming runs that have not yet opened.
@riverpod
List<Show> upcomingShows(Ref ref) {
  final now = ref.watch(currentDateProvider);
  return ref
      .watch(showsProvider)
      .where((show) => show.statusAt(now) == RunStatus.upcoming)
      .toList();
}

/// Shows sorted by community rating descending (for spotlight / acclaim).
@riverpod
List<Show> topRatedShows(Ref ref) {
  final sorted = [...ref.watch(showsProvider)]
    ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
  return sorted;
}

@immutable
class BrowseFilterState {
  final String query;
  final TheaterForm? form;
  final RunStatus? status;

  const BrowseFilterState({this.query = '', this.form, this.status});

  BrowseFilterState copyWith({
    String? query,
    TheaterForm? Function()? form,
    RunStatus? Function()? status,
  }) {
    return BrowseFilterState(
      query: query ?? this.query,
      form: form != null ? form() : this.form,
      status: status != null ? status() : this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrowseFilterState &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          form == other.form &&
          status == other.status;

  @override
  int get hashCode => Object.hash(query, form, status);
}

@riverpod
class BrowseFilterNotifier extends _$BrowseFilterNotifier {
  @override
  BrowseFilterState build() {
    return const BrowseFilterState();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setForm(TheaterForm? form) {
    state = state.copyWith(form: () => form);
  }

  void setStatus(RunStatus? status) {
    state = state.copyWith(status: () => status);
  }

  void clearAll() {
    state = const BrowseFilterState();
  }
}

/// Filtered catalog derived from [browseFilterProvider].
@riverpod
List<Show> filteredShows(Ref ref) {
  final filter = ref.watch(browseFilterProvider);
  final now = ref.watch(currentDateProvider);
  final searchIndex = ref.watch(showSearchIndexProvider);
  final query = filter.query.trim().toLowerCase();

  return ref.watch(showsProvider).where((show) {
    if (filter.form != null && show.form != filter.form) {
      return false;
    }
    if (filter.status != null && show.statusAt(now) != filter.status) {
      return false;
    }
    if (query.isEmpty) {
      return true;
    }
    return (searchIndex[show.id] ?? '').contains(query);
  }).toList();
}
