// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_resale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketResaleImpl _$$TicketResaleImplFromJson(Map<String, dynamic> json) =>
    _$TicketResaleImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      sellerId: json['sellerId'] as String,
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String?,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      listingPrice: (json['listingPrice'] as num).toDouble(),
      sellerName: json['sellerName'] as String?,
      ticketType: json['ticketType'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$ResaleStatusEnumMap, json['status']) ??
          ResaleStatus.listed,
      listedAt: DateTime.parse(json['listedAt'] as String),
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
      buyerId: json['buyerId'] as String?,
      buyerName: json['buyerName'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$TicketResaleImplToJson(_$TicketResaleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'sellerId': instance.sellerId,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate?.toIso8601String(),
      'originalPrice': instance.originalPrice,
      'listingPrice': instance.listingPrice,
      'sellerName': instance.sellerName,
      'ticketType': instance.ticketType,
      'quantity': instance.quantity,
      'description': instance.description,
      'status': _$ResaleStatusEnumMap[instance.status]!,
      'listedAt': instance.listedAt.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$ResaleStatusEnumMap = {
  ResaleStatus.listed: 'listed',
  ResaleStatus.sold: 'sold',
  ResaleStatus.cancelled: 'cancelled',
  ResaleStatus.expired: 'expired',
};

_$ResaleOfferImpl _$$ResaleOfferImplFromJson(Map<String, dynamic> json) =>
    _$ResaleOfferImpl(
      id: json['id'] as String,
      resaleId: json['resaleId'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String?,
      offeredPrice: (json['offeredPrice'] as num).toDouble(),
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$ResaleOfferImplToJson(_$ResaleOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resaleId': instance.resaleId,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'offeredPrice': instance.offeredPrice,
      'message': instance.message,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };
