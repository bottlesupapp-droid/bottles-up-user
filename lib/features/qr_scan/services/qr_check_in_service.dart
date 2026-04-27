import 'package:supabase_flutter/supabase_flutter.dart';

class QRCheckInService {
  static final QRCheckInService _instance = QRCheckInService._internal();
  factory QRCheckInService() => _instance;
  QRCheckInService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Check in with QR code
  Future<Map<String, dynamic>> checkInWithQR({
    required String bookingId,
    required String qrCode,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Verify QR code and booking
      final response = await _supabase.rpc('check_in_with_qr', params: {
        'booking_id': bookingId,
        'qr_code': qrCode,
        'user_id': currentUser.id,
      });

      if (response == null || response['success'] != true) {
        throw Exception(response?['message'] ?? 'Invalid QR code');
      }

      // Update booking status
      await _supabase
          .from('club_table_bookings')
          .update({
            'status': 'checked_in',
            'checked_in_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      return {
        'venue_name': response['venue_name'],
        'table_name': response['table_name'],
        'party_size': response['party_size'],
        'booking_id': bookingId,
      };
    } catch (e) {
      throw Exception('Check-in failed: $e');
    }
  }

  // Generate QR code data for table
  String generateTableQRCode(String tableId, String venueId) {
    return 'BOTTLESUP:TABLE:$venueId:$tableId:${DateTime.now().millisecondsSinceEpoch}';
  }

  // Validate QR code format
  bool isValidQRCode(String qrCode) {
    return qrCode.startsWith('BOTTLESUP:TABLE:') && qrCode.split(':').length >= 4;
  }

  // Get check-in history
  Future<List<Map<String, dynamic>>> getCheckInHistory() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('club_table_bookings')
          .select('''
            id,
            checked_in_at,
            club_tables!inner(name, clubs!inner(name))
          ''')
          .eq('user_id', currentUser.id)
          .eq('status', 'checked_in')
          .order('checked_in_at', ascending: false)
          .limit(20);

      return (response as List).map((data) {
        return {
          'booking_id': data['id'],
          'checked_in_at': data['checked_in_at'],
          'table_name': data['club_tables']['name'],
          'venue_name': data['club_tables']['clubs']['name'],
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
