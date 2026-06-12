## UI Testing & Validation Guide

**Status**: ✅ Backend Complete | 🚧 UI Screens Created | 📱 Ready for Testing

---

## 🎯 What's Been Implemented

### ✅ Backend (100% Complete)
- All 9 database tables created
- All service classes implemented
- All Riverpod providers generated
- Real-time subscriptions configured
- Security policies in place

### ✅ UI Screens Created (50% Complete)
1. **Venue Discovery Screen** ✅
2. **Venue Detail Screen** ✅
3. **Event Chat Screen** ✅ (with Real-time)
4. **Event Polls Screen** ✅ (with Real-time)

### 🚧 UI Screens Pending
5. Venue Comparison Screen
6. Venue Inquiry Form
7. Host Announcements Screen
8. Ticket Transfer Screen
9. Navigation route updates

---

## 📱 Testing the Implemented Screens

### 1. Venue Discovery Screen

**Location**: `lib/features/venues/screens/venue_discovery_screen.dart`

**How to Test**:
```dart
// Add to your router or navigate manually
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const VenueDiscoveryScreen(),
  ),
);
```

**What to Test**:
- ✅ Venue list loads from database
- ✅ Filtering by city, capacity, price
- ✅ Amenities filter chips
- ✅ Pull to refresh
- ✅ Empty state message
- ✅ Tap venue to navigate to details

**Test Data Needed**:
```sql
-- Insert test venue
INSERT INTO venues (name, city, state, address, zip_code, latitude, longitude, capacity, price_per_hour, contact_email, contact_phone, amenities)
VALUES
('Test Venue NYC', 'New York', 'NY', '123 Main St', '10001', 40.7589, -73.9851, 200, 500.00, 'test@venue.com', '+1-212-555-0100', ARRAY['WiFi', 'Parking']);
```

---

### 2. Venue Detail Screen

**Location**: `lib/features/venues/screens/venue_detail_screen.dart`

**How to Test**:
```dart
// Navigate with venue ID
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VenueDetailScreen(venueId: 'your-venue-id'),
  ),
);
```

**What to Test**:
- ✅ Venue details display (name, address, capacity, price)
- ✅ Image header with parallax effect
- ✅ Amenities chips display
- ✅ Contact information (tap to call/email/visit website)
- ✅ Reviews list from database
- ✅ Write review dialog
- ✅ Rating submission
- ✅ "Send Inquiry" button (shows placeholder dialog)

**Test Ratings**:
```sql
-- Insert test rating
INSERT INTO venue_ratings (venue_id, user_id, rating, review)
VALUES ('your-venue-id', 'your-user-id', 4.5, 'Great venue!');
```

---

### 3. Event Chat Screen (Real-time)

**Location**: `lib/features/events/screens/event_chat_screen.dart`

**How to Test**:
```dart
// Navigate with event details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventChatScreen(
      eventId: 'your-event-id',
      eventName: 'Test Event',
    ),
  ),
);
```

**What to Test**:
- ✅ Message list loads from database
- ✅ Send message (text input)
- ✅ Real-time message updates (open on 2 devices)
- ✅ User avatars and names display
- ✅ Timestamp with "time ago" format
- ✅ Pin/unpin messages (host only)
- ✅ View pinned messages (bottom sheet)
- ✅ Empty state message

**Real-time Test**:
1. Open chat on Device A
2. Open same chat on Device B
3. Send message from Device A
4. Verify message appears instantly on Device B

**Test Messages**:
```sql
-- Insert test message
INSERT INTO event_chat_messages (event_id, user_id, message)
VALUES ('your-event-id', 'your-user-id', 'Hello from the test!');
```

---

### 4. Event Polls Screen (Real-time)

**Location**: `lib/features/events/screens/event_polls_screen.dart`

**How to Test**:
```dart
// Navigate with event details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventPollsScreen(
      eventId: 'your-event-id',
      eventName: 'Test Event',
    ),
  ),
);
```

**What to Test**:
- ✅ Polls list loads from database
- ✅ Create poll button (FAB)
- ✅ Create poll dialog (question + options)
- ✅ Allow multiple choices toggle
- ✅ Vote on poll options
- ✅ Remove vote
- ✅ Live vote count updates (real-time)
- ✅ Progress bars with percentages
- ✅ Total vote count display
- ✅ Expired poll indicator
- ✅ Empty state message

**Real-time Test**:
1. Open polls on Device A
2. Open same polls on Device B
3. Vote from Device A
4. Verify vote count updates instantly on Device B

**Test Poll**:
```sql
-- Insert test poll
INSERT INTO event_polls (event_id, created_by, question, options, allow_multiple_choices)
VALUES ('your-event-id', 'your-user-id', 'What music do you prefer?', ARRAY['Hip Hop', 'EDM', 'Rock'], false);

-- Vote on poll
INSERT INTO poll_votes (poll_id, user_id, option_index)
VALUES ('your-poll-id', 'your-user-id', '0');
```

---

## 🧪 Testing Providers

### Test Venue Provider
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottles_up_user/features/venues/providers/venue_provider.dart';

// In your widget
final venuesAsync = ref.watch(venueListProvider());

venuesAsync.when(
  data: (venues) => Text('Found ${venues.length} venues'),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
);
```

### Test Event Chat Provider
```dart
import 'package:bottles_up_user/features/events/providers/event_chat_provider.dart';

// Watch messages (auto-subscribes to real-time)
final messagesAsync = ref.watch(eventChatMessagesProvider('event-id'));

// Send message
await ref.read(eventChatMessagesProvider('event-id').notifier).sendMessage(
  eventId: 'event-id',
  message: 'Hello!',
);
```

### Test Poll Provider
```dart
import 'package:bottles_up_user/features/events/providers/poll_provider.dart';

// Watch poll with live results (auto-subscribes to real-time)
final pollAsync = ref.watch(pollDetailProvider('poll-id'));

// Vote
await ref.read(pollDetailProvider('poll-id').notifier).vote('0');
```

---

## 🔧 Common Issues & Fixes

### Issue: Providers not found
**Fix**: Run build_runner
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Real-time not working
**Fix**: Check Supabase Realtime is enabled
1. Go to Supabase Dashboard
2. Database → Replication
3. Enable tables: `event_chat_messages`, `poll_votes`

### Issue: Authentication errors
**Fix**: Ensure user is logged in
```dart
final user = Supabase.instance.client.auth.currentUser;
if (user == null) {
  // Redirect to login
}
```

### Issue: Empty lists
**Fix**: Add test data to database (see SQL examples above)

---

## 📊 Feature Completion Status

| Feature | Backend | UI Screen | Provider | Real-time | Status |
|---------|---------|-----------|----------|-----------|--------|
| Venue Discovery | ✅ | ✅ | ✅ | N/A | 🟢 Ready |
| Venue Detail | ✅ | ✅ | ✅ | N/A | 🟢 Ready |
| Venue Ratings | ✅ | ✅ | ✅ | N/A | 🟢 Ready |
| Venue Comparison | ✅ | ❌ | ✅ | N/A | 🟡 Backend Only |
| Venue Inquiry | ✅ | ❌ | ✅ | N/A | 🟡 Backend Only |
| Event Chat | ✅ | ✅ | ✅ | ✅ | 🟢 Ready |
| Event Polls | ✅ | ✅ | ✅ | ✅ | 🟢 Ready |
| Announcements | ✅ | ❌ | ✅ | N/A | 🟡 Backend Only |
| Ticket Transfer | ✅ | ❌ | ✅ | N/A | 🟡 Backend Only |

**Legend**:
- 🟢 Ready = Fully implemented and testable
- 🟡 Backend Only = Service + Provider ready, UI needed
- ❌ = Not implemented

---

## 🚀 Quick Start Testing

### Step 1: Add Test Data
Run these SQL queries in Supabase SQL Editor:

```sql
-- 1. Create test venue
INSERT INTO venues (name, description, city, state, address, zip_code, latitude, longitude, capacity, price_per_hour, contact_email, contact_phone, amenities)
VALUES
('Grand Ballroom NYC', 'Elegant event space', 'New York', 'NY', '123 Broadway', '10001', 40.7589, -73.9851, 300, 500.00, 'contact@venue.com', '+1-212-555-0100', ARRAY['WiFi', 'Parking', 'Bar']);

-- 2. Create test event
INSERT INTO events (user_id, category_id, club_id, zone_id, name, description, event_date, start_time, end_time, ticket_price, max_capacity)
VALUES
('your-user-id', 'category-id', 'club-id', 'zone-id', 'Test Event', 'Test event description', '2026-06-15', '20:00:00', '02:00:00', 50.00, 200);

-- 3. RSVP to event (required for chat/polls access)
INSERT INTO event_rsvps (event_id, user_id, booking_type)
VALUES ('your-event-id', 'your-user-id', 'guestlist');

-- 4. Create test poll
INSERT INTO event_polls (event_id, created_by, question, options)
VALUES ('your-event-id', 'your-user-id', 'What time works best?', ARRAY['7 PM', '8 PM', '9 PM']);
```

### Step 2: Navigate to Screens
```dart
// Test Venue Discovery
Navigator.push(context, MaterialPageRoute(
  builder: (_) => VenueDiscoveryScreen(),
));

// Test Event Chat
Navigator.push(context, MaterialPageRoute(
  builder: (_) => EventChatScreen(
    eventId: 'your-event-id',
    eventName: 'Test Event',
  ),
));

// Test Event Polls
Navigator.push(context, MaterialPageRoute(
  builder: (_) => EventPollsScreen(
    eventId: 'your-event-id',
    eventName: 'Test Event',
  ),
));
```

### Step 3: Test Real-time
1. Run app on 2 devices/emulators
2. Navigate both to Event Chat
3. Send message from Device 1
4. Verify message appears on Device 2 instantly
5. Repeat for polls (vote from one device, see results update on other)

---

## 📝 Next Steps to Complete UI

### Remaining Screens to Build:

1. **Venue Comparison Screen**
   - Side-by-side venue comparison
   - Save comparisons
   - View saved comparisons

2. **Venue Inquiry Form**
   - Event details input
   - Date/time pickers
   - Expected guests
   - Send inquiry

3. **Host Announcements Screen**
   - List announcements
   - Create announcement dialog
   - Pin/unpin announcements
   - Delete announcements

4. **Ticket Transfer Screen**
   - List pending transfers (received)
   - List sent transfers
   - Accept/reject transfer
   - Send transfer dialog

5. **Navigation Routes**
   - Add routes to GoRouter
   - Deep linking support
   - Tab navigation integration

---

## ✅ Validation Checklist

Before marking a feature as complete, verify:

- [ ] Data loads from Supabase
- [ ] Create/update operations work
- [ ] Error states display properly
- [ ] Loading states show
- [ ] Empty states show
- [ ] Pull to refresh works
- [ ] Real-time updates work (if applicable)
- [ ] UI is responsive on different screen sizes
- [ ] Navigation works
- [ ] Back button works
- [ ] Authentication checks work
- [ ] RLS policies work (users only see their data)

---

## 🎨 UI Screenshots Needed

For each screen, capture:
1. Empty state
2. Loading state
3. Data loaded state
4. Error state
5. Real-time update (before/after)

---

## 📚 Documentation

- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Complete technical details
- [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md) - Backend testing guide
- [FEATURE_STATUS.md](FEATURE_STATUS.md) - Implementation status
- [SUPABASE_VALIDATION.md](SUPABASE_VALIDATION.md) - Database validation
- [QUICK_START.md](QUICK_START.md) - Quick reference
- [UI_TESTING_GUIDE.md](UI_TESTING_GUIDE.md) - This file

---

**Status**: 🟢 4/9 Screens Complete | 🟡 5/9 Backend Only

**Ready to Test**: Venue Discovery, Venue Detail, Event Chat, Event Polls

**Next**: Build remaining 5 UI screens and update navigation routes
