# Customer app: what is done and what is left

Written 24 Oct 2026 (Claude). This is the one list for `bottles-up-user`. Keep it current: tick a line when it is done and tested, and add what you find. The older status files in this folder (`PRODUCTION_READY_SUMMARY.md` and friends) describe the OLD app and are wrong about today's state; ignore them.

Rules: the website's `site_*` tables and edge functions are the source of truth (same Supabase project as the website and the vendor app); the app never decides a price, a capacity or a refund, it asks the website. Branch `feat/site-schema`; never push `main`. No build or phone test is made until the user asks.

Bundle IDs: iOS `com.btlup.pop`, Android `com.bottlesup.user`.

## Done (tested against a pretend website; never run on a phone yet)

- [x] Moved to the website's data: events and ticket types (public read), the buyer's own orders (read by verified e-mail), and the website's functions for promo codes, access codes, checkout, payment status, entry codes and account deletion.
- [x] Events tab (search, categories), event page (ticket types, scarcity, share), ticket purchase (quantity, promo code, access code, double-tap safe), payment wait (hosted Stripe Checkout in an in-app browser, polling, never "paid" before the website says so), My tickets, ticket QR (the raw `ticket_code` the door scans), entry-code e-mail for tickets that stay with the buyer.
- [x] Delete account through the website's `delete-account` function.
- [x] Three tabs (Events, My tickets, Profile); 112 old files archived (`_archive/`, Tier 4); 14 unused packages dropped (no location or push permissions left to explain to the stores).
- [x] Android release has the INTERNET permission; iOS bundle ID `com.btlup.pop`.
- [x] **B3 and B4, after purchase, built 25 Oct as "My Night" (never run on a phone):** a table booking's page now has Entry, Reservation, Guests (invite by name and e-mail, each guest gets their own QR by e-mail, send again), Payments (club payments to confirm or report, refunds, the venue's terms, ask for a refund), Orders (bottles with payment and service status, order more through Stripe or at the club, bottle replacements to approve or decline) and Getting there (directions, call), plus share and Book again. Cancelling a booking is staff-only on the website, so a guest asks for a refund instead. Guests are invited by e-mail only (no username or phone lookup exists).
- [x] **Plan items from the client's PDF that fit the existing backend (25 Oct):** Tonight and This weekend filters on Events, "Book a table" on an event page (opens the venue on the event's night), minimum spend and deposit-credit wording and included entry passes before paying, directions and share on the ticket page, a booking opens straight after checkout, BottlesUp spelled consistently, the invented privacy text replaced by the website's page. The whole plan against what exists: `docs/USER_APP_PLAN_STATUS.md` (read it first: production has no social tables at all).
- [x] **B2. My bookings (24 Oct, 356 tests; never run on a phone):** the third tab is now Bookings, with Tickets | Tables. Tables lists the guest's table bookings (coming up, past, cancelled and refunded) and opens a detail page with the QR (the confirmation code), where and when, the line-by-line cost, bottles (marked when left to pay at the club), what is still owed at the club, club payments waiting for the guest's confirmation, and refunds. It reads the customer's own rows through the policies production has (see "Production pull" below).
- [x] **Production pull (24 Oct):** read-only, with the Supabase CLI; `docs/production_snapshot/` has every column of the 16 tables the app reads, the 44 policies on them and the status values in use; `test/site/production_drift_test.dart` compares the app with it. Findings in `docs/production_snapshot/README.md`.
- [x] **B1. VIP table booking (24 Oct, 299 tests; never run on a phone):** Tables tab (venues, search), venue page (details, next bookable nights or any date, arrival times, live availability, floor plan, tables), three-step booking (your table, bottles with the pay-now / pay-at-club choice, review with refund terms and promo code), hosted Stripe page, and the confirmation (code as a QR, what was paid, what is owed at the club) on the shared payment screen. Design and the website rules it copies: `docs/TABLE_BOOKING_PLAN.md`.

## A. Decisions and information needed from the user

- [ ] A1. Confirm the payment approach: Stripe's hosted page opened inside the app, no card entry, no Apple Pay. (Built this way; assumed until told otherwise.)
- [ ] A2. Confirm buying needs sign-in. (Built this way; guest checkout would be a different flow.)
- [ ] A3. Is `com.btlup.pop` free in the Apple Developer account (team `4T453RG45S`)? Should Android match iOS?
- [ ] A4. Which cut features come back (location, the old notifications screen, favourites, loyalty)? All are in `_archive/`.
- [ ] A5. Push notifications in v1? Needs a Firebase account and the Apple push capability.
- [ ] A6. Legal texts (Privacy, Terms) and the real support contact. The current Privacy screen has invented `@bottlesup.com` addresses.
- [ ] A7. Which sign-in methods to offer. Google and Apple sign-in code exists but its buttons are not shown anywhere; if Google is offered, Apple requires Sign in with Apple too.

## B. Features to build (one at a time; discuss each with the user first)

### B1. VIP table booking: DONE 24 Oct (see "Done" above)
Left over from it, none blocking: the hourly table has no upper limit on the website, the app offers up to 12 hours; `min_guests` is only where the guest stepper starts (the website does not enforce it); bottle sign text (`bottle_sign_text`) and the website's table detail page (photos, amenities, view) are not in the app; the floor plan cannot be zoomed (the list below it has every table).

### B2. My bookings: DONE 24 Oct (see "Done" above)
Left over from it: the confirmation of a club payment is only pointed out ("use the link in the email"), not done in the app (that is B3); phone sign-ups see no bookings (below); bottle service status (awaiting prep, ready, served) is not shown.

### B3. After purchase: DONE 25 Oct (see "Done" above)
### B4. Guest tickets: DONE 25 Oct, by e-mail only
### B5. Ticket refund request: there is no website function for it
The website only has a refund request for table bookings (`guest_request_refund`). A ticket buyer has no way to ask in the app until the website gets one.

### B6. Profile and settings
- [ ] Edit profile and avatar still use the old `profiles` and `media` tables: move to the site schema or keep deliberately.
- [x] Settings replaced (27 Oct): the old screen was switches that did nothing (push, analytics, location, dark mode, currency, clear cache) and invented e-mail addresses. The new "Help and settings" shows the account, how notifications work, BottlesUp's real contact details from the CMS (`site_content`; nothing is shown that the team has not set), what the app collects, the privacy policy, and a data-copy request by e-mail. The old file is in `_archive/`.
- [x] Privacy opens the website's page (25 Oct). Terms still shows text nobody at the client wrote: needs A6.

### B8. The client's social plan (new 25 Oct, needs decisions)
`docs/USER_APP_PLAN_STATUS.md`. Production has no social tables, so Home, Create, Inbox, profiles, Members Only, the professional marketplace, venue hire, referrals and creator income are all new backend work plus new screens. Needs the user's decision on whether the first store release is booking-only (the plan's own phase 1) and on the social backend (who owns the tables, media storage, moderation, terms).

### B7. Notifications
- [ ] Push and in-app, if A5 is yes.

## C. Store readiness (27 Oct: everything that can be done without a build or the owner's accounts is done)

iOS
- [x] Privacy manifest `ios/Runner/PrivacyInfo.xcprivacy` (in the Runner target; the project still opens in Xcode), the "data collected" document `docs/DATA_COLLECTED_USER_APP.md`, and the in-app list (Profile > What this app collects). A test keeps the three in step. Apple's own checker has not run on it (it runs on the first upload).
- [x] No entitlements are needed (no Sign in with Apple button, no push, no web links); no usage strings are needed (no location, camera, microphone or contacts; the photo picker on iOS 15 needs none). `ITSAppUsesNonExemptEncryption` is false (HTTPS only), so each upload is not stopped to ask.
- [ ] Signing and provisioning profile for `com.btlup.pop`, and the App ID: the owner's step in the Apple Developer account.

Android
- [x] The build file takes the version from `pubspec.yaml` (it used to say 1.0.0 (1) whatever pubspec said), and a release build without `android/key.properties` now stops with a message instead of silently signing with the debug key; `android/key.properties.example` says what to put in it. Not run through Gradle (nothing is built without being asked).
- [ ] Create the release keystore and `key.properties`, and back the keystore up: the owner's step.

Links
- [x] Fixed (27 Oct): the app only opens from its own scheme `bottlesup://` (password reset and sign-in). The web-address filters (`bottlesupapp.com`, which the website redirects to `www`, and which no website page uses) and the old `bottlesup://payment` filter are gone, so there are no verification files to serve. **The password-reset e-mail used to send people to `bottlesupapp://auth-callback/reset-password`, a scheme neither phone registered, so the link could never open the app.** It now asks for `bottlesup://reset-password`.
- [ ] **For the user:** add `bottlesup://reset-password` to Supabase > Authentication > URL Configuration > Redirect URLs. Without it Supabase ignores the address and sends the e-mail link to the website's address, where nothing handles it. The website has no forgot-password page either (it only changes a password for a signed-in person).
- [ ] Optional later: universal links so website pages for events and venues open the app (needs the entitlement, the website's association files and a handler for each page).

Store listing
- [ ] Answer Apple's App Privacy and Google's Data safety forms from `docs/DATA_COLLECTED_USER_APP.md`; screenshots, descriptions: the owner's step.
- [ ] The profile picture goes to a public bucket (`media`): decide whether to leave it (the in-app text says so) or have the website make it private.
- [ ] Terms of use: the app still shows text nobody at the client wrote (decision A6).
- [x] Version and build numbers come from `pubspec.yaml` (`2.0.1+3` today: change it to what the first release should be called).
- [ ] Crash reporting: none, and the privacy answers say none. Adding it means adding it to the manifest and the forms first.

## D. Quality and clean-up

- [ ] Run on a real phone or the simulator (only when the user asks for a build). Checks: sign in, open an event, buy with a Stripe test card, see the ticket and QR in My tickets, scan it with the vendor door scanner, book a table, delete a test account.
- [x] Analyzer 278 -> 6 (27 Oct). The 6 left are the hidden Google/Apple sign-in buttons (`_handleSocialLogin`, `_SocialLoginButton` in login and sign-up): they go when decision A7 (which sign-in methods) is made. Also removed: log lines that printed a person's e-mail at sign-up, and a dead second password-reset path.
- [x] Read what production holds (24 Oct, `docs/production_snapshot/`). `supabase db pull` itself was not run (it needs Docker, which this machine does not have, and it writes a migration into the website repo).
- [ ] **For the website, not the app:** three customer "read your own rows" policies (table bookings, booking bottles, bottle substitutions) exist only in production, in no file of the website repo; a database rebuilt from the repo shows customers none of their table bookings. `docs/production_snapshot/customer_read_policies.sql` has them for reference. Recommended: a website migration written `drop policy if exists` + `create policy`, which changes nothing in production. Needs the user's yes.
- [ ] **Check the Supabase Auth setting "Confirm email" is ON** (Dashboard > Authentication > Providers > Email). The policies compare e-mail addresses and never look at confirmation; today it is harmless (1 of 84 accounts has an unconfirmed e-mail, matching no booking), but with the switch off anyone could read another person's bookings by signing up with their address.
- [ ] **Phone sign-ups see nothing:** 6 accounts have no e-mail, so no booking or ticket matches them. Decide: ask for an e-mail after a phone sign-in, or look bookings up by phone.
- [ ] Retire the old payment functions (`create-checkout-session`, `create-payment-intent`), still deployed and callable.
- [ ] Optional website change: make `site-create-checkout-session` (and the table checkout) also return `session_id` and `order_id`. Needs a deploy.
- [ ] Test both account-deletion paths with a test account.
- [ ] Merge `feat/site-schema`; move the submodule pointer in the monorepo.

## E. Not in the first store release unless the user says otherwise

Location and maps, loyalty, ticket transfer and resale, venue comparison, and everything in the client's plan that needs a backend that does not exist (feed, stories, reels, Members Only, customer inbox, professional bookings, venue hire, referrals, subscriptions, creator income, rankings, jobs): see `docs/USER_APP_PLAN_STATUS.md`. The old app's messaging, loyalty and social code is in `_archive/` (Tier 1 and 2); it reads the old tables, which hold none of the website's data, so it is a reference, not a head start.
