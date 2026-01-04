import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/auth_provider.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation - adjust based on your requirements
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Please enter a valid phone number with country code (e.g., +1234567890)';
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  Future<void> _handleSendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      print('DEBUG [PhoneLoginScreen]: Form validated, starting OTP send process');

      setState(() {
        _isLoading = true;
      });

      try {
        // Format phone number (remove spaces and dashes)
        final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');
        print('DEBUG [PhoneLoginScreen]: Formatted phone number: $phoneNumber');
        print('DEBUG [PhoneLoginScreen]: Calling signInWithPhone...');

        await ref.read(authStateProvider.notifier).signInWithPhone(phoneNumber);

        print('DEBUG [PhoneLoginScreen]: signInWithPhone completed successfully');

        if (mounted) {
          setState(() {
            _otpSent = true;
            _isLoading = false;
          });

          print('DEBUG [PhoneLoginScreen]: UI state updated - OTP sent flag set to true');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent successfully! Please check your phone.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('DEBUG [PhoneLoginScreen]: Error occurred - $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('DEBUG [PhoneLoginScreen]: Form validation failed');
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.length != 6) {
      print('DEBUG [PhoneLoginScreen]: Invalid OTP length - ${_otpController.text.length}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('DEBUG [PhoneLoginScreen]: Starting OTP verification process');

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');
      print('DEBUG [PhoneLoginScreen]: Phone number for verification: $phoneNumber');
      print('DEBUG [PhoneLoginScreen]: OTP entered: ${_otpController.text}');
      print('DEBUG [PhoneLoginScreen]: Calling verifyPhoneOtp...');

      await ref.read(authStateProvider.notifier).verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: _otpController.text,
      );

      print('DEBUG [PhoneLoginScreen]: OTP verification successful, navigating to home');

      // Navigate to home on successful verification
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      print('DEBUG [PhoneLoginScreen]: OTP verification failed - $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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

                            // Back button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Title
                            Center(
                              child: Text(
                                'Phone Login',
                                style: GoogleFonts.syne(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              _otpSent
                                  ? 'Enter the OTP sent to your phone'
                                  : 'Enter your phone number to receive an OTP',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),

                            // Phone Number Field
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '+1234567890',
                                prefixIcon: const Icon(Iconsax.call),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: _validatePhone,
                              enabled: !_otpSent && !_isLoading,
                            ),

                            if (_otpSent) ...[
                              const SizedBox(height: 16),

                              // OTP Field
                              TextFormField(
                                controller: _otpController,
                                decoration: InputDecoration(
                                  labelText: 'OTP',
                                  hintText: '123456',
                                  prefixIcon: const Icon(Iconsax.key),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: _validateOtp,
                                enabled: !_isLoading,
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Action Button
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : (_otpSent ? _handleVerifyOtp : _handleSendOtp),
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
                                  : Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
                            ),

                            if (_otpSent) ...[
                              const SizedBox(height: 16),

                              // Resend OTP button
                              TextButton(
                                onPressed: _isLoading ? null : _handleSendOtp,
                                child: const Text('Resend OTP'),
                              ),

                              const SizedBox(height: 8),

                              // Change phone number button
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _otpSent = false;
                                          _otpController.clear();
                                        });
                                      },
                                child: const Text('Change Phone Number'),
                              ),
                            ],

                            const Spacer(),

                            // Back to login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Prefer email login?',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          context.pop();
                                        },
                                  child: const Text('Login with Email'),
                                ),
                              ],
                            ),

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
