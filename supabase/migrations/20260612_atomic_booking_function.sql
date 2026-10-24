-- =====================================================
-- ATOMIC TABLE BOOKING FUNCTION
-- Prevents race conditions and double-booking
-- =====================================================

-- Function to atomically create a table booking with capacity checking and row locking
CREATE OR REPLACE FUNCTION create_table_booking_atomic(
  p_event_id UUID,
  p_user_id UUID,
  p_table_id UUID,
  p_party_size INT,
  p_deposit_amount DECIMAL,
  p_minimum_bottles INT,
  p_special_requests TEXT DEFAULT NULL,
  p_contact_email TEXT DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS UUID AS $$
DECLARE
  v_booking_id UUID;
  v_table_capacity INT;
  v_current_bookings INT;
  v_table_name TEXT;
BEGIN
  -- Lock the table row FOR UPDATE to prevent concurrent bookings
  -- This ensures only one transaction can book this table at a time
  SELECT capacity, name INTO v_table_capacity, v_table_name
  FROM event_tables
  WHERE id = p_table_id
    AND event_id = p_event_id
    AND is_active = true
  FOR UPDATE NOWAIT; -- NOWAIT fails immediately if locked, rather than waiting

  -- If table not found or not available
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Table not available for booking' USING ERRCODE = '90001';
  END IF;

  -- Validate party size
  IF p_party_size > v_table_capacity THEN
    RAISE EXCEPTION 'Party size (%) exceeds table capacity (%)', p_party_size, v_table_capacity USING ERRCODE = '90002';
  END IF;

  -- Count current confirmed or pending bookings for this table at this event
  -- A table can only have ONE active booking at a time
  SELECT COUNT(*) INTO v_current_bookings
  FROM event_table_bookings
  WHERE table_id = p_table_id
    AND event_id = p_event_id
    AND status IN ('confirmed', 'pending_payment')
    AND (cancelled_at IS NULL OR cancelled_at > NOW()); -- Not cancelled

  -- Check if table is already booked
  IF v_current_bookings >= 1 THEN
    RAISE EXCEPTION 'Table "%" is already booked for this event', v_table_name USING ERRCODE = '90003';
  END IF;

  -- All checks passed - create booking atomically
  INSERT INTO event_table_bookings (
    id,
    event_id,
    user_id,
    table_id,
    guest_count,
    deposit_amount,
    bottle_minimum,
    special_requests,
    contact_email,
    status,
    payment_status,
    metadata,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    p_event_id,
    p_user_id,
    p_table_id,
    p_party_size,
    p_deposit_amount,
    p_minimum_bottles,
    p_special_requests,
    COALESCE(p_contact_email, (SELECT email FROM auth.users WHERE id = p_user_id)),
    'confirmed', -- Created as confirmed since called from webhook after payment
    'paid',      -- Payment already confirmed by webhook
    p_metadata,
    NOW(),
    NOW()
  ) RETURNING id INTO v_booking_id;

  -- Log successful booking for audit trail
  RAISE NOTICE 'Booking created: % for user % at table %', v_booking_id, p_user_id, v_table_name;

  RETURN v_booking_id;

EXCEPTION
  WHEN lock_not_available THEN
    RAISE EXCEPTION 'Table is being booked by another user. Please try again.' USING ERRCODE = '90004';
  WHEN OTHERS THEN
    -- Re-raise the exception to rollback transaction
    RAISE;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to authenticated users (via service role in edge functions)
GRANT EXECUTE ON FUNCTION create_table_booking_atomic TO authenticated;
GRANT EXECUTE ON FUNCTION create_table_booking_atomic TO service_role;

-- =====================================================
-- FUNCTION TO CHECK TABLE AVAILABILITY
-- Non-locking version for display purposes only
-- =====================================================

CREATE OR REPLACE FUNCTION check_table_availability(
  p_event_id UUID,
  p_table_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_is_available BOOLEAN;
BEGIN
  -- Check if table exists and is active
  IF NOT EXISTS (
    SELECT 1 FROM event_tables
    WHERE id = p_table_id
      AND event_id = p_event_id
      AND is_active = true
  ) THEN
    RETURN false;
  END IF;

  -- Check if table has any active bookings
  SELECT NOT EXISTS (
    SELECT 1 FROM event_table_bookings
    WHERE table_id = p_table_id
      AND event_id = p_event_id
      AND status IN ('confirmed', 'pending_payment')
      AND (cancelled_at IS NULL OR cancelled_at > NOW())
  ) INTO v_is_available;

  RETURN v_is_available;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION check_table_availability TO authenticated;
GRANT EXECUTE ON FUNCTION check_table_availability TO anon;

-- =====================================================
-- FUNCTION TO CANCEL BOOKING AND FREE TABLE
-- =====================================================

CREATE OR REPLACE FUNCTION cancel_table_booking(
  p_booking_id UUID,
  p_user_id UUID,
  p_reason TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
  v_booking_user_id UUID;
  v_booking_status TEXT;
BEGIN
  -- Get booking details and lock row
  SELECT user_id, status INTO v_booking_user_id, v_booking_status
  FROM event_table_bookings
  WHERE id = p_booking_id
  FOR UPDATE;

  -- Check if booking exists
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Booking not found' USING ERRCODE = '90005';
  END IF;

  -- Check if user owns this booking
  IF v_booking_user_id != p_user_id THEN
    RAISE EXCEPTION 'Unauthorized: You can only cancel your own bookings' USING ERRCODE = '90006';
  END IF;

  -- Check if booking is already cancelled
  IF v_booking_status = 'cancelled' THEN
    RAISE EXCEPTION 'Booking is already cancelled' USING ERRCODE = '90007';
  END IF;

  -- Update booking to cancelled
  UPDATE event_table_bookings
  SET
    status = 'cancelled',
    cancelled_at = NOW(),
    metadata = jsonb_set(
      COALESCE(metadata, '{}'::jsonb),
      '{cancellation_reason}',
      to_jsonb(COALESCE(p_reason, 'User cancellation'))
    ),
    updated_at = NOW()
  WHERE id = p_booking_id;

  RAISE NOTICE 'Booking cancelled: % by user %', p_booking_id, p_user_id;

  RETURN true;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION cancel_table_booking TO authenticated;

-- =====================================================
-- MIGRATION NOTES
-- =====================================================

-- This migration adds:
-- 1. create_table_booking_atomic() - Creates bookings with row-level locking to prevent double-booking
-- 2. check_table_availability() - Fast non-locking check for UI display
-- 3. cancel_table_booking() - Safely cancels bookings and frees up tables
--
-- Usage from Stripe webhook:
--   SELECT create_table_booking_atomic(
--     event_id, user_id, table_id, party_size, deposit_amount, ...
--   );
--
-- Error Codes:
--   90001: Table not available
--   90002: Party size exceeds capacity
--   90003: Table already booked
--   90004: Table locked by concurrent transaction
--   90005: Booking not found
--   90006: Unauthorized cancellation
--   90007: Already cancelled
--
-- Performance:
--   - Uses row-level locking (FOR UPDATE NOWAIT) to prevent race conditions
--   - Atomic transaction ensures consistency
--   - NOWAIT ensures fast failure instead of deadlock
