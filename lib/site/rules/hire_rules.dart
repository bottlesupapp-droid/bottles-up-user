import '../models/hire.dart';

/// The limits the website enforces on venue hire and on teams. The app checks the same things first so a person is told before they send, but the website has the last word.
const int minEventTypeLength = 2;
const int maxEventTypeLength = 80;
const int maxHoursLength = 60;
const int maxSpaceLength = 160;
const int maxHireLineLength = 300;
const int maxHireNotesLength = 1000;
const int maxCancellationLength = 600;
const int maxHireCents = 100000000;
const int maxAttendance = 100000;
const int maxOfferDays = 14;
const int maxItemTitleLength = 120;
const int minItemTitleLength = 2;
const int maxWorkspaceItems = 60;
const int maxTeamSize = 20;

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// The sentence for what is wrong with a request to a venue, or null.
String? checkHireRequest({
  required DateTime? date,
  required String eventType,
  required DateTime today,
  String? hours,
  int? attendance,
  String? space,
  String? equipment,
  String? staffing,
  int? budgetCents,
  String? notes,
}) {
  final day = _day(today);
  if (date == null || !date.isAfter(day) || date.isAfter(DateTime(day.year, day.month, day.day + 730))) return 'Choose a date between tomorrow and two years from now.';
  final t = eventType.trim().length;
  if (t < minEventTypeLength || t > maxEventTypeLength) return 'Say what kind of event it is in $minEventTypeLength to $maxEventTypeLength characters.';
  if ((hours?.trim().length ?? 0) > maxHoursLength) return 'Keep the hours to $maxHoursLength characters.';
  if (attendance != null && (attendance < 1 || attendance > maxAttendance)) return 'Choose an expected attendance between 1 and 100,000.';
  if ((space?.trim().length ?? 0) > maxSpaceLength) return 'Keep the space to $maxSpaceLength characters.';
  if ((equipment?.trim().length ?? 0) > maxHireLineLength) return 'Keep the equipment to $maxHireLineLength characters.';
  if ((staffing?.trim().length ?? 0) > maxHireLineLength) return 'Keep the staffing to $maxHireLineLength characters.';
  if (budgetCents != null && (budgetCents < 0 || budgetCents > maxHireCents)) return 'Choose a budget between 0 and 1,000,000.00.';
  if ((notes?.trim().length ?? 0) > maxHireNotesLength) return 'Keep the special requests to $maxHireNotesLength characters.';
  return null;
}

/// The sentence for what is wrong with an offer, or null.
String? checkOffer({
  required int? rentalCents,
  required int? depositCents,
  required int? minSalesCents,
  required int? barShareBps,
  required HireControl? control,
  required int? validDays,
  String? staffing,
  String? equipment,
  String? cancellation,
  String? notes,
}) {
  if (rentalCents == null || rentalCents < 0 || rentalCents > maxHireCents) return 'Choose a rental cost between 0 and 1,000,000.00.';
  if (depositCents == null || depositCents < 0 || depositCents > rentalCents) return 'The deposit cannot be more than the rental cost.';
  if (minSalesCents == null || minSalesCents < 0 || minSalesCents > maxHireCents) return 'Choose a minimum sales figure between 0 and 1,000,000.00.';
  if (barShareBps == null || barShareBps < 0 || barShareBps > 10000) return 'Choose a bar share between 0% and 100%.';
  if (control == null) return 'Say who controls tickets and tables.';
  if ((staffing?.trim().length ?? 0) > maxHireLineLength) return 'Keep the staffing to $maxHireLineLength characters.';
  if ((equipment?.trim().length ?? 0) > maxHireLineLength) return 'Keep the equipment to $maxHireLineLength characters.';
  if ((cancellation?.trim().length ?? 0) > maxCancellationLength) return 'Keep the cancellation terms to $maxCancellationLength characters.';
  if ((notes?.trim().length ?? 0) > maxHireNotesLength) return 'Keep the notes to $maxHireNotesLength characters.';
  if (validDays == null || validDays < 1 || validDays > maxOfferDays) return 'An offer can stay open for 1 to $maxOfferDays days.';
  return null;
}

/// A bar share typed as a percentage ("20", "12.5", "7,5") as basis points, or null when it is not a number from 0 to 100.
int? parseBarShareBps(String text) {
  final t = text.trim().replaceAll('%', '').replaceAll(',', '.');
  if (t.isEmpty) return null;
  final v = double.tryParse(t);
  if (v == null || v.isNaN || v < 0 || v > 100) return null;
  return (v * 100).round();
}

/// The sentence for what is wrong with a task or schedule item, or null. [atTime] is "HH:MM" for a schedule item.
String? checkHireItem({required bool schedule, required String title, required DateTime today, String? atTime, DateTime? dueOn}) {
  final t = title.trim().length;
  if (t < minItemTitleLength || t > maxItemTitleLength) return 'Give it a title of $minItemTitleLength to $maxItemTitleLength characters.';
  if (schedule && (atTime == null || !RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(atTime))) return 'Say what time it is.';
  if (!schedule && dueOn != null) {
    final day = _day(today);
    if (_day(dueOn).isBefore(day) || _day(dueOn).isAfter(DateTime(day.year, day.month, day.day + 730))) return 'Choose a due date from today to two years from now.';
  }
  return null;
}

/// Either side can cancel an agreed or confirmed hire before its day.
bool canCancelHire(Hire h, DateTime today) => (h.state == HireState.agreed || h.state == HireState.confirmed) && _day(h.eventDate).isAfter(_day(today));

/// The hire can still be turned down or withdrawn (before it is agreed).
bool isHireOpen(Hire h) => h.state == HireState.requested || h.state == HireState.offered || h.state == HireState.offerExpired;

/// "9:00 PM" for "21:00".
String timeText(String hhmm) {
  final parts = hhmm.split(':');
  if (parts.length < 2) return hhmm;
  final h = int.tryParse(parts[0]);
  if (h == null) return hhmm;
  final m = parts[1];
  final h12 = h % 12 == 0 ? 12 : h % 12;
  return '$h12:$m ${h < 12 ? 'AM' : 'PM'}';
}

/// "21:00" from a time of day.
String hhmm(int hour, int minute) => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
