# Environment Setup Guide

## Security: Environment Variables

This app uses environment variables to securely manage API keys and secrets. **NEVER commit actual secrets to version control.**

## Required Environment Variables

Create a local `env.json` file (git-ignored) with your actual values:

```json
{
  "SUPABASE_URL": "https://hwmynlghrmtoufyrcihp.supabase.co",
  "SUPABASE_ANON_KEY": "your-actual-supabase-anon-key",
  "STRIPE_PUBLISHABLE_KEY": "pk_test_... or pk_live_..."
}
```

## Building the App

### Development Build

Use `--dart-define-from-file` to load environment variables:

```bash
flutter run --dart-define-from-file=env.json
```

### Production Build (Android)

```bash
flutter build apk --dart-define-from-file=env.json --release
flutter build appbundle --dart-define-from-file=env.json --release
```

### Production Build (iOS)

```bash
flutter build ios --dart-define-from-file=env.json --release
```

## Alternative: Individual --dart-define Flags

If you prefer not to use a JSON file:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGc... \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...
```

## CI/CD Setup

### GitHub Actions Example

Add secrets to your repository settings, then use in workflow:

```yaml
- name: Build APK
  run: |
    flutter build apk --release \
      --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
      --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }} \
      --dart-define=STRIPE_PUBLISHABLE_KEY=${{ secrets.STRIPE_PUBLISHABLE_KEY }}
```

## Stripe Configuration

### Client-Side (Mobile App)

- ✅ **ONLY** use Stripe **Publishable Key** (`pk_test_...` or `pk_live_...`)
- ❌ **NEVER** include Stripe **Secret Key** (`sk_test_...` or `sk_live_...`)

Secret keys grant full account control and must NEVER exist in mobile apps.

### Server-Side (Supabase Edge Functions)

All Stripe secret operations are handled by Supabase Edge Functions:

1. **create-payment-intent** - Creates PaymentIntent for in-app payments
2. **create-checkout-session** - Creates Checkout Session for browser payments
3. **stripe-webhook** - Handles payment confirmations from Stripe

Configure Stripe secrets in Supabase Dashboard → Settings → Edge Functions → Secrets:

```bash
# Set secrets via Supabase CLI
supabase secrets set STRIPE_SECRET_KEY=sk_test_...
supabase secrets set STRIPE_PUBLISHABLE_KEY=pk_test_...
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_...
```

## Supabase Configuration

### Anon Key (Client-Safe)

The `SUPABASE_ANON_KEY` is client-safe and used for:
- Authentication
- Row Level Security (RLS) queries
- Realtime subscriptions

### Service Role Key (Server-Only)

The Service Role Key bypasses RLS and must ONLY be used in Edge Functions:

```bash
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
```

## Security Best Practices

1. ✅ **DO** use environment variables for all secrets
2. ✅ **DO** add `env.json` to `.gitignore`
3. ✅ **DO** use `env.example.json` as a template (no real secrets)
4. ❌ **NEVER** commit real API keys to git
5. ❌ **NEVER** use Stripe secret keys client-side
6. ❌ **NEVER** trust client-provided amounts (validate server-side)

## Verification

After setup, verify configuration:

```bash
# This should run without errors
flutter run --dart-define-from-file=env.json

# If you see "not configured" errors, check your env.json values
```

## Getting Your Keys

### Supabase

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Settings → API
4. Copy `URL` and `anon` key (public)

### Stripe

1. Go to [Stripe Dashboard](https://dashboard.stripe.com)
2. Developers → API keys
3. Copy **Publishable key** only (`pk_test_...` for testing)
4. For production, use live keys (`pk_live_...`)

**IMPORTANT:** Never copy or use the Secret key (`sk_...`) in the mobile app!

## Test vs Production

### Test Mode

Use test keys for development:
- `pk_test_...` - Stripe test publishable key
- Use test cards: `4242 4242 4242 4242`

### Production Mode

Use live keys for production builds:
- `pk_live_...` - Stripe live publishable key
- Real transactions will be processed

## Troubleshooting

### "SUPABASE_URL not configured" Error

Ensure you're passing environment variables when running:

```bash
flutter run --dart-define-from-file=env.json
```

### "STRIPE_PUBLISHABLE_KEY not configured" Error

Check that your `env.json` contains the Stripe publishable key.

### Payment Fails Immediately

Verify Stripe secrets are configured in Supabase Edge Functions:

```bash
supabase secrets list
```

Should show: `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`
