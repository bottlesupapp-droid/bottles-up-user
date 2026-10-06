import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkTester {
  /// Test various deep link scenarios
  static void testDeepLinks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deep Link Tester'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Test different deep link scenarios:'),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () {
                context.pop();
                _testResetPasswordLink(context);
              },
              child: const Text('Test Reset Password Link'),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () {
                context.pop();
                _testInvalidLink(context);
              },
              child: const Text('Test Invalid Link'),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () {
                context.pop();
                _showTestInstructions(context);
              },
              child: const Text('Show Test Instructions'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static void _testResetPasswordLink(BuildContext context) {
    // Simulate a deep link with dummy tokens
    const testUrl = '/reset-password?access_token=dummy_access_token&refresh_token=dummy_refresh_token';
    
    try {
      context.go(testUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navigated to reset password screen with test tokens'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static void _testInvalidLink(BuildContext context) {
    // Test navigation without tokens
    const testUrl = '/reset-password';
    
    try {
      context.go(testUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navigated to reset password screen without tokens'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static void _showTestInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deep Link Testing'),
        content: const SingleChildScrollView(
          child: Text('''
MANUAL TESTING INSTRUCTIONS:

🤖 ANDROID:
1. Custom scheme: adb shell am start -W -a android.intent.action.VIEW -d "bottlesup://reset-password?access_token=test&refresh_token=test" com.example.bottles_up_user
2. HTTP fallback: adb shell am start -W -a android.intent.action.VIEW -d "http://bottlesupapp.com/reset-password?access_token=test&refresh_token=test" com.example.bottles_up_user

🍎 iOS SIMULATOR:
1. Custom scheme: xcrun simctl openurl booted "bottlesup://reset-password?access_token=test&refresh_token=test"
2. HTTP fallback: xcrun simctl openurl booted "http://bottlesupapp.com/reset-password?access_token=test&refresh_token=test"

📧 EMAIL TESTING:
1. Request password reset from app
2. Check email for reset link
3. Link should open app automatically
4. Should navigate to reset password screen

🔍 VERIFICATION:
- App opens when clicking link ✓
- Navigates to correct screen ✓
- Tokens are passed correctly ✓
- Form validation works ✓
          '''),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }
}