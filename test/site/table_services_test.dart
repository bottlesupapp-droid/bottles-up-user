import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/rules/table_rules.dart';
import 'package:bottles_up_user/site/services/table_checkout_service.dart';
import 'package:bottles_up_user/site/services/ticket_checkout_service.dart';
import 'package:bottles_up_user/site/services/venues_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  group('venues', () {
    test('asks for published venues by name, each with its tables and booking times in one request', () async {
      site.tables['site_venues'] = [venueRow()];
      final venues = await VenuesService(site.client).venues();
      final r = site.forTable('site_venues').single;
      expect(r.method, 'GET');
      expect(r.query['status'], 'eq.published');
      expect(r.query['order'], startsWith('name.asc'));
      expect(r.query['select'], allOf(contains('site_table_types('), contains('site_venue_time_slots('), contains('bottle_payment_mode'), contains('deposit_is_credit'), contains('booking_start_date')));
      expect(venues.single.name, 'Club A');
      expect(venues.single.tables.single.name, 'Booth 1');
      expect(venues.single.slots.single.startTime, '22:00:00');
    });

    test('a venue with no tables is not listed, and a venue that cannot be read does not break the rest', () async {
      site.tables['site_venues'] = [venueRow(id: 'empty', tables: const []), {...venueRow(id: 'bad'), 'name': null}, venueRow(id: 'ok')];
      expect((await VenuesService(site.client).venues()).map((v) => v.id), ['ok']);
    });

    test('a failure is a plain sentence', () async {
      site.failAllWith = 500;
      await expectLater(VenuesService(site.client).venues(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load venues. Check your connection and try again.')));
    });

    test('one venue is asked for by id and only if published; none is null', () async {
      site.tables['site_venues'] = [venueRow(id: 'v9')];
      final v = await VenuesService(site.client).venue('v9');
      final r = site.forTable('site_venues').single;
      expect([r.query['id'], r.query['status']], ['eq.v9', 'eq.published']);
      expect(v?.id, 'v9');
      site.tables['site_venues'] = [];
      expect(await VenuesService(site.client).venue('v9'), isNull);
    });
  });

  group('floors and bottles', () {
    test('floors are asked for by venue, in the venue\'s order', () async {
      site.tables['site_venue_floors'] = [floorRow(id: 'f1'), floorRow(id: 'f2', label: 'Roof', sort: 1), {...floorRow(id: 'bad'), 'image_url': null}];
      final floors = await VenuesService(site.client).floors('v1');
      final r = site.forTable('site_venue_floors').single;
      expect([r.query['venue_id'], r.query['order']], ['eq.v1', startsWith('sort_order.asc')]);
      expect(floors.map((f) => f.label), ['Main floor', 'Roof']);
    });

    test('bottles are asked for by venue, only the ones on the menu and in stock', () async {
      site.tables['site_bottles'] = [bottleRow(), bottleRow(id: 'b2', name: 'Don Julio', size: null, price: 40000)];
      final bottles = await VenuesService(site.client).bottles('v1');
      final r = site.forTable('site_bottles').single;
      expect([r.query['venue_id'], r.query['is_available'], r.query['is_sold_out'], r.query['order']], ['eq.v1', 'eq.true', 'eq.false', startsWith('sort_order.asc')]);
      expect(bottles.map((b) => b.displayName), ['Grey Goose (1.75L)', 'Don Julio']);
    });

    test('a failure is a plain sentence', () async {
      site.failAllWith = 500;
      await expectLater(VenuesService(site.client).floors('v1'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load the floor plan. Check your connection and try again.')));
      await expectLater(VenuesService(site.client).bottles('v1'), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load the bottle menu. Check your connection and try again.')));
    });
  });

  group('availability', () {
    test('asks the website which tables are full for the venue, the night and the time, and returns their ids', () async {
      site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: ['tt1', 'tt3']);
      final taken = await VenuesService(site.client).unavailableTables(venueId: 'v1', night: '2026-10-30', slotId: 's1');
      expect(site.forRpc('get_unavailable_table_types').single.body, {'p_venue_id': 'v1', 'p_booking_date': '2026-10-30', 'p_time_slot_id': 's1'});
      expect(taken, {'tt1', 'tt3'});
    });

    test('nothing taken is an empty set', () async {
      site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: <String>[]);
      expect(await VenuesService(site.client).unavailableTables(venueId: 'v1', night: '2026-10-30', slotId: 's1'), isEmpty);
    });

    test('when it cannot be read the app does not guess: it says so', () async {
      site.rpcs['get_unavailable_table_types'] = (b) => (status: 500, body: {'message': 'boom'});
      await expectLater(
        VenuesService(site.client).unavailableTables(venueId: 'v1', night: '2026-10-30', slotId: 's1'),
        throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not check which tables are free. Check your connection and try again.')),
      );
      site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: {'not': 'a list'});
      await expectLater(VenuesService(site.client).unavailableTables(venueId: 'v1', night: '2026-10-30', slotId: 's1'), throwsA(isA<SiteException>()));
    });
  });

  group('refund terms and fee', () {
    test('the venue\'s refund policy is read as sentences', () async {
      site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: [{'has_policy': true, 'lines': ['Full refund up to 48 hours before.', ' ', 'No refund after check-in.']}]);
      final p = await VenuesService(site.client).refundPolicy('v1');
      expect(site.forRpc('public_venue_refund_policy').single.body, {'p_venue': 'v1'});
      expect(p!.hasPolicy, isTrue);
      expect(p.lines, ['Full refund up to 48 hours before.', 'No refund after check-in.']);
    });

    test('nothing to show when the venue says nothing, answers oddly or cannot be reached (as on the website)', () async {
      site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: <Object>[]);
      expect(await VenuesService(site.client).refundPolicy('v1'), isNull);
      site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: [{'has_policy': false, 'lines': <String>[]}]);
      expect(await VenuesService(site.client).refundPolicy('v1'), isNull);
      site.rpcs['public_venue_refund_policy'] = (b) => (status: 500, body: {'message': 'boom'});
      expect(await VenuesService(site.client).refundPolicy('v1'), isNull);
    });

    test('the BottlesUp fee is read from the site settings; null when it cannot be', () async {
      site.tables['site_content'] = [
        {'bottlesup_fee_bps': 250}
      ];
      expect(await VenuesService(site.client).feeBasisPoints(), 250);
      final r = site.forTable('site_content').single;
      expect([r.query['select'], r.query['id']], ['bottlesup_fee_bps', 'eq.1']);
      site.tables['site_content'] = [];
      expect(await VenuesService(site.client).feeBasisPoints(), isNull);
      site.failAllWith = 500;
      expect(await VenuesService(site.client).feeBasisPoints(), isNull);
    });
  });

  group('booking a table', () {
    const url = 'https://checkout.stripe.com/c/pay/cs_test_t1B2c3#frag';

    Future<dynamic> start({Map<String, int> bottles = const {}, int? hours, String? phone, String? promo, BottlePaymentChoice choice = BottlePaymentChoice.payAhead}) => TableCheckoutService(site.client).start(
          venueId: 'v1',
          tableId: 'tt1',
          slotId: 's1',
          night: '2026-10-30',
          guests: 4,
          hours: hours,
          name: ' Dana Lee ',
          email: 'dana@example.com',
          phone: phone,
          bottles: bottles,
          promoCode: promo,
          bottlePayment: choice,
        );

    test('sends the choices, never a price, and gives back the page to pay on with its payment id', () async {
      site.functions['create-table-booking-checkout'] = (b) => (status: 200, body: {'url': url});
      final s = await start(bottles: {'b1': 2, 'b2': 0}, hours: 3, phone: '416-555-0100', promo: ' save10 ', choice: BottlePaymentChoice.payAtClub);
      expect(site.forFunction('create-table-booking-checkout').single.body, {
        'venue_id': 'v1',
        'table_type_id': 'tt1',
        'time_slot_id': 's1',
        'booking_date': '2026-10-30',
        'guest_count': 4,
        'hours': 3,
        'customer_name': 'Dana Lee',
        'customer_email': 'dana@example.com',
        'customer_phone': '416-555-0100',
        'bottles': [
          {'bottle_id': 'b1', 'quantity': 2}
        ],
        'promo_code': 'save10',
        'bottle_payment_choice': 'pay_at_club',
      });
      expect(s.url.toString(), url);
      expect(s.sessionId, 'cs_test_t1B2c3');
    });

    test('leaves out what was not given: hours, phone, promo code', () async {
      site.functions['create-table-booking-checkout'] = (b) => (status: 200, body: {'url': url});
      await start();
      final sent = site.forFunction('create-table-booking-checkout').single.body;
      for (final k in ['hours', 'customer_phone', 'promo_code']) {
        expect(sent.containsKey(k), isFalse, reason: k);
      }
      expect(sent['bottles'], isEmpty);
      expect(sent['bottle_payment_choice'], 'pay_ahead');
    });

    test('a refusal (no tables left) is the website\'s own sentence', () async {
      site.functions['create-table-booking-checkout'] = (b) => (status: 409, body: {'error': 'No tables of this type left for that date and time'});
      await expectLater(start(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'No tables of this type left for that date and time')));
    });

    test('a server error, a lost connection and an answer with no payment page are each a plain sentence', () async {
      site.functions['create-table-booking-checkout'] = (b) => (status: 500, body: {'error': 'Internal server error'});
      await expectLater(start(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not start your booking. Check your connection and try again.')));
      site.functions['create-table-booking-checkout'] = (b) => (status: 200, body: {'url': 'http://not-https.example'});
      await expectLater(start(), throwsA(isA<SiteException>().having((e) => e.message, 'message', actionFailedMessage)));
      site.networkDown = true;
      await expectLater(start(), throwsA(isA<SiteException>()));
    });

    test('where the payment stands is asked of the same website function as for tickets, and a table answers with its booking', () async {
      site.functions['site-booking-status'] = (b) => (status: 200, body: paidBookingAnswer());
      final s = await TicketCheckoutService(site.client).status('cs_test_t1B2c3');
      expect(site.forFunction('site-booking-status').single.body, {'session_id': 'cs_test_t1B2c3'});
      expect(s.booking!.confirmationCode, 'TB-ABCD2345');
    });

    test('a promo code for a table says it applies to tables', () async {
      site.functions['validate-promo-code'] = (b) => (status: 200, body: {'valid': true, 'discountCents': 500, 'message': '5 off'});
      await TicketCheckoutService(site.client).checkPromo(code: 'X', subtotalCents: 10000, venueId: 'v1', appliesTo: 'tables');
      expect(site.forFunction('validate-promo-code').single.body, {'code': 'X', 'applies_to': 'tables', 'venue_id': 'v1', 'subtotal_cents': 10000});
    });
  });

  // The website's database and edge functions decide every name, limit and sentence here; these read its SQL and TypeScript when it is checked out beside this app.
  group('agrees with the website', skip: websiteIsHere ? false : websiteMissing, () {
    Set<String> selectedColumns(String select) => {
          for (final c in select.replaceAll(RegExp(r'[A-Za-z_]+\([^)]*\)'), '').split(','))
            if (c.trim().isNotEmpty) c.trim(),
        };

    test('every column the app reads from venues, tables, times, floors and bottles exists in the website\'s tables', () async {
      site.tables['site_venues'] = [];
      site.tables['site_venue_floors'] = [];
      site.tables['site_bottles'] = [];
      final service = VenuesService(site.client);
      await service.venues();
      await service.floors('v1');
      await service.bottles('v1');
      final venueSelect = site.forTable('site_venues').single.query['select']!;
      final embeddedTables = RegExp(r'site_table_types\(([^)]*)\)').firstMatch(venueSelect)!.group(1)!;
      final embeddedSlots = RegExp(r'site_venue_time_slots\(([^)]*)\)').firstMatch(venueSelect)!.group(1)!;

      // A column that no migration of the repository creates must at least be one the website's own types and code use (it exists in production only).
      void check(String table, Set<String> cols) {
        final have = columnsOf(table);
        expect(have, contains('id'), reason: 'the column reader found $table');
        final typed = typedColumns(table);
        expect(typed, contains('id'), reason: 'the website\'s types describe $table');
        for (final c in cols) {
          if (!have.contains(c)) expect(typed, contains(c), reason: '$table.$c is in no migration and not in the website\'s types');
        }
      }

      check('site_venues', selectedColumns(venueSelect));
      check('site_table_types', selectedColumns(embeddedTables));
      check('site_venue_time_slots', selectedColumns(embeddedSlots));
      check('site_venue_floors', selectedColumns(site.forTable('site_venue_floors').single.query['select']!));
      check('site_bottles', selectedColumns(site.forTable('site_bottles').single.query['select']!));
      expect(columnsOf('site_content'), contains('bottlesup_fee_bps'));
    });

    test('a visitor can read what the app reads: published venues, their tables, times, floors and bottles, and the site settings', () {
      final sql = allMigrations();
      for (final p in [
        'public read published venues',
        'public read time slots for published venues',
        'public read table types for published venues',
        'public read floors for published venues',
        'public read available bottles for published venues',
        'public read site content',
      ]) {
        expect(sql, contains('create policy "$p"'), reason: p);
      }
    });

    test('the availability and refund policy functions exist with the arguments the app sends, and a visitor may call the policy', () {
      final sql = allMigrations();
      expect(sql, contains('function public.get_unavailable_table_types(p_venue_id uuid, p_booking_date date, p_time_slot_id uuid)'));
      expect(sql, contains('returns setof uuid'));
      expect(sql, contains('function public.public_venue_refund_policy(p_venue uuid)'));
      expect(sql, contains('returns table (has_policy boolean, lines text[])'));
      expect(sql, contains('grant execute on function public.public_venue_refund_policy(uuid), public.guest_request_refund(text, text, text) to anon, authenticated, service_role'));
    });

    test('the table checkout takes the fields the app sends and decides the price itself', () {
      final ts = readFunction('create-table-booking-checkout');
      for (final f in ['venue_id', 'table_type_id', 'time_slot_id', 'booking_date', 'guest_count', 'hours', 'customer_name', 'customer_email', 'customer_phone', 'bottles', 'promo_code', 'bottle_payment_choice']) {
        expect(ts, contains(f), reason: f);
      }
      expect(ts, contains('b?.bottle_id'));
      expect(ts, contains('b?.quantity'));
      expect(ts, contains('return json({ url: session.url })'));
      expect(ts, contains("appliesTo: 'tables'"));
      expect(ts, contains('const guests = Number(guest_count);'));
      expect(ts, contains('guests > tableType.max_guests'));
      expect(ts, contains('tableType.hourly_rate_cents * requestedHours'));
    });

    test('the night and the after-midnight cutoff are the website\'s', () {
      final ts = readFunctionFile('_shared/bookingNight.ts');
      expect(ts, contains("AFTER_MIDNIGHT_CUTOFF = '$afterMidnightCutoff'"));
      expect(ts, contains('startTime < AFTER_MIDNIGHT_CUTOFF'));
      expect(readFunction('create-table-booking-checkout'), contains('requestedDayOfWeek !== timeSlot.day_of_week'));
      expect(readFunction('create-table-booking-checkout'), contains('getUTCDay()'));
    });

    test('tax, the BottlesUp fee and what is due at the club are worked out the way the app previews them', () {
      final ts = readFunction('create-table-booking-checkout');
      expect(ts, contains('Math.round((discountedSubtotalCents * taxRateBps) / 10000)'));
      expect(ts, contains('Math.round((discountedSubtotalCents * bottlesupFeeBps) / 10000)'));
      expect(ts, contains("const chargeNowBottleCents = bottlePaymentChoice === 'pay_at_club' ? 0 : bottleSubtotalCents;"));
      expect(ts, contains('const preTaxSubtotalCents = depositCents + chargeNowBottleCents;'));
      final shared = readFunctionFile('_shared/bottlePayment.ts');
      expect(shared, contains('Math.max(opts.bottleSubtotalCents - opts.depositCents, 0)'));
      expect(shared, contains("opts.bottlePaymentChoice !== 'pay_at_club'"));
      expect(ts, contains("venuePaymentMode === 'both'"));
    });

    test('the booking window and the time of a slot are checked by the website the way the app checks them', () {
      final ts = readFunction('create-table-booking-checkout');
      expect(ts, contains('booking_date < tableType.venue.booking_start_date'));
      expect(ts, contains('booking_date > tableType.venue.booking_end_date'));
      expect(columnsOf('site_venue_time_slots'), containsAll(['day_of_week', 'start_time']));
      expect(allMigrations(), contains('day_of_week int not null check (day_of_week between 0 and 6)'));
    });

    test('the status function answers a paid table with the booking fields the app reads', () {
      final ts = readFunction('site-booking-status');
      for (final f in [
        'confirmationCode',
        'customerEmail',
        'guestCount',
        'tableTypeName',
        'venueName',
        'bookingDate',
        'startTime',
        'depositCents',
        'bottleSubtotalCents',
        'taxCents',
        'bottlesupFeeCents',
        'discountCents',
        'totalCents',
        'paidNowCents',
        'dueAtVenueCents',
        'currency',
        'lineTotalCents',
        'paymentStatus',
      ]) {
        expect(ts, contains('$f:'), reason: f);
      }
      expect(ts, contains("status: 'paid'"));
      expect(ts, contains("status: 'not_found'"));
    });
  });
}
