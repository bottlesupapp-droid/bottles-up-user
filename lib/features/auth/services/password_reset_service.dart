import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordResetService {
  static final PasswordResetService _instance = PasswordResetService._internal();
  factory PasswordResetService() => _instance;
  PasswordResetService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send password reset email with comprehensive error handling
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      
      // Validate email format first
      if (!_isValidEmail(email)) {
        throw 'Please enter a valid email address.';
      }

      // Check if user exists first (optional - some prefer not to reveal this)
      final userExists = await _checkIfUserExists(email);

      // TEMPORARILY DISABLED - Skip user check and let Supabase handle it
      // This is more secure as it doesn't reveal if emails exist

      // Only proceed if user exists (COMMENTED OUT FOR TESTING)
      // if (!userExists) {
      //   throw 'No account found with this email address. Please check your email or create an account.';
      // }

      // Send reset email
      await _supabase.auth.resetPasswordForEmail(email);
      
      
    } on AuthException catch (e) {
      
      switch (e.statusCode) {
        case '422':
          throw 'Invalid email format. Please check your email address.';
        case '429':
          throw 'Too many reset attempts. Please wait a few minutes before trying again.';
        case '400':
          if (e.message.contains('Email rate limit exceeded')) {
            throw 'Email rate limit exceeded. Please wait before requesting another reset.';
          } else if (e.message.contains('User not found')) {
            throw 'No account found with this email address.';
          }
          throw 'Invalid request. Please check your email address.';
        case '500':
          if (e.message.contains('Error sending recovery email')) {
            throw 'Email service is currently unavailable. This is a server configuration issue. Please try again later or contact support.';
          }
          throw 'Server error occurred. Please try again later.';
        default:
          throw 'Unable to send reset email: ${e.message}';
      }
    } on PostgrestException catch (e) {
      throw 'Database error occurred. Please try again.';
    } on String catch (e) {
      // Re-throw our own error messages without modification
      rethrow;
    } catch (e) {
      throw 'An unexpected error occurred. Please check your internet connection and try again.';
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  /// Check if user exists in the system
  Future<bool> _checkIfUserExists(String email) async {
    try {
      // Check both auth users and profiles table
      // First check profiles table
      final profileResponse = await _supabase
          .from('profiles')
          .select('email')
          .eq('email', email.toLowerCase())
          .maybeSingle();
      
      if (profileResponse != null) {
        return true;
      }
      
      // If not in profiles, we'll still try the reset to let Supabase handle it
      return false;
      
    } catch (e) {
      // Return true to proceed with reset attempt anyway (let Supabase handle it)
      return true;
    }
  }

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