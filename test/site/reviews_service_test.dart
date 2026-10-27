import 'package:bottles_up_user/site/models/review.dart';
import 'package:bottles_up_user/site/services/reviews_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late ReviewsService service;

  setUp(() {
    site = FakeWebsite();
    service = ReviewsService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  test('asks whether a profile may review', () async {
    site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'You can review a venue after a night you booked there.', 'mine': null});
    final e = await service.eligibility(actor: 'me', kind: ReviewKind.venue, target: 'v1');
    expect(e.eligible, isFalse);
    expect(site.forRpc('review_eligibility').single.body, {'p_actor': 'me', 'p_kind': 'venue', 'p_target': 'v1'});
  });

  test('saves a review, trimming the words', () async {
    site.rpcs['review_save'] = (_) => ok(reviewRow(mine: true));
    final r = await service.save(actor: 'me', kind: ReviewKind.event, target: 'e1', rating: 4, body: '  Great  ');
    expect(r.isMine, isTrue);
    expect(site.forRpc('review_save').single.body, {'p_actor': 'me', 'p_kind': 'event', 'p_target': 'e1', 'p_rating': 4, 'p_body': 'Great'});
  });

  test('the website\'s refusals are shown', () async {
    site.rpcs['review_save'] = (_) => raised('You can review a venue after a night you booked there.');
    await expectLater(service.save(actor: 'me', kind: ReviewKind.venue, target: 'v1', rating: 5), sentence('You can review a venue after a night you booked there.'));
    site.rpcs['review_save'] = (_) => raised('Read and accept the community rules first.');
    await expectLater(service.save(actor: 'me', kind: ReviewKind.venue, target: 'v1', rating: 5), sentence('Read and accept the community rules first.'));
  });

  test('an answer that is not a review is an error', () async {
    site.rpcs['review_save'] = (_) => ok({'oops': 1});
    await expectLater(service.save(actor: 'me', kind: ReviewKind.venue, target: 'v1', rating: 5), throwsA(isA<SiteException>()));
  });

  test('deleting, replying, removing a reply', () async {
    site.rpcs['review_delete'] = (_) => ok({'deleted': true});
    site.rpcs['review_reply'] = (_) => ok(reviewRow(canReply: true));
    site.rpcs['review_reply_delete'] = (_) => ok({'deleted': true});
    await service.delete(actor: 'me', review: 'r1');
    await service.reply(actor: 'biz', review: 'r1', body: ' Thanks ');
    await service.deleteReply(actor: 'biz', review: 'r1');
    expect(site.forRpc('review_delete').single.body, {'p_actor': 'me', 'p_review': 'r1'});
    expect(site.forRpc('review_reply').single.body, {'p_actor': 'biz', 'p_review': 'r1', 'p_body': 'Thanks'});
    expect(site.forRpc('review_reply_delete').single.body, {'p_actor': 'biz', 'p_review': 'r1'});
  });

  test('a page of reviews pages after the last one seen, to the microsecond', () async {
    site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'a', createdAt: '2099-10-24T23:00:00.123456Z')], count: 1, average: 4, stars: [0, 0, 0, 1, 0]));
    final first = await service.reviews(actor: 'me', kind: ReviewKind.venue, target: 'v1');
    expect(first.summary.count, 1);
    expect(site.forRpc('reviews_list').single.body, {'p_actor': 'me', 'p_kind': 'venue', 'p_target': 'v1', 'p_limit': 20, 'p_before': null, 'p_before_id': null});
    await service.reviews(actor: 'me', kind: ReviewKind.venue, target: 'v1', after: first.items.last);
    expect(site.forRpc('reviews_list').last.body['p_before'], '2099-10-24T23:00:00.123456Z');
    expect(site.forRpc('reviews_list').last.body['p_before_id'], 'a');
  });

  test('a failed list of reviews says to check the connection', () async {
    site.networkDown = true;
    await expectLater(service.reviews(actor: 'me', kind: ReviewKind.venue, target: 'v1'), throwsA(isA<SiteException>()));
  });

  group('quiet reads', () {
    test('ratings are asked for the venues on screen', () async {
      site.rpcs['venue_ratings'] = (_) => ok({'v1': {'count': 2, 'average': 4.0}});
      final r = await service.ratings(['v1', 'v2']);
      expect(r['v1']!.count, 2);
      expect(site.forRpc('venue_ratings').single.body, {'p_venues': ['v1', 'v2']});
      expect(await service.ratings(const []), isEmpty);
      expect(site.forRpc('venue_ratings'), hasLength(1), reason: 'no venues, no question');
    });

    test('ratings and hot lists fail quietly: a card just shows no stars', () async {
      site.networkDown = true;
      expect(await service.ratings(['v1']), isEmpty);
      expect(await service.hotVenues(), isEmpty);
      expect(await service.hotEvents(), isEmpty);
    });

    test('hot venues and events', () async {
      site.rpcs['explore_hot_venues'] = (_) => ok([{'id': 'v1', 'score': 9}]);
      site.rpcs['explore_hot_events'] = (_) => ok([{'id': 'e1', 'score': 5}]);
      expect((await service.hotVenues()).single.id, 'v1');
      expect((await service.hotEvents(limit: 3)).single.score, 5);
      expect(site.forRpc('explore_hot_events').single.body, {'p_limit': 3});
    });
  });

  test('the directory', () async {
    site.rpcs['explore_professionals'] = (_) => ok([profileRow(id: 'p1', kind: 'business', handle: 'djann', category: 'dj')]);
    final r = await service.professionals(actor: 'me', category: 'dj', city: ' Toronto ', query: '  ', limit: 5, offset: 10);
    expect(r.single.handle, 'djann');
    expect(site.forRpc('explore_professionals').single.body, {'p_actor': 'me', 'p_category': 'dj', 'p_city': 'Toronto', 'p_query': null, 'p_limit': 5, 'p_offset': 10});
  });

  test('a category the website does not know is explained', () async {
    site.rpcs['explore_professionals'] = (_) => raised('Choose a kind of professional from the list.');
    await expectLater(service.professionals(actor: 'me', category: 'wizard'), sentence('Choose a kind of professional from the list.'));
  });
}
