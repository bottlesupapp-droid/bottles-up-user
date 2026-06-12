import 'dart:async';
import 'package:bottles_up_user/core/error/global_error_handler.dart';
import 'package:bottles_up_user/features/auth/services/deep_link_listener.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Run app in error-handling zone
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Initialize deep link listener
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await DeepLinkListener().initialize(context);
      }
    });
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
