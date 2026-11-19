import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

class HomeSection extends StatefulWidget {
  final String title;
  final List<Show> shows;

  const HomeSection({super.key, required this.title, required this.shows});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final ScrollController _scrollController = ScrollController();

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      position.maxScrollExtent,
    );
    unawaited(
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shows.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool showArrows = kIsWeb && MediaQuery.sizeOf(context).width > 600;
    final scale = MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 2.0);
    final sectionHeight = 308 + (scale - 1.0) * 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Semantics(
            header: true,
            child: Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: sectionHeight,
          width: double.infinity,
          child: Row(
            children: [
              if (showArrows)
                IconButton(
                  tooltip: 'Scroll ${widget.title} left',
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => _scrollBy(-340),
                ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.shows.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return ShowPosterCard(show: widget.shows[index]);
                  },
                ),
              ),
              if (showArrows)
                IconButton(
                  tooltip: 'Scroll ${widget.title} right',
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _scrollBy(340),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
