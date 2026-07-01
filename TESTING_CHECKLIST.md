# 🧪 Stripe Test Mode - Testing Checklist

Use this checklist to verify that the test mode setup is working correctly.

---

## 📋 Pre-Flight Checks

Before running the app, verify:

- [ ] Supabase secrets are set:
  ```bash
  supabase secrets list --project-ref hwmynlghrmtoufyrcihp | grep -E "test_PK|test_SK"
  ```
  Expected output: Both `test_PK` and `test_SK` should be listed

- [ ] Edge functions are deployed:
  ```bash
  # Check deployment status in Supabase dashboard
  open https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/functions
  ```
  Expected: All three functions should show recent deployment timestamp

---

## 🚀 App Testing

### Step 1: Launch the App

```bash
cd /Users/abdulrazak/Downloads/bottlesup-monorepo/apps/bottles-up-user
flutter run
```

**Expected Console Output:**
```
✓ Built build/ios/iphoneos/Runner.app
...
```

**Checklist:**
- [ ] App launches successfully
- [ ] No Stripe configuration errors in console
- [ ] App doesn't crash on startup

---

### Step 2: Navigate to Payment Screen

1. Sign in to the app
2. Browse events or tables
3. Select an item to book
4. Proceed to payment screen

**Checklist:**
- [ ] Navigation works smoothly
- [ ] No crashes when opening payment screen

---

### Step 3: Verify Test Mode Indicators

**On Screen:**
- [ ] Orange "🧪 TEST MODE" banner is visible at top of payment screen
- [ ] Banner shows test card instructions: `4242 4242 4242 4242`

**In Console:**
Look for these 💳 debug messages:
```
💳 Starting payment process...
💳 Creating payment intent...
💳 Payment intent created successfully
💳 Presenting payment sheet...
```

**Checklist:**
- [ ] All 💳 messages appear in order
- [ ] No error messages between steps

---

### Step 4: Check Edge Function Response

**In Console:**
After "Creating payment intent..." you should see:
```
✅ Using TEST mode Stripe key: pk_test_...
```

**In Supabase Dashboard:**
```bash
# View edge function logs in real-time
supabase functions logs create-payment-intent --project-ref hwmynlghrmtoufyrcihp
```

Expected logs:
```
✅ Using TEST mode Stripe secret key
✅ Returning TEST mode publishable key
```

**Checklist:**
- [ ] Test mode confirmation appears in app console
- [ ] Edge function logs show test mode messages
- [ ] No errors in edge function logs

---

### Step 5: Verify Payment Sheet Opens

After tapping payment button:

**Expected Behavior:**
- Payment sheet slides up from bottom
- Shows "BottlesUp" as merchant name
- Shows amount and currency
- Has "Pay" button

**Checklist:**
- [ ] Payment sheet appears (not stuck/blank)
- [ ] Merchant name is correct
- [ ] Amount matches selected item
- [ ] Payment methods (card/Apple Pay/Google Pay) are shown

**Console Message:**
```
💳 Presenting payment sheet...
```

---

### Step 6: Test Payment with Test Card

**Test Card Details:**
- **Card Number:** `4242 4242 4242 4242`
- **Expiry:** `12/34` (any future date)
- **CVC:** `123` (any 3 digits)
- **ZIP:** `12345` (any 5 digits)

**Steps:**
1. Tap "Add card" or card field
2. Enter test card number: `4242 4242 4242 4242`
3. Enter expiry: `12/34`
4. Enter CVC: `123`
5. Enter ZIP: `12345`
6. Tap "Pay" button

**Expected Console Output:**
```
💳 Payment sheet result: true
💳 Payment completed successfully
```

**Checklist:**
- [ ] Card entry fields work correctly
- [ ] No validation errors with test card
- [ ] "Pay" button is enabled
- [ ] Payment processes successfully
- [ ] Success message or navigation occurs

---

### Step 7: Verify in Stripe Dashboard

1. Open Stripe Test Dashboard:
   ```bash
   open https://dashboard.stripe.com/test/payments
   ```

2. Look for your payment:
   - Should appear at top of list
   - Status: "Succeeded"
   - Amount matches your booking
   - Description includes event/table details

**Checklist:**
- [ ] Payment appears in Stripe test dashboard
- [ ] Top banner says "TEST MODE" with orange background
- [ ] Status is "Succeeded"
- [ ] Amount is correct
- [ ] Customer email matches your account

---

### Step 8: Verify in App Database

Check Supabase database for payment record:

```sql
-- Run in Supabase SQL Editor
SELECT * FROM payment_transactions
ORDER BY created_at DESC
LIMIT 1;
```

**Expected:**
- `status`: 'paid' or 'pending'
- `payment_intent_id`: starts with 'pi_'
- `stripe_customer_id`: starts with 'cus_'
- `amount`: matches booking amount

**Checklist:**
- [ ] Payment transaction record exists
- [ ] Status is correct
- [ ] Payment intent ID is valid
- [ ] Amount matches

---

## 🎯 Test Scenarios

Test these different scenarios to ensure comprehensive coverage:

### Scenario 1: Successful Payment ✅
**Card:** `4242 4242 4242 4242`
**Expected:** Payment succeeds, booking confirmed

**Checklist:**
- [ ] Payment sheet opens
- [ ] Payment processes
- [ ] Success message shown
- [ ] Booking appears in "My Bookings"

---

### Scenario 2: Declined Card ❌
**Card:** `4000 0000 0000 0002`
**Expected:** Payment fails with "card declined" message

**Checklist:**
- [ ] Payment sheet opens
- [ ] Error message shown
- [ ] User can retry with different card
- [ ] No booking created

---

### Scenario 3: Insufficient Funds ❌
**Card:** `4000 0000 0000 9995`
**Expected:** Payment fails with "insufficient funds" message

**Checklist:**
- [ ] Payment sheet opens
- [ ] Error message shown
- [ ] User can retry
- [ ] No booking created

---

### Scenario 4: Apple Pay (if available)
**Expected:** Apple Pay option appears and works

**Checklist:**
- [ ] Apple Pay button shown
- [ ] Tapping opens Apple Pay sheet
- [ ] Can complete payment with Apple Pay
- [ ] Payment succeeds

---

### Scenario 5: Cancel Payment
**Expected:** User can cancel without charge

**Steps:**
1. Open payment sheet
2. Tap "X" or back button
3. Confirm cancellation

**Checklist:**
- [ ] Can cancel payment sheet
- [ ] No charge created
- [ ] Returns to previous screen
- [ ] No database record created

---

## 🐛 Common Issues & Solutions

### Issue: Payment sheet doesn't appear

**Debug Steps:**
1. Check console for errors after "💳 Presenting payment sheet..."
2. Look for view hierarchy warnings
3. Verify Stripe SDK version in pubspec.yaml

**Solution:**
- Ensure no artificial delays in code
- Verify mounted checks are in place
- Check that Stripe.instance is initialized

---

### Issue: "Live Stripe key detected" error

**Cause:** Edge function returning LIVE key instead of TEST key

**Debug Steps:**
1. Check Supabase secrets:
   ```bash
   supabase secrets list --project-ref hwmynlghrmtoufyrcihp
   ```
2. Verify `test_PK` starts with `pk_test_`

**Solution:**
```bash
supabase secrets set test_PK=pk_test_YOUR_KEY --project-ref hwmynlghrmtoufyrcihp
```
Then redeploy edge function.

---

### Issue: Edge function error "test_SK not configured"

**Cause:** Supabase secret not set

**Solution:**
```bash
supabase secrets set test_SK=sk_test_YOUR_KEY --project-ref hwmynlghrmtoufyrcihp
```

---

### Issue: Payment succeeds but booking not created

**Debug Steps:**
1. Check `payment_transactions` table for record
2. Check edge function logs for database errors
3. Verify webhook is receiving events

**Solution:**
- Check webhook endpoint is configured in Stripe
- Verify `STRIPE_WEBHOOK_SECRET` is set
- Check database RLS policies

---

## 📊 Success Criteria

✅ **Setup is successful if:**

1. **App Launch**
   - [x] App starts without Stripe errors
   - [x] No configuration warnings

2. **Payment UI**
   - [x] TEST MODE banner visible
   - [x] Payment sheet opens smoothly
   - [x] Test card info shown

3. **Payment Processing**
   - [x] Test card `4242 4242 4242 4242` works
   - [x] Payment appears in Stripe test dashboard
   - [x] Database record created
   - [x] Booking confirmed in app

4. **Safety**
   - [x] LIVE keys are blocked
   - [x] Console shows test mode confirmations
   - [x] All payments go to TEST mode in Stripe

---

## 🎉 Next Steps

Once all checks pass:

1. **Share Results**
   - Screenshot of TEST MODE banner
   - Screenshot of successful payment in Stripe dashboard
   - Copy of console logs showing 💳 messages

2. **Test on Real Device**
   - Run on physical iPhone/iPad
   - Verify same behavior as simulator

3. **TestFlight Build** (optional)
   - Build for TestFlight with test credentials
   - Verify works on TestFlight build

4. **Production Planning**
   - Review [TEST_MODE_SETUP_COMPLETE.md](TEST_MODE_SETUP_COMPLETE.md)
   - Plan switch to LIVE mode when ready for App Store

---

**Testing Date:** _____________
**Tester:** _____________
**Result:** ☐ PASS  ☐ FAIL
**Notes:**

