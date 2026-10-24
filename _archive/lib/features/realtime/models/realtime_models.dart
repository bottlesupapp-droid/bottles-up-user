import 'package:freezed_annotation/freezed_annotation.dart';

part 'realtime_models.freezed.dart';
part 'realtime_models.g.dart';

enum VenueAvailabilityStatus {
  available,
  filling,
  full,
  closed,
}

enum BookingUpdateType {
  confirmed,
  modified,
  cancelled,
  completed,
  noShow,
}

enum QueueStatus {
  waiting,
  called,
  seated,
  expired,
  cancelled,
}

@freezed
class LiveVenueAvailability with _$LiveVenueAvailability {
  const factory LiveVenueAvailability({
    required String venueId,
    required String venueName,
    required VenueAvailabilityStatus status,
    required int currentCapacity,
    required int maxCapacity,
    required int availableTables,
    required int totalTables,
    @Default(0) int estimatedWaitTime,
    @Default(0) int queueLength,
    required DateTime lastUpdated,
    Map<String, dynamic>? metadata,
  }) = _LiveVenueAvailability;

  factory LiveVenueAvailability.fromJson(Map<String, dynamic> json) =>
      _$LiveVenueAvailabilityFromJson(json);

  factory LiveVenueAvailability.fromSupabase(Map<String, dynamic> data) {
    return LiveVenueAvailability(
      venueId: data['venue_id'] as String,
      venueName: data['venue_name'] as String,
      status: VenueAvailabilityStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => VenueAvailabilityStatus.available,
      ),
      currentCapacity: data['current_capacity'] as int,
      maxCapacity: data['max_capacity'] as int,
      availableTables: data['available_tables'] as int,
      totalTables: data['total_tables'] as int,
      estimatedWaitTime: data['estimated_wait_time'] as int? ?? 0,
      queueLength: data['queue_length'] as int? ?? 0,
      lastUpdated: DateTime.parse(data['last_updated'] as String),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class BookingStatusUpdate with _$BookingStatusUpdate {
  const factory BookingStatusUpdate({
    required String bookingId,
    required BookingUpdateType updateType,
    required String message,
    required DateTime timestamp,
    Map<String, dynamic>? changes,
    String? notificationId,
  }) = _BookingStatusUpdate;

  factory BookingStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$BookingStatusUpdateFromJson(json);

  factory BookingStatusUpdate.fromSupabase(Map<String, dynamic> data) {
    return BookingStatusUpdate(
      bookingId: data['booking_id'] as String,
      updateType: BookingUpdateType.values.firstWhere(
        (e) => e.name == data['update_type'],
        orElse: () => BookingUpdateType.confirmed,
      ),
      message: data['message'] as String,
      timestamp: DateTime.parse(data['timestamp'] as String),
      changes: data['changes'] != null
          ? Map<String, dynamic>.from(data['changes'] as Map)
          : null,
      notificationId: data['notification_id'] as String?,
    );
  }
}

@freezed
class QueueEntry with _$QueueEntry {
  const factory QueueEntry({
    required String id,
    required String venueId,
    required String userId,
    required String userName,
    String? userPhone,
    required int partySize,
    required QueueStatus status,
    required int position,
    required DateTime joinedAt,
    DateTime? calledAt,
    DateTime? seatedAt,
    DateTime? expiresAt,
    @Default(0) int estimatedWaitMinutes,
    Map<String, dynamic>? preferences,
  }) = _QueueEntry;

  factory QueueEntry.fromJson(Map<String, dynamic> json) =>
      _$QueueEntryFromJson(json);

  factory QueueEntry.fromSupabase(Map<String, dynamic> data) {
    return QueueEntry(
      id: data['id'] as String,
      venueId: data['venue_id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userPhone: data['user_phone'] as String?,
      partySize: data['party_size'] as int,
      status: QueueStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => QueueStatus.waiting,
      ),
      position: data['position'] as int,
      joinedAt: DateTime.parse(data['joined_at'] as String),
      calledAt: data['called_at'] != null
          ? DateTime.parse(data['called_at'] as String)
          : null,
      seatedAt: data['seated_at'] != null
          ? DateTime.parse(data['seated_at'] as String)
          : null,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      estimatedWaitMinutes: data['estimated_wait_minutes'] as int? ?? 0,
      preferences: data['preferences'] != null
          ? Map<String, dynamic>.from(data['preferences'] as Map)
          : null,
    );
  }
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String content,
    @Default('text') String messageType,
    @Default([]) List<String> attachments,
    required DateTime sentAt,
    @Default(false) bool isRead,
    DateTime? readAt,
    @Default(false) bool isEdited,
    DateTime? editedAt,
    Map<String, dynamic>? metadata,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromSupabase(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] as String,
      conversationId: data['conversation_id'] as String,
      senderId: data['sender_id'] as String,
      senderName: data['sender_name'] as String,
      senderAvatar: data['sender_avatar'] as String?,
      content: data['content'] as String,
      messageType: data['message_type'] as String? ?? 'text',
      attachments: data['attachments'] != null
          ? List<String>.from(data['attachments'] as List)
          : [],
      sentAt: DateTime.parse(data['sent_at'] as String),
      isRead: data['is_read'] as bool? ?? false,
      readAt: data['read_at'] != null
          ? DateTime.parse(data['read_at'] as String)
          : null,
      isEdited: data['is_edited'] as bool? ?? false,
      editedAt: data['edited_at'] != null
          ? DateTime.parse(data['edited_at'] as String)
          : null,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class UserPresence with _$UserPresence {
  const factory UserPresence({
    required String userId,
    required bool isOnline,
    DateTime? lastSeen,
    String? currentActivity,
    Map<String, dynamic>? metadata,
  }) = _UserPresence;

  factory UserPresence.fromJson(Map<String, dynamic> json) =>
      _$UserPresenceFromJson(json);

  factory UserPresence.fromSupabase(Map<String, dynamic> data) {
    return UserPresence(
      userId: data['user_id'] as String,
      isOnline: data['is_online'] as bool,
      lastSeen: data['last_seen'] != null
          ? DateTime.parse(data['last_seen'] as String)
          : null,
      currentActivity: data['current_activity'] as String?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class TypingIndicator with _$TypingIndicator {
  const factory TypingIndicator({
    required String conversationId,
    required String userId,
    required String userName,
    required DateTime startedAt,
  }) = _TypingIndicator;

  factory TypingIndicator.fromJson(Map<String, dynamic> json) =>
      _$TypingIndicatorFromJson(json);
}

@freezed
class EventUpdate with _$EventUpdate {
  const factory EventUpdate({
    required String eventId,
    required String updateType,
    required String message,
    required DateTime timestamp,
    Map<String, dynamic>? changes,
    @Default(false) bool isUrgent,
  }) = _EventUpdate;

  factory EventUpdate.fromJson(Map<String, dynamic> json) =>
      _$EventUpdateFromJson(json);

  factory EventUpdate.fromSupabase(Map<String, dynamic> data) {
    return EventUpdate(
      eventId: data['event_id'] as String,
      updateType: data['update_type'] as String,
      message: data['message'] as String,
      timestamp: DateTime.parse(data['timestamp'] as String),
      changes: data['changes'] != null
          ? Map<String, dynamic>.from(data['changes'] as Map)
          : null,
      isUrgent: data['is_urgent'] as bool? ?? false,
    );
  }
}
