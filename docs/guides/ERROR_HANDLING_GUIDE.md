# Error Handling Implementation Guide

## Overview

This guide shows how to wrap all Supabase/HTTP service calls with comprehensive error handling using the `ErrorHandler` utility.

## Quick Start

### 1. Import the ErrorHandler

```dart
import 'package:bottles_up_user/core/error/error_handler.dart';
```

### 2. Wrap Service Calls

**Before:**
```dart
Future<List<Event>> getEvents() async {
  final response = await _supabase
      .from('events')
      .select()
      .eq('is_active', true);

  return (response as List)
      .map((e) => Event.fromSupabase(e))
      .toList();
}
```

**After:**
```dart
Future<List<Event>> getEvents() async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase
          .from('events')
          .select()
          .eq('is_active', true);

      return (response as List)
          .map((e) => Event.fromSupabase(e))
          .toList();
    },
    errorMessage: 'Failed to load events',
  );
}
```

### 3. Alternative: Extension Method

```dart
Future<List<Event>> getEvents() async {
  return await _supabase
      .from('events')
      .select()
      .eq('is_active', true)
      .then((response) => (response as List)
          .map((e) => Event.fromSupabase(e))
          .toList())
      .withErrorHandling(errorMessage: 'Failed to load events');
}
```

## Exception Types

The `ErrorHandler` provides typed exceptions:

- `NetworkException` - Network connectivity issues
- `AuthException` - Authentication/authorization failures
- `ServerException` - Backend/database errors
- `ValidationException` - Data validation failures
- `AppException` - Generic application errors

## Error Handling in UI

### Using AsyncValue (Riverpod)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final eventsAsync = ref.watch(eventsProvider);

  return eventsAsync.when(
    data: (events) => EventsList(events: events),
    loading: () => LoadingShimmer(),
    error: (error, stack) {
      final message = ErrorHandler.getUserMessage(error);
      final isNetwork = error is NetworkException;

      return ErrorEventsState(
        message: message,
        isNetworkError: isNetwork,
        onRetry: () => ref.refresh(eventsProvider),
      );
    },
  );
}
```

### Using Try-Catch in Widgets

```dart
Future<void> _submitForm() async {
  try {
    setState(() => _isLoading = true);
    await _service.createBooking(data);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking created successfully')),
      );
    }
  } on AppException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

## Service Patterns

### Pattern 1: Simple Query

```dart
Future<Model?> getById(String id) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase
          .from('table')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null ? Model.fromSupabase(response) : null;
    },
    errorMessage: 'Failed to load item',
  );
}
```

### Pattern 2: List Query with Filters

```dart
Future<List<Model>> getFiltered({
  required String category,
  int limit = 20,
}) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase
          .from('table')
          .select()
          .eq('category', category)
          .eq('is_active', true)
          .limit(limit);

      return (response as List)
          .map((e) => Model.fromSupabase(e))
          .toList();
    },
    errorMessage: 'Failed to load items',
  );
}
```

### Pattern 3: Insert/Update Operations

```dart
Future<Model> create(Model model) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase
          .from('table')
          .insert(model.toJson())
          .select()
          .single();

      return Model.fromSupabase(response);
    },
    errorMessage: 'Failed to create item',
  );
}

Future<void> update(String id, Map<String, dynamic> updates) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      await _supabase
          .from('table')
          .update(updates)
          .eq('id', id);
    },
    errorMessage: 'Failed to update item',
  );
}
```

### Pattern 4: Delete Operations

```dart
Future<void> delete(String id) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      await _supabase
          .from('table')
          .delete()
          .eq('id', id);
    },
    errorMessage: 'Failed to delete item',
  );
}
```

### Pattern 5: Storage Operations

```dart
Future<String> uploadImage(String path, Uint8List data) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      await _supabase.storage
          .from('images')
          .uploadBinary(path, data);

      return _supabase.storage
          .from('images')
          .getPublicUrl(path);
    },
    errorMessage: 'Failed to upload image',
  );
}
```

### Pattern 6: Edge Function Calls

```dart
Future<Map<String, dynamic>> callEdgeFunction({
  required String functionName,
  required Map<String, dynamic> body,
}) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase.functions.invoke(
        functionName,
        body: body,
      );

      return response.data as Map<String, dynamic>;
    },
    errorMessage: 'Failed to process request',
  );
}
```

### Pattern 7: Realtime Subscriptions

```dart
RealtimeChannel subscribeToChanges({
  required void Function(Map<String, dynamic>) onInsert,
  required void Function(Map<String, dynamic>) onUpdate,
  required void Function(Map<String, dynamic>) onDelete,
}) {
  return _supabase
      .channel('table_changes')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'table',
        callback: (payload) {
          try {
            onInsert(payload.newRecord);
          } catch (e) {
            debugPrint('Error handling insert: $e');
            GlobalErrorHandler().reportError(e, StackTrace.current);
          }
        },
      )
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'table',
        callback: (payload) {
          try {
            onUpdate(payload.newRecord);
          } catch (e) {
            debugPrint('Error handling update: $e');
            GlobalErrorHandler().reportError(e, StackTrace.current);
          }
        },
      )
      .subscribe();
}
```

## Silent Error Handling

For non-critical operations where you don't want to show errors to users:

```dart
Future<void> trackAnalytics(String event) async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      await _supabase.from('analytics').insert({'event': event});
    },
    errorMessage: 'Analytics tracking failed',
    silent: true, // ✅ Logs error but doesn't throw
  );
}
```

## Migration Checklist

For each service file:

- [ ] Add ErrorHandler import
- [ ] Wrap all Supabase queries with `ErrorHandler.handleAsync()`
- [ ] Wrap all edge function calls with `ErrorHandler.handleAsync()`
- [ ] Wrap all storage operations with `ErrorHandler.handleAsync()`
- [ ] Add try-catch blocks around realtime callbacks
- [ ] Provide user-friendly error messages
- [ ] Test error scenarios (network off, invalid data, auth expired)

## Priority Services (Apply Error Handling First)

1. **Authentication Services** - Critical for app access
   - `lib/features/auth/services/auth_service.dart`
   - `lib/features/auth/services/google_sign_in_service.dart`
   - `lib/features/auth/services/apple_sign_in_service.dart`

2. **Event Services** - Core app functionality
   - `lib/features/events/services/event_service.dart`
   - `lib/features/events/services/event_booking_service.dart`

3. **Payment Services** - Financial operations
   - `lib/core/services/payment_service.dart`
   - `lib/features/billing/services/live_bill_service.dart`

4. **Location Services** - User experience
   - `lib/features/location/services/location_service.dart`

## Testing Error Handling

### Test Network Errors

1. Turn off internet connection
2. Try to load events
3. Should show: "No internet connection. Please try again."

### Test Authentication Errors

1. Manually expire auth token (or sign out in Supabase dashboard)
2. Try to create booking
3. Should show: "Authentication error. Please sign in again."

### Test Validation Errors

1. Try to create duplicate record
2. Should show: "This record already exists."

### Test Server Errors

1. Use invalid table name in query
2. Should show generic: "Database operation failed"

## Best Practices

✅ **DO:**
- Always provide user-friendly error messages
- Use specific error messages per operation ("Failed to load events" not "Error")
- Handle errors at the UI layer with proper user feedback
- Log errors in debug mode for troubleshooting
- Test error scenarios during development

❌ **DON'T:**
- Don't expose technical error details to users
- Don't silently swallow errors (except analytics/tracking)
- Don't show error dialogs for every minor issue
- Don't use generic "Something went wrong" for everything
- Don't forget to handle loading/error states in UI

## Next Steps

1. Apply error handling to priority services (auth, events, payments)
2. Update UI components to use ErrorEventsState and EmptyEventsState
3. Test error scenarios thoroughly
4. Apply to remaining services
5. Monitor error logs in production
6. Integrate crash reporting (Sentry/Firebase Crashlytics)
