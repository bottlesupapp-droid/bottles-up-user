import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  setUp(() {
    site = FakeWebsite();
    site.tables['site_events'] = [
      eventRow(id: 'e1', title: 'Friday Night', start: '2099-10-24T23:00:00Z', tiers: [tierRow(id: 't1', eventId: 'e1', price: 5000)], category: 'Nightlife'),
      eventRow(id: 'e2', title: 'Free Brunch', start: '2099-11-14T16:00:00Z', end: '2099-11-14T20:00:00Z', tiers: [tierRow(id: 't2', eventId: 'e2', price: 0)], category: 'Brunch'),
      eventRow(id: 'e3', title: 'Sold Out Gala', start: '2099-11-20T23:00:00Z', tiers: [tierRow(id: 't3', eventId: 'e3', price: 2000, capacity: 5, sold: 5)], category: 'Nightlife'),
    ];
    site.tables['site_venues'] = [venueRow(id: 'v1', name: 'Club A'), venueRow(id: 'v2', name: 'Rooftop')];
    site.rpcs['explore_hot_venues'] = (_) => ok([{'id': 'v2', 'score': 9}, {'id': 'v1', 'score': 3}, {'id': 'gone', 'score': 1}]);
    site.rpcs['explore_hot_events'] = (_) => ok([{'id': 'e2', 'score': 7}]);
  });

  const on = {'social': true};

  Future<void> open(WidgetTester tester, {List<Map<String, dynamic>>? mine}) => openSocial(tester, site, '/explore', features: on, mine: mine).then((_) {});

  testWidgets('shows what is hot, in the order the website gave, skipping what is not loaded', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('hot-venues-heading')), findsOneWidget);
    final first = tester.getTopLeft(find.byKey(const Key('hot-venue-v2'))).dx;
    final second = tester.getTopLeft(find.byKey(const Key('hot-venue-v1'))).dx;
    expect(first, lessThan(second));
    expect(find.byKey(const Key('hot-event-e2')), findsOneWidget);
    expect(find.text('Rooftop'), findsWidgets);
  });

  testWidgets('nothing hot: no empty headings', (tester) async {
    site.rpcs['explore_hot_venues'] = (_) => ok(<Object>[]);
    site.rpcs['explore_hot_events'] = (_) => (status: 500, body: {'message': 'boom'});
    await open(tester);
    expect(find.byKey(const Key('hot-venues-heading')), findsNothing);
    expect(find.byKey(const Key('hot-events-heading')), findsNothing);
    expect(find.byKey(const Key('event-e1')), findsOneWidget, reason: 'events still list');
  });

  testWidgets('narrowing events by price, tickets left, category and when', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('explore-page')).first);
    for (final id in ['e1', 'e2', 'e3']) {
      await tester.scrollUntilVisible(find.byKey(Key('event-$id')), 300, scrollable: find.byType(Scrollable).last);
      expect(find.byKey(Key('event-$id')), findsOneWidget);
    }
    await tester.scrollUntilVisible(find.byKey(const Key('price-free')), -300, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.byKey(const Key('price-free')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
    expect(find.byKey(const Key('event-e1')), findsNothing);
    await tester.tap(find.byKey(const Key('price-any')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('only-available')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-e3')), findsNothing);
    expect(find.byKey(const Key('event-e1')), findsOneWidget);
    await tester.tap(find.byKey(const Key('category-Brunch')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
    expect(find.byKey(const Key('event-e1')), findsNothing);
    await tester.tap(find.byKey(const Key('category-Brunch')));
    await tester.tap(find.byKey(const Key('when-tonight')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('no-matching-events')), findsOneWidget, reason: 'the real clock is not 2099, so nothing is tonight');
  });

  testWidgets('a search finds events, venues and people together', (tester) async {
    site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'p1', handle: 'roofer', name: 'Roof Fan')]);
    await open(tester);
    await tester.enterText(find.byKey(const Key('explore-search')), 'roof');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('explore-results')), findsOneWidget);
    expect(find.byKey(const Key('venue-v2')), findsOneWidget);
    expect(find.byKey(const Key('venue-v1')), findsNothing);
    expect(find.byKey(const Key('profile-roofer')), findsOneWidget);
    expect(site.forRpc('profile_search').single.body, {'p_actor': 'me', 'p_query': 'roof', 'p_limit': 20});
  });

  testWidgets('an event found by its title', (tester) async {
    site.rpcs['profile_search'] = (_) => ok(<Object>[]);
    await open(tester);
    await tester.enterText(find.byKey(const Key('explore-search')), 'brunch');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
    expect(find.byKey(const Key('event-e1')), findsNothing);
  });

  testWidgets('one letter is not a search; nothing found says so', (tester) async {
    site.rpcs['profile_search'] = (_) => ok(<Object>[]);
    await open(tester);
    await tester.enterText(find.byKey(const Key('explore-search')), 'c');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('explore-page')), findsOneWidget);
    expect(site.forRpc('profile_search'), isEmpty);
    await tester.enterText(find.byKey(const Key('explore-search')), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('explore-nothing')), findsOneWidget);
  });

  testWidgets('without a profile the search still finds events and venues, and asks for no people', (tester) async {
    await open(tester, mine: const []);
    await tester.enterText(find.byKey(const Key('explore-search')), 'roof');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('venue-v2')), findsOneWidget);
    expect(site.forRpc('profile_search'), isEmpty);
  });

  testWidgets('clearing the search brings the page back', (tester) async {
    site.rpcs['profile_search'] = (_) => ok(<Object>[]);
    await open(tester);
    await tester.enterText(find.byKey(const Key('explore-search')), 'club');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('explore-clear')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('explore-page')), findsOneWidget);
  });

  testWidgets('the directory of professionals opens', (tester) async {
    site.rpcs['explore_professionals'] = (_) => ok(<Object>[]);
    final router = await openSocial(tester, site, '/explore', features: on);
    await tester.tap(find.byKey(const Key('open-professionals')));
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/explore/professionals');
  });

  testWidgets('a failed event list offers to try again', (tester) async {
    site.failTables.add('site_events');
    await open(tester);
    expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
  });
}
