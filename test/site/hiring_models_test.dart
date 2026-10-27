import 'package:bottles_up_user/site/models/hiring.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('words from the website', () {
    test('every request status is known with a label, and an unknown one is not', () {
      for (final w in ['requested', 'quoted', 'declined', 'withdrawn', 'accepted']) {
        final s = RequestStatus.fromWire(w);
        expect(s, isNotNull, reason: w);
        expect(s!.label, isNotEmpty);
      }
      expect(RequestStatus.fromWire('bogus'), isNull);
      expect([for (final s in RequestStatus.values) if (s.isOpen) s], [RequestStatus.requested, RequestStatus.quoted]);
    });

    test('every quote status is known', () {
      for (final w in ['sent', 'accepted', 'declined', 'withdrawn', 'expired']) {
        expect(QuoteStatus.fromWire(w)?.wire, w);
      }
      expect(QuoteStatus.fromWire('x'), isNull);
    });

    test('every booking state is known, and only the ones that cannot change are closed', () {
      for (final w in ['awaiting_deposit', 'expired', 'confirmed', 'paid', 'done', 'completed', 'disputed', 'cancelled']) {
        final s = BookingState.fromWire(w);
        expect(s?.wire, w);
        expect(s!.label, isNotEmpty);
      }
      expect(BookingState.fromWire('x'), isNull);
      expect([for (final s in BookingState.values) if (s.isClosed) s.wire], ['expired', 'completed', 'cancelled']);
    });
  });

  group('services', () {
    test('are read, and a row without an id or a name is dropped', () {
      final list = parseProServices([proServiceRow(), proServiceRow(id: 'sv2', description: null, from: null, note: null, active: false), {'title': 'x'}, {'id': 'a'}, 'junk', proServiceRow(id: 'sv3', title: 'MC')]);
      expect([for (final s in list) s.id], ['sv1', 'sv2', 'sv3']);
      expect(list.first.fromCents, 100000);
      expect(list[1].active, isFalse);
      expect(list[1].description, isNull);
      expect(parseProServices(null), isEmpty);
    });
  });

  group('quotes', () {
    test('are read with the balance they leave', () {
      final q = parseProQuote(proQuoteRow())!;
      expect([q.id, q.totalCents, q.depositCents, q.balanceCents, q.status, q.isOpen], ['q1', 100000, 30000, 70000, QuoteStatus.sent, true]);
      expect(q.balanceDueBy, DateTime(2099, 11, 1));
      expect(q.validUntil.toUtc(), DateTime.utc(2099, 10, 30, 12));
    });

    test('a quote paid at once has no balance date', () {
      final q = parseProQuote(proQuoteRow(deposit: 100000))!;
      expect([q.balanceCents, q.balanceDueBy], [0, null]);
    });

    test('anything the website could not mean is nothing', () {
      for (final bad in [
        proQuoteRow(total: 0),
        proQuoteRow(deposit: 0),
        proQuoteRow(deposit: 100001),
        proQuoteRow(status: 'x'),
        proQuoteRow(scope: ''),
        proQuoteRow(valid: 'not a time'),
        {...proQuoteRow()}..remove('id'),
        'x',
        null,
      ]) {
        expect(parseProQuote(bad), isNull, reason: '$bad');
      }
    });

    test('an expired or answered quote is not open', () {
      for (final s in ['accepted', 'declined', 'withdrawn', 'expired']) {
        expect(parseProQuote(proQuoteRow(status: s))!.isOpen, isFalse, reason: s);
      }
    });
  });

  group('bookings', () {
    test('are read as the customer sees them: no customer, no net', () {
      final b = parseProBooking(proBookingRow(state: 'confirmed', paid: 30000))!;
      expect([b.id, b.requestId, b.state, b.title, b.totalCents, b.depositCents, b.paidCents, b.owedCents, b.freeCancelDays], ['pb1', 'pr1', BookingState.confirmed, 'Wedding DJ set', 100000, 30000, 30000, 70000, 7]);
      expect(b.eventDate, DateTime(2099, 11, 8));
      expect(b.provider!.displayName, 'DJ Dee');
      expect([b.customer, b.netCents, b.commissionBps, b.isProviderView], [null, null, null, false]);
      expect(b.payBy!.toUtc(), DateTime.utc(2099, 10, 26, 12));
    });

    test('and as the professional sees them: the customer, the commission and what they will be paid', () {
      final b = parseProBooking(proBookingRow(client: {'name': 'Ann Lee', 'handle': 'ann'}, net: 95000))!;
      expect([b.customer!.name, b.customer!.handle, b.netCents, b.commissionBps, b.isProviderView], ['Ann Lee', 'ann', 95000, 500, true]);
    });

    test('a dispute is read, open or decided', () {
      expect(parseProBooking(proBookingRow(dispute: {'id': 'd1', 'status': 'open', 'reason': 'No show'}))!.dispute!.open, isTrue);
      final d = parseProBooking(proBookingRow(dispute: {'id': 'd1', 'status': 'resolved', 'outcome': 'refund_part', 'reason': 'Late'}))!.dispute!;
      expect([d.open, d.outcome, d.outcomeText], [false, 'refund_part', 'BottlesUp decided part of the payment goes back to the customer.']);
      expect(parseProBooking(proBookingRow(dispute: {'id': 'd1', 'status': 'open', 'reason': 'x'}))!.dispute!.outcomeText, 'BottlesUp is looking at it.');
      expect(const ProDispute(id: 'a', open: false, reason: 'r', outcome: 'release').outcomeText, contains('professional'));
      expect(const ProDispute(id: 'a', open: false, reason: 'r', outcome: 'refund_full').outcomeText, contains('everything'));
    });

    test('what a late cancellation keeps is the deposit, at least 30%, never more than was paid', () {
      ProBooking b({int total = 100000, int deposit = 30000, int paid = 100000}) => parseProBooking(proBookingRow(total: total, deposit: deposit, paid: paid))!;
      expect(b().keptIfLateCents, 30000);
      expect(b(deposit: 50000).keptIfLateCents, 50000);
      expect(b(deposit: 10000).keptIfLateCents, 30000);
      expect(b(deposit: 10000, paid: 10000).keptIfLateCents, 10000);
      expect(b(deposit: 50000, paid: 20000).keptIfLateCents, 20000);
    });

    test('a booking missing what it needs is nothing', () {
      for (final bad in [
        {...proBookingRow()}..remove('id'),
        proBookingRow(state: 'x'),
        proBookingRow(date: 'soon'),
        proBookingRow(total: 0),
        proBookingRow(deposit: 0),
        'x',
        null,
      ]) {
        expect(parseProBooking(bad), isNull, reason: '$bad');
      }
    });
  });

  group('requests', () {
    test('are read with their service, the professional, the quote and the booking', () {
      final r = parseProRequest(proRequestRow(status: 'accepted', quote: proQuoteRow(status: 'accepted'), booking: proBookingRow()))!;
      expect([r.id, r.status, r.message, r.timeNote, r.location, r.guests, r.budgetCents, r.serviceTitle], ['pr1', RequestStatus.accepted, 'A birthday night for 120', '9pm to 1am', 'Club A', 120, 150000, 'Wedding DJ set']);
      expect(r.eventDate, DateTime(2099, 11, 8));
      expect(r.provider!.handle, 'djdee');
      expect(r.quote!.status, QuoteStatus.accepted);
      expect(r.booking!.id, 'pb1');
      expect([r.isProviderView, r.hasOpenQuote], [false, false]);
    });

    test('an open quote is one the customer can accept', () {
      expect(parseProRequest(proRequestRow(status: 'quoted', quote: proQuoteRow()))!.hasOpenQuote, isTrue);
      expect(parseProRequest(proRequestRow(status: 'quoted', quote: proQuoteRow(status: 'expired')))!.hasOpenQuote, isFalse);
      expect(parseProRequest(proRequestRow(status: 'requested', quote: proQuoteRow()))!.hasOpenQuote, isFalse);
      expect(parseProRequest(proRequestRow(status: 'quoted'))!.hasOpenQuote, isFalse);
    });

    test('the professional\'s view names the customer', () {
      final r = parseProRequest(proRequestRow(client: {'name': 'Ann Lee', 'handle': 'ann'}))!;
      expect([r.isProviderView, r.customer!.name], [true, 'Ann Lee']);
    });

    test('optional parts may be missing', () {
      final r = parseProRequest(proRequestRow(timeNote: null, location: null, guests: null, budget: null, service: null, declineNote: 'Away'))!;
      expect([r.timeNote, r.location, r.guests, r.budgetCents, r.serviceTitle, r.declineNote], [null, null, null, null, null, 'Away']);
    });

    test('a list drops the rows it cannot read', () {
      final list = parseProRequests([proRequestRow(id: 'a'), proRequestRow(id: 'b', status: 'x'), proRequestRow(id: 'c', date: 'x'), {...proRequestRow(id: 'd')}..remove('message'), 'x', proRequestRow(id: 'e')]);
      expect([for (final r in list) r.id], ['a', 'e']);
      expect(parseProRequests(null), isEmpty);
    });
  });

  group('how a payment stands', () {
    test('is read with the booking as it now is', () {
      final p = parseProPayment({'status': 'paid', 'booking': proBookingRow(state: 'confirmed', paid: 30000)})!;
      expect([p.status, p.booking!.paidCents], [ProPayment.paid, 30000]);
      expect(parseProPayment({'status': 'pending'})!.booking, isNull);
      expect(parseProPayment({'status': 'none', 'booking': proBookingRow()})!.status, ProPayment.none);
    });

    test('anything else is nothing', () {
      for (final j in [null, 'paid', <String, dynamic>{}, {'status': 'x'}, {'status': 5}]) {
        expect(parseProPayment(j), isNull, reason: '$j');
      }
    });
  });

  group('what a row without the optional fields means', () {
    test('a booking seen by the professional is told by what they will be paid, not by who the customer is', () {
      expect(parseProBooking(proBookingRow(net: 95000))!.isProviderView, isTrue, reason: 'the customer may have gone');
      expect(parseProBooking(proBookingRow(client: {'name': 'Ann Lee', 'handle': 'ann'}))!.isProviderView, isFalse);
    });

    test('a booking without the amounts still due is all still due, and without the cancel days has seven', () {
      final row = proBookingRow()..remove('owed_cents')..remove('free_cancel_days');
      final b = parseProBooking(row)!;
      expect([b.owedCents, b.freeCancelDays], [100000, 7]);
    });

    test('a service without "active" is shown', () {
      final row = proServiceRow()..remove('active');
      expect(parseProService(row)!.active, isTrue);
      expect(parseProService(proServiceRow(active: false))!.active, isFalse);
    });
  });
}
