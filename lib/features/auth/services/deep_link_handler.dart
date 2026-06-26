import 'package:bottles_up_user/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  /// Handle incoming deep link URLs.
  ///
  /// [context] is optional and only used for showing snackbars — navigation
  /// always goes through [appRouter] directly so it works regardless of where
  /// in the widget tree the caller lives (avoids "no GoRouter in scope" crash).
  static bool handleDeepLink(String link, [BuildContext? context]) {
    debugPrint('🔗 [DLH-1] handleDeepLink entry: $link');
    try {
      final uri = Uri.parse(link);
      debugPrint('🔗 [DLH-2] Parsed URI — scheme:${uri.scheme} host:${uri.host} path:${uri.path} query:${uri.queryParameters}');

      // Handle password reset deep links from multiple schemes
      bool isResetPasswordLink = false;

      if (uri.scheme == 'bottlesup' && uri.host == 'reset-password') {
        isResetPasswordLink = true;
      }

      if ((uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host == 'bottlesupapp.com' &&
          uri.path.contains('reset-password')) {
        isResetPasswordLink = true;
      }

      if (isResetPasswordLink) {
        debugPrint('🔗 [DLH-3] Identified as password reset link');
        final params = extractParams(uri);
        final accessToken = params['access_token'] ?? '';
        final refreshToken = params['refresh_token'] ?? '';
        final type = params['type'] ?? '';

        if (accessToken.isNotEmpty && type == 'recovery') {
          _safeGo('/reset-password?access_token=$accessToken&refresh_token=$refreshToken');
          return true;
        } else {
          _safeGo('/forgot-password');
          return true;
        }
      }

      // Handle payment deep links
      if (uri.scheme == 'bottlesup' && uri.host == 'payment') {
        final path = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
        debugPrint('🔗 [DLH-4] Payment deep link — path segment: "$path"');

        if (path == 'success') {
          final sessionId = uri.queryParameters['session_id'] ?? '';
          debugPrint('🔗 [DLH-5] Payment SUCCESS — session_id: "$sessionId"');

          if (sessionId.isNotEmpty) {
            debugPrint('🔗 [DLH-6] Calling _safeGo(/checkout-success?session_id=$sessionId)');
            _safeGo('/checkout-success?session_id=$sessionId');
            debugPrint('🔗 [DLH-7] _safeGo returned (navigation scheduled)');
          } else {
            debugPrint('🔗 [DLH-6b] No session_id, going to /home');
            _safeGo('/home');
          }
          return true;
        } else if (path == 'cancel') {
          debugPrint('🔗 [DLH-4b] Payment CANCEL deep link');
          _safeGo('/home');
          return true;
        } else {
          debugPrint('⚠️ [DLH-4c] Unknown payment path: "$path"');
        }
      }

      debugPrint('⚠️ [DLH-8] No handler matched for: $link');
      return false;
    } catch (e, stack) {
      debugPrint('❌ [DLH-ERR] DeepLinkHandler error: $e');
      debugPrint('❌ Stack: $stack');
      return false;
    }
  }

  /// Navigate safely regardless of current frame phase.
  static void _safeGo(String location) {
    debugPrint('🔗 [NAV-1] _safeGo($location) — schedulerPhase: ${SchedulerBinding.instance.schedulerPhase}');
    void doNav() {
      debugPrint('🔗 [NAV-2] Executing appRouter.go($location)');
      try {
        appRouter.go(location);
        debugPrint('🔗 [NAV-3] appRouter.go($location) completed');
      } catch (e, stack) {
        debugPrint('❌ [NAV-ERR] Navigation error for $location: $e');
        debugPrint('❌ Stack: $stack');
      }
    }

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle ||
        SchedulerBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
      doNav();
    } else {
      debugPrint('🔗 [NAV-1b] Deferring navigation to next frame');
      SchedulerBinding.instance.addPostFrameCallback((_) => doNav());
    }
  }

  /// Extract URL parameters from fragment or query
  static Map<String, String> extractParams(Uri uri) {
    final params = <String, String>{};
    
    // Extract from query parameters
    params.addAll(uri.queryParameters);
    
    // Extract from fragment (common with OAuth flows)
    if (uri.fragment.isNotEmpty) {
      final fragmentParts = uri.fragment.split('&');
      for (final part in fragmentParts) {
        final keyValue = part.split('=');
        if (keyValue.length == 2) {
          params[keyValue[0]] = keyValue[1];
        }
      }
    }
    
    return params;
  }
}