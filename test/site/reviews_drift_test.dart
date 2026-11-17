import 'package:bottles_up_user/site/models/review.dart';
import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/rules/profile_rules.dart';
import 'package:bottles_up_user/site/services/reviews_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's reviews and explore migration.
void main() {
  group('reviews and explore against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('explore_reviews'));

    test('every function the app calls exists with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = ReviewsService(site.client);
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true});
      for (final n in ['review_save', 'review_reply']) {
        site.rpcs[n] = (_) => ok(reviewRow());
      }
      site.rpcs['review_delete'] = (_) => ok({'deleted': true});
      site.rpcs['review_reply_delete'] = (_) => ok({'deleted': true});
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['venue_ratings'] = (_) => ok(<String, Object>{});
      site.rpcs['explore_hot_venues'] = (_) => ok(<Object>[]);
      site.rpcs['explore_hot_events'] = (_) => ok(<Object>[]);
      site.rpcs['explore_professionals'] = (_) => ok(<Object>[]);

      final page = await (() async {
        site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow()], count: 1, average: 4));
        return service.reviews(actor: 'a', kind: ReviewKind.venue, target: 't');
      })();
      await service.eligibility(actor: 'a', kind: ReviewKind.event, target: 't');
      await service.save(actor: 'a', kind: ReviewKind.venue, target: 't', rating: 3, body: 'x');
      await service.delete(actor: 'a', review: 'r');
      await service.reply(actor: 'a', review: 'r', body: 'x');
      await service.deleteReply(actor: 'a', review: 'r');
      await service.reviews(actor: 'a', kind: ReviewKind.venue, target: 't', after: page.items.last);
      await service.ratings(['v']);
      await service.hotVenues();
      await service.hotEvents();
      await service.professionals(actor: 'a', category: 'dj', city: 'x', query: 'y', offset: 1);

      expect(site.rpcRequests.map((r) => r.name).toSet(), hasLength(10));
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('the venue features the app knows are the website\'s, with a name for each', () {
      final fromCheck = sqlWordsInBrackets(sql, 'amenities <@ array[');
      expect(venueAmenityKeys.toSet(), fromCheck);
      expect(venueAmenityLabels.keys.toSet(), fromCheck);
      final inFunction = sqlWordsInBrackets(sql.substring(sql.indexOf('create function public.save_venue_facts')), 'if not (v_amenities <@ array[');
      expect(inFunction, fromCheck);
    });

    test('the columns the app reads from a venue exist', () {
      final cols = columnsOf('site_venues');
      for (final c in ['amenities', 'parking_info', 'min_age', 'id_required', 'last_entry', 'kitchen_hours', 'menu_url']) {
        expect(cols, contains(c));
      }
    });

    test('a review has the limits the app says', () {
      expect(sql, contains('char_length(btrim(body)) between 1 and 1000'));
      expect(sql, contains("raise exception 'A review can be 1000 characters at most.'"));
      expect(sql, contains("raise exception 'Choose 1 to 5 stars.'"));
      expect(sql, contains('rating smallint not null check (rating between 1 and 5)'));
    });

    test('the directory\'s categories are the profile categories without a venue', () {
      final inDirectory = sqlWordsAfter(sql.substring(sql.indexOf('create function public.explore_professionals')), 'v_category not in');
      expect(inDirectory, {for (final c in profileCategories) if (c.key != 'venue') c.key});
    });
  });
}
