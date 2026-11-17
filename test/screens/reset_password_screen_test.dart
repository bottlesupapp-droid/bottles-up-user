import 'dart:async';

import 'package:bottles_up_user/features/auth/screens/reset_password_screen.dart';
import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException;

import '../support/fake_recovery_auth.dart';
import '../support/pump_reset_flow.dart';

void main() {
  late FakeRecoveryAuth auth;
  late PasswordResetService service;

  setUp(() {
    // The reset session the code or the link opened.
    auth = FakeRecoveryAuth(session: true);
    service = PasswordResetService(auth: auth);
  });

  Future<void> open(WidgetTester tester) => pumpResetScreen(tester, const ResetPasswordScreen(), service: service);

  Future<void> fill(WidgetTester tester, {String password = 'new-password-1', String? confirm}) async {
    await tester.enterText(find.byKey(const Key('reset-new-password')), password);
    await tester.enterText(find.byKey(const Key('reset-confirm-password')), confirm ?? password);
    await tester.pump();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('reset-submit')));
    await tester.tap(find.byKey(const Key('reset-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('with a reset session it shows the two password boxes', (tester) async {
    await open(tester);
    expect(find.byKey(const Key('reset-new-password')), findsOneWidget);
    expect(find.byKey(const Key('reset-confirm-password')), findsOneWidget);
    expect(find.text('This reset has expired'), findsNothing);
  });

  testWidgets('without one it says the reset has expired, instead of a form that can only fail', (tester) async {
    auth.session = false;
    await open(tester);
    expect(find.text('This reset has expired'), findsOneWidget);
    expect(find.byKey(const Key('reset-new-password')), findsNothing);
  });

  testWidgets('the expired page offers a new email, and the way back to sign-in', (tester) async {
    auth.session = false;
    await open(tester);
    await tester.tap(find.byKey(const Key('reset-expired-new')));
    await tester.pumpAndSettle();
    expect(find.textContaining('FORGOT PAGE'), findsOneWidget);
  });

  testWidgets('7 characters are refused, and nothing is sent', (tester) async {
    await open(tester);
    await fill(tester, password: 'abcdefg');
    await submit(tester);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('two different passwords are refused, and nothing is sent', (tester) async {
    await open(tester);
    await fill(tester, password: 'new-password-1', confirm: 'new-password-2');
    await submit(tester);
    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('a good password is set, the reset session is ended, and the person is sent to sign in', (tester) async {
    await open(tester);
    await fill(tester);
    await submit(tester);
    await tester.pumpAndSettle();
    expect(auth.calls, ['set:new-password-1', 'signOut']);
    expect(find.text('LOGIN PAGE'), findsOneWidget);
    expect(find.text('Password updated. Sign in with your new password.'), findsOneWidget);
  });

  testWidgets('the screen does not flash "expired" in the moment between signing out and moving on', (tester) async {
    final gate = Completer<void>();
    auth.signOutGate = gate;
    await open(tester);
    await fill(tester);
    await submit(tester);
    // The session is closed, but the sign-out has not returned yet. Anything that rebuilds the screen now (here: the window changing size)
    // must not turn it into the "expired" page.
    tester.view.physicalSize = const Size(900, 1700);
    await tester.pump();
    expect(auth.session, isFalse);
    expect(find.text('This reset has expired'), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('LOGIN PAGE'), findsOneWidget);
  });

  testWidgets('the same password as before is explained, keeps the session, and signs nobody out', (tester) async {
    auth.setPasswordError = AuthApiException('same', statusCode: '422', code: 'same_password');
    await open(tester);
    await fill(tester, password: 'old-password-1');
    await submit(tester);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Your new password must be different from your old one.'), findsOneWidget);
    expect(auth.calls, ['set:old-password-1']);
    expect(auth.session, isTrue);
    expect(find.byKey(const Key('reset-new-password')), findsOneWidget, reason: 'the form is still there to try another password');
  });

  testWidgets('a weak password is explained', (tester) async {
    auth.setPasswordError = AuthApiException('weak', statusCode: '422', code: 'weak_password');
    await open(tester);
    await fill(tester, password: 'password');
    await submit(tester);
    expect(find.textContaining('too easy to guess'), findsOneWidget);
  });

  testWidgets('each password box can be shown and hidden', (tester) async {
    await open(tester);
    bool hidden(String key) =>
        tester.widget<EditableText>(find.descendant(of: find.byKey(Key(key)), matching: find.byType(EditableText))).obscureText;
    Finder eye(String key) => find.descendant(of: find.byKey(Key(key)), matching: find.byType(IconButton));

    expect(hidden('reset-new-password'), isTrue);
    expect(hidden('reset-confirm-password'), isTrue);

    await tester.tap(eye('reset-new-password'));
    await tester.pump();
    expect(hidden('reset-new-password'), isFalse);
    expect(hidden('reset-confirm-password'), isTrue, reason: 'the other box is not affected');

    await tester.tap(eye('reset-new-password'));
    await tester.pump();
    expect(hidden('reset-new-password'), isTrue);

    await tester.tap(eye('reset-confirm-password'));
    await tester.pump();
    expect(hidden('reset-confirm-password'), isFalse);
  });
}
