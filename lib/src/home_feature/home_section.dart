import 'package:flutter/material.dart';
import 'package:playbilld/src/mock/mock_shows.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

class HomeSection extends StatelessWidget {
  final String title;

  const HomeSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 260,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockShows.length,
            itemBuilder: (BuildContext context, int index) {
              final item = mockShows[index];
              return ShowPosterCard(show: item);
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
