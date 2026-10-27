import 'package:bottles_up_user/site/models/hiring.dart';
import 'package:bottles_up_user/site/services/hiring_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late HiringService service;

  setUp(() {
    site = FakeWebsite();
    service = HiringService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  group('services and days', () {
    test('a professional\'s services are read', () async {
      site.rpcs['pro_services_of'] = (_) => ok([proServiceRow(), proServiceRow(id: 'sv2', title: 'MC', active: false)]);
      final list = await service.services('p-dj');
      expect([for (final s in list) s.id], ['sv1', 'sv2']);
      expect(site.forRpc('pro_services_of').single.body, {'p_profile': 'p-dj'});
    });

    test('saving sends the actor, the text trimmed, blanks as nothing, and answers the saved service', () async {
      site.rpcs['pro_service_save'] = (_) => ok(proServiceRow(title: 'Wedding DJ set'));
      final s = await service.saveService(actor: 'p-dj', id: 'sv1', title: '  Wedding DJ set ', description: '   ', fromCents: 125000, priceNote: ' from ', active: false);
      expect(s.title, 'Wedding DJ set');
      expect(site.forRpc('pro_service_save').single.body, {'p_actor': 'p-dj', 'p_id': 'sv1', 'p_title': 'Wedding DJ set', 'p_description': null, 'p_from_cents': 125000, 'p_note': 'from', 'p_active': false});
    });

    test('a refusal is its sentence, an unreadable answer is an error', () async {
      site.rpcs['pro_service_save'] = (_) => raised('A profile can list up to 20 services.');
      await expectLater(service.saveService(actor: 'p', title: 'abc'), sentence('A profile can list up to 20 services.'));
      site.rpcs['pro_service_save'] = (_) => ok({'oops': 1});
      await expectLater(service.saveService(actor: 'p', title: 'abc'), throwsA(isA<SiteException>().having((e) => e.message, 'm', contains('may not have been saved'))));
    });

    test('removing names the actor and the service', () async {
      site.rpcs['pro_service_remove'] = (_) => ok(null);
      await service.removeService(actor: 'p-dj', id: 'sv1');
      expect(site.forRpc('pro_service_remove').single.body, {'p_actor': 'p-dj', 'p_id': 'sv1'});
    });

    test('busy days are read as days, and a day it cannot read is dropped', () async {
      site.rpcs['pro_busy_days'] = (_) => ok(['2099-11-08', '2099-11-09', 'soon', 5, null]);
      final days = await service.busyDays('p-dj', from: DateTime(2099, 10, 25));
      expect(days, [DateTime(2099, 11, 8), DateTime(2099, 11, 9)]);
      expect(site.forRpc('pro_busy_days').single.body, {'p_profile': 'p-dj', 'p_from': '2099-10-25', 'p_days': 120});
      site.rpcs['pro_busy_days'] = (_) => ok(null);
      expect(await service.busyDays('p-dj', from: DateTime(2099, 10, 25)), isEmpty);
    });

    test('setting a day names the day as a calendar day', () async {
      site.rpcs['pro_busy_set'] = (_) => ok(null);
      await service.setBusy(actor: 'p-dj', day: DateTime(2099, 1, 5, 23, 59), busy: true);
      expect(site.forRpc('pro_busy_set').single.body, {'p_actor': 'p-dj', 'p_day': '2099-01-05', 'p_busy': true});
    });
  });

  group('requests and quotes', () {
    test('a request goes with everything the person typed, trimmed, and answers the request', () async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      final r = await service.createRequest(provider: 'p-dj', service: 'sv1', date: DateTime(2099, 11, 8), timeNote: ' 9pm ', location: '   ', guests: 120, message: '  A night out ', budgetCents: 150000);
      expect(r.id, 'pr1');
      expect(site.forRpc('pro_request_create').single.body, {
        'p_provider': 'p-dj',
        'p_service': 'sv1',
        'p_event_date': '2099-11-08',
        'p_time_note': '9pm',
        'p_location': null,
        'p_guests': 120,
        'p_message': 'A night out',
        'p_budget_cents': 150000,
      });
    });

    test('refusals are shown as they came; an answer it cannot read says the request may not have been sent', () async {
      site.rpcs['pro_request_create'] = (_) => raised('This professional is not free on that day.');
      await expectLater(service.createRequest(provider: 'p', date: DateTime(2099), message: 'abc'), sentence('This professional is not free on that day.'));
      site.rpcs['pro_request_create'] = (_) => ok({'x': 1});
      await expectLater(service.createRequest(provider: 'p', date: DateTime(2099), message: 'abc'), throwsA(isA<SiteException>().having((e) => e.message, 'm', contains('Look at your requests'))));
      site.networkDown = true;
      await expectLater(service.createRequest(provider: 'p', date: DateTime(2099), message: 'abc'), throwsA(isA<SiteException>()));
    });

    test('the lists and one request are read', () async {
      site.rpcs['pro_requests_mine'] = (_) => ok([proRequestRow(), proRequestRow(id: 'pr2')]);
      site.rpcs['pro_requests_for'] = (_) => ok([proRequestRow(client: {'name': 'Ann Lee'})]);
      site.rpcs['pro_request_get'] = (_) => ok(proRequestRow(status: 'quoted', quote: proQuoteRow()));
      expect((await service.myRequests()).length, 2);
      expect((await service.requestsFor('p-dj')).single.isProviderView, isTrue);
      expect((await service.request('pr1')).hasOpenQuote, isTrue);
      expect(site.forRpc('pro_requests_mine').single.body, isEmpty);
      expect(site.forRpc('pro_requests_for').single.body, {'p_actor': 'p-dj'});
      expect(site.forRpc('pro_request_get').single.body, {'p_request': 'pr1'});
    });

    test('a quote goes with its money in cents, the balance day as a day and the scope trimmed', () async {
      site.rpcs['pro_quote_send'] = (_) => ok(proRequestRow(status: 'quoted', quote: proQuoteRow()));
      await service.sendQuote(actor: 'p-dj', request: 'pr1', total: 100000, deposit: 30000, balanceDueBy: DateTime(2099, 11, 1, 18), scope: '  Four hours  of music ', validDays: 5);
      expect(site.forRpc('pro_quote_send').single.body, {'p_actor': 'p-dj', 'p_request': 'pr1', 'p_total_cents': 100000, 'p_deposit_cents': 30000, 'p_balance_due_by': '2099-11-01', 'p_scope': 'Four hours  of music', 'p_valid_days': 5});
      await service.sendQuote(actor: 'p-dj', request: 'pr1', total: 100000, deposit: 100000, scope: 'All in one go', validDays: 3);
      expect(site.forRpc('pro_quote_send').last.body['p_balance_due_by'], isNull);
    });

    test('withdrawing, declining and accepting each name what they act on', () async {
      for (final f in ['pro_quote_withdraw', 'pro_request_decline', 'pro_request_withdraw', 'pro_quote_decline']) {
        site.rpcs[f] = (_) => ok(proRequestRow(status: 'declined'));
      }
      await service.withdrawQuote(actor: 'p-dj', request: 'pr1');
      await service.declineRequest(actor: 'p-dj', request: 'pr1', note: ' away ');
      await service.declineRequest(actor: 'p-dj', request: 'pr1', note: '  ');
      await service.withdrawRequest('pr1');
      await service.declineQuote('pr1');
      expect(site.forRpc('pro_quote_withdraw').single.body, {'p_actor': 'p-dj', 'p_request': 'pr1'});
      expect(site.forRpc('pro_request_decline').map((c) => c.body), [
        {'p_actor': 'p-dj', 'p_request': 'pr1', 'p_note': 'away'},
        {'p_actor': 'p-dj', 'p_request': 'pr1', 'p_note': null},
      ]);
      expect(site.forRpc('pro_request_withdraw').single.body, {'p_request': 'pr1'});
      expect(site.forRpc('pro_quote_decline').single.body, {'p_request': 'pr1'});
      site.rpcs['pro_quote_accept'] = (_) => ok(proBookingRow());
      expect((await service.acceptQuote('pr1')).state, BookingState.awaitingDeposit);
      expect(site.forRpc('pro_quote_accept').single.body, {'p_request': 'pr1'});
    });

    test('accepting says the sentence when the quote ran out', () async {
      site.rpcs['pro_quote_accept'] = (_) => raised('This quote has expired. Ask for a new one.');
      await expectLater(service.acceptQuote('pr1'), sentence('This quote has expired. Ask for a new one.'));
      site.rpcs['pro_quote_accept'] = (_) => ok({'x': 1});
      await expectLater(service.acceptQuote('pr1'), throwsA(isA<SiteException>()));
    });
  });

  group('bookings', () {
    test('are read, and the actions name the booking', () async {
      site.rpcs['pro_booking_get'] = (_) => ok(proBookingRow(state: 'confirmed', paid: 30000));
      site.rpcs['pro_booking_done'] = (_) => ok(proBookingRow(state: 'done', paid: 100000, net: 95000));
      site.rpcs['pro_booking_confirm'] = (_) => ok(proBookingRow(state: 'completed', paid: 100000));
      site.rpcs['pro_dispute_open'] = (_) => ok(proBookingRow(state: 'disputed', paid: 100000));
      expect((await service.booking('pb1')).paidCents, 30000);
      expect((await service.markDone(actor: 'p-dj', booking: 'pb1')).state, BookingState.done);
      expect((await service.confirm('pb1')).state, BookingState.completed);
      expect((await service.openDispute(booking: 'pb1', reason: '  He did not come at all ')).state, BookingState.disputed);
      expect(site.forRpc('pro_booking_get').single.body, {'p_booking': 'pb1'});
      expect(site.forRpc('pro_booking_done').single.body, {'p_actor': 'p-dj', 'p_booking': 'pb1'});
      expect(site.forRpc('pro_booking_confirm').single.body, {'p_booking': 'pb1'});
      expect(site.forRpc('pro_dispute_open').single.body, {'p_booking': 'pb1', 'p_reason': 'He did not come at all'});
    });

    test('a refusal is its sentence', () async {
      site.rpcs['pro_booking_done'] = (_) => raised('You can mark it done on the day of the job or after.');
      await expectLater(service.markDone(actor: 'p', booking: 'b'), sentence('You can mark it done on the day of the job or after.'));
      site.rpcs['pro_booking_confirm'] = (_) => ok(null);
      await expectLater(service.confirm('b'), throwsA(isA<SiteException>()));
    });

    test('cancelling goes through the website\'s function and reads the booking and the refunds', () async {
      site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'booking': proBookingRow(state: 'cancelled', cancelledBy: 'client'), 'refunded': 2, 'failed': 1});
      final r = await service.cancel(booking: 'pb1', reason: '  plans changed ');
      expect([r.booking.state, r.refunded, r.failed], [BookingState.cancelled, 2, 1]);
      expect(site.forFunction('cancel-pro-booking').single.body, {'booking_id': 'pb1', 'reason': 'plans changed'});
      await service.cancel(booking: 'pb1', reason: '  ');
      expect(site.forFunction('cancel-pro-booking').last.body, {'booking_id': 'pb1'});
    });

    test('a refusal to cancel is its sentence; anything else is a plain one', () async {
      site.functions['cancel-pro-booking'] = (b) => (status: 409, body: {'error': 'This booking is already closed.'});
      await expectLater(service.cancel(booking: 'pb1'), sentence('This booking is already closed.'));
      site.functions['cancel-pro-booking'] = (b) => (status: 500, body: {'error': 'Internal server error'});
      await expectLater(service.cancel(booking: 'pb1'), sentence('The booking was not cancelled. Check your connection and try again.'));
      site.functions['cancel-pro-booking'] = (b) => (status: 200, body: {'nope': 1});
      await expectLater(service.cancel(booking: 'pb1'), sentence('The booking was not cancelled. Check your connection and try again.'));
    });
  });

  group('paying', () {
    test('starting returns the page and the session to follow; the session the website names wins', () async {
      site.functions['create-pro-checkout'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_abc#f', 'session_id': 'cs_other', 'kind': 'deposit', 'amount_cents': 30000});
      final s = await service.startPayment('pb1');
      expect([s.url.host, s.sessionId], ['checkout.stripe.com', 'cs_other']);
      expect(site.forFunction('create-pro-checkout').single.body, {'booking_id': 'pb1'});
      site.functions['create-pro-checkout'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_zzz#f'});
      expect((await service.startPayment('pb1')).sessionId, 'cs_test_zzz');
    });

    test('an address that is not a payment page, no address, or a refusal', () async {
      site.functions['create-pro-checkout'] = (b) => (status: 200, body: {'url': 'http://not-secure.example/pay'});
      await expectLater(service.startPayment('pb1'), throwsA(isA<SiteException>()));
      site.functions['create-pro-checkout'] = (b) => (status: 200, body: {'nope': 1});
      await expectLater(service.startPayment('pb1'), throwsA(isA<SiteException>()));
      site.functions['create-pro-checkout'] = (b) => (status: 409, body: {'error': 'You have paid everything for this booking.'});
      await expectLater(service.startPayment('pb1'), sentence('You have paid everything for this booking.'));
      site.functions['create-pro-checkout'] = (b) => (status: 503, body: {'error': 'Payments are not set up yet.'});
      await expectLater(service.startPayment('pb1'), sentence('We could not open the payment page. Check your connection and try again.'));
    });

    test('how it stands is read with the booking', () async {
      for (final s in ProPayment.values) {
        site.functions['confirm-pro-payment'] = (b) => (status: 200, body: {'status': s.name, 'booking': proBookingRow(state: 'confirmed', paid: 30000)});
        final r = await service.paymentStatus('pb1');
        expect([r.status, r.booking!.paidCents], [s, 30000]);
      }
      expect(site.forFunction('confirm-pro-payment').first.body, {'booking_id': 'pb1'});
    });

    test('an answer it cannot read, or a failure, is an error', () async {
      site.functions['confirm-pro-payment'] = (b) => (status: 200, body: {'status': 'bogus'});
      await expectLater(service.paymentStatus('pb1'), throwsA(isA<SiteException>()));
      site.functions['confirm-pro-payment'] = (b) => (status: 500, body: {'error': 'x'});
      await expectLater(service.paymentStatus('pb1'), sentence('We could not check your payment. Check your connection and try again.'));
    });
  });

  group('a request without a budget', () {
    test('sends no budget, no guests and no service', () async {
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      await service.createRequest(provider: 'p-dj', date: DateTime(2099, 11, 8), message: 'Need a DJ');
      final sent = site.forRpc('pro_request_create').single.body;
      expect([sent['p_budget_cents'], sent['p_guests'], sent['p_service'], sent['p_time_note'], sent['p_location']], [null, null, null, null, null]);
    });
  });
}
