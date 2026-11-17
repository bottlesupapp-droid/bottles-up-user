import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart' show AuthException, AuthRetryableFetchException;

/// The rules of "forgot password", kept free of Supabase and of widgets so each one can be tested on its own.
///
/// The reset e-mail has a button and a 6-digit code. The button goes to the website's /reset-password page, which can hand the person back to
/// this app on `bottlesup://reset-password?token_hash=...&type=recovery`; the code is typed on the "enter the code" screen.

/// How many digits the e-mailed code has (Supabase's default).
const int resetCodeLength = 6;

/// A new code can be asked for once a minute: Supabase refuses a second reset e-mail for the same person sooner than that.
const Duration resetResendCooldown = Duration(seconds: 60);

const int minPasswordLength = 8;

/// bcrypt, which Supabase hashes passwords with, reads only the first 72 bytes and refuses more.
const int maxPasswordBytes = 72;

/// Keeps only the digits: people paste "483 920" or "483-920".
String normaliseResetCode(String raw) => raw.replaceAll(RegExp(r'\D'), '');

String? validateResetCode(String? raw) {
  final code = normaliseResetCode(raw ?? '');
  if (code.isEmpty) return 'Enter the 6-digit code from your email';
  if (code.length != resetCodeLength) return 'The code has $resetCodeLength digits';
  return null;
}

String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < minPasswordLength) return 'Use at least $minPasswordLength characters';
  if (utf8.encode(value).length > maxPasswordBytes) return 'That password is too long. Use 72 characters or fewer';
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) return 'Please confirm your password';
  if (value != password) return 'Passwords do not match';
  return null;
}

// The parts of an incoming link that act like a password for a few minutes. They are shown as "..." wherever a link is logged.
const _secretParams = {'token_hash', 'access_token', 'refresh_token', 'code', 'token'};

/// [link] with every secret value replaced, safe to print. Anything that is not a link is returned as it is.
String redactLink(String link) => link.replaceAllMapped(
      RegExp('([?&#]|^)(${_secretParams.join('|')})=([^&#]*)'),
      (m) => '${m[1]}${m[2]}=...',
    );

// Supabase token hashes are hexadecimal; anything outside this shape is not one of ours and is never sent to the server.
final RegExp _tokenHash = RegExp(r'^[A-Za-z0-9_-]{8,256}$');

/// What to do with a link that came in on the app's own scheme.
sealed class ResetLinkAction {
  const ResetLinkAction();
}

/// A link with a one-time token (from the website's page): spend it for a session, then ask for the new password.
class VerifyResetToken extends ResetLinkAction {
  const VerifyResetToken(this.tokenHash);
  final String tokenHash;
}

/// A link whose session the Supabase library has already read out of the address (Supabase's own template): go straight to the new password.
class UseOpenedSession extends ResetLinkAction {
  const UseOpenedSession();
}

/// A link Supabase refused, or one with nothing usable in it: say so, and offer a new e-mail.
class ResetLinkUnusable extends ResetLinkAction {
  const ResetLinkUnusable();
}

/// A link that is not about resetting a password at all.
class NotAResetLink extends ResetLinkAction {
  const NotAResetLink();
}

ResetLinkAction resetLinkActionFor(Uri uri) {
  if (uri.scheme != 'bottlesup' || uri.host != 'reset-password') return const NotAResetLink();

  final params = <String, String>{...uri.queryParameters};
  if (uri.fragment.isNotEmpty) {
    // Parsed as a query string, so the value is decoded and a value holding "=" is kept whole.
    try {
      params.addAll(Uri.splitQueryString(uri.fragment));
    } on FormatException {
      // A fragment that is not a query string carries nothing we read.
    }
  }

  if (params.containsKey('error') || params.containsKey('error_code')) return const ResetLinkUnusable();

  final tokenHash = params['token_hash'];
  if (tokenHash != null && params['type'] == 'recovery' && _tokenHash.hasMatch(tokenHash)) return VerifyResetToken(tokenHash);

  if ((params['access_token'] ?? '').isNotEmpty && params['type'] == 'recovery') return const UseOpenedSession();

  return const ResetLinkUnusable();
}

/// What can go wrong between asking for a reset and having a new password, as far as the screens care.
enum ResetProblem { codeWrong, linkExpired, sameAsOld, tooWeak, tooManyRequests, network, other }

class PasswordResetException implements Exception {
  const PasswordResetException(this.problem, this.message);
  final ResetProblem problem;

  /// A sentence for the person.
  final String message;

  @override
  String toString() => message;
}

const Map<ResetProblem, String> _messages = {
  ResetProblem.codeWrong: 'That code is not right, or it has expired. Check it, or ask for a new one.',
  ResetProblem.linkExpired: 'This reset link has expired or was already used. Ask for a new one.',
  ResetProblem.sameAsOld: 'Your new password must be different from your old one.',
  ResetProblem.tooWeak: 'That password is too easy to guess. Try a longer one, with letters and numbers.',
  ResetProblem.tooManyRequests: 'Please wait a minute before asking for another email.',
  ResetProblem.network: 'We could not reach BottlesUp. Check your connection and try again.',
  ResetProblem.other: 'Something went wrong. Please try again.',
};

/// The sentence for [problem].
String resetProblemMessage(ResetProblem problem) => _messages[problem]!;

/// Turns what Supabase said into a [PasswordResetException]. [duringCode] says the person was checking a code or a link, where a refusal
/// means "wrong or expired" and not "something broke".
PasswordResetException resetExceptionFor(Object error, {bool duringCode = false}) {
  if (error is PasswordResetException) return error;
  ResetProblem problem = ResetProblem.other;
  if (error is AuthRetryableFetchException) {
    problem = ResetProblem.network;
  } else if (error is AuthException) {
    final code = error.code;
    final status = error.statusCode;
    if (code == 'same_password') {
      problem = ResetProblem.sameAsOld;
    } else if (code == 'weak_password') {
      problem = ResetProblem.tooWeak;
    } else if (code == 'over_email_send_rate_limit' || code == 'over_request_rate_limit' || status == '429') {
      problem = ResetProblem.tooManyRequests;
    } else if (code == 'otp_expired' || code == 'otp_disabled' || code == 'session_not_found' || code == 'session_expired' || status == '401' || status == '403') {
      problem = duringCode ? ResetProblem.codeWrong : ResetProblem.linkExpired;
    } else if (duringCode && (status == '400' || status == '422')) {
      problem = ResetProblem.codeWrong;
    }
  } else if (error.toString().contains('SocketException') || error.toString().contains('ClientException')) {
    problem = ResetProblem.network;
  }
  return PasswordResetException(problem, resetProblemMessage(problem));
}
