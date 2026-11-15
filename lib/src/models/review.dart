class ShowReview {
  final String id;
  final String showId;
  final String runId;
  final String runLabel;
  final String authorName;
  final double rating;
  final bool liked;
  final String body;
  final DateTime watchedDate;
  final DateTime createdAt;
  final bool isUserReview;

  const ShowReview({
    required this.id,
    required this.showId,
    required this.runId,
    required this.runLabel,
    required this.authorName,
    required this.rating,
    required this.liked,
    required this.body,
    required this.watchedDate,
    required this.createdAt,
    this.isUserReview = false,
  });

  ShowReview copyWith({
    String? id,
    String? showId,
    String? runId,
    String? runLabel,
    String? authorName,
    double? rating,
    bool? liked,
    String? body,
    DateTime? watchedDate,
    DateTime? createdAt,
    bool? isUserReview,
  }) {
    return ShowReview(
      id: id ?? this.id,
      showId: showId ?? this.showId,
      runId: runId ?? this.runId,
      runLabel: runLabel ?? this.runLabel,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      liked: liked ?? this.liked,
      body: body ?? this.body,
      watchedDate: watchedDate ?? this.watchedDate,
      createdAt: createdAt ?? this.createdAt,
      isUserReview: isUserReview ?? this.isUserReview,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'showId': showId,
      'runId': runId,
      'runLabel': runLabel,
      'authorName': authorName,
      'rating': rating,
      'liked': liked,
      'body': body,
      'watchedDate': watchedDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isUserReview': isUserReview,
    };
  }

  factory ShowReview.fromJson(Map<String, dynamic> json) {
    return ShowReview(
      id: json['id'] as String,
      showId: json['showId'] as String,
      runId: json['runId'] as String,
      runLabel: json['runLabel'] as String,
      authorName: json['authorName'] as String,
      rating: (json['rating'] as num).toDouble(),
      liked: json['liked'] as bool,
      body: json['body'] as String,
      watchedDate: DateTime.parse(json['watchedDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isUserReview: json['isUserReview'] as bool? ?? true,
    );
  }
}
