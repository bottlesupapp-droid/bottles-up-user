import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    try {
      if (provider == 'Google') {
        await ref.read(authProvider.notifier).signInWithGoogle();
      } else if (provider == 'Apple') {
        await ref.read(authProvider.notifier).signInWithApple();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$provider login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    
    // Navigate to home when authenticated
    ref.listen<AsyncValue<bool>>(authProvider, (previous, next) {
      if (next.value == true) {
        context.go('/home');
      }
    });

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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 48),
                            
                            // Logo or App Name
                            Center(
                              child: Text(
                                'Bottles Up',
                                style: GoogleFonts.syne(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Text(
                              'Welcome Back',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'your.email@example.com',
                                prefixIcon: const Icon(Iconsax.sms),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              enabled: !authState.isLoading,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
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
                              validator: _validatePassword,
                              enabled: !authState.isLoading,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () {
                                        context.push('/forgot-password');
                                      },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Terms and Conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: authState.isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _acceptTerms = value ?? false;
                                          });
                                        },
                                ),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'I accept the ',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      InkWell(
                                        onTap: () => context.push('/profile/terms-conditions'),
                                        child: Text(
                                          'Terms and Conditions',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' and ',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      InkWell(
                                        onTap: () => context.push('/profile/privacy-policy'),
                                        child: Text(
                                          'Privacy Policy',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Login Button
                            ElevatedButton(
                              onPressed: authState.isLoading ? null : _handleLogin,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? LoadingAnimationWidget.inkDrop(
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : const Text('Login'),
                            ),
                            
                            if (authState.hasError) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Login failed. Please try again.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            

                            // Phone Login Button
                            OutlinedButton.icon(
                              onPressed: authState.isLoading
                                  ? null
                                  : () {
                                      context.push('/phone-login');
                                    },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              icon: const Icon(Iconsax.call, size: 24),
                              label: const Text('Login with Phone'),
                            ),

                            const SizedBox(height: 24),

                            const Spacer(),
                            
                            SizedBox.shrink(),
                            
                            const SizedBox(height: 16),
                          ],
                        ),
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

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(label),
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
