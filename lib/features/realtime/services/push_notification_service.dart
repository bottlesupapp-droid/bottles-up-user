import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await PushNotificationService().handleBackgroundMessage(message);
}

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final SupabaseClient _supabase = Supabase.instance.client;

  String? _fcmToken;
  bool _isInitialized = false;

  // Notification action callbacks
  Function(String route, Map<String, dynamic>? params)? onNotificationTap;

  // Initialize push notifications
  Future<void> initialize({
    Function(String route, Map<String, dynamic>? params)? onNotificationTap,
  }) async {
    if (_isInitialized) return;

    this.onNotificationTap = onNotificationTap;

    // Request permission
    final notificationSettings = await _requestPermission();
    if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Push notification permission denied');
      return;
    }

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get FCM token
    _fcmToken = await _fcm.getToken();
    if (_fcmToken != null) {
      await _saveFcmToken(_fcmToken!);
    }

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFcmToken(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _isInitialized = true;
  }

  // Request notification permission
  Future<NotificationSettings> _requestPermission() async {
    return await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );
  }

  // Save FCM token to backend
  Future<void> _saveFcmToken(String token) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('user_devices').upsert({
        'user_id': currentUser.id,
        'fcm_token': token,
        'platform': defaultTargetPlatform.name,
        'last_active': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  // Delete FCM token from backend
  Future<void> deleteFcmToken() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null || _fcmToken == null) return;

      await _supabase
          .from('user_devices')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('fcm_token', _fcmToken!);

      await _fcm.deleteToken();
      _fcmToken = null;
    } catch (e) {
      debugPrint('Failed to delete FCM token: $e');
    }
  }

  // Handle foreground message
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.messageId}');

    // Show local notification
    await _showLocalNotification(
      title: message.notification?.title ?? 'New notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );

    // Update badge count
    if (message.data['badge_count'] != null) {
      final count = int.tryParse(message.data['badge_count'].toString()) ?? 0;
      await _updateBadgeCount(count);
    }
  }

  // Handle background message
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Background message received: ${message.messageId}');

    // Process background data
    if (message.data['type'] == 'booking_update') {
      // Update local cache or trigger sync
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');

    final route = message.data['route'] as String?;
    if (route != null && onNotificationTap != null) {
      final params = Map<String, dynamic>.from(message.data);
      params.remove('route');
      onNotificationTap!(route, params.isNotEmpty ? params : null);
    }
  }

  // Handle local notification tap
  void _handleLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.id}');

    if (response.payload != null && onNotificationTap != null) {
      // Parse payload and navigate
      // Payload should be JSON string with route and params
      try {
        final data = Map<String, dynamic>.from(
          Map.from(response.payload as Map),
        );
        final route = data['route'] as String?;
        if (route != null) {
          data.remove('route');
          onNotificationTap!(route, data.isNotEmpty ? data : null);
        }
      } catch (e) {
        debugPrint('Failed to parse notification payload: $e');
      }
    }
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? imageUrl,
    NotificationPriority priority = NotificationPriority.defaultPriority,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription: 'General notifications',
        importance: _mapPriorityToImportance(priority),
        priority: priority,
        styleInformation: imageUrl != null
            ? BigPictureStyleInformation(
                FilePathAndroidBitmap(imageUrl),
              )
            : const DefaultStyleInformation(true, true),
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecond,
        title,
        body,
        notificationDetails,
        payload: payload?.toString(),
      );
    } catch (e) {
      debugPrint('Failed to show local notification: $e');
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Failed to subscribe to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic: $e');
    }
  }

  // Update badge count
  Future<void> _updateBadgeCount(int count) async {
    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(badge: true);

      // iOS badge
      await _fcm.setApplicationIconBadgeNumber(count);
    } catch (e) {
      debugPrint('Failed to update badge count: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
    await _updateBadgeCount(0);
  }

  // Get current FCM token
  String? get fcmToken => _fcmToken;

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await _fcm.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Helper to map priority to importance
  Importance _mapPriorityToImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.min:
        return Importance.min;
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.defaultPriority:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.max:
        return Importance.max;
    }
  }

  // Notification type handlers
  Future<void> sendBookingNotification({
    required String bookingId,
    required String venueName,
    required String message,
  }) async {
    await _showLocalNotification(
      title: 'Booking Update',
      body: message,
      priority: NotificationPriority.high,
      payload: {
        'route': '/booking-details',
        'booking_id': bookingId,
        'venue_name': venueName,
      },
    );
  }

  Future<void> sendEventNotification({
    required String eventId,
    required String eventName,
    required String message,
  }) async {
    await _showLocalNotification(
      title: eventName,
      body: message,
      priority: NotificationPriority.high,
      payload: {
        'route': '/event-details',
        'event_id': eventId,
      },
    );
  }

  Future<void> sendMessageNotification({
    required String conversationId,
    required String senderName,
    required String message,
  }) async {
    await _showLocalNotification(
      title: senderName,
      body: message,
      priority: NotificationPriority.high,
      payload: {
        'route': '/chat',
        'conversation_id': conversationId,
      },
    );
  }

  Future<void> sendQueueNotification({
    required String queueId,
    required String venueName,
    required int position,
  }) async {
    await _showLocalNotification(
      title: 'Queue Update',
      body: 'Your position at $venueName: #$position',
      priority: NotificationPriority.high,
      payload: {
        'route': '/queue-status',
        'queue_id': queueId,
      },
    );
  }

  Future<void> sendPromotionNotification({
    required String promotionId,
    required String title,
    required String message,
    String? imageUrl,
  }) async {
    await _showLocalNotification(
      title: title,
      body: message,
      imageUrl: imageUrl,
      priority: NotificationPriority.defaultPriority,
      payload: {
        'route': '/promotion-details',
        'promotion_id': promotionId,
      },
    );
  }
}

class NotificationChannelManager {
  static final NotificationChannelManager _instance = NotificationChannelManager._internal();
  factory NotificationChannelManager() => _instance;
  NotificationChannelManager._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Create notification channels (Android)
  Future<void> createChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'General notifications',
        importance: Importance.defaultImportance,
      ),
      AndroidNotificationChannel(
        'booking_channel',
        'Booking Updates',
        description: 'Notifications about your bookings',
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'message_channel',
        'Messages',
        description: 'Chat messages',
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'event_channel',
        'Event Updates',
        description: 'Updates about events you\'re attending',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'promotion_channel',
        'Promotions',
        description: 'Special offers and promotions',
        importance: Importance.low,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // Delete notification channel (Android)
  Future<void> deleteChannel(String channelId) async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);
  }
}
