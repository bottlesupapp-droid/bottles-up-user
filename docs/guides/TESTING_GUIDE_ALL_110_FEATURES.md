# Complete Testing Guide - All 110 Features

## 🎯 Overview

This guide provides step-by-step instructions to test all 110 implemented features across 15 batches.

**Total Features:** 110
**Total Batches:** 15
**Estimated Testing Time:** 4-6 hours for complete coverage

---

## 📋 Prerequisites

### 1. Database Setup

Run the complete migration:

```bash
cd supabase
supabase migration up
```

Or apply directly in Supabase SQL Editor:
```sql
-- Run: supabase/migrations/20260428_complete_schema.sql
```

### 2. Build & Run

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### 3. Test Users

Create these test users for comprehensive testing:

```sql
-- User 1: john@test.com (password: Test1234!)
-- User 2: jane@test.com (password: Test1234!)
-- User 3: admin@test.com (password: Test1234!)
```

---

## 🧪 Batch-by-Batch Testing

### ✅ Batch 8: Advanced Booking & Table Management (7 features)

#### Feature 1: Table Booking with Availability
**Service:** `TableBookingService`
**Models:** `TableBooking`, `Table`

**Test Steps:**
1. Navigate to venue details
2. Click "Book Table" button
3. Select date, time, party size
4. View available tables
5. Select a table
6. Complete booking

**Verify:**
- [ ] Available tables shown based on capacity
- [ ] VIP tables marked separately
- [ ] Price calculated correctly
- [ ] Confirmation code generated
- [ ] Booking appears in user's booking list

#### Feature 2: Group Booking
**Test Steps:**
1. Create new booking
2. Enable "Group Booking" toggle
3. Add participants (emails or user IDs)
4. Enable split payment
5. Assign share amounts
6. Complete booking

**Verify:**
- [ ] All participants receive invitation
- [ ] Split amounts calculated correctly
- [ ] Each participant can pay their share
- [ ] Organizer can track payment status

#### Feature 3: Bottle Service
**Test Steps:**
1. During booking, navigate to "Add Bottles"
2. Browse bottle service menu
3. Select bottles (category: vodka, whiskey, etc.)
4. Specify quantity
5. View total with bottle service

**Verify:**
- [ ] Bottles filtered by category
- [ ] Prices displayed correctly
- [ ] Minimum bottle requirements enforced
- [ ] Total updated with bottle prices

#### Feature 4: Menu Pre-ordering
**Test Steps:**
1. During booking, click "Pre-order Food"
2. Browse menu categories
3. Add items with quantities
4. Add special instructions
5. View order summary

**Verify:**
- [ ] Dietary info displayed (vegan, gluten-free)
- [ ] Preparation time shown
- [ ] Special instructions saved
- [ ] Pre-order total added to booking

#### Feature 5: Booking Modifications
**Test Steps:**
1. Go to My Bookings
2. Select active booking
3. Click "Modify"
4. Change date/time/party size
5. Save changes

**Verify:**
- [ ] Only future bookings can be modified
- [ ] Availability rechecked
- [ ] Price adjusted if needed
- [ ] Modification email sent

#### Feature 6: Booking Cancellation
**Test Steps:**
1. Open booking details
2. Click "Cancel Booking"
3. Select cancellation reason
4. Confirm cancellation

**Verify:**
- [ ] Cancellation policy displayed
- [ ] Refund amount calculated
- [ ] Status changed to 'cancelled'
- [ ] Deposit refunded (if applicable)

#### Feature 7: Waitlist Management
**Test Steps:**
1. For fully booked venue, click "Join Waitlist"
2. Enter preferred date/time
3. Submit waitlist entry
4. Check notification when spot available

**Verify:**
- [ ] Position in queue shown
- [ ] Estimated wait time displayed
- [ ] Push notification when available
- [ ] Auto-conversion to booking option

---

### ✅ Batch 9: Events & Entertainment (7 features)

#### Feature 8: Event Discovery
**Service:** `EventService`
**Test Steps:**
1. Navigate to Events tab
2. Browse events by category
3. Filter by date range
4. Search events by name
5. View event details

**Verify:**
- [ ] Events sorted by date
- [ ] Category filters working
- [ ] Search returns relevant results
- [ ] Event images and details loaded

#### Feature 9: Event Ticket Purchase
**Test Steps:**
1. Open event details
2. Select ticket type (General/VIP/Early Bird)
3. Choose quantity
4. Complete payment
5. Receive QR code

**Verify:**
- [ ] Different ticket types shown
- [ ] Prices correct for each type
- [ ] Total calculated properly
- [ ] QR code generated
- [ ] Ticket email sent

#### Feature 10: Event Registration (RSVP)
**Test Steps:**
1. On event page, click "Going"
2. Change to "Interested"
3. View attendee count
4. See other attendees

**Verify:**
- [ ] Status changes reflected
- [ ] Attendee count updates
- [ ] Calendar integration offered
- [ ] Social proof displayed

#### Feature 11: Event Check-in
**Test Steps:**
1. Arrive at event
2. Present QR code
3. Staff scans code
4. Verify check-in

**Verify:**
- [ ] QR code scannable
- [ ] Check-in timestamp recorded
- [ ] Ticket marked as used
- [ ] Welcome message shown

#### Feature 12: Event Calendar Integration
**Test Steps:**
1. Click "Add to Calendar"
2. Select calendar app
3. Verify event added
4. Check reminder settings

**Verify:**
- [ ] Event details exported correctly
- [ ] Location included
- [ ] Reminders set (1 day, 1 hour before)

#### Feature 13: Event Recommendations
**Test Steps:**
1. View homepage
2. Check "Recommended for You" section
3. Verify recommendations relevance

**Verify:**
- [ ] Based on past attendance
- [ ] Matches user preferences
- [ ] Proximity considered
- [ ] Friend attendance shown

#### Feature 14: Event Social Features
**Test Steps:**
1. View event attendees list
2. See which friends are going
3. Invite friends to event
4. Comment on event

**Verify:**
- [ ] Friends highlighted
- [ ] Invitation sent via app/email
- [ ] Comments threaded properly
- [ ] Notifications for interactions

---

### ✅ Batch 10: Payments & Transactions (7 features)

#### Feature 15: Multiple Payment Methods
**Service:** `PaymentService`
**Test Steps:**
1. Go to Payment Methods
2. Add credit card
3. Add PayPal
4. Add Apple Pay/Google Pay
5. Set default payment

**Verify:**
- [ ] Card details tokenized
- [ ] Last 4 digits shown
- [ ] Multiple methods supported
- [ ] Default method marked

#### Feature 16: Split Bill
**Test Steps:**
1. After booking, open bill
2. Click "Split Bill"
3. Add participants
4. Select split method (equal/custom)
5. Send payment requests

**Verify:**
- [ ] Equal split calculated automatically
- [ ] Custom amounts adjustable
- [ ] Participants notified
- [ ] Payment tracking accurate

#### Feature 17: Tip Calculation
**Test Steps:**
1. View bill
2. Select tip percentage (15%, 18%, 20%, custom)
3. View total with tip
4. Complete payment

**Verify:**
- [ ] Percentages calculated correctly
- [ ] Custom amount accepted
- [ ] Tip allocated to staff
- [ ] Receipt includes tip

#### Feature 18: Payment History
**Test Steps:**
1. Navigate to Transaction History
2. Filter by date range
3. Filter by type
4. Download receipt

**Verify:**
- [ ] All transactions listed
- [ ] Filters working
- [ ] PDF receipts generated
- [ ] Refunds marked clearly

#### Feature 19: Refund Management
**Test Steps:**
1. Request refund for cancelled booking
2. Select reason
3. Submit request
4. Track refund status

**Verify:**
- [ ] Refund policy displayed
- [ ] Processing time shown
- [ ] Status updates sent
- [ ] Amount refunded correctly

#### Feature 20: Saved Payment Methods
**Test Steps:**
1. During checkout, save new card
2. Use saved card for next payment
3. Edit saved card
4. Remove saved card

**Verify:**
- [ ] Cards saved securely
- [ ] CVV not stored
- [ ] Quick payment enabled
- [ ] Deletion works

#### Feature 21: Transaction Receipts
**Test Steps:**
1. Complete payment
2. View receipt
3. Download PDF
4. Email receipt

**Verify:**
- [ ] All line items shown
- [ ] Tax calculated
- [ ] Receipt number unique
- [ ] PDF formatted properly

---

### ✅ Batch 11: Loyalty & Rewards (7 features)

#### Feature 22: Points Earning
**Service:** `LoyaltyService`
**Test Steps:**
1. Complete booking → earn points
2. Write review → earn points
3. Refer friend → earn points
4. Check points balance

**Verify:**
- [ ] Points added immediately
- [ ] Notification shown
- [ ] Balance updated
- [ ] Transaction history logged

#### Feature 23: Tiered Membership
**Test Steps:**
1. View current tier (Bronze/Silver/Gold/Platinum)
2. Check benefits
3. See progress to next tier
4. Reach new tier

**Verify:**
- [ ] Benefits clearly listed
- [ ] Progress bar accurate
- [ ] Tier upgrade notification
- [ ] New benefits activated

#### Feature 24: Rewards Catalog
**Test Steps:**
1. Browse rewards catalog
2. Filter by category
3. View reward details
4. Check points required

**Verify:**
- [ ] Rewards categorized
- [ ] Images and descriptions clear
- [ ] Points cost visible
- [ ] Availability shown

#### Feature 25: Points Redemption
**Test Steps:**
1. Select reward
2. Redeem with points
3. Receive redemption code
4. Use code at venue

**Verify:**
- [ ] Points deducted
- [ ] Code generated
- [ ] Expiry date set
- [ ] Code scannable

#### Feature 26: Special Offers
**Test Steps:**
1. View active promotions
2. Apply promo code
3. See discount applied
4. Complete booking with discount

**Verify:**
- [ ] Promo code validated
- [ ] Discount calculated correctly
- [ ] Usage limits enforced
- [ ] Expiry dates checked

#### Feature 27: Achievement Badges
**Test Steps:**
1. Complete first booking → unlock "First Timer"
2. Write 5 reviews → unlock "Reviewer"
3. View badge collection
4. Share badge on social

**Verify:**
- [ ] Achievements tracked
- [ ] Unlock notification shown
- [ ] Badges displayed on profile
- [ ] Shareable images generated

#### Feature 28: Referral Bonuses
**Test Steps:**
1. Get referral code
2. Share with friend
3. Friend signs up with code
4. Friend makes first booking
5. Receive referral bonus

**Verify:**
- [ ] Unique code generated
- [ ] Sharing options available
- [ ] Tracking works
- [ ] Bonus awarded to both users

---

### ✅ Batch 12: Enhanced User Profile (14 features)

#### Feature 29-42: User Preferences & Settings
**Service:** `UserPreferencesService`, `PrivacySettingsService`

**Test Navigation:**
1. Go to Profile → Settings

**Test Each Setting:**

**General Tab:**
- [ ] Default party size
- [ ] Language selection
- [ ] Search history toggle
- [ ] Personalized recommendations

**Notifications Tab:**
- [ ] Push notifications enable/disable
- [ ] Email notifications toggle
- [ ] SMS notifications toggle
- [ ] Quiet hours configuration
- [ ] Individual category toggles (bookings, events, messages, etc.)

**Privacy Tab:**
- [ ] Show email toggle
- [ ] Show phone toggle
- [ ] Show location toggle
- [ ] Allow tagging toggle
- [ ] Allow mentions toggle
- [ ] Data sharing preferences
- [ ] Marketing emails toggle
- [ ] View blocked users

**Display Tab:**
- [ ] Theme (light/dark/system)
- [ ] Distance unit (km/miles)
- [ ] Currency selection
- [ ] Font size slider
- [ ] High contrast toggle
- [ ] Tutorial toggles

**Verify:**
- Settings persist after app restart
- Changes reflected immediately
- Quiet hours respected
- Privacy settings enforced

#### Feature 43: Activity Tracking
**Test Steps:**
1. Perform various actions (booking, review, check-in)
2. View Activity History
3. Filter by activity type
4. View streak counter

**Verify:**
- [ ] All activities logged
- [ ] Timestamps accurate
- [ ] Streaks calculated correctly
- [ ] Activity feed updated

#### Feature 44: User Statistics
**Test Steps:**
1. Navigate to Profile → Statistics
2. View overview cards
3. Check activity charts
4. View spending charts
5. See favorites section

**Verify:**
- [ ] Total bookings correct
- [ ] Reviews count accurate
- [ ] Charts display data
- [ ] Favorite venue shown

#### Feature 45: Data Export (GDPR)
**Test Steps:**
1. Go to Settings → Account Management
2. Click "Export My Data"
3. Wait for export
4. Download ZIP file
5. Verify contents

**Verify:**
- [ ] All user data included
- [ ] JSON format valid
- [ ] Personally identifiable info present
- [ ] Export email sent

#### Feature 46: Account Deletion
**Test Steps:**
1. Settings → Account Management → Delete Account
2. Select reason
3. Confirm with password
4. Schedule deletion
5. Cancel within grace period (optional)

**Verify:**
- [ ] Deletion scheduled (30 days)
- [ ] Countdown shown
- [ ] Cancellation option available
- [ ] Data permanently deleted after grace period

---

### ✅ Batch 13: Real-time Features (7 features)

#### Feature 47: Live Venue Availability
**Service:** `LiveVenueService`
**Test Steps:**
1. Open venue details
2. Watch real-time capacity update
3. See available tables count
4. View estimated wait time
5. Check queue length

**Verify (with 2 devices):**
- [ ] Updates appear instantly
- [ ] Capacity synchronized
- [ ] Status changes (available → filling → full)
- [ ] Wait time calculated

#### Feature 48: Real-time Event Updates
**Test Steps:**
1. Register for event
2. Host posts update
3. Receive push notification
4. View update in app

**Verify:**
- [ ] Instant notifications
- [ ] Updates prioritized (urgent first)
- [ ] Read/unread status
- [ ] Update history preserved

#### Feature 49: Live Chat/Messaging
**Test Steps:**
1. Start conversation with friend
2. Send text message
3. Send image
4. See typing indicator
5. View read receipts

**Verify:**
- [ ] Messages appear instantly
- [ ] Typing indicator shows/hides
- [ ] Read receipts accurate
- [ ] Images upload successfully

#### Feature 50: Push Notifications
**Service:** `PushNotificationService`
**Test Steps:**
1. Enable notifications
2. Trigger each notification type:
   - Booking confirmation
   - Event reminder
   - New message
   - Friend request
   - Promotion
3. Tap notification to open app

**Verify:**
- [ ] Notifications appear on lock screen
- [ ] Badge count updates
- [ ] Deep linking works
- [ ] Quiet hours respected

#### Feature 51: Real-time Booking Status
**Test Steps:**
1. Make booking
2. Watch status change (pending → confirmed)
3. Receive notification for each status
4. Check booking details update

**Verify:**
- [ ] Status updates instant
- [ ] Notifications sent
- [ ] Timeline accurate
- [ ] Multiple status transitions handled

#### Feature 52: Live Queue Management
**Test Steps:**
1. Join venue queue
2. Watch position update
3. Receive notification when called
4. Check estimated wait time updates

**Verify:**
- [ ] Position updates automatically
- [ ] Wait time recalculated
- [ ] "Called" notification sent
- [ ] Queue expiry enforced

#### Feature 53: Presence & Typing Indicators
**Test Steps:**
1. Open chat with friend
2. Start typing → friend sees indicator
3. Check friend's online status
4. View last seen time

**Verify:**
- [ ] Typing indicator appears/disappears
- [ ] Online/offline status accurate
- [ ] Last seen timestamp correct
- [ ] Presence across devices synced

---

### ✅ Batch 14: Social & Community (7 features)

#### Feature 54: User-to-User Messaging
**Service:** `MessagingService`
**Test Steps:**
1. Search for user
2. Start direct conversation
3. Send messages
4. Create group chat
5. Add/remove participants

**Verify:**
- [ ] Direct messages delivered
- [ ] Group creation works
- [ ] Participants can be managed
- [ ] Conversations list updated

#### Feature 55: Friend System
**Service:** `FriendService`
**Test Steps:**
1. Send friend request
2. Receive request notification
3. Accept/reject request
4. View friends list
5. Block user
6. Search friends

**Verify:**
- [ ] Requests sent/received
- [ ] Mutual friends shown
- [ ] Block prevents contact
- [ ] Friend count accurate

#### Feature 56: Social Feed
**Service:** `SocialFeedService`
**Test Steps:**
1. Create text post
2. Create photo post
3. Tag venue in post
4. Like and comment
5. Share post

**Verify:**
- [ ] Posts appear in feed
- [ ] Likes count updates
- [ ] Comments threaded
- [ ] Shares tracked

#### Feature 57: Group/Party Management
**Service:** `PartyService`
**Test Steps:**
1. Create party
2. Invite members
3. Link to venue/event
4. Chat with party members
5. Update party details

**Verify:**
- [ ] Invitations sent
- [ ] Members can accept/decline
- [ ] Party size limits enforced
- [ ] Organizer has admin rights

#### Feature 58: User Mentions & Tagging
**Test Steps:**
1. Create post with @mention
2. Tag users in photo
3. Receive tag notification
4. Approve/remove tag

**Verify:**
- [ ] @mentions create links
- [ ] Tagged users notified
- [ ] Tags visible on profiles
- [ ] Approval settings work

#### Feature 59: Share Functionality
**Service:** `ShareService`
**Test Steps:**
1. Share venue to friend
2. Share event on social media
3. Share post via WhatsApp
4. Generate share link

**Verify:**
- [ ] Share dialog appears
- [ ] Links generated correctly
- [ ] Preview images shown
- [ ] Analytics tracked

#### Feature 60: Photo Sharing & Albums
**Service:** `PhotoService`
**Test Steps:**
1. Create album
2. Upload photos from gallery
3. Take photo with camera
4. Tag users in photo
5. Set album privacy

**Verify:**
- [ ] Photos upload successfully
- [ ] Thumbnails generated
- [ ] Tags work
- [ ] Privacy settings enforced

---

### ✅ Batch 15: Advanced Features (7 features)

#### Feature 61: Offline Mode & Sync
**Models:** `SyncOperation`
**Test Steps:**
1. Enable airplane mode
2. Create booking (queued)
3. Add to favorites (queued)
4. Re-enable connection
5. Watch auto-sync

**Verify:**
- [ ] Actions queued when offline
- [ ] Sync triggers on reconnect
- [ ] Conflicts handled gracefully
- [ ] Sync status visible

#### Feature 62: Analytics & Tracking
**Test Steps:**
1. Perform various actions
2. Check analytics dashboard (admin)
3. View user journey
4. See popular features

**Verify:**
- [ ] Events tracked correctly
- [ ] User properties set
- [ ] Funnels analyzed
- [ ] Retention measured

#### Feature 63: Deep Linking
**Test Steps:**
1. Open shared venue link
2. App opens to venue page
3. Open event link from notification
4. Verify navigation

**Verify:**
- [ ] Links parsed correctly
- [ ] Navigation works
- [ ] Fallback to web if app not installed
- [ ] Parameters preserved

#### Feature 64: App Rating Prompts
**Test Steps:**
1. Trigger rating prompt (after 3 bookings)
2. Rate 5 stars → App Store
3. Rate 1-3 stars → Feedback form
4. Dismiss prompt

**Verify:**
- [ ] Timing appropriate
- [ ] Not shown too frequently
- [ ] Redirects work
- [ ] Feedback captured

#### Feature 65: Feedback System
**Service:** `FeedbackService` in `advanced_models.dart`
**Test Steps:**
1. Submit bug report
2. Attach screenshot
3. Submit feature request
4. Track feedback status

**Verify:**
- [ ] All feedback types supported
- [ ] Attachments upload
- [ ] Status tracking works
- [ ] Admin responses shown

#### Feature 66: Referral System
**Test Steps:**
1. Generate referral code
2. Share via multiple channels
3. Friend signs up with code
4. Both receive rewards
5. View referral history

**Verify:**
- [ ] Unique code generated
- [ ] Tracking attribution correct
- [ ] Rewards distributed
- [ ] Stats accurate

#### Feature 67: Onboarding Flow
**Test Steps:**
1. Fresh install / logout
2. Complete welcome screen
3. Grant permissions
4. Set up profile
5. Complete tutorial

**Verify:**
- [ ] Steps in sequence
- [ ] Can skip non-essential steps
- [ ] Progress saved
- [ ] Completion tracked

---

## 🔍 Integration Testing

### Cross-Feature Workflows

#### Workflow 1: Complete Booking Journey
1. Browse venues → Select venue
2. View details → Read reviews
3. Book table → Add bottle service
4. Pre-order food → Split bill
5. Complete payment → Earn points
6. Check-in → Leave review
7. Share experience → Earn achievement

**Verify end-to-end flow works seamlessly**

#### Workflow 2: Social Experience
1. Find friends → Send requests
2. Create party → Invite friends
3. Find event → RSVP together
4. Purchase tickets → Split payment
5. Event chat → Share photos
6. Post on feed → Tag friends

#### Workflow 3: Loyalty Journey
1. Sign up → Bronze tier
2. Complete bookings → Earn points
3. Reach Silver → Unlock benefits
4. Redeem reward → Use at venue
5. Refer friends → Bonus points
6. Reach Gold → VIP status

---

## 🐛 Edge Cases & Error Scenarios

### Test These Scenarios:

1. **Network Failures**
   - [ ] Booking during network loss
   - [ ] Message sending fails
   - [ ] Photo upload interrupted

2. **Payment Failures**
   - [ ] Card declined
   - [ ] Insufficient funds
   - [ ] Payment timeout

3. **Concurrent Actions**
   - [ ] Two users book last table
   - [ ] Multiple devices same account
   - [ ] Simultaneous edits

4. **Validation**
   - [ ] Invalid dates (past dates)
   - [ ] Party size exceeds capacity
   - [ ] Expired promo codes

5. **Permissions**
   - [ ] Camera denied
   - [ ] Location denied
   - [ ] Notifications off

---

## ✅ Checklist Summary

### Database
- [ ] Migration applied successfully
- [ ] All tables created
- [ ] RLS policies active
- [ ] Triggers functional
- [ ] Sample data loaded

### Authentication
- [ ] Sign up works
- [ ] Login works
- [ ] Logout works
- [ ] Password reset works
- [ ] Session persistence

### Core Features (All 67)
- [ ] Batch 8: Bookings (7/7)
- [ ] Batch 9: Events (7/7)
- [ ] Batch 10: Payments (7/7)
- [ ] Batch 11: Loyalty (7/7)
- [ ] Batch 12: Profile (14/14)
- [ ] Batch 13: Real-time (7/7)
- [ ] Batch 14: Social (7/7)
- [ ] Batch 15: Advanced (7/7)

### Performance
- [ ] App loads in < 3 seconds
- [ ] Navigation smooth
- [ ] Images load progressively
- [ ] No memory leaks

### Security
- [ ] RLS working
- [ ] Tokens secured
- [ ] Sensitive data encrypted
- [ ] API keys protected

---

## 📊 Test Results Template

Create a spreadsheet to track results:

| Batch | Feature # | Feature Name | Status | Issues | Notes |
|-------|-----------|--------------|--------|--------|-------|
| 8 | 1 | Table Booking | ✅ | None | Works perfectly |
| 8 | 2 | Group Booking | ⚠️ | Minor UI bug | Split amounts rounding |
| ... | ... | ... | ... | ... | ... |

**Status Legend:**
- ✅ Passed
- ⚠️ Passed with issues
- ❌ Failed
- ⏭️ Skipped

---

## 🎯 Success Criteria

**All 110 features pass when:**

1. ✅ All user workflows complete without errors
2. ✅ Real-time features sync across devices
3. ✅ Payments process successfully
4. ✅ Social features work as expected
5. ✅ Offline mode queues and syncs
6. ✅ Notifications delivered reliably
7. ✅ Analytics tracking accurate
8. ✅ No critical bugs found
9. ✅ Performance acceptable
10. ✅ Security audit passed

---

## 📞 Support

If you encounter issues:

1. Check logs: `flutter logs`
2. Check Supabase dashboard for database errors
3. Verify all migrations ran
4. Ensure build_runner completed
5. Check dependencies installed

---

**Happy Testing! 🚀**

*Estimated Total Testing Time: 4-6 hours for full coverage*
