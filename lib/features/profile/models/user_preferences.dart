import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

enum NotificationPreference {
  all,
  important,
  none,
}

enum ThemeMode {
  light,
  dark,
  system,
}

enum DistanceUnit {
  kilometers,
  miles,
}

enum CurrencyPreference {
  usd,
  eur,
  gbp,
  cad,
  aud,
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required String userId,

    // Notification preferences
    @Default(NotificationPreference.all) NotificationPreference notificationPreference,
    @Default(true) bool bookingReminders,
    @Default(true) bool eventAnnouncements,
    @Default(true) bool friendActivity,
    @Default(true) bool promotionalOffers,
    @Default(true) bool loyaltyUpdates,
    @Default(false) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(false) bool smsNotifications,

    // Privacy settings
    @Default(true) bool profileVisible,
    @Default(true) bool showActivityToFriends,
    @Default(false) bool showActivityPublic,
    @Default(true) bool allowFriendRequests,
    @Default(false) bool shareLocationWithFriends,

    // Display preferences
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(DistanceUnit.kilometers) DistanceUnit distanceUnit,
    @Default(CurrencyPreference.usd) CurrencyPreference currency,
    @Default('en') String language,
    @Default(true) bool showTutorials,

    // Search and discovery
    @Default(true) bool personalizedRecommendations,
    @Default(true) bool saveSearchHistory,
    @Default([]) List<String> favoriteCategories,
    @Default({}) Map<String, dynamic> savedFilters,

    // Booking preferences
    @Default(false) bool autoConfirmBookings,
    @Default(true) bool sendBookingConfirmation,
    @Default(2) int defaultPartySize,
    String? preferredPaymentMethod,

    // Accessibility
    @Default(1.0) double fontSize,
    @Default(false) bool highContrast,
    @Default(false) bool screenReaderOptimized,

    // Other
    Map<String, dynamic>? customSettings,
    required DateTime updatedAt,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  factory UserPreferences.fromSupabase(Map<String, dynamic> data) {
    return UserPreferences(
      userId: data['user_id'] as String,
      notificationPreference: data['notification_preference'] != null
          ? NotificationPreference.values.firstWhere(
              (e) => e.name == data['notification_preference'],
              orElse: () => NotificationPreference.all,
            )
          : NotificationPreference.all,
      bookingReminders: data['booking_reminders'] as bool? ?? true,
      eventAnnouncements: data['event_announcements'] as bool? ?? true,
      friendActivity: data['friend_activity'] as bool? ?? true,
      promotionalOffers: data['promotional_offers'] as bool? ?? true,
      loyaltyUpdates: data['loyalty_updates'] as bool? ?? true,
      emailNotifications: data['email_notifications'] as bool? ?? false,
      pushNotifications: data['push_notifications'] as bool? ?? true,
      smsNotifications: data['sms_notifications'] as bool? ?? false,
      profileVisible: data['profile_visible'] as bool? ?? true,
      showActivityToFriends: data['show_activity_to_friends'] as bool? ?? true,
      showActivityPublic: data['show_activity_public'] as bool? ?? false,
      allowFriendRequests: data['allow_friend_requests'] as bool? ?? true,
      shareLocationWithFriends: data['share_location_with_friends'] as bool? ?? false,
      themeMode: data['theme_mode'] != null
          ? ThemeMode.values.firstWhere(
              (e) => e.name == data['theme_mode'],
              orElse: () => ThemeMode.system,
            )
          : ThemeMode.system,
      distanceUnit: data['distance_unit'] != null
          ? DistanceUnit.values.firstWhere(
              (e) => e.name == data['distance_unit'],
              orElse: () => DistanceUnit.kilometers,
            )
          : DistanceUnit.kilometers,
      currency: data['currency'] != null
          ? CurrencyPreference.values.firstWhere(
              (e) => e.name == data['currency'],
              orElse: () => CurrencyPreference.usd,
            )
          : CurrencyPreference.usd,
      language: data['language'] as String? ?? 'en',
      showTutorials: data['show_tutorials'] as bool? ?? true,
      personalizedRecommendations: data['personalized_recommendations'] as bool? ?? true,
      saveSearchHistory: data['save_search_history'] as bool? ?? true,
      favoriteCategories: data['favorite_categories'] != null
          ? List<String>.from(data['favorite_categories'] as List)
          : [],
      savedFilters: data['saved_filters'] != null
          ? Map<String, dynamic>.from(data['saved_filters'] as Map)
          : {},
      autoConfirmBookings: data['auto_confirm_bookings'] as bool? ?? false,
      sendBookingConfirmation: data['send_booking_confirmation'] as bool? ?? true,
      defaultPartySize: data['default_party_size'] as int? ?? 2,
      preferredPaymentMethod: data['preferred_payment_method'] as String?,
      fontSize: (data['font_size'] as num?)?.toDouble() ?? 1.0,
      highContrast: data['high_contrast'] as bool? ?? false,
      screenReaderOptimized: data['screen_reader_optimized'] as bool? ?? false,
      customSettings: data['custom_settings'] != null
          ? Map<String, dynamic>.from(data['custom_settings'] as Map)
          : null,
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}

@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    required String userId,
    @Default(true) bool showEmail,
    @Default(false) bool showPhone,
    @Default(true) bool showDateOfBirth,
    @Default(true) bool showGender,
    @Default(true) bool showLocation,
    @Default(true) bool allowTagging,
    @Default(true) bool allowMentions,
    @Default(false) bool allowDataSharing,
    @Default(false) bool allowMarketingEmails,
    @Default([]) List<String> blockedUsers,
    required DateTime updatedAt,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);

  factory PrivacySettings.fromSupabase(Map<String, dynamic> data) {
    return PrivacySettings(
      userId: data['user_id'] as String,
      showEmail: data['show_email'] as bool? ?? true,
      showPhone: data['show_phone'] as bool? ?? false,
      showDateOfBirth: data['show_date_of_birth'] as bool? ?? true,
      showGender: data['show_gender'] as bool? ?? true,
      showLocation: data['show_location'] as bool? ?? true,
      allowTagging: data['allow_tagging'] as bool? ?? true,
      allowMentions: data['allow_mentions'] as bool? ?? true,
      allowDataSharing: data['allow_data_sharing'] as bool? ?? false,
      allowMarketingEmails: data['allow_marketing_emails'] as bool? ?? false,
      blockedUsers: data['blocked_users'] != null
          ? List<String>.from(data['blocked_users'] as List)
          : [],
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required String userId,

    // Push notifications
    @Default(true) bool pushEnabled,
    @Default(true) bool pushBookings,
    @Default(true) bool pushEvents,
    @Default(true) bool pushMessages,
    @Default(true) bool pushFriendRequests,
    @Default(true) bool pushPromotions,

    // Email notifications
    @Default(false) bool emailEnabled,
    @Default(true) bool emailBookings,
    @Default(true) bool emailEvents,
    @Default(false) bool emailMessages,
    @Default(true) bool emailFriendRequests,
    @Default(false) bool emailPromotions,
    @Default(false) bool emailWeeklyDigest,

    // SMS notifications
    @Default(false) bool smsEnabled,
    @Default(true) bool smsBookingReminders,
    @Default(false) bool smsEventReminders,

    // Quiet hours
    @Default(false) bool quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,

    required DateTime updatedAt,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  factory NotificationSettings.fromSupabase(Map<String, dynamic> data) {
    return NotificationSettings(
      userId: data['user_id'] as String,
      pushEnabled: data['push_enabled'] as bool? ?? true,
      pushBookings: data['push_bookings'] as bool? ?? true,
      pushEvents: data['push_events'] as bool? ?? true,
      pushMessages: data['push_messages'] as bool? ?? true,
      pushFriendRequests: data['push_friend_requests'] as bool? ?? true,
      pushPromotions: data['push_promotions'] as bool? ?? true,
      emailEnabled: data['email_enabled'] as bool? ?? false,
      emailBookings: data['email_bookings'] as bool? ?? true,
      emailEvents: data['email_events'] as bool? ?? true,
      emailMessages: data['email_messages'] as bool? ?? false,
      emailFriendRequests: data['email_friend_requests'] as bool? ?? true,
      emailPromotions: data['email_promotions'] as bool? ?? false,
      emailWeeklyDigest: data['email_weekly_digest'] as bool? ?? false,
      smsEnabled: data['sms_enabled'] as bool? ?? false,
      smsBookingReminders: data['sms_booking_reminders'] as bool? ?? true,
      smsEventReminders: data['sms_event_reminders'] as bool? ?? false,
      quietHoursEnabled: data['quiet_hours_enabled'] as bool? ?? false,
      quietHoursStart: data['quiet_hours_start'] as String?,
      quietHoursEnd: data['quiet_hours_end'] as String?,
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}
