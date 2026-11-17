import 'package:bottles_up_user/features/bookings_site/screens/table_booking_detail_screen.dart';
import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String m(int c) => formatMoney(c);

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  late List<String> shared;
  late List<TableBooking> toBottles;

  void paidBooking({Map<String, dynamic>? over}) {
    site.tables['site_table_bookings'] = [
      {...bookingRow(bottles: 25000, total: 36300, paid: 11300, choice: 'pay_at_club'), ...?over}
    ];
  }

  Future<void> open(WidgetTester tester, {DateTime? now}) async {
    await pumpSite(
      tester,
      TableBookingDetailScreen(bookingId: 'bk1', now: now ?? DateTime(2099, 11, 1), onAddBottles: (c, b) => toBottles.add(b), share: (t) async => shared.add(t)),
      site: site,
      opened: opened,
      settle: false,
    );
    await settleCalls(tester);
    await settleCalls(tester);
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  setUp(() {
    site = FakeWebsite();
    opened = [];
    shared = [];
    toBottles = [];
    paidBooking();
    site.tables['site_table_booking_bottles'] = [bottleLineRow(payment: 'due_at_venue')];
    site.tables['site_table_booking_club_payments'] = [];
    site.tables['site_table_booking_refunds'] = [];
    site.tables['site_table_booking_bottle_substitutions'] = [];
    site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer());
    site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: [{'has_policy': true, 'lines': ['Full refund up to 48 hours before arrival.']}]);
  });

  group('the night, in sections', () {
    testWidgets('a confirmed booking that is coming up has every section', (tester) async {
      await open(tester);
      for (final k in ['section-entry', 'section-reservation', 'section-guests', 'section-payments', 'section-orders', 'section-getting-there']) {
        expect(find.byKey(Key(k)), findsOneWidget, reason: k);
      }
    });

    testWidgets('a cancelled booking has no guests and no orders to manage', (tester) async {
      paidBooking(over: {'status': 'cancelled', 'cancellation_reason': 'Venue closed'});
      await open(tester);
      for (final k in ['section-guests', 'section-orders']) {
        expect(find.byKey(Key(k)), findsNothing, reason: k);
      }
      expect(find.byKey(const Key('section-entry')), findsOneWidget);
      expect(find.byKey(const Key('section-getting-there')), findsNothing);
    });

    testWidgets('a booking that is over keeps its record but offers no guests, no more bottles and no refund request', (tester) async {
      await open(tester, now: DateTime(2100, 1, 1));
      expect(find.byKey(const Key('section-guests')), findsNothing);
      expect(find.byKey(const Key('add-bottles')), findsNothing);
      expect(find.byKey(const Key('refund-open')), findsNothing);
      expect(find.byKey(const Key('section-payments')), findsOneWidget);
    });
  });

  group('guests', () {
    testWidgets('lists who is invited with their status and how many places are left', (tester) async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer(max: 6, remaining: 3, guests: [guestRow(), guestRow(id: 'g2', name: 'Lee', email: 'lee@example.com', sent: null), guestRow(id: 'g3', name: 'Kim', email: 'kim@example.com', checkedIn: '2099-11-06T23:00:00Z')]));
      await open(tester);
      expect(textOf(tester, 'guests-summary'), startsWith('3 of 5 guest places given out.'));
      expect(textOf(tester, 'guest-status-g1'), 'Ticket sent');
      expect(textOf(tester, 'guest-status-g2'), 'Not sent yet');
      expect(textOf(tester, 'guest-status-g3'), 'Checked in');
      expect(find.byKey(const Key('guest-resend-g3')), findsNothing, reason: 'a guest who has checked in needs no ticket again');
      expect(site.forFunction('manage-guest-tickets').first.body, {'confirmation_code': 'TB-ABCD2345', 'action': 'list'});
    });

    testWidgets('a ticket can be sent again', (tester) async {
      await open(tester);
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: b['action'] == 'resend' ? {'success': true} : rosterAnswer());
      await tap(tester, 'guest-resend-g1');
      await settleCalls(tester);
      expect(site.forFunction('manage-guest-tickets').any((r) => r.body['action'] == 'resend' && r.body['guest_id'] == 'g1'), isTrue);
      expect(find.text('Ticket sent again to Sam Park.'), findsOneWidget);
    });

    testWidgets('inviting a guest asks for a name and an e-mail, sends them to the website, and says the ticket will be e-mailed', (tester) async {
      await open(tester);
      site.functions['manage-guest-tickets'] = (b) => b['action'] == 'add' ? (status: 200, body: {'success': true, 'results': [{'id': 'g9', 'guest_name': 'Ava Chen', 'guest_email': 'ava@example.com', 'sent': true}]}) : (status: 200, body: rosterAnswer());
      await tap(tester, 'guest-add');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('guest-name-0')), ' Ava Chen ');
      await tester.enterText(find.byKey(const Key('guest-email-0')), 'ava@example.com');
      await tester.tap(find.byKey(const Key('guest-send')));
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final add = site.forFunction('manage-guest-tickets').firstWhere((r) => r.body['action'] == 'add').body;
      expect(add['guests'], [
        {'name': 'Ava Chen', 'email': 'ava@example.com'}
      ]);
      expect(find.text('Ava Chen will get their ticket by e-mail.'), findsOneWidget);
    });

    testWidgets('a guest added whose e-mail could not be sent is said plainly, so the host can send it again', (tester) async {
      await open(tester);
      site.functions['manage-guest-tickets'] = (b) => b['action'] == 'add' ? (status: 200, body: {'success': true, 'results': [{'id': 'g9', 'guest_name': 'Ava', 'guest_email': 'ava@example.com', 'sent': false}]}) : (status: 200, body: rosterAnswer());
      await tap(tester, 'guest-add');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('guest-name-0')), 'Ava');
      await tester.enterText(find.byKey(const Key('guest-email-0')), 'ava@example.com');
      await tester.tap(find.byKey(const Key('guest-send')));
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.textContaining('Added, but the ticket for Ava could not be e-mailed'), findsOneWidget);
    });

    testWidgets('an incomplete guest is caught before anything is sent: no e-mail, a bad e-mail, no name, nothing, the same e-mail twice', (tester) async {
      await open(tester);
      await tap(tester, 'guest-add');
      await tester.pumpAndSettle();
      Future<void> send() async {
        await tester.tap(find.byKey(const Key('guest-send')));
        await tester.pump();
      }

      await send();
      expect(textOf(tester, 'guest-problem'), 'Add at least one guest.');
      await tester.enterText(find.byKey(const Key('guest-name-0')), 'Ava');
      await send();
      expect(textOf(tester, 'guest-problem'), 'Enter a valid e-mail for Ava.');
      await tester.enterText(find.byKey(const Key('guest-email-0')), 'ava@');
      await send();
      expect(textOf(tester, 'guest-problem'), 'Enter a valid e-mail for Ava.');
      await tester.enterText(find.byKey(const Key('guest-name-0')), '');
      await tester.enterText(find.byKey(const Key('guest-email-0')), 'ava@example.com');
      await send();
      expect(textOf(tester, 'guest-problem'), 'Give each guest a name.');
      await tester.enterText(find.byKey(const Key('guest-name-0')), 'Ava');
      await tester.tap(find.byKey(const Key('guest-more')));
      await tester.pump();
      await tester.enterText(find.byKey(const Key('guest-name-1')), 'Ava Two');
      await tester.enterText(find.byKey(const Key('guest-email-1')), 'AVA@example.com');
      await send();
      expect(textOf(tester, 'guest-problem'), 'AVA@example.com is listed twice.');
      expect(site.forFunction('manage-guest-tickets').where((r) => r.body['action'] == 'add'), isEmpty);
    });

    testWidgets('no more rows than there are places left', (tester) async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer(max: 3, remaining: 2));
      await open(tester);
      await tap(tester, 'guest-add');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('guest-more')));
      await tester.pump();
      expect(find.byKey(const Key('guest-name-1')), findsOneWidget);
      expect(find.byKey(const Key('guest-more')), findsNothing);
    });

    testWidgets('a full table offers no invitation', (tester) async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer(max: 2, remaining: 0));
      await open(tester);
      expect(find.byKey(const Key('guest-add')), findsNothing);
      expect(find.byKey(const Key('guests-full')), findsOneWidget);
    });

    testWidgets('the website\'s refusal (too many guests) is shown in its own words', (tester) async {
      await open(tester);
      site.functions['manage-guest-tickets'] = (b) => b['action'] == 'add' ? (status: 400, body: {'error': 'Only 1 guest ticket left for this table'}) : (status: 200, body: rosterAnswer());
      await tap(tester, 'guest-add');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('guest-name-0')), 'Ava');
      await tester.enterText(find.byKey(const Key('guest-email-0')), 'ava@example.com');
      await tester.tap(find.byKey(const Key('guest-send')));
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('Only 1 guest ticket left for this table'), findsOneWidget);
    });

    testWidgets('if the guest list cannot be loaded there is a sentence and a way to try again, and the rest of the page still works', (tester) async {
      site.functions['manage-guest-tickets'] = (b) => (status: 500, body: {'error': 'boom'});
      await open(tester);
      expect(textOf(tester, 'guests-failed'), 'We could not load the guest list. Check your connection and try again.');
      expect(find.byKey(const Key('section-payments')), findsOneWidget);
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer());
      await tap(tester, 'guests-retry');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.byKey(const Key('guest-g1')), findsOneWidget);
    });
  });

  group('orders', () {
    testWidgets('says how many bottles are ordered and how many are left for the club, and offers more', (tester) async {
      site.tables['site_table_booking_bottles'] = [bottleLineRow(payment: 'due_at_venue', qty: 2), bottleLineRow(id: 'l2', name: 'Don Julio', size: null, payment: 'paid'), bottleLineRow(id: 'l3', cancelledAt: '2099-10-25T10:00:00Z')];
      await open(tester);
      expect(textOf(tester, 'orders-summary'), '3 bottles ordered (2 to pay at the club).');
      await tap(tester, 'add-bottles');
      expect(toBottles.single.id, 'bk1');
    });

    testWidgets('no bottles says so', (tester) async {
      site.tables['site_table_booking_bottles'] = [];
      await open(tester);
      expect(textOf(tester, 'orders-summary'), 'No bottles ordered yet.');
    });

    testWidgets('a replacement the club suggests is explained, with the price difference, and can be approved', (tester) async {
      site.tables['site_table_booking_bottle_substitutions'] = [substitutionRow(diff: 2000)];
      await open(tester);
      expect(textOf(tester, 'sub-text-s1'), 'Grey Goose (1.75L) is not available (Out of stock tonight). The club suggests Belvedere (1.75L), ${m(2000)} more.');
      site.functions['respond-bottle-substitution'] = (b) {
        site.tables['site_table_booking_bottle_substitutions'] = [];
        return (status: 200, body: {'success': true, 'status': 'approved'});
      };
      await tap(tester, 'sub-approve-s1');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forFunction('respond-bottle-substitution').single.body, {'token': 'sub-tok-1', 'action': 'approve'});
      expect(find.byKey(const Key('sub-s1')), findsNothing, reason: 'answered, so it is gone');
    });

    testWidgets('a replacement can be declined, and a cheaper or same-price one says so', (tester) async {
      site.tables['site_table_booking_bottle_substitutions'] = [substitutionRow(id: 'a', diff: -1500, token: 'ta'), substitutionRow(id: 'b', diff: 0, token: 'tb')];
      await open(tester);
      expect(textOf(tester, 'sub-text-a'), contains('${m(1500)} less.'));
      expect(textOf(tester, 'sub-text-b'), contains('at the same price.'));
      site.functions['respond-bottle-substitution'] = (b) => (status: 200, body: {'success': true, 'status': 'declined'});
      await tap(tester, 'sub-decline-a');
      await settleCalls(tester);
      expect(site.forFunction('respond-bottle-substitution').single.body, {'token': 'ta', 'action': 'decline'});
      expect(find.text('Replacement declined.'), findsOneWidget);
    });

    testWidgets('an answer that cannot be sent says why and the replacement stays', (tester) async {
      site.tables['site_table_booking_bottle_substitutions'] = [substitutionRow()];
      await open(tester);
      site.functions['respond-bottle-substitution'] = (b) => (status: 500, body: {'error': 'boom'});
      await tap(tester, 'sub-approve-s1');
      await settleCalls(tester);
      expect(find.text('We could not send your answer. Check your connection and try again.'), findsOneWidget);
      expect(find.byKey(const Key('sub-s1')), findsOneWidget);
    });
  });

  group('payments', () {
    testWidgets('a payment the club recorded can be confirmed', (tester) async {
      site.tables['site_table_booking_club_payments'] = [clubPaymentRow()];
      await open(tester);
      expect(find.textContaining('The club recorded a payment of ${m(25000)} (debit) for your bottles. Is that right?'), findsOneWidget);
      site.functions['respond-club-payment'] = (b) {
        site.tables['site_table_booking_club_payments'] = [];
        return (status: 200, body: {'success': true, 'status': 'confirmed'});
      };
      await tap(tester, 'club-confirm-cp1');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forFunction('respond-club-payment').single.body, {'token': 'tok-1', 'action': 'confirm'});
      expect(find.byKey(const Key('bd-club-payment-cp1')), findsNothing);
    });

    testWidgets('a payment can be reported with a reason, which is needed first', (tester) async {
      site.tables['site_table_booking_club_payments'] = [clubPaymentRow()];
      await open(tester);
      await tap(tester, 'club-report-cp1');
      expect(tester.widget<FilledButton>(find.byKey(const Key('club-report-send-cp1'))).onPressed, isNull);
      await tester.enterText(find.byKey(const Key('club-reason-cp1')), 'I was charged twice');
      await tester.pump();
      site.functions['respond-club-payment'] = (b) => (status: 200, body: {'success': true, 'status': 'disputed'});
      await tap(tester, 'club-report-send-cp1');
      await settleCalls(tester);
      expect(site.forFunction('respond-club-payment').single.body, {'token': 'tok-1', 'action': 'dispute', 'reason': 'I was charged twice'});
      expect(find.text('Thanks, we passed your report to the venue.'), findsOneWidget);
    });

    testWidgets('the venue\'s refund terms are shown', (tester) async {
      await open(tester);
      expect(find.text('•  Full refund up to 48 hours before arrival.'), findsOneWidget);
    });

    testWidgets('a refund can be asked for, with a reason, and the website\'s sentence is shown; nothing is promised', (tester) async {
      await open(tester);
      await tap(tester, 'refund-open');
      expect(tester.widget<FilledButton>(find.byKey(const Key('refund-send'))).onPressed, isNull);
      expect(find.textContaining('Asking does not refund anything by itself'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('refund-reason')), 'I can no longer come');
      await tester.pump();
      site.rpcs['guest_request_refund'] = (b) => (status: 200, body: 'Your request has been sent to the venue. They will look at it and update you.');
      await tap(tester, 'refund-send');
      await settleCalls(tester);
      expect(site.forRpc('guest_request_refund').single.body, {'p_code': 'TB-ABCD2345', 'p_email': 'dana@example.com', 'p_reason': 'I can no longer come'});
      expect(textOf(tester, 'refund-sent'), 'Your request has been sent to the venue. They will look at it and update you.');
      expect(find.byKey(const Key('refund-open')), findsNothing);
    });

    testWidgets('a refund the venue cannot take (already asked) says why and can be tried again', (tester) async {
      await open(tester);
      await tap(tester, 'refund-open');
      await tester.enterText(find.byKey(const Key('refund-reason')), 'again');
      await tester.pump();
      site.rpcs['guest_request_refund'] = (b) => (status: 400, body: {'code': 'P0001', 'message': 'you have already asked for a refund on this booking: the venue is looking at it'});
      await tap(tester, 'refund-send');
      await settleCalls(tester);
      expect(textOf(tester, 'refund-error'), 'You have already asked for a refund on this booking: the venue is looking at it.');
      expect(tester.widget<FilledButton>(find.byKey(const Key('refund-send'))).onPressed, isNotNull);
    });

    testWidgets('a booking that was scanned, or has nothing paid on it, offers no refund request (the terms are still shown)', (tester) async {
      paidBooking(over: {'checked_in_at': '2099-11-06T23:00:00Z'});
      await open(tester);
      expect(find.byKey(const Key('refund-open')), findsNothing);
      expect(find.byKey(const Key('refund-policy-detail')), findsOneWidget);
    });

    testWidgets('nothing paid, no request', (tester) async {
      paidBooking(over: {'amount_paid_cents': 0});
      await open(tester);
      expect(find.byKey(const Key('refund-open')), findsNothing);
    });
  });

  group('getting there and sharing', () {
    testWidgets('directions open the venue\'s address in maps, and the venue can be called', (tester) async {
      await open(tester);
      await tap(tester, 'maps-open');
      await tap(tester, 'venue-call');
      expect(opened.map((u) => u.toString()), [
        'https://www.google.com/maps/search/?api=1&query=1+King+St+W%2C+Toronto',
        'tel:4165550199',
      ]);
    });

    testWidgets('sharing says where the guest is going, with the venue\'s page on the website', (tester) async {
      await open(tester);
      await tester.tap(find.byKey(const Key('booking-share')));
      await tester.pump();
      expect(shared.single, allOf(startsWith('I am going to Club A on '), contains('/venues/v1')));
    });

    testWidgets('a booking that is not confirmed cannot be shared', (tester) async {
      paidBooking(over: {'status': 'cancelled'});
      await open(tester);
      expect(find.byKey(const Key('booking-share')), findsNothing);
    });
  });

  group('bottle service', () {
    testWidgets('each bottle shows whether it is paid and, separately, where the venue has got to with it', (tester) async {
      site.tables['site_table_booking_bottles'] = [
        bottleLineRow(service: 'preparing'),
        bottleLineRow(id: 'l2', name: 'Don Julio', size: null, payment: 'due_at_venue', service: 'served'),
        bottleLineRow(id: 'l3', name: 'Mystery', service: 'unheard_of'),
      ];
      await open(tester);
      String chip(String key) => tester.widget<Text>(find.descendant(of: find.byKey(Key(key)), matching: find.byType(Text))).data!;
      expect(chip('bottle-pay-l1'), 'Paid');
      expect(chip('bottle-service-l1'), 'Being prepared');
      expect(chip('bottle-pay-l2'), 'Pay at the club');
      expect(chip('bottle-service-l2'), 'Delivered');
      expect(find.byKey(const Key('bottle-service-l3')), findsNothing, reason: 'a status the app does not know is not shown as one it does');
    });

    testWidgets('a cancelled bottle is not listed as an order', (tester) async {
      site.tables['site_table_booking_bottles'] = [bottleLineRow(cancelledAt: '2099-10-25T10:00:00Z')];
      await open(tester);
      expect(find.byKey(const Key('bottle-line-l1')), findsNothing);
    });

    testWidgets('Refresh reads the booking again, so a bottle moving along shows up', (tester) async {
      site.tables['site_table_booking_bottles'] = [bottleLineRow(service: 'awaiting_prep')];
      await open(tester);
      expect(find.descendant(of: find.byKey(const Key('bottle-service-l1')), matching: find.text('Order received')), findsOneWidget);
      site.tables['site_table_booking_bottles'] = [bottleLineRow(service: 'ready')];
      await tester.tap(find.byKey(const Key('booking-refresh')));
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.descendant(of: find.byKey(const Key('bottle-service-l1')), matching: find.text('Ready')), findsOneWidget);
    });
  });

  group('after the night', () {
    testWidgets('a booking that is over, cancelled or refunded offers to book the venue again; one that is coming up does not', (tester) async {
      await open(tester);
      expect(find.byKey(const Key('book-again')), findsNothing);
    });

    testWidgets('over', (tester) async {
      await open(tester, now: DateTime(2100, 1, 1));
      expect(find.byKey(const Key('book-again')), findsOneWidget);
      expect(find.text('Book Club A again'), findsOneWidget);
    });

    testWidgets('cancelled', (tester) async {
      paidBooking(over: {'status': 'cancelled'});
      await open(tester);
      expect(find.byKey(const Key('book-again')), findsOneWidget);
    });
  });
}
