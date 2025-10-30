import 'package:flutter/material.dart';
import 'package:playbilld/src/home_feature/home_section.dart';
import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {

  static const routeName = '/';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playbilld'), // Changed AppBar title
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeSection(title: 'New Musicals'),
              HomeSection(title: 'Upcoming Shows'),
              HomeSection(title: 'Popular Near You'),
            ],
          ),
        )
      )
    );
  }
}
