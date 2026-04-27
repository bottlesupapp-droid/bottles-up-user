import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_booking.dart';

class GroupBookingService {
  static final GroupBookingService _instance = GroupBookingService._internal();
  factory GroupBookingService() => _instance;
  GroupBookingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create group booking
  Future<GroupBooking> createGroupBooking({
    required String name,
    String? description,
    DateTime? proposedDate,
    List<String>? initialMemberIds,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('group_bookings').insert({
        'organizer_id': currentUser.id,
        'name': name,
        'description': description,
        'proposed_date': proposedDate?.toIso8601String(),
        'status': GroupBookingStatus.planning.name,
      }).select().single();

      final groupBookingId = response['id'] as String;

      // Add organizer as member
      await _supabase.from('group_members').insert({
        'group_booking_id': groupBookingId,
        'user_id': currentUser.id,
        'is_organizer': true,
        'response': InvitationResponse.accepted.name,
      });

      // Add initial members
      if (initialMemberIds != null && initialMemberIds.isNotEmpty) {
        await Future.wait(
          initialMemberIds.map((userId) => inviteMember(
                groupBookingId: groupBookingId,
                userId: userId,
              )),
        );
      }

      return await getGroupBooking(groupBookingId);
    } catch (e) {
      throw Exception('Failed to create group booking: $e');
    }
  }

  // Get group booking
  Future<GroupBooking> getGroupBooking(String groupBookingId) async {
    try {
      final response = await _supabase.rpc('get_group_booking', params: {
        'group_booking_id_param': groupBookingId,
      });

      return GroupBooking.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get group booking: $e');
    }
  }

  // Get user's group bookings
  Future<List<GroupBooking>> getUserGroupBookings({
    GroupBookingStatus? status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('group_bookings')
          .select('*, members:group_members(*)')
          .contains('members', {'user_id': currentUser.id});

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => GroupBooking.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Invite member to group booking
  Future<GroupMember> inviteMember({
    required String groupBookingId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.from('group_members').insert({
        'group_booking_id': groupBookingId,
        'user_id': userId,
        'response': InvitationResponse.pending.name,
      }).select().single();

      return GroupMember.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to invite member: $e');
    }
  }

  // Respond to group invitation
  Future<void> respondToInvitation({
    required String memberId,
    required InvitationResponse response,
  }) async {
    try {
      await _supabase.from('group_members').update({
        'response': response.name,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', memberId);
    } catch (e) {
      throw Exception('Failed to respond to invitation: $e');
    }
  }

  // Remove member from group
  Future<void> removeMember(String memberId) async {
    try {
      await _supabase.from('group_members').delete().eq('id', memberId);
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  // Propose venue
  Future<VenueProposal> proposeVenue({
    required String groupBookingId,
    required String venueId,
    DateTime? proposedDate,
    String? notes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('venue_proposals').insert({
        'group_booking_id': groupBookingId,
        'venue_id': venueId,
        'proposed_by': currentUser.id,
        'proposed_date': proposedDate?.toIso8601String(),
        'notes': notes,
      }).select().single();

      return VenueProposal.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to propose venue: $e');
    }
  }

  // Vote on venue proposal
  Future<VenueVote> voteOnProposal({
    required String proposalId,
    required bool isUpvote,
    String? comment,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if user already voted
      final existing = await _supabase
          .from('venue_votes')
          .select()
          .eq('proposal_id', proposalId)
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (existing != null) {
        // Update existing vote
        final response = await _supabase.from('venue_votes').update({
          'is_upvote': isUpvote,
          'comment': comment,
        }).eq('id', existing['id']).select().single();

        return VenueVote.fromSupabase(response as Map<String, dynamic>);
      } else {
        // Create new vote
        final response = await _supabase.from('venue_votes').insert({
          'proposal_id': proposalId,
          'user_id': currentUser.id,
          'is_upvote': isUpvote,
          'comment': comment,
        }).select().single();

        return VenueVote.fromSupabase(response as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('Failed to vote on proposal: $e');
    }
  }

  // Start voting phase
  Future<void> startVoting({
    required String groupBookingId,
    DateTime? votingDeadline,
  }) async {
    try {
      await _supabase.from('group_bookings').update({
        'status': GroupBookingStatus.voting.name,
        'voting_deadline': votingDeadline?.toIso8601String() ??
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      }).eq('id', groupBookingId);
    } catch (e) {
      throw Exception('Failed to start voting: $e');
    }
  }

  // Confirm group booking with winning venue
  Future<void> confirmBooking({
    required String groupBookingId,
    required String venueId,
    Map<String, dynamic>? bookingDetails,
  }) async {
    try {
      await _supabase.from('group_bookings').update({
        'status': GroupBookingStatus.confirmed.name,
        'venue_id': venueId,
        'booking_details': bookingDetails,
        'confirmed_at': DateTime.now().toIso8601String(),
      }).eq('id', groupBookingId);
    } catch (e) {
      throw Exception('Failed to confirm booking: $e');
    }
  }

  // Cancel group booking
  Future<void> cancelGroupBooking(String groupBookingId) async {
    try {
      await _supabase.from('group_bookings').update({
        'status': GroupBookingStatus.cancelled.name,
      }).eq('id', groupBookingId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Send group message
  Future<GroupMessage> sendMessage({
    required String groupBookingId,
    required String message,
    String? messageType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('group_messages').insert({
        'group_booking_id': groupBookingId,
        'sender_id': currentUser.id,
        'message': message,
        'message_type': messageType,
        'metadata': metadata,
      }).select().single();

      return GroupMessage.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get group messages
  Future<List<GroupMessage>> getGroupMessages({
    required String groupBookingId,
    int limit = 100,
  }) async {
    try {
      final response = await _supabase
          .from('group_messages')
          .select('*, sender:users!sender_id(*)')
          .eq('group_booking_id', groupBookingId)
          .order('sent_at', ascending: true)
          .limit(limit);

      return (response as List)
          .map((item) => GroupMessage.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get venue proposals for group booking
  Future<List<VenueProposal>> getVenueProposals(String groupBookingId) async {
    try {
      final response = await _supabase.rpc('get_venue_proposals', params: {
        'group_booking_id_param': groupBookingId,
      });

      return (response as List)
          .map((item) => VenueProposal.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get winning proposal (most upvotes)
  Future<VenueProposal?> getWinningProposal(String groupBookingId) async {
    try {
      final proposals = await getVenueProposals(groupBookingId);
      if (proposals.isEmpty) return null;

      proposals.sort((a, b) {
        final aScore = a.upvotes - a.downvotes;
        final bScore = b.upvotes - b.downvotes;
        return bScore.compareTo(aScore);
      });

      return proposals.first;
    } catch (e) {
      return null;
    }
  }

  // Subscribe to group updates
  RealtimeChannel subscribeToGroupUpdates({
    required String groupBookingId,
    required Function() onUpdate,
  }) {
    final channel = _supabase.channel('group_booking_$groupBookingId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'group_bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: groupBookingId,
          ),
          callback: (payload) => onUpdate(),
        )
        .subscribe();

    return channel;
  }

  // Subscribe to group messages
  RealtimeChannel subscribeToGroupMessages({
    required String groupBookingId,
    required Function(GroupMessage) onNewMessage,
  }) {
    final channel = _supabase.channel('group_messages_$groupBookingId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'group_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'group_booking_id',
            value: groupBookingId,
          ),
          callback: (payload) {
            final message = GroupMessage.fromSupabase(payload.newRecord);
            onNewMessage(message);
          },
        )
        .subscribe();

    return channel;
  }
}
