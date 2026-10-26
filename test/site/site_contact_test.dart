import 'package:bottles_up_user/site/models/site_contact.dart';
import 'package:bottles_up_user/site/services/site_contact_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('the contact row', () {
    test('everything the team set is read, and nothing else', () {
      final c = parseSiteContact({
        'contact_email': ' help@bottlesupapp.com ',
        'contact_phone': '+1 (416) 555-0100',
        'address': '1 King St W, Toronto',
        'social_instagram': 'https://instagram.com/bottlesup',
        'social_facebook': 'javascript:alert(1)',
        'social_twitter': null,
        'social_linkedin': '  ',
      });
      expect([c.email, c.phone, c.address, c.hasEmail, c.hasPhone, c.isEmpty], ['help@bottlesupapp.com', '+1 (416) 555-0100', '1 King St W, Toronto', true, true, false]);
      expect(c.socials.map((s) => (s.name, s.url.toString())), [('Instagram', 'https://instagram.com/bottlesup')], reason: 'only real web addresses are opened');
    });

    test('a row with nothing set, or no row, is empty', () {
      expect(parseSiteContact(null).isEmpty, isTrue);
      expect(parseSiteContact({'contact_email': '', 'contact_phone': null, 'address': ' '}).isEmpty, isTrue);
    });

    test('an e-mail that is not an e-mail, and a phone number too short to be one, are not offered', () {
      final c = parseSiteContact({'contact_email': 'not an email', 'contact_phone': '12345'});
      expect([c.email, c.hasEmail, c.hasPhone, c.isEmpty], [null, false, false, true]);
    });

    test('a phone number becomes a tel: link with digits and a leading plus only', () {
      expect(telUri('+1 (416) 555-0100').toString(), 'tel:+14165550100');
      expect(telUri('416-555-0100').toString(), 'tel:4165550100');
      expect(telUri('555'), isNull);
      expect(telUri('1' * 20), isNull);
    });

    test('a message to BottlesUp is a mail link with the subject and body encoded, and who it is from; nothing is sent from the app', () {
      final u = supportMailto('help@bottlesupapp.com', subject: 'Copy of my data', message: 'Please send it.', from: 'dana@example.com');
      expect(u.scheme, 'mailto');
      expect(u.path, 'help@bottlesupapp.com');
      expect(u.toString(), contains('subject=Copy%20of%20my%20data'));
      expect(Uri.decodeComponent(u.query.split('&body=')[1]), 'Please send it.\n\nAccount e-mail: dana@example.com');
      expect(supportMailto('a@b.co', subject: 'S', message: 'M').query, 'subject=S&body=M');
    });

    test('only web addresses count as web addresses', () {
      expect(webUri('https://x.example/page')?.host, 'x.example');
      expect(webUri('http://x.example'), isNotNull);
      for (final bad in ['javascript:alert(1)', 'x.example', 'ftp://x.example', 'https://', null, ' ']) {
        expect(webUri(bad), isNull, reason: '$bad');
      }
    });
  });

  group('the service', () {
    late FakeWebsite site;
    setUp(() => site = FakeWebsite());

    test('reads the one public row of site settings', () async {
      site.tables['site_content'] = [
        {'contact_email': 'help@bottlesupapp.com', 'contact_phone': null, 'address': null}
      ];
      final c = await SiteContactService(site.client).load();
      final r = site.forTable('site_content').single;
      expect([r.query['id'], r.query['select']], ['eq.1', allOf(contains('contact_email'), contains('contact_phone'), contains('address'), contains('social_instagram'))]);
      expect(c.email, 'help@bottlesupapp.com');
    });

    test('no row is nothing set, not a failure; a failure to read is a plain sentence', () async {
      site.tables['site_content'] = [];
      expect((await SiteContactService(site.client).load()).isEmpty, isTrue);
      site.failAllWith = 500;
      await expectLater(SiteContactService(site.client).load(), throwsA(isA<SiteException>().having((e) => e.message, 'message', 'We could not load the contact details. Check your connection and try again.')));
    });
  });
}
