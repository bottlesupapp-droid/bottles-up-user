# ✅ Test Mode Setup Complete

## Summary

All Stripe payment integrations have been successfully configured to use **TEST MODE** credentials from Supabase secrets.

---

## 🔐 Supabase Secrets Configuration

The following test credentials are now stored in Supabase secrets:

- **`test_PK`**: Stripe Test Publishable Key (pk_test_...)
- **`test_SK`**: Stripe Test Secret Key (sk_test_...)

You can verify these secrets are set:
```bash
supabase secrets list --project-ref hwmynlghrmtoufyrcihp
```

---

## 📝 Edge Functions Updated

All Stripe-related edge functions have been updated to use test credentials:

### 1. create-payment-intent ✅
**File:** [supabase/functions/create-payment-intent/index.ts](supabase/functions/create-payment-intent/index.ts)

**Changes:**
- Uses `test_SK` instead of `STRIPE_SECRET_KEY`
- Returns `test_PK` instead of `STRIPE_PUBLISHABLE_KEY`
- Added validation to ensure keys start with `sk_test_` and `pk_test_`
- Added console logging for test mode confirmation

**Deployed:** ✅ Yes

### 2. stripe-webhook ✅
**File:** [supabase/functions/stripe-webhook/index.ts](supabase/functions/stripe-webhook/index.ts)

**Changes:**
- Uses `test_SK` instead of `STRIPE_SECRET_KEY`
- Added validation to ensure key starts with `sk_test_`
- Added console logging for test mode confirmation

**Deployed:** ✅ Yes

### 3. create-checkout-session ✅
**File:** [supabase/functions/create-checkout-session/index.ts](supabase/functions/create-checkout-session/index.ts)

**Changes:**
- Uses `test_SK` instead of `STRIPE_SECRET_KEY`
- Added validation to ensure key starts with `sk_test_`
- Added console logging for test mode confirmation

**Deployed:** ✅ Yes

---

## 📱 Client-Side Configuration

### Payment Service
**File:** [lib/core/services/payment_service.dart](lib/core/services/payment_service.dart)

**Features:**
- Receives test publishable key from edge function response
- Validates key starts with `pk_test_` (blocks `pk_live_`)
- Throws error if LIVE key is detected
- Logs test mode confirmation to console

### Payment Screen UI
**File:** [lib/features/payment/screens/payment_screen.dart](lib/features/payment/screens/payment_screen.dart)

**Features:**
- Shows prominent "🧪 TEST MODE" banner (orange border)
- Displays test card instructions: `4242 4242 4242 4242`
- Visible on all payment screens

---

## 🧪 How to Test

### 1. Run the App

```bash
flutter run
```

### 2. Navigate to Payment Screen

Try to book an event or make a payment.

### 3. Look for Test Mode Indicators

**On Screen:**
- Orange "🧪 TEST MODE" banner
- Test card instructions

**In Console:**
```
💳 Starting payment process...
💳 Creating payment intent...
✅ Using TEST mode Stripe key: pk_test_...
💳 Payment intent created successfully
💳 Presenting payment sheet...
```

**In Supabase Edge Function Logs:**
```
✅ Using TEST mode Stripe secret key
✅ Returning TEST mode publishable key
```

### 4. Use Test Card

**Card Number:** `4242 4242 4242 4242`
**Expiry:** Any future date (e.g., 12/34)
**CVC:** Any 3 digits (e.g., 123)
**ZIP:** Any 5 digits (e.g., 12345)

### 5. Verify in Stripe Dashboard

- Go to https://dashboard.stripe.com/test/payments
- You should see the test payment appear
- Top banner should say "TEST MODE"

---

## 🛡️ Safety Features

### 1. Server-Side Validation (Edge Functions)

All edge functions validate the secret key format:

```typescript
// Verify it's a test key
if (!stripeKey.startsWith('sk_test_')) {
  throw new Error('Invalid Stripe test key. Expected sk_test_... for test mode.')
}
```

**Result:** Edge functions will **fail** if you try to use a LIVE secret key.

### 2. Client-Side Validation (Flutter App)

Payment service validates the publishable key:

```dart
// SAFETY CHECK: Ensure we're using TEST keys, not LIVE keys
if (publishableKey.startsWith('pk_live_')) {
  throw PaymentException(
    '🚨 CRITICAL: Live Stripe key detected!\n'
    'This app is configured to use LIVE payments.\n'
    'Please contact support immediately.\n\n'
    'For testing, use keys starting with pk_test_'
  );
}
```

**Result:** App will **crash** if edge function returns a LIVE publishable key.

### 3. Visual Confirmation

The TEST MODE banner provides immediate visual feedback that you're in test mode.

---

## 🎯 What Changed from LIVE to TEST Mode

| Component | Before (LIVE) | After (TEST) |
|-----------|---------------|--------------|
| Edge Functions | `STRIPE_SECRET_KEY` (sk_live_) | `test_SK` (sk_test_) |
| Publishable Key | `STRIPE_PUBLISHABLE_KEY` (pk_live_) | `test_PK` (pk_test_) |
| Validation | None | ✅ Key format validation |
| Logging | Minimal | ✅ Test mode confirmation |
| UI Indicator | None | ✅ Orange TEST MODE banner |
| Safety Check | None | ✅ Blocks LIVE keys |

---

## 🔄 Switching to LIVE Mode (Production)

When you're ready to accept real payments (App Store release):

### 1. Update Supabase Secrets

```bash
# Set LIVE keys in Supabase secrets
supabase secrets set test_SK=sk_live_YOUR_LIVE_SECRET_KEY --project-ref hwmynlghrmtoufyrcihp
supabase secrets set test_PK=pk_live_YOUR_LIVE_PUBLISHABLE_KEY --project-ref hwmynlghrmtoufyrcihp
```

**⚠️ WARNING:** This will cause the app to crash due to safety checks!

### 2. Remove Test Mode Validation

You'll need to update the edge functions and payment service to:
- Remove the `startsWith('sk_test_')` validation
- Remove the `startsWith('pk_test_')` validation
- Update to check for `pk_live_` instead

### 3. Remove/Update UI Banner

Update [payment_screen.dart](lib/features/payment/screens/payment_screen.dart) to either:
- Remove the TEST MODE banner entirely
- Change it to show "LIVE MODE" (not recommended for user-facing UI)

### 4. Verify Stripe Account

Ensure your Stripe account is:
- ✅ Fully verified
- ✅ Business information complete
- ✅ Bank account connected for payouts
- ✅ Tax information submitted

---

## 📊 Monitoring

### Supabase Edge Function Logs

View logs in real-time:
```bash
supabase functions logs create-payment-intent --project-ref hwmynlghrmtoufyrcihp
```

### Stripe Dashboard

- **Test Mode:** https://dashboard.stripe.com/test/payments
- **Live Mode:** https://dashboard.stripe.com/payments

Always verify you're in the correct mode by checking the top banner.

---

## ✅ Checklist

- [x] Supabase secrets `test_PK` and `test_SK` are set
- [x] `create-payment-intent` edge function updated and deployed
- [x] `stripe-webhook` edge function updated and deployed
- [x] `create-checkout-session` edge function updated and deployed
- [x] Client-side validation added to payment service
- [x] TEST MODE banner added to payment screen
- [x] All edge functions deployed successfully
- [ ] Run the app and test payment flow with test card
- [ ] Verify test payment appears in Stripe dashboard

---

## 🆘 Troubleshooting

### Issue: "Stripe test secret key not configured"

**Cause:** `test_SK` secret not set in Supabase.

**Solution:**
```bash
supabase secrets set test_SK=sk_test_YOUR_KEY --project-ref hwmynlghrmtoufyrcihp
```

### Issue: "Invalid Stripe test key. Expected sk_test_..."

**Cause:** You set a LIVE key (`sk_live_` or `pk_live_`) in the test secrets.

**Solution:** Replace with actual TEST keys from https://dashboard.stripe.com/test/apikeys

### Issue: App crashes with "Live Stripe key detected"

**Cause:** Edge function is returning a LIVE publishable key.

**Solution:**
1. Verify `test_PK` in Supabase starts with `pk_test_`
2. Redeploy edge functions
3. Clear app cache and restart

### Issue: Payment sheet doesn't appear

**Cause:** Multiple possible issues (see previous debugging).

**Solution:**
1. Check console for 💳 debug messages
2. Verify edge function logs in Supabase dashboard
3. Ensure Stripe SDK is initialized correctly

---

## 📚 Additional Resources

- **Stripe Test Cards:** https://stripe.com/docs/testing
- **Supabase Edge Functions:** https://supabase.com/docs/guides/functions
- **Stripe Payment Intents:** https://stripe.com/docs/payments/payment-intents
- **Flutter Stripe SDK:** https://pub.dev/packages/flutter_stripe

---

**Last Updated:** 2026-06-19
**Status:** ✅ TEST MODE ACTIVE
**Deployment:** All edge functions deployed successfully
