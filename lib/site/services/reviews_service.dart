import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';
import '../models/social_profile.dart';
import '../site_error.dart';

/// Reviews of venues and events, and what is hot, through the website's `review_*`, `reviews_list`, `venue_ratings`, `explore_*` functions. Who may review, and who may answer, is the
/// website's call each time; the app shows the sentence it gives.
class ReviewsService {
  ReviewsService(this._db);

  final SupabaseClient _db;

  Future<Object?> _rpc(String name, Map<String, dynamic> params, String generic) async {
    try {
      return await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
  }

  Review _one(Object? json) {
    final r = parseReview(json);
    if (r == null) throw const SiteException('We could not read that review. Try again in a moment.');
    return r;
  }

  Future<ReviewEligibility> eligibility({required String actor, required ReviewKind kind, required String target}) async =>
      parseReviewEligibility(await _rpc('review_eligibility', {'p_actor': actor, 'p_kind': kind.name, 'p_target': target}, loadFailedMessage('that')));

  Future<Review> save({required String actor, required ReviewKind kind, required String target, required int rating, String? body}) async => _one(await _rpc(
        'review_save',
        {'p_actor': actor, 'p_kind': kind.name, 'p_target': target, 'p_rating': rating, 'p_body': body?.trim()},
        'We could not save your review. Check your connection and try again.',
      ));

  Future<void> delete({required String actor, required String review}) async {
    await _rpc('review_delete', {'p_actor': actor, 'p_review': review}, actionFailedMessage);
  }

  Future<Review> reply({required String actor, required String review, required String body}) async =>
      _one(await _rpc('review_reply', {'p_actor': actor, 'p_review': review, 'p_body': body.trim()}, 'We could not send your reply. Check your connection and try again.'));

  Future<void> deleteReply({required String actor, required String review}) async {
    await _rpc('review_reply_delete', {'p_actor': actor, 'p_review': review}, actionFailedMessage);
  }

  Future<ReviewsPage> reviews({required String actor, required ReviewKind kind, required String target, int limit = 20, Review? after}) async => parseReviewsPage(await _rpc(
        'reviews_list',
        {
          'p_actor': actor,
          'p_kind': kind.name,
          'p_target': target,
          'p_limit': limit,
          'p_before': after?.createdAt.toUtc().toIso8601String(),
          'p_before_id': after?.id,
        },
        loadFailedMessage('the reviews'),
      ));

  /// Average and count for many venues at once, for a list of cards. Quiet on failure: a card just shows no stars.
  Future<Map<String, VenueRating>> ratings(List<String> venueIds) async {
    if (venueIds.isEmpty) return const {};
    try {
      return parseVenueRatings(await _db.rpc('venue_ratings', params: {'p_venues': venueIds}));
    } catch (error) {
      logProblem('read venue ratings', error);
      return const {};
    }
  }

  Future<List<HotItem>> hotVenues({int limit = 10}) async {
    try {
      return parseHotItems(await _db.rpc('explore_hot_venues', params: {'p_limit': limit}));
    } catch (error) {
      logProblem('read the hot venues', error);
      return const [];
    }
  }

  Future<List<HotItem>> hotEvents({int limit = 10}) async {
    try {
      return parseHotItems(await _db.rpc('explore_hot_events', params: {'p_limit': limit}));
    } catch (error) {
      logProblem('read the hot events', error);
      return const [];
    }
  }

  /// Professionals and event groups, best known first. [offset] pages the directory.
  Future<List<SocialProfile>> professionals({required String actor, String? category, String? city, String? query, int limit = 20, int offset = 0}) async => parseSocialProfiles(await _rpc(
        'explore_professionals',
        {'p_actor': actor, 'p_category': category, 'p_city': city?.trim().isEmpty ?? true ? null : city!.trim(), 'p_query': query?.trim().isEmpty ?? true ? null : query!.trim(), 'p_limit': limit, 'p_offset': offset},
        loadFailedMessage('the directory'),
      ));
}
