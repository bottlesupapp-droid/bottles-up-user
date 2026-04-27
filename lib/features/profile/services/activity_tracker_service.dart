import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_activity.dart';

class ActivityTrackerService {
  static final ActivityTrackerService _instance = ActivityTrackerService._internal();
  factory ActivityTrackerService() => _instance;
  ActivityTrackerService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Track activity
  Future<void> trackActivity({
    required ActivityType type,
    required String description,
    String? relatedId,
    String? relatedType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('user_activities').insert({
        'user_id': currentUser.id,
        'type': type.name,
        'description': description,
        'related_id': relatedId,
        'related_type': relatedType,
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Non-critical error - don't throw
    }
  }

  // Get user activities
  Future<List<UserActivity>> getActivities({
    ActivityType? type,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('user_activities')
          .select()
          .eq('user_id', currentUser.id);

      if (type != null) {
        query = query.eq('type', type.name);
      }

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => UserActivity.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get activity statistics
  Future<ActivityStats?> getActivityStats() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('get_activity_stats', params: {
        'user_id_param': currentUser.id,
      });

      if (response == null) return null;

      return ActivityStats.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get activities by type
  Future<List<UserActivity>> getActivitiesByType(ActivityType type) async {
    return getActivities(type: type);
  }

  // Get recent activities
  Future<List<UserActivity>> getRecentActivities({int limit = 20}) async {
    return getActivities(limit: limit);
  }

  // Get activities for date range
  Future<List<UserActivity>> getActivitiesForDateRange({
    required DateTime start,
    required DateTime end,
  }) async {
    return getActivities(startDate: start, endDate: end);
  }

  // Delete activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await _supabase.from('user_activities').delete().eq('id', activityId);
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  // Clear all activities
  Future<void> clearAllActivities() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('user_activities')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to clear activities: $e');
    }
  }

  // Calculate current streak
  Future<int> getCurrentStreak() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return 0;

      final response = await _supabase.rpc('calculate_activity_streak', params: {
        'user_id_param': currentUser.id,
      });

      return response as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Helper methods for specific activity types
  Future<void> trackBooking(String bookingId, String venueName) async {
    await trackActivity(
      type: ActivityType.booking,
      description: 'Booked a table at $venueName',
      relatedId: bookingId,
      relatedType: 'booking',
    );
  }

  Future<void> trackReview(String reviewId, String venueName, double rating) async {
    await trackActivity(
      type: ActivityType.review,
      description: 'Reviewed $venueName',
      relatedId: reviewId,
      relatedType: 'review',
      metadata: {'rating': rating},
    );
  }

  Future<void> trackCheckIn(String venueId, String venueName) async {
    await trackActivity(
      type: ActivityType.checkIn,
      description: 'Checked in at $venueName',
      relatedId: venueId,
      relatedType: 'venue',
    );
  }

  Future<void> trackVenueView(String venueId, String venueName) async {
    await trackActivity(
      type: ActivityType.venueView,
      description: 'Viewed $venueName',
      relatedId: venueId,
      relatedType: 'venue',
    );
  }

  Future<void> trackSearch(String query, int resultsCount) async {
    await trackActivity(
      type: ActivityType.search,
      description: 'Searched for "$query"',
      metadata: {'query': query, 'results_count': resultsCount},
    );
  }

  Future<void> trackShare(String contentType, String contentId) async {
    await trackActivity(
      type: ActivityType.share,
      description: 'Shared $contentType',
      relatedId: contentId,
      relatedType: contentType,
    );
  }

  Future<void> trackFavorite(String itemType, String itemId, String itemName) async {
    await trackActivity(
      type: ActivityType.favorite,
      description: 'Added $itemName to favorites',
      relatedId: itemId,
      relatedType: itemType,
    );
  }
}

class SavedItemsService {
  static final SavedItemsService _instance = SavedItemsService._internal();
  factory SavedItemsService() => _instance;
  SavedItemsService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Save item
  Future<SavedItem> saveItem({
    required String itemId,
    required String itemType,
    required String itemName,
    String? itemImage,
    Map<String, dynamic>? itemData,
    List<String>? tags,
    String? notes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('saved_items').insert({
        'user_id': currentUser.id,
        'item_id': itemId,
        'item_type': itemType,
        'item_name': itemName,
        'item_image': itemImage,
        'item_data': itemData,
        'tags': tags ?? [],
        'notes': notes,
      }).select().single();

      return SavedItem.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to save item: $e');
    }
  }

  // Get saved items
  Future<List<SavedItem>> getSavedItems({
    String? itemType,
    List<String>? tags,
    int limit = 100,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase.from('saved_items').select().eq('user_id', currentUser.id);

      if (itemType != null) {
        query = query.eq('item_type', itemType);
      }

      if (tags != null && tags.isNotEmpty) {
        query = query.contains('tags', tags);
      }

      final response = await query
          .order('saved_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => SavedItem.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Check if item is saved
  Future<bool> isItemSaved(String itemId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('saved_items')
          .select('id')
          .eq('user_id', currentUser.id)
          .eq('item_id', itemId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Unsave item
  Future<void> unsaveItem(String itemId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('saved_items')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('item_id', itemId);
    } catch (e) {
      throw Exception('Failed to unsave item: $e');
    }
  }

  // Update saved item
  Future<SavedItem> updateSavedItem({
    required String savedItemId,
    List<String>? tags,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (tags != null) updates['tags'] = tags;
      if (notes != null) updates['notes'] = notes;

      final response = await _supabase
          .from('saved_items')
          .update(updates)
          .eq('id', savedItemId)
          .select()
          .single();

      return SavedItem.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update saved item: $e');
    }
  }

  // Get saved items by type
  Future<List<SavedItem>> getSavedVenues() async {
    return getSavedItems(itemType: 'venue');
  }

  Future<List<SavedItem>> getSavedEvents() async {
    return getSavedItems(itemType: 'event');
  }

  // Get all tags used
  Future<List<String>> getAllTags() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_user_saved_item_tags', params: {
        'user_id_param': currentUser.id,
      });

      return List<String>.from(response as List? ?? []);
    } catch (e) {
      return [];
    }
  }
}

class UserStatisticsService {
  static final UserStatisticsService _instance = UserStatisticsService._internal();
  factory UserStatisticsService() => _instance;
  UserStatisticsService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user statistics
  Future<UserStatistics?> getUserStatistics() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('get_user_statistics', params: {
        'user_id_param': currentUser.id,
      });

      if (response == null) return null;

      return UserStatistics.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get statistics for date range
  Future<Map<String, dynamic>> getStatisticsForDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return {};

      final response = await _supabase.rpc('get_user_statistics_range', params: {
        'user_id_param': currentUser.id,
        'start_date_param': startDate.toIso8601String(),
        'end_date_param': endDate.toIso8601String(),
      });

      return Map<String, dynamic>.from(response as Map? ?? {});
    } catch (e) {
      return {};
    }
  }

  // Get monthly spending
  Future<Map<String, double>> getMonthlySpending({int months = 12}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return {};

      final response = await _supabase.rpc('get_monthly_spending', params: {
        'user_id_param': currentUser.id,
        'months_param': months,
      });

      return Map<String, double>.from(response as Map? ?? {});
    } catch (e) {
      return {};
    }
  }

  // Get top venues
  Future<List<Map<String, dynamic>>> getTopVenues({int limit = 10}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_user_top_venues', params: {
        'user_id_param': currentUser.id,
        'limit_param': limit,
      });

      return List<Map<String, dynamic>>.from(response as List? ?? []);
    } catch (e) {
      return [];
    }
  }

  // Update last active timestamp
  Future<void> updateLastActive() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('users').update({
        'last_active': DateTime.now().toIso8601String(),
      }).eq('id', currentUser.id);
    } catch (e) {
      // Non-critical error
    }
  }
}
