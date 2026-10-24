/// Small readers for rows the website sent. A value that is missing or the wrong kind becomes null; nothing here throws.
int? readInt(Object? v) => v is num ? v.toInt() : int.tryParse('$v');

String? readText(Object? v) {
  final s = v is String ? v.trim() : null;
  return s == null || s.isEmpty ? null : s;
}

List<String> readTexts(Object? v) => v is List ? [for (final x in v) if (x is String && x.trim().isNotEmpty) x.trim()] : const [];

/// A calendar day with no time ("2026-11-07"), as a date at midnight in the phone's own calendar.
DateTime? readDay(Object? v) {
  if (v is! String || v.length < 10) return null;
  final parts = v.substring(0, 10).split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]), m = int.tryParse(parts[1]), d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}
