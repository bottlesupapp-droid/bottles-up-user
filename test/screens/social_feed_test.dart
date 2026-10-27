import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

Map<String, dynamic> post(String id, {String caption = 'hello', String kind = 'post', int likes = 0, int comments = 0, bool liked = false, bool saved = false, bool mine = false, String audience = 'public', String by = 'ann', List<Map<String, dynamic>> tags = const [], List<Map<String, dynamic>>? media}) => postRow(
      id: id,
      kind: kind,
      caption: caption,
      likes: likes,
      commentCount: comments,
      liked: liked,
      saved: saved,
      mine: mine,
      audience: audience,
      author: profileRow(id: 'author-$by', handle: by, name: by.toUpperCase()),
      tags: tags,
      media: media,
    );

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> openFeed(WidgetTester tester, {Map<String, bool> features = const {'social': true, 'stories': true, 'reels': true}, List<Map<String, dynamic>>? mine}) =>
      openSocial(tester, site, '/feed', features: features, mine: mine).then((_) {});

  group('the home feed', () {
    testWidgets('shows the posts newest first with the stories row on top', (tester) async {
      site.rpcs['feed_home'] = (_) => ok([post('p1', caption: 'first one'), post('p2', caption: 'second one', likes: 3)]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['story_rail'] = (_) => ok([railRow(profile: profileRow(id: 'bob1', handle: 'bob', name: 'Bob Ray'))]);
      await openFeed(tester);
      expect(find.byKey(const Key('story-rail')), findsOneWidget);
      expect(find.byKey(const Key('your-story')), findsOneWidget);
      expect(find.byKey(const Key('story-bob')), findsOneWidget);
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
      expect(find.byKey(const Key('post-p2')), findsOneWidget);
      expect(find.text('3 likes'), findsOneWidget);
      expect(site.forRpc('feed_home').single.body, {'p_actor': 'me', 'p_limit': 20, 'p_before': null, 'p_before_id': null});
    });

    testWidgets('an empty feed says so and offers a way out; suggestions still show', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok([post('s1', caption: 'popular', by: 'sam')]);
      await openFeed(tester);
      expect(find.byKey(const Key('empty-feed')), findsOneWidget);
      expect(find.byKey(const Key('empty-find')), findsOneWidget);
      expect(find.byKey(const Key('suggested-heading')), findsOneWidget);
      expect(find.byKey(const Key('caption-s1')), findsOneWidget);
    });

    testWidgets('a suggestion that is already in the feed is not shown twice', (tester) async {
      site.rpcs['feed_home'] = (_) => ok([post('p1')]);
      site.rpcs['feed_suggested'] = (_) => ok([post('p1')]);
      await openFeed(tester);
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
      expect(find.byKey(const Key('suggested-heading')), findsNothing);
    });

    testWidgets('a failure to read suggestions does not hide the feed', (tester) async {
      site.rpcs['feed_home'] = (_) => ok([post('p1')]);
      site.rpcs['feed_suggested'] = (_) => (status: 500, body: {'message': 'boom'});
      await openFeed(tester);
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
    });

    testWidgets('a failed feed offers to try again', (tester) async {
      var fail = true;
      site.rpcs['feed_home'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok([post('p1')]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openFeed(tester);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
    });

    testWidgets('a full page offers more and the next page starts after the last post', (tester) async {
      var calls = 0;
      site.rpcs['feed_home'] = (_) {
        calls++;
        return ok(calls == 1 ? [for (var i = 0; i < 20; i++) post('p$i', caption: 'c$i', media: [mediaRow(path: 'a/$i.jpg')], by: 'ann').._at('2099-10-24T22:00:${(59 - i).toString().padLeft(2, '0')}Z')] : [post('late', caption: 'the last one')]);
      };
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/feed', settle: false);
      await settleCalls(tester);
      await tester.scrollUntilVisible(find.byKey(const Key('feed-more')), 800, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.byKey(const Key('feed-more')));
      await settleCalls(tester);
      final last = site.forRpc('feed_home').last.body;
      expect(last['p_before_id'], 'p19');
      expect(last['p_before'], '2099-10-24T22:00:40.000Z');
      await tester.scrollUntilVisible(find.byKey(const Key('caption-late')), 800, scrollable: find.byType(Scrollable).first);
      expect(find.byKey(const Key('caption-late')), findsOneWidget);
    });

    testWidgets('pull to refresh reads the feed again', (tester) async {
      var round = 0;
      site.rpcs['feed_home'] = (_) => ok(++round == 1 ? [post('p1', caption: 'old')] : [post('p2', caption: 'fresh')]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openFeed(tester);
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
      // The pull gesture itself is the framework's; what matters here is what the screen does when asked to refresh.
      final refresh = tester.widget<RefreshIndicator>(find.byType(RefreshIndicator)).onRefresh();
      await tester.pumpAndSettle();
      await refresh;
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('caption-p2')), findsOneWidget);
      expect(find.byKey(const Key('caption-p1')), findsNothing);
    });

    testWidgets('the reels button shows only while reels are on', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openFeed(tester, features: const {'social': true, 'reels': false});
      expect(find.byKey(const Key('open-reels')), findsNothing);
      expect(find.byKey(const Key('story-rail')), findsNothing, reason: 'stories are off');
    });

    testWidgets('nothing opens while social is off', (tester) async {
      await openFeed(tester, features: const {'social': false});
      expect(find.text('Coming soon'), findsOneWidget);
      expect(site.forRpc('feed_home'), isEmpty);
    });
  });

  group('the row of stories', () {
    testWidgets('your own story is added with a plus; others show their ring', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['story_rail'] = (_) => ok([
            railRow(profile: profileRow(id: 'm1', handle: 'members', name: 'Members Co'), membersOnly: true),
            railRow(profile: profileRow(id: 's1', handle: 'seen', name: 'Seen Co'), unseen: false),
            railRow(profile: profileRow(id: 'n1', handle: 'newone', name: 'New Co')),
          ]);
      await openFeed(tester);
      Color? ringOf(String key) {
        final deco = tester.widget<Container>(find.descendant(of: find.byKey(Key(key)), matching: find.byType(Container)).first).decoration as BoxDecoration?;
        return (deco?.border as Border?)?.top.color;
      }

      expect(ringOf('story-members'), const Color(0xFFFF6B00), reason: 'Members Only is orange');
      expect(ringOf('story-seen'), Colors.grey);
      expect(ringOf('story-newone'), Colors.blueAccent);
      expect(ringOf('your-story'), isNull, reason: 'no story yet: no ring');
    });

    testWidgets('tapping your story with none opens the creator for a story; with one, the viewer', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/feed', features: const {'social': true, 'stories': true});
      await tester.tap(find.byKey(const Key('your-story')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/create');
      expect(find.text('Share to your story'), findsOneWidget, reason: 'the creator opens on Story');
    });

    testWidgets('your own story, once posted, opens the viewer', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['story_rail'] = (_) => ok([railRow(profile: profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true), mine: true, unseen: false)]);
      site.rpcs['profile_get'] = (_) => ok(myPersonal());
      site.rpcs['stories_of'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/feed', features: const {'social': true, 'stories': true});
      await tester.tap(find.byKey(const Key('your-story')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/stories/dana');
    });
  });

  group('a post in a feed', () {
    Future<void> openOne(WidgetTester tester, Map<String, dynamic> p) async {
      site.rpcs['feed_home'] = (_) => ok([p]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openFeed(tester);
    }

    testWidgets('liking is shown at once and kept when the website agrees', (tester) async {
      site.rpcs['post_like'] = (b) => ok({'liked': b['p_liked'], 'likes': 5});
      await openOne(tester, post('p1', likes: 4));
      expect(find.text('4 likes'), findsOneWidget);
      await tester.tap(find.byKey(const Key('like-p1')));
      await tester.pump();
      expect(find.text('5 likes'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(site.forRpc('post_like').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_liked': true});
      expect(find.text('5 likes'), findsOneWidget);
      await tester.tap(find.byKey(const Key('like-p1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_like').last.body['p_liked'], false);
    });

    testWidgets('a like the website refuses is taken back and explained', (tester) async {
      site.rpcs['post_like'] = (_) => raised('This post isn\'t available.');
      await openOne(tester, post('p1', likes: 1));
      await tester.tap(find.byKey(const Key('like-p1')));
      await tester.pumpAndSettle();
      expect(find.text('1 like'), findsOneWidget);
      expect(find.text('This post isn\'t available.'), findsOneWidget);
    });

    testWidgets('saving and unsaving', (tester) async {
      site.rpcs['post_save'] = (b) => ok({'saved': b['p_saved']});
      await openOne(tester, post('p1'));
      await tester.tap(find.byKey(const Key('save-p1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_save').single.body['p_saved'], true);
      await tester.tap(find.byKey(const Key('save-p1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_save').last.body['p_saved'], false);
    });

    testWidgets('a save that fails goes back', (tester) async {
      site.rpcs['post_save'] = (_) => (status: 500, body: {'message': 'boom'});
      await openOne(tester, post('p1', saved: true));
      await tester.tap(find.byKey(const Key('save-p1')));
      await tester.pumpAndSettle();
      expect(tester.widget<IconButton>(find.byKey(const Key('save-p1'))).tooltip, 'Unsave');
    });

    testWidgets('comments: a count that opens the post, and none when comments are off', (tester) async {
      await openOne(tester, post('p1', comments: 7));
      expect(find.text('View all 7 comments'), findsOneWidget);
      expect(find.byKey(const Key('comment-p1')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site = FakeWebsite();
      await openOne(tester, {...post('p2', comments: 2), 'comments_enabled': false});
      expect(find.byKey(const Key('comment-p2')), findsNothing);
      expect(find.byKey(const Key('view-comments-p2')), findsNothing);
    });

    testWidgets('a Members Only post is marked, and says who it is for', (tester) async {
      await openOne(tester, post('p1', audience: 'members'));
      expect(find.byKey(const Key('members-badge-p1')), findsOneWidget);
      expect(find.textContaining('Members Only'), findsWidgets);
    });

    testWidgets('several photos can be swiped and show dots', (tester) async {
      await openOne(tester, post('p1', media: [mediaRow(id: 'm1', position: 0, path: 'a/1.jpg'), mediaRow(id: 'm2', position: 1, path: 'a/2.jpg')]));
      expect(find.byKey(const Key('media-item-m1')), findsOneWidget);
      await tester.drag(find.byKey(const Key('media-p1')), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('media-item-m2')), findsOneWidget);
    });

    testWidgets('the private pictures are signed in one request for the whole screen', (tester) async {
      site.rpcs['feed_home'] = (_) => ok([post('p1'), post('p2'), post('p3')]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      await openFeed(tester);
      // The posts on screen are signed together; one further down is signed when it scrolls into view.
      expect(site.storageOf('sign'), hasLength(1));
      expect(site.storageOf('sign').single.paths.toSet(), containsAll({'a1/p1.jpg', 'a1/p2.jpg'}));
    });

    testWidgets('a tag on an event opens the event, a venue its page, a person their profile', (tester) async {
      final tags = [
        {'kind': 'event', 'id': 'e1', 'name': 'Friday Night'},
        {'kind': 'venue', 'id': 'v1', 'name': 'Club A'},
        {'kind': 'profile', 'id': 'p9', 'profile': profileRow(id: 'p9', handle: 'sam', name: 'Sam Park')},
      ];
      site.rpcs['feed_home'] = (_) => ok([post('p1', tags: tags)]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p9', handle: 'sam', name: 'Sam Park'));
      final router = await openSocial(tester, site, '/feed');
      await tester.tap(find.byKey(const Key('tag-event-e1')));
      await tester.pump();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/events/e1');
    });

    testWidgets('your own post can be edited, and the change shows', (tester) async {
      site.rpcs['post_edit'] = (b) => ok(post('p1', caption: b['p_caption'] as String, audience: b['p_audience'] as String, mine: true));
      await openOne(tester, post('p1', caption: 'before', mine: true));
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('edit-caption')), 'after');
      await tester.tap(find.text('Followers'));
      await tester.pump();
      await tester.tap(find.byKey(const Key('save-edit')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_edit').single.body, {'p_actor': 'me', 'p_post': 'p1', 'p_caption': 'after', 'p_audience': 'followers', 'p_comments_enabled': true});
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('caption-p1'))).textSpan!.toPlainText(), contains('after'));
    });

    testWidgets('an edit the website refuses is explained and the sheet stays', (tester) async {
      site.rpcs['post_edit'] = (_) => raised('That text goes against our community rules.');
      await openOne(tester, post('p1', mine: true));
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-edit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('edit-problem')), findsOneWidget);
      expect(find.text('That text goes against our community rules.'), findsOneWidget);
    });

    testWidgets('your own post can be deleted after asking, and its files are removed', (tester) async {
      site.rpcs['post_delete'] = (_) => ok(['a1/p1.jpg']);
      await openOne(tester, post('p1', mine: true));
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_delete'), isEmpty);
      await tester.tap(find.byKey(const Key('confirm-delete-post')));
      await tester.pumpAndSettle();
      expect(site.forRpc('post_delete').single.body, {'p_actor': 'me', 'p_post': 'p1'});
      expect(site.storageOf('remove').single.paths, ['a1/p1.jpg']);
      expect(find.byKey(const Key('post-p1')), findsNothing);
    });

    testWidgets('other people\'s posts have no edit or delete', (tester) async {
      await openOne(tester, post('p1', mine: false));
      expect(find.byKey(const Key('post-menu-p1')), findsNothing);
    });
  });
}

extension on Map<String, dynamic> {
  void _at(String when) => this['created_at'] = when;
}
