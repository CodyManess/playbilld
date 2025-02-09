class Show {
  final String title;
  final String description;
  final String genre;
  final List<String> cast;
  final DateTime startDate;
  final DateTime endDate;
  final double averageRating;
  final String posterImageUrl; // URL to the show's poster

  Show({
    required this.title,
    required this.description,
    required this.genre,
    required this.cast,
    required this.startDate,
    required this.endDate,
    required this.averageRating,
    required this.posterImageUrl,
  });
}