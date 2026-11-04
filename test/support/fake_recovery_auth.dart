import 'dart:async';

import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';

/// A scripted stand-in for Supabase's side of "forgot password". It records what it was asked, in order, and fails when told to.
class FakeRecoveryAuth implements RecoveryAuth {
  FakeRecoveryAuth({this.session = false});

  final List<String> calls = [];

  /// Is there a reset session right now? Verifying a code or a token opens one; signing out closes it.
  bool session;
  Object? sendError;
  Object? codeError;
  Object? tokenError;
  Object? setPasswordError;
  Object? signOutError;

  /// When set, signing out closes the session at once but does not return until this completes: the moment between "signed out" and "moved on".
  Completer<void>? signOutGate;

  @override
  Future<void> sendResetEmail(String email) async {
    calls.add('send:$email');
    if (sendError != null) throw sendError!;
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    calls.add('code:$email:$code');
    if (codeError != null) throw codeError!;
    session = true;
  }

  @override
  Future<void> verifyTokenHash(String tokenHash) async {
    calls.add('token:$tokenHash');
    if (tokenError != null) throw tokenError!;
    session = true;
  }

  @override
  bool get hasSession => session;

  @override
  Future<void> setPassword(String password) async {
    calls.add('set:$password');
    if (setPasswordError != null) throw setPasswordError!;
  }

  @override
  Future<void> signOutHere() async {
    calls.add('signOut');
    if (signOutError != null) throw signOutError!;
    session = false;
    await signOutGate?.future;
  }
}
