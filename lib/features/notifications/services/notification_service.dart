import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user's notifications
  Future<List<AppNotification>> getUserNotifications({
    int limit = 50,
    int offset = 0,
    bool? isRead,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated';
      }

      // Build filter query before applying ordering/range
      var filterQuery = _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId);

      if (isRead != null) {
        filterQuery = filterQuery.eq('is_read', isRead);
      }

      final response = await filterQuery
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((data) => AppNotification.fromSupabase(data))
          .toList();
    } on PostgrestException catch (e) {
      // Table may not exist yet — return empty list rather than crashing
      if (e.code == '42P01') return [];
      throw 'Failed to fetch notifications: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      await _supabase
          .from('notifications')
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      if (e.code == '42P01') return;
      throw 'Failed to mark notification as read: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      await _supabase
          .from('notifications')
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('is_read', false);
    } on PostgrestException catch (e) {
      if (e.code == '42P01') return;
      throw 'Failed to mark all notifications as read: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } on PostgrestException catch (e) {
      if (e.code == '42P01') return 0;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Create a new notification (for system use)
  Future<AppNotification> createNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    NotificationPriority priority = NotificationPriority.normal,
    String? actionUrl,
    DateTime? expiresAt,
  }) async {
    try {
      final response = await _supabase
          .from('notifications')
          .insert({
            'user_id': userId,
            'type': type.name,
            'title': title,
            'message': message,
            'data': data ?? {},
            'priority': priority.name,
            'action_url': actionUrl,
            'expires_at': expiresAt?.toIso8601String(),
          })
          .select()
          .single();

      return AppNotification.fromSupabase(response);
    } on PostgrestException catch (e) {
      throw 'Failed to create notification: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      if (e.code == '42P01') return;
      throw 'Failed to delete notification: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Listen to real-time notification updates
  Stream<List<AppNotification>> getNotificationStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((item) => AppNotification.fromSupabase(item))
            .toList());
  }
}