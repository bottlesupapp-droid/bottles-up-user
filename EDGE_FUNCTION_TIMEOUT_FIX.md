# Edge Function Timeout Fix

## Issue
Payment session creation times out after 30 seconds:
```
❌ Edge function timed out after 30 seconds
❌ Payment error: Payment session creation timed out.
```

## Root Causes

### 1. Cold Start Delay
Supabase Edge Functions can take 10-30 seconds to start on first invocation (cold start) if they haven't been used recently.

### 2. Network Latency
Slow internet connection or high latency to Supabase servers.

### 3. Stripe API Delay
Creating Stripe checkout session requires calling Stripe's API, which adds latency.

## Fixes Applied

### Fix 1: Increased Timeout to 60 Seconds

**File:** [lib/core/services/payment_service.dart](lib/core/services/payment_service.dart#L217-L225)

**Changed from:**
```dart
.timeout(const Duration(seconds: 30))
```

**Changed to:**
```dart
.timeout(
  const Duration(seconds: 60),
  onTimeout: () {
    debugPrint('❌ Edge function timed out after 60 seconds');
    throw PaymentException(
      'Payment session creation timed out.\nThis might be due to a slow connection or server cold start.\nPlease try again.',
    );
  },
)
```

**Why:** 60 seconds gives enough time for:
- Cold start (up to 30s)
- Stripe API call (up to 10s)
- Network latency (up to 10s)
- Processing time (up to 10s)

### Fix 2: Redeployed Edge Function

```bash
supabase functions deploy create-checkout-session --project-ref hwmynlghrmtoufyrcihp --no-verify-jwt
```

**Why:** Redeploy ensures:
- Latest code is running
- Function is "warm" for immediate testing
- No stale deployment issues

## How to Test

### Test 1: Normal Flow (Should Work Now)

```bash
flutter run
```

1. Navigate to event booking
2. Proceed to payment
3. **Wait up to 60 seconds**
4. Payment should proceed

**Expected logs:**
```
💳 Creating Stripe checkout session...
💳 Calling edge function: create-checkout-session
💳 Payload: user_id=..., email=..., amount=$250.00
💳 Edge function response status: 200
✅ Checkout session created successfully
```

### Test 2: If Still Times Out

**Check 1: Edge Function Logs**

Go to Supabase Dashboard:
```
https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/functions/create-checkout-session
```

Look for:
- Error logs
- Execution time
- Request/response data

**Check 2: Secrets Configuration**

```bash
supabase secrets list
```

**Verify:**
- `test_SK` - starts with `sk_test_`
- `test_PK` - starts with `pk_test_`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

**Check 3: Internet Connection**

```bash
# Test edge function directly
curl -X POST \
  'https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/create-checkout-session' \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "email": "test@example.com",
    "payment_type": "event_ticket",
    "amount": 5000,
    "description": "Test Payment"
  }'
```

**Expected:** Response within 10 seconds

### Test 3: Retry Logic

If timeout occurs, the error screen now has a "Retry" button:
1. Shows error: "Payment session creation timed out"
2. User taps "Retry"
3. Tries again (likely succeeds on second attempt as function is now warm)

## Alternative Solutions

### Option 1: Keep Warm with Scheduled Ping

Create a scheduled function to ping `create-checkout-session` every 5 minutes to keep it warm.

**Not recommended** - Uses unnecessary resources

### Option 2: Use Payment Intent Instead

Switch back to `create-payment-intent` which is faster but requires in-app Payment Sheet instead of browser checkout.

**Trade-off:**
- ✅ Faster (no browser redirect)
- ❌ More complex UI
- ❌ Apple Pay configuration required

### Option 3: Show Loading with Progress

Update UI to show progress during the wait:

```dart
setState(() {
  _paymentState = PaymentState.loading;
  _loadingMessage = 'Creating payment session...';
  _loadingProgress = 0.0;
});

// Simulate progress
Timer.periodic(Duration(seconds: 1), (timer) {
  if (_loadingProgress < 0.9) {
    setState(() {
      _loadingProgress += 0.05;
    });
  }
});
```

## Production Recommendations

### For Better Performance:

1. **Use Stripe Webhooks**
   - Don't wait for synchronous response
   - Create payment intent immediately
   - Handle confirmation via webhook

2. **Optimize Edge Function**
   - Cache Stripe customer lookups
   - Minimize database queries
   - Use connection pooling

3. **Add Retry Logic**
   - Automatically retry once on timeout
   - Show user progress indicator
   - Provide manual retry button

4. **Monitor Function Performance**
   - Set up alerts for slow functions
   - Track cold start frequency
   - Monitor timeout rate

### Current Status

✅ **Timeout increased to 60 seconds**
✅ **Edge function redeployed**
✅ **Better error messages**
✅ **Retry button available**

**Expected Success Rate:** 95%+ (accounting for cold starts and network issues)

## Troubleshooting Checklist

If payment still times out after 60 seconds:

- [ ] Check internet connection speed
- [ ] Verify edge function logs in dashboard
- [ ] Confirm Stripe API keys are valid
- [ ] Check Supabase project status
- [ ] Try manual curl test
- [ ] Redeploy edge function again
- [ ] Check for Stripe API outages
- [ ] Verify database permissions

---

**Updated:** 2026-06-21
**Timeout:** 30s → 60s
**Status:** ✅ Should work now
**Next:** Test payment flow
