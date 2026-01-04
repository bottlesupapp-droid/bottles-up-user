/// Payment configuration for the Bottles Up app
/// Contains Stripe API keys and payment settings
class PaymentConfig {
  // Stripe API Keys
  // Live Keys (get proper publishable key from Stripe dashboard)
  static const String stripePublishableKey = 'pk_live_51RG48ACAp3BDUztNna3vtSxo6XSUd1eU9LV3Mu1j88rwvyoOePTxC0Fg7B41RoCa4uRZsgGHG2Io4VBt1S9GKNyR002ATpwcyK';
  static const String stripeSecretKey = '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';

  // Test Keys for development (replace with your actual test keys)
  static const String stripeTestPublishableKey = 'pk_test_51H7GWUBk8jNkJoAZ8f4MQjZaXUvZkLGFJNVQyGkFkqfGBPjZnCvyQUXJkZP2Jf3F5GkJNV4Q1JfGBPjZnCvyQUXJkZP2';
  static const String stripeTestSecretKey = 'sk_test_51H7GWUBk8jNkJoAZ8f4MQjZaXUvZkLGFJNVQyGkFkqfGBPjZnCvyQUXJkZP2Jf3F5GkJNV4Q1JfGBPjZnCvyQUXJkZP2';
  
  // Stripe API Base URL
  static const String stripeApiBaseUrl = 'https://api.stripe.com/v1';
  
  // Default currency
  static const String defaultCurrency = 'USD';
  
  // Merchant display name
  static const String merchantDisplayName = 'Bottles Up';
  
  // Default pricing (can be overridden)
  static const double defaultTableBookingPrice = 150.0;
  static const double defaultEventTicketPrice = 50.0;
  static const double defaultBottleServicePrice = 200.0;
  static const double defaultMembershipPrice = 99.0;
  
  // Payment processing settings
  static const int paymentTimeoutSeconds = 30;
  static const bool enableApplePay = true;
  static const bool enableGooglePay = true;
  
  // Test mode settings (for development)
  static const bool isTestMode = false; // Set to true for testing
  
  // Test card numbers for Stripe testing
  static const Map<String, String> testCards = {
    'success': '4242424242424242',
    'decline': '4000000000000002',
    'insufficient_funds': '4000000000009995',
    'expired': '4000000000000069',
    'cvc_fail': '4000000000000127',
  };
  
  // Payment method types to accept
  static const List<String> acceptedPaymentMethods = [
    'card',
    'apple_pay',
    'google_pay',
  ];
  
  // Supported currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
  ];
  
  // Payment description templates
  static String getPaymentDescription(String type, String details) {
    switch (type.toLowerCase()) {
      case 'table':
        return 'Table Booking - $details';
      case 'event':
        return 'Event Ticket - $details';
      case 'bottle':
        return 'Bottle Service - $details';
      case 'membership':
        return 'Membership - $details';
      default:
        return 'Bottles Up - $details';
    }
  }
  
  // Get appropriate Stripe keys based on test mode
  static String get currentPublishableKey {
    if (isTestMode) {
      return stripeTestPublishableKey;
    }
    return stripePublishableKey;
  }

  static String get currentSecretKey {
    if (isTestMode) {
      return stripeTestSecretKey;
    }
    return stripeSecretKey;
  }
}