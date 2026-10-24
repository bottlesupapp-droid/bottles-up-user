import 'dart:async';
import 'package:bottles_up_user/features/auth/models/auth_state.dart';
import 'package:bottles_up_user/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

part 'auth_provider.g.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  StreamSubscription? _authSubscription;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    // Initialize auth state
    _initialize();
    // Listen to auth state changes (OAuth callbacks, etc.)
    _listenToAuthChanges();
  }

  Future<void> _initialize() async {
    final user = _authService.currentUser;
    if (user != null) {
      // Handle OAuth profile creation if needed
      await _authService.handleOAuthCallback();
      state = AuthState.authenticated(user);
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  void _listenToAuthChanges() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session?.user != null) {
            // Handle OAuth profile creation if needed
            _authService.handleOAuthCallback();
            state = AuthState.authenticated(session!.user);
          }
          break;
        case AuthChangeEvent.signedOut:
          state = const AuthState.unauthenticated();
          break;
        case AuthChangeEvent.tokenRefreshed:
          if (session?.user != null) {
            state = AuthState.authenticated(session!.user);
          }
          break;
        default:
          // Handle other auth events if needed
          break;
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      state = const AuthState.loading();
      
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('Failed to sign in');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      state = const AuthState.loading();
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('Failed to sign up');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const AuthState.loading();
      final response = await _authService.signInWithGoogle();
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('Failed to sign in with Google');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = const AuthState.loading();
      await _authService.signInWithApple();
      final user = _authService.currentUser;
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.error('Failed to sign in with Apple');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = const AuthState.loading();
      await _authService.resetPassword(email);
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthState.loading();
      await _authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      state = const AuthState.loading();
      await _authService.deleteAccount();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      state = const AuthState.loading();

      await _authService.signInWithPhone(phoneNumber);

      // OTP sent successfully, but user not authenticated yet
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      state = const AuthState.loading();

      final response = await _authService.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );


      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      } else {
        state = const AuthState.error('Failed to verify OTP');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Reset the auth state to unauthenticated (clears any error)
  void reset() {
    state = const AuthState.unauthenticated();
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<bool> build() async {
    // Check if user is authenticated
    final authService = ref.watch(authServiceProvider);
    return authService.isAuthenticated;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = const AsyncData(true);
      } else {
        throw 'Failed to sign in';
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required int age,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();

    try {
      print('🔐 Starting signup for: $email');
      final authService = ref.read(authServiceProvider);
      final response = await authService.signUpWithProfile(
        name: name,
        email: email,
        password: password,
        age: age,
        phoneNumber: phoneNumber,
      );

      print('🔐 Signup response received, user ID: ${response.user?.id}');

      // Check if signup was successful
      if (response.user?.id != null) {
        // Signup successful - user and profile created
        print('✅ Signup successful!');
        state = const AsyncData(true);
      } else {
        // This shouldn't happen with our new flow, but handle it just in case
        print('❌ Signup failed - no user ID');
        throw 'Signup completed but user verification failed. Please try logging in.';
      }
    } catch (error, stackTrace) {
      print('❌ Signup error: $error');
      print('Stack trace: $stackTrace');
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AsyncData(false);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signInWithGoogle();
      
      // OAuth redirect flow will handle the actual sign-in
      // The app will need to check auth state after redirect
      if (response.user != null) {
        state = const AsyncData(true);
      } else {
        throw 'Failed to sign in with Google';
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      
      // OAuth redirect flow will handle the actual sign-in
      // The app will need to check auth state after redirect
      state = const AsyncData(true);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
} 