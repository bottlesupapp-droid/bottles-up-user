// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletPassImpl _$$WalletPassImplFromJson(Map<String, dynamic> json) =>
    _$WalletPassImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      bookingId: json['bookingId'] as String,
      passType: json['passType'] as String,
      eventName: json['eventName'] as String,
      venueName: json['venueName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventTime: json['eventTime'] as String,
      qrCodeData: json['qrCodeData'] as String?,
      verificationCode: json['verificationCode'] as String?,
      tableNumber: json['tableNumber'] as String?,
      partySize: (json['partySize'] as num?)?.toInt(),
      passUrl: json['passUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WalletPassImplToJson(_$WalletPassImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'bookingId': instance.bookingId,
      'passType': instance.passType,
      'eventName': instance.eventName,
      'venueName': instance.venueName,
      'eventDate': instance.eventDate.toIso8601String(),
      'eventTime': instance.eventTime,
      'qrCodeData': instance.qrCodeData,
      'verificationCode': instance.verificationCode,
      'tableNumber': instance.tableNumber,
      'partySize': instance.partySize,
      'passUrl': instance.passUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
