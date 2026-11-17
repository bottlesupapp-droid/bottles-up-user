import 'package:bottles_up_user/features/auth/services/deep_link_handler.dart';
import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException, AuthRetryableFetchException;

import '../support/fake_recovery_auth.dart';

const hash = 'a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c';

void main() {
  late FakeRecoveryAuth auth;
  late List<String> went;

  setUp(() {
    auth = FakeRecoveryAuth();
    went = [];
    DeepLinkHandler.navigate = went.add;
    DeepLinkHandler.resetService = () => PasswordResetService(auth: auth);
    DeepLinkHandler.sessionWait = Duration.zero;
  });

  tearDown(() {
    // Put the real wiring back for any test that runs after this file.
    DeepLinkHandler.sessionWait = const Duration(milliseconds: 3000);
  });

  Future<bool> open(String link) async {
    final handled = DeepLinkHandler.handleDeepLink(link);
    await pumpEventQueue();
    return handled;
  }

  test('a link with a token spends it, then opens the new-password screen', () async {
    expect(await open('bottlesup://reset-password?token_hash=$hash&type=recovery'), isTrue);
    expect(auth.calls, ['token:$hash']);
    expect(went, ['/reset-password']);
  });

  test('a token that was already used goes to the "ask again" page, which says it expired', () async {
    auth.tokenError = AuthApiException('used', statusCode: '403', code: 'otp_expired');
    await open('bottlesup://reset-password?token_hash=$hash&type=recovery');
    expect(went, ['/forgot-password?expired=1']);
  });

  test('no connection does not claim the link expired: the same link still works', () async {
    auth.tokenError = AuthRetryableFetchException(message: 'offline');
    await open('bottlesup://reset-password?token_hash=$hash&type=recovery');
    expect(went, ['/forgot-password']);
  });

  test('a link Supabase refused goes to the "ask again" page without asking the server anything', () async {
    expect(await open('bottlesup://reset-password#error=access_denied&error_code=otp_expired'), isTrue);
    expect(went, ['/forgot-password?expired=1']);
    expect(auth.calls, isEmpty);
  });

  test('a link with nothing in it also goes there', () async {
    expect(await open('bottlesup://reset-password'), isTrue);
    expect(went, ['/forgot-password?expired=1']);
  });

  test('a link that brings its own session goes straight to the new password once the session is there', () async {
    auth.session = true;
    await open('bottlesup://reset-password#access_token=abc.def&refresh_token=xyz&type=recovery');
    expect(went, ['/reset-password']);
    expect(auth.calls, isEmpty, reason: 'the library opened the session; nothing is spent again');
  });

  test('a link that promised a session which never arrived is dead', () async {
    auth.session = false;
    await open('bottlesup://reset-password#access_token=abc.def&refresh_token=xyz&type=recovery');
    expect(went, ['/forgot-password?expired=1']);
  });

  test('a link that is not about resetting a password is not handled, and goes nowhere', () async {
    expect(await open('bottlesup://auth-callback'), isFalse);
    expect(await open('https://www.bottlesupapp.com/reset-password?token_hash=$hash&type=recovery'), isFalse);
    expect(went, isEmpty);
  });

  test('a reset link is reported as handled at once, before the token is spent', () {
    expect(DeepLinkHandler.handleDeepLink('bottlesup://reset-password?token_hash=$hash&type=recovery'), isTrue);
  });
}
