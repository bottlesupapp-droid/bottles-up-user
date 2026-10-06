import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Simple test screen to verify booking creation works
/// This bypasses ALL payment logic to test just the database insert
class TestBookingCreation extends StatefulWidget {
  const TestBookingCreation({super.key});

  @override
  State<TestBookingCreation> createState() => _TestBookingCreationState();
}

class _TestBookingCreationState extends State<TestBookingCreation> {
  String _status = 'Ready to test';
  bool _isLoading = false;

  Future<void> _testCreateBooking() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing booking creation...';
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          _status = '❌ ERROR: User not authenticated';
          _isLoading = false;
        });
        return;
      }

      debugPrint('🧪 [TEST-1] User authenticated: ${user.id}');
      debugPrint('🧪 [TEST-2] User email: ${user.email}');

      // Get a test event ID (first event in database)
      final eventsResponse = await supabase
          .from('events')
          .select('id, name')
          .limit(1)
          .single();

      final eventId = eventsResponse['id'] as String;
      final eventName = eventsResponse['name'] as String;

      debugPrint('🧪 [TEST-3] Found event: $eventName ($eventId)');

      setState(() {
        _status = 'Found event: $eventName\nCreating booking...';
      });

      // Generate confirmation code
      final confirmationCode = 'TEST${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      // Prepare booking data
      final bookingData = {
        'user_id': user.id,
        'event_id': eventId,
        'ticket_quantity': 1,
        'total_amount': 0.0, // Free test
        'status': 'confirmed',
        'confirmation_code': confirmationCode,
        'payment_status': 'test',
        'qr_code': confirmationCode,
      };

      debugPrint('🧪 [TEST-4] Attempting insert with data: $bookingData');

      // Try to insert
      final response = await supabase
          .from('events_bookings')
          .insert(bookingData)
          .select('id, confirmation_code, created_at')
          .single();

      debugPrint('🧪 [TEST-5] SUCCESS! Booking created: ${response['id']}');
      debugPrint('🧪 [TEST-6] Confirmation code: ${response['confirmation_code']}');
      debugPrint('🧪 [TEST-7] Created at: ${response['created_at']}');

      setState(() {
        _status = '✅ SUCCESS!\n\n'
            'Booking ID: ${response['id']}\n'
            'Confirmation: ${response['confirmation_code']}\n'
            'Event: $eventName\n\n'
            'Check "My Bookings" tab to verify!';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('🧪 [TEST-ERROR] Failed to create booking: $e');
      debugPrint('🧪 [TEST-STACK] $stackTrace');

      setState(() {
        _status = '❌ FAILED!\n\n'
            'Error: ${e.toString()}\n\n'
            'Check console for full stack trace';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Booking Creation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Booking Creation Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This will create a FREE test booking without any payment.\n\n'
              'Use this to verify the database insert works before adding payment back.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Text(
                _status,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _testCreateBooking,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Test Booking'),
            ),
            const SizedBox(height: 16),
            const Text(
              'After success, go to "My Bookings" tab to verify the booking appears.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
