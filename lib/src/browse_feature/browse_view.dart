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
              _FilterChipRow<TheaterForm>(
                allLabel: 'All Forms',
                values: TheaterForm.values,
                selected: filter.form,
                labelOf: (form) => form.label,
                onSelected: filterNotifier.setForm,
              ),
              _FilterChipRow<RunStatus>(
                allLabel: 'All Runs',
                values: RunStatus.values,
                selected: filter.status,
                labelOf: (status) => status.label,
                onSelected: filterNotifier.setStatus,
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
                        gridDelegate: showPosterGridDelegate,
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

class _FilterChipRow<T> extends StatelessWidget {
  final String allLabel;
  final List<T> values;
  final T? selected;
  final String Function(T) labelOf;
  final void Function(T?) onSelected;

  const _FilterChipRow({
    required this.allLabel,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(allLabel),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final value in values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(labelOf(value)),
              selected: selected == value,
              onSelected: (_) => onSelected(selected == value ? null : value),
            ),
          ],
        ],
      ),
    );
  }
}
