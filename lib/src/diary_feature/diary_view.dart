import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/browse_feature/browse_view.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/reviews/log_review_sheet.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/date_formatters.dart';
import 'package:playbilld/src/shared/review_card.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';

class DiaryView extends ConsumerWidget {
  static const routeName = '/diary';

  const DiaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(theaterLogProvider).userReviews;
    final theme = Theme.of(context);

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
                        onPressed: () => context.go(BrowseView.routeName),
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

                    return ReviewCard(
                      title: show?.title ?? review.showId,
                      subtitle:
                          '${review.runLabel} • ${mediumDateFormat.format(review.watchedDate)}',
                      rating: review.rating,
                      liked: review.liked,
                      body: review.body,
                      onTap: show == null
                          ? null
                          : () => unawaited(
                              context.push(
                                ShowDetailView.routeFor(show.id),
                                extra: show,
                              ),
                            ),
                      onEdit: show == null
                          ? null
                          : () => unawaited(
                              showLogReviewSheet(
                                context,
                                show,
                                existingReview: review,
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
