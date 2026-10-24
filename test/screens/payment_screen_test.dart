import 'package:bottles_up_user/features/main_navigation/providers/nav_index_provider.dart';
import 'package:bottles_up_user/features/tickets_site/screens/payment_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/features/tickets_site/widgets/ticket_qr.dart';
import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

final payPage = Uri.parse('https://checkout.stripe.com/c/pay/cs_test_a1B2c3D4#frag');

PaymentWaitArgs argsWith({String? sessionId = 'cs_test_a1B2c3D4'}) => PaymentWaitArgs(
      eventId: 'e1',
      tierId: 't1',
      eventTitle: 'Friday Night',
      start: CheckoutStart(url: payPage, sessionId: sessionId),
      startedAt: DateTime.utc(2099, 10, 20, 12),
    );

Map<String, dynamic> paidAnswer() => {
      'status': 'paid',
      'ticket': {
        'ticketCode': 'BU-ABCD2345',
        'customerName': 'Dana Lee',
        'customerEmail': 'dana@example.com',
        'quantity': 2,
        'discountCents': 0,
        'tierName': 'General',
        'eventTitle': 'Friday Night',
        'venueName': 'Club A',
        'startDate': '2099-10-24T23:00:00Z',
      },
    };

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  late int viewedTickets;
  late int wentBack;

  Future<void> open(WidgetTester tester, {PaymentWaitArgs? args, Duration interval = const Duration(seconds: 1), Duration giveUpAfter = const Duration(minutes: 5)}) {
    return pumpSite(
      tester,
      PaymentScreen(args: args ?? argsWith(), interval: interval, giveUpAfter: giveUpAfter, onViewTickets: (c) => viewedTickets++, onBackToEvent: (c) => wentBack++),
      site: site,
      opened: opened,
      settle: false,
    );
  }

  Future<void> tick(WidgetTester tester, [Duration by = const Duration(seconds: 1)]) async {
    await tester.pump(by);
    await settleCalls(tester);
  }

  setUp(() {
    site = FakeWebsite();
    opened = [];
    viewedTickets = 0;
    wentBack = 0;
  });

  testWidgets('waits, asks the website about this payment every few seconds, and shows the ticket only once the website says it is paid', (tester) async {
    var calls = 0;
    site.functions['site-booking-status'] = (b) => ++calls < 3 ? (status: 200, body: {'status': 'pending'}) : (status: 200, body: paidAnswer());
    await open(tester);
    expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
    expect(find.byKey(const Key('payment-done')), findsNothing);
    expect(site.forFunction('site-booking-status'), isEmpty, reason: 'not before the first interval');

    await tick(tester);
    expect(site.forFunction('site-booking-status').single.body, {'session_id': 'cs_test_a1B2c3D4'});
    expect(find.byKey(const Key('payment-done')), findsNothing);
    await tick(tester);
    expect(find.byKey(const Key('payment-done')), findsNothing);
    await tick(tester);

    expect(find.byKey(const Key('payment-done')), findsOneWidget);
    expect(textOf(tester, 'paid-event'), 'Friday Night');
    expect(textOf(tester, 'paid-when'), formatWhen(parseWhen('2099-10-24T23:00:00Z')!));
    expect(textOf(tester, 'paid-line'), '2 × General');
    expect(tester.widget<SelectableText>(find.byKey(const Key('ticket-code'))).data, 'BU-ABCD2345');
    expect(find.byKey(const Key('ticket-qr')), findsOneWidget);
    expect(tester.widget<TicketQr>(find.byType(TicketQr)).code, 'BU-ABCD2345', reason: 'the door scans exactly the ticket code');
    expect(find.textContaining('We also sent it to dana@example.com'), findsOneWidget);

    final asked = site.forFunction('site-booking-status').length;
    await tick(tester, const Duration(seconds: 5));
    expect(site.forFunction('site-booking-status').length, asked, reason: 'it stops asking once paid');
  });

  testWidgets('"I have paid" asks straight away, without waiting for the next round', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: paidAnswer());
    await open(tester);
    await tester.tap(find.byKey(const Key('payment-check')));
    await settleCalls(tester);
    expect(find.byKey(const Key('payment-done')), findsOneWidget);
  });

  testWidgets('coming back to the app from the payment page asks straight away', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'pending'});
    await open(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settleCalls(tester);
    expect(site.forFunction('site-booking-status').length, 1);
  });

  testWidgets('"not found" so soon after paying is not a failure: it keeps waiting', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'not_found'});
    await open(tester);
    await tick(tester);
    await tick(tester);
    expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
    expect(find.byKey(const Key('payment-failed')), findsNothing);
  });

  testWidgets('a payment that failed says so, says nothing was charged, stops asking, and goes back to the event', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'failed'});
    await open(tester);
    await tick(tester);
    expect(find.byKey(const Key('payment-failed')), findsOneWidget);
    expect(find.textContaining('You have not been charged'), findsOneWidget);
    final asked = site.forFunction('site-booking-status').length;
    await tick(tester, const Duration(seconds: 5));
    expect(site.forFunction('site-booking-status').length, asked);
    await tester.tap(find.byKey(const Key('payment-retry')));
    expect(wentBack, 1);
  });

  testWidgets('if the website cannot be reached the person sees a plain sentence and it keeps trying; the sentence goes when it works again', (tester) async {
    var up = false;
    site.functions['site-booking-status'] = (b) => up ? (status: 200, body: paidAnswer()) : (status: 500, body: {'error': 'boom'});
    await open(tester);
    await tick(tester);
    expect(textOf(tester, 'payment-hint'), 'We could not check your payment. Check your connection and try again.');
    expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
    up = true;
    await tick(tester);
    expect(find.byKey(const Key('payment-done')), findsOneWidget);
    expect(find.byKey(const Key('payment-hint')), findsNothing);
  });

  testWidgets('after the give up time it says it has not seen the payment yet, offers My tickets, and Check again resumes the wait', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'pending'});
    await open(tester, interval: const Duration(seconds: 1), giveUpAfter: const Duration(seconds: 3));
    for (var i = 0; i < 4; i++) {
      await tick(tester);
    }
    expect(find.byKey(const Key('payment-stalled')), findsOneWidget);
    expect(find.textContaining('If you paid, it will appear in Bookings'), findsOneWidget);

    await tester.tap(find.byKey(const Key('payment-my-tickets')));
    expect(viewedTickets, 1);
    await tester.tap(find.byKey(const Key('payment-back')));
    expect(wentBack, 1);

    site.functions['site-booking-status'] = (b) => (status: 200, body: paidAnswer());
    await tester.tap(find.byKey(const Key('payment-check-again')));
    await settleCalls(tester);
    expect(find.byKey(const Key('payment-done')), findsOneWidget);
  });

  testWidgets('the payment page can be opened again, and the person can cancel', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'pending'});
    await open(tester);
    await tester.tap(find.byKey(const Key('payment-reopen')));
    await tester.pump();
    expect(opened, [payPage]);
    await tester.tap(find.byKey(const Key('payment-cancel')));
    expect(wentBack, 1);
  });

  testWidgets('View my tickets goes to the tickets', (tester) async {
    site.functions['site-booking-status'] = (b) => (status: 200, body: paidAnswer());
    await open(tester);
    await tick(tester);
    await tester.tap(find.byKey(const Key('view-tickets')));
    expect(viewedTickets, 1);
  });

  group('when the website did not say which payment it was', () {
    testWidgets('it looks for the order this person made just now, and shows the ticket when that order is paid', (tester) async {
      site.tables['site_orders'] = [orderRow(status: 'pending', code: null)];
      await open(tester, args: argsWith(sessionId: null));
      await tick(tester);
      expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
      final r = site.forTable('site_orders').last;
      expect([r.query['event_id'], r.query['tier_id']], ['eq.e1', 'eq.t1']);
      expect(site.forFunction('site-booking-status'), isEmpty);

      site.tables['site_orders'] = [orderRow()];
      await tick(tester);
      expect(find.byKey(const Key('payment-done')), findsOneWidget);
      expect(tester.widget<SelectableText>(find.byKey(const Key('ticket-code'))).data, 'BU-ABCD2345');
      expect(textOf(tester, 'paid-line'), '2 × General');
    });

    testWidgets('an order that failed ends the wait', (tester) async {
      site.tables['site_orders'] = [orderRow(status: 'failed', code: null)];
      await open(tester, args: argsWith(sessionId: null));
      await tick(tester);
      expect(find.byKey(const Key('payment-failed')), findsOneWidget);
    });

    testWidgets('no order yet keeps waiting', (tester) async {
      site.tables['site_orders'] = [];
      await open(tester, args: argsWith(sessionId: null));
      await tick(tester);
      expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
    });
  });

  group('paying for a table', () {
    PaymentWaitArgs tableArgs({String? sessionId = 'cs_test_tbl1'}) => PaymentWaitArgs.table(venueId: 'v1', venueName: 'Club A', start: CheckoutStart(url: payPage, sessionId: sessionId), startedAt: DateTime.utc(2099, 10, 20, 12));

    testWidgets('says what is being paid for and goes back to the venue', (tester) async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'pending'});
      await open(tester, args: tableArgs());
      expect(textOf(tester, 'payment-explained'), startsWith('Pay for your table at Club A on the page that opened.'));
      final back = <String>[];
      await pumpSite(tester, PaymentScreen(args: tableArgs(), onBackToEvent: (c) => back.add(tableArgs().backPath)), site: site, settle: false);
      await tester.tap(find.byKey(const Key('payment-cancel')));
      expect(back, ['/venues/v1']);
    });

    testWidgets('shows the confirmation only once the website says the table is booked: the code as a QR, where and when, and what was paid', (tester) async {
      var calls = 0;
      site.functions['site-booking-status'] = (b) => ++calls < 2 ? (status: 200, body: {'status': 'pending'}) : (status: 200, body: paidBookingAnswer());
      await open(tester, args: tableArgs());
      await tick(tester);
      expect(find.byKey(const Key('payment-done')), findsNothing);
      expect(site.forFunction('site-booking-status').single.body, {'session_id': 'cs_test_tbl1'});
      await tick(tester);
      expect(find.byKey(const Key('payment-done')), findsOneWidget);
      expect(find.text('Your table is booked!'), findsOneWidget);
      expect(textOf(tester, 'paid-venue'), 'Club A');
      expect(textOf(tester, 'paid-table'), 'Booth 1 · 4 guests');
      expect(textOf(tester, 'paid-arrival'), 'Sat, Nov 7 · Arrival 10:00 PM');
      expect(tester.widget<TicketQr>(find.byType(TicketQr)).code, 'TB-ABCD2345');
      expect(textOf(tester, 'paid-deposit'), '\$100.00');
      expect(textOf(tester, 'paid-tax'), '\$13.00');
      expect(textOf(tester, 'paid-now'), '\$113.00');
      expect(find.byKey(const Key('paid-due')), findsNothing);
      expect(find.textContaining('We also sent it to dana@example.com'), findsOneWidget);
    });

    testWidgets('bottles left for the club are listed as such, with what is still owed there', (tester) async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: paidBookingAnswer(bottles: 25000, due: 25000));
      await open(tester, args: tableArgs());
      await tick(tester);
      expect(find.textContaining('Grey Goose (1.75L) × 1 · pay at the club'), findsOneWidget);
      expect(textOf(tester, 'paid-now'), '\$113.00');
      expect(textOf(tester, 'paid-due'), '\$250.00');
      expect(find.text('Paid now'), findsOneWidget);
      expect(find.text('To pay at the club'), findsOneWidget);
    });

    testWidgets('View my bookings goes to the bookings', (tester) async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: paidBookingAnswer());
      await open(tester, args: tableArgs());
      await tick(tester);
      await tester.tap(find.byKey(const Key('view-bookings')));
      expect(viewedTickets, 1);
    });

    testWidgets('by default, View my bookings opens the Bookings tab on the tables, and for tickets on the tickets', (tester) async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: paidBookingAnswer());
      late ProviderContainer container;
      Future<void> run(PaymentWaitArgs args) async {
        final router = GoRouter(routes: [
          GoRoute(path: '/', builder: (c, s) => PaymentScreen(args: args, interval: const Duration(seconds: 1))),
          GoRoute(path: '/home', builder: (c, s) => const Scaffold(body: Text('home', key: Key('home')))),
        ]);
        tester.view.physicalSize = const Size(800, 2200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ));
        await tester.pump();
        await tick(tester);
        await tester.tap(find.byKey(const Key('view-bookings')));
        await tester.pumpAndSettle();
      }

      container = ProviderContainer(overrides: [siteClientProvider.overrideWithValue(site.client)]);
      addTearDown(container.dispose);
      await run(tableArgs());
      expect(find.byKey(const Key('home')), findsOneWidget);
      expect(container.read(mainNavIndexProvider), MainTab.bookings);
      expect(container.read(bookingsSegmentProvider), BookingsSegment.tables);
    });

    testWidgets('a payment the website did not name cannot be looked up for a table, so it keeps waiting and never invents a booking', (tester) async {
      site.tables['site_orders'] = [orderRow()];
      await open(tester, args: tableArgs(sessionId: null));
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
      expect(site.forTable('site_orders'), isEmpty);
      expect(site.forFunction('site-booking-status'), isEmpty);
    });

    testWidgets('a table payment that failed says so, like a ticket', (tester) async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'failed'});
      await open(tester, args: tableArgs());
      await tick(tester);
      expect(find.byKey(const Key('payment-failed')), findsOneWidget);
    });
  });
}
