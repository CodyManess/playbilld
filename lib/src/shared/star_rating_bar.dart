import 'package:material_ui/material_ui.dart';

/// Displays a 5-star rating bar supporting half-star increments.
class StarRatingBar extends StatelessWidget {
  final double rating;
  final double size;

  const StarRatingBar({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final threshold = index + 1;
        final IconData icon;
        if (rating >= threshold) {
          icon = Icons.star;
        } else if (rating >= threshold - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
