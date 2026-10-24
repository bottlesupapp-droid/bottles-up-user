import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/models/ticket_order.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/site_config.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../support/fake_website.dart';

void main() {
  group('money', () {
    test('is whole cents turned into words', () {
      expect(formatMoney(5000), '\$50.00');
      expect(formatMoney(5), '\$0.05');
      expect(formatMoney(123456789), '\$1,234,567.89');
      expect(formatMoney(-250), '-\$2.50');
      expect(formatPrice(0), 'Free');
      expect(formatPrice(100), '\$1.00');
    });
  });

  group('the site address', () {
    test('is the real site unless a plain https address is configured', () {
      expect(siteOrigin(null), defaultSiteUrl);
      expect(siteOrigin(''), defaultSiteUrl);
      expect(siteOrigin('http://staging.example.com'), defaultSiteUrl);
      expect(siteOrigin('https://user:pw@staging.example.com'), defaultSiteUrl);
      expect(siteOrigin('https://localhost'), defaultSiteUrl);
      expect(siteOrigin('https://staging.example.com/some/path?x=1'), 'https://staging.example.com');
    });

    test('links point at the website\'s own pages', () {
      expect(eventPageUri('e 1', origin: 'https://s.example.com').toString(), 'https://s.example.com/events/e%201');
      expect(privacyPolicyUri(origin: 'https://s.example.com').toString(), 'https://s.example.com/privacy-policy');
    });
  });

  group('an event', () {
    test('is read with its ticket types, cheapest first, and the lineup in either shape', () {
      final e = parseSiteEvent(eventRow(tiers: [tierRow(id: 'b', price: 9000, name: 'VIP'), tierRow(id: 'a', price: 3000)]))!;
      expect([e.id, e.title, e.venueName, e.venueId], ['e1', 'Friday Night', 'Club A', 'v1']);
      expect(e.tiers.map((t) => t.id), ['a', 'b']);
      expect(e.lineup, ['DJ One', 'DJ Two']);
      expect(e.goodToKnow, ['19+', 'ID required']);
      expect(e.picture, 'https://img.example/cover.jpg');
      expect(e.fromPriceCents, 3000);
    });

    test('a row that cannot be trusted is dropped, never guessed', () {
      expect(parseSiteEvent({...eventRow(), 'id': null}), isNull);
      expect(parseSiteEvent({...eventRow(), 'title': '  '}), isNull);
      expect(parseSiteEvent({...eventRow(), 'start_date': 'soon'}), isNull);
    });

    test('a ticket type with no price or no name is left out of the event', () {
      final e = parseSiteEvent(eventRow(tiers: [tierRow(id: 'a'), {...tierRow(id: 'b'), 'price_cents': null}, {...tierRow(id: 'c'), 'name': ''}]))!;
      expect(e.tiers.map((t) => t.id), ['a']);
    });

    test('the picture is the banner first, then the cover, then the gallery', () {
      expect(parseSiteEvent({...eventRow(), 'banner_image_url': 'https://img/b.jpg'})!.picture, 'https://img/b.jpg');
      expect(parseSiteEvent({...eventRow(), 'cover_image_url': null, 'gallery': ['https://img/g.jpg']})!.picture, 'https://img/g.jpg');
      expect(parseSiteEvent({...eventRow(), 'cover_image_url': null})!.picture, isNull);
    });

    test('is over when it ends; with no end it lasts 12 hours', () {
      final e = parseSiteEvent(eventRow(start: '2026-10-24T22:00:00Z', end: '2026-10-25T02:00:00Z'))!;
      expect(e.isOver(DateTime.utc(2026, 10, 25, 1)), isFalse);
      expect(e.isLive(DateTime.utc(2026, 10, 25, 1)), isTrue);
      expect(e.isOver(DateTime.utc(2026, 10, 25, 2)), isTrue);
      final open = parseSiteEvent(eventRow(start: '2026-10-24T22:00:00Z', end: null))!;
      expect(open.isOver(DateTime.utc(2026, 10, 25, 9)), isFalse);
      expect(open.isOver(DateTime.utc(2026, 10, 25, 10)), isTrue);
      expect(e.isLive(DateTime.utc(2026, 10, 24, 21)), isFalse, reason: 'not started');
    });

    test('the price to show skips sold out and locked types, but falls back to them', () {
      final open = parseSiteEvent(eventRow(tiers: [tierRow(id: 'a', price: 1000, sold: 100), tierRow(id: 'b', price: 2000, code: true), tierRow(id: 'c', price: 4000)]))!;
      expect(open.fromPriceCents, 4000);
      final onlyLocked = parseSiteEvent(eventRow(tiers: [tierRow(id: 'b', price: 2000, code: true), tierRow(id: 'a', price: 1000, sold: 100)]))!;
      expect(onlyLocked.fromPriceCents, 2000);
      final none = parseSiteEvent(eventRow(tiers: [tierRow(id: 'a', sold: 100)]))!;
      expect(none.fromPriceCents, isNull);
      expect(none.soldOut, isTrue);
      expect(parseSiteEvent(eventRow(tiers: []))!.soldOut, isFalse, reason: 'no ticket types yet is not "sold out"');
    });
  });

  group('a ticket type', () {
    test('counts what is left and never goes below nothing', () {
      final t = parseTicketTier(tierRow(capacity: 10, sold: 4))!;
      expect([t.available, t.soldOut, t.isFree], [6, false, false]);
      expect(parseTicketTier(tierRow(capacity: 10, sold: 14))!.available, 0);
      expect(parseTicketTier(tierRow(price: 0))!.isFree, isTrue);
    });

    test('keeps the flags the website sets', () {
      final t = parseTicketTier(tierRow(code: true, nonTransferable: true))!;
      expect([t.requiresAccessCode, t.isNonTransferable], [true, true]);
    });

    test('negative prices and missing ids are refused', () {
      expect(parseTicketTier({...tierRow(), 'price_cents': -1}), isNull);
      expect(parseTicketTier({...tierRow(), 'id': null}), isNull);
    });
  });

  group('an order of tickets', () {
    test('is read with its event and ticket type', () {
      final o = parseTicketOrder(orderRow())!;
      expect([o.id, o.status, o.quantity, o.amountCents, o.ticketCode, o.eventTitle, o.venueName, o.tierName], ['o1', OrderStatus.paid, 2, 10000, 'BU-ABCD2345', 'Friday Night', 'Club A', 'General']);
      expect(o.isPaid, isTrue);
      expect(o.hasTicket, isTrue);
    });

    test('is only a ticket once it is paid and has a code', () {
      expect(parseTicketOrder(orderRow(code: null))!.isPaid, isFalse);
      expect(parseTicketOrder(orderRow(status: 'refunded'))!.isPaid, isFalse);
      expect(parseTicketOrder(orderRow(status: 'refunded'))!.isRefunded, isTrue);
    });

    test('a status the app does not know, or a missing quantity, is not shown', () {
      expect(parseTicketOrder(orderRow(status: 'exploded')), isNull);
      expect(parseTicketOrder({...orderRow(), 'quantity': 0}), isNull);
      expect(parseTicketOrder({...orderRow(), 'id': null}), isNull);
    });

    test('is past once the event is over, and not before; no known event is never past', () {
      final o = parseTicketOrder(orderRow(eventStart: '2026-10-24T22:00:00Z', eventEnd: '2026-10-25T02:00:00Z'))!;
      expect(o.isPast(DateTime.utc(2026, 10, 25, 1)), isFalse);
      expect(o.isPast(DateTime.utc(2026, 10, 25, 3)), isTrue);
      expect(parseTicketOrder({...orderRow(), 'site_events': null})!.isPast(DateTime.utc(2100)), isFalse);
    });

    test('knows when it was used', () {
      expect(parseTicketOrder(orderRow(checkedIn: '2026-10-24T23:30:00Z'))!.isUsed, isTrue);
      expect(parseTicketOrder(orderRow())!.isUsed, isFalse);
    });
  });

  group('checkout answers', () {
    test('a promo check is a discount only when valid and above nothing', () {
      expect(parsePromoCheck({'valid': true, 'message': 'ok', 'discountCents': 500}).discountCents, 500);
      expect(parsePromoCheck({'valid': false, 'message': 'This promo code has expired', 'discountCents': 500}).discountCents, 0);
      expect(parsePromoCheck({'valid': false}).message, 'That promo code did not work.');
      expect(parsePromoCheck({'valid': true, 'message': 'ok', 'discountCents': -5}).valid, isFalse);
    });

    test('an access check says valid or not, in the website\'s words', () {
      expect(parseAccessCheck({'valid': true, 'message': 'Access code accepted'}).valid, isTrue);
      expect(parseAccessCheck({'valid': false, 'message': 'Invalid access code'}).message, 'Invalid access code');
      expect(parseAccessCheck({}).valid, isFalse);
    });

    test('the payment page must be a real https address; the session id comes from the answer or from the address', () {
      final a = parseCheckoutStart({'url': 'https://checkout.stripe.com/c/pay/cs_test_a1B2c3#frag', 'order_id': 'o9'})!;
      expect([a.sessionId, a.orderId], ['cs_test_a1B2c3', 'o9']);
      final b = parseCheckoutStart({'url': 'https://checkout.stripe.com/c/pay/cs_live_zzz', 'session_id': 'cs_live_given'})!;
      expect(b.sessionId, 'cs_live_given');
      expect(parseCheckoutStart({'url': 'http://checkout.stripe.com/x'}), isNull);
      expect(parseCheckoutStart({'url': 'javascript:alert(1)'}), isNull);
      expect(parseCheckoutStart({'url': ''}), isNull);
      expect(parseCheckoutStart({}), isNull);
      expect(parseCheckoutStart({'url': 'https://example.com/pay'})!.sessionId, isNull);
    });

    test('a payment status is paid only with a ticket code; the rest is waiting, failed or not found', () {
      final paid = parsePaymentStatus({
        'status': 'paid',
        'ticket': {'ticketCode': 'BU-ABCD2345', 'quantity': 2, 'tierName': 'General', 'eventTitle': 'Friday Night', 'venueName': 'Club A', 'startDate': '2099-10-24T23:00:00Z', 'customerEmail': 'a@b.co', 'discountCents': 500},
      });
      expect(paid.state, PaymentState.paid);
      expect([paid.ticket!.ticketCode, paid.ticket!.quantity, paid.ticket!.discountCents], ['BU-ABCD2345', 2, 500]);
      expect(parsePaymentStatus({'status': 'paid'}).state, PaymentState.waiting, reason: 'paid but no ticket yet');
      expect(parsePaymentStatus({'status': 'paid', 'ticket': {'quantity': 1}}).state, PaymentState.waiting);
      expect(parsePaymentStatus({'status': 'pending'}).state, PaymentState.waiting);
      expect(parsePaymentStatus({'status': 'failed'}).state, PaymentState.failed);
      expect(parsePaymentStatus({'status': 'not_found'}).state, PaymentState.notFound);
      expect(parsePaymentStatus({}).state, PaymentState.waiting);
    });
  });

  group('errors', () {
    test('a refusal from the website is shown in its own words', () {
      final e = siteExceptionFrom(const FunctionException(status: 409, details: {'error': 'Not enough tickets left in this tier'}));
      expect([e.message, e.status], ['Not enough tickets left in this tier', 409]);
      expect(siteExceptionFrom(const FunctionException(status: 400, details: {'valid': false, 'message': 'This promo code has expired'})).message, 'This promo code has expired');
    });

    test('a server error, an expired sign-in and anything else become plain sentences', () {
      expect(siteExceptionFrom(const FunctionException(status: 500, details: {'error': 'Internal server error'})).message, actionFailedMessage);
      expect(siteExceptionFrom(const FunctionException(status: 401, details: {'error': 'Unauthorized'})).message, 'Your sign-in has expired. Sign in again, then try again.');
      expect(siteExceptionFrom(Exception('socket closed')).message, actionFailedMessage);
      expect(siteExceptionFrom(Exception('x'), generic: 'Custom.').message, 'Custom.');
    });

    test('a bare "Unauthorized" from the website is not shown as it is', () {
      expect(siteExceptionFrom(const FunctionException(status: 403, details: {'error': 'Unauthorized'})).message, 'That is not available to your account.');
      expect(siteExceptionFrom(const FunctionException(status: 403, details: {'error': 'Forbidden.'})).message, 'That is not available to your account.');
    });

    test('an odd refusal body is not shown (too long, empty, or not a sentence)', () {
      expect(siteExceptionFrom(FunctionException(status: 400, details: {'error': 'x' * 300})).message, actionFailedMessage);
      expect(siteExceptionFrom(const FunctionException(status: 400, details: {'error': '  '})).message, actionFailedMessage);
      expect(siteExceptionFrom(const FunctionException(status: 400, details: 'plain text')).message, actionFailedMessage);
    });
  });
}
