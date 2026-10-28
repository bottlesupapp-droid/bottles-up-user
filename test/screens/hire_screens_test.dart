import 'package:bottles_up_user/features/hire/widgets/hire_card.dart';
import 'package:bottles_up_user/features/hire/widgets/hire_widgets.dart';
import 'package:bottles_up_user/features/hiring/widgets/hiring_widgets.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/hire_fixtures.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  final on = {'social': true, 'venue_hire': true, 'inbox': true, 'marketplace': true};
  final now = DateTime.now();
  final soon = DateTime(now.year, now.month, now.day + 30);
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  final grp = groupProfile();
  final club = {...clubProfile(), 'is_mine': true};
  final asGroup = [selectedProfileIdProvider.overrideWith((ref) => 'grp')];
  final asClub = [selectedProfileIdProvider.overrideWith((ref) => 'club')];

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  List<Override> picking(DateTime? day) => [dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async => day)];
  List<Override> recording(List<({DateTime first, DateTime last, DateTime initial})> log, DateTime? day) => [
        dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async {
          log.add((first: first, last: last, initial: initial));
          return day;
        })
      ];

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), grp, club]);
    site.rpcs['pro_requests_mine'] = (_) => ok(<Object>[]);
    site.rpcs['team_invitations_mine'] = (_) => ok(<Object>[]);
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

  Future<GoRouter> open(WidgetTester tester, String location, {List<Override> overrides = const [], Widget? home, Map<String, bool>? features}) async {
    final router = await openSocial(tester, site, location, features: features ?? on, overrides: overrides, home: home);
    await settleCalls(tester);
    return router;
  }

  group('asking a venue to host an event', () {
    Future<GoRouter> openForm(WidgetTester tester, {DateTime? day, List<Override>? as}) => open(tester, '/venues/club/host', overrides: [...(as ?? asGroup), ...picking(day ?? soon)]);

    testWidgets('a personal profile is asked to switch to its event group', (tester) async {
      await open(tester, '/venues/club/host', overrides: picking(soon));
      expect(find.text('Ask as your event group'), findsOneWidget);
      expect(find.byKey(const Key('hire-switch')), findsOneWidget);
      expect(find.byKey(const Key('hire-send')), findsNothing);
    });

    testWidgets('a venue cannot ask a venue', (tester) async {
      await openForm(tester, as: asClub);
      expect(find.text('Ask as your event group'), findsOneWidget);
    });

    testWidgets('sends the day, the kind of night, the numbers and the words, then opens the hire', (tester) async {
      site.rpcs['hire_request'] = (_) => ok(hireRow());
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow()));
      final router = await openForm(tester);
      expect(find.textContaining('Asking as EONICS'), findsOneWidget);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', ' Themed night ');
      await type(tester, 'hire-hours', '9pm to 3am');
      await type(tester, 'hire-attendance', '400');
      await type(tester, 'hire-budget', '5000');
      await type(tester, 'hire-space', 'Main room');
      await type(tester, 'hire-equipment', 'Own DJ booth');
      await type(tester, 'hire-staffing', 'Two bartenders');
      await type(tester, 'hire-notes-field', 'Please keep the lights low');
      await tap(tester, 'hire-send');
      await settleCalls(tester);
      expect(site.forRpc('hire_request').single.body, {
        'p_actor': 'grp',
        'p_venue': 'club',
        'p_date': iso(soon),
        'p_hours': '9pm to 3am',
        'p_type': 'Themed night',
        'p_attendance': 400,
        'p_space': 'Main room',
        'p_equipment': 'Own DJ booth',
        'p_staffing': 'Two bartenders',
        'p_budget_cents': 500000,
        'p_notes': 'Please keep the lights low',
      });
      await settleCalls(tester);
      expect(path(router), '/hires/hr1');
      expect(site.forRpc('hire_workspace').last.body['p_actor'], 'grp', reason: 'opened as the profile it is for');
      expect(router.canPop(), isFalse, reason: 'the form is replaced by the hire');
    });

    testWidgets('leaves out what was not filled in', (tester) async {
      site.rpcs['hire_request'] = (_) => ok(hireRow());
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow()));
      await openForm(tester);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', 'Themed night');
      await tap(tester, 'hire-send');
      await settleCalls(tester);
      final sent = site.forRpc('hire_request').single.body;
      expect([sent['p_hours'], sent['p_attendance'], sent['p_space'], sent['p_equipment'], sent['p_staffing'], sent['p_budget_cents'], sent['p_notes']], [null, null, null, null, null, null, null]);
    });

    testWidgets('says what is missing before anything is sent', (tester) async {
      await openForm(tester);
      await tap(tester, 'hire-send');
      expect(textOf(tester, 'hire-problem'), 'Choose a date between tomorrow and two years from now.');
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await tap(tester, 'hire-send');
      expect(textOf(tester, 'hire-problem'), 'Say what kind of event it is in 2 to 80 characters.');
      await type(tester, 'hire-type', 'Themed night');
      await type(tester, 'hire-attendance', 'lots');
      await tap(tester, 'hire-send');
      expect(textOf(tester, 'hire-problem'), 'Type the expected attendance as a whole number.');
      await type(tester, 'hire-attendance', '0');
      await tap(tester, 'hire-send');
      expect(textOf(tester, 'hire-problem'), 'Choose an expected attendance between 1 and 100,000.');
      await type(tester, 'hire-attendance', '');
      await type(tester, 'hire-budget', 'a lot');
      await tap(tester, 'hire-send');
      expect(textOf(tester, 'hire-problem'), 'Type the budget like 5000 or 5000.00.');
      await settleCalls(tester);
      expect(site.forRpc('hire_request'), isEmpty);
    });

    testWidgets('offers days from tomorrow to two years from now', (tester) async {
      final asked = <({DateTime first, DateTime last, DateTime initial})>[];
      await open(tester, '/venues/club/host', overrides: [...asGroup, ...recording(asked, soon)]);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      final d = DateTime.now();
      expect([asked.single.first, asked.single.initial, asked.single.last], [DateTime(d.year, d.month, d.day + 1), DateTime(d.year, d.month, d.day + 1), DateTime(d.year, d.month, d.day + 730)]);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      expect(asked.last.initial, soon, reason: 'it starts from the day already chosen');
    });

    testWidgets('a refusal is shown as it came and the form stays', (tester) async {
      site.rpcs['hire_request'] = (_) => raised('This venue is already booked for a hire that day.');
      final router = await openForm(tester);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', 'Themed night');
      await tap(tester, 'hire-send');
      await settleCalls(tester);
      expect(textOf(tester, 'hire-problem'), 'This venue is already booked for a hire that day.');
      expect(path(router), '/venues/club/host');
      expect(tester.widget<FilledButton>(find.byKey(const Key('hire-send'))).onPressed, isNotNull);
    });

    testWidgets('a double tap on Send sends one request', (tester) async {
      site.rpcs['hire_request'] = (_) => ok(hireRow());
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow()));
      await openForm(tester);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', 'Themed night');
      await tester.ensureVisible(find.byKey(const Key('hire-send')));
      await tester.tap(find.byKey(const Key('hire-send')));
      await tester.tap(find.byKey(const Key('hire-send')));
      await settleCalls(tester);
      expect(site.forRpc('hire_request').length, 1);
    });

    testWidgets('nobody who has not accepted the community rules sends anything', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      await openForm(tester);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', 'Themed night');
      await tap(tester, 'hire-send');
      await settleCalls(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(site.forRpc('hire_request'), isEmpty);
    });

    testWidgets('says it is not open yet when hiring a venue is switched off', (tester) async {
      await open(tester, '/venues/club/host', features: {'social': true}, overrides: asGroup);
      expect(find.text('Hosting events at venues is not open yet.'), findsOneWidget);
    });
  });

  group('my hires and the requests a venue has had', () {
    testWidgets('a group sees the offers to answer first, and where the rest stand', (tester) async {
      site.rpcs['hires_mine'] = (_) => ok([
            hireRow(id: 'a', state: 'requested'),
            hireRow(id: 'b', state: 'offered', offer: hireOfferRow()),
            hireRow(id: 'c', state: 'confirmed', offer: hireOfferRow(status: 'accepted')),
            hireRow(id: 'd', state: 'agreed', offer: hireOfferRow(status: 'accepted')),
          ]);
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow(id: 'b', state: 'offered', offer: hireOfferRow()), open: false));
      final router = await open(tester, '/me/hires', overrides: asGroup);
      expect(site.forRpc('hires_mine').first.body, {'p_actor': 'grp'});
      expect(find.text('Offers to answer'), findsOneWidget);
      expect(find.text('Everything else'), findsOneWidget);
      final order = [for (final id in ['b', 'a', 'c', 'd']) tester.getTopLeft(find.byKey(Key('hire-$id'))).dy];
      expect(order, [...order]..sort());
      expect(find.descendant(of: find.byKey(const Key('hire-b')), matching: find.text('Offer to answer')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-a')), matching: find.text('Waiting for an offer')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-c')), matching: find.text('Confirmed')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-d')), matching: find.textContaining('waiting for the venue')), findsOneWidget, reason: 'agreed is not booked');
      expect(find.descendant(of: find.byKey(const Key('hire-b')), matching: find.text('Club X')), findsOneWidget);
      await tester.tap(find.byKey(const Key('hire-b')));
      await tester.pumpAndSettle();
      expect(path(router), '/hires/b');
      expect(site.forRpc('hire_workspace').last.body['p_actor'], 'grp', reason: 'opened as the profile it is for');
    });

    testWidgets('a venue sees what waits for it first', (tester) async {
      site.rpcs['hires_for'] = (_) => ok([
            hireRow(id: 'a', state: 'offered', offer: hireOfferRow(), asker: {'name': 'Gus', 'handle': 'gus'}),
            hireRow(id: 'b', state: 'requested', asker: {'name': 'Gus', 'handle': 'gus'}),
            hireRow(id: 'c', state: 'agreed', offer: hireOfferRow(status: 'accepted'), asker: {'name': 'Gus', 'handle': 'gus'}),
            hireRow(id: 'd', state: 'offer_expired', offer: hireOfferRow(status: 'expired'), asker: {'name': 'Gus', 'handle': 'gus'}),
          ]);
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(id: 'b', asker: {'name': 'Gus', 'handle': 'gus'}), open: false));
      final router = await open(tester, '/me/hire-requests', overrides: asClub);
      expect(site.forRpc('hires_for').first.body, {'p_actor': 'club'});
      expect(find.text('Waiting for you'), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-b')), matching: find.text('Needs your offer')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-c')), matching: find.text('Agreed: confirm the date')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-d')), matching: find.text('Your offer ran out')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-a')), matching: find.text('Offer made')), findsOneWidget);
      final waiting = [for (final id in ['b', 'c', 'd']) tester.getTopLeft(find.byKey(Key('hire-$id'))).dy];
      expect(waiting.every((y) => y < tester.getTopLeft(find.byKey(const Key('hire-a'))).dy), isTrue, reason: 'what waits for the venue is above the rest');
      await tester.tap(find.byKey(const Key('hire-b')));
      await tester.pumpAndSettle();
      expect(path(router), '/hires/b');
      expect(site.forRpc('hire_workspace').last.body['p_actor'], 'club', reason: 'opened as the profile it is for');
    });

    testWidgets('only things that need no answer: no heading for the rest', (tester) async {
      site.rpcs['hires_mine'] = (_) => ok([hireRow(state: 'declined')]);
      await open(tester, '/me/hires', overrides: asGroup);
      expect(find.text('Offers to answer'), findsNothing);
      expect(find.text('Everything else'), findsNothing);
      expect(find.byKey(const Key('hire-hr1')), findsOneWidget);
    });

    testWidgets('has plain empty states', (tester) async {
      site.rpcs['hires_mine'] = (_) => ok(<Object>[]);
      site.rpcs['hires_for'] = (_) => ok(<Object>[]);
      await open(tester, '/me/hires', overrides: asGroup);
      expect(find.text('You have not asked a venue yet'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await open(tester, '/me/hire-requests', overrides: asClub);
      expect(find.text('No requests yet'), findsOneWidget);
    });

    testWidgets('the wrong profile is told which to switch to, and nothing is asked', (tester) async {
      await open(tester, '/me/hires', overrides: asClub);
      expect(find.text('Switch to your event group'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await open(tester, '/me/hire-requests', overrides: asGroup);
      expect(find.text('Switch to your venue profile'), findsOneWidget);
      expect(site.forRpc('hires_mine'), isEmpty);
      expect(site.forRpc('hires_for'), isEmpty);
    });

    testWidgets('says why it cannot load, and loads again', (tester) async {
      var fail = true;
      site.rpcs['hires_mine'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok([hireRow()]);
      await open(tester, '/me/hires', overrides: asGroup);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('hire-hr1')), findsOneWidget);
    });

    testWidgets('says it is not open yet when hiring a venue is switched off', (tester) async {
      await open(tester, '/me/hires', features: {'social': true}, overrides: asGroup);
      expect(find.text('Hosting events at venues is not open yet.'), findsOneWidget);
    });

    testWidgets('Home says an offer waits, and goes straight to it when there is one', (tester) async {
      site.rpcs['hires_mine'] = (_) => ok([hireRow(state: 'offered', offer: hireOfferRow()), hireRow(id: 'x', state: 'requested')]);
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow(state: 'offered', offer: hireOfferRow()), open: false));
      final router = await open(tester, '/', overrides: asGroup, home: const HireCard());
      expect(find.text('Club X made you an offer'), findsOneWidget);
      await tester.tap(find.byKey(const Key('offers-to-answer')));
      await tester.pumpAndSettle();
      expect(path(router), '/hires/hr1');
      expect(site.forRpc('hire_workspace').last.body['p_actor'], 'grp', reason: 'opened as the profile it is for');
    });

    testWidgets('Home counts several offers together, and shows nothing when there is none', (tester) async {
      site.rpcs['hires_mine'] = (_) => ok([hireRow(id: 'a', state: 'offered', offer: hireOfferRow()), hireRow(id: 'b', state: 'offered', offer: hireOfferRow(id: 'of2'))]);
      final router = await open(tester, '/', overrides: asGroup, home: const HireCard());
      expect(find.text('2 venues made you an offer'), findsOneWidget);
      await tester.tap(find.byKey(const Key('offers-to-answer')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/hires');
      await tester.pumpWidget(const SizedBox());
      site.rpcs['hires_mine'] = (_) => ok([hireRow(state: 'offered', offer: hireOfferRow(status: 'expired'))]);
      await open(tester, '/', overrides: asGroup, home: const HireCard());
      expect(find.byKey(const Key('offers-to-answer')), findsNothing);
    });

    testWidgets('Home tells a venue that groups are waiting, counting what is to confirm', (tester) async {
      site.rpcs['hires_for'] = (_) => ok([hireRow(id: 'a', state: 'requested', asker: {'name': 'Gus', 'handle': 'gus'}), hireRow(id: 'b', state: 'agreed', offer: hireOfferRow(status: 'accepted'), asker: {'name': 'Gus', 'handle': 'gus'}), hireRow(id: 'c', state: 'offered', offer: hireOfferRow())]);
      final router = await open(tester, '/', overrides: asClub, home: const HireCard());
      expect(find.text('2 groups are waiting for you'), findsOneWidget);
      expect(find.text('1 to confirm · tap to answer'), findsOneWidget);
      await tester.tap(find.byKey(const Key('hires-waiting')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/hire-requests');
    });

    testWidgets('Home names the one group that waits, and goes to it', (tester) async {
      site.rpcs['hires_for'] = (_) => ok([hireRow(state: 'requested', asker: {'name': 'Gus', 'handle': 'gus'})]);
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(asker: {'name': 'Gus', 'handle': 'gus'}), open: false));
      final router = await open(tester, '/', overrides: asClub, home: const HireCard());
      expect(find.text('EONICS wants to host a night'), findsOneWidget);
      expect(find.text('Tap to answer'), findsOneWidget);
      await tester.tap(find.byKey(const Key('hires-waiting')));
      await tester.pumpAndSettle();
      expect(path(router), '/hires/hr1');
      expect(site.forRpc('hire_workspace').last.body['p_actor'], 'club', reason: 'opened as the profile it is for');
    });

    testWidgets('Home shows nothing for a personal profile or while hiring a venue is off', (tester) async {
      await open(tester, '/', home: const HireCard());
      expect(find.byKey(const Key('offers-to-answer')), findsNothing);
      expect(find.byKey(const Key('hires-waiting')), findsNothing);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['hires_mine'] = (_) => ok([hireRow(state: 'offered', offer: hireOfferRow())]);
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await open(tester, '/', features: {'social': true}, overrides: asGroup, home: const HireCard());
      expect(find.byKey(const Key('offers-to-answer')), findsNothing);
      expect(site.forRpc('hires_mine'), isEmpty);
    });
  });

  group('a hire, from the group\'s side', () {
    Future<GoRouter> openHire(WidgetTester tester, Map<String, dynamic> row, {List<Override> overrides = const []}) async {
      site.rpcs['hire_workspace'] = (_) => ok(row);
      return open(tester, '/hires/hr1?as=grp', overrides: [...asGroup, ...overrides]);
    }

    Map<String, dynamic> ws(String state, {Map<String, dynamic>? offer, List<Map<String, dynamic>> items = const [], List<Map<String, dynamic>> bookings = const [], Map<String, dynamic>? event, List<String> pending = const [], bool? open, String? hireChat, String? eventChat, String? cancelledBy, String? cancelReason, String? declineNote}) =>
        workspaceRow(
          hire: hireRow(state: state, offer: offer, cancelledBy: cancelledBy, cancelReason: cancelReason, declineNote: declineNote, eventId: event == null ? null : 'ev1'),
          open: open ?? (state == 'agreed' || state == 'confirmed'),
          items: items,
          bookings: bookings,
          event: event,
          pending: pending,
          hireChat: hireChat,
          eventChat: eventChat,
        );

    testWidgets('a request says it is only a request, shows what was asked, and offers to withdraw it', (tester) async {
      await openHire(tester, ws('requested'));
      expect(site.forRpc('hire_workspace').first.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
      expect(textOf(tester, 'hire-title'), 'Themed night');
      expect(textOf(tester, 'hire-who'), 'At Club X');
      expect(textOf(tester, 'hire-state-line'), 'This is only a request. The venue has not answered yet.');
      expect(find.text('9pm to 3am'), findsOneWidget);
      expect(find.text('400 people'), findsOneWidget);
      expect(find.text('Main room'), findsOneWidget);
      expect(find.text('\$5,000.00'), findsOneWidget);
      expect(textOf(tester, 'hire-notes'), 'Please keep the lights low');
      expect([for (final k in ['hire-offer', 'hire-agree', 'hire-cancel', 'hire-confirm', 'hire-offer-button', 'hire-decline']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0, 0, 0]);
      expect(find.text('Workspace'), findsNothing, reason: 'the workspace opens once it is agreed');
      await tap(tester, 'hire-withdraw');
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('withdrawing asks the website as the group, and reads the hire again', (tester) async {
      site.rpcs['hire_withdraw'] = (_) => ok(hireRow(state: 'withdrawn'));
      await openHire(tester, ws('requested'));
      await tap(tester, 'hire-withdraw');
      await settleCalls(tester);
      await tester.pump();
      expect(site.forRpc('hire_withdraw').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
      expect(find.text('Your request was withdrawn.'), findsOneWidget);
      expect(site.forRpc('hire_workspace').length, greaterThanOrEqualTo(2));
    });

    testWidgets('an offer shows its terms and what agreeing means, and agreeing asks first', (tester) async {
      site.rpcs['hire_agree'] = (_) => ok(hireRow(state: 'agreed'));
      await openHire(tester, ws('offered', offer: hireOfferRow()));
      expect(textOf(tester, 'hire-state-line'), contains('Nothing is booked until you agree and the venue confirms'));
      expect(find.text('The venue\'s offer'), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-offer')), matching: find.text('\$4,500.00')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-offer')), matching: find.text('\$1,000.00')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-offer')), matching: find.text('\$3,000.00')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-offer')), matching: find.text('20%')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('hire-offer')), matching: find.text('Shared')), findsOneWidget);
      expect(find.text('Two bartenders included'), findsOneWidget);
      expect(find.text('Lose the deposit within 14 days'), findsOneWidget);
      expect(textOf(tester, 'offer-validity'), startsWith('Open until'));
      expect(find.textContaining('BottlesUp does not take it'), findsWidgets);
      await tap(tester, 'hire-agree');
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.descendant(of: find.byType(AlertDialog), matching: find.textContaining('You agree to the terms'))).data!;
      expect(text, allOf(contains('\$4,500.00'), contains('\$1,000.00'), contains('\$3,000.00'), contains('20%'), contains('still has to confirm')));
      await tap(tester, 'ask-no');
      await tester.pumpAndSettle();
      expect(site.forRpc('hire_agree'), isEmpty);
      await tap(tester, 'hire-agree');
      await tester.pumpAndSettle();
      await tap(tester, 'ask-yes');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_agree').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
    });

    testWidgets('turning the offer down asks the website', (tester) async {
      site.rpcs['hire_offer_decline'] = (_) => ok(hireRow());
      await openHire(tester, ws('offered', offer: hireOfferRow()));
      await tap(tester, 'hire-turn-down');
      await settleCalls(tester);
      expect(site.forRpc('hire_offer_decline').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
    });

    testWidgets('an offer that ran out cannot be agreed, but the request can be withdrawn', (tester) async {
      await openHire(tester, ws('offer_expired', offer: hireOfferRow(status: 'expired')));
      expect(find.byKey(const Key('hire-agree')), findsNothing);
      expect(textOf(tester, 'offer-validity'), 'This offer has run out.');
      expect(find.byKey(const Key('hire-withdraw')), findsOneWidget);
    });

    testWidgets('a refusal is shown as it came and the hire is read again', (tester) async {
      site.rpcs['hire_agree'] = (_) => raised('This offer has expired. Ask the venue for a new one.');
      await openHire(tester, ws('offered', offer: hireOfferRow()));
      await tap(tester, 'hire-agree');
      await tester.pumpAndSettle();
      await tap(tester, 'ask-yes');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      await tester.pump();
      expect(find.text('This offer has expired. Ask the venue for a new one.'), findsOneWidget);
      expect(site.forRpc('hire_workspace').length, greaterThanOrEqualTo(2));
    });

    testWidgets('an agreement says plainly it is not a booking yet, and lists what is pending', (tester) async {
      await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted'), pending: ['The venue has not confirmed the date yet.']));
      expect(textOf(tester, 'hire-state-line'), 'Agreed, but the date is NOT booked until the venue confirms it.');
      expect(find.text('The agreed terms'), findsOneWidget);
      expect(find.text('Still pending'), findsOneWidget);
      expect(find.byKey(const Key('pending-The venue has not confirmed the date yet.')), findsOneWidget);
      expect(find.byKey(const Key('hire-cancel')), findsOneWidget);
      expect(find.byKey(const Key('link-event')), findsNothing, reason: 'an event is linked once the venue has confirmed');
      expect(find.byKey(const Key('attach-booking')), findsNothing);
    });

    testWidgets('nothing is pending says so', (tester) async {
      await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted')));
      expect(find.byKey(const Key('pending-none')), findsOneWidget);
    });

    testWidgets('cancelling says nothing was paid through BottlesUp, asks first, and sends the reason', (tester) async {
      site.rpcs['hire_cancel'] = (_) => ok(hireRow(state: 'cancelled'));
      await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted')));
      await tap(tester, 'hire-cancel');
      await tester.pumpAndSettle();
      expect(textOf(tester, 'cancel-intro'), contains('Nothing was paid through BottlesUp'));
      await tap(tester, 'cancel-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('hire_cancel'), isEmpty);
      await tap(tester, 'hire-cancel');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('cancel-reason')), ' Headliner dropped out ');
      await tap(tester, 'cancel-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_cancel').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_reason': 'Headliner dropped out'});
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('The hire is cancelled.'), findsOneWidget);
    });

    testWidgets('a hire whose day has come or passed cannot be cancelled', (tester) async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow(state: 'confirmed', date: iso(now), offer: hireOfferRow(status: 'accepted')), open: true));
      await open(tester, '/hires/hr1?as=grp', overrides: asGroup);
      expect(find.byKey(const Key('hire-cancel')), findsNothing);
    });

    testWidgets('says how it ended', (tester) async {
      await openHire(tester, ws('cancelled', cancelledBy: 'venue', cancelReason: 'Flood in the cellar'));
      expect(textOf(tester, 'hire-cancel-note'), 'Cancelled by the other side: Flood in the cellar');
      await tester.pumpWidget(const SizedBox());
      await openHire(tester, ws('cancelled', cancelledBy: 'organizer'));
      expect(textOf(tester, 'hire-cancel-note'), 'Cancelled by you');
      await tester.pumpWidget(const SizedBox());
      await openHire(tester, ws('declined', declineNote: 'Booked out that weekend'));
      expect(textOf(tester, 'hire-decline-note'), 'Note: Booked out that weekend');
      expect(find.byKey(const Key('hire-withdraw')), findsNothing);
    });

    testWidgets('a night that has passed is done, and its workspace is read-only', (tester) async {
      await openHire(tester, ws('completed', offer: hireOfferRow(status: 'accepted'), open: false, items: [hireItemRow(), hireItemRow(id: 'it2', kind: 'schedule', title: 'Doors open', at: '21:00')]));
      expect(textOf(tester, 'hire-state-line'), 'The night has passed.');
      expect(find.byKey(const Key('add-task')), findsNothing);
      expect(find.byKey(const Key('add-schedule')), findsNothing);
      expect(find.byKey(const Key('remove-it1')), findsNothing);
      expect(tester.widget<Checkbox>(find.byKey(const Key('tick-it1'))).onChanged, isNull);
    });

    group('the workspace', () {
      testWidgets('shows the schedule with times and the tasks with who added them and when they are due', (tester) async {
        await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted'), items: [
          hireItemRow(id: 's1', kind: 'schedule', title: 'Doors open', at: '21:00', side: 'venue'),
          hireItemRow(id: 't1', title: 'Send the lineup', due: '2099-11-01'),
          hireItemRow(id: 't2', title: 'Check the lights', done: true, side: 'venue'),
        ]));
        expect(find.text('9:00 PM  Doors open'), findsOneWidget);
        expect(find.descendant(of: find.byKey(const Key('item-s1')), matching: find.text('The venue')), findsOneWidget);
        expect(find.descendant(of: find.byKey(const Key('item-t1')), matching: find.textContaining('The group · due')), findsOneWidget);
        expect(tester.widget<Checkbox>(find.byKey(const Key('tick-t2'))).value, isTrue);
        expect(tester.widget<Checkbox>(find.byKey(const Key('tick-t1'))).value, isFalse);
        expect(find.byKey(const Key('tick-s1')), findsNothing, reason: 'a schedule line is not ticked off');
        expect(find.byKey(const Key('schedule-none')), findsNothing);
        expect(find.byKey(const Key('tasks-none')), findsNothing);
      });

      testWidgets('says when there is nothing scheduled or no task', (tester) async {
        await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted')));
        expect(find.byKey(const Key('schedule-none')), findsOneWidget);
        expect(find.byKey(const Key('tasks-none')), findsOneWidget);
        expect(find.byKey(const Key('lineup-none')), findsOneWidget);
        expect(find.byKey(const Key('event-none')), findsOneWidget);
      });

      testWidgets('adds a task with its day, and a schedule item with its time', (tester) async {
        site.rpcs['hire_item_add'] = (_) => ok(hireItemRow());
        await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted')), overrides: [...picking(soon), timePickerProvider.overrideWithValue((context, {required initial}) async => const TimeOfDay(hour: 21, minute: 30))]);
        await tap(tester, 'add-task');
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('item-title')), ' Send the lineup ');
        await tap(tester, 'item-due');
        await settleCalls(tester);
        await tap(tester, 'item-add');
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('hire_item_add').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_kind': 'task', 'p_title': 'Send the lineup', 'p_at': null, 'p_due': iso(soon)});
        await tap(tester, 'add-schedule');
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('item-title')), 'Doors open');
        await tap(tester, 'item-time');
        await settleCalls(tester);
        expect(find.text('9:30 PM'), findsOneWidget);
        await tap(tester, 'item-add');
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('hire_item_add').last.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_kind': 'schedule', 'p_title': 'Doors open', 'p_at': '21:30', 'p_due': null});
      });

      testWidgets('says what is wrong with an item before sending it', (tester) async {
        await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted')));
        await tap(tester, 'add-schedule');
        await tester.pumpAndSettle();
        await tap(tester, 'item-add');
        expect(find.text('Give it a title of 2 to 120 characters.'), findsOneWidget);
        await tester.enterText(find.byKey(const Key('item-title')), 'Doors open');
        await tap(tester, 'item-add');
        expect(find.text('Say what time it is.'), findsOneWidget);
        await tap(tester, 'item-cancel');
        await tester.pumpAndSettle();
        expect(site.forRpc('hire_item_add'), isEmpty);
      });

      testWidgets('ticks a task off and removes an item', (tester) async {
        site.rpcs['hire_item_set'] = (_) => ok(hireItemRow(done: true));
        site.rpcs['hire_item_remove'] = (_) => ok(null);
        await openHire(tester, ws('agreed', offer: hireOfferRow(status: 'accepted'), items: [hireItemRow(), hireItemRow(id: 's1', kind: 'schedule', title: 'Doors open', at: '21:00')]));
        await tap(tester, 'tick-it1');
        await settleCalls(tester);
        expect(site.forRpc('hire_item_set').single.body, {'p_actor': 'grp', 'p_item': 'it1', 'p_title': null, 'p_done': true});
        await tap(tester, 'remove-s1');
        await settleCalls(tester);
        expect(site.forRpc('hire_item_remove').single.body, {'p_actor': 'grp', 'p_item': 's1'});
      });

      testWidgets('the lineup shows who is confirmed and who is not, and a professional can be taken off', (tester) async {
        site.rpcs['hire_detach_booking'] = (_) => ok(null);
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted'), bookings: [lineupRow(), lineupRow(id: 'pb2', title: 'Photos', confirmed: true, state: 'paid')]));
        expect(find.descendant(of: find.byKey(const Key('lineup-pb1')), matching: find.text('Not confirmed yet')), findsOneWidget);
        expect(find.descendant(of: find.byKey(const Key('lineup-pb2')), matching: find.text('Confirmed: their deposit is in')), findsOneWidget);
        await tap(tester, 'detach-pb1');
        await settleCalls(tester);
        expect(site.forRpc('hire_detach_booking').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_booking': 'pb1'});
      });

      testWidgets('attaches a booking made for that day, offering only what is not attached already', (tester) async {
        site.rpcs['pro_requests_mine'] = (_) => ok([
              proRequestRow(id: 'r1', status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(id: 'pb7', date: '2099-11-08', state: 'confirmed', paid: 30000)),
              proRequestRow(id: 'r2', status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(id: 'pb1', date: '2099-11-08', state: 'confirmed', paid: 30000)),
              proRequestRow(id: 'r3', status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(id: 'pb8', date: '2099-11-09', state: 'confirmed')),
              proRequestRow(id: 'r4', status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow(id: 'pb9', date: '2099-11-08', state: 'cancelled')),
              proRequestRow(id: 'r5'),
            ]);
        site.rpcs['hire_attach_booking'] = (_) => ok({'attached': true});
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted'), bookings: [lineupRow()]));
        await tap(tester, 'attach-booking');
        await settleCalls(tester);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('attach-pb7')), findsOneWidget);
        for (final k in ['attach-pb1', 'attach-pb8', 'attach-pb9']) {
          expect(find.byKey(Key(k)), findsNothing, reason: k);
        }
        await tester.tap(find.byKey(const Key('attach-pb7')));
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('hire_attach_booking').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_booking': 'pb7'});
        await tester.pump(const Duration(milliseconds: 600));
        expect(find.text('Added to the lineup.'), findsOneWidget);
      });

      testWidgets('says there is nothing to attach when no professional is booked that day', (tester) async {
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted')));
        await tap(tester, 'attach-booking');
        await settleCalls(tester);
        await tester.pumpAndSettle();
        expect(find.textContaining('no booking with a professional for'), findsOneWidget);
        expect(find.byKey(const Key('attach-sheet')), findsNothing);
      });

      testWidgets('links the public event the group runs, and shows its ticket numbers', (tester) async {
        site.rpcs['hire_events_linkable'] = (_) => ok([
              {'id': 'ev1', 'title': 'Themed night', 'start_date': '2099-11-08T21:00:00Z'},
              {'id': 'ev2', 'title': 'Another night', 'start_date': '2099-11-08T22:00:00Z'}
            ]);
        site.rpcs['hire_link_event'] = (_) => ok(hireRow(state: 'confirmed', eventId: 'ev1'));
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted')));
        await tap(tester, 'link-event');
        await tester.pumpAndSettle();
        expect(site.forRpc('hire_events_linkable').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
        await tester.tap(find.byKey(const Key('link-ev1')));
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('hire_link_event').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_event': 'ev1'});
      });

      testWidgets('says when there is no event to link', (tester) async {
        site.rpcs['hire_events_linkable'] = (_) => ok(<Object>[]);
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted')));
        await tap(tester, 'link-event');
        await settleCalls(tester);
        await tester.pumpAndSettle();
        expect(find.textContaining('no published event near this day'), findsOneWidget);
        expect(find.byKey(const Key('link-sheet')), findsNothing);
      });

      testWidgets('shows the linked event and unlinks it', (tester) async {
        site.rpcs['hire_unlink_event'] = (_) => ok(hireRow(state: 'confirmed'));
        await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted'), event: linkedEventRow()));
        expect(find.descendant(of: find.byKey(const Key('linked-event')), matching: find.text('Themed night')), findsOneWidget);
        expect(find.text('130 of 350 tickets sold'), findsOneWidget);
        expect(find.byKey(const Key('link-event')), findsNothing);
        await tap(tester, 'unlink-event');
        await settleCalls(tester);
        expect(site.forRpc('hire_unlink_event').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
      });

      testWidgets('opens the chats as the profile that is in them', (tester) async {
        site.rpcs['dm_conversation'] = (_) => ok({'id': 'c1', 'kind': 'group', 'title': 'Hire: Club X', 'members': <Object>[]});
        site.rpcs['dm_messages'] = (_) => ok(<Object>[]);
        final router = await openHire(tester, ws('confirmed', offer: hireOfferRow(status: 'accepted'), hireChat: 'c1', eventChat: 'c2'));
        expect(find.text('Message the venue'), findsOneWidget);
        expect(find.byKey(const Key('hire-open-event-chat')), findsOneWidget);
        await tap(tester, 'hire-open-chat');
        await tester.pumpAndSettle();
        expect(path(router), '/inbox/c1');
      });

      testWidgets('has no chat buttons before there are chats', (tester) async {
        await openHire(tester, ws('requested'));
        expect(find.byKey(const Key('hire-open-chat')), findsNothing);
        expect(find.byKey(const Key('hire-open-event-chat')), findsNothing);
      });
    });

    testWidgets('says why a hire cannot be opened, and tries again', (tester) async {
      var fail = true;
      site.rpcs['hire_workspace'] = (_) => fail ? raised('This hire is not available.') : ok(ws('requested'));
      await open(tester, '/hires/hr1?as=grp', overrides: asGroup);
      expect(find.text('This hire is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('hire-detail')), findsOneWidget);
    });

    testWidgets('without a profile to open it as, it asks the person to choose one', (tester) async {
      site.rpcs['profile_my_profiles'] = (_) => ok(<Object>[]);
      await open(tester, '/hires/hr1');
      expect(find.byKey(const Key('hire-detail')), findsNothing);
    });
  });

  group('a hire, from the venue\'s side', () {
    final asker = {'name': 'Gus Group', 'handle': 'gus'};

    Future<GoRouter> openHire(WidgetTester tester, String state, {Map<String, dynamic>? offer, List<Map<String, dynamic>> items = const [], bool isOpen = false, String? hireChat, String? eventChat}) async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(state: state, asker: asker, offer: offer), open: isOpen, items: items, hireChat: hireChat, eventChat: eventChat));
      return open(tester, '/hires/hr1?as=club', overrides: asClub);
    }

    testWidgets('a request shows who asked and offers to make an offer or decline, nothing else', (tester) async {
      await openHire(tester, 'requested');
      expect(textOf(tester, 'hire-who'), 'From EONICS');
      expect(find.text('Gus Group'), findsOneWidget);
      expect(textOf(tester, 'hire-state-line'), 'This is a request. Make an offer or decline.');
      expect(find.widgetWithText(FilledButton, 'Make an offer'), findsOneWidget);
      expect(find.byKey(const Key('hire-decline')), findsOneWidget);
      expect([for (final k in ['hire-agree', 'hire-withdraw', 'hire-turn-down', 'hire-confirm', 'hire-take-back', 'hire-cancel']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0, 0, 0]);
      expect(find.descendant(of: find.byKey(const Key('hire-chip-hr1')), matching: find.text('Needs your offer')), findsOneWidget);
    });

    testWidgets('an offer is made from a sheet that says what is wrong before sending', (tester) async {
      await openHire(tester, 'requested');
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      await tap(tester, 'offer-send');
      expect(textOf(tester, 'offer-problem'), 'Choose a rental cost between 0 and 1,000,000.00.');
      await type(tester, 'offer-rental', '4500');
      await type(tester, 'offer-deposit', '5000');
      await tap(tester, 'offer-send');
      expect(textOf(tester, 'offer-problem'), 'The deposit cannot be more than the rental cost.');
      await type(tester, 'offer-deposit', '1000');
      await type(tester, 'offer-bar', 'lots');
      await tap(tester, 'offer-send');
      expect(textOf(tester, 'offer-problem'), 'Choose a bar share between 0% and 100%.');
      await type(tester, 'offer-bar', '20');
      await type(tester, 'offer-sales', 'x');
      await tap(tester, 'offer-send');
      expect(textOf(tester, 'offer-problem'), 'Choose a minimum sales figure between 0 and 1,000,000.00.');
      expect(site.forRpc('hire_offer_send'), isEmpty);
    });

    testWidgets('sends the terms as typed, with the days it stays open', (tester) async {
      site.rpcs['hire_offer_send'] = (_) => ok(hireRow(state: 'offered', asker: asker, offer: hireOfferRow()));
      await openHire(tester, 'requested');
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('offer-staffing'))).controller!.text, 'Two bartenders', reason: 'it starts from what the group asked for');
      expect(tester.widget<TextField>(find.byKey(const Key('offer-equipment'))).controller!.text, 'Own DJ booth');
      await type(tester, 'offer-rental', '4500');
      await type(tester, 'offer-deposit', '1000');
      await type(tester, 'offer-sales', '3000');
      await type(tester, 'offer-bar', '12.5');
      await tester.ensureVisible(find.byKey(const Key('offer-control')));
      await tester.tap(find.byKey(const Key('offer-control')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Shared').last);
      await tester.pumpAndSettle();
      await type(tester, 'offer-cancellation', ' Lose the deposit within 14 days ');
      await tester.ensureVisible(find.byKey(const Key('offer-days')));
      await tester.tap(find.byKey(const Key('offer-days')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 days').last);
      await tester.pumpAndSettle();
      await tap(tester, 'offer-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_offer_send').single.body, {
        'p_actor': 'club',
        'p_hire': 'hr1',
        'p_rental_cents': 450000,
        'p_deposit_cents': 100000,
        'p_min_sales_cents': 300000,
        'p_bar_share_bps': 1250,
        'p_control': 'shared',
        'p_staffing': 'Two bartenders',
        'p_equipment': 'Own DJ booth',
        'p_cancellation': 'Lose the deposit within 14 days',
        'p_notes': null,
        'p_valid_days': 3,
      });
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Your offer was sent.'), findsOneWidget);
    });

    testWidgets('an offer with no deposit, sales or share sends zeros', (tester) async {
      site.rpcs['hire_offer_send'] = (_) => ok(hireRow(state: 'offered', asker: asker, offer: hireOfferRow()));
      await openHire(tester, 'requested');
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      await type(tester, 'offer-rental', '1000');
      await tap(tester, 'offer-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final sent = site.forRpc('hire_offer_send').single.body;
      expect([sent['p_deposit_cents'], sent['p_min_sales_cents'], sent['p_bar_share_bps'], sent['p_control'], sent['p_valid_days']], [0, 0, 0, 'venue', 7]);
    });

    testWidgets('a refusal stays in the sheet, and the sheet stays open', (tester) async {
      site.rpcs['hire_offer_send'] = (_) => raised('This request is no longer open.');
      await openHire(tester, 'requested');
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      await type(tester, 'offer-rental', '1000');
      await tap(tester, 'offer-send');
      await settleCalls(tester);
      expect(textOf(tester, 'offer-problem'), 'This request is no longer open.');
      expect(tester.widget<FilledButton>(find.byKey(const Key('offer-send'))).onPressed, isNotNull);
    });

    testWidgets('a double tap on Send sends one offer', (tester) async {
      site.rpcs['hire_offer_send'] = (_) => ok(hireRow(state: 'offered', asker: asker, offer: hireOfferRow()));
      await openHire(tester, 'requested');
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      await type(tester, 'offer-rental', '1000');
      await tester.ensureVisible(find.byKey(const Key('offer-send')));
      await tester.tap(find.byKey(const Key('offer-send')));
      await tester.tap(find.byKey(const Key('offer-send')), warnIfMissed: false);
      await settleCalls(tester);
      expect(site.forRpc('hire_offer_send').length, 1);
    });

    testWidgets('an offer made can be changed, starting from what was offered, or taken back', (tester) async {
      site.rpcs['hire_offer_withdraw'] = (_) => ok(hireRow(asker: asker));
      await openHire(tester, 'offered', offer: hireOfferRow());
      expect(textOf(tester, 'hire-state-line'), 'You made an offer. The group has not answered yet.');
      expect(find.widgetWithText(FilledButton, 'Change the offer'), findsOneWidget);
      await tap(tester, 'hire-offer-button');
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('offer-rental'))).controller!.text, '4500.00');
      expect(tester.widget<TextField>(find.byKey(const Key('offer-deposit'))).controller!.text, '1000.00');
      expect(tester.widget<TextField>(find.byKey(const Key('offer-sales'))).controller!.text, '3000.00');
      expect(tester.widget<TextField>(find.byKey(const Key('offer-bar'))).controller!.text, '20');
      expect(tester.widget<TextField>(find.byKey(const Key('offer-cancellation'))).controller!.text, 'Lose the deposit within 14 days');
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await tap(tester, 'hire-take-back');
      await settleCalls(tester);
      expect(site.forRpc('hire_offer_withdraw').single.body, {'p_actor': 'club', 'p_hire': 'hr1'});
    });

    testWidgets('an offer that ran out can be made again', (tester) async {
      await openHire(tester, 'offer_expired', offer: hireOfferRow(status: 'expired'));
      expect(find.widgetWithText(FilledButton, 'Change the offer'), findsOneWidget);
      expect(find.byKey(const Key('hire-take-back')), findsNothing);
      expect(find.descendant(of: find.byKey(const Key('hire-chip-hr1')), matching: find.text('Your offer ran out')), findsOneWidget);
    });

    testWidgets('declining asks for a note and sends it, or nothing', (tester) async {
      site.rpcs['hire_decline'] = (_) => ok(hireRow(state: 'declined', asker: asker));
      await openHire(tester, 'requested');
      await tap(tester, 'hire-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'decline-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('hire_decline'), isEmpty);
      await tap(tester, 'hire-decline');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('decline-note')), ' Booked out that weekend ');
      await tap(tester, 'decline-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_decline').single.body, {'p_actor': 'club', 'p_hire': 'hr1', 'p_note': 'Booked out that weekend'});
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('The request is declined.'), findsOneWidget);
    });

    testWidgets('declining without a note sends none', (tester) async {
      site.rpcs['hire_decline'] = (_) => ok(hireRow(state: 'declined', asker: asker));
      await openHire(tester, 'requested');
      await tap(tester, 'hire-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'decline-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_decline').single.body['p_note'], null);
    });

    testWidgets('an agreement is confirmed after a question that says only now is it booked', (tester) async {
      site.rpcs['hire_confirm'] = (_) => ok(hireRow(state: 'confirmed', asker: asker));
      await openHire(tester, 'agreed', offer: hireOfferRow(status: 'accepted'), isOpen: true);
      expect(textOf(tester, 'hire-state-line'), 'Agreed, but the date is NOT booked until the venue confirms it.');
      expect(find.descendant(of: find.byKey(const Key('hire-chip-hr1')), matching: find.text('Agreed: confirm the date')), findsOneWidget);
      expect(find.byKey(const Key('hire-offer-button')), findsNothing);
      await tap(tester, 'hire-confirm');
      await tester.pumpAndSettle();
      expect(find.textContaining('Only now is it a booked hire'), findsOneWidget);
      await tap(tester, 'ask-no');
      await tester.pumpAndSettle();
      expect(site.forRpc('hire_confirm'), isEmpty);
      await tap(tester, 'hire-confirm');
      await tester.pumpAndSettle();
      await tap(tester, 'ask-yes');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_confirm').single.body, {'p_actor': 'club', 'p_hire': 'hr1'});
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('The date is confirmed.'), findsOneWidget);
    });

    testWidgets('a refusal to confirm is shown as it came', (tester) async {
      site.rpcs['hire_confirm'] = (_) => raised('This venue is already booked for a hire that day.');
      await openHire(tester, 'agreed', offer: hireOfferRow(status: 'accepted'), isOpen: true);
      await tap(tester, 'hire-confirm');
      await tester.pumpAndSettle();
      await tap(tester, 'ask-yes');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      await tester.pump();
      expect(find.text('This venue is already booked for a hire that day.'), findsOneWidget);
    });

    testWidgets('a confirmed hire can be cancelled by the venue, who adds to the workspace but cannot attach or link', (tester) async {
      site.rpcs['hire_cancel'] = (_) => ok(hireRow(state: 'cancelled', asker: asker));
      site.rpcs['hire_item_add'] = (_) => ok(hireItemRow(kind: 'schedule', title: 'Doors open', at: '21:00', side: 'venue'));
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(state: 'confirmed', asker: asker, offer: hireOfferRow(status: 'accepted')), open: true, eventChat: 'c2'));
      await open(tester, '/hires/hr1?as=club', overrides: [...asClub, timePickerProvider.overrideWithValue((context, {required initial}) async => const TimeOfDay(hour: 21, minute: 0))]);
      expect([for (final k in ['attach-booking', 'link-event', 'unlink-event']) find.byKey(Key(k)).evaluate().length], [0, 0, 0]);
      expect(find.text('Message the group'), findsNothing, reason: 'there is no hire chat in this fixture');
      expect(find.byKey(const Key('hire-open-event-chat')), findsOneWidget);
      await tap(tester, 'add-schedule');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('item-title')), 'Doors open');
      await tap(tester, 'item-time');
      await settleCalls(tester);
      await tap(tester, 'item-add');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_item_add').single.body['p_actor'], 'club');
      await tap(tester, 'hire-cancel');
      await tester.pumpAndSettle();
      await tap(tester, 'cancel-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('hire_cancel').single.body, {'p_actor': 'club', 'p_hire': 'hr1', 'p_reason': null});
    });

    testWidgets('the venue\'s chat button talks to the group', (tester) async {
      await openHire(tester, 'confirmed', offer: hireOfferRow(status: 'accepted'), isOpen: true, hireChat: 'c1');
      expect(find.text('Message the group'), findsOneWidget);
    });

    testWidgets('the venue sees what the group has attached, without money', (tester) async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(state: 'confirmed', asker: asker, offer: hireOfferRow(status: 'accepted')), open: true, bookings: [lineupRow(confirmed: true, state: 'paid')]));
      await open(tester, '/hires/hr1?as=club', overrides: asClub);
      expect(find.descendant(of: find.byKey(const Key('lineup-pb1')), matching: find.text('Confirmed: their deposit is in')), findsOneWidget);
      expect(find.byKey(const Key('detach-pb1')), findsNothing, reason: 'only the group takes a professional off');
      expect(find.byKey(const Key('attach-booking')), findsNothing);
    });

    testWidgets('a request the venue declined shows its note and nothing to press', (tester) async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: 'venue', hire: hireRow(state: 'declined', asker: asker, declineNote: 'Booked out'), open: false));
      await open(tester, '/hires/hr1?as=club', overrides: asClub);
      expect(textOf(tester, 'hire-decline-note'), 'Note: Booked out');
      expect([for (final k in ['hire-offer-button', 'hire-decline', 'hire-confirm', 'hire-cancel']) find.byKey(Key(k)).evaluate().length], [0, 0, 0, 0]);
    });
  });

  group('each side sees only its own buttons, and the page opens as the profile it is for', () {
    final asker = {'name': 'Gus Group', 'handle': 'gus'};
    ProviderContainer scope(WidgetTester tester) => ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

    Future<void> openAs(WidgetTester tester, String side, String state, {Map<String, dynamic>? offer, List<Map<String, dynamic>> items = const [], Map<String, dynamic>? event, String? hireChat, bool isOpen = true, List<Override> overrides = const []}) async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(side: side, hire: hireRow(state: state, asker: asker, offer: offer, eventId: event == null ? null : 'ev1'), open: isOpen, items: items, event: event, hireChat: hireChat));
      await open(tester, '/hires/hr1?as=${side == 'venue' ? 'club' : 'grp'}', overrides: overrides);
    }

    int count(List<String> keys) => keys.fold(0, (n, k) => n + find.byKey(Key(k)).evaluate().length);

    testWidgets('the group is shown the offer to answer, never the venue\'s buttons or who asked', (tester) async {
      await openAs(tester, 'organizer', 'offered', offer: hireOfferRow(), isOpen: false);
      expect(find.byKey(const Key('hire-agree')), findsOneWidget);
      expect(find.byKey(const Key('hire-turn-down')), findsOneWidget);
      expect(count(['hire-take-back', 'hire-offer-button', 'hire-decline', 'hire-confirm']), 0);
      expect(find.text('Asked by'), findsNothing);
    });

    testWidgets('the venue is shown its offer to take back and who asked, never the group\'s buttons', (tester) async {
      await openAs(tester, 'venue', 'offered', offer: hireOfferRow(), isOpen: false);
      expect(find.byKey(const Key('hire-take-back')), findsOneWidget);
      expect(find.text('Asked by'), findsOneWidget);
      expect(find.text('Gus Group'), findsOneWidget);
      expect(count(['hire-agree', 'hire-turn-down', 'hire-withdraw']), 0);
    });

    testWidgets('an agreement is confirmed by the venue only, and cancelled by either', (tester) async {
      await openAs(tester, 'organizer', 'agreed', offer: hireOfferRow(status: 'accepted'));
      expect(find.byKey(const Key('hire-confirm')), findsNothing);
      expect(find.byKey(const Key('hire-cancel')), findsOneWidget);
    });

    testWidgets('the venue confirms an agreement', (tester) async {
      await openAs(tester, 'venue', 'agreed', offer: hireOfferRow(status: 'accepted'));
      expect(find.byKey(const Key('hire-confirm')), findsOneWidget);
      expect(find.byKey(const Key('hire-cancel')), findsOneWidget);
    });

    testWidgets('the linked event cannot be unlinked by the venue', (tester) async {
      await openAs(tester, 'venue', 'confirmed', offer: hireOfferRow(status: 'accepted'), event: linkedEventRow());
      expect(find.byKey(const Key('linked-event')), findsOneWidget);
      expect(find.byKey(const Key('unlink-event')), findsNothing);
    });

    testWidgets('a task that is done is struck through, one that is not is not', (tester) async {
      await openAs(tester, 'organizer', 'agreed', offer: hireOfferRow(status: 'accepted'), items: [hireItemRow(done: true), hireItemRow(id: 'it2', title: 'Book the sound')]);
      expect(tester.widget<Text>(find.text('Send the lineup')).style?.decoration, TextDecoration.lineThrough);
      expect(tester.widget<Text>(find.text('Book the sound')).style?.decoration, isNot(TextDecoration.lineThrough));
    });

    testWidgets('a chat opens as the profile the page is for', (tester) async {
      site.rpcs['dm_conversation'] = (_) => ok({'id': 'c1', 'kind': 'group', 'title': 'Hire: Club X', 'members': <Object>[]});
      site.rpcs['dm_messages'] = (_) => ok(<Object>[]);
      await openAs(tester, 'organizer', 'confirmed', offer: hireOfferRow(status: 'accepted'), hireChat: 'c1');
      expect(scope(tester).read(selectedProfileIdProvider), isNull, reason: 'the person is acting as themselves until the chat opens');
      await tap(tester, 'hire-open-chat');
      await tester.pumpAndSettle();
      expect(scope(tester).read(selectedProfileIdProvider), 'grp');
    });

    testWidgets('a double tap on Withdraw withdraws once', (tester) async {
      site.rpcs['hire_withdraw'] = (_) => ok(hireRow(state: 'withdrawn'));
      await openAs(tester, 'organizer', 'requested', isOpen: false);
      await tester.ensureVisible(find.byKey(const Key('hire-withdraw')));
      await tester.tap(find.byKey(const Key('hire-withdraw')));
      await tester.tap(find.byKey(const Key('hire-withdraw')));
      await settleCalls(tester);
      expect(site.forRpc('hire_withdraw').length, 1);
    });

    testWidgets('after a request is sent the group\'s hires are read again', (tester) async {
      site.rpcs['hire_request'] = (_) => ok(hireRow());
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(hire: hireRow()));
      site.rpcs['hires_mine'] = (_) => ok(<Object>[]);
      await open(tester, '/venues/club/host', overrides: [...asGroup, ...picking(soon)]);
      scope(tester).listen(hiresMineProvider('grp'), (_, __) {}, fireImmediately: true);
      await settleCalls(tester);
      final before = site.forRpc('hires_mine').length;
      expect(before, 1);
      await tap(tester, 'hire-date');
      await settleCalls(tester);
      await type(tester, 'hire-type', 'Themed night');
      await tap(tester, 'hire-send');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forRpc('hires_mine').length, greaterThan(before));
    });
  });

  group('who counts as a group or a venue', () {
    SocialProfile profile(Map<String, dynamic> row) => parseSocialProfile(row)!;

    test('a group is an event group or a promoter that is a business and not suspended', () {
      expect(isOrganizerProfile(profile(groupProfile())), isTrue);
      expect(isOrganizerProfile(profile({...groupProfile(), 'category': 'promoter'})), isTrue);
      expect(isOrganizerProfile(profile({...groupProfile(), 'status': 'suspended'})), isFalse);
      expect(isOrganizerProfile(profile({...groupProfile(), 'category': 'dj'})), isFalse);
      expect(isOrganizerProfile(profile({...groupProfile(), 'kind': 'personal', 'category': null})), isFalse);
    });

    test('a venue is a venue that is a business and not suspended', () {
      expect(isVenueProfile(profile(clubProfile())), isTrue);
      expect(isVenueProfile(profile({...clubProfile(), 'status': 'suspended'})), isFalse);
      expect(isVenueProfile(profile({...clubProfile(), 'category': 'dj'})), isFalse);
      expect(isVenueProfile(profile({...clubProfile(), 'kind': 'personal', 'category': null})), isFalse);
    });
  });

  test('the hires are not asked for while hiring a venue is off', () async {
    final off = FakeWebsite();
    off.rpcs['site_features'] = (_) => ok({'social': true, 'marketplace': true});
    off.rpcs['hires_mine'] = (_) => ok([hireRow()]);
    off.rpcs['hires_for'] = (_) => ok([hireRow()]);
    final container = ProviderContainer(overrides: [siteClientProvider.overrideWithValue(off.client)]);
    addTearDown(container.dispose);
    await container.read(featuresProvider.future);
    expect(await container.read(hiresMineProvider('grp').future), isEmpty);
    expect(await container.read(hiresForProvider('club').future), isEmpty);
    expect(off.forRpc('hires_mine'), isEmpty);
    expect(off.forRpc('hires_for'), isEmpty);
  });

}
