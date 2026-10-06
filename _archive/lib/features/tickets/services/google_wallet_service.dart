import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleWalletService {
  static final GoogleWalletService _instance = GoogleWalletService._internal();
  factory GoogleWalletService() => _instance;
  GoogleWalletService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Generate Google Wallet pass
  Future<String> generateWalletPass({
    required String ticketId,
    required String eventName,
    required String venueName,
    required DateTime eventDate,
    required String ticketType,
    required String qrCodeData,
    String? seatNumber,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create pass object
      final passObject = {
        'id': 'bottlesup_ticket_$ticketId',
        'classId': 'bottlesup_event_pass',
        'state': 'ACTIVE',
        'heroImage': {
          'sourceUri': {
            'uri': 'https://bottlesup.app/images/event-hero.jpg',
          },
          'contentDescription': {
            'defaultValue': {
              'language': 'en-US',
              'value': 'Event Hero Image',
            },
          },
        },
        'textModulesData': [
          {
            'id': 'event_name',
            'header': 'Event',
            'body': eventName,
          },
          {
            'id': 'venue',
            'header': 'Venue',
            'body': venueName,
          },
          {
            'id': 'ticket_type',
            'header': 'Ticket Type',
            'body': ticketType,
          },
          if (seatNumber != null)
            {
              'id': 'seat',
              'header': 'Seat',
              'body': seatNumber,
            },
        ],
        'barcode': {
          'type': 'QR_CODE',
          'value': qrCodeData,
          'alternateText': ticketId,
        },
        'validTimeInterval': {
          'start': {
            'date': eventDate.subtract(const Duration(hours: 24)).toIso8601String(),
          },
          'end': {
            'date': eventDate.add(const Duration(hours: 6)).toIso8601String(),
          },
        },
      };

      // Call backend to generate signed JWT
      final response = await _supabase.rpc('generate_google_wallet_pass', params: {
        'ticket_id': ticketId,
        'pass_object': jsonEncode(passObject),
      });

      final jwt = response as String;

      // Return Google Wallet save URL
      return 'https://pay.google.com/gp/v/save/$jwt';
    } catch (e) {
      throw Exception('Failed to generate Google Wallet pass: $e');
    }
  }

  // Add ticket to Google Wallet
  Future<void> addToGoogleWallet({
    required String ticketId,
    required String eventName,
    required String venueName,
    required DateTime eventDate,
    required String ticketType,
    required String qrCodeData,
    String? seatNumber,
  }) async {
    try {
      final walletUrl = await generateWalletPass(
        ticketId: ticketId,
        eventName: eventName,
        venueName: venueName,
        eventDate: eventDate,
        ticketType: ticketType,
        qrCodeData: qrCodeData,
        seatNumber: seatNumber,
      );

      // Log wallet addition
      await _supabase.from('wallet_passes').insert({
        'ticket_id': ticketId,
        'wallet_type': 'google',
        'pass_url': walletUrl,
        'status': 'active',
      });
    } catch (e) {
      throw Exception('Failed to add to Google Wallet: $e');
    }
  }

  // Check if ticket is in Google Wallet
  Future<bool> isTicketInWallet(String ticketId) async {
    try {
      final response = await _supabase
          .from('wallet_passes')
          .select()
          .eq('ticket_id', ticketId)
          .eq('wallet_type', 'google')
          .eq('status', 'active')
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Remove ticket from Google Wallet
  Future<void> removeFromWallet(String ticketId) async {
    try {
      await _supabase
          .from('wallet_passes')
          .update({'status': 'inactive'})
          .eq('ticket_id', ticketId)
          .eq('wallet_type', 'google');
    } catch (e) {
      throw Exception('Failed to remove from Google Wallet: $e');
    }
  }

  // Update pass (e.g., when event details change)
  Future<void> updateWalletPass({
    required String ticketId,
    String? eventName,
    String? venueName,
    DateTime? eventDate,
  }) async {
    try {
      // Call backend to update pass
      await _supabase.rpc('update_google_wallet_pass', params: {
        'ticket_id': ticketId,
        'event_name': eventName,
        'venue_name': venueName,
        'event_date': eventDate?.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update Google Wallet pass: $e');
    }
  }
}
