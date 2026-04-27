// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnhancedEventRSVPImpl _$$EnhancedEventRSVPImplFromJson(
        Map<String, dynamic> json) =>
    _$EnhancedEventRSVPImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      response: $enumDecode(_$RsvpResponseEnumMap, json['response']),
      plusOneEnabled: json['plusOneEnabled'] as bool? ?? false,
      plusOneName: json['plusOneName'] as String?,
      specialRequests: json['specialRequests'] as String?,
      verificationCode: json['verificationCode'] as String?,
      qrCodeData: json['qrCodeData'] as String?,
      isAttended: json['isAttended'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? false,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
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

Map<String, dynamic> _$$EnhancedEventRSVPImplToJson(
        _$EnhancedEventRSVPImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'email': instance.email,
      'phone': instance.phone,
      'response': _$RsvpResponseEnumMap[instance.response]!,
      'plusOneEnabled': instance.plusOneEnabled,
      'plusOneName': instance.plusOneName,
      'specialRequests': instance.specialRequests,
      'verificationCode': instance.verificationCode,
      'qrCodeData': instance.qrCodeData,
      'isAttended': instance.isAttended,
      'isVisible': instance.isVisible,
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verifiedBy': instance.verifiedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RsvpResponseEnumMap = {
  RsvpResponse.going: 'going',
  RsvpResponse.maybe: 'maybe',
  RsvpResponse.notGoing: 'not_going',
  RsvpResponse.notResponded: 'not_responded',
};

_$RsvpCountsImpl _$$RsvpCountsImplFromJson(Map<String, dynamic> json) =>
    _$RsvpCountsImpl(
      going: (json['going'] as num?)?.toInt() ?? 0,
      maybe: (json['maybe'] as num?)?.toInt() ?? 0,
      notGoing: (json['notGoing'] as num?)?.toInt() ?? 0,
      notResponded: (json['notResponded'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      plusOnes: (json['plusOnes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RsvpCountsImplToJson(_$RsvpCountsImpl instance) =>
    <String, dynamic>{
      'going': instance.going,
      'maybe': instance.maybe,
      'notGoing': instance.notGoing,
      'notResponded': instance.notResponded,
      'total': instance.total,
      'plusOnes': instance.plusOnes,
    };

_$GuestListVisibilityImpl _$$GuestListVisibilityImplFromJson(
        Map<String, dynamic> json) =>
    _$GuestListVisibilityImpl(
      eventId: json['eventId'] as String,
      showGuestList: json['showGuestList'] as bool? ?? true,
      showRsvpCount: json['showRsvpCount'] as bool? ?? true,
      showPlusOnes: json['showPlusOnes'] as bool? ?? false,
      onlyShowConfirmed: json['onlyShowConfirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$$GuestListVisibilityImplToJson(
        _$GuestListVisibilityImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'showGuestList': instance.showGuestList,
      'showRsvpCount': instance.showRsvpCount,
      'showPlusOnes': instance.showPlusOnes,
      'onlyShowConfirmed': instance.onlyShowConfirmed,
    };

_$FriendAttendingImpl _$$FriendAttendingImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendAttendingImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      response: $enumDecode(_$RsvpResponseEnumMap, json['response']),
      plusOneEnabled: json['plusOneEnabled'] as bool? ?? false,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$FriendAttendingImplToJson(
        _$FriendAttendingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'response': _$RsvpResponseEnumMap[instance.response]!,
      'plusOneEnabled': instance.plusOneEnabled,
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };
