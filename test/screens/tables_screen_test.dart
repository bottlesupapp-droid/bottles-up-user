import 'package:bottles_up_user/features/tables/screens/tables_screen.dart';
import 'package:bottles_up_user/site/models/venue.dart';
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
    site.tables['site_venues'] = [
      venueRow(id: 'v1', name: 'Club A', tables: [tableTypeRow(id: 'a1', venueId: 'v1', deposit: 20000), tableTypeRow(id: 'a2', venueId: 'v1', name: 'Couch', deposit: 10000)]),
      venueRow(id: 'v2', name: 'Rooftop', tables: [tableTypeRow(id: 'b1', venueId: 'v2', name: 'Cabana', deposit: 30000, floorId: 'f1', x: 10, y: 10)], slots: [slotRow(id: 'sb', venueId: 'v2')]),
      venueRow(id: 'v3', name: 'New Place', tables: [tableTypeRow(id: 'c1', venueId: 'v3')], slots: const []),
    ];
  });

  Future<void> open(WidgetTester tester, {void Function(BuildContext, Venue)? onOpen}) => pumpSite(tester, Scaffold(body: TablesScreen(onOpenVenue: onOpen)), site: site);

  testWidgets('lists the website\'s venues with how many tables and from what price', (tester) async {
    await open(tester);
    for (final id in ['v1', 'v2', 'v3']) {
      expect(find.byKey(Key('venue-$id')), findsOneWidget, reason: id);
    }
    expect(textOf(tester, 'venue-name-v1'), 'Club A');
    expect(textOf(tester, 'venue-summary-v1'), '2 tables · From ${formatMoney(10000)}');
    expect(textOf(tester, 'venue-summary-v2'), '1 table · From ${formatMoney(30000)}');
    expect(site.forTable('site_venues').single.query['status'], 'eq.published');
  });

  testWidgets('a venue with a floor plan says so; one without booking times says they are coming', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('venue-plan-v2')), findsOneWidget);
    expect(find.byKey(const Key('venue-plan-v1')), findsNothing);
    expect(textOf(tester, 'venue-summary-v3'), 'Booking times coming soon');
  });

  testWidgets('searching narrows the list by venue, address or table name; clearing brings it back', (tester) async {
    await open(tester);
    await tester.enterText(find.byKey(const Key('tables-search')), 'roof');
    await tester.pump();
    expect(find.byKey(const Key('venue-v2')), findsOneWidget);
    expect(find.byKey(const Key('venue-v1')), findsNothing);

    await tester.enterText(find.byKey(const Key('tables-search')), 'couch');
    await tester.pump();
    expect(find.byKey(const Key('venue-v1')), findsOneWidget);
    expect(find.byKey(const Key('venue-v2')), findsNothing);

    await tester.enterText(find.byKey(const Key('tables-search')), 'zzz');
    await tester.pump();
    expect(find.text('Nothing matches'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tables-search-clear')));
    await tester.pump();
    expect(find.byKey(const Key('venue-v1')), findsOneWidget);
    expect(find.byKey(const Key('venue-v2')), findsOneWidget);
  });

  testWidgets('tapping a venue opens it', (tester) async {
    Venue? opened;
    await open(tester, onOpen: (c, v) => opened = v);
    await tester.tap(find.byKey(const Key('venue-v2')));
    expect(opened?.id, 'v2');
  });

  testWidgets('venues without a table are not listed, and no venues says so kindly', (tester) async {
    site.tables['site_venues'] = [venueRow(tables: const [])];
    await open(tester);
    expect(find.text('No tables right now'), findsOneWidget);
  });

  testWidgets('if the venues cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.failAllWith = 500;
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load venues. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('venue-v1')), findsOneWidget);
  });
}
