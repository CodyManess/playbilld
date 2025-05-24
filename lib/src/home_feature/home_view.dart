import 'package:flutter/material.dart';
import 'package:playbilld/src/mock/mock_shows.dart';
import 'package:playbilld/src/shared/playbill_card.dart';

import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {

  static const routeName = '/';

  const HomeView({super.key});

  Widget _buildHorizontalListView(BuildContext context) {
    return SizedBox(
      height: 200,
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
        title: const Text('Sample Items'),
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
        child: Column ( 
          children: [
            Text('Testing 12345'),
            _buildHorizontalListView(context),
            _buildHorizontalListView(context),
            _buildHorizontalListView(context)
          ]
        )
      )
    );
  }
}
