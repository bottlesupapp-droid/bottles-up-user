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

  /// Makes every request fail with this status (a dropped connection is [networkDown]).
  int? failAllWith;
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
    if (segments.length >= 3 && segments[0] == 'rest' && segments[1] == 'v1') {
      final table = segments[2];
      Object? body;
      if (request.body.isNotEmpty) body = jsonDecode(request.body);
      tableRequests.add(TableRequest(request.method, table, request.url.queryParameters, body));
      if (failAllWith != null) return _json(request, failAllWith!, {'message': 'failed'});
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
      'site_venues': {'name': venueName, 'address': '1 King St W, Toronto'},
      'site_venue_time_slots': {'start_time': time, 'label': slotLabel},
    };

Map<String, dynamic> bottleLineRow({String id = 'l1', String name = 'Grey Goose', String? size = '1.75L', int qty = 1, int unit = 25000, String payment = 'paid', bool addon = false, String? cancelledAt}) => {
      'id': id,
      'bottle_name': name,
      'size': size,
      'quantity': qty,
      'unit_price_cents': unit,
      'line_total_cents': unit * qty,
      'payment_status': payment,
      'is_addon': addon,
      'cancelled_at': cancelledAt,
      'created_at': '2099-10-20T12:01:00Z',
    };

Map<String, dynamic> clubPaymentRow({String id = 'cp1', String token = 'tok-1', int billed = 25000, int paid = 25000, String method = 'debit'}) =>
    {'id': id, 'confirm_token': token, 'billed_amount_cents': billed, 'amount_paid_cents': paid, 'payment_method': method};

Map<String, dynamic> bookingRefundRow({String type = 'full', int amount = 11300, String reason = 'Cancelled by the guest', String at = '2099-10-25T10:00:00Z'}) =>
    {'refund_type': type, 'amount_cents': amount, 'reason': reason, 'recorded_at': at};
