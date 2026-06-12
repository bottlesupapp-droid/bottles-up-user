# In-App Payment Setup Guide

## Overview

This guide shows you how to complete the setup for **in-app payments with saved card support** using Stripe Payment Sheet. Users can now pay without leaving the app and save their cards for faster future purchases.

---

## Step 1: Deploy Database Migration

The `stripe_customers` table stores the mapping between your users and Stripe customers (for saved cards).

### Deploy Migration

```bash
cd /Users/abdulrazak/Downloads/bottles-up-user-main

# Option 1: Using Supabase CLI (requires database password)
supabase db push

# Option 2: Using Supabase Dashboard
# 1. Go to https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/editor
# 2. Click "SQL Editor"
# 3. Copy contents of supabase/migrations/20260503_stripe_customers.sql
# 4. Paste and click "Run"
```

**Verify Migration:**
```bash
supabase db diff
# Should show no pending migrations
```

---

## Step 2: Set Stripe Publishable Key

The app needs the **publishable key** (safe for client-side) to initialize the Stripe Payment Sheet.

### Get Your Publishable Key

1. Go to https://dashboard.stripe.com/apikeys
2. Copy the **Publishable key** (starts with `pk_test_` or `pk_live_`)

### Set in Supabase

```bash
# Test mode (recommended first)
supabase secrets set STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_KEY_HERE

# Production mode (after testing)
supabase secrets set STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_KEY_HERE
```

**Verify Secret:**
```bash
supabase secrets list
```

You should see:
- STRIPE_SECRET_KEY (already set)
- STRIPE_PUBLISHABLE_KEY (newly set)
- STRIPE_WEBHOOK_SECRET (if webhook configured)

---

## Step 3: Update Stripe Webhook Events

Your webhook needs to handle **in-app payment events** in addition to browser checkout events.

### Add Events in Stripe Dashboard

1. Go to https://dashboard.stripe.com/webhooks
2. Find your webhook for: `https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/stripe-webhook`
3. Click **"Add events"**
4. Select these events:
   - ✅ `payment_intent.succeeded` (NEW - for in-app payments)
   - ✅ `payment_intent.payment_failed` (NEW - for in-app failures)
   - ✅ `checkout.session.completed` (existing - for browser checkout)
   - ✅ `checkout.session.expired` (existing)
   - ✅ `charge.refunded` (existing)
5. Click **"Add events"**

**Why:** The Payment Sheet uses Payment Intents, not Checkout Sessions. The webhook is already updated to handle both.

---

## Step 4: Update Flutter Checkout Screens

You have **two payment methods** available:

1. **In-App Payment Sheet** (RECOMMENDED) - No browser redirect, saved cards
2. **Browser Checkout** (Old method) - Opens Stripe in browser

### Option A: In-App Payment (RECOMMENDED)

Update your checkout screens to use `createPaymentIntent()` and `presentPaymentSheet()`.

#### Example: Update Event Booking

Find your event booking flow (e.g., `lib/features/events/screens/event_detail_screen.dart` or checkout screen):

```dart
import 'package:bottles_up/core/services/payment_service.dart';

// Inside your booking/checkout method:
Future<void> _handleInAppPayment() async {
  final paymentService = PaymentService();

  try {
    // Show loading
    setState(() => _isProcessing = true);

    // Step 1: Create Payment Intent
    final paymentIntent = await paymentService.createPaymentIntent(
      paymentType: 'event_booking',
      amount: totalAmount, // e.g., 50.00
      bookingId: bookingId, // Optional: if booking already created
      eventId: eventId,
      description: 'Tickets for ${eventName}',
      metadata: {
        'event_name': eventName,
        'ticket_count': ticketCount.toString(),
      },
    );

    // Step 2: Present Payment Sheet
    final success = await paymentService.presentPaymentSheet(
      paymentIntent: paymentIntent,
      enableGooglePay: true, // Android users can use Google Pay
      enableApplePay: true,  // iOS users can use Apple Pay
    );

    if (success) {
      // Payment successful!
      // Navigate to success screen or show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Check your orders.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to orders screen
        context.go('/profile/orders');
      }
    }
  } on PaymentException catch (e) {
    // Handle payment errors
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }
}
```

#### Example: Update Table Booking

For table bookings (`lib/features/bookings/` or similar):

```dart
Future<void> _bookTableWithPayment() async {
  final paymentService = PaymentService();

  try {
    // Calculate total (table price + bottles + addons)
    final double tablePrice = selectedTable.price;
    final double bottlesTotal = selectedBottles.fold(0.0, (sum, b) => sum + b.price);
    final double addonsTotal = selectedAddons.fold(0.0, (sum, a) => sum + a.price);
    final double total = tablePrice + bottlesTotal + addonsTotal;

    // Create booking first (status: 'pending')
    final booking = await _bookingService.createBooking(
      tableId: selectedTable.id,
      date: selectedDate,
      timeSlot: selectedTimeSlot,
      bottles: selectedBottles,
      addons: selectedAddons,
    );

    // Create Payment Intent
    final paymentIntent = await paymentService.createPaymentIntent(
      paymentType: 'table_booking',
      amount: total,
      bookingId: booking.id,
      description: 'Table booking at ${venue.name}',
      metadata: {
        'venue_id': venue.id,
        'table_id': selectedTable.id,
        'date': selectedDate.toIso8601String(),
      },
    );

    // Show Payment Sheet
    final success = await paymentService.presentPaymentSheet(
      paymentIntent: paymentIntent,
    );

    if (success) {
      // Webhook will automatically update booking.payment_status to 'paid'
      // and booking.status to 'confirmed'
      _showSuccessDialog(booking);
    }
  } catch (e) {
    _showErrorDialog(e.toString());
  }
}
```

### Option B: Browser Checkout (Keep Old Method)

If you want to keep browser checkout as a fallback or alternative:

```dart
Future<void> _handleBrowserPayment() async {
  final paymentService = PaymentService();

  try {
    // Create checkout session
    final checkout = await paymentService.createCheckoutSession(
      paymentType: 'event_booking',
      amount: totalAmount,
      eventId: eventId,
      description: 'Tickets for ${eventName}',
    );

    // Open browser
    await paymentService.openCheckoutUrl(checkout.checkoutUrl);

    // Poll for payment status
    // (Your existing polling logic)
  } catch (e) {
    // Handle error
  }
}
```

### Choosing Between Methods

| Feature | In-App Payment Sheet | Browser Checkout |
|---------|---------------------|------------------|
| User Experience | Seamless, no context switch | Opens browser |
| Saved Cards | ✅ Yes | ❌ No |
| Google Pay / Apple Pay | ✅ Yes | ✅ Yes |
| Setup Complexity | Medium | Easy |
| Best For | All use cases | Fallback option |

**Recommendation:** Use **In-App Payment Sheet** for all new bookings.

---

## Step 5: Test the Flow

### Test In-App Payment

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Test event booking:**
   - Go to Events tab
   - Tap any event
   - Tap "Buy Tickets"
   - **Expected:** Payment Sheet opens INSIDE the app (not browser)
   - Enter test card: `4242 4242 4242 4242`
   - Expiry: Any future date (e.g., `12/26`)
   - CVC: Any 3 digits (e.g., `123`)
   - **Expected:** Payment processes in-app
   - **Expected:** Success message, no browser redirect

3. **Test saved cards:**
   - Complete one payment with card `4242 4242 4242 4242`
   - Make another booking
   - **Expected:** Payment Sheet shows saved card as option
   - Select saved card
   - **Expected:** Payment completes without re-entering card details

4. **Test Google Pay / Apple Pay:**
   - Open Payment Sheet
   - **Expected:** Google Pay or Apple Pay button appears
   - Tap to pay with digital wallet
   - **Expected:** Payment completes instantly

### Test Error Scenarios

1. **Declined card:** Use `4000 0000 0000 0002`
   - **Expected:** Error message "Card declined", can retry

2. **Network error:** Turn off WiFi during payment
   - **Expected:** Error "Check your connection"

3. **Cancel payment:** Close Payment Sheet mid-payment
   - **Expected:** Payment cancelled, booking remains pending

### Verify Database Updates

After successful payment, check Supabase:

```sql
-- Check payment transaction
SELECT * FROM payment_transactions
WHERE user_id = 'YOUR_USER_ID'
ORDER BY created_at DESC
LIMIT 1;

-- Should show: status = 'paid', payment_intent_id = 'pi_xxx'

-- Check stripe customer was created
SELECT * FROM stripe_customers
WHERE user_id = 'YOUR_USER_ID';

-- Should show: stripe_customer_id = 'cus_xxx'

-- Check booking was confirmed
SELECT * FROM bookings
WHERE id = 'YOUR_BOOKING_ID';

-- Should show: status = 'confirmed', payment_status = 'paid'
```

---

## Step 6: QA Testing

Use the comprehensive test checklist to verify all features:

**Test Document:** [QA_TEST_CHECKLIST.md](QA_TEST_CHECKLIST.md)

**Priority Test Cases:**
- **UC-016:** Buy Event Tickets (In-App Payment)
- **UC-017:** Book VIP Table with In-App Payment
- **UC-018:** Payment with Saved Card
- **UC-019:** Payment Error Handling
- **UC-020:** Google Pay / Apple Pay

---

## Troubleshooting

### Error: "Failed to create payment intent"

**Possible Causes:**
1. Edge function not deployed
2. STRIPE_SECRET_KEY not set
3. User not authenticated

**Fix:**
```bash
# Verify function deployed
supabase functions list
# Should show: create-payment-intent

# Verify secrets
supabase secrets list
# Should show: STRIPE_SECRET_KEY, STRIPE_PUBLISHABLE_KEY

# Check function logs
supabase functions logs create-payment-intent
```

### Error: "No publishable key provided"

**Cause:** STRIPE_PUBLISHABLE_KEY not set in Supabase

**Fix:**
```bash
supabase secrets set STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_KEY
```

### Error: Payment Sheet doesn't show saved cards

**Possible Causes:**
1. stripe_customers table not created
2. Customer not properly stored
3. Using different Stripe account

**Fix:**
```bash
# Verify migration ran
supabase db diff

# Check if customer exists
# Run SQL query in Supabase Dashboard:
SELECT * FROM stripe_customers WHERE user_id = 'YOUR_USER_ID';

# If empty, make one payment and check again
```

### Error: Payment stays "pending" forever

**Cause:** Webhook not receiving events

**Fix:**
1. Verify webhook URL is correct: `https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/stripe-webhook`
2. Check Stripe webhook events include `payment_intent.succeeded`
3. Check webhook logs in Stripe Dashboard
4. Check edge function logs:
   ```bash
   supabase functions logs stripe-webhook
   ```

---

## Production Checklist

Before going live with real payments:

- [ ] Database migration deployed (`stripe_customers` table exists)
- [ ] STRIPE_SECRET_KEY set (using `sk_live_xxx`)
- [ ] STRIPE_PUBLISHABLE_KEY set (using `pk_live_xxx`)
- [ ] Webhook configured with `payment_intent.succeeded` event
- [ ] STRIPE_WEBHOOK_SECRET set
- [ ] Tested in-app payment with test cards
- [ ] Tested saved card functionality
- [ ] Tested Google Pay / Apple Pay (if applicable)
- [ ] Tested error scenarios (declined cards, network errors)
- [ ] Verified webhook updates database correctly
- [ ] Completed QA test checklist (220 test cases)
- [ ] Tested on both iOS and Android
- [ ] Stripe account activated (not in test mode)

---

## Summary

### What Changed

**Before:**
- Payment opens browser (Stripe Checkout)
- No saved cards
- Context switching disrupts UX

**After:**
- Payment happens IN-APP (Payment Sheet)
- Cards saved automatically
- Seamless, native experience
- Google Pay / Apple Pay support

### Key Benefits

1. **Better UX:** Users never leave the app
2. **Faster Checkout:** Saved cards = one-tap payments
3. **Higher Conversion:** Less friction = more completed purchases
4. **Modern Payment Methods:** Google Pay, Apple Pay, Link
5. **Secure:** PCI compliant, Stripe handles card data

### Files You May Need to Update

1. `lib/features/events/screens/event_detail_screen.dart` - Event booking
2. `lib/features/bookings/screens/` - Table booking screens
3. `lib/features/payment/screens/checkout_screen.dart` - General checkout
4. Any other screens that initiate payments

**Key Change:** Replace `createCheckoutSession()` with `createPaymentIntent()` + `presentPaymentSheet()`

---

## Quick Reference

### Payment Service Methods

```dart
// In-App Payment (RECOMMENDED)
final intent = await paymentService.createPaymentIntent(...);
final success = await paymentService.presentPaymentSheet(paymentIntent: intent);

// Browser Checkout (OLD METHOD)
final checkout = await paymentService.createCheckoutSession(...);
await paymentService.openCheckoutUrl(checkout.checkoutUrl);
```

### Edge Functions

- **create-payment-intent** - Returns Payment Intent for in-app payment
- **create-checkout-session** - Returns checkout URL for browser payment
- **stripe-webhook** - Handles both payment_intent and checkout events

### Secrets Required

```bash
STRIPE_SECRET_KEY=sk_test_xxx       # Server-side Stripe API key
STRIPE_PUBLISHABLE_KEY=pk_test_xxx  # Client-side Stripe key
STRIPE_WEBHOOK_SECRET=whsec_xxx     # Webhook signature verification
```

---

## Need Help?

1. **Check Function Logs:**
   ```bash
   supabase functions logs create-payment-intent --tail
   supabase functions logs stripe-webhook --tail
   ```

2. **Check Database:**
   - Go to https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/editor
   - Tables: `stripe_customers`, `payment_transactions`, `bookings`

3. **Check Stripe Dashboard:**
   - Payments: https://dashboard.stripe.com/payments
   - Webhooks: https://dashboard.stripe.com/webhooks
   - Logs: https://dashboard.stripe.com/logs

4. **Test Mode Cards:**
   - Success: `4242 4242 4242 4242`
   - Declined: `4000 0000 0000 0002`
   - 3D Secure: `4000 0025 0000 3155`

---

**You're all set! Your app now has a world-class in-app payment experience.** 🎉
