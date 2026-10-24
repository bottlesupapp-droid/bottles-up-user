import 'package:intl/intl.dart';

/// A time the website stored (an ISO instant, or a date), as the phone's own local time. Null when it cannot be read.
DateTime? parseWhen(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  return parsed?.toLocal();
}

/// "Sat, Oct 25 · 10:00 PM".
String formatWhen(DateTime when) => '${DateFormat('EEE, MMM d').format(when)} · ${DateFormat('h:mm a').format(when)}';

/// "Sat, Oct 25".
String formatDay(DateTime when) => DateFormat('EEE, MMM d').format(when);

/// "10:00 PM".
String formatTime(DateTime when) => DateFormat('h:mm a').format(when);

/// A date without a time ("2026-10-25"), as a date.
DateTime? parseDay(Object? value) {
  if (value is! String || value.length < 10) return null;
  final parts = value.substring(0, 10).split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]), m = int.tryParse(parts[1]), d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}
