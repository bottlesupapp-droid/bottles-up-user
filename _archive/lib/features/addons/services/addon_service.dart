import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/addon.dart';

class AddonService {
  static final AddonService _instance = AddonService._internal();
  factory AddonService() => _instance;
  AddonService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all available addons
  Future<List<Addon>> getAvailableAddons({String? venueId}) async {
    try {
      dynamic query = _supabase
          .from('addons')
          .select()
          .eq('is_available', true);

      if (venueId != null) {
        query = query.eq('venue_id', venueId);
      }

      query = query.order('category');
      final response = await query;

      return (response as List)
          .map((item) => Addon.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get available addons: $e');
    }
  }

  // Get addons by category
  Future<List<Addon>> getAddonsByCategory(AddonCategory category) async {
    try {
      final response = await _supabase
          .from('addons')
          .select()
          .eq('category', category.name)
          .eq('is_available', true)
          .order('price');

      return (response as List)
          .map((item) => Addon.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get addons by category: $e');
    }
  }

  // Add addon to booking
  Future<BookingAddon> addAddonToBooking({
    required String bookingId,
    required String addonId,
    required int quantity,
    String? specialInstructions,
    DateTime? scheduledTime,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get addon details
      final addon = await _supabase
          .from('addons')
          .select()
          .eq('id', addonId)
          .single();

      final price = (addon['price'] as num).toDouble();
      final totalPrice = price * quantity;

      // Check stock availability
      if (addon['available_stock'] != null) {
        final availableStock = addon['available_stock'] as int;
        if (availableStock < quantity) {
          throw Exception('Insufficient stock available');
        }
      }

      // Create booking addon
      final response = await _supabase.from('booking_addons').insert({
        'booking_id': bookingId,
        'addon_id': addonId,
        'addon_name': addon['name'],
        'price': price,
        'quantity': quantity,
        'total_price': totalPrice,
        'special_instructions': specialInstructions,
        'scheduled_time': scheduledTime?.toIso8601String(),
        'status': addon['requires_approval'] == true ? 'pending' : 'approved',
      }).select().single();

      // Update stock if applicable
      if (addon['available_stock'] != null) {
        await _supabase
            .from('addons')
            .update({
              'available_stock': (addon['available_stock'] as int) - quantity,
            })
            .eq('id', addonId);
      }

      return BookingAddon.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add addon to booking: $e');
    }
  }

  // Get booking addons
  Future<List<BookingAddon>> getBookingAddons(String bookingId) async {
    try {
      final response = await _supabase
          .from('booking_addons')
          .select()
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => BookingAddon.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update addon quantity
  Future<void> updateAddonQuantity({
    required String bookingAddonId,
    required int newQuantity,
  }) async {
    try {
      // Get current addon
      final current = await _supabase
          .from('booking_addons')
          .select()
          .eq('id', bookingAddonId)
          .single();

      final price = (current['price'] as num).toDouble();
      final newTotalPrice = price * newQuantity;

      await _supabase
          .from('booking_addons')
          .update({
            'quantity': newQuantity,
            'total_price': newTotalPrice,
          })
          .eq('id', bookingAddonId);
    } catch (e) {
      throw Exception('Failed to update addon quantity: $e');
    }
  }

  // Remove addon from booking
  Future<void> removeAddonFromBooking(String bookingAddonId) async {
    try {
      // Get addon details to restore stock
      final bookingAddon = await _supabase
          .from('booking_addons')
          .select()
          .eq('id', bookingAddonId)
          .single();

      // Delete booking addon
      await _supabase
          .from('booking_addons')
          .delete()
          .eq('id', bookingAddonId);

      // Restore stock if applicable
      final addon = await _supabase
          .from('addons')
          .select()
          .eq('id', bookingAddon['addon_id'])
          .single();

      if (addon['available_stock'] != null) {
        await _supabase
            .from('addons')
            .update({
              'available_stock': (addon['available_stock'] as int) + (bookingAddon['quantity'] as int),
            })
            .eq('id', bookingAddon['addon_id']);
      }
    } catch (e) {
      throw Exception('Failed to remove addon from booking: $e');
    }
  }

  // Get popular addons
  Future<List<Addon>> getPopularAddons({int limit = 10}) async {
    try {
      final response = await _supabase.rpc('get_popular_addons', params: {
        'limit_count': limit,
      });

      return (response as List)
          .map((item) => Addon.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get addon recommendations based on booking
  Future<List<Addon>> getAddonRecommendations(String bookingId) async {
    try {
      final response = await _supabase.rpc('get_addon_recommendations', params: {
        'booking_id_param': bookingId,
      });

      return (response as List)
          .map((item) => Addon.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Calculate total addons price for booking
  Future<double> calculateAddonsTotal(String bookingId) async {
    try {
      final addons = await getBookingAddons(bookingId);
      return addons.fold<double>(0.0, (sum, addon) => sum + addon.totalPrice);
    } catch (e) {
      return 0.0;
    }
  }

  // Update addon status
  Future<void> updateAddonStatus({
    required String bookingAddonId,
    required AddonStatus status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
      };

      if (status == AddonStatus.approved) {
        updates['approved_at'] = DateTime.now().toIso8601String();
      } else if (status == AddonStatus.delivered) {
        updates['delivered_at'] = DateTime.now().toIso8601String();
      }

      await _supabase
          .from('booking_addons')
          .update(updates)
          .eq('id', bookingAddonId);
    } catch (e) {
      throw Exception('Failed to update addon status: $e');
    }
  }
}
