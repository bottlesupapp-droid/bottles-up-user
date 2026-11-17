import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../logic/password_reset_logic.dart';
import '../providers/password_reset_provider.dart';

/// Step two of "forgot password" for anyone whose email button did not open the app (or who read the email on another device):
/// type the 6-digit code from the email, and the next screen is the new password.
class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  const VerifyResetCodeScreen({super.key, required this.email});

  /// The address the code was sent to, carried over from the "forgot password" screen.
  final String email;

  @override
  ConsumerState<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends ConsumerState<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  Timer? _ticker;
  // The email went out a moment ago, so the next one has to wait the full minute.
  int _secondsLeft = resetResendCooldown.inSeconds;
  bool _checking = false;
  bool _resending = false;
  String? _problem;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  // Counts the wait down once a second. Never calls setState itself, so initState can start it.
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _verify() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _checking = true;
      _problem = null;
      _notice = null;
    });
    try {
      await ref.read(passwordResetServiceProvider).verifyCode(email: widget.email, code: _codeController.text);
      if (mounted) context.go('/reset-password');
    } on PasswordResetException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _problem = null;
      _notice = null;
    });
    try {
      await ref.read(passwordResetServiceProvider).sendEmail(widget.email);
      if (mounted) {
        _codeController.clear();
        setState(() {
          _notice = 'We sent a new email. Only the newest code works.';
          _secondsLeft = resetResendCooldown.inSeconds;
        });
        _startTicker();
      }
    } on PasswordResetException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = Colors.white.withValues(alpha: 0.7);

    if (widget.email.trim().isEmpty) {
      // Reached without an address (a stale link): there is no email to check a code against.
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Start from Forgot password', style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('We need your email address to check the code.', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: muted), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('reset-code-start-over'),
                  onPressed: () => context.go('/forgot-password'),
                  child: const Text('Forgot password'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.canPop() ? context.pop() : context.go('/forgot-password'),
                  icon: const Icon(Iconsax.arrow_left),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(child: Icon(Iconsax.sms_tracking, size: 64, color: colorScheme.primary)),
              const SizedBox(height: 24),
              Text(
                'Enter the 6-digit code',
                style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('We emailed a code to', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: muted), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: TextFormField(
                  key: const Key('reset-code-field'),
                  controller: _codeController,
                  enabled: !_checking,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 -]')), LengthLimitingTextInputFormatter(resetCodeLength + 2)],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, letterSpacing: 8, fontWeight: FontWeight.w700, fontFeatures: [FontFeature.tabularFigures()]),
                  decoration: InputDecoration(
                    hintText: '••••••',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: validateResetCode,
                  onFieldSubmitted: (_) => _verify(),
                ),
              ),
              if (_problem != null) ...[
                const SizedBox(height: 12),
                Text(_problem!, key: const Key('reset-code-problem'), style: TextStyle(color: colorScheme.error), textAlign: TextAlign.center),
              ],
              if (_notice != null) ...[
                const SizedBox(height: 12),
                Text(_notice!, key: const Key('reset-code-notice'), style: TextStyle(color: Colors.green.shade300), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('reset-code-submit'),
                onPressed: _checking ? null : _verify,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _checking ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 24) : const Text('Continue'),
              ),
              const SizedBox(height: 12),
              TextButton(
                key: const Key('reset-code-resend'),
                onPressed: (_secondsLeft > 0 || _resending || _checking) ? null : _resend,
                child: Text(_secondsLeft > 0 ? 'Send a new code in ${_secondsLeft}s' : (_resending ? 'Sending...' : 'Send a new code')),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
