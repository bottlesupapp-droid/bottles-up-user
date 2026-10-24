import 'package:bottles_up_user/features/tables/screens/table_booking_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String m(int cents) => formatMoney(cents);

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_tbl1B2c3#frag';

void main() {
  late FakeWebsite site;
  late List<PaymentWaitArgs> started;
  late List<Uri> opened;

  void venue({String mode = 'pay_ahead', bool credit = false}) {
    site.tables['site_venues'] = [
      venueRow(
        mode: mode,
        credit: credit,
        tables: [
          tableTypeRow(id: 'tt1', name: 'Booth 1', maxGuests: 6, deposit: 10000),
          tableTypeRow(id: 'tt2', name: 'Dance floor', maxGuests: 8, mode: 'hourly', rate: 15000, minHours: 2),
          tableTypeRow(id: 'tt3', name: 'Stool', maxGuests: 1, deposit: 5000),
        ],
        slots: [slotRow(id: 's1', day: 5, time: '22:00:00'), slotRow(id: 'late', day: 5, time: '01:00:00'), slotRow(id: 'sat', day: 6, time: '22:00:00')],
      ),
    ];
  }

  Future<void> open(WidgetTester tester, {String table = 'tt1', String? date = '2026-10-30', String? slot = 's1', Account? account = signedIn, bool canOpen = true}) {
    return pumpSite(
      tester,
      TableBookingScreen(venueId: 'v1', tableId: table, dateKey: date, slotId: slot, now: DateTime(2026, 10, 24), onStarted: (c, a) => started.add(a)),
      site: site,
      account: account,
      opened: opened,
      canOpen: canOpen,
    );
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  Future<void> toBottles(WidgetTester tester) => tap(tester, 'to-bottles');

  Future<void> toReview(WidgetTester tester) async {
    await toBottles(tester);
    await tap(tester, 'to-review');
  }

  setUp(() {
    site = FakeWebsite();
    started = [];
    opened = [];
    venue();
    site.tables['site_bottles'] = [bottleRow(id: 'b1', price: 25000), bottleRow(id: 'b2', name: 'Don Julio', size: null, price: 40000, sort: 1)];
    site.tables['site_content'] = [
      {'bottlesup_fee_bps': 250}
    ];
    site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: [{'has_policy': true, 'lines': ['Full refund up to 48 hours before arrival.', 'No refund after check-in.']}]);
    site.functions['create-table-booking-checkout'] = (b) => (status: 200, body: {'url': payUrl});
    site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': true, 'discountCents': 1000, 'message': '10 dollars off'});
  });

  group('step 1: your table', () {
    testWidgets('shows the table, venue, day and arrival time, and fills in the details from the account', (tester) async {
      await open(tester);
      expect(textOf(tester, 'booking-table'), 'Booth 1');
      expect(textOf(tester, 'booking-venue'), 'Club A');
      expect(textOf(tester, 'booking-when'), 'Fri, Oct 30 · 10:00 PM');
      expect(find.byKey(const Key('booking-arrival-note')), findsNothing);
      expect(textOf(tester, 'guests'), '2');
      expect(tester.widget<TextField>(find.byKey(const Key('buyer-name'))).controller!.text, 'Dana Lee');
      expect(tester.widget<TextField>(find.byKey(const Key('buyer-phone'))).controller!.text, '416-555-0100');
      expect(textOf(tester, 'buyer-email'), 'dana@example.com');
      expect(textOf(tester, 'table-amount'), m(10000));
    });

    testWidgets('an after-midnight time shows the day the guests arrive', (tester) async {
      await open(tester, slot: 'late');
      expect(textOf(tester, 'booking-when'), 'Sat, Oct 31 · 1:00 AM');
      expect(textOf(tester, 'booking-arrival-note'), 'Friday night\'s event - you\'ll be arriving Saturday, 1:00 AM.');
    });

    testWidgets('guests stay between one and what the table seats', (tester) async {
      await open(tester);
      for (var i = 0; i < 10; i++) {
        await tester.ensureVisible(find.byKey(const Key('guests-plus')));
        await tester.tap(find.byKey(const Key('guests-plus')), warnIfMissed: false);
        await tester.pump();
      }
      expect(textOf(tester, 'guests'), '6');
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byKey(const Key('guests-minus')), warnIfMissed: false);
        await tester.pump();
      }
      expect(textOf(tester, 'guests'), '1');
    });

    testWidgets('a table that states a minimum number of guests starts there', (tester) async {
      site.tables['site_venues'] = [
        venueRow(tables: [
          {...tableTypeRow(id: 'tt1', maxGuests: 8), 'min_guests': 4}
        ], slots: [slotRow(id: 's1')]),
      ];
      await open(tester);
      expect(textOf(tester, 'guests'), '4');
    });

    testWidgets('a table for one starts at one guest', (tester) async {
      await open(tester, table: 'tt3');
      expect(textOf(tester, 'guests'), '1');
    });

    testWidgets('an hourly table starts at its minimum hours, never goes below, and the total follows the hours', (tester) async {
      await open(tester, table: 'tt2');
      expect(textOf(tester, 'hours'), '2');
      expect(textOf(tester, 'table-amount'), m(30000));
      expect(tester.widget<IconButton>(find.byKey(const Key('hours-minus'))).onPressed, isNull);
      await tester.tap(find.byKey(const Key('hours-plus')));
      await tester.pump();
      expect(textOf(tester, 'hours'), '3');
      expect(textOf(tester, 'table-amount'), m(45000));
      expect(find.text('Table total (3 hr)'), findsOneWidget);
    });

    testWidgets('a flat table has no hours', (tester) async {
      await open(tester);
      expect(find.byKey(const Key('hours')), findsNothing);
    });

    testWidgets('a missing name is caught before going on', (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('buyer-name')), 'D');
      await tap(tester, 'to-bottles');
      expect(textOf(tester, 'booking-problem'), 'Enter your name (at least 2 letters).');
      expect(find.byKey(const Key('booking-bottles-step')), findsNothing);
    });

    testWidgets('continuing goes to the bottles', (tester) async {
      await open(tester);
      await toBottles(tester);
      expect(find.byKey(const Key('booking-bottles-step')), findsOneWidget);
    });
  });

  group('step 2: bottles', () {
    testWidgets('lists the bottle menu, counts them, and adds up the bottles', (tester) async {
      await open(tester);
      await toBottles(tester);
      expect(textOf(tester, 'bottle-name-b1'), 'Grey Goose (1.75L)');
      expect(textOf(tester, 'bottle-price-b1'), m(25000));
      expect(textOf(tester, 'bottle-name-b2'), 'Don Julio');
      expect(find.byKey(const Key('bottle-subtotal')), findsNothing);
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'bottle-plus-b2');
      expect(textOf(tester, 'bottle-qty-b1'), '2');
      expect(textOf(tester, 'bottle-subtotal'), m(90000));
      await tap(tester, 'bottle-minus-b1');
      await tap(tester, 'bottle-minus-b2');
      expect(textOf(tester, 'bottle-subtotal'), m(25000));
      expect(tester.widget<IconButton>(find.byKey(const Key('bottle-minus-b2'))).onPressed, isNull);
    });

    testWidgets('a venue with no bottle menu says so and the booking can go on without bottles', (tester) async {
      site.tables['site_bottles'] = [];
      await open(tester);
      await toBottles(tester);
      expect(find.byKey(const Key('no-bottles')), findsOneWidget);
      await tap(tester, 'to-review');
      expect(find.byKey(const Key('booking-review-step')), findsOneWidget);
    });

    testWidgets('if the menu cannot be loaded the person is told and can still go on without bottles', (tester) async {
      await open(tester);
      site.tables['site_bottles'] = [];
      site.failAllWith = 500;
      await toBottles(tester);
      expect(textOf(tester, 'load-failed-message'), 'We could not load the bottle menu. Check your connection and try again.');
      site.failAllWith = null;
      await tap(tester, 'load-failed-retry');
      expect(find.byKey(const Key('no-bottles')), findsOneWidget);
    });

    testWidgets('where the venue takes bottle payment ahead, it says bottles are charged now', (tester) async {
      await open(tester);
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      expect(find.byKey(const Key('bottles-ahead')), findsOneWidget);
      expect(find.byKey(const Key('pay-at-club')), findsNothing);
    });

    testWidgets('where the venue takes bottle payment at the club, it says only the table is charged now', (tester) async {
      venue(mode: 'pay_at_club');
      await open(tester);
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      expect(find.byKey(const Key('bottles-at-club')), findsOneWidget);
    });

    testWidgets('where the venue allows both, the guest chooses, but only once there are bottles', (tester) async {
      venue(mode: 'both');
      await open(tester);
      await toBottles(tester);
      expect(find.byKey(const Key('pay-at-club')), findsNothing);
      await tap(tester, 'bottle-plus-b1');
      expect(find.byKey(const Key('pay-ahead')), findsOneWidget);
      expect(find.byKey(const Key('pay-at-club')), findsOneWidget);
    });

    testWidgets('going back keeps what was entered', (tester) async {
      await open(tester);
      await tap(tester, 'guests-plus');
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'back');
      expect(textOf(tester, 'guests'), '3');
      await toBottles(tester);
      expect(textOf(tester, 'bottle-qty-b1'), '1');
    });
  });

  group('step 3: review and pay', () {
    testWidgets('a table alone: the deposit, tax and the BottlesUp fee add up to what is due today', (tester) async {
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'line-table-value'), m(10000));
      expect(textOf(tester, 'line-tax-value'), m(1300));
      expect(textOf(tester, 'line-fee-value'), m(250));
      expect(textOf(tester, 'line-total-value'), m(11550));
      expect(find.byKey(const Key('due-at-club')), findsNothing);
      expect(find.byKey(const Key('line-discount')), findsNothing);
    });

    testWidgets('bottles paid ahead are charged now with the rest', (tester) async {
      await open(tester);
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'to-review');
      expect(textOf(tester, 'line-bottle-b1-value'), m(25000));
      expect(textOf(tester, 'line-tax-value'), m(4550));
      expect(textOf(tester, 'line-fee-value'), m(875));
      expect(textOf(tester, 'line-total-value'), m(40425));
      expect(find.byKey(const Key('due-at-club')), findsNothing);
    });

    testWidgets('bottles paid at the club are not charged now: only the table is, and the club is owed the bottles', (tester) async {
      venue(mode: 'both');
      await open(tester);
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'pay-at-club');
      await tap(tester, 'to-review');
      expect(textOf(tester, 'line-total-value'), m(11550));
      expect(textOf(tester, 'due-at-club-value'), m(25000));
      expect(find.textContaining('pay at the club'), findsWidgets);
    });

    testWidgets('when the deposit counts as credit, the club asks only for what is left after it', (tester) async {
      venue(mode: 'pay_at_club', credit: true);
      await open(tester);
      await toBottles(tester);
      await tap(tester, 'bottle-plus-b1');
      await tap(tester, 'to-review');
      expect(textOf(tester, 'due-at-club-value'), m(15000));
      expect(textOf(tester, 'line-total-value'), m(11550));
    });

    testWidgets('an hourly table is charged for its hours', (tester) async {
      await open(tester, table: 'tt2');
      await toReview(tester);
      expect(find.text('Table (2 hr)'), findsOneWidget);
      expect(textOf(tester, 'line-table-value'), m(30000));
      expect(textOf(tester, 'line-tax-value'), m(3900));
    });

    testWidgets('the venue\'s refund terms are shown before paying, and nothing is shown when it has none', (tester) async {
      await open(tester);
      await toReview(tester);
      expect(find.byKey(const Key('refund-policy')), findsOneWidget);
      expect(find.text('•  Full refund up to 48 hours before arrival.'), findsOneWidget);
      expect(find.text('•  No refund after check-in.'), findsOneWidget);
    });

    testWidgets('no refund terms: no box', (tester) async {
      site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: <Object>[]);
      await open(tester);
      await toReview(tester);
      expect(find.byKey(const Key('refund-policy')), findsNothing);
    });

    testWidgets('if the fee cannot be read the screen says a fee may be added on the payment page', (tester) async {
      site.tables['site_content'] = [];
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'booking-explained'), contains('A BottlesUp fee may be added there.'));
      expect(textOf(tester, 'line-total-value'), m(11300));
    });

    group('promo code', () {
      testWidgets('a good code is asked for the tables, comes off before tax and fee, and is sent with the booking', (tester) async {
        await open(tester);
        await toReview(tester);
        await tester.enterText(find.byKey(const Key('promo-code')), 'save10');
        await tap(tester, 'apply-promo');
        await settleCalls(tester);
        expect(site.forFunction('validate-promo-code').single.body, {'code': 'save10', 'applies_to': 'tables', 'venue_id': 'v1', 'subtotal_cents': 10000});
        expect(textOf(tester, 'promo-applied'), 'SAVE10 applied');
        expect(textOf(tester, 'line-discount-value'), '-${m(1000)}');
        expect(textOf(tester, 'line-tax-value'), m(1170));
        expect(textOf(tester, 'line-fee-value'), m(225));
        expect(textOf(tester, 'line-total-value'), m(10395));

        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(site.forFunction('create-table-booking-checkout').single.body['promo_code'], 'SAVE10');
      });

      testWidgets('a code that does not work shows why and is not sent', (tester) async {
        site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': false, 'message': 'This code has expired'});
        await open(tester);
        await toReview(tester);
        await tester.enterText(find.byKey(const Key('promo-code')), 'OLD');
        await tap(tester, 'apply-promo');
        await settleCalls(tester);
        expect(textOf(tester, 'promo-message'), 'This code has expired');
        expect(find.byKey(const Key('line-discount')), findsNothing);
        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(site.forFunction('create-table-booking-checkout').single.body.containsKey('promo_code'), isFalse);
      });

      testWidgets('a code can be removed', (tester) async {
        await open(tester);
        await toReview(tester);
        await tester.enterText(find.byKey(const Key('promo-code')), 'SAVE10');
        await tap(tester, 'apply-promo');
        await settleCalls(tester);
        await tap(tester, 'remove-promo');
        expect(find.byKey(const Key('promo-applied')), findsNothing);
        expect(textOf(tester, 'line-total-value'), m(11550));
      });

      testWidgets('going back to change the bottles drops the code, because the discount depends on the total', (tester) async {
        await open(tester);
        await toReview(tester);
        await tester.enterText(find.byKey(const Key('promo-code')), 'SAVE10');
        await tap(tester, 'apply-promo');
        await settleCalls(tester);
        await tap(tester, 'back');
        await tap(tester, 'to-review');
        expect(find.byKey(const Key('promo-applied')), findsNothing);
        expect(textOf(tester, 'line-total-value'), m(11550));
      });
    });

    group('paying', () {
      testWidgets('sends the choices and not a price, opens Stripe\'s page in the app, and hands over to the waiting screen for a table', (tester) async {
        venue(mode: 'both');
        await open(tester);
        await tap(tester, 'guests-plus');
        await tester.enterText(find.byKey(const Key('buyer-name')), '  Dana  Lee ');
        await toBottles(tester);
        await tap(tester, 'bottle-plus-b1');
        await tap(tester, 'bottle-plus-b1');
        await tap(tester, 'bottle-plus-b2');
        await tap(tester, 'pay-at-club');
        await tap(tester, 'to-review');
        await tap(tester, 'pay');
        await settleCalls(tester);

        expect(site.forFunction('create-table-booking-checkout').single.body, {
          'venue_id': 'v1',
          'table_type_id': 'tt1',
          'time_slot_id': 's1',
          'booking_date': '2026-10-30',
          'guest_count': 3,
          'customer_name': 'Dana  Lee',
          'customer_email': 'dana@example.com',
          'customer_phone': '416-555-0100',
          'bottles': [
            {'bottle_id': 'b1', 'quantity': 2},
            {'bottle_id': 'b2', 'quantity': 1},
          ],
          'bottle_payment_choice': 'pay_at_club',
        });
        expect(opened.single.toString(), payUrl);
        final args = started.single;
        expect(args.kind, PaymentKind.table);
        expect(args.start.sessionId, 'cs_test_tbl1B2c3');
        expect(args.title, 'your table at Club A');
        expect(args.backPath, '/venues/v1');
      });

      testWidgets('an hourly table sends its hours', (tester) async {
        await open(tester, table: 'tt2');
        await toReview(tester);
        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(site.forFunction('create-table-booking-checkout').single.body['hours'], 2);
      });

      testWidgets('a flat table sends no hours', (tester) async {
        await open(tester);
        await toReview(tester);
        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(site.forFunction('create-table-booking-checkout').single.body.containsKey('hours'), isFalse);
      });

      testWidgets('with no bottles chosen the choice sent is pay ahead whatever the venue allows', (tester) async {
        venue(mode: 'pay_at_club');
        await open(tester);
        await toReview(tester);
        await tap(tester, 'pay');
        await settleCalls(tester);
        final sent = site.forFunction('create-table-booking-checkout').single.body;
        expect(sent['bottles'], isEmpty);
        expect(sent['bottle_payment_choice'], 'pay_ahead');
      });

      testWidgets('tapping Pay twice quickly makes one booking', (tester) async {
        await open(tester);
        await toReview(tester);
        await tester.ensureVisible(find.byKey(const Key('pay')));
        await tester.tap(find.byKey(const Key('pay')));
        await tester.tap(find.byKey(const Key('pay')), warnIfMissed: false);
        await settleCalls(tester);
        expect(site.forFunction('create-table-booking-checkout').length, 1);
        expect(started.length, 1);
      });

      testWidgets('when the website refuses (no tables left) the person reads its sentence, nothing is opened and they can try again', (tester) async {
        site.functions['create-table-booking-checkout'] = (b) => (status: 409, body: {'error': 'No tables of this type left for that date and time'});
        await open(tester);
        await toReview(tester);
        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(textOf(tester, 'booking-problem'), 'No tables of this type left for that date and time');
        expect(opened, isEmpty);
        expect(started, isEmpty);
        expect(tester.widget<FilledButton>(find.byKey(const Key('pay'))).onPressed, isNotNull);
      });

      testWidgets('if the payment page cannot be opened the person is told and is not sent on', (tester) async {
        await open(tester, canOpen: false);
        await toReview(tester);
        await tap(tester, 'pay');
        await settleCalls(tester);
        expect(textOf(tester, 'booking-problem'), startsWith('We could not open the payment page.'));
        expect(started, isEmpty);
      });
    });
  });

  group('when the booking cannot be made', () {
    testWidgets('no date or time in the address asks to choose them first', (tester) async {
      await open(tester, date: null, slot: null);
      expect(find.text('Choose a date and time first'), findsOneWidget);
    });

    testWidgets('a time of another weekday than the night is not accepted', (tester) async {
      await open(tester, slot: 'sat');
      expect(find.text('Choose a date and time first'), findsOneWidget);
    });

    testWidgets('a night that cannot be read is not accepted', (tester) async {
      await open(tester, date: 'next-friday');
      expect(find.text('Choose a date and time first'), findsOneWidget);
    });

    testWidgets('a table the venue does not have says it is no longer available', (tester) async {
      await open(tester, table: 'gone');
      expect(find.text('This table is no longer available'), findsOneWidget);
    });

    testWidgets('a venue the website no longer shows says the same', (tester) async {
      site.tables['site_venues'] = [];
      await open(tester);
      expect(find.text('This table is no longer available'), findsOneWidget);
    });

    testWidgets('someone who is not signed in is asked to sign in', (tester) async {
      await open(tester, account: null);
      expect(find.text('Sign in to book a table'), findsOneWidget);
      expect(find.byKey(const Key('to-bottles')), findsNothing);
    });

    testWidgets('a night in the past is caught when continuing', (tester) async {
      await open(tester, date: '2026-10-23', slot: 's1');
      // 2026-10-23 is a Friday, so the time fits the weekday; the night itself has passed.
      await tap(tester, 'to-bottles');
      expect(textOf(tester, 'booking-problem'), 'That date has passed.');
    });
  });

  group('what the deposit means', () {
    testWidgets('where the deposit counts toward the minimum spend it says how much is left to spend at the venue', (tester) async {
      venue(credit: true);
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'min-spend-note'), 'This table has a minimum spend of ${m(50000)}. Your ${m(10000)} deposit counts toward it, so ${m(40000)} is left to spend at the venue.');
    });

    testWidgets('where it does not count it says so', (tester) async {
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'min-spend-note'), 'This table has a minimum spend of ${m(50000)}, spent at the venue. Your ${m(10000)} deposit does not count toward it.');
    });

    testWidgets('a deposit bigger than the minimum leaves nothing, never a negative', (tester) async {
      venue(credit: true);
      site.tables['site_venues'] = [
        venueRow(credit: true, tables: [tableTypeRow(id: 'tt1', minSpend: 8000, deposit: 10000)], slots: [slotRow(id: 's1')]),
      ];
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'min-spend-note'), contains('so ${m(0)} is left to spend'));
    });

    testWidgets('an hourly table has no minimum spend note, and no included passes means no passes note', (tester) async {
      await open(tester, table: 'tt2');
      await toReview(tester);
      expect(find.byKey(const Key('min-spend-note')), findsNothing);
      expect(find.byKey(const Key('passes-note')), findsNothing);
    });

    testWidgets('included entry passes are explained, and that seating is not passes', (tester) async {
      site.tables['site_venues'] = [
        venueRow(tables: [
          {...tableTypeRow(id: 'tt1', maxGuests: 10), 'included_admissions': 4}
        ], slots: [slotRow(id: 's1')]),
      ];
      await open(tester);
      await toReview(tester);
      expect(textOf(tester, 'passes-note'), 'Includes 4 entry passes. Your table seating 10 does not mean 10 passes.');
    });
  });
}
