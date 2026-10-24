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

typedef FunctionHandler = ({int status, Object? body}) Function(Map<String, dynamic> body);

/// A pretend BottlesUp website: the real Supabase client talks to it over HTTP, so a test sees exactly the requests the app makes (the address, the filters, the body) and decides
/// what comes back. Tables answer with the rows a test put in them; the filters are NOT applied (a test checks the request carried them).
class FakeWebsite {
  FakeWebsite();

  final Map<String, List<Map<String, dynamic>>> tables = {};
  final Map<String, FunctionHandler> functions = {};
  final List<TableRequest> tableRequests = [];
  final List<FunctionRequest> functionRequests = [];

  /// Makes every request fail with this status (a dropped connection is [networkDown]).
  int? failAllWith;
  bool networkDown = false;

  late final SupabaseClient client = SupabaseClient('https://site.test', 'anon-key', httpClient: MockClient(_handle));

  List<TableRequest> forTable(String table) => [
        for (final r in tableRequests)
          if (r.table == table) r,
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
}) =>
    {
      'id': id,
      'title': title,
      'description': 'A big night out.',
      'venue_name': 'Club A',
      'address': '1 King St W, Toronto',
      'start_date': start,
      'end_date': end,
      'cover_image_url': 'https://img.example/cover.jpg',
      'banner_image_url': null,
      'gallery': <String>[],
      'category': 'Nightlife',
      'slug': 'friday-night',
      'venue_id': 'v1',
      'lineup': ['DJ One', {'name': 'DJ Two'}],
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
