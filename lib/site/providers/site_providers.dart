import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/site_event.dart';
import '../models/venue.dart';
import '../models/ticket_order.dart';
import '../services/account_service.dart';
import '../services/my_tickets_service.dart';
import '../services/site_events_service.dart';
import '../services/table_checkout_service.dart';
import '../services/ticket_checkout_service.dart';
import '../services/venues_service.dart';

/// The one connection to BottlesUp's project. Replaced in tests with a client that talks to a pretend website.
final siteClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final siteEventsServiceProvider = Provider<SiteEventsService>((ref) => SiteEventsService(ref.watch(siteClientProvider)));
final ticketCheckoutServiceProvider = Provider<TicketCheckoutService>((ref) => TicketCheckoutService(ref.watch(siteClientProvider)));
final myTicketsServiceProvider = Provider<MyTicketsService>((ref) => MyTicketsService(ref.watch(siteClientProvider)));
final venuesServiceProvider = Provider<VenuesService>((ref) => VenuesService(ref.watch(siteClientProvider)));
final tableCheckoutServiceProvider = Provider<TableCheckoutService>((ref) => TableCheckoutService(ref.watch(siteClientProvider)));
final accountServiceProvider = Provider<AccountService>((ref) => AccountService(ref.watch(siteClientProvider)));

/// The events still to come. Read again each time the screen opens: ticket counts change with every sale.
final upcomingEventsProvider = FutureProvider.autoDispose<List<SiteEvent>>((ref) => ref.watch(siteEventsServiceProvider).upcoming());

/// One event with its ticket types.
final eventProvider = FutureProvider.autoDispose.family<SiteEvent?, String>((ref, id) => ref.watch(siteEventsServiceProvider).event(id));

/// The signed-in person's paid and refunded orders of tickets.
/// The published venues with tables, for the Tables tab.
final venuesProvider = FutureProvider.autoDispose<List<Venue>>((ref) => ref.watch(venuesServiceProvider).venues());

final venueProvider = FutureProvider.autoDispose.family<Venue?, String>((ref, id) => ref.watch(venuesServiceProvider).venue(id));

final venueFloorsProvider = FutureProvider.autoDispose.family<List<Floor>, String>((ref, venueId) => ref.watch(venuesServiceProvider).floors(venueId));

final venueBottlesProvider = FutureProvider.autoDispose.family<List<Bottle>, String>((ref, venueId) => ref.watch(venuesServiceProvider).bottles(venueId));

final venueRefundPolicyProvider = FutureProvider.autoDispose.family<RefundPolicy?, String>((ref, venueId) => ref.watch(venuesServiceProvider).refundPolicy(venueId));

final siteFeeProvider = FutureProvider.autoDispose<int?>((ref) => ref.watch(venuesServiceProvider).feeBasisPoints());

/// Which tables are full for a night and arrival time. The key is a [AvailabilityQuery].
final unavailableTablesProvider = FutureProvider.autoDispose.family<Set<String>, AvailabilityQuery>(
  (ref, q) => ref.watch(venuesServiceProvider).unavailableTables(venueId: q.venueId, night: q.night, slotId: q.slotId),
);

class AvailabilityQuery {
  const AvailabilityQuery({required this.venueId, required this.night, required this.slotId});

  final String venueId;
  final String night;
  final String slotId;

  @override
  bool operator ==(Object other) => other is AvailabilityQuery && other.venueId == venueId && other.night == night && other.slotId == slotId;

  @override
  int get hashCode => Object.hash(venueId, night, slotId);
}

final myTicketOrdersProvider = FutureProvider.autoDispose<List<TicketOrder>>((ref) => ref.watch(myTicketsServiceProvider).orders());

/// Who is buying: the account's own name, e-mail address and phone, to put on the order. The e-mail is the signed-in account's verified address, because the database shows a person
/// only the orders made with that address.
class Account {
  const Account({required this.email, this.name = '', this.phone = ''});

  final String email;
  final String name;
  final String phone;
}

final accountProvider = FutureProvider.autoDispose<Account?>((ref) async {
  final db = ref.watch(siteClientProvider);
  final user = db.auth.currentUser;
  final email = user?.email;
  if (user == null || email == null || email.isEmpty) return null;
  var name = (user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? '').toString();
  var phone = '';
  try {
    final row = await db.from('profiles').select().eq('id', user.id).maybeSingle();
    if (row != null) {
      final n = row['name'] ?? row['full_name'];
      if (n is String && n.trim().isNotEmpty) name = n;
      final p = row['phone'] ?? row['phone_number'];
      if (p is String && p.trim().isNotEmpty) phone = p;
    }
  } catch (_) {
    // The profile only prefills the form; the person can type their details.
  }
  return Account(email: email, name: name.trim(), phone: phone.trim());
});

/// Opens an address outside the app: in the phone's own browser, or in a browser view on top of the app ([inApp], for paying, so the person comes straight back). Returns whether
/// anything could open it. Replaced in tests.
typedef OpenUrl = Future<bool> Function(Uri uri, {bool inApp});

final urlOpenerProvider = Provider<OpenUrl>((ref) {
  return (uri, {bool inApp = false}) async {
    try {
      if (await launchUrl(uri, mode: inApp ? LaunchMode.inAppBrowserView : LaunchMode.externalApplication)) return true;
    } catch (_) {
      // try the other way below
    }
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  };
});
