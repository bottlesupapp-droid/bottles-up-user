// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddonImpl _$$AddonImplFromJson(Map<String, dynamic> json) => _$AddonImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$AddonCategoryEnumMap, json['category']),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      maxQuantity: (json['maxQuantity'] as num?)?.toInt(),
      availableStock: (json['availableStock'] as num?)?.toInt(),
      includedItems: (json['includedItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      estimatedDuration: json['estimatedDuration'] as String?,
    );

Map<String, dynamic> _$$AddonImplToJson(_$AddonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$AddonCategoryEnumMap[instance.category]!,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'requiresApproval': instance.requiresApproval,
      'maxQuantity': instance.maxQuantity,
      'availableStock': instance.availableStock,
      'includedItems': instance.includedItems,
      'estimatedDuration': instance.estimatedDuration,
    };

const _$AddonCategoryEnumMap = {
  AddonCategory.hookah: 'hookah',
  AddonCategory.decoration: 'decoration',
  AddonCategory.sparklers: 'sparklers',
  AddonCategory.photography: 'photography',
  AddonCategory.entertainment: 'entertainment',
  AddonCategory.food: 'food',
  AddonCategory.other: 'other',
};

_$BookingAddonImpl _$$BookingAddonImplFromJson(Map<String, dynamic> json) =>
    _$BookingAddonImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      addonId: json['addonId'] as String,
      addonName: json['addonName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: $enumDecodeNullable(_$AddonStatusEnumMap, json['status']) ??
          AddonStatus.pending,
      specialInstructions: json['specialInstructions'] as String?,
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingAddonImplToJson(_$BookingAddonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'addonId': instance.addonId,
      'addonName': instance.addonName,
      'price': instance.price,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'status': _$AddonStatusEnumMap[instance.status]!,
      'specialInstructions': instance.specialInstructions,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AddonStatusEnumMap = {
  AddonStatus.pending: 'pending',
  AddonStatus.approved: 'approved',
  AddonStatus.preparing: 'preparing',
  AddonStatus.delivered: 'delivered',
  AddonStatus.cancelled: 'cancelled',
};
