import 'package:intl/intl.dart';

/// Shared formatter for medium dates (e.g., "Nov 15, 2026") to avoid
/// reallocating [DateFormat] instances during widget builds.
final DateFormat mediumDateFormat = DateFormat.yMMMd();
