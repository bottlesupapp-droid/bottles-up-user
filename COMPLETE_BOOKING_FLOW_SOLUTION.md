# Complete Booking Flow - Clean Solution

## Current Status: Payment is Broken, Let's Fix the Foundation First

You're right - we're in a loop. Let's start fresh with a working foundation.

## What We Know WORKS

✅ **Event Table Booking** (event_booking_screen.dart lines 1026-1176)
- Uses PaymentScreen (in-app)
- Creates booking after payment
- Shows success dialog
- THIS IS OUR REFERENCE

## What's BROKEN

❌ **Event Ticket Purchase** (event_detail_screen.dart)
- Payment sheet fails to initialize
- Even when payment works, booking creation fails (RLS policy)

## The ROOT CAUSE

**Database Issue**: RLS (Row Level Security) policy on `events_bookings` table is blocking inserts from the client.

## SIMPLEST FIX - Two Options

### Option 1: Fix Database RLS Policy (RECOMMENDED)

Go to Supabase Dashboard → Authentication → Policies → `events_bookings` table

**Add this policy:**
```sql
-- Allow authenticated users to insert their own bookings
CREATE POLICY "Users can insert their own bookings"
ON events_bookings
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Allow users to read their own bookings
CREATE POLICY "Users can read their own bookings"
ON events_bookings
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);
```

Then the current code will work!

### Option 2: Create Edge Function for Booking Creation

Create `/supabase/functions/create-booking/index.ts`:

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  try {
    const { user_id, event_id, ticket_quantity, total_amount } = await req.json()

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' // Service role bypasses RLS
    )

    // Generate confirmation code
    const confirmationCode = `BU${Date.now().toString().slice(-8)}`

    // Insert booking (bypasses RLS with service role key)
    const { data, error } = await supabase
      .from('events_bookings')
      .insert({
        user_id,
        event_id,
        ticket_quantity,
        total_amount,
        status: 'confirmed',
        confirmation_code: confirmationCode,
        payment_status: 'paid',
        qr_code: confirmationCode,
      })
      .select()
      .single()

    if (error) throw error

    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})
```

Deploy:
```bash
supabase functions deploy create-booking
```

Then in event_detail_screen.dart, call the edge function instead of direct insert.

## COMPLETE WORKING FLOW (After RLS Fix)

### 1. Event Detail Screen - Buy Ticket

```dart
// event_detail_screen.dart _handleBooking()

void _handleBooking(String type) async {
  final event = ref.read(eventByIdProvider(widget.eventId)).valueOrNull;
  if (event == null) return;

  // Navigate to payment screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(
        amount: event.ticketPrice,
        description: 'Event Ticket - ${event.name}',
        paymentType: PaymentType.eventTicket,
        onPaymentSuccess: () async {
          await _createBooking(event);
        },
      ),
    ),
  );
}

Future<void> _createBooking(Event event) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser!;
  final code = 'BU${DateTime.now().millisecondsSinceEpoch}';

  await supabase.from('events_bookings').insert({
    'user_id': user.id,
    'event_id': event.id,
    'ticket_quantity': 1,
    'total_amount': event.ticketPrice,
    'status': 'confirmed',
    'confirmation_code': code,
    'payment_status': 'paid',
    'qr_code': code,
  });

  // Show success
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Ticket purchased! Code: $code'))
  );
}
```

### 2. Payment Screen (Already Exists)

- Uses Stripe Payment Sheet
- Calls `onPaymentSuccess` callback
- No changes needed (if Stripe works)

### 3. Booking Shows in My Bookings

- `userBookingsProvider` already queries `events_bookings`
- Will automatically show new booking
- QR code will display

## TESTING APPROACH

### Step 1: Test Booking Creation (Skip Payment)

Add a test button that creates a booking without payment:

```dart
// Temporary test button in event_detail_screen.dart
if (kDebugMode)
  TextButton(
    onPressed: () => _createBooking(event),
    child: Text('TEST: Create Booking (No Payment)'),
  ),
```

**Expected**:
1. Click button
2. Booking created in database
3. Success message shows
4. Booking appears in "My Bookings"

**If this fails**: Fix RLS policy or use edge function

### Step 2: Test Payment (Once Booking Works)

Once booking creation works, test the payment:

```dart
onPaymentSuccess: () async {
  await _createBooking(event); // This now works!
},
```

## IMMEDIATE ACTION PLAN

### Today - Get Booking Creation Working

1. **Fix RLS Policy** (5 minutes)
   - Go to Supabase Dashboard
   - Add INSERT policy for authenticated users
   - Test with temporary test button

2. **Verify Bookings Display** (2 minutes)
   - Check "My Bookings" tab
   - Verify booking shows with QR code

3. **Test End-to-End Flow** (10 minutes)
   - Browse event
   - Click "Buy Tickets"
   - Skip payment for now (use test button)
   - Verify booking created
   - Verify shows in "My Bookings"

### Tomorrow - Add Payment Back

Once booking creation is solid:

1. Check if event table booking payment works
2. If yes, copy that exact payment code
3. If no, we'll debug payment separately

## FILES TO CHANGE

**Minimal changes needed:**

1. **Supabase Dashboard** - Add RLS policy
2. **event_detail_screen.dart** - Simplify `_handleBooking` and `_createBooking`
3. **Test** - Add temporary test button

That's it. No payment changes needed yet.

## SUCCESS CRITERIA

✅ Can create booking (even without payment)
✅ Booking appears in database
✅ Booking shows in "My Bookings"
✅ QR code displays
✅ Confirmation code generated

Once this works, we add payment back.

## NEXT STEPS

1. **You**: Go to Supabase Dashboard, add RLS policy
2. **Me**: I'll create a simplified version of event_detail_screen.dart with test button
3. **Test**: Create a booking, verify it shows
4. **Then**: Add payment back once booking is solid

---

**Ready to fix the RLS policy?** Let me know and I'll guide you step-by-step.
