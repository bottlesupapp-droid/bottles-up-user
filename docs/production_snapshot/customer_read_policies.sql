-- REFERENCE ONLY, NOT A MIGRATION. Do not run this. It is what production holds today for the customer's own rows, read from pg_policies on 24 Oct 2026
-- (see README.md). Three of these six exist in no file of the website repository: "users read own table bookings", "users read own booking bottles" and
-- "users read own bottle substitutions". A database rebuilt from the repository would therefore not let a customer see their own table bookings.
-- If these are added to the website as a migration, write them as drop policy if exists + create policy so that applying it to production changes nothing.

-- site_orders
create policy "users read own orders by verified email" on public.site_orders
  for select using (((auth.role() = 'authenticated'::text) AND (lower(customer_email) = lower(auth.email()))));

-- site_table_booking_bottle_substitutions
create policy "users read own bottle substitutions by verified email" on public.site_table_booking_bottle_substitutions
  for select using (((auth.role() = 'authenticated'::text) AND (EXISTS ( SELECT 1 FROM site_table_bookings b WHERE ((b.id = site_table_booking_bottle_substitutions.booking_id) AND (lower(b.customer_email) = lower(auth.email())))))));

-- site_table_booking_bottles
create policy "users read own booking bottles by verified email" on public.site_table_booking_bottles
  for select using (((auth.role() = 'authenticated'::text) AND (EXISTS ( SELECT 1 FROM site_table_bookings b WHERE ((b.id = site_table_booking_bottles.booking_id) AND (lower(b.customer_email) = lower(auth.email())))))));

-- site_table_booking_club_payments
create policy "users read own club payments by verified email" on public.site_table_booking_club_payments
  for select using (((auth.role() = 'authenticated'::text) AND (EXISTS ( SELECT 1 FROM site_table_bookings b WHERE ((b.id = site_table_booking_club_payments.booking_id) AND (lower(b.customer_email) = lower(auth.email())))))));

-- site_table_booking_refunds
create policy "users read own refunds by verified email" on public.site_table_booking_refunds
  for select using (((auth.role() = 'authenticated'::text) AND (EXISTS ( SELECT 1 FROM site_table_bookings b WHERE ((b.id = site_table_booking_refunds.booking_id) AND (lower(b.customer_email) = lower(auth.email())))))));

-- site_table_bookings
create policy "users read own table bookings by verified email" on public.site_table_bookings
  for select using (((auth.role() = 'authenticated'::text) AND (lower(customer_email) = lower(auth.email()))));
