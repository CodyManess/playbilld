import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:playbilld/src/mock/mock_shows.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

class HomeSection extends StatefulWidget {
  final String title;

  const HomeSection({super.key, required this.title});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 340, // approx two cards wide
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 340,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showArrows = kIsWeb && MediaQuery.sizeOf(context).width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showArrows)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _scrollLeft,
                ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: mockShows.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = mockShows[index];
                      return ShowPosterCard(show: item);
                    },
                  ),
                ),
              ),
              if (showArrows)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _scrollRight,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
