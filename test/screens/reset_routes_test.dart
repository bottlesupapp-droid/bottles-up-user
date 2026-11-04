import 'dart:io';

import 'package:bottles_up_user/features/auth/models/auth_state.dart';
import 'package:bottles_up_user/features/auth/providers/auth_provider.dart';
import 'package:bottles_up_user/features/auth/providers/password_reset_provider.dart';
import 'package:bottles_up_user/features/auth/screens/forgot_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/reset_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/verify_reset_code_screen.dart';
import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_recovery_auth.dart';

/// The real route table (without the sign-in redirect, which needs the app's session), so what the reset screens are given by the address is checked.
class _IdleAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _IdleAuthNotifier() : super(const AuthState.initial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeRecoveryAuth auth;

  setUp(() => auth = FakeRecoveryAuth());

  Future<void> openAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(initialLocation: location, routes: appRoutes);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        passwordResetServiceProvider.overrideWithValue(PasswordResetService(auth: auth)),
        authStateProvider.overrideWith((ref) => _IdleAuthNotifier()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('/verify-reset-code carries the address from the query into the screen', (tester) async {
    await openAt(tester, '/verify-reset-code?email=${Uri.encodeQueryComponent('sam+x@example.com')}');
    expect(find.byType(VerifyResetCodeScreen), findsOneWidget);
    expect(find.text('sam+x@example.com'), findsOneWidget);
  });

  testWidgets('/verify-reset-code with no address does not offer a box that cannot work', (tester) async {
    await openAt(tester, '/verify-reset-code');
    expect(find.byKey(const Key('reset-code-field')), findsNothing);
    expect(find.text('Start from Forgot password'), findsOneWidget);
  });

  testWidgets('/forgot-password?expired=1 says the link no longer works; plain /forgot-password does not', (tester) async {
    await openAt(tester, '/forgot-password?expired=1');
    expect(tester.widget<ForgotPasswordScreen>(find.byType(ForgotPasswordScreen)).linkExpired, isTrue);
    expect(find.byKey(const Key('forgot-link-expired')), findsOneWidget);

    await openAt(tester, '/forgot-password');
    expect(tester.widget<ForgotPasswordScreen>(find.byType(ForgotPasswordScreen)).linkExpired, isFalse);
    expect(find.byKey(const Key('forgot-link-expired')), findsNothing);
  });

  testWidgets('/reset-password with a reset session shows the form', (tester) async {
    auth.session = true;
    await openAt(tester, '/reset-password');
    expect(find.byType(ResetPasswordScreen), findsOneWidget);
    expect(find.byKey(const Key('reset-new-password')), findsOneWidget);
  });

  testWidgets('/reset-password without one says the reset has expired', (tester) async {
    await openAt(tester, '/reset-password');
    expect(find.text('This reset has expired'), findsOneWidget);
  });

  testWidgets('an old-style link that still carries tokens in its address opens the same screen, and nothing is read from it', (tester) async {
    auth.session = true;
    await openAt(tester, '/reset-password?access_token=abc.def&refresh_token=xyz');
    expect(find.byKey(const Key('reset-new-password')), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  test('all three reset pages are public, so a person who is not signed in can reach them', () {
    final source = File('lib/routing/app_router.dart').readAsStringSync();
    final set = RegExp(r'const _publicRoutes = \{([\s\S]*?)\};').firstMatch(source)!.group(1)!;
    final paths = RegExp(r"'([^']+)'").allMatches(set).map((m) => m.group(1)).toSet();
    expect(paths, containsAll(['/forgot-password', '/verify-reset-code', '/reset-password']));
  });
}
