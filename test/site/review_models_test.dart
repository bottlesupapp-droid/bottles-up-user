import 'package:bottles_up_user/site/models/review.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/rules/event_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('reviews', () {
    test('a review with its reply', () {
      final r = parseReview(reviewRow(
        id: 'r9',
        kind: 'event',
        rating: 5,
        mine: true,
        canReply: true,
        reply: {'body': 'Thank you!', 'created_at': '2099-10-25T10:00:00Z', 'author': profileRow(id: 'v1', handle: 'clubaclub', name: 'Club A', kind: 'business')},
      ))!;
      expect(r.kind, ReviewKind.event);
      expect(r.rating, 5);
      expect(r.isMine && r.canReply, isTrue);
      expect(r.reply!.body, 'Thank you!');
      expect(r.reply!.author.handle, 'clubaclub');
      expect(r.author.handle, 'ann');
    });

    test('a review without words is fine; without a rating, an author or a time it is dropped', () {
      expect(parseReview(reviewRow(body: null))!.body, isNull);
      expect(parseReview(reviewRow(rating: 0)), isNull);
      expect(parseReview(reviewRow(rating: 6)), isNull);
      expect(parseReview(reviewRow()..remove('author')), isNull);
      expect(parseReview({...reviewRow(), 'created_at': 'soon'}), isNull);
      expect(parseReview({...reviewRow(), 'kind': 'bar'}), isNull);
      expect(parseReview('x'), isNull);
    });

    test('a reply that cannot be read is left off, the review stays', () {
      final r = parseReview(reviewRow(reply: {'body': '  ', 'created_at': '2099-10-25T10:00:00Z', 'author': profileRow()}))!;
      expect(r.reply, isNull);
    });

    test('the summary', () {
      final s = parseReviewSummary({'count': 12, 'average': 4.3, 'stars': [0, 1, 2, 4, 5]});
      expect(s.count, 12);
      expect(s.average, 4.3);
      expect(s.stars, [0, 1, 2, 4, 5]);
      expect(parseReviewSummary({'count': 1, 'average': '4', 'stars': [1]}).stars, [0, 0, 0, 0, 0], reason: 'a bad list of stars is zeros');
      expect(parseReviewSummary(null).count, 0);
    });

    test('a page', () {
      final p = parseReviewsPage(reviewsPage(items: [reviewRow(id: 'a'), reviewRow(rating: 9, id: 'bad'), reviewRow(id: 'b')], count: 2, average: 4));
      expect([for (final r in p.items) r.id], ['a', 'b']);
      expect(p.summary.count, 2);
      expect(parseReviewsPage(null).items, isEmpty);
    });

    test('eligibility', () {
      final yes = parseReviewEligibility({'eligible': true, 'reason': null, 'mine': 'r1'});
      expect(yes.eligible && yes.mineId == 'r1', isTrue);
      final no = parseReviewEligibility({'eligible': false, 'reason': 'You can review a venue after a night you booked there.'});
      expect(no.eligible, isFalse);
      expect(no.reason, contains('after a night'));
      expect(parseReviewEligibility('x').eligible, isFalse, reason: 'unreadable means no');
      expect(parseReviewEligibility({'eligible': 'true'}).eligible, isFalse);
    });

    test('hot lists and ratings', () {
      expect([for (final h in parseHotItems([{'id': 'a', 'score': 9}, 'x', {'score': 1}, {'id': 'b', 'score': '3'}])) '${h.id}:${h.score}'], ['a:9', 'b:3']);
      expect(parseHotItems(null), isEmpty);
      final r = parseVenueRatings({'v1': {'count': 3, 'average': 4.5}, 'v2': {'count': 0, 'average': 0}, 'v3': 'x', 'v4': {'count': 2}});
      expect(r.keys, ['v1']);
      expect(r['v1']!.average, 4.5);
      expect(parseVenueRatings(null), isEmpty);
    });
  });

  group('venue facts', () {
    Map<String, dynamic> row(Map<String, dynamic> extra) => {...venueRow(), ...extra};

    test('are read from the venue', () {
      final v = parseVenue(row({'amenities': ['wifi', 'parking', 'helipad'], 'parking_info': 'Lot behind', 'min_age': 19, 'id_required': true, 'last_entry': '1:30 AM', 'kitchen_hours': '6 to 11', 'menu_url': 'https://x.example/menu'}))!;
      expect(v.amenities, ['wifi', 'parking'], reason: 'a feature the app does not know is ignored');
      expect(v.parkingInfo, 'Lot behind');
      expect(v.minAge, 19);
      expect(v.idRequired, isTrue);
      expect(v.lastEntry, '1:30 AM');
      expect(v.kitchenHours, '6 to 11');
      expect(v.menuUrl, 'https://x.example/menu');
    });

    test('are nothing when the venue has set nothing', () {
      final v = parseVenue(venueRow())!;
      expect(v.amenities, isEmpty);
      expect(v.minAge, isNull);
      expect(v.idRequired, isFalse);
      expect(v.menuUrl, isNull);
    });

    test('a menu link that is not secure is not kept', () {
      expect(parseVenue(row({'menu_url': 'http://x.example/menu'}))!.menuUrl, isNull);
      expect(parseVenue(row({'menu_url': 'javascript:alert(1)'}))!.menuUrl, isNull);
    });
  });

  group('event filters', () {
    SiteEvent ev(String id, {List<Map<String, dynamic>>? tiers}) => parseSiteEvent({...eventRow(id: id), 'tiers': tiers ?? [tierRow()]})!;

    test('by price', () {
      final free = ev('free', tiers: [tierRow(id: 't1', price: 0)]);
      final cheap = ev('cheap', tiers: [tierRow(id: 't2', price: 2500)]);
      final dear = ev('dear', tiers: [tierRow(id: 't3', price: 8000)]);
      final none = ev('none', tiers: const []);
      final all = [free, cheap, dear, none];
      expect([for (final e in filterEventsByPrice(all, PriceFilter.any)) e.id], ['free', 'cheap', 'dear', 'none']);
      expect([for (final e in filterEventsByPrice(all, PriceFilter.free)) e.id], ['free']);
      expect([for (final e in filterEventsByPrice(all, PriceFilter.under30)) e.id], ['free', 'cheap']);
    });

    test('only what has tickets left', () {
      final open = ev('open', tiers: [tierRow(id: 't1', capacity: 10, sold: 3)]);
      final sold = ev('sold', tiers: [tierRow(id: 't2', capacity: 10, sold: 10)]);
      final soon = ev('soon', tiers: const []);
      expect([for (final e in onlyAvailableEvents([open, sold, soon])) e.id], ['open', 'soon']);
    });

    test('hot order keeps the order of the list and skips what was not loaded', () {
      expect(inHotOrder<String>(['a', 'b', 'c'], (x) => x, ['c', 'zzz', 'a']), ['c', 'a']);
      expect(inHotOrder<String>(['a'], (x) => x, const []), isEmpty);
    });
  });
}
