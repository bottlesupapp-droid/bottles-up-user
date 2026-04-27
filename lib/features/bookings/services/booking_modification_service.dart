import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_modification.dart';
import '../../club/models/table_booking.dart';

class BookingModificationService {
  static final BookingModificationService _instance =
      BookingModificationService._internal();
  factory BookingModificationService() => _instance;
  BookingModificationService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Calculate refund based on cancellation policy
  Future<RefundCalculation> calculateRefund({
    required TableBooking booking,
    CancellationPolicy? policy,
  }) async {
    final now = DateTime.now();
    final eventDateTime = booking.bookingDate;
    final hoursUntilEvent = eventDateTime.difference(now).inHours;

    // Use provided policy or get from database
    final cancellationPolicy = policy ?? await _getCancellationPolicy(booking);

    double refundPercentage = 0;
    bool isRefundable = false;
    String? message;

    if (hoursUntilEvent >= cancellationPolicy.hoursBeforeEvent) {
      refundPercentage = cancellationPolicy.refundPercentage;
      isRefundable = true;
      message = '${refundPercentage.toInt()}% refund available';
    } else if (hoursUntilEvent >= 24) {
      // Grace period - 50% refund
      refundPercentage = 50;
      isRefundable = true;
      message = '50% refund (within grace period)';
    } else if (hoursUntilEvent >= 0) {
      // Less than 24 hours - no refund
      refundPercentage = 0;
      isRefundable = false;
      message = 'No refund available (less than 24 hours to event)';
    } else {
      // Event has passed
      refundPercentage = 0;
      isRefundable = false;
      message = 'Event has already occurred';
    }

    final originalAmount = booking.totalPrice;
    final refundAmount = (originalAmount * refundPercentage) / 100;
    final cancellationFee =
        (originalAmount * cancellationPolicy.cancellationFeePercentage) / 100;
    final netRefund = refundAmount - cancellationFee;

    return RefundCalculation(
      originalAmount: originalAmount,
      refundPercentage: refundPercentage,
      refundAmount: refundAmount,
      cancellationFee: cancellationFee,
      netRefund: netRefund > 0 ? netRefund : 0,
      policy: cancellationPolicy,
      hoursUntilEvent: hoursUntilEvent,
      isRefundable: isRefundable,
      message: message,
    );
  }

  // Request booking cancellation
  Future<BookingModification> requestCancellation({
    required String bookingId,
    required CancellationReason reason,
    String? userNotes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get booking details
      final booking = await _getBooking(bookingId);

      // Calculate refund
      final refundCalc = await calculateRefund(booking: booking);

      final modificationData = {
        'booking_id': bookingId,
        'user_id': currentUser.id,
        'modification_type': ModificationType.cancel.name,
        'status': ModificationStatus.pending.name,
        'cancellation_reason': reason.name,
        'refund_amount': refundCalc.netRefund,
        'user_notes': userNotes,
        'old_values': {
          'status': booking.status,
          'total_amount': booking.totalPrice,
        },
        'requested_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('booking_modifications')
          .insert(modificationData)
          .select()
          .single();

      return BookingModification.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to request cancellation: $e');
    }
  }

  // Request booking reschedule
  Future<BookingModification> requestReschedule({
    required String bookingId,
    required DateTime newEventDate,
    String? userNotes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final booking = await _getBooking(bookingId);

      final modificationData = {
        'booking_id': bookingId,
        'user_id': currentUser.id,
        'modification_type': ModificationType.reschedule.name,
        'status': ModificationStatus.pending.name,
        'old_values': {
          'booking_date': booking.bookingDate.toIso8601String(),
        },
        'new_values': {
          'booking_date': newEventDate.toIso8601String(),
        },
        'user_notes': userNotes,
        'requested_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('booking_modifications')
          .insert(modificationData)
          .select()
          .single();

      return BookingModification.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to request reschedule: $e');
    }
  }

  // Request guest count change
  Future<BookingModification> requestGuestChange({
    required String bookingId,
    required int newGuestCount,
    String? userNotes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final booking = await _getBooking(bookingId);

      // Calculate price difference
      final pricePerGuest = booking.totalPrice / booking.guestCount;
      final newTotalAmount = pricePerGuest * newGuestCount;
      final priceDifference = newTotalAmount - booking.totalPrice;

      final modificationData = {
        'booking_id': bookingId,
        'user_id': currentUser.id,
        'modification_type': ModificationType.changeGuests.name,
        'status': ModificationStatus.pending.name,
        'old_values': {
          'guest_count': booking.guestCount,
          'total_amount': booking.totalPrice,
        },
        'new_values': {
          'guest_count': newGuestCount,
          'total_amount': newTotalAmount,
        },
        'additional_charge': priceDifference > 0 ? priceDifference : null,
        'refund_amount': priceDifference < 0 ? priceDifference.abs() : null,
        'user_notes': userNotes,
        'requested_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('booking_modifications')
          .insert(modificationData)
          .select()
          .single();

      return BookingModification.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to request guest change: $e');
    }
  }

  // Get modification requests for a booking
  Future<List<BookingModification>> getBookingModifications(
    String bookingId,
  ) async {
    try {
      final response = await _supabase
          .from('booking_modifications')
          .select()
          .eq('booking_id', bookingId)
          .order('requested_at', ascending: false);

      return (response as List)
          .map((data) => BookingModification.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user's modification requests
  Future<List<BookingModification>> getUserModifications() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('booking_modifications')
          .select()
          .eq('user_id', currentUser.id)
          .order('requested_at', ascending: false);

      return (response as List)
          .map((data) => BookingModification.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Cancel modification request
  Future<void> cancelModificationRequest(String modificationId) async {
    try {
      await _supabase
          .from('booking_modifications')
          .update({'status': ModificationStatus.rejected.name})
          .eq('id', modificationId);
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  // Check if modification is allowed
  Future<bool> canModifyBooking(TableBooking booking) async {
    final now = DateTime.now();
    final eventDateTime = booking.bookingDate;
    final hoursUntilEvent = eventDateTime.difference(now).inHours;

    // Can't modify past events
    if (hoursUntilEvent < 0) return false;

    // Can't modify cancelled bookings
    if (booking.status == 'cancelled') return false;

    // Check for pending modifications
    final modifications = await getBookingModifications(booking.id);
    final hasPending = modifications.any(
      (m) => m.status == ModificationStatus.pending,
    );

    return !hasPending;
  }

  // Helper: Get booking
  Future<TableBooking> _getBooking(String bookingId) async {
    final response = await _supabase
        .from('club_table_bookings')
        .select()
        .eq('id', bookingId)
        .single();

    return TableBooking.fromSupabase(response);
  }

  // Helper: Get cancellation policy
  Future<CancellationPolicy> _getCancellationPolicy(TableBooking booking) async {
    try {
      // Try to get club-specific policy
      if (booking.clubId != null) {
        final response = await _supabase
            .from('cancellation_policies')
            .select()
            .eq('club_id', booking.clubId!)
            .eq('is_active', true)
            .maybeSingle();

        if (response != null) {
          return CancellationPolicy.fromSupabase(response);
        }
      }

      // Default to moderate policy
      return CancellationPolicy.moderate;
    } catch (e) {
      return CancellationPolicy.moderate;
    }
  }

  // Subscribe to modification updates
  RealtimeChannel subscribeToModifications(
    String bookingId,
    void Function(BookingModification) onUpdate,
  ) {
    return _supabase
        .channel('booking_modifications_$bookingId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'booking_modifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'booking_id',
            value: bookingId,
          ),
          callback: (payload) {
            if (payload.newRecord != null) {
              onUpdate(BookingModification.fromSupabase(payload.newRecord));
            }
          },
        )
        .subscribe();
  }
}
