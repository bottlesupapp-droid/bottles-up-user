import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/social_models.dart';

class PartyService {
  static final PartyService _instance = PartyService._internal();
  factory PartyService() => _instance;
  PartyService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create party
  Future<Party> createParty({
    required String name,
    String? description,
    List<String>? memberIds,
    String? venueId,
    String? eventId,
    DateTime? scheduledFor,
    int maxMembers = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final members = memberIds?.toSet() ?? <String>{};
      members.add(currentUser.id);

      final response = await _supabase.from('parties').insert({
        'name': name,
        'description': description,
        'organizer_id': currentUser.id,
        'member_ids': members.toList(),
        'venue_id': venueId,
        'event_id': eventId,
        'scheduled_for': scheduledFor?.toIso8601String(),
        'status': PartyStatus.planning.name,
        'max_members': maxMembers,
      }).select('*, organizer:users!organizer_id(*), members:users!inner(*)').single();

      return Party.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create party: $e');
    }
  }

  // Get party by ID
  Future<Party?> getParty(String partyId) async {
    try {
      final response = await _supabase
          .from('parties')
          .select('*, organizer:users!organizer_id(*), members:users!inner(*), venue:venues(*)')
          .eq('id', partyId)
          .maybeSingle();

      if (response == null) return null;

      return Party.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get user parties
  Future<List<Party>> getUserParties({
    PartyStatus? status,
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('parties')
          .select('*, organizer:users!organizer_id(*)')
          .contains('member_ids', [currentUser.id]);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Party.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update party
  Future<Party> updateParty({
    required String partyId,
    String? name,
    String? description,
    String? venueId,
    String? eventId,
    DateTime? scheduledFor,
    PartyStatus? status,
    int? maxMembers,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (venueId != null) updates['venue_id'] = venueId;
      if (eventId != null) updates['event_id'] = eventId;
      if (scheduledFor != null) updates['scheduled_for'] = scheduledFor.toIso8601String();
      if (status != null) updates['status'] = status.name;
      if (maxMembers != null) updates['max_members'] = maxMembers;

      final response = await _supabase
          .from('parties')
          .update(updates)
          .eq('id', partyId)
          .select('*, organizer:users!organizer_id(*)')
          .single();

      return Party.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update party: $e');
    }
  }

  // Delete party
  Future<void> deleteParty(String partyId) async {
    try {
      await _supabase.from('parties').delete().eq('id', partyId);
    } catch (e) {
      throw Exception('Failed to delete party: $e');
    }
  }

  // Invite user to party
  Future<PartyInvitation> inviteToParty({
    required String partyId,
    required String userId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('party_invitations').insert({
        'party_id': partyId,
        'user_id': userId,
        'invited_by': currentUser.id,
        'status': InvitationStatus.pending.name,
      }).select('*, party:parties(*), inviter:users!invited_by(*)').single();

      // Add to invited list
      final party = await _supabase
          .from('parties')
          .select('invited_user_ids')
          .eq('id', partyId)
          .single();

      final invited = List<String>.from(party['invited_user_ids'] as List? ?? []);
      if (!invited.contains(userId)) {
        invited.add(userId);
        await _supabase.from('parties').update({
          'invited_user_ids': invited,
        }).eq('id', partyId);
      }

      return PartyInvitation.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to invite user: $e');
    }
  }

  // Accept party invitation
  Future<Party> acceptInvitation(String invitationId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Update invitation
      await _supabase.from('party_invitations').update({
        'status': InvitationStatus.accepted.name,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', invitationId);

      // Get invitation details
      final invitation = await _supabase
          .from('party_invitations')
          .select('party_id')
          .eq('id', invitationId)
          .single();

      final partyId = invitation['party_id'] as String;

      // Add user to party members
      final party = await _supabase
          .from('parties')
          .select('member_ids')
          .eq('id', partyId)
          .single();

      final members = List<String>.from(party['member_ids'] as List? ?? []);
      if (!members.contains(currentUser.id)) {
        members.add(currentUser.id);
        await _supabase.from('parties').update({
          'member_ids': members,
        }).eq('id', partyId);
      }

      // Get updated party
      final updatedParty = await getParty(partyId);
      if (updatedParty == null) {
        throw Exception('Party not found');
      }

      return updatedParty;
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  // Decline party invitation
  Future<void> declineInvitation(String invitationId) async {
    try {
      await _supabase.from('party_invitations').update({
        'status': InvitationStatus.declined.name,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', invitationId);
    } catch (e) {
      throw Exception('Failed to decline invitation: $e');
    }
  }

  // Get party invitations
  Future<List<PartyInvitation>> getInvitations({
    InvitationStatus? status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('party_invitations')
          .select('*, party:parties(*), inviter:users!invited_by(*)')
          .eq('user_id', currentUser.id);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => PartyInvitation.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Leave party
  Future<void> leaveParty(String partyId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      final party = await _supabase
          .from('parties')
          .select('member_ids, organizer_id')
          .eq('id', partyId)
          .single();

      // Check if user is organizer
      if (party['organizer_id'] == currentUser.id) {
        throw Exception('Organizer cannot leave the party. Delete it instead.');
      }

      final members = List<String>.from(party['member_ids'] as List);
      members.remove(currentUser.id);

      await _supabase.from('parties').update({
        'member_ids': members,
      }).eq('id', partyId);
    } catch (e) {
      throw Exception('Failed to leave party: $e');
    }
  }

  // Remove member from party
  Future<void> removeMember({
    required String partyId,
    required String userId,
  }) async {
    try {
      final party = await _supabase
          .from('parties')
          .select('member_ids')
          .eq('id', partyId)
          .single();

      final members = List<String>.from(party['member_ids'] as List);
      members.remove(userId);

      await _supabase.from('parties').update({
        'member_ids': members,
      }).eq('id', partyId);
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  // Transfer party ownership
  Future<Party> transferOwnership({
    required String partyId,
    required String newOrganizerId,
  }) async {
    try {
      final response = await _supabase.from('parties').update({
        'organizer_id': newOrganizerId,
      }).eq('id', partyId).select('*, organizer:users!organizer_id(*)').single();

      return Party.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to transfer ownership: $e');
    }
  }

  // Get upcoming parties
  Future<List<Party>> getUpcomingParties({int limit = 20}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final now = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('parties')
          .select('*, organizer:users!organizer_id(*)')
          .contains('member_ids', [currentUser.id])
          .gte('scheduled_for', now)
          .order('scheduled_for', ascending: true)
          .limit(limit);

      return (response as List)
          .map((item) => Party.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get active parties (currently happening)
  Future<List<Party>> getActiveParties() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('parties')
          .select('*, organizer:users!organizer_id(*)')
          .contains('member_ids', [currentUser.id])
          .eq('status', PartyStatus.active.name)
          .order('scheduled_for', ascending: false);

      return (response as List)
          .map((item) => Party.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get party members
  Future<List<UserProfile>> getPartyMembers(String partyId) async {
    try {
      final party = await _supabase
          .from('parties')
          .select('member_ids')
          .eq('id', partyId)
          .single();

      final memberIds = List<String>.from(party['member_ids'] as List);

      final response = await _supabase
          .from('users')
          .select()
          .in_('id', memberIds);

      return (response as List)
          .map((item) => UserProfile.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
