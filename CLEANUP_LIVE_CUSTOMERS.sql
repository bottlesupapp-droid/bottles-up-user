-- ⚠️ CLEANUP SCRIPT: Remove LIVE mode customer IDs from database
-- This script helps clean up customer IDs that were created in LIVE mode
-- when switching to TEST mode

-- ==============================================================================
-- IMPORTANT: Run this in Supabase SQL Editor
-- ==============================================================================

-- 1. First, let's see how many LIVE customer records exist
SELECT
  id,
  user_id,
  stripe_customer_id,
  email,
  created_at
FROM stripe_customers
WHERE stripe_customer_id LIKE 'cus_%'
ORDER BY created_at DESC;

-- This will show all customer records with Stripe customer IDs

-- ==============================================================================
-- OPTION 1: Delete all Stripe customer records (recommended for TEST mode)
-- ==============================================================================
-- This forces the app to create new TEST mode customers for all users
-- Uncomment the line below to execute:

-- DELETE FROM stripe_customers;

-- After this, when users make payments, new TEST customers will be created

-- ==============================================================================
-- OPTION 2: Delete only specific user's customer record
-- ==============================================================================
-- Replace 'USER_ID_HERE' with the actual user_id from the error
-- Uncomment the line below to execute:

-- DELETE FROM stripe_customers WHERE user_id = 'USER_ID_HERE';

-- ==============================================================================
-- OPTION 3: Set customer IDs to NULL (keep the record, clear the ID)
-- ==============================================================================
-- This preserves the record but clears the LIVE customer ID
-- Uncomment the line below to execute:

-- UPDATE stripe_customers SET stripe_customer_id = NULL;

-- ==============================================================================
-- Verification: Check remaining records
-- ==============================================================================

SELECT
  COUNT(*) as total_customers,
  COUNT(stripe_customer_id) as with_customer_id,
  COUNT(*) - COUNT(stripe_customer_id) as without_customer_id
FROM stripe_customers;

-- ==============================================================================
-- NOTES
-- ==============================================================================
--
-- The edge function has been updated to automatically handle this situation:
-- - Detects if existing customer ID is from LIVE mode
-- - Creates new TEST customer if needed
-- - Updates database with new TEST customer ID
--
-- You typically DON'T need to run this script manually.
-- The edge function will handle it automatically on the next payment attempt.
--
-- Only run this script if you want to force a clean slate for all users.
-- ==============================================================================
