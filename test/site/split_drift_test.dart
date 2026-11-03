import 'package:bottles_up_user/site/models/split.dart';
import 'package:bottles_up_user/site/rules/split_rules.dart';
import 'package:bottles_up_user/site/services/split_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's split-payments migration and the four functions that go with it.
void main() {
  group('splitting the bill against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('split_payments'));

    String bodyOf(String fn) {
      final start = sql.indexOf('create function public.$fn(');
      expect(start, greaterThanOrEqualTo(0), reason: fn);
      final end = sql.indexOf('\ncreate function', start + 10);
      return sql.substring(start, end == -1 ? sql.length : end);
    }

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = SplitService(site.client);
      site.rpcs['split_create'] = (_) => ok(splitPlanRow());
      site.rpcs['split_for_booking'] = (_) => ok(splitPlanRow());
      site.rpcs['split_my_shares'] = (_) => ok(<Object>[]);
      site.rpcs['split_share_decline'] = (_) => ok({'id': 's', 'state': 'declined'});
      await service.create(bookingId: 'b', shares: const [ShareAsk(payer: 'p', amountCents: 500)], deadline: DateTime.utc(2099));
      await service.forBooking('b');
      await service.myShares();
      await service.decline('s');
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('a friend can call what a friend calls, and only that; the website\'s own functions are not for the app', () {
      final granted = RegExp(r'grant execute on function([\s\S]*?)to authenticated;', caseSensitive: false).firstMatch(sql)!.group(1)!;
      for (final f in ['split_create', 'split_for_booking', 'split_cancel', 'split_my_shares', 'split_share_status', 'split_share_decline', 'split_share_begin']) {
        expect(granted, contains('public.$f('), reason: f);
      }
      final service = RegExp(r'grant execute on function([\s\S]*?)to service_role;', caseSensitive: false).firstMatch(sql)!.group(1)!;
      for (final f in ['split_share_attach', 'split_share_paid', 'split_refunds_due', 'split_share_refunded']) {
        expect(service, contains('public.$f('), reason: f);
        expect(granted, isNot(contains('public.$f(')), reason: '$f is the website\'s alone');
      }
    });

    test('the states a share can be in are exactly the ones the app knows', () {
      final body = bodyOf('split_share_state');
      final words = {for (final m in RegExp(r"then '([a-z]+)'").allMatches(body)) m.group(1)!, ...RegExp(r"else '([a-z]+)'").allMatches(body).map((m) => m.group(1)!)};
      expect(words, {for (final s in ShareState.values) s.wire});
    });

    test('the states a split can be in are exactly the ones the app knows', () {
      final body = bodyOf('split_card');
      final fromCase = body.substring(body.indexOf('v_state := case'), body.indexOf('end;', body.indexOf('v_state := case')));
      final words = {for (final m in RegExp(r"then '([a-z]+)'").allMatches(fromCase)) m.group(1)!, ...RegExp(r"else '([a-z]+)'").allMatches(fromCase).map((m) => m.group(1)!)};
      expect(words, {for (final s in SplitState.values) s.wire});
    });

    test('the fields the app reads of a plan, a share line and a request are the ones the website writes', () {
      final card = bodyOf('split_card');
      for (final key in ['id', 'booking_id', 'state', 'deadline', 'currency', 'balance_cents', 'collected_cents', 'outstanding_cents', 'shares', 'created_at']) {
        expect(card, contains("'$key'"), reason: 'plan.$key');
      }
      for (final key in ['id', 'payer', 'amount_cents', 'status', 'paid_at']) {
        expect(card, contains("'$key'"), reason: 'share.$key');
      }
      final mine = bodyOf('split_my_shares');
      for (final key in ['id', 'state', 'amount_cents', 'currency', 'deadline', 'host', 'venue', 'booking_date', 'start_time', 'paid_at']) {
        expect(mine, contains("'$key'"), reason: 'request.$key');
      }
      // ...and nothing beyond those: a friend is never told the code, the total or the other shares
      final keys = {for (final m in RegExp(r"'([a-z_]+)', ").allMatches(mine.substring(mine.indexOf('jsonb_build_object'), mine.indexOf(') as row')))) m.group(1)!};
      expect(keys, {'id', 'state', 'amount_cents', 'currency', 'deadline', 'host', 'venue', 'booking_date', 'start_time', 'paid_at'});
    });

    test('the limits the app checks first are the website\'s', () {
      final all = sql;
      expect(all, contains('amount_cents int not null check (amount_cents between $minShareCents and $maxShareCents)'));
      expect(all, contains('jsonb_array_length(p_shares) > $maxSplitFriends then'));
      expect(all, contains("raise exception 'A split can have up to $maxSplitFriends friends.'"));
      expect(all, contains("raise exception 'The smallest share is 5.00.'"));
      expect(all, contains("raise exception 'The largest share is 5,000.00.'"));
      expect(all, contains("p_deadline < now() + interval '1 hour'"));
      expect(all, contains("p_deadline > now() + interval '14 days'"));
      expect(all, contains('(v_hours + 12) * 3600'));
      expect(all, contains('v_hours <= -12'));
    });

    test('the friend\'s money rules the app promises in words', () {
      // no fee on top, one request at a time per booking, paid back in full when cancelled
      final cancel = bodyOf('split_cancel');
      expect(cancel, contains('refund_due_cents = paid_cents'));
      expect(cancel, contains("status in ('unpaid', 'pending')"));
      expect(sql, contains('create unique index site_splits_one_open on public.site_splits (booking_id) where status = \'open\''));
    });

    group('the website\'s functions', () {
      test('are all there, and read the keys the app sends and answer the keys the app reads', () {
        final create = readFunction('create-split-checkout');
        expect(create, contains("parseId(body, 'share_id')"));
        expect(create, contains('json({ url: session.url, session_id: session.id })'));
        final confirm = readFunction('confirm-split-share');
        expect(confirm, contains("parseId(body, 'share_id')"));
        for (final word in SharePayment.values) {
          // everything confirm-split-share can say is something the app knows; the states it passes through come from the database
          if (word == SharePayment.paid || word == SharePayment.pending) expect(confirm, contains("status: '${word.name}'"), reason: word.name);
        }
        expect(confirm, contains('json({ status: state })'));
        final cancel = readFunction('cancel-split');
        expect(cancel, contains("parseId(body, 'split_id')"));
        expect(cancel, contains('json({ split: card, refunded, failed })'));
      });

      test('the sentences the app maps to statuses are the ones the functions use', () {
        final shared = readFunctionFile('_shared/splitPayments.ts');
        expect(shared, contains("'Choose a request to pay.'"));
        expect(shared, contains("'Choose a split.'"));
      });
    });
  });
}
