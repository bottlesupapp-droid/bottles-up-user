import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkListener {
  static final DeepLinkListener _instance = DeepLinkListener._internal();
  factory DeepLinkListener() => _instance;
  DeepLinkListener._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkStreamSubscription;
  BuildContext? _context;

  /// Initialize deep link listening
  Future<void> initialize(BuildContext context) async {
    _context = context;
    _appLinks = AppLinks();
    
    print('DEBUG: DeepLinkListener initialized');
    
    // Handle app launch from deep link
    await _handleInitialLink();
    
    // Handle deep links when app is already running
    _linkStreamSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        print('DEBUG: Received deep link: $uri');
        _handleDeepLink(uri.toString(), context);
      },
      onError: (err) {
        print('DEBUG: Deep link error: $err');
      },
    );
  }

  /// Handle the initial link that launched the app
  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null && _context != null) {
        print('DEBUG: App launched with deep link: $initialLink');
        _handleDeepLink(initialLink.toString(), _context!);
      }
    } catch (e) {
      print('DEBUG: Failed to get initial link: $e');
    }
  }

  /// Handle deep link from external sources (like GoRouter's initial location)
  static void handleInitialLink(String link, BuildContext context) {
    print('DEBUG: Handling manual deep link: $link');
    DeepLinkListener()._handleDeepLink(link, context);
  }

  /// Handle the incoming deep link
  void _handleDeepLink(String link, BuildContext context) {
    try {
      print('DEBUG: Processing deep link: $link');
      
      final uri = Uri.parse(link);
      print('DEBUG: URI details - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}');
      print('DEBUG: Query params: ${uri.queryParameters}');
      print('DEBUG: Fragment: ${uri.fragment}');
      
      // Check if this is a password reset link
      if (_isPasswordResetLink(uri)) {
        _handlePasswordResetLink(uri, context);
      } else {
        print('DEBUG: Unhandled deep link type');
      }
    } catch (e) {
      print('DEBUG: Error handling deep link: $e');
    }
  }

  /// Check if the URI is a password reset link
  bool _isPasswordResetLink(Uri uri) {
    print('DEBUG: Checking if password reset link - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}');
    
    // Custom scheme: bottlesup://reset-password
    if (uri.scheme == 'bottlesup' && (uri.host == 'reset-password' || uri.path.contains('reset-password'))) {
      return true;
    }
    
    // HTTP scheme: http://bottlesupapp.com/reset-password
    if ((uri.scheme == 'http' || uri.scheme == 'https') && 
        uri.host == 'bottlesupapp.com' && 
        uri.path.contains('reset-password')) {
      return true;
    }
    
    return false;
  }

  /// Handle password reset deep link
  void _handlePasswordResetLink(Uri uri, BuildContext context) {
    print('DEBUG: Handling password reset link');
    
    // Extract parameters from both query and fragment
    final params = <String, String>{};
    
    // Add query parameters
    params.addAll(uri.queryParameters);
    
    // Parse fragment parameters (Supabase uses fragments)
    if (uri.fragment.isNotEmpty) {
      print('DEBUG: Processing fragment: ${uri.fragment}');
      final fragmentParts = uri.fragment.split('&');
      for (final part in fragmentParts) {
        final keyValue = part.split('=');
        if (keyValue.length == 2) {
          params[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
        }
      }
    }
    
    print('DEBUG: Extracted parameters: $params');
    
    final accessToken = params['access_token'] ?? '';
    final refreshToken = params['refresh_token'] ?? '';
    final type = params['type'] ?? '';
    
    // Check if we have the required parameters
    if (accessToken.isNotEmpty && type == 'recovery') {
      print('DEBUG: Valid reset tokens found, navigating to reset password screen');
      
      // Navigate to reset password screen with tokens
      context.go('/reset-password?access_token=$accessToken&refresh_token=$refreshToken');
    } else {
      print('DEBUG: Invalid tokens or type - access_token: ${accessToken.isEmpty ? "missing" : "present"}, type: $type');
      
      // Show error message and go to forgot password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid or expired reset link. Please request a new one.'),
          backgroundColor: Colors.red,
        ),
      );
      
      context.go('/forgot-password');
    }
  }

  /// Dispose of the listener  
  void dispose() {
    _linkStreamSubscription?.cancel();
    _context = null;
  }
}