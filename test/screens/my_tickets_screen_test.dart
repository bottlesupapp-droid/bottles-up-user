import 'package:bottles_up_user/features/tickets_site/screens/my_tickets_screen.dart';
import 'package:bottles_up_user/site/models/ticket_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> open(WidgetTester tester, {void Function(BuildContext, TicketOrder)? onOpen}) =>
      pumpSite(tester, Scaffold(body: MyTicketsScreen(onOpen: onOpen, now: DateTime.utc(2099, 10, 24, 12))), site: site);

  testWidgets('asks only for paid and refunded orders, newest first, and shows the event, when and what was bought', (tester) async {
    site.tables['site_orders'] = [orderRow()];
    await open(tester);
    final r = site.forTable('site_orders').single;
    expect(r.query['status'], 'in.("paid","refunded")');
    expect(r.query['order'], startsWith('created_at.desc'));
    expect(textOf(tester, 'order-title-o1'), 'Friday Night');
    expect(textOf(tester, 'order-line-o1'), '2 × General · Club A');
    expect(find.byKey(const Key('order-chip-o1')), findsNothing, reason: 'a ticket that can still be used has no label');
  });

  testWidgets('upcoming tickets come first; past, used and refunded ones follow, labelled', (tester) async {
    site.tables['site_orders'] = [
      orderRow(id: 'past', eventStart: '2020-01-01T20:00:00Z', eventEnd: '2020-01-02T02:00:00Z'),
      orderRow(id: 'soon'),
      orderRow(id: 'used', checkedIn: '2099-10-24T23:30:00Z'),
      orderRow(id: 'refunded', status: 'refunded'),
    ];
    await open(tester);
    String chip(String id) => tester.widget<Text>(find.descendant(of: find.byKey(Key('order-chip-$id')), matching: find.byType(Text))).data!;
    expect(chip('past'), 'Ended');
    expect(chip('used'), 'Used');
    expect(chip('refunded'), 'Refunded');
    expect(find.byKey(const Key('order-chip-soon')), findsNothing);
    double y(String id) => tester.getTopLeft(find.byKey(Key('order-$id'))).dy;
    expect(y('soon'), lessThan(y('past')));
    expect(y('soon'), lessThan(y('used')));
    expect(y('past'), lessThan(y('refunded')), reason: 'refunded orders are last');
    expect(find.text('Past'), findsOneWidget);
    expect(find.text('Refunded'), findsWidgets);
  });

  testWidgets('with only old tickets it says there are no upcoming ones, and still lists them', (tester) async {
    site.tables['site_orders'] = [orderRow(id: 'past', eventStart: '2020-01-01T20:00:00Z', eventEnd: '2020-01-02T02:00:00Z')];
    await open(tester);
    expect(find.byKey(const Key('no-upcoming')), findsOneWidget);
    expect(find.byKey(const Key('order-past')), findsOneWidget);
  });

  testWidgets('tapping a ticket opens it', (tester) async {
    site.tables['site_orders'] = [orderRow()];
    TicketOrder? opened;
    await open(tester, onOpen: (c, o) => opened = o);
    await tester.tap(find.byKey(const Key('order-o1')));
    expect(opened?.id, 'o1');
    expect(opened?.ticketCode, 'BU-ABCD2345');
  });

  testWidgets('no tickets says so kindly', (tester) async {
    site.tables['site_orders'] = [];
    await open(tester);
    expect(find.text('No tickets yet'), findsOneWidget);
  });

  testWidgets('an order the app cannot read is left out instead of breaking the list', (tester) async {
    site.tables['site_orders'] = [
      {...orderRow(id: 'broken'), 'quantity': 0},
      {...orderRow(id: 'nodate'), 'created_at': 'yesterday'},
      orderRow(id: 'fine'),
    ];
    await open(tester);
    expect(find.byKey(const Key('order-fine')), findsOneWidget);
    expect(find.byKey(const Key('order-broken')), findsNothing);
    expect(find.byKey(const Key('order-nodate')), findsNothing);
  });

  testWidgets('a paid ticket whose event the website no longer shows (taken down) is still listed, so the buyer can always find their ticket', (tester) async {
    site.tables['site_orders'] = [{...orderRow(id: 'gone'), 'site_events': null}];
    await open(tester);
    expect(textOf(tester, 'order-title-gone'), 'Event');
  });

  testWidgets('if the tickets cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.failAllWith = 500;
    site.tables['site_orders'] = [orderRow()];
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load your tickets. Check your connection and try again.');
    site.failAllWith = null;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('order-o1')), findsOneWidget);
  });
}
