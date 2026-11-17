import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.enterText(find.byKey(Key(key)), text);
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  /// A person with no profile yet, who opens the people search and is sent to set one up.
  Future<void> openSetup(WidgetTester tester) async {
    var saved = false;
    site.rpcs['profile_my_profiles'] = (_) => ok(saved ? [myPersonal(handle: 'dana.lee', name: 'Dana Lee')] : <Object>[]);
    site.rpcs['save_my_profile'] = (_) => ok({'id': 'me'});
    site.rpcs['profile_save_personal'] = (_) {
      saved = true;
      return ok(myPersonal(handle: 'dana.lee'));
    };
    site.rpcs['handle_available'] = (_) => ok(true);
    await openSocial(tester, site, '/people', mine: const []);
    await tester.tap(find.byKey(const Key('open-setup')));
    await tester.pumpAndSettle();
  }

  group('setting up your profile', () {
    testWidgets('starts with the account\'s name and asks for the rest', (tester) async {
      await openSetup(tester);
      expect(find.text('Set up your profile'), findsWidgets);
      expect(tester.widget<TextField>(find.byKey(const Key('name-field'))).controller!.text, 'Dana Lee');
      expect(find.text('Create my profile'), findsOneWidget);
    });

    testWidgets('says what is missing before asking the website anything', (tester) async {
      await openSetup(tester);
      await tapKey(tester, 'save-profile');
      expect(find.text('Choose a username.'), findsWidgets);
      expect(find.byKey(const Key('setup-problem')), findsOneWidget);
      await type(tester, 'username-field', 'dana.lee');
      await tapKey(tester, 'save-profile');
      expect(find.text('Add your city.'), findsOneWidget);
      expect(site.forRpc('save_my_profile'), isEmpty);
      await type(tester, 'name-field', '  ');
      await tapKey(tester, 'save-profile');
      expect(find.text('Add your name.'), findsOneWidget);
    });

    testWidgets('a username is checked as it is typed', (tester) async {
      await openSetup(tester);
      site.rpcs['handle_available'] = (b) => ok(b['p_handle'] == 'free.name');
      await type(tester, 'username-field', 'ab');
      await tester.pump();
      expect(find.text('A username needs at least 3 characters.'), findsOneWidget);
      expect(site.forRpc('handle_available'), isEmpty);
      await type(tester, 'username-field', 'bad name');
      await tester.pump();
      expect(find.text('Use only letters, numbers, dots and underscores.'), findsOneWidget);
      await type(tester, 'username-field', 'taken.name');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('That username is not available.'), findsOneWidget);
      await type(tester, 'username-field', 'free.name');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);
      // One question for each word that was left alone for a moment.
      expect([for (final r in site.forRpc('handle_available')) r.body['p_handle']], ['taken.name', 'free.name']);
    });

    testWidgets('saves the details, then the profile, and goes back', (tester) async {
      await openSetup(tester);
      await type(tester, 'username-field', 'Dana.Lee');
      await type(tester, 'city-field', 'Toronto');
      await type(tester, 'bio-field', 'Nights out, done right.');
      await type(tester, 'interest-field', 'Afrobeats');
      await tapKey(tester, 'add-interest');
      await type(tester, 'interest-field', 'afrobeats');
      await tapKey(tester, 'add-interest');
      expect(find.byKey(const Key('interest-afrobeats')), findsOneWidget);
      await tapKey(tester, 'private-switch');
      expect(find.text('Only people you approve can follow you and see your posts.'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('links-tile')));
      await tester.tap(find.byKey(const Key('links-tile')));
      await tester.pumpAndSettle();
      await type(tester, 'link-field-instagram', 'dana.lee');
      await tapKey(tester, 'save-profile');

      expect(site.forRpc('save_my_profile').single.body, {
        'p_name': 'Dana Lee',
        'p_username': 'dana.lee',
        'p_city': 'Toronto',
        'p_bio': 'Nights out, done right.',
        'p_social': {'instagram': 'dana.lee'},
      });
      expect(site.forRpc('profile_save_personal').single.body, {'p_privacy': 'private', 'p_interests': ['afrobeats']});
      // Back on the page that sent them, which now has a profile to act as.
      expect(find.byKey(const Key('people-search-field')), findsOneWidget);
    });

    testWidgets('the website\'s refusal is shown and nothing is half-saved on the screen', (tester) async {
      await openSetup(tester);
      site.rpcs['save_my_profile'] = (_) => raised('username is not available');
      await type(tester, 'username-field', 'taken.name');
      await type(tester, 'city-field', 'Toronto');
      await tapKey(tester, 'save-profile');
      expect(find.text('Username is not available.'), findsWidgets);
      expect(site.forRpc('profile_save_personal'), isEmpty);
      expect(find.byKey(const Key('save-profile')), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('save-profile'))).onPressed, isNotNull);
    });

    testWidgets('interests are limited like the website\'s', (tester) async {
      await openSetup(tester);
      await type(tester, 'interest-field', 'x');
      await tapKey(tester, 'add-interest');
      expect(find.text('An interest must be 2 to 30 characters.'), findsOneWidget);
      for (final w in ['aa', 'bb', 'cc', 'dd', 'ee', 'ff', 'gg', 'hh', 'ii', 'jj', 'kk']) {
        await type(tester, 'interest-field', w);
        await tapKey(tester, 'add-interest');
      }
      expect(find.text('Choose up to 10 interests.'), findsOneWidget);
      expect(find.byKey(const Key('interest-kk')), findsNothing);
    });

    testWidgets('an existing profile is edited, not created', (tester) async {
      site.rpcs['save_my_profile'] = (_) => ok({'id': 'me'});
      site.rpcs['profile_save_personal'] = (_) => ok(myPersonal());
      site.rpcs['handle_available'] = (_) => ok(true);
      final router = await openSocial(tester, site, '/', home: const SocialEntryCard(), mine: [
        profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', city: 'Toronto', bio: 'hi', privacy: 'private', mine: true, interests: ['music'], links: {'instagram': 'dana'}),
      ]);
      router.push('/me/setup');
      await tester.pumpAndSettle();
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(tester.widget<TextField>(find.descendant(of: find.byKey(const Key('username-field')), matching: find.byType(TextField))).controller!.text, 'dana');
      expect(find.byKey(const Key('interest-music')), findsOneWidget);
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('private-switch'))).value, isTrue);
      await tapKey(tester, 'save-profile');
      expect(site.forRpc('save_my_profile').single.body['p_social'], {'instagram': 'dana'});
      expect(site.forRpc('profile_save_personal').single.body, {'p_privacy': 'private', 'p_interests': ['music']});
    });

    testWidgets('nothing opens while social is switched off', (tester) async {
      await openSocial(tester, site, '/me/setup', features: {'social': false});
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.byKey(const Key('save-profile')), findsNothing);
    });
  });

  group('business profiles', () {
    testWidgets('create one: a venue is not on offer here, and the new profile opens', (tester) async {
      site.rpcs['handle_available'] = (_) => ok(true);
      site.rpcs['profile_create_business'] = (_) => ok(myBusiness(id: 'new1', handle: 'djdana', name: 'DJ Dana'));
      site.rpcs['profile_get'] = (_) => ok(myBusiness(id: 'new1', handle: 'djdana', name: 'DJ Dana'));
      final router = await openSocial(tester, site, '/me/business/new');
      await tester.tap(find.byKey(const Key('category-field')));
      await tester.pumpAndSettle();
      expect(find.text('DJ'), findsWidgets);
      expect(find.text('Event group'), findsOneWidget);
      expect(find.text('Venue'), findsNothing);
      await tester.tap(find.text('Photographer').last);
      await tester.pumpAndSettle();
      await type(tester, 'business-name-field', 'DJ Dana');
      await type(tester, 'business-username-field', 'DJDana');
      await type(tester, 'business-city-field', 'Toronto');
      await tapKey(tester, 'save-business');
      expect(site.forRpc('profile_create_business').single.body, {'p_category': 'photographer', 'p_display_name': 'DJ Dana', 'p_handle': 'djdana', 'p_bio': null, 'p_city': 'Toronto'});
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/u/djdana');
    });

    testWidgets('a name and a valid username are needed, and the website\'s refusals are shown', (tester) async {
      site.rpcs['handle_available'] = (_) => ok(true);
      site.rpcs['profile_create_business'] = (_) => raised('You can have up to 5 business profiles.');
      await openSocial(tester, site, '/me/business/new');
      await tapKey(tester, 'save-business');
      expect(find.text('Add the name people will see.'), findsOneWidget);
      await type(tester, 'business-name-field', 'DJ Dana');
      await tapKey(tester, 'save-business');
      expect(find.text('Choose a username.'), findsWidgets);
      await type(tester, 'business-username-field', 'djdana');
      await tapKey(tester, 'save-business');
      expect(find.text('You can have up to 5 business profiles.'), findsOneWidget);
    });

    testWidgets('edit one you manage: the username stays, the rest changes', (tester) async {
      site.rpcs['profile_update_business'] = (_) => ok(myBusiness());
      await openSocial(tester, site, '/me/business/biz/edit', mine: [myPersonal(), myBusiness()]);
      expect(find.text('@djdana'), findsOneWidget);
      expect(find.byKey(const Key('business-username-field')), findsNothing);
      expect(find.byKey(const Key('category-field')), findsNothing);
      await type(tester, 'business-name-field', 'DJ Dana Official');
      await type(tester, 'business-bio-field', 'House and disco');
      await tester.ensureVisible(find.text('Links (optional)'));
      await tester.tap(find.text('Links (optional)'));
      await tester.pumpAndSettle();
      await type(tester, 'business-link-website', 'djdana.example');
      await tapKey(tester, 'save-business');
      expect(site.forRpc('profile_update_business').single.body, {
        'p_profile': 'biz',
        'p_display_name': 'DJ Dana Official',
        'p_bio': 'House and disco',
        'p_city': 'Toronto',
        'p_social': {'website': 'djdana.example'},
      });
    });

    testWidgets('someone else\'s profile cannot be edited', (tester) async {
      await openSocial(tester, site, '/me/business/other/edit', mine: [myPersonal(), myBusiness()]);
      expect(find.text('You cannot edit this profile'), findsOneWidget);
      expect(find.byKey(const Key('save-business')), findsNothing);
    });
  });

  group('the way in from the Profile tab', () {
    testWidgets('is not shown while social is off', (tester) async {
      await openSocial(tester, site, '/', features: {'social': false}, home: const SocialEntryCard());
      expect(find.byKey(const Key('social-entry')), findsNothing);
      expect(find.byKey(const Key('setup-prompt')), findsNothing);
      expect(site.forRpc('profile_my_profiles'), isEmpty);
    });

    testWidgets('asks someone with no profile to set one up', (tester) async {
      final router = await openSocial(tester, site, '/', mine: const [], home: const SocialEntryCard());
      await tester.tap(find.byKey(const Key('setup-prompt')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/me/setup');
    });

    testWidgets('shows the profile being used and where to go from there', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(myPersonal());
      final router = await openSocial(tester, site, '/', mine: [myPersonal()], home: const SocialEntryCard());
      expect(find.text('Dana Lee'), findsOneWidget);
      expect(find.text('@dana'), findsOneWidget);
      // Not private, one profile: no requests link and no switcher, but a way to make a business profile.
      expect(find.byKey(const Key('open-requests')), findsNothing);
      expect(find.byKey(const Key('open-switcher')), findsNothing);
      expect(find.byKey(const Key('open-new-business')), findsOneWidget);
      await tester.tap(find.byKey(const Key('find-people')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/people');
    });

    testWidgets('a private account has a requests link and with a business it can switch', (tester) async {
      await openSocial(tester, site, '/', mine: [myPersonal(private: true), myBusiness()], home: const SocialEntryCard());
      expect(find.byKey(const Key('open-requests')), findsOneWidget);
      expect(find.byKey(const Key('open-switcher')), findsOneWidget);
      expect(find.byKey(const Key('open-new-business')), findsNothing);
      await tester.tap(find.byKey(const Key('open-switcher')));
      await tester.pumpAndSettle();
      expect(find.text('Switch profile'), findsOneWidget);
      await tester.tap(find.byKey(const Key('profile-djdana')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('entry-name')), findsOneWidget);
      expect(find.text('DJ Dana'), findsOneWidget);
      expect(find.text('@djdana (business)'), findsOneWidget);
    });

    testWidgets('a failed load can be tried again', (tester) async {
      var fail = true;
      site.rpcs['profile_my_profiles'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok([myPersonal()]);
      await openSocial(tester, site, '/', home: const SocialEntryCard());
      expect(find.byKey(const Key('social-entry-error')), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('social-entry')), findsOneWidget);
    });

    testWidgets('forgetting the person drops their profiles and the profile they chose', (tester) async {
      await openSocial(tester, site, '/', mine: [myPersonal(), myBusiness()], home: Consumer(builder: (c, ref, _) => TextButton(onPressed: () => resetSocialState(ref), child: const Text('forget'))));
      final container = ProviderScope.containerOf(tester.element(find.text('forget')));
      container.read(selectedProfileIdProvider.notifier).state = 'biz';
      await container.read(myProfilesProvider.future);
      expect(container.read(actorProfileProvider)?.id, 'biz');
      await tester.tap(find.text('forget'));
      await tester.pump();
      expect(container.read(selectedProfileIdProvider), isNull);
      await container.read(myProfilesProvider.future);
      expect(container.read(actorProfileProvider)?.id, 'me');
      expect(site.forRpc('profile_my_profiles'), hasLength(2));
    });
  });
}
