import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

enum ActivityType {
  booking,
  review,
  checkIn,
  venueView,
  eventView,
  search,
  share,
  favorite,
  friendRequest,
  profileUpdate,
  loyaltyPointsEarned,
  rewardRedeemed,
  referral,
}

@freezed
class UserActivity with _$UserActivity {
  const factory UserActivity({
    required String id,
    required String userId,
    required ActivityType type,
    required String description,
    String? relatedId,
    String? relatedType,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  factory UserActivity.fromSupabase(Map<String, dynamic> data) {
    return UserActivity(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ActivityType.profileUpdate,
      ),
      description: data['description'] as String,
      relatedId: data['related_id'] as String?,
      relatedType: data['related_type'] as String?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}

@freezed
class ActivityStats with _$ActivityStats {
  const factory ActivityStats({
    required int totalActivities,
    required int bookingsCount,
    required int reviewsCount,
    required int checkInsCount,
    required int sharesCount,
    required int favoritesCount,
    required Map<String, int> activitiesByType,
    required Map<String, int> activitiesByMonth,
    DateTime? firstActivityDate,
    DateTime? lastActivityDate,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
  }) = _ActivityStats;

  factory ActivityStats.fromJson(Map<String, dynamic> json) =>
      _$ActivityStatsFromJson(json);

  factory ActivityStats.fromSupabase(Map<String, dynamic> data) {
    return ActivityStats(
      totalActivities: data['total_activities'] as int? ?? 0,
      bookingsCount: data['bookings_count'] as int? ?? 0,
      reviewsCount: data['reviews_count'] as int? ?? 0,
      checkInsCount: data['check_ins_count'] as int? ?? 0,
      sharesCount: data['shares_count'] as int? ?? 0,
      favoritesCount: data['favorites_count'] as int? ?? 0,
      activitiesByType: data['activities_by_type'] != null
          ? Map<String, int>.from(data['activities_by_type'] as Map)
          : {},
      activitiesByMonth: data['activities_by_month'] != null
          ? Map<String, int>.from(data['activities_by_month'] as Map)
          : {},
      firstActivityDate: data['first_activity_date'] != null
          ? DateTime.parse(data['first_activity_date'] as String)
          : null,
      lastActivityDate: data['last_activity_date'] != null
          ? DateTime.parse(data['last_activity_date'] as String)
          : null,
      currentStreak: data['current_streak'] as int? ?? 0,
      longestStreak: data['longest_streak'] as int? ?? 0,
    );
  }
}

@freezed
class SavedItem with _$SavedItem {
  const factory SavedItem({
    required String id,
    required String userId,
    required String itemId,
    required String itemType,
    required String itemName,
    String? itemImage,
    Map<String, dynamic>? itemData,
    @Default([]) List<String> tags,
    String? notes,
    required DateTime savedAt,
  }) = _SavedItem;

  factory SavedItem.fromJson(Map<String, dynamic> json) =>
      _$SavedItemFromJson(json);

  factory SavedItem.fromSupabase(Map<String, dynamic> data) {
    return SavedItem(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      itemId: data['item_id'] as String,
      itemType: data['item_type'] as String,
      itemName: data['item_name'] as String,
      itemImage: data['item_image'] as String?,
      itemData: data['item_data'] != null
          ? Map<String, dynamic>.from(data['item_data'] as Map)
          : null,
      tags: data['tags'] != null ? List<String>.from(data['tags'] as List) : [],
      notes: data['notes'] as String?,
      savedAt: DateTime.parse(data['saved_at'] as String),
    );
  }
}

@freezed
class UserStatistics with _$UserStatistics {
  const factory UserStatistics({
    required String userId,
    required int totalBookings,
    required int totalReviews,
    required int totalCheckIns,
    required int totalPointsEarned,
    required int totalRewardsRedeemed,
    required int totalReferrals,
    required int totalFriends,
    @Default(0.0) double averageRating,
    @Default(0.0) double totalSpent,
    String? favoriteVenue,
    String? favoriteCategory,
    List<String>? topVenues,
    Map<String, int>? visitsByCategory,
    Map<String, double>? spendingByMonth,
    required DateTime memberSince,
    DateTime? lastActive,
  }) = _UserStatistics;

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);

  factory UserStatistics.fromSupabase(Map<String, dynamic> data) {
    return UserStatistics(
      userId: data['user_id'] as String,
      totalBookings: data['total_bookings'] as int? ?? 0,
      totalReviews: data['total_reviews'] as int? ?? 0,
      totalCheckIns: data['total_check_ins'] as int? ?? 0,
      totalPointsEarned: data['total_points_earned'] as int? ?? 0,
      totalRewardsRedeemed: data['total_rewards_redeemed'] as int? ?? 0,
      totalReferrals: data['total_referrals'] as int? ?? 0,
      totalFriends: data['total_friends'] as int? ?? 0,
      averageRating: (data['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalSpent: (data['total_spent'] as num?)?.toDouble() ?? 0.0,
      favoriteVenue: data['favorite_venue'] as String?,
      favoriteCategory: data['favorite_category'] as String?,
      topVenues: data['top_venues'] != null
          ? List<String>.from(data['top_venues'] as List)
          : null,
      visitsByCategory: data['visits_by_category'] != null
          ? Map<String, int>.from(data['visits_by_category'] as Map)
          : null,
      spendingByMonth: data['spending_by_month'] != null
          ? Map<String, double>.from(data['spending_by_month'] as Map)
          : null,
      memberSince: DateTime.parse(data['member_since'] as String),
      lastActive: data['last_active'] != null
          ? DateTime.parse(data['last_active'] as String)
          : null,
    );
  }
}
