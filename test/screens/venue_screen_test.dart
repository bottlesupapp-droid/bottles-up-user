import 'package:bottles_up_user/features/tables/screens/venue_screen.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

// Saturday 24 Oct 2026. Fridays are 30 Oct, 6 Nov, ...
final now = DateTime(2026, 10, 24);

void main() {
  late FakeWebsite site;
  late List<(String, String, String, String)> booked;

  Future<void> open(WidgetTester tester, {PickNight? pickNight, bool settle = true}) async {
    await pumpSite(
      tester,
      VenueScreen(
        venueId: 'v1',
        now: now,
        pickNight: pickNight ?? (c, v, t) async => null,
        onBook: (c, v, t, n, s) => booked.add((v.id, t.id, '${n.year}-${n.month}-${n.day}', s.id)),
      ),
      site: site,
      settle: settle,
    );
    // The floor plan's picture never finishes loading in a test, so its spinner would keep pumpAndSettle waiting: pump a few frames instead.
    if (!settle) {
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }
  }

  setUp(() {
    site = FakeWebsite();
    booked = [];
    site.tables['site_venues'] = [
      venueRow(
        tables: [tableTypeRow(id: 'tt1', name: 'Booth 1', deposit: 10000, minSpend: 50000), tableTypeRow(id: 'tt2', name: 'Couch', deposit: 20000, minSpend: 80000, sort: 1), tableTypeRow(id: 'tt3', name: 'Dance floor', mode: 'hourly', rate: 15000, minHours: 2, sort: 2)],
        slots: [slotRow(id: 'early', day: 5, time: '21:00:00'), slotRow(id: 'late', day: 5, time: '01:00:00', label: 'After hours'), slotRow(id: 'sat', day: 6, time: '22:00:00')],
      ),
    ];
    site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: ['tt2']);
  });

  testWidgets('shows what the venue is: name, address, hours, dress code, music, capacity, phone and description', (tester) async {
    await open(tester);
    expect(textOf(tester, 'venue-title'), 'Club A');
    expect(textOf(tester, 'venue-address'), '1 King St W, Toronto');
    expect(textOf(tester, 'venue-hours'), 'Thu to Sat, 10pm to 3am');
    expect(textOf(tester, 'venue-dress'), 'Dress code: Smart casual');
    expect(textOf(tester, 'venue-music'), 'House, Hip hop');
    expect(textOf(tester, 'venue-capacity'), 'Capacity 400');
    expect(textOf(tester, 'venue-phone'), '416-555-0199');
    expect(textOf(tester, 'venue-description'), 'The best room in town.');
    final r = site.forTable('site_venues').single;
    expect([r.query['id'], r.query['status']], ['eq.v1', 'eq.published']);
  });

  testWidgets('offers the next nights that can be booked (the weekdays the venue has times for) and nothing is chosen yet', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('night-2026-10-24')), findsOneWidget, reason: 'today is a Saturday and the venue opens Saturdays');
    expect(find.byKey(const Key('night-2026-10-30')), findsOneWidget);
    expect(find.byKey(const Key('night-2026-10-27')), findsNothing, reason: 'a Tuesday');
    expect(find.byKey(const Key('pick-first')), findsOneWidget);
    expect(find.byKey(const Key('slot-early')), findsNothing);
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt1'))).onPressed, isNull);
    expect(find.text('Pick a date above'), findsNWidgets(3));
    expect(site.forRpc('get_unavailable_table_types'), isEmpty, reason: 'nothing to ask until a night and time are chosen');
  });

  testWidgets('choosing a night shows that weekday\'s times, picks the first one, and asks the website which tables are taken for that night and time', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot-early')), findsOneWidget);
    expect(find.byKey(const Key('slot-late')), findsOneWidget);
    expect(find.byKey(const Key('slot-sat')), findsNothing);
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('slot-late'))).selected, isFalse);
    expect(find.text('1:00 AM (After hours)'), findsOneWidget);
    // 21:00 is the earliest, so it is chosen.
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('slot-early'))).selected, isTrue);
    expect(site.forRpc('get_unavailable_table_types').single.body, {'p_venue_id': 'v1', 'p_booking_date': '2026-10-30', 'p_time_slot_id': 'early'});
  });

  testWidgets('a taken table says so and cannot be booked; a free one can', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt1'))).onPressed, isNotNull);
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt2'))).onPressed, isNull);
    expect(find.descendant(of: find.byKey(const Key('book-tt2')), matching: find.text('Booked for this date')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('book-tt1')), matching: find.text('Book table')), findsOneWidget);
  });

  testWidgets('booking a table hands over the venue, the table, the night and the time', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('book-tt1')));
    await tester.tap(find.byKey(const Key('book-tt1')));
    expect(booked, [('v1', 'tt1', '2026-10-30', 'early')]);
  });

  testWidgets('changing the time asks again and a table that was taken may now be free', (tester) async {
    site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: b['p_time_slot_id'] == 'early' ? ['tt1'] : <String>[]);
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt1'))).onPressed, isNull);
    await tester.tap(find.byKey(const Key('slot-late')));
    await tester.pumpAndSettle();
    expect(site.forRpc('get_unavailable_table_types').last.body['p_time_slot_id'], 'late');
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt1'))).onPressed, isNotNull);
  });

  testWidgets('an after-midnight time says which day the guests arrive', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('arrival-note')), findsNothing);
    await tester.tap(find.byKey(const Key('slot-late')));
    await tester.pumpAndSettle();
    expect(textOf(tester, 'arrival-note'), 'Friday night\'s event - you\'ll be arriving Saturday, 1:00 AM.');
    expect(site.forRpc('get_unavailable_table_types').last.body['p_booking_date'], '2026-10-30', reason: 'the website is asked about the night picked, and works out the arrival day itself');
  });

  testWidgets('tables are listed with their guests, price and deposit; an hourly table shows its rate', (tester) async {
    await open(tester);
    expect(textOf(tester, 'table-name-tt1'), 'Booth 1');
    expect(textOf(tester, 'table-guests-tt1'), 'Up to 6 guests');
    expect(textOf(tester, 'table-price-tt1'), '\$500 min spend');
    expect(textOf(tester, 'table-deposit-tt1'), 'Deposit ${formatMoney(10000)}');
    expect(textOf(tester, 'table-price-tt3'), '\$150/hr · 2hr min');
    expect(textOf(tester, 'table-deposit-tt3'), '');
  });

  testWidgets('another date can be picked from the calendar, and a date the venue does not take is refused by the picker (it only offers good days)', (tester) async {
    await open(tester, pickNight: (c, v, t) async => DateTime(2026, 11, 13));
    await tester.ensureVisible(find.byKey(const Key('pick-date')));
    await tester.tap(find.byKey(const Key('pick-date')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot-early')), findsOneWidget);
    expect(site.forRpc('get_unavailable_table_types').single.body['p_booking_date'], '2026-11-13');
  });

  testWidgets('the booking window the venue set is shown, and nights outside it are not offered', (tester) async {
    site.tables['site_venues'] = [venueRow(start: '2026-11-06', end: '2026-11-20')];
    await open(tester);
    expect(textOf(tester, 'booking-window'), 'Bookings open Nov 6, 2026 through Nov 20, 2026.');
    expect(find.byKey(const Key('night-2026-10-30')), findsNothing);
    expect(find.byKey(const Key('night-2026-11-06')), findsOneWidget);
  });

  testWidgets('a venue with no booking times says so and its tables cannot be booked', (tester) async {
    site.tables['site_venues'] = [venueRow(slots: const [])];
    await open(tester);
    expect(find.byKey(const Key('not-bookable')), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const Key('book-tt1'))).onPressed, isNull);
  });

  testWidgets('if availability cannot be read the person is told and can try again; booking is not blocked for good', (tester) async {
    var up = false;
    site.rpcs['get_unavailable_table_types'] = (b) => up ? (status: 200, body: <String>[]) : (status: 500, body: {'message': 'boom'});
    await open(tester);
    await tester.tap(find.byKey(const Key('night-2026-10-30')));
    await tester.pumpAndSettle();
    expect(textOf(tester, 'availability-error'), 'We could not check which tables are free. Check your connection and try again.');
    up = true;
    await tester.ensureVisible(find.byKey(const Key('availability-retry')));
    await tester.tap(find.byKey(const Key('availability-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('availability-error')), findsNothing);
  });

  group('floor plan', () {
    setUp(() {
      site.tables['site_venues'] = [
        venueRow(tables: [
          tableTypeRow(id: 'tt1', floorId: 'f1', x: 10, y: 10),
          tableTypeRow(id: 'tt2', name: 'Roof 1', floorId: 'f2', x: 20, y: 20, sort: 1),
          tableTypeRow(id: 'tt3', name: 'Bar stool', sort: 2),
        ]),
      ];
      site.tables['site_venue_floors'] = [floorRow(id: 'f1'), floorRow(id: 'f2', label: 'Roof', sort: 1)];
    });

    testWidgets('a venue with positioned tables shows its plan and one chip per floor; all tables are still listed', (tester) async {
      await open(tester, settle: false);
      expect(find.byKey(const Key('floor-plan')), findsOneWidget);
      expect(find.byKey(const Key('floor-f1')), findsOneWidget);
      expect(find.byKey(const Key('floor-f2')), findsOneWidget);
      expect(site.forTable('site_venue_floors').single.query['venue_id'], 'eq.v1');
      for (final id in ['tt1', 'tt2', 'tt3']) {
        expect(find.byKey(Key('table-$id')), findsOneWidget, reason: id);
      }
    });

    testWidgets('a venue without positioned tables shows no plan and asks for none', (tester) async {
      site.tables['site_venues'] = [venueRow()];
      await open(tester);
      expect(find.byKey(const Key('floor-plan')), findsNothing);
      expect(site.forTable('site_venue_floors'), isEmpty);
    });
  });

  testWidgets('a venue the website no longer shows says so', (tester) async {
    site.tables['site_venues'] = [];
    await open(tester);
    expect(find.text('This venue is no longer available'), findsOneWidget);
  });

  testWidgets('if the venue cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.failAllWith = 500;
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load this venue. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('venue-page')), findsOneWidget);
  });

  group('coming from an event', () {
    Future<void> openOn(WidgetTester tester, String? night) async {
      await pumpSite(tester, VenueScreen(venueId: 'v1', initialNight: night, now: now, pickNight: (c, v, t) async => null, onBook: (c, v, t, n, s) => booked.add((v.id, t.id, '${n.year}-${n.month}-${n.day}', s.id))), site: site);
    }

    testWidgets('starts on the event\'s night, with its first time chosen and availability asked for', (tester) async {
      await openOn(tester, '2026-10-30');
      expect(tester.widget<ChoiceChip>(find.byKey(const Key('night-2026-10-30'))).selected, isTrue);
      expect(tester.widget<ChoiceChip>(find.byKey(const Key('slot-early'))).selected, isTrue);
      expect(site.forRpc('get_unavailable_table_types').single.body['p_booking_date'], '2026-10-30');
      expect(find.byKey(const Key('night-note')), findsNothing);
    });

    testWidgets('a night the venue does not take bookings on says so and chooses nothing', (tester) async {
      await openOn(tester, '2026-10-28');
      expect(textOf(tester, 'night-note'), 'Club A does not take table bookings on a Wednesday.');
      expect(find.byKey(const Key('slot-early')), findsNothing);
      expect(site.forRpc('get_unavailable_table_types'), isEmpty);
    });

    testWidgets('a night that cannot be read is ignored', (tester) async {
      await openOn(tester, 'tomorrow');
      expect(find.byKey(const Key('night-note')), findsNothing);
      expect(find.byKey(const Key('slot-early')), findsNothing);
    });
  });

  testWidgets('a table that includes entry passes says so', (tester) async {
    site.tables['site_venues'] = [
      venueRow(tables: [
        {...tableTypeRow(id: 'tt1'), 'included_admissions': 4},
        {...tableTypeRow(id: 'tt2', name: 'Couch'), 'included_admissions': 1},
        tableTypeRow(id: 'tt3', name: 'Stool'),
      ])
    ];
    await open(tester);
    expect(textOf(tester, 'table-passes-tt1'), 'Includes 4 entry passes');
    expect(textOf(tester, 'table-passes-tt2'), 'Includes 1 entry pass');
    expect(find.byKey(const Key('table-passes-tt3')), findsNothing);
  });
}
