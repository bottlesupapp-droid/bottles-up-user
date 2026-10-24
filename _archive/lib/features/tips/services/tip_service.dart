import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tip_record.dart';

class TipService {
  static final TipService _instance = TipService._internal();
  factory TipService() => _instance;
  TipService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Default tip presets
  static const List<TipPreset> defaultPresets = [
    TipPreset(label: '15%', percentage: 15.0),
    TipPreset(label: '18%', percentage: 18.0, isDefault: true),
    TipPreset(label: '20%', percentage: 20.0),
    TipPreset(label: '25%', percentage: 25.0),
  ];

  // Record a tip
  Future<TipRecord> recordTip({
    required String bookingId,
    required double tipAmount,
    required double billAmount,
    required TipType tipType,
    double? tipPercentage,
    String? venueId,
    String? venueName,
    String? staffId,
    String? staffName,
    String? paymentMethod,
    String? currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('tip_records').insert({
        'user_id': currentUser.id,
        'booking_id': bookingId,
        'venue_id': venueId,
        'venue_name': venueName,
        'staff_id': staffId,
        'staff_name': staffName,
        'tip_amount': tipAmount,
        'bill_amount': billAmount,
        'tip_type': tipType.name,
        'tip_percentage': tipPercentage,
        'payment_method': paymentMethod,
        'currency': currency ?? 'USD',
        'metadata': metadata,
      }).select().single();

      return TipRecord.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to record tip: $e');
    }
  }

  // Get user's tip history
  Future<List<TipRecord>> getTipHistory({
    int limit = 50,
    int offset = 0,
    String? venueId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('tip_records')
          .select()
          .eq('user_id', currentUser.id);

      if (venueId != null) {
        query = query.eq('venue_id', venueId);
      }

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => TipRecord.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get tip statistics
  Future<TipStatistics> getTipStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('get_tip_statistics', params: {
        'user_id_param': currentUser.id,
        'start_date_param': startDate?.toIso8601String(),
        'end_date_param': endDate?.toIso8601String(),
      });

      return TipStatistics.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get tip statistics: $e');
    }
  }

  // Calculate tip amount from percentage
  double calculateTip({
    required double billAmount,
    required double percentage,
  }) {
    return billAmount * (percentage / 100);
  }

  // Calculate tip percentage from amount
  double calculateTipPercentage({
    required double billAmount,
    required double tipAmount,
  }) {
    if (billAmount == 0) return 0;
    return (tipAmount / billAmount) * 100;
  }

  // Get tip for booking (if already tipped)
  Future<TipRecord?> getTipForBooking(String bookingId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('tip_records')
          .select()
          .eq('user_id', currentUser.id)
          .eq('booking_id', bookingId)
          .maybeSingle();

      if (response == null) return null;

      return TipRecord.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update tip amount
  Future<void> updateTip({
    required String tipId,
    required double tipAmount,
    required TipType tipType,
    double? tipPercentage,
  }) async {
    try {
      await _supabase.from('tip_records').update({
        'tip_amount': tipAmount,
        'tip_type': tipType.name,
        'tip_percentage': tipPercentage,
      }).eq('id', tipId);
    } catch (e) {
      throw Exception('Failed to update tip: $e');
    }
  }

  // Get average tip for venue (helps user decide)
  Future<double?> getAverageTipPercentageForVenue(String venueId) async {
    try {
      final response = await _supabase.rpc('get_venue_average_tip', params: {
        'venue_id_param': venueId,
      });

      return (response as num?)?.toDouble();
    } catch (e) {
      return null;
    }
  }

  // Get user's preferred tip presets
  Future<List<TipPreset>> getTipPresets() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return defaultPresets;

      final response = await _supabase
          .from('users')
          .select('tip_presets')
          .eq('id', currentUser.id)
          .single();

      final presets = response['tip_presets'] as List?;
      if (presets == null || presets.isEmpty) {
        return defaultPresets;
      }

      return presets
          .map((p) => TipPreset.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return defaultPresets;
    }
  }

  // Save custom tip presets
  Future<void> saveTipPresets(List<TipPreset> presets) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('users').update({
        'tip_presets': presets.map((p) => p.toJson()).toList(),
      }).eq('id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to save tip presets: $e');
    }
  }

  // Get tips grouped by venue
  Future<Map<String, List<TipRecord>>> getTipsGroupedByVenue() async {
    try {
      final tips = await getTipHistory(limit: 100);
      final grouped = <String, List<TipRecord>>{};

      for (final tip in tips) {
        final venueId = tip.venueId ?? 'unknown';
        if (!grouped.containsKey(venueId)) {
          grouped[venueId] = [];
        }
        grouped[venueId]!.add(tip);
      }

      return grouped;
    } catch (e) {
      return {};
    }
  }

  // Get monthly tip summary
  Future<Map<String, double>> getMonthlyTipSummary({
    required int year,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return {};

      final response = await _supabase.rpc('get_monthly_tip_summary', params: {
        'user_id_param': currentUser.id,
        'year_param': year,
      });

      return Map<String, double>.from(response as Map);
    } catch (e) {
      return {};
    }
  }

  // Check if booking has been tipped
  Future<bool> hasBeenTipped(String bookingId) async {
    try {
      final tip = await getTipForBooking(bookingId);
      return tip != null;
    } catch (e) {
      return false;
    }
  }

  // Add tip to existing payment
  Future<TipRecord> addTipToPayment({
    required String bookingId,
    required double billAmount,
    required double tipPercentage,
    String? staffId,
  }) async {
    final tipAmount = calculateTip(
      billAmount: billAmount,
      percentage: tipPercentage,
    );

    return await recordTip(
      bookingId: bookingId,
      tipAmount: tipAmount,
      billAmount: billAmount,
      tipType: TipType.percentage,
      tipPercentage: tipPercentage,
      staffId: staffId,
    );
  }

  // Get tip insights (best tipping habits, recommendations)
  Future<Map<String, dynamic>> getTipInsights() async {
    try {
      final stats = await getTipStatistics();
      final insights = <String, dynamic>{};

      // Calculate user's typical tip percentage
      insights['typical_tip_percentage'] = stats.averageTipPercentage;

      // Determine if user is a generous tipper
      if (stats.averageTipPercentage >= 20) {
        insights['tipper_level'] = 'generous';
      } else if (stats.averageTipPercentage >= 15) {
        insights['tipper_level'] = 'standard';
      } else {
        insights['tipper_level'] = 'conservative';
      }

      // Total spent on tips
      insights['total_tipped'] = stats.totalTipped;

      // Most frequent venue
      insights['favorite_venue'] = stats.mostTippedVenue;

      return insights;
    } catch (e) {
      return {};
    }
  }
}
