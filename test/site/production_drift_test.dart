import 'dart:convert';
import 'dart:io';

import 'package:bottles_up_user/site/models/table_booking.dart';
import 'package:bottles_up_user/site/services/my_bookings_service.dart';
import 'package:bottles_up_user/site/services/my_tickets_service.dart';
import 'package:bottles_up_user/site/services/site_events_service.dart';
import 'package:bottles_up_user/site/services/venues_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

// What production really holds, read on 24 Oct 2026 (docs/production_snapshot/README.md). The website's repository does not have all of it (three of the customer's "read your own rows"
// policies and some columns exist only in production), so these tests compare the app with the snapshot rather than with the repository. The snapshot does not notice a later change in
// production: read it again after the website's next migration.
void main() {
  final snap = jsonDecode(File('docs/production_snapshot/production_snapshot.json').readAsStringSync()) as Map<String, dynamic>;
  final columns = {
    for (final e in (snap['columns'] as Map<String, dynamic>).entries) e.key: {for (final c in e.value as List) (c as Map)['name'] as String},
  };
  final policies = [for (final p in snap['policies'] as List) Map<String, dynamic>.from(p as Map)];

  /// The plain column names in a PostgREST `select` (embedded resources left out), spaces ignored.
  Set<String> plain(String select) => {
        for (final c in select.replaceAll(RegExp(r'[A-Za-z_]+(?::[A-Za-z_]+)?\([^)]*\)'), '').split(','))
          if (c.trim().isNotEmpty) c.trim(),
      };

  Set<String> inside(String select, String resource) {
    final m = RegExp('(?:\\w+:)?$resource\\(([^)]*)\\)').firstMatch(select);
    return m == null ? {} : {for (final c in m.group(1)!.split(',')) c.trim()};
  }

  void expectColumns(String table, Set<String> read, {String? where}) {
    expect(columns, contains(table), reason: 'the snapshot has $table');
    for (final c in read) {
      expect(columns[table], contains(c), reason: '$table.$c${where == null ? '' : ' ($where)'} is read by the app but is not in production');
    }
  }

  test('the snapshot is the kind of file this test expects', () {
    expect(snap['pulled_at'], isNotNull);
    expect(columns.keys, containsAll(['site_table_bookings', 'site_table_booking_bottles', 'site_orders', 'site_venues', 'site_table_types']));
    expect(policies, isNotEmpty);
  });

  test('every column the app reads exists in production, in every table it reads', () async {
    final site = FakeWebsite();
    for (final t in ['site_events', 'site_orders', 'site_venues', 'site_venue_floors', 'site_bottles', 'site_table_bookings', 'site_table_booking_bottles', 'site_table_booking_club_payments', 'site_table_booking_refunds', 'site_table_booking_bottle_substitutions']) {
      site.tables[t] = [];
    }
    site.tables['site_content'] = [];
    site.tables['site_table_bookings'] = [bookingRow()];
    await SiteEventsService(site.client).upcoming();
    await MyTicketsService(site.client).orders();
    final venues = VenuesService(site.client);
    await venues.venues();
    await venues.floors('v1');
    await venues.bottles('v1');
    await venues.feeBasisPoints();
    final bookings = MyBookingsService(site.client);
    await bookings.bookings();
    await bookings.booking('bk1');

    final events = site.forTable('site_events').single.query['select']!;
    expectColumns('site_events', plain(events));
    expectColumns('site_ticket_tiers', inside(events, 'site_ticket_tiers'));

    final orders = site.forTable('site_orders').single.query['select']!;
    expectColumns('site_orders', plain(orders));
    expectColumns('site_events', inside(orders, 'site_events'), where: 'inside an order');
    expectColumns('site_ticket_tiers', inside(orders, 'site_ticket_tiers'), where: 'inside an order');

    final venueSelect = site.forTable('site_venues').single.query['select']!;
    expectColumns('site_venues', plain(venueSelect));
    expectColumns('site_table_types', inside(venueSelect, 'site_table_types'));
    expectColumns('site_venue_time_slots', inside(venueSelect, 'site_venue_time_slots'));
    expectColumns('site_venue_floors', plain(site.forTable('site_venue_floors').single.query['select']!));
    expectColumns('site_bottles', plain(site.forTable('site_bottles').single.query['select']!));
    expectColumns('site_content', plain(site.forTable('site_content').single.query['select']!));

    final bookingSelects = {for (final r in site.forTable('site_table_bookings')) r.query['select']!};
    expect(bookingSelects.length, 1, reason: 'the list and the detail read the same columns');
    final bookingSelect = bookingSelects.single;
    expectColumns('site_table_bookings', plain(bookingSelect));
    expectColumns('site_table_types', inside(bookingSelect, 'site_table_types'), where: 'inside a booking');
    expectColumns('site_venues', inside(bookingSelect, 'site_venues'), where: 'inside a booking');
    expectColumns('site_venue_time_slots', inside(bookingSelect, 'site_venue_time_slots'), where: 'inside a booking');
    expectColumns('site_table_booking_bottles', plain(site.forTable('site_table_booking_bottles').single.query['select']!));
    expectColumns('site_table_booking_club_payments', plain(site.forTable('site_table_booking_club_payments').single.query['select']!));
    expectColumns('site_table_booking_refunds', plain(site.forTable('site_table_booking_refunds').single.query['select']!));
    expectColumns('site_table_booking_bottle_substitutions', plain(site.forTable('site_table_booking_bottle_substitutions').single.query['select']!));
  });

  test('the columns the app filters and sorts on exist too', () {
    expectColumns('site_table_bookings', {'status', 'created_at', 'id'});
    expectColumns('site_table_booking_bottles', {'booking_id', 'payment_status', 'created_at'});
    expectColumns('site_table_booking_club_payments', {'booking_id', 'customer_confirmation_status'});
    expectColumns('site_table_booking_refunds', {'booking_id', 'recorded_at'});
    expectColumns('site_table_booking_bottle_substitutions', {'booking_id', 'status', 'requested_at'});
    expectColumns('site_venues', {'status'});
    expectColumns('site_bottles', {'venue_id', 'is_available', 'is_sold_out', 'sort_order'});
    expectColumns('site_venue_floors', {'venue_id', 'sort_order'});
    expectColumns('site_orders', {'status', 'event_id', 'tier_id', 'created_at'});
  });

  group('the customer reads their own rows through policies production has', () {
    Map<String, dynamic>? policy(String table, String name) {
      for (final p in policies) {
        if (p['table'] == table && p['name'] == name) return p;
      }
      return null;
    }

    test('orders and table bookings: signed in, and the e-mail on the row is the e-mail on the sign-in', () {
      for (final (table, name) in [('site_orders', 'users read own orders by verified email'), ('site_table_bookings', 'users read own table bookings by verified email')]) {
        final p = policy(table, name);
        expect(p, isNotNull, reason: '$table: $name');
        expect(p!['cmd'], 'SELECT');
        expect(p['using'], allOf(contains("auth.role() = 'authenticated'"), contains('lower(customer_email) = lower(auth.email())')));
      }
    });

    test('the bottle lines, club payments and refunds of a booking are readable through the booking\'s e-mail', () {
      for (final (table, name) in [
        ('site_table_booking_bottles', 'users read own booking bottles by verified email'),
        ('site_table_booking_club_payments', 'users read own club payments by verified email'),
        ('site_table_booking_refunds', 'users read own refunds by verified email'),
        ('site_table_booking_bottle_substitutions', 'users read own bottle substitutions by verified email'),
      ]) {
        final p = policy(table, name);
        expect(p, isNotNull, reason: '$table: $name');
        expect(p!['cmd'], 'SELECT');
        expect(p['using'], allOf(contains("auth.role() = 'authenticated'"), contains('FROM site_table_bookings b'), contains('lower(b.customer_email) = lower(auth.email())')), reason: table);
      }
    });

    test('a customer has no policy that lets them change any of these rows', () {
      for (final p in policies) {
        if (!(p['table'] as String).startsWith('site_table_booking') && p['table'] != 'site_orders') continue;
        if (p['cmd'] == 'SELECT') continue;
        expect(p['using'] as String, contains('is_cms_admin()'), reason: '${p['table']}: ${p['name']} must be for CMS admins only');
      }
    });

    test('everyone can read what is published: venues, tables, times, floors, bottles, events, ticket types and the site settings', () {
      for (final (table, name) in [
        ('site_venues', 'public read published venues'),
        ('site_table_types', 'public read table types for published venues'),
        ('site_venue_time_slots', 'public read time slots for published venues'),
        ('site_venue_floors', 'public read floors for published venues'),
        ('site_bottles', 'public read available bottles for published venues'),
        ('site_events', 'public read published events'),
        ('site_ticket_tiers', 'public read tiers for published events'),
        ('site_content', 'public read site content'),
      ]) {
        expect(policy(table, name), isNotNull, reason: '$table: $name');
      }
    });
  });

  test('the app knows every status production has in use', () {
    final values = snap['status_values'] as Map<String, dynamic>;
    for (final s in values['site_table_bookings.status'] as List) {
      expect(BookingStatus.fromDb(s), isNotNull, reason: 'booking status $s');
    }
    for (final s in values['site_table_booking_bottles.payment_status'] as List) {
      expect(['paid', 'due_at_venue'], contains(s), reason: 'bottle payment status $s');
    }
  });
}
