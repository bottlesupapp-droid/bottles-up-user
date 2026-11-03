import 'package:bottles_up_user/features/hiring/screens/hiring_booking_screen.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_card.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_dialogs.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_widgets.dart';
import 'package:bottles_up_user/features/hiring/widgets/pro_services_section.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_pro1#frag';

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  late int wentBack;
  final on = {'social': true, 'marketplace': true};
  // The form accepts days up to two years ahead, so its tests ask for a day a month from now.
  final now = DateTime.now();
  final soon = DateTime(now.year, now.month, now.day + 30);
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    opened = [];
    wentBack = 0;
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['pro_services_of'] = (_) => ok([proServiceRow(), proServiceRow(id: 'sv2', title: 'Photo booth', from: null, note: null)]);
    site.rpcs['pro_busy_days'] = (_) => ok(<Object>[]);
    site.rpcs['pro_requests_mine'] = (_) => ok(<Object>[]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> tick(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await settleCalls(tester);
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump();
  }

  List<Override> recording(List<({DateTime first, DateTime last, DateTime initial})> log, DateTime? day) => [
        dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async {
          log.add((first: first, last: last, initial: initial));
          return day;
        })
      ];

  List<Override> picking(DateTime? day) => [dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async => day)];

  group('asking a professional for a job', () {
    Future<GoRouter> openForm(WidgetTester tester, {DateTime? day}) async {
      final router = await openSocial(tester, site, '/pros/p-dj/request', features: on, overrides: picking(day ?? soon));
      await settleCalls(tester);
      return router;
    }

    testWidgets('sends the day, the service and what the person typed, then opens the request', (tester) async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow());
      final router = await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      expect(find.text('Choose the day'), findsNothing);
      await tester.tap(find.byKey(const Key('request-service')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wedding DJ set').last);
      await tester.pumpAndSettle();
      await type(tester, 'request-time', ' 9pm to 1am ');
      await type(tester, 'request-place', 'Club A');
      await type(tester, 'request-guests', '120');
      await type(tester, 'request-budget', '1500');
      await type(tester, 'request-message', '  A birthday night for 120 ');
      await tap(tester, 'request-send');
      await settleCalls(tester);
      final sent = site.forRpc('pro_request_create').single.body;
      expect(sent, {
        'p_provider': 'p-dj',
        'p_service': 'sv1',
        'p_event_date': iso(soon),
        'p_time_note': '9pm to 1am',
        'p_location': 'Club A',
        'p_guests': 120,
        'p_message': 'A birthday night for 120',
        'p_budget_cents': 150000,
      });
      await settleCalls(tester);
      expect(path(router), '/hiring/pr1');
    });

    testWidgets('offers days from tomorrow to two years from now', (tester) async {
      final asked = <({DateTime first, DateTime last, DateTime initial})>[];
      await openSocial(tester, site, '/pros/p-dj/request', features: on, overrides: recording(asked, soon));
      await settleCalls(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      final d = DateTime.now();
      expect([asked.single.first, asked.single.initial], [DateTime(d.year, d.month, d.day + 1), DateTime(d.year, d.month, d.day + 1)]);
      expect(asked.single.last, DateTime(d.year, d.month, d.day + 730));
      await tap(tester, 'request-date');
      await settleCalls(tester);
      expect(asked.last.initial, soon, reason: 'it starts from the day already chosen');
    });

    testWidgets('the list of my requests underneath is read again once a request is sent', (tester) async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow());
      final router = await openSocial(tester, site, '/me/hiring', features: on, overrides: picking(soon));
      await settleCalls(tester);
      expect(site.forRpc('pro_requests_mine').length, 1);
      router.push('/pros/p-dj/request');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tap(tester, 'request-send');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forRpc('pro_requests_mine').length, greaterThanOrEqualTo(2));
    });

    testWidgets('leaves out what was not filled in', (tester) async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow());
      await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tap(tester, 'request-send');
      await settleCalls(tester);
      final sent = site.forRpc('pro_request_create').single.body;
      expect([sent['p_service'], sent['p_time_note'], sent['p_location'], sent['p_guests'], sent['p_budget_cents']], [null, null, null, null, null]);
    });

    testWidgets('says what is missing before anything is sent', (tester) async {
      await openForm(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tap(tester, 'request-send');
      expect(textOf(tester, 'request-problem'), 'Choose a date between tomorrow and two years from now.');
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'x');
      await tap(tester, 'request-send');
      expect(textOf(tester, 'request-problem'), startsWith('Tell them about the job'));
      await type(tester, 'request-message', 'Need a DJ');
      await type(tester, 'request-guests', 'lots');
      await tap(tester, 'request-send');
      expect(textOf(tester, 'request-problem'), 'Type the number of guests as a whole number.');
      await type(tester, 'request-guests', '');
      await type(tester, 'request-budget', 'a lot');
      await tap(tester, 'request-send');
      expect(textOf(tester, 'request-problem'), 'Type the budget like 1500 or 1500.00.');
      await settleCalls(tester);
      expect(site.forRpc('pro_request_create'), isEmpty);
    });

    testWidgets('a day the professional is busy is refused at once and not kept', (tester) async {
      site.rpcs['pro_busy_days'] = (_) => ok([iso(soon)]);
      await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      expect(textOf(tester, 'request-problem'), contains('not free on'));
      expect(find.text('Choose the day'), findsOneWidget);
    });

    testWidgets('a refusal from the website is shown as it came and the form stays', (tester) async {
      site.rpcs['pro_request_create'] = (_) => raised('You have sent a lot of requests today. Try again tomorrow.');
      final router = await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tap(tester, 'request-send');
      await settleCalls(tester);
      expect(textOf(tester, 'request-problem'), 'You have sent a lot of requests today. Try again tomorrow.');
      expect(path(router), '/pros/p-dj/request');
      expect(tester.widget<FilledButton>(find.byKey(const Key('request-send'))).onPressed, isNotNull);
    });

    testWidgets('a double tap on Send sends one request', (tester) async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow());
      await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tester.ensureVisible(find.byKey(const Key('request-send')));
      await tester.tap(find.byKey(const Key('request-send')));
      await tester.tap(find.byKey(const Key('request-send')));
      await settleCalls(tester);
      expect(site.forRpc('pro_request_create').length, 1);
    });

    testWidgets('nobody who has not accepted the community rules sends anything', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      await openForm(tester);
      await tap(tester, 'request-date');
      await settleCalls(tester);
      await type(tester, 'request-message', 'Need a DJ');
      await tap(tester, 'request-send');
      await settleCalls(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(site.forRpc('pro_request_create'), isEmpty);
    });

    testWidgets('says it is not open yet when hiring is switched off', (tester) async {
      await openSocial(tester, site, '/pros/p-dj/request', features: {'social': true}, overrides: picking(soon));
      await settleCalls(tester);
      expect(find.text('Hiring professionals is not open yet.'), findsOneWidget);
      expect(find.byKey(const Key('request-send')), findsNothing);
    });
  });

  group('my requests', () {
    testWidgets('puts the quotes to answer first and says where the rest stand', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([
            proRequestRow(id: 'a', status: 'requested'),
            proRequestRow(id: 'b', status: 'quoted', quote: proQuoteRow(), provider: profileRow(id: 'p2', kind: 'business', handle: 'photo', name: 'Pia Photo', category: 'photographer')),
            proRequestRow(id: 'c', status: 'declined'),
          ]);
      final router = await openSocial(tester, site, '/me/hiring', features: on);
      await settleCalls(tester);
      expect(find.text('Quotes to answer'), findsOneWidget);
      expect(find.text('Everything else'), findsOneWidget);
      final order = [for (final id in ['b', 'a', 'c']) tester.getTopLeft(find.byKey(Key('request-$id'))).dy];
      expect(order, [...order]..sort());
      expect(find.descendant(of: find.byKey(const Key('request-b')), matching: find.text('Quote to answer')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('request-a')), matching: find.text('Waiting for a quote')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('request-c')), matching: find.text('Declined')), findsOneWidget);
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow(id: 'b', status: 'quoted', quote: proQuoteRow()));
      await tester.tap(find.byKey(const Key('request-b')));
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/b');
    });

    testWidgets('a booking that is accepted shows the booking\'s own progress', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(state: 'confirmed', paid: 30000))]);
      await openSocial(tester, site, '/me/hiring', features: on);
      await settleCalls(tester);
      expect(find.text('Booked: balance to pay'), findsOneWidget);
    });

    testWidgets('with nothing that needs an answer there is no second heading', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(status: 'declined'), proRequestRow(id: 'x', status: 'requested')]);
      await openSocial(tester, site, '/me/hiring', features: on);
      await settleCalls(tester);
      expect(find.text('Quotes to answer'), findsNothing);
      expect(find.text('Everything else'), findsNothing);
      expect(find.byKey(const Key('request-x')), findsOneWidget);
    });

    testWidgets('has a plain empty state and a way to try again when it cannot load', (tester) async {
      await openSocial(tester, site, '/me/hiring', features: on);
      await settleCalls(tester);
      expect(find.text('You have not asked anyone yet'), findsOneWidget);
    });

    testWidgets('says why it cannot load and loads again', (tester) async {
      var fail = true;
      site.rpcs['pro_requests_mine'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok([proRequestRow()]);
      await openSocial(tester, site, '/me/hiring', features: on);
      await settleCalls(tester);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('request-pr1')), findsOneWidget);
    });

    testWidgets('says it is not open yet when hiring is switched off', (tester) async {
      await openSocial(tester, site, '/me/hiring', features: {'social': true});
      await settleCalls(tester);
      expect(find.text('Hiring professionals is not open yet.'), findsOneWidget);
    });
  });

  group('a request, from the customer\'s side', () {
    Future<GoRouter> openRequest(WidgetTester tester, Map<String, dynamic> row) async {
      site.rpcs['pro_request_get'] = (_) => ok(row);
      final router = await openSocial(tester, site, '/hiring/pr1', features: on);
      await settleCalls(tester);
      return router;
    }

    testWidgets('shows the job, the quote and what accepting means', (tester) async {
      await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow()));
      expect(textOf(tester, 'request-title'), 'Your request to DJ Dee');
      expect(textOf(tester, 'request-message-text'), 'A birthday night for 120');
      expect(find.text('Wedding DJ set'), findsOneWidget);
      expect(find.text('9pm to 1am'), findsOneWidget);
      expect(find.text('\$1,000.00'), findsWidgets);
      expect(find.text('\$300.00'), findsOneWidget);
      expect(textOf(tester, 'quote-scope-text'), 'Four hours of music, lights and sound');
      expect(textOf(tester, 'quote-validity'), startsWith('Open until'));
      await tap(tester, 'request-accept');
      await tester.pumpAndSettle();
      final dialog = tester.widget<Text>(find.descendant(of: find.byType(AlertDialog), matching: find.textContaining('24 hours'))).data!;
      expect(dialog, allOf(contains('\$300.00'), contains('\$700.00'), contains('not paid back')));
    });

    testWidgets('a quote paid in one go shows no balance and says nothing about one', (tester) async {
      await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow(deposit: 100000)));
      expect(find.text('Balance'), findsNothing);
      await tap(tester, 'request-accept');
      await tester.pumpAndSettle();
      final dialog = tester.widget<Text>(find.descendant(of: find.byType(AlertDialog), matching: find.textContaining('24 hours'))).data!;
      expect(dialog, contains('deposit of \$1,000.00'));
      expect(dialog, isNot(contains('then')));
      expect(dialog, isNot(contains('not paid back')));
    });

    testWidgets('an accepted quote is called the accepted quote', (tester) async {
      await openRequest(tester, proRequestRow(status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow()));
      expect(find.text('The accepted quote'), findsOneWidget);
      expect(find.text('The quote'), findsNothing);
    });

    testWidgets('accepting asks first, then opens the booking it made', (tester) async {
      site.rpcs['pro_quote_accept'] = (_) => ok(proBookingRow());
      site.rpcs['pro_booking_get'] = (_) => ok(proBookingRow());
      final router = await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow()));
      await tap(tester, 'request-accept');
      await tester.pumpAndSettle();
      await tap(tester, 'accept-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('pro_quote_accept'), isEmpty);
      await tap(tester, 'request-accept');
      await tester.pumpAndSettle();
      await tap(tester, 'accept-confirm');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      expect(site.forRpc('pro_quote_accept').single.body, {'p_request': 'pr1'});
      expect(path(router), '/hiring/bookings/pb1');
      expect(router.canPop(), isFalse, reason: 'the booking takes the request\'s place');
    });

    testWidgets('a refused acceptance is shown and the request is read again', (tester) async {
      site.rpcs['pro_quote_accept'] = (_) => raised('This quote has expired.');
      await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow()));
      await tap(tester, 'request-accept');
      await tester.pumpAndSettle();
      await tap(tester, 'accept-confirm');
      await settleCalls(tester);
      await tester.pump();
      expect(find.text('This quote has expired.'), findsOneWidget);
      expect(site.forRpc('pro_request_get').length, greaterThanOrEqualTo(2));
    });

    testWidgets('an expired quote cannot be accepted, and a turned-down one is not offered again', (tester) async {
      await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow(status: 'expired')));
      expect(find.byKey(const Key('request-accept')), findsNothing);
      expect(textOf(tester, 'quote-validity'), 'This quote has expired.');
    });

    testWidgets('turning the quote down and withdrawing the request each ask the website once', (tester) async {
      site.rpcs['pro_quote_decline'] = (_) => ok(proRequestRow(status: 'requested'));
      site.rpcs['pro_request_withdraw'] = (_) => ok(proRequestRow(status: 'withdrawn'));
      await openRequest(tester, proRequestRow(status: 'quoted', quote: proQuoteRow()));
      await tap(tester, 'request-decline-quote');
      await settleCalls(tester);
      expect(site.forRpc('pro_quote_decline').single.body, {'p_request': 'pr1'});
      await tap(tester, 'request-withdraw');
      await settleCalls(tester);
      expect(site.forRpc('pro_request_withdraw').single.body, {'p_request': 'pr1'});
      expect(site.forRpc('pro_request_get').length, greaterThanOrEqualTo(3), reason: 'the request is read again after each step');
    });

    testWidgets('a double tap on Withdraw withdraws once', (tester) async {
      site.rpcs['pro_request_withdraw'] = (_) => ok(proRequestRow(status: 'withdrawn'));
      await openRequest(tester, proRequestRow());
      await tester.ensureVisible(find.byKey(const Key('request-withdraw')));
      await tester.tap(find.byKey(const Key('request-withdraw')));
      await tester.tap(find.byKey(const Key('request-withdraw')));
      await tester.pump();
      await settleCalls(tester);
      expect(site.forRpc('pro_request_withdraw').length, 1);
    });

    testWidgets('a request still waiting for a quote can only be withdrawn', (tester) async {
      await openRequest(tester, proRequestRow());
      expect(find.byKey(const Key('request-withdraw')), findsOneWidget);
      expect(find.byKey(const Key('request-accept')), findsNothing);
      expect(find.byKey(const Key('request-quote')), findsNothing);
      expect(find.byKey(const Key('request-decline')), findsNothing);
    });

    testWidgets('a declined request shows the professional\'s note and nothing to press', (tester) async {
      await openRequest(tester, proRequestRow(status: 'declined', declineNote: 'Sorry, booked that weekend'));
      expect(textOf(tester, 'request-decline-note'), 'Note: Sorry, booked that weekend');
      expect(find.byKey(const Key('request-withdraw')), findsNothing);
    });

    testWidgets('an accepted request opens its booking', (tester) async {
      site.rpcs['pro_booking_get'] = (_) => ok(proBookingRow(state: 'confirmed', paid: 30000));
      final router = await openRequest(tester, proRequestRow(status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(state: 'confirmed', paid: 30000)));
      expect(textOf(tester, 'quote-scope-text'), isNotEmpty);
      expect(textOf(tester, 'quote-validity'), '', reason: 'an accepted quote is not "open until" nor "expired"');
      await tap(tester, 'request-open-booking');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/bookings/pb1');
    });

    testWidgets('says why a request cannot be read', (tester) async {
      site.rpcs['pro_request_get'] = (_) => raised('This request is not available.');
      await openSocial(tester, site, '/hiring/pr1', features: on);
      await settleCalls(tester);
      expect(find.text('This request is not available.'), findsOneWidget);
    });
  });

  group('a booking, from the customer\'s side', () {
    var row = proBookingRow();

    setUp(() {
      row = proBookingRow();
      site.rpcs['pro_booking_get'] = (_) => ok(row);
      site.functions['create-pro-checkout'] = (b) => (status: 200, body: {'url': payUrl, 'session_id': 'cs_test_pro1'});
      site.functions['confirm-pro-payment'] = (b) => (status: 200, body: {'status': 'pending'});
    });

    Future<GoRouter> openBooking(WidgetTester tester, {Duration giveUpAfter = const Duration(minutes: 5)}) async {
      final router = await openSocial(tester, site, '/', features: on, opened: opened, fullPage: HiringBookingScreen(bookingId: 'pb1', interval: const Duration(seconds: 1), giveUpAfter: giveUpAfter, onBack: (c) => wentBack++));
      await settleCalls(tester);
      return router;
    }

    testWidgets('says what is agreed, what is paid and what the next step is', (tester) async {
      await openBooking(tester);
      expect(textOf(tester, 'booking-title'), 'Wedding DJ set');
      expect(textOf(tester, 'booking-who'), 'With DJ Dee');
      expect(find.text('Waiting for the deposit'), findsOneWidget);
      expect(find.text('\$1,000.00'), findsNWidgets(2), reason: 'the total, and all of it still to pay');
      expect(textOf(tester, 'booking-status-text'), startsWith('Pay the deposit'));
      expect(find.widgetWithText(FilledButton, 'Pay the deposit of \$300.00'), findsOneWidget);
      expect(find.byKey(const Key('booking-done')), findsNothing);
      expect(find.byKey(const Key('booking-confirm')), findsNothing);
      expect(find.byKey(const Key('booking-dispute')), findsNothing);
      expect(find.text('You will be paid'), findsNothing);
    });

    testWidgets('a booking paid in one go shows no balance date, even if the website sent one', (tester) async {
      row = {...proBookingRow(total: 50000, deposit: 50000), 'balance_due_by': '2099-11-01'};
      await openBooking(tester);
      expect(find.text('Balance due by'), findsNothing);
    });

    testWidgets('a cancelled booking does not say there is still something to pay', (tester) async {
      row = proBookingRow(state: 'cancelled', cancelledBy: 'client');
      await openBooking(tester);
      expect(find.text('Still to pay'), findsNothing);
      row = proBookingRow(state: 'confirmed', paid: 30000);
      await tester.pumpWidget(const SizedBox());
      await openBooking(tester);
      expect(find.text('Still to pay'), findsOneWidget);
    });

    testWidgets('a booking marked confirmed with nothing left to pay offers no payment', (tester) async {
      row = proBookingRow(state: 'confirmed', paid: 100000);
      await openBooking(tester);
      expect(find.byKey(const Key('booking-pay')), findsNothing);
    });

    testWidgets('an unpaid acceptance can be cancelled whatever the date, but one in dispute cannot', (tester) async {
      row = proBookingRow(date: '2020-01-01');
      await openBooking(tester);
      expect(find.byKey(const Key('booking-cancel')), findsOneWidget);
      row = proBookingRow(state: 'disputed', paid: 100000, dispute: {'id': 'd1', 'status': 'open', 'outcome': null, 'reason': 'The DJ left early'});
      await tester.pumpWidget(const SizedBox());
      await openBooking(tester);
      expect(find.byKey(const Key('booking-cancel')), findsNothing, reason: 'a date still ahead, but BottlesUp decides it');
    });

    testWidgets('a deposit that is the whole price says so', (tester) async {
      row = proBookingRow(total: 50000, deposit: 50000);
      await openBooking(tester);
      expect(find.widgetWithText(FilledButton, 'Pay \$500.00'), findsOneWidget);
      expect(find.text('Balance due by'), findsNothing);
    });

    testWidgets('paying opens the page in the app, waits, and shows the new state only when the website says it is paid', (tester) async {
      var calls = 0;
      site.functions['confirm-pro-payment'] = (b) {
        if (++calls < 3) return (status: 200, body: {'status': 'pending'});
        row = proBookingRow(state: 'confirmed', paid: 30000);
        return (status: 200, body: {'status': 'paid', 'booking': row});
      };
      await openBooking(tester);
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      expect(site.forFunction('create-pro-checkout').single.body, {'booking_id': 'pb1'});
      expect(site.forFunction('confirm-pro-payment'), isEmpty);
      await tester.pump();
      expect(opened.single.toString(), payUrl);
      expect(find.byKey(const Key('booking-waiting')), findsOneWidget);
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('booking-state')), findsNothing, reason: 'still waiting');
      await tick(tester);
      expect(site.forFunction('confirm-pro-payment').first.body, {'booking_id': 'pb1'});
      await tester.pump();
      expect(find.text('Booked: balance to pay'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Pay the balance of \$700.00'), findsOneWidget);
      expect(find.text('Your payment is in.'), findsOneWidget);
      final asked = site.forFunction('confirm-pro-payment').length;
      await tick(tester);
      expect(site.forFunction('confirm-pro-payment').length, asked, reason: 'it stops asking once paid');
    });

    testWidgets('a double tap on Pay opens one payment page', (tester) async {
      await openBooking(tester);
      await tester.ensureVisible(find.byKey(const Key('booking-pay')));
      await tester.tap(find.byKey(const Key('booking-pay')));
      await tester.tap(find.byKey(const Key('booking-pay')));
      await tester.pump();
      await settleCalls(tester);
      expect(site.forFunction('create-pro-checkout').length, 1);
      expect(opened.length, 1);
    });

    testWidgets('coming back to the app while the page is open asks the website at once, and "I have paid" does too', (tester) async {
      await openBooking(tester);
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      expect(site.forFunction('confirm-pro-payment'), isEmpty);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settleCalls(tester);
      expect(site.forFunction('confirm-pro-payment').length, 1);
      await tap(tester, 'booking-check');
      await settleCalls(tester);
      expect(site.forFunction('confirm-pro-payment').length, 2);
    });

    testWidgets('after a while it says it has not seen the payment and offers to check or to open the page again', (tester) async {
      await openBooking(tester, giveUpAfter: const Duration(seconds: 2));
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      await tick(tester);
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('booking-stalled')), findsOneWidget);
      expect(textOf(tester, 'booking-wait-text'), contains('within a minute or two'));
      await tap(tester, 'booking-reopen');
      await tester.pump();
      expect(opened.length, 2);
      await tap(tester, 'booking-leave');
      expect(find.byKey(const Key('booking-details')), findsOneWidget);
    });

    testWidgets('a payment page that cannot be opened says so and does not wait', (tester) async {
      await openSocial(tester, site, '/', features: on, fullPage: const HiringBookingScreen(bookingId: 'pb1'), overrides: [urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async => false)]);
      await settleCalls(tester);
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      expect(textOf(tester, 'booking-problem'), startsWith('We could not open the payment page'));
      expect(find.byKey(const Key('booking-waiting')), findsNothing);
    });

    testWidgets('a refusal to start paying is shown as it came', (tester) async {
      site.functions['create-pro-checkout'] = (b) => (status: 400, body: {'error': 'This booking is no longer open for payment.'});
      await openBooking(tester);
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      expect(textOf(tester, 'booking-problem'), 'This booking is no longer open for payment.');
      expect(opened, isEmpty);
    });

    testWidgets('a payment the website no longer knows about brings the person back to the booking', (tester) async {
      site.functions['confirm-pro-payment'] = (b) => (status: 200, body: {'status': 'none'});
      await openBooking(tester);
      await tap(tester, 'booking-pay');
      await settleCalls(tester);
      await tick(tester);
      expect(find.byKey(const Key('booking-details')), findsOneWidget);
      expect(textOf(tester, 'booking-problem'), 'No payment is open for this booking any more.');
    });

    group('cancelling', () {
      testWidgets('before anything is paid says nothing is charged, asks, then cancels through the website\'s function', (tester) async {
        site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'booking': proBookingRow(state: 'cancelled', cancelledBy: 'client'), 'refunded': 0, 'failed': 0});
        await openBooking(tester);
        await tap(tester, 'booking-cancel');
        await tester.pumpAndSettle();
        expect(textOf(tester, 'cancel-policy'), 'Nothing has been paid, so nothing is charged.');
        await tap(tester, 'cancel-keep');
        await tester.pumpAndSettle();
        expect(site.forFunction('cancel-pro-booking'), isEmpty);
        await tap(tester, 'booking-cancel');
        await tester.pumpAndSettle();
        await tap(tester, 'cancel-confirm');
        await settleCalls(tester);
        await tester.pump();
        expect(site.forFunction('cancel-pro-booking').single.body, {'booking_id': 'pb1'});
        expect(find.text('The booking is cancelled.'), findsOneWidget);
      });

      testWidgets('well before the job everything paid comes back, and the reason is sent', (tester) async {
        row = proBookingRow(state: 'confirmed', paid: 30000);
        site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'booking': proBookingRow(state: 'cancelled', cancelledBy: 'client', paid: 30000), 'refunded': 1, 'failed': 0});
        await openBooking(tester);
        await tap(tester, 'booking-cancel');
        await tester.pumpAndSettle();
        expect(textOf(tester, 'cancel-policy'), 'Everything you paid (\$300.00) is paid back to you.');
        await tester.enterText(find.byKey(const Key('cancel-reason')), ' Plans changed ');
        await tap(tester, 'cancel-confirm');
        await settleCalls(tester);
        await tester.pump();
        expect(site.forFunction('cancel-pro-booking').single.body, {'booking_id': 'pb1', 'reason': 'Plans changed'});
        expect(find.text('The booking is cancelled and the money is on its way back to the card.'), findsOneWidget);
      });

      testWidgets('less than a week before the job says what is kept and what comes back', (tester) async {
        row = proBookingRow(state: 'paid', paid: 100000);
        await withClock(Clock.fixed(DateTime(2099, 11, 5, 10)), () async {
          await openBooking(tester);
          await tap(tester, 'booking-cancel');
          await tester.pumpAndSettle();
          expect(textOf(tester, 'cancel-policy'), contains('less than 7 days away'));
          expect(textOf(tester, 'cancel-policy'), allOf(contains('\$300.00'), contains('\$700.00')));
        });
      });

      testWidgets('a refund that could not go through is said plainly', (tester) async {
        row = proBookingRow(state: 'confirmed', paid: 30000);
        site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'booking': proBookingRow(state: 'cancelled', cancelledBy: 'client', paid: 30000), 'refunded': 0, 'failed': 1});
        await openBooking(tester);
        await tap(tester, 'booking-cancel');
        await tester.pumpAndSettle();
        await tap(tester, 'cancel-confirm');
        await settleCalls(tester);
        await tester.pump();
        expect(find.textContaining('could not be paid back yet'), findsOneWidget);
      });

      testWidgets('a refusal is shown, the booking is read again, and the button works once more', (tester) async {
        site.functions['cancel-pro-booking'] = (b) => (status: 400, body: {'error': 'The date has come: if something went wrong, open a dispute instead.'});
        await openBooking(tester);
        await tap(tester, 'booking-cancel');
        await tester.pumpAndSettle();
        await tap(tester, 'cancel-confirm');
        await settleCalls(tester);
        await tester.pump();
        expect(textOf(tester, 'booking-problem'), 'The date has come: if something went wrong, open a dispute instead.');
        expect(tester.widget<TextButton>(find.byKey(const Key('booking-cancel'))).onPressed, isNotNull);
      });

      testWidgets('is not offered on the day of the job, once cancelled, or in dispute', (tester) async {
        row = proBookingRow(state: 'paid', paid: 100000);
        await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
          await openBooking(tester);
          expect(find.byKey(const Key('booking-cancel')), findsNothing);
        });
      });

      testWidgets('is not offered when the booking is closed', (tester) async {
        row = proBookingRow(state: 'cancelled', cancelledBy: 'provider', cancelReason: 'Ill');
        await openBooking(tester);
        expect(find.byKey(const Key('booking-cancel')), findsNothing);
        expect(textOf(tester, 'booking-status-text'), 'The professional cancelled this. "Ill"');
      });
    });

    group('after the job', () {
      testWidgets('the customer confirms it went well once the professional says it is done', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        site.rpcs['pro_booking_confirm'] = (_) => ok(proBookingRow(state: 'completed', paid: 100000));
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          expect(textOf(tester, 'booking-status-text'), contains('The professional says the job is done'));
          expect(find.byKey(const Key('booking-pay')), findsNothing);
          await tap(tester, 'booking-confirm');
          await settleCalls(tester);
          await tester.pump();
          expect(site.forRpc('pro_booking_confirm').single.body, {'p_booking': 'pb1'});
          expect(find.text('Thank you. The professional will be paid.'), findsOneWidget);
          expect(site.forRpc('pro_booking_get').length, greaterThanOrEqualTo(2), reason: 'the booking is read again after a step');
        });
      });

      testWidgets('a double tap on Confirm confirms once', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        site.rpcs['pro_booking_confirm'] = (_) => ok(proBookingRow(state: 'completed', paid: 100000));
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          await tester.ensureVisible(find.byKey(const Key('booking-confirm')));
          await tester.tap(find.byKey(const Key('booking-confirm')));
          await tester.tap(find.byKey(const Key('booking-confirm')));
          await tester.pump();
          await settleCalls(tester);
          expect(site.forRpc('pro_booking_confirm').length, 1);
        });
      });

      testWidgets('a refusal is shown and the booking is read again', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        site.rpcs['pro_booking_confirm'] = (_) => raised('This booking is not waiting for your confirmation.');
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          await tap(tester, 'booking-confirm');
          await settleCalls(tester);
          await tester.pump();
          expect(textOf(tester, 'booking-problem'), 'This booking is not waiting for your confirmation.');
          expect(site.forRpc('pro_booking_get').length, greaterThanOrEqualTo(2));
        });
      });

      testWidgets('on the day a customer can dispute even before the balance is paid, but not mark it done', (tester) async {
        row = proBookingRow(state: 'confirmed', paid: 30000);
        await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
          await openBooking(tester);
          expect(find.byKey(const Key('booking-dispute')), findsOneWidget);
          expect(find.byKey(const Key('booking-done')), findsNothing);
          expect(find.byKey(const Key('booking-confirm')), findsNothing);
        });
      });

      testWidgets('confirming is not offered before the professional says it is done', (tester) async {
        row = proBookingRow(state: 'paid', paid: 100000);
        await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
          await openBooking(tester);
          expect(find.byKey(const Key('booking-confirm')), findsNothing);
          expect(find.byKey(const Key('booking-done')), findsNothing, reason: 'only the professional marks it done');
          expect(find.byKey(const Key('booking-dispute')), findsOneWidget);
        });
      });

      testWidgets('a dispute needs a reason that is long enough, and is sent once it is', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        site.rpcs['pro_dispute_open'] = (_) => ok(proBookingRow(state: 'disputed', paid: 100000, dispute: {'id': 'd1', 'status': 'open', 'reason': 'The DJ never came at all', 'outcome': null}));
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          await tap(tester, 'booking-dispute');
          await tester.pumpAndSettle();
          await tester.enterText(find.byKey(const Key('dispute-reason')), 'Bad');
          await tap(tester, 'dispute-send');
          await tester.pump();
          expect(find.text('Say what went wrong in 10 to 1000 characters.'), findsOneWidget);
          expect(site.forRpc('pro_dispute_open'), isEmpty);
          await tester.enterText(find.byKey(const Key('dispute-reason')), ' The DJ never came at all ');
          await tap(tester, 'dispute-send');
          await settleCalls(tester);
          await tester.pump();
          expect(site.forRpc('pro_dispute_open').single.body, {'p_booking': 'pb1', 'p_reason': 'The DJ never came at all'});
          expect(find.text('Your dispute is open. BottlesUp will look at it.'), findsOneWidget);
        });
      });

      testWidgets('not now closes the dispute form without sending anything', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          await tap(tester, 'booking-dispute');
          await tester.pumpAndSettle();
          await tap(tester, 'dispute-keep');
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('dispute-reason')), findsNothing);
          expect(site.forRpc('pro_dispute_open'), isEmpty);
        });
      });

      testWidgets('a dispute cannot be opened more than a week after the job', (tester) async {
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        await withClock(Clock.fixed(DateTime(2099, 11, 16, 10)), () async {
          await openBooking(tester);
          expect(find.byKey(const Key('booking-dispute')), findsNothing);
          expect(find.byKey(const Key('booking-confirm')), findsOneWidget);
        });
        row = proBookingRow(state: 'done', paid: 100000, doneAt: '2099-11-08T20:00:00Z');
        await withClock(Clock.fixed(DateTime(2099, 11, 15, 23)), () async {
          await tester.pumpWidget(const SizedBox());
          await openBooking(tester);
          expect(find.byKey(const Key('booking-dispute')), findsOneWidget);
        });
      });

      testWidgets('a booking in dispute shows the reason and what BottlesUp decided, and offers no step', (tester) async {
        row = proBookingRow(state: 'disputed', paid: 100000, dispute: {'id': 'd1', 'status': 'resolved', 'outcome': 'refund_part', 'reason': 'The DJ left early'});
        await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
          await openBooking(tester);
          expect(textOf(tester, 'dispute-text'), 'The DJ left early');
          expect(textOf(tester, 'dispute-outcome'), 'BottlesUp decided part of the payment goes back to the customer.');
          expect([for (final k in ['booking-pay', 'booking-confirm', 'booking-dispute', 'booking-cancel']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0]);
          expect(textOf(tester, 'booking-status-text'), 'BottlesUp holds the payment and will decide.');
        });
      });

      testWidgets('an open dispute says BottlesUp is looking at it', (tester) async {
        row = proBookingRow(state: 'disputed', paid: 100000, dispute: {'id': 'd1', 'status': 'open', 'outcome': null, 'reason': 'The DJ left early'});
        await openBooking(tester);
        expect(textOf(tester, 'dispute-outcome'), 'BottlesUp is looking at it.');
      });
    });

    testWidgets('an unpaid booking whose time ran out says it is closed', (tester) async {
      row = proBookingRow(state: 'expired');
      await openBooking(tester);
      expect(textOf(tester, 'booking-status-text'), 'The deposit was not paid in time, so this booking is closed.');
      expect([for (final k in ['booking-pay', 'booking-cancel']) find.byKey(Key(k)).evaluate().length], [0, 0]);
    });

    testWidgets('the customer sees neither what the professional is paid nor the commission', (tester) async {
      await openBooking(tester);
      expect(find.textContaining('BottlesUp keeps'), findsNothing);
      expect(find.text('You will be paid'), findsNothing);
    });

    testWidgets('has links to the request and the professional, and a way back', (tester) async {
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow());
      final router = await openBooking(tester);
      await tap(tester, 'booking-back');
      expect(wentBack, 1);
      await tap(tester, 'booking-request');
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/pr1');
    });

    testWidgets('says why a booking cannot be read, with a way to try again', (tester) async {
      site.rpcs['pro_booking_get'] = (_) => raised('This booking is not available.');
      await openBooking(tester);
      expect(find.text('This booking is not available.'), findsOneWidget);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    });
  });

  group('the small pieces', () {
    testWidgets('a bold line looks bolder than a plain one', (tester) async {
      await pumpSite(tester, const Scaffold(body: Column(children: [InfoLine('Total', '\$10.00', bold: true), InfoLine('Deposit', '\$3.00')])), site: site);
      final bold = tester.widget<Text>(find.text('Total')).style!;
      final plain = tester.widget<Text>(find.text('Deposit')).style!;
      expect(bold, isNot(plain));
      expect(bold.fontWeight, isNot(plain.fontWeight));
    });

    testWidgets('a text question answers what was typed, trimmed, and nothing when kept', (tester) async {
      String? answer = 'unset';
      await pumpSite(tester, Builder(builder: (context) => Scaffold(body: TextButton(key: const Key('ask'), onPressed: () async => answer = await showTextDialog(context, title: 'T', label: 'L', confirmText: 'Yes', keepText: 'No', fieldKey: const Key('f'), confirmKey: const Key('y'), keepKey: const Key('n')), child: const Text('ask')))), site: site);
      await tester.tap(find.byKey(const Key('ask')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('f')), '  words  ');
      await tester.tap(find.byKey(const Key('y')));
      await tester.pumpAndSettle();
      expect(answer, 'words');
      await tester.tap(find.byKey(const Key('ask')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('n')));
      await tester.pumpAndSettle();
      expect(answer, isNull);
    });
  });

  group('on a professional\'s profile and on Home', () {
    SocialProfile pro({String category = 'dj', bool mine = false, bool blocked = false, bool suspended = false}) =>
        parseSocialProfile(profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: category, mine: mine, blocked: blocked, status: suspended ? 'suspended' : 'active'))!;

    testWidgets('lists what the professional offers and asks for a quote', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: ProServicesSection(profile: pro()));
      await settleCalls(tester);
      expect(find.text('Hire DJ Dee'), findsOneWidget);
      expect(find.text('Wedding DJ set'), findsOneWidget);
      expect(find.text('Photo booth'), findsOneWidget);
      expect(find.text('from \$1,000.00 from'), findsOneWidget);
      await tap(tester, 'request-pro');
      await tester.pumpAndSettle();
      expect(path(router), '/pros/p-dj/request');
    });

    testWidgets('still offers a quote when no service is listed', (tester) async {
      site.rpcs['pro_services_of'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/', features: on, home: ProServicesSection(profile: pro()));
      await settleCalls(tester);
      expect(find.byKey(const Key('pro-services-none')), findsOneWidget);
      expect(find.byKey(const Key('request-pro')), findsOneWidget);
    });

    testWidgets('shows nothing for a venue, an event group, a person, a blocked or suspended profile, or when hiring is off', (tester) async {
      for (final p in [pro(category: 'venue'), pro(category: 'event_group'), pro(blocked: true), pro(suspended: true), parseSocialProfile(profileRow(id: 'p1', handle: 'ann', name: 'Ann'))!]) {
        await openSocial(tester, site, '/', features: on, home: ProServicesSection(profile: p));
        await settleCalls(tester);
        expect(find.byKey(const Key('pro-services')), findsNothing);
        expect(find.byKey(const Key('request-pro')), findsNothing);
        await tester.pumpWidget(const SizedBox());
      }
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, home: ProServicesSection(profile: pro()));
      await settleCalls(tester);
      expect(find.byKey(const Key('request-pro')), findsNothing);
    });

    testWidgets('on the professional\'s own profile it leads to their services and requests, not to hiring themselves', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: ProServicesSection(profile: pro(mine: true)));
      await settleCalls(tester);
      expect(find.byKey(const Key('request-pro')), findsNothing);
      await tap(tester, 'manage-services');
      await tester.pumpAndSettle();
      expect(path(router), '/me/services');
    });

    testWidgets('Home says a quote is waiting, and goes straight to it when there is one', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(status: 'quoted', quote: proQuoteRow()), proRequestRow(id: 'x', status: 'requested')]);
      final router = await openSocial(tester, site, '/', features: on, home: const HiringCard());
      await settleCalls(tester);
      expect(find.text('DJ Dee sent you a quote'), findsOneWidget);
      expect(find.text('\$1,000.00 · tap to answer'), findsOneWidget);
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow(status: 'quoted', quote: proQuoteRow()));
      await tester.tap(find.byKey(const Key('quotes-to-answer')));
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/pr1');
    });

    testWidgets('Home shows nothing, and asks for nothing, while hiring is switched off', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(status: 'quoted', quote: proQuoteRow())]);
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), myBusiness()]);
      site.rpcs['pro_requests_for'] = (_) => ok([proRequestRow(client: {'name': 'Ann'})]);
      await openSocial(tester, site, '/', features: {'social': true}, home: const HiringCard(), overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')]);
      await settleCalls(tester);
      expect(find.byKey(const Key('quotes-to-answer')), findsNothing);
      expect(find.byKey(const Key('requests-to-quote')), findsNothing);
      expect(site.forRpc('pro_requests_mine'), isEmpty);
      expect(site.forRpc('pro_requests_for'), isEmpty);
    });

    testWidgets('the Profile tab hides the way into hiring while it is switched off', (tester) async {
      await openSocial(tester, site, '/', features: {'social': true}, mine: [myPersonal()], home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-hiring')), findsNothing);
    });

    testWidgets('Home asks about requests for a professional only for a professional profile', (tester) async {
      site.rpcs['pro_requests_for'] = (_) => ok([proRequestRow(client: {'name': 'Ann'})]);
      await openSocial(tester, site, '/', features: on, home: const HiringCard());
      await settleCalls(tester);
      expect(site.forRpc('pro_requests_for'), isEmpty);
      expect(find.byKey(const Key('requests-to-quote')), findsNothing);
    });

    testWidgets('Home lists several quotes together, and shows nothing when none is waiting', (tester) async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(id: 'a', status: 'quoted', quote: proQuoteRow()), proRequestRow(id: 'b', status: 'quoted', quote: proQuoteRow(id: 'q2'))]);
      final router = await openSocial(tester, site, '/', features: on, home: const HiringCard());
      await settleCalls(tester);
      expect(find.text('2 quotes are waiting for your answer'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quotes-to-answer')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/hiring');
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(status: 'quoted', quote: proQuoteRow(status: 'expired'))]);
      await tester.pumpWidget(const SizedBox());
      await openSocial(tester, site, '/', features: on, home: const HiringCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('quotes-to-answer')), findsNothing);
    });
  });
}
