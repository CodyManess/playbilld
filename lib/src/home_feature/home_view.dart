import 'package:flutter/material.dart';
import 'package:playbilld/src/mock/mock_shows.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {

  static const routeName = '/';

  const HomeView({super.key});

  Widget _buildHorizontalListView(BuildContext context) {
    return SizedBox(
      height: 260, // Adjusted height for 240px card + 10px top/bottom padding
      width: double.infinity, // Add this line
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mockShows.length,
        itemBuilder: (BuildContext context, int index) {
          final item = mockShows[index];
          return ShowPosterCard(show: item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playbilld'), // Changed AppBar title
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding( // Added padding around the scroll view's content
          padding: const EdgeInsets.all(12.0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start, // Align titles to the left
            children: [
              // Section 1
              Text(
                'New Musicals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              _buildHorizontalListView(context),
              const SizedBox(height: 16.0), // Spacing between sections

              // Section 2
              Text(
                'Upcoming Shows',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              _buildHorizontalListView(context),
              const SizedBox(height: 16.0),

              // Section 3
              Text(
                'Popular Near You',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              _buildHorizontalListView(context),
            ],
          ),
        )
      )
    );
  }
}
