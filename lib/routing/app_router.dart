import 'dart:async';
import 'package:bottles_up_user/features/auth/screens/forgot_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/phone_login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/reset_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/signup_screen.dart';
import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:bottles_up_user/features/profile/screens/edit_profile_screen.dart';
import 'package:bottles_up_user/features/profile/screens/privacy_policy_screen.dart';
import 'package:bottles_up_user/features/profile/screens/settings_screen.dart';
import 'package:bottles_up_user/features/profile/screens/terms_conditions_screen.dart';
import 'package:bottles_up_user/features/splash/screens/splash_screen.dart';
import 'package:bottles_up_user/features/tables/screens/table_booking_screen.dart';
import 'package:bottles_up_user/features/tables/screens/venue_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/payment_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Routes that do not require authentication.
const _publicRoutes = {
  '/',
  '/login',
  '/signup',
  '/phone-login',
  '/forgot-password',
  '/reset-password',
};

// Refreshes the router whenever Supabase auth state changes.
class _AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  _AuthRefreshNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final _authRefreshNotifier = _AuthRefreshNotifier();

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final path = state.uri.path;

    // Splash manages its own flow — leave it alone.
    if (path == '/') return null;

    final isPublic = _publicRoutes.any((r) => path == r || path.startsWith('$r/'));

    if (!isLoggedIn && !isPublic) {
      // Preserve the intended destination so we can redirect back after login.
      final encoded = Uri.encodeComponent(state.uri.toString());
      return '/login?redirect=$encoded';
    }

    if (isLoggedIn && (path == '/login' || path == '/signup' || path == '/phone-login')) {
      return '/home';
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Page not found: ${state.uri}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
  routes: appRoutes,
);

/// Every screen the app can open. Apart from the router so a test can open them without a signed-in session.
final List<RouteBase> appRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    path: '/phone-login',
    builder: (context, state) => const PhoneLoginScreen(),
  ),
  GoRoute(
    path: '/forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/reset-password',
    builder: (context, state) {
      // Extract parameters from both query and fragment
      final params = <String, String>{};
      params.addAll(state.uri.queryParameters);

      // Parse fragment parameters (Supabase uses fragments)
      if (state.uri.fragment.isNotEmpty) {
        final fragmentParts = state.uri.fragment.split('&');
        for (final part in fragmentParts) {
          final keyValue = part.split('=');
          if (keyValue.length == 2) {
            params[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
          }
        }
      }

      final accessToken = params['access_token'];
      final refreshToken = params['refresh_token'];

      return ResetPasswordScreen(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    },
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const MainNavigationScreen(),
  ),
  GoRoute(
    path: '/profile/edit',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const EditProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/settings',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/privacy-policy',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const PrivacyPolicyScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/terms-conditions',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const TermsConditionsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/events/:id',
    builder: (context, state) => EventPageScreen(eventId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/events/:id/tickets/:tierId',
    builder: (context, state) => TicketPurchaseScreen(eventId: state.pathParameters['id']!, tierId: state.pathParameters['tierId']!),
  ),
  GoRoute(
    path: '/venues/:id',
    builder: (context, state) => VenueScreen(venueId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/venues/:id/tables/:tableId/book',
    builder: (context, state) => TableBookingScreen(
      venueId: state.pathParameters['id']!,
      tableId: state.pathParameters['tableId']!,
      dateKey: state.uri.queryParameters['date'],
      slotId: state.uri.queryParameters['slot'],
    ),
  ),
  GoRoute(
    path: '/payment',
    redirect: (context, state) => state.extra is PaymentWaitArgs ? null : '/home',
    builder: (context, state) => PaymentScreen(args: state.extra as PaymentWaitArgs),
  ),
  GoRoute(
    path: '/tickets/:id',
    builder: (context, state) => TicketScreen(orderId: state.pathParameters['id']!),
  ),
];
