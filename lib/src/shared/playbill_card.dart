import 'package:flutter/material.dart';
import 'package:playbilld/src/models/show.dart';

class ShowPosterCard extends StatelessWidget {
  final Show show;

  const ShowPosterCard({required this.show, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card click here, e.g., navigate to show details
        print("Card clicked for ${show.title}");
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Prevents image from overflowing card edges
        child: Image.network(
          show.posterImageUrl,
          fit: BoxFit.contain, // Ensures the image covers the entire card
          width: 100, // Makes the image fill the card horizontally
          height: 50, // Adjust the height as needed
          errorBuilder: (context, object, stackTrace) => const Icon(Icons.error), //handles image load errors
        ),
      ),
    );
  }
}