import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    // iOS Client ID from Google Cloud Console
    clientId: '386838494006-tqo6ags4qbr2onoertn9e716jvv4rdnk.apps.googleusercontent.com',
    // Web Client ID for server authentication
    serverClientId: '386838494006-j472kn5eh58552cln304f0b9l4daf7gh.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with Google and authenticate with Supabase
  static Future<AuthResponse> signInWithGoogle() async {
    try {
      debugPrint('🔵 Starting Google Sign-In flow...');
      debugPrint('🔵 Client ID: ${_googleSignIn.clientId}');
      debugPrint('🔵 Server Client ID: ${_googleSignIn.serverClientId}');
      debugPrint('🔵 Scopes: ${_googleSignIn.scopes}');

      // Check if already signed in and sign out first to ensure clean state
      if (_googleSignIn.currentUser != null) {
        debugPrint('🔵 Already signed in, signing out first...');
        await _googleSignIn.signOut();
      }

      // Trigger the Google Sign-In flow
      debugPrint('🔵 Triggering Google Sign-In UI...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          debugPrint('🔴 Google Sign-In timeout');
          throw 'Google sign-in timed out. Please try again.';
        },
      );

      if (googleUser == null) {
        debugPrint('🟡 Google sign-in was cancelled by user');
        throw 'Google sign-in was cancelled';
      }

      debugPrint('🔵 Google user signed in: ${googleUser.email}');

      // Get the Google ID token
      debugPrint('🔵 Getting authentication tokens...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      debugPrint('🔵 ID Token: ${googleAuth.idToken != null ? "✓" : "✗"}');
      debugPrint('🔵 Access Token: ${googleAuth.accessToken != null ? "✓" : "✗"}');

      if (googleAuth.idToken == null) {
        debugPrint('🔴 Failed to get Google ID token');
        throw 'Failed to get Google ID token. Please try again.';
      }

      // IMPORTANT: Use nonce for better security and compatibility
      debugPrint('🔵 Authenticating with Supabase...');

      try {
        // Try with nonce first (more secure)
        debugPrint('🔵 Calling signInWithIdToken...');
        debugPrint('🔵 Provider: google');
        debugPrint('🔵 Has idToken: ${googleAuth.idToken != null}');
        debugPrint('🔵 Has accessToken: ${googleAuth.accessToken != null}');

        final AuthResponse response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
          nonce: null, // Let Supabase handle nonce
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            debugPrint('🔴 Supabase authentication timeout');
            throw 'Authentication timeout. Please check your internet connection.';
          },
        );

        debugPrint('🔵 Supabase response received');

        if (response.user == null) {
          debugPrint('🔴 Supabase returned null user');
          throw 'Failed to authenticate with server. Please try again.';
        }

        debugPrint('🟢 Successfully authenticated: ${response.user!.email}');

        // Check if this is a new user and create profile if needed
        debugPrint('🔵 Checking/creating user profile...');
        await _createProfileIfNeeded(response.user!);

        debugPrint('🟢 Google Sign-In completed successfully!');
        return response;
      } on AuthException catch (authError) {
        debugPrint('🔴 Supabase Auth Exception: ${authError.message}');
        debugPrint('🔴 Status Code: ${authError.statusCode}');

        // If PKCE error, suggest configuration change
        if (authError.message.contains('pkce') ||
            authError.message.contains('code_challenge') ||
            authError.message.contains('oauth_token')) {
          debugPrint('🔴 PKCE flow issue detected');
          throw 'Authentication configuration error. Please check Supabase settings or contact support.';
        }

        throw 'Supabase authentication failed: ${authError.message}';
      }
    } on PlatformException catch (e) {
      debugPrint('🔴 Platform Exception: ${e.code} - ${e.message}');

      // Handle specific platform errors
      if (e.code == 'sign_in_canceled') {
        throw 'Google sign-in was cancelled';
      } else if (e.code == 'network_error') {
        throw 'Network error. Please check your internet connection.';
      } else if (e.code == 'sign_in_failed') {
        // More detailed error for sign_in_failed
        final message = e.message ?? '';
        if (message.contains('oauth_token')) {
          debugPrint('🔴 OAuth token exchange failed');
          throw 'OAuth authentication failed. This may be a configuration issue. Please contact support.';
        }
        throw 'Google sign-in failed. Please try again.';
      }
      throw 'Google sign-in error: ${e.message ?? e.code}';
    } on TimeoutException catch (e) {
      debugPrint('🔴 Timeout Exception: $e');
      throw 'Sign-in timed out. Please try again.';
    } on AuthException catch (e) {
      debugPrint('🔴 Auth Exception: ${e.message}');
      throw 'Authentication error: ${e.message}';
    } catch (e, stackTrace) {
      debugPrint('🔴 Unexpected error during Google Sign-In: $e');
      debugPrint('Stack trace: $stackTrace');

      // Handle specific error messages
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancelled')) {
        throw 'Google sign-in was cancelled';
      } else if (errorString.contains('network')) {
        throw 'Network error. Please check your internet connection.';
      } else if (errorString.contains('timeout')) {
        throw 'Sign-in timed out. Please try again.';
      } else if (errorString.contains('oauth') || errorString.contains('token')) {
        throw 'OAuth token error. Please try again or contact support if the issue persists.';
      }

      throw 'Failed to sign in with Google: ${e.toString()}';
    }
  }

  /// Create user profile if it doesn't exist
  static Future<void> _createProfileIfNeeded(User user) async {
    try {
      // Check if profile already exists
      final existingProfile = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      // If profile doesn't exist, create one
      if (existingProfile == null) {
        await _supabase.from('profiles').insert({
          'id': user.id,
          'name': user.userMetadata?['full_name'] ?? 
                  user.userMetadata?['name'] ?? 
                  user.email?.split('@')[0] ?? 
                  'User',
          'email': user.email!,
          'phone_number': user.phone,
          'age': null, // Will be filled later by user if needed
        });
      }
    } catch (e) {
      // Log error but don't throw - we don't want to break the sign-in flow
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
    }
  }

  /// Check if user is currently signed in with Google
  static bool get isSignedIn => _googleSignIn.currentUser != null;

  /// Get current Google user
  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
} 