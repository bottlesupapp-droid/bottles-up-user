# Payment Stuck on "Creating Payment Session" - Troubleshooting

## Problem
App gets stuck on "Creating payment session..." screen and never proceeds to Stripe checkout page.

## Possible Causes

### 1. Edge Function Timeout
The `create-checkout-session` edge function might be timing out or failing silently.

### 2. Supabase Authentication Issue
The edge function requires authentication to get user details.

### 3. Missing Environment Variables
The edge function needs `test_SK` and `test_PK` secrets configured.

## Diagnostic Steps

### Step 1: Check Console Logs

Run the app and watch for these logs:

```bash
flutter run
```

**Expected logs:**
```
💳 Creating Stripe checkout session...
💳 Checkout session created: https://checkout.stripe.com/c/pay/cs_test_...
💳 Opening checkout URL: https://checkout.stripe.com/...
```

**If you see:**
```
💳 Creating Stripe checkout session...
❌ Payment error: ...
```
Then the edge function is failing.

### Step 2: Test Edge Function Directly

Test the edge function using curl:

```bash
# Get your access token
ACCESS_TOKEN="your_supabase_access_token"

curl -X POST \
  'https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/create-checkout-session' \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user-id",
    "email": "test@example.com",
    "payment_type": "event_general",
    "amount": 5000,
    "currency": "usd",
    "description": "Test Payment"
  }'
```

**Expected response:**
```json
{
  "success": true,
  "checkout_url": "https://checkout.stripe.com/c/pay/cs_test_...",
  "session_id": "cs_test_...",
  "transaction_id": "..."
}
```

### Step 3: Verify Secrets

Check Supabase secrets are configured:

```bash
supabase secrets list
```

**Required secrets:**
- `test_SK` - Should start with `sk_test_`
- `test_PK` - Should start with `pk_test_`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

### Step 4: Check Function Deployment

Verify the function is deployed and active:

```bash
supabase functions list
```

**Look for:**
```
create-checkout-session    | ACTIVE | 8 | 2026-06-20 19:58:50
```

## Quick Fixes

### Fix 1: Add Timeout to Function Call

The issue might be the function call hanging indefinitely. Let me add a timeout.

**File:** `lib/core/services/payment_service.dart`

Add timeout to the function call:

```dart
// Call Supabase Edge Function with timeout
final response = await _supabase.functions
    .invoke(
      'create-checkout-session',
      body: payload,
    )
    .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw PaymentException(
          'Payment session creation timed out. Please check your internet connection and try again.',
        );
      },
    );
```

### Fix 2: Add Better Error Logging

Add more detailed logging to see where it's failing:

```dart
try {
  debugPrint('💳 Calling edge function with payload: ${payload.keys.toList()}');

  final response = await _supabase.functions.invoke(
    'create-checkout-session',
    body: payload,
  );

  debugPrint('💳 Edge function response status: ${response.status}');
  debugPrint('💳 Edge function response data: ${response.data}');

  // Rest of code...
} catch (e, stackTrace) {
  debugPrint('❌ Error creating checkout session: $e');
  debugPrint('❌ Stack trace: $stackTrace');
  throw PaymentException('Failed to create checkout session: $e');
}
```

### Fix 3: Check User Authentication

Ensure the user is authenticated before calling the edge function:

```dart
final user = currentUser;
if (user == null) {
  debugPrint('❌ User not authenticated');
  throw PaymentException('User must be authenticated to create payment');
}

debugPrint('✅ User authenticated: ${user.email}');
```

### Fix 4: Redeploy Edge Function

Sometimes the edge function needs to be redeployed:

```bash
# Redeploy the function
supabase functions deploy create-checkout-session --project-ref hwmynlghrmtoufyrcihp

# Verify deployment
supabase functions list
```

## Common Issues

### Issue 1: Function Returns 401 Unauthorized

**Cause:** User not authenticated or invalid session

**Fix:**
1. Ensure user is logged in
2. Check Supabase client has valid session
3. Verify Authorization header is being sent

### Issue 2: Function Returns 500 Internal Server Error

**Cause:** Edge function error (missing secrets, Stripe API error, etc.)

**Fix:**
1. Check edge function logs (via Supabase dashboard)
2. Verify Stripe test keys are valid
3. Check Stripe account status

### Issue 3: Function Times Out

**Cause:** Slow network or Stripe API delay

**Fix:**
1. Add timeout handling (see Fix 1 above)
2. Show retry option to user
3. Check internet connection

### Issue 4: Invalid Amount

**Cause:** Amount is 0 or negative

**Fix:**
```dart
if (amount <= 0) {
  throw PaymentException('Invalid payment amount: \$${amount.toStringAsFixed(2)}');
}

debugPrint('💳 Payment amount: \$${amount.toStringAsFixed(2)} (${(amount * 100).round()} cents)');
```

## Debugging Checklist

- [ ] User is authenticated
- [ ] Edge function is deployed
- [ ] Secrets are configured (test_SK, test_PK)
- [ ] Amount is valid (> 0)
- [ ] Internet connection is working
- [ ] Supabase client is initialized
- [ ] Console shows error message
- [ ] Edge function logs checked (Supabase dashboard)

## If Still Stuck

Check these files for console output:

1. **Flutter app logs:**
   ```bash
   flutter run 2>&1 | tee payment-debug.log
   ```

2. **Edge function logs:**
   - Go to: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/functions
   - Click on `create-checkout-session`
   - View logs tab

3. **Stripe dashboard:**
   - Go to: https://dashboard.stripe.com/test/logs
   - Check for API calls

## Temporary Workaround

If edge function is failing, you can test with a hardcoded checkout URL:

```dart
// TEMPORARY DEBUG ONLY - Remove after testing
if (true) {
  debugPrint('⚠️ Using test mode - skipping edge function');

  return PaymentCheckoutResult(
    checkoutUrl: 'https://checkout.stripe.com/c/pay/cs_test_YOUR_SESSION_ID',
    sessionId: 'cs_test_YOUR_SESSION_ID',
    transactionId: null,
  );
}
```

This will let you test the deep link return flow while debugging the edge function.

---

**Created:** 2026-06-20
**Issue:** Payment stuck on "Creating payment session"
**Status:** Investigating
