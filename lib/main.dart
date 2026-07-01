import 'dart:async';
import 'package:bottles_up_user/core/config/payment_config.dart';
import 'package:bottles_up_user/core/error/global_error_handler.dart';
import 'package:bottles_up_user/features/auth/services/deep_link_listener.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Allow runtime font fetching - fonts will be downloaded on first use
  // TODO: Bundle Syne fonts in assets to avoid network calls
  GoogleFonts.config.allowRuntimeFetching = true;

  // Run app in error-handling zone
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Stripe. The publishable key comes from dart-define; if not
      // set at build time the payment service will set it later from the edge
      // function response. urlScheme enables 3DS redirects back to the app on iOS.
      // NOTE: merchantIdentifier (Apple Pay) is intentionally NOT set here —
      // Apple Pay requires a registered merchant ID + com.apple.developer.in-app-payments
      // entitlement. Until those are configured in Apple Developer Portal, setting
      // merchantIdentifier causes internal Apple Pay validation to hang on iOS.
      try {
        Stripe.publishableKey = PaymentConfig.stripePublishableKey;
        Stripe.urlScheme = 'bottlesup';
        await Stripe.instance.applySettings();
      } catch (e) {
        // Key not provided at build time — payment service sets it dynamically.
        debugPrint('⚠️ Stripe initialization skipped: $e');
        debugPrint('Stripe will be initialized with key from payment intent');
      }

      // Initialize global error handler
      GlobalErrorHandler().initialize(
        crashReporter: (error, stackTrace) async {
          // TODO: Integrate with Sentry, Firebase Crashlytics, or other crash reporting service
          // Example: await Sentry.captureException(error, stackTrace: stackTrace);
          debugPrint('Crash reported: $error');
        },
        userNotifier: (message) {
          // TODO: Show user-friendly error dialog or snackbar
          // This will be handled by the UI layer when needed
          debugPrint('User notification: $message');
        },
      );

      // SECURITY: Load Supabase credentials from environment variables
      // Pass via --dart-define when building:
      // --dart-define=SUPABASE_URL=https://...
      // --dart-define=SUPABASE_ANON_KEY=eyJ...
      const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
      const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw StateError(
          'Supabase credentials not configured.\n'
          'Pass --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=... when building.',
        );
      }

      await Supabase.initialize(
        url: supabaseUrl,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.implicit,
        ),
        anonKey: supabaseAnonKey,
      );

      runApp(
        const ProviderScope(
          child: MainApp(),
        ),
      );
    },
    (error, stackTrace) {
      // Catch errors outside Flutter framework
      GlobalErrorHandler().reportError(error, stackTrace);
    },
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('🚀 [APP-1] MainApp.initState — app starting or re-mounting');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('🚀 [APP-2] First frame rendered — initializing DeepLinkListener');
      if (mounted) {
        await DeepLinkListener().initialize(context);
        debugPrint('🚀 [APP-3] DeepLinkListener initialized');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🚀 [APP-LIFECYCLE] AppLifecycleState changed: $state');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
