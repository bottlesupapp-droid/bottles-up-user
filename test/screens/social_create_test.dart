import 'dart:io';

import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:bottles_up_user/site/services/media_picker.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  late Directory dir;
  late FakeMediaPicker picker;

  setUp(() {
    site = FakeWebsite();
    dir = Directory.systemTemp.createTempSync('create_test');
    picker = FakeMediaPicker();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['post_create'] = (b) => ok(postRow(id: 'new1', kind: b['p_kind'] as String, caption: b['p_caption'] as String?, mine: true));
    site.rpcs['post_get'] = (_) => ok(postRow(id: 'new1', mine: true));
    site.rpcs['comment_list'] = (_) => ok(<Object>[]);
  });
  tearDown(() => dir.deleteSync(recursive: true));

  PickedMedia photo(String name, {int bytes = 8, String type = 'image/jpeg'}) {
    final f = File('${dir.path}/$name')..writeAsBytesSync(List.filled(bytes, 3));
    return PickedMedia(path: f.path, type: type, bytes: bytes);
  }

  PickedMedia video(String name, {int ms = 20000, int bytes = 32}) {
    final f = File('${dir.path}/$name')..writeAsBytesSync(List.filled(bytes, 9));
    return PickedMedia(path: f.path, type: 'video/mp4', bytes: bytes, durationMs: ms, width: 720, height: 1280);
  }

  Future<GoRouter> openCreate(WidgetTester tester, {String kind = 'post', Map<String, bool> features = const {'social': true, 'reels': true, 'stories': true, 'members_only': true}, List<Map<String, dynamic>>? mine}) async {
    final router = await openSocial(tester, site, '/feed', features: features, mine: mine, overrides: [mediaPickerProvider.overrideWithValue(picker)]);
    router.push(kind == 'post' ? '/create' : '/create?kind=$kind');
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollUntilVisible(find.byKey(Key(key)), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  testWidgets('shows who is posting and offers Reel and Story only while they are on', (tester) async {
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    await openCreate(tester);
    expect(find.text('Posting as @dana'), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('kind-picker')), matching: find.text('Reel')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('kind-picker')), matching: find.text('Story')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('audience-picker')), matching: find.text('Members')), findsOneWidget);
  });

  testWidgets('with reels, stories and Members Only off those choices are not there', (tester) async {
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    await openCreate(tester, features: const {'social': true});
    expect(find.descendant(of: find.byKey(const Key('kind-picker')), matching: find.text('Reel')), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('kind-picker')), matching: find.text('Story')), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('audience-picker')), matching: find.text('Members')), findsNothing);
  });

  testWidgets('the audience hint says what each choice means', (tester) async {
    await openCreate(tester);
    expect(find.text(audienceHint(PostAudience.public)), findsOneWidget);
    await tester.tap(find.descendant(of: find.byKey(const Key('audience-picker')), matching: find.text('Members')));
    await tester.pump();
    expect(find.text(audienceHint(PostAudience.members)), findsOneWidget);
  });

  testWidgets('sharing with nothing chosen says what is missing', (tester) async {
    await openCreate(tester);
    await tapKey(tester, 'publish');
    expect(find.text('Add at least one photo.'), findsOneWidget);
    expect(site.storageOf('upload'), isEmpty);
    expect(site.forRpc('post_create'), isEmpty);
  });

  testWidgets('photos are uploaded one by one, then the post is made and opened', (tester) async {
    picker.photosToReturn = [photo('a.jpg'), photo('b.png', type: 'image/png')];
    final router = await openCreate(tester);
    await tapKey(tester, 'choose-media');
    await tester.pump();
    expect(find.byKey(const Key('picked-0')), findsOneWidget);
    expect(find.byKey(const Key('picked-1')), findsOneWidget);
    expect(picker.lastMax, 10);
    await tester.enterText(find.byKey(const Key('caption-field')), '  Friday vibes ');
    await tester.tap(find.descendant(of: find.byKey(const Key('audience-picker')), matching: find.text('Followers')));
    await tester.pump();
    await tapKey(tester, 'publish');
    await settleCalls(tester);
    await settleCalls(tester);
    final ups = site.storageOf('upload');
    expect(ups, hasLength(2));
    expect(ups[0].path, matches(RegExp(r'^me/[0-9a-f]{32}\.jpg$')));
    expect(ups[1].path, matches(RegExp(r'^me/[0-9a-f]{32}\.png$')));
    final body = site.forRpc('post_create').single.body;
    expect(body['p_actor'], 'me');
    expect(body['p_kind'], 'post');
    expect(body['p_caption'], 'Friday vibes');
    expect(body['p_audience'], 'followers');
    expect(body['p_comments_enabled'], true);
    expect([for (final m in body['p_media'] as List) (m as Map)['path']], [ups[0].path, ups[1].path]);
    expect([for (final m in body['p_media'] as List) (m as Map)['type']], ['image', 'image']);
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/post/new1');
  });

  testWidgets('a post can be left without comments', (tester) async {
    picker.photosToReturn = [photo('a.jpg')];
    await openCreate(tester);
    await tapKey(tester, 'choose-media');
    await tapKey(tester, 'comments-switch');
    await tapKey(tester, 'publish');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(site.forRpc('post_create').single.body['p_comments_enabled'], false);
  });

  testWidgets('a photo can be taken out before sharing', (tester) async {
    picker.photosToReturn = [photo('a.jpg'), photo('b.jpg')];
    await openCreate(tester);
    await tapKey(tester, 'choose-media');
    await tapKey(tester, 'remove-picked-0');
    expect(find.byKey(const Key('picked-0')), findsOneWidget);
    expect(find.byKey(const Key('picked-1')), findsNothing);
  });

  testWidgets('choosing more photos asks for only as many as there is room for', (tester) async {
    picker.photosToReturn = [for (var i = 0; i < 8; i++) photo('p$i.jpg')];
    await openCreate(tester);
    await tapKey(tester, 'choose-media');
    picker.photosToReturn = [for (var i = 0; i < 5; i++) photo('q$i.jpg')];
    await tapKey(tester, 'choose-media');
    expect(picker.lastMax, 2);
    expect(find.text('10 of 10 photos'), findsOneWidget);
    await tapKey(tester, 'choose-media');
    expect(find.text('You can add up to 10 photos.'), findsOneWidget);
  });

  testWidgets('a photo that is too big is refused with the reason, the others are kept', (tester) async {
    picker.photosToReturn = [photo('ok.jpg'), PickedMedia(path: '${dir.path}/huge.jpg', type: 'image/jpeg', bytes: maxImageBytes + 1)];
    await openCreate(tester);
    await tapKey(tester, 'choose-media');
    expect(find.text('A photo can be 10 MB at most.'), findsOneWidget);
    expect(find.byKey(const Key('picked-0')), findsOneWidget);
    expect(find.byKey(const Key('picked-1')), findsNothing);
  });

  testWidgets('a reel is one video of up to 60 seconds', (tester) async {
    picker.videoToReturn = video('long.mp4', ms: 61000);
    await openCreate(tester, kind: 'reel');
    await tapKey(tester, 'choose-media');
    expect(find.text('A video can be up to 60 seconds.'), findsOneWidget);
    expect(find.byKey(const Key('picked-0')), findsNothing);
    picker.videoToReturn = video('clip.mp4', ms: 30000);
    await tapKey(tester, 'choose-media');
    expect(find.byKey(const Key('picked-0')), findsOneWidget);
    expect(find.text('A video can be up to 60 seconds.'), findsNothing);
    await tapKey(tester, 'publish');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(site.storageOf('upload').single.path, endsWith('.mp4'));
    final body = site.forRpc('post_create').single.body;
    expect(body['p_kind'], 'reel');
    expect((body['p_media'] as List).single, containsPair('duration_ms', 30000));
    expect((body['p_media'] as List).single, containsPair('type', 'video'));
  });

  testWidgets('a story is shared and the creator closes with a note', (tester) async {
    picker.photosToReturn = [photo('s.jpg')];
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    final router = await openCreate(tester, kind: 'story');
    expect(find.text('Share to your story'), findsOneWidget);
    expect(find.byKey(const Key('comments-switch')), findsNothing, reason: 'a story has no comments');
    await tapKey(tester, 'choose-story-photo');
    await tapKey(tester, 'publish');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(site.forRpc('post_create').single.body['p_kind'], 'story');
    expect(site.forRpc('post_create').single.body['p_comments_enabled'], true);
    await tester.pumpAndSettle();
    expect(find.text('Your story is up for 24 hours.'), findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/feed');
  });

  testWidgets('switching the kind clears what was chosen', (tester) async {
    picker.photosToReturn = [photo('a.jpg')];
    await openCreate(tester);
    await tapKey(tester, 'choose-media');
    expect(find.byKey(const Key('picked-0')), findsOneWidget);
    await tester.tap(find.descendant(of: find.byKey(const Key('kind-picker')), matching: find.text('Reel')));
    await tester.pump();
    expect(find.byKey(const Key('picked-0')), findsNothing);
  });

  group('the community rules', () {
    testWidgets('are asked for before the first post, and posting carries on after accepting', (tester) async {
      var accepted = false;
      site.rpcs['rules_status'] = (_) => ok({'accepted': accepted});
      site.rpcs['rules_accept'] = (_) {
        accepted = true;
        return ok({'accepted': true});
      };
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      await tapKey(tester, 'publish');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(site.storageOf('upload'), isEmpty, reason: 'nothing is uploaded before the rules are accepted');
      await tester.tap(find.byKey(const Key('rules-accept')));
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.storageOf('upload'), hasLength(1));
      expect(site.forRpc('post_create'), hasLength(1));
    });

    testWidgets('not accepting posts nothing', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'accepted': false});
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      await tapKey(tester, 'publish');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('rules-decline')));
      await tester.pumpAndSettle();
      expect(site.storageOf('upload'), isEmpty);
      expect(site.forRpc('post_create'), isEmpty);
    });
  });

  group('when something goes wrong', () {
    testWidgets('an upload that fails says so, makes no post, and keeps what was chosen', (tester) async {
      site.failUploads = true;
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      await tapKey(tester, 'publish');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.text('We could not upload that. Check your connection and try again.'), findsOneWidget);
      expect(site.forRpc('post_create'), isEmpty);
      expect(find.byKey(const Key('picked-0')), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('publish'))).onPressed, isNotNull, reason: 'can try again');
    });

    testWidgets('a refusal from the website is shown and the photos are kept', (tester) async {
      site.rpcs['post_create'] = (_) => raised('That text goes against our community rules.');
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      await tapKey(tester, 'publish');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(find.text('That text goes against our community rules.'), findsOneWidget);
      expect(find.byKey(const Key('picked-0')), findsOneWidget);
    });

    testWidgets('a library that cannot be opened says so', (tester) async {
      picker = _ThrowingPicker();
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      expect(find.textContaining('could not open your photos'), findsOneWidget);
    });
  });

  group('tags', () {
    testWidgets('an event, a venue and a person can be tagged, and go with the post', (tester) async {
      site.tables['site_events'] = [eventRow(id: 'e1', title: 'Friday Night')];
      site.tables['site_venues'] = [venueRow(id: 'v1', name: 'Club A')];
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'p9', handle: 'sam', name: 'Sam Park')]);
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'choose-media');
      await tapKey(tester, 'tag-button');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tag-event-e1')));
      await tester.tap(find.byKey(const Key('tag-venue-v1')));
      await tester.enterText(find.byKey(const Key('tag-search')), 'sam');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tag-profile-p9')));
      await tester.pump();
      expect(find.text('Done (3)'), findsOneWidget);
      await tester.tap(find.byKey(const Key('tags-done')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('chosen-tag-event-e1')), findsOneWidget);
      expect(find.text('Tags (3)'), findsOneWidget);
      await tapKey(tester, 'publish');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forRpc('post_create').single.body['p_tags'], [
        {'kind': 'event', 'id': 'e1'},
        {'kind': 'venue', 'id': 'v1'},
        {'kind': 'profile', 'id': 'p9'},
      ]);
    });

    testWidgets('a tag can be taken off again', (tester) async {
      site.tables['site_events'] = [eventRow(id: 'e1', title: 'Friday Night')];
      picker.photosToReturn = [photo('a.jpg')];
      await openCreate(tester);
      await tapKey(tester, 'tag-button');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tag-event-e1')));
      await tester.tap(find.byKey(const Key('tags-done')));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.byKey(const Key('chosen-tag-event-e1')), matching: find.byTooltip('Delete')));
      await tester.pump();
      expect(find.byKey(const Key('chosen-tag-event-e1')), findsNothing);
    });
  });

  testWidgets('with a business profile one can choose which to post as', (tester) async {
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    picker.photosToReturn = [photo('a.jpg')];
    await openCreate(tester, mine: [myPersonal(), myBusiness()]);
    expect(find.text('Posting as @dana'), findsOneWidget);
    await tester.tap(find.byKey(const Key('change-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-djdana')));
    await tester.pumpAndSettle();
    expect(find.text('Posting as @djdana'), findsOneWidget);
    await tapKey(tester, 'choose-media');
    await tapKey(tester, 'publish');
    await settleCalls(tester);
    await settleCalls(tester);
    expect(site.forRpc('post_create').single.body['p_actor'], 'biz');
    expect(site.storageOf('upload').single.path, startsWith('biz/'));
  });

  testWidgets('nothing opens while social is off', (tester) async {
    await openSocial(tester, site, '/create', features: const {'social': false});
    expect(find.text('Coming soon'), findsOneWidget);
  });
}

class _ThrowingPicker extends FakeMediaPicker {
  @override
  Future<List<PickedMedia>> photos({required int max}) async => throw const SiteException('We could not open your photos. Check that BottlesUp may use them in Settings.');
}
