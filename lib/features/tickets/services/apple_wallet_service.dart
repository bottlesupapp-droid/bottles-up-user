import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppleWalletService {
  static final AppleWalletService _instance = AppleWalletService._internal();
  factory AppleWalletService() => _instance;
  AppleWalletService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Generate Apple Wallet pass (.pkpass)
  Future<String> generateWalletPass({
    required String ticketId,
    required String eventName,
    required String venueName,
    required DateTime eventDate,
    required String ticketType,
    required String qrCodeData,
    String? seatNumber,
    String? gateInfo,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create pass.json structure
      final passData = {
        'formatVersion': 1,
        'passTypeIdentifier': 'pass.com.bottlesup.ticket',
        'serialNumber': ticketId,
        'teamIdentifier': 'BOTTLESUP',
        'organizationName': 'BottlesUp',
        'description': 'BottlesUp Event Ticket',
        'logoText': 'BottlesUp',
        'foregroundColor': 'rgb(255, 255, 255)',
        'backgroundColor': 'rgb(255, 107, 0)',
        'labelColor': 'rgb(255, 255, 255)',
        'eventTicket': {
          'primaryFields': [
            {
              'key': 'event',
              'label': 'EVENT',
              'value': eventName,
            },
          ],
          'secondaryFields': [
            {
              'key': 'venue',
              'label': 'VENUE',
              'value': venueName,
            },
            {
              'key': 'date',
              'label': 'DATE',
              'value': _formatEventDate(eventDate),
              'dateStyle': 'PKDateStyleMedium',
              'timeStyle': 'PKDateStyleShort',
            },
          ],
          'auxiliaryFields': [
            {
              'key': 'type',
              'label': 'TYPE',
              'value': ticketType,
            },
            if (seatNumber != null)
              {
                'key': 'seat',
                'label': 'SEAT',
                'value': seatNumber,
              },
            if (gateInfo != null)
              {
                'key': 'gate',
                'label': 'GATE',
                'value': gateInfo,
              },
          ],
          'backFields': [
            {
              'key': 'ticket_id',
              'label': 'Ticket ID',
              'value': ticketId,
            },
            {
              'key': 'terms',
              'label': 'Terms & Conditions',
              'value': 'Present this pass for entry. Non-transferable. Valid ID required.',
            },
          ],
        },
        'barcode': {
          'message': qrCodeData,
          'format': 'PKBarcodeFormatQR',
          'messageEncoding': 'iso-8859-1',
          'altText': ticketId,
        },
        'barcodes': [
          {
            'message': qrCodeData,
            'format': 'PKBarcodeFormatQR',
            'messageEncoding': 'iso-8859-1',
            'altText': ticketId,
          },
        ],
        'relevantDate': eventDate.toIso8601String(),
        'expirationDate': eventDate.add(const Duration(hours: 6)).toIso8601String(),
      };

      // Call backend to generate signed .pkpass file
      final response = await _supabase.rpc('generate_apple_wallet_pass', params: {
        'ticket_id': ticketId,
        'pass_data': jsonEncode(passData),
      });

      final passUrl = response as String;

      // Return download URL for .pkpass file
      return passUrl;
    } catch (e) {
      throw Exception('Failed to generate Apple Wallet pass: $e');
    }
  }

  // Add ticket to Apple Wallet
  Future<String> addToAppleWallet({
    required String ticketId,
    required String eventName,
    required String venueName,
    required DateTime eventDate,
    required String ticketType,
    required String qrCodeData,
    String? seatNumber,
    String? gateInfo,
  }) async {
    try {
      final passUrl = await generateWalletPass(
        ticketId: ticketId,
        eventName: eventName,
        venueName: venueName,
        eventDate: eventDate,
        ticketType: ticketType,
        qrCodeData: qrCodeData,
        seatNumber: seatNumber,
        gateInfo: gateInfo,
      );

      // Log wallet addition
      await _supabase.from('wallet_passes').insert({
        'ticket_id': ticketId,
        'wallet_type': 'apple',
        'pass_url': passUrl,
        'status': 'active',
      });

      return passUrl;
    } catch (e) {
      throw Exception('Failed to add to Apple Wallet: $e');
    }
  }

  // Check if ticket is in Apple Wallet
  Future<bool> isTicketInWallet(String ticketId) async {
    try {
      final response = await _supabase
          .from('wallet_passes')
          .select()
          .eq('ticket_id', ticketId)
          .eq('wallet_type', 'apple')
          .eq('status', 'active')
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Remove ticket from Apple Wallet (mark as expired)
  Future<void> removeFromWallet(String ticketId) async {
    try {
      await _supabase
          .from('wallet_passes')
          .update({'status': 'inactive'})
          .eq('ticket_id', ticketId)
          .eq('wallet_type', 'apple');

      // Send push notification to update pass
      await _supabase.rpc('invalidate_apple_wallet_pass', params: {
        'ticket_id': ticketId,
      });
    } catch (e) {
      throw Exception('Failed to remove from Apple Wallet: $e');
    }
  }

  // Update pass (sends push notification to devices)
  Future<void> updateWalletPass({
    required String ticketId,
    String? eventName,
    String? venueName,
    DateTime? eventDate,
    String? gateInfo,
  }) async {
    try {
      // Call backend to update pass and push to devices
      await _supabase.rpc('update_apple_wallet_pass', params: {
        'ticket_id': ticketId,
        'event_name': eventName,
        'venue_name': venueName,
        'event_date': eventDate?.toIso8601String(),
        'gate_info': gateInfo,
      });
    } catch (e) {
      throw Exception('Failed to update Apple Wallet pass: $e');
    }
  }

  // Send location-based notification when near venue
  Future<void> enableLocationNotification({
    required String ticketId,
    required double latitude,
    required double longitude,
    String? message,
  }) async {
    try {
      await _supabase.rpc('set_wallet_pass_location', params: {
        'ticket_id': ticketId,
        'latitude': latitude,
        'longitude': longitude,
        'message': message ?? 'You\'re near the venue! Your ticket is ready.',
      });
    } catch (e) {
      throw Exception('Failed to enable location notification: $e');
    }
  }

  String _formatEventDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[date.month - 1];
    final day = date.day;
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $hour:$minute $period';
  }
}
