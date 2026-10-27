import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

Map<String, dynamic> story(String id, {String caption = 'hi', bool seen = false, bool mine = false, String audience = 'public', bool video = false, int? ms}) => {
      ...postRow(
        id: id,
        kind: 'story',
        caption: caption,
        audience: audience,
        mine: mine,
        expiresAt: '2099-10-25T22:00:00Z',
        media: [video ? mediaRow(id: 'm-$id', type: 'video', path: 'a1/$id.mp4', durationMs: ms ?? 12000) : mediaRow(id: 'm-$id', path: 'a1/$id.jpg')],
      ),
      'seen': seen,
    };

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  const features = {'social': true, 'stories': true, 'reels': true};

  Future<GoRouter> openStory(WidgetTester tester, List<Map<String, dynamic>> stories, {bool owner = false}) async {
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee', mine: owner));
    site.rpcs['stories_of'] = (_) => ok(stories);
    site.rpcs['story_seen'] = (_) => ok({'seen': true});
    final router = await openSocial(tester, site, '/feed', features: features);
    router.push('/stories/ann');
    // The profile, then its stories, then the picture's address, each a moment: wait until the viewer is up (or says there is nothing to show).
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byKey(const Key('story-surface')).evaluate().isNotEmpty || find.text('No story right now').evaluate().isNotEmpty) break;
    }
    await tester.pump(const Duration(milliseconds: 150));
    return router;
  }

  Future<void> tapRight(WidgetTester tester) async {
    await tester.tapAt(const Offset(700, 800));
    await tester.pump();
  }

  Future<void> tapLeft(WidgetTester tester) async {
    await tester.tapAt(const Offset(60, 800));
    await tester.pump();
  }

  group('the story viewer', () {
    testWidgets('starts at the first story not yet watched and marks it watched', (tester) async {
      await openStory(tester, [story('s1', seen: true, caption: 'old'), story('s2', caption: 'new'), story('s3', caption: 'newer')]);
      expect(find.text('new'), findsOneWidget);
      expect(site.forRpc('story_seen').single.body, {'p_actor': 'me', 'p_story': 's2'});
      expect(site.forRpc('stories_of').single.body, {'p_actor': 'me', 'p_profile': 'a1'});
    });

    testWidgets('starts at the first when all were watched, and does not mark them again', (tester) async {
      await openStory(tester, [story('s1', seen: true, caption: 'one'), story('s2', seen: true, caption: 'two')]);
      expect(find.text('one'), findsOneWidget);
      expect(site.forRpc('story_seen'), isEmpty);
    });

    testWidgets('moves on by itself after five seconds, and closes after the last', (tester) async {
      final router = await openStory(tester, [story('s1', caption: 'one'), story('s2', caption: 'two')]);
      expect(find.text('one'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('one'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('two'), findsOneWidget);
      expect(site.forRpc('story_seen').map((r) => r.body['p_story']), ['s1', 's2']);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/feed');
    });

    testWidgets('a tap on the right goes forward, on the left goes back', (tester) async {
      await openStory(tester, [story('s1', caption: 'one'), story('s2', caption: 'two'), story('s3', caption: 'three')]);
      await tapRight(tester);
      expect(find.text('two'), findsOneWidget);
      await tapRight(tester);
      expect(find.text('three'), findsOneWidget);
      await tapLeft(tester);
      expect(find.text('two'), findsOneWidget);
      await tapLeft(tester);
      await tapLeft(tester);
      expect(find.text('one'), findsOneWidget, reason: 'going back from the first stays on the first');
    });

    testWidgets('the progress bars show what has gone and what is to come', (tester) async {
      await openStory(tester, [story('s1'), story('s2'), story('s3')]);
      await tapRight(tester);
      expect(tester.widget<LinearProgressIndicator>(find.byKey(const Key('story-progress-0'))).value, 1);
      expect(find.byKey(const Key('story-progress-current')), findsOneWidget);
      expect(tester.widget<LinearProgressIndicator>(find.byKey(const Key('story-progress-2'))).value, 0);
    });

    testWidgets('holding a story keeps it up', (tester) async {
      await openStory(tester, [story('s1', caption: 'one'), story('s2', caption: 'two')]);
      final hold = await tester.startGesture(const Offset(400, 800));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 8));
      expect(find.text('one'), findsOneWidget, reason: 'paused while held');
      await hold.up();
      await tester.pump(); // the first frame after letting go starts the clock
      await tester.pump(const Duration(seconds: 6));
      await tester.pump();
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('a Members Only story is marked', (tester) async {
      await openStory(tester, [story('s1', audience: 'members')]);
      expect(find.byKey(const Key('story-members-badge')), findsOneWidget);
    });

    testWidgets('a video story stays up for as long as it runs', (tester) async {
      await openStory(tester, [story('s1', video: true, ms: 20000, caption: 'clip'), story('s2', caption: 'after')]);
      expect(find.text('video autoplay=true'), findsOneWidget);
      await tester.pump(const Duration(seconds: 15));
      expect(find.text('clip'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      expect(find.text('after'), findsOneWidget);
    });

    testWidgets('the close button leaves', (tester) async {
      final router = await openStory(tester, [story('s1')]);
      await tester.tap(find.byKey(const Key('close-story')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/feed');
    });

    testWidgets('your own story can be deleted after asking, and the next one shows', (tester) async {
      site.rpcs['post_delete'] = (_) => ok(['a1/s1.jpg']);
      await openStory(tester, [story('s1', caption: 'one', mine: true), story('s2', caption: 'two', mine: true)], owner: true);
      await tester.tap(find.byKey(const Key('delete-story')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(site.forRpc('post_delete'), isEmpty, reason: 'asks first');
      await tester.tap(find.byKey(const Key('confirm-delete-story')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(site.forRpc('post_delete').single.body, {'p_actor': 'me', 'p_post': 's1'});
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('only your own stories have a delete button', (tester) async {
      await openStory(tester, [story('s1')]);
      expect(find.byKey(const Key('delete-story')), findsNothing);
    });

    testWidgets('no story right now says so', (tester) async {
      await openStory(tester, const []);
      expect(find.text('No story right now'), findsOneWidget);
    });

    testWidgets('stories off: nothing opens', (tester) async {
      await openSocial(tester, site, '/stories/ann', features: const {'social': false});
      expect(find.text('Coming soon'), findsOneWidget);
    });
  });

  group('reels', () {
    Map<String, dynamic> reel(String id, {int likes = 0, bool liked = false, String caption = 'on stage', int comments = 0}) => postRow(
          id: id,
          kind: 'reel',
          caption: caption,
          likes: likes,
          liked: liked,
          commentCount: comments,
          media: [mediaRow(id: 'm-$id', type: 'video', path: 'a1/$id.mp4', durationMs: 10000)],
        );

    Future<GoRouter> openReels(WidgetTester tester) => openSocial(tester, site, '/reels', features: features);

    testWidgets('shows the first reel playing, with who posted it', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([reel('r1'), reel('r2', caption: 'second')]);
      await openReels(tester);
      expect(find.byKey(const Key('reels-pager')), findsOneWidget);
      expect(find.text('@ann'), findsOneWidget);
      expect(find.text('on stage'), findsOneWidget);
      expect(find.text('video autoplay=true'), findsOneWidget);
      expect(site.forRpc('feed_reels').single.body, {'p_actor': 'me', 'p_limit': 10, 'p_before': null, 'p_before_id': null});
    });

    testWidgets('swiping up shows the next, and only that one plays', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([reel('r1'), reel('r2', caption: 'second')]);
      await openReels(tester);
      await tester.fling(find.byKey(const Key('reels-pager')), const Offset(0, -600), 2000);
      await tester.pumpAndSettle();
      expect(find.text('second'), findsOneWidget);
      expect(find.text('on stage'), findsNothing);
      expect(find.text('video autoplay=true'), findsOneWidget);
    });

    testWidgets('liking and saving go to the website; the count moves at once', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([reel('r1', likes: 2)]);
      site.rpcs['post_like'] = (b) => ok({'liked': true, 'likes': 3});
      site.rpcs['post_save'] = (b) => ok({'saved': true});
      await openReels(tester);
      await tester.tap(find.byKey(const Key('reel-like-r1')));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(const Key('reel-likes-r1'))).data, '3');
      expect(site.forRpc('post_like').single.body, {'p_actor': 'me', 'p_post': 'r1', 'p_liked': true});
      await tester.tap(find.byKey(const Key('reel-save-r1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_save').single.body['p_saved'], true);
    });

    testWidgets('a like that is refused goes back', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([reel('r1', likes: 2)]);
      site.rpcs['post_like'] = (_) => raised('This post isn\'t available.');
      await openReels(tester);
      await tester.tap(find.byKey(const Key('reel-like-r1')));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(const Key('reel-likes-r1'))).data, '2');
      expect(find.text('This post isn\'t available.'), findsOneWidget);
    });

    testWidgets('comments open the post', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([reel('r1', comments: 4)]);
      site.rpcs['post_get'] = (_) => ok(reel('r1'));
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      final router = await openReels(tester);
      await tester.tap(find.byKey(const Key('reel-comments-r1')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/post/r1');
    });

    testWidgets('near the end of a full page the next page is read, after the last reel', (tester) async {
      var calls = 0;
      site.rpcs['feed_reels'] = (_) {
        calls++;
        return ok(calls == 1 ? [for (var i = 0; i < 10; i++) {...reel('r$i'), 'created_at': '2099-10-24T22:00:${(59 - i).toString().padLeft(2, '0')}Z'}] : [reel('late', caption: 'the last')]);
      };
      await openSocial(tester, site, '/reels', features: features, settle: false);
      await settleCalls(tester);
      for (var i = 0; i < 8; i++) {
        await tester.fling(find.byKey(const Key('reels-pager')), const Offset(0, -600), 2000);
        await tester.pumpAndSettle();
      }
      expect(site.forRpc('feed_reels'), hasLength(2));
      expect(site.forRpc('feed_reels').last.body['p_before_id'], 'r9');
      expect(site.forRpc('feed_reels').last.body['p_before'], '2099-10-24T22:00:50.000Z');
    });

    testWidgets('no reels says so; a failure offers to try again', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok(<Object>[]);
      await openReels(tester);
      expect(find.text('No reels yet'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site = FakeWebsite();
      site.rpcs['feed_reels'] = (_) => (status: 500, body: {'message': 'boom'});
      await openReels(tester);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    });
  });
}
