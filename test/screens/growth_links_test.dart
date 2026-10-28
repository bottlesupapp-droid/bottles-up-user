import 'package:bottles_up_user/features/billing/widgets/tip_button.dart';
import 'package:bottles_up_user/features/social/widgets/profile_widgets.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/models/safety.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:bottles_up_user/site/rules/safety_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  final all = {'social': true, 'marketplace': true, 'creator_earnings': true, 'referrals': true, 'subscriptions': true, 'ranks': true, 'jobs': true};
  final asDj = [selectedProfileIdProvider.overrideWith((ref) => 'biz')];

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['rank_levels'] = (_) => ok(<Object>[]);
    site.rpcs['team_invitations_mine'] = (_) => ok(<Object>[]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  group('the Profile tab', () {
    testWidgets('leads a professional to everything that can earn, be won or be applied for', (tester) async {
      final router = await openSocial(tester, site, '/', features: all, mine: [myPersonal(), myBusiness()], overrides: asDj, home: const SocialEntryCard());
      await settleCalls(tester);
      for (final k in ['open-earnings', 'open-subscription', 'open-referrals', 'open-recognition', 'open-opportunities', 'open-applications', 'open-jobs']) {
        expect(find.byKey(Key(k)), findsOneWidget, reason: k);
      }
      const routes = {
        'open-earnings': '/me/earnings',
        'open-subscription': '/me/subscription',
        'open-referrals': '/me/referrals',
        'open-recognition': '/me/recognition',
        'open-opportunities': '/jobs',
        'open-applications': '/me/applications',
        'open-jobs': '/me/jobs',
      };
      for (final e in routes.entries) {
        await tap(tester, e.key);
        await tester.pumpAndSettle();
        expect(path(router), e.value, reason: e.key);
        router.pop();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('a person sees referrals, ranks and applications, but not what only a business has', (tester) async {
      await openSocial(tester, site, '/', features: all, home: const SocialEntryCard());
      await settleCalls(tester);
      for (final k in ['open-referrals', 'open-recognition', 'open-opportunities', 'open-applications']) {
        expect(find.byKey(Key(k)), findsOneWidget, reason: k);
      }
      for (final k in ['open-earnings', 'open-subscription', 'open-jobs']) {
        expect(find.byKey(Key(k)), findsNothing, reason: k);
      }
    });

    testWidgets('an event group has earnings and jobs but no subscription (that is for a professional)', (tester) async {
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), profileRow(id: 'grp', kind: 'business', handle: 'eonics', name: 'EONICS', category: 'event_group', mine: true)]);
      await openSocial(tester, site, '/', features: all, overrides: [selectedProfileIdProvider.overrideWith((ref) => 'grp')], home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-earnings')), findsOneWidget);
      expect(find.byKey(const Key('open-jobs')), findsOneWidget);
      expect(find.byKey(const Key('open-subscription')), findsNothing);
    });

    testWidgets('shows none of these while every switch is off, and only the ones that are on', (tester) async {
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, mine: [myPersonal(), myBusiness()], overrides: asDj, home: const SocialEntryCard());
      await settleCalls(tester);
      for (final k in ['open-earnings', 'open-subscription', 'open-referrals', 'open-recognition', 'open-opportunities', 'open-applications', 'open-jobs']) {
        expect(find.byKey(Key(k)), findsNothing, reason: k);
      }
      await tester.pumpWidget(const SizedBox());
      site.rpcs.remove('site_features');
      await openSocial(tester, site, '/', features: {'social': true, 'creator_earnings': true}, mine: [myPersonal(), myBusiness()], overrides: asDj, home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-earnings')), findsOneWidget);
      expect(find.byKey(const Key('open-referrals')), findsNothing);
      expect(find.byKey(const Key('open-subscription')), findsNothing);
    });
  });

  group('Explore', () {
    testWidgets('leads to Opportunities when jobs are on, and not otherwise', (tester) async {
      site.rpcs['explore_hot'] = (_) => ok({'venues': <Object>[], 'events': <Object>[]});
      site.rpcs['jobs_list'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/explore', features: all);
      await settleCalls(tester);
      await tap(tester, 'open-opportunities');
      await tester.pumpAndSettle();
      expect(path(router), '/jobs');
      await tester.pumpWidget(const SizedBox());
      site.rpcs.remove('site_features');
      await openSocial(tester, site, '/explore', features: {'social': true});
      await settleCalls(tester);
      expect(find.byKey(const Key('open-opportunities')), findsNothing);
    });
  });

  group('Send a tip', () {
    SocialProfile profile({String kind = 'business', bool mine = false, bool blocked = false, String status = 'active'}) =>
        parseSocialProfile(profileRow(id: 'p-dj', kind: kind, handle: 'djdee', name: 'DJ Dee', category: kind == 'business' ? 'dj' : null, mine: mine, blocked: blocked, status: status))!;

    testWidgets('is offered on a business profile that is not yours, and leads to the tip page', (tester) async {
      final router = await openSocial(tester, site, '/', features: all, home: TipSection(profile: profile()));
      await settleCalls(tester);
      await tap(tester, 'send-tip');
      await tester.pumpAndSettle();
      expect(path(router), '/tip/p-dj');
    });

    testWidgets('is not offered for a person, your own business, a blocked or suspended one, or while tips are off', (tester) async {
      for (final p in [profile(kind: 'personal'), profile(mine: true), profile(blocked: true), profile(status: 'suspended')]) {
        await openSocial(tester, site, '/', features: all, home: TipSection(profile: p));
        await settleCalls(tester);
        expect(find.byKey(const Key('send-tip')), findsNothing);
        await tester.pumpWidget(const SizedBox());
      }
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, home: TipSection(profile: profile()));
      await settleCalls(tester);
      expect(find.byKey(const Key('send-tip')), findsNothing);
    });
  });

  group('a profile\'s rank', () {
    test('is read only for a verified profile', () {
      expect(parseSocialProfile(profileRow(verified: true, extra: {'rank': 'elite'}))!.rank, 'elite');
      expect(parseSocialProfile(profileRow(verified: true, extra: {'rank': ' '}))!.rank, isNull);
      expect(parseSocialProfile(profileRow(verified: true))!.rank, isNull);
      expect(parseSocialProfile(profileRow(extra: {'rank': 'elite'}))!.rank, isNull, reason: 'a rank without the tick is not shown');
    });

    testWidgets('colours the tick beside a name in a list', (tester) async {
      await openSocial(tester, site, '/', features: {'social': true, 'ranks': true}, home: ProfileTile(profile: parseSocialProfile(profileRow(handle: 'ann', name: 'Ann Lee', verified: true, extra: {'rank': 'elite'}))!));
      await settleCalls(tester);
      expect(tester.widget<Icon>(find.byKey(const Key('rank-elite'))).color, const Color(0xFF2E9E5B));
    });

    testWidgets('is a plain Verified tick when the website says only that', (tester) async {
      await openSocial(tester, site, '/', features: {'social': true}, home: ProfileTile(profile: parseSocialProfile(profileRow(handle: 'ann', name: 'Ann Lee', verified: true))!));
      await settleCalls(tester);
      expect(tester.widget<Icon>(find.byKey(const Key('rank-verified'))).color, const Color(0xFF1D9BF0));
    });

    testWidgets('is not shown for a profile that is not verified', (tester) async {
      await openSocial(tester, site, '/', features: {'social': true}, home: ProfileTile(profile: parseSocialProfile(profileRow(handle: 'ann', name: 'Ann Lee'))!));
      await settleCalls(tester);
      expect(find.byKey(const Key('verified-tick')), findsNothing);
    });
  });

  test('a job can be reported, and has a name in the sentence', () {
    expect(ReportKind.job.wire, 'job');
    expect(reportKindLabel(ReportKind.job), 'job');
  });
}
