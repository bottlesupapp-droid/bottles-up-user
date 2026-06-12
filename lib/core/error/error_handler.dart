import 'dart:async';
import 'dart:io';
import 'package:bottles_up_user/core/error/global_error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Exception types for different error scenarios
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String? message])
      : super(message ?? 'Network connection failed. Please check your internet.');
}

class AuthException extends AppException {
  AuthException([String? message])
      : super(message ?? 'Authentication failed. Please sign in again.');
}

class ServerException extends AppException {
  ServerException([String? message])
      : super(message ?? 'Server error. Please try again later.');
}

class ValidationException extends AppException {
  ValidationException([String? message])
      : super(message ?? 'Invalid input. Please check your data.');
}

/// Error handler utility for wrapping service calls
class ErrorHandler {
  /// Wrap a Supabase/HTTP call with comprehensive error handling
  ///
  /// Usage:
  /// ```dart
  /// final result = await ErrorHandler.handleAsync(
  ///   operation: () => _supabase.from('events').select(),
  ///   errorMessage: 'Failed to load events',
  /// );
  /// ```
  static Future<T> handleAsync<T>({
    required Future<T> Function() operation,
    String? errorMessage,
    bool silent = false,
  }) async {
    try {
      return await operation();
    } on PostgrestException catch (e) {
      final error = _handlePostgrestError(e, errorMessage);
      if (!silent) _logError(error, e);
      throw error;
    } on StorageException catch (e) {
      final error = _handleStorageError(e, errorMessage);
      if (!silent) _logError(error, e);
      throw error;
    } on SocketException catch (e) {
      final error = NetworkException('No internet connection. Please try again.');
      if (!silent) _logError(error, e);
      throw error;
    } on TimeoutException catch (e) {
      final error = NetworkException('Request timed out. Please try again.');
      if (!silent) _logError(error, e);
      throw error;
    } on AppException catch (e) {
      // Re-throw our own exceptions
      if (!silent) _logError(e, e.originalError);
      rethrow;
    } catch (e, stackTrace) {
      final error = AppException(
        errorMessage ?? 'An unexpected error occurred',
        originalError: e,
      );
      if (!silent) {
        _logError(error, e);
        GlobalErrorHandler().reportError(e, stackTrace);
      }
      throw error;
    }
  }

  /// Handle Postgrest (Supabase database) errors
  static AppException _handlePostgrestError(
    PostgrestException error,
    String? customMessage,
  ) {
    // Check for specific error codes
    if (error.code == '23505') {
      return ValidationException('This record already exists.');
    }
    if (error.code == '23503') {
      return ValidationException('Invalid reference. The related record does not exist.');
    }
    if (error.code == '42501') {
      return AuthException('You do not have permission to perform this action.');
    }

    // Check for network-related errors
    if (error.message.toLowerCase().contains('network')) {
      return NetworkException();
    }

    // Generic server error
    return ServerException(
      customMessage ?? error.message,
    );
  }

  /// Handle Supabase Storage errors
  static AppException _handleStorageError(
    StorageException error,
    String? customMessage,
  ) {
    if (error.statusCode == '404') {
      return AppException('File not found.');
    }
    if (error.statusCode == '401' || error.statusCode == '403') {
      return AuthException('You do not have permission to access this file.');
    }

    return ServerException(
      customMessage ?? error.message,
    );
  }

  /// Log error to console in debug mode
  static void _logError(AppException error, dynamic originalError) {
    if (kDebugMode) {
      debugPrint('═══ SERVICE ERROR ═══');
      debugPrint('Message: ${error.message}');
      if (error.code != null) debugPrint('Code: ${error.code}');
      debugPrint('Original: $originalError');
      debugPrint('═════════════════════');
    }
  }

  /// Get user-friendly error message from any exception
  static String getUserMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    if (error is SocketException) {
      return 'No internet connection. Please try again.';
    }
    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }
    if (error is PostgrestException) {
      return _handlePostgrestError(error, null).message;
    }
    if (error is StorageException) {
      return _handleStorageError(error, null).message;
    }
    if (error is AuthException) {
      return 'Authentication error. Please sign in again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Extension methods for easier error handling
extension FutureErrorHandling<T> on Future<T> {
  /// Wrap this future with error handling
  Future<T> withErrorHandling({
    String? errorMessage,
    bool silent = false,
  }) {
    return ErrorHandler.handleAsync(
      operation: () => this,
      errorMessage: errorMessage,
      silent: silent,
    );
  }
}
