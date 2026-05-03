# BottlesUp QA Test Checklist
## Comprehensive Test Cases for All 110 Features

**Version**: 1.0
**Date**: May 3, 2026
**App**: BottlesUp User App
**Total Features**: 110
**Total Test Cases**: 220 (110 Happy Path + 110 Edge/Stress Tests)

---

## Test Types Legend

✅ **Happy Path** - Normal user flow, everything works as expected
⚠️ **Edge/Stress Test** - Error handling, boundary conditions, unusual scenarios

---

## 1. Authentication & Onboarding (8 Features)

### UC-001: Email/Password Sign Up

**✅ Happy Path Test**
1. Open app → Tap "Sign Up"
2. Enter email: `test@bottlesup.com`
3. Enter password: `Test123!@#`
4. Tap "Create Account"
5. **Expected**: Account created, redirected to location permission screen
6. **Verify**: User can login with same credentials

**⚠️ Edge/Stress Test**
1. Try weak password: `123`
2. **Expected**: Error "Password must be at least 8 characters"
3. Try existing email
4. **Expected**: Error "Email already registered"
5. Try invalid email format: `notanemail`
6. **Expected**: Error "Invalid email format"
7. Leave fields empty
8. **Expected**: Validation errors shown

---

### UC-002: Social Login (Google/Apple)

**✅ Happy Path Test**
1. Tap "Continue with Google"
2. Select Google account
3. **Expected**: Logged in, redirected to location screen
4. **Verify**: Profile shows Google email

**⚠️ Edge/Stress Test**
1. Cancel Google sign-in mid-flow
2. **Expected**: Returned to login screen, no crash
3. Try with no internet
4. **Expected**: Error "No internet connection"
5. Revoke app permissions in Google
6. **Expected**: Proper error message

---

### UC-003: Password Reset

**✅ Happy Path Test**
1. Tap "Forgot Password"
2. Enter registered email
3. **Expected**: "Reset link sent" message
4. Check email → Click reset link
5. Enter new password
6. **Expected**: Password updated, can login

**⚠️ Edge/Stress Test**
1. Enter non-existent email
2. **Expected**: Error "Email not found"
3. Click reset link twice
4. **Expected**: Second click shows "Link expired"
5. Use old password after reset
6. **Expected**: Login fails

---

## 2. Venue Discovery (17 Features)

### UC-004: Browse Venues

**✅ Happy Path Test**
1. Login → Home tab
2. See list of nearby venues
3. Scroll through venues
4. **Expected**: Smooth scrolling, images load
5. **Verify**: Venues show distance, rating, price

**⚠️ Edge/Stress Test**
1. Scroll to bottom rapidly (500 venues)
2. **Expected**: Pagination works, no crash
3. Turn off internet mid-scroll
4. **Expected**: Cached venues still visible
5. Deny location permission
6. **Expected**: Manual location entry option shown

---

### UC-005: Search Venues

**✅ Happy Path Test**
1. Tap search bar
2. Enter "Rooftop"
3. **Expected**: Filtered results appear instantly
4. **Verify**: Results match search term

**⚠️ Edge/Stress Test**
1. Search special characters: `!@#$%`
2. **Expected**: No results or handled gracefully
3. Search extremely long text (500 chars)
4. **Expected**: Input limited or handled
5. Search then clear immediately
6. **Expected**: Returns to full list

---

### UC-006: Filter by Category/Price/Rating

**✅ Happy Path Test**
1. Tap "Filter" button
2. Select "Nightclub" category
3. Select price range "$$$"
4. Select rating "4+ stars"
5. Tap "Apply"
6. **Expected**: Filtered results shown
7. **Verify**: All results match criteria

**⚠️ Edge/Stress Test**
1. Select all filter combinations
2. **Expected**: Results update correctly
3. Select filters with no results
4. **Expected**: "No venues found" message
5. Apply filters then search
6. **Expected**: Both filters and search work together

---

### UC-007: View Venue Details

**✅ Happy Path Test**
1. Tap any venue card
2. **Expected**: Detail screen opens
3. View photo gallery (swipe)
4. Scroll to see hours, menu, reviews
5. **Verify**: All information displays correctly

**⚠️ Edge/Stress Test**
1. Tap venue with no photos
2. **Expected**: Placeholder image shown
3. Tap venue with no reviews
4. **Expected**: "No reviews yet" message
5. Load venue while offline
6. **Expected**: Cached data shown or error

---

### UC-008: Favorite a Venue

**✅ Happy Path Test**
1. Tap heart icon on venue
2. **Expected**: Heart fills, venue favorited
3. Go to Profile → Favorites
4. **Expected**: Venue appears in list

**⚠️ Edge/Stress Test**
1. Tap heart 10 times rapidly
2. **Expected**: No duplicate favorites
3. Favorite while offline
4. **Expected**: Syncs when online
5. Unfavorite from list
6. **Expected**: Removed immediately

---

## 3. Table Bookings (17 Features)

### UC-009: Create Table Reservation

**✅ Happy Path Test**
1. Open venue → Tap "Book Table"
2. Select date (tomorrow)
3. Select time (8:00 PM)
4. Enter 4 guests
5. **Expected**: Available tables shown
6. Select table
7. **Expected**: Reservation summary displayed

**⚠️ Edge/Stress Test**
1. Select past date
2. **Expected**: Error "Cannot book past dates"
3. Enter 100 guests
4. **Expected**: Error or max guests enforced
5. Select fully booked time
6. **Expected**: "No tables available" shown
7. Book without internet
8. **Expected**: Error "Check your connection"

---

### UC-010: Add Special Requests

**✅ Happy Path Test**
1. During booking, tap "Special Requests"
2. Enter "Birthday celebration, need candles"
3. **Expected**: Request saved with booking
4. View in orders
5. **Expected**: Special request visible

**⚠️ Edge/Stress Test**
1. Enter 5000 character request
2. **Expected**: Limited to reasonable length
3. Enter special characters/emojis
4. **Expected**: Handled correctly
5. Leave empty
6. **Expected**: Optional, booking proceeds

---

### UC-011: Modify Booking

**✅ Happy Path Test**
1. Go to Profile → Orders
2. Tap future booking
3. Tap "Modify"
4. Change time to 9:00 PM
5. **Expected**: Booking updated

**⚠️ Edge/Stress Test**
1. Try modifying past booking
2. **Expected**: Error "Cannot modify past bookings"
3. Change to unavailable time
4. **Expected**: Error "Time not available"
5. Modify 1 minute before reservation
6. **Expected**: Error "Too late to modify"

---

### UC-012: Cancel Booking

**✅ Happy Path Test**
1. Open booking → Tap "Cancel"
2. Confirm cancellation
3. **Expected**: Booking cancelled, refund initiated

**⚠️ Edge/Stress Test**
1. Cancel twice rapidly
2. **Expected**: Only cancels once
3. Cancel 1 hour before
4. **Expected**: Warning "Cancellation fee applies"
5. Cancel while offline
6. **Expected**: Error message

---

## 4. Bottle Service (10 Features)

### UC-013: Order Bottle Service

**✅ Happy Path Test**
1. During table booking → "Add Bottles"
2. Browse bottle menu
3. Select "Grey Goose 750ml"
4. Add mixers (Coke, Cranberry)
5. Add to reservation
6. **Expected**: Bottle added to total

**⚠️ Edge/Stress Test**
1. Add 50 bottles
2. **Expected**: Warning or limit enforced
3. Select bottle out of stock
4. **Expected**: "Out of stock" message
5. Remove all mixers
6. **Expected**: Still can proceed

---

### UC-014: Upgrade Bottle Selection

**✅ Happy Path Test**
1. Select standard bottle
2. Tap "Upgrade"
3. Choose premium option
4. **Expected**: Price difference shown, upgraded

**⚠️ Edge/Stress Test**
1. Upgrade then downgrade rapidly
2. **Expected**: Final selection correct
3. Upgrade unavailable bottle
4. **Expected**: Error handled

---

## 5. Events & Tickets (16 Features)

### UC-015: Browse Events

**✅ Happy Path Test**
1. Tap "Events" tab
2. See upcoming events
3. Filter by "This Weekend"
4. **Expected**: Only weekend events shown

**⚠️ Edge/Stress Test**
1. Load with 1000 events
2. **Expected**: Pagination works smoothly
3. Filter to no results
4. **Expected**: "No events found"

---

### UC-016: Buy Event Tickets (IN-APP PAYMENT)

**✅ Happy Path Test**
1. Tap event → "Buy Tickets"
2. Select General Admission
3. Quantity: 2
4. **Expected**: Payment sheet opens IN-APP
5. Enter card: `4242 4242 4242 4242`
6. **Expected**: Payment processes in app
7. **Verify**: Payment complete WITHOUT opening browser
8. **Verify**: Tickets appear in Orders

**⚠️ Edge/Stress Test**
1. Use declined card: `4000 0000 0000 0002`
2. **Expected**: Error "Card declined", can retry
3. Close payment sheet mid-payment
4. **Expected**: Payment cancelled, can retry
5. Buy 100 tickets
6. **Expected**: Limit enforced or warning
7. Turn off internet during payment
8. **Expected**: Error "Check connection"
9. Use card requiring 3D Secure: `4000 0025 0000 3155`
10. **Expected**: 3D Secure flow shown IN-APP

---

### UC-017: View Ticket QR Code

**✅ Happy Path Test**
1. Profile → Orders → Events
2. Tap event booking
3. **Expected**: Full ticket screen loads
4. **Verify**: QR code visible and scannable
5. Tap "View Full Screen QR"
6. **Expected**: Large QR modal opens
7. **Verify**: Back button works

**⚠️ Edge/Stress Test**
1. View QR offline
2. **Expected**: QR still shows (cached)
3. Screenshot QR code
4. **Expected**: Works normally
5. View cancelled ticket
6. **Expected**: Shows "CANCELLED" status

---

### UC-018: Transfer Ticket

**✅ Happy Path Test**
1. Open ticket → "Transfer"
2. Enter friend's email
3. Confirm transfer
4. **Expected**: Ticket transferred

**⚠️ Edge/Stress Test**
1. Transfer to invalid email
2. **Expected**: Error "Invalid email"
3. Transfer already transferred ticket
4. **Expected**: Error "Already transferred"

---

## 6. In-App Payment System (10 Features)

### UC-019: Add Payment Method

**✅ Happy Path Test**
1. Profile → Settings → Payment Methods
2. Tap "+ Add Card"
3. Enter card details in Payment Sheet
4. **Expected**: Card saved for future use
5. **Verify**: Card appears in saved cards list
6. **Verify**: Last 4 digits shown

**⚠️ Edge/Stress Test**
1. Add same card twice
2. **Expected**: Duplicate detection
3. Add expired card
4. **Expected**: Error "Card expired"
5. Enter invalid CVV
6. **Expected**: Validation error

---

### UC-020: Use Saved Payment Method

**✅ Happy Path Test**
1. Buy event ticket
2. In payment sheet, see saved cards
3. Select saved card (no re-entry needed)
4. Confirm with CVV only
5. **Expected**: Payment completes faster
6. **Verify**: Transaction successful

**⚠️ Edge/Stress Test**
1. Use saved card that was cancelled by bank
2. **Expected**: Error, prompt to update card
3. Delete card mid-selection
4. **Expected**: Handled gracefully

---

### UC-021: Google Pay / Apple Pay

**✅ Happy Path Test**
1. Start payment
2. Select "Google Pay" option in sheet
3. Confirm with fingerprint/face
4. **Expected**: Payment completes IN-APP
5. **Verify**: No browser redirect

**⚠️ Edge/Stress Test**
1. Cancel biometric prompt
2. **Expected**: Return to payment options
3. Google Pay not set up
4. **Expected**: Prompt to set up or hide option

---

### UC-022: Payment Confirmation

**✅ Happy Path Test**
1. Complete any payment
2. **Expected**: Success screen shows
3. **Verify**: Receipt emailed
4. **Verify**: Transaction in payment history

**⚠️ Edge/Stress Test**
1. Payment pending for 5 minutes
2. **Expected**: Timeout with retry option
3. Double-tap pay button
4. **Expected**: Only one charge

---

## 7. Group Bookings (10 Features)

### UC-023: Create Group Reservation

**✅ Happy Path Test**
1. Book table for 12+ guests
2. **Expected**: Group booking mode enabled
3. Invite friends via email/phone
4. **Expected**: Invites sent

**⚠️ Edge/Stress Test**
1. Invite 100 people
2. **Expected**: Limit or warning
3. Send to invalid emails
4. **Expected**: Validation errors

---

### UC-024: Split Payment

**✅ Happy Path Test**
1. In group booking → "Split Cost"
2. Select "Split Evenly" among 4 people
3. **Expected**: Each pays $X
4. **Verify**: Math is correct

**⚠️ Edge/Stress Test**
1. Split among 100 people
2. **Expected**: Handles small amounts
3. One person pays then cancels
4. **Expected**: Recalculates split

---

## 8. Loyalty & Rewards (8 Features)

### UC-025: Earn Points

**✅ Happy Path Test**
1. Complete a booking
2. Check Profile → Loyalty
3. **Expected**: Points added
4. **Verify**: Points match spend

**⚠️ Edge/Stress Test**
1. Cancel booking after points awarded
2. **Expected**: Points deducted
3. Complete 1000 bookings rapidly
4. **Expected**: Points accumulate correctly

---

### UC-026: Redeem Rewards

**✅ Happy Path Test**
1. Earn 1000 points
2. Browse Rewards
3. Tap "Redeem" on reward
4. **Expected**: Reward applied to account

**⚠️ Edge/Stress Test**
1. Redeem without enough points
2. **Expected**: Error shown
3. Redeem expired reward
4. **Expected**: "Reward expired"

---

### UC-027: Tier Progression

**✅ Happy Path Test**
1. Earn enough points
2. **Expected**: Tier upgrade notification
3. **Verify**: New tier benefits active

**⚠️ Edge/Stress Test**
1. Downgrade due to inactivity
2. **Expected**: Notification, benefits removed

---

## 9. Social Features (8 Features)

### UC-028: Add Friends

**✅ Happy Path Test**
1. Profile → Friends → "+ Add"
2. Search by email/username
3. Send friend request
4. **Expected**: Request sent

**⚠️ Edge/Stress Test**
1. Add yourself as friend
2. **Expected**: Error "Cannot add yourself"
3. Add blocked user
4. **Expected**: Error shown

---

### UC-029: Send Messages

**✅ Happy Path Test**
1. Select friend → "Message"
2. Type and send message
3. **Expected**: Message delivered
4. **Verify**: Friend receives notification

**⚠️ Edge/Stress Test**
1. Send 10000 character message
2. **Expected**: Limited or warning
3. Send while offline
4. **Expected**: Queued, sent when online

---

### UC-030: Share Venue

**✅ Happy Path Test**
1. Open venue → Tap share icon
2. Select "Share with Friend"
3. Choose friend
4. **Expected**: Venue link sent

**⚠️ Edge/Stress Test**
1. Share to blocked friend
2. **Expected**: Error or filtered
3. Share non-existent venue
4. **Expected**: Handled

---

## 10. Profile & Settings (6 Features)

### UC-031: Edit Profile

**✅ Happy Path Test**
1. Profile → "Edit Profile"
2. Change name, photo, bio
3. Tap "Save"
4. **Expected**: Changes saved

**⚠️ Edge/Stress Test**
1. Upload 50MB photo
2. **Expected**: Size limit or compression
3. Enter 10000 char bio
4. **Expected**: Character limit

---

### UC-032: Change Password

**✅ Happy Path Test**
1. Settings → "Change Password"
2. Enter old password
3. Enter new password
4. **Expected**: Password updated

**⚠️ Edge/Stress Test**
1. Enter wrong old password
2. **Expected**: Error "Incorrect password"
3. Use same password
4. **Expected**: Error "Use different password"

---

### UC-033: Notification Preferences

**✅ Happy Path Test**
1. Settings → "Notifications"
2. Toggle various options
3. **Expected**: Settings saved

**⚠️ Edge/Stress Test**
1. Disable all notifications
2. **Expected**: Warning shown
3. Toggle rapidly
4. **Expected**: Final state correct

---

### UC-034: Logout

**✅ Happy Path Test**
1. Settings → "Logout"
2. Confirm
3. **Expected**: Returned to login screen

**⚠️ Edge/Stress Test**
1. Logout with pending uploads
2. **Expected**: Warning or queue cleared
3. Logout then close app
4. **Expected**: Stays logged out

---

## 11. Edge Cases & Stress Tests

### UC-035: Network Issues

**⚠️ Stress Test Scenarios**
1. Turn off WiFi mid-booking
2. **Expected**: Error, can retry when online
3. Switch from WiFi to cellular
4. **Expected**: Seamless transition
5. Airplane mode then back
6. **Expected**: App reconnects

---

### UC-036: App Performance

**⚠️ Stress Test Scenarios**
1. Keep app open for 8 hours
2. **Expected**: No memory leaks, no slowdown
3. Open/close app 100 times
4. **Expected**: No crashes
5. Fill cache with 10000 venue images
6. **Expected**: Auto-cleanup or manageable

---

### UC-037: Concurrent Actions

**⚠️ Stress Test Scenarios**
1. Make 3 bookings simultaneously
2. **Expected**: All process correctly
3. Pay for booking while receiving message
4. **Expected**: Both complete
5. Edit profile while uploading photo
6. **Expected**: No data corruption

---

### UC-038: Data Persistence

**⚠️ Stress Test Scenarios**
1. Force quit during booking
2. **Expected**: Booking draft saved or cleared
3. Clear app cache
4. **Expected**: Favorites/settings restored from server
5. Uninstall and reinstall
6. **Expected**: Login restores data

---

### UC-039: Security Tests

**⚠️ Stress Test Scenarios**
1. Try accessing API without auth token
2. **Expected**: 401 Unauthorized
3. Modify payment amount in network request
4. **Expected**: Server-side validation fails
5. Screenshot payment screen
6. **Expected**: Sensitive data masked (if applicable)

---

### UC-040: Accessibility Tests

**✅ Accessibility Checks**
1. Enable VoiceOver (iOS) / TalkBack (Android)
2. Navigate entire app
3. **Expected**: All elements readable
4. Increase text size to 200%
5. **Expected**: UI adapts, no overflow
6. Test in dark mode
7. **Expected**: All text readable

---

## Test Execution Summary

### Test Metrics

| Category | Features | Happy Path Tests | Edge/Stress Tests | Total Tests |
|----------|----------|------------------|-------------------|-------------|
| Authentication | 8 | 8 | 8 | 16 |
| Venue Discovery | 17 | 17 | 17 | 34 |
| Table Bookings | 17 | 17 | 17 | 34 |
| Bottle Service | 10 | 10 | 10 | 20 |
| Events & Tickets | 16 | 16 | 16 | 32 |
| In-App Payments | 10 | 10 | 10 | 20 |
| Group Bookings | 10 | 10 | 10 | 20 |
| Loyalty & Rewards | 8 | 8 | 8 | 16 |
| Social Features | 8 | 8 | 8 | 16 |
| Profile & Settings | 6 | 6 | 6 | 12 |
| **TOTAL** | **110** | **110** | **110** | **220** |

---

## Critical Test Cases (Must Pass Before Release)

### P0 - Blocker Issues
1. ✅ User can sign up and login
2. ✅ Venues load and display correctly
3. ✅ Table booking completes successfully
4. ✅ **In-app payment processes WITHOUT browser**
5. ✅ Event tickets can be purchased IN-APP
6. ✅ QR codes display properly
7. ✅ **Saved cards work for repeat purchases**
8. ✅ App doesn't crash on common actions

### P1 - Critical Issues
1. Search and filters work
2. Notifications send correctly
3. Profile edits save
4. Favorites persist
5. **Payment Sheet shows saved cards**
6. **Google Pay / Apple Pay work in-app**

### P2 - Important Issues
1. Special requests save
2. Group bookings split correctly
3. Rewards redeem properly
4. Messages deliver

---

## Test Environment Setup

### Required Test Accounts
- Email: `qa.test@bottlesup.com` / `Test123!@#`
- Google test account
- Apple test account

### Test Cards (Stripe Test Mode)
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`
- 3D Secure: `4000 0025 0000 3155`
- Insufficient funds: `4000 0000 0000 9995`

### Test Devices
- iOS: iPhone 12+ (iOS 15+)
- Android: Pixel 5+ (Android 10+)
- Both WiFi and Cellular

---

## Bug Reporting Template

```
**Bug ID**: BUG-XXX
**Severity**: P0 / P1 / P2
**Use Case**: UC-XXX
**Test Type**: Happy Path / Edge Case

**Steps to Reproduce**:
1.
2.
3.

**Expected Result**:

**Actual Result**:

**Screenshots**:

**Device**: iPhone 14 Pro / iOS 16.5
**App Version**: 2.0.1
```

---

## Sign-Off Criteria

### Ready for Production When:
- [ ] All P0 tests pass
- [ ] 95%+ P1 tests pass
- [ ] No critical crashes
- [ ] **In-app payment works smoothly**
- [ ] **Saved cards function correctly**
- [ ] **No browser redirects during payment**
- [ ] Payment success rate > 98%
- [ ] QR code displays reliably
- [ ] Performance acceptable (app loads < 2s)

---

**Status**: ✅ Ready for QA Testing
**Last Updated**: May 3, 2026
