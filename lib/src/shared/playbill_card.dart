import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';

class ShowPosterCard extends ConsumerWidget {
  final Show show;
  final double width;
  final double height;

  const ShowPosterCard({
    required this.show,
    this.width = 156,
    this.height = 220,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final logState = ref.watch(theaterLogProvider);
    final effectiveRating = ref.watch(effectiveShowRatingProvider(show));
    final now = ref.watch(currentDateProvider);
    final primaryRun = show.primaryRunAt(now);
    final isWatchlisted = logState.watchlistIds.contains(show.id);
    final isLogged = logState.userReviews.any((r) => r.showId == show.id);

    final posterStack = Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          show.posterImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, object, stackTrace) => Center(
            child: Icon(
              Icons.theaters,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                show.form.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        if (isLogged || isWatchlisted)
          Positioned(
            top: 8,
            right: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isLogged ? Icons.check_circle : Icons.bookmark,
                  size: 16,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
      ],
    );

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            unawaited(
              context.push(ShowDetailView.routeFor(show.id), extra: show),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final hasBoundedHeight = constraints.hasBoundedHeight;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: hasBoundedHeight
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  if (hasBoundedHeight)
                    Expanded(child: posterStack)
                  else
                    SizedBox(width: width, height: height, child: posterStack),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          show.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          primaryRun.venue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              effectiveRating.rating.toStringAsFixed(1),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
