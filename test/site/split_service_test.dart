import 'package:bottles_up_user/site/models/split.dart';
import 'package:bottles_up_user/site/services/split_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late SplitService service;

  setUp(() {
    site = FakeWebsite();
    service = SplitService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  group('asking friends', () {
    test('sends the booking, each friend with their amount, and the deadline in UTC', () async {
      site.rpcs['split_create'] = (_) => ok(splitPlanRow());
      final plan = await service.create(
        bookingId: 'bk1',
        shares: const [ShareAsk(payer: 'p-bob', amountCents: 5000), ShareAsk(payer: 'p-cy', amountCents: 2500)],
        deadline: DateTime.utc(2099, 11, 5, 22),
      );
      expect(plan.id, 'sp1');
      expect(site.forRpc('split_create').single.body, {
        'p_booking': 'bk1',
        'p_shares': [
          {'payer': 'p-bob', 'amount_cents': 5000},
          {'payer': 'p-cy', 'amount_cents': 2500},
        ],
        'p_deadline': '2099-11-05T22:00:00.000Z',
      });
    });

    test('a local deadline is sent as the same instant in UTC', () async {
      site.rpcs['split_create'] = (_) => ok(splitPlanRow());
      final local = DateTime(2099, 11, 5, 22);
      await service.create(bookingId: 'bk1', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: local);
      expect(DateTime.parse(site.forRpc('split_create').single.body['p_deadline'] as String), local.toUtc());
    });

    test('the website\'s refusals are shown as they came', () async {
      for (final said in ['This booking is not yours.', 'The shares add up to more than what is left to pay on this booking (CAD 200.00).', 'One of the people you chose is not available.']) {
        site.rpcs['split_create'] = (_) => raised(said);
        await expectLater(service.create(bookingId: 'b', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: DateTime.utc(2099)), sentence(said));
      }
    });

    test('a failure that is not a sentence is a plain one, and a dropped connection says the requests may not have been sent', () async {
      site.rpcs['split_create'] = (_) => (status: 500, body: {'message': 'secret internals'});
      await expectLater(service.create(bookingId: 'b', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: DateTime.utc(2099)), sentence('The requests were not sent. Check your connection and try again.'));
      site.networkDown = true;
      await expectLater(service.create(bookingId: 'b', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: DateTime.utc(2099)), throwsA(isA<SiteException>()));
    });

    test('an answer it cannot read is an error, not a pretend success', () async {
      site.rpcs['split_create'] = (_) => ok({'oops': 1});
      await expectLater(service.create(bookingId: 'b', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: DateTime.utc(2099)), throwsA(isA<SiteException>().having((e) => e.message, 'message', contains('may not have been sent'))));
    });
  });

  group('looking at a booking\'s split', () {
    test('asks for this booking and reads the plan', () async {
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow(state: 'complete'));
      final plan = await service.forBooking('bk1');
      expect(plan!.state, SplitState.complete);
      expect(site.forRpc('split_for_booking').single.body, {'p_booking': 'bk1'});
    });

    test('a booking that never had one is nothing', () async {
      site.rpcs['split_for_booking'] = (_) => ok(null);
      expect(await service.forBooking('bk1'), isNull);
    });

    test('an answer it cannot read is an error; a refusal is its sentence', () async {
      site.rpcs['split_for_booking'] = (_) => ok({'x': 1});
      await expectLater(service.forBooking('bk1'), throwsA(isA<SiteException>()));
      site.rpcs['split_for_booking'] = (_) => raised('This booking is not yours.');
      await expectLater(service.forBooking('bk1'), sentence('This booking is not yours.'));
    });
  });

  group('cancelling', () {
    test('goes through the website\'s function and reads the plan and the refunds', () async {
      site.functions['cancel-split'] = (b) => (status: 200, body: {'split': splitPlanRow(state: 'cancelled'), 'refunded': 2, 'failed': 1});
      final r = await service.cancel('sp1');
      expect(r.plan.isCancelled, isTrue);
      expect([r.refunded, r.failed], [2, 1]);
      expect(site.forFunction('cancel-split').single.body, {'split_id': 'sp1'});
    });

    test('missing counts are none', () async {
      site.functions['cancel-split'] = (b) => (status: 200, body: {'split': splitPlanRow(state: 'cancelled')});
      final r = await service.cancel('sp1');
      expect([r.refunded, r.failed], [0, 0]);
    });

    test('a refusal is its sentence; anything else is a plain one', () async {
      site.functions['cancel-split'] = (b) => (status: 409, body: {'error': 'This split is already cancelled.'});
      await expectLater(service.cancel('sp1'), sentence('This split is already cancelled.'));
      site.functions['cancel-split'] = (b) => (status: 500, body: {'error': 'Internal server error'});
      await expectLater(service.cancel('sp1'), sentence('The split was not cancelled. Check your connection and try again.'));
      site.functions['cancel-split'] = (b) => (status: 200, body: {'nope': 1});
      await expectLater(service.cancel('sp1'), sentence('The split was not cancelled. Check your connection and try again.'));
    });
  });

  group('a friend\'s requests', () {
    test('are read, newest first as the website sends them', () async {
      site.rpcs['split_my_shares'] = (_) => ok([shareRequestRow(id: 'a'), shareRequestRow(id: 'b', state: 'paid')]);
      final list = await service.myShares();
      expect([for (final r in list) r.id], ['a', 'b']);
      expect(site.forRpc('split_my_shares').single.body, isEmpty);
    });

    test('a failure says the requests could not be loaded', () async {
      site.networkDown = true;
      await expectLater(service.myShares(), throwsA(isA<SiteException>().having((e) => e.message, 'message', contains('your requests to pay'))));
    });

    test('turning one down names it', () async {
      site.rpcs['split_share_decline'] = (_) => ok({'id': 'sh1', 'state': 'declined'});
      await service.decline('sh1');
      expect(site.forRpc('split_share_decline').single.body, {'p_share': 'sh1'});
      site.rpcs['split_share_decline'] = (_) => raised('This request can no longer be turned down.');
      await expectLater(service.decline('sh1'), sentence('This request can no longer be turned down.'));
    });
  });

  group('paying', () {
    test('starting returns the payment page and the session to follow', () async {
      site.functions['create-split-checkout'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_abc#frag', 'session_id': 'cs_test_abc'});
      final start = await service.startPayment('sh1');
      expect(start.url.host, 'checkout.stripe.com');
      expect(start.sessionId, 'cs_test_abc');
      expect(site.forFunction('create-split-checkout').single.body, {'share_id': 'sh1'});
    });

    test('the session the website names is the one to follow, even when the address names another', () async {
      site.functions['create-split-checkout'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_abc#frag', 'session_id': 'cs_other'});
      expect((await service.startPayment('sh1')).sessionId, 'cs_other');
    });

    test('a page whose session is only in its address is still followed', () async {
      site.functions['create-split-checkout'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_zzz#frag'});
      expect((await service.startPayment('sh1')).sessionId, 'cs_test_zzz');
    });

    test('an address that is not a payment page, or no address, is an error', () async {
      site.functions['create-split-checkout'] = (b) => (status: 200, body: {'url': 'http://not-secure.example/pay'});
      await expectLater(service.startPayment('sh1'), throwsA(isA<SiteException>()));
      site.functions['create-split-checkout'] = (b) => (status: 200, body: {'nope': 1});
      await expectLater(service.startPayment('sh1'), throwsA(isA<SiteException>()));
    });

    test('a refusal is its sentence', () async {
      site.functions['create-split-checkout'] = (b) => (status: 409, body: {'error': 'You already paid this.'});
      await expectLater(service.startPayment('sh1'), sentence('You already paid this.'));
      site.functions['create-split-checkout'] = (b) => (status: 503, body: {'error': 'Payments are not set up yet.'});
      await expectLater(service.startPayment('sh1'), sentence('We could not open the payment page. Check your connection and try again.'));
    });

    test('how it stands is read from the website', () async {
      for (final s in SharePayment.values) {
        site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': s.name});
        expect(await service.paymentStatus('sh1'), s);
      }
      expect(site.forFunction('confirm-split-share').first.body, {'share_id': 'sh1'});
    });

    test('an answer it cannot read, or a failure, is an error', () async {
      site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'bogus'});
      await expectLater(service.paymentStatus('sh1'), throwsA(isA<SiteException>()));
      site.functions['confirm-split-share'] = (b) => (status: 500, body: {'error': 'x'});
      await expectLater(service.paymentStatus('sh1'), sentence('We could not check your payment. Check your connection and try again.'));
    });
  });
}
