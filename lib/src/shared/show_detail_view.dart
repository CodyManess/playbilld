import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/log_review_sheet.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/date_formatters.dart';
import 'package:playbilld/src/shared/playbill_card.dart';
import 'package:playbilld/src/shared/review_card.dart';
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
                  _RunCard(run: run, status: run.statusAt(now)),
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
                    ReviewCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      title: review.authorName,
                      subtitle:
                          '${review.runLabel} • Seen ${mediumDateFormat.format(review.watchedDate)}',
                      rating: review.rating,
                      liked: review.liked,
                      body: review.body,
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

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: posterWidth,
                height: isCompact ? 180 : 240,
                child: ShowPosterImage(
                  imageUrl: show.posterImageUrl,
                  logicalWidth: posterWidth,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
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
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RunCard extends StatelessWidget {
  final TheaterRun run;
  final RunStatus status;

  const _RunCard({required this.run, required this.status});

  @override
  Widget build(BuildContext context) {
    final end = run.endDate;
    final dateText = end == null
        ? 'Opened ${mediumDateFormat.format(run.startDate)} • Open-ended'
        : '${mediumDateFormat.format(run.startDate)} – ${mediumDateFormat.format(end)}';

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
