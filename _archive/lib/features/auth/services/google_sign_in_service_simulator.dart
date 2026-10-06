import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Alternative Google Sign-In service for iOS Simulator testing
/// This uses Supabase's web-based OAuth flow which works on simulators
class GoogleSignInServiceSimulator {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with Google using web-based OAuth (works on simulator)
  static Future<bool> signInWithGoogleWeb() async {
    try {
      debugPrint('🔵 Starting web-based Google Sign-In flow...');
      debugPrint('🔵 Platform: ${Platform.operatingSystem}');
      debugPrint('🔵 Is iOS Simulator: Testing mode');

      // Use Supabase's web-based OAuth flow
      final bool result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'bottlesup://auth-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      debugPrint('🔵 OAuth flow initiated: $result');

      if (!result) {
        throw 'Failed to initiate Google sign-in';
      }

      // The actual authentication will complete when the app receives the redirect
      // The auth state listener will handle the rest
      debugPrint('🟢 Google OAuth flow started successfully');
      debugPrint('🔵 Waiting for redirect callback...');

      return true;
    } catch (e, stackTrace) {
      debugPrint('🔴 Error in web-based Google Sign-In: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Check if we're running on a simulator
  static Future<bool> isSimulator() async {
    if (!Platform.isIOS) return false;

    // On iOS simulator, the machine name is usually something like "iPhone Simulator"
    // This is a heuristic and not 100% reliable
    try {
      return kDebugMode; // For now, assume debug mode = simulator
    } catch (e) {
      return false;
    }
  }
}
