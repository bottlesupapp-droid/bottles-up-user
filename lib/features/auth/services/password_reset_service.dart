import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordResetService {
  static final PasswordResetService _instance = PasswordResetService._internal();
  factory PasswordResetService() => _instance;
  PasswordResetService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Update password using reset tokens
  Future<void> updatePassword({
    required String newPassword,
    String? accessToken,
    String? refreshToken,
  }) async {
    try {
      
      // Check current session - Supabase should have set it automatically from the deep link
      final session = _supabase.auth.currentSession;
      
      if (session == null) {
        throw 'Reset session expired. Please request a new password reset link.';
      }
      
      // Update the password
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
      if (response.user == null) {
        throw 'Failed to update password. Please try again.';
      }
      
      
    } on AuthException catch (e) {
      
      switch (e.statusCode) {
        case '422':
          throw 'Invalid password. Please ensure it meets the requirements.';
        case '401':
          throw 'Reset link has expired. Please request a new password reset.';
        case '400':
          throw 'Invalid request. Please try requesting a new password reset.';
        default:
          throw 'Failed to update password: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }
}