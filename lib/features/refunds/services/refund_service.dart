import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/refund_request.dart';

class RefundService {
  static final RefundService _instance = RefundService._internal();
  factory RefundService() => _instance;
  RefundService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit refund request
  Future<RefundRequest> submitRefundRequest({
    required String bookingId,
    required double originalAmount,
    required double requestedAmount,
    required RefundReason reason,
    required String description,
    List<String>? attachments,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final requestData = {
        'user_id': currentUser.id,
        'booking_id': bookingId,
        'original_amount': originalAmount,
        'requested_amount': requestedAmount,
        'reason': reason.name,
        'description': description,
        'attachments': attachments,
        'status': RefundStatus.pending.name,
      };

      final response = await _supabase
          .from('refund_requests')
          .insert(requestData)
          .select()
          .single();

      return RefundRequest.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to submit refund request: $e');
    }
  }

  // Get user's refund requests
  Future<List<RefundRequest>> getUserRefundRequests() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('refund_requests')
          .select()
          .eq('user_id', currentUser.id)
          .order('requested_at', ascending: false);

      return (response as List)
          .map((data) => RefundRequest.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get refund request by ID
  Future<RefundRequest?> getRefundRequest(String requestId) async {
    try {
      final response = await _supabase
          .from('refund_requests')
          .select()
          .eq('id', requestId)
          .single();

      return RefundRequest.fromSupabase(response);
    } catch (e) {
      return null;
    }
  }

  // Cancel refund request
  Future<void> cancelRefundRequest(String requestId) async {
    try {
      await _supabase
          .from('refund_requests')
          .delete()
          .eq('id', requestId)
          .eq('status', RefundStatus.pending.name);
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  // Upload attachment
  Future<String> uploadAttachment(String filePath) async {
    try {
      final fileName = 'refund_${DateTime.now().millisecondsSinceEpoch}_${filePath.split('/').last}';

      await _supabase.storage
          .from('refund-attachments')
          .upload(fileName, filePath);

      final url = _supabase.storage
          .from('refund-attachments')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      throw Exception('Failed to upload attachment: $e');
    }
  }
}
