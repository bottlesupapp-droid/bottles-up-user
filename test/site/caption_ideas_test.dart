import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/rules/caption_rules.dart';
import 'package:bottles_up_user/site/services/caption_ideas_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

void main() {
  group('what is enough to ask with', () {
    test('three to three hundred characters, once the spaces are squeezed', () {
      expect(ideaIsEnough('ab'), isFalse);
      expect(ideaIsEnough('abc'), isTrue);
      expect(ideaIsEnough('   a   '), isFalse, reason: 'one letter and spaces');
      expect(ideaIsEnough('  a   b  '), isTrue, reason: 'a b is three characters once the spaces are squeezed');
      expect(ideaIsEnough('a' * ideaMax), isTrue);
      expect(ideaIsEnough('a' * (ideaMax + 1)), isFalse);
      expect(ideaIsEnough(''), isFalse);
    });
  });

  group('the service', () {
    late FakeWebsite site;
    late CaptionIdeasService service;

    setUp(() {
      site = FakeWebsite();
      service = CaptionIdeasService(site.client);
    });

    test('sends the words squeezed and trimmed, the kind, and the place only when there is one', () async {
      site.functions['suggest-caption'] = (_) => (status: 200, body: {'captions': ['One', 'Two']});
      await service.suggest(idea: '  Friday   night\nwith the crew ', kind: PostKind.reel, context: ' Club A ');
      await service.suggest(idea: 'Friday night', kind: PostKind.story, context: '   ');
      await service.suggest(idea: 'Friday night', kind: PostKind.post);
      final calls = site.forFunction('suggest-caption');
      expect(calls[0].body, {'idea': 'Friday night with the crew', 'kind': 'reel', 'context': 'Club A'});
      expect(calls[1].body, {'idea': 'Friday night', 'kind': 'story'});
      expect(calls[2].body, {'idea': 'Friday night', 'kind': 'post'});
    });

    test('gives back up to three trimmed captions, ignoring what is not text', () async {
      site.functions['suggest-caption'] = (_) => (status: 200, body: {'captions': ['  One ', '', 3, null, 'Two', 'Three', 'Four']});
      final ideas = await service.suggest(idea: 'abc', kind: PostKind.post);
      expect(ideas.captions, ['One', 'Two', 'Three']);
      expect(ideas.message, isNull);
    });

    test('nothing and a sentence', () async {
      site.functions['suggest-caption'] = (_) => (status: 200, body: {'captions': [], 'message': ' We could not think of a caption for that. '});
      final ideas = await service.suggest(idea: 'abc', kind: PostKind.post);
      expect(ideas.captions, isEmpty);
      expect(ideas.message, 'We could not think of a caption for that.');
    });

    test('an empty answer is no ideas; one that is not an object is an error', () async {
      site.functions['suggest-caption'] = (_) => (status: 200, body: <String, dynamic>{});
      expect((await service.suggest(idea: 'abc', kind: PostKind.post)).captions, isEmpty);
      site.functions['suggest-caption'] = (_) => (status: 200, body: [1, 2]);
      await expectLater(service.suggest(idea: 'abc', kind: PostKind.post), throwsA(isA<SiteException>()));
    });

    test('a refusal in words is shown as it came; a server fault is not', () async {
      site.functions['suggest-caption'] = (_) => (status: 429, body: {'error': "You have used all of today's caption ideas. Try again tomorrow."});
      await expectLater(service.suggest(idea: 'abc', kind: PostKind.post), throwsA(isA<SiteException>().having((e) => e.message, 'message', "You have used all of today's caption ideas. Try again tomorrow.")));
      site.functions['suggest-caption'] = (_) => (status: 403, body: {'error': 'Caption ideas are not open yet.'});
      await expectLater(service.suggest(idea: 'abc', kind: PostKind.post), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'Caption ideas are not open yet.')));
      site.functions['suggest-caption'] = (_) => (status: 502, body: {'error': 'We could not reach the caption writer just now. Try again in a moment.'});
      await expectLater(service.suggest(idea: 'abc', kind: PostKind.post), throwsA(isA<SiteException>().having((e) => e.message, 'message', contains('could not get caption ideas'))));
      site.networkDown = true;
      await expectLater(service.suggest(idea: 'abc', kind: PostKind.post), throwsA(isA<SiteException>()));
    });
  });

  group('against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String shared;
    setUpAll(() => shared = readFunctionFile('_shared/captionIdeas.ts'));

    test('the function exists and reads the fields the app sends', () {
      final fn = readFunction('suggest-caption');
      expect(fn, contains("callerClient.rpc('ai_caption_begin')"));
      expect(shared, contains('o.idea'));
      expect(shared, contains('o.kind'));
      expect(shared, contains('o.context'));
    });

    test('the limits are the same', () {
      expect(shared, contains('export const IDEA_MIN = $ideaMin;'));
      expect(shared, contains('export const IDEA_MAX = $ideaMax;'));
      expect(shared, contains('export const CONTEXT_MAX = $ideaContextMax;'));
      expect(shared, contains('export const CAPTION_COUNT = $ideasMax;'));
    });

    test('the kinds are the same as the app\'s post kinds', () {
      final m = RegExp(r"const KINDS: CaptionKind\[\] = \[([^\]]*)\]").firstMatch(shared)!;
      final kinds = {for (final k in RegExp("'([a-z]+)'").allMatches(m.group(1)!)) k.group(1)!};
      expect(kinds, {for (final k in PostKind.values) k.name});
    });

    test('the sentence the website gives for a day used up is the one the app shows people as it came', () {
      expect(allMigrations(), contains("raise exception 'You have used all of today''s caption ideas. Try again tomorrow.'"));
    });
  });
}
