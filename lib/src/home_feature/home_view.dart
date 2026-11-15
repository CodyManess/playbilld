import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/browse_feature/browse_view.dart';
import 'package:playbilld/src/home_feature/home_section.dart';
import 'package:playbilld/src/localization/app_localizations.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/settings/settings_view.dart';

class HomeView extends ConsumerWidget {
  static const routeName = '/';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlaying = ref.watch(nowPlayingShowsProvider);
    final upcoming = ref.watch(upcomingShowsProvider);
    final topRated = ref.watch(topRatedShowsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
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
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: theme.colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Track every curtain call.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Log plays, musicals, revivals, and live theater runs.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonalIcon(
                          onPressed: () => context.go(BrowseView.routeName),
                          icon: const Icon(Icons.search),
                          label: const Text('Browse'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                HomeSection(title: 'Now Playing', shows: nowPlaying),
                HomeSection(title: 'Upcoming Runs', shows: upcoming),
                HomeSection(title: 'Top Rated Theater', shows: topRated),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
