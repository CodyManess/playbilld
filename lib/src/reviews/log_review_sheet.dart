import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/models/review.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/reviews/theater_log_controller.dart';
import 'package:playbilld/src/shared/date_formatters.dart';
import 'package:playbilld/src/shared/star_rating_bar.dart';

Future<void> showLogReviewSheet(
  BuildContext context,
  Show show, {
  ShowReview? existingReview,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) =>
        _LogReviewSheet(show: show, existingReview: existingReview),
  );
}

class _LogReviewSheet extends ConsumerStatefulWidget {
  final Show show;
  final ShowReview? existingReview;

  const _LogReviewSheet({required this.show, this.existingReview});

  @override
  ConsumerState<_LogReviewSheet> createState() => _LogReviewSheetState();
}

class _LogReviewSheetState extends ConsumerState<_LogReviewSheet> {
  late TheaterRun _selectedRun;
  late DateTime _watchedDate;
  late double _rating;
  late bool _liked;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReview;
    _selectedRun = widget.show.runs.firstWhere(
      (run) => run.id == existing?.runId,
      orElse: () => widget.show.runs.first,
    );
    _watchedDate = existing?.watchedDate ?? DateTime.now();
    _rating = existing?.rating ?? 4.0;
    _liked = existing?.liked ?? false;
    _bodyController = TextEditingController(text: existing?.body ?? '');
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _watchedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() {
        _watchedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    final existing = widget.existingReview;
    final now = DateTime.now();
    final review = ShowReview(
      id:
          existing?.id ??
          'user-${widget.show.id}-${now.microsecondsSinceEpoch}',
      showId: widget.show.id,
      runId: _selectedRun.id,
      runLabel: '${_selectedRun.productionName} • ${_selectedRun.venue}',
      authorName: 'You',
      rating: _rating,
      liked: _liked,
      body: _bodyController.text.trim(),
      watchedDate: _watchedDate,
      createdAt: existing?.createdAt ?? now,
      isUserReview: true,
    );

    await ref.read(theaterLogProvider.notifier).saveReview(review);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _delete() async {
    final existing = widget.existingReview;
    if (existing == null) return;
    await ref.read(theaterLogProvider.notifier).deleteReview(existing.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.existingReview == null
                        ? 'Log ${widget.show.title}'
                        : 'Edit Log: ${widget.show.title}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.existingReview != null)
                  IconButton(
                    tooltip: 'Delete log',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => unawaited(_delete()),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TheaterRun>(
              initialValue: _selectedRun,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Production / Run',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final run in widget.show.runs)
                  DropdownMenuItem(
                    value: run,
                    child: Text(
                      '${run.productionName} (${run.venue})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRun = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => unawaited(_pickDate()),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      'Seen ${mediumDateFormat.format(_watchedDate)}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  selected: _liked,
                  label: const Text('Like'),
                  avatar: Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                  ),
                  onSelected: (value) {
                    setState(() {
                      _liked = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rating: ${_rating.toStringAsFixed(1)} / 5',
                  style: theme.textTheme.titleMedium,
                ),
                StarRatingBar(rating: _rating, size: 22),
              ],
            ),
            Slider(
              value: _rating,
              min: 0.5,
              max: 5.0,
              divisions: 9,
              label: _rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Review or performance notes (optional)',
                hintText: 'Thoughts on the cast, staging, score, or seats...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => unawaited(_save()),
                child: Text(
                  widget.existingReview == null ? 'Save Log' : 'Update Log',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
