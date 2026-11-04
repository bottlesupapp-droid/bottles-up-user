import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../logic/password_reset_logic.dart';
import '../providers/password_reset_provider.dart';
import '../services/password_reset_service.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  PasswordResetService get _service => ref.read(passwordResetServiceProvider);

  // Set once the password is changed, so the screen does not flash "expired" while the phone moves on to the sign-in.
  bool _done = false;

  Future<void> _handleResetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      await _service.updatePassword(_passwordController.text);
      // The reset session was only for this: the person signs in with the new password.
      _done = true;
      await _service.finish();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated. Sign in with your new password.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is PasswordResetException ? e.message : resetProblemMessage(ResetProblem.other)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // A reset needs the session the code or the link opened. Without one (the link was used, or the app sat closed for a long time)
    // there is nothing to change, and a form that can only fail would be worse than saying so.
    if (!_done && !_service.hasRecoverySession) return const _ResetExpiredView();

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background blur circles
            Positioned(
              top: -100,
              right: -100,
              child: _BlurredCircle(
                size: size.width * 0.7,
                color: colorScheme.primary,
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: _BlurredCircle(
                size: size.width * 0.6,
                color: colorScheme.primary,
              ),
            ),
            
            // Main content
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          
                          // Back button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => context.go('/login'),
                              icon: const Icon(Iconsax.arrow_left),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Reset Password Form
                          Center(
                            child: Icon(
                              Iconsax.lock,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Reset Password',
                            style: GoogleFonts.syne(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Text(
                            'Enter your new password below.',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // New Password Field
                                TextFormField(
                                  key: const Key('reset-new-password'),
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    hintText: '••••••••',
                                    prefixIcon: const Icon(Iconsax.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: validateNewPassword,
                                  enabled: !_isLoading,
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Confirm Password Field
                                TextFormField(
                                  key: const Key('reset-confirm-password'),
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    hintText: '••••••••',
                                    prefixIcon: const Icon(Iconsax.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscureConfirmPassword,
                                  validator: (value) => validateConfirmPassword(value, _passwordController.text),
                                  enabled: !_isLoading,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Update Password Button
                          ElevatedButton(
                            key: const Key('reset-submit'),
                            onPressed: _isLoading ? null : _handleResetPassword,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? LoadingAnimationWidget.inkDrop(
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : const Text('Update Password'),
                          ),
                          
                          const Spacer(),
                          
                          // Back to Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: const Text('Back to Login'),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurredCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50,
          sigmaY: 50,
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

/// Shown when there is no reset session behind the screen: the link was used, or the reset was abandoned.
class _ResetExpiredView extends StatelessWidget {
  const _ResetExpiredView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Iconsax.timer_1, size: 64, color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'This reset has expired',
                style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Reset links and codes work once and only for a short time. Ask for a new one.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                key: const Key('reset-expired-new'),
                onPressed: () => context.go('/forgot-password'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ask for a new email'),
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
