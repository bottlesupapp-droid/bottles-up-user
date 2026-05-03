// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserActivityImpl _$$UserActivityImplFromJson(Map<String, dynamic> json) =>
    _$UserActivityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      description: json['description'] as String,
      relatedId: json['relatedId'] as String?,
      relatedType: json['relatedType'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserActivityImplToJson(_$UserActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'description': instance.description,
      'relatedId': instance.relatedId,
      'relatedType': instance.relatedType,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.booking: 'booking',
  ActivityType.review: 'review',
  ActivityType.checkIn: 'checkIn',
  ActivityType.venueView: 'venueView',
  ActivityType.eventView: 'eventView',
  ActivityType.search: 'search',
  ActivityType.share: 'share',
  ActivityType.favorite: 'favorite',
  ActivityType.friendRequest: 'friendRequest',
  ActivityType.profileUpdate: 'profileUpdate',
  ActivityType.loyaltyPointsEarned: 'loyaltyPointsEarned',
  ActivityType.rewardRedeemed: 'rewardRedeemed',
  ActivityType.referral: 'referral',
};

_$ActivityStatsImpl _$$ActivityStatsImplFromJson(Map<String, dynamic> json) =>
    _$ActivityStatsImpl(
      totalActivities: (json['totalActivities'] as num).toInt(),
      bookingsCount: (json['bookingsCount'] as num).toInt(),
      reviewsCount: (json['reviewsCount'] as num).toInt(),
      checkInsCount: (json['checkInsCount'] as num).toInt(),
      sharesCount: (json['sharesCount'] as num).toInt(),
      favoritesCount: (json['favoritesCount'] as num).toInt(),
      activitiesByType: Map<String, int>.from(json['activitiesByType'] as Map),
      activitiesByMonth:
          Map<String, int>.from(json['activitiesByMonth'] as Map),
      firstActivityDate: json['firstActivityDate'] == null
          ? null
          : DateTime.parse(json['firstActivityDate'] as String),
      lastActivityDate: json['lastActivityDate'] == null
          ? null
          : DateTime.parse(json['lastActivityDate'] as String),
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ActivityStatsImplToJson(_$ActivityStatsImpl instance) =>
    <String, dynamic>{
      'totalActivities': instance.totalActivities,
      'bookingsCount': instance.bookingsCount,
      'reviewsCount': instance.reviewsCount,
      'checkInsCount': instance.checkInsCount,
      'sharesCount': instance.sharesCount,
      'favoritesCount': instance.favoritesCount,
      'activitiesByType': instance.activitiesByType,
      'activitiesByMonth': instance.activitiesByMonth,
      'firstActivityDate': instance.firstActivityDate?.toIso8601String(),
      'lastActivityDate': instance.lastActivityDate?.toIso8601String(),
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
    };

_$SavedItemImpl _$$SavedItemImplFromJson(Map<String, dynamic> json) =>
    _$SavedItemImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      itemName: json['itemName'] as String,
      itemImage: json['itemImage'] as String?,
      itemData: json['itemData'] as Map<String, dynamic>?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      notes: json['notes'] as String?,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );

Map<String, dynamic> _$$SavedItemImplToJson(_$SavedItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'itemName': instance.itemName,
      'itemImage': instance.itemImage,
      'itemData': instance.itemData,
      'tags': instance.tags,
      'notes': instance.notes,
      'savedAt': instance.savedAt.toIso8601String(),
    };

_$UserStatisticsImpl _$$UserStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatisticsImpl(
      userId: json['userId'] as String,
      totalBookings: (json['totalBookings'] as num).toInt(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      totalCheckIns: (json['totalCheckIns'] as num).toInt(),
      totalPointsEarned: (json['totalPointsEarned'] as num).toInt(),
      totalRewardsRedeemed: (json['totalRewardsRedeemed'] as num).toInt(),
      totalReferrals: (json['totalReferrals'] as num).toInt(),
      totalFriends: (json['totalFriends'] as num).toInt(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      favoriteVenue: json['favoriteVenue'] as String?,
      favoriteCategory: json['favoriteCategory'] as String?,
      topVenues: (json['topVenues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visitsByCategory:
          (json['visitsByCategory'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      spendingByMonth: (json['spendingByMonth'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      memberSince: DateTime.parse(json['memberSince'] as String),
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$$UserStatisticsImplToJson(
        _$UserStatisticsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalBookings': instance.totalBookings,
      'totalReviews': instance.totalReviews,
      'totalCheckIns': instance.totalCheckIns,
      'totalPointsEarned': instance.totalPointsEarned,
      'totalRewardsRedeemed': instance.totalRewardsRedeemed,
      'totalReferrals': instance.totalReferrals,
      'totalFriends': instance.totalFriends,
      'averageRating': instance.averageRating,
      'totalSpent': instance.totalSpent,
      'favoriteVenue': instance.favoriteVenue,
      'favoriteCategory': instance.favoriteCategory,
      'topVenues': instance.topVenues,
      'visitsByCategory': instance.visitsByCategory,
      'spendingByMonth': instance.spendingByMonth,
      'memberSince': instance.memberSince.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
    };
