import 'package:bottles_up_user/features/recognition/widgets/awards_section.dart';
import 'package:bottles_up_user/features/recognition/widgets/rank_badge.dart';
import 'package:bottles_up_user/site/models/recognition.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';
import '../support/recognition_fixtures.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

String hex(int argb) => '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

List<Map<String, dynamic>> levelRows() => [for (final l in proposedRanks) levelRow(key: l.key, name: l.name, min: l.minFollowers, colour: hex(l.colour), plaque: l.plaque)];

void main() {
  late FakeWebsite site;
  final on = {'social': true, 'ranks': true};
  final today = DateTime.now();
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final later = iso(DateTime(today.year, today.month, today.day + 20));
  final earlier = iso(DateTime(today.year, today.month, today.day - 1));

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['rank_levels'] = (_) => ok(levelRows());
    site.rpcs['verification_status'] = (_) => ok(verificationRow());
    site.rpcs['rank_status'] = (_) => ok(rankStatusRow());
    site.rpcs['awards_of'] = (_) => ok(<Object>[]);
    site.rpcs['plaques_mine'] = (_) => ok(<Object>[]);
    site.rpcs['verification_request'] = (_) => ok(verificationRow(request: requestRow()));
    site.rpcs['rank_request'] = (_) => ok(rankStatusRow(canRequest: false, pending: {'id': 'r1', 'level': 'elite', 'created_at': '2026-11-02T10:00:00Z'}));
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> openIt(WidgetTester tester, {Map<String, bool>? features}) async {
    await openSocial(tester, site, '/me/recognition', features: features ?? on);
    await settleCalls(tester);
  }

  group('the page', () {
    testWidgets('says it is not open yet while ranks are off', (tester) async {
      await openIt(tester, features: {'social': true});
      expect(find.text('Verification and ranks are not open yet.'), findsOneWidget);
      expect(site.forRpc('verification_status'), isEmpty);
    });

    testWidgets('always says a rank is earned and never bought', (tester) async {
      await openIt(tester);
      expect(textOf(tester, 'recognition-note'), 'Ranks are earned, never bought. A subscription does not give you a tick.');
    });
  });

  group('verification', () {
    testWidgets('someone who is not verified is invited to ask, and the rank card waits for it', (tester) async {
      await openIt(tester);
      expect(find.byKey(const Key('ask-verify')), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Ask to be verified'), findsOneWidget);
      expect(find.byKey(const Key('rank-needs-verified')), findsOneWidget);
      expect(site.forRpc('rank_status'), isEmpty, reason: 'nothing is asked about ranks before they are verified');
      expect(site.forRpc('verification_status').first.body, {'p_profile': 'me'});
    });

    testWidgets('asking sends the note and says BottlesUp will look', (tester) async {
      await openIt(tester);
      await tap(tester, 'ask-verify');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('verify-intro')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('verify-note')), '  I am a radio host.  ');
      await tap(tester, 'verify-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('verification_request').single.body, {'p_profile': 'me', 'p_note': 'I am a radio host.'});
      expect(find.text('Your request was sent. BottlesUp will look at it.'), findsOneWidget);
    });

    testWidgets('a note can be left empty, and the person can change their mind', (tester) async {
      await openIt(tester);
      await tap(tester, 'ask-verify');
      await tester.pumpAndSettle();
      await tap(tester, 'verify-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('verification_request'), isEmpty);
      await tap(tester, 'ask-verify');
      await tester.pumpAndSettle();
      await tap(tester, 'verify-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('verification_request').single.body['p_note'], isNull);
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['verification_request'] = (_) => raised('Your request is already waiting for a decision.');
      await openIt(tester);
      await tap(tester, 'ask-verify');
      await tester.pumpAndSettle();
      await tap(tester, 'verify-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('Your request is already waiting for a decision.'), findsOneWidget);
    });

    testWidgets('a request that is waiting says so, shows the note, and offers no new one', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(request: requestRow()));
      await openIt(tester);
      expect(find.byKey(const Key('waiting-line')), findsOneWidget);
      expect(find.text('You wrote: I am a radio host.'), findsOneWidget);
      expect(find.byKey(const Key('ask-verify')), findsNothing);
    });

    testWidgets('a request turned down says why and when to ask again, and cannot be repeated before then', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(request: requestRow(state: 'rejected', reason: 'We could not confirm who you are.', retryOn: later)));
      await openIt(tester);
      expect(textOf(tester, 'turned-down-line'), 'BottlesUp could not verify this profile.');
      expect(textOf(tester, 'turned-down-reason'), 'We could not confirm who you are.');
      expect(textOf(tester, 'retry-line'), startsWith('You can ask again on '));
      expect(tester.widget<FilledButton>(find.byKey(const Key('ask-verify'))).onPressed, isNull);
      expect(find.widgetWithText(FilledButton, 'Ask again'), findsOneWidget);
    });

    testWidgets('after the wait the person can ask again', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(request: requestRow(state: 'rejected', reason: 'No.', retryOn: earlier)));
      await openIt(tester);
      expect(find.byKey(const Key('retry-line')), findsNothing);
      expect(tester.widget<FilledButton>(find.byKey(const Key('ask-verify'))).onPressed, isNotNull);
    });

    testWidgets('a tick taken back says so', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(request: requestRow(state: 'revoked', reason: 'Not genuine.', retryOn: later)));
      await openIt(tester);
      expect(textOf(tester, 'turned-down-line'), 'BottlesUp took the tick back.');
    });

    testWidgets('verified through a request, or through the business account', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(verified: true, via: 'review'));
      await openIt(tester);
      expect(textOf(tester, 'verified-line'), 'BottlesUp verified this profile.');
      expect(find.byKey(const Key('ask-verify')), findsNothing);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['verification_status'] = (_) => ok(verificationRow(verified: true, via: 'business', orgRun: true));
      await openIt(tester);
      expect(textOf(tester, 'verified-line'), 'Verified through your business account.');
    });

    testWidgets('a profile run by a business account is told verification goes through the account', (tester) async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(orgRun: true));
      await openIt(tester);
      expect(find.byKey(const Key('org-run-line')), findsOneWidget);
      expect(find.byKey(const Key('ask-verify')), findsNothing);
    });

    testWidgets('says why it cannot be read, and reads it again', (tester) async {
      var fail = true;
      site.rpcs['verification_status'] = (_) => fail ? raised('This profile is not available.') : ok(verificationRow());
      await openIt(tester);
      expect(find.text('This profile is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.widgetWithText(TextButton, 'Try again').first);
      await settleCalls(tester);
      expect(find.byKey(const Key('ask-verify')), findsOneWidget);
    });
  });

  group('rank', () {
    setUp(() => site.rpcs['verification_status'] = (_) => ok(verificationRow(verified: true, via: 'review')));

    testWidgets('shows the rank, the followers and how far the next level is', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(followers: 50000, canRequest: false));
      await openIt(tester);
      expect(textOf(tester, 'rank-name'), 'Verified');
      expect(textOf(tester, 'rank-followers'), '50,000 followers');
      expect(textOf(tester, 'rank-next'), 'Next: Elite at 100,000 followers');
      expect(tester.widget<LinearProgressIndicator>(find.byKey(const Key('rank-progress'))).value, 0.5);
      expect(find.byKey(const Key('rank-hint')), findsOneWidget);
      expect(find.byKey(const Key('ask-rank')), findsNothing);
    });

    testWidgets('a level within reach can be asked for, and BottlesUp is said to look at the followers', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(target: {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'}));
      await openIt(tester);
      expect(find.widgetWithText(FilledButton, 'Ask BottlesUp to look at Elite'), findsOneWidget);
      expect(find.text('BottlesUp checks that the followers are genuine before it awards a rank.'), findsOneWidget);
      await tap(tester, 'ask-rank');
      await settleCalls(tester);
      expect(site.forRpc('rank_request').single.body, {'p_profile': 'me'});
      expect(find.text('BottlesUp will look at your followers and answer here.'), findsOneWidget);
    });

    testWidgets('a level the website says cannot be asked for yet is not offered, even when it is named', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(canRequest: false, target: {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'}));
      await openIt(tester);
      expect(find.byKey(const Key('ask-rank')), findsNothing);
      expect(find.byKey(const Key('rank-hint')), findsOneWidget);
    });

    testWidgets('a double tap on asking for a rank sends one request', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(target: {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'}));
      await openIt(tester);
      await tester.ensureVisible(find.byKey(const Key('ask-rank')));
      await tester.tap(find.byKey(const Key('ask-rank')));
      await tester.tap(find.byKey(const Key('ask-rank')));
      await settleCalls(tester);
      expect(site.forRpc('rank_request').length, 1);
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(target: {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'}));
      site.rpcs['rank_request'] = (_) => raised('You have not reached the next level yet.');
      await openIt(tester);
      await tap(tester, 'ask-rank');
      await settleCalls(tester);
      expect(find.text('You have not reached the next level yet.'), findsOneWidget);
    });

    testWidgets('a review that is waiting says so by name', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(canRequest: false, pending: {'id': 'r1', 'level': 'elite', 'created_at': '2026-11-02T10:00:00Z'}));
      await openIt(tester);
      expect(textOf(tester, 'rank-waiting'), 'BottlesUp is looking at your Elite request.');
      expect(find.byKey(const Key('ask-rank')), findsNothing);
    });

    testWidgets('a rank turned down says why and when to ask again', (tester) async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow(canRequest: false, rejected: {'level': 'elite', 'reason': 'Some followers look bought.', 'retry_on': later}));
      await openIt(tester);
      expect(textOf(tester, 'rank-rejected'), 'BottlesUp looked and could not award it yet.');
      expect(textOf(tester, 'rank-rejected-reason'), 'Some followers look bought.');
      expect(textOf(tester, 'rank-retry'), startsWith('You can ask again on '));
      expect(find.byKey(const Key('ask-rank')), findsNothing);
    });

    testWidgets('the top rank has nothing above it', (tester) async {
      site.rpcs['rank_status'] = (_) => ok({'verified': true, 'followers': 100000000, 'rank': 'immortal', 'next': null, 'target': null, 'can_request': false, 'pending': null, 'rejected': null});
      await openIt(tester);
      expect(textOf(tester, 'rank-name'), 'BottlesUp Immortal');
      expect(find.byKey(const Key('rank-top')), findsOneWidget);
      expect(find.byKey(const Key('rank-progress')), findsNothing);
    });

    testWidgets('says why it cannot be read, and reads it again', (tester) async {
      var fail = true;
      site.rpcs['rank_status'] = (_) => fail ? raised('This profile is not available.') : ok(rankStatusRow());
      await openIt(tester);
      expect(find.text('This profile is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.widgetWithText(TextButton, 'Try again').first);
      await settleCalls(tester);
      expect(find.byKey(const Key('rank-name')), findsOneWidget);
    });
  });

  group('awards and plaques', () {
    setUp(() {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(verified: true, via: 'review'));
      site.rpcs['awards_of'] = (_) => ok([awardRow(level: 'icon', name: 'Icon', colour: '#7E57C2', plaque: true), awardRow(id: 'aw2')]);
    });

    Future<void> fill(WidgetTester tester, {String recipient = 'Ann Lee', String line1 = '1 King St W', String city = 'Toronto', String postal = 'M5V 1A1', String country = 'Canada'}) async {
      await tester.enterText(find.byKey(const Key('plaque-recipient')), recipient);
      await tester.enterText(find.byKey(const Key('plaque-line1')), line1);
      await tester.enterText(find.byKey(const Key('plaque-line2')), ' Unit 4 ');
      await tester.enterText(find.byKey(const Key('plaque-city')), city);
      await tester.enterText(find.byKey(const Key('plaque-region')), ' ON ');
      await tester.enterText(find.byKey(const Key('plaque-postal')), postal);
      await tester.enterText(find.byKey(const Key('plaque-country')), country);
      await tester.pump();
    }

    testWidgets('lists the ranks held, and offers a plaque only where the rank comes with one', (tester) async {
      await openIt(tester);
      expect(site.forRpc('awards_of').first.body, {'p_actor': 'me', 'p_profile': 'me'});
      expect(find.byKey(const Key('award-row-icon')), findsOneWidget);
      expect(find.byKey(const Key('award-row-elite')), findsOneWidget);
      expect(find.byKey(const Key('ask-plaque-icon')), findsOneWidget);
      expect(find.byKey(const Key('ask-plaque-elite')), findsNothing);
    });

    testWidgets('says there is nothing yet when there is no award', (tester) async {
      site.rpcs['awards_of'] = (_) => ok(<Object>[]);
      await openIt(tester);
      expect(find.byKey(const Key('awards-empty')), findsOneWidget);
    });

    testWidgets('asking for a plaque sends the address tidied, and says we keep it only for the parcel', (tester) async {
      site.rpcs['plaque_claim'] = (_) => ok(plaqueRow());
      await openIt(tester);
      await tap(tester, 'ask-plaque-icon');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('plaque-privacy')), findsOneWidget);
      expect(tester.widget<TextField>(find.byKey(const Key('plaque-recipient'))).controller!.text, 'Dana Lee', reason: 'the name on the profile is offered');
      await fill(tester);
      await tap(tester, 'plaque-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('plaque_claim').single.body, {
        'p_award': 'aw1', 'p_recipient': 'Ann Lee', 'p_line1': '1 King St W', 'p_line2': 'Unit 4', 'p_city': 'Toronto', 'p_region': 'ON', 'p_postal': 'M5V 1A1', 'p_country': 'Canada', 'p_phone': null,
      });
      expect(find.text('Your plaque was asked for. We will tell you when it is posted.'), findsOneWidget);
    });

    testWidgets('says what is wrong with an address before sending it', (tester) async {
      await openIt(tester);
      await tap(tester, 'ask-plaque-icon');
      await tester.pumpAndSettle();
      await fill(tester, line1: '1');
      await tap(tester, 'plaque-send');
      expect(textOf(tester, 'plaque-problem'), 'Write the street address (3 to 120 characters).');
      expect(site.forRpc('plaque_claim'), isEmpty);
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['plaque_claim'] = (_) => raised('A plaque has already been asked for.');
      await openIt(tester);
      await tap(tester, 'ask-plaque-icon');
      await tester.pumpAndSettle();
      await fill(tester);
      await tap(tester, 'plaque-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('A plaque has already been asked for.'), findsOneWidget);
    });

    testWidgets('a plaque asked for shows where it is going, and can be cancelled after a question', (tester) async {
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow()]);
      site.rpcs['plaque_cancel'] = (_) => ok(plaqueRow(state: 'cancelled', removed: true));
      await openIt(tester);
      expect(textOf(tester, 'plaque-line'), 'Plaque asked for. We will post it soon.');
      expect(find.textContaining('To: Ann Lee, 1 King St W, Unit 4, Toronto, ON M5V 1A1, Canada'), findsOneWidget);
      expect(find.byKey(const Key('ask-plaque-icon')), findsNothing, reason: 'one is already asked for');
      await tap(tester, 'cancel-plaque');
      await tester.pumpAndSettle();
      await tap(tester, 'plaque-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('plaque_cancel'), isEmpty);
      await tap(tester, 'cancel-plaque');
      await tester.pumpAndSettle();
      await tap(tester, 'plaque-cancel-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('plaque_cancel').single.body, {'p_plaque': 'pq1'});
      expect(find.text('Cancelled. The address is deleted.'), findsOneWidget);
    });

    testWidgets('a plaque on its way shows the carrier and tracking number and cannot be cancelled', (tester) async {
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow(state: 'shipped', carrier: 'Canada Post', tracking: 'AB123456789CA')]);
      await openIt(tester);
      expect(textOf(tester, 'plaque-line'), 'Your plaque is on its way.');
      expect(textOf(tester, 'plaque-tracking'), 'Canada Post: AB123456789CA');
      expect(find.byKey(const Key('cancel-plaque')), findsNothing);
    });

    testWidgets('a plaque that arrived says so, and says the address has been deleted', (tester) async {
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow(state: 'delivered', removed: true, carrier: 'Canada Post', tracking: 'AB1')]);
      await openIt(tester);
      expect(textOf(tester, 'plaque-line'), 'Your plaque was delivered.');
      expect(find.byKey(const Key('plaque-removed')), findsOneWidget);
      expect(find.textContaining('To:'), findsNothing);
    });

    testWidgets('a plaque that was cancelled can be asked for again', (tester) async {
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow(state: 'cancelled', removed: true)]);
      await openIt(tester);
      expect(find.byKey(const Key('ask-plaque-icon')), findsOneWidget);
      expect(find.byKey(const Key('plaque-line')), findsNothing);
    });

    testWidgets('says why the awards cannot be read, and reads them again', (tester) async {
      var fail = true;
      site.rpcs['awards_of'] = (_) => fail ? raised('This profile is not available.') : ok([awardRow()]);
      await openIt(tester);
      expect(find.text('This profile is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.widgetWithText(TextButton, 'Try again').first);
      await settleCalls(tester);
      expect(find.byKey(const Key('award-row-elite')), findsOneWidget);
    });
  });

  group('the badge', () {
    testWidgets('has the colour of the rank, and a tap says what it means and lists the ranks', (tester) async {
      await openSocial(tester, site, '/', features: on, home: const RankBadge(rank: 'elite', size: 24));
      await settleCalls(tester);
      final icon = tester.widget<Icon>(find.byKey(const Key('rank-elite')));
      expect(icon.color, const Color(0xFF2E9E5B));
      await tap(tester, 'verified-tick');
      await tester.pumpAndSettle();
      expect(textOf(tester, 'rank-sheet-name'), 'Elite');
      expect(textOf(tester, 'rank-sheet-text'), 'Verified, and 100K genuine followers. BottlesUp looks at the followers before it awards this rank. Ranks are earned, never bought.');
      expect(find.text('Verified: identity checked'), findsOneWidget);
      expect(find.text('BottlesUp Immortal: 100,000,000 followers'), findsOneWidget);
    });

    testWidgets('uses the colours the website sends, and the plan\'s while it has not answered', (tester) async {
      site.rpcs['rank_levels'] = (_) => ok([levelRow(key: 'elite', name: 'Rising', min: 5, colour: '#112233')]);
      await openSocial(tester, site, '/', features: on, home: const RankBadge(rank: 'elite'));
      await settleCalls(tester);
      expect(tester.widget<Icon>(find.byKey(const Key('rank-elite'))).color, const Color(0xFF112233));
      await tester.pumpWidget(const SizedBox());
      site.rpcs['rank_levels'] = (_) => raised('Verification and ranks are not open yet.');
      await openSocial(tester, site, '/', features: on, home: const RankBadge(rank: 'icon'));
      await settleCalls(tester);
      expect(tester.widget<Icon>(find.byKey(const Key('rank-icon'))).color, const Color(0xFF7E57C2));
    });

    testWidgets('shows nothing without a rank', (tester) async {
      await openSocial(tester, site, '/', features: on, home: const RankBadge());
      await settleCalls(tester);
      expect(find.byKey(const Key('verified-tick')), findsNothing);
    });
  });

  group('awards on a profile', () {
    SocialProfile profile({bool verified = true, bool blocked = false}) => parseSocialProfile(profileRow(id: 'p-ann', handle: 'ann', name: 'Ann Lee', verified: verified, blocked: blocked))!;
    SocialProfile actor() => parseSocialProfile(profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true))!;

    testWidgets('shows one chip for each rank, the highest first', (tester) async {
      site.rpcs['awards_of'] = (_) => ok([awardRow(level: 'icon', name: 'Icon', colour: '#7E57C2'), awardRow(id: 'aw2')]);
      await openSocial(tester, site, '/', features: on, home: AwardsSection(actor: actor(), profile: profile()));
      await settleCalls(tester);
      expect(find.byKey(const Key('awards-section')), findsOneWidget);
      expect(tester.getTopLeft(find.byKey(const Key('award-icon'))).dx, lessThan(tester.getTopLeft(find.byKey(const Key('award-elite'))).dx));
      expect(site.forRpc('awards_of').single.body, {'p_actor': 'me', 'p_profile': 'p-ann'});
    });

    testWidgets('shows nothing without awards, for a profile that is not verified, a blocked one, or while ranks are off', (tester) async {
      await openSocial(tester, site, '/', features: on, home: AwardsSection(actor: actor(), profile: profile()));
      await settleCalls(tester);
      expect(find.byKey(const Key('awards-section')), findsNothing);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['awards_of'] = (_) => ok([awardRow()]);
      for (final p in [profile(verified: false), profile(blocked: true)]) {
        await openSocial(tester, site, '/', features: on, home: AwardsSection(actor: actor(), profile: p));
        await settleCalls(tester);
        expect(find.byKey(const Key('awards-section')), findsNothing);
        await tester.pumpWidget(const SizedBox());
      }
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, home: AwardsSection(actor: actor(), profile: profile()));
      await settleCalls(tester);
      expect(find.byKey(const Key('awards-section')), findsNothing);
    });
  });
}
