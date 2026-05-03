import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottles_up_user/core/services/payment_service.dart' as service;
import 'package:bottles_up_user/core/models/payment_models.dart';

class PaymentState {
  final bool isLoading;
  final String? error;
  final PaymentIntent? currentPaymentIntent;
  final List<BookingPayment> paymentHistory;

  PaymentState({
    this.isLoading = false,
    this.error,
    this.currentPaymentIntent,
    this.paymentHistory = const [],
  });

  PaymentState copyWith({
    bool? isLoading,
    String? error,
    PaymentIntent? currentPaymentIntent,
    List<BookingPayment>? paymentHistory,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPaymentIntent: currentPaymentIntent ?? this.currentPaymentIntent,
      paymentHistory: paymentHistory ?? this.paymentHistory,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final service.PaymentService _paymentService = service.PaymentService();
  PaymentNotifier() : super(PaymentState());

  Future<service.PaymentCheckoutResult?> createCheckoutSession({
    required String paymentType,
    required double amount,
    String? bookingId,
    String? eventId,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _paymentService.createCheckoutSession(
        paymentType: paymentType,
        amount: amount,
        bookingId: bookingId,
        eventId: eventId,
        description: description,
        metadata: metadata,
      );
      
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<bool> openCheckoutUrl(String url) async {
    try {
      return await _paymentService.openCheckoutUrl(url);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<service.PaymentStatus?> checkStatus(String sessionId) async {
    try {
      return await _paymentService.checkPaymentStatus(sessionId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearCurrentPaymentIntent() {
    state = state.copyWith(currentPaymentIntent: null);
  }

  void addPaymentToHistory(BookingPayment payment) {
    final updatedHistory = [...state.paymentHistory, payment];
    state = state.copyWith(paymentHistory: updatedHistory);
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(),
);