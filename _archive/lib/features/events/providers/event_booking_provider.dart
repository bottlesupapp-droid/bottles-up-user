import 'package:bottles_up_user/features/events/models/event.dart';
import 'package:bottles_up_user/features/bookings/providers/user_bookings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/event_rsvp.dart';
import '../services/event_booking_service.dart';
import '../services/email_service.dart';
import '../providers/event_provider.dart';

part 'event_booking_provider.g.dart';

// Booking option state
enum BookingOption { guestlist, table, ticket }

// Event booking state
@riverpod
class EventBookingState extends _$EventBookingState {
  @override
  BookingOption build() => BookingOption.guestlist;

  void setBookingOption(BookingOption option) {
    state = option;
  }
}

// Event configuration provider
@riverpod
Future<EventConfiguration?> eventConfiguration(
  EventConfigurationRef ref,
  String eventId,
) async {
  return await EventBookingService().getEventConfiguration(eventId);
}

// Available tables provider
@riverpod
Future<List<Map<String, dynamic>>> availableTables(
  AvailableTablesRef ref,
  String eventId,
) async {
  return await EventBookingService().getAvailableTables(eventId);
}

// Available bottles provider
@riverpod
Future<List<Map<String, dynamic>>> availableBottles(
  AvailableBottlesRef ref,
  String eventId,
) async {
  return await EventBookingService().getAvailableBottles(eventId);
}

// User's existing RSVP provider
@riverpod
Future<EventRSVP?> userEventRSVP(
  UserEventRSVPRef ref,
  String eventId,
) async {
  return await EventBookingService().getUserRSVP(eventId);
}

// User's existing table booking provider
@riverpod
Future<EventTableBooking?> userEventTableBooking(
  UserEventTableBookingRef ref,
  String eventId,
) async {
  return await EventBookingService().getUserTableBooking(eventId);
}

// RSVP form state
@riverpod
class RSVPFormState extends _$RSVPFormState {
  @override
  RSVPFormData build() => const RSVPFormData();

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void updateSpecialRequests(String? specialRequests) {
    state = state.copyWith(specialRequests: specialRequests);
  }

  bool isValid() {
    return state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.email.isNotEmpty &&
        _isValidEmail(state.email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void reset() {
    state = const RSVPFormData();
  }
}

// Table booking form state
@riverpod
class TableBookingFormState extends _$TableBookingFormState {
  @override
  TableBookingFormData build() => const TableBookingFormData();

  void selectTable(Map<String, dynamic> table) {
    state = state.copyWith(selectedTable: table);
  }

  void updatePartySize(int partySize) {
    // Adjust guest names list to match party size
    final currentGuestNames = List<String>.from(state.guestNames);

    // If reducing party size, trim guest names
    if (partySize < currentGuestNames.length) {
      currentGuestNames.removeRange(partySize, currentGuestNames.length);
    }

    state = state.copyWith(
      partySize: partySize,
      guestNames: currentGuestNames,
    );
  }

  void updateSpecialRequests(String? specialRequests) {
    state = state.copyWith(specialRequests: specialRequests);
  }

  void updateGuestNames(List<String> guestNames) {
    state = state.copyWith(guestNames: guestNames);
  }

  void setEnableSplitPayment(bool enable) {
    state = state.copyWith(enableSplitPayment: enable);
    if (!enable) {
      // Reset split payment data
      state = state.copyWith(
        splitPaymentParticipants: [],
      );
    }
  }

  void updateSplitPaymentParticipants(List<SplitPaymentParticipant> participants) {
    state = state.copyWith(splitPaymentParticipants: participants);
  }

  void updateBottleQuantity(String bottleId, int quantity) {
    final updatedBottles = Map<String, int>.from(state.selectedBottles);
    if (quantity <= 0) {
      updatedBottles.remove(bottleId);
    } else {
      updatedBottles[bottleId] = quantity;
    }
    state = state.copyWith(selectedBottles: updatedBottles);
  }

  void clearBottleSelection() {
    state = state.copyWith(selectedBottles: {});
  }

  double calculateBottlesTotal(List<Map<String, dynamic>> availableBottles) {
    double total = 0.0;
    for (final bottleId in state.selectedBottles.keys) {
      final quantity = state.selectedBottles[bottleId] ?? 0;
      final bottle = availableBottles.firstWhere(
        (b) => b['id'] == bottleId,
        orElse: () => {},
      );
      if (bottle.isNotEmpty) {
        final price = bottle['price'] as double? ?? 0.0;
        total += price * quantity;
      }
    }
    return total;
  }

  bool isValid() {
    return state.selectedTable != null &&
        state.partySize >= 1 &&
        state.partySize <= (state.selectedTable?['capacity'] ?? 10);
  }

  void reset() {
    state = const TableBookingFormData();
  }
}

// Form data classes
class RSVPFormData {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? specialRequests;

  const RSVPFormData({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone,
    this.specialRequests,
  });

  RSVPFormData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? specialRequests,
  }) {
    return RSVPFormData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}

class TableBookingFormData {
  final Map<String, dynamic>? selectedTable;
  final int partySize;
  final String? specialRequests;
  final bool enableSplitPayment;
  final List<SplitPaymentParticipant> splitPaymentParticipants;
  final Map<String, int> selectedBottles; // bottle_id -> quantity
  final List<String> guestNames; // List of guest names

  const TableBookingFormData({
    this.selectedTable,
    this.partySize = 2,
    this.specialRequests,
    this.enableSplitPayment = false,
    this.splitPaymentParticipants = const [],
    this.selectedBottles = const {},
    this.guestNames = const [],
  });

  TableBookingFormData copyWith({
    Map<String, dynamic>? selectedTable,
    int? partySize,
    String? specialRequests,
    bool? enableSplitPayment,
    List<SplitPaymentParticipant>? splitPaymentParticipants,
    Map<String, int>? selectedBottles,
    List<String>? guestNames,
  }) {
    return TableBookingFormData(
      selectedTable: selectedTable ?? this.selectedTable,
      partySize: partySize ?? this.partySize,
      specialRequests: specialRequests ?? this.specialRequests,
      enableSplitPayment: enableSplitPayment ?? this.enableSplitPayment,
      splitPaymentParticipants: splitPaymentParticipants ?? this.splitPaymentParticipants,
      selectedBottles: selectedBottles ?? this.selectedBottles,
      guestNames: guestNames ?? this.guestNames,
    );
  }
}

// Booking submission providers
@riverpod
class RSVPSubmission extends _$RSVPSubmission {
  @override
  AsyncValue<EventRSVP?> build() => const AsyncValue.data(null);

  Future<void> submitRSVP(String eventId, RSVPFormData formData) async {
    state = const AsyncValue.loading();

    try {
      // Validate required fields
      if (formData.firstName.isEmpty || formData.lastName.isEmpty || formData.email.isEmpty) {
        throw Exception('Please fill in all required fields');
      }

      // Create RSVP
      final rsvp = await EventBookingService().createGuestlistRSVP(
        eventId: eventId,
        firstName: formData.firstName.trim(),
        lastName: formData.lastName.trim(),
        email: formData.email.trim().toLowerCase(),
        phone: formData.phone?.trim(),
        specialRequests: formData.specialRequests?.trim(),
      );

      // Send pending confirmation email
      try {
        // Get event details for email
        final eventDetails = await ref.read(eventByIdProvider(eventId).future);
        if (eventDetails != null && rsvp.verificationCode != null) {
          await EmailService().sendRSVPPendingEmail(
            to: formData.email.trim().toLowerCase(),
            customerName: '${formData.firstName.trim()} ${formData.lastName.trim()}',
            eventName: eventDetails.name,
            eventDate: eventDetails.formattedDate,
            eventTime: eventDetails.formattedTime,
            venue: eventDetails.venueDisplay,
            verificationCode: rsvp.verificationCode!,
          );
        }
      } catch (emailError) {
        // Email failure shouldn't prevent successful RSVP
      }

      // Invalidate related providers to refresh data
      ref.invalidate(userEventRSVPProvider);
      ref.invalidate(userBookingsProvider);

      state = AsyncValue.data(rsvp);
    } catch (error, stackTrace) {
      // Log error details for debugging
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class TableBookingSubmission extends _$TableBookingSubmission {
  @override
  AsyncValue<EventTableBooking?> build() => const AsyncValue.data(null);

  Future<void> submitTableBooking(String eventId, TableBookingFormData formData) async {
    state = const AsyncValue.loading();

    try {
      if (formData.selectedTable == null) {
        throw Exception('No table selected');
      }

      final booking = await EventBookingService().createTableBooking(
        eventId: eventId,
        tableId: formData.selectedTable!['id'],
        partySize: formData.partySize,
        depositAmount: formData.selectedTable!['deposit_amount'].toDouble(),
        minimumBottles: formData.selectedTable!['minimum_bottles'],
        specialRequests: formData.specialRequests,
        splitPayments: formData.enableSplitPayment ? formData.splitPaymentParticipants : null,
      );

      // Invalidate related providers to refresh data
      ref.invalidate(userEventTableBookingProvider);
      ref.invalidate(userBookingsProvider);

      state = AsyncValue.data(booking);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}