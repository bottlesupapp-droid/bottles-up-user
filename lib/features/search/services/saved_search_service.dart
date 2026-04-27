import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_filter.dart';

class SavedSearchService {
  static final SavedSearchService _instance = SavedSearchService._internal();
  factory SavedSearchService() => _instance;
  SavedSearchService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Save a search
  Future<void> saveSearch({
    required String name,
    required SearchFilter filter,
    bool enableNotifications = false,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.from('saved_searches').insert({
        'user_id': currentUser.id,
        'name': name,
        'filter': filter.toJson(),
        'notifications_enabled': enableNotifications,
      });
    } catch (e) {
      throw Exception('Failed to save search: $e');
    }
  }

  // Get all saved searches
  Future<List<Map<String, dynamic>>> getSavedSearches() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('saved_searches')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Delete saved search
  Future<void> deleteSavedSearch(String searchId) async {
    try {
      await _supabase.from('saved_searches').delete().eq('id', searchId);
    } catch (e) {
      throw Exception('Failed to delete saved search: $e');
    }
  }

  // Update saved search
  Future<void> updateSavedSearch({
    required String searchId,
    String? name,
    SearchFilter? filter,
    bool? enableNotifications,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (filter != null) updates['filter'] = filter.toJson();
      if (enableNotifications != null) {
        updates['notifications_enabled'] = enableNotifications;
      }

      await _supabase.from('saved_searches').update(updates).eq('id', searchId);
    } catch (e) {
      throw Exception('Failed to update saved search: $e');
    }
  }

  // Increment use count
  Future<void> incrementUseCount(String searchId) async {
    try {
      await _supabase.rpc('increment_saved_search_usage', params: {
        'search_id_param': searchId,
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Toggle notifications
  Future<void> toggleNotifications(String searchId, bool enabled) async {
    try {
      await _supabase.from('saved_searches').update({
        'notifications_enabled': enabled,
      }).eq('id', searchId);
    } catch (e) {
      throw Exception('Failed to toggle notifications: $e');
    }
  }
}
