import '../read.dart';
import 'social_profile.dart';

enum ReviewKind { venue, event }

/// A venue's (or organizer's) answer to a review.
class ReviewReply {
  const ReviewReply({required this.body, required this.createdAt, required this.author});

  final String body;
  final DateTime createdAt;
  final SocialProfile author;
}

class Review {
  const Review({required this.id, required this.kind, required this.rating, required this.createdAt, required this.author, this.body, this.isMine = false, this.canReply = false, this.reply});

  final String id;
  final ReviewKind kind;
  final int rating;
  final String? body;
  final DateTime createdAt;
  final SocialProfile author;
  final bool isMine;

  /// The signed-in profile may answer this review (it is the venue's own, or the organizer's).
  final bool canReply;
  final ReviewReply? reply;
}

/// The average, how many reviews, and how many of each star (one to five).
class ReviewSummary {
  const ReviewSummary({required this.count, required this.average, required this.stars});

  const ReviewSummary.empty() : this(count: 0, average: 0, stars: const [0, 0, 0, 0, 0]);

  final int count;
  final double average;
  final List<int> stars;
}

ReviewSummary parseReviewSummary(Object? json) {
  if (json is! Map) return const ReviewSummary.empty();
  final raw = json['stars'];
  final stars = raw is List && raw.length == 5 ? [for (final s in raw) readInt(s) ?? 0] : const [0, 0, 0, 0, 0];
  final avg = json['average'];
  return ReviewSummary(count: readInt(json['count']) ?? 0, average: avg is num ? avg.toDouble() : (double.tryParse('$avg') ?? 0), stars: stars);
}

Review? parseReview(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final author = parseSocialProfile(json['author']);
  final rating = readInt(json['rating']);
  final created = readText(json['created_at']);
  final at = created == null ? null : DateTime.tryParse(created)?.toLocal();
  final kind = switch (json['kind']) {
    'venue' => ReviewKind.venue,
    'event' => ReviewKind.event,
    _ => null,
  };
  if (id == null || author == null || rating == null || rating < 1 || rating > 5 || at == null || kind == null) return null;
  ReviewReply? reply;
  final r = json['reply'];
  if (r is Map) {
    final replyAuthor = parseSocialProfile(r['author']);
    final body = readText(r['body']);
    final replyAt = readText(r['created_at']);
    final when = replyAt == null ? null : DateTime.tryParse(replyAt)?.toLocal();
    if (replyAuthor != null && body != null && when != null) reply = ReviewReply(body: body, createdAt: when, author: replyAuthor);
  }
  return Review(id: id, kind: kind, rating: rating, createdAt: at, author: author, body: readText(json['body']), isMine: json['is_mine'] == true, canReply: json['can_reply'] == true, reply: reply);
}

List<Review> parseReviews(Object? json) => json is List ? [for (final r in json) if (parseReview(r) case final v?) v] : const [];

class ReviewsPage {
  const ReviewsPage({required this.summary, required this.items});

  final ReviewSummary summary;
  final List<Review> items;
}

ReviewsPage parseReviewsPage(Object? json) {
  if (json is! Map) return const ReviewsPage(summary: ReviewSummary.empty(), items: []);
  return ReviewsPage(summary: parseReviewSummary(json['summary']), items: parseReviews(json['items']));
}

/// May this profile review this venue or event? [reason] is the sentence to show when not; [mineId] is the review it already wrote.
class ReviewEligibility {
  const ReviewEligibility({required this.eligible, this.reason, this.mineId});

  final bool eligible;
  final String? reason;
  final String? mineId;
}

ReviewEligibility parseReviewEligibility(Object? json) {
  if (json is! Map) return const ReviewEligibility(eligible: false, reason: 'We could not check that. Try again in a moment.');
  return ReviewEligibility(eligible: json['eligible'] == true, reason: readText(json['reason']), mineId: readText(json['mine']));
}

/// A venue or event that is busy, with the score it was ranked by. Only the order is meant to be shown.
class HotItem {
  const HotItem({required this.id, required this.score});

  final String id;
  final int score;
}

List<HotItem> parseHotItems(Object? json) => json is List
    ? [
        for (final r in json)
          if (r is Map && readText(r['id']) != null) HotItem(id: readText(r['id'])!, score: readInt(r['score']) ?? 0),
      ]
    : const [];

/// The rating and number of reviews of a venue, as shown on its card.
class VenueRating {
  const VenueRating({required this.average, required this.count});

  final double average;
  final int count;
}

Map<String, VenueRating> parseVenueRatings(Object? json) {
  if (json is! Map) return const {};
  final out = <String, VenueRating>{};
  for (final e in json.entries) {
    final v = e.value;
    if (e.key is String && v is Map) {
      final n = readInt(v['count']) ?? 0;
      final a = v['average'];
      final avg = a is num ? a.toDouble() : double.tryParse('$a');
      if (n > 0 && avg != null) out[e.key as String] = VenueRating(average: avg, count: n);
    }
  }
  return out;
}
