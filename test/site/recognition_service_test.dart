import 'package:bottles_up_user/site/models/recognition.dart';
import 'package:bottles_up_user/site/services/recognition_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/recognition_fixtures.dart';

void main() {
  late FakeWebsite site;
  late RecognitionService service;

  setUp(() {
    site = FakeWebsite();
    service = RecognitionService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));
  Matcher generic() => throwsA(isA<SiteException>());

  test('the ranks are asked for with nothing and read in order', () async {
    site.rpcs['rank_levels'] = (_) => ok([levelRow(key: 'verified', name: 'Verified', min: 0), levelRow()]);
    final l = await service.levels();
    expect(l.map((x) => x.key), ['verified', 'elite']);
    expect(site.forRpc('rank_levels').single.body, <String, dynamic>{});
  });

  group('verification', () {
    test('the standing of a profile is asked for that profile', () async {
      site.rpcs['verification_status'] = (_) => ok(verificationRow(request: requestRow()));
      final v = await service.verification('p-ann');
      expect(v.request!.isWaiting, isTrue);
      expect(site.forRpc('verification_status').single.body, {'p_profile': 'p-ann'});
      site.rpcs['verification_status'] = (_) => ok('nonsense');
      await expectLater(service.verification('p-ann'), sentence('We could not read the answer.'));
      site.rpcs['verification_status'] = (_) => raised('This profile is not available.');
      await expectLater(service.verification('p-ann'), sentence('This profile is not available.'));
    });

    test('a request carries the note trimmed, and none when there are no words', () async {
      site.rpcs['verification_request'] = (_) => ok(verificationRow(request: requestRow()));
      await service.requestVerification(profile: 'p-ann', note: '  I am a radio host.  ');
      await service.requestVerification(profile: 'p-ann', note: '   ');
      await service.requestVerification(profile: 'p-ann');
      final sent = site.forRpc('verification_request');
      expect(sent[0].body, {'p_profile': 'p-ann', 'p_note': 'I am a radio host.'});
      expect(sent[1].body, {'p_profile': 'p-ann', 'p_note': null});
      expect(sent[2].body, {'p_profile': 'p-ann', 'p_note': null});
    });

    test('a refused request is its sentence, and an unreadable answer is an error', () async {
      site.rpcs['verification_request'] = (_) => raised('Your request is already waiting for a decision.');
      await expectLater(service.requestVerification(profile: 'p'), sentence('Your request is already waiting for a decision.'));
      site.rpcs['verification_request'] = (_) => ok(null);
      await expectLater(service.requestVerification(profile: 'p'), generic());
    });
  });

  group('ranks', () {
    test('the standing is asked for the profile', () async {
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow());
      expect((await service.rankStatus('p-ann')).followers, 120000);
      expect(site.forRpc('rank_status').single.body, {'p_profile': 'p-ann'});
      site.rpcs['rank_status'] = (_) => ok(<String, Object>{});
      await expectLater(service.rankStatus('p-ann'), sentence('We could not read the answer.'));
    });

    test('a review is asked for, and a refusal is its sentence', () async {
      site.rpcs['rank_request'] = (_) => ok(rankStatusRow(canRequest: false, pending: {'id': 'r1', 'level': 'elite', 'created_at': '2026-11-02T10:00:00Z'}));
      expect((await service.requestRank('p-ann')).isWaiting, isTrue);
      expect(site.forRpc('rank_request').single.body, {'p_profile': 'p-ann'});
      site.rpcs['rank_request'] = (_) => raised('You have not reached the next level yet.');
      await expectLater(service.requestRank('p-ann'), sentence('You have not reached the next level yet.'));
      site.rpcs['rank_request'] = (_) => ok(null);
      await expectLater(service.requestRank('p-ann'), generic());
    });

    test('the awards of a profile are asked for as the profile the person acts as', () async {
      site.rpcs['awards_of'] = (_) => ok([awardRow()]);
      expect((await service.awards(actor: 'p-me', profile: 'p-ann')).single.name, 'Elite');
      expect(site.forRpc('awards_of').single.body, {'p_actor': 'p-me', 'p_profile': 'p-ann'});
    });
  });

  group('plaques', () {
    const address = PlaqueAddress(recipient: ' Ann Lee ', line1: ' 1 King St W ', line2: ' Unit 4 ', city: ' Toronto ', region: ' ON ', postal: ' M5V 1A1 ', country: ' Canada ', phone: ' 555 0100 ');

    test('the plaques of a profile are asked for', () async {
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow(), plaqueRow(id: 'pq2', state: 'delivered', removed: true)]);
      final p = await service.plaques('p-ann');
      expect(p.map((x) => x.id), ['pq1', 'pq2']);
      expect(site.forRpc('plaques_mine').single.body, {'p_profile': 'p-ann'});
    });

    test('a plaque is asked for with the address trimmed, and what is left blank is not sent', () async {
      site.rpcs['plaque_claim'] = (_) => ok(plaqueRow());
      await service.claimPlaque(award: 'aw1', address: address);
      await service.claimPlaque(award: 'aw1', address: const PlaqueAddress(recipient: 'Ann Lee', line1: '1 King St', line2: '  ', city: 'Toronto', region: '', postal: 'M5V', country: 'Canada'));
      final sent = site.forRpc('plaque_claim');
      expect(sent[0].body, {
        'p_award': 'aw1', 'p_recipient': 'Ann Lee', 'p_line1': '1 King St W', 'p_line2': 'Unit 4', 'p_city': 'Toronto', 'p_region': 'ON', 'p_postal': 'M5V 1A1', 'p_country': 'Canada', 'p_phone': '555 0100',
      });
      expect(sent[1].body, {'p_award': 'aw1', 'p_recipient': 'Ann Lee', 'p_line1': '1 King St', 'p_line2': null, 'p_city': 'Toronto', 'p_region': null, 'p_postal': 'M5V', 'p_country': 'Canada', 'p_phone': null});
    });

    test('a refused claim is its sentence, and an unreadable answer is an error', () async {
      site.rpcs['plaque_claim'] = (_) => raised('A plaque has already been asked for.');
      await expectLater(service.claimPlaque(award: 'aw1', address: address), sentence('A plaque has already been asked for.'));
      site.rpcs['plaque_claim'] = (_) => ok(null);
      await expectLater(service.claimPlaque(award: 'aw1', address: address), generic());
    });

    test('a plaque is taken back by its id', () async {
      site.rpcs['plaque_cancel'] = (_) => ok(plaqueRow(state: 'cancelled', removed: true));
      expect((await service.cancelPlaque('pq1')).isCancelled, isTrue);
      expect(site.forRpc('plaque_cancel').single.body, {'p_plaque': 'pq1'});
      site.rpcs['plaque_cancel'] = (_) => raised('It is already on its way, so it cannot be cancelled here.');
      await expectLater(service.cancelPlaque('pq1'), sentence('It is already on its way, so it cannot be cancelled here.'));
    });
  });
}
