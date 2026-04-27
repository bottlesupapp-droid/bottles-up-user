import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountManagementService {
  static final AccountManagementService _instance = AccountManagementService._internal();
  factory AccountManagementService() => _instance;
  AccountManagementService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Export user data
  Future<Map<String, dynamic>> exportUserData() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Fetch all user data from various tables
      final userData = await _fetchUserProfile();
      final bookings = await _fetchBookings();
      final reviews = await _fetchReviews();
      final favorites = await _fetchFavorites();
      final activities = await _fetchActivities();
      final preferences = await _fetchPreferences();
      final friendsList = await _fetchFriends();
      final loyaltyData = await _fetchLoyaltyData();

      return {
        'export_date': DateTime.now().toIso8601String(),
        'user_id': currentUser.id,
        'profile': userData,
        'bookings': bookings,
        'reviews': reviews,
        'favorites': favorites,
        'activities': activities,
        'preferences': preferences,
        'friends': friendsList,
        'loyalty': loyaltyData,
      };
    } catch (e) {
      throw Exception('Failed to export user data: $e');
    }
  }

  // Export as JSON string
  Future<String> exportUserDataAsJson() async {
    final data = await exportUserData();
    return jsonEncode(data);
  }

  // Request data deletion
  Future<void> requestAccountDeletion({
    required String reason,
    String? additionalComments,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create deletion request
      await _supabase.from('account_deletion_requests').insert({
        'user_id': currentUser.id,
        'reason': reason,
        'additional_comments': additionalComments,
        'requested_at': DateTime.now().toIso8601String(),
        'status': 'pending',
      });

      // Mark account for deletion
      await _supabase.from('users').update({
        'deletion_requested': true,
        'deletion_requested_at': DateTime.now().toIso8601String(),
      }).eq('id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to request account deletion: $e');
    }
  }

  // Cancel deletion request
  Future<void> cancelDeletionRequest() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('account_deletion_requests')
          .update({'status': 'cancelled'})
          .eq('user_id', currentUser.id)
          .eq('status', 'pending');

      await _supabase.from('users').update({
        'deletion_requested': false,
        'deletion_requested_at': null,
      }).eq('id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to cancel deletion request: $e');
    }
  }

  // Permanently delete account (called by backend after grace period)
  Future<void> permanentlyDeleteAccount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // This would typically be handled by backend with proper cleanup
      await _supabase.rpc('delete_user_account', params: {
        'user_id_param': currentUser.id,
      });

      // Sign out after deletion
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Anonymize user data instead of deletion
  Future<void> anonymizeAccount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.rpc('anonymize_user_account', params: {
        'user_id_param': currentUser.id,
      });

      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to anonymize account: $e');
    }
  }

  // Private helper methods to fetch data

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return {};

    final response = await _supabase
        .from('users')
        .select()
        .eq('id', currentUser.id)
        .maybeSingle();

    return response ?? {};
  }

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('bookings')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('reviews')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> _fetchFavorites() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', currentUser.id);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> _fetchActivities() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('user_activities')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false)
        .limit(1000);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<Map<String, dynamic>> _fetchPreferences() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return {};

    final response = await _supabase
        .from('user_preferences')
        .select()
        .eq('user_id', currentUser.id)
        .maybeSingle();

    return response ?? {};
  }

  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('friends')
        .select()
        .eq('user_id', currentUser.id);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<Map<String, dynamic>> _fetchLoyaltyData() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return {};

    final response = await _supabase
        .from('user_loyalty')
        .select()
        .eq('user_id', currentUser.id)
        .maybeSingle();

    return response ?? {};
  }

  // Get account deletion status
  Future<Map<String, dynamic>?> getDeletionRequestStatus() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('account_deletion_requests')
          .select()
          .eq('user_id', currentUser.id)
          .eq('status', 'pending')
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Download user data as file (returns bytes)
  Future<List<int>> downloadUserDataAsFile() async {
    final jsonData = await exportUserDataAsJson();
    return utf8.encode(jsonData);
  }

  // Clear specific data types
  Future<void> clearActivityHistory() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('user_activities')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to clear activity history: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('search_history')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

  Future<void> clearSavedItems() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('saved_items')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to clear saved items: $e');
    }
  }

  // Deactivate account (temporary)
  Future<void> deactivateAccount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('users').update({
        'is_active': false,
        'deactivated_at': DateTime.now().toIso8601String(),
      }).eq('id', currentUser.id);

      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to deactivate account: $e');
    }
  }

  // Reactivate account
  Future<void> reactivateAccount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('users').update({
        'is_active': true,
        'deactivated_at': null,
      }).eq('id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to reactivate account: $e');
    }
  }
}
