import 'package:bottles_up_user/site/models/my_night.dart';
import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/services/booking_actions_service.dart';
import 'package:bottles_up_user/site/services/guest_passes_service.dart';
import 'package:bottles_up_user/site/services/my_bookings_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  group('guests', () {
    test('a guest and the roster are read; a guest with no name or e-mail is dropped, the room left never goes below nothing', () {
      final r = parseGuestRoster(rosterAnswer(max: 6, remaining: 3, guests: [guestRow(), guestRow(id: 'g2', name: 'Lee', email: 'lee@example.com', sent: null), {...guestRow(id: 'bad'), 'guest_name': null}, guestRow(id: 'g3', checkedIn: '2099-11-06T23:00:00Z')]))!;
      expect([r.maxGuests, r.remainingCapacity, r.guests.map((g) => g.id).toList(), r.canAdd], [6, 3, ['g1', 'g2', 'g3'], true]);
      expect(r.guests.map((g) => g.status), ['Ticket sent', 'Not sent yet', 'Checked in']);
      expect(parseGuestRoster(rosterAnswer(remaining: -2))!.remainingCapacity, 0);
      expect(parseGuestRoster(rosterAnswer(remaining: 0))!.canAdd, isFalse);
      expect(parseGuestRoster({'guests': []}), isNull);
    });

    test('asks for the list with the booking\'s code', () async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer());
      final r = await GuestPassesService(site.client).roster('TB-ABCD2345');
      expect(site.forFunction('manage-guest-tickets').single.body, {'confirmation_code': 'TB-ABCD2345', 'action': 'list'});
      expect(r.guests.single.name, 'Sam Park');
    });

    test('adds guests (trimmed) and says for each whether the ticket e-mail went out', () async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: {'success': true, 'results': [{'id': 'g9', 'guest_name': 'Ava', 'guest_email': 'ava@example.com', 'sent': true}, {'id': 'g10', 'guest_name': 'Bo', 'guest_email': 'bo@example.com', 'sent': false}]});
      final r = await GuestPassesService(site.client).add('TB-ABCD2345', [(name: ' Ava ', email: ' ava@example.com '), (name: 'Bo', email: 'bo@example.com')]);
      expect(site.forFunction('manage-guest-tickets').single.body, {
        'confirmation_code': 'TB-ABCD2345',
        'action': 'add',
        'guests': [
          {'name': 'Ava', 'email': 'ava@example.com'},
          {'name': 'Bo', 'email': 'bo@example.com'},
        ],
      });
      expect(r.map((x) => (x.name, x.sent)), [('Ava', true), ('Bo', false)]);
    });

    test('too many guests is the website\'s own sentence; a server error or a lost connection is a plain one', () async {
      site.functions['manage-guest-tickets'] = (b) => (status: 400, body: {'error': 'Only 1 guest ticket left for this table'});
      await expectLater(GuestPassesService(site.client).add('C', [(name: 'Ava', email: 'a@b.co')]), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Only 1 guest ticket left for this table')));
      site.functions['manage-guest-tickets'] = (b) => (status: 500, body: {'error': 'Failed to add guest'});
      await expectLater(GuestPassesService(site.client).add('C', [(name: 'Ava', email: 'a@b.co')]), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not add your guests. Check your connection and try again.')));
      await expectLater(GuestPassesService(site.client).roster('C'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load the guest list. Check your connection and try again.')));
    });

    test('sends one ticket again by the guest\'s id', () async {
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: {'success': true});
      await GuestPassesService(site.client).resend('C', 'g1');
      expect(site.forFunction('manage-guest-tickets').single.body, {'confirmation_code': 'C', 'action': 'resend', 'guest_id': 'g1'});
      site.functions['manage-guest-tickets'] = (b) => (status: 200, body: {'success': false});
      await expectLater(GuestPassesService(site.client).resend('C', 'g1'), throwsA(isA<SiteException>()));
    });
  });

  group('bottle replacements', () {
    test('a pending replacement is read; an answered one, or one with no token, is not', () {
      final s = parseSubstitution(substitutionRow())!;
      expect([s.id, s.lineId, s.reason, s.replacementDisplay, s.priceDiffCents, s.token], ['s1', 'l1', 'Out of stock tonight', 'Belvedere (1.75L)', 2000, 'sub-tok-1']);
      expect(parseSubstitution(substitutionRow(size: null))!.replacementDisplay, 'Belvedere');
      expect(parseSubstitution(substitutionRow(status: 'approved')), isNull);
      expect(parseSubstitution({...substitutionRow(), 'confirm_token': null}), isNull);
    });

    test('the booking comes with the replacements waiting for an answer', () async {
      site.tables['site_table_bookings'] = [bookingRow()];
      for (final t in ['site_table_booking_bottles', 'site_table_booking_club_payments', 'site_table_booking_refunds']) {
        site.tables[t] = [];
      }
      site.tables['site_table_booking_bottle_substitutions'] = [substitutionRow()];
      final b = (await MyBookingsService(site.client).booking('bk1'))!;
      final q = site.forTable('site_table_booking_bottle_substitutions').single.query;
      expect([q['booking_id'], q['status']], ['eq.bk1', 'eq.pending']);
      expect(b.substitutions.single.replacementName, 'Belvedere');
    });
  });

  group('after paying', () {
    BookingActionsService actions() => BookingActionsService(site.client);

    test('extra bottles paid at the club are recorded, with the choice sent only when it is the club', () async {
      site.functions['add-table-booking-bottles'] = (b) => (status: 200, body: {'success': true, 'mode': 'due_at_venue'});
      final r = await actions().addBottles(bookingId: 'bk1', bottles: {'b1': 2, 'b2': 0}, choice: BottlePaymentChoice.payAtClub);
      expect(site.forFunction('add-table-booking-bottles').single.body, {
        'booking_id': 'bk1',
        'bottles': [
          {'bottle_id': 'b1', 'quantity': 2}
        ],
        'bottle_payment_choice': 'pay_at_club',
      });
      expect(r.mode, BottlePaymentChoice.payAtClub);
      expect(r.start, isNull);
    });

    test('extra bottles paid now give the page to pay on, with the payment\'s id', () async {
      site.functions['add-table-booking-bottles'] = (b) => (status: 200, body: {'success': true, 'mode': 'pay_ahead', 'url': 'https://checkout.stripe.com/c/pay/cs_test_addon1#f'});
      final r = await actions().addBottles(bookingId: 'bk1', bottles: {'b1': 1}, choice: BottlePaymentChoice.payAhead);
      expect(site.forFunction('add-table-booking-bottles').single.body.containsKey('bottle_payment_choice'), isFalse);
      expect([r.mode, r.start!.sessionId], [BottlePaymentChoice.payAhead, 'cs_test_addon1']);
    });

    test('an order already waiting on payment comes back with the page to finish it on', () async {
      site.functions['add-table-booking-bottles'] = (b) => (status: 409, body: {'error': 'You already have an order waiting on payment. Finish or cancel it before adding more.', 'pending_checkout_url': 'https://checkout.stripe.com/c/pay/cs_test_wait#f'});
      await expectLater(
        actions().addBottles(bookingId: 'bk1', bottles: {'b1': 1}, choice: BottlePaymentChoice.payAhead),
        throwsA(isA<AddonPaymentPending>().having((e) => e.url.toString(), 'url', 'https://checkout.stripe.com/c/pay/cs_test_wait#f').having((e) => e.message, 'message', startsWith('You already have an order waiting on payment.'))),
      );
    });

    test('other refusals are the website\'s own sentence, a server error a plain one', () async {
      site.functions['add-table-booking-bottles'] = (b) => (status: 409, body: {'error': 'Not enough "Grey Goose" left in stock'});
      await expectLater(actions().addBottles(bookingId: 'bk1', bottles: {'b1': 1}, choice: BottlePaymentChoice.payAhead), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Not enough "Grey Goose" left in stock')));
      site.functions['add-table-booking-bottles'] = (b) => (status: 500, body: {'error': 'Failed to start checkout'});
      await expectLater(actions().addBottles(bookingId: 'bk1', bottles: {'b1': 1}, choice: BottlePaymentChoice.payAhead), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not order those bottles. Check your connection and try again.')));
      site.functions['add-table-booking-bottles'] = (b) => (status: 200, body: {'success': true, 'mode': 'pay_ahead', 'url': 'http://not-https.example'});
      await expectLater(actions().addBottles(bookingId: 'bk1', bottles: {'b1': 1}, choice: BottlePaymentChoice.payAhead), throwsA(isA<SiteException>()));
    });

    test('where an extra payment stands: paid, still waiting, or not found', () async {
      for (final (answer, state) in [('paid', AddonState.paid), ('pending', AddonState.pending), ('not_found', AddonState.notFound)]) {
        site.functions['confirm-bottle-addon'] = (b) => (status: 200, body: {'status': answer});
        expect(await actions().addonStatus('cs_test_addon1'), state);
      }
      expect(site.forFunction('confirm-bottle-addon').first.body, {'session_id': 'cs_test_addon1'});
    });

    test('a replacement is approved or declined with its token; an answer already given is said in words', () async {
      site.functions['respond-bottle-substitution'] = (b) => (status: 200, body: {'success': true, 'status': b['action'] == 'approve' ? 'approved' : 'declined'});
      await actions().answerSubstitution(token: 'sub-tok-1', approve: true);
      await actions().answerSubstitution(token: 'sub-tok-1', approve: false);
      expect(site.forFunction('respond-bottle-substitution').map((r) => r.body), [
        {'token': 'sub-tok-1', 'action': 'approve'},
        {'token': 'sub-tok-1', 'action': 'decline'},
      ]);
      site.functions['respond-bottle-substitution'] = (b) => (status: 200, body: {'success': false, 'error': 'already_responded', 'status': 'approved'});
      await expectLater(actions().answerSubstitution(token: 't', approve: true), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'You already answered this one.')));
    });

    test('a payment the club recorded is confirmed, or reported with a reason', () async {
      site.functions['respond-club-payment'] = (b) => (status: 200, body: {'success': true, 'status': b['action'] == 'confirm' ? 'confirmed' : 'disputed'});
      await actions().answerClubPayment(token: 'tok-1', confirm: true);
      await actions().answerClubPayment(token: 'tok-1', confirm: false, reason: '  I was charged twice ');
      expect(site.forFunction('respond-club-payment').map((r) => r.body), [
        {'token': 'tok-1', 'action': 'confirm'},
        {'token': 'tok-1', 'action': 'dispute', 'reason': 'I was charged twice'},
      ]);
      site.functions['respond-club-payment'] = (b) => (status: 400, body: {'error': 'A reason is required to report an issue'});
      await expectLater(actions().answerClubPayment(token: 't', confirm: false, reason: ''), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'A reason is required to report an issue')));
    });

    test('a refund is asked for with the booking code, the account\'s e-mail and the reason, and the website\'s sentence comes back', () async {
      site.rpcs['guest_request_refund'] = (b) => (status: 200, body: 'Your request has been sent to the venue. They will look at it and update you.');
      final said = await actions().requestRefund(code: ' TB-ABCD2345 ', email: ' dana@example.com ', reason: ' I cannot come ');
      expect(site.forRpc('guest_request_refund').single.body, {'p_code': 'TB-ABCD2345', 'p_email': 'dana@example.com', 'p_reason': 'I cannot come'});
      expect(said, 'Your request has been sent to the venue. They will look at it and update you.');
    });

    test('a refund the database refuses says why, with a capital and a full stop; any other failure is a plain sentence', () async {
      site.rpcs['guest_request_refund'] = (b) => (status: 400, body: {'code': 'P0001', 'message': 'you have already asked for a refund on this booking: the venue is looking at it'});
      await expectLater(actions().requestRefund(code: 'C', email: 'e@x.co', reason: 'why'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'You have already asked for a refund on this booking: the venue is looking at it.')));
      site.rpcs['guest_request_refund'] = (b) => (status: 500, body: {'message': 'boom'});
      await expectLater(actions().requestRefund(code: 'C', email: 'e@x.co', reason: 'why'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Your request could not be sent just now. Try again in a moment.')));
      site.networkDown = true;
      await expectLater(actions().requestRefund(code: 'C', email: 'e@x.co', reason: 'why'), throwsA(isA<SiteException>()));
    });
  });

  group('agrees with the website', skip: websiteIsHere ? false : websiteMissing, () {
    test('the guest list function takes the booking code and an action, and answers the fields the app reads', () {
      final ts = readFunction('manage-guest-tickets');
      for (final f in ['confirmation_code', "action === 'list'", "action === 'add'", "action === 'resend'", 'guest_id', 'maxGuests', 'remainingCapacity', 'guest_name', 'guest_email', 'ticket_sent_at', 'checked_in_at', 'success: true', 'results']) {
        expect(ts, contains(f), reason: f);
      }
      expect(ts, contains('guests'));
      expect(ts, contains('sent: email.sent'));
      expect(ts, contains("const name = typeof g?.name === 'string'"));
      expect(ts, contains("const email = typeof g?.email === 'string'"));
      expect(ts, contains('maxGuests - 1 -'), reason: 'the host is one of the table\'s guests');
    });

    test('adding bottles takes a signed-in guest\'s booking id, bottle ids and quantities, and answers a mode, a page to pay on, or the order already waiting', () {
      final ts = readFunction('add-table-booking-bottles');
      for (final f in ['booking_id', 'bottles', 'bottle_payment_choice', "req.headers.get('Authorization')", 'customer_email.toLowerCase()']) {
        expect(ts, contains(f), reason: f);
      }
      final shared = readFunctionFile('_shared/bottleOrdering.ts');
      expect(shared, contains("mode: 'due_at_venue'"));
      expect(shared, contains("mode: 'pay_ahead', url: session.url"));
      expect(shared, contains('pending_checkout_url'));
      expect(shared, contains('Math.round((bottleSubtotalCents * (venue.tax_rate_bps ?? 0)) / 10000)'), reason: 'an extra order is taxed on the bottles alone, as the app previews it');
      expect(shared, contains('Math.round((bottleSubtotalCents * bottlesupFeeBps) / 10000)'));
      expect(shared, contains("kind: 'bottle_addon'"));
      expect(readFunction('confirm-bottle-addon'), allOf(contains('session_id'), contains("status: 'paid'"), contains("status: 'pending'"), contains("status: 'not_found'")));
    });

    test('the replacement and club payment answers take the token and an action', () {
      final sub = readFunction('respond-bottle-substitution');
      expect(sub, allOf(contains('const { token, action }'), contains("action !== 'approve' && action !== 'decline'"), contains("error: 'already_responded'"), contains('success: true')));
      final club = readFunction('respond-club-payment');
      expect(club, allOf(contains('token, action, reason'), contains("action !== 'confirm' && action !== 'dispute'"), contains("error: 'already_responded'"), contains('A reason is required to report an issue')));
    });

    test('a refund is asked for through the database function a visitor or signed-in guest may call', () {
      final sql = allMigrations();
      expect(sql, contains('function public.guest_request_refund(p_code text, p_email text, p_reason text)'));
      expect(sql, contains('grant execute on function public.public_venue_refund_policy(uuid), public.guest_request_refund(text, text, text) to anon, authenticated, service_role'));
    });

    test('cancelling a booking is for staff, so the app asks for a refund instead', () {
      final ts = readFunction('cancel-table-booking');
      expect(ts, contains('desk_may_cancel_booking'));
      expect(ts, contains("cms_admins"));
    });
  });
}
