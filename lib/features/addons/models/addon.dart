import 'package:freezed_annotation/freezed_annotation.dart';

part 'addon.freezed.dart';
part 'addon.g.dart';

enum AddonCategory {
  hookah,
  decoration,
  sparklers,
  photography,
  entertainment,
  food,
  other,
}

@freezed
class Addon with _$Addon {
  const factory Addon({
    required String id,
    required String name,
    required String description,
    required AddonCategory category,
    required double price,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(false) bool requiresApproval,
    int? maxQuantity,
    int? availableStock,
    List<String>? includedItems,
    String? estimatedDuration,
  }) = _Addon;

  factory Addon.fromJson(Map<String, dynamic> json) => _$AddonFromJson(json);

  factory Addon.fromSupabase(Map<String, dynamic> data) {
    return Addon(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      category: AddonCategory.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => AddonCategory.other,
      ),
      price: (data['price'] as num).toDouble(),
      imageUrl: data['image_url'] as String?,
      isAvailable: data['is_available'] as bool? ?? true,
      requiresApproval: data['requires_approval'] as bool? ?? false,
      maxQuantity: data['max_quantity'] as int?,
      availableStock: data['available_stock'] as int?,
      includedItems: data['included_items'] != null
          ? List<String>.from(data['included_items'] as List)
          : null,
      estimatedDuration: data['estimated_duration'] as String?,
    );
  }
}

@freezed
class BookingAddon with _$BookingAddon {
  const factory BookingAddon({
    required String id,
    required String bookingId,
    required String addonId,
    required String addonName,
    required double price,
    required int quantity,
    required double totalPrice,
    @Default(AddonStatus.pending) AddonStatus status,
    String? specialInstructions,
    DateTime? scheduledTime,
    DateTime? approvedAt,
    DateTime? deliveredAt,
    required DateTime createdAt,
  }) = _BookingAddon;

  factory BookingAddon.fromJson(Map<String, dynamic> json) =>
      _$BookingAddonFromJson(json);

  factory BookingAddon.fromSupabase(Map<String, dynamic> data) {
    return BookingAddon(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      addonId: data['addon_id'] as String,
      addonName: data['addon_name'] as String,
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int,
      totalPrice: (data['total_price'] as num).toDouble(),
      status: AddonStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => AddonStatus.pending,
      ),
      specialInstructions: data['special_instructions'] as String?,
      scheduledTime: data['scheduled_time'] != null
          ? DateTime.parse(data['scheduled_time'] as String)
          : null,
      approvedAt: data['approved_at'] != null
          ? DateTime.parse(data['approved_at'] as String)
          : null,
      deliveredAt: data['delivered_at'] != null
          ? DateTime.parse(data['delivered_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}

enum AddonStatus {
  pending,
  approved,
  preparing,
  delivered,
  cancelled,
}
