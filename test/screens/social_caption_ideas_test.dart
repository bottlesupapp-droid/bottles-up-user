import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:bottles_up_user/site/services/media_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  late FakeMediaPicker picker;
  late bool rulesAccepted;

  setUp(() {
    site = FakeWebsite();
    picker = FakeMediaPicker();
    rulesAccepted = true;
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': rulesAccepted});
    site.rpcs['rules_accept'] = (_) {
      rulesAccepted = true;
      return ok({'version': 1, 'accepted': true});
    };
    site.functions['suggest-caption'] = (_) => (status: 200, body: {'captions': ['Friday was a good one', 'Lights, music, friends', 'Again next week?']});
  });

  const on = {'social': true, 'ai_captions': true};

  Future<GoRouter> openCreate(WidgetTester tester, {Map<String, bool> features = on}) async {
    final router = await openSocial(tester, site, '/feed', features: features, overrides: [mediaPickerProvider.overrideWithValue(picker)]);
    router.push('/create');
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('caption-ideas')));
    await tester.tap(find.byKey(const Key('caption-ideas')));
    await tester.pumpAndSettle();
  }

  String caption(WidgetTester tester) => tester.widget<TextField>(find.byKey(const Key('caption-field'))).controller!.text;

  testWidgets('the button is there only while caption ideas are switched on', (tester) async {
    await openCreate(tester, features: const {'social': true});
    expect(find.byKey(const Key('caption-ideas')), findsNothing);
  });

  testWidgets('the sheet says the ideas come from an AI and need reading; asking needs a few words', (tester) async {
    await openCreate(tester);
    await openSheet(tester);
    expect(find.byKey(const Key('caption-ideas-sheet')), findsOneWidget);
    expect(find.byKey(const Key('ai-note')), findsOneWidget);
    expect(find.textContaining('written by an AI'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const Key('get-ideas'))).onPressed, isNull);
    await tester.enterText(find.byKey(const Key('idea-field')), 'ab');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byKey(const Key('get-ideas'))).onPressed, isNull);
    await tester.enterText(find.byKey(const Key('idea-field')), 'abc');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byKey(const Key('get-ideas'))).onPressed, isNotNull);
  });

  testWidgets('three ideas are offered, and choosing one fills the caption box without posting', (tester) async {
    site.rpcs['post_create'] = (_) => ok(postRow(id: 'new1', mine: true));
    await openCreate(tester);
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('idea-field')), 'Friday night with the crew');
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(site.forFunction('suggest-caption').single.body, {'idea': 'Friday night with the crew', 'kind': 'post'});
    for (var i = 0; i < 3; i++) {
      expect(find.byKey(Key('idea-$i')), findsOneWidget);
    }
    expect(find.text('Lights, music, friends'), findsOneWidget);
    await tester.tap(find.byKey(const Key('use-idea-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('caption-ideas-sheet')), findsNothing);
    expect(caption(tester), 'Lights, music, friends');
    expect(site.forRpc('post_create'), isEmpty, reason: 'nothing is posted by choosing an idea');
  });

  testWidgets('tapping the idea itself chooses it too; closing the sheet changes nothing', (tester) async {
    await openCreate(tester);
    await tester.enterText(find.byKey(const Key('caption-field')), 'my own words');
    await openSheet(tester);
    await tester.tapAt(const Offset(400, 100));
    await tester.pumpAndSettle();
    expect(caption(tester), 'my own words');
    await openSheet(tester);
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('idea-0')));
    await tester.pumpAndSettle();
    expect(caption(tester), 'Friday was a good one');
  });

  testWidgets('what is already in the caption box starts the idea, and a tagged place (not a tagged person) goes with it', (tester) async {
    site.tables['site_events'] = [eventRow(id: 'e1', title: 'Friday Night')];
    site.tables['site_venues'] = [];
    site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'p9', handle: 'sam', name: 'Sam Park')]);
    picker.photosToReturn = [const PickedMedia(path: '/tmp/none.jpg', type: 'image/jpeg', bytes: 8)];
    await openCreate(tester);
    await tester.enterText(find.byKey(const Key('caption-field')), 'dancing all night');
    await tester.ensureVisible(find.byKey(const Key('tag-button')));
    await tester.tap(find.byKey(const Key('tag-button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('tag-search')), 'sam');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tag-profile-p9')));
    await tester.tap(find.byKey(const Key('tag-event-e1')));
    await tester.tap(find.byKey(const Key('tags-done')));
    await tester.pumpAndSettle();
    await openSheet(tester);
    expect(tester.widget<TextField>(find.byKey(const Key('idea-field'))).controller!.text, 'dancing all night');
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(site.forFunction('suggest-caption').single.body, {'idea': 'dancing all night', 'kind': 'post', 'context': 'Friday Night'});
  });

  testWidgets('a refusal is shown under the box; trying again asks again', (tester) async {
    var fail = true;
    site.functions['suggest-caption'] = (_) => fail ? (status: 429, body: {'error': "You have used all of today's caption ideas. Try again tomorrow."}) : (status: 200, body: {'captions': ['Back again']});
    await openCreate(tester);
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('idea-field')), 'great night');
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ideas-problem')), findsOneWidget);
    expect(find.text("You have used all of today's caption ideas. Try again tomorrow."), findsOneWidget);
    fail = false;
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ideas-problem')), findsNothing);
    expect(find.text('Back again'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('when the writer has nothing it says so, with its own sentence', (tester) async {
    site.functions['suggest-caption'] = (_) => (status: 200, body: {'captions': [], 'message': 'We could not think of a caption for that. Try saying it a different way.'});
    await openCreate(tester);
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('idea-field')), 'great night');
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('no-ideas')), findsOneWidget);
    expect(find.textContaining('could not think of a caption'), findsOneWidget);
    expect(find.byKey(const Key('idea-0')), findsNothing);
  });

  testWidgets('the community rules come first, once', (tester) async {
    rulesAccepted = false;
    await openCreate(tester);
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('idea-field')), 'great night');
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('rules-text')), findsOneWidget);
    expect(site.forFunction('suggest-caption'), isEmpty);
    await tester.tap(find.byKey(const Key('rules-accept')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(site.forFunction('suggest-caption'), hasLength(1));
    expect(find.byKey(const Key('idea-0')), findsOneWidget);
  });

  testWidgets('a reel asks for a reel and a story for a story', (tester) async {
    final router = await openSocial(tester, site, '/feed', features: {...on, 'reels': true, 'stories': true}, overrides: [mediaPickerProvider.overrideWithValue(picker)]);
    router.push('/create?kind=reel');
    await tester.pumpAndSettle();
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('idea-field')), 'great night');
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-ideas')));
    await settleCalls(tester);
    await tester.pumpAndSettle();
    expect(site.forFunction('suggest-caption').single.body['kind'], 'reel');
  });
}
