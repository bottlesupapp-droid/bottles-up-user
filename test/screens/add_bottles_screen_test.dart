import 'package:bottles_up_user/features/bookings_site/screens/add_bottles_screen.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String m(int c) => formatMoney(c);

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_addon9#frag';

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  late int wentBack;

  void venue({String mode = 'pay_ahead'}) => site.tables['site_venues'] = [venueRow(mode: mode, taxBps: 1300)];

  Future<void> open(WidgetTester tester, {bool canOpen = true, Duration giveUpAfter = const Duration(minutes: 5)}) async {
    await pumpSite(tester, AddBottlesScreen(bookingId: 'bk1', interval: const Duration(seconds: 1), giveUpAfter: giveUpAfter, onBack: (c) => wentBack++), site: site, opened: opened, canOpen: canOpen, settle: false);
    await settleCalls(tester);
    await settleCalls(tester);
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> tick(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await settleCalls(tester);
  }

  setUp(() {
    site = FakeWebsite();
    opened = [];
    wentBack = 0;
    site.tables['site_table_bookings'] = [bookingRow()];
    for (final t in ['site_table_booking_bottles', 'site_table_booking_club_payments', 'site_table_booking_refunds', 'site_table_booking_bottle_substitutions']) {
      site.tables[t] = [];
    }
    venue();
    site.tables['site_bottles'] = [bottleRow(id: 'b1', price: 25000), bottleRow(id: 'b2', name: 'Don Julio', size: null, price: 40000, sort: 1)];
    site.tables['site_content'] = [
      {'bottlesup_fee_bps': 250}
    ];
    site.functions['add-table-booking-bottles'] = (b) => (status: 200, body: {'success': true, 'mode': 'pay_ahead', 'url': payUrl});
    site.functions['confirm-bottle-addon'] = (b) => (status: 200, body: {'status': 'pending'});
  });

  testWidgets('shows the venue\'s bottle menu and adds up the order', (tester) async {
    await open(tester);
    expect(textOf(tester, 'bottle-name-b1'), 'Grey Goose (1.75L)');
    expect(find.byKey(const Key('addon-subtotal')), findsNothing);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'bottle-plus-b2');
    expect(textOf(tester, 'addon-subtotal'), m(90000));
    expect(site.forTable('site_bottles').single.query['venue_id'], 'eq.v1');
  });

  testWidgets('paid now: tax and the BottlesUp fee are on the bottles alone, as the website works them out', (tester) async {
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    expect(textOf(tester, 'addon-tax'), m(3250));
    expect(textOf(tester, 'addon-fee'), m(625));
    expect(textOf(tester, 'addon-total'), m(28875));
    expect(find.byKey(const Key('bottles-ahead')), findsOneWidget);
  });

  testWidgets('paid at the club: nothing is charged now and the bottles are what is owed at the club', (tester) async {
    venue(mode: 'pay_at_club');
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    expect(find.byKey(const Key('addon-tax')), findsNothing);
    expect(textOf(tester, 'addon-total'), m(25000));
    expect(find.text('To pay at the club'), findsOneWidget);
    expect(find.byKey(const Key('bottles-at-club')), findsOneWidget);
  });

  testWidgets('where the venue allows both, the guest chooses, and the total follows', (tester) async {
    venue(mode: 'both');
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    expect(textOf(tester, 'addon-total'), m(28875));
    await tap(tester, 'pay-at-club');
    expect(textOf(tester, 'addon-total'), m(25000));
    await tap(tester, 'pay-ahead');
    expect(textOf(tester, 'addon-total'), m(28875));
  });

  testWidgets('ordering to pay at the club is recorded and said plainly, and the bookings are read again', (tester) async {
    venue(mode: 'both');
    site.functions['add-table-booking-bottles'] = (b) => (status: 200, body: {'success': true, 'mode': 'due_at_venue'});
    await open(tester);
    await tap(tester, 'bottle-plus-b2');
    await tap(tester, 'pay-at-club');
    final before = site.forTable('site_table_bookings').length;
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(site.forFunction('add-table-booking-bottles').single.body, {
      'booking_id': 'bk1',
      'bottles': [
        {'bottle_id': 'b2', 'quantity': 1}
      ],
      'bottle_payment_choice': 'pay_at_club',
    });
    expect(find.byKey(const Key('addon-done')), findsOneWidget);
    expect(textOf(tester, 'addon-done-text'), 'You pay for them at the club. They are on your booking.');
    expect(opened, isEmpty);
    expect(site.forTable('site_table_bookings').length, greaterThan(before));
    await tap(tester, 'addon-back');
    expect(wentBack, 1);
  });

  testWidgets('paying now opens the payment page in the app, waits for the website, and says it is paid only when the website does', (tester) async {
    var calls = 0;
    site.functions['confirm-bottle-addon'] = (b) => ++calls < 3 ? (status: 200, body: {'status': 'pending'}) : (status: 200, body: {'status': 'paid', 'booking_id': 'bk1'});
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    expect(opened.single.toString(), payUrl);
    expect(site.forFunction('add-table-booking-bottles').single.body.containsKey('bottle_payment_choice'), isFalse);
    expect(find.byKey(const Key('addon-waiting')), findsOneWidget);
    await tick(tester);
    await tick(tester);
    expect(find.byKey(const Key('addon-done')), findsNothing);
    await tick(tester);
    expect(site.forFunction('confirm-bottle-addon').first.body, {'session_id': 'cs_test_addon9'});
    expect(find.byKey(const Key('addon-done')), findsOneWidget);
    expect(textOf(tester, 'addon-done-text'), 'They are on your booking.');
    final asked = site.forFunction('confirm-bottle-addon').length;
    await tick(tester);
    expect(site.forFunction('confirm-bottle-addon').length, asked, reason: 'it stops asking once paid');
  });

  testWidgets('"I have paid" asks straight away', (tester) async {
    site.functions['confirm-bottle-addon'] = (b) => (status: 200, body: {'status': 'paid', 'booking_id': 'bk1'});
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    await tap(tester, 'addon-check');
    await settleCalls(tester);
    expect(find.byKey(const Key('addon-done')), findsOneWidget);
  });

  testWidgets('if the website cannot be reached the person sees a plain sentence and it keeps trying', (tester) async {
    var up = false;
    site.functions['confirm-bottle-addon'] = (b) => up ? (status: 200, body: {'status': 'paid'}) : (status: 500, body: {'error': 'boom'});
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    await tick(tester);
    expect(textOf(tester, 'addon-hint'), 'We could not check your payment. Check your connection and try again.');
    up = true;
    await tick(tester);
    expect(find.byKey(const Key('addon-done')), findsOneWidget);
  });

  testWidgets('after the give up time it says it has not seen the payment, and Check again resumes', (tester) async {
    await open(tester, giveUpAfter: const Duration(seconds: 3));
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    for (var i = 0; i < 4; i++) {
      await tick(tester);
    }
    expect(find.byKey(const Key('addon-stalled')), findsOneWidget);
    expect(find.textContaining('If you paid, your bottles will show on your booking'), findsOneWidget);
    site.functions['confirm-bottle-addon'] = (b) => (status: 200, body: {'status': 'paid'});
    await tap(tester, 'addon-check');
    await settleCalls(tester);
    expect(find.byKey(const Key('addon-done')), findsOneWidget);
  });

  testWidgets('the payment page can be opened again from the waiting screen, and the person can go back to their booking', (tester) async {
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    await tap(tester, 'addon-reopen');
    expect(opened.length, 2);
    await tap(tester, 'addon-leave');
    expect(wentBack, 1);
  });

  testWidgets('an order already waiting on payment is said, and its page can be opened to finish it', (tester) async {
    site.functions['add-table-booking-bottles'] = (b) => (status: 409, body: {'error': 'You already have an order waiting on payment. Finish or cancel it before adding more.', 'pending_checkout_url': 'https://checkout.stripe.com/c/pay/cs_test_wait7#f'});
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    expect(textOf(tester, 'addon-problem'), startsWith('You already have an order waiting on payment.'));
    await tap(tester, 'addon-resume');
    await settleCalls(tester);
    expect(opened.single.toString(), 'https://checkout.stripe.com/c/pay/cs_test_wait7#f');
    expect(find.byKey(const Key('addon-waiting')), findsOneWidget);
    await tick(tester);
    expect(site.forFunction('confirm-bottle-addon').first.body, {'session_id': 'cs_test_wait7'});
  });

  testWidgets('a refusal (not enough in stock) is the website\'s own sentence, and the order can be changed and tried again', (tester) async {
    site.functions['add-table-booking-bottles'] = (b) => (status: 409, body: {'error': 'Not enough "Grey Goose" left in stock'});
    await open(tester);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    expect(textOf(tester, 'addon-problem'), 'Not enough "Grey Goose" left in stock');
    expect(tester.widget<FilledButton>(find.byKey(const Key('add-confirm'))).onPressed, isNotNull);
    expect(opened, isEmpty);
  });

  testWidgets('if the payment page cannot be opened the person is told and nothing is waited for', (tester) async {
    await open(tester, canOpen: false);
    await tap(tester, 'bottle-plus-b1');
    await tap(tester, 'add-confirm');
    await settleCalls(tester);
    expect(textOf(tester, 'addon-problem'), startsWith('We could not open the payment page.'));
    expect(find.byKey(const Key('addon-waiting')), findsNothing);
  });

  testWidgets('tapping Order twice quickly makes one order, and with nothing chosen there is nothing to send', (tester) async {
    await open(tester);
    expect(tester.widget<FilledButton>(find.byKey(const Key('add-confirm'))).onPressed, isNull);
    await tap(tester, 'bottle-plus-b1');
    await tester.ensureVisible(find.byKey(const Key('add-confirm')));
    await tester.tap(find.byKey(const Key('add-confirm')));
    await tester.tap(find.byKey(const Key('add-confirm')), warnIfMissed: false);
    await settleCalls(tester);
    expect(site.forFunction('add-table-booking-bottles').length, 1);
  });

  testWidgets('a booking that is not confirmed cannot order bottles', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow(status: 'cancelled')];
    await open(tester);
    expect(find.text('Bottles cannot be added here'), findsOneWidget);
  });

  testWidgets('a venue with no bottle menu says so', (tester) async {
    site.tables['site_bottles'] = [];
    await open(tester);
    expect(find.text('No bottle menu yet'), findsOneWidget);
  });

  testWidgets('if the menu cannot be loaded the person is told and can try again', (tester) async {
    site.failTables.add('site_bottles');
    await open(tester);
    expect(textOf(tester, 'load-failed-message'), 'We could not load the bottle menu. Check your connection and try again.');
    site.failTables.clear();
    await tap(tester, 'load-failed-retry');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(find.byKey(const Key('bottle-b1')), findsOneWidget);
  });
}
