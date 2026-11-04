import 'package:bottles_up_user/features/auth/logic/password_reset_logic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException, AuthException, AuthRetryableFetchException;

const hash = 'a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c';

void main() {
  group('the code from the email', () {
    test('keeps only the digits, so a pasted "483 920" or "483-920" works', () {
      expect(normaliseResetCode('483920'), '483920');
      expect(normaliseResetCode('483 920'), '483920');
      expect(normaliseResetCode('483-920'), '483920');
      expect(normaliseResetCode(' 4a8b3 '), '483');
      expect(normaliseResetCode(''), '');
    });

    test('is valid at exactly 6 digits', () {
      expect(validateResetCode('483920'), isNull);
      expect(validateResetCode('483 920'), isNull);
      expect(validateResetCode('48392'), 'The code has 6 digits');
      expect(validateResetCode('4839201'), 'The code has 6 digits');
    });

    test('says what to do when nothing was typed', () {
      expect(validateResetCode(''), 'Enter the 6-digit code from your email');
      expect(validateResetCode(null), 'Enter the 6-digit code from your email');
      expect(validateResetCode('   '), 'Enter the 6-digit code from your email');
    });

    test('is 6 digits long, and a new email can be asked for after a minute', () {
      expect(resetCodeLength, 6);
      expect(resetResendCooldown, const Duration(seconds: 60));
    });
  });

  group('the new password', () {
    test('needs 8 characters: 7 is refused, 8 is accepted', () {
      expect(validateNewPassword('abcdefg'), 'Use at least 8 characters');
      expect(validateNewPassword('abcdefgh'), isNull);
    });

    test('is required', () {
      expect(validateNewPassword(''), 'Password is required');
      expect(validateNewPassword(null), 'Password is required');
    });

    test('is limited to 72 bytes, counted in bytes and not characters', () {
      expect(validateNewPassword('a' * 72), isNull);
      expect(validateNewPassword('a' * 73), contains('too long'));
      expect(validateNewPassword('é' * 37), contains('too long')); // 74 bytes
      expect(validateNewPassword('é' * 36), isNull); // 72 bytes
    });

    test('the confirmation must be there and must match', () {
      expect(validateConfirmPassword('abcdefgh', 'abcdefgh'), isNull);
      expect(validateConfirmPassword('abcdefgH', 'abcdefgh'), 'Passwords do not match');
      expect(validateConfirmPassword('', 'abcdefgh'), 'Please confirm your password');
      expect(validateConfirmPassword(null, 'abcdefgh'), 'Please confirm your password');
    });
  });

  group('what a link on the app\'s own scheme means', () {
    ResetLinkAction act(String link) => resetLinkActionFor(Uri.parse(link));

    test('a link from the website\'s page carries a token to spend', () {
      final action = act('bottlesup://reset-password?token_hash=$hash&type=recovery');
      expect(action, isA<VerifyResetToken>());
      expect((action as VerifyResetToken).tokenHash, hash);
    });

    test('the token must be a recovery token', () {
      expect(act('bottlesup://reset-password?token_hash=$hash&type=signup'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password?token_hash=$hash'), isA<ResetLinkUnusable>());
    });

    test('a token that is not the shape of one of ours is never used', () {
      expect(act('bottlesup://reset-password?token_hash=short&type=recovery'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password?token_hash=${Uri.encodeQueryComponent('a b c d e f g h')}&type=recovery'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password?token_hash=${'a' * 300}&type=recovery'), isA<ResetLinkUnusable>());
    });

    test('a link Supabase\'s own template built brings its session, in the fragment', () {
      expect(act('bottlesup://reset-password#access_token=abc.def.ghi&refresh_token=xyz&type=recovery'), isA<UseOpenedSession>());
    });

    test('a session of another type is not a reset', () {
      expect(act('bottlesup://reset-password#access_token=abc&type=signup'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password#access_token=abc'), isA<ResetLinkUnusable>());
    });

    test('a link Supabase refused is unusable, wherever the error is written', () {
      expect(act('bottlesup://reset-password#error=access_denied&error_code=otp_expired&error_description=Email+link+is+invalid'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password?error=access_denied'), isA<ResetLinkUnusable>());
      expect(act('bottlesup://reset-password?error_code=otp_expired'), isA<ResetLinkUnusable>());
    });

    test('an error wins over a token in the same link', () {
      expect(act('bottlesup://reset-password?token_hash=$hash&type=recovery&error=access_denied'), isA<ResetLinkUnusable>());
    });

    test('a reset link with nothing in it is unusable, not ignored: the person is waiting for something to happen', () {
      expect(act('bottlesup://reset-password'), isA<ResetLinkUnusable>());
    });

    test('anything that is not a reset link is left alone', () {
      expect(act('bottlesup://auth-callback'), isA<NotAResetLink>());
      expect(act('bottlesup://payment?x=1'), isA<NotAResetLink>());
      expect(act('https://www.bottlesupapp.com/reset-password?token_hash=$hash&type=recovery'), isA<NotAResetLink>());
      expect(act('otherapp://reset-password?token_hash=$hash&type=recovery'), isA<NotAResetLink>());
    });

    test('a fragment that is not a query string does not crash it', () {
      expect(act('bottlesup://reset-password#%zz'), isA<ResetLinkUnusable>());
    });
  });

  group('logging a link', () {
    test('hides every secret in it', () {
      expect(redactLink('bottlesup://reset-password?token_hash=$hash&type=recovery'), 'bottlesup://reset-password?token_hash=...&type=recovery');
      expect(redactLink('bottlesup://reset-password#access_token=abc.def&refresh_token=xyz&type=recovery'), 'bottlesup://reset-password#access_token=...&refresh_token=...&type=recovery');
      expect(redactLink('bottlesup://x?code=123456&state=ok'), 'bottlesup://x?code=...&state=ok');
    });

    test('leaves a link with no secret as it was', () {
      expect(redactLink('bottlesup://auth-callback'), 'bottlesup://auth-callback');
      expect(redactLink('bottlesup://reset-password?app=user'), 'bottlesup://reset-password?app=user');
    });

    test('does not mistake a longer name for a secret one', () {
      expect(redactLink('bottlesup://x?mytoken=1&tokens=2'), 'bottlesup://x?mytoken=1&tokens=2');
    });
  });

  group('what went wrong, in words', () {
    PasswordResetException of(Object e, {bool duringCode = false}) => resetExceptionFor(e, duringCode: duringCode);

    test('every problem has a sentence', () {
      for (final problem in ResetProblem.values) {
        expect(resetProblemMessage(problem), isNotEmpty);
      }
    });

    test('losing the connection is a connection problem, never "expired"', () {
      expect(of(AuthRetryableFetchException(message: 'x')).problem, ResetProblem.network);
      expect(of(Exception('SocketException: Failed host lookup')).problem, ResetProblem.network);
    });

    test('a wrong or expired code, while checking one', () {
      expect(of(AuthApiException('Token has expired or is invalid', statusCode: '403', code: 'otp_expired'), duringCode: true).problem, ResetProblem.codeWrong);
      expect(of(const AuthException('bad', statusCode: '400'), duringCode: true).problem, ResetProblem.codeWrong);
      expect(of(const AuthException('bad', statusCode: '422'), duringCode: true).problem, ResetProblem.codeWrong);
    });

    test('an expired reset, when not checking a code, is an expired link', () {
      expect(of(AuthApiException('gone', statusCode: '401', code: 'session_expired')).problem, ResetProblem.linkExpired);
      expect(of(AuthApiException('gone', statusCode: '403', code: 'otp_expired')).problem, ResetProblem.linkExpired);
      expect(of(AuthApiException('gone', code: 'session_not_found')).problem, ResetProblem.linkExpired);
    });

    test('the same password and a weak password', () {
      expect(of(AuthApiException('same', statusCode: '422', code: 'same_password')).problem, ResetProblem.sameAsOld);
      expect(of(AuthApiException('weak', statusCode: '422', code: 'weak_password')).problem, ResetProblem.tooWeak);
    });

    test('asking for emails too often', () {
      expect(of(AuthApiException('slow down', statusCode: '429', code: 'over_email_send_rate_limit')).problem, ResetProblem.tooManyRequests);
      expect(of(const AuthException('slow down', statusCode: '429')).problem, ResetProblem.tooManyRequests);
    });

    test('anything else is "something went wrong", and a 400 outside a code check is not "wrong code"', () {
      expect(of(Exception('boom')).problem, ResetProblem.other);
      expect(of(const AuthException('bad', statusCode: '400')).problem, ResetProblem.other);
    });

    test('an exception of ours passes through untouched', () {
      const original = PasswordResetException(ResetProblem.tooWeak, 'x');
      expect(identical(of(original), original), isTrue);
    });

    test('the message is what toString says, so old catch blocks still show it', () {
      expect(of(AuthApiException('x', statusCode: '422', code: 'same_password')).toString(), resetProblemMessage(ResetProblem.sameAsOld));
    });
  });
}
