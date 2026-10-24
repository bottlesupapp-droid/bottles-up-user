import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/models/ticket_order.dart';
import 'package:bottles_up_user/site/rules/ticket_rules.dart';
import 'package:bottles_up_user/site/services/my_tickets_service.dart';
import 'package:bottles_up_user/site/services/site_events_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

// The website's database and edge functions decide every name, limit and sentence here; the app must not drift from them. These read the website's SQL and TypeScript when it is
// checked out beside this app (the monorepo) and are skipped otherwise.
void main() {
  group('agrees with the website', skip: websiteIsHere ? false : websiteMissing, () {
    /// The columns named inside a PostgREST `select=` string for one table, leaving out embedded resources.
    List<String> selected(String select) {
      // Drop embedded resources ("alias:table(columns)") and keep the plain column names.
      final plain = select.replaceAll(RegExp(r'[A-Za-z_]+(?::[A-Za-z_]+)?\([^)]*\)'), '');
      return [for (final part in plain.split(',')) part.trim()].where((p) => p.isNotEmpty).toList();
    }

    String embedded(String select, String name) {
      final m = RegExp('(?:\\w+:)?$name\\(([^)]*)\\)').firstMatch(select);
      return m == null ? '' : m.group(1)!;
    }

    test('every column the app reads from the events, ticket types and orders exists in the website\'s tables', () async {
      final site = FakeWebsite();
      site.tables['site_events'] = [];
      site.tables['site_orders'] = [];
      await SiteEventsService(site.client).upcoming();
      await MyTicketsService(site.client).orders();
      final eventSelect = site.forTable('site_events').single.query['select']!;
      final orderSelect = site.forTable('site_orders').single.query['select']!;

      final eventCols = columnsOf('site_events');
      expect(eventCols, containsAll(['id', 'title', 'start_date', 'status']), reason: 'the column reader found the table');
      for (final c in selected(eventSelect)) {
        expect(eventCols, contains(c), reason: 'site_events.$c');
      }
      final tierCols = columnsOf('site_ticket_tiers');
      for (final c in embedded(eventSelect, 'site_ticket_tiers').split(',').map((x) => x.trim())) {
        expect(tierCols, contains(c), reason: 'site_ticket_tiers.$c');
      }
      // Columns that exist in production but in no migration of the repository (the promo codes feature was made by hand): the website's own checkout writes `discount_cents`, so it is there.
      const productionOnly = {'discount_cents'};
      final orderCols = columnsOf('site_orders');
      for (final c in selected(orderSelect)) {
        if (productionOnly.contains(c)) continue;
        expect(orderCols, contains(c), reason: 'site_orders.$c');
      }
      expect(readFunction('site-create-checkout-session'), contains('discount_cents'), reason: 'the production-only column is one the website\'s own function writes');
      for (final c in embedded(orderSelect, 'site_events').split(',').map((x) => x.trim())) {
        expect(eventCols, contains(c), reason: 'site_events.$c (in an order)');
      }
      for (final c in embedded(orderSelect, 'site_ticket_tiers').split(',').map((x) => x.trim())) {
        expect(tierCols, contains(c), reason: 'site_ticket_tiers.$c (in an order)');
      }
    });

    test('the order columns the app asks for when it looks up one payment exist too', () {
      final orderCols = columnsOf('site_orders');
      for (final c in ['event_id', 'tier_id', 'created_at', 'status']) {
        expect(orderCols, contains(c), reason: c);
      }
    });

    test('the order statuses are the website\'s', () {
      final sql = allMigrations().replaceAll(RegExp(r'--[^\n]*'), '');
      final block = RegExp(r'create\s+table\s+public\.site_orders\s*\(([\s\S]*?)\n\);', caseSensitive: false).firstMatch(sql)!.group(1)!;
      final m = RegExp(r"status\s+text[^\n]*check\s*\(\s*status\s+in\s*\(([^)]*)\)\s*\)").firstMatch(block);
      expect(m, isNotNull);
      final values = RegExp(r"'([a-z_]+)'").allMatches(m!.group(1)!).map((x) => x.group(1)!).toSet();
      expect(values, {for (final s in OrderStatus.values) s.db});
    });

    test('a visitor can read published events and their ticket types, and a signed-in person only their own orders, by e-mail', () {
      final sql = allMigrations();
      expect(sql, contains('create policy "public read published events" on public.site_events'));
      expect(sql, contains('create policy "public read tiers for published events" on public.site_ticket_tiers'));
      expect(sql, contains('create policy "users read own orders by verified email" on public.site_orders'));
      expect(sql, contains('lower(customer_email) = lower(auth.email())'));
    });

    test('the checkout function takes the fields the app sends, and refuses more than one order allows', () {
      final ts = readFunction('site-create-checkout-session');
      for (final field in ['event_id', 'tier_id', 'quantity', 'customer_name', 'customer_email', 'customer_phone', 'promo_code', 'access_code']) {
        expect(ts, contains(field), reason: field);
      }
      expect(ts, contains('qty > $maxTicketsPerOrder'));
      expect(ts, contains('qty < 1'));
      expect(ts, contains('return json({ url: session.url })'));
      expect(ts, contains('This event is not currently on sale'));
      expect(ts, contains('Not enough tickets left in this tier'));
    });

    test('the preview functions take what the app sends', () {
      final promo = readFunction('validate-promo-code');
      for (final f in ['code', 'applies_to', 'venue_id', 'subtotal_cents']) {
        expect(promo, contains(f), reason: f);
      }
      expect(promo, contains("applies_to !== 'tickets' && applies_to !== 'tables'"));
      final access = readFunction('validate-tier-access-code');
      expect(access, contains('const { tier_id, code } = await req.json()'));
    });

    test('the status function takes a session id and answers with the fields the app reads', () {
      final ts = readFunction('site-booking-status');
      expect(ts, contains('const { session_id } = await req.json()'));
      for (final f in ['ticketCode', 'customerEmail', 'quantity', 'discountCents', 'tierName', 'eventTitle', 'venueName', 'startDate']) {
        expect(ts, contains(f), reason: f);
      }
      expect(ts, contains("status: 'paid'"));
      expect(ts, contains("status: 'not_found'"));
    });

    test('the entry code function is for the signed-in owner of the order and answers what the app reads', () {
      final ts = readFunction('request-ticket-otp');
      expect(ts, contains('const { order_id } = await req.json()'));
      expect(ts, contains('success: true'));
      expect(ts, contains('email_preview'));
      expect(ts, contains('expires_in_seconds'));
      expect(ts, contains("req.headers.get('Authorization')"));
    });

    test('the website\'s own rules for names are not stricter than the app\'s', () {
      // The website only requires a name and an e-mail; the app asks for a little more, which can only make an order less likely to be refused.
      final ts = readFunction('site-create-checkout-session');
      expect(ts, contains('!customer_name || !customer_email'));
      expect(nameMin, greaterThanOrEqualTo(1));
    });

    test('what the app tells the website about a payment is the form the website\'s checkout page returns for it', () {
      final ts = readFunction('site-create-checkout-session');
      expect(ts, contains('success_url'));
      expect(sessionIdFromCheckoutUrl('https://checkout.stripe.com/c/pay/cs_test_a1B2c3d4#fidkdWxOYHwnPyd1blpxYHZxWjA0'), 'cs_test_a1B2c3d4');
    });
  });
}
