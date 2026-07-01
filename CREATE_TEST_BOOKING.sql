-- Create a test booking for events_bookings table
-- This will help us test the "My Bookings" screen and ticket display

-- Step 1: Get the user ID for your email
-- Replace 'your-email@example.com' with your actual email
WITH user_data AS (
  SELECT id, email
  FROM auth.users
  WHERE email = 'arbazkdr7866@gmail.com'  -- CHANGE THIS TO YOUR EMAIL
  LIMIT 1
),

-- Step 2: Get an available event
event_data AS (
  SELECT id, name, event_date, start_time, end_time
  FROM events
  WHERE event_date >= CURRENT_DATE  -- Only future events
  ORDER BY event_date ASC
  LIMIT 1
)

-- Step 3: Insert the test booking
INSERT INTO events_bookings (
  user_id,
  event_id,
  ticket_quantity,
  total_amount,
  status,
  confirmation_code,
  payment_status,
  qr_code,
  created_at,
  updated_at
)
SELECT
  user_data.id as user_id,
  event_data.id as event_id,
  1 as ticket_quantity,
  0.00 as total_amount,  -- Free test booking
  'confirmed' as status,
  'TEST' || FLOOR(RANDOM() * 100000000)::TEXT as confirmation_code,
  'test' as payment_status,
  'TEST' || FLOOR(RANDOM() * 100000000)::TEXT as qr_code,
  NOW() as created_at,
  NOW() as updated_at
FROM user_data, event_data
RETURNING
  id,
  confirmation_code,
  qr_code,
  (SELECT name FROM events WHERE id = event_id) as event_name;

-- This will return the booking details including the confirmation code
