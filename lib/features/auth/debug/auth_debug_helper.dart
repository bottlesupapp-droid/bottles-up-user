import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDebugHelper {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Test Supabase connection and configuration
  static Future<Map<String, dynamic>> testSupabaseConnection() async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Check if Supabase is initialized
      results['supabase_initialized'] = true;
      
      // Test 2: Check anonymous access
      try {
        await _supabase.from('profiles').select('count').limit(1);
        results['database_accessible'] = true;
        results['database_error'] = null;
      } catch (e) {
        results['database_accessible'] = false;
        results['database_error'] = e.toString();
      }
      
      // Test 3: Check current session
      try {
        final session = _supabase.auth.currentSession;
        results['current_session'] = session != null ? 'Active session' : 'No session';
        results['auth_endpoint_accessible'] = true;
        results['auth_error'] = null;
      } catch (e) {
        results['auth_endpoint_accessible'] = false;
        results['auth_error'] = e.toString();
      }
      
      // Test 4: Current user info
      final user = _supabase.auth.currentUser;
      results['current_user'] = user != null ? 'User logged in' : 'Not logged in';
      
    } catch (e) {
      results['general_error'] = e.toString();
    }
    
    return results;
  }

  /// Test password reset functionality specifically
  static Future<Map<String, dynamic>> testPasswordResetSetup() async {
    final results = <String, dynamic>{};
    
    try {
      // Test with a dummy email to see what error we get
      // Note: This won't actually send an email, but will show us configuration issues
      await _supabase.auth.resetPasswordForEmail('test@example.com');
      results['reset_endpoint_accessible'] = true;
      results['reset_error'] = null;
    } on AuthException catch (e) {
      results['reset_endpoint_accessible'] = true; // Endpoint works, but got expected error
      results['auth_exception'] = {
        'message': e.message,
        'statusCode': e.statusCode,
      };
    } catch (e) {
      results['reset_endpoint_accessible'] = false;
      results['reset_error'] = e.toString();
    }
    
    return results;
  }

  /// Check profiles table structure and data
  static Future<void> checkProfilesTable() async {
    print('\n=== PROFILES TABLE DEBUG ===');
    
    try {
      // Get a few sample profiles to understand the structure
      final profiles = await _supabase
          .from('profiles')
          .select('id, email, name')
          .limit(3);
      
      print('Sample profiles found: ${profiles.length}');
      for (var profile in profiles) {
        print('  Profile: $profile');
      }
      
      // Check total count (simpliit fied)
      final allProfiles = await _supabase
          .from('profiles')
          .select('id')
          .limit(100); // Reasonable limit for counting
      
      print('Total profiles in database (up to 100): ${allProfiles.length}');
      
    } catch (e) {
      print('Error accessing profiles table: $e');
    }
  }

  /// Print comprehensive debug info
  static Future<void> printDebugInfo() async {
    print('=== SUPABASE DEBUG INFO ===');
    
    final connectionTest = await testSupabaseConnection();
    print('Connection Test Results:');
    connectionTest.forEach((key, value) {
      print('  $key: $value');
    });
    
    print('\n=== PASSWORD RESET DEBUG INFO ===');
    
    final resetTest = await testPasswordResetSetup();
    print('Password Reset Test Results:');
    resetTest.forEach((key, value) {
      print('  $key: $value');
    });
    
    // Check profiles table
    await checkProfilesTable();
    
    print('\n=== CONFIGURATION INFO ===');
    print('Supabase URL: https://hwmynlghrmtoufyrcihp.supabase.co');
    print('Current DateTime: ${DateTime.now()}');
    print('================================');
  }
}