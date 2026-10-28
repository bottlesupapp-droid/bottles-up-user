import 'package:bottles_up_user/features/auth/widgets/social_sign_in_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _show(WidgetTester tester, {bool enabled = true, VoidCallback? onGoogle, VoidCallback? onApple}) => tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: SocialSignInButtons(enabled: enabled, onGoogle: onGoogle ?? () {}, onApple: onApple ?? () {}))),
    ));

void main() {
  testWidgets('on an Android phone only Google is offered', (tester) async {
    await _show(tester);
    expect(find.byKey(const Key('social-google')), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.byKey(const Key('social-apple')), findsNothing);
  });

  testWidgets('on an iPhone Apple is offered with Google, as Apple requires', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await _show(tester);
      expect(find.byKey(const Key('social-google')), findsOneWidget);
      expect(find.byKey(const Key('social-apple')), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('each button runs its own action', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      final pressed = <String>[];
      await _show(tester, onGoogle: () => pressed.add('google'), onApple: () => pressed.add('apple'));
      await tester.tap(find.byKey(const Key('social-google')));
      expect(pressed, ['google']);
      await tester.tap(find.byKey(const Key('social-apple')));
      expect(pressed, ['google', 'apple']);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('while a sign-in is running neither button can be pressed', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      final pressed = <String>[];
      await _show(tester, enabled: false, onGoogle: () => pressed.add('google'), onApple: () => pressed.add('apple'));
      await tester.tap(find.byKey(const Key('social-google')), warnIfMissed: false);
      await tester.tap(find.byKey(const Key('social-apple')), warnIfMissed: false);
      expect(pressed, isEmpty);
      expect(tester.widget<OutlinedButton>(find.byKey(const Key('social-google'))).onPressed, isNull);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
