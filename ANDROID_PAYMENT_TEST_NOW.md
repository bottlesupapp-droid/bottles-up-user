# Android Payment Testing - Step by Step

## Changes Applied ✅

1. **Fixed event detail screen** to use in-app payment instead of browser checkout
2. **Added detailed logging** to track payment and booking creation
3. **Improved error handling** with stack traces

## Before Testing

### Make sure you have:
- Android device connected or emulator running
- Flutter environment set up
- `env.json` with TEST Stripe keys (`pk_test_...`)

### Rebuild the app:
```bash
cd /Users/abdulrazak/Downloads/bottlesup-monorepo/apps/bottles-up-user

flutter clean
flutter pub get
flutter run --dart-define-from-file=env.json
```

## Test Flow

### 1. Login/Signup
- Open app
- Login with your test account
- Make sure you're authenticated

### 2. Navigate to Events
- Go to Home or Events tab
- Browse available events
- Select any event

### 3. Buy Event Ticket

#### Click "Buy Tickets - $XXX.XX" button

**What should happen**:
1. Payment screen opens **INSIDE the app** ✅
2. Payment sheet slides up from bottom ✅
3. Shows Stripe payment UI in-app ✅

**What should NOT happen**:
- ❌ Browser opens
- ❌ "Creating payment session..." timeout
- ❌ App crashes or closes

#### Enter Payment Details

Use test card:
- **Card**: `4242 4242 4242 4242`
- **Expiry**: `12/34`
- **CVC**: `123`
- **ZIP**: `12345`

Tap "Pay"

#### After Payment Succeeds

**Watch console logs for**:
```
💳 Starting payment process...
💳 Creating payment intent...
✅ Using TEST mode Stripe key: pk_test_...
💳 Payment sheet completed successfully!
📝 [TICKET-1] Creating event ticket booking
📝 [TICKET-2] User: <user-id>, Event: <event-id>
✅ [TICKET-3] Booking created: <booking-id>
🎫 [TICKET-4] Confirmation: BU<code>
```

**Watch screen for**:
- Green success message: "🎫 Ticket purchased! Check 'My Bookings' tab"
- Message appears for 4 seconds

### 4. Verify Booking Created

#### Navigate to "My Bookings" Tab
- Tap the Bookings/Events tab in bottom navigation
- Pull down to refresh if needed

**Expected**:
- ✅ New booking appears in "Upcoming" tab
- ✅ Shows event name
- ✅ Shows venue name
- ✅ Shows date and time
- ✅ Shows "1 Ticket"
- ✅ Shows confirmation code
- ✅ Shows QR code (if implemented)

#### Check Database
1. Go to Supabase Dashboard
2. Open `events_bookings` table
3. Find booking by confirmation code (BU...)

**Verify fields**:
- `user_id` = your user ID
- `event_id` = the event you purchased
- `ticket_quantity` = 1
- `total_amount` = ticket price
- `status` = 'confirmed'
- `payment_status` = 'paid'
- `confirmation_code` = starts with 'BU'
- `created_at` = recent timestamp

## If You See Errors

### Error: "Payment session creation timed out"

**This means you're still using browser checkout (old code)**

Check console for:
```
🏦 [CS-1] CheckoutScreen.initState — paymentType=event_ticket
💳 Calling edge function: create-checkout-session
⏳ Attempt 1 timed out after 30s, retrying...
```

**Fix**:
1. Make sure you pulled the latest code changes
2. Rebuild completely:
   ```bash
   flutter clean
   flutter pub get
   flutter run --dart-define-from-file=env.json
   ```

### Error: "Payment succeeded but booking failed"

**This means payment worked but database insert failed**

Check console for:
```
💳 Payment sheet completed successfully!
📝 [TICKET-1] Creating event ticket booking
❌ [TICKET-ERROR] Failed to create booking: <error>
❌ [TICKET-STACK] <stack trace>
```

**Common causes**:
1. **User not authenticated**: Login again
2. **Database permissions**: Check RLS policies on `events_bookings`
3. **Missing event_id**: Event might not exist in database
4. **Field validation**: Check required fields match database schema

**To fix**:
- Share the `[TICKET-ERROR]` and `[TICKET-STACK]` logs
- Check Supabase logs for errors
- Verify event exists in `events` table

### Error: "Payment sheet doesn't appear"

**Check**:
1. Stripe key is set correctly
2. env.json has `pk_test_...` key
3. No other modals blocking the view

**Console should show**:
```
💳 Starting payment process...
💳 Creating payment intent...
```

**If you don't see these logs**, the payment isn't starting at all.

### Error: App crashes when payment sheet opens

**iOS specific issue** - shouldn't happen on Android

If it does happen on Android:
1. Check Android API level (need >= 21)
2. Update Stripe Flutter SDK
3. Check for memory issues

## Success Indicators

### ✅ Everything Working Correctly

**Console logs**:
```
💳 Starting payment process...
💳 Creating payment intent...
✅ Using TEST mode Stripe key: pk_test_51RG48...
💳 Payment sheet completed successfully!
📝 [TICKET-1] Creating event ticket booking
📝 [TICKET-2] User: 736b50da-..., Event: 29b29696-...
✅ [TICKET-3] Booking created: a1b2c3d4-...
🎫 [TICKET-4] Confirmation: BU8293847
```

**User experience**:
1. ✅ Click "Buy Tickets" → Payment screen opens in-app
2. ✅ Payment sheet slides up smoothly
3. ✅ Enter card → Payment processes
4. ✅ Green success message appears
5. ✅ Booking appears in "My Bookings"
6. ✅ Shows confirmation code
7. ✅ No browser opens
8. ✅ No app crashes
9. ✅ No timeouts

**Database**:
1. ✅ New record in `events_bookings` table
2. ✅ All fields populated correctly
3. ✅ Status = 'confirmed'
4. ✅ Payment status = 'paid'

## What to Share if Issues Occur

### 1. Full Console Output

**Run with logs**:
```bash
flutter run --dart-define-from-file=env.json -v
```

**Share logs from**:
- When you click "Buy Tickets"
- Through payment process
- Until success/error message

### 2. Error Messages

Copy exact error text:
- From console
- From UI (SnackBar messages)
- From Android logcat

### 3. Database State

- Did booking record get created?
- What fields are populated?
- Any error logs in Supabase?

### 4. Screenshots

- Payment screen
- Error messages
- "My Bookings" screen

## Common Test Scenarios

### Scenario 1: Successful Purchase ✅

**Test card**: `4242 4242 4242 4242`

**Expected**:
- Payment succeeds
- Booking created
- Success message shows
- Appears in "My Bookings"

### Scenario 2: Declined Card

**Test card**: `4000 0000 0000 0002`

**Expected**:
- Payment fails
- Error message shows
- NO booking created
- Can try again

### Scenario 3: Cancel Payment

**Action**: Swipe down to dismiss payment sheet

**Expected**:
- Returns to payment screen
- NO booking created
- Can try again

### Scenario 4: Network Error

**Action**: Turn off wifi during payment

**Expected**:
- Error message shows
- Can retry when reconnected

## Next Steps After Android Works

1. **Test on iOS device**
   - Same flow as Android
   - Should work identically
   - No browser opens
   - No app crashes

2. **Test event table booking**
   - Select event → "Reserve a Table"
   - Select table
   - Complete payment
   - Verify booking created

3. **Production preparation**
   - Switch to LIVE Stripe keys
   - Test with real cards (small amounts)
   - Set up refund policies
   - Monitor payment success rates

---

**Ready?** Rebuild the app and test purchasing an event ticket!

Report back with console logs if you hit any issues.
