import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_preferences.dart';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user preferences
  Future<UserPreferences?> getUserPreferences() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (response == null) {
        // Create default preferences
        return await _createDefaultPreferences();
      }

      return UserPreferences.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update user preferences
  Future<UserPreferences> updatePreferences(
    Map<String, dynamic> updates,
  ) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('user_preferences')
          .update(updates)
          .eq('user_id', currentUser.id)
          .select()
          .single();

      return UserPreferences.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }

  // Create default preferences
  Future<UserPreferences> _createDefaultPreferences() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('user_preferences').insert({
        'user_id': currentUser.id,
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();

      return UserPreferences.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create preferences: $e');
    }
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    NotificationPreference? preference,
    bool? bookingReminders,
    bool? eventAnnouncements,
    bool? friendActivity,
    bool? promotionalOffers,
    bool? loyaltyUpdates,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
  }) async {
    final updates = <String, dynamic>{};

    if (preference != null) updates['notification_preference'] = preference.name;
    if (bookingReminders != null) updates['booking_reminders'] = bookingReminders;
    if (eventAnnouncements != null) updates['event_announcements'] = eventAnnouncements;
    if (friendActivity != null) updates['friend_activity'] = friendActivity;
    if (promotionalOffers != null) updates['promotional_offers'] = promotionalOffers;
    if (loyaltyUpdates != null) updates['loyalty_updates'] = loyaltyUpdates;
    if (emailNotifications != null) updates['email_notifications'] = emailNotifications;
    if (pushNotifications != null) updates['push_notifications'] = pushNotifications;
    if (smsNotifications != null) updates['sms_notifications'] = smsNotifications;

    await updatePreferences(updates);
  }

  // Update privacy preferences
  Future<void> updatePrivacyPreferences({
    bool? profileVisible,
    bool? showActivityToFriends,
    bool? showActivityPublic,
    bool? allowFriendRequests,
    bool? shareLocationWithFriends,
  }) async {
    final updates = <String, dynamic>{};

    if (profileVisible != null) updates['profile_visible'] = profileVisible;
    if (showActivityToFriends != null) updates['show_activity_to_friends'] = showActivityToFriends;
    if (showActivityPublic != null) updates['show_activity_public'] = showActivityPublic;
    if (allowFriendRequests != null) updates['allow_friend_requests'] = allowFriendRequests;
    if (shareLocationWithFriends != null) updates['share_location_with_friends'] = shareLocationWithFriends;

    await updatePreferences(updates);
  }

  // Update display preferences
  Future<void> updateDisplayPreferences({
    ThemeMode? themeMode,
    DistanceUnit? distanceUnit,
    CurrencyPreference? currency,
    String? language,
    bool? showTutorials,
  }) async {
    final updates = <String, dynamic>{};

    if (themeMode != null) updates['theme_mode'] = themeMode.name;
    if (distanceUnit != null) updates['distance_unit'] = distanceUnit.name;
    if (currency != null) updates['currency'] = currency.name;
    if (language != null) updates['language'] = language;
    if (showTutorials != null) updates['show_tutorials'] = showTutorials;

    await updatePreferences(updates);
  }

  // Add favorite category
  Future<void> addFavoriteCategory(String category) async {
    try {
      final prefs = await getUserPreferences();
      if (prefs == null) return;

      final categories = List<String>.from(prefs.favoriteCategories);
      if (!categories.contains(category)) {
        categories.add(category);
        await updatePreferences({'favorite_categories': categories});
      }
    } catch (e) {
      throw Exception('Failed to add favorite category: $e');
    }
  }

  // Remove favorite category
  Future<void> removeFavoriteCategory(String category) async {
    try {
      final prefs = await getUserPreferences();
      if (prefs == null) return;

      final categories = List<String>.from(prefs.favoriteCategories);
      categories.remove(category);
      await updatePreferences({'favorite_categories': categories});
    } catch (e) {
      throw Exception('Failed to remove favorite category: $e');
    }
  }

  // Update booking preferences
  Future<void> updateBookingPreferences({
    bool? autoConfirmBookings,
    bool? sendBookingConfirmation,
    int? defaultPartySize,
    String? preferredPaymentMethod,
  }) async {
    final updates = <String, dynamic>{};

    if (autoConfirmBookings != null) updates['auto_confirm_bookings'] = autoConfirmBookings;
    if (sendBookingConfirmation != null) updates['send_booking_confirmation'] = sendBookingConfirmation;
    if (defaultPartySize != null) updates['default_party_size'] = defaultPartySize;
    if (preferredPaymentMethod != null) updates['preferred_payment_method'] = preferredPaymentMethod;

    await updatePreferences(updates);
  }

  // Update accessibility preferences
  Future<void> updateAccessibilityPreferences({
    double? fontSize,
    bool? highContrast,
    bool? screenReaderOptimized,
  }) async {
    final updates = <String, dynamic>{};

    if (fontSize != null) updates['font_size'] = fontSize;
    if (highContrast != null) updates['high_contrast'] = highContrast;
    if (screenReaderOptimized != null) updates['screen_reader_optimized'] = screenReaderOptimized;

    await updatePreferences(updates);
  }

  // Reset preferences to defaults
  Future<void> resetToDefaults() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('user_preferences').delete().eq('user_id', currentUser.id);
      await _createDefaultPreferences();
    } catch (e) {
      throw Exception('Failed to reset preferences: $e');
    }
  }
}
