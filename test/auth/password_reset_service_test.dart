import 'package:bottles_up_user/features/auth/logic/password_reset_logic.dart';
import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException, AuthRetryableFetchException;

import '../support/fake_recovery_auth.dart';

void main() {
  late FakeRecoveryAuth auth;
  late PasswordResetService service;

  setUp(() {
    auth = FakeRecoveryAuth();
    service = PasswordResetService(auth: auth);
  });

  Future<PasswordResetException> failure(Future<void> Function() run) async {
    try {
      await run();
    } on PasswordResetException catch (e) {
      return e;
    }
    fail('expected a PasswordResetException');
  }

  group('asking for the email', () {
    test('trims the address', () async {
      await service.sendEmail('  sam@example.com ');
      expect(auth.calls, ['send:sam@example.com']);
    });

    test('a refusal becomes a sentence, and a rate limit says to wait', () async {
      auth.sendError = AuthApiException('slow', statusCode: '429', code: 'over_email_send_rate_limit');
      expect((await failure(() => service.sendEmail('sam@example.com'))).problem, ResetProblem.tooManyRequests);
    });

    test('no connection is a connection problem', () async {
      auth.sendError = AuthRetryableFetchException(message: 'offline');
      expect((await failure(() => service.sendEmail('sam@example.com'))).problem, ResetProblem.network);
    });
  });

  group('checking the code', () {
    test('sends the digits only and the trimmed address, and opens a session', () async {
      await service.verifyCode(email: ' sam@example.com ', code: '483 920');
      expect(auth.calls, ['code:sam@example.com:483920']);
      expect(service.hasRecoverySession, isTrue);
    });

    test('a wrong or expired code says so and opens nothing', () async {
      auth.codeError = AuthApiException('Token has expired or is invalid', statusCode: '403', code: 'otp_expired');
      final e = await failure(() => service.verifyCode(email: 'sam@example.com', code: '000000'));
      expect(e.problem, ResetProblem.codeWrong);
      expect(service.hasRecoverySession, isFalse);
    });

    test('a dropped connection is not called a wrong code', () async {
      auth.codeError = AuthRetryableFetchException(message: 'offline');
      expect((await failure(() => service.verifyCode(email: 'sam@example.com', code: '483920'))).problem, ResetProblem.network);
    });
  });

  group('a link that reached the app', () {
    test('spends the token and opens a session', () async {
      await service.verifyLink('abc12345');
      expect(auth.calls, ['token:abc12345']);
      expect(service.hasRecoverySession, isTrue);
    });

    test('a token that was used is an expired link', () async {
      auth.tokenError = AuthApiException('used', statusCode: '403', code: 'otp_expired');
      expect((await failure(() => service.verifyLink('abc12345'))).problem, ResetProblem.codeWrong);
    });
  });

  group('the new password', () {
    test('needs a reset session, and without one asks nothing of the server', () async {
      final e = await failure(() => service.updatePassword('new-password-1'));
      expect(e.problem, ResetProblem.linkExpired);
      expect(auth.calls, isEmpty);
    });

    test('is set on the session the code opened', () async {
      await service.verifyCode(email: 'sam@example.com', code: '483920');
      await service.updatePassword('new-password-1');
      expect(auth.calls.last, 'set:new-password-1');
    });

    test('the same password, and a weak one, are told apart', () async {
      auth.session = true;
      auth.setPasswordError = AuthApiException('same', statusCode: '422', code: 'same_password');
      expect((await failure(() => service.updatePassword('old-password'))).problem, ResetProblem.sameAsOld);
      auth.setPasswordError = AuthApiException('weak', statusCode: '422', code: 'weak_password');
      expect((await failure(() => service.updatePassword('password'))).problem, ResetProblem.tooWeak);
    });

    test('a refused password leaves the session, so the person can try another', () async {
      auth.session = true;
      auth.setPasswordError = AuthApiException('weak', statusCode: '422', code: 'weak_password');
      await failure(() => service.updatePassword('password'));
      expect(service.hasRecoverySession, isTrue);
      expect(auth.calls, isNot(contains('signOut')));
    });
  });

  group('finishing', () {
    test('signs out on this phone only, once', () async {
      auth.session = true;
      await service.finish();
      expect(auth.calls, ['signOut']);
      expect(service.hasRecoverySession, isFalse);
    });

    test('never throws, even when signing out fails', () async {
      auth.signOutError = Exception('storage unavailable');
      await service.finish();
      expect(auth.calls, ['signOut']);
    });
  });
}
