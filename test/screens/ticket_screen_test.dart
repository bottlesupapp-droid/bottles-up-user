import 'package:bottles_up_user/features/tickets_site/screens/ticket_screen.dart';
import 'package:bottles_up_user/features/tickets_site/widgets/ticket_qr.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> open(WidgetTester tester, {String id = 'o1'}) => pumpSite(tester, TicketScreen(orderId: id, now: DateTime.utc(2099, 10, 24, 12)), site: site);

  testWidgets('shows the QR code (the ticket code itself, which the door scans), the event, when and where, and what was paid', (tester) async {
    site.tables['site_orders'] = [orderRow(amount: 10000)];
    await open(tester);
    expect(find.byKey(const Key('ticket-qr')), findsOneWidget);
    expect(tester.widget<TicketQr>(find.byType(TicketQr)).code, 'BU-ABCD2345');
    expect(tester.widget<SelectableText>(find.byKey(const Key('ticket-code'))).data, 'BU-ABCD2345');
    expect(textOf(tester, 'ticket-event'), 'Friday Night');
    expect(textOf(tester, 'ticket-when'), formatWhen(parseWhen('2099-10-24T23:00:00Z')!));
    expect(textOf(tester, 'ticket-where'), 'Club A · 1 King St W, Toronto');
    expect(textOf(tester, 'ticket-line'), '2 × General');
    expect(textOf(tester, 'ticket-paid'), formatPrice(10000, currency: 'cad'));
    expect(find.text('Show this at the door.'), findsOneWidget);
    expect(find.byKey(const Key('send-entry-code')), findsNothing, reason: 'an ordinary ticket needs no entry code');
  });

  testWidgets('a promo discount is shown', (tester) async {
    site.tables['site_orders'] = [{...orderRow(), 'discount_cents': 1000}];
    await open(tester);
    expect(textOf(tester, 'ticket-discount'), '-${formatMoney(1000, currency: 'cad')}');
  });

  testWidgets('a ticket that was scanned says so, and the code is greyed', (tester) async {
    site.tables['site_orders'] = [orderRow(checkedIn: '2099-10-24T23:30:00Z')];
    await open(tester);
    expect(textOf(tester, 'ticket-used'), startsWith('Used '));
    expect(find.text('Show this at the door.'), findsNothing);
    expect(find.byKey(const Key('send-entry-code')), findsNothing);
  });

  testWidgets('a ticket for an event that has ended says so', (tester) async {
    site.tables['site_orders'] = [orderRow(eventStart: '2020-01-01T20:00:00Z', eventEnd: '2020-01-02T02:00:00Z')];
    await open(tester);
    expect(find.byKey(const Key('ticket-ended')), findsOneWidget);
  });

  testWidgets('a refunded order shows no code at all', (tester) async {
    site.tables['site_orders'] = [orderRow(status: 'refunded')];
    await open(tester);
    expect(find.byKey(const Key('ticket-refunded')), findsOneWidget);
    expect(find.byKey(const Key('ticket-qr')), findsNothing);
  });

  testWidgets('an order that is not there says the ticket was not found', (tester) async {
    site.tables['site_orders'] = [orderRow(id: 'other')];
    await open(tester);
    expect(find.text('Ticket not found'), findsOneWidget);
  });

  group('a ticket that stays with its buyer', () {
    testWidgets('can email the person the 6-digit code the door asks for, and says where it went', (tester) async {
      site.tables['site_orders'] = [orderRow(nonTransferable: true)];
      site.functions['request-ticket-otp'] = (b) => (status: 200, body: {'success': true, 'email_preview': 'da***@example.com', 'expires_in_seconds': 300});
      await open(tester);
      await tester.tap(find.byKey(const Key('send-entry-code')));
      await settleCalls(tester);
      expect(site.forFunction('request-ticket-otp').single.body, {'order_id': 'o1'});
      expect(textOf(tester, 'entry-code-sent'), 'We sent a 6-digit code to da***@example.com. It works for 5 minutes. Show it at the door with this QR code.');
    });

    testWidgets('if the code cannot be sent the person reads why', (tester) async {
      site.tables['site_orders'] = [orderRow(nonTransferable: true)];
      site.functions['request-ticket-otp'] = (b) => (status: 400, body: {'error': 'Too many requests, wait a minute'});
      await open(tester);
      await tester.tap(find.byKey(const Key('send-entry-code')));
      await settleCalls(tester);
      expect(textOf(tester, 'entry-code-problem'), 'Too many requests, wait a minute');
      expect(find.byKey(const Key('entry-code-sent')), findsNothing);
    });

    testWidgets('is not offered once the ticket is used', (tester) async {
      site.tables['site_orders'] = [orderRow(nonTransferable: true, checkedIn: '2099-10-24T23:30:00Z')];
      await open(tester);
      expect(find.byKey(const Key('send-entry-code')), findsNothing);
    });
  });

  group('getting there and sharing', () {
    testWidgets('directions open the event\'s address in maps', (tester) async {
      site.tables['site_orders'] = [orderRow()];
      final opened = <Uri>[];
      await pumpSite(tester, TicketScreen(orderId: 'o1', now: DateTime.utc(2099, 10, 24, 12)), site: site, opened: opened);
      expect(textOf(tester, 'ticket-address'), '1 King St W, Toronto');
      await tester.ensureVisible(find.byKey(const Key('ticket-maps')));
      await tester.tap(find.byKey(const Key('ticket-maps')));
      await tester.pump();
      expect(opened.single.toString(), 'https://www.google.com/maps/search/?api=1&query=1+King+St+W%2C+Toronto');
    });

    testWidgets('sharing says where the guest is going, with the event\'s page on the website', (tester) async {
      site.tables['site_orders'] = [orderRow()];
      final shared = <String>[];
      await pumpSite(tester, TicketScreen(orderId: 'o1', now: DateTime.utc(2099, 10, 24, 12), share: (t) async => shared.add(t)), site: site);
      await tester.tap(find.byKey(const Key('ticket-share')));
      await tester.pump();
      expect(shared.single, allOf(startsWith('I am going to Friday Night on '), contains('/events/e1')));
    });

    testWidgets('a refunded order offers no directions and cannot be shared', (tester) async {
      site.tables['site_orders'] = [orderRow(status: 'refunded')];
      await pumpSite(tester, TicketScreen(orderId: 'o1', now: DateTime.utc(2099, 10, 24, 12)), site: site);
      expect(find.byKey(const Key('ticket-maps')), findsNothing);
      expect(find.byKey(const Key('ticket-share')), findsNothing);
    });
  });
}
