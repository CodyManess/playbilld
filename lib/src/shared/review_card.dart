import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/shared/star_rating_bar.dart';

/// Displays a logged performance or community review card.
class ReviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double rating;
  final bool liked;
  final String body;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final EdgeInsetsGeometry margin;

  const ReviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.liked,
    required this.body,
    this.onTap,
    this.onEdit,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StarRatingBar(rating: rating, size: 16),
              if (liked) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.favorite,
                  size: 16,
                  semanticLabel: 'Liked',
                  color: theme.colorScheme.error,
                ),
              ],
              if (onEdit != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Edit review',
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onEdit,
                ),
              ],
            ],
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );

    return Card(
      margin: margin,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
