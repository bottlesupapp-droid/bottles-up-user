// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupBookingImpl _$$GroupBookingImplFromJson(Map<String, dynamic> json) =>
    _$GroupBookingImpl(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      maxMembers: (json['maxMembers'] as num).toInt(),
      currentMembers: (json['currentMembers'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      amountPerPerson: (json['amountPerPerson'] as num).toDouble(),
      status:
          $enumDecodeNullable(_$GroupBookingStatusEnumMap, json['status']) ??
              GroupBookingStatus.pending,
      confirmationDeadline: json['confirmationDeadline'] == null
          ? null
          : DateTime.parse(json['confirmationDeadline'] as String),
      specialRequests: json['specialRequests'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GroupBookingImplToJson(_$GroupBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'organizerName': instance.organizerName,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'maxMembers': instance.maxMembers,
      'currentMembers': instance.currentMembers,
      'totalAmount': instance.totalAmount,
      'amountPerPerson': instance.amountPerPerson,
      'status': _$GroupBookingStatusEnumMap[instance.status]!,
      'confirmationDeadline': instance.confirmationDeadline?.toIso8601String(),
      'specialRequests': instance.specialRequests,
      'members': instance.members,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GroupBookingStatusEnumMap = {
  GroupBookingStatus.pending: 'pending',
  GroupBookingStatus.confirmed: 'confirmed',
  GroupBookingStatus.cancelled: 'cancelled',
  GroupBookingStatus.completed: 'completed',
};

_$GroupMemberImpl _$$GroupMemberImplFromJson(Map<String, dynamic> json) =>
    _$GroupMemberImpl(
      id: json['id'] as String,
      groupBookingId: json['groupBookingId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      amountOwed: (json['amountOwed'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num?)?.toDouble(),
      status: $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
          MemberStatus.invited,
      invitedAt: json['invitedAt'] == null
          ? null
          : DateTime.parse(json['invitedAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentIntentId: json['paymentIntentId'] as String?,
    );

Map<String, dynamic> _$$GroupMemberImplToJson(_$GroupMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupBookingId': instance.groupBookingId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'amountOwed': instance.amountOwed,
      'amountPaid': instance.amountPaid,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'invitedAt': instance.invitedAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentIntentId': instance.paymentIntentId,
    };

const _$MemberStatusEnumMap = {
  MemberStatus.invited: 'invited',
  MemberStatus.accepted: 'accepted',
  MemberStatus.declined: 'declined',
  MemberStatus.paid: 'paid',
};

_$GroupInviteImpl _$$GroupInviteImplFromJson(Map<String, dynamic> json) =>
    _$GroupInviteImpl(
      id: json['id'] as String,
      groupBookingId: json['groupBookingId'] as String,
      invitedByUserId: json['invitedByUserId'] as String,
      invitedByName: json['invitedByName'] as String,
      recipientUserId: json['recipientUserId'] as String?,
      recipientEmail: json['recipientEmail'] as String?,
      recipientPhone: json['recipientPhone'] as String?,
      inviteToken: json['inviteToken'] as String,
      isAccepted: json['isAccepted'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GroupInviteImplToJson(_$GroupInviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupBookingId': instance.groupBookingId,
      'invitedByUserId': instance.invitedByUserId,
      'invitedByName': instance.invitedByName,
      'recipientUserId': instance.recipientUserId,
      'recipientEmail': instance.recipientEmail,
      'recipientPhone': instance.recipientPhone,
      'inviteToken': instance.inviteToken,
      'isAccepted': instance.isAccepted,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
