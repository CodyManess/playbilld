import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/review.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/log_review_sheet.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/date_formatters.dart';
import 'package:playbilld/src/shared/star_rating_bar.dart';

class ShowDetailView extends ConsumerWidget {
  const ShowDetailView({super.key, required this.show});

  static const routeName = '/shows';

  static String routeFor(String id) => '$routeName/$id';

  final Show show;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = ref.watch(currentDateProvider);
    final isWatchlisted = ref.watch(
      theaterLogProvider.select((s) => s.watchlistIds.contains(show.id)),
    );
    final isLiked = ref.watch(
      theaterLogProvider.select((s) => s.likedShowIds.contains(show.id)),
    );
    final userReview = ref.watch(
      theaterLogProvider.select(
        (s) => s.userReviews.where((r) => r.showId == show.id).firstOrNull,
      ),
    );
    final reviews = ref.watch(reviewsForShowProvider(show.id));
    final ratingSummary = ref.watch(effectiveShowRatingProvider(show));
    final overallStatus = show.statusAt(now);

    return Scaffold(
      appBar: AppBar(title: Text(show.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShowHeader(
                  show: show,
                  status: overallStatus,
                  rating: ratingSummary.rating,
                  reviewCount: ratingSummary.count,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () => unawaited(
                        showLogReviewSheet(
                          context,
                          show,
                          existingReview: userReview,
                        ),
                      ),
                      icon: Icon(
                        userReview == null ? Icons.rate_review : Icons.edit,
                      ),
                      label: Text(
                        userReview == null ? 'Log / Review' : 'Edit Your Log',
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => unawaited(
                        ref
                            .read(theaterLogProvider.notifier)
                            .toggleWatchlist(show.id),
                      ),
                      icon: Icon(
                        isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      label: Text(isWatchlisted ? 'Watchlisted' : 'Watchlist'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => unawaited(
                        ref
                            .read(theaterLogProvider.notifier)
                            .toggleLike(show.id),
                      ),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? theme.colorScheme.error : null,
                      ),
                      label: Text(isLiked ? 'Liked' : 'Like'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(show.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 16),
                if (show.creators.isNotEmpty)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.create),
                    title: const Text('Creators'),
                    subtitle: Text(show.creators.join(', ')),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.people),
                  title: const Text('Featured Cast'),
                  subtitle: Text(show.cast.join(', ')),
                ),
                const Divider(height: 32),
                Text(
                  'Runs & Venues',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (final run in show.runs)
                  _RunCard(
                    run: run,
                    status: run.statusAt(now),
                    dateFormat: mediumDateFormat,
                  ),
                const Divider(height: 32),
                Text(
                  'Reviews (${reviews.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (reviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No reviews yet. Be the first to log a performance!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  for (final review in reviews)
                    _ReviewCard(
                      review: review,
                      dateFormat: mediumDateFormat,
                      onEdit: review.isUserReview
                          ? () => unawaited(
                              showLogReviewSheet(
                                context,
                                show,
                                existingReview: review,
                              ),
                            )
                          : null,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShowHeader extends StatelessWidget {
  final Show show;
  final RunStatus status;
  final double rating;
  final int reviewCount;

  const _ShowHeader({
    required this.show,
    required this.status,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;
        final posterWidth = isCompact ? 120.0 : 160.0;
        final decodeWidth =
            (posterWidth * MediaQuery.devicePixelRatioOf(context)).round();
        final poster = Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: posterWidth,
            height: isCompact ? 180 : 240,
            child: Image.network(
              show.posterImageUrl,
              fit: BoxFit.cover,
              cacheWidth: decodeWidth,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.theaters, size: 40)),
            ),
          ),
        );

        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(label: Text(show.form.label)),
                Chip(label: Text(status.label)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              show.genre,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                StarRatingBar(rating: rating, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$rating/5 ($reviewCount)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            poster,
            const SizedBox(width: 16),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}

class _RunCard extends StatelessWidget {
  final TheaterRun run;
  final RunStatus status;
  final DateFormat dateFormat;

  const _RunCard({
    required this.run,
    required this.status,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final end = run.endDate;
    final dateText = end == null
        ? 'Opened ${dateFormat.format(run.startDate)} • Open-ended'
        : '${dateFormat.format(run.startDate)} – ${dateFormat.format(end)}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(run.productionName),
        subtitle: Text('${run.venue}, ${run.city}\n$dateText'),
        isThreeLine: true,
        trailing: Chip(label: Text(status.label)),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ShowReview review;
  final DateFormat dateFormat;
  final VoidCallback? onEdit;

  const _ReviewCard({
    required this.review,
    required this.dateFormat,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.authorName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StarRatingBar(rating: review.rating, size: 16),
                if (review.liked) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.favorite,
                    size: 16,
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
              '${review.runLabel} • Seen ${dateFormat.format(review.watchedDate)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (review.body.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(review.body, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
