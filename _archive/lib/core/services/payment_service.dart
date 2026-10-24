import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:bottles_up_user/core/config/payment_config.dart';

// Channel registered in SceneDelegate.swift — calls makeKeyAndVisible() so
// that stripe_ios finds a UIViewController that is in the window hierarchy.
const _stripeHelper = MethodChannel('bottles_up/stripe_helper');

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
      // Re-apply Stripe settings if the edge function returned the key.
      if (paymentIntent.publishableKey != null) {
        final publishableKey = paymentIntent.publishableKey!;
        final mode = publishableKey.startsWith('pk_live_') ? 'LIVE' : 'TEST';
        debugPrint('✅ Using $mode mode Stripe key: ${publishableKey.substring(0, 20)}...');
        Stripe.publishableKey = publishableKey;
        // urlScheme only — merchantIdentifier is intentionally omitted because
        // Apple Pay requires a registered Apple Pay merchant + entitlement file.
        // Setting merchantIdentifier without those entitlements causes internal
        // Apple Pay validation to hang on iOS.
        Stripe.urlScheme = 'bottlesup';
        await Stripe.instance.applySettings();
      }

      debugPrint('💳 Initializing payment sheet...');
      debugPrint('💳 Payment Intent: ${paymentIntent.paymentIntent.substring(0, 20)}...');
      debugPrint('💳 Customer: ${paymentIntent.customer}');
      debugPrint('💳 Ephemeral Key: ${paymentIntent.ephemeralKey?.substring(0, 20)}...');

      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent.paymentIntent,
            merchantDisplayName: 'Bottles Up',
            // customerId + customerEphemeralKeySecret intentionally omitted.
            // When set, Stripe activates the Link Card integration on iOS.
            // If Link's network initialization fails (common in test mode and
            // some network conditions), the payment sheet freezes with:
            // "PaymentSheet could not offer the Link Card integration."
            // and the completion handler never fires. Removing these fields
            // disables Link entirely — users enter card details each time,
            // which is the correct behaviour for go-live without saved cards.
            style: ThemeMode.dark,
            // returnURL is REQUIRED on iOS for any payment that opens an external
            // URL (3D Secure, bank redirects). Without it, Stripe opens Safari but
            // can never return to the app — presentPaymentSheet freezes forever.
            returnURL: 'bottlesup://payment/return',
            googlePay: enableGooglePay
                ? PaymentSheetGooglePay(
                    merchantCountryCode: 'US',
                    currencyCode: 'USD',
                    testEnv: !(paymentIntent.publishableKey?.startsWith('pk_live_') ?? false),
                  )
                : null,
            // Apple Pay disabled until Apple Pay merchant ID is registered in
            // Apple Developer Portal and the entitlement is added to Runner.
            applePay: null,
            allowsDelayedPaymentMethods: false,
          ),
        );
        debugPrint('💳 Payment sheet initialized successfully!');
      } catch (e) {
        debugPrint('❌ initPaymentSheet() failed: $e');
        rethrow;
      }

      debugPrint('💳 Presenting payment sheet now...');

      // Wait for Flutter's page-push animation to fully complete (300 ms)
      // before layering the native Stripe modal on top.
      await Future.delayed(const Duration(milliseconds: 400));

      // iOS: call makeKeyAndVisible() via SceneDelegate before stripe_ios
      // tries to find a UIViewController to present on. Without this the
      // FlutterViewController's view can be temporarily detached from the
      // window hierarchy during a Flutter navigation transition, causing
      // UIKit to log "whose view is not in the window hierarchy" and the
      // Stripe completion handler to never fire → presentPaymentSheet hangs.
      if (Platform.isIOS) {
        try {
          await _stripeHelper.invokeMethod('prepareForPayment');
          debugPrint('💳 iOS window prepared for Stripe presentation');
          // Small pause after makeKeyAndVisible so UIKit finishes layout.
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          debugPrint('⚠️ prepareForPayment channel error (non-fatal): $e');
        }
      }

      // Race the sheet completion against a 90-second polling fallback.
      // The poll hits Stripe's API directly every 3 s so that even if the
      // native → Dart channel callback is delayed the booking still lands.
      final paymentIntentId = paymentIntent.paymentIntent.split('_secret_').first;
      final publishableKey = paymentIntent.publishableKey ?? PaymentConfig.stripePublishableKey;

      try {
        final result = await Future.any([
          Stripe.instance.presentPaymentSheet().then((_) => 'sheet_done'),
          _pollPaymentIntentStatus(
            paymentIntentId: paymentIntentId,
            publishableKey: publishableKey,
            timeout: const Duration(seconds: 90),
          ),
        ]);

        if (result == 'sheet_done' || result == 'succeeded') {
          debugPrint('💳 Payment confirmed via: $result');
          return true;
        }
        throw PaymentException('Payment cancelled by user');
      } catch (e) {
        if (e is PaymentException) rethrow;
        debugPrint('❌ presentPaymentSheet() error: $e');
        rethrow;
      }
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

      debugPrint('💳 Calling edge function: create-checkout-session');
      debugPrint('💳 Payload: user_id=${user.id}, email=${user.email}, amount=\$${amount.toStringAsFixed(2)}');

      // Retry up to 3 times with a 30-second per-attempt timeout.
      // Edge Functions can cold-start slowly on Supabase free tier.
      FunctionResponse? response;
      PaymentException? lastError;
      for (int attempt = 1; attempt <= 3; attempt++) {
        try {
          debugPrint('💳 Attempt $attempt/3 calling edge function...');
          response = await _supabase.functions
              .invoke('create-checkout-session', body: payload)
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  debugPrint('⏳ Attempt $attempt timed out after 30s, retrying...');
                  throw TimeoutException('Edge function cold-start timeout');
                },
              );
          break; // Success — exit retry loop
        } on TimeoutException {
          lastError = PaymentException(
            'Payment session creation timed out after 3 attempts.\nPlease check your connection and try again.',
          );
          if (attempt < 3) await Future.delayed(const Duration(seconds: 2));
        } on FunctionException catch (e) {
          // Non-retriable server error
          throw PaymentException('Payment service error: ${e.details}');
        }
      }

      if (response == null) throw lastError!;

      debugPrint('💳 Edge function response status: ${response.status}');

      // Check for errors
      if (response.status != 200) {
        final errorMsg = response.data?['error'] ?? 'Unknown error';
        debugPrint('❌ Edge function error: $errorMsg');
        throw PaymentException(
          'Failed to create checkout session: $errorMsg',
        );
      }

      final data = response.data as Map<String, dynamic>;
      debugPrint('💳 Response data keys: ${data.keys.toList()}');

      // Validate response
      if (data['checkout_url'] == null || data['session_id'] == null) {
        debugPrint('❌ Invalid response: missing checkout_url or session_id');
        throw PaymentException('Invalid response from payment server');
      }

      debugPrint('✅ Checkout session created successfully');

      return PaymentCheckoutResult(
        checkoutUrl: data['checkout_url'] as String,
        sessionId: data['session_id'] as String,
        transactionId: data['transaction_id'] as String?,
      );
    } on FunctionException catch (e) {
      debugPrint('❌ FunctionException: ${e.details}');
      throw PaymentException('Payment service error: ${e.details}');
    } on PaymentException {
      rethrow; // Re-throw PaymentException as-is
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      throw PaymentException('Failed to create checkout session: $e');
    }
  }

  /// Open Stripe checkout page in browser
  Future<void> openCheckoutPage(String checkoutUrl) async {
    try {
      debugPrint('💳 Opening checkout URL: $checkoutUrl');

      // Import url_launcher package
      final Uri url = Uri.parse(checkoutUrl);

      // Try to launch the URL
      if (await canLaunchUrl(url)) {
        final launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Open in external browser
        );

        if (!launched) {
          throw PaymentException('Could not open payment page. Please try again.');
        }
      } else {
        throw PaymentException('Could not open payment page. Invalid URL.');
      }
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentException('Failed to open payment page: $e');
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

  /// Verify checkout session after payment
  /// Call this when user returns from Stripe checkout page
  Future<CheckoutSessionVerification> verifyCheckoutSession(String sessionId) async {
    try {
      debugPrint('💳 Verifying checkout session: $sessionId');

      final response = await _supabase.functions.invoke(
        'verify-checkout-session',
        body: {'sessionId': sessionId},
      );

      if (response.status != 200) {
        throw PaymentException(
          'Failed to verify payment: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final sessionData = data['session'] as Map<String, dynamic>;

        debugPrint('✅ Payment verified: ${sessionData['paymentStatus']}');

        return CheckoutSessionVerification(
          success: true,
          sessionId: sessionData['id'] as String,
          paymentStatus: sessionData['paymentStatus'] as String,
          amount: (sessionData['amount'] as num?)?.toDouble(),
          currency: sessionData['currency'] as String?,
          customerEmail: sessionData['customerEmail'] as String?,
          paymentIntent: sessionData['paymentIntent'] as String?,
        );
      } else {
        throw PaymentException(data['error'] ?? 'Payment verification failed');
      }
    } on FunctionException catch (e) {
      debugPrint('❌ Verification error: ${e.details}');
      throw PaymentException('Payment verification failed: ${e.details}');
    } catch (e) {
      debugPrint('❌ Verification error: $e');
      if (e is PaymentException) rethrow;
      throw PaymentException('Failed to verify payment: $e');
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

  /// iOS: confirm a payment using card details entered in a mounted CardFormField.
  ///
  /// This bypasses the native payment sheet entirely, using flutter_stripe's
  /// confirmPayment API which reads card data from the active CardFormField
  /// widget rendered in Flutter UI. This avoids the UISheetPresentationController
  /// completion-handler bug that causes presentPaymentSheet to hang on iOS.
  Future<bool> confirmPaymentWithCard({
    required PaymentIntentResult paymentIntent,
    String? userEmail,
  }) async {
    try {
      if (paymentIntent.publishableKey != null) {
        final key = paymentIntent.publishableKey!;
        final mode = key.startsWith('pk_live_') ? 'LIVE' : 'TEST';
        debugPrint('✅ confirmPayment using $mode Stripe key');
        Stripe.publishableKey = key;
        Stripe.urlScheme = 'bottlesup';
        await Stripe.instance.applySettings();
      }

      debugPrint('💳 [iOS] confirmPayment via CardFormField...');

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent.paymentIntent,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: userEmail != null
                ? BillingDetails(email: userEmail)
                : null,
          ),
        ),
      );

      debugPrint('💳 [iOS] confirmPayment succeeded');
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw PaymentException('Payment cancelled by user');
      }
      throw PaymentException('Payment failed: ${e.error.message}');
    } catch (e) {
      throw PaymentException('Failed to process payment: $e');
    }
  }

  /// iOS fallback: poll Stripe's API directly for payment intent status.
  ///
  /// flutter_stripe's presentPaymentSheet() can hang on iOS when dynamic
  /// framework linkage silently drops the completion handler. This poller
  /// resolves the race in Future.any() when the sheet result never fires.
  ///
  /// Returns 'succeeded', 'cancelled', or throws on hard timeout.
  Future<String> _pollPaymentIntentStatus({
    required String paymentIntentId,
    required String publishableKey,
    required Duration timeout,
  }) async {
    final deadline = DateTime.now().add(timeout);
    const pollInterval = Duration(seconds: 3);

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(pollInterval);

      try {
        final response = await http.get(
          Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
          headers: {'Authorization': 'Bearer $publishableKey'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final status = data['status'] as String?;
          debugPrint('💳 [poll] PaymentIntent status: $status');

          if (status == 'succeeded') return 'succeeded';
          if (status == 'canceled') return 'cancelled';
          // requires_payment_method / requires_confirmation / processing — keep polling
        }
      } catch (e) {
        debugPrint('💳 [poll] error checking status: $e');
      }
    }

    // Timed out — user likely closed the sheet without paying
    throw PaymentException('Payment timed out. Please try again.');
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

/// Checkout session verification result
class CheckoutSessionVerification {
  final bool success;
  final String sessionId;
  final String paymentStatus;
  final double? amount;
  final String? currency;
  final String? customerEmail;
  final String? paymentIntent;

  CheckoutSessionVerification({
    required this.success,
    required this.sessionId,
    required this.paymentStatus,
    this.amount,
    this.currency,
    this.customerEmail,
    this.paymentIntent,
  });

  bool get isPaid => paymentStatus == 'paid';
}

/// Custom payment exception
class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);

  @override
  String toString() => message;
}