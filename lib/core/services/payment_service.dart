import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';

/// Payment service that integrates with Supabase Edge Functions
/// ALL payment processing is done via Supabase Edge Functions - NO hardcoded Stripe keys
/// Supports both in-app Payment Sheet (recommended) and browser checkout
class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current authenticated user
  User? get currentUser => _supabase.auth.currentUser;

  /// Create Payment Intent for in-app payment (Payment Sheet)
  /// This is the RECOMMENDED method - keeps users in the app
  Future<PaymentIntentResult> createPaymentIntent({
    required String paymentType,
    required double amount,
    String currency = 'usd',
    String? bookingId,
    String? eventId,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw PaymentException('User must be authenticated to create payment');
      }

      // Prepare payload for edge function
      final payload = {
        'user_id': user.id,
        'email': user.email,
        'payment_type': paymentType,
        'amount': (amount * 100).round(), // Convert to cents
        'currency': currency.toLowerCase(),
        if (description != null) 'description': description,
        if (bookingId != null) 'booking_id': bookingId,
        if (eventId != null) 'event_id': eventId,
        if (metadata != null) 'metadata': metadata,
      };

      // Call Supabase Edge Function
      final response = await _supabase.functions.invoke(
        'create-payment-intent',
        body: payload,
      );

      // Check for errors
      if (response.status != 200) {
        throw PaymentException(
          'Failed to create payment intent: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      final data = response.data as Map<String, dynamic>;

      // Validate response
      if (data['payment_intent'] == null || data['ephemeral_key'] == null) {
        throw PaymentException('Invalid response from payment server');
      }

      return PaymentIntentResult(
        paymentIntent: data['payment_intent'] as String,
        ephemeralKey: data['ephemeral_key'] as String,
        customer: data['customer'] as String,
        publishableKey: data['publishable_key'] as String?,
        transactionId: data['transaction_id'] as String?,
      );
    } on FunctionException catch (e) {
      throw PaymentException('Payment service error: ${e.details}');
    } catch (e) {
      throw PaymentException('Failed to create payment intent: $e');
    }
  }

  /// Present Payment Sheet for in-app payment
  /// Returns true if payment was successful
  Future<bool> presentPaymentSheet({
    required PaymentIntentResult paymentIntent,
    bool enableGooglePay = true,
    bool enableApplePay = true,
  }) async {
    try {
      // Initialize Stripe if needed
      if (paymentIntent.publishableKey != null) {
        Stripe.publishableKey = paymentIntent.publishableKey!;
        await Stripe.instance.applySettings();
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent.paymentIntent,
          merchantDisplayName: 'BottlesUp',
          customerEphemeralKeySecret: paymentIntent.ephemeralKey,
          customerId: paymentIntent.customer,
          style: ThemeMode.system,
          googlePay: enableGooglePay
              ? const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  currencyCode: 'USD',
                  testEnv: true,
                )
              : null,
          applePay: enableApplePay
              ? const PaymentSheetApplePay(
                  merchantCountryCode: 'US',
                )
              : null,
          allowsDelayedPaymentMethods: true,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      return true; // Payment successful
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw PaymentException('Payment cancelled by user');
      }
      throw PaymentException('Payment failed: ${e.error.message}');
    } catch (e) {
      throw PaymentException('Failed to process payment: $e');
    }
  }

  /// Create a checkout session via Supabase Edge Function
  /// Returns a checkout URL to redirect user to Stripe hosted checkout
  Future<PaymentCheckoutResult> createCheckoutSession({
    required String paymentType,
    required double amount,
    String currency = 'usd',
    String? bookingId,
    String? eventId,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw PaymentException('User must be authenticated to create payment');
      }

      // Prepare payload for edge function
      final payload = {
        'user_id': user.id,
        'email': user.email,
        'payment_type': paymentType,
        'amount': (amount * 100).round(), // Convert to cents
        'currency': currency.toLowerCase(),
        if (description != null) 'description': description,
        if (bookingId != null) 'booking_id': bookingId,
        if (eventId != null) 'event_id': eventId,
        if (metadata != null) 'metadata': metadata,
        // Success/cancel URLs for redirect after payment
        'success_url': 'bottlesup://payment/success',
        'cancel_url': 'bottlesup://payment/cancel',
      };

      // Call Supabase Edge Function
      final response = await _supabase.functions.invoke(
        'create-checkout-session',
        body: payload,
      );

      // Check for errors
      if (response.status != 200) {
        throw PaymentException(
          'Failed to create checkout session: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      final data = response.data as Map<String, dynamic>;

      // Validate response
      if (data['checkout_url'] == null || data['session_id'] == null) {
        throw PaymentException('Invalid response from payment server');
      }

      return PaymentCheckoutResult(
        checkoutUrl: data['checkout_url'] as String,
        sessionId: data['session_id'] as String,
        transactionId: data['transaction_id'] as String?,
      );
    } on FunctionException catch (e) {
      throw PaymentException('Payment service error: ${e.details}');
    } catch (e) {
      throw PaymentException('Failed to create checkout session: $e');
    }
  }

  /// Open Stripe checkout URL in browser
  Future<bool> openCheckoutUrl(String checkoutUrl) async {
    try {
      final uri = Uri.parse(checkoutUrl);

      if (!await canLaunchUrl(uri)) {
        throw PaymentException('Cannot open payment URL');
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Open in browser
      );

      return launched;
    } catch (e) {
      throw PaymentException('Failed to open checkout: $e');
    }
  }

  /// Check payment status from database
  /// Call this after user returns from Stripe checkout
  Future<PaymentStatus> checkPaymentStatus(String sessionId) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select('status, amount, payment_intent_id, created_at')
          .eq('stripe_session_id', sessionId)
          .maybeSingle();

      if (response == null) {
        return PaymentStatus(
          status: 'pending',
          message: 'Payment not found',
        );
      }

      return PaymentStatus(
        status: response['status'] as String,
        amount: (response['amount'] as num?)?.toDouble(),
        paymentIntentId: response['payment_intent_id'] as String?,
        createdAt: DateTime.tryParse(response['created_at'] as String? ?? ''),
        message: _getStatusMessage(response['status'] as String),
      );
    } catch (e) {
      throw PaymentException('Failed to check payment status: $e');
    }
  }

  /// Get payment transaction by booking ID
  Future<PaymentTransaction?> getPaymentByBookingId(String bookingId) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('booking_id', bookingId)
          .maybeSingle();

      if (response == null) return null;

      return PaymentTransaction.fromJson(response);
    } catch (e) {
      throw PaymentException('Failed to get payment: $e');
    }
  }

  /// Get user's payment history
  Future<List<PaymentTransaction>> getPaymentHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw PaymentException('User must be authenticated');
      }

      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => PaymentTransaction.fromJson(json))
          .toList();
    } catch (e) {
      throw PaymentException('Failed to get payment history: $e');
    }
  }

  /// Verify payment webhook (called by edge function after Stripe webhook)
  /// This is handled server-side, but included for completeness
  Future<void> refreshPaymentStatus(String transactionId) async {
    try {
      await _supabase.functions.invoke(
        'verify-payment',
        body: {'transaction_id': transactionId},
      );
    } catch (e) {
      // Non-critical - webhook should handle this
      // Silently fail - webhook will update status
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'success':
      case 'completed':
        return 'Payment successful';
      case 'pending':
        return 'Payment pending';
      case 'failed':
        return 'Payment failed';
      case 'cancelled':
      case 'canceled':
        return 'Payment cancelled';
      case 'refunded':
        return 'Payment refunded';
      default:
        return 'Unknown status';
    }
  }
}

/// Result from creating checkout session (browser-based)
class PaymentCheckoutResult {
  final String checkoutUrl;
  final String sessionId;
  final String? transactionId;

  PaymentCheckoutResult({
    required this.checkoutUrl,
    required this.sessionId,
    this.transactionId,
  });
}

/// Result from creating payment intent (in-app Payment Sheet)
class PaymentIntentResult {
  final String paymentIntent;
  final String ephemeralKey;
  final String customer;
  final String? publishableKey;
  final String? transactionId;

  PaymentIntentResult({
    required this.paymentIntent,
    required this.ephemeralKey,
    required this.customer,
    this.publishableKey,
    this.transactionId,
  });
}

/// Payment status result
class PaymentStatus {
  final String status;
  final String message;
  final double? amount;
  final String? paymentIntentId;
  final DateTime? createdAt;

  PaymentStatus({
    required this.status,
    required this.message,
    this.amount,
    this.paymentIntentId,
    this.createdAt,
  });

  bool get isPaid => status.toLowerCase() == 'paid' || status.toLowerCase() == 'success';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isCancelled => status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'canceled';
}

/// Payment transaction model
class PaymentTransaction {
  final String id;
  final String userId;
  final String? bookingId;
  final String? eventId;
  final double amount;
  final String currency;
  final String status;
  final String? stripeSessionId;
  final String? paymentIntentId;
  final String? paymentType;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PaymentTransaction({
    required this.id,
    required this.userId,
    this.bookingId,
    this.eventId,
    required this.amount,
    required this.currency,
    required this.status,
    this.stripeSessionId,
    this.paymentIntentId,
    this.paymentType,
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookingId: json['booking_id'] as String?,
      eventId: json['event_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'usd',
      status: json['status'] as String,
      stripeSessionId: json['stripe_session_id'] as String?,
      paymentIntentId: json['payment_intent_id'] as String?,
      paymentType: json['payment_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

/// Custom payment exception
class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);

  @override
  String toString() => message;
}