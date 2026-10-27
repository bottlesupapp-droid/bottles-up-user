import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:bottles_up_user/site/services/posts_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's posts migration: a change there the app does not follow fails here.
void main() {
  group('posts against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('social_posts'));

    test('every function the app calls exists with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = PostsService(site.client);
      final card = postRow();
      for (final name in ['post_create', 'post_edit', 'post_get']) {
        site.rpcs[name] = (_) => ok(card);
      }
      for (final name in ['feed_home', 'feed_suggested', 'feed_reels', 'stories_of', 'saved_posts']) {
        site.rpcs[name] = (_) => ok([card]);
      }
      site.rpcs['profile_posts'] = (_) => ok({'total': 1, 'items': [card]});
      site.rpcs['rules_status'] = (_) => ok({'accepted': true});
      site.rpcs['rules_accept'] = (_) => ok({'accepted': true});
      site.rpcs['post_delete'] = (_) => ok(['a/b.jpg']);
      site.rpcs['post_untag'] = (_) => ok({'untagged': true});
      site.rpcs['story_rail'] = (_) => ok([railRow()]);
      site.rpcs['story_seen'] = (_) => ok({'seen': true});
      site.rpcs['post_like'] = (_) => ok({'liked': true, 'likes': 1});
      site.rpcs['post_save'] = (_) => ok({'saved': true});
      site.rpcs['comment_add'] = (_) => ok(commentRow());
      site.rpcs['comment_list'] = (_) => ok([commentRow()]);
      site.rpcs['comment_delete'] = (_) => ok({'deleted': true});
      site.rpcs['members_list'] = (_) => ok([profileRow(id: 'b1', handle: 'bob')]);
      site.rpcs['members_set'] = (_) => ok({'members': 1});

      final after = parseSocialPost(card)!;
      await service.rulesAccepted();
      await service.acceptRules();
      await service.create(actor: 'a', kind: PostKind.post, audience: PostAudience.public, media: const [UploadedMedia(path: 'a/b.jpg', type: 'image/jpeg')], caption: 'x', tags: const [TagRef(TagKind.event, 'e')]);
      await service.edit(actor: 'a', post: 'p', caption: 'x', audience: PostAudience.public, commentsEnabled: true);
      await service.delete(actor: 'a', post: 'p');
      await service.post(actor: 'a', id: 'p');
      await service.untagMe(actor: 'a', post: 'p');
      await service.profilePosts(actor: 'a', profile: 'p', kind: PostKind.post, after: after);
      await service.feed(actor: 'a', after: after);
      await service.suggested(actor: 'a');
      await service.reels(actor: 'a', after: after);
      await service.storyRail('a');
      await service.storiesOf(actor: 'a', profile: 'p');
      await service.storySeen(actor: 'a', story: 's');
      await service.like(actor: 'a', post: 'p', liked: true);
      await service.save(actor: 'a', post: 'p', saved: true);
      await service.savedPosts(actor: 'a', before: DateTime.utc(2099));
      await service.addComment(actor: 'a', post: 'p', body: 'x', replyTo: 'c');
      await service.comments(actor: 'a', post: 'p', parent: 'c', after: DateTime.utc(2099));
      await service.deleteComment(actor: 'a', comment: 'c');
      await service.members(actor: 'a', before: DateTime.utc(2099));
      await service.setMember(actor: 'a', member: 'b', isMember: true);

      expect(site.rpcRequests.map((r) => r.name).toSet(), hasLength(22));
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('the limits are the website\'s', () {
      expect(sql, contains('char_length(caption) <= $maxCaptionLength'));
      expect(sql, contains('char_length(btrim(body)) between 1 and $maxCommentLength'));
      expect(sql, contains('jsonb_array_length(p_media) > $maxPhotosPerPost'));
      expect(sql, contains('v_size > $maxImageBytes then'));
      expect(sql, contains('v_size > $maxVideoBytes then'));
      expect(sql, contains('v_dur > $maxVideoMillis'));
      expect(sql, contains('between 1 and $maxVideoMillis'));
      expect(sql, contains("> $maxTagsPerPost then raise exception 'You can tag up to 10.'"));
      expect(sql, contains('>= $maxMembers'));
      expect(sql, contains("raise exception 'The caption can be $maxCaptionLength characters at most.'"));
      expect(sql, contains("raise exception 'A comment can be $maxCommentLength characters at most.'"));
      expect(sql, contains("raise exception 'A photo can be 10 MB at most.'"));
      expect(sql, contains("raise exception 'A video can be 100 MB at most.'"));
      expect(sql, contains("raise exception 'A video can be up to 60 seconds.'"));
    });

    test('the bucket takes the types the app offers, and nothing the app does not', () {
      final bucket = sql.substring(sql.indexOf('insert into storage.buckets'));
      final types = {for (final m in RegExp("'([a-z]+/[a-z0-9.+-]+)'").allMatches(bucket.substring(0, bucket.indexOf(';')))) m.group(1)!};
      expect(types, {...allowedImageTypes, ...allowedVideoTypes}, reason: 'the bucket list');
      expect(sql, contains("file_size_limit, allowed_mime_types)\nvalues ('social-media', 'social-media', false, $maxVideoBytes,"));
    });

    test('the app\'s file paths are in the shape the website checks', () {
      final m = RegExp(r"p_name ~ '([^']+)'").firstMatch(sql)!;
      final re = RegExp(m.group(1)!);
      for (final ext in ['jpg', 'png', 'webp', 'mp4', 'mov']) {
        expect(re.hasMatch(mediaPathFor('00000000-0000-4000-8000-000000000001', ext)), isTrue, reason: ext);
      }
      expect(re.hasMatch('00000000-0000-4000-8000-000000000001/../x'), isFalse);
    });

    test('the app\'s idea of the rules version is the website\'s', () {
      expect(sql, contains('create function public.social_rules_version()\nreturns int\nlanguage sql\nimmutable\nset search_path = public\nas \$\$ select 1 \$\$;'));
    });

    test('the audiences and kinds are the website\'s', () {
      expect(sqlWordsAfter(sql, "audience text not null default 'public' check (audience in"), {for (final a in PostAudience.values) a.name});
      expect(sqlWordsAfter(sql, "kind text not null check (kind in"), {for (final k in PostKind.values) k.name});
    });
  });
}
