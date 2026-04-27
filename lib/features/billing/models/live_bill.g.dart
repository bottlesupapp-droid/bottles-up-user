// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveBillImpl _$$LiveBillImplFromJson(Map<String, dynamic> json) =>
    _$LiveBillImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      venueId: json['venueId'] as String,
      venueName: json['venueName'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => BillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      serviceCharge: (json['serviceCharge'] as num).toDouble(),
      tip: (json['tip'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String? ?? 'open',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
    );

Map<String, dynamic> _$$LiveBillImplToJson(_$LiveBillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'userId': instance.userId,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'serviceCharge': instance.serviceCharge,
      'tip': instance.tip,
      'total': instance.total,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
    };

_$BillItemImpl _$$BillItemImplFromJson(Map<String, dynamic> json) =>
    _$BillItemImpl(
      id: json['id'] as String,
      billId: json['billId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      category: json['category'] as String?,
      notes: json['notes'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
      addedBy: json['addedBy'] as String?,
    );

Map<String, dynamic> _$$BillItemImplToJson(_$BillItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billId': instance.billId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'pricePerUnit': instance.pricePerUnit,
      'totalPrice': instance.totalPrice,
      'category': instance.category,
      'notes': instance.notes,
      'addedAt': instance.addedAt.toIso8601String(),
      'addedBy': instance.addedBy,
    };
