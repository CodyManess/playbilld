import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playbilld/src/home_feature/home_section.dart';

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
              context.go('/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeSection(title: 'New Musicals'),
                  HomeSection(title: 'Upcoming Shows'),
                  HomeSection(title: 'Popular Near You'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
