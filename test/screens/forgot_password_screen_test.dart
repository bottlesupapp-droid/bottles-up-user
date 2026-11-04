import 'package:bottles_up_user/features/auth/models/auth_state.dart';
import 'package:bottles_up_user/features/auth/providers/auth_provider.dart';
import 'package:bottles_up_user/features/auth/screens/forgot_password_screen.dart';
import 'package:bottles_up_user/features/auth/services/password_reset_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_recovery_auth.dart';
import '../support/pump_reset_flow.dart';

/// The real notifier starts listening to Supabase when it is made, so a test hands the screen this one: it only knows how to ask for the email.
class _FakeAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _FakeAuthNotifier(this.requested) : super(const AuthState.initial());
  final List<String> requested;

  @override
  Future<void> resetPassword(String email) async {
    state = const AuthState.loading();
    requested.add(email);
    state = const AuthState.unauthenticated();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late List<String> requested;

  setUp(() => requested = []);

  Future<void> open(WidgetTester tester, {bool linkExpired = false}) => pumpResetScreen(
        tester,
        ForgotPasswordScreen(linkExpired: linkExpired),
        service: PasswordResetService(auth: FakeRecoveryAuth()),
        overrides: [authStateProvider.overrideWith((ref) => _FakeAuthNotifier(requested))],
      );

  Future<void> sendFor(WidgetTester tester, String email) async {
    await tester.enterText(find.byType(TextFormField), email);
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('asks for the email, and says nothing about an expired link', (tester) async {
    await open(tester);
    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(find.byKey(const Key('forgot-link-expired')), findsNothing);
  });

  testWidgets('coming from a dead link, it says so before asking for the email again', (tester) async {
    await open(tester, linkExpired: true);
    expect(find.byKey(const Key('forgot-link-expired')), findsOneWidget);
    expect(find.textContaining('expired or was already used'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });

  testWidgets('an address without an @ is refused and nothing is requested', (tester) async {
    await open(tester);
    await sendFor(tester, 'not-an-email');
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(requested, isEmpty);
  });

  testWidgets('after the email is sent it names the address and offers the 6-digit code', (tester) async {
    await open(tester);
    await sendFor(tester, 'sam@example.com');
    expect(requested, ['sam@example.com']);
    expect(find.byKey(const Key('forgot-sent-title')), findsOneWidget);
    expect(find.text('sam@example.com'), findsOneWidget);
    expect(find.byKey(const Key('forgot-enter-code')), findsOneWidget);
    expect(find.textContaining('use its 6-digit code'), findsOneWidget);
  });

  testWidgets('the code button opens the code page, carrying the address', (tester) async {
    await open(tester);
    await sendFor(tester, 'sam+test@example.com');
    await tester.ensureVisible(find.byKey(const Key('forgot-enter-code')));
    await tester.tap(find.byKey(const Key('forgot-enter-code')));
    await tester.pumpAndSettle();
    expect(find.text('CODE PAGE sam+test@example.com'), findsOneWidget);
  });

  testWidgets('the expired banner is not shown once the new email has been sent', (tester) async {
    await open(tester, linkExpired: true);
    await sendFor(tester, 'sam@example.com');
    expect(find.byKey(const Key('forgot-link-expired')), findsNothing);
  });
}

