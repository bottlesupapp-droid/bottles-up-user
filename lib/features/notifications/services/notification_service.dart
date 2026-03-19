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

      // Since we might not have the notifications table yet, let's create sample data
      // In production, this would query the actual notifications table
      return _getSampleNotifications(userId);
      
      // When the table exists, use this query:
      /*
      var query = _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (isRead != null) {
        query = query.eq('is_read', isRead);
      }

      final response = await query;
      
      return (response as List)
          .map((data) => AppNotification.fromSupabase(data))
          .toList();
      */
    } on PostgrestException catch (e) {
      throw 'Failed to fetch notifications: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated';
      }

      // In production, this would update the actual notifications table
      /*
      await _supabase
          .from('notifications')
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId)
          .eq('user_id', userId);
      */
    } on PostgrestException catch (e) {
      throw 'Failed to mark notification as read: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated';
      }

      // In production, this would update the actual notifications table
      /*
      await _supabase
          .from('notifications')
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('is_read', false);
      */
    } on PostgrestException catch (e) {
      throw 'Failed to mark all notifications as read: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return 0;
      }

      // Return sample count for now
      return 3;

      // In production, this would query the actual notifications table
      /*
      final response = await _supabase
          .from('notifications')
          .select('id', const FetchOptions(count: CountOption.exact))
          .eq('user_id', userId)
          .eq('is_read', false);

      return response.count ?? 0;
      */
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
      final now = DateTime.now();
      final notification = AppNotification(
        id: 'temp_${now.millisecondsSinceEpoch}',
        userId: userId,
        type: type,
        title: title,
        message: message,
        data: data ?? {},
        priority: priority,
        actionUrl: actionUrl,
        expiresAt: expiresAt,
        createdAt: now,
        updatedAt: now,
      );

      // In production, this would insert into the actual notifications table
      /*
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
      */

      return notification;
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
      if (userId == null) {
        throw 'User not authenticated';
      }

      // In production, this would delete from the actual notifications table
      /*
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId)
          .eq('user_id', userId);
      */
    } on PostgrestException catch (e) {
      throw 'Failed to delete notification: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Generate sample notifications based on user's booking data
  Future<List<AppNotification>> _getSampleNotifications(String userId) async {
    final now = DateTime.now();
    
    // In a real app, these would be generated from actual booking/event data
    return [
      AppNotification(
        id: '1',
        userId: userId,
        type: NotificationType.bookingConfirmed,
        title: 'Booking Confirmed',
        message: 'Your table reservation at Club Luxe has been confirmed for tonight at 9:00 PM.',
        data: {
          'booking_id': 'booking_123',
          'club_name': 'Club Luxe',
          'date': '2024-01-20',
          'time': '21:00',
        },
        priority: NotificationPriority.high,
        actionUrl: '/bookings/booking_123',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '2',
        userId: userId,
        type: NotificationType.eventReminder,
        title: 'Event Reminder',
        message: 'DJ Night at Rooftop Bar starts in 2 hours. Don\'t forget your tickets!',
        data: {
          'event_id': 'event_456',
          'event_name': 'DJ Night',
          'venue': 'Rooftop Bar',
          'start_time': '22:00',
        },
        priority: NotificationPriority.normal,
        actionUrl: '/events/event_456',
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),
      AppNotification(
        id: '3',
        userId: userId,
        type: NotificationType.clubOffer,
        title: 'Special Offer',
        message: '🎉 50% off bottle service at VIP Lounge this weekend! Limited time offer.',
        data: {
          'offer_id': 'offer_789',
          'club_name': 'VIP Lounge',
          'discount': 50,
          'valid_until': '2024-01-25',
        },
        priority: NotificationPriority.normal,
        actionUrl: '/clubs/vip_lounge',
        expiresAt: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      AppNotification(
        id: '4',
        userId: userId,
        type: NotificationType.paymentSuccess,
        title: 'Payment Successful',
        message: 'Your payment of \$150 for table booking has been processed successfully.',
        data: {
          'payment_id': 'pay_101',
          'amount': 150,
          'currency': 'USD',
          'booking_id': 'booking_123',
        },
        priority: NotificationPriority.normal,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: '5',
        userId: userId,
        type: NotificationType.welcome,
        title: 'Welcome to Bottles Up!',
        message: 'Thanks for joining us! Discover the best nightlife experiences in your city.',
        data: {
          'onboarding': true,
        },
        priority: NotificationPriority.low,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Listen to real-time notification updates
  Stream<List<AppNotification>> getNotificationStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value([]);
    }

    // In production, this would listen to real-time changes
    /*
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((item) => AppNotification.fromSupabase(item))
            .toList());
    */

    // For now, return a periodic stream with sample data
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => _getSampleNotifications(userId),
    ).asyncMap((future) => future);
  }
}