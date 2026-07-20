import 'package:flutter/material.dart';
import 'package:playbilld/src/models/show.dart';

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  elevation: 4.0,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    show.posterImageUrl,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 50),
                  ),
                ),
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    leading: const Icon(Icons.theaters),
                    title: Text(show.genre),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: Text(show.cast.join(', ')),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(
                        '${show.startDate.toString().substring(0, 10)} - ${show.endDate.toString().substring(0, 10)}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: Text('${show.averageRating}/10'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}
