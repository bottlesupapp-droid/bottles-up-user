import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_rsvp.dart';

class EventBookingService {
  static final EventBookingService _instance = EventBookingService._internal();
  factory EventBookingService() => _instance;
  EventBookingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get event configuration
  Future<EventConfiguration?> getEventConfiguration(String eventId) async {
    try {
      final response = await _supabase
          .from('event_configurations')
          .select()
          .eq('event_id', eventId)
          .maybeSingle();

      if (response == null) return null;
      return EventConfiguration.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to fetch event configuration: $e');
    }
  }

  /// Create a guestlist RSVP with pending status and verification code
  Future<EventRSVP> createGuestlistRSVP({
    required String eventId,
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? specialRequests,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Check if user already has an RSVP for this event
      final existingRSVP = await _supabase
          .from('event_rsvps')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingRSVP != null) {
        throw Exception('You have already RSVP\'d to this event');
      }

      // Generate verification code
      final verificationCode = await _generateVerificationCode();

      final response = await _supabase
          .from('event_rsvps')
          .insert({
            'event_id': eventId,
            'user_id': user.id,
            'rsvp_type': 'guestlist',
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone': phone,
            'special_requests': specialRequests,
            'status': 'pending', // Changed from 'confirmed' to 'pending'
            'verification_code': verificationCode,
            'is_attended': false,
            'table_booking_id': null, // Explicitly set to null for guestlist RSVPs
          })
          .select()
          .single();

      return EventRSVP.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to create RSVP: $e');
    }
  }

  /// Generate a unique verification code
  Future<String> _generateVerificationCode() async {
    try {
      final response = await _supabase.rpc('generate_verification_code');
      return response as String;
    } catch (e) {
      // Fallback to local generation if RPC fails
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final random = (timestamp.hashCode % 100000000).toString().padLeft(8, '0');
      return random.substring(0, 8).toUpperCase();
    }
  }

  /// Verify RSVP with verification code (for organizers)
  Future<void> verifyRSVP({
    required String verificationCode,
    required String organizerId,
  }) async {
    try {
      final response = await _supabase
          .from('event_rsvps')
          .update({
            'status': 'verified',
            'verified_at': DateTime.now().toIso8601String(),
            'verified_by': organizerId,
          })
          .eq('verification_code', verificationCode)
          .select()
          .single();

      // The database trigger will handle sending the approval email
      print('RSVP verified successfully for code: $verificationCode');
    } catch (e) {
      throw Exception('Failed to verify RSVP: $e');
    }
  }

  /// Create a table booking
  Future<EventTableBooking> createTableBooking({
    required String eventId,
    required String tableId,
    required int partySize,
    required double depositAmount,
    required int minimumBottles,
    String? specialRequests,
    List<SplitPaymentParticipant>? splitPayments,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Check if user already has a table booking for this event
      final existingBooking = await _supabase
          .from('event_table_bookings')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingBooking != null) {
        throw Exception('You already have a table booking for this event');
      }

      // Verify the table exists and is available for this event
      final tableExists = await _supabase
          .from('event_tables')
          .select('id')
          .eq('id', tableId)
          .eq('event_id', eventId)
          .eq('is_active', true)
          .maybeSingle();

      if (tableExists == null) {
        throw Exception('Selected table is not available for this event');
      }

      final response = await _supabase
          .from('event_table_bookings')
          .insert({
            'event_id': eventId,
            'user_id': user.id,
            'table_id': tableId,
            'guest_count': partySize,
            'deposit_amount': depositAmount,
            'bottle_minimum': minimumBottles,
            'special_requests': specialRequests,
            'status': 'pending_payment',
            'payment_status': 'pending',
            'contact_email': user.email,
          })
          .select()
          .single();

      final booking = EventTableBooking.fromSupabase(response);

      // If split payments are provided, create them
      if (splitPayments != null && splitPayments.isNotEmpty) {
        await _createSplitPayments(booking.id, splitPayments);
      }

      return booking;
    } catch (e) {
      throw Exception('Failed to create table booking: $e');
    }
  }

  /// Create split payment participants
  Future<void> _createSplitPayments(
    String tableBookingId,
    List<SplitPaymentParticipant> participants,
  ) async {
    try {
      final data = participants.map((participant) => {
        'table_booking_id': tableBookingId,
        'participant_name': participant.participantName,
        'email': participant.email,
        'amount': participant.amount,
        'payment_status': 'pending',
      }).toList();

      await _supabase.from('split_payment_participants').insert(data);
    } catch (e) {
      throw Exception('Failed to create split payments: $e');
    }
  }

  /// Get user's RSVP for an event
  Future<EventRSVP?> getUserRSVP(String eventId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('event_rsvps')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return EventRSVP.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to fetch user RSVP: $e');
    }
  }

  /// Get user's table booking for an event
  Future<EventTableBooking?> getUserTableBooking(String eventId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('event_table_bookings')
          .select('''
            *,
            split_payments:split_payment_participants(*)
          ''')
          .eq('event_id', eventId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return EventTableBooking.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to fetch user table booking: $e');
    }
  }

  /// Get available tables for an event
  Future<List<Map<String, dynamic>>> getAvailableTables(String eventId) async {
    try {
      // Fetch available tables from the event_tables table
      final tablesResponse = await _supabase
          .from('event_tables')
          .select('id, name, capacity, price, is_vip, location_description, minimum_spend, image_url')
          .eq('event_id', eventId)
          .eq('is_active', true);

      // Get event configuration for defaults
      final config = await getEventConfiguration(eventId);

      // Transform the tables to match the expected format
      return tablesResponse.map((table) {
        final price = table['price'] as num?;
        final minimumSpend = table['minimum_spend'] as num?;
        return {
          'id': table['id'], // This is now a proper UUID
          'name': table['name'],
          'capacity': table['capacity'],
          'price': price != null ? price.toDouble() : // Price is already in dollars
              (config?.minTableDeposit ?? 100.0),
          'deposit_amount': config?.minTableDeposit ?? 50.0, // Separate deposit amount
          'minimum_bottles': config?.minBottleRequirement ?? 2,
          'description': table['location_description'] ??
              (table['is_vip'] == true ? 'VIP table with premium service' : 'Standard table'),
          'minimum_spend': minimumSpend != null ? minimumSpend.toDouble() / 100 : null, // minimum_spend might still be in cents
          'image_url': table['image_url'], // Table image URL
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch available tables: $e');
    }
  }

  /// Update deposit payment status
  Future<void> updateDepositPaymentStatus(
    String tableBookingId,
    bool isPaid,
    String? paymentIntentId,
  ) async {
    try {
      await _supabase
          .from('event_table_bookings')
          .update({
            'payment_status': isPaid ? 'paid' : 'pending',
            'status': isPaid ? 'confirmed' : 'pending_payment',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', tableBookingId);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Calculate split payment amounts
  List<SplitPaymentParticipant> calculateSplitPayments({
    required double totalAmount,
    required int numberOfPeople,
    required List<String> participantNames,
    required List<String> participantEmails,
  }) {
    final amountPerPerson = totalAmount / numberOfPeople;

    final participants = <SplitPaymentParticipant>[];
    for (int i = 0; i < numberOfPeople; i++) {
      participants.add(
        SplitPaymentParticipant(
          id: '', // Will be generated by database
          tableBookingId: '', // Will be set when creating
          participantName: i < participantNames.length ? participantNames[i] : 'Participant ${i + 1}',
          email: i < participantEmails.length ? participantEmails[i] : '',
          amount: amountPerPerson,
          paymentStatus: 'pending',
        ),
      );
    }

    return participants;
  }

  /// Get available bottles for an event
  Future<List<Map<String, dynamic>>> getAvailableBottles(String eventId) async {
    try {
      final bottlesResponse = await _supabase
          .from('bottles')
          .select('id, name, category, subcategory, brand, price, volume_ml, alcohol_content, description, image_url, is_featured')
          .eq('event_id', eventId)
          .eq('is_available', true)
          .order('is_featured', ascending: false)
          .order('category')
          .order('price');

      return bottlesResponse.map((bottle) {
        final price = bottle['price'] as num?;
        return {
          'id': bottle['id'],
          'name': bottle['name'],
          'category': bottle['category'],
          'subcategory': bottle['subcategory'],
          'brand': bottle['brand'],
          'price': price != null ? price.toDouble() / 100 : 0.0, // Convert from cents to dollars
          'volume_ml': bottle['volume_ml'],
          'alcohol_content': bottle['alcohol_content'],
          'description': bottle['description'],
          'image_url': bottle['image_url'],
          'is_featured': bottle['is_featured'] ?? false,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch available bottles: $e');
    }
  }

  /// Calculate total cost with fees
  Map<String, double> calculateTotalCost({
    required double depositAmount,
    double bottlesTotal = 0.0,
    double serviceFeeRate = 0.07,
    double taxRate = 0.13,
  }) {
    final subtotalBeforeFees = depositAmount + bottlesTotal;
    final serviceFee = subtotalBeforeFees * serviceFeeRate;
    final subtotal = subtotalBeforeFees + serviceFee;
    final tax = subtotal * taxRate;
    final total = subtotal + tax;

    return {
      'deposit': depositAmount,
      'bottles': bottlesTotal,
      'service_fee': serviceFee,
      'tax': tax,
      'total': total,
    };
  }
}