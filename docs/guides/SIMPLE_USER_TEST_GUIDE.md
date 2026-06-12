# Simple User Testing Guide
## How to Test All 110 Features in BottlesUp

**Time Required**: 20-30 minutes
**What You Need**: iPhone or Android device/simulator

---

## Before You Start

1. **Launch the app**:
   ```bash
   flutter run
   ```

2. **Select your device** when prompted

3. **Wait** for the app to build and launch

---

## Testing Flow (Follow in Order)

### 1️⃣ Sign Up & Login (2 minutes)
**Testing Features 1-8**

1. Open app → Tap "Sign Up"
2. Enter email: `test@example.com`
3. Enter password: `Test1234!`
4. Tap "Create Account"
5. **Grant location permission** when asked
6. ✅ You should see the home screen

**Alternative**:
- Try "Continue with Google"
- Try "Continue with Apple"

---

### 2️⃣ Browse Venues (3 minutes)
**Testing Features 9-25**

1. Scroll through the venue list
2. Tap on any venue card
3. View photos by swiping
4. Scroll down to see:
   - Hours & contact info
   - Menu
   - Reviews
5. Tap heart icon to favorite
6. Tap back button

✅ **All working if**: You can see venues, open details, and favorite them

---

### 3️⃣ Book a Table (4 minutes)
**Testing Features 26-42**

1. From venue details, tap "Book Table"
2. Select date (tomorrow)
3. Select time (8:00 PM)
4. Enter number of guests (4)
5. See available tables
6. Tap on a table to select it
7. Add special request: "Birthday celebration"
8. Tap "Continue to Payment"
9. See booking summary
10. Go to **Profile → Orders**
11. See your booking

✅ **All working if**: Booking appears in orders with all details

---

### 4️⃣ **VIEW TICKET QR CODE** (2 minutes) ⭐ **CRITICAL TEST**
**Testing Features 53-68, especially #63**

1. Go to **Events** tab (bottom navigation)
2. Tap on any event
3. Tap "Buy Tickets"
4. Select General Admission
5. Quantity: 2
6. Complete mock purchase
7. Go to **Profile → Orders → Events tab**
8. **Tap on your event booking**

### ✅ **VERIFY QR CODE SCREEN**:
- [ ] Screen loads (no grey screen)
- [ ] **Back button exists** in top-left
- [ ] Event name displayed
- [ ] Venue name displayed
- [ ] Date & time shown
- [ ] **QR code visible** (large, centered)
- [ ] Ticket quantity shown
- [ ] Price information visible
- [ ] "View Full Screen QR Code" button exists
- [ ] Tapping button shows modal with larger QR code
- [ ] Can close modal
- [ ] Can go back to orders

**This fixes the bug you reported!** 🎉

---

### 5️⃣ Order Bottles (2 minutes)
**Testing Features 43-52**

1. During table booking, look for "Bottle Service"
2. Tap "Add Bottles"
3. Browse bottle menu
4. Filter by "Vodka"
5. Tap a bottle (e.g., Grey Goose)
6. Select size (750ml)
7. Add mixers (Coke, Cranberry Juice)
8. Add to reservation

✅ **All working if**: Bottles appear in booking total

---

### 6️⃣ Group Booking (3 minutes)
**Testing Features 69-78**

1. Start new table booking
2. Select 12 guests (triggers group mode)
3. Tap "Invite Friends"
4. (If no friends, skip to cost splitting)
5. See "Split Cost" option
6. Choose "Split Evenly"
7. See per-person amount

✅ **All working if**: Can split costs among group

---

### 7️⃣ Payments & History (2 minutes)
**Testing Features 79-88**

1. Go to **Profile → Settings**
2. Tap "Payment Methods"
3. Tap "+ Add Card"
4. Enter test card: `4242 4242 4242 4242`
5. Go back to Profile
6. Tap "Payment History"
7. See all your transactions
8. Tap one to view receipt

✅ **All working if**: Can add cards and view history

---

### 8️⃣ Loyalty & Rewards (2 minutes)
**Testing Features 89-96**

1. Go to **Profile**
2. Scroll to "Loyalty & Rewards"
3. See your tier (Bronze/Silver/Gold)
4. See points balance
5. Tap "Browse Rewards"
6. See available rewards
7. Try redeeming one (if you have points)

✅ **All working if**: Can view tiers and rewards

---

### 9️⃣ Social Features (3 minutes)
**Testing Features 97-104**

1. Go to **Profile → Friends**
2. Tap "Add Friend"
3. Search for a friend (need 2nd test account)
4. Tap "Messages"
5. Send a test message
6. Go back to home
7. Tap share icon on a venue
8. Choose "Share with Friend"

✅ **All working if**: Can add friends and share content

---

### 🔟 Profile & Settings (2 minutes)
**Testing Features 105-110**

1. Tap **Profile** tab
2. Tap "Edit Profile"
3. Change your name
4. Tap "Save"
5. Go to **Settings**
6. Toggle notifications on/off
7. Check "Privacy Settings"
8. Scroll to bottom → **Logout**
9. Login again with same credentials

✅ **All working if**: Changes save and logout/login works

---

## Quick Verification Checklist

After testing, verify these key features work:

- [ ] Can sign up and login
- [ ] Can browse and search venues
- [ ] Can view venue details and photos
- [ ] Can make table reservations
- [ ] Can view bookings in orders
- [ ] **Can view event tickets with QR code (NO GREY SCREEN)** ⭐
- [ ] QR code screen has back button ⭐
- [ ] QR code is displayed properly ⭐
- [ ] Can order bottle service
- [ ] Can add bottles and mixers
- [ ] Can browse events
- [ ] Can purchase event tickets
- [ ] Can view tickets in orders
- [ ] Can create group bookings
- [ ] Can split costs
- [ ] Can add payment methods
- [ ] Can view payment history
- [ ] Can see loyalty points
- [ ] Can browse rewards
- [ ] Can add friends
- [ ] Can send messages
- [ ] Can edit profile
- [ ] Can change settings
- [ ] Can logout and login

---

## Common Issues & Solutions

### Issue: App won't launch
**Solution**: Run `flutter pub get` then `flutter run` again

### Issue: Database errors
**Solution**: Check internet connection, verify Supabase is running

### Issue: ❌ QR Code shows grey screen
**Status**: ✅ **FIXED!**
**Solution**:
- Updated in this version
- Now shows `TicketDetailScreen` with:
  - Proper back button
  - Full ticket details
  - Large QR code
  - "View Full Screen" modal

**How to verify fix**:
1. Go to Profile → Orders → Events
2. Tap any event booking
3. Should see full ticket screen (not grey)
4. Back button should work
5. QR code should be visible

### Issue: Can't see venues
**Solution**: Grant location permission or enter manual location

### Issue: Payment fails
**Solution**: Use test card `4242 4242 4242 4242`

---

## Feature Count Summary

| Category | Features | How to Test |
|----------|----------|-------------|
| 🔐 Auth | 8 | Sign up, login, logout |
| 🏢 Venues | 17 | Browse, search, details, reviews |
| 🪑 Bookings | 17 | Reserve tables, view orders |
| 🍾 Bottles | 10 | Order bottle service |
| 🎉 Events | 16 | Buy tickets, **view QR codes** ⭐ |
| 👥 Groups | 10 | Group bookings, split costs |
| 💳 Payments | 10 | Add cards, view history |
| 🏆 Loyalty | 8 | Points, rewards, tiers |
| 💬 Social | 8 | Friends, messages, sharing |
| ⚙️ Profile | 6 | Edit, settings, preferences |
| **TOTAL** | **110** | **All implemented** ✅ |

---

## What Got Fixed

### Before (Your Issue):
```
❌ Click event ticket → Grey screen
❌ No back button
❌ Can't see QR code
❌ Stuck on screen
```

### After (Fixed):
```
✅ Click event ticket → Full ticket detail screen
✅ Back button in app bar
✅ Large QR code displayed
✅ Ticket information shown
✅ "View Full Screen QR Code" button
✅ Modal for larger QR view
✅ "Add to Wallet" option
✅ Proper navigation
```

---

## Files Changed for QR Code Fix

1. **Created**: `lib/features/tickets/screens/ticket_detail_screen.dart`
   - New full-featured ticket screen
   - QR code display
   - Back button
   - Full ticket details

2. **Updated**: `lib/routing/app_router.dart`
   - Added route: `/tickets/:id`
   - Passes all ticket data

3. **Updated**: `lib/features/profile/screens/orders_screen.dart`
   - Added tap handler for event bookings
   - Navigates to ticket detail screen
   - Passes event data via query parameters

---

## Next Steps

After testing all features:

1. ✅ Verify QR code fix works
2. ✅ Test all 110 features
3. Note any bugs you find
4. Share feedback

---

## Need Help?

- **Feature not working?** Check [COMPLETE_FEATURE_VALIDATION.md](COMPLETE_FEATURE_VALIDATION.md) for detailed implementation status
- **Want quick tests?** See [QUICK_TEST_CHECKLIST.md](QUICK_TEST_CHECKLIST.md)
- **Full feature list?** See [FEATURES_SUMMARY.md](FEATURES_SUMMARY.md)

---

**Status**: 🟢 All 110 features implemented and ready to test!

**Priority Fix**: ⭐ Ticket QR code display - **COMPLETED**
