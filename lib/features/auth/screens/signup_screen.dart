import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/auth_provider.dart';
import '../models/country.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  Country? _selectedCountry;
  
  final List<Country> _countries = [
    Country(name: 'United States', code: 'US', phoneCode: '+1'),
    Country(name: 'United Kingdom', code: 'GB', phoneCode: '+44'),
    Country(name: 'Canada', code: 'CA', phoneCode: '+1'),
    Country(name: 'Australia', code: 'AU', phoneCode: '+61'),
    Country(name: 'India', code: 'IN', phoneCode: '+91'),
    Country(name: 'Germany', code: 'DE', phoneCode: '+49'),
    Country(name: 'France', code: 'FR', phoneCode: '+33'),
    Country(name: 'Japan', code: 'JP', phoneCode: '+81'),
    Country(name: 'Singapore', code: 'SG', phoneCode: '+65'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 13 || age > 120) {
      return 'Age must be between 13 and 120';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 8) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _handleSignup() async {
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
      final phoneNumber = '${_selectedCountry!.phoneCode}${_phoneController.text}';
      
      await ref.read(authProvider.notifier).signup(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        age: int.parse(_ageController.text),
        phoneNumber: phoneNumber,
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
                            const SizedBox(height: 32),

                            // Back button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),

                            const SizedBox(height: 8),

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
                              'Create Account',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Name Field
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'John Doe',
                                prefixIcon: const Icon(Iconsax.user),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: _validateName,
                              enabled: !authState.isLoading,
                            ),
                            
                            const SizedBox(height: 16),
                            
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
                            
                            const SizedBox(height: 16),
                            
                            // Confirm Password Field
                            TextFormField(
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
                              validator: _validateConfirmPassword,
                              enabled: !authState.isLoading,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Age Field
                            TextFormField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                hintText: '25',
                                prefixIcon: const Icon(Iconsax.calendar),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: _validateAge,
                              enabled: !authState.isLoading,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Phone Number with Country Dropdown
                            Row(
                              children: [
                                // Country Dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Country>(
                                      value: _selectedCountry,
                                      items: _countries.map((country) {
                                        return DropdownMenuItem<Country>(
                                          value: country,
                                          child: Text('${country.code} ${country.phoneCode}'),
                                        );
                                      }).toList(),
                                      onChanged: authState.isLoading ? null : (Country? value) {
                                        setState(() {
                                          _selectedCountry = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Phone Number Field
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      hintText: '1234567890',
                                      prefixIcon: const Icon(Iconsax.call),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: _validatePhone,
                                    enabled: !authState.isLoading,
                                  ),
                                ),
                              ],
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
                            
                            SizedBox.shrink(),
                            
                            if (authState.hasError) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Signup failed. Please try again.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            
                            

                            const SizedBox(height: 24),

                            const Spacer(),
                            
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : () {
                                          context.go('/login');
                                        },
                                  child: const Text('Login'),
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

