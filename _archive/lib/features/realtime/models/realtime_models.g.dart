// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveVenueAvailabilityImpl _$$LiveVenueAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$LiveVenueAvailabilityImpl(
      venueId: json['venueId'] as String,
      venueName: json['venueName'] as String,
      status: $enumDecode(_$VenueAvailabilityStatusEnumMap, json['status']),
      currentCapacity: (json['currentCapacity'] as num).toInt(),
      maxCapacity: (json['maxCapacity'] as num).toInt(),
      availableTables: (json['availableTables'] as num).toInt(),
      totalTables: (json['totalTables'] as num).toInt(),
      estimatedWaitTime: (json['estimatedWaitTime'] as num?)?.toInt() ?? 0,
      queueLength: (json['queueLength'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LiveVenueAvailabilityImplToJson(
        _$LiveVenueAvailabilityImpl instance) =>
    <String, dynamic>{
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'status': _$VenueAvailabilityStatusEnumMap[instance.status]!,
      'currentCapacity': instance.currentCapacity,
      'maxCapacity': instance.maxCapacity,
      'availableTables': instance.availableTables,
      'totalTables': instance.totalTables,
      'estimatedWaitTime': instance.estimatedWaitTime,
      'queueLength': instance.queueLength,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$VenueAvailabilityStatusEnumMap = {
  VenueAvailabilityStatus.available: 'available',
  VenueAvailabilityStatus.filling: 'filling',
  VenueAvailabilityStatus.full: 'full',
  VenueAvailabilityStatus.closed: 'closed',
};

_$BookingStatusUpdateImpl _$$BookingStatusUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingStatusUpdateImpl(
      bookingId: json['bookingId'] as String,
      updateType: $enumDecode(_$BookingUpdateTypeEnumMap, json['updateType']),
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      changes: json['changes'] as Map<String, dynamic>?,
      notificationId: json['notificationId'] as String?,
    );

Map<String, dynamic> _$$BookingStatusUpdateImplToJson(
        _$BookingStatusUpdateImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'updateType': _$BookingUpdateTypeEnumMap[instance.updateType]!,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'changes': instance.changes,
      'notificationId': instance.notificationId,
    };

const _$BookingUpdateTypeEnumMap = {
  BookingUpdateType.confirmed: 'confirmed',
  BookingUpdateType.modified: 'modified',
  BookingUpdateType.cancelled: 'cancelled',
  BookingUpdateType.completed: 'completed',
  BookingUpdateType.noShow: 'noShow',
};

_$QueueEntryImpl _$$QueueEntryImplFromJson(Map<String, dynamic> json) =>
    _$QueueEntryImpl(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String?,
      partySize: (json['partySize'] as num).toInt(),
      status: $enumDecode(_$QueueStatusEnumMap, json['status']),
      position: (json['position'] as num).toInt(),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      calledAt: json['calledAt'] == null
          ? null
          : DateTime.parse(json['calledAt'] as String),
      seatedAt: json['seatedAt'] == null
          ? null
          : DateTime.parse(json['seatedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      estimatedWaitMinutes:
          (json['estimatedWaitMinutes'] as num?)?.toInt() ?? 0,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$QueueEntryImplToJson(_$QueueEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'partySize': instance.partySize,
      'status': _$QueueStatusEnumMap[instance.status]!,
      'position': instance.position,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'calledAt': instance.calledAt?.toIso8601String(),
      'seatedAt': instance.seatedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'estimatedWaitMinutes': instance.estimatedWaitMinutes,
      'preferences': instance.preferences,
    };

const _$QueueStatusEnumMap = {
  QueueStatus.waiting: 'waiting',
  QueueStatus.called: 'called',
  QueueStatus.seated: 'seated',
  QueueStatus.expired: 'expired',
  QueueStatus.cancelled: 'cancelled',
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'content': instance.content,
      'messageType': instance.messageType,
      'attachments': instance.attachments,
      'sentAt': instance.sentAt.toIso8601String(),
      'isRead': instance.isRead,
      'readAt': instance.readAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'editedAt': instance.editedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$UserPresenceImpl _$$UserPresenceImplFromJson(Map<String, dynamic> json) =>
    _$UserPresenceImpl(
      userId: json['userId'] as String,
      isOnline: json['isOnline'] as bool,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      currentActivity: json['currentActivity'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserPresenceImplToJson(_$UserPresenceImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'currentActivity': instance.currentActivity,
      'metadata': instance.metadata,
    };

_$TypingIndicatorImpl _$$TypingIndicatorImplFromJson(
        Map<String, dynamic> json) =>
    _$TypingIndicatorImpl(
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
    );

Map<String, dynamic> _$$TypingIndicatorImplToJson(
        _$TypingIndicatorImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'userName': instance.userName,
      'startedAt': instance.startedAt.toIso8601String(),
    };

_$EventUpdateImpl _$$EventUpdateImplFromJson(Map<String, dynamic> json) =>
    _$EventUpdateImpl(
      eventId: json['eventId'] as String,
      updateType: json['updateType'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      changes: json['changes'] as Map<String, dynamic>?,
      isUrgent: json['isUrgent'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventUpdateImplToJson(_$EventUpdateImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'updateType': instance.updateType,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'changes': instance.changes,
      'isUrgent': instance.isUrgent,
    };
