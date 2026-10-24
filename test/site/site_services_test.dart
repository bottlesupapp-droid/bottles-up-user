import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/services/my_tickets_service.dart';
import 'package:bottles_up_user/site/services/site_events_service.dart';
import 'package:bottles_up_user/site/services/ticket_checkout_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  group('events', () {
    test('asks for published events, soonest first, with their ticket types in one request', () async {
      site.tables['site_events'] = [eventRow()];
      final events = await SiteEventsService(site.client).upcoming(now: DateTime.utc(2099, 1, 1));
      final r = site.forTable('site_events').single;
      expect(r.method, 'GET');
      expect(r.query['status'], 'eq.published');
      expect(r.query['order'], startsWith('start_date.asc'));
      expect(r.query['select'], allOf(contains('title'), contains('start_date'), contains('tiers:site_ticket_tiers('), contains('requires_access_code'), contains('is_non_transferable')));
      expect(events.single.title, 'Friday Night');
      expect(events.single.tiers.single.name, 'General');
    });

    test('leaves out events that are over, and events that cannot be read; sorts by start', () async {
      site.tables['site_events'] = [
        eventRow(id: 'late', title: 'Late', start: '2099-11-01T20:00:00Z'),
        eventRow(id: 'over', title: 'Over', start: '2020-01-01T20:00:00Z', end: '2020-01-02T02:00:00Z'),
        {...eventRow(id: 'bad'), 'start_date': 'soon'},
        eventRow(id: 'soon', title: 'Soon', start: '2099-10-01T20:00:00Z'),
      ];
      final events = await SiteEventsService(site.client).upcoming(now: DateTime.utc(2099, 1, 1));
      expect(events.map((e) => e.id), ['soon', 'late']);
    });

    test('an event that is running now is still listed', () async {
      site.tables['site_events'] = [eventRow(start: '2026-10-24T22:00:00Z', end: '2026-10-25T04:00:00Z')];
      expect((await SiteEventsService(site.client).upcoming(now: DateTime.utc(2026, 10, 25, 1))).length, 1);
    });

    test('a failure is a plain sentence, never the technical reason', () async {
      site.failAllWith = 500;
      await expectLater(SiteEventsService(site.client).upcoming(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load events. Check your connection and try again.')));
      site.failAllWith = null;
      site.networkDown = true;
      await expectLater(SiteEventsService(site.client).upcoming(), throwsA(isA<SiteException>()));
    });

    test('one event is asked for by id, only if published', () async {
      site.tables['site_events'] = [eventRow()];
      final e = await SiteEventsService(site.client).event('e1');
      final r = site.forTable('site_events').single;
      expect([r.query['id'], r.query['status']], ['eq.e1', 'eq.published']);
      expect(e!.id, 'e1');
    });

    test('no such published event is null, not an error', () async {
      site.tables['site_events'] = [];
      expect(await SiteEventsService(site.client).event('nope'), isNull);
    });
  });

  group('buying tickets', () {
    test('a promo code is previewed for tickets, with the venue and the subtotal, and the code as typed (trimmed)', () async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': true, 'message': 'ok', 'discountCents': 500});
      final c = await TicketCheckoutService(site.client).checkPromo(code: '  WELCOME5 ', subtotalCents: 10000, venueId: 'v1');
      expect(site.forFunction('validate-promo-code').single.body, {'code': 'WELCOME5', 'applies_to': 'tickets', 'venue_id': 'v1', 'subtotal_cents': 10000});
      expect([c.valid, c.discountCents], [true, 500]);
    });

    test('a promo code without a venue sends none', () async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': false, 'message': 'Invalid promo code'});
      final c = await TicketCheckoutService(site.client).checkPromo(code: 'X', subtotalCents: 0);
      expect(site.forFunction('validate-promo-code').single.body.containsKey('venue_id'), isFalse);
      expect([c.valid, c.message], [false, 'Invalid promo code']);
    });

    test('an access code is checked for its ticket type', () async {
      site.functions['validate-tier-access-code'] = (b) => (status: 200, body: {'valid': true, 'message': 'Access code accepted', 'price_cents': 5000, 'currency': 'cad'});
      final c = await TicketCheckoutService(site.client).checkAccessCode(tierId: 't1', code: ' VIP ');
      expect(site.forFunction('validate-tier-access-code').single.body, {'tier_id': 't1', 'code': 'VIP'});
      expect(c.valid, isTrue);
    });

    test('starting the order sends exactly what the website wants, leaving out what is empty, and gives back the page to pay on', () async {
      site.functions['site-create-checkout-session'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_abc123#x'});
      final start = await TicketCheckoutService(site.client).start(eventId: 'e1', tierId: 't1', quantity: 2, name: ' Dana Door ', email: ' dana@example.com ', phone: '  ', promoCode: '', accessCode: null);
      expect(site.forFunction('site-create-checkout-session').single.body, {'event_id': 'e1', 'tier_id': 't1', 'quantity': 2, 'customer_name': 'Dana Door', 'customer_email': 'dana@example.com'});
      expect(start.url.host, 'checkout.stripe.com');
      expect(start.sessionId, 'cs_test_abc123');
    });

    test('phone, promo and access code are sent when given', () async {
      site.functions['site-create-checkout-session'] = (b) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_live_z', 'session_id': 'cs_live_z', 'order_id': 'o1'});
      final start = await TicketCheckoutService(site.client).start(eventId: 'e1', tierId: 't1', quantity: 1, name: 'Dana', email: 'd@e.co', phone: ' +1 555 0100 ', promoCode: ' WELCOME5 ', accessCode: ' VIP ');
      final body = site.forFunction('site-create-checkout-session').single.body;
      expect([body['customer_phone'], body['promo_code'], body['access_code']], ['+1 555 0100', 'WELCOME5', 'VIP']);
      expect([start.sessionId, start.orderId], ['cs_live_z', 'o1']);
    });

    test('the website\'s refusal comes back in its own words', () async {
      site.functions['site-create-checkout-session'] = (b) => (status: 409, body: {'error': 'Not enough tickets left in this tier'});
      await expectLater(
        TicketCheckoutService(site.client).start(eventId: 'e1', tierId: 't1', quantity: 5, name: 'Dana', email: 'd@e.co'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Not enough tickets left in this tier')),
      );
    });

    test('a server error, a lost connection and an answer with no payment page are each a plain sentence', () async {
      final service = TicketCheckoutService(site.client);
      site.functions['site-create-checkout-session'] = (b) => (status: 500, body: {'error': 'Internal server error'});
      await expectLater(service.start(eventId: 'e', tierId: 't', quantity: 1, name: 'Dana', email: 'd@e.co'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not start your payment. Check your connection and try again.')));
      site.functions['site-create-checkout-session'] = (b) => (status: 200, body: {'url': 'http://not-https.example'});
      await expectLater(service.start(eventId: 'e', tierId: 't', quantity: 1, name: 'Dana', email: 'd@e.co'), throwsA(isA<SiteException>()));
      site.networkDown = true;
      await expectLater(service.start(eventId: 'e', tierId: 't', quantity: 1, name: 'Dana', email: 'd@e.co'), throwsA(isA<SiteException>().having((e) => e.message, 'message', isNot(contains('network')))));
    });

    test('the payment status is asked for by session id', () async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: {'status': 'pending'});
      final s = await TicketCheckoutService(site.client).status('cs_test_abc');
      expect(site.forFunction('site-booking-status').single.body, {'session_id': 'cs_test_abc'});
      expect(s.state, PaymentState.waiting);
    });

    test('a status that fails to load is a sentence, so the screen can keep waiting', () async {
      site.networkDown = true;
      await expectLater(TicketCheckoutService(site.client).status('cs_test_abc'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not check your payment. Check your connection and try again.')));
    });
  });

  group('my tickets', () {
    test('asks for paid and refunded orders, newest first, with the event and ticket type', () async {
      site.tables['site_orders'] = [orderRow(), orderRow(id: 'o2', status: 'refunded')];
      final orders = await MyTicketsService(site.client).orders();
      final r = site.forTable('site_orders').single;
      expect(r.query['status'], 'in.("paid","refunded")');
      expect(r.query['order'], startsWith('created_at.desc'));
      expect(r.query['select'], allOf(contains('ticket_code'), contains('site_events('), contains('site_ticket_tiers('), contains('is_non_transferable')));
      expect(orders.map((o) => o.id), ['o1', 'o2']);
    });

    test('an order that cannot be read is left out', () async {
      site.tables['site_orders'] = [orderRow(), orderRow(id: 'bad', status: 'weird')];
      expect((await MyTicketsService(site.client).orders()).map((o) => o.id), ['o1']);
    });

    test('failing to load is a sentence', () async {
      site.failAllWith = 500;
      await expectLater(MyTicketsService(site.client).orders(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load your tickets. Check your connection and try again.')));
    });

    test('the newest order for a ticket type since a time is asked for by event, type and time', () async {
      site.tables['site_orders'] = [orderRow(status: 'pending', code: null)];
      final o = await MyTicketsService(site.client).latestFor(eventId: 'e1', tierId: 't1', since: DateTime.utc(2099, 10, 20, 12));
      final r = site.forTable('site_orders').single;
      expect([r.query['event_id'], r.query['tier_id'], r.query['created_at'], r.query['limit']], ['eq.e1', 'eq.t1', 'gte.2099-10-20T12:00:00.000Z', '1']);
      expect(r.query['order'], startsWith('created_at.desc'));
      expect(o!.status.db, 'pending');
    });

    test('no order yet is null', () async {
      site.tables['site_orders'] = [];
      expect(await MyTicketsService(site.client).latestFor(eventId: 'e1', tierId: 't1', since: DateTime.utc(2099)), isNull);
    });

    test('an entry code is asked for by order, and says where it went and how long it lasts', () async {
      site.functions['request-ticket-otp'] = (b) => (status: 200, body: {'success': true, 'email_preview': 'da***@example.com', 'expires_in_seconds': 300});
      final sent = await MyTicketsService(site.client).requestEntryCode('o1');
      expect(site.forFunction('request-ticket-otp').single.body, {'order_id': 'o1'});
      expect([sent.emailPreview, sent.expiresIn], ['da***@example.com', const Duration(minutes: 5)]);
    });

    test('an entry code that cannot be sent says why in the website\'s words, or a plain sentence', () async {
      site.functions['request-ticket-otp'] = (b) => (status: 400, body: {'error': 'Ticket has already been used'});
      await expectLater(MyTicketsService(site.client).requestEntryCode('o1'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Ticket has already been used')));
      site.functions['request-ticket-otp'] = (b) => (status: 500, body: {'error': 'Email provider failed to send'});
      await expectLater(MyTicketsService(site.client).requestEntryCode('o1'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not send your entry code. Check your connection and try again.')));
    });
  });
}
