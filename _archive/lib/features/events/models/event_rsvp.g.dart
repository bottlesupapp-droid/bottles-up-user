// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_rsvp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventRSVPImpl _$$EventRSVPImplFromJson(Map<String, dynamic> json) =>
    _$EventRSVPImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      rsvpType: $enumDecode(_$RsvpTypeEnumMap, json['rsvpType']),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      specialRequests: json['specialRequests'] as String?,
      status: json['status'] as String? ?? 'pending',
      isAttended: json['isAttended'] as bool? ?? false,
      verificationCode: json['verificationCode'] as String?,
      qrCodeData: json['qrCodeData'] as String?,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verifiedBy: json['verifiedBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EventRSVPImplToJson(_$EventRSVPImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'rsvpType': _$RsvpTypeEnumMap[instance.rsvpType]!,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'specialRequests': instance.specialRequests,
      'status': instance.status,
      'isAttended': instance.isAttended,
      'verificationCode': instance.verificationCode,
      'qrCodeData': instance.qrCodeData,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verifiedBy': instance.verifiedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RsvpTypeEnumMap = {
  RsvpType.guestlist: 'guestlist',
  RsvpType.table: 'table',
};

_$EventTableBookingImpl _$$EventTableBookingImplFromJson(
        Map<String, dynamic> json) =>
    _$EventTableBookingImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      tableId: json['tableId'] as String,
      partySize: (json['partySize'] as num).toInt(),
      depositAmount: (json['depositAmount'] as num).toDouble(),
      minimumBottles: (json['minimumBottles'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      depositPaid: json['depositPaid'] as bool? ?? false,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      specialRequests: json['specialRequests'] as String?,
      splitPayments: (json['splitPayments'] as List<dynamic>?)
          ?.map((e) =>
              SplitPaymentParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EventTableBookingImplToJson(
        _$EventTableBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'tableId': instance.tableId,
      'partySize': instance.partySize,
      'depositAmount': instance.depositAmount,
      'minimumBottles': instance.minimumBottles,
      'status': instance.status,
      'depositPaid': instance.depositPaid,
      'eventDate': instance.eventDate?.toIso8601String(),
      'specialRequests': instance.specialRequests,
      'splitPayments': instance.splitPayments,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$SplitPaymentParticipantImpl _$$SplitPaymentParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$SplitPaymentParticipantImpl(
      id: json['id'] as String,
      tableBookingId: json['tableBookingId'] as String,
      participantName: json['participantName'] as String,
      email: json['email'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      paymentIntentId: json['paymentIntentId'] as String?,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SplitPaymentParticipantImplToJson(
        _$SplitPaymentParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableBookingId': instance.tableBookingId,
      'participantName': instance.participantName,
      'email': instance.email,
      'amount': instance.amount,
      'paymentStatus': instance.paymentStatus,
      'paymentIntentId': instance.paymentIntentId,
      'paidAt': instance.paidAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$EventConfigurationImpl _$$EventConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$EventConfigurationImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      enableGuestlistRsvp: json['enableGuestlistRsvp'] as bool? ?? true,
      enableTableBooking: json['enableTableBooking'] as bool? ?? true,
      minTableDeposit: (json['minTableDeposit'] as num?)?.toDouble() ?? 50.0,
      maxTableDeposit: (json['maxTableDeposit'] as num?)?.toDouble() ?? 200.0,
      minBottleRequirement:
          (json['minBottleRequirement'] as num?)?.toInt() ?? 2,
      maxPartySize: (json['maxPartySize'] as num?)?.toInt() ?? 10,
      serviceFeeRate: (json['serviceFeeRate'] as num?)?.toDouble() ?? 0.07,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.13,
      availableTableIds: (json['availableTableIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tableConfiguration: json['tableConfiguration'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EventConfigurationImplToJson(
        _$EventConfigurationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'enableGuestlistRsvp': instance.enableGuestlistRsvp,
      'enableTableBooking': instance.enableTableBooking,
      'minTableDeposit': instance.minTableDeposit,
      'maxTableDeposit': instance.maxTableDeposit,
      'minBottleRequirement': instance.minBottleRequirement,
      'maxPartySize': instance.maxPartySize,
      'serviceFeeRate': instance.serviceFeeRate,
      'taxRate': instance.taxRate,
      'availableTableIds': instance.availableTableIds,
      'tableConfiguration': instance.tableConfiguration,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
