# VIP table booking in the customer app: design (24 Oct 2026) and status: BUILT, tested, not run on a phone

Read from the website (`apps/bottles-up-website-main`) so the app does exactly what the website does. If the website changes, `test/site/site_drift_test.dart` is meant to fail first.

## What the website does

**Reads (public, no sign-in; RLS shows only published venues):** `site_venues`, `site_table_types`, `site_venue_time_slots`, `site_venue_floors`, `site_bottles` (only `is_available` and not `is_sold_out`), `site_content.bottlesup_fee_bps`. Same select the website uses: `site_venues` with `site_table_types(*)` and `site_venue_time_slots(*)`.

**RPCs a visitor may call:** `get_unavailable_table_types(p_venue_id, p_booking_date, p_time_slot_id)` returns the ids of table types that are full for that night and slot (paid bookings, checkouts started in the last 10 minutes = the hold, and manager blocks); `public_venue_refund_policy(p_venue)` returns one row `{has_policy, lines[]}` of plain sentences.

**Checkout:** `create-table-booking-checkout` with `{venue_id, table_type_id, time_slot_id, booking_date, guest_count, hours?, customer_name, customer_email, customer_phone?, bottles: [{bottle_id, quantity}], promo_code?, bottle_payment_choice}` answers `{url}` (Stripe's hosted page) or `{error}` with a sentence. It re-reads every price, the slot, the window, capacity and stock; the client decides nothing. The booking exists as `pending` and holds the table for 10 minutes. `validate-promo-code` takes `applies_to: 'tables'`.

**After paying:** `site-booking-status {session_id}` answers `{status:'paid', booking:{confirmationCode, customerName, customerEmail, guestCount, tableTypeName, venueName, bookingDate, startTime, depositCents, bottleSubtotalCents, taxCents, bottlesupFeeCents, discountCents, totalCents, paidNowCents, dueAtVenueCents, currency, bottles[]}}`, or `{status: <pending|...>}`, or `{status:'not_found'}`. It asks Stripe itself if the webhook has not fired. The website shows the `confirmationCode` as the QR (the door scans that text).

## Rules (copied from the website's code, with the test that pins each)

- **Night versus arrival date.** The guest picks a "night" (a calendar day) and a time slot. A slot that starts before `06:00:00` is the tail of the previous night, so the stored arrival date is the next day. The app sends the night as `booking_date`; the website stores the arrival date. The RPC takes the night.
- **Day of week.** `time_slot.day_of_week` is 0 = Sunday ... 6 = Saturday (JavaScript's `getDay()`); Dart's `weekday` is 1 = Monday ... 7 = Sunday, so use `weekday % 7`. A date can be picked only if some slot exists for its weekday, it is not in the past, and it is inside the venue's `booking_start_date` / `booking_end_date` when set.
- **Price.** Flat tables charge `deposit_cents`; hourly tables charge `hourly_rate_cents * hours` (at least `min_hours`, a whole number). Bottles: sum of price x quantity. Bottle payment: the venue's `bottle_payment_mode` is `pay_ahead`, `pay_at_club` or `both`; the guest chooses only when it is `both`. `pay_at_club` charges only the table amount now; the bottles are settled at the club (less the deposit when `deposit_is_credit`). Then: promo discount off what is charged now, `tax = round(afterDiscount * tax_rate_bps / 10000)`, `fee = round(afterDiscount * bottlesup_fee_bps / 10000)`, total due today = afterDiscount + tax + fee. The app only previews this; the website recomputes.
- **Guests:** 1 to `max_guests` (the website does not enforce `min_guests`; neither does the app).
- **Floor plan:** a table type with `floor_id` and `pos_x` has a hotspot at `pos_x/pos_y/width/height` percent of the floor image. Tables without a position are listed.
- **Refund terms** are shown before paying (`public_venue_refund_policy`); nothing is shown if they cannot be read.

## App design

Files: `lib/site/models/venue.dart`, `lib/site/models/table_booking.dart`, `lib/site/rules/table_rules.dart`, `lib/site/services/venues_service.dart`, `lib/site/services/table_checkout_service.dart`; screens in `lib/features/tables/`.

Tabs become **Events | Tables | My tickets | Profile** (indexes in `nav_index_provider.dart`).
- **Tables tab** (`/home`, tab 1): published venues that have table types (cover, name, address, "From $X", how many tables), search.
- **Venue page** (`/venues/:id`): details, a date picker limited to bookable days, the slots for that day, the live availability for the chosen night and slot, the floor plan when the venue has one, and the tables (booked ones greyed with "Booked for this date").
- **Booking** (`/venues/:id/tables/:tableId/book?date=YYYY-MM-DD&slot=<id>`): three steps in one screen: your table (guests, hours, name, phone), bottles (optional, with the pay-now / pay-at-club choice only when the venue allows both), review and pay (refund terms, promo code, breakdown, due at the club). Pay opens Stripe's page in the app and goes to the payment screen.
- **Payment screen** is shared with tickets: it polls `site-booking-status`, and for a table shows the confirmation code as a QR, the arrival and what is due at the club.
- Sign-in is required (the booking carries the account's e-mail, which is how the buyer later sees it).

## Out of scope for this step

My bookings list and detail (B2), adding bottles afterwards, guest tickets, cancel and refund request (B3, B4). The confirmation is shown right after payment and e-mailed by the website.

## Known risks

- The customer read policies on `site_table_bookings` and friends are production-only, so B2 needs `supabase db pull` first. B1 does not read them.
- `site-create-checkout-session` style: the table checkout answers only `{url}`; the session id is read out of the Stripe address, as for tickets.
- A table is held for 10 minutes only after checkout starts; a person who leaves the Stripe page open longer loses it, and the website then refuses or the payment lands on a booking that is no longer held. The website decides; the app shows what the website says.

## Built (24 Oct)

`lib/site/models/venue.dart`, `lib/site/rules/table_rules.dart`, `lib/site/services/venues_service.dart` and `table_checkout_service.dart`, `lib/features/tables/` (Tables tab, venue page, floor plan, venue card, booking), the table half of `lib/features/tickets_site/screens/payment_screen.dart`, and `PaidBooking` in `lib/site/models/checkout.dart`. Tabs are Events | Tables | My tickets | Profile (`MainTab`). Tests: `test/site/table_*_test.dart` (models, rules, services, and drift tests that read the website's SQL and functions), `test/screens/{tables,venue,floor_plan,table_booking}_screen_test.dart`, the table cases in `payment_screen_test.dart` and `routes_test.dart`.

Decisions made while building (change them if the user wants something else):
- The time list of a night is in the order the night goes: evening times first, after-midnight ones last (the database order would put 1:00 AM first). The first one is chosen for the guest, as the website does.
- The venue page offers the next five nights as chips plus the phone's calendar (limited to days the venue takes bookings), because a calendar alone is slow on a phone.
- All tables are listed below the floor plan (the website lists only the ones without a spot); a finger cannot reliably hit a small spot.
- When availability cannot be read the page says so with a retry and does not block booking: the website checks again at payment and refuses a table that is gone.
- Going back from the review step drops an applied promo code, because the discount depends on the total.
