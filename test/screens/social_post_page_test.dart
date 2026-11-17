import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Map<String, dynamic> myComment(String id, String body, {String by = 'bob', int replies = 0, bool delete = false, String? replyTo, String at = '2099-10-24T23:00:00Z'}) =>
      commentRow(id: id, body: body, replies: replies, canDelete: delete, replyTo: replyTo, createdAt: at, author: profileRow(id: 'u-$by', handle: by, name: by));

  Future<void> openPost(WidgetTester tester, {Map<String, dynamic>? post, List<Map<String, dynamic>> comments = const [], bool accepted = true}) async {
    site.rpcs['post_get'] = (_) => ok(post ?? postRow(id: 'p1', caption: 'Friday vibes', commentCount: comments.length));
    site.rpcs['comment_list'] = (b) => ok(b['p_parent'] == null ? comments : <Object>[]);
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': accepted});
    site.rpcs['rules_accept'] = (_) {
      accepted = true;
      return ok({'version': 1, 'accepted': true});
    };
    await openSocial(tester, site, '/post/p1');
  }

  testWidgets('shows the post with its comments below, oldest first', (tester) async {
    await openPost(tester, comments: [myComment('c1', 'Great night!'), myComment('c2', 'Loved it', by: 'sam')]);
    expect(find.byKey(const Key('caption-p1')), findsOneWidget);
    expect(find.byKey(const Key('comment-c1')), findsOneWidget);
    expect(find.byKey(const Key('comment-c2')), findsOneWidget);
    expect(find.text('No comments yet. Be the first.'), findsNothing);
    expect(site.forRpc('post_get').single.body, {'p_actor': 'me', 'p_post': 'p1'});
    expect(site.forRpc('comment_list').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_parent': null, 'p_limit': 30, 'p_after': null});
  });

  testWidgets('no comments says so', (tester) async {
    await openPost(tester);
    expect(find.byKey(const Key('no-comments')), findsOneWidget);
  });

  testWidgets('a post that is not available says so kindly', (tester) async {
    site.rpcs['post_get'] = (_) => raised('This post isn\'t available.');
    await openSocial(tester, site, '/post/p1');
    expect(find.text('This post isn\'t available'), findsOneWidget);
    expect(find.byKey(const Key('load-failed-retry')), findsNothing);
  });

  testWidgets('a failed load offers to try again', (tester) async {
    var fail = true;
    site.rpcs['post_get'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok(postRow(id: 'p1'));
    site.rpcs['comment_list'] = (_) => ok(<Object>[]);
    await openSocial(tester, site, '/post/p1');
    expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    fail = false;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('post-p1')), findsOneWidget);
  });

  group('adding a comment', () {
    testWidgets('after the rules are accepted it is added to the list', (tester) async {
      site.rpcs['comment_add'] = (b) => ok(myComment('c9', b['p_body'] as String, by: 'dana'));
      await openPost(tester);
      await tester.enterText(find.byKey(const Key('comment-field')), '  Nice one  ');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(site.forRpc('comment_add').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_body': 'Nice one', 'p_reply_to': null});
      expect(find.byKey(const Key('comment-c9')), findsOneWidget);
      expect(tester.widget<TextField>(find.byKey(const Key('comment-field'))).controller!.text, '');
      expect(find.byKey(const Key('no-comments')), findsNothing);
    });

    testWidgets('an empty comment is refused on the spot', (tester) async {
      await openPost(tester);
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(find.text('Write something first.'), findsOneWidget);
      expect(site.forRpc('comment_add'), isEmpty);
    });

    testWidgets('the website\'s refusal is shown under the box', (tester) async {
      site.rpcs['comment_add'] = (_) => raised('You are commenting too quickly. Try again in a moment.');
      await openPost(tester);
      await tester.enterText(find.byKey(const Key('comment-field')), 'hi');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(find.text('You are commenting too quickly. Try again in a moment.'), findsOneWidget);
      expect(tester.widget<TextField>(find.byKey(const Key('comment-field'))).controller!.text, 'hi', reason: 'what was typed is kept');
    });

    testWidgets('the community rules come first, once', (tester) async {
      site.rpcs['comment_add'] = (b) => ok(myComment('c9', b['p_body'] as String, by: 'dana'));
      await openPost(tester, accepted: false);
      await tester.enterText(find.byKey(const Key('comment-field')), 'first');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(site.forRpc('comment_add'), isEmpty);
      await tester.tap(find.byKey(const Key('rules-decline')));
      await tester.pumpAndSettle();
      expect(site.forRpc('comment_add'), isEmpty, reason: 'declining posts nothing');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('rules_accept').single.body, {'p_version': 1});
      expect(site.forRpc('comment_add'), hasLength(1), reason: 'accepting carries on with what the person was doing');
      await tester.enterText(find.byKey(const Key('comment-field')), 'second');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(site.forRpc('comment_add'), hasLength(2));
      expect(find.byKey(const Key('rules-text')), findsNothing, reason: 'asked only once');
      expect(site.forRpc('rules_accept'), hasLength(1));
    });

    testWidgets('a refusal when accepting the rules is shown in the dialog', (tester) async {
      await openPost(tester, accepted: false);
      site.rpcs['rules_accept'] = (_) => raised('The community rules have changed. Read them again.');
      await tester.enterText(find.byKey(const Key('comment-field')), 'x');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-problem')), findsOneWidget);
      expect(find.text('The community rules have changed. Read them again.'), findsOneWidget);
    });
  });

  group('replies and deleting', () {
    testWidgets('replying names who it is to and sends the comment it answers', (tester) async {
      site.rpcs['comment_add'] = (b) => ok(myComment('r1', b['p_body'] as String, by: 'dana', replyTo: b['p_reply_to'] as String?));
      await openPost(tester, comments: [myComment('c1', 'Great night!')]);
      await tester.tap(find.byKey(const Key('reply-c1')));
      await tester.pump();
      expect(find.text('Replying to @bob'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('comment-field')), 'Thanks');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
      expect(site.forRpc('comment_add').single.body['p_reply_to'], 'c1');
      expect(find.byKey(const Key('comment-r1')), findsOneWidget);
      expect(find.text('Replying to @bob'), findsNothing);
    });

    testWidgets('cancelling a reply goes back to a top-level comment', (tester) async {
      await openPost(tester, comments: [myComment('c1', 'Great night!')]);
      await tester.tap(find.byKey(const Key('reply-c1')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('cancel-reply')));
      await tester.pump();
      expect(find.byKey(const Key('replying-to')), findsNothing);
    });

    testWidgets('replies are loaded on request', (tester) async {
      site.rpcs['comment_list'] = (b) => ok(b['p_parent'] == null ? [myComment('c1', 'Great night!', replies: 2)] : [myComment('r1', 'one', by: 'sam', replyTo: 'c1'), myComment('r2', 'two', by: 'eve', replyTo: 'c1')]);
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1', commentCount: 3));
      site.rpcs['rules_status'] = (_) => ok({'accepted': true});
      await openSocial(tester, site, '/post/p1');
      expect(find.text('View 2 replies'), findsOneWidget);
      await tester.tap(find.byKey(const Key('replies-c1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('comment-r1')), findsOneWidget);
      expect(find.byKey(const Key('comment-r2')), findsOneWidget);
      expect(site.forRpc('comment_list').last.body['p_parent'], 'c1');
      expect(find.text('View 2 replies'), findsNothing);
    });

    testWidgets('delete shows only where the website allows it, and removes the comment', (tester) async {
      site.rpcs['comment_delete'] = (_) => ok({'deleted': true});
      await openPost(tester, comments: [myComment('c1', 'mine', delete: true), myComment('c2', 'not mine')]);
      expect(find.byKey(const Key('delete-comment-c2')), findsNothing);
      await tester.tap(find.byKey(const Key('delete-comment-c1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('comment_delete').single.body, {'p_actor': 'me', 'p_comment': 'c1'});
      expect(find.byKey(const Key('comment-c1')), findsNothing);
      expect(find.byKey(const Key('comment-c2')), findsOneWidget);
    });

    testWidgets('a delete the website refuses is explained and the comment stays', (tester) async {
      site.rpcs['comment_delete'] = (_) => raised('You can only delete your own comments, or comments on your own posts.');
      await openPost(tester, comments: [myComment('c1', 'mine', delete: true)]);
      await tester.tap(find.byKey(const Key('delete-comment-c1')));
      await tester.pumpAndSettle();
      expect(find.text('You can only delete your own comments, or comments on your own posts.'), findsOneWidget);
      expect(find.byKey(const Key('comment-c1')), findsOneWidget);
    });
  });

  testWidgets('a full page of comments offers more, and the next page starts after the last one', (tester) async {
    var calls = 0;
    site.rpcs['comment_list'] = (_) {
      calls++;
      return ok(calls == 1 ? [for (var i = 0; i < 30; i++) myComment('c$i', 'comment $i', at: '2099-10-24T23:00:${i.toString().padLeft(2, '0')}Z')] : [myComment('late', 'the last comment', at: '2099-10-25T00:00:00Z')]);
    };
    site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1', commentCount: 31));
    site.rpcs['rules_status'] = (_) => ok({'accepted': true});
    await openSocial(tester, site, '/post/p1', settle: false);
    await settleCalls(tester);
    await tester.scrollUntilVisible(find.byKey(const Key('more-comments')), 600, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const Key('more-comments')));
    await settleCalls(tester);
    expect(site.forRpc('comment_list').last.body['p_after'], '2099-10-24T23:00:29.000Z');
    await tester.scrollUntilVisible(find.byKey(const Key('comment-late')), 600, scrollable: find.byType(Scrollable).first);
    expect(find.byKey(const Key('comment-late')), findsOneWidget);
  });

  testWidgets('with comments turned off there is a notice and no box', (tester) async {
    await openPost(tester, post: {...postRow(id: 'p1'), 'comments_enabled': false});
    expect(find.byKey(const Key('comments-off')), findsOneWidget);
    expect(find.byKey(const Key('comment-field')), findsNothing);
    expect(site.forRpc('comment_list'), isEmpty);
  });
}
