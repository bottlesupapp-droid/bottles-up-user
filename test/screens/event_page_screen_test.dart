import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;

  Future<void> open(WidgetTester tester, {void Function(BuildContext, SiteEvent, TicketTier)? onBuy, void Function(BuildContext, SiteEvent)? onBookTable, Future<void> Function(String)? share, String id = 'e1'}) =>
      pumpSite(tester, EventPageScreen(eventId: id, onBuy: onBuy, onBookTable: onBookTable, share: share), site: site);

  setUp(() {
    site = FakeWebsite();
    site.tables['site_events'] = [
      eventRow(cover: null, tiers: [
        tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 20),
        tierRow(id: 't2', name: 'VIP entry', price: 12000, capacity: 20, sold: 17, code: true, nonTransferable: true),
        tierRow(id: 't3', name: 'Early bird', price: 3000, capacity: 50, sold: 50),
      ]),
    ];
  });

  testWidgets('shows what the event is: title, when, where, who is behind it, what it is, the line-up and what to know', (tester) async {
    await open(tester);
    expect(textOf(tester, 'event-title'), 'Friday Night');
    expect(textOf(tester, 'event-when'), formatWhen(parseWhen('2099-10-24T23:00:00Z')!));
    expect(textOf(tester, 'event-where'), 'Club A · 1 King St W, Toronto');
    expect(textOf(tester, 'event-by'), 'By Night Co (verified)');
    expect(textOf(tester, 'event-description'), 'A big night out.');
    expect(find.byKey(const Key('lineup-DJ One')), findsOneWidget);
    expect(find.byKey(const Key('lineup-DJ Two')), findsOneWidget);
    expect(find.text('19+'), findsOneWidget);
    expect(find.text('ID required'), findsOneWidget);
    expect(find.byKey(const Key('event-over')), findsNothing);
    final r = site.forTable('site_events').single;
    expect(r.query['id'], 'eq.e1');
  });

  testWidgets('lists the ticket types with their price and how many are left; sold out ones cannot be chosen', (tester) async {
    await open(tester);
    expect(textOf(tester, 'tier-price-t1'), formatPrice(5000, currency: 'cad'));
    expect(find.byKey(const Key('tier-scarcity-t1')), findsNothing);
    expect(textOf(tester, 'tier-scarcity-t2'), 'Only 3 left');
    expect(textOf(tester, 'tier-scarcity-t3'), 'Sold out');
    expect(find.text('Needs an access code'), findsOneWidget);
    expect(find.textContaining('Stays with the buyer'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tier-t3')));
    await tester.pump();
    expect(find.byKey(const Key('tier-selected')), findsNothing, reason: 'a sold out ticket type cannot be chosen');
  });

  testWidgets('the button waits for a choice, then names the price, and opens the purchase for the chosen type', (tester) async {
    SiteEvent? boughtEvent;
    TicketTier? boughtTier;
    await open(tester, onBuy: (c, e, t) {
      boughtEvent = e;
      boughtTier = t;
    });
    final button = find.byKey(const Key('get-tickets'));
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(find.text('Choose a ticket'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tier-t1')));
    await tester.pump();
    expect(find.byKey(const Key('tier-selected')), findsOneWidget);
    expect(find.text('Get tickets · ${formatPrice(5000, currency: 'cad')}'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tier-t2')));
    await tester.pump();
    expect(find.byKey(const Key('tier-selected')), findsOneWidget, reason: 'only one is chosen at a time');
    await tester.tap(button);
    expect([boughtEvent?.id, boughtTier?.id], ['e1', 't2']);
  });

  testWidgets('an event that is over cannot be bought for', (tester) async {
    site.tables['site_events'] = [eventRow(cover: null, start: '2020-01-01T20:00:00Z', end: '2020-01-02T02:00:00Z')];
    await open(tester);
    expect(find.byKey(const Key('event-over')), findsOneWidget);
    expect(find.byKey(const Key('get-tickets')), findsNothing);
    await tester.tap(find.byKey(const Key('tier-t1')));
    await tester.pump();
    expect(find.byKey(const Key('tier-selected')), findsNothing);
  });

  testWidgets('with no ticket types it says they are not on sale yet', (tester) async {
    site.tables['site_events'] = [eventRow(cover: null, tiers: const [])];
    await open(tester);
    expect(find.byKey(const Key('no-tickets')), findsOneWidget);
    expect(find.byKey(const Key('get-tickets')), findsNothing);
  });

  testWidgets('an event the website no longer has says so', (tester) async {
    site.tables['site_events'] = [];
    await open(tester);
    expect(find.text('This event is no longer available'), findsOneWidget);
    expect(find.byKey(const Key('event-share')), findsNothing);
  });

  testWidgets('if it cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.failAllWith = 500;
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load this event. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-page')), findsOneWidget);
  });

  testWidgets('sharing sends the event\'s name, time and its page on the website', (tester) async {
    String? shared;
    await open(tester, share: (t) async => shared = t);
    await tester.tap(find.byKey(const Key('event-share')));
    await tester.pump();
    expect(shared, allOf(contains('Friday Night'), contains(formatWhen(parseWhen('2099-10-24T23:00:00Z')!)), contains('/events/e1')));
    expect(shared, startsWith('Friday Night'));
    expect(shared!.contains('https://'), isTrue);
  });

  group('book a table from the event', () {
    testWidgets('offers a table at the event\'s venue and hands over the event (its venue and night)', (tester) async {
      SiteEvent? asked;
      await open(tester, onBookTable: (c, e) => asked = e);
      expect(find.text('Book a table at Club A'), findsOneWidget);
      await tester.tap(find.byKey(const Key('book-table')));
      expect([asked?.id, asked?.venueId], ['e1', 'v1']);
    });

    testWidgets('an event that is over offers no table', (tester) async {
      site.tables['site_events'] = [eventRow(cover: null, start: '2020-01-01T20:00:00Z', end: '2020-01-02T02:00:00Z')];
      await open(tester);
      expect(find.byKey(const Key('book-table')), findsNothing);
    });

    testWidgets('an event with no venue on the website offers no table', (tester) async {
      site.tables['site_events'] = [{...eventRow(cover: null), 'venue_id': null}];
      await open(tester);
      expect(find.byKey(const Key('book-table')), findsNothing);
    });
  });

  group('the organizer\'s sales window', () {
    String iso(Duration from) => DateTime.now().toUtc().add(from).toIso8601String();

    void seedWindows() {
      site.tables['site_events'] = [
        eventRow(cover: null, tiers: [
          tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 20),
          tierRow(id: 't2', name: 'Opens later', price: 4000, capacity: 100, sold: 0, saleStarts: iso(const Duration(days: 3))),
          tierRow(id: 't3', name: 'Closed', price: 3000, capacity: 100, sold: 0, saleEnds: iso(const Duration(days: -1))),
          tierRow(id: 't4', name: 'Open until later', price: 2000, capacity: 100, sold: 0, saleStarts: iso(const Duration(days: -1)), saleEnds: iso(const Duration(days: 2))),
        ]),
      ];
    }

    testWidgets('a type that opens later says when, a closed one says so, and neither can be chosen', (tester) async {
      seedWindows();
      await open(tester);

      expect(find.byKey(const Key('tier-sale-t1')), findsNothing, reason: 'a type with no dates says nothing');
      expect(textOf(tester, 'tier-sale-t2'), startsWith('On sale from '));
      expect(textOf(tester, 'tier-sale-t3'), 'Sales ended');
      expect(find.byKey(const Key('tier-sale-t4')), findsNothing, reason: 'inside its window it says nothing');

      await tester.tap(find.byKey(const Key('tier-t2')));
      await tester.pump();
      expect(find.byKey(const Key('tier-selected')), findsNothing, reason: 'sales have not opened');
      await tester.tap(find.byKey(const Key('tier-t3')));
      await tester.pump();
      expect(find.byKey(const Key('tier-selected')), findsNothing, reason: 'sales have ended');
      expect(tester.widget<FilledButton>(find.byKey(const Key('get-tickets'))).onPressed, isNull);

      final dim = Theme.of(tester.element(find.byKey(const Key('tier-t3')))).disabledColor;
      expect(tester.widget<Text>(find.text('Closed')).style?.color, dim, reason: 'a closed type is dimmed');
      expect(tester.widget<Text>(find.text('Opens later')).style?.color, dim, reason: 'one that has not opened is dimmed too');
      expect(tester.widget<Text>(find.text('Open until later')).style?.color, isNot(dim), reason: 'one on sale is not');

      await tester.tap(find.byKey(const Key('tier-t4')));
      await tester.pump();
      expect(find.byKey(const Key('tier-selected')), findsOneWidget, reason: 'inside its window it can be chosen');
      expect(find.text('Get tickets · ${formatPrice(2000, currency: 'cad')}'), findsOneWidget);
    });

    testWidgets('a type chosen while on sale stops being buyable the moment its sales end', (tester) async {
      final ends = DateTime.now().toUtc().add(const Duration(hours: 1));
      site.tables['site_events'] = [
        eventRow(cover: null, tiers: [tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 0, saleEnds: ends.toIso8601String())]),
      ];
      var now = DateTime.now();
      await withClock(Clock(() => now), () async {
        await open(tester);
        await tester.tap(find.byKey(const Key('tier-t1')));
        await tester.pump();
        expect(tester.widget<FilledButton>(find.byKey(const Key('get-tickets'))).onPressed, isNotNull);

        now = ends.toLocal();
        await tester.tap(find.byKey(const Key('tier-t1')), warnIfMissed: false);
        await tester.pump();
        expect(find.descendant(of: find.byKey(const Key('get-tickets')), matching: find.text('Sales ended')), findsOneWidget, reason: 'the button itself says why it is off');
        expect(tester.widget<FilledButton>(find.byKey(const Key('get-tickets'))).onPressed, isNull);
      });
    });
  });
}
