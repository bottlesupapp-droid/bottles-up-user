import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottles_up_user/core/services/payment_service.dart';
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
  PaymentNotifier() : super(PaymentState());

  Future<PaymentIntent?> createPaymentIntent({
    required double amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final paymentIntentData = await PaymentService.createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
        metadata: metadata,
      );
      
      final paymentIntent = PaymentIntent.fromJson(paymentIntentData);
      
      state = state.copyWith(
        isLoading: false,
        currentPaymentIntent: paymentIntent,
      );
      
      return paymentIntent;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<bool> processPayment({
    required String clientSecret,
    String? merchantDisplayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final success = await PaymentService.presentPaymentSheet(
        clientSecret: clientSecret,
        merchantDisplayName: merchantDisplayName,
      );
      
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
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