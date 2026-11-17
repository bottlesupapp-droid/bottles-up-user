import 'dart:async';

import 'package:bottles_up_user/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../logic/password_reset_logic.dart';
import 'password_reset_service.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  /// Where a handled link goes. A test swaps it to see the destination without a real router.
  @visibleForTesting
  static void Function(String location) navigate = _safeGo;

  /// The reset flow a link's token is spent with. A test swaps it for a fake.
  @visibleForTesting
  static PasswordResetService Function() resetService = PasswordResetService.new;

  /// How long a link that arrives with its own session is given to be read by the Supabase library before the link counts as dead.
  @visibleForTesting
  static Duration sessionWait = const Duration(milliseconds: 3000);

  /// Handle incoming deep link URLs.
  ///
  /// [context] is optional and only used for showing snackbars — navigation
  /// always goes through [appRouter] directly so it works regardless of where
  /// in the widget tree the caller lives (avoids "no GoRouter in scope" crash).
  static bool handleDeepLink(String link, [BuildContext? context]) {
    debugPrint('🔗 [DLH-1] handleDeepLink entry: ${redactLink(link)}');
    try {
      final uri = Uri.parse(link);
      debugPrint('🔗 [DLH-2] Parsed URI — scheme:${uri.scheme} host:${uri.host} path:${uri.path} query keys:${uri.queryParameters.keys.toList()}');

      // The link in a password-reset email, handed back to the app by the website's /reset-password page (see password_reset_logic.dart).
      switch (resetLinkActionFor(uri)) {
        case NotAResetLink():
          break;
        case VerifyResetToken(:final tokenHash):
          debugPrint('🔗 [DLH-3] Password reset link with a token');
          unawaited(_openResetWithToken(tokenHash));
          return true;
        case UseOpenedSession():
          debugPrint('🔗 [DLH-3] Password reset link that brought its own session');
          unawaited(_openResetWithOpenedSession());
          return true;
        case ResetLinkUnusable():
          debugPrint('🔗 [DLH-3] Password reset link that cannot be used');
          navigate('/forgot-password?expired=1');
          return true;
      }

      debugPrint('⚠️ [DLH-8] No handler matched for: ${redactLink(link)}');
      return false;
    } catch (e, stack) {
      debugPrint('❌ [DLH-ERR] DeepLinkHandler error: $e');
      debugPrint('❌ Stack: $stack');
      return false;
    }
  }

  static Future<void> _openResetWithToken(String tokenHash) async {
    try {
      await resetService().verifyLink(tokenHash);
      navigate('/reset-password');
    } on PasswordResetException catch (e) {
      // No connection: the token is not spent, so the same link still works. Anything else means it is dead.
      navigate(e.problem == ResetProblem.network ? '/forgot-password' : '/forgot-password?expired=1');
    } catch (_) {
      navigate('/forgot-password?expired=1');
    }
  }

  static Future<void> _openResetWithOpenedSession() async {
    final service = resetService();
    final deadline = DateTime.now().add(sessionWait);
    while (!service.hasRecoverySession && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    navigate(service.hasRecoverySession ? '/reset-password' : '/forgot-password?expired=1');
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