import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/reviews/log_review_sheet.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';
import 'package:playbilld/src/shared/star_rating_bar.dart';

class DiaryView extends ConsumerWidget {
  static const routeName = '/diary';

  const DiaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(theaterLogProvider).userReviews;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(title: const Text('Theater Diary')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: reviews.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 56,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your Playbilld diary is empty',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Open any show to log the run you attended, rate it, and write a review.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.go('/browse'),
                        icon: const Icon(Icons.search),
                        label: const Text('Find a Show to Log'),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    final show = ref.watch(showByIdProvider(review.showId));

                    return Card(
                      child: InkWell(
                        onTap: show == null
                            ? null
                            : () => unawaited(
                                context.push(
                                  ShowDetailView.routeFor(show.id),
                                  extra: show,
                                ),
                              ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      show?.title ?? review.showId,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  StarRatingBar(
                                    rating: review.rating,
                                    size: 16,
                                  ),
                                  if (review.liked) ...[
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.favorite,
                                      size: 16,
                                      color: theme.colorScheme.error,
                                    ),
                                  ],
                                  if (show != null)
                                    IconButton(
                                      tooltip: 'Edit log',
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      onPressed: () => unawaited(
                                        showLogReviewSheet(
                                          context,
                                          show,
                                          existingReview: review,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                '${review.runLabel} • ${dateFormat.format(review.watchedDate)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (review.body.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(review.body),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
