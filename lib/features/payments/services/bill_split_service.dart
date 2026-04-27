import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bill_split.dart';

class BillSplitService {
  static final BillSplitService _instance = BillSplitService._internal();
  factory BillSplitService() => _instance;
  BillSplitService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create bill split
  Future<BillSplit> createBillSplit({
    required String bookingId,
    required double totalAmount,
    required SplitMethod splitMethod,
    required List<Map<String, dynamic>> participants,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('bill_splits').insert({
        'booking_id': bookingId,
        'total_amount': totalAmount,
        'split_method': splitMethod.name,
        'created_by': currentUser.id,
      }).select().single();

      final billSplitId = response['id'] as String;

      // Create participants
      final participantResponses = await Future.wait(
        participants.map((p) {
          return _supabase.from('bill_participants').insert({
            'bill_split_id': billSplitId,
            'user_id': p['user_id'],
            'user_name': p['user_name'],
            'email': p['email'],
            'phone': p['phone'],
            'amount_owed': p['amount_owed'],
          }).select().single();
        }),
      );

      final billSplit = BillSplit.fromSupabase(response);
      final participantsList = participantResponses
          .map((r) => BillParticipant.fromSupabase(r as Map<String, dynamic>))
          .toList();

      return billSplit.copyWith(participants: participantsList);
    } catch (e) {
      throw Exception('Failed to create bill split: $e');
    }
  }

  // Get bill split for booking
  Future<BillSplit?> getBillSplitForBooking(String bookingId) async {
    try {
      final response = await _supabase
          .from('bill_splits')
          .select('*, bill_participants(*)')
          .eq('booking_id', bookingId)
          .maybeSingle();

      if (response == null) return null;

      return BillSplit.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get bill split by ID
  Future<BillSplit?> getBillSplit(String billSplitId) async {
    try {
      final response = await _supabase
          .from('bill_splits')
          .select('*, bill_participants(*)')
          .eq('id', billSplitId)
          .single();

      return BillSplit.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Add participant to split
  Future<BillParticipant> addParticipant({
    required String billSplitId,
    String? userId,
    String? userName,
    String? email,
    String? phone,
    required double amountOwed,
  }) async {
    try {
      final response = await _supabase.from('bill_participants').insert({
        'bill_split_id': billSplitId,
        'user_id': userId,
        'user_name': userName,
        'email': email,
        'phone': phone,
        'amount_owed': amountOwed,
      }).select().single();

      return BillParticipant.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  // Update participant amount
  Future<void> updateParticipantAmount({
    required String participantId,
    required double amountOwed,
  }) async {
    try {
      await _supabase
          .from('bill_participants')
          .update({'amount_owed': amountOwed})
          .eq('id', participantId);
    } catch (e) {
      throw Exception('Failed to update participant amount: $e');
    }
  }

  // Remove participant
  Future<void> removeParticipant(String participantId) async {
    try {
      await _supabase.from('bill_participants').delete().eq('id', participantId);
    } catch (e) {
      throw Exception('Failed to remove participant: $e');
    }
  }

  // Mark participant as paid
  Future<void> markParticipantPaid({
    required String participantId,
    required double amountPaid,
    String? paymentIntentId,
  }) async {
    try {
      await _supabase.from('bill_participants').update({
        'status': ParticipantStatus.paid.name,
        'amount_paid': amountPaid,
        'payment_intent_id': paymentIntentId,
        'paid_at': DateTime.now().toIso8601String(),
      }).eq('id', participantId);

      // Check if all participants have paid
      await _checkAndCompleteSplit(participantId);
    } catch (e) {
      throw Exception('Failed to mark participant as paid: $e');
    }
  }

  // Send payment links to all participants
  Future<void> sendPaymentLinks(String billSplitId) async {
    try {
      await _supabase.functions.invoke('send-bill-split-links', body: {
        'bill_split_id': billSplitId,
      });
    } catch (e) {
      throw Exception('Failed to send payment links: $e');
    }
  }

  // Send payment reminder to participant
  Future<void> sendPaymentReminder(String participantId) async {
    try {
      await _supabase.functions.invoke('send-payment-reminder', body: {
        'participant_id': participantId,
      });
    } catch (e) {
      throw Exception('Failed to send payment reminder: $e');
    }
  }

  // Generate payment URL for participant
  Future<String> generatePaymentUrl(String participantId) async {
    try {
      final response = await _supabase.rpc('generate_payment_url', params: {
        'participant_id_param': participantId,
      });

      return response as String;
    } catch (e) {
      throw Exception('Failed to generate payment URL: $e');
    }
  }

  // Cancel bill split
  Future<void> cancelBillSplit(String billSplitId) async {
    try {
      await _supabase.from('bill_splits').update({
        'status': SplitStatus.cancelled.name,
      }).eq('id', billSplitId);

      // Cancel all pending participant payments
      await _supabase.from('bill_participants').update({
        'status': ParticipantStatus.declined.name,
      }).eq('bill_split_id', billSplitId).eq('status', ParticipantStatus.pending.name);
    } catch (e) {
      throw Exception('Failed to cancel bill split: $e');
    }
  }

  // Get user's bill splits
  Future<List<BillSplit>> getUserBillSplits({bool includePaid = false}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('bill_splits')
          .select('*, bill_participants!inner(*)')
          .or('created_by.eq.${currentUser.id},bill_participants.user_id.eq.${currentUser.id}');

      if (!includePaid) {
        query = query.neq('status', SplitStatus.completed.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => BillSplit.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Itemized split - create items
  Future<BillItem> addBillItem({
    required String billSplitId,
    required String itemName,
    required double price,
    int quantity = 1,
    List<String> assignedToUserIds = const [],
  }) async {
    try {
      final response = await _supabase.from('bill_items').insert({
        'bill_split_id': billSplitId,
        'item_name': itemName,
        'price': price,
        'quantity': quantity,
        'assigned_to_user_ids': assignedToUserIds,
      }).select().single();

      return BillItem.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add bill item: $e');
    }
  }

  // Get items for bill split
  Future<List<BillItem>> getBillItems(String billSplitId) async {
    try {
      final response = await _supabase
          .from('bill_items')
          .select()
          .eq('bill_split_id', billSplitId);

      return (response as List)
          .map((item) => BillItem.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Assign item to user
  Future<void> assignItemToUser({
    required String billItemId,
    required String userId,
  }) async {
    try {
      // Get current assigned users
      final response = await _supabase
          .from('bill_items')
          .select('assigned_to_user_ids')
          .eq('id', billItemId)
          .single();

      final currentAssigned = List<String>.from(
        response['assigned_to_user_ids'] as List? ?? [],
      );

      if (!currentAssigned.contains(userId)) {
        currentAssigned.add(userId);
        await _supabase.from('bill_items').update({
          'assigned_to_user_ids': currentAssigned,
        }).eq('id', billItemId);
      }
    } catch (e) {
      throw Exception('Failed to assign item: $e');
    }
  }

  // Calculate participant amounts from itemized bill
  Future<void> calculateFromItems(String billSplitId) async {
    try {
      await _supabase.rpc('calculate_bill_from_items', params: {
        'bill_split_id_param': billSplitId,
      });
    } catch (e) {
      throw Exception('Failed to calculate from items: $e');
    }
  }

  // Private helper to check if split is complete
  Future<void> _checkAndCompleteSplit(String participantId) async {
    try {
      // Get bill split ID
      final participantResponse = await _supabase
          .from('bill_participants')
          .select('bill_split_id')
          .eq('id', participantId)
          .single();

      final billSplitId = participantResponse['bill_split_id'] as String;

      // Check if all participants have paid
      final allParticipants = await _supabase
          .from('bill_participants')
          .select('status')
          .eq('bill_split_id', billSplitId);

      final allPaid = (allParticipants as List).every(
        (p) => p['status'] == ParticipantStatus.paid.name,
      );

      if (allPaid) {
        await _supabase.from('bill_splits').update({
          'status': SplitStatus.completed.name,
          'completed_at': DateTime.now().toIso8601String(),
        }).eq('id', billSplitId);
      }
    } catch (e) {
      // Non-critical error
    }
  }

  // Real-time subscription for bill split updates
  RealtimeChannel subscribeToBillSplit({
    required String billSplitId,
    required Function(BillSplit) onUpdate,
  }) {
    final channel = _supabase.channel('bill_split_$billSplitId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bill_participants',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'bill_split_id',
            value: billSplitId,
          ),
          callback: (payload) async {
            // Reload bill split
            final billSplit = await getBillSplit(billSplitId);
            if (billSplit != null) {
              onUpdate(billSplit);
            }
          },
        )
        .subscribe();

    return channel;
  }
}
