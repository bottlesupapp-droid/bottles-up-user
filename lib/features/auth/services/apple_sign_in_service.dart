import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'social_sign_in_support.dart';

class AppleSignInService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Apple sign-in exists on Apple's phones and computers only. Read from Flutter's platform so a test can change it.
  static bool get isAvailable => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

  /// Sign in with Apple and authenticate with Supabase
  static Future<AuthResponse> signInWithApple() async {
    try {
      if (!isAvailable) throw 'Apple Sign In is only available on iOS and macOS';

      // Apple gets the hash of this value and puts it in the token; Supabase gets the plain value and checks it.
      final rawNonce = newNonce();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: sha256Hex(rawNonce),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException('Apple Sign-In timed out. Please try again.', const Duration(seconds: 60)),
      );

      final token = credential.identityToken;
      if (token == null) throw 'Failed to get Apple ID token';

      final AuthResponse response = await _supabase.auth
          .signInWithIdToken(provider: OAuthProvider.apple, idToken: token, nonce: rawNonce)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Authentication with server timed out. Please try again.', const Duration(seconds: 30)),
          );

      final user = response.user;
      if (user != null) {
        final name = appleFullName(credential.givenName, credential.familyName);
        await _rememberName(user, name);
        await _createProfileIfNeeded(user, name: name, email: credential.email);
      }
      return response;
    } on TimeoutException catch (e) {
      debugPrint('Apple sign-in timeout: ${e.message}');
      throw 'Apple Sign-In timed out. Please check your internet connection and try again.';
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple authorization exception: ${e.code} - ${e.message}');
      if (e.code == AuthorizationErrorCode.canceled) {
        throw 'Apple Sign In was cancelled';
      } else if (e.code == AuthorizationErrorCode.failed) {
        throw 'Apple Sign In failed. Please try again.';
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        throw 'Apple Sign In is not configured properly. Please contact support.';
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        throw 'Invalid response from Apple. Please try again.';
      } else if (e.code == AuthorizationErrorCode.notInteractive) {
        throw 'Apple Sign In requires user interaction. Please try again.';
      } else if (e.code == AuthorizationErrorCode.unknown) {
        throw 'Unknown Apple Sign In error. Please try again.';
      }
      throw 'Apple Sign In error: ${e.message}';
    } on AuthException catch (e) {
      debugPrint('Apple sign-in, Supabase auth exception: ${e.message}');
      if (e.message.contains('timeout') || e.message.contains('network')) {
        throw 'Network error during authentication. Please check your internet connection and try again.';
      } else if (e.message.contains('invalid') || e.message.contains('token')) {
        throw 'Invalid Apple credentials. Please try signing in again.';
      }
      throw 'Authentication error: ${e.message}';
    } catch (e) {
      debugPrint('Unexpected error during Apple sign-in: $e');
      final errorString = e.toString().toLowerCase();
      if (isSignInCancelled(e)) {
        throw 'Apple Sign In was cancelled';
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        throw 'Network error. Please check your internet connection and try again.';
      } else if (errorString.contains('timeout')) {
        throw 'Apple Sign-In timed out. Please try again.';
      } else if (errorString.contains('configuration') || errorString.contains('setup')) {
        throw 'Apple Sign In configuration error. Please contact support.';
      }
      throw 'Failed to sign in with Apple: $e';
    }
  }

  /// Apple sends the name only the first time, so keep it on the sign-in at once; a failure here must not undo the sign-in.
  static Future<void> _rememberName(User user, String? name) async {
    if (name == null) return;
    final meta = user.userMetadata;
    if ((meta?['full_name'] ?? meta?['name']) != null) return;
    try {
      await _supabase.auth.updateUser(UserAttributes(data: {'full_name': name, 'name': name}));
    } catch (e) {
      debugPrint('Could not keep the name Apple gave: $e');
    }
  }

  /// Create the `profiles` row if there is none, as the Google sign-in and the e-mail sign-up do. The column for the e-mail cannot be empty, so without one nothing is written.
  static Future<void> _createProfileIfNeeded(User user, {String? name, String? email}) async {
    try {
      final existing = await _supabase.from('profiles').select('id').eq('id', user.id).maybeSingle();
      if (existing != null) return;
      final address = user.email ?? email;
      if (address == null || address.isEmpty) return;
      await _supabase.from('profiles').insert({
        'id': user.id,
        'name': profileNameFor(fullName: name, name: user.userMetadata?['full_name'] as String?, email: address),
        'email': address,
        'phone_number': user.phone,
        'age': null, // Will be filled later by the person if needed
      });
    } catch (e) {
      // The sign-in itself worked; do not break it over the profile row.
      debugPrint('Could not create the profile row for an Apple sign-in: $e');
    }
  }

  /// Check if Apple Sign In is configured properly
  static Future<bool> isConfigured() async {
    if (!isAvailable) return false;
    try {
      return await SignInWithApple.isAvailable().timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Apple sign-in configuration check failed: $e');
      return false;
    }
  }
}
