// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketTransferImpl _$$TicketTransferImplFromJson(Map<String, dynamic> json) =>
    _$TicketTransferImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      status: json['status'] as String? ?? 'pending',
      message: json['message'] as String?,
      transferredAt: json['transferredAt'] == null
          ? null
          : DateTime.parse(json['transferredAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      fromUserName: json['fromUserName'] as String?,
      fromUserEmail: json['fromUserEmail'] as String?,
      toUserName: json['toUserName'] as String?,
      toUserEmail: json['toUserEmail'] as String?,
      eventName: json['eventName'] as String?,
      eventDate: json['eventDate'] as String?,
    );

Map<String, dynamic> _$$TicketTransferImplToJson(
        _$TicketTransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'status': instance.status,
      'message': instance.message,
      'transferredAt': instance.transferredAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'fromUserName': instance.fromUserName,
      'fromUserEmail': instance.fromUserEmail,
      'toUserName': instance.toUserName,
      'toUserEmail': instance.toUserEmail,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate,
    };
