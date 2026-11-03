import 'package:bottles_up_user/features/hiring/screens/hiring_booking_screen.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_widgets.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_card.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
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

void main() {
  late FakeWebsite site;
  late int wentBack;
  final on = {'social': true, 'marketplace': true};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final soon = DateTime(now.year, now.month, now.day + 30);
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // The professional's own profile is the one the person is acting as.
  final asBiz = [selectedProfileIdProvider.overrideWith((ref) => 'biz')];
  final me = profileRow(id: 'biz', kind: 'business', handle: 'djdana', name: 'DJ Dana', category: 'dj', mine: true);
  final ann = {'name': 'Ann Lee', 'handle': 'ann'};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    wentBack = 0;
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['pro_services_of'] = (_) => ok([proServiceRow(), proServiceRow(id: 'sv2', title: 'Photo booth', from: null, note: null, active: false)]);
    site.rpcs['pro_busy_days'] = (_) => ok(<Object>[]);
    site.rpcs['pro_requests_for'] = (_) => ok(<Object>[]);
    site.rpcs['pro_requests_mine'] = (_) => ok(<Object>[]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
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

  Future<GoRouter> openAsPro(WidgetTester tester, String location, {List<Override> overrides = const [], Widget? home, Widget? fullPage}) async {
    final router = await openSocial(tester, site, location, features: on, mine: [myPersonal(), me], overrides: [...asBiz, ...overrides], home: home, fullPage: fullPage);
    await settleCalls(tester);
    return router;
  }

  group('my services and days', () {
    testWidgets('lists what I offer with its price, says what is hidden, and shows my busy days', (tester) async {
      site.rpcs['pro_busy_days'] = (_) => ok([iso(soon)]);
      await openAsPro(tester, '/me/services');
      expect(find.byKey(const Key('service-sv1')), findsOneWidget);
      expect(find.text('From \$1,000.00 from'), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('service-sv2')), matching: find.text('Hidden from your profile')), findsOneWidget);
      expect(find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), findsOneWidget);
      expect(site.forRpc('pro_services_of').first.body, {'p_profile': 'biz'});
    });

    testWidgets('says what to do when nothing is listed and no day is busy', (tester) async {
      site.rpcs['pro_services_of'] = (_) => ok(<Object>[]);
      await openAsPro(tester, '/me/services');
      expect(find.byKey(const Key('services-empty')), findsOneWidget);
      expect(find.byKey(const Key('busy-empty')), findsOneWidget);
    });

    testWidgets('adds a service with what was typed, and reads the list again', (tester) async {
      site.rpcs['pro_service_save'] = (_) => ok(proServiceRow(id: 'sv3'));
      await openAsPro(tester, '/me/services');
      await tap(tester, 'service-add');
      await tester.pumpAndSettle();
      await type(tester, 'service-title', '  Club night set ');
      await type(tester, 'service-description', 'Three hours');
      await type(tester, 'service-price', '450.50');
      await type(tester, 'service-note', 'per night');
      await tap(tester, 'service-active');
      await tap(tester, 'service-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_service_save').single.body, {'p_actor': 'biz', 'p_id': null, 'p_title': 'Club night set', 'p_description': 'Three hours', 'p_from_cents': 45050, 'p_note': 'per night', 'p_active': false});
      expect(find.text('Service added.'), findsOneWidget);
      expect(site.forRpc('pro_services_of').length, 2);
    });

    testWidgets('a name that is too short, or a price that is not a number, is refused before anything is sent', (tester) async {
      await openAsPro(tester, '/me/services');
      await tap(tester, 'service-add');
      await tester.pumpAndSettle();
      await type(tester, 'service-title', 'DJ');
      await tap(tester, 'service-save');
      expect(textOf(tester, 'service-problem'), 'Give the service a name of 3 to 80 characters.');
      await type(tester, 'service-title', 'Club night');
      await type(tester, 'service-price', 'lots');
      await tap(tester, 'service-save');
      expect(textOf(tester, 'service-problem'), 'Type the price as a number, for example 150 or 150.50.');
      await type(tester, 'service-price', '60000');
      await tap(tester, 'service-save');
      expect(textOf(tester, 'service-problem'), 'Choose a price between 0 and 50,000.00.');
      expect(site.forRpc('pro_service_save'), isEmpty);
    });

    testWidgets('changing a service starts from what it says now and keeps its id', (tester) async {
      site.rpcs['pro_service_save'] = (_) => ok(proServiceRow());
      await openAsPro(tester, '/me/services');
      await tester.tap(find.byKey(const Key('service-sv1')));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('service-title'))).controller!.text, 'Wedding DJ set');
      expect(tester.widget<TextField>(find.byKey(const Key('service-price'))).controller!.text, '1000.00');
      await type(tester, 'service-title', 'Wedding DJ');
      await type(tester, 'service-price', '');
      await tap(tester, 'service-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final sent = site.forRpc('pro_service_save').single.body;
      expect([sent['p_id'], sent['p_title'], sent['p_from_cents']], ['sv1', 'Wedding DJ', null]);
      expect(find.text('Service saved.'), findsOneWidget);
    });

    testWidgets('a refusal from the website is shown as it came', (tester) async {
      site.rpcs['pro_service_save'] = (_) => raised('A profile can list up to 20 services.');
      await openAsPro(tester, '/me/services');
      await tap(tester, 'service-add');
      await tester.pumpAndSettle();
      await type(tester, 'service-title', 'Club night');
      await tap(tester, 'service-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('A profile can list up to 20 services.'), findsOneWidget);
    });

    testWidgets('removing a service asks first', (tester) async {
      site.rpcs['pro_service_remove'] = (_) => ok(null);
      await openAsPro(tester, '/me/services');
      await tap(tester, 'service-remove-sv1');
      await tester.pumpAndSettle();
      await tap(tester, 'service-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('pro_service_remove'), isEmpty);
      await tap(tester, 'service-remove-sv1');
      await tester.pumpAndSettle();
      await tap(tester, 'service-remove-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_service_remove').single.body, {'p_actor': 'biz', 'p_id': 'sv1'});
      expect(find.text('Service removed.'), findsOneWidget);
      expect(site.forRpc('pro_services_of').length, 2, reason: 'the list is read again');
    });

    testWidgets('twenty services is the limit: the add button goes', (tester) async {
      site.rpcs['pro_services_of'] = (_) => ok([for (var i = 0; i < 20; i++) proServiceRow(id: 's$i', title: 'Service $i')]);
      await openAsPro(tester, '/me/services');
      expect(find.byKey(const Key('service-add')), findsNothing);
    });

    testWidgets('marks a day as busy and frees it again', (tester) async {
      site.rpcs['pro_busy_set'] = (_) => ok(null);
      var busyNow = <String>[];
      site.rpcs['pro_busy_days'] = (_) => ok(busyNow);
      await openAsPro(tester, '/me/services', overrides: picking(soon));
      busyNow = [iso(soon)];
      await tap(tester, 'busy-add');
      await settleCalls(tester);
      expect(site.forRpc('pro_busy_set').single.body, {'p_actor': 'biz', 'p_day': iso(soon), 'p_busy': true});
      expect(site.forRpc('pro_busy_days').last.body['p_profile'], 'biz');
      await tester.pump();
      expect(find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), findsOneWidget);
      busyNow = [];
      await tester.tap(find.descendant(of: find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), matching: find.byTooltip('Delete')));
      await settleCalls(tester);
      expect(site.forRpc('pro_busy_set').last.body, {'p_actor': 'biz', 'p_day': iso(soon), 'p_busy': false});
      await tester.pump();
      expect(find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), findsNothing);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.textContaining('is free again'), findsOneWidget, reason: 'the newest message replaces the one before it');
    });

    testWidgets('a double tap on a busy day frees it once', (tester) async {
      site.rpcs['pro_busy_set'] = (_) => ok(null);
      site.rpcs['pro_busy_days'] = (_) => ok([iso(soon)]);
      await openAsPro(tester, '/me/services');
      final delete = find.descendant(of: find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), matching: find.byTooltip('Delete'));
      await tester.tap(delete);
      await tester.tap(delete);
      await tester.pump();
      await settleCalls(tester);
      expect(site.forRpc('pro_busy_set').length, 1);
    });

    testWidgets('a day with a booking stays busy whatever is marked, and the screen says so', (tester) async {
      site.rpcs['pro_busy_set'] = (_) => ok(null);
      site.rpcs['pro_busy_days'] = (_) => ok([iso(soon)]);
      await openAsPro(tester, '/me/services');
      await tester.tap(find.descendant(of: find.byKey(Key('busy-${soon.year}-${soon.month}-${soon.day}')), matching: find.byTooltip('Delete')));
      await settleCalls(tester);
      await tester.pump();
      expect(find.textContaining('has a booking, so it stays busy'), findsOneWidget);
    });

    testWidgets('offers days from today to two years from now', (tester) async {
      final asked = <({DateTime first, DateTime last, DateTime initial})>[];
      await openAsPro(tester, '/me/services', overrides: recording(asked, null));
      await tap(tester, 'busy-add');
      await settleCalls(tester);
      expect([asked.single.first, asked.single.initial], [today, today]);
      expect(asked.single.last, DateTime(today.year, today.month, today.day + 730));
    });

    testWidgets('choosing no day marks nothing', (tester) async {
      await openAsPro(tester, '/me/services', overrides: picking(null));
      await tap(tester, 'busy-add');
      await settleCalls(tester);
      expect(site.forRpc('pro_busy_set'), isEmpty);
    });

    testWidgets('the Profile tab hides the way to the professional\'s requests and services while hiring is off', (tester) async {
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, mine: [myPersonal(), me], overrides: asBiz, home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-hiring')), findsNothing);
      expect(find.byKey(const Key('open-services')), findsNothing);
    });

    testWidgets('a personal profile, a venue and a person with hiring switched off are each told why there is nothing here', (tester) async {
      await openSocial(tester, site, '/me/services', features: on, mine: [myPersonal(), me]);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      final venue = profileRow(id: 'biz', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue', mine: true);
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), venue]);
      await openSocial(tester, site, '/me/services', features: on, mine: [myPersonal(), venue], overrides: asBiz);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      expect(site.forRpc('pro_services_of'), isEmpty, reason: 'nothing is asked for a profile that cannot be hired');
      await tester.pumpWidget(const SizedBox());
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/me/services', features: {'social': true}, mine: [myPersonal(), me], overrides: asBiz);
      await settleCalls(tester);
      expect(find.text('Hiring professionals is not open yet.'), findsOneWidget);
    });
  });

  group('requests for me', () {
    testWidgets('puts the requests waiting for my quote first', (tester) async {
      site.rpcs['pro_requests_for'] = (_) => ok([
            proRequestRow(id: 'a', status: 'quoted', client: ann, quote: proQuoteRow(), provider: me),
            proRequestRow(id: 'b', status: 'requested', client: {'name': 'Bo Park'}, provider: me),
            proRequestRow(id: 'c', status: 'accepted', client: ann, quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(state: 'paid', paid: 100000, net: 95000, client: ann, provider: me), provider: me),
          ]);
      final router = await openAsPro(tester, '/me/pro-requests');
      expect(site.forRpc('pro_requests_for').first.body, {'p_actor': 'biz'});
      expect(find.text('Waiting for your quote'), findsOneWidget);
      expect(find.text('Everything else'), findsOneWidget);
      expect(tester.getTopLeft(find.byKey(const Key('request-b'))).dy, lessThan(tester.getTopLeft(find.byKey(const Key('request-a'))).dy));
      expect(find.descendant(of: find.byKey(const Key('request-b')), matching: find.text('Bo Park')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('request-a')), matching: find.text('Quote sent')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('request-c')), matching: find.text('Booked and paid')), findsOneWidget);
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow(id: 'b', client: {'name': 'Bo Park'}, provider: me));
      await tester.tap(find.byKey(const Key('request-b')));
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/b');
    });

    testWidgets('has a plain empty state, and tells a personal profile to switch', (tester) async {
      await openAsPro(tester, '/me/pro-requests');
      expect(find.text('No requests yet'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await openSocial(tester, site, '/me/pro-requests', features: on, mine: [myPersonal(), me]);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcRequests.clear();
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), profileRow(id: 'biz', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue', mine: true)]);
      await openSocial(tester, site, '/me/pro-requests', features: on, overrides: asBiz);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      expect(site.forRpc('pro_requests_for'), isEmpty);
    });

    testWidgets('Home says people asked for a quote, and goes straight to the one request', (tester) async {
      site.rpcs['pro_requests_for'] = (_) => ok([proRequestRow(client: ann, provider: me)]);
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow(client: ann, provider: me));
      final router = await openAsPro(tester, '/', home: const HiringCard());
      expect(find.text('Ann Lee asked for a quote'), findsOneWidget);
      await tester.tap(find.byKey(const Key('requests-to-quote')));
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/pr1');
    });

    testWidgets('Home counts several requests, and a request I already quoted is not counted', (tester) async {
      site.rpcs['pro_requests_for'] = (_) => ok([proRequestRow(id: 'a', client: ann, provider: me), proRequestRow(id: 'b', client: ann, provider: me), proRequestRow(id: 'c', status: 'quoted', client: ann, quote: proQuoteRow(), provider: me)]);
      final router = await openAsPro(tester, '/', home: const HiringCard());
      expect(find.text('2 people asked for a quote'), findsOneWidget);
      await tester.tap(find.byKey(const Key('requests-to-quote')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/pro-requests');
    });

    testWidgets('the Profile tab links to the professional\'s requests and services, and to what they asked', (tester) async {
      final router = await openAsPro(tester, '/', home: const SocialEntryCard());
      expect(find.byKey(const Key('open-hiring')), findsOneWidget);
      expect(find.byKey(const Key('open-pro-requests')), findsOneWidget);
      await tap(tester, 'open-services');
      await tester.pumpAndSettle();
      expect(path(router), '/me/services');
    });

    testWidgets('a person with a personal profile sees only the link to what they asked', (tester) async {
      await openSocial(tester, site, '/', features: on, mine: [myPersonal()], home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-hiring')), findsOneWidget);
      expect(find.byKey(const Key('open-pro-requests')), findsNothing);
      expect(find.byKey(const Key('open-services')), findsNothing);
    });
  });

  group('a request, from the professional\'s side', () {
    Future<GoRouter> openRequest(WidgetTester tester, Map<String, dynamic> row, {List<Override> overrides = const []}) async {
      site.rpcs['pro_request_get'] = (_) => ok(row);
      return openAsPro(tester, '/hiring/pr1', overrides: overrides);
    }

    Map<String, dynamic> fresh({String status = 'requested', Map<String, dynamic>? quote, String? date, Map<String, dynamic>? booking}) =>
        proRequestRow(status: status, client: ann, quote: quote, provider: me, date: date ?? '2099-11-08', booking: booking);

    testWidgets('names the customer and the job, and offers a quote or a decline, not the customer\'s choices', (tester) async {
      await openRequest(tester, fresh());
      expect(textOf(tester, 'request-title'), 'Request from Ann Lee');
      expect(textOf(tester, 'request-message-text'), 'A birthday night for 120');
      expect(find.widgetWithText(FilledButton, 'Send a quote'), findsOneWidget);
      expect(find.byKey(const Key('request-decline')), findsOneWidget);
      expect([for (final k in ['request-accept', 'request-withdraw', 'request-decline-quote', 'request-withdraw-quote', 'request-view-profile']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0, 0]);
    });

    testWidgets('sends a quote: the total, the deposit, the day the balance is due, what is included, and how long it stays open', (tester) async {
      site.rpcs['pro_quote_send'] = (_) => ok(fresh(status: 'quoted', quote: proQuoteRow()));
      await openRequest(tester, fresh(), overrides: picking(DateTime(2099, 11, 1)));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '300');
      expect(find.byKey(const Key('quote-due')), findsOneWidget);
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      expect(find.textContaining('Balance of \$700.00 due by'), findsOneWidget);
      await type(tester, 'quote-scope', '  Four hours of music, lights and sound ');
      await tap(tester, 'quote-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_quote_send').single.body, {
        'p_actor': 'biz',
        'p_request': 'pr1',
        'p_total_cents': 100000,
        'p_deposit_cents': 30000,
        'p_balance_due_by': '2099-11-01',
        'p_scope': 'Four hours of music, lights and sound',
        'p_valid_days': 7,
      });
      expect(find.text('Your quote was sent.'), findsOneWidget);
      expect(site.forRpc('pro_request_get').length, greaterThanOrEqualTo(2));
    });

    testWidgets('the balance day can be any day from today to the day before the job', (tester) async {
      final asked = <({DateTime first, DateTime last, DateTime initial})>[];
      await openRequest(tester, fresh(), overrides: recording(asked, null));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '300');
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      expect([asked.single.first, asked.single.last, asked.single.initial], [today, DateTime(2099, 11, 7), DateTime(2099, 11, 7)]);
      expect(find.text('Balance due by...'), findsOneWidget, reason: 'choosing no day leaves it empty');
    });

    testWidgets('raising the deposit to the whole price after choosing a balance day sends no balance day', (tester) async {
      site.rpcs['pro_quote_send'] = (_) => ok(fresh(status: 'quoted', quote: proQuoteRow(deposit: 100000)));
      await openRequest(tester, fresh(), overrides: picking(DateTime(2099, 11, 1)));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '300');
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      expect(find.byKey(const Key('quote-due')), findsOneWidget);
      await type(tester, 'quote-deposit', '1000');
      expect(find.byKey(const Key('quote-due')), findsNothing);
      await type(tester, 'quote-scope', 'Everything we talked about');
      await tap(tester, 'quote-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_quote_send').single.body['p_balance_due_by'], null);
    });

    testWidgets('a deposit that is the whole price needs no balance day', (tester) async {
      site.rpcs['pro_quote_send'] = (_) => ok(fresh(status: 'quoted', quote: proQuoteRow(deposit: 100000)));
      await openRequest(tester, fresh());
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '1000');
      expect(find.byKey(const Key('quote-due')), findsNothing);
      await type(tester, 'quote-scope', 'Everything we talked about');
      await tester.ensureVisible(find.byKey(const Key('quote-days')));
      await tester.tap(find.byKey(const Key('quote-days')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 days').last);
      await tester.pumpAndSettle();
      await tap(tester, 'quote-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final sent = site.forRpc('pro_quote_send').single.body;
      expect([sent['p_deposit_cents'], sent['p_balance_due_by'], sent['p_valid_days']], [100000, null, 3]);
    });

    testWidgets('says what is wrong with a quote before sending it', (tester) async {
      await openRequest(tester, fresh(), overrides: picking(DateTime(2099, 11, 1)));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '5');
      await tap(tester, 'quote-send');
      expect(textOf(tester, 'quote-problem'), 'Choose a total between 10.00 and 50,000.00.');
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '50');
      await tap(tester, 'quote-send');
      expect(textOf(tester, 'quote-problem'), startsWith('The deposit must be at least a tenth of the total (\$100.00)'));
      await type(tester, 'quote-deposit', '300');
      await tap(tester, 'quote-send');
      expect(textOf(tester, 'quote-problem'), 'The balance must be due before the date of the job.');
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      await type(tester, 'quote-scope', 'short');
      await tap(tester, 'quote-send');
      expect(textOf(tester, 'quote-problem'), startsWith('Say what is included in 10 to 1500 characters'));
      expect(site.forRpc('pro_quote_send'), isEmpty);
    });

    testWidgets('the deposit helper says the smallest deposit', (tester) async {
      await openRequest(tester, fresh());
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      expect(find.textContaining('At least \$100.00'), findsOneWidget);
    });

    testWidgets('a job today has no day left for a balance', (tester) async {
      await openRequest(tester, fresh(date: iso(today)));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '300');
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      expect(textOf(tester, 'quote-problem'), startsWith('The job is too soon for a balance date'));
    });

    testWidgets('a refusal stays in the sheet, where it can be fixed, and the sheet stays open', (tester) async {
      site.rpcs['pro_quote_send'] = (_) => raised('This request is no longer open.');
      await openRequest(tester, fresh(), overrides: picking(DateTime(2099, 11, 1)));
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '300');
      await tap(tester, 'quote-due');
      await settleCalls(tester);
      await type(tester, 'quote-scope', 'Four hours of music');
      await tap(tester, 'quote-send');
      await settleCalls(tester);
      expect(textOf(tester, 'quote-problem'), 'This request is no longer open.');
      expect(tester.widget<FilledButton>(find.byKey(const Key('quote-send'))).onPressed, isNotNull);
    });

    testWidgets('a double tap on Send sends one quote', (tester) async {
      site.rpcs['pro_quote_send'] = (_) => ok(fresh(status: 'quoted', quote: proQuoteRow(deposit: 100000)));
      await openRequest(tester, fresh());
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      await type(tester, 'quote-total', '1000');
      await type(tester, 'quote-deposit', '1000');
      await type(tester, 'quote-scope', 'Everything we talked about');
      await tester.ensureVisible(find.byKey(const Key('quote-send')));
      await tester.tap(find.byKey(const Key('quote-send')));
      await tester.tap(find.byKey(const Key('quote-send')), warnIfMissed: false);
      await settleCalls(tester);
      expect(site.forRpc('pro_quote_send').length, 1);
    });

    testWidgets('changing a quote starts from the quote that was sent', (tester) async {
      await openRequest(tester, fresh(status: 'quoted', quote: proQuoteRow()));
      expect(find.widgetWithText(FilledButton, 'Change the quote'), findsOneWidget);
      await tap(tester, 'request-quote');
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('quote-total'))).controller!.text, '1000.00');
      expect(tester.widget<TextField>(find.byKey(const Key('quote-deposit'))).controller!.text, '300.00');
      expect(tester.widget<TextField>(find.byKey(const Key('quote-scope'))).controller!.text, 'Four hours of music, lights and sound');
      expect(find.textContaining('Balance of \$700.00 due by'), findsOneWidget);
    });

    testWidgets('the professional is not offered the customer\'s choices on a quoted request', (tester) async {
      await openRequest(tester, fresh(status: 'quoted', quote: proQuoteRow()));
      expect([for (final k in ['request-accept', 'request-decline-quote', 'request-withdraw']) find.byKey(Key(k)).evaluate().length], [0, 0, 0]);
    });

    testWidgets('withdrawing the quote asks the website once', (tester) async {
      site.rpcs['pro_quote_withdraw'] = (_) => ok(fresh());
      await openRequest(tester, fresh(status: 'quoted', quote: proQuoteRow()));
      await tap(tester, 'request-withdraw-quote');
      await settleCalls(tester);
      expect(site.forRpc('pro_quote_withdraw').single.body, {'p_actor': 'biz', 'p_request': 'pr1'});
      expect(find.text('The quote was withdrawn.'), findsOneWidget);
    });

    testWidgets('declining asks first, and sends the note (or nothing)', (tester) async {
      site.rpcs['pro_request_decline'] = (_) => ok(fresh(status: 'declined'));
      await openRequest(tester, fresh());
      await tap(tester, 'request-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'decline-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('pro_request_decline'), isEmpty);
      await tap(tester, 'request-decline');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('decline-note')), ' Booked that weekend ');
      await tap(tester, 'decline-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_request_decline').single.body, {'p_actor': 'biz', 'p_request': 'pr1', 'p_note': 'Booked that weekend'});
      expect(find.text('The request is declined.'), findsOneWidget);
    });

    testWidgets('declining without a note sends none', (tester) async {
      site.rpcs['pro_request_decline'] = (_) => ok(fresh(status: 'declined'));
      await openRequest(tester, fresh());
      await tap(tester, 'request-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'decline-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('pro_request_decline').single.body['p_note'], null);
    });

    testWidgets('a request that is over offers nothing to press, and an accepted one opens its booking', (tester) async {
      await openRequest(tester, fresh(status: 'declined'));
      expect([for (final k in ['request-quote', 'request-decline', 'request-withdraw-quote']) find.byKey(Key(k)).evaluate().length], [0, 0, 0]);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['pro_booking_get'] = (_) => ok(proBookingRow(state: 'paid', paid: 100000, net: 95000, client: ann, provider: me));
      final router = await openRequest(tester, fresh(status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(state: 'paid', paid: 100000, net: 95000, client: ann, provider: me)));
      await tap(tester, 'request-open-booking');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      expect(path(router), '/hiring/bookings/pb1');
    });
  });

  group('a booking, from the professional\'s side', () {
    var row = proBookingRow();

    setUp(() {
      row = proBookingRow(state: 'paid', paid: 100000, net: 95000, client: ann, provider: me);
      site.rpcs['pro_booking_get'] = (_) => ok(row);
    });

    Future<GoRouter> openBooking(WidgetTester tester) => openAsPro(tester, '/', fullPage: HiringBookingScreen(bookingId: 'pb1', onBack: (c) => wentBack++));

    testWidgets('says who it is for, what I will be paid and what BottlesUp keeps', (tester) async {
      await openBooking(tester);
      expect(textOf(tester, 'booking-who'), 'For Ann Lee');
      expect(find.text('You will be paid'), findsOneWidget);
      expect(find.text('\$950.00'), findsOneWidget);
      expect(find.text('5%'), findsOneWidget);
      expect(find.text('Paid and ready'), findsNothing);
      expect(textOf(tester, 'booking-status-text'), contains('mark it done'));
      expect([for (final k in ['booking-pay', 'booking-confirm', 'booking-dispute', 'booking-profile']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0]);
    });

    testWidgets('marking it done waits for the day of the job', (tester) async {
      await openBooking(tester);
      expect(find.byKey(const Key('booking-done')), findsNothing);
    });

    testWidgets('on the day it can be marked done, once, and the website is asked as the professional\'s profile', (tester) async {
      site.rpcs['pro_booking_done'] = (_) => ok(proBookingRow(state: 'done', paid: 100000, net: 95000, client: ann, provider: me, doneAt: '2099-11-08T20:00:00Z'));
      await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
        await openBooking(tester);
        await tap(tester, 'booking-done');
        await settleCalls(tester);
        await tester.pump();
        expect(site.forRpc('pro_booking_done').single.body, {'p_actor': 'biz', 'p_booking': 'pb1'});
        expect(find.text('Marked as done. The customer is asked to confirm.'), findsOneWidget);
        expect(find.byKey(const Key('booking-dispute')), findsNothing, reason: 'only the customer disputes');
        expect(find.byKey(const Key('booking-confirm')), findsNothing, reason: 'only the customer confirms');
      });
    });

    testWidgets('a booking not yet paid in full cannot be marked done', (tester) async {
      row = proBookingRow(state: 'confirmed', paid: 30000, net: 95000, client: ann, provider: me);
      await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
        await openBooking(tester);
        expect(find.byKey(const Key('booking-done')), findsNothing);
        expect(textOf(tester, 'booking-status-text'), startsWith('The deposit is paid. The customer pays the balance'));
      });
    });

    testWidgets('once marked done it waits for the customer', (tester) async {
      row = proBookingRow(state: 'done', paid: 100000, net: 95000, client: ann, provider: me, doneAt: '2099-11-08T20:00:00Z');
      await withClock(Clock.fixed(DateTime(2099, 11, 9, 10)), () async {
        await openBooking(tester);
        expect(find.byKey(const Key('booking-done')), findsNothing);
        expect(find.byKey(const Key('booking-confirm')), findsNothing, reason: 'it is the customer\'s to confirm');
        expect(find.byKey(const Key('booking-dispute')), findsNothing);
        expect(textOf(tester, 'booking-status-text'), startsWith('Marked as done on'));
      });
    });

    testWidgets('a refused step is shown as it came', (tester) async {
      site.rpcs['pro_booking_done'] = (_) => raised('You already marked this done.');
      await withClock(Clock.fixed(DateTime(2099, 11, 8, 10)), () async {
        await openBooking(tester);
        await tap(tester, 'booking-done');
        await settleCalls(tester);
        await tester.pump();
        expect(textOf(tester, 'booking-problem'), 'You already marked this done.');
      });
    });

    testWidgets('cancelling says everything the customer paid goes back to them', (tester) async {
      site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'booking': proBookingRow(state: 'cancelled', cancelledBy: 'provider', paid: 100000, net: 95000, client: ann, provider: me), 'refunded': 1, 'failed': 0});
      await openBooking(tester);
      await tap(tester, 'booking-cancel');
      await tester.pumpAndSettle();
      expect(textOf(tester, 'cancel-policy'), 'Everything the customer paid (\$1,000.00) is paid back to them.');
      await tap(tester, 'cancel-confirm');
      await settleCalls(tester);
      await tester.pump();
      expect(site.forFunction('cancel-pro-booking').single.body, {'booking_id': 'pb1'});
    });

    testWidgets('a cancelled booking says who cancelled it', (tester) async {
      row = proBookingRow(state: 'cancelled', cancelledBy: 'client', cancelReason: 'Plans changed', paid: 30000, net: 95000, client: ann, provider: me);
      await openBooking(tester);
      expect(textOf(tester, 'booking-status-text'), 'The customer cancelled this. "Plans changed"');
    });

    testWidgets('a completed booking says the payment is on its way', (tester) async {
      row = proBookingRow(state: 'completed', paid: 100000, net: 95000, client: ann, provider: me);
      await openBooking(tester);
      expect(textOf(tester, 'booking-status-text'), contains('Your payment is on its way to you'));
    });

    testWidgets('waiting for the deposit says the date is not kept for anyone else yet', (tester) async {
      row = proBookingRow(net: 95000, client: ann, provider: me);
      await openBooking(tester);
      expect(textOf(tester, 'booking-status-text'), startsWith('Waiting for the customer to pay the deposit'));
      expect(find.byKey(const Key('booking-pay')), findsNothing);
    });
  });
}
