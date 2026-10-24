import 'package:bottles_up_user/features/bookings_site/screens/table_booking_detail_screen.dart';
import 'package:bottles_up_user/features/tickets_site/widgets/ticket_qr.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String m(int c) => formatMoney(c);
String closedText(WidgetTester tester) => tester.widget<Text>(find.descendant(of: find.byKey(const Key('bd-closed')), matching: find.byType(Text))).data!;

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_table_booking_bottles'] = [];
    site.tables['site_table_booking_club_payments'] = [];
    site.tables['site_table_booking_refunds'] = [];
  });

  Future<void> open(WidgetTester tester, {String id = 'bk1'}) => pumpSite(tester, TableBookingDetailScreen(bookingId: id, now: DateTime(2099, 11, 1)), site: site);

  testWidgets('shows the code as a QR to show at the door, and where and when the guests arrive', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    await open(tester);
    expect(tester.widget<TicketQr>(find.byType(TicketQr)).code, 'TB-ABCD2345');
    expect(textOf(tester, 'bd-venue'), 'Club A');
    expect(textOf(tester, 'bd-table'), 'Booth 1');
    expect(textOf(tester, 'bd-when'), '${DateFormat('EEE, MMM d').format(DateTime(2099, 11, 6))} · 10:00 PM');
    expect(textOf(tester, 'bd-address'), '1 King St W, Toronto');
    expect(find.byKey(const Key('bd-show')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('bd-status')), matching: find.text('Confirmed')), findsOneWidget);
    expect(find.byKey(const Key('bd-night')), findsNothing);
  });

  testWidgets('an after-midnight booking says which night it belongs to', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(date: '2099-11-07', time: '01:00:00')];
    await open(tester);
    final night = DateFormat('EEEE').format(DateTime(2099, 11, 6));
    final arrival = DateFormat('EEEE').format(DateTime(2099, 11, 7));
    expect(textOf(tester, 'bd-night'), '$night night\'s event · arriving $arrival');
  });

  testWidgets('lists what it cost line by line: the table, tax, the total, what was paid', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(fee: 250, total: 11550, paid: 11550, discount: 0)];
    await open(tester);
    expect(textOf(tester, 'bd-guests-value'), '4');
    expect(textOf(tester, 'bd-line-table-value'), m(10000));
    expect(textOf(tester, 'bd-line-tax-value'), m(1300));
    expect(textOf(tester, 'bd-line-fee-value'), m(250));
    expect(textOf(tester, 'bd-line-total-value'), m(11550));
    expect(textOf(tester, 'bd-line-paid-value'), m(11550));
    expect(find.byKey(const Key('bd-line-due')), findsNothing);
    expect(find.byKey(const Key('bd-line-discount')), findsNothing);
  });

  testWidgets('an hourly table shows its hours', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(hours: 3, deposit: 45000, total: 50850, paid: 50850)];
    await open(tester);
    expect(textOf(tester, 'bd-hours-value'), '3');
    expect(find.text('Table (3 hr)'), findsOneWidget);
  });

  testWidgets('bottles are listed; the ones left for the club are marked, and what is still to pay at the club is shown', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(bottles: 25000, total: 36300, paid: 11300, choice: 'pay_at_club')];
    site.tables['site_table_booking_bottles'] = [bottleLineRow(payment: 'due_at_venue'), bottleLineRow(id: 'l2', name: 'Don Julio', size: null, unit: 40000, qty: 2, payment: 'paid', addon: true)];
    await open(tester);
    expect(find.text('Grey Goose (1.75L) × 1 · pay at the club'), findsOneWidget);
    expect(textOf(tester, 'bd-line-bottle-l1-value'), m(25000));
    expect(find.text('Don Julio × 2'), findsOneWidget);
    expect(textOf(tester, 'bd-line-bottle-l2-value'), m(80000));
    expect(textOf(tester, 'bd-line-due-value'), m(25000));
  });

  testWidgets('a bottle that was cancelled is shown as cancelled and not counted among the live lines', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    site.tables['site_table_booking_bottles'] = [bottleLineRow(cancelledAt: '2099-10-25T10:00:00Z')];
    await open(tester);
    expect(find.text('Grey Goose (1.75L) × 1 · cancelled'), findsOneWidget);
    expect(find.byKey(const Key('bd-line-bottle-l1')), findsNothing);
  });

  testWidgets('a promo discount is shown', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(discount: 1000, total: 10300, paid: 10300)];
    await open(tester);
    expect(textOf(tester, 'bd-line-discount-value'), '-${m(1000)}');
  });

  testWidgets('a payment the club recorded and the guest has not confirmed is pointed out', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(bottles: 25000, total: 36300, paid: 11300)];
    site.tables['site_table_booking_club_payments'] = [clubPaymentRow()];
    await open(tester);
    expect(find.byKey(const Key('bd-club-payment-cp1')), findsOneWidget);
    expect(find.textContaining('The club recorded a payment of ${m(25000)} (debit) for your bottles'), findsOneWidget);
  });

  testWidgets('a booking that was scanned says checked in', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(checkedIn: '2099-11-06T23:00:00Z')];
    await open(tester);
    expect(find.descendant(of: find.byKey(const Key('bd-status')), matching: find.text('Checked in')), findsOneWidget);
  });

  testWidgets('a booking that is over says so and greys the code', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(date: '2099-10-01')];
    await open(tester);
    expect(find.byKey(const Key('bd-ended')), findsOneWidget);
    expect(find.byKey(const Key('bd-show')), findsNothing);
    expect(tester.widget<Opacity>(find.ancestor(of: find.byType(TicketQr), matching: find.byType(Opacity)).first).opacity, lessThan(1));
  });

  testWidgets('a cancelled booking shows why and no code, and nothing is owed', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(status: 'cancelled', cancelReason: 'Venue closed that night', total: 36300, paid: 11300)];
    await open(tester);
    expect(find.byType(TicketQr), findsNothing);
    expect(closedText(tester), 'This booking was cancelled: Venue closed that night.');
    expect(find.byKey(const Key('bd-line-due')), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('bd-status')), matching: find.text('Cancelled')), findsOneWidget);
  });

  testWidgets('a refunded booking shows no code and lists what was refunded', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(status: 'refunded')];
    site.tables['site_table_booking_refunds'] = [bookingRefundRow(), bookingRefundRow(amount: 500, reason: 'Goodwill', at: '2099-10-26T10:00:00Z')];
    await open(tester);
    expect(find.byType(TicketQr), findsNothing);
    expect(closedText(tester), 'This booking was refunded, so the code cannot be used.');
    expect(find.textContaining('${m(11300)} · '), findsOneWidget);
    expect(find.textContaining('Cancelled by the guest'), findsOneWidget);
    expect(find.textContaining('${m(500)} · '), findsOneWidget);
  });

  testWidgets('a booking that is not confirmed yet shows no code', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(status: 'pending', code: null)];
    await open(tester);
    expect(find.byType(TicketQr), findsNothing);
  });

  testWidgets('a booking that is not there says so', (tester) async {
    site.tables['site_table_bookings'] = [];
    await open(tester, id: 'other');
    expect(find.text('Booking not found'), findsOneWidget);
  });

  testWidgets('if it cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    site.failAllWith = 500;
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load this booking. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-detail')), findsOneWidget);
  });
}
