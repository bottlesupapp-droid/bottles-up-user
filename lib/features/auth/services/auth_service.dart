import 'package:supabase_flutter/supabase_flutter.dart';
import 'google_sign_in_service.dart';
import 'apple_sign_in_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Get user provider (google, apple, email)
  String? get userProvider {
    final user = currentUser;
    if (user == null) return null;

    final identities = user.identities;
    if (identities != null && identities.isNotEmpty) {
      return identities.first.provider;
    }
    return 'email';
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      if (e.statusCode == '400' && e.message.contains('Invalid login credentials')) {
        throw 'Incorrect email or password. Please try again.';
      } else if (e.message.contains('Email not confirmed')) {
        throw 'Please verify your email before signing in.';
      } else if (e.message.contains('Password is too short')) {
        throw 'Password must be at least 6 characters long.';
      } else if (e.message.contains('Rate limit')) {
        throw 'Too many login attempts. Please try again later.';
      }
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw 'This email is already registered. Please sign in instead.';
      } else if (e.message.contains('Password is too short')) {
        throw 'Password must be at least 6 characters long.';
      } else if (e.message.contains('Email')) {
        throw 'Please enter a valid email address.';
      }
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Complete signup with profile data
  Future<AuthResponse> signUpWithProfile({
    required String name,
    required String email,
    required String password,
    required int age,
    required String phoneNumber,
  }) async {
    try {
      // Step 1: Create the auth user with metadata
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': 'user', // Store role in metadata
        },
      );

      // Step 2: Check if auth creation was successful
      if (response.user?.id != null) {
        try {
          // Step 3: Create the profile record using the user ID
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'name': name,
            'email': email,
            'phone_number': phoneNumber,
            'age': age,
          });
        } catch (profileError) {
          // If profile creation fails after successful auth creation
          throw 'Account created but profile setup failed. Please contact support or try logging in.';
        }
      } else {
        // Auth creation failed
        throw 'Failed to create user account.';
      }

      return response;
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw 'This email is already registered. Please sign in instead.';
      } else if (e.message.contains('Password is too short')) {
        throw 'Password must be at least 6 characters long.';
      } else if (e.message.contains('Email')) {
        throw 'Please enter a valid email address.';
      }
      throw e.message;
    } on PostgrestException catch (e) {
      // Handle profile creation errors
      if (e.message.contains('duplicate key value')) {
        throw 'Profile already exists for this user.';
      }
      throw 'Failed to create user profile. Please try again.';
    } catch (e) {
      throw 'An unexpected error occurred during signup. Please try again.';
    }
  }

  // Sign in with Google using the new GoogleSignInService
  Future<AuthResponse> signInWithGoogle() async {
    try {
      return await GoogleSignInService.signInWithGoogle();
    } catch (e) {
      final errorMsg = e.toString();

      // Check if it's a simulator issue
      if (errorMsg.contains('404') || errorMsg.contains('not found')) {
        throw '⚠️ Google Sign-In requires a real iOS device.\n\n'
            'The iOS Simulator has limitations with Google Sign-In.\n'
            'Please test on a physical iPhone or iPad.\n\n'
            'Original error: $errorMsg';
      }

      throw errorMsg;
    }
  }

  // Sign in with Apple
  Future<AuthResponse> signInWithApple() async {
    try {
      return await AppleSignInService.signInWithApple();
    } catch (e) {
      throw e.toString();
    }
  }

  // Method to handle OAuth callback and create profile if needed
  Future<void> handleOAuthCallback() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        // Check if profile already exists
        final profileExists = await _supabase
            .from('profiles')
            .select('id')
            .eq('id', user.id)
            .maybeSingle();
            
        // If profile doesn't exist, create one from OAuth data
        if (profileExists == null) {
          await _supabase.from('profiles').insert({
            'id': user.id,
            'name': user.userMetadata?['full_name'] ?? user.email?.split('@')[0] ?? 'User',
            'email': user.email!,
            'phone_number': user.phone,
            'age': null, // Will be filled later by user
          });
        }
      }
    } catch (e) {
      // Log error but don't throw - we don't want to break the sign-in flow
    }
  }

  // Reset password with custom redirect URL
  Future<void> resetPassword(String email) async {
    try {
      
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'bottlesupapp://auth-callback/reset-password',
      );
      
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in with Google
      if (GoogleSignInService.isSignedIn) {
        await GoogleSignInService.signOut();
      }

      // Sign out from Supabase
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with phone OTP
  Future<void> signInWithPhone(String phoneNumber) async {
    try {

      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );

    } on AuthException catch (e) {

      if (e.message.contains('Rate limit')) {
        throw 'Too many OTP requests. Please try again later.';
      }
      throw e.message;
    } catch (e) {
      throw 'Failed to send OTP. Please try again.';
    }
  }

  // Verify phone OTP
  Future<AuthResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {

      final response = await _supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );


      // After successful verification, check and create profile if needed
      if (response.user != null) {
        await handleOAuthCallback();
      } else {
      }

      return response;
    } on AuthException catch (e) {

      if (e.message.contains('Invalid') || e.message.contains('expired')) {
        throw 'Invalid or expired OTP. Please try again.';
      }
      throw e.message;
    } catch (e) {
      throw 'Failed to verify OTP. Please try again.';
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) {
        throw 'No user logged in';
      }

      // Delete user profile first
      await _supabase.from('profiles').delete().eq('id', userId);

      // Delete the auth user account using admin API
      // Note: This requires the user to be authenticated
      await _supabase.rpc('delete_user');

      // Sign out after deletion
      await signOut();
    } on PostgrestException catch (e) {
      throw 'Failed to delete account: ${e.message}';
    } on AuthException catch (e) {
      throw 'Failed to delete account: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred while deleting account. Please try again.';
    }
  }
} 