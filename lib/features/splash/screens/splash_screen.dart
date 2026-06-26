import 'package:bottles_up_user/features/auth/models/auth_state.dart';
import 'package:bottles_up_user/features/auth/providers/auth_provider.dart';
import 'package:bottles_up_user/features/location/services/location_service.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    // Show splash screen for at least 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_hasNavigated) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated) return;

    // If the deep link handler already navigated away from splash (e.g. payment
    // return), bail out — we must not override that navigation.
    final currentLocation = appRouter.routerDelegate.currentConfiguration.uri.path;
    if (currentLocation != '/') {
      _hasNavigated = true;
      return;
    }

    final authState = ref.read(authStateProvider);
    
    await authState.when(
      initial: () async {
        // If still initializing, wait a bit more
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && !_hasNavigated) {
          await _checkAuthAndNavigate();
        }
      },
      loading: () async {
        // If still loading, wait a bit more
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && !_hasNavigated) {
          await _checkAuthAndNavigate();
        }
      },
      authenticated: (user) async {
        _hasNavigated = true;

        // Check if location screen should be shown
        final locationService = ref.read(locationServiceProvider);
        final shouldShowLocationScreen = await locationService.shouldShowLocationScreen();

        if (!mounted) return;
        if (shouldShowLocationScreen) {
          context.go('/location-permission');
        } else {
          context.go('/home');
        }
      },
      unauthenticated: () async {
        _hasNavigated = true;
        if (!mounted) return;
        context.go('/login');
      },
      error: (error) async {
        _hasNavigated = true;
        if (!mounted) return;
        context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen(authStateProvider, (AuthState? previous, AuthState next) {
      if (_hasNavigated) return;

      // Only navigate after the splash timer has completed
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_hasNavigated) {
          _checkAuthAndNavigate();
        }
      });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Logo with size constraints
            SizedBox(
              width: 200,
              height: 200,
              child: SvgPicture.asset(
                'assets/app_logo.svg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            // App Name with custom font
            Text(
              'Bottles Up',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ).copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            const LoadingIndicator(size: 40),
          ],
        ),
      ),
    );
  }
} 