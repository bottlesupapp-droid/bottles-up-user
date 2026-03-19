import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:bottles_up_user/core/config/payment_config.dart';

class PaymentService {

  static Future<void> init() async {
    Stripe.publishableKey = PaymentConfig.currentPublishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${PaymentConfig.stripeApiBaseUrl}/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${PaymentConfig.currentSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).round().toString(), // Convert to cents
          'currency': currency.toLowerCase(),
          'automatic_payment_methods[enabled]': 'true',
          if (description != null) 'description': description,
          if (metadata != null)
            ...metadata.map((key, value) => MapEntry('metadata[$key]', value.toString())),
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Payment intent creation failed: $e');
    }
  }

  static Future<bool> processPayment({
    required String clientSecret,
  }) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
      );
      return true;
    } catch (e) {
      throw Exception('Payment processing failed: $e');
    }
  }

  static Future<PaymentMethod> createPaymentMethod({
    required CardDetails cardDetails,
    BillingDetails? billingDetails,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      return paymentMethod;
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    String? merchantDisplayName,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName ?? PaymentConfig.merchantDisplayName,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF6366F1),
                  text: Color(0xFFFFFFFF),
                ),
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF6366F1),
                  text: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return false; // User canceled
      }
      throw Exception('Payment failed: ${e.error.message}');
    } catch (e) {
      throw Exception('Payment sheet presentation failed: $e');
    }
  }

  static Future<Map<String, dynamic>> retrievePaymentIntent(String paymentIntentId) async {
    try {
      final response = await http.get(
        Uri.parse('${PaymentConfig.stripeApiBaseUrl}/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer ${PaymentConfig.currentSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to retrieve payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Payment intent retrieval failed: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCustomerPaymentMethods(String customerId) async {
    try {
      final response = await http.get(
        Uri.parse('${PaymentConfig.stripeApiBaseUrl}/customers/$customerId/payment_methods?type=card'),
        headers: {
          'Authorization': 'Bearer ${PaymentConfig.currentSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get payment methods: ${response.body}');
      }
    } catch (e) {
      throw Exception('Payment methods retrieval failed: $e');
    }
  }

  static Future<Map<String, dynamic>> createCustomer({
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${PaymentConfig.stripeApiBaseUrl}/customers'),
        headers: {
          'Authorization': 'Bearer ${PaymentConfig.currentSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Customer creation failed: $e');
    }
  }
}