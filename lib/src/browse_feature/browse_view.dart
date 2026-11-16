import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

class BrowseView extends ConsumerStatefulWidget {
  static const routeName = '/browse';

  const BrowseView({super.key});

  @override
  ConsumerState<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends ConsumerState<BrowseView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 150), () {
      if (mounted) {
        ref.read(browseFilterProvider.notifier).setQuery(value);
      }
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    ref.read(browseFilterProvider.notifier).setQuery('');
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(browseFilterProvider);
    final shows = ref.watch(filteredShowsProvider);
    final filterNotifier = ref.read(browseFilterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Theater')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search shows, venues, creators, or cast...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.query.isNotEmpty
                        ? IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All Forms'),
                      selected: filter.form == null,
                      onSelected: (_) => filterNotifier.setForm(null),
                    ),
                    const SizedBox(width: 8),
                    for (final form in TheaterForm.values) ...[
                      ChoiceChip(
                        label: Text(form.label),
                        selected: filter.form == form,
                        onSelected: (_) => filterNotifier.setForm(
                          filter.form == form ? null : form,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All Runs'),
                      selected: filter.status == null,
                      onSelected: (_) => filterNotifier.setStatus(null),
                    ),
                    const SizedBox(width: 8),
                    for (final status in RunStatus.values) ...[
                      ChoiceChip(
                        label: Text(status.label),
                        selected: filter.status == status,
                        onSelected: (_) => filterNotifier.setStatus(
                          filter.status == status ? null : status,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: shows.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('No shows match those filters.'),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () {
                                _searchDebounce?.cancel();
                                _searchController.clear();
                                filterNotifier.clearAll();
                              },
                              child: const Text('Reset Filters'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
