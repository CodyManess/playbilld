import 'package:flutter/material.dart';

import '../models/show.dart';

/// Displays detailed information about a SampleItem.
class ShowDetailView extends StatelessWidget {
  const ShowDetailView({super.key, required this.show});

  static const routeName = '/show_details';

  final Show show;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.network(
                show.posterImageUrl,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 50), // Made icon a bit larger
              ),
            ),
            const SizedBox(height: 24), // Increased spacing

            // Title - already in AppBar, but can be shown larger here if desired
            // Text(show.title, style: Theme.of(context).textTheme.headlineMedium),
            // const SizedBox(height: 8),

            Text(
              "Description:",
              style: Theme.of(context).textTheme.titleLarge, // Adjusted style
            ),
            const SizedBox(height: 4),
            Text(
              show.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            Text(
              "Genre: ${show.genre}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Text(
              "Cast:",
              style: Theme.of(context).textTheme.titleLarge, // Adjusted style
            ),
            const SizedBox(height: 4),
            Text(
              show.cast.join(', '),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            Text(
              "Show Dates:",
              style: Theme.of(context).textTheme.titleLarge, // Adjusted style
            ),
            const SizedBox(height: 4),
            Text(
              "Start Date: ${show.startDate.toString().substring(0, 10)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "End Date: ${show.endDate.toString().substring(0, 10)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            Text(
              "Average Rating: ${show.averageRating}/10",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
