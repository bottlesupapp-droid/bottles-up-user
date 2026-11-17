import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/apple_sign_in_service.dart';

/// "Continue with Google", and on an iPhone "Continue with Apple" under it. Apple requires an app that offers another company's sign-in on iPhone to offer Sign in with Apple as well, so
/// the two always appear together there; Apple's own button is used because App Review looks for it. While [enabled] is false (a sign-in is running) neither can be pressed.
class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key, required this.onGoogle, required this.onApple, this.enabled = true});

  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          key: const Key('social-google'),
          onPressed: enabled ? onGoogle : null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          icon: const Text('G', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF4285F4))),
          label: const Text('Continue with Google'),
        ),
        if (AppleSignInService.isAvailable) ...[
          const SizedBox(height: 12),
          Opacity(
            opacity: enabled ? 1 : 0.5,
            child: IgnorePointer(
              ignoring: !enabled,
              child: SignInWithAppleButton(
                key: const Key('social-apple'),
                onPressed: onApple,
                text: 'Continue with Apple',
                height: 48,
                style: SignInWithAppleButtonStyle.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
