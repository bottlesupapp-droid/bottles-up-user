# Supabase Edge Functions - Deployment Guide

## ✅ Edge Functions Created

Two production-ready edge functions have been created:

1. **`create-checkout-session`** - Creates Stripe checkout sessions
2. **`stripe-webhook`** - Handles Stripe webhook events

---

## 📋 Prerequisites

- Supabase CLI installed (`v2.34.3` or later)
- Supabase account with project access
- Stripe account with API keys
- Database password for your Supabase project

---

## 🚀 Deployment Steps

### Step 1: Link to Your Supabase Project

```bash
cd /Users/abdulrazak/Downloads/bottles-up-user-main

# Link to your project
supabase link --project-ref hwmynlghrmtoufyrcihp
```

**Note**: You'll be prompted for your database password. Get it from:
https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/settings/database

### Step 2: Set Environment Secrets

You need to set three secrets in Supabase:

```bash
# Set Stripe Secret Key (get from Stripe Dashboard)
supabase secrets set STRIPE_SECRET_KEY=sk_live_YOUR_STRIPE_SECRET_KEY

# Set Stripe Webhook Secret (get after creating webhook in Stripe)
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_WEBHOOK_SECRET

# Verify secrets are set
supabase secrets list
```

**Where to get these keys:**

1. **STRIPE_SECRET_KEY**:
   - Go to https://dashboard.stripe.com/apikeys
   - Copy your **Secret key** (starts with `sk_live_` or `sk_test_`)

2. **STRIPE_WEBHOOK_SECRET**:
   - Will be provided after creating webhook (Step 4)

### Step 3: Deploy Edge Functions

```bash
# Deploy checkout session function
supabase functions deploy create-checkout-session

# Deploy webhook handler
supabase functions deploy stripe-webhook

# Verify deployment
supabase functions list
```

**Expected output:**
```
┌────────────────────────────┬─────────────┬───────────┬──────────────────┐
│ NAME                       │ VERSION     │ STATUS    │ CREATED AT       │
├────────────────────────────┼─────────────┼───────────┼──────────────────┤
│ create-checkout-session    │ v1          │ ACTIVE    │ 2026-05-03 ...   │
│ stripe-webhook             │ v1          │ ACTIVE    │ 2026-05-03 ...   │
│ generate-wallet-pass       │ v1          │ ACTIVE    │ 2025-03-19 ...   │
└────────────────────────────┴─────────────┴───────────┴──────────────────┘
```

### Step 4: Configure Stripe Webhook

1. Go to https://dashboard.stripe.com/webhooks
2. Click **"Add endpoint"**
3. Set endpoint URL to:
   ```
   https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/stripe-webhook
   ```
4. Select events to listen for:
   - `checkout.session.completed`
   - `checkout.session.expired`
   - `payment_intent.payment_failed`
   - `charge.refunded`
5. Click **"Add endpoint"**
6. Copy the **Signing secret** (starts with `whsec_`)
7. Set it in Supabase:
   ```bash
   supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET
   ```

### Step 5: Test the Functions

Test checkout session creation:

```bash
curl -X POST \
  https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/create-checkout-session \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user-123",
    "email": "test@example.com",
    "payment_type": "event_ticket",
    "amount": 5000,
    "currency": "usd",
    "description": "Test Event Ticket",
    "metadata": {
      "event_name": "Test Event"
    }
  }'
```

**Expected response:**
```json
{
  "success": true,
  "checkout_url": "https://checkout.stripe.com/c/pay/cs_test_...",
  "session_id": "cs_test_...",
  "transaction_id": "uuid",
  "expires_at": 1234567890
}
```

---

## 🔐 Security Configuration

### Required Secrets

| Secret | Description | Where to Get |
|--------|-------------|--------------|
| `STRIPE_SECRET_KEY` | Stripe API secret key | https://dashboard.stripe.com/apikeys |
| `STRIPE_WEBHOOK_SECRET` | Webhook signing secret | Stripe webhook settings after creation |
| `SUPABASE_URL` | Auto-provided | N/A (automatically set) |
| `SUPABASE_SERVICE_ROLE_KEY` | Auto-provided | N/A (automatically set) |

### Verify Secrets

```bash
# List all secrets (values hidden)
supabase secrets list

# Expected output:
# STRIPE_SECRET_KEY
# STRIPE_WEBHOOK_SECRET
# SUPABASE_URL
# SUPABASE_SERVICE_ROLE_KEY
```

---

## 📱 Flutter Integration

Your Flutter app is already configured to use these functions. The `PaymentService` class calls:

```dart
final response = await _supabase.functions.invoke(
  'create-checkout-session',
  body: {
    'user_id': user.id,
    'email': user.email,
    'payment_type': 'event_ticket',
    'amount': 5000, // $50.00 in cents
    'currency': 'usd',
    'description': 'Event Ticket - Concert Night',
    'event_id': eventId,
    'metadata': {...},
  },
);
```

**Function URL:**
```
https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/create-checkout-session
```

---

## 🔄 Payment Flow

```
1. User taps "Buy Tickets" in app
        ↓
2. App calls create-checkout-session edge function
        ↓
3. Edge function creates Stripe checkout session
        ↓
4. Edge function stores transaction in payment_transactions table
        ↓
5. Returns checkout URL to app
        ↓
6. App opens Stripe checkout in browser
        ↓
7. User completes payment
        ↓
8. Stripe sends webhook to stripe-webhook function
        ↓
9. Webhook updates payment_transactions.status = 'paid'
        ↓
10. Webhook updates booking status
        ↓
11. App polls database and shows success
```

---

## 🧪 Testing

### Test Mode (Recommended First)

1. Use Stripe test keys (start with `sk_test_` and `pk_test_`)
2. Set test keys as secrets:
   ```bash
   supabase secrets set STRIPE_SECRET_KEY=sk_test_YOUR_TEST_KEY
   ```

### Test Cards

```
Success: 4242 4242 4242 4242
Decline: 4000 0000 0000 0002
3D Secure: 4000 0025 0000 3155
```

### Production Mode

1. Switch to live keys (start with `sk_live_` and `pk_live_`)
2. Update secrets:
   ```bash
   supabase secrets set STRIPE_SECRET_KEY=sk_live_YOUR_LIVE_KEY
   ```

---

## 📊 Database Schema

The edge functions interact with these tables:

### `payment_transactions`

```sql
CREATE TABLE payment_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  booking_id UUID REFERENCES bookings(id),
  event_id UUID REFERENCES events(id),
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'usd',
  status VARCHAR(20) DEFAULT 'pending',
  stripe_session_id VARCHAR(255),
  payment_intent_id VARCHAR(255),
  payment_type VARCHAR(50),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Status Values

- `pending` - Payment session created, awaiting completion
- `paid` - Payment successful
- `failed` - Payment failed
- `cancelled` - Session expired or user cancelled
- `refunded` - Payment refunded

---

## 🐛 Troubleshooting

### Issue: "Stripe secret key not configured"

**Solution:**
```bash
supabase secrets set STRIPE_SECRET_KEY=sk_live_YOUR_KEY
```

### Issue: "Database insert failed"

**Cause**: `payment_transactions` table might not exist.

**Solution**: Run the migration:
```bash
supabase db push
```

### Issue: Webhook not firing

**Check:**
1. Webhook URL is correct
2. Webhook secret is set correctly
3. Selected correct events in Stripe dashboard
4. Check Stripe webhook logs

### Issue: Function not found

**Solution:**
```bash
# Redeploy
supabase functions deploy create-checkout-session
supabase functions deploy stripe-webhook
```

### View Function Logs

```bash
# Real-time logs
supabase functions logs create-checkout-session
supabase functions logs stripe-webhook

# Follow logs
supabase functions logs create-checkout-session --follow
```

---

## 📝 Environment Variables

The functions automatically receive these from Supabase:

- `SUPABASE_URL` - Your project URL
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key for admin operations
- `SUPABASE_ANON_KEY` - Anonymous key

You must set these manually:

- `STRIPE_SECRET_KEY` - Your Stripe secret key
- `STRIPE_WEBHOOK_SECRET` - Webhook signing secret

---

## 🔄 Updating Functions

If you need to update the functions:

```bash
# Make changes to the TypeScript files
# Then redeploy

supabase functions deploy create-checkout-session
supabase functions deploy stripe-webhook
```

**Note**: Secrets are preserved between deployments.

---

## 📦 Function Files

```
supabase/functions/
├── create-checkout-session/
│   └── index.ts          # Checkout session creation
├── stripe-webhook/
│   └── index.ts          # Webhook handler
└── generate-wallet-pass/
    └── index.ts          # Existing function (unchanged)
```

---

## ✅ Deployment Checklist

- [ ] Link Supabase project: `supabase link --project-ref hwmynlghrmtoufyrcihp`
- [ ] Set Stripe secret key: `supabase secrets set STRIPE_SECRET_KEY=...`
- [ ] Deploy checkout function: `supabase functions deploy create-checkout-session`
- [ ] Deploy webhook function: `supabase functions deploy stripe-webhook`
- [ ] Create webhook in Stripe Dashboard
- [ ] Set webhook secret: `supabase secrets set STRIPE_WEBHOOK_SECRET=...`
- [ ] Test with test cards
- [ ] Verify payment flow in app
- [ ] Check webhook logs in Stripe
- [ ] Switch to production keys when ready

---

## 🎯 Quick Start (Copy-Paste)

```bash
# 1. Navigate to project
cd /Users/abdulrazak/Downloads/bottles-up-user-main

# 2. Link project (enter password when prompted)
supabase link --project-ref hwmynlghrmtoufyrcihp

# 3. Set secrets (replace with your actual keys)
supabase secrets set STRIPE_SECRET_KEY=sk_test_YOUR_KEY

# 4. Deploy functions
supabase functions deploy create-checkout-session
supabase functions deploy stripe-webhook

# 5. Verify
supabase functions list
supabase secrets list

# 6. Configure webhook in Stripe Dashboard
# URL: https://hwmynlghrmtoufyrcihp.supabase.co/functions/v1/stripe-webhook

# 7. Set webhook secret
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET

# 8. Test the app!
flutter run
```

---

## 📞 Support

If you encounter issues:

1. Check function logs: `supabase functions logs create-checkout-session`
2. Check Stripe webhook logs: https://dashboard.stripe.com/webhooks
3. Verify secrets are set: `supabase secrets list`
4. Check database for transactions: Query `payment_transactions` table

---

**Status**: 🟢 Ready for deployment

**Next Step**: Follow the Quick Start guide above to deploy to production.
