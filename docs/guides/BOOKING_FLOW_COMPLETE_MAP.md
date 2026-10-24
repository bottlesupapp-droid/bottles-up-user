# Complete Booking Flow Map & Critical Issues

## Executive Summary

**Status:** 🔴 **CRITICAL ISSUES FOUND - NOT PRODUCTION READY**

### Critical Issues Discovered:

1. ❌ **Payment confirmation happens CLIENT-SIDE** instead of SERVER-SIDE via webhook
2. ❌ **Booking created before webhook confirms payment** - race condition risk
3. ❌ **NO atomic capacity/inventory management** - double-booking possible
4. ❌ **Missing payment failure recovery flows** - users stuck if payment succeeds but booking fails
5. ⚠️ **No realtime subscription or polling for pending bookings** - stale state

---

## 1. Complete Booking Flow Map

### Flow: Event Discovery → Ticket/Wallet Pass

```
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 1: DISCOVERY                                               │
└─────────────────────────────────────────────────────────────────┘

Screen: event_discovery_screen.dart
Provider: eventsProvider (Riverpod)
Service: EventService().getEvents()
Database: SELECT * FROM events WHERE is_active = true
          JOIN venues ON events.venue_id = venues.id

User Action: Tap on event card
Navigation: context.push('/events/${event.id}')

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 2: EVENT DETAILS                                           │
└─────────────────────────────────────────────────────────────────┘

Screen: event_detail_screen.dart
Provider: eventByIdProvider(eventId)
Service: EventService().getEventById(eventId)
Database: SELECT * FROM events WHERE id = $eventId
          JOIN venues ON events.venue_id = venues.id

User Action: Tap "Book Now" or "Get Tickets"
Navigation: Navigator.push(EventBookingScreen(eventId: eventId))

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 3: BOOKING SELECTION                                       │
└─────────────────────────────────────────────────────────────────┘

Screen: event_booking_screen.dart
Providers:
  - eventConfigurationProvider(eventId)
  - availableTablesProvider(eventId)
Service: EventBookingService()
Database:
  - SELECT * FROM event_configurations WHERE event_id = $eventId
  - SELECT * FROM event_tables WHERE event_id = $eventId AND is_active = true

User sees two options (if enabled):
  A) Guestlist RSVP (free)
  B) Table Booking (paid)

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 3A: Guestlist RSVP (Free - No Payment)                    │
└─────────────────────────────────────────────────────────────────┘

User Action: Fill form (name, email, phone)
Service Call: EventBookingService().createGuestlistRSVP()
Database:
  INSERT INTO event_rsvps (
    event_id, user_id, rsvp_type, status, verification_code, ...
  ) VALUES (
    $eventId, $userId, 'guestlist', 'pending', $code, ...
  )

Edge Function: NONE (no payment required)
Result: RSVP created with status='pending'
        Verification code generated
        Email sent (via database trigger)

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 3B: Table Booking (Paid - CRITICAL PATH)                  │
└─────────────────────────────────────────────────────────────────┘

User Action: Select table, enter party size, special requests
Screen State: TableBookingFormData stored in local state
Service Call: NONE YET - no booking created yet

User Action: Tap "Proceed to Payment"
Method: _proceedToPayment()
Navigation: Navigator.push(PaymentScreen(...))

CRITICAL: At this point, NO booking exists in database yet

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 4: PAYMENT PROCESSING                                      │
└─────────────────────────────────────────────────────────────────┘

Screen: payment_screen.dart
Service: PaymentService()

Step 1: Create Payment Intent (Server-Side)
  Client calls: PaymentService().createPaymentIntent()
  Edge Function: create-payment-intent

  Edge Function Operations:
    1. Get/create Stripe customer
       - Check: SELECT * FROM stripe_customers WHERE user_id = $userId
       - If not exists: stripe.customers.create() + INSERT INTO stripe_customers

    2. Create Payment Intent
       - stripe.paymentIntents.create({
           amount, currency, customer, description, metadata
         })

    3. Create ephemeral key
       - stripe.ephemeralKeys.create({ customer })

    4. Store transaction in database
       - INSERT INTO payment_transactions (
           user_id, amount, status='pending',
           payment_intent_id, stripe_customer_id, ...
         )

  Returns to client:
    - payment_intent (client_secret)
    - ephemeral_key
    - customer_id
    - publishable_key
    - transaction_id

Step 2: Present Payment Sheet (Client-Side)
  Client calls: PaymentService().presentPaymentSheet()
  Uses: flutter_stripe package
  Operations:
    - Stripe.instance.initPaymentSheet()
    - Stripe.instance.presentPaymentSheet()

  User sees: Native Stripe Payment Sheet with:
    - Saved cards (if any)
    - New card form
    - Apple Pay button (if enabled)
    - Google Pay button (if enabled)

Step 3: User Completes Payment
  Three possible outcomes:
    a) SUCCESS: Payment processed by Stripe
    b) CANCELLED: User closes payment sheet
    c) FAILED: Card declined, insufficient funds, etc.

Step 4A: If SUCCESS (Client receives success from Stripe SDK)
  ┌───────────────────────────────────────────────────────────┐
  │ ❌ CRITICAL ISSUE #1: CLIENT-SIDE PAYMENT CONFIRMATION    │
  │                                                            │
  │ Current code calls widget.onPaymentSuccess() immediately  │
  │ This triggers EventBookingService().createTableBooking()  │
  │ BEFORE the webhook confirms payment!                      │
  │                                                            │
  │ RISK: Stripe SDK success != funds captured                │
  │       Payment could still fail server-side                │
  │       Booking created without payment confirmation        │
  └───────────────────────────────────────────────────────────┘

Current (WRONG) Flow:
  payment_screen.dart line 159-165:
    if (success && mounted) {
      _showSuccessDialog();
      widget.onPaymentSuccess?.call();  // ❌ CALLED TOO EARLY
    }

  event_booking_screen.dart line 1019-1029:
    onPaymentSuccess: () async {
      final booking = await EventBookingService().createTableBooking(...);
      // ❌ Booking created CLIENT-SIDE before webhook!
    }

Step 4B: Webhook Receives Payment Confirmation (Server-Side)
  ┌───────────────────────────────────────────────────────────┐
  │ ✅ CORRECT: Stripe Webhook (stripe-webhook function)      │
  │                                                            │
  │ This is where payment should be confirmed as SOURCE OF    │
  │ TRUTH, but currently the booking is already created by    │
  │ the client before this webhook fires!                     │
  └───────────────────────────────────────────────────────────┘

Edge Function: stripe-webhook
Event Received: payment_intent.succeeded

Webhook Operations:
  1. Verify signature: stripe.webhooks.constructEvent()
     ✅ GOOD: Signature verification prevents forged webhooks

  2. Update payment transaction:
     UPDATE payment_transactions
     SET status = 'paid', updated_at = NOW()
     WHERE payment_intent_id = $paymentIntentId

  3. Get transaction metadata:
     SELECT booking_id, event_id, user_id, metadata
     FROM payment_transactions
     WHERE payment_intent_id = $paymentIntentId

  4. Update booking (if exists):
     UPDATE event_table_bookings
     SET status = 'confirmed', payment_status = 'paid'
     WHERE id = $bookingId

  ❌ PROBLEM: The client already created the booking with
              status='pending_payment' before webhook fired!
              This creates a race condition.

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 5: BOOKING CONFIRMATION (Current Implementation)          │
└─────────────────────────────────────────────────────────────────┘

❌ CURRENT (WRONG) FLOW:
  1. Client receives Stripe SDK success
  2. Client IMMEDIATELY calls createTableBooking()
  3. Database INSERT happens:
     INSERT INTO event_table_bookings (
       event_id, user_id, table_id, status='pending_payment', ...
     )
  4. Client calls updateDepositPaymentStatus(booking.id, true)
  5. Database UPDATE happens:
     UPDATE event_table_bookings
     SET status='confirmed', payment_status='paid'
     WHERE id = $bookingId
  6. MEANWHILE: Webhook fires and tries to update booking
  7. Race condition: Who wins? Client or webhook?

✅ CORRECT FLOW (What it should be):
  1. Client receives Stripe SDK success
  2. Client shows "Processing..." state
  3. Webhook receives payment_intent.succeeded
  4. Webhook validates signature
  5. Webhook creates booking atomically:
     - Check table availability with row lock
     - Create booking with status='confirmed'
     - Decrement available capacity atomically
  6. Client polls or listens for booking confirmation
  7. Client shows success when booking.status = 'confirmed'

┌─────────────────────────────────────────────────────────────────┐
│ PHASE 6: TICKET/WALLET PASS GENERATION                          │
└─────────────────────────────────────────────────────────────────┘

After booking confirmed:

Screen: booking_success_dialog.dart
Service: WalletPassService()
Edge Function: generate-wallet-pass

User Action: Tap "Add to Apple Wallet"
Service Call: WalletPassService().generateWalletPass()
Operations:
  1. Call edge function with booking_id, event_id
  2. Edge function generates .pkpass file
  3. Returns download URL
  4. Client downloads and presents to Wallet app

Database:
  INSERT INTO wallet_passes (
    user_id, booking_id, event_id, pass_type_identifier,
    serial_number, pass_url, status='active'
  )

Result: User can add ticket to Apple Wallet

Screen: ticket_detail_screen.dart
Service: NONE (displays existing booking)
Database: SELECT * FROM event_table_bookings WHERE id = $bookingId

Displays:
  - QR code (from booking.id)
  - Event details
  - Table details
  - Booking status

---

## 2. Critical Issues & Required Fixes

### Issue #1: Client-Side Payment Confirmation ❌ CRITICAL

**Current State:**
- Client calls `onPaymentSuccess()` immediately after Stripe SDK returns success
- Booking is created before webhook confirms payment
- Client is source of truth (WRONG)

**Why This is Dangerous:**
- Stripe SDK success ≠ funds captured
- Network issues could prevent webhook from firing
- Malicious client could call onPaymentSuccess without paying
- Race condition between client and webhook updates

**Required Fix:**
1. Remove booking creation from `onPaymentSuccess` callback
2. Create booking in webhook after payment_intent.succeeded
3. Client should poll/subscribe to booking status
4. Show "Processing payment..." until booking.status = 'confirmed'

### Issue #2: No Atomic Capacity Management ❌ CRITICAL

**Current State:**
- `createTableBooking()` checks if table exists
- NO check for available capacity
- NO row locking
- NO atomic decrement of available spots

**Why This is Dangerous:**
- Two users can book the same table simultaneously
- Overbooking will occur under load
- No inventory tracking

**Required Fix:**
Create Postgres function:

```sql
CREATE OR REPLACE FUNCTION create_table_booking_atomic(
  p_event_id UUID,
  p_user_id UUID,
  p_table_id UUID,
  p_party_size INT,
  p_deposit_amount DECIMAL,
  p_metadata JSONB
) RETURNS UUID AS $$
DECLARE
  v_booking_id UUID;
  v_table_capacity INT;
  v_current_bookings INT;
BEGIN
  -- Lock the table row for update
  SELECT capacity INTO v_table_capacity
  FROM event_tables
  WHERE id = p_table_id AND event_id = p_event_id AND is_active = true
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Table not available';
  END IF;

  -- Count current confirmed bookings for this table
  SELECT COUNT(*) INTO v_current_bookings
  FROM event_table_bookings
  WHERE table_id = p_table_id
    AND event_id = p_event_id
    AND status IN ('confirmed', 'pending_payment');

  -- Check if table is available
  IF v_current_bookings >= 1 THEN
    RAISE EXCEPTION 'Table already booked';
  END IF;

  -- Create booking atomically
  INSERT INTO event_table_bookings (
    id, event_id, user_id, table_id, guest_count,
    deposit_amount, status, payment_status, metadata
  ) VALUES (
    gen_random_uuid(), p_event_id, p_user_id, p_table_id,
    p_party_size, p_deposit_amount, 'confirmed', 'paid', p_metadata
  ) RETURNING id INTO v_booking_id;

  RETURN v_booking_id;
END;
$$ LANGUAGE plpgsql;
```

### Issue #3: No Pending State Handling ❌ CRITICAL

**Current State:**
- Client shows success immediately
- No "processing payment" state
- No polling or realtime subscription
- User has no idea if payment is being processed

**Required Fix:**
1. After Stripe SDK success, show "Processing..." modal
2. Poll payment_transactions table:
   ```dart
   Future<void> _pollPaymentStatus(String transactionId) async {
     for (int i = 0; i < 30; i++) { // 30 seconds max
       await Future.delayed(Duration(seconds: 1));
       final status = await _checkPaymentStatus(transactionId);
       if (status == 'paid') {
         // Now fetch booking
         final booking = await _fetchBooking(eventId, userId);
         if (booking != null && booking.status == 'confirmed') {
           _showSuccess(booking);
           return;
         }
       } else if (status == 'failed') {
         _showError();
         return;
       }
     }
     _showTimeout(); // Webhook didn't fire in 30s
   }
   ```

3. OR use Supabase Realtime:
   ```dart
   final subscription = supabase
     .from('event_table_bookings')
     .stream(primaryKey: ['id'])
     .eq('user_id', userId)
     .eq('event_id', eventId)
     .listen((data) {
       if (data.isNotEmpty && data.first['status'] == 'confirmed') {
         _showSuccess();
         subscription.cancel();
       }
     });
   ```

### Issue #4: Missing Failure Recovery ❌ CRITICAL

**Current State:**
- If payment succeeds but booking creation fails: user charged, no booking
- If webhook fails: payment confirmed but no booking
- No retry mechanism
- No customer support flow

**Required Fix:**
1. Webhook should be idempotent (can run multiple times safely)
2. Add webhook retry in edge function:
   ```typescript
   // If booking creation fails, don't return 400
   // Return 200 to ack webhook, but log error for manual review
   try {
     await createBooking(...)
   } catch (error) {
     console.error('CRITICAL: Payment confirmed but booking failed', {
       paymentIntentId, userId, eventId, error
     })
     // Send alert to monitoring system
     // Return 200 so Stripe doesn't retry endlessly
     return new Response(JSON.stringify({
       received: true,
       booking_failed: true,
       requires_manual_review: true
     }), { status: 200 })
   }
   ```

3. Add manual recovery endpoint for support:
   ```typescript
   // supabase/functions/recover-failed-booking/index.ts
   // Allows support to manually create booking for confirmed payment
   ```

4. Client UI: Show support contact if stuck in "processing" > 1 minute

### Issue #5: Network Drop Mid-Checkout ⚠️

**Current State:**
- If user loses network after payment sheet closes
- No way to resume or check status
- User doesn't know if payment went through

**Required Fix:**
1. Store pending transaction in local state:
   ```dart
   await _localStorage.savePendingTransaction({
     'transaction_id': transactionId,
     'event_id': eventId,
     'table_id': tableId,
     'amount': amount,
     'timestamp': DateTime.now().toIso8601String(),
   });
   ```

2. On app resume, check for pending transactions:
   ```dart
   @override
   void initState() {
     super.initState();
     _checkPendingTransactions();
   }

   Future<void> _checkPendingTransactions() async {
     final pending = await _localStorage.getPendingTransactions();
     for (final txn in pending) {
       final status = await _checkPaymentStatus(txn['transaction_id']);
       if (status == 'paid') {
         final booking = await _fetchBooking(txn['event_id'], userId);
         if (booking != null) {
           _localStorage.removePendingTransaction(txn['transaction_id']);
           _showLateSuccessNotification(booking);
         }
       } else if (DateTime.now().difference(
         DateTime.parse(txn['timestamp'])
       ).inMinutes > 5) {
         // Payment still pending after 5 minutes - show support option
         _showSupportOption(txn);
       }
     }
   }
   ```

### Issue #6: Double-Tap Pay Button ⚠️

**Current State:**
- No debouncing on payment button
- User could double-tap and create two payment intents
- Both could succeed (double charge)

**Required Fix:**
```dart
bool _isProcessing = false;

Future<void> _handlePayment() async {
  if (_isProcessing) return; // Prevent double-tap

  setState(() {
    _isProcessing = true;
  });

  try {
    await _processPayment();
  } finally {
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
```

---

## 3. Recommended Architecture (Correct Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│ CORRECT PAYMENT + BOOKING FLOW                                  │
└─────────────────────────────────────────────────────────────────┘

CLIENT:
  1. User selects table
  2. User taps "Pay"
  3. Create payment intent (edge function)
     - metadata includes: event_id, table_id, user_id, party_size
  4. Present Stripe Payment Sheet
  5. User completes payment
  6. Stripe SDK returns success
  7. ✅ NEW: Show "Processing payment..." modal
  8. ✅ NEW: Poll payment_transactions OR subscribe via realtime
  9. ✅ NEW: Wait for booking.status = 'confirmed'
  10. Show success dialog with booking details

SERVER (Webhook):
  1. Receive payment_intent.succeeded
  2. Verify webhook signature
  3. Update payment_transactions.status = 'paid'
  4. Get metadata from payment_transactions
  5. ✅ NEW: Call create_table_booking_atomic() Postgres function
     - Locks table row
     - Checks capacity
     - Creates booking atomically
     - Decrements available capacity
  6. Update booking.status = 'confirmed'
  7. Send confirmation email (via trigger or edge function)

CLIENT (Polling/Realtime):
  1. Detects booking.status = 'confirmed'
  2. Close "Processing..." modal
  3. Show success dialog
  4. Navigate to ticket screen
  5. Clear local pending transaction
```

---

## 4. Summary of Required Changes

### Immediate (Blocking Production):

1. **Create Postgres function for atomic bookings** ✅ HIGH PRIORITY
   - File: `supabase/migrations/20260612_atomic_booking_function.sql`
   - Prevents double-booking
   - Implements row locking

2. **Move booking creation to webhook** ✅ HIGH PRIORITY
   - File: `supabase/functions/stripe-webhook/index.ts`
   - Call create_table_booking_atomic() on payment_intent.succeeded
   - Remove createTableBooking() from client onPaymentSuccess

3. **Add pending state handling** ✅ HIGH PRIORITY
   - File: `lib/features/payment/screens/payment_screen.dart`
   - Show "Processing..." after payment
   - Poll payment_transactions table
   - OR subscribe via Supabase Realtime

4. **Add failure recovery** ✅ HIGH PRIORITY
   - Handle payment succeeded but booking failed
   - Add support contact flow
   - Store pending transactions locally

### Important (Launch Blockers):

5. **Fix double-tap protection** ⚠️ MEDIUM PRIORITY
   - Add _isProcessing flag
   - Disable button while processing

6. **Add network resume handling** ⚠️ MEDIUM PRIORITY
   - Check pending transactions on app resume
   - Show late success notifications

7. **Update documentation** ⚠️ MEDIUM PRIORITY
   - Document correct flow for future developers

---

## 5. Testing Checklist

Before production:
- [ ] Test: Payment succeeds, booking created
- [ ] Test: Payment fails, no booking created
- [ ] Test: Payment succeeds but webhook delayed (polling works)
- [ ] Test: Two users try to book same table (one fails gracefully)
- [ ] Test: Network drops mid-payment (recovery on resume)
- [ ] Test: User double-taps pay button (only one payment created)
- [ ] Test: Webhook fails (manual recovery possible)
- [ ] Test: Payment succeeds but booking creation fails (support notified)

---

*Analysis completed: 2026-06-12*
*Status: CRITICAL FIXES REQUIRED BEFORE PRODUCTION*
