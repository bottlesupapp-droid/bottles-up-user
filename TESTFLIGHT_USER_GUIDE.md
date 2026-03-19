# TestFlight User Testing Guide - Bottles Up

Welcome to the Bottles Up beta testing program! This guide will help you test all the new features we've added to the app.

## 📱 Getting Started

### Installation
1. **Check your email** for the TestFlight invitation
2. **Download TestFlight** from the App Store (if you don't have it)
3. **Open the invitation link** and tap "Accept"
4. **Install Bottles Up** from TestFlight
5. **Launch the app** from your home screen

### First-Time Setup
When you first open the app:

1. **Sign Up / Login**
   - Create a new account with email/password, OR
   - Sign in with Google

2. **Allow Permissions** (tap "Allow" for each):
   - 📍 **Location**: "While Using the App" (required for finding nearby venues)
   - 📸 **Camera**: To take photos for reviews and profile
   - 🖼️ **Photos**: To select images from your library
   - 🔔 **Notifications**: To get ticket transfer alerts

3. **Complete Your Profile**
   - Add a profile photo
   - Enter your full name
   - Confirm you're 21+ (required)

---

## 🎯 What to Test

We've added **9 major new features**. Please test as many as you can!

---

## Feature 1: 🏢 Venue Discovery

**Where:** Home screen → Tap "Venues" tab or menu item

### What to Do:
1. **Browse venues**
   - Scroll through the venue list
   - Notice each card shows: photo, name, city, rating ⭐, capacity 👥, and price 💵

2. **Use filters** (tap filter icon in top-right):
   - Select a city from dropdown
   - Set capacity range (try: Min 50, Max 200)
   - Set price range (try: Max $500/hour)
   - Select amenities: WiFi, Parking, Bar, Kitchen, etc.
   - Tap "Apply Filters"
   - ✅ Results should update to match your filters

3. **Clear filters**:
   - Tap "Clear All" to reset

4. **Pull to refresh**:
   - Pull down on the list to reload venues

### ✅ What Should Happen:
- Venues load within 2-3 seconds
- Filters update the list correctly
- Images load smoothly
- Empty state shows "No venues found" if filters are too restrictive

### 🐛 Report if:
- [ ] Venues don't load
- [ ] Filters don't work correctly
- [ ] Images are broken or very slow
- [ ] App crashes when applying filters

---

## Feature 2: 🏛️ Venue Details & Reviews

**Where:** Tap any venue card from the venue list

### What to Do:
1. **View venue info**
   - Scroll up/down to see the parallax image effect
   - Check all details: rating, capacity, hourly price, description
   - View amenities (small chips below description)

2. **Test contact buttons**:
   - 📞 Tap phone number → Should open Phone app
   - 📧 Tap email → Should open Mail app
   - 🌐 Tap website → Should open Safari

3. **Write a review**:
   - Scroll to "Reviews" section
   - Tap "Write a Review"
   - Slide the rating slider (1-5 stars)
   - Type: "Great venue! Highly recommend for events."
   - Tap "Submit Review"
   - ✅ Your review should appear immediately in the list
   - ✅ The venue's average rating should update

### ✅ What Should Happen:
- Hero image has smooth parallax scrolling
- Contact buttons open correct apps
- Review submits successfully
- Your review appears right away
- Average rating recalculates

### 🐛 Report if:
- [ ] Image doesn't scroll smoothly
- [ ] Contact buttons don't work
- [ ] Review submission fails
- [ ] Review doesn't appear
- [ ] Rating doesn't update

---

## Feature 3: 📋 Venue Inquiry Form

**Where:** Venue detail screen → Tap "Send Inquiry" button at bottom

### What to Do:
1. **Fill out the form**:
   - Event name: "Birthday Party"
   - Event date: Tap calendar → Select a date **in the future**
   - Start time: Select from picker (e.g., 7:00 PM)
   - End time: Select from picker (e.g., 11:00 PM)
   - Guest count: 50
   - Message: "Looking to book this venue for a special celebration"

2. **Submit inquiry**:
   - Tap "Send Inquiry"
   - ✅ Success message should appear
   - ✅ Form should close/navigate back

3. **Test validation** (try these to make sure errors show):
   - Leave event name blank → Tap Submit (should show error)
   - Select a past date → Should be disabled or show error
   - Set end time before start time → Should show error

### ✅ What Should Happen:
- Date picker only allows future dates
- Time pickers work smoothly
- Form validates all required fields
- Success message shows after submit

### 🐛 Report if:
- [ ] Can select past dates
- [ ] Time pickers not working
- [ ] Form submits with empty fields
- [ ] No success/error messages
- [ ] App crashes on submit

---

## Feature 4: ⚖️ Venue Comparison

**Where:** May be accessed from venue list (Compare button) or deep link

### What to Do:
1. **View comparison**:
   - Should show 2-4 venue cards side-by-side (scroll horizontally if needed)
   - Check comparison sections:
     - 💰 **Price**: Lowest, Highest, Average
     - 👥 **Capacity**: Shows each venue's capacity
     - ⭐ **Rating**: Shows each venue's rating
   - Scroll to **Amenities Matrix**:
     - ✅ Checkmarks show which venues have which amenities

2. **Save comparison**:
   - Tap save/bookmark icon in app bar
   - Enter name: "Birthday Venue Options"
   - Tap "Save"
   - ✅ Success message should appear

### ✅ What Should Happen:
- Venues display side-by-side
- Metrics calculate correctly (price, capacity, rating)
- Amenities matrix is clear and accurate
- Save functionality works

### 🐛 Report if:
- [ ] Venues not displaying correctly
- [ ] Calculations are wrong
- [ ] Amenities matrix is confusing
- [ ] Can't save comparison

---

## Feature 5: 💬 Event Chat (Real-time)

**Where:** Event detail screen → Tap "Chat" or "Event Chat"

### What to Do:
1. **View messages**:
   - Existing messages should load automatically
   - Check each message shows: avatar, name, message text, timestamp

2. **Send a message**:
   - Type: "Hello from TestFlight testing! 👋"
   - Tap send button
   - ✅ Message appears immediately at bottom
   - ✅ Chat auto-scrolls to your message

3. **Test pinning** (if you're the event host):
   - Long-press any message
   - Tap "Pin Message"
   - Tap "View Pinned" in app bar
   - ✅ Pinned messages show in bottom sheet
   - Tap a pinned message to jump to it

4. **Real-time test** (if you have 2 devices or another tester):
   - Send message from Device A
   - ✅ Message should appear on Device B within 1-2 seconds (no refresh needed!)

### ✅ What Should Happen:
- Messages load instantly
- Sending works smoothly
- Timestamps show relative time ("2 minutes ago")
- Real-time updates work without refresh
- Pin/unpin works for hosts

### 🐛 Report if:
- [ ] Messages don't load
- [ ] Can't send messages
- [ ] No real-time updates
- [ ] Pin feature broken
- [ ] Chat doesn't auto-scroll

---

## Feature 6: 📊 Event Polls (Live Results)

**Where:** Event detail screen → Tap "Polls"

### What to Do:
1. **View polls**:
   - Should see list of polls with questions and options
   - Progress bars show current vote percentages

2. **Vote on a poll**:
   - Tap any option to vote
   - ✅ Vote registers immediately
   - ✅ Progress bars update to show new percentages
   - ✅ Your option is highlighted
   - ✅ Total vote count increases

3. **Create a poll** (if you're the event host):
   - Tap "Create Poll" button (+ icon)
   - Question: "What time should we start?"
   - Add options: "8 PM", "9 PM", "10 PM"
   - Choose "Single Choice" or "Multiple Choice"
   - Tap "Create Poll"
   - ✅ Poll appears in list immediately

4. **Real-time voting** (with another tester):
   - Vote from Device A
   - ✅ Device B should see vote count update instantly

### ✅ What Should Happen:
- Polls load quickly
- Voting works instantly
- Percentages calculate correctly
- Real-time updates work
- Poll creation works (for hosts)

### 🐛 Report if:
- [ ] Polls don't load
- [ ] Can't vote
- [ ] Percentages wrong
- [ ] No real-time updates
- [ ] Can't create poll (host)

---

## Feature 7: 📢 Host Announcements

**Where:** Event detail screen → Tap "Announcements"

### What to Do:
1. **View announcements**:
   - Should load in order: pinned first (with 📌 icon), then newest first
   - Each shows: title, message, timestamp
   - If announcement has a link, it's underlined/blue

2. **Tap a link** (if present):
   - Should open in Safari browser

3. **Create announcement** (if you're the event host):
   - Tap "+ New Announcement" button
   - Title: "Important Update"
   - Message: "Event start time changed to 9 PM. Please arrive on time!"
   - Link (optional): "https://example.com"
   - Toggle "Pin announcement" ON
   - Move priority slider to 8
   - Tap "Create"
   - ✅ Announcement appears at top (pinned)

4. **Edit announcement** (host only):
   - Tap three-dot menu (⋮) on your announcement
   - Tap "Edit"
   - Change message to: "Event starts at 9:30 PM"
   - Tap "Update"
   - ✅ Changes show immediately

5. **Delete announcement** (host only):
   - Tap three-dot menu (⋮)
   - Tap "Delete"
   - Confirm deletion
   - ✅ Announcement disappears

### ✅ What Should Happen:
- Announcements load in correct order
- Links are clickable
- Create/edit/delete works for hosts
- Pinned announcements stay at top

### 🐛 Report if:
- [ ] Announcements don't load
- [ ] Order is wrong (pinned not first)
- [ ] Links don't open
- [ ] Can't create/edit/delete (host)

---

## Feature 8: 🎟️ Ticket Transfer

**Where:** Main menu or Profile → "Ticket Transfers"

### What to Do:
1. **View received transfers**:
   - Tap "Received" tab
   - Should see pending transfers (if any)
   - Each shows: event name, sender name, # of tickets, status

2. **Accept a transfer**:
   - Tap "Accept" button (green)
   - Confirm in dialog
   - ✅ Status changes to "Accepted" (green chip)
   - ✅ Ticket should now be in your bookings

3. **Reject a transfer** (try with a different one):
   - Tap "Reject" button (red)
   - Confirm rejection
   - ✅ Status changes to "Rejected" (red chip)

4. **View sent transfers**:
   - Tap "Sent" tab
   - See transfers you've sent to others
   - Status shows: Pending, Accepted, Rejected, or Cancelled

5. **Cancel a sent transfer**:
   - Find a pending transfer you sent
   - Tap "Cancel"
   - Confirm cancellation
   - ✅ Status changes to "Cancelled" (gray chip)

6. **Check expiration**:
   - Transfers expire in 48 hours
   - If any are close to expiring, should show warning badge

### ✅ What Should Happen:
- Tabs switch smoothly
- Accept moves ticket to your account
- Reject returns ticket to sender
- Cancel works for sent transfers
- Status chips are color-coded correctly

### 🐛 Report if:
- [ ] Tabs don't work
- [ ] Transfers don't load
- [ ] Accept/reject doesn't work
- [ ] Cancel doesn't work
- [ ] Status not updating
- [ ] Ticket not transferring

---

## Feature 9: 📸 Image Upload

**Where:** Various places (venue reviews, profile photo, announcements, etc.)

### What to Do:
1. **Upload from gallery**:
   - Tap "Add Photo" or camera icon
   - Select "Choose from Library" / "Gallery"
   - Pick an image from your photos
   - ✅ Loading indicator should show
   - ✅ Image uploads and displays

2. **Take photo with camera**:
   - Tap "Add Photo" or camera icon
   - Select "Take Photo" / "Camera"
   - Take a photo
   - Tap "Use Photo"
   - ✅ Photo uploads and displays

3. **Test with poor network** (optional):
   - Turn on airplane mode
   - Try uploading
   - ✅ Should show error and retry option

### ✅ What Should Happen:
- Image picker opens smoothly
- Camera launches correctly
- Upload shows progress
- Images display after upload
- Large images compress automatically

### 🐛 Report if:
- [ ] Picker doesn't open
- [ ] Camera won't launch
- [ ] Upload fails silently
- [ ] Images don't display
- [ ] App crashes on upload

---

## 🔍 General App Testing

Please also test these general aspects:

### Navigation
- ✅ Back button works on all screens
- ✅ Bottom navigation tabs work
- ✅ No crashes when switching tabs
- ✅ Deep links open correct screens (if you get any)

### Performance
- ✅ Screens load within 2-3 seconds
- ✅ Scrolling is smooth (no lag)
- ✅ App doesn't freeze or hang
- ✅ Real-time updates happen within 1-2 seconds
- ✅ No excessive battery drain

### Error Handling
- ✅ Turn off WiFi → Error messages should be clear
- ✅ Try submitting empty forms → Validation works
- ✅ Error messages are user-friendly (not technical gibberish)
- ✅ Retry buttons work after errors

### UI/Visual
- ✅ Text is readable (good size and contrast)
- ✅ Buttons are easy to tap (not too small)
- ✅ Icons make sense
- ✅ Loading spinners show when waiting
- ✅ No overlapping text or buttons
- ✅ Images fit properly (not cut off or stretched)

---

## 📋 Testing Checklist

Use this checklist to track what you've tested:

**Venue Features:**
- [ ] Browse venue list
- [ ] Apply filters
- [ ] View venue details
- [ ] Write venue review
- [ ] Send venue inquiry
- [ ] Compare venues
- [ ] Save comparison

**Event Features:**
- [ ] View event chat
- [ ] Send messages in chat
- [ ] Pin messages (if host)
- [ ] View polls
- [ ] Vote on poll
- [ ] Create poll (if host)
- [ ] View announcements
- [ ] Create/edit/delete announcement (if host)

**Ticket Transfer:**
- [ ] View received transfers
- [ ] Accept transfer
- [ ] Reject transfer
- [ ] View sent transfers
- [ ] Cancel sent transfer

**Image Upload:**
- [ ] Upload from gallery
- [ ] Take photo with camera

**General:**
- [ ] Navigation works
- [ ] Performance is good
- [ ] Error handling is clear
- [ ] UI looks polished

---

## 🐛 How to Report Bugs

When you find an issue:

### Method 1: In-App Feedback (Preferred)
1. **Shake your iPhone** while in the app
2. Tap "Provide Feedback"
3. Select "Report a Problem"
4. Attach screenshot (if relevant)
5. Describe what happened

### Method 2: TestFlight Feedback
1. Open **TestFlight** app
2. Tap **Bottles Up**
3. Tap "Send Feedback"
4. Choose feedback type
5. Describe the issue

### What to Include:
- **What you were doing**: "I was trying to submit a venue review"
- **What happened**: "The app crashed when I tapped Submit"
- **Can you repeat it?**: "Yes, it crashes every time"
- **Device info**: iPhone model (e.g., iPhone 14 Pro) and iOS version
- **Screenshots**: If possible, attach screenshots

---

## 📊 Issue Severity Guide

Help us prioritize by indicating severity:

### 🔴 Critical (Report Immediately)
- App crashes or won't open
- Can't login/create account
- Major features completely broken
- Data loss

### 🟠 High Priority
- Feature doesn't work as expected
- Confusing navigation
- Very slow performance
- Missing validation on forms

### 🟡 Medium Priority
- UI issues (text overlap, poor spacing)
- Minor bugs
- Inconsistent behavior

### 🟢 Low Priority
- Cosmetic issues
- Typos
- Feature suggestions
- Nice-to-have improvements

---

## ✨ Feature Suggestions

We love your ideas! If you think of a way to improve the app:

1. Use TestFlight feedback
2. Mark it as "Suggestion" (not a bug)
3. Describe your idea clearly
4. Explain why it would be helpful

---

## ⏱️ Testing Timeline

To make the most of beta testing:

- **Day 1**: Install app, complete setup, explore features
- **Days 2-4**: Test all 9 features thoroughly
- **Days 5-7**: Report any issues, retest fixes
- **Ongoing**: Use app normally, report anything unexpected

---

## 🎯 What We're Looking For

Your feedback on:

1. **Functionality**: Does everything work as expected?
2. **Usability**: Is it easy to use and understand?
3. **Performance**: Is it fast and responsive?
4. **Design**: Does it look good and feel polished?
5. **Bugs**: Any crashes, errors, or unexpected behavior?

---

## ❓ Need Help?

If you have questions or need assistance:

- Email: [Your support email]
- TestFlight feedback
- [Any other support channel]

---

## 🙏 Thank You!

Your testing helps us build a better app. We appreciate your time and detailed feedback!

**Remember:**
- Be thorough but honest
- Screenshot anything unusual
- Report both bugs AND things that work well
- Test with real-world scenarios

---

## 📍 Quick Reference

### New Feature Routes
- **Venues**: Home → Venues tab
- **Venue Detail**: Tap any venue
- **Inquiry**: Venue detail → Send Inquiry
- **Compare**: Venues → Compare (or deep link)
- **Event Chat**: Event detail → Chat
- **Polls**: Event detail → Polls
- **Announcements**: Event detail → Announcements
- **Ticket Transfers**: Profile/Menu → Ticket Transfers

### Test Accounts
[Include test account credentials if applicable]

### Test Data
- You'll need at least 3 venues in your area
- Join at least 1 event to test event features
- For real-time features, coordinate with another tester if possible

---

*TestFlight Guide Version: 1.0*
*Build Date: March 16, 2026*
*Features: Venue Discovery, Venue Details, Venue Inquiry, Venue Comparison, Event Chat, Event Polls, Host Announcements, Ticket Transfer, Image Upload*
