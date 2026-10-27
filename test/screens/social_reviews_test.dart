import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:bottles_up_user/features/tables/screens/tables_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['get_unavailable_table_types'] = (_) => ok(<String>[]);
    site.rpcs['public_venue_refund_policy'] = (_) => ok(<Object>[]);
    site.rpcs['rules_status'] = (_) => ok({'accepted': true});
  });

  const on = {'social': true, 'reviews': true};

  Future<void> openVenue(WidgetTester tester, {Map<String, dynamic> venue = const {}, List<Map<String, dynamic>>? mine, Map<String, bool> features = on}) async {
    site.tables['site_venues'] = [
      {...venueRow(), ...venue}
    ];
    await openSocial(tester, site, '/venues/v1', features: features, mine: mine);
  }

  group('what a venue says about itself', () {
    testWidgets('amenities, age and ID, last entry, parking, kitchen and a menu', (tester) async {
      final opened = <Uri>[];
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'x'});
      site.tables['site_venues'] = [
        {...venueRow(), 'amenities': ['wifi', 'coat_check'], 'min_age': 19, 'id_required': true, 'last_entry': '1:30 AM', 'parking_info': 'Lot behind the club', 'kitchen_hours': '6 PM to 11 PM', 'menu_url': 'https://club.example/menu'}
      ];
      await openSocial(tester, site, '/venues/v1', features: on, opened: opened);
      expect(find.byKey(const Key('amenity-wifi')), findsOneWidget);
      expect(find.byKey(const Key('amenity-coat_check')), findsOneWidget);
      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('venue-age'))).data, '19+ · ID required');
      expect(find.text('Last entry 1:30 AM'), findsOneWidget);
      expect(find.text('Lot behind the club'), findsOneWidget);
      expect(find.text('Kitchen: 6 PM to 11 PM'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('venue-menu')));
      await tester.tap(find.byKey(const Key('venue-menu')));
      await tester.pump();
      expect(opened.single.toString(), 'https://club.example/menu');
    });

    testWidgets('only ID required is said alone; nothing set shows nothing', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'x'});
      await openVenue(tester, venue: {'id_required': true});
      expect(tester.widget<Text>(find.byKey(const Key('venue-age'))).data, 'ID required');
      await tester.pumpWidget(const SizedBox());
      site = FakeWebsite();
      site.rpcs['get_unavailable_table_types'] = (_) => ok(<String>[]);
      site.rpcs['public_venue_refund_policy'] = (_) => ok(<Object>[]);
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'x'});
      await openVenue(tester);
      expect(find.byKey(const Key('venue-facts')), findsNothing);
    });
  });

  group('reviews on a venue page', () {
    testWidgets('are summed up, the latest are listed, and all can be opened', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(
            items: [for (var i = 0; i < 5; i++) reviewRow(id: 'r$i', body: 'review $i', rating: 4)],
            count: 12,
            average: 4.2,
            stars: const [0, 1, 2, 4, 5],
          ));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'You can review a venue after a night you booked there.'});
      await openVenue(tester);
      expect(tester.widget<Text>(find.byKey(const Key('reviews-summary'))).data, '4.2 (12)');
      expect(find.byKey(const Key('review-r0')), findsOneWidget);
      expect(find.byKey(const Key('review-r2')), findsOneWidget);
      expect(find.byKey(const Key('review-r3')), findsNothing, reason: 'three are shown here');
      expect(find.text('See all 12 reviews'), findsOneWidget);
      expect(find.byKey(const Key('write-review')), findsNothing);
      expect(find.text('You can review a venue after a night you booked there.'), findsOneWidget);
      expect(site.forRpc('reviews_list').single.body, {'p_actor': 'me', 'p_kind': 'venue', 'p_target': 'v1', 'p_limit': 5, 'p_before': null, 'p_before_id': null});
    });

    testWidgets('no reviews yet says so', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'x'});
      await openVenue(tester);
      expect(find.byKey(const Key('no-reviews')), findsOneWidget);
    });

    testWidgets('a person who was there writes one: stars, words, saved', (tester) async {
      var saved = false;
      site.rpcs['reviews_list'] = (_) => ok(saved ? reviewsPage(items: [reviewRow(id: 'new', body: 'Loved it', rating: 5, mine: true)], count: 1, average: 5, stars: const [0, 0, 0, 0, 1]) : reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true, 'reason': null, 'mine': saved ? 'new' : null});
      site.rpcs['review_save'] = (_) {
        saved = true;
        return ok(reviewRow(id: 'new', body: 'Loved it', rating: 5, mine: true));
      };
      await openVenue(tester);
      await tester.ensureVisible(find.byKey(const Key('write-review')));
      await tester.tap(find.byKey(const Key('write-review')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-review')));
      await tester.pumpAndSettle();
      expect(find.text('Choose 1 to 5 stars.'), findsOneWidget);
      expect(site.forRpc('review_save'), isEmpty);
      await tester.tap(find.byKey(const Key('star-5')));
      await tester.enterText(find.byKey(const Key('review-field')), '  Loved it ');
      await tester.tap(find.byKey(const Key('save-review')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_save').single.body, {'p_actor': 'me', 'p_kind': 'venue', 'p_target': 'v1', 'p_rating': 5, 'p_body': 'Loved it'});
      expect(find.byKey(const Key('review-new')), findsOneWidget);
      expect(find.text('Change your review'), findsOneWidget);
    });

    testWidgets('changing it starts from what was written', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'mine', body: 'Good', rating: 3, mine: true)], count: 1, average: 3, stars: const [0, 0, 1, 0, 0]));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true, 'mine': 'mine'});
      site.rpcs['review_save'] = (_) => ok(reviewRow(id: 'mine', rating: 4, mine: true));
      await openVenue(tester);
      await tester.ensureVisible(find.byKey(const Key('write-review')));
      await tester.tap(find.byKey(const Key('write-review')));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('review-field'))).controller!.text, 'Good');
      expect(find.text('Change your review'), findsWidgets);
      await tester.tap(find.byKey(const Key('star-4')));
      await tester.tap(find.byKey(const Key('save-review')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_save').single.body['p_rating'], 4);
    });

    testWidgets('the website\'s refusal is shown in the sheet', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true});
      site.rpcs['review_save'] = (_) => raised('That text goes against our community rules.');
      await openVenue(tester);
      await tester.ensureVisible(find.byKey(const Key('write-review')));
      await tester.tap(find.byKey(const Key('write-review')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('star-2')));
      await tester.tap(find.byKey(const Key('save-review')));
      await tester.pumpAndSettle();
      expect(find.text('That text goes against our community rules.'), findsOneWidget);
    });

    testWidgets('the community rules come first', (tester) async {
      var accepted = false;
      site.rpcs['rules_status'] = (_) => ok({'accepted': accepted});
      site.rpcs['rules_accept'] = (_) {
        accepted = true;
        return ok({'accepted': true});
      };
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage());
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true});
      site.rpcs['review_save'] = (_) => ok(reviewRow(mine: true));
      await openVenue(tester);
      await tester.ensureVisible(find.byKey(const Key('write-review')));
      await tester.tap(find.byKey(const Key('write-review')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('star-5')));
      await tester.tap(find.byKey(const Key('save-review')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(site.forRpc('review_save'), isEmpty);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_save'), hasLength(1));
    });

    testWidgets('your review can be deleted after asking', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'mine', mine: true)], count: 1, average: 4, stars: const [0, 0, 0, 1, 0]));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': true, 'mine': 'mine'});
      site.rpcs['review_delete'] = (_) => ok({'deleted': true});
      await openVenue(tester);
      await tester.ensureVisible(find.byKey(const Key('delete-review-mine')));
      await tester.tap(find.byKey(const Key('delete-review-mine')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_delete'), isEmpty);
      await tester.tap(find.byKey(const Key('confirm-delete-review')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_delete').single.body, {'p_actor': 'me', 'p_review': 'mine'});
    });

    testWidgets('are not there while reviews are off, and not asked for', (tester) async {
      await openVenue(tester, features: const {'social': true, 'reviews': false});
      expect(find.byKey(const Key('reviews-venue-v1')), findsNothing);
      expect(site.forRpc('reviews_list'), isEmpty);
    });

    testWidgets('are not there for someone who has not set up a profile', (tester) async {
      await openVenue(tester, mine: const []);
      expect(find.byKey(const Key('reviews-venue-v1')), findsNothing);
      expect(site.forRpc('reviews_list'), isEmpty);
    });

    testWidgets('a failure to read them hides the section, not the page', (tester) async {
      site.rpcs['reviews_list'] = (_) => (status: 500, body: {'message': 'boom'});
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false});
      await openVenue(tester);
      expect(find.byKey(const Key('venue-page')), findsOneWidget);
      expect(find.byKey(const Key('reviews-venue-v1')), findsNothing);
    });
  });

  group('the venue answers', () {
    final withReply = reviewRow(id: 'r1', canReply: true, reply: {'body': 'Thanks!', 'created_at': '2099-10-25T10:00:00Z', 'author': profileRow(id: 'biz', kind: 'business', handle: 'djdana', name: 'DJ Dana')});

    Future<void> openAsVenue(WidgetTester tester, Map<String, dynamic> review) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [review], count: 1, average: 4, stars: const [0, 0, 0, 1, 0]));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'Only a person\'s own profile can write a review.'});
      await openVenue(tester, mine: [myPersonal(), myBusiness()]);
      final container = ProviderScope.containerOf(tester.element(find.byKey(const Key('venue-page'))));
      container.read(selectedProfileIdProvider.notifier).state = 'biz';
      await tester.pumpAndSettle();
    }

    testWidgets('a profile that may reply sees Reply, writes it, and it is sent as that profile', (tester) async {
      site.rpcs['review_reply'] = (_) => ok(withReply);
      await openAsVenue(tester, reviewRow(id: 'r1', canReply: true));
      expect(site.forRpc('reviews_list').last.body['p_actor'], 'biz');
      await tester.ensureVisible(find.byKey(const Key('reply-button-r1')));
      await tester.tap(find.byKey(const Key('reply-button-r1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('send-reply')));
      await tester.pumpAndSettle();
      expect(find.text('Write something first.'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('reply-field')), ' Thanks! ');
      await tester.tap(find.byKey(const Key('send-reply')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_reply').single.body, {'p_actor': 'biz', 'p_review': 'r1', 'p_body': 'Thanks!'});
    });

    testWidgets('an existing reply can be edited or removed', (tester) async {
      site.rpcs['review_reply_delete'] = (_) => ok({'deleted': true});
      await openAsVenue(tester, withReply);
      expect(find.byKey(const Key('reply-r1')), findsOneWidget);
      expect(find.text('Reply from DJ Dana'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('remove-reply-r1')));
      await tester.tap(find.byKey(const Key('remove-reply-r1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('review_reply_delete').single.body, {'p_actor': 'biz', 'p_review': 'r1'});
      await tester.tap(find.byKey(const Key('edit-reply-r1')));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byKey(const Key('reply-field'))).controller!.text, 'Thanks!');
    });

    testWidgets('a reader who may not reply has no Reply button, but sees the reply', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'r1', canReply: false, reply: withReply['reply'] as Map<String, dynamic>)], count: 1, average: 4));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false});
      await openVenue(tester);
      expect(find.byKey(const Key('reply-button-r1')), findsNothing);
      expect(find.byKey(const Key('edit-reply-r1')), findsNothing);
      expect(find.byKey(const Key('reply-r1')), findsOneWidget);
    });

    testWidgets('a refused reply is explained in the sheet', (tester) async {
      site.rpcs['review_reply'] = (_) => raised('Only the venue or the organizer it is about can reply.');
      await openAsVenue(tester, reviewRow(id: 'r1', canReply: true));
      await tester.ensureVisible(find.byKey(const Key('reply-button-r1')));
      await tester.tap(find.byKey(const Key('reply-button-r1')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('reply-field')), 'hi');
      await tester.tap(find.byKey(const Key('send-reply')));
      await tester.pumpAndSettle();
      expect(find.text('Only the venue or the organizer it is about can reply.'), findsOneWidget);
    });
  });

  group('the full list', () {
    testWidgets('shows the stars summed up and every review', (tester) async {
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'a', body: 'one'), reviewRow(id: 'b', body: 'two')], count: 4, average: 4.5, stars: const [0, 0, 0, 2, 2]));
      await openSocial(tester, site, '/reviews/venue/v1', features: on);
      expect(find.byKey(const Key('summary-header')), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(tester.widget<LinearProgressIndicator>(find.byKey(const Key('bar-5'))).value, 0.5);
      expect(tester.widget<LinearProgressIndicator>(find.byKey(const Key('bar-1'))).value, 0);
      expect(find.byKey(const Key('review-a')), findsOneWidget);
      expect(find.byKey(const Key('review-b')), findsOneWidget);
    });

    testWidgets('a full page offers more, and the next page starts after the last review', (tester) async {
      var calls = 0;
      site.rpcs['reviews_list'] = (_) {
        calls++;
        return ok(calls == 1
            ? reviewsPage(items: [for (var i = 0; i < 20; i++) reviewRow(id: 'r$i', createdAt: '2099-10-24T23:00:${(59 - i).toString().padLeft(2, '0')}Z')], count: 21, average: 4, stars: const [0, 0, 0, 21, 0])
            : reviewsPage(items: [reviewRow(id: 'late')], count: 21, average: 4, stars: const [0, 0, 0, 21, 0]));
      };
      await openSocial(tester, site, '/reviews/venue/v1', features: on, settle: false);
      await settleCalls(tester);
      await tester.scrollUntilVisible(find.byKey(const Key('more-reviews')), 600, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.byKey(const Key('more-reviews')));
      await settleCalls(tester);
      expect(site.forRpc('reviews_list').last.body['p_before_id'], 'r19');
      expect(site.forRpc('reviews_list').last.body['p_before'], '2099-10-24T23:00:40.000Z');
    });

    testWidgets('a made-up kind in the address is said to be no page', (tester) async {
      await openSocial(tester, site, '/reviews/bar/v1', features: on);
      expect(find.byKey(const Key('no-such-page')), findsOneWidget);
      expect(site.forRpc('reviews_list'), isEmpty);
    });
  });

  group('on an event page', () {
    testWidgets('the reviews are the event\'s', (tester) async {
      site.tables['site_events'] = [eventRow()];
      site.rpcs['reviews_list'] = (_) => ok(reviewsPage(items: [reviewRow(id: 'e1', kind: 'event', body: 'The best night')], count: 1, average: 5, stars: const [0, 0, 0, 0, 1]));
      site.rpcs['review_eligibility'] = (_) => ok({'eligible': false, 'reason': 'You can review an event after you went to it.'});
      await openSocial(tester, site, '/events/e1', features: on);
      await tester.scrollUntilVisible(find.byKey(const Key('reviews-event-e1')), 400, scrollable: find.byType(Scrollable).first);
      expect(find.text('The best night'), findsOneWidget);
      expect(site.forRpc('reviews_list').single.body['p_kind'], 'event');
      expect(find.text('You can review an event after you went to it.'), findsOneWidget);
    });
  });

  group('stars on the Tables list', () {
    testWidgets('a venue with reviews shows its average and count; one without shows none', (tester) async {
      site.tables['site_venues'] = [venueRow(id: 'v1', name: 'Club A'), venueRow(id: 'v2', name: 'Club B')];
      site.rpcs['site_features'] = (_) => ok({'social': true, 'reviews': true});
      site.rpcs['venue_ratings'] = (_) => ok({'v1': {'count': 7, 'average': 4.6}});
      await pumpSite(tester, const Scaffold(body: TablesScreen()), site: site);
      await tester.pumpAndSettle();
      expect(find.descendant(of: find.byKey(const Key('venue-v1')), matching: find.text('4.6 (7)')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('venue-v2')), matching: find.byKey(const Key('rating-badge'))), findsNothing);
      expect(site.forRpc('venue_ratings').single.body, {'p_venues': ['v1', 'v2']});
    });

    testWidgets('no ratings are asked for while reviews are off', (tester) async {
      site.tables['site_venues'] = [venueRow(id: 'v1', name: 'Club A')];
      site.rpcs['site_features'] = (_) => ok({'social': true, 'reviews': false});
      site.rpcs['venue_ratings'] = (_) => ok({'v1': {'count': 7, 'average': 4.6}});
      await pumpSite(tester, const Scaffold(body: TablesScreen()), site: site);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rating-badge')), findsNothing);
      expect(site.forRpc('venue_ratings'), isEmpty);
    });
  });
}
