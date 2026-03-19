import 'package:supabase_flutter/supabase_flutter.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  EmailService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send RSVP pending confirmation email
  Future<void> sendRSVPPendingEmail({
    required String to,
    required String customerName,
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String venue,
    required String verificationCode,
  }) async {
    try {
      print('🚀 Attempting to send RSVP pending email to: $to');
      print('📧 Event: $eventName');
      print('🔑 Verification Code: $verificationCode');

      final response = await _supabase.functions.invoke(
        'send-email-notifications',
        body: {
          'type': 'rsvp_pending',
          'to': to,
          'customerName': customerName,
          'eventName': eventName,
          'eventDate': eventDate,
          'eventTime': eventTime,
          'venue': venue,
          'verificationCode': verificationCode,
        },
      );

      print('📡 Edge Function Response Status: ${response.status}');
      print('📡 Edge Function Response Data: ${response.data}');

      if (response.status != 200) {
        throw Exception('Failed to send email. Status: ${response.status}, Data: ${response.data}');
      }

      print('✅ RSVP pending email sent successfully to $to');
      print('📧 Message ID: ${response.data?['messageId']}');
    } catch (e) {
      print('❌ Failed to send RSVP pending email: $e');
      print('🔍 Full error details: ${e.toString()}');
      // Don't throw error to prevent blocking RSVP submission
      // Email failure shouldn't prevent successful RSVP
    }
  }

  /// Send RSVP approved confirmation email
  Future<void> sendRSVPApprovedEmail({
    required String to,
    required String customerName,
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String venue,
    required String verificationCode,
  }) async {
    try {
      print('🚀 Attempting to send RSVP approved email to: $to');
      print('📧 Event: $eventName');
      print('🔑 Verification Code: $verificationCode');

      final response = await _supabase.functions.invoke(
        'send-email-notifications',
        body: {
          'type': 'rsvp_approved',
          'to': to,
          'customerName': customerName,
          'eventName': eventName,
          'eventDate': eventDate,
          'eventTime': eventTime,
          'venue': venue,
          'verificationCode': verificationCode,
        },
      );

      print('📡 Edge Function Response Status: ${response.status}');
      print('📡 Edge Function Response Data: ${response.data}');

      if (response.status != 200) {
        throw Exception('Failed to send email. Status: ${response.status}, Data: ${response.data}');
      }

      print('✅ RSVP approved email sent successfully to $to');
      print('📧 Message ID: ${response.data?['messageId']}');
    } catch (e) {
      print('❌ Failed to send RSVP approved email: $e');
      print('🔍 Full error details: ${e.toString()}');
      // Don't throw error to prevent blocking approval process
    }
  }

  /// Send table booking confirmation email
  Future<void> sendTableBookingConfirmationEmail({
    required String to,
    required String customerName,
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String venue,
    required String confirmationCode,
    required String tableName,
    required int partySize,
    required double depositAmount,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-email-notifications',
        body: {
          'type': 'table_booking_confirmed',
          'to': to,
          'customerName': customerName,
          'eventName': eventName,
          'eventDate': eventDate,
          'eventTime': eventTime,
          'venue': venue,
          'bookingDetails': {
            'confirmationCode': confirmationCode,
            'tableName': tableName,
            'partySize': partySize,
            'depositAmount': depositAmount,
            'bottleMinimum': 1,
          }
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to send email: ${response.data}');
      }

      print('✅ Table booking confirmation email sent successfully to $to');
    } catch (e) {
      print('❌ Failed to send table booking confirmation email: $e');
      // Don't throw error to prevent blocking booking submission
    }
  }

  /// Send payment confirmation email
  Future<void> sendPaymentConfirmationEmail({
    required String to,
    required String customerName,
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String venue,
    required double amount,
    required String paymentMethod,
    String? transactionId,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-email-notifications',
        body: {
          'type': 'payment_confirmed',
          'to': to,
          'customerName': customerName,
          'eventName': eventName,
          'eventDate': eventDate,
          'eventTime': eventTime,
          'venue': venue,
          'paymentDetails': {
            'amount': amount,
            'paymentMethod': paymentMethod,
            'transactionId': transactionId,
          }
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to send email: ${response.data}');
      }

      print('✅ Payment confirmation email sent successfully to $to');
    } catch (e) {
      print('❌ Failed to send payment confirmation email: $e');
      // Don't throw error to prevent blocking payment process
    }
  }
}