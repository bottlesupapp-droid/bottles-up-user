import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  late Map<String, bool> prefs;

  setUp(() {
    site = FakeWebsite();
    prefs = {for (final k in ['follow', 'follow_request', 'follow_accepted', 'like', 'comment', 'reply', 'tag', 'review_reply']) k: true};
    site.rpcs['notification_prefs'] = (_) => ok(prefs);
    site.rpcs['notification_prefs_set'] = (b) {
      for (final k in (b['p_kinds'] as List)) {
        prefs[k as String] = b['p_enabled'] as bool;
      }
      return ok(prefs);
    };
  });

  const on = {'social': true, 'inbox': true, 'members_only': true};
  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;
  bool switchOn(WidgetTester tester, String key) => tester.widget<SwitchListTile>(find.byKey(Key(key))).value;

  group('notifications', () {
    testWidgets('every group starts on and says what it covers', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on);
      for (final g in ['followers', 'likes', 'comments', 'tags', 'review_replies']) {
        expect(switchOn(tester, 'notify-$g'), isTrue, reason: g);
      }
      expect(find.text('Notifications for @dana'), findsOneWidget);
      expect(site.forRpc('notification_prefs').single.body, {'p_actor': 'me'});
    });

    testWidgets('a group that is off shows off', (tester) async {
      prefs['like'] = false;
      await openSocial(tester, site, '/me/settings', features: on);
      expect(switchOn(tester, 'notify-likes'), isFalse);
      expect(switchOn(tester, 'notify-comments'), isTrue);
    });

    testWidgets('a group with only some of its kinds on shows off', (tester) async {
      prefs['reply'] = false;
      await openSocial(tester, site, '/me/settings', features: on);
      expect(switchOn(tester, 'notify-comments'), isFalse);
    });

    testWidgets('switching a group off sends all of its kinds, and shows it off', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on);
      await tester.ensureVisible(find.byKey(const Key('notify-comments')));
      await tester.tap(find.byKey(const Key('notify-comments')));
      await tester.pumpAndSettle();
      expect(site.forRpc('notification_prefs_set').single.body, {'p_actor': 'me', 'p_kinds': ['comment', 'reply'], 'p_enabled': false});
      expect(switchOn(tester, 'notify-comments'), isFalse);
      await tester.tap(find.byKey(const Key('notify-comments')));
      await tester.pumpAndSettle();
      expect(site.forRpc('notification_prefs_set').last.body['p_enabled'], true);
      expect(switchOn(tester, 'notify-comments'), isTrue);
    });

    testWidgets('followers are three kinds at once', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on);
      await tester.tap(find.byKey(const Key('notify-followers')));
      await tester.pumpAndSettle();
      expect(site.forRpc('notification_prefs_set').single.body['p_kinds'], ['follow', 'follow_request', 'follow_accepted']);
    });

    testWidgets('a refusal is shown and the switch stays as it was', (tester) async {
      site.rpcs['notification_prefs_set'] = (_) => raised('Choose what to change.');
      await openSocial(tester, site, '/me/settings', features: on);
      await tester.tap(find.byKey(const Key('notify-likes')));
      await tester.pumpAndSettle();
      expect(find.text('Choose what to change.'), findsOneWidget);
      expect(switchOn(tester, 'notify-likes'), isTrue);
    });

    testWidgets('settings that cannot be loaded can be tried again', (tester) async {
      var fail = true;
      site.rpcs['notification_prefs'] = (_) => fail ? raised('Not now.') : ok(prefs);
      await openSocial(tester, site, '/me/settings', features: on);
      expect(find.text('Not now.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await tester.pumpAndSettle();
      expect(switchOn(tester, 'notify-likes'), isTrue);
    });

    testWidgets('they are the acting profile\'s own: a business profile reads its own', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on, mine: [myPersonal(), myBusiness()], overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')]);
      expect(find.text('Notifications for @djdana'), findsOneWidget);
      expect(site.forRpc('notification_prefs').single.body, {'p_actor': 'biz'});
    });
  });

  group('privacy', () {
    testWidgets('the private account switch shows the account and saves it with the interests kept, and shows it saved', (tester) async {
      var isPrivate = false;
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(private: isPrivate)]);
      site.rpcs['profile_save_personal'] = (b) {
        isPrivate = b['p_privacy'] == 'private';
        return ok(myPersonal(private: isPrivate));
      };
      await openSocial(tester, site, '/me/settings', features: on);
      expect(switchOn(tester, 'private-account'), isFalse);
      await tester.tap(find.byKey(const Key('private-account')));
      await tester.pumpAndSettle();
      expect(site.forRpc('profile_save_personal').single.body, {'p_privacy': 'private', 'p_interests': ['music']});
      expect(switchOn(tester, 'private-account'), isTrue, reason: 'the profile is read again, so the switch shows what was saved');
      expect(find.byKey(const Key('goto-requests')), findsOneWidget);
    });

    testWidgets('a private account shows the follow requests; a public one does not', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on);
      expect(find.byKey(const Key('goto-requests')), findsNothing);
    });

    testWidgets('...and a private one does, which opens them', (tester) async {
      final router = await openSocial(tester, site, '/me/settings', features: on, mine: [myPersonal(private: true)]);
      expect(switchOn(tester, 'private-account'), isTrue);
      site.rpcs['follow_requests'] = (_) => ok(<Object>[]);
      await tester.tap(find.byKey(const Key('goto-requests')));
      await tester.pumpAndSettle();
      expect(path(router), '/people/requests');
    });

    testWidgets('a refusal to save is shown', (tester) async {
      site.rpcs['profile_save_personal'] = (_) => raised('Profiles are not open yet.');
      await openSocial(tester, site, '/me/settings', features: on);
      await tester.tap(find.byKey(const Key('private-account')));
      await tester.pumpAndSettle();
      expect(find.text('Profiles are not open yet.'), findsOneWidget);
    });

    testWidgets('a business profile is always public, and has no switch', (tester) async {
      await openSocial(tester, site, '/me/settings', features: on, mine: [myPersonal(), myBusiness()], overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')]);
      expect(find.byKey(const Key('private-account')), findsNothing);
      expect(find.byKey(const Key('business-public')), findsOneWidget);
    });

    testWidgets('Members Only shows only when it is switched on; the Messages note only with messages', (tester) async {
      await openSocial(tester, site, '/me/settings', features: const {'social': true});
      expect(find.byKey(const Key('goto-members')), findsNothing);
      expect(find.byKey(const Key('messages-note')), findsNothing);
    });

    testWidgets('the links lead to the blocked list, the rules, the profile and Members Only', (tester) async {
      site.rpcs['block_list'] = (_) => ok(<Object>[]);
      site.rpcs['members_list'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/me/settings', features: on);
      Future<void> go(String key, String expected) async {
        await tester.ensureVisible(find.byKey(Key(key)));
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
        expect(path(router), expected, reason: key);
        router.pop();
        await tester.pumpAndSettle();
      }

      await go('goto-blocked', '/people/blocked');
      await go('goto-rules', '/rules');
      await go('goto-edit-profile', '/me/setup');
      await go('goto-members', '/me/members');
    });

    testWidgets('the profile tab leads here', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: const SocialEntryCard());
      await tester.ensureVisible(find.byKey(const Key('open-settings')));
      await tester.tap(find.byKey(const Key('open-settings')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/settings');
    });
  });
}
