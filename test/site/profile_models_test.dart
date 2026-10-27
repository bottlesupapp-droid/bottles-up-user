import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/rules/profile_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('SiteFeatures', () {
    test('only a real true switches a feature on', () {
      final f = SiteFeatures.parse({'social': true, 'stories': false, 'reels': 'true', 'inbox': 1, 'jobs': null});
      expect(f.isOn(Feature.social), isTrue);
      expect(f.isOn(Feature.stories), isFalse);
      expect(f.isOn(Feature.reels), isFalse);
      expect(f.isOn(Feature.inbox), isFalse);
      expect(f.isOn(Feature.jobs), isFalse);
    });

    test('anything unreadable leaves everything off', () {
      for (final bad in [null, 'x', 3, <Object?>[], const <String, Object?>{}]) {
        final f = SiteFeatures.parse(bad);
        expect([for (final k in Feature.all) f.isOn(k)].any((on) => on), isFalse, reason: '$bad');
      }
    });

    test('a feature the website does not know is off', () => expect(const SiteFeatures.allOff().isOn('anything'), isFalse));
  });

  group('parseSocialProfile', () {
    test('reads a full row', () {
      final p = parseSocialProfile(profileRow(
        id: 'p9',
        kind: 'business',
        handle: 'djann',
        name: 'DJ Ann',
        category: 'dj',
        bio: 'House and disco',
        city: 'Toronto',
        avatar: 'https://img.example/a.png',
        cover: 'https://img.example/c.png',
        verified: true,
        followers: 1200,
        following: 4,
        mine: true,
        follow: 'pending',
        followsMe: true,
        links: {'instagram': 'djann', 'x': '  '},
        extra: {'requested_at': '2099-10-20T12:00:00Z'},
      ))!;
      expect(p.id, 'p9');
      expect(p.isBusiness, isTrue);
      expect(p.handle, 'djann');
      expect(p.displayName, 'DJ Ann');
      expect(p.category, 'dj');
      expect(p.verified, isTrue);
      expect(p.followers, 1200);
      expect(p.follow, FollowState.requested);
      expect(p.followsMe, isTrue);
      expect(p.isMine, isTrue);
      expect(p.links, {'instagram': 'djann'});
      expect(p.at, DateTime.utc(2099, 10, 20, 12).toLocal());
    });

    test('follow states', () {
      expect(parseSocialProfile(profileRow(follow: 'active'))!.follow, FollowState.following);
      expect(parseSocialProfile(profileRow(follow: 'pending'))!.follow, FollowState.requested);
      expect(parseSocialProfile(profileRow(follow: 'none'))!.follow, FollowState.none);
      expect(parseSocialProfile(profileRow(follow: 'weird'))!.follow, FollowState.none);
    });

    test('a private profile the viewer cannot open stays closed when the answer is unclear', () {
      final row = profileRow(privacy: 'private')..remove('can_see_content');
      final p = parseSocialProfile(row)!;
      expect(p.isPrivate, isTrue);
      expect(p.canSeeContent, isFalse);
      expect(parseSocialProfile({...profileRow(), 'can_see_content': 'yes'})!.canSeeContent, isFalse);
    });

    test('only a secure picture address is kept', () {
      expect(parseSocialProfile(profileRow(avatar: 'http://img.example/a.png'))!.avatarUrl, isNull);
      expect(parseSocialProfile(profileRow(avatar: 'javascript:alert(1)'))!.avatarUrl, isNull);
      expect(parseSocialProfile(profileRow(avatar: 'https://img.example/a.png'))!.avatarUrl, 'https://img.example/a.png');
    });

    test('a person with no name shows their username', () => expect(parseSocialProfile(profileRow(name: null))!.displayName, 'dana'));

    test('a row without an id, a username or a known kind is dropped', () {
      expect(parseSocialProfile(profileRow()..remove('id')), isNull);
      expect(parseSocialProfile(profileRow(handle: ' ')), isNull);
      expect(parseSocialProfile(profileRow(kind: 'robot')), isNull);
      expect(parseSocialProfile('nope'), isNull);
      expect(parseSocialProfile(null), isNull);
    });

    test('counts that are not numbers are zero', () {
      final p = parseSocialProfile({...profileRow(), 'followers': 'many', 'following': null})!;
      expect(p.followers, 0);
      expect(p.following, 0);
    });

    test('a list drops its bad rows and keeps the rest in order', () {
      final list = parseSocialProfiles([profileRow(id: 'a', handle: 'aa1'), 'junk', profileRow(kind: 'x'), profileRow(id: 'b', handle: 'bb2')]);
      expect([for (final p in list) p.id], ['a', 'b']);
      expect(parseSocialProfiles(null), isEmpty);
      expect(parseSocialProfiles({'a': 1}), isEmpty);
    });
  });

  group('usernameProblem', () {
    test('accepts what the website accepts', () {
      for (final ok in ['abc', 'a.b_c9', 'x' * 30, '  Dana.Lee ']) {
        expect(usernameProblem(ok), isNull, reason: ok);
      }
    });

    test('says what is wrong', () {
      expect(usernameProblem(''), 'Choose a username.');
      expect(usernameProblem('ab'), 'A username needs at least 3 characters.');
      expect(usernameProblem('x' * 31), 'A username can be 30 characters at most.');
      expect(usernameProblem('bad name'), 'Use only letters, numbers, dots and underscores.');
      expect(usernameProblem('a-b-c'), 'Use only letters, numbers, dots and underscores.');
      expect(usernameProblem('Admin'), 'That username is not available.');
      expect(usernameProblem('bottlesup'), 'That username is not available.');
    });
  });

  group('cleanInterests', () {
    test('tidies like the website', () {
      final r = cleanInterests(['Music ', ' music', 'Dance   floor', '']);
      expect(r.interests, ['music', 'dance floor']);
      expect(r.problem, isNull);
    });

    test('refuses the wrong length and more than ten', () {
      expect(cleanInterests(['x']).problem, 'An interest must be 2 to 30 characters.');
      expect(cleanInterests(['x' * 31]).problem, 'An interest must be 2 to 30 characters.');
      expect(cleanInterests([for (var i = 0; i < 11; i++) 'item${'abcdefghijk'[i]}']).problem, 'Choose up to 10 interests.');
      expect(cleanInterests([for (var i = 0; i < 10; i++) 'item${'abcdefghij'[i]}']).problem, isNull);
    });
  });

  group('formatCount', () {
    test('short numbers', () {
      expect(formatCount(0), '0');
      expect(formatCount(999), '999');
      expect(formatCount(1000), '1K');
      expect(formatCount(1234), '1.2K');
      expect(formatCount(15500), '15.5K');
      expect(formatCount(999949), '999.9K');
      expect(formatCount(999950), '1M');
      expect(formatCount(1000000), '1M');
      expect(formatCount(1500000), '1.5M');
      expect(formatCount(2000000000), '2B');
    });
  });

  group('categories', () {
    test('labels', () {
      expect(categoryLabel('dj'), 'DJ');
      expect(categoryLabel('event_group'), 'Event group');
      expect(categoryLabel('nope'), 'Profile');
      expect(categoryLabel(null), 'Profile');
    });

    test('a venue profile is made in BottlesUp Business, not here', () {
      expect([for (final c in startableCategories) c.key], isNot(contains('venue')));
      expect(startableCategories, isNotEmpty);
    });
  });
}
