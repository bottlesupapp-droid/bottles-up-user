# BottlesUp - Quick Feature Test Checklist
## 110 Features in 10 Minutes

Use this streamlined checklist to quickly verify all features are working.

---

## 1. Authentication (8 features) - 1 min
- [ ] Sign up with email
- [ ] Login with Google
- [ ] Login with Apple
- [ ] Forgot password flow
- [ ] Location permission

**Quick test**: Create account → logout → login → reset password → allow location

---

## 2. Venue Discovery (17 features) - 2 min
- [ ] Browse venue list
- [ ] Search venues
- [ ] Filter by category
- [ ] View venue details
- [ ] View photo gallery
- [ ] Read/write reviews
- [ ] Compare 2-3 venues
- [ ] Save favorites

**Quick test**: Browse venues → search "club" → open details → view photos → write review → compare 2 venues → save favorite

---

## 3. Table Bookings (17 features) - 2 min
- [ ] View available tables
- [ ] Filter tables (VIP, capacity)
- [ ] Select table
- [ ] Add special requests
- [ ] Complete payment
- [ ] View booking in profile
- [ ] Modify booking
- [ ] Cancel booking

**Quick test**: Book table → add special request → pay → go to "My Bookings" → view details → modify → cancel

---

## 4. Bottle Service (10 features) - 1 min
- [ ] Browse bottle menu
- [ ] Filter bottles
- [ ] View bottle details
- [ ] Add mixers
- [ ] Add to reservation
- [ ] Pre-order bottles

**Quick test**: Open bottle menu → filter by vodka → view details → add mixers → add to booking

---

## 5. Events & Tickets (16 features) - 2 min
- [ ] Browse events
- [ ] Filter events
- [ ] View event details
- [ ] Buy tickets
- [ ] View ticket QR code
- [ ] RSVP to free event
- [ ] Event check-in
- [ ] Get recommendations

**Quick test**: Browse events → filter by date → open event → buy ticket → view in "My Tickets" → show QR code

---

## 6. Group Bookings (10 features) - 1 min
- [ ] Create group booking
- [ ] Invite friends
- [ ] Accept invitation (2nd account)
- [ ] Split costs
- [ ] Group chat
- [ ] Manage attendees

**Quick test**: Create group booking → invite friend → split bill 50/50 → send chat message

---

## 7. Payments (10 features) - 1 min
- [ ] Add credit card
- [ ] Add Apple/Google Pay
- [ ] Set default payment
- [ ] View transaction history
- [ ] Download receipt
- [ ] Bill split with friends
- [ ] Request refund

**Quick test**: Add payment method → make purchase → view history → download receipt → split bill

---

## 8. Loyalty & Rewards (8 features) - 1 min
- [ ] View loyalty tier
- [ ] Check points balance
- [ ] Earn points from booking
- [ ] Browse rewards
- [ ] Redeem reward
- [ ] View achievements
- [ ] Check tier progress

**Quick test**: Go to Loyalty → view tier → check points → browse rewards → redeem one → view achievements

---

## 9. Social Features (8 features) - 1 min
- [ ] Search friends
- [ ] Send friend request
- [ ] Accept request (2nd account)
- [ ] Send direct message
- [ ] Create group chat
- [ ] Share venue
- [ ] Tag friend in post

**Quick test**: Add friend → send DM → create group chat → share venue with friend

---

## 10. Profile & Settings (6 features) - 1 min
- [ ] Edit profile photo
- [ ] Update notification settings
- [ ] Set privacy settings
- [ ] Update preferences
- [ ] Contact support
- [ ] Logout/login

**Quick test**: Edit profile → change notification settings → update privacy → submit support ticket → logout → login

---

## Real-Time Features (verify throughout)
- [ ] Live table availability updates
- [ ] Real-time queue position
- [ ] Live event chat messages
- [ ] Instant push notifications
- [ ] Live venue crowd levels

**Quick test**: Open two devices → book table on one → see it become unavailable on the other

---

## Feature Count Verification

| Category | Features | Tested ✓ |
|----------|----------|----------|
| Authentication | 8 | [ ] |
| Venue Discovery | 17 | [ ] |
| Table Bookings | 17 | [ ] |
| Bottle Service | 10 | [ ] |
| Events & Tickets | 16 | [ ] |
| Group Bookings | 10 | [ ] |
| Payments | 10 | [ ] |
| Loyalty & Rewards | 8 | [ ] |
| Social Features | 8 | [ ] |
| Profile & Settings | 6 | [ ] |
| **TOTAL** | **110** | **[ ]** |

---

## Pass/Fail Criteria

**✅ PASS**: All 110 checkboxes checked, no crashes, core flows work

**❌ FAIL**: Any critical feature broken (signup, login, booking, payment)

**⚠️ PARTIAL**: Minor bugs but core functionality works

---

## Speed Testing Routes

### Route 1: Basic User Journey (5 min)
1. Sign up → allow location
2. Browse venues → open one → read reviews
3. Book table → add bottle service → pay
4. View booking → modify → cancel

### Route 2: Social User Journey (3 min)
1. Login → browse events
2. Buy event ticket → invite friend
3. Create group booking → split costs
4. Chat with friend → share venue

### Route 3: Power User Journey (2 min)
1. Login → check loyalty points
2. Redeem reward → apply to booking
3. View payment history → download receipt
4. Update preferences → logout

---

## Common Test Scenarios

### Happy Path ✓
- User signs up → finds venue → books table → pays → attends → rates venue

### Edge Cases to Test
- [ ] Booking fully booked venue (waitlist)
- [ ] Canceling within 24 hours (refund policy)
- [ ] Redeeming expired rewards
- [ ] Splitting bill with offline friends
- [ ] Booking with insufficient payment method

### Error Scenarios
- [ ] Login with wrong password
- [ ] Payment declined
- [ ] Weak internet connection
- [ ] Location services off
- [ ] Notifications disabled

---

## Testing on Different Flows

### New User Flow
Sign up → onboarding → location → browse → book → pay → profile setup

### Returning User Flow
Login → check notifications → view saved venues → rebook favorite table

### Event-Focused User Flow
Login → browse events → buy tickets → invite friends → check in at event

### Social User Flow
Login → add friends → create group booking → chat → split costs

---

## Quick Debug Commands

While app is running (`flutter run` active):

- **r** - Hot reload (test UI changes instantly)
- **R** - Hot restart (full app restart)
- **c** - Clear console
- **q** - Quit app

---

## One-Line Test Per Feature Category

```
Auth: signup→login→reset→location ✓
Venues: browse→search→details→review→compare→save ✓
Bookings: tables→select→request→pay→view→modify→cancel ✓
Bottles: menu→filter→details→mixers→add ✓
Events: browse→filter→details→tickets→checkin ✓
Groups: create→invite→split→chat ✓
Payments: add→pay→history→receipt→split ✓
Loyalty: view→earn→redeem→achievements ✓
Social: friends→message→group→share ✓
Profile: edit→settings→privacy→support→logout ✓
```

---

## Emergency Test (30 seconds)

**Bare minimum to verify app works:**

1. Open app ✓
2. Sign up ✓
3. Allow location ✓
4. See venue list ✓
5. Open venue details ✓
6. Start booking flow ✓
7. See payment screen ✓
8. Navigate to profile ✓
9. Logout ✓
10. Login ✓

**If all 10 work → core app is functional** ✅

---

## Notes Section

**Date Tested**: _______________

**Device**: _______________

**OS Version**: _______________

**Tester**: _______________

**Build Version**: _______________

**Critical Issues Found**:
- ________________________________
- ________________________________
- ________________________________

**Minor Issues**:
- ________________________________
- ________________________________

**Overall Status**: ⬜ PASS  ⬜ FAIL  ⬜ PARTIAL

---

**Remember**: The goal is to verify all 110 features exist and are accessible, not to do exhaustive testing of every edge case.

**Happy Quick Testing! ⚡**
