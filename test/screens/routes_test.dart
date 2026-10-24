import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/features/bookings_site/screens/table_booking_detail_screen.dart';
import 'package:bottles_up_user/features/tables/screens/table_booking_screen.dart';
import 'package:bottles_up_user/features/tables/screens/venue_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/payment_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_screen.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/site/models/checkout.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_events'] = [eventRow(cover: null)];
    site.tables['site_orders'] = [orderRow()];
    site.tables['site_venues'] = [venueRow()];
    site.rpcs['get_unavailable_table_types'] = (b) => (status: 200, body: <String>[]);
    site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: <Object>[]);
  });

  /// The app's own routes, without the sign-in redirect (that needs the app's session).
  Future<GoRouter> openAt(WidgetTester tester, String location, {Object? extra}) async {
    final router = GoRouter(initialLocation: location, initialExtra: extra, routes: appRoutes);
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteClientProvider.overrideWithValue(site.client),
        accountProvider.overrideWith((ref) async => signedIn),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('/events/:id opens that event', (tester) async {
    await openAt(tester, '/events/e1');
    expect(find.byType(EventPageScreen), findsOneWidget);
    expect(site.forTable('site_events').single.query['id'], 'eq.e1');
  });

  testWidgets('/events/:id/tickets/:tierId opens the purchase for that ticket type', (tester) async {
    await openAt(tester, '/events/e1/tickets/t1');
    expect(find.byType(TicketPurchaseScreen), findsOneWidget);
    expect(tester.widget<TicketPurchaseScreen>(find.byType(TicketPurchaseScreen)).tierId, 't1');
  });

  testWidgets('choosing a ticket on the event page goes to its purchase', (tester) async {
    await openAt(tester, '/events/e1');
    await tester.tap(find.byKey(const Key('tier-t1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('get-tickets')));
    await tester.pumpAndSettle();
    final screen = tester.widget<TicketPurchaseScreen>(find.byType(TicketPurchaseScreen));
    expect([screen.eventId, screen.tierId], ['e1', 't1']);
  });

  testWidgets('/venues/:id opens that venue', (tester) async {
    await openAt(tester, '/venues/v1');
    expect(find.byType(VenueScreen), findsOneWidget);
    expect(site.forTable('site_venues').single.query['id'], 'eq.v1');
  });

  testWidgets('/venues/:id/tables/:tableId/book carries the table, the night and the time into the booking', (tester) async {
    await openAt(tester, '/venues/v1/tables/tt1/book?date=2026-10-30&slot=s1');
    final screen = tester.widget<TableBookingScreen>(find.byType(TableBookingScreen));
    expect([screen.venueId, screen.tableId, screen.dateKey, screen.slotId], ['v1', 'tt1', '2026-10-30', 's1']);
  });

  testWidgets('booking a table on the venue page goes to the booking with the night and time in the address', (tester) async {
    final router = await openAt(tester, '/venues/v1');
    // The venue takes Friday bookings; pick the first night offered.
    final chips = find.byWidgetPredicate((w) => w is ChoiceChip && '${w.key}'.contains('night-'));
    expect(chips, findsWidgets);
    await tester.tap(chips.first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('book-tt1')));
    await tester.tap(find.byKey(const Key('book-tt1')));
    await tester.pumpAndSettle();
    final screen = tester.widget<TableBookingScreen>(find.byType(TableBookingScreen));
    expect([screen.venueId, screen.tableId, screen.slotId], ['v1', 'tt1', 's1']);
    expect(screen.dateKey, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, startsWith('/venues/v1/tables/tt1/book'));
  });

  testWidgets('/bookings/:id opens that table booking', (tester) async {
    site.tables['site_table_bookings'] = [bookingRow()];
    site.tables['site_table_booking_bottles'] = [];
    site.tables['site_table_booking_club_payments'] = [];
    site.tables['site_table_booking_refunds'] = [];
    await openAt(tester, '/bookings/bk1');
    expect(find.byType(TableBookingDetailScreen), findsOneWidget);
    expect(find.byKey(const Key('booking-detail')), findsOneWidget);
    expect(site.forTable('site_table_bookings').first.query['id'], 'eq.bk1');
  });

  testWidgets('/tickets/:id opens that ticket', (tester) async {
    await openAt(tester, '/tickets/o1');
    expect(find.byType(TicketScreen), findsOneWidget);
    expect(find.byKey(const Key('ticket-qr')), findsOneWidget);
  });

  testWidgets('/payment opens the waiting screen when it was handed a started payment', (tester) async {
    final args = PaymentWaitArgs(eventId: 'e1', tierId: 't1', eventTitle: 'Friday Night', start: CheckoutStart(url: Uri.parse('https://pay.example/x'), sessionId: 'cs_test_1'), startedAt: DateTime.now());
    // The waiting screen's spinner never settles, so look at it without waiting for that.
    final router = GoRouter(initialLocation: '/payment', initialExtra: args, routes: appRoutes);
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(overrides: [siteClientProvider.overrideWithValue(site.client)], child: MaterialApp.router(routerConfig: router)));
    await tester.pump();
    expect(find.byType(PaymentScreen), findsOneWidget);
    expect(find.byKey(const Key('payment-waiting')), findsOneWidget);
  });

  test('the routes the app used to have for the old booking flow are gone', () {
    final paths = <String>[];
    void walk(List<RouteBase> routes, String prefix) {
      for (final r in routes) {
        if (r is GoRoute) {
          paths.add(r.path);
          walk(r.routes, r.path);
        }
      }
    }

    walk(appRoutes, '');
    expect(paths, containsAll(['/', '/login', '/signup', '/home', '/events/:id', '/events/:id/tickets/:tierId', '/venues/:id', '/venues/:id/tables/:tableId/book', '/payment', '/tickets/:id', '/bookings/:id']));
    for (final gone in ['/checkout', '/checkout-success', '/events/:id/book', '/table-selection/:clubId', '/location-permission', '/location/manual-entry', '/profile/orders', '/notifications']) {
      expect(paths, isNot(contains(gone)), reason: gone);
    }
  });
}
