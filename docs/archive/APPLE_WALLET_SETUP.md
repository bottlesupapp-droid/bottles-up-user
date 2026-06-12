# Apple Wallet Integration Setup Guide

This guide will help you complete the Apple Wallet integration for event bookings and RSVPs.

## Overview

The Apple Wallet integration allows users to save their event tickets (both RSVP and table bookings) directly to their Apple Wallet on iOS devices. The implementation includes:

- ✅ Flutter models and services
- ✅ Add to Wallet button widgets
- ✅ Success dialogs with wallet options
- ✅ Supabase Edge Function for pass generation
- ✅ Database migration for wallet_passes table
- ⏳ Database migration application (manual)
- ⏳ Storage bucket creation (manual)
- ⏳ Edge Function deployment (manual)
- ⏳ Apple Developer setup (manual)

## Prerequisites

1. **Apple Developer Account** (required for production)
   - Enroll at https://developer.apple.com
   - Cost: $99/year
   - Needed to create Pass Type IDs and signing certificates

2. **Supabase Project** (already set up)
   - Project URL: `https://hwmynlghrmtoufyrcihp.supabase.co`

## Step 1: Apply Database Migration

Apply the wallet_passes table migration to your Supabase database:

```bash
# Using Supabase CLI
supabase db push

# OR manually via Supabase Dashboard
# 1. Go to https://supabase.com/dashboard/project/YOUR_PROJECT/editor
# 2. Open SQL Editor
# 3. Copy and paste the contents of supabase/migrations/create_wallet_passes_table.sql
# 4. Click "Run"
```

Alternatively, you can use the MCP Supabase tool:
```bash
# The migration file is located at:
# supabase/migrations/create_wallet_passes_table.sql
```

## Step 2: Create Storage Bucket

Create a storage bucket for wallet pass files:

### Via Supabase Dashboard:
1. Go to https://supabase.com/dashboard/project/YOUR_PROJECT/storage/buckets
2. Click "New bucket"
3. Name: `wallet-passes`
4. Public: Yes (passes need to be downloadable)
5. Click "Create bucket"

### Via SQL (Alternative):
```sql
-- Create storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('wallet-passes', 'wallet-passes', true);

-- Set up storage policies
CREATE POLICY "Users can upload their own passes"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'wallet-passes' AND
    (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Public can download passes"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'wallet-passes');
```

## Step 3: Deploy Supabase Edge Function

Deploy the wallet pass generation Edge Function:

```bash
# Install Supabase CLI if not already installed
brew install supabase/tap/supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref hwmynlghrmtoufyrcihp

# Deploy the Edge Function
supabase functions deploy generate-wallet-pass

# Verify deployment
supabase functions list
```

## Step 4: Apple Developer Setup (Production Only)

For production Apple Wallet passes, you need to set up Apple Developer credentials:

### 4.1 Create Pass Type ID
1. Go to https://developer.apple.com/account/resources/identifiers/list/passTypeId
2. Click "+" to create a new Pass Type ID
3. Description: "Bottles Up Event Tickets"
4. Identifier: `pass.com.bottlesup.event`
5. Click "Continue" and "Register"

### 4.2 Create Pass Type ID Certificate
1. On your Mac, open Keychain Access
2. Go to Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority
3. Enter your email and name
4. Select "Saved to disk"
5. Save the .certSigningRequest file
6. Go back to https://developer.apple.com/account/resources/identifiers/list/passTypeId
7. Click on your Pass Type ID
8. Click "Create Certificate"
9. Upload the .certSigningRequest file
10. Download the certificate (.cer file)
11. Double-click to install in Keychain Access
12. Export as .p12 file (you'll need the password later)

### 4.3 Update Edge Function with Credentials
1. Convert .p12 to base64:
   ```bash
   base64 -i certificate.p12 -o certificate.txt
   ```

2. Set Supabase secrets:
   ```bash
   supabase secrets set APPLE_PASS_TYPE_ID=pass.com.bottlesup.event
   supabase secrets set APPLE_TEAM_ID=YOUR_TEAM_ID
   supabase secrets set APPLE_CERTIFICATE_BASE64=<contents of certificate.txt>
   supabase secrets set APPLE_CERTIFICATE_PASSWORD=<your p12 password>
   ```

3. Update the Edge Function code to use these secrets and properly sign the passes

## Step 5: Testing

### Development Testing (Without Apple Certificate)
The current implementation creates pass JSON files that can be tested. To test:

1. Run the app on an iOS simulator or device
2. Complete an event booking or RSVP
3. Click "Add to Apple Wallet" button
4. The pass JSON will be generated and stored

**Note**: Without Apple certificates, the pass won't actually open in Wallet, but you can verify:
- Pass is created in database
- Pass file is stored in Supabase Storage
- QR codes are generated correctly

### Production Testing (With Apple Certificate)
Once you've set up Apple Developer credentials:

1. Update Edge Function to sign passes properly
2. Deploy updated function
3. Complete a booking
4. Click "Add to Apple Wallet"
5. The .pkpass file should open in Apple Wallet

## Implementation Details

### Files Created/Modified

**Models:**
- `lib/features/events/models/wallet_pass.dart` - Wallet pass data model

**Services:**
- `lib/features/events/services/wallet_pass_service.dart` - Service for pass generation

**Providers:**
- `lib/features/events/providers/wallet_pass_provider.dart` - Riverpod providers

**Widgets:**
- `lib/features/events/widgets/add_to_wallet_button.dart` - Add to Wallet button
- `lib/features/events/widgets/booking_success_dialog.dart` - Success dialog with wallet option

**Backend:**
- `supabase/functions/generate-wallet-pass/index.ts` - Edge Function for pass generation
- `supabase/migrations/create_wallet_passes_table.sql` - Database schema

**Dependencies Added:**
- `path_provider: ^2.1.2` - For file path management
- `qr_flutter: ^4.1.0` - For QR code generation

### How It Works

1. **User completes booking/RSVP**
   - For table bookings: After successful payment
   - For RSVPs: Immediately after submission

2. **"Add to Apple Wallet" button appears**
   - Only shown on iOS devices
   - Shows in success dialog or success section

3. **User clicks button**
   - App calls `WalletPassService.generateRsvpPass()` or `generateTableBookingPass()`
   - Service calls Supabase Edge Function with booking details
   - Edge Function generates pass JSON (and .pkpass in production)
   - Pass file uploaded to Supabase Storage
   - Pass record saved to database

4. **Pass download and sharing**
   - App downloads the pass file
   - Uses share functionality to present the pass
   - iOS recognizes .pkpass format and offers to add to Wallet

### Pass Contents

Each pass includes:
- **Event name and details**
- **Venue information**
- **Date and time**
- **QR code** (for check-in)
- **Verification code** (for RSVPs)
- **Table number** (for table bookings)
- **Party size**
- **Booking ID**

## Troubleshooting

### "Failed to generate wallet pass"
- Check Supabase Edge Function logs
- Verify storage bucket exists and is public
- Check user authentication

### "Apple Wallet is only available on iOS"
- This is expected on Android/web
- The button automatically hides on non-iOS platforms

### Pass won't open in Wallet
- Without Apple Developer certificates, passes won't open
- Complete Step 4 for production functionality

### Storage permission errors
- Verify storage bucket policies are set correctly
- Check RLS policies on wallet_passes table

## Future Enhancements

Potential improvements for the Apple Wallet integration:

1. **Push Notifications**
   - Update passes when event details change
   - Send reminders before events

2. **Location-Based Notifications**
   - Show pass when user arrives at venue
   - Add venue coordinates to passes

3. **Pass Updates**
   - Allow users to update passes if booking changes
   - Reflect payment status changes

4. **Analytics**
   - Track how many users add passes to Wallet
   - Monitor pass usage at events

5. **Android Google Wallet Support**
   - Similar functionality for Android users
   - Unified API for both platforms

## Support

For issues or questions:
- Check Supabase logs: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/logs
- Review Flutter debug console
- Verify all setup steps completed

## References

- [Apple Wallet Developer Guide](https://developer.apple.com/wallet/)
- [PassKit Package Format Reference](https://developer.apple.com/library/archive/documentation/UserExperience/Reference/PassKit_Bundle/Chapters/Introduction.html)
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Supabase Storage](https://supabase.com/docs/guides/storage)
