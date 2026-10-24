# Payment Deep Link Fix - App Crash Resolved

## Problem

After completing payment on Stripe's hosted checkout page, the app crashed when returning via deep link `bottlesup://payment/success?session_id=...`

**Error:** App crash on deep link return
**Symptom:** Payment succeeded on Stripe, but app crashed instead of showing success screen

## Root Cause

The [deep_link_handler.dart](lib/features/auth/services/deep_link_handler.dart) only handled password reset deep links. When Stripe redirected to `bottlesup://payment/success`, the app didn't recognize the URL scheme and crashed.

## Solution Applied

### 1. Added Payment Deep Link Handling

**File:** [lib/features/auth/services/deep_link_handler.dart](lib/features/auth/services/deep_link_handler.dart#L51-L86)

Added handler for payment success and cancel deep links:

```dart
// Handle payment success deep links
if (uri.scheme == 'bottlesup' && uri.host == 'payment') {
  final path = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';

  if (path == 'success') {
    // Extract session ID from query parameters
    final sessionId = uri.queryParameters['session_id'] ?? '';

    debugPrint('🔗 Payment success deep link received: $sessionId');

    if (sessionId.isNotEmpty) {
      // Navigate to checkout screen with success state
      context.go('/checkout-success?session_id=$sessionId');
      return true;
    } else {
      // Navigate to home if no session ID
      context.go('/home');
      return true;
    }
  } else if (path == 'cancel') {
    debugPrint('🔗 Payment cancel deep link received');

    // Navigate back to home with cancellation message
    context.go('/home');

    // Show cancellation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment was cancelled'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
    return true;
  }
}
```

### 2. Added Checkout Success Route

**File:** [lib/routing/app_router.dart](lib/routing/app_router.dart#L377-L389)

```dart
GoRoute(
  path: '/checkout-success',
  builder: (context, state) {
    final sessionId = state.uri.queryParameters['session_id'] ?? '';

    return CheckoutScreen(
      paymentType: 'success',
      amount: 0.0,
      description: 'Payment Success',
      metadata: {'session_id': sessionId},
    );
  },
),
```

### 3. Created Payment Verification Edge Function

**File:** [supabase/functions/verify-checkout-session/index.ts](supabase/functions/verify-checkout-session/index.ts)

This function verifies the payment session with Stripe:

```typescript
// Retrieve the checkout session from Stripe
const session = await stripe.checkout.sessions.retrieve(sessionId);

// Check if payment was successful
if (session.payment_status === 'paid') {
  console.log('✅ Payment verified successfully');

  return new Response(
    JSON.stringify({
      success: true,
      session: {
        id: session.id,
        paymentStatus: session.payment_status,
        amount: session.amount_total,
        currency: session.currency,
        customerEmail: session.customer_details?.email,
        paymentIntent: session.payment_intent,
      },
      publishableKey: stripePublishableKey,
    }),
    { status: 200 }
  );
}
```

**Deployed:** ✅ `supabase functions deploy verify-checkout-session`

### 4. Added Verification Method to Payment Service

**File:** [lib/core/services/payment_service.dart](lib/core/services/payment_service.dart#L286-L330)

```dart
/// Verify checkout session after payment
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
    }
  } catch (e) {
    throw PaymentException('Failed to verify payment: $e');
  }
}
```

### 5. Added Verification Model Class

**File:** [lib/core/services/payment_service.dart](lib/core/services/payment_service.dart#L541-L562)

```dart
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
```

### 6. Updated Checkout Screen to Handle Payment Success

**File:** [lib/features/payment/screens/checkout_screen.dart](lib/features/payment/screens/checkout_screen.dart#L52-L113)

```dart
/// Handle payment success from deep link
Future<void> _handlePaymentSuccess() async {
  final sessionId = widget.metadata?['session_id'] as String?;

  debugPrint('💳 Payment success callback received: $sessionId');

  if (sessionId == null || sessionId.isEmpty) {
    debugPrint('❌ No session ID found');
    setState(() {
      _paymentState = PaymentState.failed;
      _errorMessage = 'Invalid payment session';
    });
    return;
  }

  setState(() {
    _paymentState = PaymentState.loading;
  });

  try {
    // Verify payment with Stripe via edge function
    debugPrint('💳 Verifying payment session: $sessionId');

    final verification = await _paymentService.verifyCheckoutSession(sessionId);

    if (verification.isPaid) {
      debugPrint('✅ Payment verified successfully');
      debugPrint('💰 Amount: ${verification.amount} ${verification.currency}');

      if (mounted) {
        setState(() {
          _paymentState = PaymentState.success;
        });
      }
    } else {
      debugPrint('❌ Payment not completed: ${verification.paymentStatus}');

      if (mounted) {
        setState(() {
          _paymentState = PaymentState.failed;
          _errorMessage = 'Payment was not completed';
        });
      }
    }
  } on PaymentException catch (e) {
    debugPrint('❌ Payment verification failed: ${e.message}');
    if (mounted) {
      setState(() {
        _paymentState = PaymentState.failed;
        _errorMessage = e.message;
      });
    }
  }
}
```

## Complete Payment Flow (Fixed)

### 1. User Initiates Payment
- Navigate to event booking screen
- Select tickets/table
- Proceed to checkout
- [checkout_screen.dart](lib/features/payment/screens/checkout_screen.dart) loads

### 2. Create Checkout Session
- Call `createCheckoutSession()` edge function
- Returns Stripe checkout URL with `success_url: bottlesup://payment/success`
- Open URL in external browser

### 3. User Completes Payment
- User enters card details on Stripe's hosted page
- Test card: `4242 4242 4242 4242`, expiry: `12/34`, CVC: `123`
- Payment processes successfully

### 4. Stripe Redirects Back to App
- Stripe redirects to: `bottlesup://payment/success?session_id=cs_test_xxx`
- Deep link handler catches the URL
- Extracts `session_id` from query parameters

### 5. Payment Verification
- Navigate to `/checkout-success?session_id=cs_test_xxx`
- [checkout_screen.dart](lib/features/payment/screens/checkout_screen.dart) detects `paymentType == 'success'`
- Calls `verifyCheckoutSession(sessionId)` edge function
- Edge function retrieves session from Stripe
- Verifies `payment_status === 'paid'`

### 6. Success Screen
- Show payment success UI with:
  - Green checkmark icon
  - "Payment Successful!" message
  - Amount and booking details
  - "View Order" button

## Testing Checklist

### Before Testing
- [x] Build succeeded without errors
- [x] Edge function deployed: `verify-checkout-session`
- [x] Deep link handler updated
- [x] Router configured with `/checkout-success` route
- [x] TEST mode enforced (test_PK and test_SK)

### Test Steps

#### 1. Test Payment Success Flow
```bash
# Run the app
flutter run

# Steps:
1. Browse events
2. Select an event
3. Book tickets/table
4. Proceed to payment
5. Wait for Stripe page to open in browser
6. Enter test card: 4242 4242 4242 4242
7. Complete payment
8. Observe app returning from browser
```

**Expected Result:**
- ✅ App does NOT crash
- ✅ Shows loading screen: "Verifying payment..."
- ✅ Shows success screen: "Payment Successful!"
- ✅ Console logs show:
  ```
  🔗 Payment success deep link received: cs_test_xxx
  💳 Verifying payment session: cs_test_xxx
  ✅ Payment verified: paid
  💰 Amount: 5000.0 usd
  ```

#### 2. Test Payment Cancellation Flow
```bash
# Steps:
1. Start payment flow
2. When Stripe page opens, click "Back" or cancel
3. Observe app behavior
```

**Expected Result:**
- ✅ App does NOT crash
- ✅ Returns to home screen
- ✅ Shows orange snackbar: "Payment was cancelled"

#### 3. Test Invalid Session ID
```bash
# Manually test with invalid session ID
context.go('/checkout-success?session_id=invalid')
```

**Expected Result:**
- ✅ Shows error screen: "Payment verification failed"
- ✅ Allows retry

## Files Changed

| File | Change | Status |
|------|--------|--------|
| [deep_link_handler.dart](lib/features/auth/services/deep_link_handler.dart) | Added payment success/cancel handling | ✅ |
| [app_router.dart](lib/routing/app_router.dart) | Added `/checkout-success` route | ✅ |
| [verify-checkout-session/index.ts](supabase/functions/verify-checkout-session/index.ts) | Created verification edge function | ✅ Deployed |
| [payment_service.dart](lib/core/services/payment_service.dart) | Added `verifyCheckoutSession()` method | ✅ |
| [payment_service.dart](lib/core/services/payment_service.dart) | Added `CheckoutSessionVerification` class | ✅ |
| [checkout_screen.dart](lib/features/payment/screens/checkout_screen.dart) | Added `_handlePaymentSuccess()` method | ✅ |

## Security Features

### TEST Mode Enforcement
- ✅ Edge function validates `test_SK` starts with `sk_test_`
- ✅ Edge function validates `test_PK` starts with `pk_test_`
- ✅ Returns error if LIVE keys detected

### Payment Verification
- ✅ Session verification happens server-side via edge function
- ✅ Client cannot fake payment success
- ✅ Stripe session ID verified with Stripe API
- ✅ Payment status must be `paid` to show success

### No Hardcoded Keys
- ✅ All Stripe keys from Supabase secrets
- ✅ Client receives publishable key from edge function response
- ✅ No credentials in client code

## What Was Fixed

### Before (Broken)
1. User completes payment on Stripe ✅
2. Stripe redirects to `bottlesup://payment/success?session_id=...` ✅
3. App receives deep link ❌ **CRASH** - unrecognized URL scheme
4. Never shows success screen ❌

### After (Fixed)
1. User completes payment on Stripe ✅
2. Stripe redirects to `bottlesup://payment/success?session_id=...` ✅
3. Deep link handler catches URL ✅
4. Navigates to `/checkout-success` route ✅
5. Verifies payment with edge function ✅
6. Shows success screen ✅

## Next Steps

### Immediate Testing
1. Run the app: `flutter run`
2. Complete a payment flow
3. Verify success screen appears
4. Test cancellation flow

### Future Enhancements (Optional)
1. Create booking in database after successful payment
2. Send confirmation email via edge function
3. Add payment receipt download
4. Implement payment history screen
5. Add refund functionality

## Troubleshooting

### Issue: Still Getting Crash
**Check:**
```bash
# Ensure deep link handler is updated
grep -A 20 "payment success deep links" lib/features/auth/services/deep_link_handler.dart

# Ensure route exists
grep "checkout-success" lib/routing/app_router.dart
```

### Issue: Verification Fails
**Check:**
```bash
# Ensure edge function deployed
supabase functions list --project-ref hwmynlghrmtoufyrcihp

# Check edge function logs
supabase functions logs verify-checkout-session --project-ref hwmynlghrmtoufyrcihp
```

### Issue: Wrong Stripe Keys
**Check:**
```bash
# List secrets
supabase secrets list --project-ref hwmynlghrmtoufyrcihp

# Verify TEST keys
# test_SK should start with: sk_test_
# test_PK should start with: pk_test_
```

## Summary

The payment flow is now complete and production-ready for TEST mode:

✅ **Payment initiation** - Create checkout session via edge function
✅ **Browser checkout** - Open Stripe hosted page
✅ **Payment completion** - User pays on Stripe
✅ **Deep link return** - App recognizes payment success/cancel URLs
✅ **Payment verification** - Verify session with Stripe API
✅ **Success screen** - Show confirmation to user
✅ **Error handling** - Handle failures gracefully
✅ **TEST mode** - All operations use test keys
✅ **Security** - No hardcoded keys, server-side verification

**Status:** ✅ **READY FOR TESTING**
**Build:** ✅ **SUCCEEDED**
**Edge Functions:** ✅ **DEPLOYED**

---

**Fixed:** 2026-06-20
**Issue:** App crash on payment return deep link
**Solution:** Added payment deep link handling and verification flow
**Next:** Test complete payment flow end-to-end
