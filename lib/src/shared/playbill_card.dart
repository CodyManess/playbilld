import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playbilld/src/models/show.dart';

class ShowPosterCard extends StatelessWidget {
  final Show show;

  const ShowPosterCard({required this.show, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // Prevents image from overflowing card edges
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          context.push('/show_details', extra: show);
        },
        child: SizedBox(
          width: 160, // Adjusted width
          height: 240, // Adjusted height
          child: Image.network(
            show.posterImageUrl,
            fit: BoxFit.cover, // Ensures the image covers the entire card
            errorBuilder: (context, object, stackTrace) => const Icon(Icons.error), //handles image load errors
          ),
        ),
      ),
    );
  }
}