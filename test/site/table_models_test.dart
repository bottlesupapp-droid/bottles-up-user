import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/models/venue.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('time slots', () {
    test('a good row is read, with the time always as HH:MM:SS so times compare as text', () {
      final s = parseTimeSlot(slotRow(time: '9:30'), venueId: 'v1')!;
      expect([s.id, s.dayOfWeek, s.startTime, s.label], ['s1', 5, '09:30:00', null]);
      expect(parseTimeSlot(slotRow(time: '22:00:00', label: 'Doors'))!.label, 'Doors');
    });

    test('a row with a weekday outside 0 to 6, no time or a time that is not a time is dropped', () {
      expect(parseTimeSlot(slotRow(day: 7)), isNull);
      expect(parseTimeSlot(slotRow(day: -1)), isNull);
      expect(parseTimeSlot({...slotRow(), 'start_time': null}), isNull);
      expect(parseTimeSlot(slotRow(time: 'late')), isNull);
      expect(parseTimeSlot({...slotRow(), 'id': null}), isNull);
    });
  });

  group('table types', () {
    test('a flat table is priced by its deposit and listed by what it costs to book', () {
      final t = parseTableType(tableTypeRow(deposit: 10000, minSpend: 50000))!;
      expect([t.name, t.maxGuests, t.isHourly, t.depositCents, t.minSpendCents, t.fromCents], ['Booth 1', 6, false, 10000, 50000, 10000]);
      expect(t.hasSpot, isFalse);
    });

    test('an hourly table is priced by the rate and its minimum hours (at least one)', () {
      final t = parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 2))!;
      expect([t.isHourly, t.hourlyRateCents, t.minimumHours, t.fromCents], [true, 15000, 2, 30000]);
      expect(parseTableType(tableTypeRow(mode: 'hourly', rate: 15000))!.minimumHours, 1);
      expect(parseTableType(tableTypeRow(mode: 'hourly', rate: 15000, minHours: 0))!.minimumHours, 1);
    });

    test('an hourly table with no rate cannot be booked, so it is dropped (the website refuses it too)', () {
      expect(parseTableType(tableTypeRow(mode: 'hourly')), isNull);
      expect(parseTableType(tableTypeRow(mode: 'hourly', rate: 0)), isNull);
    });

    test('a table on the floor plan has a spot; one with only a floor does not', () {
      final t = parseTableType(tableTypeRow(floorId: 'f1', x: 12.5, y: 30))!;
      expect([t.hasSpot, t.posX, t.posY, t.width, t.height], [true, 12.5, 30.0, 10.0, 8.0]);
      expect(parseTableType(tableTypeRow(floorId: 'f1'))!.hasSpot, isFalse);
    });

    test('a row with no name, no guest limit or a guest limit under one is dropped', () {
      expect(parseTableType({...tableTypeRow(), 'name': ' '}), isNull);
      expect(parseTableType({...tableTypeRow(), 'max_guests': null}), isNull);
      expect(parseTableType(tableTypeRow(maxGuests: 0)), isNull);
      expect(parseTableType({...tableTypeRow(), 'id': null}), isNull);
    });
  });

  group('bottles', () {
    test('a bottle that is not available or is sold out is not offered', () {
      expect(parseBottle(bottleRow()), isNotNull);
      expect(parseBottle(bottleRow(available: false)), isNull);
      expect(parseBottle(bottleRow(soldOut: true)), isNull);
      expect(parseBottle({...bottleRow(), 'price_cents': null}), isNull);
    });

    test('the name carries the size when there is one', () {
      expect(parseBottle(bottleRow())!.displayName, 'Grey Goose (1.75L)');
      expect(parseBottle(bottleRow(size: null))!.displayName, 'Grey Goose');
    });
  });

  group('venues', () {
    test('a venue is read with its tables and times, tables in the venue\'s order and times by weekday and time', () {
      final v = parseVenue(venueRow(
        tables: [tableTypeRow(id: 'b', name: 'Booth B', sort: 2), tableTypeRow(id: 'a', name: 'Booth A', sort: 2), tableTypeRow(id: 'c', name: 'Couch', sort: 1)],
        slots: [slotRow(id: 's3', day: 6, time: '22:00:00'), slotRow(id: 's2', day: 5, time: '23:30:00'), slotRow(id: 's1', day: 5, time: '21:00:00')],
        start: '2026-11-01',
        end: '2027-01-31',
      ))!;
      expect(v.tables.map((t) => t.id), ['c', 'a', 'b']);
      expect(v.slots.map((s) => s.id), ['s1', 's2', 's3']);
      expect(v.bookingStart, DateTime(2026, 11, 1));
      expect(v.bookingEnd, DateTime(2027, 1, 31));
      expect([v.name, v.taxRateBps, v.bottlePaymentMode, v.depositIsCredit, v.isBookable], ['Club A', 1300, BottlePaymentMode.payAhead, false, true]);
    });

    test('bad tables and times inside a venue are left out, not fatal', () {
      final v = parseVenue(venueRow(tables: [tableTypeRow(), {...tableTypeRow(id: 'x'), 'max_guests': 0}], slots: [slotRow(), slotRow(id: 'bad', day: 9)]))!;
      expect(v.tables.length, 1);
      expect(v.slots.length, 1);
    });

    test('a venue without tables or without times cannot be booked', () {
      expect(parseVenue(venueRow(tables: const []))!.isBookable, isFalse);
      expect(parseVenue(venueRow(slots: const []))!.isBookable, isFalse);
    });

    test('the booking mode, the credit switch and the pictures are read; an unknown mode is pay ahead', () {
      expect(parseVenue(venueRow(mode: 'both'))!.bottlePaymentMode, BottlePaymentMode.both);
      expect(parseVenue(venueRow(mode: 'pay_at_club', credit: true))!.depositIsCredit, isTrue);
      expect(parseVenue(venueRow(mode: 'whatever'))!.bottlePaymentMode, BottlePaymentMode.payAhead);
      expect(parseVenue(venueRow(cover: 'https://img.example/c.jpg'))!.picture, 'https://img.example/c.jpg');
      expect(parseVenue(venueRow())!.picture, isNull);
    });

    test('the floor plan flag and the "from" price come from the tables', () {
      final plain = parseVenue(venueRow(tables: [tableTypeRow(deposit: 20000), tableTypeRow(id: 'b', deposit: 10000)]))!;
      expect([plain.hasFloorPlan, plain.fromCents], [false, 10000]);
      final plan = parseVenue(venueRow(tables: [tableTypeRow(floorId: 'f1', x: 1, y: 2)]))!;
      expect(plan.hasFloorPlan, isTrue);
      expect(parseVenue(venueRow(tables: [tableTypeRow(deposit: 0)]))!.fromCents, isNull);
    });

    test('a venue with no name or id is dropped', () {
      expect(parseVenue({...venueRow(), 'name': ''}), isNull);
      expect(parseVenue({...venueRow(), 'id': null}), isNull);
    });
  });

  group('what the website says after a table is paid', () {
    test('a paid table booking carries its confirmation, amounts and bottles', () {
      final s = parsePaymentStatus(paidBookingAnswer(bottles: 25000, due: 15000, paid: 11300));
      expect(s.state, PaymentState.paid);
      expect(s.ticket, isNull);
      final b = s.booking!;
      expect([b.confirmationCode, b.guestCount, b.tableName, b.venueName, b.startTime], ['TB-ABCD2345', 4, 'Booth 1', 'Club A', '22:00:00']);
      expect(b.bookingDate, DateTime(2099, 11, 7));
      expect([b.depositCents, b.bottleSubtotalCents, b.taxCents, b.paidNowCents, b.dueAtVenueCents, b.totalCents], [10000, 25000, 1300, 11300, 15000, 26300]);
      expect(b.bottles.single.name, 'Grey Goose');
      expect(b.bottles.single.paymentStatus, 'due_at_venue');
    });

    test('paid with no confirmation code yet keeps waiting instead of showing an empty confirmation', () {
      final answer = paidBookingAnswer();
      final booking = Map<String, dynamic>.from(answer['booking'] as Map)..['confirmationCode'] = null;
      expect(parsePaymentStatus({...answer, 'booking': booking}).state, PaymentState.waiting);
    });

    test('paid with neither a ticket nor a booking keeps waiting', () {
      expect(parsePaymentStatus({'status': 'paid'}).state, PaymentState.waiting);
    });
  });

  group('entry passes with a table', () {
    test('a table says how many entry passes it includes, when the venue says', () {
      expect(parseTableType({...tableTypeRow(), 'included_admissions': 4})!.includedAdmissions, 4);
      expect(parseTableType(tableTypeRow())!.includedAdmissions, isNull);
    });
  });
}
