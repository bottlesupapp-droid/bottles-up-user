import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/rules/profile_rules.dart';
import 'package:bottles_up_user/site/services/features_service.dart';
import 'package:bottles_up_user/site/services/social_profiles_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's SQL (the profile migrations): a change there the app does not follow fails here. Skipped when the website is not checked out beside the app.
void main() {
  group('social profiles against the website', skip: websiteIsHere ? null : websiteMissing, () {
    test('every function the app calls exists with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = SocialProfilesService(site.client);
      final card = profileRow(mine: true);
      for (final name in ['profile_save_personal', 'profile_create_business', 'profile_update_business', 'profile_get', 'follow_set']) {
        site.rpcs[name] = (_) => ok(card);
      }
      for (final name in ['profile_my_profiles', 'profile_search', 'follow_requests', 'follow_list', 'block_list']) {
        site.rpcs[name] = (_) => ok([card]);
      }
      site.rpcs['handle_available'] = (_) => ok(true);
      site.rpcs['site_features'] = (_) => ok({'social': true});
      site.rpcs['follow_respond'] = (_) => ok({'followers': 0, 'requests': 0});
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      site.rpcs['save_my_profile'] = (_) => ok({'id': 'u'});

      await FeaturesService(site.client).features();
      await service.usernameAvailable('abc');
      await service.saveDetails(name: 'n', username: 'abc', city: 'c', bio: 'b', links: {'instagram': 'x'});
      await service.savePersonal(isPrivate: true, interests: ['music']);
      await service.myProfiles();
      await service.createBusiness(category: 'dj', name: 'n', username: 'abc', bio: 'b', city: 'c');
      await service.updateBusiness(profileId: 'p', name: 'n', bio: 'b', city: 'c', links: {'x': 'y'});
      await service.profile(actor: 'a', handle: 'abc');
      await service.search(actor: 'a', query: 'ab');
      await service.setFollow(actor: 'a', target: 't', follow: true);
      await service.respond(actor: 'a', other: 'o', action: 'accept');
      await service.requests('a');
      await service.people(actor: 'a', profile: 'p', followers: true, before: DateTime.utc(2099));
      await service.setBlocked(actor: 'a', target: 't', blocked: true);
      await service.blocked('a');

      expect(site.rpcRequests.map((r) => r.name).toSet(), hasLength(15));
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('the reserved usernames are the website\'s', () {
      final sql = migrationCode('social_profiles');
      expect(reservedHandles, sqlWordsAfter(sql, 'select p_handle in'));
    });

    test('the categories are the website\'s', () {
      final sql = migrationCode('social_profiles');
      expect({for (final c in profileCategories) c.key}, sqlWordsAfter(sql, 'category in'));
    });

    test('the username shape is the website\'s', () {
      final sql = migrationCode('social_profiles');
      expect(sql, contains(r"^[a-z0-9._]{3,30}$"));
      expect(usernameProblem('a' * 30), isNull);
      expect(usernameProblem('a' * 31), isNotNull);
      expect(usernameProblem('ab'), isNotNull);
    });

    test('the interest limits are the website\'s', () {
      final sql = migrationCode('social_profiles');
      expect(sql, contains('char_length(v_item) < 2 or char_length(v_item) > 30'));
      expect(sql, contains('cardinality(v_out) > 10'));
    });

    test('the links the app can send are the ones the website allows', () {
      final sql = migrationCode('accounts_onboarding');
      expect(sqlWordsAfter(sql, 'if v_key not in'), {'instagram', 'tiktok', 'x', 'facebook', 'youtube', 'spotify', 'website'});
    });

    test('every feature the app knows is seeded off, and no other', () {
      final sql = migrationCode('feature_flags');
      final seeded = {for (final m in RegExp(r"\('([a-z_]+)',\s*'(?:[^']|'')*'\)").allMatches(sql.substring(sql.indexOf('insert into public.site_feature_flags')))) m.group(1)!};
      expect(Feature.all.toSet(), seeded);
      expect(sql, contains('enabled boolean not null default false'));
    });
  });
}
