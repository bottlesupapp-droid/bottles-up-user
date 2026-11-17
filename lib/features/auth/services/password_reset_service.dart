import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../site/site_config.dart';
import '../logic/password_reset_logic.dart';

/// What the reset flow needs from Supabase, so the flow can be tested without a server.
abstract class RecoveryAuth {
  Future<void> sendResetEmail(String email);
  Future<void> verifyCode({required String email, required String code});
  Future<void> verifyTokenHash(String tokenHash);
  bool get hasSession;
  Future<void> setPassword(String password);

  /// Ends the session on this phone only; other devices stay signed in.
  Future<void> signOutHere();
}

class SupabaseRecoveryAuth implements RecoveryAuth {
  // Read on use, not on construction: nothing here may touch Supabase before the app has started it.
  GoTrueClient get _auth => Supabase.instance.client.auth;

  @override
  Future<void> sendResetEmail(String email) => _auth.resetPasswordForEmail(email, redirectTo: passwordResetRedirect);

  @override
  Future<void> verifyCode({required String email, required String code}) => _auth.verifyOTP(email: email, token: code, type: OtpType.recovery);

  @override
  Future<void> verifyTokenHash(String tokenHash) => _auth.verifyOTP(tokenHash: tokenHash, type: OtpType.recovery);

  @override
  bool get hasSession => _auth.currentSession != null;

  @override
  Future<void> setPassword(String password) => _auth.updateUser(UserAttributes(password: password));

  @override
  Future<void> signOutHere() => _auth.signOut(scope: SignOutScope.local);
}

/// Forgot password, from the e-mail to the new password. Every failure is a [PasswordResetException] holding a sentence for the person.
class PasswordResetService {
  PasswordResetService({RecoveryAuth? auth}) : _auth = auth ?? SupabaseRecoveryAuth();

  final RecoveryAuth _auth;

  Future<void> sendEmail(String email) async {
    try {
      await _auth.sendResetEmail(email.trim());
    } catch (e) {
      throw resetExceptionFor(e);
    }
  }

  /// Checks the 6-digit code from the e-mail. On success there is a reset session, and the only thing it is good for is [updatePassword].
  Future<void> verifyCode({required String email, required String code}) async {
    try {
      await _auth.verifyCode(email: email.trim(), code: normaliseResetCode(code));
    } catch (e) {
      throw resetExceptionFor(e, duringCode: true);
    }
  }

  /// Spends the one-time token from a link that reached the app.
  Future<void> verifyLink(String tokenHash) async {
    try {
      await _auth.verifyTokenHash(tokenHash);
    } catch (e) {
      throw resetExceptionFor(e, duringCode: true);
    }
  }

  bool get hasRecoverySession => _auth.hasSession;

  Future<void> updatePassword(String newPassword) async {
    if (!_auth.hasSession) throw const PasswordResetException(ResetProblem.linkExpired, 'This reset has expired. Ask for a new link or code.');
    try {
      await _auth.setPassword(newPassword);
    } catch (e) {
      throw resetExceptionFor(e);
    }
  }

  /// The password is set: the person signs in with it, so nobody stays signed in on this phone because of the reset. Never throws.
  Future<void> finish() async {
    try {
      await _auth.signOutHere();
    } catch (_) {
      // The password is already changed; failing to clear the local session must not look like a failure.
    }
  }
}
