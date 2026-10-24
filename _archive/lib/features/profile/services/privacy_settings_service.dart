import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_preferences.dart';

class PrivacySettingsService {
  static final PrivacySettingsService _instance = PrivacySettingsService._internal();
  factory PrivacySettingsService() => _instance;
  PrivacySettingsService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get privacy settings
  Future<PrivacySettings?> getPrivacySettings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('privacy_settings')
          .select()
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (response == null) {
        return await _createDefaultSettings();
      }

      return PrivacySettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update privacy settings
  Future<PrivacySettings> updateSettings(Map<String, dynamic> updates) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('privacy_settings')
          .update(updates)
          .eq('user_id', currentUser.id)
          .select()
          .single();

      return PrivacySettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update privacy settings: $e');
    }
  }

  // Create default settings
  Future<PrivacySettings> _createDefaultSettings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('privacy_settings').insert({
        'user_id': currentUser.id,
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();

      return PrivacySettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create privacy settings: $e');
    }
  }

  // Update profile visibility
  Future<void> updateProfileVisibility(bool visible) async {
    await updateSettings({'show_email': visible});
  }

  // Update contact info visibility
  Future<void> updateContactVisibility({
    bool? showEmail,
    bool? showPhone,
  }) async {
    final updates = <String, dynamic>{};
    if (showEmail != null) updates['show_email'] = showEmail;
    if (showPhone != null) updates['show_phone'] = showPhone;

    await updateSettings(updates);
  }

  // Update personal info visibility
  Future<void> updatePersonalInfoVisibility({
    bool? showDateOfBirth,
    bool? showGender,
    bool? showLocation,
  }) async {
    final updates = <String, dynamic>{};
    if (showDateOfBirth != null) updates['show_date_of_birth'] = showDateOfBirth;
    if (showGender != null) updates['show_gender'] = showGender;
    if (showLocation != null) updates['show_location'] = showLocation;

    await updateSettings(updates);
  }

  // Update social settings
  Future<void> updateSocialSettings({
    bool? allowTagging,
    bool? allowMentions,
  }) async {
    final updates = <String, dynamic>{};
    if (allowTagging != null) updates['allow_tagging'] = allowTagging;
    if (allowMentions != null) updates['allow_mentions'] = allowMentions;

    await updateSettings(updates);
  }

  // Update data sharing preferences
  Future<void> updateDataSharing({
    bool? allowDataSharing,
    bool? allowMarketingEmails,
  }) async {
    final updates = <String, dynamic>{};
    if (allowDataSharing != null) updates['allow_data_sharing'] = allowDataSharing;
    if (allowMarketingEmails != null) updates['allow_marketing_emails'] = allowMarketingEmails;

    await updateSettings(updates);
  }

  // Block user
  Future<void> blockUser(String userId) async {
    try {
      final settings = await getPrivacySettings();
      if (settings == null) return;

      final blockedUsers = List<String>.from(settings.blockedUsers);
      if (!blockedUsers.contains(userId)) {
        blockedUsers.add(userId);
        await updateSettings({'blocked_users': blockedUsers});
      }
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  // Unblock user
  Future<void> unblockUser(String userId) async {
    try {
      final settings = await getPrivacySettings();
      if (settings == null) return;

      final blockedUsers = List<String>.from(settings.blockedUsers);
      blockedUsers.remove(userId);
      await updateSettings({'blocked_users': blockedUsers});
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  // Get blocked users list
  Future<List<Map<String, dynamic>>> getBlockedUsers() async {
    try {
      final settings = await getPrivacySettings();
      if (settings == null || settings.blockedUsers.isEmpty) return [];

      final response = await _supabase
          .from('users')
          .select('id, name, avatar_url')
          .in_('id', settings.blockedUsers);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Check if user is blocked
  Future<bool> isUserBlocked(String userId) async {
    try {
      final settings = await getPrivacySettings();
      return settings?.blockedUsers.contains(userId) ?? false;
    } catch (e) {
      return false;
    }
  }
}

class NotificationSettingsService {
  static final NotificationSettingsService _instance =
      NotificationSettingsService._internal();
  factory NotificationSettingsService() => _instance;
  NotificationSettingsService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get notification settings
  Future<NotificationSettings?> getNotificationSettings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('notification_settings')
          .select()
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (response == null) {
        return await _createDefaultSettings();
      }

      return NotificationSettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update notification settings
  Future<NotificationSettings> updateSettings(
    Map<String, dynamic> updates,
  ) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('notification_settings')
          .update(updates)
          .eq('user_id', currentUser.id)
          .select()
          .single();

      return NotificationSettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update notification settings: $e');
    }
  }

  // Create default settings
  Future<NotificationSettings> _createDefaultSettings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('notification_settings').insert({
        'user_id': currentUser.id,
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();

      return NotificationSettings.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create notification settings: $e');
    }
  }

  // Update push notification settings
  Future<void> updatePushSettings({
    bool? enabled,
    bool? bookings,
    bool? events,
    bool? messages,
    bool? friendRequests,
    bool? promotions,
  }) async {
    final updates = <String, dynamic>{};
    if (enabled != null) updates['push_enabled'] = enabled;
    if (bookings != null) updates['push_bookings'] = bookings;
    if (events != null) updates['push_events'] = events;
    if (messages != null) updates['push_messages'] = messages;
    if (friendRequests != null) updates['push_friend_requests'] = friendRequests;
    if (promotions != null) updates['push_promotions'] = promotions;

    await updateSettings(updates);
  }

  // Update email notification settings
  Future<void> updateEmailSettings({
    bool? enabled,
    bool? bookings,
    bool? events,
    bool? messages,
    bool? friendRequests,
    bool? promotions,
    bool? weeklyDigest,
  }) async {
    final updates = <String, dynamic>{};
    if (enabled != null) updates['email_enabled'] = enabled;
    if (bookings != null) updates['email_bookings'] = bookings;
    if (events != null) updates['email_events'] = events;
    if (messages != null) updates['email_messages'] = messages;
    if (friendRequests != null) updates['email_friend_requests'] = friendRequests;
    if (promotions != null) updates['email_promotions'] = promotions;
    if (weeklyDigest != null) updates['email_weekly_digest'] = weeklyDigest;

    await updateSettings(updates);
  }

  // Update SMS notification settings
  Future<void> updateSmsSettings({
    bool? enabled,
    bool? bookingReminders,
    bool? eventReminders,
  }) async {
    final updates = <String, dynamic>{};
    if (enabled != null) updates['sms_enabled'] = enabled;
    if (bookingReminders != null) updates['sms_booking_reminders'] = bookingReminders;
    if (eventReminders != null) updates['sms_event_reminders'] = eventReminders;

    await updateSettings(updates);
  }

  // Update quiet hours
  Future<void> updateQuietHours({
    bool? enabled,
    String? start,
    String? end,
  }) async {
    final updates = <String, dynamic>{};
    if (enabled != null) updates['quiet_hours_enabled'] = enabled;
    if (start != null) updates['quiet_hours_start'] = start;
    if (end != null) updates['quiet_hours_end'] = end;

    await updateSettings(updates);
  }

  // Check if notifications should be sent (respects quiet hours)
  Future<bool> shouldSendNotification() async {
    try {
      final settings = await getNotificationSettings();
      if (settings == null || !settings.quietHoursEnabled) return true;

      if (settings.quietHoursStart == null || settings.quietHoursEnd == null) {
        return true;
      }

      final now = DateTime.now();
      final start = _parseTimeString(settings.quietHoursStart!);
      final end = _parseTimeString(settings.quietHoursEnd!);

      final currentMinutes = now.hour * 60 + now.minute;
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;

      if (startMinutes <= endMinutes) {
        // Quiet hours don't cross midnight
        return currentMinutes < startMinutes || currentMinutes >= endMinutes;
      } else {
        // Quiet hours cross midnight
        return currentMinutes >= endMinutes && currentMinutes < startMinutes;
      }
    } catch (e) {
      return true; // Default to allowing notifications if check fails
    }
  }

  DateTime _parseTimeString(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(0, 1, 1, hour, minute);
  }
}
