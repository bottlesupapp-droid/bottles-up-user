import 'dart:async';
import 'package:flutter/foundation.dart';

/// Global error handler for the application
/// Captures all uncaught errors and provides crash reporting integration
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();

  /// Crash reporting callback
  /// Integrate with Sentry, Firebase Crashlytics, etc.
  Future<void> Function(dynamic error, StackTrace stackTrace)? onError;

  /// User notification callback
  /// Show error dialog or snackbar to user
  void Function(String message)? onUserError;

  /// Initialize global error handling
  void initialize({
    Future<void> Function(dynamic error, StackTrace stackTrace)? crashReporter,
    void Function(String message)? userNotifier,
  }) {
    onError = crashReporter;
    onUserError = userNotifier;

    // Capture Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _handleError(details.exception, details.stack ?? StackTrace.current);
    };

    // Capture errors outside Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleError(error, stack);
      return true; // Handled
    };
  }

  /// Handle error with reporting and logging
  void _handleError(dynamic error, StackTrace stackTrace) {
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('═══ ERROR ═══');
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('═════════════');
    }

    // Send to crash reporting (async, don't block)
    if (onError != null) {
      onError!(error, stackTrace).catchError((e) {
        debugPrint('Failed to report error: $e');
      });
    }

    // Notify user if appropriate
    if (onUserError != null && _shouldNotifyUser(error)) {
      try {
        onUserError!(_getUserFriendlyMessage(error));
      } catch (e) {
        debugPrint('Failed to notify user: $e');
      }
    }
  }

  /// Determine if user should be notified
  bool _shouldNotifyUser(dynamic error) {
    // Don't notify for network timeouts, cancelled operations, etc.
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout') ||
        errorString.contains('cancelled') ||
        errorString.contains('disposed')) {
      return false;
    }
    return true;
  }

  /// Get user-friendly error message
  String _getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network connection error. Please check your internet.';
    }
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (errorString.contains('unauthorized') || errorString.contains('auth')) {
      return 'Authentication error. Please sign in again.';
    }
    if (errorString.contains('not found') || errorString.contains('404')) {
      return 'Resource not found.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Manually report an error
  Future<void> reportError(dynamic error, StackTrace? stackTrace) async {
    _handleError(error, stackTrace ?? StackTrace.current);
  }
}

/// Example integration with Sentry
/// Uncomment and configure when adding Sentry
/*
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> initializeSentry() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.environment = kDebugMode ? 'development' : 'production';
      options.tracesSampleRate = 0.1;
    },
    appRunner: () {
      GlobalErrorHandler().initialize(
        crashReporter: (error, stackTrace) async {
          await Sentry.captureException(error, stackTrace: stackTrace);
        },
        userNotifier: (message) {
          // Show snackbar or dialog
        },
      );
    },
  );
}
*/

/// Example integration with Firebase Crashlytics
/// Uncomment and configure when adding Crashlytics
/*
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void initializeCrashlytics() {
  GlobalErrorHandler().initialize(
    crashReporter: (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        fatal: false,
      );
    },
    userNotifier: (message) {
      // Show snackbar or dialog
    },
  );
}
*/
