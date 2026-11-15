enum TheaterForm {
  musical('Musical'),
  play('Play'),
  opera('Opera'),
  dance('Dance'),
  other('Other Theater');

  const TheaterForm(this.label);

  final String label;
}

enum RunStatus {
  nowPlaying('Now Playing'),
  upcoming('Upcoming'),
  closed('Closed');

  const RunStatus(this.label);

  final String label;
}

class TheaterRun {
  final String id;
  final String productionName;
  final String venue;
  final String city;
  final DateTime startDate;
  final DateTime? endDate;

  const TheaterRun({
    required this.id,
    required this.productionName,
    required this.venue,
    required this.city,
    required this.startDate,
    this.endDate,
  });

  RunStatus statusAt(DateTime referenceDate) {
    if (referenceDate.isBefore(startDate)) {
      return RunStatus.upcoming;
    }
    final end = endDate;
    if (end != null && referenceDate.isAfter(end)) {
      return RunStatus.closed;
    }
    return RunStatus.nowPlaying;
  }
}

class Show {
  final String id;
  final String title;
  final String description;
  final TheaterForm form;
  final String genre;
  final List<String> creators;
  final List<String> cast;
  final List<TheaterRun> runs;
  final double averageRating;
  final int reviewCount;
  final String posterImageUrl;

  const Show({
    required this.id,
    required this.title,
    required this.description,
    required this.form,
    required this.genre,
    this.creators = const [],
    required this.cast,
    required this.runs,
    required this.averageRating,
    this.reviewCount = 0,
    required this.posterImageUrl,
  });

  TheaterRun primaryRunAt(DateTime referenceDate) {
    for (final run in runs) {
      if (run.statusAt(referenceDate) == RunStatus.nowPlaying) {
        return run;
      }
    }
    for (final run in runs) {
      if (run.statusAt(referenceDate) == RunStatus.upcoming) {
        return run;
      }
    }
    return runs.first;
  }

  RunStatus statusAt(DateTime referenceDate) {
    var hasUpcoming = false;
    for (final run in runs) {
      final status = run.statusAt(referenceDate);
      if (status == RunStatus.nowPlaying) {
        return RunStatus.nowPlaying;
      }
      if (status == RunStatus.upcoming) {
        hasUpcoming = true;
      }
    }
    return hasUpcoming ? RunStatus.upcoming : RunStatus.closed;
  }
}
