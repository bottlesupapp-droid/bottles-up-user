import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/friend.dart';

class FriendService {
  static final FriendService _instance = FriendService._internal();
  factory FriendService() => _instance;
  FriendService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user's friends
  Future<List<Friend>> getFriends({
    FriendshipStatus? status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('friends')
          .select('*, friend:users!friend_id(*)')
          .eq('user_id', currentUser.id);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => Friend.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Send friend request
  Future<FriendInvitation> sendFriendRequest({
    required String recipientId,
    String? message,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('friend_invitations').insert({
        'sender_id': currentUser.id,
        'recipient_id': recipientId,
        'method': InvitationMethod.username.name,
        'message': message,
        'expires_at': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
      }).select().single();

      return FriendInvitation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send friend request: $e');
    }
  }

  // Accept friend request
  Future<Friend> acceptFriendRequest(String invitationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('accept_friend_request', params: {
        'invitation_id_param': invitationId,
        'user_id_param': currentUser.id,
      });

      return Friend.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  // Decline friend request
  Future<void> declineFriendRequest(String invitationId) async {
    try {
      await _supabase.from('friend_invitations').update({
        'status': FriendshipStatus.declined.name,
      }).eq('id', invitationId);
    } catch (e) {
      throw Exception('Failed to decline friend request: $e');
    }
  }

  // Remove friend
  Future<void> removeFriend(String friendshipId) async {
    try {
      await _supabase.from('friends').delete().eq('id', friendshipId);
    } catch (e) {
      throw Exception('Failed to remove friend: $e');
    }
  }

  // Block user
  Future<void> blockUser(String userId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('blocked_users').insert({
        'user_id': currentUser.id,
        'blocked_user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  // Get pending invitations
  Future<List<FriendInvitation>> getPendingInvitations() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('friend_invitations')
          .select('*, sender:users!sender_id(*)')
          .eq('recipient_id', currentUser.id)
          .eq('status', FriendshipStatus.pending.name)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) =>
              FriendInvitation.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Send invitation by email
  Future<FriendInvitation> inviteByEmail({
    required String email,
    String? message,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('friend_invitations').insert({
        'sender_id': currentUser.id,
        'recipient_email': email,
        'method': InvitationMethod.email.name,
        'message': message,
        'invitation_code': _generateInvitationCode(),
        'expires_at': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
      }).select().single();

      // Send email
      await _sendInvitationEmail(email, response['invitation_code'] as String);

      return FriendInvitation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  // Send invitation by phone
  Future<FriendInvitation> inviteByPhone({
    required String phone,
    String? message,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('friend_invitations').insert({
        'sender_id': currentUser.id,
        'recipient_phone': phone,
        'method': InvitationMethod.phone.name,
        'message': message,
        'invitation_code': _generateInvitationCode(),
        'expires_at': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
      }).select().single();

      // Send SMS
      await _sendInvitationSMS(phone, response['invitation_code'] as String);

      return FriendInvitation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  // Get contact suggestions
  Future<List<ContactSuggestion>> getContactSuggestions({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_contact_suggestions', params: {
        'user_id_param': currentUser.id,
        'limit_param': limit,
      });

      return (response as List)
          .map((item) =>
              ContactSuggestion.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Search users
  Future<List<Map<String, dynamic>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('search_users', params: {
        'search_query': query,
        'current_user_id': currentUser.id,
        'limit_param': limit,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Toggle favorite friend
  Future<void> toggleFavoriteFriend(String friendshipId, bool isFavorite) async {
    try {
      await _supabase.from('friends').update({
        'is_favorite': isFavorite,
      }).eq('id', friendshipId);
    } catch (e) {
      throw Exception('Failed to update favorite: $e');
    }
  }

  // Get mutual friends
  Future<List<Friend>> getMutualFriends(String userId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_mutual_friends', params: {
        'user_id_1': currentUser.id,
        'user_id_2': userId,
      });

      return (response as List)
          .map((item) => Friend.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get friend activities
  Future<List<FriendActivity>> getFriendActivities({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_friend_activities', params: {
        'user_id_param': currentUser.id,
        'limit_param': limit,
      });

      return (response as List)
          .map((item) =>
              FriendActivity.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Generate invitation code
  String _generateInvitationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      8,
      (index) => chars[(random + index) % chars.length],
    ).join();
  }

  // Send invitation email (placeholder)
  Future<void> _sendInvitationEmail(String email, String code) async {
    // Integration with email service (SendGrid, etc.)
    // For now, this would be handled by Supabase Edge Functions
    await _supabase.functions.invoke('send-invitation-email', body: {
      'email': email,
      'code': code,
    });
  }

  // Send invitation SMS (placeholder)
  Future<void> _sendInvitationSMS(String phone, String code) async {
    // Integration with SMS service (Twilio, etc.)
    // For now, this would be handled by Supabase Edge Functions
    await _supabase.functions.invoke('send-invitation-sms', body: {
      'phone': phone,
      'code': code,
    });
  }

  // Subscribe to friend requests
  RealtimeChannel subscribeToFriendRequests({
    required Function(FriendInvitation) onNewRequest,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final channel = _supabase.channel('friend_requests_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'friend_invitations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: currentUser.id,
          ),
          callback: (payload) {
            final invitation =
                FriendInvitation.fromSupabase(payload.newRecord);
            onNewRequest(invitation);
          },
        )
        .subscribe();

    return channel;
  }
}
