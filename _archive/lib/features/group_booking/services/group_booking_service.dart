import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group_booking.dart';
import 'dart:math';

class GroupBookingService {
  static final GroupBookingService _instance = GroupBookingService._internal();
  factory GroupBookingService() => _instance;
  GroupBookingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create group booking
  Future<GroupBooking> createGroupBooking({
    required String eventId,
    required String eventName,
    required int maxMembers,
    required double totalAmount,
    DateTime? confirmationDeadline,
    String? specialRequests,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final amountPerPerson = totalAmount / maxMembers;

      final response = await _supabase.from('group_bookings').insert({
        'organizer_id': currentUser.id,
        'organizer_name': currentUser.userMetadata?['full_name'] ?? 'User',
        'event_id': eventId,
        'event_name': eventName,
        'max_members': maxMembers,
        'current_members': 1, // Organizer counts as first member
        'total_amount': totalAmount,
        'amount_per_person': amountPerPerson,
        'status': 'pending',
        'confirmation_deadline': confirmationDeadline?.toIso8601String(),
        'special_requests': specialRequests,
      }).select().single();

      // Add organizer as first member
      await _supabase.from('group_members').insert({
        'group_booking_id': response['id'],
        'user_id': currentUser.id,
        'user_name': currentUser.userMetadata?['full_name'] ?? 'User',
        'user_email': currentUser.email,
        'amount_owed': amountPerPerson,
        'amount_paid': 0.0,
        'status': 'accepted',
        'invited_at': DateTime.now().toIso8601String(),
        'responded_at': DateTime.now().toIso8601String(),
      });

      return GroupBooking.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create group booking: $e');
    }
  }

  // Invite members to group booking
  Future<GroupInvite> inviteMember({
    required String groupBookingId,
    String? userId,
    String? email,
    String? phone,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Generate invite token
      final token = _generateInviteToken();

      final response = await _supabase.from('group_invites').insert({
        'group_booking_id': groupBookingId,
        'invited_by_user_id': currentUser.id,
        'invited_by_name': currentUser.userMetadata?['full_name'] ?? 'User',
        'recipient_user_id': userId,
        'recipient_email': email,
        'recipient_phone': phone,
        'invite_token': token,
        'expires_at': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      }).select().single();

      // Send notification (email/SMS)
      await _sendInviteNotification(
        email: email,
        phone: phone,
        inviteToken: token,
        groupBookingId: groupBookingId,
      );

      return GroupInvite.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to invite member: $e');
    }
  }

  // Accept group booking invite
  Future<GroupMember> acceptInvite(String inviteToken) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get invite
      final invite = await _supabase
          .from('group_invites')
          .select()
          .eq('invite_token', inviteToken)
          .single();

      if (invite['is_accepted'] == true) {
        throw Exception('Invite already accepted');
      }

      if (invite['expires_at'] != null) {
        final expiresAt = DateTime.parse(invite['expires_at'] as String);
        if (DateTime.now().isAfter(expiresAt)) {
          throw Exception('Invite has expired');
        }
      }

      // Get group booking
      final groupBooking = await _supabase
          .from('group_bookings')
          .select()
          .eq('id', invite['group_booking_id'])
          .single();

      // Check if group is full
      if (groupBooking['current_members'] >= groupBooking['max_members']) {
        throw Exception('Group booking is full');
      }

      // Add member
      final memberResponse = await _supabase.from('group_members').insert({
        'group_booking_id': invite['group_booking_id'],
        'user_id': currentUser.id,
        'user_name': currentUser.userMetadata?['full_name'] ?? 'User',
        'user_email': currentUser.email,
        'amount_owed': groupBooking['amount_per_person'],
        'amount_paid': 0.0,
        'status': 'accepted',
        'invited_at': invite['created_at'],
        'responded_at': DateTime.now().toIso8601String(),
      }).select().single();

      // Update invite
      await _supabase
          .from('group_invites')
          .update({
            'is_accepted': true,
            'accepted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', invite['id']);

      // Update group booking member count
      await _supabase
          .from('group_bookings')
          .update({
            'current_members': groupBooking['current_members'] + 1,
          })
          .eq('id', invite['group_booking_id']);

      return GroupMember.fromSupabase(memberResponse as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to accept invite: $e');
    }
  }

  // Decline group booking invite
  Future<void> declineInvite(String inviteToken) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get invite
      final invite = await _supabase
          .from('group_invites')
          .select()
          .eq('invite_token', inviteToken)
          .single();

      // Add member with declined status
      await _supabase.from('group_members').insert({
        'group_booking_id': invite['group_booking_id'],
        'user_id': currentUser.id,
        'user_name': currentUser.userMetadata?['full_name'] ?? 'User',
        'user_email': currentUser.email,
        'amount_owed': 0.0,
        'amount_paid': 0.0,
        'status': 'declined',
        'invited_at': invite['created_at'],
        'responded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to decline invite: $e');
    }
  }

  // Get group booking details
  Future<GroupBooking> getGroupBooking(String groupBookingId) async {
    try {
      final response = await _supabase
          .from('group_bookings')
          .select()
          .eq('id', groupBookingId)
          .single();

      return GroupBooking.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get group booking: $e');
    }
  }

  // Get group members
  Future<List<GroupMember>> getGroupMembers(String groupBookingId) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select()
          .eq('group_booking_id', groupBookingId)
          .order('created_at');

      return (response as List)
          .map((item) => GroupMember.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Process member payment
  Future<void> processMemberPayment({
    required String groupMemberId,
    required double amount,
    required String paymentIntentId,
  }) async {
    try {
      await _supabase
          .from('group_members')
          .update({
            'amount_paid': amount,
            'status': 'paid',
            'paid_at': DateTime.now().toIso8601String(),
            'payment_intent_id': paymentIntentId,
          })
          .eq('id', groupMemberId);

      // Check if all members have paid
      final member = await _supabase
          .from('group_members')
          .select('group_booking_id')
          .eq('id', groupMemberId)
          .single();

      await _checkGroupPaymentComplete(member['group_booking_id'] as String);
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  // Check if all members have paid and confirm booking
  Future<void> _checkGroupPaymentComplete(String groupBookingId) async {
    try {
      final members = await getGroupMembers(groupBookingId);
      final allPaid = members.every((m) => m.status == MemberStatus.paid);

      if (allPaid) {
        await _supabase
            .from('group_bookings')
            .update({'status': 'confirmed'})
            .eq('id', groupBookingId);

        // Create actual booking
        await _createFinalBooking(groupBookingId);
      }
    } catch (e) {
      // Silently fail
    }
  }

  // Create final booking once all paid
  Future<void> _createFinalBooking(String groupBookingId) async {
    try {
      final groupBooking = await getGroupBooking(groupBookingId);

      await _supabase.from('bookings').insert({
        'user_id': groupBooking.organizerId,
        'event_id': groupBooking.eventId,
        'total_amount': groupBooking.totalAmount,
        'status': 'confirmed',
        'is_group_booking': true,
        'group_booking_id': groupBookingId,
        'special_requests': groupBooking.specialRequests,
      });
    } catch (e) {
      throw Exception('Failed to create final booking: $e');
    }
  }

  // Cancel group booking
  Future<void> cancelGroupBooking(String groupBookingId) async {
    try {
      await _supabase
          .from('group_bookings')
          .update({'status': 'cancelled'})
          .eq('id', groupBookingId);
    } catch (e) {
      throw Exception('Failed to cancel group booking: $e');
    }
  }

  // Get user's group bookings
  Future<List<GroupBooking>> getUserGroupBookings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('group_bookings')
          .select()
          .or('organizer_id.eq.${currentUser.id},'
              'id.in.(select group_booking_id from group_members where user_id=${currentUser.id})')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => GroupBooking.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Helper: Generate random invite token
  String _generateInviteToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Helper: Send invite notification
  Future<void> _sendInviteNotification({
    String? email,
    String? phone,
    required String inviteToken,
    required String groupBookingId,
  }) async {
    // In production, integrate with email/SMS service
    // For now, this is a placeholder
    try {
      final inviteLink = 'https://bottlesup.app/invite/$inviteToken';

      if (email != null) {
        // Send email via Supabase Edge Function
        await _supabase.functions.invoke('send-group-invite-email', body: {
          'email': email,
          'invite_link': inviteLink,
          'group_booking_id': groupBookingId,
        });
      }

      if (phone != null) {
        // Send SMS via Supabase Edge Function
        await _supabase.functions.invoke('send-group-invite-sms', body: {
          'phone': phone,
          'invite_link': inviteLink,
          'group_booking_id': groupBookingId,
        });
      }
    } catch (e) {
      // Silently fail - notification is not critical
    }
  }
}
