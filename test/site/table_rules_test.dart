import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/rules/table_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

// Saturday 24 Oct 2026; the next Friday is 30 Oct.
final today = DateTime(2026, 10, 24);

Venue venue({String? start, String? end, List<Map<String, dynamic>>? slots, String mode = 'pay_ahead', bool credit = false}) =>
    parseVenue(venueRow(start: start, end: end, slots: slots, mode: mode, credit: credit))!;

void main() {
  group('the night', () {
    test('a time before 06:00 belongs to the night before; 06:00 and later is the same day', () {
      expect(isAfterMidnightSlot('00:00:00'), isTrue);
      expect(isAfterMidnightSlot('01:00:00'), isTrue);
      expect(isAfterMidnightSlot('05:59:59'), isTrue);
      expect(isAfterMidnightSlot('06:00:00'), isFalse);
      expect(isAfterMidnightSlot('22:00:00'), isFalse);
    });

    test('an after-midnight time arrives the next calendar day, other times the day picked (also across a month)', () {
      final late = parseTimeSlot(slotRow(time: '01:00:00'))!;
      final evening = parseTimeSlot(slotRow(time: '22:00:00'))!;
      expect(arrivalDate(DateTime(2026, 10, 30), late), DateTime(2026, 10, 31));
      expect(arrivalDate(DateTime(2026, 10, 31), late), DateTime(2026, 11, 1));
      expect(arrivalDate(DateTime(2026, 12, 31), late), DateTime(2027, 1, 1));
      expect(arrivalDate(DateTime(2026, 10, 30, 15, 45), evening), DateTime(2026, 10, 30));
    });

    test('the note tells the guest which day they arrive, only for after-midnight times', () {
      expect(arrivalNote(DateTime(2026, 10, 30), parseTimeSlot(slotRow(time: '01:00:00'))!), 'Friday night\'s event - you\'ll be arriving Saturday, 1:00 AM.');
      expect(arrivalNote(DateTime(2026, 10, 30), parseTimeSlot(slotRow(time: '22:00:00'))!), isNull);
    });

    test('weekdays are numbered 0 = Sunday to 6 = Saturday, like the website', () {
      expect(weekdayIndex(DateTime(2026, 10, 25)), 0);
      expect(weekdayIndex(DateTime(2026, 10, 26)), 1);
      expect(weekdayIndex(DateTime(2026, 10, 30)), 5);
      expect(weekdayIndex(DateTime(2026, 10, 24)), 6);
    });

    test('dayKey is the date the website expects, in plain digits', () {
      expect(dayKey(DateTime(2026, 1, 5, 23, 59)), '2026-01-05');
      expect(dayKey(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('guests start at two, or at the table\'s own minimum, and never above what it seats', () {
      expect(defaultGuests(parseTableType(tableTypeRow(maxGuests: 6))!), 2);
      expect(defaultGuests(parseTableType({...tableTypeRow(maxGuests: 8), 'min_guests': 4})!), 4);
      expect(defaultGuests(parseTableType({...tableTypeRow(maxGuests: 3), 'min_guests': 5})!), 3);
      expect(defaultGuests(parseTableType(tableTypeRow(maxGuests: 1))!), 1);
      expect(defaultGuests(parseTableType({...tableTypeRow(), 'min_guests': 0})!), 1);
    });

    test('the hours offered reach at least the table\'s own minimum', () {
      expect(maxHoursFor(parseTableType(tableTypeRow(mode: 'hourly', rate: 100, minHours: 2))!), 12);
      expect(maxHoursFor(parseTableType(tableTypeRow(mode: 'hourly', rate: 100, minHours: 14))!), 14);
    });
  });

  group('which nights can be booked', () {
    final v = venue(slots: [slotRow(day: 5, time: '23:30:00'), slotRow(id: 's2', day: 5, time: '21:00:00'), slotRow(id: 's3', day: 6)]);

    test('the times of a night go in the order the night goes: after-midnight times come last', () {
      final night = venue(slots: [slotRow(id: 'late', day: 5, time: '01:00:00'), slotRow(id: 'peak', day: 5, time: '23:30:00'), slotRow(id: 'early', day: 5, time: '21:00:00'), slotRow(id: 'later', day: 5, time: '02:30:00')]);
      expect(slotsOn(night, DateTime(2026, 10, 30)).map((s) => s.id), ['early', 'peak', 'late', 'later']);
    });

    test('the slots on a day are that weekday\'s, earliest first', () {
      expect(slotsOn(v, DateTime(2026, 10, 30)).map((s) => s.id), ['s2', 's1']);
      expect(slotsOn(v, DateTime(2026, 10, 31)).map((s) => s.id), ['s3']);
      expect(slotsOn(v, DateTime(2026, 10, 28)), isEmpty);
    });

    test('a night in the past, or on a weekday with no time, is refused in words; today is fine', () {
      expect(nightBlock(v, DateTime(2026, 10, 23), today: today), 'That date has passed.');
      expect(nightBlock(v, DateTime(2026, 10, 28), today: today), 'Club A does not take table bookings on a Wednesday.');
      expect(nightBlock(v, today, today: today), isNull);
      expect(nightBlock(v, DateTime(2026, 10, 30), today: today), isNull);
    });

    test('a night outside the window the venue takes bookings in is refused, the first and last night are fine', () {
      final windowed = venue(start: '2026-11-06', end: '2026-11-20');
      expect(nightBlock(windowed, DateTime(2026, 10, 30), today: today), 'Bookings open Nov 6, 2026.');
      expect(nightBlock(windowed, DateTime(2026, 11, 6), today: today), isNull);
      expect(nightBlock(windowed, DateTime(2026, 11, 20), today: today), isNull);
      expect(nightBlock(windowed, DateTime(2026, 11, 27), today: today), 'Bookings closed Nov 20, 2026.');
    });

    test('the first night to offer is the next one that can be booked', () {
      expect(firstBookableNight(venue(), today: today), DateTime(2026, 10, 30));
      expect(firstBookableNight(venue(start: '2026-11-10'), today: today), DateTime(2026, 11, 13));
      expect(firstBookableNight(venue(end: '2026-10-01'), today: today), isNull);
      expect(firstBookableNight(venue(slots: const []), today: today), isNull);
    });
  });

  group('words', () {
    test('times read like the website\'s', () {
      expect(formatSlotTime('22:00:00'), '10:00 PM');
      expect(formatSlotTime('00:30:00'), '12:30 AM');
      expect(formatSlotTime('12:00:00'), '12:00 PM');
      expect(formatSlotTime('09:05:00'), '9:05 AM');
      expect(slotLabel(parseTimeSlot(slotRow(label: 'Doors'))!), '10:00 PM (Doors)');
      expect(slotLabel(parseTimeSlot(slotRow())!), '10:00 PM');
    });

    test('a flat table is listed by its minimum spend, an hourly one by its rate and minimum hours', () {
      expect(tablePriceLabel(parseTableType(tableTypeRow(minSpend: 50000))!), '\$500 min spend');
      expect(tablePriceLabel(parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 2))!), '\$150/hr · 2hr min');
      expect(tablePriceLabel(parseTableType(tableTypeRow(minSpend: 12550))!), '\$125.50 min spend');
    });
  });

  group('what a table costs', () {
    test('a flat table charges its deposit; an hourly one the rate times the hours', () {
      expect(tableAmountCents(parseTableType(tableTypeRow(deposit: 10000))!, 3), 10000);
      expect(tableAmountCents(parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 2))!, 3), 45000);
    });

    test('the guest chooses how to pay for bottles only when the venue allows both', () {
      expect(effectiveChoice(BottlePaymentMode.both, BottlePaymentChoice.payAtClub), BottlePaymentChoice.payAtClub);
      expect(effectiveChoice(BottlePaymentMode.both, BottlePaymentChoice.payAhead), BottlePaymentChoice.payAhead);
      expect(effectiveChoice(BottlePaymentMode.payAhead, BottlePaymentChoice.payAtClub), BottlePaymentChoice.payAhead);
      expect(effectiveChoice(BottlePaymentMode.payAtClub, BottlePaymentChoice.payAhead), BottlePaymentChoice.payAtClub);
    });

    TableQuote quote({int table = 10000, int bottles = 25000, BottlePaymentChoice choice = BottlePaymentChoice.payAhead, bool credit = false, int tax = 1300, int? fee = 250, int discount = 0}) => quoteTable(
          tableCents: table,
          bottleSubtotalCents: bottles,
          choice: choice,
          depositIsCredit: credit,
          taxRateBps: tax,
          feeBps: fee,
          discountCents: discount,
        );

    test('paying for bottles ahead charges table and bottles now, with tax and the BottlesUp fee on the sum', () {
      final q = quote();
      expect([q.beforeTaxCents, q.taxCents, q.feeCents, q.totalNowCents, q.dueAtVenueCents], [35000, 4550, 875, 40425, 0]);
    });

    test('paying at the club charges only the table now and leaves the bottles for the club', () {
      final q = quote(choice: BottlePaymentChoice.payAtClub);
      expect([q.chargedNowBottleCents, q.beforeTaxCents, q.taxCents, q.feeCents, q.totalNowCents, q.dueAtVenueCents], [0, 10000, 1300, 250, 11550, 25000]);
    });

    test('when the deposit counts as credit, the club only asks for what is left after it, never less than nothing', () {
      expect(quote(choice: BottlePaymentChoice.payAtClub, credit: true).dueAtVenueCents, 15000);
      expect(quote(choice: BottlePaymentChoice.payAtClub, credit: true, bottles: 4000).dueAtVenueCents, 0);
      expect(quote(choice: BottlePaymentChoice.payAhead, credit: true).dueAtVenueCents, 0, reason: 'credit never moves a charge back online');
    });

    test('a discount comes off what is charged now before tax and fee, and never below nothing', () {
      final q = quote(discount: 5000);
      expect([q.discountCents, q.taxCents, q.feeCents, q.totalNowCents], [5000, 3900, 750, 34650]);
      final over = quote(discount: 999999, bottles: 0);
      expect([over.discountCents, over.taxCents, over.totalNowCents], [10000, 0, 0]);
    });

    test('halves round up like the website: 6.5 cents of tax is 7', () {
      final q = quoteTable(tableCents: 50, bottleSubtotalCents: 0, choice: BottlePaymentChoice.payAhead, depositIsCredit: false, taxRateBps: 1300, feeBps: 0);
      expect(q.taxCents, 7);
    });

    test('without a fee reading the total says it may be a little higher', () {
      final q = quote(fee: null);
      expect([q.feeKnown, q.feeCents, q.totalNowCents], [false, 0, 39550]);
      expect(quote().feeKnown, isTrue);
    });
  });

  group('validateTableBooking', () {
    final v = venue();
    final table = v.tables.single;
    final hourly = parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 2))!;
    final friday = DateTime(2026, 10, 30);
    final slot = v.slots.single;

    String? check({TableType? t, DateTime? night, TimeSlot? s, int guests = 4, int hours = 1, String name = 'Dana Lee', String email = 'dana@example.com', String phone = ''}) => validateTableBooking(
          venue: v,
          table: t ?? table,
          night: night ?? friday,
          slot: s ?? slot,
          guests: guests,
          hours: hours,
          name: name,
          email: email,
          phone: phone,
          today: today,
        );

    test('a complete booking is fine', () {
      expect(check(), isNull);
    });

    test('says what is missing, in this order: table, date, a date that can be booked, time, guests, hours, name, email, phone', () {
      expect(validateTableBooking(venue: v, table: null, night: friday, slot: slot, guests: 2, hours: 1, name: 'Dana Lee', email: 'a@b.co', phone: '', today: today), 'Choose a table.');
      expect(validateTableBooking(venue: v, table: table, night: null, slot: slot, guests: 2, hours: 1, name: 'Dana Lee', email: 'a@b.co', phone: '', today: today), 'Choose a date.');
      expect(check(night: DateTime(2026, 10, 28)), 'Club A does not take table bookings on a Wednesday.');
      expect(validateTableBooking(venue: v, table: table, night: friday, slot: null, guests: 2, hours: 1, name: 'Dana Lee', email: 'a@b.co', phone: '', today: today), 'Choose an arrival time.');
      expect(check(guests: 0), 'Choose how many guests.');
      expect(check(guests: 7), 'This table seats up to 6 guests.');
      expect(check(t: hourly, hours: 1), 'This table needs at least 2 hours.');
      expect(check(name: 'D'), 'Enter your name (at least 2 letters).');
      expect(check(email: 'dana'), 'Your account needs a valid email address to send the confirmation to.');
      expect(check(phone: '1' * 41), 'That phone number is too long.');
    });

    test('a time that belongs to another weekday or another venue is not accepted', () {
      final saturdaySlot = parseTimeSlot(slotRow(id: 'sat', day: 6))!;
      expect(check(s: saturdaySlot), 'Choose an arrival time.');
      final otherVenue = parseTimeSlot(slotRow(id: 'x', venueId: 'other'))!;
      expect(check(s: otherVenue), 'Choose an arrival time.');
    });

    test('an hourly table with enough hours is fine', () {
      expect(check(t: hourly, hours: 2), isNull);
    });

    test('1 hour minimum says hour, not hours', () {
      final one = parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 1))!;
      expect(check(t: one, hours: 0), 'This table needs at least 1 hour.');
    });
  });
}
