import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool isRead,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    String? actionUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
  
  factory AppNotification.fromSupabase(Map<String, dynamic> data) {
    return AppNotification(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.systemAnnouncement,
      ),
      title: data['title'] as String,
      message: data['message'] as String,
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      isRead: data['is_read'] as bool? ?? false,
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      actionUrl: data['action_url'] as String?,
      expiresAt: data['expires_at'] != null 
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}

enum NotificationType {
  @JsonValue('booking_confirmed')
  bookingConfirmed,
  @JsonValue('booking_cancelled')
  bookingCancelled,
  @JsonValue('event_reminder')
  eventReminder,
  @JsonValue('payment_success')
  paymentSuccess,
  @JsonValue('payment_failed')
  paymentFailed,
  @JsonValue('club_offer')
  clubOffer,
  @JsonValue('system_announcement')
  systemAnnouncement,
  @JsonValue('welcome')
  welcome,
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.bookingConfirmed:
        return 'Booking Confirmed';
      case NotificationType.bookingCancelled:
        return 'Booking Cancelled';
      case NotificationType.eventReminder:
        return 'Event Reminder';
      case NotificationType.paymentSuccess:
        return 'Payment Success';
      case NotificationType.paymentFailed:
        return 'Payment Failed';
      case NotificationType.clubOffer:
        return 'Special Offer';
      case NotificationType.systemAnnouncement:
        return 'Announcement';
      case NotificationType.welcome:
        return 'Welcome';
    }
  }

  String get iconName {
    switch (this) {
      case NotificationType.bookingConfirmed:
        return 'check_circle';
      case NotificationType.bookingCancelled:
        return 'cancel';
      case NotificationType.eventReminder:
        return 'event';
      case NotificationType.paymentSuccess:
        return 'payment';
      case NotificationType.paymentFailed:
        return 'error';
      case NotificationType.clubOffer:
        return 'local_offer';
      case NotificationType.systemAnnouncement:
        return 'announcement';
      case NotificationType.welcome:
        return 'waving_hand';
    }
  }
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }
}