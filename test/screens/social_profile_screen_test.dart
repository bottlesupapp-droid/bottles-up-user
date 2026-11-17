import 'package:bottles_up_user/features/social/screens/social_profile_screen.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Finder text(String s) => find.text(s);
  Finder onButton(String s) => find.descendant(of: find.byKey(const Key('follow-button')), matching: find.text(s));

  testWidgets('your own profile shows your details and a way to edit it', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', bio: 'Nights out, done right.', city: 'Toronto', mine: true, followers: 1200, following: 15));
    await openSocial(tester, site, '/u/dana');
    expect(find.byKey(const Key('profile-name')), findsOneWidget);
    expect(text('Dana Lee'), findsOneWidget);
    expect(text('@dana'), findsOneWidget);
    expect(text('Nights out, done right.'), findsOneWidget);
    expect(text('Toronto'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('count-followers-value'))).data, '1.2K');
    expect(tester.widget<Text>(find.byKey(const Key('count-following-value'))).data, '15');
    expect(find.byKey(const Key('edit-profile')), findsOneWidget);
    expect(find.byKey(const Key('follow-button')), findsNothing);
    expect(find.byKey(const Key('profile-menu')), findsNothing);
    expect(site.forRpc('profile_get').single.body, {'p_actor': 'me', 'p_handle': 'dana', 'p_id': null});
  });

  testWidgets('following someone shows what the website answered', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park'));
    site.rpcs['follow_set'] = (b) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park', follow: b['p_follow'] == true ? 'active' : 'none', followers: b['p_follow'] == true ? 1 : 0));
    await openSocial(tester, site, '/u/sam');
    expect(onButton('Follow'), findsOneWidget);
    await tester.tap(find.byKey(const Key('follow-button')));
    await tester.pumpAndSettle();
    expect(site.forRpc('follow_set').single.body, {'p_actor': 'me', 'p_target': 'p2', 'p_follow': true});
    expect(onButton('Following'), findsOneWidget);
    await tester.tap(find.byKey(const Key('follow-button')));
    await tester.pumpAndSettle();
    expect(site.forRpc('follow_set').last.body['p_follow'], false);
    expect(onButton('Follow'), findsOneWidget);
  });

  testWidgets('a private profile you do not follow shows its header and a notice, and following it makes a request', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park', privacy: 'private', canSee: false, followers: 40));
    site.rpcs['follow_set'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park', privacy: 'private', canSee: false, follow: 'pending', followers: 40));
    await openSocial(tester, site, '/u/sam');
    expect(find.byKey(const Key('private-notice')), findsOneWidget);
    expect(text('This account is private'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('count-followers-value'))).data, '40');
    // The counts are shown but the people are not opened.
    expect(tester.widget<InkWell>(find.byKey(const Key('count-followers'))).onTap, isNull);
    await tester.tap(find.byKey(const Key('follow-button')));
    await tester.pumpAndSettle();
    expect(onButton('Requested'), findsOneWidget);
  });

  testWidgets('taking back a request', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', privacy: 'private', canSee: false, follow: 'pending'));
    site.rpcs['follow_set'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', privacy: 'private', canSee: false, follow: 'none'));
    await openSocial(tester, site, '/u/sam');
    expect(onButton('Requested'), findsOneWidget);
    await tester.tap(find.byKey(const Key('follow-button')));
    await tester.pumpAndSettle();
    expect(site.forRpc('follow_set').single.body['p_follow'], false);
    expect(onButton('Follow'), findsOneWidget);
  });

  testWidgets('someone who follows you is offered Follow back, and a follower can open the people', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', followsMe: true, followers: 5));
    await openSocial(tester, site, '/u/sam');
    expect(onButton('Follow back'), findsOneWidget);
    expect(find.byKey(const Key('follows-you')), findsOneWidget);
    expect(tester.widget<InkWell>(find.byKey(const Key('count-followers'))).onTap, isNotNull);
  });

  testWidgets('a refusal when following is shown, and the button stays', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam'));
    site.rpcs['follow_set'] = (_) => raised('You are following people too quickly. Try again later.');
    await openSocial(tester, site, '/u/sam');
    await tester.tap(find.byKey(const Key('follow-button')));
    await tester.pumpAndSettle();
    expect(text('You are following people too quickly. Try again later.'), findsOneWidget);
    expect(onButton('Follow'), findsOneWidget);
  });

  testWidgets('blocking asks first, then blocks and leaves the page', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park'));
    site.rpcs['block_set'] = (b) => ok({'blocked': b['p_blocked']});
    await openSocial(tester, site, '/u/sam');
    await tester.tap(find.byKey(const Key('profile-menu')));
    await tester.pumpAndSettle();
    await tester.tap(text('Block'));
    await tester.pumpAndSettle();
    expect(text('Block @sam?'), findsOneWidget);
    expect(site.forRpc('block_set'), isEmpty);
    await tester.tap(find.byKey(const Key('confirm-block')));
    await tester.pumpAndSettle();
    expect(site.forRpc('block_set').single.body, {'p_actor': 'me', 'p_target': 'p2', 'p_blocked': true});
  });

  testWidgets('after blocking, you are taken back to where you came from', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park'));
    site.rpcs['block_set'] = (b) => ok({'blocked': true});
    final router = await openSocial(tester, site, '/people', mine: [myPersonal()]);
    router.push('/u/sam');
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/u/sam');
    await tester.tap(find.byKey(const Key('profile-menu')));
    await tester.pumpAndSettle();
    await tester.tap(text('Block'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-block')));
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/people');
  });

  testWidgets('a suspended business cannot be acted as, even if it was the one chosen', (tester) async {
    site.rpcs['profile_get'] = (b) => ok(profileRow(id: 'p2', handle: 'sam'));
    await openSocial(tester, site, '/u/sam', mine: [myPersonal(), {...myBusiness(), 'status': 'suspended'}]);
    final element = tester.element(find.byType(SocialProfileScreen));
    ProviderScope.containerOf(element).read(selectedProfileIdProvider.notifier).state = 'biz';
    await tester.pumpAndSettle();
    expect(site.forRpc('profile_get').last.body['p_actor'], 'me');
  });

  testWidgets('cancelling the block question blocks nobody', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam'));
    site.rpcs['block_set'] = (b) => ok({'blocked': true});
    await openSocial(tester, site, '/u/sam');
    await tester.tap(find.byKey(const Key('profile-menu')));
    await tester.pumpAndSettle();
    await tester.tap(text('Block'));
    await tester.pumpAndSettle();
    await tester.tap(text('Cancel'));
    await tester.pumpAndSettle();
    expect(site.forRpc('block_set'), isEmpty);
  });

  testWidgets('a profile you blocked offers Unblock instead of Follow', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p2', handle: 'sam', blocked: true));
    site.rpcs['block_set'] = (b) => ok({'blocked': b['p_blocked']});
    await openSocial(tester, site, '/u/sam');
    expect(find.byKey(const Key('follow-button')), findsNothing);
    await tester.tap(find.byKey(const Key('unblock')));
    await tester.pumpAndSettle();
    expect(site.forRpc('block_set').single.body, {'p_actor': 'me', 'p_target': 'p2', 'p_blocked': false});
  });

  testWidgets('a business shows what it is, its tick and its links', (tester) async {
    final opened = <Uri>[];
    site.rpcs['profile_get'] = (_) => ok(profileRow(
          id: 'b1',
          kind: 'business',
          handle: 'clubaclub',
          name: 'Club A',
          category: 'venue',
          city: 'Toronto',
          verified: true,
          links: {'instagram': '@clubaclub', 'website': 'clubA.example', 'spotify': 'not a link'},
        ));
    await openSocial(tester, site, '/u/clubaclub', opened: opened);
    expect(text('Venue · Toronto'), findsOneWidget);
    expect(find.byKey(const Key('verified-tick')), findsWidgets);
    await tester.tap(find.byKey(const Key('link-instagram')));
    await tester.pump();
    expect(opened.single.toString(), 'https://instagram.com/clubaclub');
    await tester.tap(find.byKey(const Key('link-website')));
    await tester.pump();
    expect(opened.last.toString(), 'https://cluba.example');
    // A link that cannot be opened safely is shown as text, not as something to tap.
    expect(find.byType(Chip), findsOneWidget);
    expect(text('Spotify: not a link'), findsOneWidget);
  });

  testWidgets('a profile that is not available says so kindly', (tester) async {
    site.rpcs['profile_get'] = (_) => raised('This profile isn\'t available.');
    await openSocial(tester, site, '/u/gone');
    expect(text('This profile isn\'t available'), findsOneWidget);
    expect(find.byKey(const Key('load-failed-retry')), findsNothing);
  });

  testWidgets('a failed load offers to try again', (tester) async {
    var fail = true;
    site.rpcs['profile_get'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok(profileRow(id: 'p2', handle: 'sam', name: 'Sam Park'));
    await openSocial(tester, site, '/u/sam');
    expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    expect(text('boom'), findsNothing);
    fail = false;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(text('Sam Park'), findsOneWidget);
  });

  testWidgets('nothing opens while social is switched off', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow());
    await openSocial(tester, site, '/u/sam', features: {'social': false});
    expect(text('Coming soon'), findsOneWidget);
    expect(site.forRpc('profile_get'), isEmpty);
    expect(site.forRpc('profile_my_profiles'), isEmpty);
  });

  testWidgets('someone who has not set up a profile is asked to', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow());
    await openSocial(tester, site, '/u/sam', mine: const []);
    expect(text('Set up your profile first'), findsOneWidget);
    expect(site.forRpc('profile_get'), isEmpty);
  });

  testWidgets('a suspended profile of your own is marked', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'biz', kind: 'business', handle: 'djdana', name: 'DJ Dana', status: 'suspended', mine: true));
    await openSocial(tester, site, '/u/djdana', mine: [myPersonal(), {...myBusiness(), 'status': 'suspended'}]);
    expect(find.byKey(const Key('suspended-banner')), findsOneWidget);
  });

  testWidgets('switching to a business reads the page again as that business', (tester) async {
    site.rpcs['profile_get'] = (b) => ok(profileRow(id: 'p2', handle: 'sam'));
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await openSocial(tester, site, '/u/sam', mine: [myPersonal(), myBusiness()], overrides: [selectedProfileIdProvider.overrideWith((ref) => null)]);
    expect(site.forRpc('profile_get').last.body['p_actor'], 'me');
    final element = tester.element(find.byType(SocialProfileScreen));
    ProviderScope.containerOf(element).read(selectedProfileIdProvider.notifier).state = 'biz';
    await tester.pumpAndSettle();
    expect(site.forRpc('profile_get').last.body['p_actor'], 'biz');
  });

  testWidgets('a business you manage is edited from its page', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'biz', kind: 'business', handle: 'djdana', name: 'DJ Dana', category: 'dj', mine: true));
    final router = await openSocial(tester, site, '/u/djdana', mine: [myPersonal(), myBusiness()]);
    // With two profiles the page can switch between them.
    expect(find.byKey(const Key('switch-profile')), findsOneWidget);
    await tester.tap(find.byKey(const Key('edit-profile')));
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/me/business/biz/edit');
  });
}
