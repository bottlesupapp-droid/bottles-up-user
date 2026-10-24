import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_a1B2c3D4#fidkdWxOYHwnPyd1blpxYHZxWjA0';

void main() {
  late FakeWebsite site;
  late List<PaymentWaitArgs> started;
  late List<Uri> opened;

  Future<void> open(WidgetTester tester, {String tierId = 't1', Account? account = signedIn, bool canOpen = true}) {
    return pumpSite(tester, TicketPurchaseScreen(eventId: 'e1', tierId: tierId, onStarted: (c, a) => started.add(a)), site: site, account: account, opened: opened, canOpen: canOpen);
  }

  setUp(() {
    site = FakeWebsite();
    started = [];
    opened = [];
    site.tables['site_events'] = [
      eventRow(cover: null, tiers: [
        tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 20),
        tierRow(id: 't2', name: 'VIP entry', price: 12000, capacity: 20, sold: 17, code: true, nonTransferable: true),
        tierRow(id: 't3', name: 'Early bird', price: 3000, capacity: 50, sold: 50),
        tierRow(id: 't4', name: 'Few', price: 1000, capacity: 5, sold: 3),
      ]),
    ];
    site.functions['site-create-checkout-session'] = (b) => (status: 200, body: {'url': payUrl});
  });

  testWidgets('shows the event and ticket, fills in the name and phone from the account and sends the tickets to the account\'s email', (tester) async {
    await open(tester);
    expect(textOf(tester, 'purchase-event'), 'Friday Night');
    expect(textOf(tester, 'purchase-tier'), 'General');
    expect(tester.widget<TextField>(find.byKey(const Key('buyer-name'))).controller!.text, 'Dana Lee');
    expect(tester.widget<TextField>(find.byKey(const Key('buyer-phone'))).controller!.text, '416-555-0100');
    expect(textOf(tester, 'buyer-email'), 'dana@example.com');
    expect(textOf(tester, 'order-total-value'), formatPrice(5000, currency: 'cad'));
  });

  testWidgets('more tickets change the total and the line, never below one or above what is left (and never above ten)', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('qty-plus')));
    await tester.tap(find.byKey(const Key('qty-plus')));
    await tester.pump();
    expect(textOf(tester, 'qty'), '3');
    expect(textOf(tester, 'order-total-value'), formatPrice(15000, currency: 'cad'));
    expect(textOf(tester, 'order-line'), '3 × General · ${formatPrice(15000, currency: 'cad')}');
    for (var i = 0; i < 12; i++) {
      await tester.tap(find.byKey(const Key('qty-plus')), warnIfMissed: false);
      await tester.pump();
    }
    expect(textOf(tester, 'qty'), '10');
    for (var i = 0; i < 12; i++) {
      await tester.tap(find.byKey(const Key('qty-minus')), warnIfMissed: false);
      await tester.pump();
    }
    expect(textOf(tester, 'qty'), '1');
  });

  testWidgets('a ticket type with 2 left cannot be bumped past 2', (tester) async {
    await open(tester, tierId: 't4');
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byKey(const Key('qty-plus')), warnIfMissed: false);
      await tester.pump();
    }
    expect(textOf(tester, 'qty'), '2');
  });

  testWidgets('paying sends exactly what the person entered, opens the page to pay in the app, and hands over to the waiting screen with the payment\'s id', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('qty-plus')));
    await tester.enterText(find.byKey(const Key('buyer-name')), '  Dana  Lee ');
    await tester.pump();
    await tester.tap(find.byKey(const Key('pay')));
    await settleCalls(tester);

    final sent = site.forFunction('site-create-checkout-session').single.body;
    expect(sent, {'event_id': 'e1', 'tier_id': 't1', 'quantity': 2, 'customer_name': 'Dana  Lee', 'customer_email': 'dana@example.com', 'customer_phone': '416-555-0100'});
    expect(opened.single.toString(), payUrl);
    expect(started.single.eventId, 'e1');
    expect(started.single.tierId, 't1');
    expect(started.single.start.sessionId, 'cs_test_a1B2c3D4');
    expect(find.byKey(const Key('purchase-problem')), findsNothing);
  });

  testWidgets('tapping Pay twice quickly makes one order', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('pay')));
    await tester.tap(find.byKey(const Key('pay')), warnIfMissed: false);
    await settleCalls(tester);
    expect(site.forFunction('site-create-checkout-session').length, 1);
    expect(started.length, 1);
  });

  testWidgets('a missing name is caught before anything is sent', (tester) async {
    await open(tester);
    await tester.enterText(find.byKey(const Key('buyer-name')), 'D');
    await tester.tap(find.byKey(const Key('pay')));
    await tester.pump();
    expect(textOf(tester, 'purchase-problem'), 'Enter your name (at least 2 letters).');
    expect(site.forFunction('site-create-checkout-session'), isEmpty);
  });

  testWidgets('a phone number is optional and left out when empty', (tester) async {
    await open(tester);
    await tester.enterText(find.byKey(const Key('buyer-phone')), '');
    await tester.tap(find.byKey(const Key('pay')));
    await settleCalls(tester);
    expect(site.forFunction('site-create-checkout-session').single.body.containsKey('customer_phone'), isFalse);
  });

  testWidgets('when the website refuses (not enough tickets) the person reads its sentence, can try again, and the event is read again', (tester) async {
    site.functions['site-create-checkout-session'] = (b) => (status: 400, body: {'error': 'Only 1 ticket is left for General'});
    await open(tester);
    final before = site.forTable('site_events').length;
    await tester.tap(find.byKey(const Key('pay')));
    await settleCalls(tester);
    expect(textOf(tester, 'purchase-problem'), 'Only 1 ticket is left for General');
    expect(started, isEmpty);
    expect(opened, isEmpty);
    expect(tester.widget<FilledButton>(find.byKey(const Key('pay'))).onPressed, isNotNull);
    expect(site.forTable('site_events').length, greaterThan(before), reason: 'what is left may have changed');
  });

  testWidgets('if the payment page cannot be opened the person is told and nobody is sent to the waiting screen', (tester) async {
    await open(tester, canOpen: false);
    await tester.tap(find.byKey(const Key('pay')));
    await settleCalls(tester);
    expect(textOf(tester, 'purchase-problem'), startsWith('We could not open the payment page.'));
    expect(started, isEmpty);
  });

  group('promo code', () {
    testWidgets('a good code shows its discount in the total and is sent with the order', (tester) async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': true, 'discountCents': 1000, 'message': '10 dollars off'});
      await open(tester);
      await tester.enterText(find.byKey(const Key('promo-code')), 'save10');
      await tester.tap(find.byKey(const Key('apply-promo')));
      await settleCalls(tester);
      expect(site.forFunction('validate-promo-code').single.body, {'code': 'save10', 'applies_to': 'tickets', 'venue_id': 'v1', 'subtotal_cents': 5000});
      expect(textOf(tester, 'promo-message'), '10 dollars off');
      expect(textOf(tester, 'order-discount-value'), '-${formatMoney(1000, currency: 'cad')}');
      expect(textOf(tester, 'order-total-value'), formatPrice(4000, currency: 'cad'));

      await tester.tap(find.byKey(const Key('pay')));
      await settleCalls(tester);
      expect(site.forFunction('site-create-checkout-session').single.body['promo_code'], 'save10');
    });

    testWidgets('changing how many asks the website again, because the discount depends on the total', (tester) async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': true, 'discountCents': (b['subtotal_cents'] as int) ~/ 10, 'message': '10% off'});
      await open(tester);
      await tester.enterText(find.byKey(const Key('promo-code')), 'TENOFF');
      await tester.tap(find.byKey(const Key('apply-promo')));
      await settleCalls(tester);
      await tester.tap(find.byKey(const Key('qty-plus')));
      await settleCalls(tester);
      expect(site.forFunction('validate-promo-code').last.body['subtotal_cents'], 10000);
      expect(textOf(tester, 'order-total-value'), formatPrice(9000, currency: 'cad'));
    });

    testWidgets('a code that does not work shows why, costs nothing, and is not sent with the order', (tester) async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': false, 'message': 'This code has expired'});
      await open(tester);
      await tester.enterText(find.byKey(const Key('promo-code')), 'OLD');
      await tester.tap(find.byKey(const Key('apply-promo')));
      await settleCalls(tester);
      expect(textOf(tester, 'promo-message'), 'This code has expired');
      expect(find.byKey(const Key('order-discount')), findsNothing);
      await tester.tap(find.byKey(const Key('pay')));
      await settleCalls(tester);
      expect(site.forFunction('site-create-checkout-session').single.body.containsKey('promo_code'), isFalse);
    });

    testWidgets('if the website cannot be reached the person is told, and the price stays as it was', (tester) async {
      site.functions['validate-promo-code'] = (b) => (status: 500, body: {'error': 'boom'});
      await open(tester);
      await tester.enterText(find.byKey(const Key('promo-code')), 'X');
      await tester.tap(find.byKey(const Key('apply-promo')));
      await settleCalls(tester);
      expect(textOf(tester, 'promo-message'), 'We could not check that code. Check your connection and try again.');
      expect(textOf(tester, 'order-total-value'), formatPrice(5000, currency: 'cad'));
    });
  });

  group('a ticket type that needs an access code', () {
    testWidgets('cannot be paid for until the website accepts the code, and says what to do', (tester) async {
      await open(tester, tierId: 't2');
      expect(find.byKey(const Key('access-code')), findsOneWidget);
      expect(find.byKey(const Key('purchase-nontransferable')), findsOneWidget);
      await tester.tap(find.byKey(const Key('pay')));
      await tester.pump();
      expect(textOf(tester, 'purchase-problem'), 'Enter the access code for VIP entry.');
      expect(site.forFunction('site-create-checkout-session'), isEmpty);
    });

    testWidgets('a wrong code is explained, a right one unlocks and is sent with the order', (tester) async {
      var good = false;
      site.functions['validate-tier-access-code'] = (b) => good ? (status: 200, body: {'valid': true, 'message': 'Welcome, VIP'}) : (status: 200, body: {'valid': false, 'message': 'Invalid access code'});
      await open(tester, tierId: 't2');
      await tester.enterText(find.byKey(const Key('access-code')), 'nope');
      await tester.tap(find.byKey(const Key('unlock')));
      await settleCalls(tester);
      expect(textOf(tester, 'access-message'), 'Invalid access code');
      expect(site.forFunction('validate-tier-access-code').single.body, {'tier_id': 't2', 'code': 'nope'});

      good = true;
      await tester.enterText(find.byKey(const Key('access-code')), 'vip2099');
      await tester.tap(find.byKey(const Key('unlock')));
      await settleCalls(tester);
      expect(textOf(tester, 'access-accepted'), 'Welcome, VIP');
      expect(find.byKey(const Key('access-code')), findsNothing);

      await tester.tap(find.byKey(const Key('pay')));
      await settleCalls(tester);
      final sent = site.forFunction('site-create-checkout-session').single.body;
      expect([sent['tier_id'], sent['access_code']], ['t2', 'vip2099']);
    });
  });

  testWidgets('a sold out ticket type cannot be paid for', (tester) async {
    await open(tester, tierId: 't3');
    expect(tester.widget<FilledButton>(find.byKey(const Key('pay'))).onPressed, isNull);
  });

  testWidgets('a ticket type the event does not have says the tickets are gone', (tester) async {
    await open(tester, tierId: 'nope');
    expect(find.text('These tickets are no longer available'), findsOneWidget);
  });

  testWidgets('someone who is not signed in is asked to sign in, and nothing is sent', (tester) async {
    await open(tester, account: null);
    expect(find.text('Sign in to buy tickets'), findsOneWidget);
    expect(find.byKey(const Key('pay')), findsNothing);
  });
}
