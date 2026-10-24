# ✅ Database Migration Successfully Deployed

## Migration Status: COMPLETE

The `stripe_customers` table has been successfully created and configured in your Supabase database.

---

## What Was Deployed

### 1. ✅ Table Created: `stripe_customers`

**Columns:**
- `id` (UUID, primary key)
- `user_id` (UUID, foreign key to auth.users)
- `stripe_customer_id` (VARCHAR, unique)
- `email` (VARCHAR)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

**Constraints:**
- Primary key on `id`
- Foreign key on `user_id` → `auth.users(id)` with CASCADE delete
- Unique constraint on `stripe_customer_id`
- Unique constraint on `user_id`

### 2. ✅ Indexes Created

- `idx_stripe_customers_user_id` - Fast lookups by user
- `idx_stripe_customers_stripe_id` - Fast lookups by Stripe customer ID
- Primary key index
- Unique indexes on `stripe_customer_id` and `user_id`

### 3. ✅ Row Level Security Enabled

**Policies:**
- **"Users can view their own Stripe customer"** - Users can SELECT their own customer records
- **"Service role can manage all Stripe customers"** - Edge functions can INSERT/UPDATE/DELETE

### 4. ✅ Auto-Update Trigger

**Function:** `update_stripe_customers_updated_at()`
- Automatically updates `updated_at` timestamp on record changes

**Trigger:** `stripe_customers_updated_at`
- Fires BEFORE UPDATE on every row

---

## Verification

All components verified:

```sql
-- Table structure verified ✅
SELECT * FROM information_schema.columns
WHERE table_name = 'stripe_customers';

-- Indexes verified ✅
idx_stripe_customers_user_id
idx_stripe_customers_stripe_id

-- RLS policies verified ✅
Users can view their own Stripe customer
Service role can manage all Stripe customers

-- Trigger verified ✅
stripe_customers_updated_at
```

---

## Note: payment_transactions

The migration attempted to add `stripe_customer_id` column to `payment_transactions`, but that table doesn't exist yet in your database.

**This is OK** - When you create the `payment_transactions` table later, make sure to include:

```sql
ALTER TABLE payment_transactions
ADD COLUMN stripe_customer_id VARCHAR(255);
```

Or include it in the initial CREATE TABLE statement.

---

## Next Steps

Now that the database migration is complete, you need to:

### 1. Set Stripe Publishable Key (Required)

```bash
supabase secrets set STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_KEY
```

Get your key from: https://dashboard.stripe.com/apikeys

### 2. Update Stripe Webhook Events (Required)

Add these events to your webhook in Stripe Dashboard:
- `payment_intent.succeeded`
- `payment_intent.payment_failed`

Go to: https://dashboard.stripe.com/webhooks

### 3. Update Flutter Checkout Screens (Required)

Replace browser checkout with in-app payment:

```dart
// Old browser method
final checkout = await paymentService.createCheckoutSession(...);
await paymentService.openCheckoutUrl(checkout.checkoutUrl);

// New in-app method
final intent = await paymentService.createPaymentIntent(...);
final success = await paymentService.presentPaymentSheet(paymentIntent: intent);
```

**See detailed examples in:** [IN_APP_PAYMENT_SETUP.md](IN_APP_PAYMENT_SETUP.md)

---

## Testing the Migration

You can test that the table works correctly:

### Test 1: Edge Function Can Write

When you make a payment, the `create-payment-intent` edge function will:
1. Create a Stripe customer
2. Insert a record into `stripe_customers`
3. Return customer ID to the app

### Test 2: Saved Cards Work

On second payment:
1. Edge function finds existing customer in `stripe_customers`
2. Reuses that customer ID
3. Payment Sheet shows saved cards

### Test 3: Users Can Read Their Own Data

A regular user can query:
```sql
SELECT * FROM stripe_customers WHERE user_id = auth.uid();
```

But cannot see other users' data (RLS protects this).

---

## Migration Summary

| Component | Status | Notes |
|-----------|--------|-------|
| stripe_customers table | ✅ Created | All columns present |
| Indexes | ✅ Created | Performance optimized |
| RLS Policies | ✅ Active | Security enabled |
| Auto-update trigger | ✅ Working | Timestamps managed |
| payment_transactions column | ⚠️ Skipped | Table doesn't exist yet |

---

## What This Enables

With this migration complete, your app can now:

1. **Save Customer IDs** - Map Supabase users to Stripe customers
2. **Saved Cards** - Users can save cards for future purchases
3. **One-Tap Checkout** - Returning users checkout instantly
4. **Secure Access** - RLS ensures data privacy
5. **Performance** - Indexes enable fast lookups
6. **Audit Trail** - created_at and updated_at timestamps

---

## Files Reference

**Migration File:** `supabase/migrations/20260503_stripe_customers.sql`

**Edge Function:** `supabase/functions/create-payment-intent/index.ts`
- Uses this table to store/retrieve customer IDs

**Payment Service:** `lib/core/services/payment_service.dart`
- Client-side code that calls the edge function

---

## Troubleshooting

### "Table not found" errors

If you get errors about stripe_customers not existing, run:

```sql
SELECT * FROM stripe_customers LIMIT 1;
```

If this returns an error, the migration didn't complete. Contact support.

### "Permission denied" errors

Make sure RLS is enabled:

```sql
SELECT tablename, rowsecurity
FROM pg_tables
WHERE tablename = 'stripe_customers';
```

Should show `rowsecurity = true`.

### Saved cards not appearing

Check if customer record exists:

```sql
SELECT * FROM stripe_customers
WHERE user_id = 'YOUR_USER_ID';
```

If empty, the edge function hasn't created a customer yet. Make a payment first.

---

## Production Checklist

Before going live:

- [x] stripe_customers table deployed
- [x] Indexes created
- [x] RLS policies active
- [ ] STRIPE_PUBLISHABLE_KEY secret set
- [ ] Stripe webhook events configured
- [ ] Flutter checkout screens updated
- [ ] End-to-end payment tested
- [ ] Saved card functionality tested

---

## Support

If you encounter issues:

1. **Check table exists:**
   ```bash
   supabase db diff
   ```

2. **Verify in Supabase Dashboard:**
   https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/editor

3. **Check edge function logs:**
   ```bash
   supabase functions logs create-payment-intent
   ```

---

**🎉 Migration Complete! Your database is ready for in-app payments with saved cards.**
