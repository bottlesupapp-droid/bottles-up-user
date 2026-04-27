import 'package:freezed_annotation/freezed_annotation.dart';

part 'tier.freezed.dart';
part 'tier.g.dart';

enum TierLevel {
  select,
  signature,
  reserve,
  noir,
}

@freezed
class Tier with _$Tier {
  const factory Tier({
    required TierLevel level,
    required String name,
    required String description,
    required int minPoints,
    required int minSpend,
    required double discountPercentage,
    required List<String> benefits,
    required String colorHex,
    required String iconAsset,
    @Default(false) bool earlyAccess,
    @Default(0) int priorityBookingHours,
    @Default(0) double pointsMultiplier,
  }) = _Tier;

  factory Tier.fromJson(Map<String, dynamic> json) => _$TierFromJson(json);

  factory Tier.select() => const Tier(
        level: TierLevel.select,
        name: 'BottlesUp Select',
        description: 'Start your journey with exclusive perks',
        minPoints: 0,
        minSpend: 0,
        discountPercentage: 0,
        benefits: [
          'Birthday rewards',
          'Digital receipts',
          'Event notifications',
          'Standard booking',
        ],
        colorHex: '#8E8E93',
        iconAsset: 'assets/icons/tier_select.png',
        pointsMultiplier: 1.0,
      );

  factory Tier.signature() => const Tier(
        level: TierLevel.signature,
        name: 'BottlesUp Signature',
        description: 'Elevated experiences and priority access',
        minPoints: 500,
        minSpend: 2000,
        discountPercentage: 5,
        benefits: [
          'All Select benefits',
          '5% discount on bookings',
          'Priority booking (24h early access)',
          '1.25x points multiplier',
          'Skip waitlist',
          'Special birthday bottle',
        ],
        colorHex: '#FF6B00',
        iconAsset: 'assets/icons/tier_signature.png',
        earlyAccess: true,
        priorityBookingHours: 24,
        pointsMultiplier: 1.25,
      );

  factory Tier.reserve() => const Tier(
        level: TierLevel.reserve,
        name: 'BottlesUp Reserve',
        description: 'Premium privileges and VIP treatment',
        minPoints: 1500,
        minSpend: 5000,
        discountPercentage: 10,
        benefits: [
          'All Signature benefits',
          '10% discount on bookings',
          'Priority booking (48h early access)',
          '1.5x points multiplier',
          'Complimentary bottle on birthday',
          'Free table upgrades (subject to availability)',
          'Dedicated concierge',
          'Luxury car rental discount (10%)',
        ],
        colorHex: '#FFD700',
        iconAsset: 'assets/icons/tier_reserve.png',
        earlyAccess: true,
        priorityBookingHours: 48,
        pointsMultiplier: 1.5,
      );

  factory Tier.noir() => const Tier(
        level: TierLevel.noir,
        name: 'BottlesUp Noir',
        description: 'Ultimate luxury and exclusivity',
        minPoints: 3000,
        minSpend: 10000,
        discountPercentage: 15,
        benefits: [
          'All Reserve benefits',
          '15% discount on bookings',
          'Priority booking (72h early access)',
          '2x points multiplier',
          'Premium birthday experience',
          'Guaranteed table upgrades',
          'Personal VIP host',
          'Luxury car rental with chauffeur (20% off)',
          'Exclusive Noir-only events',
          'Complimentary bottle per month',
          'Free event photo packages',
        ],
        colorHex: '#000000',
        iconAsset: 'assets/icons/tier_noir.png',
        earlyAccess: true,
        priorityBookingHours: 72,
        pointsMultiplier: 2.0,
      );
}
