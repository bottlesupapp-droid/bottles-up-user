# Quick Android Payment Testing Guide

## Prerequisites
- Android device connected or emulator running
- Flutter environment set up
- env.json file configured with Stripe TEST keys

## Step 1: Clean Build

```bash
cd /Users/abdulrazak/Downloads/bottlesup-monorepo/apps/bottles-up-user

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for Android
flutter build apk --dart-define-from-file=env.json
```

## Step 2: Run on Android Device

```bash
# Run on connected device
flutter run --dart-define-from-file=env.json

# OR run on specific device
flutter devices  # List available devices
flutter run -d <device-id> --dart-define-from-file=env.json
```

## Step 3: Test Event Booking Flow

### A. Login / Signup
1. Open app
2. Login or create account
3. Complete profile if needed

### B. Navigate to Events
1. Tap "Events" or "Home" tab
2. Browse available events
3. Select an event with table bookings

### C. Book a Table
1. In event details, tap "Reserve a Table" (Option B)
2. Select a table from the horizontal list
3. (Optional) Select bottles
4. Enter party size
5. Add special requests if needed
6. Tap "Proceed to Checkout"

### D. Complete Payment
1. **IMPORTANT**: Payment UI should appear IN-APP (not browser)
2. You should see a Stripe payment sheet slide up from bottom
3. Enter test card details:
   - Card: `4242 4242 4242 4242`
   - Expiry: `12/34`
   - CVC: `123`
   - ZIP: `12345`
4. Tap "Pay"
5. Wait for payment to process

### E. Verify Success
1. **Expected**: Success dialog appears
2. **Expected**: Shows booking confirmation code
3. **Expected**: Offers "Add to Wallet" button
4. **Expected**: Shows "View My Bookings" button
5. Tap "View My Bookings"

### F. Verify Ticket Display
1. Navigate to "My Bookings" tab
2. **Expected**: See your new booking
3. **Expected**: Shows event name, date, time
4. **Expected**: Shows QR code
5. **Expected**: Shows confirmation code
6. **Expected**: Shows booking status: "Confirmed"

## Step 4: Verify in Database

1. Go to Supabase Dashboard
2. Navigate to Table Editor
3. Open `events_bookings` table
4. Find your booking by confirmation code
5. **Verify**:
   - `status` = 'confirmed'
   - `payment_status` = 'paid'
   - `stripe_session_id` is populated
   - `user_id` matches your user
   - `event_id` matches the event

## Step 5: Check Stripe Dashboard

1. Go to https://dashboard.stripe.com/test/payments
2. **Expected**: See your test payment
3. **Expected**: Amount matches booking total
4. **Expected**: Status = "Succeeded"
5. **Expected**: Customer created/used

## Common Test Scenarios

### Test 1: Successful Payment
- Card: `4242 4242 4242 4242`
- **Expected**: Payment succeeds, booking created

### Test 2: Declined Card
- Card: `4000 0000 0000 0002`
- **Expected**: Payment fails, error message shown, NO booking created

### Test 3: Insufficient Funds
- Card: `4000 0000 0000 9995`
- **Expected**: Payment fails, error message shown, NO booking created

### Test 4: Payment Requires Authentication
- Card: `4000 0025 0000 3155`
- **Expected**: 3D Secure dialog appears, payment succeeds after auth

### Test 5: Cancel Payment
- Start payment process
- Tap back or swipe down to dismiss payment sheet
- **Expected**: Returns to payment screen, NO booking created, can retry

## What to Watch For

### ✅ Good Signs
- [ ] Payment sheet appears IN-APP (not browser)
- [ ] Payment sheet slides up smoothly from bottom
- [ ] Shows correct amount and merchant name
- [ ] Test card processes successfully
- [ ] Success dialog appears immediately
- [ ] Booking appears in "My Bookings"
- [ ] QR code displays correctly
- [ ] Confirmation email received (check spam folder)

### ❌ Bad Signs (Report These)
- [ ] App opens browser for payment
- [ ] App crashes when payment sheet opens
- [ ] Payment sheet doesn't appear (stuck loading)
- [ ] Payment succeeds but no booking created
- [ ] Booking created but payment failed
- [ ] Duplicate bookings created
- [ ] App crashes when returning to app
- [ ] No confirmation email received

## Debug Commands

### Check logs while testing:
```bash
# View Flutter logs
flutter logs

# Filter for payment-related logs
flutter logs | grep "💳"

# Filter for booking-related logs
flutter logs | grep "📝"
```

### Test deep link manually:
```bash
# Test payment success deep link
adb shell am start -W -a android.intent.action.VIEW \
  -d "bottlesup://payment/success?session_id=cs_test_123"

# Test payment cancel deep link
adb shell am start -W -a android.intent.action.VIEW \
  -d "bottlesup://payment/cancel"
```

### Clear app data and restart:
```bash
# Uninstall app
flutter clean
adb uninstall com.bottlesupuser

# Reinstall
flutter run --dart-define-from-file=env.json
```

## Expected Console Output

When payment flow works correctly, you should see:

```
💳 Starting payment process...
💳 Creating payment intent...
💳 Payment intent created successfully
💳 Presenting payment sheet...
💳 Initializing payment sheet...
✅ Using TEST mode Stripe key: pk_test_...
💳 Payment sheet initialized, presenting now...
💳 Payment sheet completed successfully!
📝 [BOOKING-1] Creating booking — event=... session=... amount=...
✅ [BOOKING-2] Booking created: <booking-id>
🎫 [BOOKING-3] Confirmation code: BU<timestamp>
```

## Troubleshooting

### Issue: "Payment sheet not appearing"

1. Check Stripe key is set:
   ```dart
   debugPrint('Stripe key: ${Stripe.publishableKey}');
   ```

2. Verify env.json has correct key:
   ```bash
   cat env.json | grep STRIPE
   ```

3. Make sure key starts with `pk_test_` not `pk_live_`

### Issue: "Payment succeeds but no booking created"

1. Check if `onPaymentSuccess` callback is being called
2. Look for database errors in logs
3. Verify user is authenticated
4. Check Supabase table permissions

### Issue: "App crashes on payment"

1. Check Android version (need >= API 21)
2. Update Stripe Flutter SDK:
   ```bash
   flutter pub upgrade flutter_stripe
   ```
3. Clear build cache:
   ```bash
   flutter clean
   flutter pub get
   ```

### Issue: "Booking created but payment failed"

This should NOT happen! Report this immediately. It means booking is being created before payment confirmation.

## Success Criteria

✅ Payment flow is working correctly if:

1. Payment sheet appears IN-APP (not browser)
2. Test card `4242 4242 4242 4242` processes successfully
3. Success dialog shows after payment
4. Booking appears in "My Bookings" with QR code
5. Database has booking record with `status='confirmed'` and `payment_status='paid'`
6. Stripe dashboard shows successful payment
7. Confirmation email is received
8. No app crashes throughout the flow
9. Can repeat the flow multiple times without issues

---

**Once Android is working, proceed to iOS testing using the same steps!**

## Next: iOS Testing

After Android works:
1. Connect iOS device or run simulator
2. Run: `flutter run --dart-define-from-file=env.json`
3. Follow same test steps as Android
4. Verify payment sheet appears (not browser)
5. Verify no crashes when payment sheet opens/closes
6. Verify booking creation works same as Android

**Good luck! If you hit any issues, check the troubleshooting section above.**
