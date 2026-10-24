# 🚀 Quick Test Guide - BottlesUp App

**Ready to test in 5 minutes!**

---

## ✅ Pre-Test Checklist

- [x] Stripe secrets added to Supabase ✅
- [x] Code errors fixed ✅
- [x] App ready to build ✅

---

## 🎯 Quick Test Flow (10 minutes)

### Step 1: Build & Launch App (2 min)

```bash
# Navigate to project
cd /Users/abdulrazak/Downloads/bottles-up-user-main

# Run on iOS
flutter run

# Or run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

**Expected:** App launches, shows splash screen → login screen

---

### Step 2: Sign Up Flow (2 min)

**Test New User Registration:**

1. Tap **"Sign Up"** or **"Create Account"**
2. Enter test details:
   - **Email:** `test@bottlesup.com`
   - **Password:** `Test123456!`
   - **Name:** `Test User`
   - **Date of Birth:** Select date showing age ≥ 21
3. Tap **"Create Account"**

**✅ Expected:**
- Age verification passes (21+)
- Account created successfully
- Redirected to location permission screen or home

**❌ If age < 21:**
- Should show error: "Must be 21+ to use this app"

---

### Step 3: Browse Events (1 min)

1. From home screen, tap **"Events"** tab
2. **Expected:** See list of events with:
   - Event images
   - Event names
   - Dates & times
   - Ticket prices

3. Try search:
   - Tap search bar
   - Type event name
   - **Expected:** Results filter in real-time

4. Try filters:
   - Tap filter button
   - Select category (e.g., "Live Music")
   - **Expected:** Only matching events shown

---

### Step 4: Book Event & Test Payment (5 min)

#### 4.1: Select Event & Tickets

1. Tap any event from list
2. **Expected:** Event detail screen shows:
   - Full event description
   - Photo gallery
   - Date, time, location
   - Available ticket types
   - "Buy Tickets" button

3. Tap **"Buy Tickets"**
4. Select ticket type (e.g., "2x General Admission")
5. Tap **"Continue to Payment"** or **"Checkout"**

#### 4.2: In-App Payment Test

**Expected:** Payment Sheet opens **INSIDE THE APP** (not browser)

**✅ CORRECT:** You see native payment UI with card input
**❌ WRONG:** Browser opens with Stripe checkout page

If browser opens, check:
- Is `STRIPE_PUBLISHABLE_KEY` set in Supabase?
- Is app calling `createPaymentIntent()` instead of `createCheckoutSession()`?

#### 4.3: Complete Test Payment

**Use Stripe Test Card:**
- **Card Number:** `4242 4242 4242 4242`
- **Expiry:** Any future date (e.g., `12/26`)
- **CVC:** Any 3 digits (e.g., `123`)
- **ZIP:** Any 5 digits (e.g., `12345`)

**Tap "Pay" or "Complete Payment"**

**✅ Expected:**
1. Payment processes (shows loading)
2. Success message appears
3. Booking confirmed
4. Redirected to "Orders" or "My Tickets"

**❌ If Payment Fails:**
- Check error message
- Common issues:
  - "No publishable key" → Add `STRIPE_PUBLISHABLE_KEY` to Supabase
  - "Function not found" → Edge function not deployed
  - "Declined" → Use correct test card (4242...)

---

### Step 5: View QR Code (1 min)

1. Go to **"Profile"** → **"Orders"** or **"My Tickets"**
2. **Expected:** See your booking/ticket
3. Tap the booking
4. **Expected:** See booking details with:
   - Event name
   - Date & time
   - Ticket quantity
   - **QR Code** for check-in
   - Total paid

5. Tap QR code to enlarge
6. **Expected:** Full-screen QR code (scannable at venue)

---

## 🧪 Test Card Numbers (Stripe Test Mode)

| Card Number | Scenario | Use Case |
|-------------|----------|----------|
| `4242 4242 4242 4242` | ✅ Success | Normal payment flow |
| `4000 0000 0000 0002` | ❌ Declined | Test error handling |
| `4000 0025 0000 3155` | 🔐 3D Secure | Test authentication popup |
| `4000 0000 0000 9995` | ❌ Insufficient Funds | Test declined card |

**All test cards:**
- Expiry: Any future date
- CVC: Any 3 digits
- ZIP: Any valid format

---

## ✅ Success Criteria

Your app is working correctly if:

### Core Flow
- [x] App launches without crashes
- [x] Sign up completes successfully
- [x] Age verification works (blocks <21)
- [x] Events list displays

### Payment Flow
- [x] Payment Sheet opens **in-app** (not browser)
- [x] Test card 4242... processes successfully
- [x] Booking appears in Orders/Tickets
- [x] QR code displays correctly

### Edge Cases
- [x] Declined card (4000...0002) shows error message
- [x] User can retry payment after error
- [x] Network error handled gracefully

---

## 🐛 Troubleshooting

### Issue: Payment Sheet Doesn't Open

**Symptoms:** Nothing happens when tapping "Buy Tickets"

**Check:**
1. Console logs for errors
2. Is user logged in?
3. Does event have available tickets?

**Fix:**
```bash
# Check logs
flutter logs

# Look for "payment" or "error" messages
```

### Issue: Browser Opens Instead of In-App Payment

**Cause:** App using old browser checkout method

**Check:**
1. Is `STRIPE_PUBLISHABLE_KEY` set in Supabase?
2. Edge function `create-payment-intent` deployed?

**Quick Fix:**
- Verify Supabase Vault has both:
  - `STRIPE_SECRET_KEY`
  - `STRIPE_PUBLISHABLE_KEY`

### Issue: "Payment Failed" Error

**Common Causes:**

1. **"No publishable key"**
   - Add `STRIPE_PUBLISHABLE_KEY` to Supabase Vault
   - Get from: https://dashboard.stripe.com/test/apikeys

2. **"Function not found"**
   - Edge function not deployed
   - Check: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/functions

3. **"Card declined"**
   - Not using test card correctly
   - Make sure: `4242 4242 4242 4242` (with spaces or without)

4. **"Invalid request"**
   - Check Stripe webhook configured
   - Verify webhook has events: `payment_intent.succeeded`

### Issue: QR Code Not Showing

**Check:**
1. Did payment complete successfully?
2. Is booking status "confirmed" or "paid"?
3. Check booking_id is valid

**Verify in Supabase:**
```sql
-- Check your bookings
SELECT * FROM bookings
WHERE user_id = 'YOUR_USER_ID'
ORDER BY created_at DESC
LIMIT 5;

-- Check payment status
SELECT * FROM payment_transactions
WHERE user_id = 'YOUR_USER_ID'
ORDER BY created_at DESC
LIMIT 5;
```

---

## 📊 Verify in Stripe Dashboard

After making a test payment:

1. Go to: https://dashboard.stripe.com/test/payments
2. **Expected:** See your test payment listed
3. Click payment to see details:
   - Amount: Matches ticket price
   - Status: Succeeded
   - Customer: Your test email
   - Metadata: Event ID, booking ID

### Check Webhook

1. Go to: https://dashboard.stripe.com/test/webhooks
2. Click your webhook endpoint
3. Check **"Events"** tab
4. **Expected:** See `payment_intent.succeeded` events
5. Status should be "200 OK"

**If webhook shows errors:**
- Click event → See error details
- Common issue: Webhook secret mismatch
- Fix: Update `STRIPE_WEBHOOK_SECRET` in Supabase

---

## 🎯 Extended Testing (Optional - 20 min)

### Test Additional Features

#### 1. Google Sign-In (2 min)
1. Logout from test account
2. Login screen → "Continue with Google"
3. Select Google account
4. **Expected:** Auto-login

#### 2. Saved Cards (3 min)
1. Make first payment with card 4242...
2. Start second booking
3. Go to payment
4. **Expected:** See "Visa ••••4242" as saved option
5. Tap saved card → Complete payment faster

#### 3. Multiple Tickets (2 min)
1. Select event
2. Choose multiple ticket types:
   - 2x General Admission
   - 1x VIP
3. **Expected:** Total calculates correctly
4. Complete payment
5. Verify all tickets in Orders

#### 4. Search & Filters (2 min)
1. Events tab → Search "music"
2. **Expected:** Only music events
3. Apply filter: "This Weekend"
4. **Expected:** Only weekend events
5. Clear filters
6. **Expected:** All events return

#### 5. Profile Settings (2 min)
1. Profile → Settings
2. Change name/photo
3. **Expected:** Updates saved
4. Enable/disable notifications
5. **Expected:** Preferences saved

---

## 📝 Test Checklist

Print this or check off as you test:

### Core Functionality
- [ ] App launches successfully
- [ ] Splash screen appears
- [ ] Login screen loads

### Authentication
- [ ] Sign up with email works
- [ ] Age verification (21+) enforced
- [ ] Login with email works
- [ ] Google Sign-In works (optional)
- [ ] Session persists (close/reopen app)

### Event Discovery
- [ ] Events list displays
- [ ] Event images load
- [ ] Search filters results
- [ ] Category filter works
- [ ] Event details open

### Booking & Payment
- [ ] Can select tickets
- [ ] Payment Sheet opens in-app
- [ ] Test card processes successfully
- [ ] Booking confirms
- [ ] Order appears in "Orders"
- [ ] QR code displays

### Edge Cases
- [ ] Declined card shows error
- [ ] Can retry after error
- [ ] Logout works
- [ ] No crashes during testing

---

## 🚨 Known Issues (Safe to Ignore)

These are **cosmetic/minor issues** that don't affect core functionality:

1. **Info Warnings (86x):** `print()` statements in auth code
   - **Impact:** None - just debug logs
   - **Safe:** Yes, ignore for now

2. **Deprecated Warnings (14x):** `.withOpacity()` usage
   - **Impact:** None - still works fine
   - **Safe:** Yes, can fix later

3. **Unused Code (7x):** Unused functions in login/signup
   - **Impact:** None - doesn't affect app
   - **Safe:** Yes, clean up later

---

## ✅ Success!

If you completed the 5-step test flow successfully, **congratulations! Your app is working!** 🎉

### Next Steps:

1. **Test with real users:**
   - Share with 2-3 beta testers
   - Collect feedback

2. **Monitor Stripe Dashboard:**
   - Watch for test payments
   - Check webhook success rate

3. **Review QA Checklist:**
   - See `QA_TEST_CHECKLIST.md` for all 220 tests
   - Test edge cases and stress scenarios

4. **When Ready for Production:**
   - Switch Stripe to live keys
   - Get Stripe account verified
   - Launch! 🚀

---

## 📞 Need Help?

### Check Logs

**Flutter Console:**
```bash
flutter logs
```

**Supabase Function Logs:**
- Go to: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/functions
- Click function → "Logs" tab

**Stripe Logs:**
- Go to: https://dashboard.stripe.com/test/logs

### Common Error Messages

| Error | Meaning | Fix |
|-------|---------|-----|
| "No publishable key" | Missing Stripe key | Add to Supabase Vault |
| "Function not found" | Edge function issue | Redeploy function |
| "Authentication failed" | User not logged in | Login again |
| "Card declined" | Wrong test card | Use 4242 4242 4242 4242 |
| "Webhook error" | Webhook not configured | Add webhook in Stripe |

---

## 🎉 You're Ready to Test!

Run this command to start:

```bash
flutter run
```

Then follow the 5-step test flow above. **Good luck!** 🚀
