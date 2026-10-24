import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle_upgrade.freezed.dart';
part 'bottle_upgrade.g.dart';

@freezed
class BottleUpgrade with _$BottleUpgrade {
  const factory BottleUpgrade({
    required String id,
    required String bottleId,
    required String originalBottleName,
    required String upgradeBottleName,
    required double originalPrice,
    required double upgradePrice,
    required double priceDifference,
    String? description,
    String? imageUrl,
    @Default(false) bool isAvailable,
    @Default(false) bool isPremium,
    int? remainingStock,
  }) = _BottleUpgrade;

  factory BottleUpgrade.fromJson(Map<String, dynamic> json) =>
      _$BottleUpgradeFromJson(json);

  factory BottleUpgrade.fromSupabase(Map<String, dynamic> data) {
    return BottleUpgrade(
      id: data['id'] as String,
      bottleId: data['bottle_id'] as String,
      originalBottleName: data['original_bottle_name'] as String,
      upgradeBottleName: data['upgrade_bottle_name'] as String,
      originalPrice: (data['original_price'] as num).toDouble(),
      upgradePrice: (data['upgrade_price'] as num).toDouble(),
      priceDifference: (data['price_difference'] as num).toDouble(),
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String?,
      isAvailable: data['is_available'] as bool? ?? false,
      isPremium: data['is_premium'] as bool? ?? false,
      remainingStock: data['remaining_stock'] as int?,
    );
  }
}

@freezed
class UpgradeRequest with _$UpgradeRequest {
  const factory UpgradeRequest({
    required String id,
    required String bookingId,
    required String userId,
    required String originalBottleId,
    required String upgradeBottleId,
    required double priceDifference,
    @Default(UpgradeStatus.pending) UpgradeStatus status,
    String? notes,
    DateTime? approvedAt,
    DateTime? rejectedAt,
    String? rejectionReason,
    required DateTime createdAt,
  }) = _UpgradeRequest;

  factory UpgradeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpgradeRequestFromJson(json);

  factory UpgradeRequest.fromSupabase(Map<String, dynamic> data) {
    return UpgradeRequest(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      userId: data['user_id'] as String,
      originalBottleId: data['original_bottle_id'] as String,
      upgradeBottleId: data['upgrade_bottle_id'] as String,
      priceDifference: (data['price_difference'] as num).toDouble(),
      status: UpgradeStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => UpgradeStatus.pending,
      ),
      notes: data['notes'] as String?,
      approvedAt: data['approved_at'] != null
          ? DateTime.parse(data['approved_at'] as String)
          : null,
      rejectedAt: data['rejected_at'] != null
          ? DateTime.parse(data['rejected_at'] as String)
          : null,
      rejectionReason: data['rejection_reason'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}

enum UpgradeStatus {
  pending,
  approved,
  rejected,
  completed,
}
