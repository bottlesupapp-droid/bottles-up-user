import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/features.dart';
import '../models/inbox.dart';
import '../models/safety.dart';
import '../models/site_event.dart';
import '../models/post.dart';
import '../models/review.dart';
import '../models/social_profile.dart';
import '../models/my_night.dart';
import '../models/site_contact.dart';
import '../models/table_booking.dart';
import '../models/venue.dart';
import '../models/ticket_order.dart';
import '../services/account_service.dart';
import '../services/booking_actions_service.dart';
import '../services/caption_ideas_service.dart';
import '../services/features_service.dart';
import '../services/inbox_service.dart';
import '../services/posts_service.dart';
import '../services/reviews_service.dart';
import '../services/safety_service.dart';
import '../services/guest_passes_service.dart';
import '../services/my_bookings_service.dart';
import '../services/my_tickets_service.dart';
import '../services/site_contact_service.dart';
import '../services/site_events_service.dart';
import '../services/social_profiles_service.dart';
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
final myBookingsServiceProvider = Provider<MyBookingsService>((ref) => MyBookingsService(ref.watch(siteClientProvider)));
final guestPassesServiceProvider = Provider<GuestPassesService>((ref) => GuestPassesService(ref.watch(siteClientProvider)));
final bookingActionsServiceProvider = Provider<BookingActionsService>((ref) => BookingActionsService(ref.watch(siteClientProvider)));
final siteContactServiceProvider = Provider<SiteContactService>((ref) => SiteContactService(ref.watch(siteClientProvider)));
final accountServiceProvider = Provider<AccountService>((ref) => AccountService(ref.watch(siteClientProvider)));
final postsServiceProvider = Provider<PostsService>((ref) => PostsService(ref.watch(siteClientProvider)));
final reviewsServiceProvider = Provider<ReviewsService>((ref) => ReviewsService(ref.watch(siteClientProvider)));
final inboxServiceProvider = Provider<InboxService>((ref) => InboxService(ref.watch(siteClientProvider)));
final captionIdeasServiceProvider = Provider<CaptionIdeasService>((ref) => CaptionIdeasService(ref.watch(siteClientProvider)));
final safetyServiceProvider = Provider<SafetyService>((ref) => SafetyService(ref.watch(siteClientProvider)));
final featuresServiceProvider = Provider<FeaturesService>((ref) => FeaturesService(ref.watch(siteClientProvider)));
final socialProfilesServiceProvider = Provider<SocialProfilesService>((ref) => SocialProfilesService(ref.watch(siteClientProvider)));

/// Which parts of the app BottlesUp has switched on. Read once per run; a failed read keeps everything new switched off.
final featuresProvider = FutureProvider<SiteFeatures>((ref) => ref.watch(featuresServiceProvider).features());

/// Is this feature on right now? False while the switches are still loading.
final featureOnProvider = Provider.family<bool, String>((ref, key) => ref.watch(featuresProvider).valueOrNull?.isOn(key) ?? false);

/// Every profile the signed-in person may act as, their own first. Forget it when someone signs out ([resetSocialState]).
final myProfilesProvider = FutureProvider<List<SocialProfile>>((ref) => ref.watch(socialProfilesServiceProvider).myProfiles());

/// The profile the person chose to act as, by id. Null means their own.
final selectedProfileIdProvider = StateProvider<String?>((ref) => null);

/// The profile the person is acting as now: the one they picked while they still may, otherwise their own. Null while the list loads or when they have none yet.
final actorProfileProvider = Provider<SocialProfile?>((ref) {
  final mine = ref.watch(myProfilesProvider).valueOrNull;
  if (mine == null || mine.isEmpty) return null;
  final picked = ref.watch(selectedProfileIdProvider);
  for (final p in mine) {
    if (p.id == picked && !p.suspended) return p;
  }
  for (final p in mine) {
    if (!p.isBusiness && !p.suspended) return p;
  }
  return null;
});

/// Who is looked at: a username, or an id. [actor] is in the key so a profile is read again when the person switches.
class ProfileKey {
  const ProfileKey({required this.actor, this.handle, this.id});

  final String actor;
  final String? handle;
  final String? id;

  @override
  bool operator ==(Object other) => other is ProfileKey && other.actor == actor && other.handle == handle && other.id == id;

  @override
  int get hashCode => Object.hash(actor, handle, id);
}

final socialProfileProvider = FutureProvider.autoDispose.family<SocialProfile, ProfileKey>(
  (ref, k) => ref.watch(socialProfilesServiceProvider).profile(actor: k.actor, handle: k.handle, id: k.id),
);

/// Who follows a profile, or who it follows ([followers]); the first page.
class PeopleKey {
  const PeopleKey({required this.actor, required this.profile, required this.followers});

  final String actor;
  final String profile;
  final bool followers;

  @override
  bool operator ==(Object other) => other is PeopleKey && other.actor == actor && other.profile == profile && other.followers == followers;

  @override
  int get hashCode => Object.hash(actor, profile, followers);
}

final peopleProvider = FutureProvider.autoDispose.family<List<SocialProfile>, PeopleKey>(
  (ref, k) => ref.watch(socialProfilesServiceProvider).people(actor: k.actor, profile: k.profile, followers: k.followers),
);

/// A search of profiles, as the acting profile.
class SearchKey {
  const SearchKey({required this.actor, required this.query});

  final String actor;
  final String query;

  @override
  bool operator ==(Object other) => other is SearchKey && other.actor == actor && other.query == query;

  @override
  int get hashCode => Object.hash(actor, query);
}

final profileSearchProvider = FutureProvider.autoDispose.family<List<SocialProfile>, SearchKey>(
  (ref, k) => ref.watch(socialProfilesServiceProvider).search(actor: k.actor, query: k.query),
);

final followRequestsProvider = FutureProvider.autoDispose.family<List<SocialProfile>, String>((ref, actor) => ref.watch(socialProfilesServiceProvider).requests(actor));

final blockedProfilesProvider = FutureProvider.autoDispose.family<List<SocialProfile>, String>((ref, actor) => ref.watch(socialProfilesServiceProvider).blocked(actor));

/// The community rules as BottlesUp published them (the version to accept, and the text). Read again when the person opens the rules.
final communityRulesProvider = FutureProvider.autoDispose<CommunityRules>((ref) => ref.watch(safetyServiceProvider).rules());

/// Has the person accepted the community rules? Read again after they accept.
final rulesAcceptedProvider = FutureProvider<bool>((ref) => ref.watch(postsServiceProvider).rulesAccepted());

/// The address a private picture or video is shown from, or null when it could not be signed.
final signedMediaUrlProvider = FutureProvider.autoDispose.family<String?, String>((ref, path) => ref.watch(postsServiceProvider).signedUrl(path));

final storyRailProvider = FutureProvider.autoDispose.family<List<StoryRailItem>, String>((ref, actor) => ref.watch(postsServiceProvider).storyRail(actor));

/// A post, as the acting profile sees it.
class PostKey {
  const PostKey({required this.actor, required this.id});

  final String actor;
  final String id;

  @override
  bool operator ==(Object other) => other is PostKey && other.actor == actor && other.id == id;

  @override
  int get hashCode => Object.hash(actor, id);
}

final postProvider = FutureProvider.autoDispose.family<SocialPost, PostKey>((ref, k) => ref.watch(postsServiceProvider).post(actor: k.actor, id: k.id));

/// One profile's stories that are up, as the acting profile sees them.
final storiesOfProvider = FutureProvider.autoDispose.family<List<SocialPost>, PeopleKey>(
  (ref, k) => ref.watch(postsServiceProvider).storiesOf(actor: k.actor, profile: k.profile),
);

/// Which reviews: of a venue or an event, as a profile sees them.
class ReviewsKey {
  const ReviewsKey({required this.actor, required this.kind, required this.target});

  final String actor;
  final ReviewKind kind;
  final String target;

  @override
  bool operator ==(Object other) => other is ReviewsKey && other.actor == actor && other.kind == kind && other.target == target;

  @override
  int get hashCode => Object.hash(actor, kind, target);
}

/// The first page of reviews of a venue or event, with the summary.
final reviewsPageProvider = FutureProvider.autoDispose.family<ReviewsPage, ReviewsKey>(
  (ref, k) => ref.watch(reviewsServiceProvider).reviews(actor: k.actor, kind: k.kind, target: k.target, limit: 5),
);

/// May the profile review this? Read again after it writes or deletes one.
final reviewEligibilityProvider = FutureProvider.autoDispose.family<ReviewEligibility, ReviewsKey>(
  (ref, k) => ref.watch(reviewsServiceProvider).eligibility(actor: k.actor, kind: k.kind, target: k.target),
);

/// Ratings of the venues on screen, by venue id. The key is the ids joined with commas (a list would be a new key every time it was built). Empty while reviews are off or when
/// they cannot be read.
final venueRatingsProvider = FutureProvider.autoDispose.family<Map<String, VenueRating>, String>((ref, ids) {
  if (!ref.watch(featureOnProvider(Feature.reviews)) || ids.isEmpty) return const {};
  return ref.watch(reviewsServiceProvider).ratings(ids.split(','));
});

final hotVenuesProvider = FutureProvider.autoDispose<List<HotItem>>((ref) => ref.watch(reviewsServiceProvider).hotVenues());
final hotEventsProvider = FutureProvider.autoDispose<List<HotItem>>((ref) => ref.watch(reviewsServiceProvider).hotEvents());

/// A directory search of professionals.
class DirectoryKey {
  const DirectoryKey({required this.actor, this.category, this.city = '', this.query = ''});

  final String actor;
  final String? category;
  final String city;
  final String query;

  @override
  bool operator ==(Object other) => other is DirectoryKey && other.actor == actor && other.category == category && other.city == city && other.query == query;

  @override
  int get hashCode => Object.hash(actor, category, city, query);
}

final professionalsProvider = FutureProvider.autoDispose.family<List<SocialProfile>, DirectoryKey>(
  (ref, k) => ref.watch(reviewsServiceProvider).professionals(actor: k.actor, category: k.category, city: k.city, query: k.query),
);

/// The badge on the Inbox tab: conversations with something new and requests waiting. Zero while messages are switched off.
final inboxCountsProvider = FutureProvider.autoDispose.family<InboxCounts, String>((ref, actor) {
  if (!ref.watch(featureOnProvider(Feature.inbox))) return const InboxCounts();
  return ref.watch(inboxServiceProvider).counts(actor);
});

/// Which conversation, as the acting profile sees it.
class ConversationKey {
  const ConversationKey({required this.actor, required this.id});

  final String actor;
  final String id;

  @override
  bool operator ==(Object other) => other is ConversationKey && other.actor == actor && other.id == id;

  @override
  int get hashCode => Object.hash(actor, id);
}

final conversationProvider = FutureProvider.autoDispose.family<Conversation, ConversationKey>((ref, k) => ref.watch(inboxServiceProvider).conversation(actor: k.actor, id: k.id));

/// Which kinds of notification the profile gets.
final notificationPrefsProvider = FutureProvider.autoDispose.family<Map<String, bool>, String>((ref, actor) => ref.watch(inboxServiceProvider).notificationPrefs(actor));

/// How many notifications the profile has not read.
final unreadNotificationsProvider = FutureProvider.autoDispose.family<int, String>((ref, actor) => ref.watch(inboxServiceProvider).unreadNotifications(actor));

/// Forget everything about the person who was signed in (their profiles, which one they were acting as) so the next person starts clean.
void resetSocialState(WidgetRef ref) {
  ref.invalidate(myProfilesProvider);
  ref.invalidate(rulesAcceptedProvider);
  ref.read(selectedProfileIdProvider.notifier).state = null;
}

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

/// The person's table bookings (paid, cancelled or refunded).
final myTableBookingsProvider = FutureProvider.autoDispose<List<TableBooking>>((ref) => ref.watch(myBookingsServiceProvider).bookings());

/// One booking with its bottles, club payments and refunds.
final tableBookingProvider = FutureProvider.autoDispose.family<TableBooking?, String>((ref, id) => ref.watch(myBookingsServiceProvider).booking(id));

/// The guests on a table booking, by the booking's confirmation code.
final guestRosterProvider = FutureProvider.autoDispose.family<GuestRoster, String>((ref, code) => ref.watch(guestPassesServiceProvider).roster(code));

/// How to reach BottlesUp, from the CMS.
final siteContactProvider = FutureProvider.autoDispose<SiteContact>((ref) => ref.watch(siteContactServiceProvider).load());

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
