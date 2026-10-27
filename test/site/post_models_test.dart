import 'dart:math';

import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('parseSocialPost', () {
    test('reads a full post', () {
      final p = parseSocialPost(postRow(
        id: 'p9',
        kind: 'reel',
        caption: 'On stage',
        audience: 'members',
        media: [mediaRow(id: 'm2', position: 1, path: 'a/2.jpg'), mediaRow(id: 'm1', position: 0, type: 'video', path: 'a/1.mp4', durationMs: 12000, width: 720, height: 1280)],
        tags: [
          {'kind': 'profile', 'id': 'p2', 'profile': profileRow(id: 'p2', handle: 'sam', name: 'Sam Park')},
          {'kind': 'event', 'id': 'e1', 'name': 'Friday Night'},
          {'kind': 'venue', 'id': 'v1', 'name': 'Club A'},
        ],
        likes: 12,
        commentCount: 3,
        liked: true,
        saved: true,
        mine: true,
        expiresAt: '2099-10-25T22:00:00Z',
        extra: {'seen': true},
      ))!;
      expect(p.id, 'p9');
      expect(p.kind, PostKind.reel);
      expect(p.audience, PostAudience.members);
      expect(p.isMembersOnly, isTrue);
      expect(p.author.handle, 'ann');
      expect([for (final m in p.media) m.id], ['m1', 'm2'], reason: 'sorted by position');
      expect(p.media.first.isVideo, isTrue);
      expect(p.media.first.durationMs, 12000);
      expect(p.media.first.aspect, closeTo(720 / 1280, 0.0001));
      expect([for (final t in p.tags) '${t.kind.name}:${t.name}'], ['profile:Sam Park', 'event:Friday Night', 'venue:Club A']);
      expect(p.tags.first.handle, 'sam');
      expect(p.likes, 12);
      expect(p.comments, 3);
      expect(p.liked && p.saved && p.isMine && p.seen, isTrue);
      expect(p.expiresAt, isNotNull);
    });

    test('a post without a photo, an author, a kind or a time is dropped', () {
      expect(parseSocialPost(postRow(media: const [])), isNull);
      expect(parseSocialPost(postRow()..remove('author')), isNull);
      expect(parseSocialPost(postRow(kind: 'video')), isNull);
      expect(parseSocialPost(postRow(audience: 'friends')), isNull);
      expect(parseSocialPost(postRow()..['created_at'] = 'yesterday'), isNull);
      expect(parseSocialPost(postRow()..remove('id')), isNull);
      expect(parseSocialPost('nope'), isNull);
    });

    test('a bad media item or tag is dropped and the rest kept', () {
      final p = parseSocialPost(postRow(
        media: [mediaRow(id: 'ok'), {'id': 'bad', 'type': 'audio', 'path': 'x'}, {'id': 'nopath', 'type': 'image'}],
        tags: [
          {'kind': 'event', 'id': 'e1'},
          {'kind': 'mood', 'id': 'x', 'name': 'happy'},
          {'kind': 'event', 'id': 'e2', 'name': 'Late'},
        ],
      ))!;
      expect(p.media, hasLength(1));
      expect([for (final t in p.tags) t.id], ['e2']);
    });

    test('comments default to on, a count that is not a number is zero', () {
      final p = parseSocialPost({...postRow(), 'comments_enabled': null, 'likes': 'many', 'comments': null})!;
      expect(p.commentsEnabled, isTrue);
      expect(p.likes, 0);
      expect(p.comments, 0);
      expect(parseSocialPost({...postRow(), 'comments_enabled': false})!.commentsEnabled, isFalse);
    });

    test('an aspect needs both sides', () {
      expect(parsePostMedia(mediaRow(width: null))!.aspect, isNull);
      expect(parsePostMedia(mediaRow(width: 0, height: 10))!.aspect, isNull);
    });

    test('lists drop what cannot be read', () {
      expect([for (final p in parseSocialPosts([postRow(id: 'a'), 'x', postRow(id: 'b', media: const []), postRow(id: 'c')])) p.id], ['a', 'c']);
      expect(parseSocialPosts(null), isEmpty);
    });
  });

  group('comments, rail and grid', () {
    test('a comment', () {
      final c = parsePostComment(commentRow(replyTo: 'c0', replies: 2, mine: true, canDelete: true))!;
      expect(c.body, 'Great night!');
      expect(c.replyTo, 'c0');
      expect(c.replies, 2);
      expect(c.isMine && c.canDelete, isTrue);
      expect(c.author.handle, 'bob');
      expect(parsePostComment(commentRow()..remove('author')), isNull);
      expect(parsePostComment({...commentRow(), 'body': '  '}), isNull);
      expect([for (final c in parsePostComments([commentRow(id: 'a'), 1, commentRow(id: 'b')])) c.id], ['a', 'b']);
    });

    test('the row of stories', () {
      final r = parseStoryRailItem(railRow(unseen: false, membersOnly: true, count: 3, mine: true))!;
      expect(r.unseen, isFalse);
      expect(r.membersOnly, isTrue);
      expect(r.count, 3);
      expect(r.isMine, isTrue);
      expect(parseStoryRailItem(railRow()..['latest_at'] = 'x'), isNull);
      expect(parseStoryRail([railRow(), 'x']), hasLength(1));
    });

    test('a profile\'s posts with their total', () {
      final g = parseProfilePosts({'total': 5, 'items': [postRow(id: 'a'), 'x']});
      expect(g.total, 5);
      expect(g.items, hasLength(1));
      expect(parseProfilePosts(null).total, 0);
      expect(parseProfilePosts({'items': [postRow()]}).total, 1);
    });

    test('a Members Only row says whether the person still follows', () {
      expect(parseSocialProfile({...profileRow(handle: 'bob'), 'added_at': '2099-01-01T00:00:00Z', 'still_following': false})!.stillFollowing, isFalse);
      expect(parseSocialProfile(profileRow(handle: 'bob'))!.stillFollowing, isTrue);
      expect(parseSocialProfile({...profileRow(handle: 'bob'), 'added_at': '2099-01-01T00:00:00Z'})!.at, isNotNull);
    });
  });

  group('rules', () {
    test('captions and comments', () {
      expect(captionProblem(null), isNull);
      expect(captionProblem('a' * 2200), isNull);
      expect(captionProblem('a' * 2201), 'The caption can be 2200 characters at most.');
      expect(commentProblem('  '), 'Write something first.');
      expect(commentProblem('a' * 1001), 'A comment can be 1000 characters at most.');
      expect(commentProblem('a' * 1000), isNull);
    });

    test('how long ago', () {
      final now = DateTime(2026, 10, 27, 12);
      expect(timeAgo(now.subtract(const Duration(seconds: 20)), now), 'now');
      expect(timeAgo(now.subtract(const Duration(minutes: 5)), now), '5m');
      expect(timeAgo(now.subtract(const Duration(hours: 3)), now), '3h');
      expect(timeAgo(now.subtract(const Duration(days: 2)), now), '2d');
      expect(timeAgo(now.subtract(const Duration(days: 15)), now), '2w');
      expect(timeAgo(DateTime(2026, 6, 3), now), 'Jun 3');
      expect(timeAgo(DateTime(2025, 6, 3), now), 'Jun 3, 2025');
    });

    test('file types', () {
      expect(extensionForType('image/jpeg'), 'jpg');
      expect(extensionForType('IMAGE/PNG'), 'png');
      expect(extensionForType('video/quicktime'), 'mov');
      expect(extensionForType('image/gif'), isNull);
      expect(extensionForType('application/pdf'), isNull);
      expect(typeForName('x.JPG'), 'image/jpeg');
      expect(typeForName('x.mov'), 'video/quicktime');
      expect(typeForName('x.gif'), isNull);
      expect(typeForName('noextension'), isNull);
    });

    test('a path goes in the profile\'s folder, in lower case, in the shape the website checks', () {
      final p = mediaPathFor('ABCDEF12-0000-0000-0000-000000000001', 'jpg', random: Random(1));
      expect(p, matches(RegExp(r'^abcdef12-0000-0000-0000-000000000001/[0-9a-f]{32}\.jpg$')));
      expect(mediaPathFor('x', 'jpg'), isNot(mediaPathFor('x', 'jpg')), reason: 'random names');
    });

    test('chosen files', () {
      const img = PickedMedia(path: '/x.jpg', type: 'image/jpeg', bytes: 1000);
      expect(mediaProblem(img), isNull);
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'image/jpeg', bytes: maxImageBytes)), isNull);
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'image/jpeg', bytes: maxImageBytes + 1)), 'A photo can be 10 MB at most.');
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'image/gif', bytes: 10)), contains('not supported'));
      const vid = PickedMedia(path: '/x.mp4', type: 'video/mp4', bytes: 5000000, durationMs: 59000);
      expect(mediaProblem(vid), isNull);
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'video/mp4', bytes: 10, durationMs: 60000)), isNull);
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'video/mp4', bytes: 10, durationMs: 60001)), 'A video can be up to 60 seconds.');
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'video/mp4', bytes: 10)), 'We could not read how long that video is.');
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'video/mp4', bytes: maxVideoBytes + 1, durationMs: 1000)), 'A video can be 100 MB at most.');
      expect(mediaProblem(const PickedMedia(path: '/x', type: 'video/webm', bytes: 10, durationMs: 1000)), contains('not supported'));
    });

    test('labels', () {
      expect(audienceLabel(PostAudience.members), 'Members Only');
      expect(kindLabel(PostKind.reel), 'Reel');
      expect(audienceHint(PostAudience.public), isNotEmpty);
      expect(draftCommunityRules, contains('report'));
    });
  });
}
