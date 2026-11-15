import 'package:playbilld/src/models/review.dart';

final List<ShowReview> mockCommunityReviews = List.unmodifiable([
  ShowReview(
    id: 'community-hadestown-1',
    showId: 'hadestown',
    runId: 'hadestown-broadway',
    runLabel: 'Broadway Production • Walter Kerr Theatre',
    authorName: 'Maya R.',
    rating: 5.0,
    liked: true,
    body:
        'The swinging lamps during Wait for Me still give me chills. Even knowing the myth, the ending hits every single time.',
    watchedDate: DateTime(2026, 9, 18),
    createdAt: DateTime(2026, 9, 19),
  ),
  ShowReview(
    id: 'community-wicked-1',
    showId: 'wicked',
    runId: 'wicked-broadway',
    runLabel: 'Broadway Open-Ended Run • Gershwin Theatre',
    authorName: 'Jordan K.',
    rating: 4.5,
    liked: true,
    body:
        'Seeing it live from the front mezzanine makes Defying Gravity feel massive. Pure Broadway spectacle.',
    watchedDate: DateTime(2026, 8, 4),
    createdAt: DateTime(2026, 8, 5),
  ),
  ShowReview(
    id: 'community-sweeney-1',
    showId: 'sweeney-todd',
    runId: 'sweeney-2023-revival',
    runLabel: '2023 Broadway Revival • Lunt-Fontanne Theatre',
    authorName: 'Elena T.',
    rating: 5.0,
    liked: true,
    body:
        'Having the full 26-piece orchestra back in the pit transformed the score. Annaleigh Ashford stole every scene.',
    watchedDate: DateTime(2024, 3, 12),
    createdAt: DateTime(2024, 3, 13),
  ),
  ShowReview(
    id: 'community-oh-mary-1',
    showId: 'oh-mary',
    runId: 'oh-mary-broadway',
    runLabel: 'Broadway Transfer • Lyceum Theatre',
    authorName: 'Devon P.',
    rating: 4.5,
    liked: true,
    body:
        'Eighty minutes of nonstop, unhinged comedic precision. The audience was howling from the first blackout.',
    watchedDate: DateTime(2026, 10, 2),
    createdAt: DateTime(2026, 10, 3),
  ),
]);
