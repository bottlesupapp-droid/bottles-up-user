import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bottle_upgrade.dart';

class BottleUpgradeService {
  static final BottleUpgradeService _instance = BottleUpgradeService._internal();
  factory BottleUpgradeService() => _instance;
  BottleUpgradeService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get available upgrades for a bottle
  Future<List<BottleUpgrade>> getAvailableUpgrades(String bottleId) async {
    try {
      final response = await _supabase
          .from('bottle_upgrades')
          .select()
          .eq('bottle_id', bottleId)
          .eq('is_available', true)
          .order('price_difference', ascending: true);

      return (response as List)
          .map((item) => BottleUpgrade.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get available upgrades: $e');
    }
  }

  // Request bottle upgrade
  Future<UpgradeRequest> requestUpgrade({
    required String bookingId,
    required String originalBottleId,
    required String upgradeBottleId,
    String? notes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get price difference
      final upgrade = await _supabase
          .from('bottle_upgrades')
          .select()
          .eq('bottle_id', originalBottleId)
          .eq('upgrade_bottle_id', upgradeBottleId)
          .single();

      final priceDifference = (upgrade['price_difference'] as num).toDouble();

      // Create upgrade request
      final response = await _supabase.from('upgrade_requests').insert({
        'booking_id': bookingId,
        'user_id': currentUser.id,
        'original_bottle_id': originalBottleId,
        'upgrade_bottle_id': upgradeBottleId,
        'price_difference': priceDifference,
        'notes': notes,
        'status': 'pending',
      }).select().single();

      return UpgradeRequest.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to request upgrade: $e');
    }
  }

  // Approve upgrade and process payment
  Future<void> approveUpgrade(String upgradeRequestId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get upgrade request details
      final request = await _supabase
          .from('upgrade_requests')
          .select()
          .eq('id', upgradeRequestId)
          .single();

      // Process payment for price difference
      await _supabase.rpc('process_upgrade_payment', params: {
        'upgrade_request_id': upgradeRequestId,
        'user_id': currentUser.id,
        'amount': request['price_difference'],
      });

      // Update upgrade request status
      await _supabase
          .from('upgrade_requests')
          .update({
            'status': 'approved',
            'approved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', upgradeRequestId);

      // Update booking with new bottle
      await _supabase
          .from('bookings')
          .update({
            'bottle_id': request['upgrade_bottle_id'],
          })
          .eq('id', request['booking_id']);
    } catch (e) {
      throw Exception('Failed to approve upgrade: $e');
    }
  }

  // Get upgrade request status
  Future<UpgradeRequest?> getUpgradeRequest(String upgradeRequestId) async {
    try {
      final response = await _supabase
          .from('upgrade_requests')
          .select()
          .eq('id', upgradeRequestId)
          .maybeSingle();

      if (response == null) return null;

      return UpgradeRequest.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get upgrade requests for booking
  Future<List<UpgradeRequest>> getBookingUpgradeRequests(String bookingId) async {
    try {
      final response = await _supabase
          .from('upgrade_requests')
          .select()
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => UpgradeRequest.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Cancel upgrade request
  Future<void> cancelUpgradeRequest(String upgradeRequestId) async {
    try {
      await _supabase
          .from('upgrade_requests')
          .update({
            'status': 'rejected',
            'rejected_at': DateTime.now().toIso8601String(),
            'rejection_reason': 'Cancelled by user',
          })
          .eq('id', upgradeRequestId);
    } catch (e) {
      throw Exception('Failed to cancel upgrade request: $e');
    }
  }

  // Get premium upgrade options
  Future<List<BottleUpgrade>> getPremiumUpgrades(String bottleId) async {
    try {
      final response = await _supabase
          .from('bottle_upgrades')
          .select()
          .eq('bottle_id', bottleId)
          .eq('is_premium', true)
          .eq('is_available', true)
          .order('upgrade_price', ascending: false);

      return (response as List)
          .map((item) => BottleUpgrade.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get upgrade recommendations based on booking
  Future<List<BottleUpgrade>> getUpgradeRecommendations({
    required String bottleId,
    required double budget,
  }) async {
    try {
      final response = await _supabase.rpc('get_upgrade_recommendations', params: {
        'bottle_id_param': bottleId,
        'max_price_difference': budget,
      });

      return (response as List)
          .map((item) => BottleUpgrade.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
