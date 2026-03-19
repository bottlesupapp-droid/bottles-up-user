import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ticket_transfer.dart';

class TicketTransferService {
  static final TicketTransferService _instance = TicketTransferService._internal();
  factory TicketTransferService() => _instance;
  TicketTransferService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Initiate ticket transfer to a friend
  Future<TicketTransfer> transferTicket({
    required String ticketId,
    required String toUserEmail,
    String? message,
    Duration? expiryDuration,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Find recipient user by email
    final userResponse = await _supabase
        .from('users')
        .select('id')
        .eq('email', toUserEmail)
        .maybeSingle();

    if (userResponse == null) {
      throw Exception('User with email $toUserEmail not found');
    }

    final toUserId = userResponse['id'] as String;

    // Check if ticket belongs to current user
    final ticketResponse = await _supabase
        .from('event_rsvps')
        .select('user_id')
        .eq('id', ticketId)
        .single();

    if (ticketResponse['user_id'] != userId) {
      throw Exception('You do not own this ticket');
    }

    final expiresAt = expiryDuration != null
        ? DateTime.now().add(expiryDuration)
        : DateTime.now().add(const Duration(days: 7));

    final data = {
      'ticket_id': ticketId,
      'from_user_id': userId,
      'to_user_id': toUserId,
      'status': 'pending',
      'message': message,
      'expires_at': expiresAt.toIso8601String(),
    };

    final response = await _supabase
        .from('ticket_transfers')
        .insert(data)
        .select()
        .single();

    return TicketTransfer.fromSupabase(response);
  }

  /// Get pending transfer requests (received)
  Future<List<TicketTransfer>> getPendingTransfers() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('ticket_transfers')
        .select('''
          *,
          from_user:users!from_user_id(full_name, email),
          to_user:users!to_user_id(full_name, email),
          event_rsvps!inner(
            events!inner(name, event_date)
          )
        ''')
        .eq('to_user_id', userId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final fromUser = item['from_user'] as Map<String, dynamic>?;
      final toUser = item['to_user'] as Map<String, dynamic>?;
      final rsvp = item['event_rsvps'] as Map<String, dynamic>?;
      final event = rsvp?['events'] as Map<String, dynamic>?;

      return TicketTransfer.fromSupabase({
        ...item,
        'from_user_name': fromUser?['full_name'],
        'from_user_email': fromUser?['email'],
        'to_user_name': toUser?['full_name'],
        'to_user_email': toUser?['email'],
        'event_name': event?['name'],
        'event_date': event?['event_date'],
      });
    }).toList();
  }

  /// Get sent transfer requests
  Future<List<TicketTransfer>> getSentTransfers() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('ticket_transfers')
        .select('''
          *,
          from_user:users!from_user_id(full_name, email),
          to_user:users!to_user_id(full_name, email),
          event_rsvps!inner(
            events!inner(name, event_date)
          )
        ''')
        .eq('from_user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final fromUser = item['from_user'] as Map<String, dynamic>?;
      final toUser = item['to_user'] as Map<String, dynamic>?;
      final rsvp = item['event_rsvps'] as Map<String, dynamic>?;
      final event = rsvp?['events'] as Map<String, dynamic>?;

      return TicketTransfer.fromSupabase({
        ...item,
        'from_user_name': fromUser?['full_name'],
        'from_user_email': fromUser?['email'],
        'to_user_name': toUser?['full_name'],
        'to_user_email': toUser?['email'],
        'event_name': event?['name'],
        'event_date': event?['event_date'],
      });
    }).toList();
  }

  /// Accept ticket transfer
  Future<void> acceptTransfer(String transferId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Get transfer details
    final transfer = await _supabase
        .from('ticket_transfers')
        .select('*, event_rsvps!inner(id)')
        .eq('id', transferId)
        .single();

    if (transfer['to_user_id'] != userId) {
      throw Exception('This transfer is not for you');
    }

    if (transfer['status'] != 'pending') {
      throw Exception('Transfer is no longer pending');
    }

    // Update ticket ownership
    await _supabase
        .from('event_rsvps')
        .update({'user_id': userId})
        .eq('id', transfer['ticket_id']);

    // Update transfer status
    await _supabase
        .from('ticket_transfers')
        .update({
          'status': 'accepted',
          'transferred_at': DateTime.now().toIso8601String(),
        })
        .eq('id', transferId);
  }

  /// Reject ticket transfer
  Future<void> rejectTransfer(String transferId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('ticket_transfers')
        .update({'status': 'rejected'})
        .eq('id', transferId)
        .eq('to_user_id', userId);
  }

  /// Cancel ticket transfer (sender)
  Future<void> cancelTransfer(String transferId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('ticket_transfers')
        .update({'status': 'cancelled'})
        .eq('id', transferId)
        .eq('from_user_id', userId)
        .eq('status', 'pending');
  }
}
