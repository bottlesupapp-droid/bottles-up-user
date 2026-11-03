import 'fake_website.dart';

/// The group that asks (an event group the person runs) and the venue, as `profile_mini` gives them.
Map<String, dynamic> groupProfile() => profileRow(id: 'grp', kind: 'business', handle: 'eonics', name: 'EONICS', category: 'event_group', mine: true);
Map<String, dynamic> clubProfile() => profileRow(id: 'club', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue');

/// An offer as `hire_offer_json` gives it.
Map<String, dynamic> hireOfferRow({
  String id = 'of1',
  int rental = 450000,
  int deposit = 100000,
  int minSales = 300000,
  int barShare = 2000,
  String control = 'shared',
  String status = 'sent',
  String valid = '2099-10-30T12:00:00Z',
  String? staffing = 'Two bartenders included',
  String? equipment = 'House sound',
  String? cancellation = 'Lose the deposit within 14 days',
  String? notes,
}) =>
    {
      'id': id,
      'rental_cents': rental,
      'deposit_cents': deposit,
      'min_sales_cents': minSales,
      'bar_share_bps': barShare,
      'control': control,
      'staffing': staffing,
      'equipment': equipment,
      'cancellation': cancellation,
      'notes': notes,
      'valid_until': valid,
      'status': status,
      'created_at': '2099-10-25T12:00:00Z',
    };

/// A hire as `hire_json` gives it. Pass [asker] to see it as the venue does.
Map<String, dynamic> hireRow({
  String id = 'hr1',
  String state = 'requested',
  String date = '2099-11-08',
  String type = 'Themed night',
  String? hours = '9pm to 3am',
  int? attendance = 400,
  String? space = 'Main room',
  String? equipment = 'Own DJ booth',
  String? staffing = 'Two bartenders',
  int? budget = 500000,
  String? notes = 'Please keep the lights low',
  String? declineNote,
  String? cancelledBy,
  String? cancelReason,
  String? eventId,
  Map<String, dynamic>? organizer,
  Map<String, dynamic>? venue,
  Map<String, dynamic>? asker,
  Map<String, dynamic>? offer,
}) =>
    {
      'id': id,
      'state': state,
      'event_date': date,
      'hours': hours,
      'event_type': type,
      'attendance': attendance,
      'space': space,
      'equipment': equipment,
      'staffing': staffing,
      'budget_cents': budget,
      'notes': notes,
      'decline_note': declineNote,
      'cancelled_by': cancelledBy,
      'cancel_reason': cancelReason,
      'event_id': eventId,
      'confirmed_at': state == 'confirmed' ? '2099-10-26T12:00:00Z' : null,
      'created_at': '2099-10-24T12:00:00Z',
      'organizer': organizer ?? groupProfile(),
      'venue': venue ?? clubProfile(),
      'requested_by': asker,
      'offer': offer,
    };

Map<String, dynamic> hireItemRow({String id = 'it1', String kind = 'task', String title = 'Send the lineup', String? at, String? due, bool done = false, String side = 'organizer'}) =>
    {'id': id, 'kind': kind, 'title': title, 'at_time': at, 'due_on': due, 'done': done, 'side': side, 'created_at': '2099-10-25T12:00:00Z'};

Map<String, dynamic> lineupRow({String id = 'pb1', String title = 'DJ set', bool confirmed = false, String state = 'awaiting_deposit'}) => {
      'id': id,
      'title': title,
      'confirmed': confirmed,
      'state': state,
      'provider': profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: 'dj'),
    };

/// The workspace page as `hire_workspace` gives it.
Map<String, dynamic> workspaceRow({
  String side = 'organizer',
  bool open = true,
  Map<String, dynamic>? hire,
  List<Map<String, dynamic>> items = const [],
  List<Map<String, dynamic>> bookings = const [],
  Map<String, dynamic>? event,
  List<String> pending = const [],
  String? hireChat,
  String? eventChat,
}) =>
    {
      'hire': hire ?? hireRow(state: 'confirmed', offer: hireOfferRow(status: 'accepted')),
      'side': side,
      'open': open,
      'items': items,
      'bookings': bookings,
      'event': event,
      'pending': pending,
      'hire_chat': hireChat,
      'event_chat': eventChat,
    };

Map<String, dynamic> linkedEventRow({String id = 'ev1', String title = 'Themed night', int sold = 130, int capacity = 350}) =>
    {'id': id, 'title': title, 'start_date': '2099-11-08T21:00:00Z', 'status': 'published', 'tickets_sold': sold, 'tickets_capacity': capacity};

/// A team member as `team_member_json` gives it.
Map<String, dynamic> teamMemberRow({String id = 'tm1', String role = 'booking_agent', List<String> permissions = const ['bookings'], String status = 'active', String name = 'Ann Lee', String handle = 'annteam'}) =>
    {'id': id, 'role': role, 'permissions': permissions, 'status': status, 'invited_at': '2099-10-25T12:00:00Z', 'answered_at': null, 'person': {'name': name, 'handle': handle}};

Map<String, dynamic> teamInfoRow({bool canManage = true, List<Map<String, dynamic>>? members, String? chat, String? chatProfile}) => {
      'can_manage': canManage,
      'owner': {'name': 'Dee Dee', 'handle': 'deeteam'},
      'members': members ?? [teamMemberRow()],
      'chat': chat,
      'chat_profile': chatProfile,
    };

Map<String, dynamic> teamInvitationRow({String id = 'tm9', String role = 'content_manager', List<String> permissions = const ['content']}) => {
      'id': id,
      'role': role,
      'permissions': permissions,
      'invited_at': '2099-10-25T12:00:00Z',
      'profile': profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: 'dj'),
    };
