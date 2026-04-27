import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rsvp_status.dart';

class EnhancedRsvpService {
  static final EnhancedRsvpService _instance = EnhancedRsvpService._internal();
  factory EnhancedRsvpService() => _instance;
  EnhancedRsvpService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit RSVP with three-state response
  Future<EnhancedEventRSVP> submitRsvp({
    required String eventId,
    required RsvpResponse response,
    bool plusOneEnabled = false,
    String? plusOneName,
    String? specialRequests,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final rsvpData = {
        'event_id': eventId,
        'user_id': currentUser.id,
        'user_name': currentUser.userMetadata?['full_name'] ?? 'Unknown',
        'user_avatar': currentUser.userMetadata?['avatar_url'],
        'email': currentUser.email,
        'response': response.name,
        'plus_one_enabled': plusOneEnabled,
        'plus_one_name': plusOneName,
        'special_requests': specialRequests,
        'responded_at': DateTime.now().toIso8601String(),
      };

      final existing = await _supabase
          .from('enhanced_event_rsvps')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', currentUser.id)
          .maybeSingle();

      final response_data = existing != null
          ? await _supabase
              .from('enhanced_event_rsvps')
              .update(rsvpData)
              .eq('id', existing['id'])
              .select()
              .single()
          : await _supabase
              .from('enhanced_event_rsvps')
              .insert(rsvpData)
              .select()
              .single();

      return EnhancedEventRSVP.fromSupabase(response_data);
    } catch (e) {
      throw Exception('Failed to submit RSVP: $e');
    }
  }

  // Get RSVP counts for an event
  Future<RsvpCounts> getRsvpCounts(String eventId) async {
    try {
      final response = await _supabase.rpc('get_rsvp_counts', params: {
        'p_event_id': eventId,
      });

      if (response != null) {
        return RsvpCounts.fromSupabase(response);
      }

      // Fallback: manually count
      final rsvps = await _supabase
          .from('enhanced_event_rsvps')
          .select('response, plus_one_enabled')
          .eq('event_id', eventId);

      int going = 0, maybe = 0, notGoing = 0, plusOnes = 0;

      for (final rsvp in rsvps as List) {
        final response = rsvp['response'] as String;
        if (response == 'going') going++;
        if (response == 'maybe') maybe++;
        if (response == 'notGoing') notGoing++;
        if (rsvp['plus_one_enabled'] == true) plusOnes++;
      }

      return RsvpCounts(
        going: going,
        maybe: maybe,
        notGoing: notGoing,
        total: going + maybe,
        plusOnes: plusOnes,
      );
    } catch (e) {
      // Return zeros for frontend development
      return const RsvpCounts();
    }
  }

  // Get all RSVPs for an event (respecting visibility)
  Future<List<EnhancedEventRSVP>> getEventRsvps(
    String eventId, {
    RsvpResponse? filterByResponse,
  }) async {
    try {
      var query = _supabase
          .from('enhanced_event_rsvps')
          .select()
          .eq('event_id', eventId)
          .eq('is_visible', true);

      if (filterByResponse != null) {
        query = query.eq('response', filterByResponse.name);
      }

      final response = await query.order('responded_at', ascending: false);

      return (response as List)
          .map((data) => EnhancedEventRSVP.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get current user's RSVP for an event
  Future<EnhancedEventRSVP?> getMyRsvp(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('enhanced_event_rsvps')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (response == null) return null;

      return EnhancedEventRSVP.fromSupabase(response);
    } catch (e) {
      return null;
    }
  }

  // Get friends attending an event
  Future<List<FriendAttending>> getFriendsAttending(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      // This would need a friends table and junction
      // For now, return empty list for frontend development
      final response = await _supabase.rpc(
        'get_friends_attending_event',
        params: {
          'p_event_id': eventId,
          'p_user_id': currentUser.id,
        },
      );

      if (response == null) return [];

      return (response as List)
          .map((data) => FriendAttending.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update guest list visibility
  Future<void> updateGuestListVisibility({
    required String eventId,
    required GuestListVisibility settings,
  }) async {
    try {
      final existing = await _supabase
          .from('guest_list_visibility')
          .select()
          .eq('event_id', eventId)
          .maybeSingle();

      if (existing != null) {
        await _supabase
            .from('guest_list_visibility')
            .update(settings.toSupabase())
            .eq('event_id', eventId);
      } else {
        await _supabase
            .from('guest_list_visibility')
            .insert(settings.toSupabase());
      }
    } catch (e) {
      throw Exception('Failed to update visibility settings: $e');
    }
  }

  // Get guest list visibility settings
  Future<GuestListVisibility> getGuestListVisibility(String eventId) async {
    try {
      final response = await _supabase
          .from('guest_list_visibility')
          .select()
          .eq('event_id', eventId)
          .maybeSingle();

      if (response != null) {
        return GuestListVisibility.fromSupabase(response);
      }

      // Return default settings
      return GuestListVisibility(eventId: eventId);
    } catch (e) {
      return GuestListVisibility(eventId: eventId);
    }
  }

  // Update RSVP visibility (for individual users)
  Future<void> updateRsvpVisibility({
    required String rsvpId,
    required bool isVisible,
  }) async {
    try {
      await _supabase
          .from('enhanced_event_rsvps')
          .update({'is_visible': isVisible}).eq('id', rsvpId);
    } catch (e) {
      throw Exception('Failed to update RSVP visibility: $e');
    }
  }

  // Real-time RSVP subscription
  RealtimeChannel subscribeToRsvpUpdates(
    String eventId,
    void Function(RsvpCounts) onUpdate,
  ) {
    return _supabase
        .channel('rsvp_updates_$eventId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'enhanced_event_rsvps',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (payload) async {
            final counts = await getRsvpCounts(eventId);
            onUpdate(counts);
          },
        )
        .subscribe();
  }
}
