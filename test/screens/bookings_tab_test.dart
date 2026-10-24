import 'package:bottles_up_user/features/bookings_site/screens/bookings_tab.dart';
import 'package:bottles_up_user/features/main_navigation/providers/nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_orders'] = [orderRow()];
    site.tables['site_table_bookings'] = [bookingRow()];
  });

  Future<void> open(WidgetTester tester) => pumpSite(tester, Scaffold(body: BookingsTab(now: DateTime(2099, 11, 1))), site: site);

  testWidgets('starts on the tickets, and switches to the tables and back', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('my-tickets')), findsOneWidget);
    expect(find.byKey(const Key('order-o1')), findsOneWidget);
    expect(find.byKey(const Key('my-table-bookings')), findsNothing);
    expect(site.forTable('site_table_bookings'), isEmpty, reason: 'the tables are not asked for until they are looked at');

    await tester.tap(find.byKey(const Key('segment-tables')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('my-table-bookings')), findsOneWidget);
    expect(find.byKey(const Key('booking-bk1')), findsOneWidget);
    expect(find.byKey(const Key('my-tickets')), findsNothing);

    await tester.tap(find.byKey(const Key('segment-tickets')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('order-o1')), findsOneWidget);
  });

  testWidgets('the title is there once, not once per list', (tester) async {
    await open(tester);
    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('My tickets'), findsNothing);
    await tester.tap(find.byKey(const Key('segment-tables')));
    await tester.pumpAndSettle();
    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('My tables'), findsNothing);
  });

  testWidgets('coming from a paid table the tab opens on the tables', (tester) async {
    await pumpSite(tester, Scaffold(body: Consumer(builder: (context, ref, _) {
      // What the payment screen does before it switches to this tab.
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(bookingsSegmentProvider.notifier).state = BookingsSegment.tables);
      return BookingsTab(now: DateTime(2099, 11, 1));
    })), site: site);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-bk1')), findsOneWidget);
  });

  testWidgets('an empty list in one segment does not hide the other', (tester) async {
    site.tables['site_orders'] = [];
    await open(tester);
    expect(find.text('No tickets yet'), findsOneWidget);
    await tester.tap(find.byKey(const Key('segment-tables')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('booking-bk1')), findsOneWidget);
  });

  testWidgets('the tab\'s scroll controller (which hides the bar and scrolls to the top) follows the list on view, also across a switch', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpSite(tester, Scaffold(body: BookingsTab(scrollController: controller, now: DateTime(2099, 11, 1))), site: site);
    expect(controller.hasClients, isTrue);
    expect(controller.positions.length, 1);
    await tester.tap(find.byKey(const Key('segment-tables')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(controller.positions.length, 1, reason: 'only the list on view is attached');
    await tester.tap(find.byKey(const Key('segment-tickets')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(controller.positions.length, 1);
    expect(controller.offset, 0);
  });
}
