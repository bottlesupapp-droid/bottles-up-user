import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_tier.freezed.dart';
part 'loyalty_tier.g.dart';

enum TierLevel {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

@freezed
class LoyaltyTier with _$LoyaltyTier {
  const factory LoyaltyTier({
    required String id,
    required String name,
    required TierLevel level,
    required int minPoints,
    required int maxPoints,
    required String description,
    required List<String> benefits,
    required String iconUrl,
    required String colorHex,
    @Default(0) int earlyAccessHours,
    @Default(0) double discountPercentage,
    @Default(0) int priorityBookingDays,
    @Default(false) bool hasExclusiveEvents,
    @Default(false) bool hasBirthdayReward,
    @Default(0) double pointsMultiplier,
    Map<String, dynamic>? metadata,
  }) = _LoyaltyTier;

  factory LoyaltyTier.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTierFromJson(json);

  factory LoyaltyTier.fromSupabase(Map<String, dynamic> data) {
    return LoyaltyTier(
      id: data['id'] as String,
      name: data['name'] as String,
      level: TierLevel.values.firstWhere(
        (e) => e.name == data['level'],
        orElse: () => TierLevel.bronze,
      ),
      minPoints: data['min_points'] as int,
      maxPoints: data['max_points'] as int,
      description: data['description'] as String,
      benefits: List<String>.from(data['benefits'] as List),
      iconUrl: data['icon_url'] as String,
      colorHex: data['color_hex'] as String,
      earlyAccessHours: data['early_access_hours'] as int? ?? 0,
      discountPercentage: (data['discount_percentage'] as num?)?.toDouble() ?? 0,
      priorityBookingDays: data['priority_booking_days'] as int? ?? 0,
      hasExclusiveEvents: data['has_exclusive_events'] as bool? ?? false,
      hasBirthdayReward: data['has_birthday_reward'] as bool? ?? false,
      pointsMultiplier: (data['points_multiplier'] as num?)?.toDouble() ?? 1.0,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class UserLoyaltyStatus with _$UserLoyaltyStatus {
  const factory UserLoyaltyStatus({
    required String userId,
    required LoyaltyTier currentTier,
    required int totalPoints,
    required int lifetimePoints,
    LoyaltyTier? nextTier,
    int? pointsToNextTier,
    required DateTime joinedAt,
    DateTime? lastActivityAt,
    @Default(0) int tierUpgradeCount,
    @Default([]) List<String> unlockedBenefits,
  }) = _UserLoyaltyStatus;

  factory UserLoyaltyStatus.fromJson(Map<String, dynamic> json) =>
      _$UserLoyaltyStatusFromJson(json);

  factory UserLoyaltyStatus.fromSupabase(Map<String, dynamic> data) {
    return UserLoyaltyStatus(
      userId: data['user_id'] as String,
      currentTier: LoyaltyTier.fromSupabase(data['current_tier'] as Map<String, dynamic>),
      totalPoints: data['total_points'] as int,
      lifetimePoints: data['lifetime_points'] as int,
      nextTier: data['next_tier'] != null
          ? LoyaltyTier.fromSupabase(data['next_tier'] as Map<String, dynamic>)
          : null,
      pointsToNextTier: data['points_to_next_tier'] as int?,
      joinedAt: DateTime.parse(data['joined_at'] as String),
      lastActivityAt: data['last_activity_at'] != null
          ? DateTime.parse(data['last_activity_at'] as String)
          : null,
      tierUpgradeCount: data['tier_upgrade_count'] as int? ?? 0,
      unlockedBenefits: data['unlocked_benefits'] != null
          ? List<String>.from(data['unlocked_benefits'] as List)
          : [],
    );
  }
}

@freezed
class EarlyAccessEvent with _$EarlyAccessEvent {
  const factory EarlyAccessEvent({
    required String id,
    required String eventId,
    required String eventName,
    required TierLevel minimumTier,
    required DateTime earlyAccessStartsAt,
    required DateTime publicAccessStartsAt,
    required int availableSlots,
    required int bookedSlots,
    String? eventImageUrl,
    bool? isActive,
  }) = _EarlyAccessEvent;

  factory EarlyAccessEvent.fromJson(Map<String, dynamic> json) =>
      _$EarlyAccessEventFromJson(json);

  factory EarlyAccessEvent.fromSupabase(Map<String, dynamic> data) {
    return EarlyAccessEvent(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      eventName: data['event_name'] as String,
      minimumTier: TierLevel.values.firstWhere(
        (e) => e.name == data['minimum_tier'],
        orElse: () => TierLevel.bronze,
      ),
      earlyAccessStartsAt: DateTime.parse(data['early_access_starts_at'] as String),
      publicAccessStartsAt: DateTime.parse(data['public_access_starts_at'] as String),
      availableSlots: data['available_slots'] as int,
      bookedSlots: data['booked_slots'] as int,
      eventImageUrl: data['event_image_url'] as String?,
      isActive: data['is_active'] as bool?,
    );
  }
}

@freezed
class ExclusiveEvent with _$ExclusiveEvent {
  const factory ExclusiveEvent({
    required String id,
    required String eventId,
    required String eventName,
    required String description,
    required TierLevel minimumTier,
    required DateTime eventDate,
    required int maxAttendees,
    required int currentAttendees,
    String? venueId,
    String? venueName,
    String? imageUrl,
    double? price,
    @Default(true) bool requiresRSVP,
    @Default(false) bool isWaitlistEnabled,
  }) = _ExclusiveEvent;

  factory ExclusiveEvent.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveEventFromJson(json);

  factory ExclusiveEvent.fromSupabase(Map<String, dynamic> data) {
    return ExclusiveEvent(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      eventName: data['event_name'] as String,
      description: data['description'] as String,
      minimumTier: TierLevel.values.firstWhere(
        (e) => e.name == data['minimum_tier'],
        orElse: () => TierLevel.bronze,
      ),
      eventDate: DateTime.parse(data['event_date'] as String),
      maxAttendees: data['max_attendees'] as int,
      currentAttendees: data['current_attendees'] as int,
      venueId: data['venue_id'] as String?,
      venueName: data['venue_name'] as String?,
      imageUrl: data['image_url'] as String?,
      price: (data['price'] as num?)?.toDouble(),
      requiresRSVP: data['requires_rsvp'] as bool? ?? true,
      isWaitlistEnabled: data['is_waitlist_enabled'] as bool? ?? false,
    );
  }
}
