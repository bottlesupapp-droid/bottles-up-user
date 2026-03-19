import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

class AppleSignInService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if Apple Sign In is available on this platform
  static bool get isAvailable => Platform.isIOS || Platform.isMacOS;

  /// Sign in with Apple and authenticate with Supabase
  static Future<AuthResponse> signInWithApple() async {
    try {
      debugPrint('🍎 Starting Apple Sign-In flow...');
      
      // Check if Apple Sign In is available
      if (!isAvailable) {
        debugPrint('🔴 Apple Sign-In not available on this platform');
        throw 'Apple Sign In is only available on iOS and macOS';
      }

      debugPrint('🍎 Platform check passed, requesting Apple ID credential...');

      // Request Apple Sign In with timeout
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          debugPrint('🔴 Apple Sign-In credential request timeout');
          throw TimeoutException('Apple Sign-In timed out. Please try again.', const Duration(seconds: 60));
        },
      );

      debugPrint('🍎 Apple credential received');
      debugPrint('🍎 User ID: ${credential.userIdentifier}');
      debugPrint('🍎 Email: ${credential.email ?? "Not provided"}');
      debugPrint('🍎 Name: ${credential.givenName ?? ""} ${credential.familyName ?? ""}');

      // Check if we got the required tokens
      if (credential.identityToken == null) {
        debugPrint('🔴 No identity token received from Apple');
        throw 'Failed to get Apple ID token';
      }

      debugPrint('🍎 Identity token received, authenticating with Supabase...');

      // Sign in with Supabase using the Apple ID token with timeout
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
        accessToken: credential.authorizationCode,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('🔴 Supabase authentication timeout');
          throw TimeoutException('Authentication with server timed out. Please try again.', const Duration(seconds: 30));
        },
      );

      debugPrint('🟢 Supabase authentication successful');
      debugPrint('🍎 User authenticated: ${response.user?.email}');

      // Check if this is a new user and create profile if needed
      if (response.user != null) {
        debugPrint('🍎 Creating user profile if needed...');
        await _createProfileIfNeeded(response.user!, credential);
        debugPrint('🟢 Profile creation completed');
      }

      debugPrint('🟢 Apple Sign-In flow completed successfully');
      return response;
    } on TimeoutException catch (e) {
      debugPrint('🔴 Timeout Exception: ${e.message}');
      throw 'Apple Sign-In timed out. Please check your internet connection and try again.';
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('🔴 Apple Authorization Exception: ${e.code} - ${e.message}');
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
      throw 'Apple Sign In error: ${e.message ?? e.code.toString()}';
    } on AuthException catch (e) {
      debugPrint('🔴 Supabase Auth Exception: ${e.message}');
      if (e.message.contains('timeout') || e.message.contains('network')) {
        throw 'Network error during authentication. Please check your internet connection and try again.';
      } else if (e.message.contains('invalid') || e.message.contains('token')) {
        throw 'Invalid Apple credentials. Please try signing in again.';
      }
      throw 'Authentication error: ${e.message}';
    } catch (e, stackTrace) {
      debugPrint('🔴 Unexpected error during Apple Sign-In: $e');
      debugPrint('Stack trace: $stackTrace');

      // Handle specific error messages
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancelled') || errorString.contains('canceled')) {
        throw 'Apple Sign In was cancelled';
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        throw 'Network error. Please check your internet connection and try again.';
      } else if (errorString.contains('timeout')) {
        throw 'Apple Sign-In timed out. Please try again.';
      } else if (errorString.contains('configuration') || errorString.contains('setup')) {
        throw 'Apple Sign In configuration error. Please contact support.';
      }

      throw 'Failed to sign in with Apple: ${e.toString()}';
    }
  }

  /// Create user profile if it doesn't exist
  static Future<void> _createProfileIfNeeded(
    User user,
    AuthorizationCredentialAppleID credential,
  ) async {
    try {
      debugPrint('🍎 Profile creation temporarily disabled - Apple Sign-In will work without profile creation');
      debugPrint('🟢 Skipping profile creation for now');
      
      // TODO: Uncomment this section after running the profiles table migration
      /*
      debugPrint('🍎 Checking if user profile exists...');
      
      // Check if profile already exists with timeout
      final existingProfile = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              debugPrint('🔴 Profile check timeout');
              throw TimeoutException('Profile check timed out', const Duration(seconds: 15));
            },
          );

      // If profile doesn't exist, create one
      if (existingProfile == null) {
        debugPrint('🍎 Profile does not exist, creating new profile...');
        
        // Build name from Apple credential
        String name = 'User';
        if (credential.givenName != null && credential.familyName != null) {
          name = '${credential.givenName} ${credential.familyName}';
        } else if (credential.givenName != null) {
          name = credential.givenName!;
        } else if (user.userMetadata?['full_name'] != null) {
          name = user.userMetadata!['full_name'];
        } else if (user.email != null) {
          name = user.email!.split('@')[0];
        }

        debugPrint('🍎 Creating profile with name: $name');

        await _supabase.from('profiles').insert({
          'id': user.id,
          'name': name,
          'email': user.email ?? credential.email,
          'phone_number': user.phone,
          'age': null, // Will be filled later by user if needed
        }).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            debugPrint('🔴 Profile creation timeout');
            throw TimeoutException('Profile creation timed out', const Duration(seconds: 15));
          },
        );
        
        debugPrint('🟢 Profile created successfully');
      } else {
        debugPrint('🍎 Profile already exists, skipping creation');
      }
      */
    } catch (e) {
      // Log error but don't throw - we don't want to break the sign-in flow
      debugPrint('🔴 Error creating profile for Apple user: $e');
    }
  }

  /// Check if Apple Sign In is configured properly
  static Future<bool> isConfigured() async {
    if (!isAvailable) {
      debugPrint('🍎 Apple Sign-In not available on this platform');
      return false;
    }

    try {
      debugPrint('🍎 Checking Apple Sign-In configuration...');
      
      // Try to get credential state - this will fail if not configured
      await SignInWithApple.isAvailable().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('🔴 Apple Sign-In configuration check timeout');
          throw TimeoutException('Configuration check timed out', const Duration(seconds: 10));
        },
      );
      
      debugPrint('🟢 Apple Sign-In is properly configured');
      return true;
    } catch (e) {
      debugPrint('🔴 Apple Sign-In configuration check failed: $e');
      return false;
    }
  }
}
