-- =====================================================
-- ADD USER APP SPECIFIC EVENT FIELDS
-- Optional migration to sync schema with user app expectations
-- =====================================================

-- Add columns that user app expects but aren't in current schema
ALTER TABLE events
ADD COLUMN IF NOT EXISTS invitation_code VARCHAR(50),
ADD COLUMN IF NOT EXISTS is_private BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS location_hidden BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS table_arrangement_image_url TEXT,
ADD COLUMN IF NOT EXISTS rsvp_count INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS table_booking_count INT DEFAULT 0;

-- Add useful indexes
CREATE INDEX IF NOT EXISTS idx_events_invitation_code
  ON events(invitation_code)
  WHERE invitation_code IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_events_is_private
  ON events(is_private)
  WHERE is_private = true;

CREATE INDEX IF NOT EXISTS idx_events_status_active
  ON events(status, is_active)
  WHERE is_active = true;

-- Add comments
COMMENT ON COLUMN events.invitation_code IS 'Private event access code';
COMMENT ON COLUMN events.is_private IS 'Event requires invitation code to view';
COMMENT ON COLUMN events.location_hidden IS 'Hide venue location until user RSVPs';
COMMENT ON COLUMN events.table_arrangement_image_url IS 'URL to table layout diagram';
COMMENT ON COLUMN events.rsvp_count IS 'Cached count of RSVPs';
COMMENT ON COLUMN events.table_booking_count IS 'Cached count of table bookings';

-- =====================================================
-- MIGRATION NOTES
-- =====================================================
--
-- This migration adds columns that the user app expects but the vendor app
-- doesn't currently write. These fields enable:
--
-- 1. invitation_code - Private events with access codes
-- 2. is_private - Mark events as private/invite-only
-- 3. location_hidden - Hide venue until user confirms
-- 4. table_arrangement_image_url - Show table layout
-- 5. rsvp_count - Cached RSVP count for performance
-- 6. table_booking_count - Cached booking count for performance
--
-- Status: OPTIONAL
-- These fields are not required for basic functionality but enable
-- advanced features in the user app.
--
-- Vendor App Impact:
-- - Vendor app should be updated to write these fields when creating events
-- - If not updated, events will use default values (safe)
--
-- User App Impact:
-- - User app already has defaults for these fields
-- - No changes needed in user app
--
-- Next Steps:
-- 1. Deploy this migration
-- 2. Update vendor app to write new fields (optional)
-- 3. Update user app to use new fields (already does via defaults)
