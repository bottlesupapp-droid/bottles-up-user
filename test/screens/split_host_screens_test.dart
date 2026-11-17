import 'package:bottles_up_user/features/split/screens/split_bill_screen.dart';
import 'package:bottles_up_user/features/split/widgets/split_section.dart';
import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  final on = {'social': true, 'split_payments': true};

  TableBooking booking({int total = 30000, int paid = 10000, String status = 'paid'}) =>
      parseTableBooking(bookingRow(total: total, paid: paid, status: status), bottles: const [], clubPayments: const [], refunds: const [])!;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_table_bookings'] = [bookingRow(total: 30000, paid: 10000)];
    for (final t in ['site_table_booking_bottles', 'site_table_booking_club_payments', 'site_table_booking_refunds', 'site_table_booking_bottle_substitutions']) {
      site.tables[t] = [];
    }
    site.rpcs['profile_search'] = (b) => ok([
          profileRow(id: 'p-bob', handle: 'bob', name: 'Bob Ray'),
          profileRow(id: 'p-cy', handle: 'cy', name: 'Cy Rus'),
          profileRow(id: 'p-dj', kind: 'business', handle: 'djbob', name: 'DJ Bob', category: 'dj'),
          profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true),
        ]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  group('the split on a booking', () {
    Future<dynamic> section(WidgetTester tester, {TableBooking? b, bool canStart = true}) => openSocial(tester, site, '/', features: on, home: SplitSection(booking: b ?? booking(), canStart: canStart));

    testWidgets('with no split it says what is owed at the club and offers to split', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(null);
      final router = await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-explained'), contains('\$200.00 still owed at the club'));
      expect(find.byKey(const Key('split-was-cancelled')), findsNothing);
      await tap(tester, 'split-start');
      await tester.pump();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/bookings/bk1/split');
      expect(site.forRpc('split_for_booking').single.body, {'p_booking': 'bk1'});
    });

    testWidgets('it cannot be started when the night is over or nothing is left', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(null);
      await section(tester, canStart: false);
      await settleCalls(tester);
      expect(tester.widget<FilledButton>(find.byKey(const Key('split-start'))).onPressed, isNull);
      expect(find.byKey(const Key('split-cannot')), findsNothing, reason: 'the night is not over and \$200 is left: no reason to give when the booking page said no for another reason');
    });

    testWidgets('a table that is paid up says there is nothing left to split', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(null);
      await section(tester, b: booking(total: 30000, paid: 30000), canStart: false);
      await settleCalls(tester);
      expect(textOf(tester, 'split-cannot'), 'There is nothing left to split: the rest is paid.');
      expect(textOf(tester, 'split-explained'), 'Nothing is left to pay at the club.');
    });

    testWidgets('an open split shows who was asked, what they owe and how they stand', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(collected: 5000, outstanding: 5000, balance: 15000, shares: [
            shareLineRow(id: 'a', status: 'paid', paidAt: '2099-11-02T10:00:00Z'),
            shareLineRow(id: 'b', payer: profileRow(id: 'p-cy', handle: 'cy', name: 'Cy Rus')),
          ]));
      await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-title'), 'Waiting for your friends');
      expect(textOf(tester, 'split-summary'), 'Friends have paid \$50.00 of the \$100.00 you asked for.');
      expect(textOf(tester, 'split-balance'), 'Still to pay at the club: \$150.00');
      expect(find.descendant(of: find.byKey(const Key('split-share-state-a')), matching: find.text('Paid')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('split-share-state-b')), matching: find.text('Waiting for payment')), findsOneWidget);
      expect(textOf(tester, 'split-share-a'), 'Bob Ray');
      expect(textOf(tester, 'split-share-b'), 'Cy Rus');
      expect(find.byKey(const Key('split-start')), findsNothing, reason: 'one split at a time');
    });

    testWidgets('a split everyone has paid says so', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(state: 'complete'));
      await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-title'), 'Everyone has paid');
      expect(textOf(tester, 'split-deadline'), startsWith('The deadline was'));
    });

    testWidgets('a split whose time ran out says so', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(state: 'expired'));
      await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-title'), 'The time to pay has passed');
      expect(textOf(tester, 'split-deadline'), startsWith('The deadline was'));
    });

    testWidgets('an open one says until when they can pay', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow());
      await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-deadline'), startsWith('They can pay until'));
    });

    testWidgets('a cancelled split offers a new one and remembers the last was cancelled', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(state: 'cancelled'));
      await section(tester);
      await settleCalls(tester);
      expect(find.byKey(const Key('split-was-cancelled')), findsOneWidget);
      expect(find.byKey(const Key('split-start')), findsOneWidget);
      expect(find.byKey(const Key('split-cancel')), findsNothing);
    });

    testWidgets('cancelling asks first, says who is paid back, calls the website and reloads', (tester) async {
      var plan = splitPlanRow(collected: 5000, shares: [shareLineRow(id: 'a', status: 'paid')]);
      site.rpcs['split_for_booking'] = (_) => ok(plan);
      site.functions['cancel-split'] = (b) {
        plan = splitPlanRow(state: 'cancelled');
        return (status: 200, body: {'split': plan, 'refunded': 1, 'failed': 0});
      };
      await section(tester);
      await settleCalls(tester);
      await tap(tester, 'split-cancel');
      await tester.pumpAndSettle();
      expect(find.textContaining('paid back in full'), findsOneWidget);
      expect(find.textContaining('\$50.00'), findsWidgets);
      await tap(tester, 'split-keep');
      await tester.pumpAndSettle();
      expect(site.forFunction('cancel-split'), isEmpty);
      await tap(tester, 'split-cancel');
      await tester.pumpAndSettle();
      await tap(tester, 'split-cancel-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forFunction('cancel-split').single.body, {'split_id': 'sp1'});
      expect(find.text('Split cancelled. Your friends have been paid back.'), findsOneWidget);
      expect(site.forRpc('split_for_booking').length, greaterThanOrEqualTo(2));
      expect(find.byKey(const Key('split-was-cancelled')), findsOneWidget);
    });

    testWidgets('with nobody paid, it says nobody has paid and does not promise a refund', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow());
      site.functions['cancel-split'] = (b) => (status: 200, body: {'split': splitPlanRow(state: 'cancelled'), 'refunded': 0, 'failed': 0});
      await section(tester);
      await settleCalls(tester);
      await tap(tester, 'split-cancel');
      await tester.pumpAndSettle();
      expect(find.textContaining('Nobody has paid yet'), findsOneWidget);
      await tap(tester, 'split-cancel-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.text('Split cancelled.'), findsOneWidget);
    });

    testWidgets('refunds that are still on their way are said as such', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(collected: 5000));
      site.functions['cancel-split'] = (b) => (status: 200, body: {'split': splitPlanRow(state: 'cancelled'), 'refunded': 0, 'failed': 1});
      await section(tester);
      await settleCalls(tester);
      await tap(tester, 'split-cancel');
      await tester.pumpAndSettle();
      await tap(tester, 'split-cancel-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.textContaining('Some refunds are on their way'), findsOneWidget);
    });

    testWidgets('a refusal to cancel is shown as the website said it', (tester) async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow());
      site.functions['cancel-split'] = (b) => (status: 409, body: {'error': 'This booking is over, so the split can no longer be cancelled here. Ask the venue.'});
      await section(tester);
      await settleCalls(tester);
      await tap(tester, 'split-cancel');
      await tester.pumpAndSettle();
      await tap(tester, 'split-cancel-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.text('This booking is over, so the split can no longer be cancelled here. Ask the venue.'), findsOneWidget);
      expect(find.byKey(const Key('split-cancel')), findsOneWidget);
    });

    testWidgets('a split that cannot be loaded says so and can be tried again', (tester) async {
      var up = false;
      site.rpcs['split_for_booking'] = (_) => up ? ok(null) : (status: 500, body: {'message': 'x'});
      await section(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-error'), contains('the split'));
      up = true;
      await tap(tester, 'split-retry');
      await settleCalls(tester);
      expect(find.byKey(const Key('split-start')), findsOneWidget);
    });
  });

  group('splitting the bill', () {
    final now = DateTime(2099, 11, 3, 12);

    Future<void> open(WidgetTester tester) async {
      await openSocial(tester, site, '/', features: on, fullPage: SplitBillScreen(bookingId: 'bk1', now: now));
      await settleCalls(tester);
      await settleCalls(tester);
    }

    Future<void> search(WidgetTester tester, String q) async {
      await tester.enterText(find.byKey(const Key('split-person-search')), q);
      await tester.pump(const Duration(milliseconds: 400));
      await settleCalls(tester);
    }

    testWidgets('shows what is owed, asks for at least two letters, and lists only people (not businesses, not yourself)', (tester) async {
      await open(tester);
      expect(textOf(tester, 'split-form-balance'), 'Still owed at the club: \$200.00');
      expect(find.text('Type at least 2 letters.'), findsOneWidget);
      await search(tester, 'bo');
      expect(find.byKey(const Key('split-pick-bob')), findsOneWidget);
      expect(find.byKey(const Key('split-pick-cy')), findsOneWidget);
      expect(find.byKey(const Key('split-pick-djbob')), findsNothing);
      expect(find.byKey(const Key('split-pick-dana')), findsNothing);
      expect(site.forRpc('profile_search').single.body['p_query'], 'bo');
    });

    testWidgets('a search with no people says so', (tester) async {
      site.rpcs['profile_search'] = (b) => ok(<Object>[]);
      await open(tester);
      await search(tester, 'zz');
      expect(find.byKey(const Key('split-no-people')), findsOneWidget);
    });

    testWidgets('choosing friends splits what is owed equally between them and the host, who keeps the rest', (tester) async {
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-pick-cy');
      expect(textOf(tester, 'split-amount-bob'), '\$66.66');
      expect(textOf(tester, 'split-amount-cy'), '\$66.66');
      expect(textOf(tester, 'split-mine'), 'You still pay \$66.68 at the club.');
      await tap(tester, 'split-remove-cy');
      expect(textOf(tester, 'split-amount-bob'), '\$100.00');
      expect(textOf(tester, 'split-mine'), 'You still pay \$100.00 at the club.');
      expect(find.byKey(const Key('split-chosen-cy')), findsNothing);
    });

    testWidgets('own amounts: each friend has a box, the total and what is left are kept up to date', (tester) async {
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-pick-cy');
      await tap(tester, 'split-mode');
      await tester.tap(find.text('My own amounts'));
      await tester.pump();
      await tester.enterText(find.byKey(const Key('split-amount-input-bob')), '40');
      await tester.enterText(find.byKey(const Key('split-amount-input-cy')), '35.50');
      await tester.pump();
      expect(textOf(tester, 'split-mine'), 'You still pay \$124.50 at the club.');
    });

    testWidgets('sending: needs friends, amounts, and a deadline, each said in words', (tester) async {
      await open(tester);
      await tap(tester, 'split-send');
      expect(textOf(tester, 'split-problem'), 'Choose at least one friend.');
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-send');
      expect(textOf(tester, 'split-problem'), 'Choose when they have to pay by.');
      await tester.tap(find.text('My own amounts'));
      await tester.pump();
      await tap(tester, 'split-deadline-In 24 hours');
      await tap(tester, 'split-send');
      expect(textOf(tester, 'split-problem'), 'Type an amount for every friend, like 25 or 25.50.');
      await tester.enterText(find.byKey(const Key('split-amount-input-bob')), '4');
      await tester.pump();
      await tap(tester, 'split-send');
      expect(textOf(tester, 'split-problem'), 'The smallest share is \$5.00.');
      await tester.enterText(find.byKey(const Key('split-amount-input-bob')), '250');
      await tester.pump();
      await tap(tester, 'split-send');
      expect(textOf(tester, 'split-problem'), 'The shares add up to more than what is left to pay (\$200.00).');
      expect(site.forRpc('split_create'), isEmpty, reason: 'nothing was sent while the form was wrong');
    });

    testWidgets('sending asks the website for exactly what was chosen, and tells the host', (tester) async {
      site.rpcs['split_create'] = (b) => ok(splitPlanRow());
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-pick-cy');
      await tap(tester, 'split-deadline-In 24 hours');
      await tap(tester, 'split-send');
      await settleCalls(tester);
      await settleCalls(tester);
      final body = site.forRpc('split_create').single.body;
      expect(body['p_booking'], 'bk1');
      expect(body['p_shares'], [
        {'payer': 'p-bob', 'amount_cents': 6666},
        {'payer': 'p-cy', 'amount_cents': 6666},
      ]);
      expect(DateTime.parse(body['p_deadline'] as String), now.add(const Duration(hours: 24)).toUtc());
      expect(find.text('Your requests were sent to 2 friends.'), findsOneWidget);
    });

    testWidgets('one friend is said by name', (tester) async {
      site.rpcs['split_create'] = (b) => ok(splitPlanRow());
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-deadline-In 2 hours');
      await tap(tester, 'split-send');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.text('Your request was sent to Bob Ray.'), findsOneWidget);
    });

    testWidgets('a refusal from the website is shown and nothing else changes', (tester) async {
      site.rpcs['split_create'] = (b) => raised('One of the people you chose is not available.');
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-deadline-In 2 hours');
      await tap(tester, 'split-send');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'split-problem'), 'One of the people you chose is not available.');
      expect(find.byKey(const Key('split-chosen-bob')), findsOneWidget);
    });

    testWidgets('a double tap sends once', (tester) async {
      site.rpcs['split_create'] = (b) => ok(splitPlanRow());
      await open(tester);
      await search(tester, 'bo');
      await tap(tester, 'split-pick-bob');
      await tap(tester, 'split-deadline-In 2 hours');
      await tester.ensureVisible(find.byKey(const Key('split-send')));
      await tester.tap(find.byKey(const Key('split-send')));
      await tester.tap(find.byKey(const Key('split-send')));
      await tester.pump();
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forRpc('split_create').length, 1);
    });

    testWidgets('up to twenty friends can be chosen, and the twenty-first is said no to', (tester) async {
      site.rpcs['profile_search'] = (b) => ok([for (var i = 0; i < 21; i++) profileRow(id: 'p$i', handle: 'user$i', name: 'User $i')]);
      tester.view.physicalSize = const Size(800, 9000);
      await open(tester);
      await search(tester, 'us');
      for (var i = 0; i < 21; i++) {
        await tap(tester, 'split-pick-user$i');
      }
      expect(find.byKey(const Key('split-chosen-user19')), findsOneWidget);
      expect(find.byKey(const Key('split-chosen-user20')), findsNothing);
      expect(textOf(tester, 'split-problem'), 'A split can have up to 20 friends.');
    });

    testWidgets('a booking that has ended, or is paid up, or is not confirmed, cannot be split', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(date: '2020-01-01', total: 30000, paid: 10000)];
      await open(tester);
      expect(find.text('Nothing to split'), findsOneWidget);
      expect(find.text('This booking has ended.'), findsOneWidget);
    });

    testWidgets('paid up', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(total: 20000, paid: 20000)];
      await open(tester);
      expect(find.text('The rest of this table is paid.'), findsOneWidget);
    });

    testWidgets('not confirmed', (tester) async {
      site.tables['site_table_bookings'] = [bookingRow(status: 'pending', paid: 0)];
      await open(tester);
      expect(find.text('This booking cannot be split'), findsOneWidget);
    });

    testWidgets('with social off the screen says it is not open', (tester) async {
      await openSocial(tester, site, '/', features: const {'split_payments': true}, fullPage: SplitBillScreen(bookingId: 'bk1', now: now));
      await settleCalls(tester);
      expect(find.text('Coming soon'), findsOneWidget);
    });
  });
}
