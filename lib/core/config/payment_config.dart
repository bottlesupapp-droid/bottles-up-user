/// Payment configuration for the Bottles Up app
/// SECURITY: All sensitive keys loaded from environment variables
/// NO hardcoded secrets - Stripe secret keys NEVER belong in client code
class PaymentConfig {
  // Stripe Publishable Key (client-safe, loaded from environment)
  // CRITICAL: Only publishable key is allowed client-side
  // Secret keys must ONLY exist server-side in Supabase Edge Functions
  static String get stripePublishableKey {
    const key = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    if (key.isEmpty) {
      throw StateError(
        'STRIPE_PUBLISHABLE_KEY not configured. '
        'Pass --dart-define=STRIPE_PUBLISHABLE_KEY=pk_... when building.',
      );
    }
    return key;
  }

  // REMOVED: stripeSecretKey - SECRET KEYS MUST NEVER EXIST IN MOBILE APPS
  // All server operations (PaymentIntents, refunds, etc.) are handled by
  // Supabase Edge Functions: create-payment-intent, create-checkout-session, stripe-webhook

  // Stripe API Base URL (not used - all API calls via Supabase Edge Functions)
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
  
  // Get current publishable key (always from environment)
  static String get currentPublishableKey => stripePublishableKey;

  // REMOVED: currentSecretKey getter
  // Secret keys must NEVER be accessed from client code
  // All secret operations handled by Supabase Edge Functions
}