import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;

  Future<void> open(WidgetTester tester, {void Function(BuildContext, SiteEvent, TicketTier)? onBuy, Future<void> Function(String)? share, String id = 'e1'}) =>
      pumpSite(tester, EventPageScreen(eventId: id, onBuy: onBuy, share: share), site: site);

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
}
