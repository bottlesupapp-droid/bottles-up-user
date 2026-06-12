-- =====================================================
-- EVENTS TABLE ROW LEVEL SECURITY
-- CRITICAL: Events table currently has NO RLS!
-- This migration enables RLS and adds proper policies
-- =====================================================

-- Enable Row Level Security on events table
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLICY 1: Public Read Access (Anon + Authenticated)
-- =====================================================
-- Users can ONLY see:
-- - Active events (is_active = true)
-- - Published events (status = 'active')
-- - Current or future events (not too old)
--
-- This prevents users from seeing:
-- - Draft events
-- - Cancelled events
-- - Test events
-- - Past events (older than 1 day)

CREATE POLICY "Public can read active published events"
  ON events FOR SELECT
  TO anon, authenticated
  USING (
    is_active = true
    AND status = 'active'
    AND event_date >= CURRENT_DATE - INTERVAL '1 day'
  );

-- =====================================================
-- POLICY 2: Vendor Management (Authenticated Users)
-- =====================================================
-- Vendors (authenticated users) can:
-- - View all their own events (including drafts)
-- - Insert new events
-- - Update their own events
-- - Delete their own events
--
-- Constraint: Can only manage events where user_id = auth.uid()

CREATE POLICY "Vendors can manage own events"
  ON events FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- POLICY 3: Service Role Full Access
-- =====================================================
-- Edge functions and backend services need full access
-- This allows:
-- - Automated event creation
-- - Batch updates
-- - Admin operations

CREATE POLICY "Service role full access to events"
  ON events FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================

-- Allow anonymous users to SELECT published events
GRANT SELECT ON events TO anon;

-- Allow authenticated users full CRUD on their own events
-- (Controlled by RLS policies above)
GRANT ALL ON events TO authenticated;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- Run these after deployment to verify RLS is working:

-- 1. Check RLS is enabled
-- SELECT tablename, rowsecurity
-- FROM pg_tables
-- WHERE tablename = 'events';
-- Expected: rowsecurity = true

-- 2. Test as anon user (should only see active published events)
-- SET ROLE anon;
-- SELECT count(*) FROM events;
-- SELECT count(*) FROM events WHERE status != 'active';  -- Should be 0
-- RESET ROLE;

-- 3. List all policies
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd
-- FROM pg_policies
-- WHERE tablename = 'events';

-- =====================================================
-- MIGRATION NOTES
-- =====================================================
--
-- This migration is CRITICAL for security and must be deployed ASAP.
--
-- Before this migration:
-- - ❌ Events table has NO RLS
-- - ❌ Anyone can read ALL events (drafts, cancelled, test events)
-- - ❌ Potential unauthorized write access
--
-- After this migration:
-- - ✅ RLS enabled
-- - ✅ Public users only see published events
-- - ✅ Vendors can manage their own events
-- - ✅ Service role can do everything
--
-- Impact:
-- - User app will only show published events (GOOD)
-- - Vendor app can still see all own events including drafts (GOOD)
-- - Edge functions can create/update events (GOOD)
--
-- Breaking Changes:
-- - If any code relies on seeing draft events without authentication: WILL BREAK
-- - If any public queries try to read cancelled events: WILL BREAK
-- - This is INTENTIONAL and CORRECT behavior
--
-- Rollback (if needed):
-- DROP POLICY "Public can read active published events" ON events;
-- DROP POLICY "Vendors can manage own events" ON events;
-- DROP POLICY "Service role full access to events" ON events;
-- ALTER TABLE events DISABLE ROW LEVEL SECURITY;
