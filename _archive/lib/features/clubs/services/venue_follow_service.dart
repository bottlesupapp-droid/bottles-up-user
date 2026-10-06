import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue_follow.dart';

class VenueFollowService {
  static final VenueFollowService _instance = VenueFollowService._internal();
  factory VenueFollowService() => _instance;
  VenueFollowService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Follow a venue
  Future<VenueFollow> followVenue({
    required String clubId,
    bool notificationsEnabled = true,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if already following
      final existing = await _supabase
          .from('venue_follows')
          .select()
          .eq('user_id', currentUser.id)
          .eq('club_id', clubId)
          .maybeSingle();

      if (existing != null) {
        return VenueFollow.fromSupabase(existing);
      }

      final followData = {
        'user_id': currentUser.id,
        'club_id': clubId,
        'user_name': currentUser.userMetadata?['full_name'],
        'user_avatar': currentUser.userMetadata?['avatar_url'],
        'notifications_enabled': notificationsEnabled,
      };

      final response = await _supabase
          .from('venue_follows')
          .insert(followData)
          .select()
          .single();

      // Increment follower count
      await _supabase.rpc('increment_venue_followers', params: {
        'club_id': clubId,
      });

      return VenueFollow.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to follow venue: $e');
    }
  }

  // Unfollow a venue
  Future<void> unfollowVenue(String clubId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('venue_follows')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('club_id', clubId);

      // Decrement follower count
      await _supabase.rpc('decrement_venue_followers', params: {
        'club_id': clubId,
      });
    } catch (e) {
      throw Exception('Failed to unfollow venue: $e');
    }
  }

  // Toggle follow status
  Future<bool> toggleFollow(String clubId) async {
    final isFollowing = await isFollowingVenue(clubId);
    if (isFollowing) {
      await unfollowVenue(clubId);
      return false;
    } else {
      await followVenue(clubId: clubId);
      return true;
    }
  }

  // Check if user is following a venue
  Future<bool> isFollowingVenue(String clubId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('venue_follows')
          .select()
          .eq('user_id', currentUser.id)
          .eq('club_id', clubId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get venue follow stats
  Future<VenueFollowStats> getVenueStats(String clubId) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      // Get follower count
      final followersResponse = await _supabase
          .from('venue_follows')
          .select('id')
          .eq('club_id', clubId);

      final followersCount = (followersResponse as List).length;

      // Get events count
      final eventsResponse = await _supabase
          .from('events')
          .select('id')
          .eq('club_id', clubId)
          .eq('is_active', true);

      final eventsCount = (eventsResponse as List).length;

      // Check if current user is following
      bool isFollowing = false;
      if (currentUser != null) {
        isFollowing = await isFollowingVenue(clubId);
      }

      return VenueFollowStats(
        clubId: clubId,
        followersCount: followersCount,
        eventsCount: eventsCount,
        isFollowing: isFollowing,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get venue stats: $e');
    }
  }

  // Get user's followed venues
  Future<List<VenueFollow>> getUserFollowedVenues() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('venue_follows')
          .select('''
            *,
            clubs:club_id (
              name,
              location,
              image_url
            )
          ''')
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      return (response as List).map((data) {
        // Merge club data into the follow record
        if (data['clubs'] != null) {
          data['club_name'] = data['clubs']['name'];
          data['club_location'] = data['clubs']['location'];
          data['club_image_url'] = data['clubs']['image_url'];
        }
        return VenueFollow.fromSupabase(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get venue followers
  Future<List<VenueFollow>> getVenueFollowers(String clubId) async {
    try {
      final response = await _supabase
          .from('venue_follows')
          .select()
          .eq('club_id', clubId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => VenueFollow.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    required String clubId,
    required bool enabled,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('venue_follows')
          .update({'notifications_enabled': enabled})
          .eq('user_id', currentUser.id)
          .eq('club_id', clubId);
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  // Get updates from followed venues
  Future<List<FollowedVenueUpdate>> getFollowedVenueUpdates({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get list of followed club IDs
      final follows = await _supabase
          .from('venue_follows')
          .select('club_id')
          .eq('user_id', currentUser.id);

      final clubIds =
          (follows as List).map((f) => f['club_id'] as String).toList();

      if (clubIds.isEmpty) {
        return [];
      }

      // Get updates for followed venues
      final response = await _supabase
          .from('venue_updates')
          .select('''
            *,
            clubs:club_id (
              name,
              image_url
            )
          ''')
          .inFilter('club_id', clubIds)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((data) {
        if (data['clubs'] != null) {
          data['club_name'] = data['clubs']['name'];
          data['club_image_url'] = data['clubs']['image_url'];
        }
        return FollowedVenueUpdate.fromSupabase(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Mark update as read
  Future<void> markUpdateAsRead(String updateId) async {
    try {
      await _supabase
          .from('venue_updates')
          .update({'is_read': true})
          .eq('id', updateId);
    } catch (e) {
      // Silently fail
    }
  }

  // Get unread updates count
  Future<int> getUnreadUpdatesCount() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return 0;

      final follows = await _supabase
          .from('venue_follows')
          .select('club_id')
          .eq('user_id', currentUser.id);

      final clubIds =
          (follows as List).map((f) => f['club_id'] as String).toList();

      if (clubIds.isEmpty) return 0;

      final response = await _supabase
          .from('venue_updates')
          .select('id')
          .inFilter('club_id', clubIds)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  // Subscribe to venue follower updates
  RealtimeChannel subscribeToVenueFollowers(
    String clubId,
    void Function(int) onFollowersChanged,
  ) {
    return _supabase
        .channel('venue_followers_$clubId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'venue_follows',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'club_id',
            value: clubId,
          ),
          callback: (payload) async {
            final stats = await getVenueStats(clubId);
            onFollowersChanged(stats.followersCount);
          },
        )
        .subscribe();
  }
}
