import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationList extends _$NotificationList {
  @override
  Future<List<AppNotification>> build() async {
    return await NotificationService().getUserNotifications();
  }

  // Refresh notifications
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await NotificationService().getUserNotifications();
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    state = await AsyncValue.guard(() async {
      await NotificationService().markAsRead(notificationId);
      
      // Update local state
      final currentNotifications = state.value ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(
            isRead: true,
            updatedAt: DateTime.now(),
          );
        }
        return notification;
      }).toList();
      
      return updatedNotifications;
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    state = await AsyncValue.guard(() async {
      await NotificationService().markAllAsRead();
      
      // Update local state
      final currentNotifications = state.value ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        return notification.copyWith(
          isRead: true,
          updatedAt: DateTime.now(),
        );
      }).toList();
      
      return updatedNotifications;
    });
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    state = await AsyncValue.guard(() async {
      await NotificationService().deleteNotification(notificationId);
      
      // Update local state
      final currentNotifications = state.value ?? [];
      return currentNotifications
          .where((notification) => notification.id != notificationId)
          .toList();
    });
  }
}

@riverpod
Future<int> unreadNotificationCount(UnreadNotificationCountRef ref) async {
  return await NotificationService().getUnreadCount();
}

@riverpod
Stream<List<AppNotification>> notificationStream(NotificationStreamRef ref) {
  return NotificationService().getNotificationStream();
}

// Filter providers
@riverpod
List<AppNotification> unreadNotifications(UnreadNotificationsRef ref) {
  final notifications = ref.watch(notificationListProvider);
  return notifications.when(
    data: (notifications) => notifications.where((n) => !n.isRead).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
List<AppNotification> notificationsByType(
  NotificationsByTypeRef ref,
  NotificationType type,
) {
  final notifications = ref.watch(notificationListProvider);
  return notifications.when(
    data: (notifications) => notifications.where((n) => n.type == type).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
List<AppNotification> priorityNotifications(PriorityNotificationsRef ref) {
  final notifications = ref.watch(notificationListProvider);
  return notifications.when(
    data: (notifications) => notifications
        .where((n) => n.priority == NotificationPriority.high || 
                     n.priority == NotificationPriority.urgent)
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}