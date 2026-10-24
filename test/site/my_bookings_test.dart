import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:bottles_up_user/site/services/my_bookings_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

TableBooking booking([Map<String, dynamic>? row]) => parseTableBooking(row ?? bookingRow())!;

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  group('a booking', () {
    test('is read with where, when and what it cost', () {
      final b = booking();
      expect([b.id, b.status, b.confirmationCode, b.guestCount, b.tableName, b.venueName, b.venueAddress, b.venuePhone, b.startTime], ['bk1', BookingStatus.paid, 'TB-ABCD2345', 4, 'Booth 1', 'Club A', '1 King St W, Toronto', '416-555-0199', '22:00:00']);
      expect(b.bookingDate, DateTime(2099, 11, 6));
      expect([b.depositCents, b.taxCents, b.totalCents, b.paidCents, b.currency], [10000, 1300, 11300, 11300, 'cad']);
      expect(b.arrival, DateTime(2099, 11, 6, 22));
    });

    test('a row that cannot be trusted is dropped: no id, an unknown status, no day, no guests, no creation time', () {
      expect(parseTableBooking({...bookingRow(), 'id': null}), isNull);
      expect(parseTableBooking(bookingRow(status: 'mystery')), isNull);
      expect(parseTableBooking({...bookingRow(), 'booking_date': 'soon'}), isNull);
      expect(parseTableBooking(bookingRow(guests: 0)), isNull);
      expect(parseTableBooking({...bookingRow(), 'created_at': null}), isNull);
    });

    test('a booking whose table, venue or time the website no longer shows still reads, with plain stand-ins', () {
      final b = parseTableBooking({...bookingRow(), 'site_table_types': null, 'site_venues': null, 'site_venue_time_slots': null})!;
      expect([b.tableName, b.venueName, b.startTime, b.arrival], ['VIP table', 'Venue', null, null]);
    });

    test('the status says what it means to a guest', () {
      expect(BookingStatus.paid.label, 'Confirmed');
      expect(BookingStatus.cancelled.label, 'Cancelled');
      expect(BookingStatus.refunded.label, 'Refunded');
      expect(BookingStatus.fromDb('paid'), BookingStatus.paid);
      expect(BookingStatus.fromDb('nonsense'), isNull);
    });

    test('what is still owed at the club is the total less what was paid, never below nothing, and nothing on a cancelled booking', () {
      expect(booking(bookingRow(total: 36300, paid: 11300)).dueAtClubCents, 25000);
      expect(booking(bookingRow(total: 11300, paid: 11300)).dueAtClubCents, 0);
      expect(booking(bookingRow(total: 5000, paid: 9000)).dueAtClubCents, 0);
      expect(booking(bookingRow(status: 'cancelled', total: 36300, paid: 11300)).dueAtClubCents, 0);
    });

    test('a booking is over twelve hours after the guests arrive, not before', () {
      final b = booking();
      expect(b.isOver(DateTime(2099, 11, 6, 21)), isFalse);
      expect(b.isOver(DateTime(2099, 11, 7, 9, 59)), isFalse);
      expect(b.isOver(DateTime(2099, 11, 7, 10)), isTrue);
    });

    test('without a known time the booking is over at the end of its day', () {
      final b = parseTableBooking({...bookingRow(), 'site_venue_time_slots': null})!;
      expect(b.isOver(DateTime(2099, 11, 6, 23, 59)), isFalse);
      expect(b.isOver(DateTime(2099, 11, 7)), isTrue);
    });

    test('checked in, cancelled and refunded are read from the row', () {
      final b = booking(bookingRow(checkedIn: '2099-11-06T23:00:00Z'));
      expect(b.isCheckedIn, isTrue);
      final c = booking(bookingRow(status: 'cancelled', cancelledAt: '2099-11-01T10:00:00Z', cancelReason: 'Venue closed'));
      expect([c.isCancelled, c.cancellationReason, c.cancelledAt != null], [true, 'Venue closed', true]);
      expect(booking(bookingRow(status: 'refunded')).isRefunded, isTrue);
    });
  });

  group('its lines', () {
    test('a bottle line carries its price and whether it is paid now or at the club', () {
      final l = parseBookingBottle(bottleLineRow(qty: 2, payment: 'due_at_venue', addon: true))!;
      expect([l.displayName, l.quantity, l.unitPriceCents, l.lineTotalCents, l.dueAtClub, l.isAddon, l.cancelled], ['Grey Goose (1.75L)', 2, 25000, 50000, true, true, false]);
      expect(parseBookingBottle(bottleLineRow(cancelledAt: '2099-11-01T10:00:00Z'))!.cancelled, isTrue);
      expect(parseBookingBottle(bottleLineRow(size: null))!.displayName, 'Grey Goose');
    });

    test('a bottle line with no name, id or a quantity under one is dropped', () {
      expect(parseBookingBottle({...bottleLineRow(), 'bottle_name': null}), isNull);
      expect(parseBookingBottle({...bottleLineRow(), 'id': null}), isNull);
      expect(parseBookingBottle(bottleLineRow(qty: 0)), isNull);
    });

    test('a club payment waiting for the guest and a refund are read', () {
      final p = parseClubPayment(clubPaymentRow())!;
      expect([p.id, p.token, p.billedCents, p.paidCents, p.method], ['cp1', 'tok-1', 25000, 25000, 'debit']);
      expect(parseClubPayment({...clubPaymentRow(), 'confirm_token': null}), isNull);
      final r = parseBookingRefund(bookingRefundRow())!;
      expect([r.type, r.amountCents, r.reason, r.recordedAt != null], ['full', 11300, 'Cancelled by the guest', true]);
      expect(parseBookingRefund({...bookingRefundRow(), 'amount_cents': null}), isNull);
    });
  });

  group('the service', () {
    test('asks for paid, refunded and cancelled bookings, newest first, with the table, venue and time in one request', () async {
      site.tables['site_table_bookings'] = [bookingRow()];
      final list = await MyBookingsService(site.client).bookings();
      final r = site.forTable('site_table_bookings').single;
      expect(r.method, 'GET');
      expect(r.query['status'], 'in.("paid","refunded","cancelled")');
      expect(r.query['order'], startsWith('created_at.desc'));
      expect(r.query['select'], allOf(contains('confirmation_code'), contains('amount_paid_cents'), contains('site_table_types(name)'), contains('site_venues(name,address,phone)'), contains('site_venue_time_slots(start_time,label)')));
      expect(list.single.tableName, 'Booth 1');
    });

    test('a booking that cannot be read does not break the list', () async {
      site.tables['site_table_bookings'] = [bookingRow(id: 'ok'), {...bookingRow(id: 'bad'), 'booking_date': null}];
      expect((await MyBookingsService(site.client).bookings()).map((b) => b.id), ['ok']);
    });

    test('a failure is a plain sentence', () async {
      site.failAllWith = 500;
      await expectLater(MyBookingsService(site.client).bookings(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load your bookings. Check your connection and try again.')));
    });

    test('one booking comes with its bottles (not the unpaid ones), the club payments waiting for the guest, and the refunds', () async {
      site.tables['site_table_bookings'] = [bookingRow(bottles: 25000, total: 36300)];
      site.tables['site_table_booking_bottles'] = [bottleLineRow(), bottleLineRow(id: 'l2', name: 'Don Julio', size: null, payment: 'due_at_venue')];
      site.tables['site_table_booking_club_payments'] = [clubPaymentRow()];
      site.tables['site_table_booking_refunds'] = [bookingRefundRow()];
      final b = (await MyBookingsService(site.client).booking('bk1'))!;
      expect(site.forTable('site_table_bookings').single.query['id'], 'eq.bk1');
      final bottles = site.forTable('site_table_booking_bottles').single.query;
      expect([bottles['booking_id'], bottles['payment_status']], ['eq.bk1', 'neq.pending_payment']);
      final club = site.forTable('site_table_booking_club_payments').single.query;
      expect([club['booking_id'], club['customer_confirmation_status']], ['eq.bk1', 'eq.pending']);
      expect(site.forTable('site_table_booking_refunds').single.query['booking_id'], 'eq.bk1');
      expect(b.bottles.map((l) => l.displayName), ['Grey Goose (1.75L)', 'Don Julio']);
      expect(b.clubPayments.single.token, 'tok-1');
      expect(b.refunds.single.amountCents, 11300);
    });

    test('a booking that is not there (or is not theirs) is null', () async {
      site.tables['site_table_bookings'] = [];
      expect(await MyBookingsService(site.client).booking('nope'), isNull);
    });

    test('a failure reading one booking is a plain sentence', () async {
      site.failAllWith = 500;
      await expectLater(MyBookingsService(site.client).booking('bk1'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load this booking. Check your connection and try again.')));
    });
  });

  group('where the venue has got to with a bottle', () {
    String? label(String status) => parseBookingBottle(bottleLineRow(service: status))!.serviceLabel;

    test('each status the venue uses has a plain label, and one the app does not know has none', () {
      expect([label('awaiting_prep'), label('preparing'), label('ready'), label('picked_up'), label('served')], ['Order received', 'Being prepared', 'Ready', 'On the way', 'Delivered']);
      expect(label('mystery'), isNull);
      expect(parseBookingBottle({...bottleLineRow(), 'service_status': null})!.serviceLabel, isNull);
    });

    test('the quantity delivered so far is read', () {
      expect(parseBookingBottle(bottleLineRow(qty: 3, delivered: 2))!.deliveredQuantity, 2);
    });
  });
}
