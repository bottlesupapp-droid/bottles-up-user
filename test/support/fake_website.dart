import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// What the app asked a table for (the part of the address the database cares about).
class TableRequest {
  TableRequest(this.method, this.table, this.query, this.body);

  final String method;
  final String table;
  final Map<String, String> query;
  final Object? body;
}

/// What the app asked a website function (edge function) to do.
class FunctionRequest {
  FunctionRequest(this.name, this.body, this.headers);

  final String name;
  final Map<String, dynamic> body;
  final Map<String, String> headers;
}

/// What the app asked a database function (RPC) to do.
class RpcRequest {
  RpcRequest(this.name, this.body);

  final String name;
  final Map<String, dynamic> body;
}

/// What the app asked storage to do: upload a file, sign addresses, remove files.
class StorageRequest {
  StorageRequest(this.method, this.action, this.path, this.contentType, this.size, this.paths, [this.body = '']);

  final String method;

  /// 'upload', 'sign' or 'remove'.
  final String action;

  /// For an upload: the path in the bucket.
  final String? path;
  final String? contentType;
  final int size;

  /// For sign and remove: the paths asked about.
  final List<String> paths;

  /// The start of an upload's body as text (a multipart upload carries the file's own type in it).
  final String body;
}

typedef FunctionHandler = ({int status, Object? body}) Function(Map<String, dynamic> body);

/// A pretend BottlesUp website: the real Supabase client talks to it over HTTP, so a test sees exactly the requests the app makes (the address, the filters, the body) and decides
/// what comes back. Tables answer with the rows a test put in them; the filters are NOT applied (a test checks the request carried them).
class FakeWebsite {
  final Map<String, List<Map<String, dynamic>>> tables = {};
  final Map<String, FunctionHandler> functions = {};

  /// Database functions the app calls with `rpc` (`/rest/v1/rpc/<name>`).
  final Map<String, FunctionHandler> rpcs = {};
  final List<RpcRequest> rpcRequests = [];
  final List<TableRequest> tableRequests = [];
  final List<FunctionRequest> functionRequests = [];
  final List<StorageRequest> storageRequests = [];

  /// Paths storage will not sign (the website refuses them), and whether uploads fail.
  final Set<String> unsignable = {};
  bool failUploads = false;

  /// Makes every request fail with this status (a dropped connection is [networkDown]).
  int? failAllWith;

  /// Tables that answer with a failure while the others keep working.
  final Set<String> failTables = {};
  bool networkDown = false;

  /// Made when the pretend website is, because a call to a website function hands its JSON to a separate isolate: that has to start outside a widget test's fake clock
  /// (build the website in `setUp`), and a test then lets the calls finish with [settleCalls].
  late final SupabaseClient client;

  FakeWebsite() {
    client = SupabaseClient(
      'https://site.test',
      'anon-key',
      httpClient: MockClient(_handle),
      // The client's token-refresh clock would still be ticking when a screen test ends.
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
  }

  List<TableRequest> forTable(String table) => [
        for (final r in tableRequests)
          if (r.table == table) r,
      ];

  List<RpcRequest> forRpc(String name) => [
        for (final r in rpcRequests)
          if (r.name == name) r,
      ];

  List<StorageRequest> storageOf(String action) => [
        for (final r in storageRequests)
          if (r.action == action) r,
      ];

  List<FunctionRequest> forFunction(String name) => [
        for (final r in functionRequests)
          if (r.name == name) r,
      ];

  http.Response _json(http.Request request, int status, Object? body) =>
      http.Response(jsonEncode(body), status, request: request, headers: {'content-type': 'application/json'});

  Future<http.Response> _handle(http.Request request) async {
    if (networkDown) throw http.ClientException('network down');
    final segments = request.url.pathSegments;
    if (segments.length >= 4 && segments[0] == 'rest' && segments[1] == 'v1' && segments[2] == 'rpc') {
      final name = segments[3];
      final decoded = request.body.isEmpty ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(request.body) as Map);
      rpcRequests.add(RpcRequest(name, decoded));
      if (failAllWith != null) return _json(request, failAllWith!, {'message': 'failed'});
      final handler = rpcs[name];
      if (handler == null) return _json(request, 404, {'message': 'no such function $name'});
      final r = handler(decoded);
      return _json(request, r.status, r.body);
    }
    if (segments.length >= 4 && segments[0] == 'storage' && segments[1] == 'v1' && segments[2] == 'object') {
      if (failAllWith != null) return _json(request, failAllWith!, {'message': 'failed'});
      if (segments[3] == 'sign' && segments.length == 5) {
        final body = jsonDecode(request.body) as Map;
        final paths = [for (final p in body['paths'] as List) p as String];
        storageRequests.add(StorageRequest('POST', 'sign', null, null, 0, paths));
        return _json(request, 200, [
          for (final p in paths)
            unsignable.contains(p) ? {'error': 'Object not found', 'path': p, 'signedURL': null} : {'error': null, 'path': p, 'signedURL': '/object/sign/social-media/$p?token=t-$p'},
        ]);
      }
      if (request.method == 'DELETE') {
        final body = jsonDecode(request.body) as Map;
        final paths = [for (final p in body['prefixes'] as List) p as String];
        storageRequests.add(StorageRequest('DELETE', 'remove', null, null, 0, paths));
        return _json(request, 200, <Object>[]);
      }
      if (request.method == 'POST' && segments[3] == 'social-media') {
        final path = segments.sublist(4).join('/');
        storageRequests.add(StorageRequest('POST', 'upload', path, request.headers['content-type'], request.bodyBytes.length, const [], latin1.decode(request.bodyBytes.take(400).toList(), allowInvalid: true)));
        if (failUploads) return _json(request, 500, {'message': 'storage is down'});
        return _json(request, 200, {'Key': 'social-media/$path'});
      }
    }
    if (segments.length >= 3 && segments[0] == 'rest' && segments[1] == 'v1') {
      final table = segments[2];
      Object? body;
      if (request.body.isNotEmpty) body = jsonDecode(request.body);
      tableRequests.add(TableRequest(request.method, table, request.url.queryParameters, body));
      if (failAllWith != null || failTables.contains(table)) return _json(request, failAllWith ?? 500, {'message': 'failed'});
      return _json(request, 200, tables[table] ?? const []);
    }
    if (segments.length >= 3 && segments[0] == 'functions' && segments[1] == 'v1') {
      final name = segments[2];
      final decoded = request.body.isEmpty ? <String, dynamic>{} : Map<String, dynamic>.from(jsonDecode(request.body) as Map);
      functionRequests.add(FunctionRequest(name, decoded, request.headers));
      if (failAllWith != null) return _json(request, failAllWith!, {'error': 'failed'});
      final handler = functions[name];
      if (handler == null) return _json(request, 404, {'error': 'no such function $name'});
      final r = handler(decoded);
      return _json(request, r.status, r.body);
    }
    return _json(request, 404, {'message': 'unexpected ${request.method} ${request.url}'});
  }
}

// A few rows the tests share, shaped like the website's.
Map<String, dynamic> eventRow({
  String id = 'e1',
  String title = 'Friday Night',
  String start = '2099-10-24T23:00:00Z',
  String? end = '2099-10-25T05:00:00Z',
  List<Map<String, dynamic>>? tiers,
  String status = 'published',
  String? cover = 'https://img.example/cover.jpg',
  String? category = 'Nightlife',
  String venue = 'Club A',
  List<Object> lineup = const ['DJ One', {'name': 'DJ Two'}],
}) =>
    {
      'id': id,
      'title': title,
      'description': 'A big night out.',
      'venue_name': venue,
      'address': '1 King St W, Toronto',
      'start_date': start,
      'end_date': end,
      'cover_image_url': cover,
      'banner_image_url': null,
      'gallery': <String>[],
      'category': category,
      'slug': 'friday-night',
      'venue_id': 'v1',
      'lineup': lineup,
      'good_to_know': ['19+', 'ID required'],
      'organizer_name': 'Night Co',
      'organizer_bio': null,
      'organizer_verified': true,
      'tiers': tiers ?? [tierRow(eventId: id)],
    };

Map<String, dynamic> tierRow({
  String id = 't1',
  String eventId = 'e1',
  String name = 'General',
  int price = 5000,
  int capacity = 100,
  int sold = 20,
  bool code = false,
  bool nonTransferable = false,
}) =>
    {
      'id': id,
      'event_id': eventId,
      'name': name,
      'price_cents': price,
      'currency': 'cad',
      'capacity': capacity,
      'sold_count': sold,
      'requires_access_code': code,
      'is_non_transferable': nonTransferable,
    };

Map<String, dynamic> orderRow({
  String id = 'o1',
  String status = 'paid',
  int quantity = 2,
  int amount = 10000,
  String? code = 'BU-ABCD2345',
  String created = '2099-10-20T12:00:00Z',
  String? checkedIn,
  bool nonTransferable = false,
  String eventStart = '2099-10-24T23:00:00Z',
  String? eventEnd = '2099-10-25T05:00:00Z',
}) =>
    {
      'id': id,
      'status': status,
      'quantity': quantity,
      'amount_total_cents': amount,
      'currency': 'cad',
      'discount_cents': 0,
      'ticket_code': code,
      'checked_in_at': checkedIn,
      'created_at': created,
      'is_non_transferable': nonTransferable,
      'site_ticket_tiers': {'name': 'General'},
      'site_events': {
        'id': 'e1',
        'title': 'Friday Night',
        'venue_name': 'Club A',
        'address': '1 King St W, Toronto',
        'start_date': eventStart,
        'end_date': eventEnd,
        'cover_image_url': null,
      },
    };

Map<String, dynamic> venueRow({
  String id = 'v1',
  String name = 'Club A',
  String mode = 'pay_ahead',
  bool credit = false,
  int taxBps = 1300,
  String? start,
  String? end,
  List<Map<String, dynamic>>? tables,
  List<Map<String, dynamic>>? slots,
  String? cover,
}) =>
    {
      'id': id,
      'name': name,
      'slug': 'club-a',
      'description': 'The best room in town.',
      'address': '1 King St W, Toronto',
      'cover_image_url': cover,
      'gallery': <String>[],
      'category': 'Club',
      'phone': '416-555-0199',
      'website_url': null,
      'hours_note': 'Thu to Sat, 10pm to 3am',
      'dress_code': 'Smart casual',
      'capacity': 400,
      'music_genres': 'House, Hip hop',
      'tax_rate_bps': taxBps,
      'show_bottle_images': true,
      'bottle_payment_mode': mode,
      'deposit_is_credit': credit,
      'booking_start_date': start,
      'booking_end_date': end,
      'site_table_types': tables ?? [tableTypeRow(venueId: id)],
      'site_venue_time_slots': slots ?? [slotRow(venueId: id)],
    };

Map<String, dynamic> tableTypeRow({
  String id = 'tt1',
  String venueId = 'v1',
  String name = 'Booth 1',
  int maxGuests = 6,
  int minSpend = 50000,
  int deposit = 10000,
  int inventory = 1,
  String mode = 'flat',
  int? rate,
  int? minHours,
  String? floorId,
  double? x,
  double? y,
  int sort = 0,
}) =>
    {
      'id': id,
      'venue_id': venueId,
      'name': name,
      'description': 'Right by the DJ.',
      'max_guests': maxGuests,
      'min_guests': null,
      'min_spend_cents': minSpend,
      'deposit_cents': deposit,
      'currency': 'cad',
      'inventory_count': inventory,
      'image_url': null,
      'badge_label': null,
      'is_featured': false,
      'floor_id': floorId,
      'pos_x': x,
      'pos_y': y,
      'width': x == null ? null : 10.0,
      'height': y == null ? null : 8.0,
      'pricing_mode': mode,
      'hourly_rate_cents': rate,
      'min_hours': minHours,
      'table_view': null,
      'privacy_level': null,
      'seating_type': null,
      'amenities': null,
      'policy_note': null,
      'included_admissions': null,
      'sort_order': sort,
    };

/// A Friday (5) at 10pm unless said otherwise. 0 = Sunday ... 6 = Saturday.
Map<String, dynamic> slotRow({String id = 's1', String venueId = 'v1', int day = 5, String time = '22:00:00', String? label}) =>
    {'id': id, 'venue_id': venueId, 'day_of_week': day, 'start_time': time, 'label': label};

Map<String, dynamic> bottleRow({String id = 'b1', String venueId = 'v1', String name = 'Grey Goose', String? size = '1.75L', int price = 25000, bool available = true, bool soldOut = false, int sort = 0}) => {
      'id': id,
      'venue_id': venueId,
      'name': name,
      'size': size,
      'description': null,
      'price_cents': price,
      'currency': 'cad',
      'category': 'Vodka',
      'image_url': null,
      'is_available': available,
      'is_sold_out': soldOut,
      'sort_order': sort,
    };

Map<String, dynamic> floorRow({String id = 'f1', String venueId = 'v1', String label = 'Main floor', int sort = 0}) =>
    {'id': id, 'venue_id': venueId, 'label': label, 'image_url': 'https://img.example/floor.png', 'sort_order': sort};

/// What `site-booking-status` answers for a paid table booking.
Map<String, dynamic> paidBookingAnswer({String code = 'TB-ABCD2345', int deposit = 10000, int bottles = 0, int due = 0, int paid = 11300}) => {
      'status': 'paid',
      'booking': {
        'confirmationCode': code,
        'customerName': 'Dana Lee',
        'customerEmail': 'dana@example.com',
        'guestCount': 4,
        'tableTypeName': 'Booth 1',
        'venueName': 'Club A',
        'bookingDate': '2099-11-07',
        'startTime': '22:00:00',
        'depositCents': deposit,
        'bottleSubtotalCents': bottles,
        'taxCents': 1300,
        'bottlesupFeeCents': 0,
        'discountCents': 0,
        'totalCents': paid + due,
        'paidNowCents': paid,
        'dueAtVenueCents': due,
        'currency': 'cad',
        'bottles': bottles == 0
            ? <Object>[]
            : [
                {'name': 'Grey Goose', 'size': '1.75L', 'quantity': 1, 'unitPriceCents': bottles, 'lineTotalCents': bottles, 'paymentStatus': due > 0 ? 'due_at_venue' : 'paid'},
              ],
      },
    };

/// A row of `site_table_bookings` as the customer's own read returns it, with the table, venue and time embedded.
Map<String, dynamic> bookingRow({
  String id = 'bk1',
  String status = 'paid',
  String? code = 'TB-ABCD2345',
  int guests = 4,
  String date = '2099-11-06',
  String time = '22:00:00',
  String? slotLabel,
  int deposit = 10000,
  int bottles = 0,
  int tax = 1300,
  int fee = 0,
  int discount = 0,
  int total = 11300,
  int paid = 11300,
  String tableName = 'Booth 1',
  String venueName = 'Club A',
  String? checkedIn,
  String? cancelledAt,
  String? cancelReason,
  String created = '2099-10-20T12:00:00Z',
  int? hours,
  String choice = 'pay_ahead',
}) =>
    {
      'id': id,
      'status': status,
      'confirmation_code': code,
      'guest_count': guests,
      'hours': hours,
      'booking_date': date,
      'venue_id': 'v1',
      'deposit_cents': deposit,
      'bottle_subtotal_cents': bottles,
      'tax_cents': tax,
      'bottlesup_fee_cents': fee,
      'discount_cents': discount,
      'amount_total_cents': total,
      'amount_paid_cents': paid,
      'currency': 'cad',
      'bottle_payment_choice': choice,
      'checked_in_at': checkedIn,
      'cancelled_at': cancelledAt,
      'cancellation_reason': cancelReason,
      'created_at': created,
      'site_table_types': {'name': tableName},
      'site_venues': {'name': venueName, 'address': '1 King St W, Toronto', 'phone': '416-555-0199'},
      'site_venue_time_slots': {'start_time': time, 'label': slotLabel},
    };

Map<String, dynamic> bottleLineRow({String id = 'l1', String name = 'Grey Goose', String? size = '1.75L', int qty = 1, int unit = 25000, String payment = 'paid', bool addon = false, String? cancelledAt, String service = 'awaiting_prep', int delivered = 0}) => {
      'id': id,
      'bottle_name': name,
      'size': size,
      'quantity': qty,
      'unit_price_cents': unit,
      'line_total_cents': unit * qty,
      'payment_status': payment,
      'is_addon': addon,
      'cancelled_at': cancelledAt,
      'service_status': service,
      'delivered_quantity': delivered,
      'created_at': '2099-10-20T12:01:00Z',
    };

Map<String, dynamic> clubPaymentRow({String id = 'cp1', String token = 'tok-1', int billed = 25000, int paid = 25000, String method = 'debit'}) =>
    {'id': id, 'confirm_token': token, 'billed_amount_cents': billed, 'amount_paid_cents': paid, 'payment_method': method};

Map<String, dynamic> bookingRefundRow({String type = 'full', int amount = 11300, String reason = 'Cancelled by the guest', String at = '2099-10-25T10:00:00Z'}) =>
    {'refund_type': type, 'amount_cents': amount, 'reason': reason, 'recorded_at': at};

/// A pending bottle replacement as the customer's own read returns it.
Map<String, dynamic> substitutionRow({String id = 's1', String lineId = 'l1', String reason = 'Out of stock tonight', String name = 'Belvedere', String? size = '1.75L', int diff = 2000, String token = 'sub-tok-1', String status = 'pending'}) => {
      'id': id,
      'bottle_line_id': lineId,
      'reason': reason,
      'replacement_bottle_name': name,
      'replacement_size': size,
      'price_diff_cents': diff,
      'status': status,
      'confirm_token': token,
    };

/// What `manage-guest-tickets` answers to `list`.
Map<String, dynamic> rosterAnswer({int max = 6, int remaining = 4, List<Map<String, dynamic>>? guests}) => {
      'booking': {'customerName': 'Dana Lee', 'venueName': 'Club A', 'tableTypeName': 'Booth 1', 'maxGuests': max, 'remainingCapacity': remaining},
      'guests': guests ?? [guestRow()],
    };

Map<String, dynamic> guestRow({String id = 'g1', String name = 'Sam Park', String email = 'sam@example.com', String? sent = '2099-10-21T10:00:00Z', String? checkedIn}) => {'id': id, 'guest_name': name, 'guest_email': email, 'ticket_sent_at': sent, 'checked_in_at': checkedIn};

/// A profile as the website's `profile_card` shows it. [follow] is 'none', 'active' or 'pending'.
Map<String, dynamic> profileRow({
  String id = 'p1',
  String kind = 'personal',
  String handle = 'dana',
  String? name = 'Dana Lee',
  String? category,
  String? bio,
  String? city = 'Toronto',
  String? avatar,
  String? cover,
  String privacy = 'public',
  String status = 'active',
  bool verified = false,
  int followers = 0,
  int following = 0,
  bool mine = false,
  String follow = 'none',
  bool followsMe = false,
  bool blocked = false,
  bool canSee = true,
  List<String> interests = const [],
  Map<String, dynamic> links = const {},
  Map<String, dynamic> extra = const {},
}) =>
    {
      'id': id,
      'kind': kind,
      'handle': handle,
      'display_name': name,
      'category': category,
      'bio': bio,
      'city': city,
      'avatar_url': avatar,
      'cover_url': cover,
      'social_links': links,
      'privacy': privacy,
      'status': status,
      'verified': verified,
      'interests': interests,
      'followers': followers,
      'following': following,
      'is_mine': mine,
      'relation': {'follow': follow, 'follows_me': followsMe, 'blocked': blocked},
      'can_see_content': canSee,
      ...extra,
    };

/// The answer of an rpc that returns a value or a list.
({int status, Object? body}) ok(Object? body) => (status: 200, body: body);

/// What the database says when a function raises a sentence (`raise exception '...'`): PostgREST answers 400 with code P0001.
({int status, Object? body}) raised(String sentence) => (status: 400, body: {'code': 'P0001', 'message': sentence, 'details': null, 'hint': null});

/// A media item of a post.
Map<String, dynamic> mediaRow({String id = 'm1', int position = 0, String type = 'image', String path = 'author/file.jpg', String? poster, int? width = 1080, int? height = 1350, int? durationMs}) =>
    {'id': id, 'position': position, 'type': type, 'path': path, 'poster_path': poster, 'width': width, 'height': height, 'duration_ms': durationMs};

/// A post as the website's `post_card` shows it.
Map<String, dynamic> postRow({
  String id = 'post1',
  String kind = 'post',
  String? caption = 'Friday vibes',
  String audience = 'public',
  bool comments = true,
  String createdAt = '2099-10-24T22:00:00Z',
  String? expiresAt,
  Map<String, dynamic>? author,
  List<Map<String, dynamic>>? media,
  List<Map<String, dynamic>> tags = const [],
  int likes = 0,
  int commentCount = 0,
  bool liked = false,
  bool saved = false,
  bool mine = false,
  Map<String, dynamic> extra = const {},
}) =>
    {
      'id': id,
      'kind': kind,
      'caption': caption,
      'audience': audience,
      'comments_enabled': comments,
      'created_at': createdAt,
      'expires_at': expiresAt,
      'author': author ?? profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'),
      'media': media ?? [mediaRow(path: 'a1/$id.jpg')],
      'tags': tags,
      'likes': likes,
      'comments': commentCount,
      'liked': liked,
      'saved': saved,
      'is_mine': mine,
      ...extra,
    };

Map<String, dynamic> commentRow({String id = 'c1', String post = 'post1', String? replyTo, String body = 'Great night!', String createdAt = '2099-10-24T23:00:00Z', Map<String, dynamic>? author, int replies = 0, bool mine = false, bool canDelete = false}) => {
      'id': id,
      'post': post,
      'reply_to': replyTo,
      'body': body,
      'created_at': createdAt,
      'author': author ?? profileRow(id: 'b1', handle: 'bob', name: 'Bob Ray'),
      'replies': replies,
      'is_mine': mine,
      'can_delete': canDelete,
    };

Map<String, dynamic> railRow({Map<String, dynamic>? profile, String latest = '2099-10-24T23:00:00Z', bool unseen = true, bool membersOnly = false, int count = 1, bool mine = false}) =>
    {'profile': profile ?? profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'), 'latest_at': latest, 'unseen': unseen, 'members_only': membersOnly, 'count': count, 'is_mine': mine};

/// A review as the website's `review_card` shows it.
Map<String, dynamic> reviewRow({
  String id = 'r1',
  String kind = 'venue',
  int rating = 4,
  String? body = 'Great night, slow bar.',
  String createdAt = '2099-10-24T23:00:00Z',
  Map<String, dynamic>? author,
  bool mine = false,
  bool canReply = false,
  Map<String, dynamic>? reply,
}) =>
    {
      'id': id,
      'kind': kind,
      'rating': rating,
      'body': body,
      'created_at': createdAt,
      'updated_at': createdAt,
      'author': author ?? profileRow(id: 'u1', handle: 'ann', name: 'Ann Lee'),
      'is_mine': mine,
      'can_reply': canReply,
      'reply': reply,
    };

Map<String, dynamic> reviewsPage({List<Map<String, dynamic>> items = const [], int count = 0, double average = 0, List<int> stars = const [0, 0, 0, 0, 0]}) => {
      'summary': {'count': count, 'average': average, 'stars': stars},
      'items': items,
    };

/// A conversation as the website's inbox lists it.
Map<String, dynamic> convRow({
  String id = 'c1',
  String kind = 'direct',
  String? title,
  String status = 'active',
  bool muted = false,
  String lastAt = '2099-10-24T23:00:00Z',
  int members = 2,
  List<Map<String, dynamic>>? others,
  Map<String, dynamic>? last,
  int unread = 0,
  String? bookingId,
}) =>
    {
      'id': id,
      'kind': kind,
      'title': title,
      'booking_id': bookingId,
      'status': status,
      'muted': muted,
      'last_message_at': lastAt,
      'member_count': members,
      'others': others ?? [profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray')],
      'last': last ?? {'kind': 'text', 'body': 'See you there', 'removed': false, 'created_at': lastAt, 'sender': profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray'), 'is_mine': false},
      'unread': unread,
    };

/// A message as the website's `dm_message_card` shows it.
Map<String, dynamic> dmRow({
  String id = 'm1',
  String conversation = 'c1',
  String kind = 'text',
  String? body = 'Hello',
  bool removed = false,
  String createdAt = '2099-10-24T23:00:00Z',
  Map<String, dynamic>? sender,
  bool mine = false,
  Map<String, dynamic>? ref,
}) =>
    {
      'id': id,
      'conversation': conversation,
      'kind': kind,
      'body': body,
      'removed': removed,
      'created_at': createdAt,
      'sender': sender ?? (mine ? profileRow(id: 'me', handle: 'dana', name: 'Dana Lee') : profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray')),
      'is_mine': mine,
      'ref': ref,
    };

Map<String, dynamic> notificationRow({String id = 'n1', String kind = 'like', String createdAt = '2099-10-24T23:00:00Z', Map<String, dynamic>? actor, bool read = false, Map<String, dynamic>? post, String? commentBody, bool followsBack = false}) => {
      'id': id,
      'kind': kind,
      'created_at': createdAt,
      'read': read,
      'actor': actor ?? profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray'),
      'post': post,
      'comment_body': commentBody,
      'review_id': null,
      'follows_back': followsBack,
    };

/// One friend's share as the host's card lists it (`split_card`).
Map<String, dynamic> shareLineRow({String id = 'sh1', Map<String, dynamic>? payer, int amount = 5000, String status = 'unpaid', String? paidAt}) =>
    {'id': id, 'payer': payer ?? profileRow(id: 'p-bob', handle: 'bob', name: 'Bob Ray'), 'amount_cents': amount, 'status': status, 'paid_at': paidAt};

/// A split as its host sees it (`split_for_booking`, `split_create`, `split_cancel`).
Map<String, dynamic> splitPlanRow({
  String id = 'sp1',
  String booking = 'bk1',
  String state = 'open',
  String deadline = '2099-11-05T22:00:00Z',
  int balance = 20000,
  int collected = 0,
  int outstanding = 10000,
  List<Map<String, dynamic>>? shares,
}) =>
    {
      'id': id,
      'booking_id': booking,
      'state': state,
      'deadline': deadline,
      'currency': 'cad',
      'balance_cents': balance,
      'collected_cents': collected,
      'outstanding_cents': outstanding,
      'shares': shares ?? [shareLineRow(id: 'sh1'), shareLineRow(id: 'sh2', payer: profileRow(id: 'p-cy', handle: 'cy', name: 'Cy Rus'))],
      'created_at': '2099-11-01T12:00:00Z',
    };

/// A request to pay a share as the friend sees it (`split_my_shares`).
Map<String, dynamic> shareRequestRow({
  String id = 'sh1',
  String state = 'unpaid',
  int amount = 5000,
  String deadline = '2099-11-05T22:00:00Z',
  String host = 'Ann',
  String venue = 'Club A',
  String date = '2099-11-06',
  String time = '22:00',
  String? paidAt,
}) =>
    {'id': id, 'state': state, 'amount_cents': amount, 'currency': 'cad', 'deadline': deadline, 'host': host, 'venue': venue, 'booking_date': date, 'start_time': time, 'paid_at': paidAt};

/// A service a professional lists (`pro_services_of`).
Map<String, dynamic> proServiceRow({String id = 'sv1', String title = 'Wedding DJ set', String? description = 'Four hours with lights', int? from = 100000, String? note = 'from', bool active = true}) =>
    {'id': id, 'title': title, 'description': description, 'from_cents': from, 'price_note': note, 'active': active};

/// A quote as it sits on a request.
Map<String, dynamic> proQuoteRow({String id = 'q1', int total = 100000, int deposit = 30000, String? due = '2099-11-01', String scope = 'Four hours of music, lights and sound', String valid = '2099-10-30T12:00:00Z', String status = 'sent'}) =>
    {'id': id, 'total_cents': total, 'deposit_cents': deposit, 'balance_due_by': deposit >= total ? null : due, 'scope': scope, 'valid_until': valid, 'status': status, 'created_at': '2099-10-25T12:00:00Z'};

/// A booking with a professional, from either side: pass [net] to see it as the professional does.
Map<String, dynamic> proBookingRow({
  String id = 'pb1',
  String request = 'pr1',
  String state = 'awaiting_deposit',
  String title = 'Wedding DJ set',
  String date = '2099-11-08',
  int total = 100000,
  int deposit = 30000,
  int paid = 0,
  String? due = '2099-11-01',
  String? payBy = '2099-10-26T12:00:00Z',
  String? doneAt,
  String? cancelledBy,
  String? cancelReason,
  int freeDays = 7,
  Map<String, dynamic>? provider,
  Map<String, dynamic>? client,
  int? net,
  Map<String, dynamic>? dispute,
}) =>
    {
      'id': id,
      'request_id': request,
      'state': state,
      'title': title,
      'event_date': date,
      'currency': 'cad',
      'total_cents': total,
      'deposit_cents': deposit,
      'balance_due_by': deposit >= total ? null : due,
      'paid_cents': paid,
      'owed_cents': total - paid,
      'pay_by': payBy,
      'provider_done_at': doneAt,
      'completed_at': null,
      'cancelled_by': cancelledBy,
      'cancel_reason': cancelReason,
      'free_cancel_days': freeDays,
      'provider': provider ?? profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: 'dj'),
      'client': client,
      'net_cents': net,
      'commission_bps': net == null ? null : 500,
      'dispute': dispute,
      'created_at': '2099-10-25T12:00:00Z',
    };

/// A request to hire a professional (`pro_request_get` and the lists). Pass [client] to see it as the professional does.
Map<String, dynamic> proRequestRow({
  String id = 'pr1',
  String status = 'requested',
  String date = '2099-11-08',
  String message = 'A birthday night for 120',
  String? timeNote = '9pm to 1am',
  String? location = 'Club A',
  int? guests = 120,
  int? budget = 150000,
  String? declineNote,
  Map<String, dynamic>? service = const {'id': 'sv1', 'title': 'Wedding DJ set'},
  Map<String, dynamic>? provider,
  Map<String, dynamic>? client,
  Map<String, dynamic>? quote,
  Map<String, dynamic>? booking,
}) =>
    {
      'id': id,
      'status': status,
      'event_date': date,
      'time_note': timeNote,
      'location': location,
      'guests': guests,
      'message': message,
      'budget_cents': budget,
      'decline_note': declineNote,
      'created_at': '2099-10-24T12:00:00Z',
      'service': service,
      'provider': provider ?? profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: 'dj'),
      'client': client,
      'quote': quote,
      'booking': booking,
    };
