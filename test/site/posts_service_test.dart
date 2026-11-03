import 'dart:io';

import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:bottles_up_user/site/services/posts_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late PostsService service;
  late Directory dir;
  var clock = DateTime.utc(2099, 1, 1, 12);

  setUp(() {
    site = FakeWebsite();
    clock = DateTime.utc(2099, 1, 1, 12);
    service = PostsService(site.client, now: () => clock);
    dir = Directory.systemTemp.createTempSync('posts_service_test');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  PickedMedia photo({int bytes = 4, String type = 'image/jpeg'}) {
    final f = File('${dir.path}/pic.jpg')..writeAsBytesSync(List.filled(bytes, 7));
    return PickedMedia(path: f.path, type: type, bytes: bytes);
  }

  PickedMedia video({int ms = 15000}) {
    final f = File('${dir.path}/clip.mp4')..writeAsBytesSync(List.filled(32, 1));
    return PickedMedia(path: f.path, type: 'video/mp4', bytes: 32, durationMs: ms, width: 720, height: 1280);
  }

  group('the rules', () {
    test('asks and accepts', () async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      site.rpcs['rules_accept'] = (_) => ok({'version': 1, 'accepted': true});
      expect(await service.rulesAccepted(), isFalse);
      await service.acceptRules(1);
      expect(site.forRpc('rules_accept').single.body, {'p_version': 1});
    });
  });

  group('files', () {
    test('a photo goes up from memory into the profile\'s folder with its type', () async {
      final u = await service.upload('ABC12345-0000-0000-0000-000000000001', photo());
      final up = site.storageOf('upload').single;
      expect(up.path, u.path);
      expect(u.path, matches(RegExp(r'^abc12345-0000-0000-0000-000000000001/[0-9a-f]{32}\.jpg$')));
      expect(up.body.toLowerCase(), contains('content-type: image/jpeg'));
      expect(up.size, greaterThan(3));
      expect(u.toJson()['type'], 'image');
    });

    test('a video goes up from the file and says how long it is', () async {
      final u = await service.upload('a1', video(ms: 42000));
      expect(site.storageOf('upload').single.path, endsWith('.mp4'));
      expect(u.toJson(), {'path': u.path, 'type': 'video', 'duration_ms': 42000, 'width': 720, 'height': 1280});
    });

    test('a file that is too big, too long or of a wrong type is refused before anything is sent', () async {
      await expectLater(service.upload('a1', photo(bytes: maxImageBytes + 1, type: 'image/jpeg')), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'A photo can be 10 MB at most.')));
      await expectLater(service.upload('a1', video(ms: 61000)), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'A video can be up to 60 seconds.')));
      await expectLater(service.upload('a1', photo(type: 'image/gif')), throwsA(isA<SiteException>()));
      expect(site.storageRequests, isEmpty);
    });

    test('a failed upload says to check the connection', () async {
      site.failUploads = true;
      await expectLater(service.upload('a1', photo()), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'We could not upload that. Check your connection and try again.')));
    });

    test('signed addresses are asked for once, together, and kept for a while', () async {
      final a = await service.signedUrls(['x/1.jpg', 'x/2.jpg']);
      expect(a['x/1.jpg'], startsWith('https://site.test/storage/v1/object/sign/social-media/x/1.jpg'));
      expect(site.storageOf('sign'), hasLength(1));
      expect(site.storageOf('sign').single.paths, ['x/1.jpg', 'x/2.jpg']);
      await service.signedUrls(['x/1.jpg', 'x/3.jpg']);
      expect(site.storageOf('sign').last.paths, ['x/3.jpg'], reason: 'the first one was kept');
      clock = clock.add(const Duration(minutes: 41));
      await service.signedUrls(['x/1.jpg']);
      expect(site.storageOf('sign').last.paths, ['x/1.jpg'], reason: 'asked again after 40 minutes');
    });

    test('a path that cannot be signed is left out, not an error', () async {
      site.unsignable.add('x/gone.jpg');
      final r = await service.signedUrls(['x/gone.jpg', 'x/ok.jpg']);
      expect(r.keys, ['x/ok.jpg']);
    });

    test('signing that fails leaves the pictures to their placeholders', () async {
      site.networkDown = true;
      expect(await service.signedUrls(['x/1.jpg']), isEmpty);
    });

    test('pictures asked for in the same moment are signed in one request', () async {
      final futures = [service.signedUrl('x/1.jpg'), service.signedUrl('x/2.jpg'), service.signedUrl('x/3.jpg')];
      final urls = await Future.wait(futures);
      expect(urls.every((u) => u != null && u.startsWith('https://')), isTrue);
      expect(site.storageOf('sign'), hasLength(1));
      expect(site.storageOf('sign').single.paths, ['x/1.jpg', 'x/2.jpg', 'x/3.jpg']);
      expect(await service.signedUrl('x/1.jpg'), urls.first);
      expect(site.storageOf('sign'), hasLength(1));
    });
  });

  group('posts', () {
    test('creates one with the files, the tags and who it is for', () async {
      site.rpcs['post_create'] = (_) => ok(postRow(id: 'new1', kind: 'reel'));
      final p = await service.create(
        actor: 'me',
        kind: PostKind.reel,
        audience: PostAudience.members,
        media: const [UploadedMedia(path: 'me/a.mp4', type: 'video/mp4', durationMs: 9000)],
        caption: '  On stage ',
        tags: const [TagRef(TagKind.event, 'e1'), TagRef(TagKind.profile, 'p2')],
        commentsEnabled: false,
      );
      expect(p.id, 'new1');
      expect(site.forRpc('post_create').single.body, {
        'p_actor': 'me',
        'p_kind': 'reel',
        'p_caption': 'On stage',
        'p_audience': 'members',
        'p_media': [
          {'path': 'me/a.mp4', 'type': 'video', 'duration_ms': 9000},
        ],
        'p_tags': [
          {'kind': 'event', 'id': 'e1'},
          {'kind': 'profile', 'id': 'p2'},
        ],
        'p_comments_enabled': false,
      });
    });

    test('the website\'s refusals are shown as they come', () async {
      site.rpcs['post_create'] = (_) => raised('Read and accept the community rules first.');
      await expectLater(
        service.create(actor: 'me', kind: PostKind.post, audience: PostAudience.public, media: const []),
        throwsA(isA<SiteException>().having((e) => e.message, 'm', 'Read and accept the community rules first.')),
      );
    });

    test('an answer that is not a post is an error', () async {
      site.rpcs['post_create'] = (_) => ok({'oops': 1});
      await expectLater(service.create(actor: 'me', kind: PostKind.post, audience: PostAudience.public, media: const []), throwsA(isA<SiteException>()));
    });

    test('edits', () async {
      site.rpcs['post_edit'] = (_) => ok(postRow());
      await service.edit(actor: 'me', post: 'p1', caption: ' new ', audience: PostAudience.followers, commentsEnabled: true);
      expect(site.forRpc('post_edit').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_caption': 'new', 'p_audience': 'followers', 'p_comments_enabled': true});
    });

    test('deleting removes the files the website names', () async {
      site.rpcs['post_delete'] = (_) => ok(['me/a.jpg', 'me/a-poster.jpg']);
      await service.delete(actor: 'me', post: 'p1');
      expect(site.storageOf('remove').single.paths, ['me/a.jpg', 'me/a-poster.jpg']);
    });

    test('files that cannot be removed do not undo a deletion', () async {
      var storageCalls = 0;
      site.rpcs['post_delete'] = (_) {
        storageCalls++;
        return ok(['me/a.jpg']);
      };
      site.failAllWith = null;
      // A failing storage call is swallowed (a clean-up job finds what is left).
      await service.delete(actor: 'me', post: 'p1');
      expect(storageCalls, 1);
    });

    test('opens one post', () async {
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1'));
      expect((await service.post(actor: 'me', id: 'p1')).id, 'p1');
      expect(site.forRpc('post_get').single.body, {'p_actor': 'me', 'p_post': 'p1'});
    });

    test('a post that is not available shows the sentence', () async {
      site.rpcs['post_get'] = (_) => raised('This post isn\'t available.');
      await expectLater(service.post(actor: 'me', id: 'p1'), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'This post isn\'t available.')));
    });

    test('takes a tag off', () async {
      site.rpcs['post_untag'] = (_) => ok({'untagged': true});
      await service.untagMe(actor: 'me', post: 'p1');
      expect(site.forRpc('post_untag').single.body, {'p_actor': 'me', 'p_post': 'p1'});
    });
  });

  group('reading', () {
    test('the feed pages after the last post seen, with microsecond precision', () async {
      site.rpcs['feed_home'] = (_) => ok([postRow(id: 'a', createdAt: '2099-10-24T22:00:00.123456Z')]);
      final first = await service.feed(actor: 'me');
      expect(site.forRpc('feed_home').single.body, {'p_actor': 'me', 'p_limit': 20, 'p_before': null, 'p_before_id': null});
      await service.feed(actor: 'me', after: first.last);
      expect(site.forRpc('feed_home').last.body['p_before'], '2099-10-24T22:00:00.123456Z');
      expect(site.forRpc('feed_home').last.body['p_before_id'], 'a');
    });

    test('suggestions, reels, the rail, one profile\'s stories and a profile\'s grid', () async {
      site.rpcs['feed_suggested'] = (_) => ok([postRow(id: 's')]);
      site.rpcs['feed_reels'] = (_) => ok([postRow(id: 'r', kind: 'reel')]);
      site.rpcs['story_rail'] = (_) => ok([railRow()]);
      site.rpcs['stories_of'] = (_) => ok([postRow(id: 't', kind: 'story', expiresAt: '2099-10-25T22:00:00Z')]);
      site.rpcs['profile_posts'] = (_) => ok({'total': 7, 'items': [postRow(id: 'g')]});
      expect((await service.suggested(actor: 'me')).single.id, 's');
      expect((await service.reels(actor: 'me')).single.kind, PostKind.reel);
      expect((await service.storyRail('me')).single.profile.handle, 'ann');
      expect((await service.storiesOf(actor: 'me', profile: 'a1')).single.kind, PostKind.story);
      final grid = await service.profilePosts(actor: 'me', profile: 'a1', kind: PostKind.reel);
      expect(grid.total, 7);
      expect(site.forRpc('profile_posts').single.body['p_kind'], 'reel');
      expect(site.forRpc('feed_suggested').single.body, {'p_actor': 'me', 'p_limit': 10});
      expect(site.forRpc('stories_of').single.body, {'p_actor': 'me', 'p_profile': 'a1'});
    });

    test('a private profile\'s grid shows the website\'s sentence', () async {
      site.rpcs['profile_posts'] = (_) => raised('Follow this profile to see its posts.');
      await expectLater(service.profilePosts(actor: 'me', profile: 'a1'), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'Follow this profile to see its posts.')));
    });

    test('marking a story watched never fails the screen', () async {
      site.rpcs['story_seen'] = (_) => raised('This story isn\'t available.');
      await service.storySeen(actor: 'me', story: 's1');
      expect(site.forRpc('story_seen').single.body, {'p_actor': 'me', 'p_story': 's1'});
    });
  });

  group('likes, saves and comments', () {
    test('like answers the count now', () async {
      site.rpcs['post_like'] = (b) => ok({'liked': b['p_liked'], 'likes': 4});
      expect(await service.like(actor: 'me', post: 'p1', liked: true), 4);
      expect(site.forRpc('post_like').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_liked': true});
    });

    test('saves and the saved list', () async {
      site.rpcs['post_save'] = (_) => ok({'saved': true});
      site.rpcs['saved_posts'] = (_) => ok([postRow(id: 'sv', saved: true)]);
      await service.save(actor: 'me', post: 'p1', saved: true);
      expect(site.forRpc('post_save').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_saved': true});
      expect((await service.savedPosts(actor: 'me', before: DateTime.utc(2099, 1, 2))).single.saved, isTrue);
      expect(site.forRpc('saved_posts').single.body['p_before'], '2099-01-02T00:00:00.000Z');
    });

    test('comments: add, reply, list, delete', () async {
      site.rpcs['comment_add'] = (_) => ok(commentRow(id: 'c2', replyTo: 'c1'));
      site.rpcs['comment_list'] = (_) => ok([commentRow(id: 'c1')]);
      site.rpcs['comment_delete'] = (_) => ok({'deleted': true});
      final c = await service.addComment(actor: 'me', post: 'p1', body: '  nice ', replyTo: 'c1');
      expect(c.replyTo, 'c1');
      expect(site.forRpc('comment_add').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_body': 'nice', 'p_reply_to': 'c1'});
      expect((await service.comments(actor: 'me', post: 'p1', after: DateTime.utc(2099, 1, 1))).single.id, 'c1');
      expect(site.forRpc('comment_list').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_parent': null, 'p_limit': 30, 'p_after': '2099-01-01T00:00:00.000Z'});
      await service.deleteComment(actor: 'me', comment: 'c1');
      expect(site.forRpc('comment_delete').single.body, {'p_actor': 'me', 'p_comment': 'c1'});
    });

    test('a comment refused for speed says so', () async {
      site.rpcs['comment_add'] = (_) => raised('You are commenting too quickly. Try again in a moment.');
      await expectLater(service.addComment(actor: 'me', post: 'p1', body: 'x'), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'You are commenting too quickly. Try again in a moment.')));
    });
  });

  group('Members Only', () {
    test('lists and changes the list', () async {
      site.rpcs['members_list'] = (_) => ok([{...profileRow(id: 'b1', handle: 'bob', name: 'Bob Ray'), 'added_at': '2099-01-01T00:00:00Z', 'still_following': false}]);
      site.rpcs['members_set'] = (b) => ok({'members': 1, 'is_member': b['p_in']});
      final m = await service.members(actor: 'me');
      expect(m.single.stillFollowing, isFalse);
      expect(site.forRpc('members_list').single.body, {'p_actor': 'me', 'p_limit': 100, 'p_before': null});
      await service.setMember(actor: 'me', member: 'b1', isMember: true);
      expect(site.forRpc('members_set').single.body, {'p_actor': 'me', 'p_member': 'b1', 'p_in': true});
    });

    test('the website says they must follow first', () async {
      site.rpcs['members_set'] = (_) => raised('They need to follow you first.');
      await expectLater(service.setMember(actor: 'me', member: 'b1', isMember: true), throwsA(isA<SiteException>().having((e) => e.message, 'm', 'They need to follow you first.')));
    });
  });
}
