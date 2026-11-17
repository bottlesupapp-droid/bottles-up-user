import 'package:bottles_up_user/site/models/hiring.dart';
import 'package:bottles_up_user/site/rules/hiring_rules.dart';
import 'package:bottles_up_user/site/services/hiring_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's marketplace migration and the four functions that go with it.
void main() {
  group('hiring professionals against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('service_marketplace'));

    String bodyOf(String fn) {
      final start = sql.indexOf('create function public.$fn(');
      expect(start, greaterThanOrEqualTo(0), reason: fn);
      final end = sql.indexOf('\ncreate function', start + 10);
      return sql.substring(start, end == -1 ? sql.length : end);
    }

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final s = HiringService(site.client);
      for (final f in ['pro_services_of', 'pro_service_save']) {
        site.rpcs[f] = (_) => ok(f == 'pro_services_of' ? [proServiceRow()] : proServiceRow());
      }
      site.rpcs['pro_service_remove'] = (_) => ok(null);
      site.rpcs['pro_busy_days'] = (_) => ok(<Object>[]);
      site.rpcs['pro_busy_set'] = (_) => ok(null);
      site.rpcs['pro_request_create'] = (_) => ok(proRequestRow());
      site.rpcs['pro_requests_mine'] = (_) => ok(<Object>[]);
      site.rpcs['pro_requests_for'] = (_) => ok(<Object>[]);
      for (final f in ['pro_request_get', 'pro_quote_send', 'pro_quote_withdraw', 'pro_request_decline', 'pro_request_withdraw', 'pro_quote_decline']) {
        site.rpcs[f] = (_) => ok(proRequestRow());
      }
      for (final f in ['pro_quote_accept', 'pro_booking_get', 'pro_booking_done', 'pro_booking_confirm', 'pro_dispute_open']) {
        site.rpcs[f] = (_) => ok(proBookingRow());
      }
      await s.services('p');
      await s.saveService(actor: 'a', id: 'i', title: 'abc', description: 'd', fromCents: 1, priceNote: 'n');
      await s.removeService(actor: 'a', id: 'i');
      await s.busyDays('p', from: DateTime(2099));
      await s.setBusy(actor: 'a', day: DateTime(2099), busy: true);
      await s.createRequest(provider: 'p', service: 's', date: DateTime(2099), timeNote: 't', location: 'l', guests: 1, message: 'abc', budgetCents: 1);
      await s.myRequests();
      await s.requestsFor('a');
      await s.request('r');
      await s.sendQuote(actor: 'a', request: 'r', total: 1, deposit: 1, balanceDueBy: DateTime(2099), scope: 'scope scope', validDays: 1);
      await s.withdrawQuote(actor: 'a', request: 'r');
      await s.declineRequest(actor: 'a', request: 'r', note: 'n');
      await s.withdrawRequest('r');
      await s.declineQuote('r');
      await s.acceptQuote('r');
      await s.booking('b');
      await s.markDone(actor: 'a', booking: 'b');
      await s.confirm('b');
      await s.openDispute(booking: 'b', reason: 'reason reason');
      expect(site.rpcRequests.length, 19);
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('a person can call what a person calls, and only that; the money functions are the website\'s alone', () {
      final people = RegExp(r'grant execute on function([\s\S]*?)to authenticated;', caseSensitive: false).allMatches(sql).map((m) => m.group(1)!).join('\n');
      for (final f in [
        'pro_service_save', 'pro_service_remove', 'pro_services_of', 'pro_busy_set', 'pro_busy_days', 'pro_request_create', 'pro_request_get', 'pro_requests_mine', 'pro_requests_for',
        'pro_quote_send', 'pro_quote_withdraw', 'pro_request_decline', 'pro_request_withdraw', 'pro_quote_decline', 'pro_quote_accept', 'pro_booking_get', 'pro_payment_begin',
        'pro_booking_cancel', 'pro_booking_done', 'pro_booking_confirm', 'pro_dispute_open',
      ]) {
        expect(people, contains('public.$f('), reason: f);
      }
      final service = RegExp(r'grant execute on function([\s\S]*?)to service_role;', caseSensitive: false).firstMatch(sql)!.group(1)!;
      for (final f in ['pro_payment_attach', 'pro_payment_paid', 'pro_refunds_due', 'pro_payment_refunded', 'market_housekeeping']) {
        expect(service, contains('public.$f('), reason: f);
        expect(people, isNot(contains('public.$f(')), reason: '$f is the website\'s alone');
      }
    });

    test('the states the app knows are exactly the ones the website says', () {
      final state = bodyOf('market_booking_state');
      final words = {for (final m in RegExp(r"then '([a-z_]+)'").allMatches(state)) m.group(1)!, ...RegExp(r"else '([a-z_]+)'").allMatches(state).map((m) => m.group(1)!)};
      expect(words, {for (final s in BookingState.values) s.wire});
      expect(sqlWordsAfter(sql, "status text not null default 'requested' check (status in"), {for (final s in RequestStatus.values) s.wire});
      final quote = bodyOf('market_quote_json');
      expect({...sqlWordsAfter(sql, "status text not null default 'sent' check (status in"), 'expired'}, {for (final s in QuoteStatus.values) s.wire});
      expect(quote, contains("then 'expired'"));
    });

    test('the fields the app reads of a request, a quote and a booking are the ones the website writes', () {
      final request = bodyOf('pro_request_json');
      for (final k in ['id', 'status', 'event_date', 'time_note', 'location', 'guests', 'message', 'budget_cents', 'decline_note', 'created_at', 'service', 'provider', 'client', 'quote', 'booking']) {
        expect(request, contains("'$k'"), reason: 'request.$k');
      }
      final quote = bodyOf('market_quote_json');
      for (final k in ['id', 'total_cents', 'deposit_cents', 'balance_due_by', 'scope', 'valid_until', 'status']) {
        expect(quote, contains("'$k'"), reason: 'quote.$k');
      }
      final booking = bodyOf('market_booking_json');
      for (final k in ['id', 'request_id', 'state', 'title', 'event_date', 'currency', 'total_cents', 'deposit_cents', 'balance_due_by', 'paid_cents', 'owed_cents', 'pay_by', 'provider_done_at', 'completed_at', 'cancelled_by', 'cancel_reason', 'free_cancel_days', 'provider', 'client', 'net_cents', 'commission_bps', 'dispute', 'created_at']) {
        expect(booking, contains("'$k'"), reason: 'booking.$k');
      }
    });

    test('the limits the app checks first are the website\'s', () {
      expect(sql, contains('total_cents int not null check (total_cents between $minQuoteCents and $maxQuoteCents)'));
      expect(sql, contains('p_deposit_cents < (p_total_cents + 9) / 10'));
      expect(sql, contains("raise exception 'Say what is included in $minScopeLength to $maxScopeLength characters.'"));
      expect(sql, contains("raise exception 'A quote can stay open for 1 to $maxQuoteDays days.'"));
      expect(sql, contains("raise exception 'Tell them about the job in $minTextLength to $maxMessageLength characters.'"));
      expect(sql, contains("raise exception 'Say what went wrong in $minReasonLength to $maxReasonLength characters.'"));
      expect(sql, contains('p_event_date <= current_date or p_event_date > current_date + 730'));
      expect(sql, contains('b.event_date + 7 < current_date'));
      expect(sql, contains("(b.total_cents * 30 / 100)"));
    });

    group('the website\'s functions', () {
      test('read the keys the app sends and answer the keys the app reads', () {
        final create = readFunction('create-pro-checkout');
        expect(create, contains("parseId(body, 'booking_id')"));
        expect(create, contains('json({ url: session.url, session_id: session.id, kind: b.kind, amount_cents: b.amount_cents })'));
        final confirm = readFunction('confirm-pro-payment');
        expect(confirm, contains("parseId(body, 'booking_id')"));
        for (final p in ProPayment.values) {
          expect(confirm, contains("'${p.name}'"), reason: p.name);
        }
        final cancel = readFunction('cancel-pro-booking');
        expect(cancel, contains("parseId(body, 'booking_id')"));
        expect(cancel, contains('json({ booking, refunded, failed })'));
        expect(cancel, contains('(body as { reason?: unknown }).reason'));
      });
    });
  });
}
