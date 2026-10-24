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

### B3. After purchase
- [ ] Add bottles to a booking (`add-table-booking-bottles`) and order by code (`order-bottles-by-code`).
- [ ] Approve or decline a bottle substitution (`respond-bottle-substitution`, `confirm-bottle-addon`).
- [ ] Cancel a booking (`cancel-table-booking`).
- [ ] Request a refund (`guest_request_refund`).

### B4. Guest tickets
- [ ] Send and manage tickets for the people in a booking (`manage-guest-tickets`).

### B5. Ticket refund request
- [ ] A way for buyers to ask for a refund on event tickets.

### B6. Profile and settings
- [ ] Edit profile and avatar still use the old `profiles` and `media` tables: move to the site schema or keep deliberately.
- [ ] Review the Settings screen for legacy leftovers.
- [ ] Replace the hard-coded Privacy and Terms screens with the website's pages.

### B7. Notifications
- [ ] Push and in-app, if A5 is yes.

## C. Store readiness

iOS
- [ ] `PrivacyInfo.xcprivacy` (privacy manifest) and a "data collected" document, as for the vendor app.
- [ ] Entitlements file, only for capabilities actually used (Sign in with Apple, push, associated domains).
- [ ] Signing and provisioning profile for `com.btlup.pop`.
- [ ] Check `Info.plist` needs no usage strings now that location is gone.

Android
- [ ] `key.properties` and a release keystore (the build file reads them; none seen).
- [ ] Check the release build configuration.

Links
- [ ] The app-link filters use `bottlesupapp.com` but the website is `www.bottlesupapp.com`.
- [ ] Both platforms need the website's verification files (`assetlinks.json`, Apple association file).
- [ ] Remove the leftover `bottlesup://payment` filter.

Store listing
- [ ] Privacy text, data-safety answers, screenshots, descriptions.
- [ ] Crash reporting key, if wanted.
- [ ] Version and build numbers.

## D. Quality and clean-up

- [ ] Run on a real phone or the simulator (only when the user asks for a build). Checks: sign in, open an event, buy with a Stripe test card, see the ticket and QR in My tickets, scan it with the vendor door scanner, book a table, delete a test account.
- [ ] Clear the 36 analyzer warnings left in the old login and theme code.
- [x] Read what production holds (24 Oct, `docs/production_snapshot/`). `supabase db pull` itself was not run (it needs Docker, which this machine does not have, and it writes a migration into the website repo).
- [ ] **For the website, not the app:** three customer "read your own rows" policies (table bookings, booking bottles, bottle substitutions) exist only in production, in no file of the website repo; a database rebuilt from the repo shows customers none of their table bookings. `docs/production_snapshot/customer_read_policies.sql` has them for reference. Recommended: a website migration written `drop policy if exists` + `create policy`, which changes nothing in production. Needs the user's yes.
- [ ] **Check the Supabase Auth setting "Confirm email" is ON** (Dashboard > Authentication > Providers > Email). The policies compare e-mail addresses and never look at confirmation; today it is harmless (1 of 84 accounts has an unconfirmed e-mail, matching no booking), but with the switch off anyone could read another person's bookings by signing up with their address.
- [ ] **Phone sign-ups see nothing:** 6 accounts have no e-mail, so no booking or ticket matches them. Decide: ask for an e-mail after a phone sign-in, or look bookings up by phone.
- [ ] Retire the old payment functions (`create-checkout-session`, `create-payment-intent`), still deployed and callable.
- [ ] Optional website change: make `site-create-checkout-session` (and the table checkout) also return `session_id` and `order_id`. Needs a deploy.
- [ ] Test both account-deletion paths with a test account.
- [ ] Merge `feat/site-schema`; move the submodule pointer in the monorepo.

## E. Not planned for v1

Location and maps, loyalty, messaging, ticket transfer and resale, venue comparison, and anything waiting on the client's open decisions (ambassadors and Event Leads, ticket discounts as a product, SMS).
