import 'dart:ui' show Offset, Rect, Size;

import 'package:intl/intl.dart';

import '../models/venue.dart';
import '../money.dart';

/// Rules for booking a VIP table, copied from the website (its booking page and `create-table-booking-checkout`). The website decides everything again when the booking is made; these
/// only let the app say the same thing first. `test/site/site_drift_test.dart` keeps the constants in step with the website.

/// A time slot that starts before this is the tail of the PREVIOUS calendar day's night (a table booked for 1:00 AM is a guest arriving the morning after the night they picked).
const String afterMidnightCutoff = '06:00:00';

/// The most hours the stepper offers for an hourly table. The website sets no limit; this only keeps the control sensible.
const int maxHoursOffered = 12;

const int tableNameMin = 2;
const int tableNameMax = 120;
const int tablePhoneMax = 40;

final RegExp _emailShape = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

bool isAfterMidnightSlot(String startTime) => startTime.compareTo(afterMidnightCutoff) < 0;

/// "2026-10-30": the day as the website expects it, with ASCII digits whatever the phone's language is.
String dayKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// How many guests to start from: two, or the table's own minimum when it states one, never more than it seats. It is where the stepper starts, not a rule (the website does not enforce
/// a minimum).
int defaultGuests(TableType t) {
  final start = t.minGuests ?? 2;
  return start < 1 ? 1 : (start > t.maxGuests ? t.maxGuests : start);
}

/// The most hours the stepper offers for this table: [maxHoursOffered], or its own minimum when that is higher.
int maxHoursFor(TableType t) => t.minimumHours > maxHoursOffered ? t.minimumHours : maxHoursOffered;

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// The calendar day the guest actually arrives: the picked night, or the next day for an after-midnight slot.
DateTime arrivalDate(DateTime night, TimeSlot slot) {
  final n = _dayOnly(night);
  return isAfterMidnightSlot(slot.startTime) ? DateTime(n.year, n.month, n.day + 1) : n;
}

/// 0 = Sunday ... 6 = Saturday, the way the website stores the weekday of a slot.
int weekdayIndex(DateTime d) => d.weekday % 7;

/// The venue's booking times on a calendar day, in the order the night goes: evening times first, then the after-midnight ones (1:00 AM comes after 11:30 PM).
List<TimeSlot> slotsOn(Venue venue, DateTime date) => [
      for (final s in venue.slots)
        if (s.dayOfWeek == weekdayIndex(date)) s,
    ]..sort((a, b) => _nightOrder(a).compareTo(_nightOrder(b)));

String _nightOrder(TimeSlot s) => '${isAfterMidnightSlot(s.startTime) ? '1' : '0'}${s.startTime}';

/// Why this night cannot be booked, as a sentence, or null when it can: in the past, no booking time on that weekday, outside the window the venue takes bookings in.
String? nightBlock(Venue venue, DateTime night, {required DateTime today}) {
  final day = _dayOnly(night);
  if (day.isBefore(_dayOnly(today))) return 'That date has passed.';
  if (slotsOn(venue, day).isEmpty) return '${venue.name} does not take table bookings on a ${DateFormat('EEEE').format(day)}.';
  final start = venue.bookingStart;
  if (start != null && day.isBefore(start)) return 'Bookings open ${DateFormat('MMM d, yyyy').format(start)}.';
  final end = venue.bookingEnd;
  if (end != null && day.isAfter(end)) return 'Bookings closed ${DateFormat('MMM d, yyyy').format(end)}.';
  return null;
}

bool canBookNight(Venue venue, DateTime night, {required DateTime today}) => nightBlock(venue, night, today: today) == null;

/// The first night from [today] that can be booked, looking up to [within] days ahead, or null.
DateTime? firstBookableNight(Venue venue, {required DateTime today, int within = 120}) {
  final start = _dayOnly(today);
  for (var i = 0; i < within; i++) {
    final d = DateTime(start.year, start.month, start.day + i);
    if (canBookNight(venue, d, today: today)) return d;
  }
  return null;
}

/// "10:00 PM".
String formatSlotTime(String startTime) {
  final parts = startTime.split(':');
  final h = int.tryParse(parts[0]) ?? 0;
  final m = parts.length > 1 ? parts[1] : '00';
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  return '$hour12:$m ${h >= 12 ? 'PM' : 'AM'}';
}

/// "10:00 PM", or "10:00 PM (Doors)" when the venue named the time.
String slotLabel(TimeSlot slot) => slot.label == null ? formatSlotTime(slot.startTime) : '${formatSlotTime(slot.startTime)} (${slot.label})';

/// For an after-midnight time: "Saturday night's event - you'll be arriving Sunday, 1:00 AM." Null for any other time.
String? arrivalNote(DateTime night, TimeSlot slot) {
  if (!isAfterMidnightSlot(slot.startTime)) return null;
  final arrival = arrivalDate(night, slot);
  return '${DateFormat('EEEE').format(night)} night\'s event - you\'ll be arriving ${DateFormat('EEEE').format(arrival)}, ${formatSlotTime(slot.startTime)}.';
}

/// What the table costs to book, as the list shows it: "$150/hr · 2hr min" or "$500 min spend".
String tablePriceLabel(TableType t) => t.isHourly
    ? '${formatMoney(t.hourlyRateCents ?? 0, currency: t.currency).replaceAll('.00', '')}/hr · ${t.minimumHours}hr min'
    : '${formatMoney(t.minSpendCents, currency: t.currency).replaceAll('.00', '')} min spend';

/// What is charged for the table itself: the deposit, or the hourly rate times the hours.
int tableAmountCents(TableType t, int hours) => t.isHourly ? (t.hourlyRateCents ?? 0) * hours : t.depositCents;

/// What the guest can choose for the bottles. When the venue allows both, the guest chooses; otherwise the venue has decided.
BottlePaymentChoice effectiveChoice(BottlePaymentMode mode, BottlePaymentChoice chosen) => switch (mode) {
      BottlePaymentMode.both => chosen,
      BottlePaymentMode.payAhead => BottlePaymentChoice.payAhead,
      BottlePaymentMode.payAtClub => BottlePaymentChoice.payAtClub,
    };

/// What a booking comes to. The numbers are the website's rules; the website works them out again at payment, so this is a preview.
class TableQuote {
  const TableQuote({
    required this.tableCents,
    required this.bottleSubtotalCents,
    required this.chargedNowBottleCents,
    required this.dueAtVenueCents,
    required this.discountCents,
    required this.taxCents,
    required this.feeCents,
    required this.totalNowCents,
    required this.feeKnown,
  });

  final int tableCents;
  final int bottleSubtotalCents;

  /// The bottles charged online now (all of them for pay ahead, none for pay at the club).
  final int chargedNowBottleCents;

  /// What is left to pay at the club, for the bottles.
  final int dueAtVenueCents;
  final int discountCents;
  final int taxCents;
  final int feeCents;

  /// The total charged on the payment page.
  final int totalNowCents;

  /// False when the BottlesUp fee could not be read, so the total may be a little higher.
  final bool feeKnown;

  int get beforeTaxCents => tableCents + chargedNowBottleCents;
}

TableQuote quoteTable({
  required int tableCents,
  required int bottleSubtotalCents,
  required BottlePaymentChoice choice,
  required bool depositIsCredit,
  required int taxRateBps,
  required int? feeBps,
  int discountCents = 0,
}) {
  final atClub = choice == BottlePaymentChoice.payAtClub;
  final due = !atClub ? 0 : (depositIsCredit ? (bottleSubtotalCents - tableCents).clamp(0, 1 << 31) : bottleSubtotalCents);
  final chargedBottles = atClub ? 0 : bottleSubtotalCents;
  final before = tableCents + chargedBottles;
  final discount = discountCents.clamp(0, before);
  final discounted = before - discount;
  final tax = (discounted * taxRateBps / 10000).round();
  final fee = (discounted * (feeBps ?? 0) / 10000).round();
  return TableQuote(
    tableCents: tableCents,
    bottleSubtotalCents: bottleSubtotalCents,
    chargedNowBottleCents: chargedBottles,
    dueAtVenueCents: due,
    discountCents: discount,
    taxCents: tax,
    feeCents: fee,
    totalNowCents: discounted + tax + fee,
    feeKnown: feeBps != null,
  );
}

/// The first thing wrong with a table booking about to be sent, as a sentence, or null when it can go ahead. The website checks all of this again.
String? validateTableBooking({
  required Venue venue,
  required TableType? table,
  required DateTime? night,
  required TimeSlot? slot,
  required int guests,
  required int hours,
  required String name,
  required String email,
  required String phone,
  required DateTime today,
}) {
  if (table == null) return 'Choose a table.';
  if (night == null) return 'Choose a date.';
  final block = nightBlock(venue, night, today: today);
  if (block != null) return block;
  if (slot == null || slot.venueId != venue.id || slot.dayOfWeek != weekdayIndex(night)) return 'Choose an arrival time.';
  if (guests < 1) return 'Choose how many guests.';
  if (guests > table.maxGuests) return 'This table seats up to ${table.maxGuests} guests.';
  if (table.isHourly && hours < table.minimumHours) return 'This table needs at least ${table.minimumHours} hour${table.minimumHours == 1 ? '' : 's'}.';
  final n = name.trim();
  if (n.length < tableNameMin) return 'Enter your name (at least $tableNameMin letters).';
  if (n.length > tableNameMax) return 'That name is too long.';
  final e = email.trim();
  if (e.isEmpty || e.length > 254 || !_emailShape.hasMatch(e)) return 'Your account needs a valid email address to send the confirmation to.';
  if (phone.trim().length > tablePhoneMax) return 'That phone number is too long.';
  return null;
}

/// The venues that match what the person typed (name, address or category), ignoring case.
List<Venue> filterVenues(List<Venue> venues, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return venues;
  return [
    for (final v in venues)
      if (v.name.toLowerCase().contains(q) || (v.address ?? '').toLowerCase().contains(q) || (v.category ?? '').toLowerCase().contains(q) || v.tables.any((t) => t.name.toLowerCase().contains(q))) v,
  ];
}

/// The next few nights that can be booked from [today], for quick choosing.
List<DateTime> nextBookableNights(Venue venue, {required DateTime today, int count = 5, int within = 120}) {
  final out = <DateTime>[];
  final start = _dayOnly(today);
  for (var i = 0; i < within && out.length < count; i++) {
    final d = DateTime(start.year, start.month, start.day + i);
    if (canBookNight(venue, d, today: today)) out.add(d);
  }
  return out;
}

/// Where a table's spot is on the floor plan picture, for a picture [size]. A spot is never smaller than [minSide] so a finger can hit it.
Rect hotspotRect(TableType t, Size size, {double minSide = 30}) {
  final w = (size.width * (t.width ?? 0) / 100);
  final h = (size.height * (t.height ?? 0) / 100);
  final left = size.width * (t.posX ?? 0) / 100;
  final top = size.height * (t.posY ?? 0) / 100;
  final cx = left + w / 2, cy = top + h / 2;
  final width = w < minSide ? minSide : w;
  final height = h < minSide ? minSide : h;
  return Rect.fromCenter(center: Offset(cx, cy), width: width, height: height);
}
