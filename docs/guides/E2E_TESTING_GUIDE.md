# End-to-End Testing Guide

This guide provides step-by-step instructions to test all newly implemented features in the Bottles Up User app.

## Prerequisites

Before testing, ensure:
- ✅ Flutter app is running on a device/emulator
- ✅ Supabase backend is accessible
- ✅ User account is created and authenticated
- ✅ Location permissions are granted
- ✅ Test data exists in the database (venues, events)

## Feature Testing Checklist

### 1. Venue Discovery & Search

**Route:** `/venues`

**Test Steps:**
1. Navigate to venue discovery screen
2. Verify venues are loaded and displayed
3. Test filter functionality:
   - Tap filter icon in app bar
   - Select a city from dropdown
   - Enter minimum capacity (e.g., 100)
   - Enter maximum price (e.g., 500)
   - Select amenities (WiFi, Parking, etc.)
   - Tap "Apply Filters"
4. Verify filtered results match criteria
5. Test "Clear All" filters button
6. Pull to refresh the venue list

**Expected Results:**
- ✅ Venues display with image, name, location, rating, capacity, price
- ✅ Filters work correctly and update the list
- ✅ Empty state shows when no venues match filters
- ✅ Refresh reloads data

**Database Validation:**
```sql
-- Verify venues exist
SELECT id, name, city, capacity, price_per_hour, average_rating
FROM venues
LIMIT 10;

-- Check amenities
SELECT venue_id, amenity
FROM venue_amenities
LIMIT 10;
```

---

### 2. Venue Details & Rating

**Route:** `/venues/:id`

**Test Steps:**
1. From venue discovery, tap on a venue card
2. Verify venue detail screen loads:
   - Hero image with parallax scrolling
   - Venue name, rating, capacity, price
   - Description
   - Amenities chips
   - Contact information
3. Test contact actions:
   - Tap phone number (should open dialer)
   - Tap email (should open email app)
   - Tap website (should open browser)
4. Scroll to reviews section
5. Tap "Write a Review" button
6. Enter rating (1-5) using slider
7. Enter review text
8. Tap "Submit Review"
9. Verify review appears in list

**Expected Results:**
- ✅ All venue information displays correctly
- ✅ Contact actions trigger appropriate apps
- ✅ Review submission succeeds
- ✅ New review appears immediately
- ✅ Average rating updates

**Database Validation:**
```sql
-- Check venue details
SELECT * FROM venues WHERE id = 'your-venue-id';

-- Verify your review was saved
SELECT * FROM venue_ratings
WHERE venue_id = 'your-venue-id'
  AND user_id = auth.uid()
ORDER BY created_at DESC
LIMIT 1;

-- Check rating average was updated
SELECT average_rating, rating_count
FROM venues
WHERE id = 'your-venue-id';
```

---

### 3. Venue Inquiry System

**Route:** `/venues/:id/inquiry`

**Test Steps:**
1. From venue detail screen, tap "Send Inquiry" button
2. Fill out inquiry form:
   - Event name: "Birthday Party"
   - Select event date (future date)
   - Select start time
   - Select end time
   - Guest count: 50
   - Message: "Looking to book for a special occasion"
3. Tap "Send Inquiry"
4. Verify success message

**Expected Results:**
- ✅ Form validates all required fields
- ✅ Date picker only allows future dates
- ✅ Time pickers work correctly
- ✅ Inquiry submits successfully
- ✅ Success feedback shown

**Database Validation:**
```sql
-- Verify inquiry was created
SELECT * FROM venue_inquiries
WHERE user_id = auth.uid()
ORDER BY created_at DESC
LIMIT 1;

-- Check status is 'pending'
SELECT status, event_name, event_date, guest_count
FROM venue_inquiries
WHERE id = 'your-inquiry-id';
```

---

### 4. Venue Comparison

**Route:** `/venues/compare?venueIds=id1,id2,id3`

**Test Steps:**
1. Navigate to venue comparison (can be triggered from search with query params)
2. Verify comparison screen shows:
   - Venue header cards with images
   - Price comparison (lowest, highest, average)
   - Capacity comparison
   - Rating comparison
   - Amenities matrix
3. Test "Save Comparison" button:
   - Tap save icon in app bar
   - Enter comparison name: "Birthday Venue Options"
   - Tap "Save"
4. Verify success message

**Expected Results:**
- ✅ All comparison metrics calculate correctly
- ✅ Amenities matrix shows checkmarks for available amenities
- ✅ Save comparison works
- ✅ Comparison name is stored

**Database Validation:**
```sql
-- Verify comparison was saved
SELECT * FROM venue_comparisons
WHERE user_id = auth.uid()
ORDER BY created_at DESC
LIMIT 1;

-- Check venue IDs were stored correctly
SELECT comparison_id, venue_id
FROM venue_comparison_items
WHERE comparison_id = 'your-comparison-id';
```

---

### 5. Event Chat (Group Chat)

**Route:** `/events/:id/chat`

**Test Steps:**
1. Navigate to an event detail screen
2. Tap "Event Chat" option
3. Verify existing messages load
4. Send a test message: "Hello everyone!"
5. Verify message appears in chat
6. Test pinned messages (if host):
   - Long press on a message
   - Tap "Pin Message"
   - Verify message is pinned
   - Tap "View Pinned" in app bar
   - Verify pinned messages appear in bottom sheet
7. Test real-time updates:
   - Open app on second device/emulator
   - Send message from second device
   - Verify message appears on first device in real-time

**Expected Results:**
- ✅ Messages load correctly with timestamps
- ✅ New messages appear immediately
- ✅ Pin/unpin works for hosts
- ✅ Real-time subscription works
- ✅ Messages auto-scroll to bottom

**Database Validation:**
```sql
-- Check messages exist
SELECT * FROM event_chat_messages
WHERE event_id = 'your-event-id'
ORDER BY created_at DESC
LIMIT 10;

-- Verify pinned messages
SELECT message_id, is_pinned
FROM event_chat_messages
WHERE event_id = 'your-event-id'
  AND is_pinned = true;
```

**Real-time Test:**
```sql
-- Subscribe to changes (in Supabase Realtime)
-- Channel: event_chat:{event_id}
-- Should see INSERT events when new messages arrive
```

---

### 6. Event Polls

**Route:** `/events/:id/polls`

**Test Steps:**
1. Navigate to event polls screen
2. View existing polls
3. Create new poll (if host):
   - Tap "Create Poll" FAB
   - Question: "What music genre do you prefer?"
   - Add options: "Hip Hop", "EDM", "R&B", "Pop"
   - Select "Single Choice"
   - Tap "Create Poll"
4. Vote on a poll:
   - Tap on an option
   - Verify vote registers
   - Verify percentages update
5. Test real-time voting:
   - Open app on second device
   - Vote from second device
   - Verify vote count updates on first device

**Expected Results:**
- ✅ Polls display with current vote counts
- ✅ Poll creation works
- ✅ Voting updates percentages immediately
- ✅ Real-time vote updates work
- ✅ Progress bars show correct percentages

**Database Validation:**
```sql
-- Verify poll was created
SELECT * FROM event_polls
WHERE event_id = 'your-event-id'
ORDER BY created_at DESC
LIMIT 1;

-- Check poll options
SELECT poll_id, option_text, vote_count
FROM poll_options
WHERE poll_id = 'your-poll-id';

-- Verify your vote
SELECT * FROM poll_votes
WHERE poll_id = 'your-poll-id'
  AND user_id = auth.uid();
```

---

### 7. Host Announcements

**Route:** `/events/:id/announcements`

**Test Steps:**
1. Navigate to announcements screen
2. View existing announcements
3. Create announcement (if host):
   - Tap "New Announcement" FAB
   - Title: "Important Update"
   - Message: "Event start time changed to 9 PM"
   - Link: "https://example.com" (optional)
   - Toggle "Pin announcement"
   - Set priority slider to 8
   - Tap "Create"
4. Verify announcement appears at top (if pinned)
5. Test edit announcement:
   - Tap three-dot menu on announcement
   - Tap "Edit"
   - Modify message
   - Tap "Update"
6. Test delete announcement:
   - Tap three-dot menu
   - Tap "Delete"
   - Confirm deletion

**Expected Results:**
- ✅ Announcements load in correct order (pinned first, then by date)
- ✅ Create, edit, delete work for hosts
- ✅ Pin/unpin functionality works
- ✅ Links are clickable
- ✅ Pull to refresh reloads announcements

**Database Validation:**
```sql
-- Verify announcement was created
SELECT * FROM event_announcements
WHERE event_id = 'your-event-id'
ORDER BY is_pinned DESC, priority DESC, created_at DESC;

-- Check pinned status
SELECT id, title, is_pinned, priority
FROM event_announcements
WHERE event_id = 'your-event-id'
  AND is_pinned = true;
```

---

### 8. Ticket Transfer

**Route:** `/ticket-transfers`

**Test Steps:**
1. Navigate to ticket transfer screen
2. View "Received" tab:
   - Verify pending transfers appear
   - Tap "Accept" on a transfer
   - Confirm acceptance
   - Verify ticket is transferred
3. View "Sent" tab:
   - Verify sent transfers appear
   - Find pending transfer
   - Tap "Cancel"
   - Confirm cancellation
4. Test transfer expiration:
   - Check if expired transfers show warning

**Expected Results:**
- ✅ Tabs switch correctly
- ✅ Accept transfer moves ticket to your account
- ✅ Reject transfer returns ticket to sender
- ✅ Cancel transfer works for sender
- ✅ Status chips show correct state
- ✅ Expired transfers display warning

**Database Validation:**
```sql
-- Check received transfers
SELECT * FROM ticket_transfers
WHERE to_user_id = auth.uid()
  AND status = 'pending'
ORDER BY created_at DESC;

-- Check sent transfers
SELECT * FROM ticket_transfers
WHERE from_user_id = auth.uid()
ORDER BY created_at DESC;

-- Verify transfer status after accept
SELECT status, from_user_id, to_user_id, booking_id
FROM ticket_transfers
WHERE id = 'your-transfer-id';

-- Verify booking ownership changed
SELECT user_id FROM bookings
WHERE id = 'transferred-booking-id';
```

---

### 9. Image Upload Service

**Test Steps:**
1. Navigate to any screen that allows image upload (e.g., venue rating with photo)
2. Tap image upload button
3. Select "Gallery":
   - Choose image from gallery
   - Verify image uploads
   - Check image displays
4. Select "Camera":
   - Take photo with camera
   - Verify photo uploads
   - Check photo displays
5. Test multiple image upload (if supported):
   - Upload 3-5 images
   - Verify progress callback works
   - Check all images save correctly

**Expected Results:**
- ✅ Image picker opens correctly
- ✅ Selected images upload to Supabase Storage
- ✅ Public URLs are generated
- ✅ Images display correctly
- ✅ Unique filenames prevent collisions

**Supabase Storage Validation:**
```sql
-- Check storage buckets exist
SELECT * FROM storage.buckets
WHERE name IN ('venue-images', 'rating-images', 'announcement-images', 'chat-images');

-- View uploaded files (use Supabase Dashboard)
-- Navigate to Storage > venue-images (or appropriate bucket)
-- Verify files with format: {timestamp}_{userId}.{extension}
```

---

## Navigation Flow Testing

Test that all routes are accessible and navigation works:

```
/ (Splash)
  → /login
    → /home (Main Navigation)
      → /venues (Venue Discovery)
        → /venues/:id (Venue Detail)
          → /venues/:id/inquiry (Inquiry Form)
      → /venues/compare?venueIds=... (Comparison)
      → /events/:id (Event Detail)
        → /events/:id/chat (Event Chat)
        → /events/:id/polls (Event Polls)
        → /events/:id/announcements (Announcements)
      → /ticket-transfers (Ticket Transfers)
```

**Test Each Navigation:**
1. ✅ All routes load without errors
2. ✅ Back navigation works correctly
3. ✅ Deep links work (if configured)
4. ✅ Query parameters are parsed correctly

---

## Performance Testing

1. **Load Times:**
   - Venue list should load in < 2 seconds
   - Venue detail should load in < 1 second
   - Chat messages should load in < 1 second

2. **Real-time Performance:**
   - New chat messages appear within 1 second
   - Poll votes update within 1 second
   - No memory leaks from Realtime subscriptions

3. **Image Upload:**
   - Images compress appropriately (max 1920x1920, 85% quality)
   - Upload completes within 3-5 seconds on good connection

---

## Error Handling Testing

1. **Network Errors:**
   - Turn off internet
   - Navigate to screens
   - Verify error messages display
   - Turn on internet
   - Verify refresh works

2. **Invalid Data:**
   - Try submitting empty forms
   - Verify validation messages
   - Try invalid date/time selections
   - Verify proper error handling

3. **Permission Errors:**
   - Deny camera permission
   - Try taking photo
   - Verify error message
   - Deny gallery permission
   - Try selecting image
   - Verify error message

---

## Database RLS Testing

Test that Row Level Security policies work correctly:

```sql
-- Try to access another user's inquiry (should fail)
SELECT * FROM venue_inquiries
WHERE user_id != auth.uid();

-- Try to update another user's rating (should fail)
UPDATE venue_ratings
SET rating = 5
WHERE user_id != auth.uid();

-- Try to send chat message to event you're not attending (should fail)
INSERT INTO event_chat_messages (event_id, user_id, message)
VALUES ('not-your-event-id', auth.uid(), 'Test');
```

**Expected Results:**
- ✅ All unauthorized access attempts fail
- ✅ Users can only see/modify their own data
- ✅ Event participants can only access their event's data

---

## Cleanup After Testing

After testing is complete:

```sql
-- Delete test data
DELETE FROM venue_inquiries WHERE event_name LIKE '%Test%';
DELETE FROM venue_ratings WHERE review_text LIKE '%Test%';
DELETE FROM event_chat_messages WHERE message LIKE '%Test%';
DELETE FROM event_announcements WHERE title LIKE '%Test%';
```

---

## Known Issues / Limitations

Document any issues found during testing:
- [ ] Issue 1: Description
- [ ] Issue 2: Description

---

## Success Criteria

All features pass testing when:
- ✅ All CRUD operations work correctly
- ✅ Real-time updates function properly
- ✅ Error handling is graceful
- ✅ Data persists correctly in Supabase
- ✅ RLS policies enforce security
- ✅ UI is responsive and intuitive
- ✅ Navigation flows smoothly
- ✅ Images upload and display correctly

---

## Testing Checklist Summary

- [ ] Venue Discovery & Filters
- [ ] Venue Details & Rating
- [ ] Venue Inquiry Form
- [ ] Venue Comparison
- [ ] Event Chat (Real-time)
- [ ] Event Polls (Real-time)
- [ ] Host Announcements
- [ ] Ticket Transfer (Accept/Reject/Cancel)
- [ ] Image Upload Service
- [ ] Navigation & Routing
- [ ] Performance
- [ ] Error Handling
- [ ] Database RLS Security

---

## Next Steps

After completing E2E testing:
1. Document any bugs found
2. Run `flutter analyze` for code quality
3. Run `flutter test` for unit tests
4. Perform final build: `flutter build apk` or `flutter build ios`
5. Test on real devices (iOS and Android)
6. Prepare for deployment
