import 'package:bottles_up_user/features/bookings_site/screens/my_table_bookings_screen.dart';
import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String day(String iso) => DateFormat('EEE, MMM d').format(DateTime.parse(iso));
String chip(WidgetTester tester, String id) => tester.widget<Text>(find.descendant(of: find.byKey(Key('booking-chip-$id')), matching: find.byType(Text))).data!;

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> open(WidgetTester tester, {void Function(BuildContext, TableBooking)? onOpen}) =>
      pumpSite(tester, Scaffold(body: MyTableBookingsScreen(onOpen: onOpen, now: DateTime(2099, 11, 1))), site: site);

  testWidgets('shows the venue, the table, when the guests arrive, how many and what it cost', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    await open(tester);
    expect(textOf(tester, 'booking-venue-bk1'), 'Club A');
    expect(textOf(tester, 'booking-title-bk1'), 'Booth 1');
    expect(textOf(tester, 'booking-when-bk1'), '${day('2099-11-06')} · 10:00 PM');
    expect(textOf(tester, 'booking-guests-bk1'), '4 guests · ${formatMoney(11300)}');
    expect(find.byKey(const Key('booking-chip-bk1')), findsNothing, reason: 'a booking that can still be used has no label');
    expect(find.byKey(const Key('booking-due-bk1')), findsNothing);
  });

  testWidgets('one guest is "1 guest"', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(guests: 1)];
    await open(tester);
    expect(textOf(tester, 'booking-guests-bk1'), startsWith('1 guest · '));
  });

  testWidgets('what is still to pay at the club is shown for a booking that is coming up', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(total: 36300, paid: 11300, bottles: 25000, choice: 'pay_at_club')];
    await open(tester);
    expect(textOf(tester, 'booking-due-bk1'), '${formatMoney(25000)} to pay at the club');
  });

  testWidgets('coming up first (soonest first), then past ones, then cancelled and refunded, each labelled', (tester) async {
    site.tables['site_table_bookings'] = [
      bookingRow(id: 'past', date: '2099-10-01'),
      bookingRow(id: 'later', date: '2099-12-01'),
      bookingRow(id: 'soon', date: '2099-11-06'),
      bookingRow(id: 'here', date: '2099-11-01', time: '23:00:00', checkedIn: '2099-11-01T23:30:00Z'),
      bookingRow(id: 'cancelled', status: 'cancelled', code: null, date: '2099-11-20'),
      bookingRow(id: 'refunded', status: 'refunded', date: '2099-11-21'),
    ];
    await open(tester);
    expect(chip(tester, 'past'), 'Ended');
    expect(chip(tester, 'here'), 'Checked in');
    expect(chip(tester, 'cancelled'), 'Cancelled');
    expect(chip(tester, 'refunded'), 'Refunded');
    expect(find.byKey(const Key('booking-chip-soon')), findsNothing);
    double y(String id) => tester.getTopLeft(find.byKey(Key('booking-$id'))).dy;
    expect(y('here'), lessThan(y('soon')));
    expect(y('soon'), lessThan(y('later')));
    expect(y('later'), lessThan(y('past')));
    expect(y('past'), lessThan(y('cancelled')));
    expect(find.text('Past'), findsOneWidget);
    expect(find.text('Cancelled and refunded'), findsOneWidget);
  });

  testWidgets('with only old bookings it says there are no upcoming ones, and still lists them', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(id: 'past', date: '2099-10-01')];
    await open(tester);
    expect(find.byKey(const Key('no-upcoming-bookings')), findsOneWidget);
    expect(find.byKey(const Key('booking-past')), findsOneWidget);
  });

  testWidgets('tapping a booking opens it', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    TableBooking? opened;
    await open(tester, onOpen: (c, b) => opened = b);
    await tester.tap(find.byKey(const Key('booking-bk1')));
    expect(opened?.id, 'bk1');
    expect(opened?.confirmationCode, 'TB-ABCD2345');
  });

  testWidgets('no bookings says so kindly', (tester) async {
    site.tables['site_table_bookings'] = [];
    await open(tester);
    expect(find.text('No table bookings yet'), findsOneWidget);
  });

  testWidgets('a booking the app cannot read is left out instead of breaking the list', (tester) async {
    site.tables['site_table_bookings'] = [
      {...bookingRow(id: 'bad'), 'booking_date': null},
      bookingRow(id: 'fine'),
    ];
    await open(tester);
    expect(find.byKey(const Key('booking-fine')), findsOneWidget);
    expect(find.byKey(const Key('booking-bad')), findsNothing);
  });

  testWidgets('a paid booking whose venue the website no longer shows is still listed, so the guest can always find it', (tester) async {
    site.tables['site_table_bookings'] = [{...bookingRow(id: 'gone'), 'site_venues': null}];
    await open(tester);
    expect(textOf(tester, 'booking-venue-gone'), 'Venue');
  });

  testWidgets('if the bookings cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    site.failAllWith = 500;
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load your bookings. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-bk1')), findsOneWidget);
  });
}
