# BottlesUp - Complete Feature Testing Guide
## Test All 110 Features as a Normal User

This guide walks you through testing all 110 features in the order a normal user would experience them.

---

## Phase 1: Getting Started (Features 1-8)

### 1. Authentication & Onboarding
**Features to test: 8**

#### Sign Up
1. Launch the app
2. Tap "Sign Up"
3. **Feature 1**: Enter email and password (Email/Password Auth)
4. **Feature 2**: Tap "Sign up with Google" (Google Sign-In)
5. **Feature 3**: Tap "Sign in with Apple" (Apple Sign-In)
6. Complete age verification (must be 21+)
7. Accept terms and conditions

#### Login
8. Go back to login screen
9. **Feature 4**: Login with your email/password
10. **Feature 5**: Try "Forgot Password" link
11. Check your email for reset link
12. **Feature 6**: Reset your password using the link

#### Location Permission
13. **Feature 7**: Allow location access when prompted
14. **Feature 8**: If denied, manually enter your city/address

**Expected Result**: You should be logged in and see the home screen with nearby venues.

---

## Phase 2: Exploring Venues (Features 9-25)

### 2. Discover Clubs & Venues
**Features to test: 17**

#### Browse Venues
1. Open the app, you're now on the Home screen
2. **Feature 9**: Scroll through the list of nearby clubs/venues
3. **Feature 10**: Pull down to refresh the venue list
4. **Feature 11**: Tap on category filters (Nightclub, Lounge, Bar, etc.)
5. **Feature 12**: Use the search bar to search for a specific venue name

#### View Venue Details
6. Tap on any venue card
7. **Feature 13**: View detailed venue info (address, hours, photos, description)
8. **Feature 14**: Scroll through venue photo gallery
9. **Feature 15**: Check the venue's operating hours and contact info
10. **Feature 16**: View the venue's menu (drinks, bottles, food)
11. **Feature 17**: See current crowd level and wait time (real-time)

#### Venue Ratings & Reviews
12. **Feature 18**: Scroll down to see user reviews and ratings
13. **Feature 19**: Tap "Write Review" and submit your own rating (1-5 stars)
14. **Feature 20**: Add photos to your review
15. **Feature 21**: Read reviews filtered by rating or date

#### Venue Comparison
16. **Feature 22**: Tap "Compare" button
17. **Feature 23**: Select 2-3 venues to compare side-by-side
18. **Feature 24**: View comparison of prices, ratings, distance, amenities
19. **Feature 25**: Save your favorite venues by tapping the heart icon

**Expected Result**: You can browse, search, view details, read reviews, and compare venues.

---

## Phase 3: Making Reservations (Features 26-42)

### 3. Table Bookings
**Features to test: 17**

#### Browse Available Tables
1. From venue detail screen, tap "Book a Table"
2. **Feature 26**: Select your preferred date and time
3. **Feature 27**: View available tables with capacity, location, and pricing
4. **Feature 28**: Filter tables by capacity (2, 4, 6, 8+ people)
5. **Feature 29**: Filter by VIP vs Regular tables
6. **Feature 30**: View table location on venue floor plan

#### Make a Reservation
7. **Feature 31**: Select a table and tap "Reserve"
8. **Feature 32**: Enter number of guests in your party
9. **Feature 33**: Add special requests (birthday, anniversary, accessibility needs)
10. **Feature 34**: Choose to add bottle service to your reservation
11. **Feature 35**: Review reservation summary and total cost
12. **Feature 36**: Complete payment (credit card, Apple Pay, Google Pay)

#### Manage Bookings
13. Go to Profile → "My Bookings"
14. **Feature 37**: View all your upcoming reservations
15. **Feature 38**: View past booking history
16. **Feature 39**: Tap on a booking to see details and QR code
17. **Feature 40**: Modify your reservation (change time, add guests)
18. **Feature 41**: Cancel a reservation (check refund policy)
19. **Feature 42**: Download booking confirmation as PDF

**Expected Result**: You can browse tables, make reservations, and manage your bookings.

---

## Phase 4: Bottle Service (Features 43-52)

### 4. Ordering Bottles
**Features to test: 10**

#### Browse Bottle Menu
1. From table booking screen or venue menu, tap "Bottle Service"
2. **Feature 43**: Browse available bottles (vodka, whiskey, champagne, tequila)
3. **Feature 44**: View bottle details (size, price, brand, ABV)
4. **Feature 45**: Filter bottles by category, price range, or popularity
5. **Feature 46**: Search for specific bottle brands

#### Order Bottles
6. **Feature 47**: Add bottles to your order
7. **Feature 48**: Select bottle size (375ml, 750ml, 1L, magnum)
8. **Feature 49**: Add mixers and garnishes (coke, juice, lemons, limes)
9. **Feature 50**: View recommended bottles based on your party size
10. **Feature 51**: Add bottle to existing table reservation
11. **Feature 52**: Pre-order bottles for future reservation

**Expected Result**: You can browse bottles, customize your order, and add to reservations.

---

## Phase 5: Events & Tickets (Features 53-68)

### 5. Discover Events
**Features to test: 16**

#### Browse Events
1. Tap "Events" tab at the bottom navigation
2. **Feature 53**: View upcoming events at nearby venues
3. **Feature 54**: Filter events by date, category (DJ night, concert, special event)
4. **Feature 55**: Search for specific events or artists
5. **Feature 56**: View event details (date, time, lineup, dress code, age requirement)
6. **Feature 57**: See event photos and promotional videos

#### Purchase Tickets
7. Tap on an event, then "Buy Tickets"
8. **Feature 58**: View available ticket types (General, VIP, Table packages)
9. **Feature 59**: Select ticket quantity
10. **Feature 60**: Choose add-ons (parking pass, coat check, fast entry)
11. **Feature 61**: Complete purchase and receive digital tickets
12. **Feature 62**: View tickets in Profile → "My Tickets"
13. **Feature 63**: Show QR code at venue for entry

#### Event Registration & Check-In
14. **Feature 64**: RSVP to free events
15. **Feature 65**: Add event to your calendar
16. **Feature 66**: Check in at the event using QR code
17. **Feature 67**: Receive event notifications and updates
18. **Feature 68**: Get personalized event recommendations

**Expected Result**: You can discover events, buy tickets, and manage event attendance.

---

## Phase 6: Group Features (Features 69-78)

### 6. Group Bookings & Parties
**Features to test: 10**

#### Create Group Booking
1. From any venue or event, tap "Group Booking"
2. **Feature 69**: Create a group booking for large parties (10+ people)
3. **Feature 70**: Invite friends to join your group booking
4. **Feature 71**: Friends receive invitation via app notification or SMS
5. **Feature 72**: Track who has accepted/declined
6. **Feature 73**: Split the total cost among group members
7. **Feature 74**: Set different payment amounts per person

#### Manage Group
8. **Feature 75**: Chat with group members about the booking
9. **Feature 76**: Update group booking details (add/remove people)
10. **Feature 77**: Assign a group leader who manages the booking
11. **Feature 78**: View group attendance and payment status

**Expected Result**: You can organize group outings, invite friends, and split costs.

---

## Phase 7: Payments & Billing (Features 79-88)

### 7. Payment Management
**Features to test: 10**

#### Payment Methods
1. Go to Profile → Settings → Payment Methods
2. **Feature 79**: Add credit/debit card
3. **Feature 80**: Add Apple Pay / Google Pay
4. **Feature 81**: Save multiple payment methods
5. **Feature 82**: Set a default payment method
6. **Feature 83**: Remove old payment methods

#### Transaction History
7. Go to Profile → "Payment History"
8. **Feature 84**: View all past transactions
9. **Feature 85**: Filter by date, venue, or amount
10. **Feature 86**: Download transaction receipts
11. **Feature 87**: Request refund for eligible purchases

#### Bill Splitting
12. After a night out, go to a completed booking
13. **Feature 88**: Split bill with friends who attended
14. View individual amounts owed
15. Send payment requests to friends
16. Track who has paid their share

**Expected Result**: You can manage payment methods, view history, and split bills easily.

---

## Phase 8: Loyalty & Rewards (Features 89-96)

### 8. Loyalty Program
**Features to test: 8**

#### Earn Points
1. Go to Profile → "Loyalty & Rewards"
2. **Feature 89**: View your loyalty tier (Bronze, Silver, Gold, Platinum)
3. **Feature 90**: Check your current points balance
4. **Feature 91**: See points earned from recent bookings and purchases
5. **Feature 92**: View progress to next tier

#### Redeem Rewards
6. **Feature 93**: Browse available rewards (free drinks, discounts, VIP upgrades)
7. **Feature 94**: Redeem points for rewards
8. **Feature 95**: Apply reward code at checkout
9. **Feature 96**: View reward expiration dates

#### Achievements
10. Tap "Achievements"
11. View unlocked badges (First Booking, Regular Visitor, Party Animal, etc.)
12. Check progress on locked achievements

**Expected Result**: You earn points with each booking and can redeem them for rewards.

---

## Phase 9: Social Features (Features 97-104)

### 9. Social Networking
**Features to test: 8**

#### Add Friends
1. Go to Profile → "Friends"
2. **Feature 97**: Search for friends by username or phone number
3. **Feature 98**: Send friend requests
4. **Feature 99**: Accept incoming friend requests
5. **Feature 100**: View your friends list

#### Messaging
6. Tap on a friend, then "Message"
7. **Feature 101**: Send direct messages
8. **Feature 102**: Create group chats
9. **Feature 103**: Share venue recommendations with friends
10. **Feature 104**: Share your bookings and invite friends

#### Social Sharing
11. From any venue or event, tap "Share"
12. Share to Instagram, Facebook, Twitter
13. Share booking confirmation with friends
14. Tag friends in photos

**Expected Result**: You can connect with friends, chat, and share experiences.

---

## Phase 10: Profile & Settings (Features 105-110)

### 10. Account Management
**Features to test: 6**

#### Edit Profile
1. Go to Profile → "Edit Profile"
2. **Feature 105**: Update profile photo
3. Edit name, bio, birthday
4. Update contact information

#### Preferences
5. Go to Profile → "Settings"
6. **Feature 106**: Set notification preferences
   - Push notifications for bookings
   - Email notifications for events
   - SMS alerts for reminders
7. **Feature 107**: Update privacy settings
   - Make profile public/private
   - Control who can see your bookings
   - Manage blocked users

#### User Preferences
8. **Feature 108**: Set favorite venue types
9. Set preferred music genres
10. Set dietary restrictions/preferences
11. Set accessibility needs

#### Support & Help
12. **Feature 109**: Go to Profile → "Help & Support"
13. Browse FAQ
14. Submit support ticket
15. Contact customer service via chat

#### Account Actions
16. **Feature 110**: Log out
17. Log back in
18. Test "Remember Me" feature
19. Review Terms & Privacy Policy

**Expected Result**: You can fully customize your profile, preferences, and get support.

---

## Bonus: Real-Time Features to Check

### Live Updates (throughout the app)
- **Real-time venue availability**: Watch tables become available/unavailable
- **Live queue positions**: See your waitlist position update in real-time
- **Event chat**: Join event chat rooms and see messages appear live
- **Notifications**: Receive instant push notifications for:
  - Booking confirmations
  - Event reminders (24hr, 1hr before)
  - Table ready notifications
  - Friend requests
  - Group booking invitations
  - Loyalty reward unlocks

---

## Summary Checklist

Print this and check off as you test:

**Phase 1: Getting Started (8 features)**
- [ ] Email/Password signup & login
- [ ] Google Sign-In
- [ ] Apple Sign-In
- [ ] Password reset
- [ ] Location permission & manual entry

**Phase 2: Venues (17 features)**
- [ ] Browse, search, filter venues
- [ ] View details, photos, menu
- [ ] Read and write reviews
- [ ] Compare venues
- [ ] Save favorites

**Phase 3: Reservations (17 features)**
- [ ] Browse available tables
- [ ] Make table reservation
- [ ] View/modify/cancel bookings
- [ ] Special requests
- [ ] Payment processing

**Phase 4: Bottle Service (10 features)**
- [ ] Browse bottle menu
- [ ] Order bottles with mixers
- [ ] Pre-order for reservations

**Phase 5: Events (16 features)**
- [ ] Browse and search events
- [ ] Purchase tickets
- [ ] Event check-in
- [ ] Event recommendations

**Phase 6: Groups (10 features)**
- [ ] Create group booking
- [ ] Invite friends
- [ ] Split costs
- [ ] Group chat

**Phase 7: Payments (10 features)**
- [ ] Add payment methods
- [ ] View transaction history
- [ ] Bill splitting
- [ ] Refund requests

**Phase 8: Loyalty (8 features)**
- [ ] View tier and points
- [ ] Earn points from bookings
- [ ] Redeem rewards
- [ ] Unlock achievements

**Phase 9: Social (8 features)**
- [ ] Add friends
- [ ] Direct messaging
- [ ] Group chats
- [ ] Share content

**Phase 10: Profile (6 features)**
- [ ] Edit profile
- [ ] Notification settings
- [ ] Privacy settings
- [ ] User preferences
- [ ] Help & support
- [ ] Logout/login

**Total: 110 Features ✓**

---

## Testing Tips

1. **Create Multiple Test Accounts**: Test friend requests and group features with 2-3 accounts
2. **Use Real Locations**: Test location-based features with actual GPS or various manual locations
3. **Test Edge Cases**:
   - Try booking tables at capacity
   - Cancel and modify bookings
   - Test with poor internet connection
   - Test notification permissions denied
4. **Check Error Handling**:
   - Invalid payment info
   - Expired tickets
   - Insufficient points for rewards
5. **Test on Different Devices**: iOS, Android, different screen sizes

---

## Reporting Issues

If you find any bugs or features not working:

1. Note the feature number and name
2. Describe what you expected vs. what happened
3. Include screenshots if possible
4. Note your device type and OS version

**Happy Testing!** 🎉
