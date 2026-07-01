# 🚨 CRITICAL: Stripe LIVE Key Detected!

## ⚠️ IMMEDIATE ACTION REQUIRED

Your app is currently configured with **LIVE Stripe credentials**, which means:
- Any payments processed will be **REAL CHARGES**
- Customers will be **actually billed**
- This is **NOT SAFE for testing**

---

## 🔍 Current Configuration

**File:** `env.json`

```json
{
  "SUPABASE_URL": "https://hwmynlghrmtoufyrcihp.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGci...",
  "STRIPE_PUBLISHABLE_KEY": "pk_live_51RG48ACAp3BDUztNna3vtSxo6XSUd1eU9LV3Mu1j88rwvyoOePTxC0Fg7B41RoCa4uRZsgGHG2Io4VBt1S9GKNyR002ATpwcyK"
}
```

**Problem:** Key starts with `pk_live_` → **LIVE MODE** (real money!)

---

## ✅ How to Fix

### Step 1: Get Your Stripe TEST Key

1. Go to https://dashboard.stripe.com/test/apikeys
2. Copy your **Publishable key** (starts with `pk_test_`)
   - Example: `pk_test_51ABC...`

### Step 2: Update env.json

Replace the LIVE key with your TEST key:

```json
{
  "SUPABASE_URL": "https://hwmynlghrmtoufyrcihp.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3bXlubGdocm10b3VmeXJjaWhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE2Mzc3ODAsImV4cCI6MjA2NzIxMzc4MH0.1VpevdV-ReX7w3QCoM0xaPjSywusUtrbrtFk9AsWNAw",
  "STRIPE_PUBLISHABLE_KEY": "pk_test_YOUR_TEST_KEY_HERE"
}
```

### Step 3: Regenerate iOS Configuration

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

### Step 4: Verify Test Mode

Run the app and look for:
- 🧪 **TEST MODE** banner on payment screen (orange border)
- Console message: `✅ Using TEST mode Stripe key: pk_test_...`

---

## 🛡️ Safety Features Added

I've implemented the following protections:

### 1. Runtime Validation

**File:** [lib/core/services/payment_service.dart](lib/core/services/payment_service.dart#L93-L115)

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

// Verify it's a test key
if (!publishableKey.startsWith('pk_test_')) {
  throw PaymentException(
    'Invalid Stripe key format. Expected pk_test_... for test mode.'
  );
}

debugPrint('✅ Using TEST mode Stripe key: ${publishableKey.substring(0, 20)}...');
```

**Result:** App will **CRASH** if you try to use a LIVE key, preventing accidental charges.

### 2. Visual Test Mode Indicator

**File:** [lib/features/payment/screens/payment_screen.dart](lib/features/payment/screens/payment_screen.dart#L389-L428)

A prominent orange banner shows:
```
🧪 TEST MODE
Use test card: 4242 4242 4242 4242
Any CVC, future date
```

**Result:** Users can see clearly that they're in test mode.

---

## 🧪 Testing with Test Cards

Once you switch to test mode, use these test cards:

| Card Number | Result |
|-------------|--------|
| 4242 4242 4242 4242 | ✅ Success |
| 4000 0000 0000 9995 | ❌ Declined (insufficient funds) |
| 4000 0000 0000 0002 | ❌ Declined (card declined) |
| 4000 0025 0000 3155 | ✅ Success (requires 3DS authentication) |

**CVC:** Any 3 digits
**Expiry:** Any future date
**ZIP:** Any 5 digits

More test cards: https://stripe.com/docs/testing

---

## 🔐 Edge Function Configuration

You also need to verify your Supabase Edge Functions are using TEST mode.

### Check Your Edge Functions

1. Go to your Supabase dashboard
2. Navigate to Edge Functions
3. Check `create-payment-intent` function
4. Verify it uses `STRIPE_SECRET_KEY` that starts with `sk_test_` (NOT `sk_live_`)

### Edge Function Environment Variables

In Supabase dashboard → Settings → Edge Functions:

```
STRIPE_SECRET_KEY=sk_test_YOUR_SECRET_KEY_HERE
```

**NEVER** use `sk_live_` keys during development/testing!

---

## ⚠️ Before Going Live

When you're ready for production (App Store release):

1. ✅ Complete Stripe account verification
2. ✅ Enable live mode in Stripe dashboard
3. ✅ Update env.json with LIVE keys
4. ✅ Update Supabase Edge Function with LIVE secret key
5. ✅ **Remove or comment out** the test mode banner in payment_screen.dart
6. ✅ Test thoroughly with real cards (small amounts)
7. ✅ Set up refund policies and customer support

---

## 📋 Checklist

- [ ] Replace `pk_live_` with `pk_test_` in env.json
- [ ] Run `cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..`
- [ ] Verify Supabase Edge Function uses `sk_test_` key
- [ ] Run the app and confirm TEST MODE banner appears
- [ ] Test payment with 4242 4242 4242 4242
- [ ] Verify no real charges in Stripe dashboard

---

## 🆘 Need Help?

If you see this error when trying to make a payment:

```
🚨 CRITICAL: Live Stripe key detected!
This app is configured to use LIVE payments.
Please contact support immediately.

For testing, use keys starting with pk_test_
```

**This is GOOD!** The safety mechanism is working. Follow the fix steps above.

---

**Created:** 2026-06-19
**Status:** 🚨 IMMEDIATE ACTION REQUIRED
