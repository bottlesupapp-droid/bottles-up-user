import 'dart:async';

import 'package:bottles_up_user/site/models/safety.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_social.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';

void main() {
  late FakeWebsite site;
  late int rulesVersion;
  late String? rulesBody;
  late int acceptedVersion;

  setUp(() {
    site = FakeWebsite();
    rulesVersion = 1;
    rulesBody = null;
    acceptedVersion = 1;
    site.rpcs['report_create'] = (_) => ok({'id': 'r1', 'already': false});
    site.rpcs['rules_current'] = (_) => ok({'version': rulesVersion, 'body': rulesBody});
    site.rpcs['rules_status'] = (_) => ok({'version': rulesVersion, 'accepted': acceptedVersion >= rulesVersion});
    site.rpcs['rules_accept'] = (b) {
      if (b['p_version'] != rulesVersion) return raised('The community rules have changed. Read them again.');
      acceptedVersion = rulesVersion;
      return ok({'version': rulesVersion, 'accepted': true});
    };
  });

  const on = {'social': true, 'inbox': true, 'reviews': true, 'stories': true, 'reels': true};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  Future<void> choose(WidgetTester tester, String reason) async {
    await tester.tap(find.byKey(Key('reason-$reason')));
    await tester.pump();
  }

  Future<void> send(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('report-send')));
    await tester.tap(find.byKey(const Key('report-send')));
    await tester.pumpAndSettle();
  }

  Map<String, dynamic> bobPost({String id = 'p1', bool mine = false}) => postRow(id: id, mine: mine, author: profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray'));

  group('reporting a post', () {
    Future<GoRouter> openPost(WidgetTester tester, {Map<String, dynamic>? post}) {
      site.rpcs['post_get'] = (_) => ok(post ?? bobPost());
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      return openSocial(tester, site, '/post/p1', features: on);
    }

    testWidgets('the menu offers Report; the sheet needs a reason before it sends', (tester) async {
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('report-sheet')), findsOneWidget);
      expect(find.text('Report this post'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('report-send'))).onPressed, isNull);
      await choose(tester, 'scam');
      expect(tester.widget<FilledButton>(find.byKey(const Key('report-send'))).onPressed, isNotNull);
    });

    testWidgets('sending reports it as the acting profile, with the reason and the words, and says thanks', (tester) async {
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'hate');
      await tester.enterText(find.byKey(const Key('report-details')), '  They are insulting people  ');
      await send(tester);
      expect(site.forRpc('report_create').single.body, {'p_actor': 'me', 'p_kind': 'post', 'p_target': 'p1', 'p_reason': 'hate', 'p_details': 'They are insulting people'});
      expect(find.byKey(const Key('report-sheet')), findsNothing);
      expect(find.text('Thanks for telling us. Our team will take a look.'), findsOneWidget);
    });

    testWidgets('a report already sent says so, kindly', (tester) async {
      site.rpcs['report_create'] = (_) => ok({'id': 'r1', 'already': true});
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await send(tester);
      expect(find.text('You already reported this. Our team has it.'), findsOneWidget);
    });

    testWidgets('a refusal is shown in the sheet, which stays open with what was typed', (tester) async {
      site.rpcs['report_create'] = (_) => raised('You have sent a lot of reports today. Our team is looking at them.');
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.enterText(find.byKey(const Key('report-details')), 'keep me');
      await send(tester);
      expect(find.byKey(const Key('report-problem')), findsOneWidget);
      expect(find.text('You have sent a lot of reports today. Our team is looking at them.'), findsOneWidget);
      expect(find.byKey(const Key('report-sheet')), findsOneWidget);
      expect(tester.widget<TextField>(find.byKey(const Key('report-details'))).controller!.text, 'keep me');
      expect(tester.widget<FilledButton>(find.byKey(const Key('report-send'))).onPressed, isNotNull, reason: 'it can be tried again');
    });

    testWidgets('"also block" blocks the author after the report and leaves the post\'s page', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/feed', features: on);
      router.push('/post/p1');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'harassment');
      expect(find.text('Also block @bob'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(site.forRpc('report_create'), hasLength(1));
      expect(site.forRpc('block_set').single.body, {'p_actor': 'me', 'p_target': 'u-bob', 'p_blocked': true});
      expect(path(router), '/feed');
      expect(find.textContaining('They are blocked.'), findsOneWidget);
    });

    testWidgets('a block made here is in the blocked list at once', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      site.rpcs['block_list'] = (_) => ok(<Object>[]);
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/feed', features: on);
      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));
      final listening = container.listen(blockedProfilesProvider('me'), (_, __) {});
      addTearDown(listening.close);
      await tester.pumpAndSettle();
      expect(site.forRpc('block_list'), hasLength(1));
      router.push('/post/p1');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(site.forRpc('block_list'), hasLength(2), reason: 'the list is read again after the block');
    });

    testWidgets('without the tick nobody is blocked', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await send(tester);
      expect(site.forRpc('block_set'), isEmpty);
    });

    testWidgets('if blocking fails the report still went, and it says so', (tester) async {
      site.rpcs['block_set'] = (_) => raised('That did not work.');
      await openPost(tester);
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(find.textContaining('Thanks for telling us.'), findsOneWidget);
      expect(find.textContaining('We could not block them: That did not work.'), findsOneWidget);
    });

    testWidgets('your own post offers Edit and Delete, not Report', (tester) async {
      await openPost(tester, post: bobPost(mine: true));
      await tester.tap(find.byKey(const Key('post-menu-p1')));
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Report'), findsNothing);
    });
  });

  group('reporting a comment', () {
    Future<void> open(WidgetTester tester, List<Map<String, dynamic>> comments) async {
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (b) => ok(b['p_parent'] == null ? comments : <Object>[]);
      await openSocial(tester, site, '/post/p1', features: on);
    }

    testWidgets('someone else\'s comment has a menu; yours does not', (tester) async {
      await open(tester, [
        commentRow(id: 'c1', body: 'rude words', author: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam')),
        commentRow(id: 'c2', body: 'mine', author: profileRow(id: 'me', handle: 'dana', name: 'Dana'), mine: true, canDelete: true),
      ]);
      expect(find.byKey(const Key('comment-menu-c1')), findsOneWidget);
      expect(find.byKey(const Key('comment-menu-c2')), findsNothing);
    });

    testWidgets('reporting it sends the comment and offers to block its writer', (tester) async {
      await open(tester, [commentRow(id: 'c1', body: 'rude words', author: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam'))]);
      await tester.tap(find.byKey(const Key('comment-menu-c1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(find.text('Report this comment'), findsOneWidget);
      expect(find.text('Also block @sam'), findsOneWidget);
      await choose(tester, 'harassment');
      await send(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_kind', 'comment'));
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 'c1'));
    });

    testWidgets('blocking the writer takes their comment off the list', (tester) async {
      var blocked = false;
      site.rpcs['block_set'] = (_) {
        blocked = true;
        return ok({'blocked': true});
      };
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (b) => ok(b['p_parent'] == null && !blocked ? [commentRow(id: 'c1', body: 'rude words', author: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam'))] : <Object>[]);
      await openSocial(tester, site, '/post/p1', features: on);
      await tester.tap(find.byKey(const Key('comment-menu-c1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'harassment');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(find.byKey(const Key('comment-c1')), findsNothing);
    });
  });

  group('reporting a profile', () {
    testWidgets('the menu on someone else\'s profile has Block and Report', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park'));
      await openSocial(tester, site, '/u/sam', features: on);
      await tester.tap(find.byKey(const Key('profile-menu')));
      await tester.pumpAndSettle();
      expect(find.text('Block'), findsOneWidget);
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(find.text('Report this profile'), findsOneWidget);
      await choose(tester, 'impersonation');
      await send(tester);
      expect(site.forRpc('report_create').single.body, {'p_actor': 'me', 'p_kind': 'profile', 'p_target': 'u-sam', 'p_reason': 'impersonation', 'p_details': null});
    });

    testWidgets('someone already blocked can still be reported, without being offered a block', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park', blocked: true));
      await openSocial(tester, site, '/u/sam', features: on);
      await tester.tap(find.byKey(const Key('profile-menu')));
      await tester.pumpAndSettle();
      expect(find.text('Unblock'), findsWidgets);
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('report-also-block')), findsNothing);
    });

    testWidgets('your own profile has no menu to report yourself with', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true));
      await openSocial(tester, site, '/u/dana', features: on);
      expect(find.byKey(const Key('profile-menu')), findsNothing);
    });
  });

  group('reporting a message', () {
    Future<GoRouter> open(WidgetTester tester, List<Map<String, dynamic>> messages, {Map<String, dynamic>? head}) {
      site.rpcs['dm_conversation'] = (_) => ok(head ?? convRow(id: 'c1'));
      site.rpcs['dm_messages'] = (_) => ok(messages);
      site.rpcs['dm_mark_read'] = (_) => ok({'read': true});
      site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 0});
      site.rpcs['notifications_unread'] = (_) => ok(0);
      site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
      return openSocial(tester, site, '/inbox/c1', features: on);
    }

    testWidgets('long-pressing someone else\'s message reports it', (tester) async {
      await open(tester, [dmRow(id: 'm1', body: 'you will regret this')]);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      expect(find.text('Report this message'), findsOneWidget);
      await choose(tester, 'violence');
      await send(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_kind', 'message'));
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 'm1'));
      expect(site.forRpc('report_create').single.body, containsPair('p_reason', 'violence'));
    });

    testWidgets('your own message still offers to remove it, not to report it', (tester) async {
      await open(tester, [dmRow(id: 'm1', body: 'oops', mine: true)]);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('remove-message')), findsOneWidget);
      expect(find.byKey(const Key('report-sheet')), findsNothing);
    });

    testWidgets('a removed message has nothing to report', (tester) async {
      await open(tester, [dmRow(id: 'm1', body: null, removed: true)]);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('report-sheet')), findsNothing);
    });

    testWidgets('reporting and blocking in a one-to-one conversation leaves it', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      final router = await open(tester, [dmRow(id: 'm1', body: 'go away')]);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      await choose(tester, 'harassment');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(site.forRpc('block_set').single.body, containsPair('p_target', 'u-bob'));
      expect(path(router), '/inbox');
    });

    testWidgets('in a group, blocking one person does not end the group', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      final router = await open(tester, [dmRow(id: 'm1', body: 'rude')], head: convRow(id: 'c1', kind: 'group', title: 'Crew', members: 3));
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      await choose(tester, 'harassment');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(path(router), '/inbox/c1');
    });
  });

  group('reporting a review', () {
    testWidgets('someone else\'s review has a menu; yours has Delete', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [
            reviewRow(id: 'a', body: 'awful', author: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam')),
            reviewRow(id: 'b', body: 'fine', mine: true, author: profileRow(id: 'me', handle: 'dana', name: 'Dana')),
          ], count: 2, average: 3, stars: const [0, 0, 1, 0, 1]));
      await openSocial(tester, site, '/reviews/venue/v1', features: on);
      expect(find.byKey(const Key('review-menu-a')), findsOneWidget);
      expect(find.byKey(const Key('review-menu-b')), findsNothing);
      expect(find.byKey(const Key('delete-review-b')), findsOneWidget);
      await tester.tap(find.byKey(const Key('review-menu-a')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(find.text('Report this review'), findsOneWidget);
      await choose(tester, 'spam');
      await send(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_kind', 'review'));
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 'a'));
    });

    testWidgets('reporting and blocking a reviewer reads the list again', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      var blocked = false;
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [if (!blocked) reviewRow(id: 'a', body: 'awful', author: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam'))], count: blocked ? 0 : 1, average: 1, stars: const [1, 0, 0, 0, 0]));
      await openSocial(tester, site, '/reviews/venue/v1', features: on);
      final before = site.forRpc('reviews_list').length;
      await tester.tap(find.byKey(const Key('review-menu-a')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      blocked = true;
      await send(tester);
      expect(site.forRpc('reviews_list').length, greaterThan(before));
      expect(find.byKey(const Key('review-a')), findsNothing);
    });
  });

  group('reporting a story and a reel', () {
    testWidgets('a story has a flag; reporting it sends the story as a post', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      site.rpcs['stories_of'] = (_) => ok([
            {
              ...postRow(id: 's1', kind: 'story', caption: 'hi', expiresAt: '2099-10-25T22:00:00Z', media: [mediaRow(id: 'm-s1', path: 'a1/s1.jpg')]),
              'seen': false,
            }
          ]);
      site.rpcs['story_seen'] = (_) => ok({'seen': true});
      final router = await openSocial(tester, site, '/feed', features: on);
      router.push('/stories/ann');
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (find.byKey(const Key('report-story')).evaluate().isNotEmpty) break;
      }
      await tester.pump(const Duration(milliseconds: 150));
      await tester.tap(find.byKey(const Key('report-story')));
      await tester.pumpAndSettle();
      await choose(tester, 'sexual');
      await send(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_kind', 'post'));
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 's1'));
      expect(find.byKey(const Key('report-sheet')), findsNothing);
    });

    testWidgets('reporting a story and blocking its owner closes the viewer', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      site.rpcs['stories_of'] = (_) => ok([
            {
              ...postRow(id: 's1', kind: 'story', caption: 'hi', expiresAt: '2099-10-25T22:00:00Z', media: [mediaRow(id: 'm-s1', path: 'a1/s1.jpg')]),
              'seen': false,
            }
          ]);
      site.rpcs['story_seen'] = (_) => ok({'seen': true});
      final router = await openSocial(tester, site, '/feed', features: on);
      router.push('/stories/ann');
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (find.byKey(const Key('report-story')).evaluate().isNotEmpty) break;
      }
      await tester.pump(const Duration(milliseconds: 150));
      await tester.tap(find.byKey(const Key('report-story')));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('report-send')));
      await tester.tap(find.byKey(const Key('report-send')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(path(router), '/feed');
    });

    testWidgets('your own story has Delete and no flag', (tester) async {
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true));
      site.rpcs['stories_of'] = (_) => ok([
            {
              ...postRow(id: 's1', kind: 'story', mine: true, expiresAt: '2099-10-25T22:00:00Z', media: [mediaRow(id: 'm-s1', path: 'a1/s1.jpg')]),
              'seen': false,
            }
          ]);
      site.rpcs['story_seen'] = (_) => ok({'seen': true});
      final router = await openSocial(tester, site, '/feed', features: on);
      router.push('/stories/dana');
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (find.byKey(const Key('delete-story')).evaluate().isNotEmpty) break;
      }
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byKey(const Key('delete-story')), findsOneWidget);
      expect(find.byKey(const Key('report-story')), findsNothing);
    });

    testWidgets('reporting a reel and blocking its owner leaves the reels', (tester) async {
      site.rpcs['block_set'] = (_) => ok({'blocked': true});
      site.rpcs['feed_home'] = (_) => ok(<Object>[]);
      site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
      site.rpcs['feed_reels'] = (_) => ok([postRow(id: 'r1', kind: 'reel', caption: 'on stage', media: [mediaRow(id: 'm-r1', type: 'video', path: 'a1/r1.mp4', durationMs: 10000)])]);
      final router = await openSocial(tester, site, '/feed', features: on);
      router.push('/reels');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reel-report-r1')));
      await tester.pumpAndSettle();
      await choose(tester, 'spam');
      await tester.ensureVisible(find.byKey(const Key('report-also-block')));
      await tester.tap(find.byKey(const Key('report-also-block')));
      await tester.pump();
      await send(tester);
      expect(path(router), '/feed');
    });

    testWidgets('a reel has a flag on someone else\'s reel', (tester) async {
      site.rpcs['feed_reels'] = (_) => ok([
            postRow(id: 'r1', kind: 'reel', caption: 'on stage', media: [mediaRow(id: 'm-r1', type: 'video', path: 'a1/r1.mp4', durationMs: 10000)]),
            postRow(id: 'r2', kind: 'reel', caption: 'mine', mine: true, media: [mediaRow(id: 'm-r2', type: 'video', path: 'a1/r2.mp4', durationMs: 10000)]),
          ]);
      await openSocial(tester, site, '/reels', features: on);
      await tester.tap(find.byKey(const Key('reel-report-r1')));
      await tester.pumpAndSettle();
      expect(find.text('Report this post'), findsOneWidget);
      await choose(tester, 'spam');
      await send(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 'r1'));
      await tester.fling(find.byKey(const Key('reels-pager')), const Offset(0, -600), 2000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reel-report-r2')), findsNothing);
    });
  });

  group('the community rules', () {
    Future<void> comment(WidgetTester tester) async {
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      site.rpcs['comment_add'] = (b) => ok(commentRow(id: 'c9', body: b['p_body'] as String, author: profileRow(id: 'me', handle: 'dana', name: 'Dana'), mine: true));
      await openSocial(tester, site, '/post/p1', features: on);
      await tester.enterText(find.byKey(const Key('comment-field')), 'hello');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pumpAndSettle();
    }

    testWidgets('until BottlesUp publishes its own, the app\'s draft is shown and version 1 is accepted', (tester) async {
      acceptedVersion = 0;
      await comment(tester);
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(find.textContaining('Be kind.'), findsOneWidget);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('rules_accept').single.body, {'p_version': 1});
      expect(site.forRpc('comment_add'), hasLength(1));
    });

    testWidgets('BottlesUp\'s own text is shown, and the version the person read is the one accepted', (tester) async {
      rulesVersion = 7;
      rulesBody = 'Our house rules: respect everyone.';
      acceptedVersion = 0;
      await comment(tester);
      expect(find.text('Our house rules: respect everyone.'), findsOneWidget);
      expect(find.textContaining('Be kind.'), findsNothing);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('rules_accept').single.body, {'p_version': 7});
      expect(site.forRpc('comment_add'), hasLength(1));
    });

    testWidgets('new rules ask again, even from someone who accepted the old ones', (tester) async {
      acceptedVersion = 1;
      rulesVersion = 2;
      rulesBody = 'New rules, please read them.';
      await comment(tester);
      expect(find.text('New rules, please read them.'), findsOneWidget);
      expect(site.forRpc('comment_add'), isEmpty);
    });

    testWidgets('if the rules change while the dialog is open, the new text is shown and accepting is tried again', (tester) async {
      rulesVersion = 2;
      rulesBody = 'Version two.';
      acceptedVersion = 0;
      var first = true;
      site.rpcs['rules_accept'] = (b) {
        if (first) {
          first = false;
          rulesVersion = 3;
          rulesBody = 'Version three.';
          return raised('The community rules have changed. Read them again.');
        }
        acceptedVersion = rulesVersion;
        return ok({'version': rulesVersion, 'accepted': true});
      };
      await comment(tester);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(find.text('The community rules have changed. Read them again.'), findsOneWidget);
      expect(find.text('Version three.'), findsOneWidget);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('rules_accept').map((c) => c.body['p_version']), [2, 3]);
      expect(site.forRpc('comment_add'), hasLength(1));
    });

    testWidgets('if the rules cannot be loaded, the person can try again and cannot accept what they have not read', (tester) async {
      acceptedVersion = 0;
      var fail = true;
      site.rpcs['rules_current'] = (_) => fail ? raised('We could not load the community rules.') : ok({'version': 1, 'body': null});
      await comment(tester);
      expect(find.byKey(const Key('rules-load-problem')), findsOneWidget);
      expect(find.byKey(const Key('rules-accept')), findsNothing);
      fail = false;
      await tester.tap(find.byKey(const Key('rules-retry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-accept')), findsOneWidget);
    });

    testWidgets('while the rules are still loading, "I agree" cannot be pressed', (tester) async {
      acceptedVersion = 0;
      site.rpcs['post_get'] = (_) => ok(bobPost());
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/post/p1', features: on, overrides: [communityRulesProvider.overrideWith((ref) => Completer<CommunityRules>().future)]);
      await tester.enterText(find.byKey(const Key('comment-field')), 'hello');
      await tester.tap(find.byKey(const Key('send-comment')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const Key('rules-accept')), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('rules-accept'))).onPressed, isNull);
      expect(site.forRpc('rules_accept'), isEmpty);
    });

    testWidgets('the rules page shows the published text to anyone, and how to report and block', (tester) async {
      rulesVersion = 2;
      rulesBody = 'Our house rules.';
      await openSocial(tester, site, '/rules', features: on);
      expect(find.text('Our house rules.'), findsOneWidget);
      expect(find.textContaining('You can report any post'), findsOneWidget);
    });

    testWidgets('...or the draft until there is one; a failure offers to try again', (tester) async {
      await openSocial(tester, site, '/rules', features: on);
      expect(find.textContaining('Be kind.'), findsOneWidget);
    });

    testWidgets('the rules page can fail and be retried', (tester) async {
      var fail = true;
      site.rpcs['rules_current'] = (_) => fail ? raised('We could not load the community rules.') : ok({'version': 2, 'body': 'Back again.'});
      await openSocial(tester, site, '/rules', features: on);
      expect(find.text('We could not load the community rules.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await tester.pumpAndSettle();
      expect(find.text('Back again.'), findsOneWidget);
    });
  });

  testWidgets('the profile tab links to the community rules', (tester) async {
    final router = await openSocial(tester, site, '/', features: on, home: const SocialEntryCard());
    await tester.ensureVisible(find.byKey(const Key('open-rules')));
    await tester.tap(find.byKey(const Key('open-rules')));
    await tester.pumpAndSettle();
    expect(path(router), '/rules');
  });

  testWidgets('the blocked list says a block covers all of a person\'s profiles', (tester) async {
    site.rpcs['block_list'] = (_) => ok(<Object>[]);
    await openSocial(tester, site, '/people/blocked', features: on);
    expect(find.textContaining('hides all of their profiles'), findsOneWidget);
  });
}
