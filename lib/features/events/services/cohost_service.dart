import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_cohost.dart';

class CohostService {
  static final CohostService _instance = CohostService._internal();
  factory CohostService() => _instance;
  CohostService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Invite a co-host to an event
  Future<EventCohost> inviteCohost({
    required String eventId,
    required String userId,
    required String userName,
    String? userEmail,
    required List<CohostPermission> permissions,
    String? message,
  }) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final cohostData = {
        'event_id': eventId,
        'user_id': userId,
        'user_name': userName,
        'invited_by': currentUserId,
        'status': CohostStatus.pending.name,
        'permissions': permissions.map((p) => p.name).toList(),
        'notes': message,
        'invited_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('event_cohosts')
          .insert(cohostData)
          .select()
          .single();

      // TODO: Send notification to invited user
      // await _sendCohostInviteNotification(userId, eventId, message);

      return EventCohost.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to invite co-host: $e');
    }
  }

  // Get all co-hosts for an event
  Future<List<EventCohost>> getEventCohosts(String eventId) async {
    try {
      final response = await _supabase
          .from('event_cohosts')
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => EventCohost.fromSupabase(data))
          .toList();
    } catch (e) {
      // Return empty list for development
      return [];
    }
  }

  // Get pending cohost invitations for current user
  Future<List<EventCohost>> getPendingInvitations() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return [];

      final response = await _supabase
          .from('event_cohosts')
          .select()
          .eq('user_id', currentUserId)
          .eq('status', CohostStatus.pending.name)
          .order('invited_at', ascending: false);

      return (response as List)
          .map((data) => EventCohost.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Accept co-host invitation
  Future<void> acceptInvitation(String cohostId) async {
    try {
      await _supabase.from('event_cohosts').update({
        'status': CohostStatus.accepted.name,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', cohostId);

      // TODO: Notify event creator
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  // Decline co-host invitation
  Future<void> declineInvitation(String cohostId) async {
    try {
      await _supabase.from('event_cohosts').update({
        'status': CohostStatus.declined.name,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', cohostId);

      // TODO: Notify event creator
    } catch (e) {
      throw Exception('Failed to decline invitation: $e');
    }
  }

  // Remove a co-host
  Future<void> removeCohost(String cohostId) async {
    try {
      await _supabase.from('event_cohosts').update({
        'status': CohostStatus.removed.name,
      }).eq('id', cohostId);

      // TODO: Notify removed co-host
    } catch (e) {
      throw Exception('Failed to remove co-host: $e');
    }
  }

  // Update co-host permissions
  Future<void> updatePermissions({
    required String cohostId,
    required List<CohostPermission> permissions,
  }) async {
    try {
      await _supabase.from('event_cohosts').update({
        'permissions': permissions.map((p) => p.name).toList(),
      }).eq('id', cohostId);
    } catch (e) {
      throw Exception('Failed to update permissions: $e');
    }
  }

  // Check if user is a co-host for an event
  Future<bool> isCohost(String eventId, String userId) async {
    try {
      final response = await _supabase
          .from('event_cohosts')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', userId)
          .eq('status', CohostStatus.accepted.name)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Check if user has specific permission
  Future<bool> hasPermission({
    required String eventId,
    required String userId,
    required CohostPermission permission,
  }) async {
    try {
      final response = await _supabase
          .from('event_cohosts')
          .select('permissions')
          .eq('event_id', eventId)
          .eq('user_id', userId)
          .eq('status', CohostStatus.accepted.name)
          .maybeSingle();

      if (response == null) return false;

      final permissions = (response['permissions'] as List<dynamic>)
          .map((p) => CohostPermission.values.firstWhere(
                (e) => e.name == p.toString(),
                orElse: () => CohostPermission.viewAnalytics,
              ))
          .toList();

      return permissions.contains(permission);
    } catch (e) {
      return false;
    }
  }

  // Get co-host details for a specific user and event
  Future<EventCohost?> getCohostDetails({
    required String eventId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('event_cohosts')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return EventCohost.fromSupabase(response);
    } catch (e) {
      return null;
    }
  }

  // Search users for co-host invitation (mock implementation)
  Future<List<Map<String, dynamic>>> searchUsersForInvite(String query) async {
    try {
      // In a real implementation, this would search your users table
      // For now, return empty list for frontend development
      final response = await _supabase
          .from('profiles')
          .select('id, full_name, avatar_url, email')
          .ilike('full_name', '%$query%')
          .limit(10);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
