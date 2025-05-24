import 'package:flutter/material.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';
import 'package:playbilld/src/models/show.dart';

class ShowPosterCard extends StatelessWidget {
  final Show show;

  const ShowPosterCard({required this.show, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card click here, e.g., navigate to show details
        Navigator.pushNamed(context, ShowDetailView.routeName,);
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Prevents image from overflowing card edges
        child: SizedBox(
          width: 150, // Set the desired width (or use constraints)
          height: 50, // Set the desired height (or use constraints)
          child: Image.network(
            show.posterImageUrl,
            fit: BoxFit.cover, // Ensures the image covers the entire card
            errorBuilder: (context, object, stackTrace) => const Icon(Icons.error), //handles image load errors
          )
        )
      ),
    );
  }
}