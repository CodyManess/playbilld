import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/settings/settings_view.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

enum _ProfileCollection { watchlist, likes }

class ProfileView extends ConsumerStatefulWidget {
  static const routeName = '/profile';

  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  _ProfileCollection _selectedCollection = _ProfileCollection.watchlist;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(userTheaterStatsProvider);
    final logState = ref.watch(theaterLogProvider);
    final allShows = ref.watch(showsProvider);

    final targetIds = _selectedCollection == _ProfileCollection.watchlist
        ? logState.watchlistIds
        : logState.likedShowIds;
    final List<Show> shows = allShows
        .where((show) => targetIds.contains(show.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Lists'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              unawaited(context.push(SettingsView.routeName));
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _StatCard(label: 'Logged', value: '${stats.loggedCount}'),
                  _StatCard(
                    label: 'Reviews',
                    value: '${stats.writtenReviewCount}',
                  ),
                  _StatCard(
                    label: 'Watchlist',
                    value: '${stats.watchlistCount}',
                  ),
                  _StatCard(
                    label: 'Avg Rating',
                    value: stats.averageRating == null
                        ? '—'
                        : '${stats.averageRating}/5',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SegmentedButton<_ProfileCollection>(
                segments: const [
                  ButtonSegment<_ProfileCollection>(
                    value: _ProfileCollection.watchlist,
                    label: Text('Watchlist'),
                    icon: Icon(Icons.bookmark_outline),
                  ),
                  ButtonSegment<_ProfileCollection>(
                    value: _ProfileCollection.likes,
                    label: Text('Liked'),
                    icon: Icon(Icons.favorite_border),
                  ),
                ],
                selected: {_selectedCollection},
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedCollection = selection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (shows.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      _selectedCollection == _ProfileCollection.watchlist
                          ? 'No shows on your watchlist yet.'
                          : 'No liked shows yet.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 190,
                    mainAxisExtent: 300,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: shows.length,
                  itemBuilder: (context, index) {
                    return ShowPosterCard(show: shows[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
