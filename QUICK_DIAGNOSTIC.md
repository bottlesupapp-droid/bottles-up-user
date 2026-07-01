# Quick Payment Diagnostic

## What to Check

### 1. Does the app open PaymentScreen?

When you click "Buy Tickets", do you see:
- A new screen with "Pay $250.00" button?
- OR does it stay on the event detail screen?
- OR does it crash/close?

### 2. What's in the console?

Look for these specific messages in order:

**If payment flow starts correctly:**
```
💳 Starting payment process...
💳 Creating payment intent...
💳 Payment intent created successfully
💳 Presenting payment sheet...
💳 Initializing payment sheet...
✅ Using TEST mode Stripe key: pk_test_...
💳 Payment sheet initialized, presenting now...
```

**If payment sheet times out:**
```
❌ presentPaymentSheet() timed out after 30 seconds!
This usually means the view controller is not ready to present modals.
Payment sheet failed to appear. Please try again.
```

**If Stripe initialization fails:**
```
❌ Invalid Stripe key format
OR
❌ CRITICAL: Live Stripe key detected!
```

### 3. Test Edge Function Directly

Let's test if the edge function is working:

```bash
curl -X POST https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/create-payment-intent \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3bXlubGdocm10b3VmeXJjaWhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE2Mzc3ODAsImV4cCI6MjA2NzIxMzc4MH0.1VpevdV-ReX7w3QCoM0xaPjSywusUtrbrtFk9AsWNAw" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "email": "test@test.com",
    "payment_type": "event_ticket",
    "amount": 25000,
    "description": "Test event ticket"
  }'
```

**Expected response:**
```json
{
  "paymentIntent": "pi_xxx_secret_yyy",
  "ephemeralKey": "ek_test_xxx",
  "customer": "cus_xxx",
  "publishableKey": "pk_test_51RG48..."
}
```

**If edge function fails:**
- Check Supabase logs
- Verify Stripe keys are set in Supabase secrets

### 4. Check Stripe Key in env.json

```bash
cat env.json | grep STRIPE
```

**Should show:**
```json
"STRIPE_PUBLISHABLE_KEY": "pk_test_51RG48..."
```

**NOT:**
```json
"STRIPE_PUBLISHABLE_KEY": "pk_live_..."
```

## Common Issues

### Issue 1: PaymentScreen doesn't open

**Symptom**: Clicking "Buy Tickets" does nothing or crashes

**Fix**: Check for navigation errors in console

### Issue 2: "Payment sheet failed to appear"

**Symptom**: PaymentScreen opens, but payment sheet times out after 30s

**Causes**:
- Payment intent creation failing
- Stripe SDK not initialized
- View controller hierarchy issues (iOS)
- Missing Stripe keys

**Debug**:
1. Check console for `💳 Creating payment intent...`
2. If you don't see it, edge function isn't being called
3. If you see it but it hangs, edge function is timing out
4. Check Supabase edge function logs

### Issue 3: "Invalid Stripe key"

**Symptom**: Error about key format

**Fix**:
1. Check env.json has `pk_test_...` key
2. Rebuild app with `--dart-define-from-file=env.json`

### Issue 4: Edge function timeout

**Symptom**: Payment intent creation takes >30s

**Fix**:
- Check Supabase status
- Verify Stripe API is accessible
- Check edge function logs for errors

## Quick Fixes

### Fix 1: Rebuild with env variables

```bash
flutter clean
flutter pub get
flutter run --dart-define-from-file=env.json
```

### Fix 2: Test on different device

Sometimes emulators have network issues:
- Try on physical Android device
- Check if emulator has internet access

### Fix 3: Check Supabase Connection

```dart
// In your code, test Supabase is reachable:
final response = await supabase.from('events').select('id').limit(1);
debugPrint('Supabase connected: $response');
```

## Next Steps Based on Error

### If you see: "Creating payment intent..." but it hangs

**Problem**: Edge function timeout

**Action**:
1. Check Supabase edge function logs
2. Test edge function directly (curl command above)
3. Verify Stripe secrets in Supabase

### If you see: "Payment sheet initialized" but it hangs

**Problem**: Stripe Payment Sheet not presenting

**Action**:
1. Android: Check if Google Play Services installed
2. Check Stripe Flutter SDK version
3. Try without delay: Remove 500ms delay temporarily

### If you don't see any payment logs

**Problem**: Payment flow not starting

**Action**:
1. Check if PaymentScreen opened
2. Add debug print in event_detail_screen.dart _handleBooking
3. Verify navigation isn't blocked

---

**Tell me exactly what you see** and I'll help diagnose the specific issue!
