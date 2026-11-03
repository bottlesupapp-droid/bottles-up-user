import 'package:bottles_up_user/features/social/widgets/my_night_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_table_bookings'] = [];
    site.tables['site_orders'] = [];
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer());
    site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: <Object>[]);
  });

  const on = {'social': true};
  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  group('Your next night', () {
    testWidgets('shows the table coming up: the venue, when, the table and the guests', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(date: '2099-11-06', time: '22:00:00')];
      await openSocial(tester, site, '/feed', features: on);
      expect(find.byKey(const Key('my-night')), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('my-night-title'))).data, 'Club A');
      expect(tester.widget<Text>(find.byKey(const Key('my-night-detail'))).data, contains('Booth 1 · 4 guests'));
      expect(tester.widget<Text>(find.byKey(const Key('my-night-detail'))).data, contains('10:00 PM'));
    });

    testWidgets('tapping a table opens its page', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(id: 'bk9', date: '2099-11-06')];
      final router = await openSocial(tester, site, '/feed', features: on);
      await tester.tap(find.byKey(const Key('my-night')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(path(router), '/bookings/bk9');
    });

    testWidgets('tickets are the next night when they are sooner, and open the ticket', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(date: '2099-12-30')];
      site.tables['site_orders'] = [orderRow(id: 'o7', eventStart: '2099-11-05T23:00:00Z', eventEnd: '2099-11-06T05:00:00Z')];
      final router = await openSocial(tester, site, '/feed', features: on);
      expect(tester.widget<Text>(find.byKey(const Key('my-night-title'))).data, 'Friday Night');
      expect(tester.widget<Text>(find.byKey(const Key('my-night-detail'))).data, contains('2 tickets'));
      await tester.tap(find.byKey(const Key('my-night')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(path(router), '/tickets/o7');
    });

    testWidgets('nothing booked, nothing shown', (tester) async {
      await openSocial(tester, site, '/feed', features: on);
      expect(find.byKey(const Key('my-night')), findsNothing);
    });

    testWidgets('a booking that is not paid, or is over, is not the next night', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(id: 'p', status: 'pending'), bookingRow(id: 'old', date: '2020-01-01')];
      site.tables['site_orders'] = [orderRow(id: 'past', eventStart: '2020-01-01T20:00:00Z', eventEnd: '2020-01-02T02:00:00Z')];
      await openSocial(tester, site, '/feed', features: on);
      expect(find.byKey(const Key('my-night')), findsNothing);
    });

    testWidgets('the card on its own, with a clock', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(date: '2099-11-06')];
      await openSocial(tester, site, '/', features: on, home: MyNightCard(now: DateTime(2099, 11, 7, 20)));
      expect(find.byKey(const Key('my-night')), findsNothing, reason: 'by the 7th at 8 pm the 6th is over');
    });
  });
}
