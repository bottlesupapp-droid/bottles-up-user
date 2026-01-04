import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/wallet_pass.dart';
import '../models/event.dart';
import '../models/event_rsvp.dart';

/// Service for managing Apple Wallet passes for event bookings
class WalletPassService {
  static final WalletPassService _instance = WalletPassService._internal();
  factory WalletPassService() => _instance;
  WalletPassService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Generate and save Apple Wallet pass for RSVP
  Future<WalletPass> generateRsvpPass({
    required String eventId,
    required String rsvpId,
    required Event event,
    required EventRSVP rsvp,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate QR code data if not already present
      final qrCodeData = rsvp.qrCodeData ?? _generateQrCodeData(rsvpId);

      // Create wallet pass record
      final passData = {
        'event_id': eventId,
        'user_id': userId,
        'booking_id': rsvpId,
        'pass_type': 'rsvp',
        'event_name': event.name,
        'venue_name': event.venueDisplay,
        'event_date': event.eventDate.toIso8601String(),
        'event_time': event.formattedTime,
        'qr_code_data': qrCodeData,
        'verification_code': rsvp.verificationCode,
      };

      // Call Supabase Edge Function to generate .pkpass file
      final response = await _supabase.functions.invoke(
        'generate-wallet-pass',
        body: passData,
      );

      if (response.status != 200) {
        throw Exception('Failed to generate wallet pass: ${response.data}');
      }

      final passUrl = response.data['pass_url'] as String;

      // Save pass record to database
      final savedPass = await _supabase
          .from('wallet_passes')
          .insert({
            ...passData,
            'pass_url': passUrl,
          })
          .select()
          .single();

      return WalletPass.fromSupabase(savedPass);
    } catch (e) {
      debugPrint('Error generating RSVP wallet pass: $e');
      rethrow;
    }
  }

  /// Generate and save Apple Wallet pass for table booking
  Future<WalletPass> generateTableBookingPass({
    required String eventId,
    required String bookingId,
    required Event event,
    required EventTableBooking booking,
    required String tableName,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate QR code data
      final qrCodeData = _generateQrCodeData(bookingId);

      // Create wallet pass record
      final passData = {
        'event_id': eventId,
        'user_id': userId,
        'booking_id': bookingId,
        'pass_type': 'table_booking',
        'event_name': event.name,
        'venue_name': event.venueDisplay,
        'event_date': event.eventDate.toIso8601String(),
        'event_time': event.formattedTime,
        'qr_code_data': qrCodeData,
        'table_number': tableName,
        'party_size': booking.partySize,
      };

      // Call Supabase Edge Function to generate .pkpass file
      final response = await _supabase.functions.invoke(
        'generate-wallet-pass',
        body: passData,
      );

      if (response.status != 200) {
        throw Exception('Failed to generate wallet pass: ${response.data}');
      }

      final passUrl = response.data['pass_url'] as String;

      // Save pass record to database
      final savedPass = await _supabase
          .from('wallet_passes')
          .insert({
            ...passData,
            'pass_url': passUrl,
          })
          .select()
          .single();

      return WalletPass.fromSupabase(savedPass);
    } catch (e) {
      debugPrint('Error generating table booking wallet pass: $e');
      rethrow;
    }
  }

  /// Download and save .pkpass file locally
  Future<String> downloadPassFile(String passUrl) async {
    try {
      final response = await http.get(Uri.parse(passUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to download pass file');
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'event_pass_${DateTime.now().millisecondsSinceEpoch}.pkpass';
      final file = File('${tempDir.path}/$fileName');

      // Write the file
      await file.writeAsBytes(response.bodyBytes);

      return file.path;
    } catch (e) {
      debugPrint('Error downloading pass file: $e');
      rethrow;
    }
  }

  /// Open Apple Wallet with the pass (iOS only)
  Future<void> addToAppleWallet(String passUrl) async {
    try {
      if (!Platform.isIOS) {
        throw Exception('Apple Wallet is only available on iOS');
      }

      // Download the pass file
      final filePath = await downloadPassFile(passUrl);

      // The pass file can be opened using url_launcher or share functionality
      // For now, we'll use the share functionality which allows the user to add it
      debugPrint('Pass file downloaded to: $filePath');

      // Note: The actual implementation would use a native iOS method
      // or a package like url_launcher to open the .pkpass file
      // which iOS will automatically recognize and offer to add to Wallet
    } catch (e) {
      debugPrint('Error adding to Apple Wallet: $e');
      rethrow;
    }
  }

  /// Get wallet pass for a booking
  Future<WalletPass?> getPassForBooking({
    required String bookingId,
    required String passType,
  }) async {
    try {
      final response = await _supabase
          .from('wallet_passes')
          .select()
          .eq('booking_id', bookingId)
          .eq('pass_type', passType)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return WalletPass.fromSupabase(response);
    } catch (e) {
      debugPrint('Error getting wallet pass: $e');
      return null;
    }
  }

  /// Generate QR code data for verification
  String _generateQrCodeData(String bookingId) {
    // Create a unique QR code data string
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'BOTTLESUP-${bookingId.toUpperCase()}-$timestamp';
  }

  /// Check if platform supports Apple Wallet
  bool get isAppleWalletSupported => Platform.isIOS;
}
