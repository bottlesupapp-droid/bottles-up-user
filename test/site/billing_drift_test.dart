import 'package:bottles_up_user/site/models/billing.dart';
import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/services/billing_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's subscriptions, referrals, tips and earnings migration and the three edge functions.
void main() {
  group('billing against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() {
      sql = migrationCode('billing_referrals_earnings');
    });

    String bodyOf(String fn) {
      final start = sql.indexOf('create function public.$fn(');
      expect(start, greaterThanOrEqualTo(0), reason: fn);
      final end = sql.indexOf('\ncreate function', start + 10);
      return sql.substring(start, end == -1 ? sql.length : end);
    }

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final s = BillingService(site.client);
      site.rpcs['sub_plans'] = (_) => ok(plansRow());
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow());
      site.rpcs['referral_code'] = (_) => ok({'code': 'ABCD1234'});
      site.rpcs['referral_mine'] = (_) => ok(null);
      site.rpcs['referral_claim'] = (_) => ok({'claimed': true});
      site.rpcs['referral_stats'] = (_) => ok(statsRow());
      site.rpcs['tip_status'] = (_) => ok(tipRow());
      site.rpcs['earnings_overview'] = (_) => ok(earningsRow());
      await s.plans();
      await s.status('p');
      await s.referralCode('p');
      await s.myReferral();
      await s.claim('ABCD1234');
      await s.referralStats('p');
      await s.tipState('t');
      await s.earnings('p');
      expect(site.rpcRequests.length, 8);
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('a person can call what a person calls, and the money functions are not for them', () {
      final people = RegExp(r'grant execute on function([\s\S]*?)to authenticated;', caseSensitive: false).allMatches(sql).map((m) => m.group(1)!).join('\n');
      for (final f in ['sub_plans', 'sub_status', 'referral_code', 'referral_mine', 'referral_claim', 'referral_stats', 'tip_status', 'earnings_overview']) {
        expect(people, contains('public.$f('), reason: f);
      }
      for (final f in ['sub_apply', 'sub_attach', 'tip_attach', 'tip_paid', 'billing_require', 'referral_credit_for']) {
        expect(people, isNot(contains('public.$f(')), reason: '$f is not for a person');
      }
    });

    test('the switches the app looks at are the ones the website checks', () {
      expect(bodyOf('sub_plans'), contains("billing_require('${Feature.subscriptions}')"));
      expect(bodyOf('sub_status'), contains("billing_require('${Feature.subscriptions}')"));
      expect(bodyOf('referral_code'), contains("billing_require('${Feature.referrals}')"));
      expect(bodyOf('referral_claim'), contains("billing_require('${Feature.referrals}')"));
      expect(bodyOf('tip_begin'), contains("billing_require('${Feature.creatorEarnings}')"));
      expect(bodyOf('tip_status'), contains("billing_require('${Feature.creatorEarnings}')"));
    });

    test('the plans, the statuses and the states the app knows are the website\'s', () {
      expect(sqlWordsAfter(sql, 'plan text not null check (plan in'), {for (final p in SubPlan.values) p.wire});
      expect(sqlWordsAfter(sql, "status text not null default 'incomplete' check (status in"), {'incomplete', 'active', 'past_due', 'cancelled'});
      expect(sqlWordsAfter(sql, "status text not null default 'created' check (status in"), {'created', 'paid', 'void'});
    });

    test('the fields the app reads of the plans, a subscription, a tip and the earnings are the ones the website writes', () {
      for (final k in ['currency', 'monthly_cents', 'yearly_cents', 'subscribed_commission_bps', 'standard_commission_bps']) {
        expect(bodyOf('sub_plans'), contains("'$k'"), reason: 'plans.$k');
      }
      for (final k in ['id', 'profile', 'plan', 'status', 'current_period_end', 'cancel_at_period_end']) {
        expect(bodyOf('sub_json'), contains("'$k'"), reason: 'subscription.$k');
      }
      for (final k in ['id', 'status', 'amount_cents', 'currency', 'creator']) {
        expect(bodyOf('tip_status'), contains("'$k'"), reason: 'tip.$k');
      }
      for (final k in ['referred', 'credited', 'payable_cents', 'paid_cents', 'credit_cents']) {
        expect(bodyOf('referral_stats'), contains("'$k'"), reason: 'stats.$k');
      }
      for (final k in ['referrer', 'claimed_at']) {
        expect(bodyOf('referral_mine'), contains("'$k'"), reason: 'referral.$k');
      }
      final overview = bodyOf('earnings_overview');
      for (final k in ['hiring', 'tips', 'referrals', 'subscription', 'collected_cents', 'held_cents', 'earned_cents', 'withdrawable_cents', 'paid_cents', 'commission_cents', 'count']) {
        expect(overview, contains("'$k'"), reason: 'earnings.$k');
      }
    });

    test('the edge functions take what the app sends and answer what the app reads', () {
      final sub = readFunction('create-subscription-checkout');
      expect(sub, contains("'profile_id'"));
      expect(sub, contains('parsePlan(body)'));
      expect(readFunctionFile('_shared/billing.ts'), contains('as Record<string, unknown>).plan'));
      expect(sub, contains('url: session.url'));
      expect(sub, contains('session_id: session.id'));
      final portal = readFunction('create-billing-portal');
      expect(portal, contains("'profile_id'"));
      expect(portal, contains('url: portal.url'));
      final tip = readFunction('create-tip-checkout');
      for (final k in ["'creator_id'", "'amount_cents'"]) {
        expect(tip, contains(k), reason: 'tip checkout reads $k');
      }
      expect(readFunctionFile('_shared/billing.ts'), contains('as Record<string, unknown>).message'));
      expect(tip, contains('tip_id: b.tip_id'));
      expect(tip, contains('url: session.url'));
      expect(tip, contains('session_id: session.id'));
    });
  });
}
