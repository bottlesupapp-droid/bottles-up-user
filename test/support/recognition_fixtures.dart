import 'fake_website.dart';

Map<String, dynamic> levelRow({String key = 'elite', String name = 'Elite', int min = 100000, String colour = '#2E9E5B', bool plaque = false}) =>
    {'key': key, 'name': name, 'min_followers': min, 'colour': colour, 'plaque': plaque};

Map<String, dynamic> verificationRow({bool verified = false, String? via, bool orgRun = false, Map<String, dynamic>? request}) => {'verified': verified, 'via': via, 'org_run': orgRun, 'request': request};

Map<String, dynamic> requestRow({String id = 'vr1', String state = 'requested', String? note = 'I am a radio host.', String? reason, String? retryOn}) =>
    {'id': id, 'state': state, 'note': note, 'reason': reason, 'created_at': '2026-11-02T10:00:00Z', 'decided_at': null, 'retry_on': retryOn};

Map<String, dynamic> rankStatusRow({
  bool verified = true,
  String? rank = 'verified',
  int followers = 120000,
  Map<String, dynamic>? next,
  Map<String, dynamic>? target,
  bool canRequest = true,
  Map<String, dynamic>? pending,
  Map<String, dynamic>? rejected,
}) =>
    {
      'verified': verified,
      'rank': rank,
      'followers': followers,
      'next': next ?? {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'},
      'target': target,
      'can_request': canRequest,
      'pending': pending,
      'rejected': rejected,
    };

Map<String, dynamic> awardRow({String id = 'aw1', String level = 'elite', String name = 'Elite', String colour = '#2E9E5B', bool plaque = false}) =>
    {'id': id, 'level': level, 'name': name, 'colour': colour, 'awarded_at': '2026-11-03T10:00:00Z', 'plaque': plaque};

Map<String, dynamic> plaqueRow({String id = 'pq1', String state = 'requested', bool removed = false, String? carrier, String? tracking}) => {
      'id': id,
      'award': 'aw1',
      'level': 'icon',
      'level_name': 'Icon',
      'state': state,
      'recipient': removed ? null : 'Ann Lee',
      'line1': removed ? null : '1 King St W',
      'line2': removed ? null : 'Unit 4',
      'city': removed ? null : 'Toronto',
      'region': removed ? null : 'ON',
      'postal': removed ? null : 'M5V 1A1',
      'country': removed ? null : 'Canada',
      'phone': null,
      'carrier': carrier,
      'tracking': tracking,
      'address_removed': removed,
    };

Map<String, dynamic> jobRow({
  String id = 'job1',
  String title = 'Weekend bartender',
  String kind = 'part_time',
  String status = 'open',
  bool open = true,
  String deadline = '2099-12-01',
  bool remote = false,
  String? location = 'Toronto',
  bool mine = false,
  int? applications,
  int? waiting,
  Map<String, dynamic>? applied,
}) =>
    {
      'id': id,
      'title': title,
      'kind': kind,
      'description': 'We need an experienced bartender for weekends.',
      'requirements': 'Two years behind a bar.',
      'compensation': '\$20 an hour plus tips',
      'location': location,
      'remote': remote,
      'schedule': 'Fri and Sat nights',
      'deadline': deadline,
      'status': status,
      'created_at': '2026-11-02T10:00:00Z',
      'open': open,
      'poster': profileRow(id: 'p-club', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue'),
      'mine': mine,
      'applications': applications,
      'waiting': waiting,
      'applied': applied,
    };

Map<String, dynamic> applicationRow({String id = 'ap1', String state = 'sent', String? reply, String? link = 'https://example.com/me', Map<String, dynamic>? job}) => {
      'id': id,
      'state': state,
      'message': 'I have worked many bars in Toronto.',
      'link': link,
      'reply': reply,
      'created_at': '2026-11-03T10:00:00Z',
      'decided_at': null,
      'applicant': profileRow(id: 'p-bob', handle: 'bob', name: 'Bob Ray'),
      'job': job ??
          {
            'id': 'job1',
            'title': 'Weekend bartender',
            'kind': 'part_time',
            'status': 'open',
            'deadline': '2099-12-01',
            'open': true,
            'poster': profileRow(id: 'p-club', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue'),
          },
    };
