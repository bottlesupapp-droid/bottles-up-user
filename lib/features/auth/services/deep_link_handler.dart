import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  /// Handle incoming deep link URLs
  static bool handleDeepLink(String link, BuildContext context) {
    try {
      print('DEBUG: Handling deep link: $link');
      
      final uri = Uri.parse(link);
      print('DEBUG: Parsed URI - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}');
      print('DEBUG: Query parameters: ${uri.queryParameters}');
      print('DEBUG: Fragment: ${uri.fragment}');
      
      // Handle password reset deep links from multiple schemes
      bool isResetPasswordLink = false;
      
      // Check for bottlesup:// scheme
      if (uri.scheme == 'bottlesup' && uri.host == 'reset-password') {
        isResetPasswordLink = true;
      }
      
      // Check for http/https schemes with reset-password path
      if ((uri.scheme == 'http' || uri.scheme == 'https') && 
          uri.host == 'bottlesupapp.com' && 
          uri.path.contains('reset-password')) {
        isResetPasswordLink = true;
      }
      
      if (isResetPasswordLink) {
        // Extract tokens from both query parameters and fragments
        final params = extractParams(uri);
        print('DEBUG: Extracted params: $params');
        
        final accessToken = params['access_token'] ?? '';
        final refreshToken = params['refresh_token'] ?? '';
        final type = params['type'] ?? '';
        
        print('DEBUG: access_token: ${accessToken.isNotEmpty ? "Found" : "Missing"}');
        print('DEBUG: refresh_token: ${refreshToken.isNotEmpty ? "Found" : "Missing"}');
        print('DEBUG: type: $type');
        
        if (accessToken.isNotEmpty && type == 'recovery') {
          print('DEBUG: Valid reset tokens found, navigating to reset screen');
          
          // Navigate to reset password screen with tokens
          context.go('/reset-password?access_token=$accessToken&refresh_token=$refreshToken');
          return true;
        } else {
          print('DEBUG: Invalid or missing tokens - access_token: $accessToken, type: $type');
          // Show error and redirect to forgot password screen
          context.go('/forgot-password');
          return true;
        }
      }
      
      // Handle other deep links (add more cases as needed)
      print('DEBUG: Unhandled deep link: $link');
      return false;
      
    } catch (e) {
      print('DEBUG: Error handling deep link: $e');
      return false;
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