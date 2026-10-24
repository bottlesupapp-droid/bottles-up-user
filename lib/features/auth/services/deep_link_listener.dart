import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'deep_link_handler.dart';

class DeepLinkListener {
  static final DeepLinkListener _instance = DeepLinkListener._internal();
  factory DeepLinkListener() => _instance;
  DeepLinkListener._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkStreamSubscription;
  bool _initialized = false;

  /// Initialize deep link listening. Safe to call multiple times.
  Future<void> initialize(BuildContext context) async {
    debugPrint('🔗 [DL-1] DeepLinkListener.initialize called. Already initialized: $_initialized');
    if (_initialized) return;
    _initialized = true;
    debugPrint('🔗 [DL-2] Creating AppLinks instance');
    _appLinks = AppLinks();
    debugPrint('🔗 [DL-3] AppLinks created, checking initial link...');

    // Handle link that cold-started the app
    await _handleInitialLink();

    debugPrint('🔗 [DL-4] Setting up uriLinkStream subscription...');
    // Handle links while the app is already running / in background
    _linkStreamSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('🔗 [DL-STREAM] uriLinkStream fired: $uri');
        _handleDeepLink(uri.toString());
      },
      onError: (err) {
        debugPrint('❌ [DL-STREAM-ERR] Deep link stream error: $err');
      },
    );
    debugPrint('🔗 [DL-5] DeepLinkListener fully initialized');
  }

  /// Handle the initial link that launched the app from a dead state.
  Future<void> _handleInitialLink() async {
    try {
      debugPrint('🔗 [DL-INIT-1] Calling getInitialLink...');
      final Uri? initialLink = await _appLinks.getInitialLink();
      debugPrint('🔗 [DL-INIT-2] getInitialLink result: $initialLink');
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      } else {
        debugPrint('🔗 [DL-INIT-3] No initial link (app not cold-started via deep link)');
      }
    } catch (e, stack) {
      debugPrint('❌ [DL-INIT-ERR] Error getting initial link: $e');
      debugPrint('❌ Stack: $stack');
    }
  }

  /// Handle the incoming deep link (navigation via appRouter, no context needed)
  void _handleDeepLink(String link) {
    debugPrint('🔗 [DL-HANDLE-1] _handleDeepLink called with: $link');
    try {
      final handled = DeepLinkHandler.handleDeepLink(link);
      debugPrint('🔗 [DL-HANDLE-2] DeepLinkHandler.handleDeepLink returned: $handled');
      if (handled) {
        debugPrint('✅ [DL-HANDLE-3] Deep link handled successfully');
      } else {
        debugPrint('⚠️ [DL-HANDLE-3] Deep link not recognized: $link');
      }
    } catch (e, stack) {
      debugPrint('❌ [DL-HANDLE-ERR] Error handling deep link: $e');
      debugPrint('❌ Stack: $stack');
    }
  }

  /// Dispose of the listener
  void dispose() {
    _linkStreamSubscription?.cancel();
    _initialized = false;
  }
}