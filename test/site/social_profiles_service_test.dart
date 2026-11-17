import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/services/features_service.dart';
import 'package:bottles_up_user/site/services/social_profiles_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late SocialProfilesService service;

  setUp(() {
    site = FakeWebsite();
    service = SocialProfilesService(site.client);
  });

  group('features', () {
    test('asks the website and reads the answer', () async {
      site.rpcs['site_features'] = (_) => ok({'social': true, 'marketplace': false});
      final f = await FeaturesService(site.client).features();
      expect(f.isOn(Feature.social), isTrue);
      expect(f.isOn(Feature.marketplace), isFalse);
      expect(site.forRpc('site_features'), hasLength(1));
    });

    test('a failed read switches nothing on', () async {
      site.failAllWith = 500;
      final f = await FeaturesService(site.client).features();
      expect([for (final k in Feature.all) f.isOn(k)].any((on) => on), isFalse);
    });

    test('a connection that is down switches nothing on', () async {
      site.networkDown = true;
      final f = await FeaturesService(site.client).features();
      expect(f.isOn(Feature.social), isFalse);
    });
  });

  group('username and details', () {
    test('asks if a username is free', () async {
      site.rpcs['handle_available'] = (b) => ok(b['p_handle'] == 'free.one');
      expect(await service.usernameAvailable('free.one'), isTrue);
      expect(await service.usernameAvailable('taken'), isFalse);
      expect(site.forRpc('handle_available').first.body, {'p_handle': 'free.one'});
    });

    test('an answer that is not a clear yes is no', () async {
      site.rpcs['handle_available'] = (_) => ok('true');
      expect(await service.usernameAvailable('x'), isFalse);
    });

    test('saves the details the way the website expects them', () async {
      site.rpcs['save_my_profile'] = (_) => ok({'id': 'u1'});
      await service.saveDetails(name: '  Dana Lee ', username: ' Dana.Lee ', city: ' Toronto ', bio: ' hi ', links: {'instagram': 'dana'});
      expect(site.forRpc('save_my_profile').single.body, {
        'p_name': 'Dana Lee',
        'p_username': 'dana.lee',
        'p_city': 'Toronto',
        'p_bio': 'hi',
        'p_social': {'instagram': 'dana'},
      });
    });

    test('the website\'s own sentence is shown, capitalised', () async {
      site.rpcs['save_my_profile'] = (_) => raised('username is not available');
      await expectLater(
        service.saveDetails(name: 'D', username: 'dana', city: 'T'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Username is not available.')),
      );
    });

    test('a fault in the database is never shown as it came', () async {
      site.rpcs['save_my_profile'] = (_) => (status: 500, body: {'code': 'XX000', 'message': 'relation "profiles" does not exist'});
      await expectLater(
        service.saveDetails(name: 'D', username: 'dana', city: 'T'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not save your details. Check your connection and try again.')),
      );
    });

    test('a missing permission is not shown as it came either', () async {
      site.rpcs['handle_available'] = (_) => (status: 403, body: {'code': '42501', 'message': 'permission denied for function handle_available'});
      await expectLater(
        service.usernameAvailable('x'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', isNot(contains('permission')))),
      );
    });
  });

  group('profiles', () {
    test('saves the personal profile', () async {
      site.rpcs['profile_save_personal'] = (_) => ok(profileRow(mine: true, privacy: 'private', interests: ['music']));
      final p = await service.savePersonal(isPrivate: true, interests: ['music']);
      expect(site.forRpc('profile_save_personal').single.body, {'p_privacy': 'private', 'p_interests': ['music']});
      expect(p.isPrivate, isTrue);
      expect(p.interests, ['music']);
      await service.savePersonal(isPrivate: false, interests: const []);
      expect(site.forRpc('profile_save_personal').last.body['p_privacy'], 'public');
    });

    test('an answer that is not a profile is an error, not a blank screen', () async {
      site.rpcs['profile_save_personal'] = (_) => ok({'oops': true});
      await expectLater(service.savePersonal(isPrivate: false, interests: const []), throwsA(isA<SiteException>()));
    });

    test('lists the person\'s profiles and drops unreadable ones', () async {
      site.rpcs['profile_my_profiles'] = (_) => ok([profileRow(id: 'a', mine: true), 'junk', profileRow(id: 'b', handle: 'djann', kind: 'business', mine: true)]);
      final list = await service.myProfiles();
      expect([for (final p in list) p.id], ['a', 'b']);
    });

    test('creates a business profile', () async {
      site.rpcs['profile_create_business'] = (_) => ok(profileRow(id: 'b', kind: 'business', handle: 'djann', category: 'dj', mine: true));
      final p = await service.createBusiness(category: 'dj', name: ' DJ Ann ', username: ' DJAnn ', bio: ' house ', city: ' Toronto ');
      expect(site.forRpc('profile_create_business').single.body, {'p_category': 'dj', 'p_display_name': 'DJ Ann', 'p_handle': 'djann', 'p_bio': 'house', 'p_city': 'Toronto'});
      expect(p.isBusiness, isTrue);
    });

    test('edits a business profile', () async {
      site.rpcs['profile_update_business'] = (_) => ok(profileRow(id: 'b', kind: 'business', handle: 'djann', mine: true));
      await service.updateBusiness(profileId: 'b', name: ' DJ Ann ', bio: 'x', city: 'T', links: {'website': 'https://x.example'});
      expect(site.forRpc('profile_update_business').single.body, {
        'p_profile': 'b',
        'p_display_name': 'DJ Ann',
        'p_bio': 'x',
        'p_city': 'T',
        'p_social': {'website': 'https://x.example'},
      });
    });

    test('opens a profile by username or id, as the acting profile', () async {
      site.rpcs['profile_get'] = (_) => ok(profileRow());
      await service.profile(actor: 'me', handle: 'dana');
      await service.profile(actor: 'me', id: 'p1');
      expect(site.forRpc('profile_get').first.body, {'p_actor': 'me', 'p_handle': 'dana', 'p_id': null});
      expect(site.forRpc('profile_get').last.body, {'p_actor': 'me', 'p_handle': null, 'p_id': 'p1'});
    });

    test('a profile that is not available shows the website\'s sentence', () async {
      site.rpcs['profile_get'] = (_) => raised('This profile isn\'t available.');
      await expectLater(
        service.profile(actor: 'me', handle: 'gone'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'This profile isn\'t available.')),
      );
    });

    test('searches', () async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'a', handle: 'ann1')]);
      final r = await service.search(actor: 'me', query: '  ann ', limit: 5);
      expect(site.forRpc('profile_search').single.body, {'p_actor': 'me', 'p_query': 'ann', 'p_limit': 5});
      expect(r.single.handle, 'ann1');
    });
  });

  group('following and blocking', () {
    test('follows and unfollows as the acting profile', () async {
      site.rpcs['follow_set'] = (b) => ok(profileRow(id: 't', follow: b['p_follow'] == true ? 'pending' : 'none'));
      final asked = await service.setFollow(actor: 'me', target: 't', follow: true);
      expect(asked.follow, FollowState.requested);
      final undone = await service.setFollow(actor: 'me', target: 't', follow: false);
      expect(undone.follow, FollowState.none);
      expect(site.forRpc('follow_set').first.body, {'p_actor': 'me', 'p_target': 't', 'p_follow': true});
    });

    test('a refusal such as "too quickly" is shown', () async {
      site.rpcs['follow_set'] = (_) => raised('You are following people too quickly. Try again later.');
      await expectLater(
        service.setFollow(actor: 'me', target: 't', follow: true),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'You are following people too quickly. Try again later.')),
      );
    });

    test('answers a request', () async {
      site.rpcs['follow_respond'] = (_) => ok({'followers': 1, 'requests': 0});
      await service.respond(actor: 'me', other: 'o', action: 'accept');
      expect(site.forRpc('follow_respond').single.body, {'p_actor': 'me', 'p_other': 'o', 'p_action': 'accept'});
    });

    test('lists requests, followers and following', () async {
      site.rpcs['follow_requests'] = (_) => ok([profileRow(id: 'r', handle: 'req1', extra: {'requested_at': '2099-01-01T00:00:00Z'})]);
      site.rpcs['follow_list'] = (_) => ok([profileRow(id: 'f', handle: 'fol1', extra: {'followed_at': '2099-01-02T00:00:00Z'})]);
      final reqs = await service.requests('me');
      expect(reqs.single.at, isNotNull);
      final before = DateTime.utc(2099, 1, 3);
      final people = await service.people(actor: 'me', profile: 'p', followers: true, before: before);
      expect(people.single.handle, 'fol1');
      await service.people(actor: 'me', profile: 'p', followers: false);
      expect(site.forRpc('follow_list').first.body, {'p_actor': 'me', 'p_profile': 'p', 'p_kind': 'followers', 'p_limit': 30, 'p_before': '2099-01-03T00:00:00.000Z'});
      expect(site.forRpc('follow_list').last.body['p_kind'], 'following');
      expect(site.forRpc('follow_list').last.body['p_before'], isNull);
    });

    test('a private profile\'s people are refused with the website\'s sentence', () async {
      site.rpcs['follow_list'] = (_) => raised('Follow this profile to see its people.');
      await expectLater(
        service.people(actor: 'me', profile: 'p', followers: true),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Follow this profile to see its people.')),
      );
    });

    test('blocks, unblocks and lists', () async {
      site.rpcs['block_set'] = (b) => ok({'blocked': b['p_blocked']});
      site.rpcs['block_list'] = (_) => ok([profileRow(id: 'x', handle: 'blk1', blocked: true)]);
      await service.setBlocked(actor: 'me', target: 'x', blocked: true);
      await service.setBlocked(actor: 'me', target: 'x', blocked: false);
      expect(site.forRpc('block_set').first.body, {'p_actor': 'me', 'p_target': 'x', 'p_blocked': true});
      expect(site.forRpc('block_set').last.body['p_blocked'], false);
      expect((await service.blocked('me')).single.blockedByMe, isTrue);
    });

    test('a dropped connection says to check the connection', () async {
      site.networkDown = true;
      await expectLater(
        service.setFollow(actor: 'me', target: 't', follow: true),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', actionFailedMessage)),
      );
    });
  });
}
