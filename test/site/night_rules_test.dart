import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:bottles_up_user/site/models/ticket_order.dart';
import 'package:bottles_up_user/site/rules/night_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

TableBooking booking({String id = 'b1', String status = 'paid', String date = '2099-11-06', String time = '22:00:00', int guests = 4, String venue = 'Club A', String table = 'Booth 1'}) =>
    parseTableBooking(bookingRow(id: id, status: status, date: date, time: time, guests: guests, venueName: venue, tableName: table))!;

TicketOrder order({String id = 'o1', String status = 'paid', String? start = '2099-11-05T22:00:00Z', String? end, int quantity = 2, bool used = false}) => parseTicketOrder({
      'id': id,
      'status': status,
      'quantity': quantity,
      'amount_total_cents': 4000,
      'currency': 'cad',
      'created_at': '2099-10-20T12:00:00Z',
      'ticket_code': 'BU-ABCD2345',
      'checked_in_at': used ? '2099-11-05T23:00:00Z' : null,
      'site_events': {'id': 'e1', 'title': 'Friday Night', 'venue_name': 'Club A', 'start_date': start, 'end_date': end},
      'site_ticket_tiers': {'name': 'General'},
    })!;

void main() {
  final now = DateTime(2099, 11, 1);

  test('nothing coming up is nothing', () {
    expect(nextUp(bookings: const [], orders: const [], now: now), isNull);
  });

  test('a paid table is the next night, with its venue, table and guests', () {
    final n = nextUp(bookings: [booking()], orders: const [], now: now)!;
    expect(n.kind, NextUpKind.table);
    expect(n.id, 'b1');
    expect(n.title, 'Club A');
    expect(n.detail, 'Booth 1 · 4 guests');
    expect(n.when, DateTime(2099, 11, 6, 22));
  });

  test('one guest and one ticket are singular', () {
    expect(nextUp(bookings: [booking(guests: 1)], orders: const [], now: now)!.detail, 'Booth 1 · 1 guest');
    expect(nextUp(bookings: const [], orders: [order(quantity: 1)], now: now)!.detail, '1 ticket · Club A');
  });

  test('paid tickets count, with the event and the venue', () {
    final n = nextUp(bookings: const [], orders: [order()], now: now)!;
    expect(n.kind, NextUpKind.tickets);
    expect(n.id, 'o1');
    expect(n.title, 'Friday Night');
    expect(n.detail, '2 tickets · Club A');
  });

  test('the soonest of a table and tickets is the next night', () {
    expect(nextUp(bookings: [booking(date: '2099-11-06')], orders: [order(start: DateTime.utc(2099, 11, 5, 22).toIso8601String())], now: now)!.kind, NextUpKind.tickets);
    expect(nextUp(bookings: [booking(date: '2099-11-04')], orders: [order(start: DateTime.utc(2099, 11, 5, 22).toIso8601String())], now: now)!.kind, NextUpKind.table);
  });

  test('of two tables the earlier one', () {
    expect(nextUp(bookings: [booking(id: 'late', date: '2099-11-09'), booking(id: 'soon', date: '2099-11-03')], orders: const [], now: now)!.id, 'soon');
  });

  test('a table and tickets at the same time: the table', () {
    final start = DateTime(2099, 11, 6, 22);
    expect(nextUp(bookings: [booking()], orders: [order(start: start.toUtc().toIso8601String())], now: now)!.kind, NextUpKind.table);
  });

  test('what is not paid, is over, was used, or has no start time is not a next night', () {
    expect(nextUp(bookings: [booking(status: 'pending'), booking(status: 'cancelled'), booking(date: '2099-10-01')], orders: const [], now: now), isNull);
    expect(nextUp(bookings: const [], orders: [order(status: 'pending'), order(start: '2099-10-01T22:00:00Z'), order(used: true), order(start: null)], now: now), isNull);
  });

  test('a night is still on for twelve hours after the arrival, and not after', () {
    final b = booking(date: '2099-11-06', time: '22:00:00');
    expect(nextUp(bookings: [b], orders: const [], now: DateTime(2099, 11, 7, 9, 59)), isNotNull);
    expect(nextUp(bookings: [b], orders: const [], now: DateTime(2099, 11, 7, 10)), isNull);
  });
}
