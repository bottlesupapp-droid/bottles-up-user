import '../read.dart';
import '../when.dart';
import 'hiring.dart';
import 'social_profile.dart';

/// Which side of a hire the person is on.
enum HireSide { organizer, venue }

/// Where a hire really stands, as `hire_state` says it. A request, an offer and an agreement are NOT a booked venue: only `confirmed` (and `completed` after the day) is.
enum HireState {
  requested('requested', 'Waiting for an offer'),
  offered('offered', 'Offer made'),
  offerExpired('offer_expired', 'Offer ran out'),
  agreed('agreed', 'Agreed: waiting for the venue to confirm'),
  confirmed('confirmed', 'Confirmed'),
  declined('declined', 'Declined'),
  withdrawn('withdrawn', 'Withdrawn'),
  cancelled('cancelled', 'Cancelled'),
  lapsed('lapsed', 'Not agreed in time'),
  completed('completed', 'Done');

  const HireState(this.wire, this.label);

  final String wire;
  final String label;

  static HireState? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }

  /// Booked: the venue has said yes to the date.
  bool get isBooked => this == confirmed || this == completed;

  /// Nothing more will happen to it.
  bool get isClosed => this == declined || this == withdrawn || this == cancelled || this == lapsed || this == completed;
}

/// Who controls ticket and table sales on the night, as agreed in the offer.
enum HireControl {
  venue('venue', 'The venue'),
  organizer('organizer', 'The group'),
  shared('shared', 'Shared');

  const HireControl(this.wire, this.label);

  final String wire;
  final String label;

  static HireControl? fromWire(Object? v) {
    for (final c in values) {
      if (c.wire == v) return c;
    }
    return null;
  }
}

/// What the venue offered. The money is agreed here and settled between the group and the venue (BottlesUp does not take it).
class HireOffer {
  const HireOffer({
    required this.id,
    required this.rentalCents,
    required this.depositCents,
    required this.minSalesCents,
    required this.barShareBps,
    required this.control,
    required this.validUntil,
    required this.status,
    this.staffing,
    this.equipment,
    this.cancellation,
    this.notes,
  });

  final String id;
  final int rentalCents;
  final int depositCents;
  final int minSalesCents;
  final int barShareBps;
  final HireControl control;
  final DateTime validUntil;

  /// `sent`, `accepted`, `declined`, `withdrawn` or `expired`.
  final String status;
  final String? staffing;
  final String? equipment;
  final String? cancellation;
  final String? notes;

  bool get isLive => status == 'sent';
  bool get isAccepted => status == 'accepted';

  /// The bar share as a percentage in words ("20%", "12.5%").
  String get barShareText {
    final whole = barShareBps % 100 == 0;
    return '${(barShareBps / 100).toStringAsFixed(whole ? 0 : 1)}%';
  }
}

HireOffer? parseHireOffer(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final rental = readInt(json['rental_cents']);
  final deposit = readInt(json['deposit_cents']);
  final control = HireControl.fromWire(json['control']);
  final until = parseWhen(json['valid_until']);
  final status = readText(json['status']);
  if (id == null || rental == null || rental < 0 || deposit == null || deposit < 0 || deposit > rental || control == null || until == null || status == null) return null;
  return HireOffer(
    id: id,
    rentalCents: rental,
    depositCents: deposit,
    minSalesCents: readInt(json['min_sales_cents']) ?? 0,
    barShareBps: readInt(json['bar_share_bps']) ?? 0,
    control: control,
    validUntil: until,
    status: status,
    staffing: readText(json['staffing']),
    equipment: readText(json['equipment']),
    cancellation: readText(json['cancellation']),
    notes: readText(json['notes']),
  );
}

/// One venue-hire request and what has become of it.
class Hire {
  const Hire({
    required this.id,
    required this.state,
    required this.eventDate,
    required this.eventType,
    required this.createdAt,
    required this.side,
    this.hours,
    this.attendance,
    this.space,
    this.equipment,
    this.staffing,
    this.budgetCents,
    this.notes,
    this.declineNote,
    this.cancelledBy,
    this.cancelReason,
    this.eventId,
    this.confirmedAt,
    this.organizer,
    this.venue,
    this.requestedBy,
    this.offer,
  });

  final String id;
  final HireState state;
  final DateTime eventDate;
  final String eventType;
  final DateTime createdAt;
  final HireSide side;
  final String? hours;
  final int? attendance;
  final String? space;
  final String? equipment;
  final String? staffing;
  final int? budgetCents;
  final String? notes;
  final String? declineNote;

  /// `organizer` or `venue`.
  final String? cancelledBy;
  final String? cancelReason;
  final String? eventId;
  final DateTime? confirmedAt;
  final SocialProfile? organizer;
  final SocialProfile? venue;

  /// Only the venue is told who asked.
  final Customer? requestedBy;
  final HireOffer? offer;

  /// The profile on the other side, for the title.
  SocialProfile? get other => side == HireSide.organizer ? venue : organizer;

  /// The profile this side acts as.
  SocialProfile? get mine => side == HireSide.organizer ? organizer : venue;

  /// There is a live offer the group can still agree to.
  bool get hasLiveOffer => state == HireState.offered && offer != null && offer!.isLive;
}

Hire? parseHire(Object? json, HireSide side) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final state = HireState.fromWire(json['state']);
  final day = readDay(json['event_date']);
  final type = readText(json['event_type']);
  final created = parseWhen(json['created_at']);
  if (id == null || state == null || day == null || type == null || created == null) return null;
  return Hire(
    id: id,
    state: state,
    eventDate: day,
    eventType: type,
    createdAt: created,
    side: side,
    hours: readText(json['hours']),
    attendance: readInt(json['attendance']),
    space: readText(json['space']),
    equipment: readText(json['equipment']),
    staffing: readText(json['staffing']),
    budgetCents: readInt(json['budget_cents']),
    notes: readText(json['notes']),
    declineNote: readText(json['decline_note']),
    cancelledBy: readText(json['cancelled_by']),
    cancelReason: readText(json['cancel_reason']),
    eventId: readText(json['event_id']),
    confirmedAt: parseWhen(json['confirmed_at']),
    organizer: parseSocialProfile(json['organizer']),
    venue: parseSocialProfile(json['venue']),
    requestedBy: parseCustomer(json['requested_by']),
    offer: parseHireOffer(json['offer']),
  );
}

List<Hire> parseHires(Object? json, HireSide side) => json is List ? [for (final r in json) if (parseHire(r, side) case final Hire h) h] : const [];

/// A task or a schedule item in the shared workspace.
class HireItem {
  const HireItem({required this.id, required this.isSchedule, required this.title, required this.done, required this.side, this.atTime, this.dueOn});

  final String id;
  final bool isSchedule;
  final String title;
  final bool done;
  final HireSide side;

  /// "21:00" for a schedule item.
  final String? atTime;
  final DateTime? dueOn;
}

HireItem? parseHireItem(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final kind = json['kind'];
  final title = readText(json['title']);
  final side = switch (json['side']) {
    'organizer' => HireSide.organizer,
    'venue' => HireSide.venue,
    _ => null,
  };
  if (id == null || (kind != 'task' && kind != 'schedule') || title == null || side == null) return null;
  final at = readText(json['at_time']);
  if (kind == 'schedule' && at == null) return null;
  return HireItem(id: id, isSchedule: kind == 'schedule', title: title, done: json['done'] == true, side: side, atTime: at, dueOn: readDay(json['due_on']));
}

/// A professional the group attached to the hire. The venue sees who and whether the deposit is in, never the money.
class LineupEntry {
  const LineupEntry({required this.bookingId, required this.title, required this.confirmed, this.provider, this.state});

  final String bookingId;
  final String title;
  final bool confirmed;
  final SocialProfile? provider;
  final BookingState? state;
}

LineupEntry? parseLineupEntry(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  if (id == null) return null;
  return LineupEntry(bookingId: id, title: readText(json['title']) ?? 'Booking', confirmed: json['confirmed'] == true, provider: parseSocialProfile(json['provider']), state: BookingState.fromWire(json['state']));
}

/// The public event linked to the hire, with its ticket numbers.
class LinkedEvent {
  const LinkedEvent({required this.id, required this.title, required this.ticketsSold, required this.ticketsCapacity, this.startDate});

  final String id;
  final String title;
  final int ticketsSold;
  final int ticketsCapacity;
  final DateTime? startDate;
}

LinkedEvent? parseLinkedEvent(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final title = readText(json['title']);
  if (id == null || title == null) return null;
  return LinkedEvent(id: id, title: title, ticketsSold: readInt(json['tickets_sold']) ?? 0, ticketsCapacity: readInt(json['tickets_capacity']) ?? 0, startDate: parseWhen(json['start_date']));
}

/// An event the group could link.
class LinkableEvent {
  const LinkableEvent({required this.id, required this.title, this.startDate});

  final String id;
  final String title;
  final DateTime? startDate;
}

List<LinkableEvent> parseLinkableEvents(Object? json) => json is List
    ? [
        for (final r in json)
          if (r is Map && readText(r['id']) != null && readText(r['title']) != null) LinkableEvent(id: readText(r['id'])!, title: readText(r['title'])!, startDate: parseWhen(r['start_date'])),
      ]
    : const [];

/// The private page of a hire: terms, schedule and tasks, lineup, public event, what is pending and the chats.
class Workspace {
  const Workspace({required this.hire, required this.side, required this.open, required this.items, required this.lineup, required this.pending, this.event, this.hireChat, this.eventChat});

  final Hire hire;
  final HireSide side;

  /// Items can be added from the agreement until the day.
  final bool open;
  final List<HireItem> items;
  final List<LineupEntry> lineup;
  final List<String> pending;
  final LinkedEvent? event;
  final String? hireChat;
  final String? eventChat;
}

Workspace? parseWorkspace(Object? json) {
  if (json is! Map) return null;
  final side = switch (json['side']) {
    'organizer' => HireSide.organizer,
    'venue' => HireSide.venue,
    _ => null,
  };
  if (side == null) return null;
  final hire = parseHire(json['hire'], side);
  if (hire == null) return null;
  final items = json['items'];
  final bookings = json['bookings'];
  final pending = json['pending'];
  return Workspace(
    hire: hire,
    side: side,
    open: json['open'] == true,
    items: items is List ? [for (final i in items) if (parseHireItem(i) case final HireItem x) x] : const [],
    lineup: bookings is List ? [for (final b in bookings) if (parseLineupEntry(b) case final LineupEntry x) x] : const [],
    pending: pending is List ? [for (final p in pending) if (p is String && p.trim().isNotEmpty) p] : const [],
    event: parseLinkedEvent(json['event']),
    hireChat: readText(json['hire_chat']),
    eventChat: readText(json['event_chat']),
  );
}

// ---- teams

/// A role on a professional's team, with what it may do. Mirrors `team_role_permissions` (a test reads the migration and compares).
enum TeamRole {
  manager('manager', 'Manager', 'Bookings, posts and earnings', {'bookings', 'content', 'finance'}),
  bookingAgent('booking_agent', 'Booking agent', 'Services, requests, quotes and hires', {'bookings'}),
  contentManager('content_manager', 'Content manager', 'Posts and the profile\'s details', {'content'}),
  financeAssistant('finance_assistant', 'Finance assistant', 'Earnings', {'finance'}),
  doorStaff('door_staff', 'Door staff', 'Acts as the profile for following and messaging only', <String>{}),
  custom('custom', 'Custom', 'You choose', <String>{});

  const TeamRole(this.wire, this.label, this.summary, this.permissions);

  final String wire;
  final String label;
  final String summary;
  final Set<String> permissions;

  static TeamRole? fromWire(Object? v) {
    for (final r in values) {
      if (r.wire == v) return r;
    }
    return null;
  }
}

/// The three kinds of work a role can carry, and what each is called.
const Map<String, String> teamPermissionLabels = {
  'bookings': 'Services, requests, quotes and hires',
  'content': 'Posts and the profile\'s details',
  'finance': 'Earnings',
};

class TeamMember {
  const TeamMember({required this.id, required this.role, required this.permissions, required this.status, this.person, this.invitedAt});

  final String id;
  final TeamRole role;
  final Set<String> permissions;

  /// `invited` or `active`.
  final String status;
  final Customer? person;
  final DateTime? invitedAt;

  bool get isActive => status == 'active';
}

TeamMember? parseTeamMember(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final role = TeamRole.fromWire(json['role']);
  final status = readText(json['status']);
  if (id == null || role == null || status == null) return null;
  return TeamMember(id: id, role: role, permissions: Set<String>.from(readTexts(json['permissions'])), status: status, person: parseCustomer(json['person']), invitedAt: parseWhen(json['invited_at']));
}

class TeamInfo {
  const TeamInfo({required this.canManage, required this.members, this.owner, this.chat, this.chatProfile});

  final bool canManage;
  final List<TeamMember> members;
  final Customer? owner;

  /// The team chat, and the personal profile to open it as.
  final String? chat;
  final String? chatProfile;
}

TeamInfo? parseTeamInfo(Object? json) {
  if (json is! Map) return null;
  final members = json['members'];
  return TeamInfo(
    canManage: json['can_manage'] == true,
    owner: parseCustomer(json['owner']),
    members: members is List ? [for (final m in members) if (parseTeamMember(m) case final TeamMember x) x] : const [],
    chat: readText(json['chat']),
    chatProfile: readText(json['chat_profile']),
  );
}

/// An invitation to join somebody's team.
class TeamInvitation {
  const TeamInvitation({required this.id, required this.role, required this.permissions, required this.profile, this.invitedAt});

  final String id;
  final TeamRole role;
  final Set<String> permissions;
  final SocialProfile profile;
  final DateTime? invitedAt;
}

List<TeamInvitation> parseTeamInvitations(Object? json) {
  if (json is! List) return const [];
  final out = <TeamInvitation>[];
  for (final r in json) {
    if (r is! Map) continue;
    final id = readText(r['id']);
    final role = TeamRole.fromWire(r['role']);
    final profile = parseSocialProfile(r['profile']);
    if (id == null || role == null || profile == null) continue;
    out.add(TeamInvitation(id: id, role: role, permissions: Set<String>.from(readTexts(r['permissions'])), profile: profile, invitedAt: parseWhen(r['invited_at'])));
  }
  return out;
}

/// What the person may do as a profile they act as.
class ProfileAccess {
  const ProfileAccess({required this.owner, required this.permissions});

  final bool owner;
  final Set<String> permissions;

  bool can(String permission) => owner || permissions.contains(permission);
}

ProfileAccess? parseProfileAccess(Object? json) {
  if (json is! Map) return null;
  return ProfileAccess(owner: json['owner'] == true, permissions: Set<String>.from(readTexts(json['permissions'])));
}
