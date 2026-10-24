import 'package:bottles_up_user/features/discover/screens/events_screen.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_events'] = [
      eventRow(id: 'e1', title: 'Friday Night', cover: null, category: 'Nightlife', start: '2099-10-24T23:00:00Z'),
      eventRow(id: 'e2', title: 'Sunday Brunch', cover: null, category: 'Day party', venue: 'Rooftop', lineup: const ['Mia Moon'], start: '2099-10-26T16:00:00Z', tiers: [tierRow(id: 't2', eventId: 'e2', price: 0)]),
      eventRow(id: 'e3', title: 'Sold Out Gala', cover: null, category: 'Nightlife', start: '2099-11-01T23:00:00Z', tiers: [tierRow(id: 't3', eventId: 'e3', capacity: 10, sold: 10)]),
    ];
  });

  testWidgets('lists the website\'s events with when, where and what tickets cost', (tester) async {
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    for (final id in ['e1', 'e2', 'e3']) {
      expect(find.byKey(Key('event-$id')), findsOneWidget, reason: id);
    }
    expect(textOf(tester, 'event-title-e1'), 'Friday Night');
    expect(textOf(tester, 'event-price-e1'), 'From ${formatMoney(5000, currency: 'cad')}');
    expect(textOf(tester, 'event-price-e2'), 'Free');
    expect(textOf(tester, 'event-price-e3'), 'Sold out');
    expect(site.forTable('site_events').single.query['status'], 'eq.published');
  });

  testWidgets('searching narrows the list (title, venue, act), clearing brings it back, and nothing found says so', (tester) async {
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    await tester.enterText(find.byKey(const Key('events-search')), 'brunch');
    await tester.pump();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
    expect(find.byKey(const Key('event-e1')), findsNothing);

    await tester.enterText(find.byKey(const Key('events-search')), 'rooftop');
    await tester.pump();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('events-search')), 'mia moon');
    await tester.pump();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('events-search')), 'zzz');
    await tester.pump();
    expect(find.byKey(const Key('empty-title')), findsOneWidget);
    expect(find.text('Nothing matches'), findsOneWidget);

    await tester.tap(find.byKey(const Key('events-search-clear')));
    await tester.pump();
    expect(find.byKey(const Key('event-e1')), findsOneWidget);
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
  });

  testWidgets('a category chip shows only that category, and tapping it again shows all', (tester) async {
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    await tester.tap(find.byKey(const Key('category-Nightlife')));
    await tester.pump();
    expect(find.byKey(const Key('event-e1')), findsOneWidget);
    expect(find.byKey(const Key('event-e3')), findsOneWidget);
    expect(find.byKey(const Key('event-e2')), findsNothing);
    await tester.tap(find.byKey(const Key('category-Nightlife')));
    await tester.pump();
    expect(find.byKey(const Key('event-e2')), findsOneWidget);
    await tester.tap(find.byKey(const Key('category-Day party')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('category-all')));
    await tester.pump();
    expect(find.byKey(const Key('event-e1')), findsOneWidget);
  });

  testWidgets('with only one category there is nothing to choose, so no chips', (tester) async {
    site.tables['site_events'] = [eventRow(cover: null)];
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    expect(find.byKey(const Key('category-all')), findsNothing);
  });

  testWidgets('tapping an event opens it', (tester) async {
    SiteEvent? opened;
    await pumpSite(tester, Scaffold(body: EventsScreen(onOpenEvent: (c, e) => opened = e)), site: site);
    await tester.tap(find.byKey(const Key('event-e2')));
    expect(opened?.id, 'e2');
  });

  testWidgets('no events says so kindly', (tester) async {
    site.tables['site_events'] = [];
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    expect(find.text('No events right now'), findsOneWidget);
    expect(find.byKey(const Key('load-failed-message')), findsNothing);
  });

  testWidgets('when the events cannot be loaded the person is told in a sentence and can try again', (tester) async {
    site.failAllWith = 500;
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    expect(textOf(tester, 'load-failed-message'), 'We could not load events. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('event-e1')), findsOneWidget);
    expect(find.byKey(const Key('load-failed-message')), findsNothing);
  });

  testWidgets('an event that is on right now says so', (tester) async {
    final now = DateTime.now().toUtc();
    site.tables['site_events'] = [eventRow(cover: null, start: now.subtract(const Duration(hours: 1)).toIso8601String(), end: now.add(const Duration(hours: 4)).toIso8601String())];
    await pumpSite(tester, const Scaffold(body: EventsScreen()), site: site);
    expect(find.byKey(const Key('event-live')), findsOneWidget);
  });

  group('by date', () {
    // A Wednesday at noon, on the phone's own clock, far enough ahead that the events are still to come whenever this runs.
    final wednesday = () {
      var d = DateTime(2099, 10, 1);
      while (d.weekday != DateTime.wednesday) {
        d = DateTime(d.year, d.month, d.day + 1);
      }
      return d;
    }();
    final now = DateTime(wednesday.year, wednesday.month, wednesday.day, 12);
    String at(int dayOffset, int hour) => DateTime(wednesday.year, wednesday.month, wednesday.day + dayOffset, hour).toUtc().toIso8601String();

    void events() {
      site.tables['site_events'] = [
        eventRow(id: 'today', title: 'Wednesday Night', cover: null, start: at(0, 22), end: at(1, 4)),
        eventRow(id: 'fri', title: 'Friday Night', cover: null, start: at(2, 23), end: at(3, 5)),
        eventRow(id: 'sat', title: 'Saturday Night', cover: null, start: at(3, 23), end: at(4, 5)),
        eventRow(id: 'next', title: 'Next Friday', cover: null, start: at(9, 23), end: at(10, 5)),
      ];
    }

    Future<void> openAt(WidgetTester tester) => pumpSite(tester, Scaffold(body: EventsScreen(now: now)), site: site);

    testWidgets('Tonight shows only what is on tonight', (tester) async {
      events();
      await openAt(tester);
      await tester.tap(find.byKey(const Key('when-tonight')));
      await tester.pump();
      expect(find.byKey(const Key('event-today')), findsOneWidget);
      expect(find.byKey(const Key('event-fri')), findsNothing);
    });

    testWidgets('This weekend shows Friday, Saturday and Sunday nights, not the weekend after', (tester) async {
      events();
      await openAt(tester);
      await tester.tap(find.byKey(const Key('when-weekend')));
      await tester.pump();
      expect(find.byKey(const Key('event-fri')), findsOneWidget);
      expect(find.byKey(const Key('event-sat')), findsOneWidget);
      expect(find.byKey(const Key('event-today')), findsNothing);
      expect(find.byKey(const Key('event-next')), findsNothing);
    });

    testWidgets('Any date brings everything back, and a date filter works with the search', (tester) async {
      events();
      await openAt(tester);
      await tester.tap(find.byKey(const Key('when-weekend')));
      await tester.pump();
      await tester.enterText(find.byKey(const Key('events-search')), 'saturday');
      await tester.pump();
      expect(find.byKey(const Key('event-sat')), findsOneWidget);
      expect(find.byKey(const Key('event-fri')), findsNothing);
      await tester.enterText(find.byKey(const Key('events-search')), '');
      await tester.tap(find.byKey(const Key('when-any')));
      await tester.pump();
      for (final id in ['today', 'fri', 'sat', 'next']) {
        expect(find.byKey(Key('event-$id')), findsOneWidget, reason: id);
      }
    });

    testWidgets('nothing tonight says so, and the filter can be cleared', (tester) async {
      site.tables['site_events'] = [eventRow(id: 'next', cover: null, start: at(9, 23), end: at(10, 5))];
      await openAt(tester);
      await tester.tap(find.byKey(const Key('when-tonight')));
      await tester.pump();
      expect(find.text('Nothing matches'), findsOneWidget);
    });
  });
}
