import 'package:bottles_up_user/site/models/recognition.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/recognition_fixtures.dart';

void main() {
  group('the ranks', () {
    test('a colour is read, only as six hex digits after a #', () {
      expect(parseColour('#2E9E5B'), 0xFF2E9E5B);
      expect(parseColour('#2e9e5b'), 0xFF2E9E5B);
      for (final bad in ['2E9E5B', '#2E9E5', '#2E9E5BB', '#GGGGGG', '', null, 5]) {
        expect(parseColour(bad), isNull, reason: '$bad');
      }
    });

    test('a level is read with its name, count, colour and plaque', () {
      final l = parseRankLevel(levelRow(key: 'icon', name: 'Icon', min: 1000000, colour: '#7E57C2', plaque: true))!;
      expect([l.key, l.name, l.minFollowers, l.colour, l.plaque, l.isVerified], ['icon', 'Icon', 1000000, 0xFF7E57C2, true, false]);
      expect(parseRankLevel(levelRow(key: 'verified', name: 'Verified', min: 0))!.isVerified, isTrue);
      expect(parseRankLevel(levelRow())!.plaque, isFalse);
    });

    test('a level that cannot be read is dropped', () {
      expect(parseRankLevel(null), isNull);
      expect(parseRankLevel('x'), isNull);
      for (final key in ['key', 'name', 'colour', 'min_followers']) {
        expect(parseRankLevel(levelRow()..remove(key)), isNull, reason: key);
      }
      expect(parseRankLevel(levelRow(min: -1)), isNull);
      expect(parseRankLevel(levelRow(colour: 'green')), isNull);
      expect(parseRankLevels([levelRow(), 'x', levelRow(key: 'icon', name: 'Icon', min: 5)]).map((l) => l.key), ['elite', 'icon']);
      expect(parseRankLevels(null), isEmpty);
    });

    test('the ranks in the client\'s plan are what the app knows until the website answers', () {
      expect(proposedRanks.map((l) => l.key), ['verified', 'elite', 'icon', 'legend', 'global_icon', 'immortal']);
      expect(proposedRanks.map((l) => l.minFollowers), [0, 100000, 1000000, 10000000, 50000000, 100000000]);
      expect(proposedRanks.where((l) => l.plaque).map((l) => l.key), ['icon', 'legend', 'global_icon', 'immortal']);
      expect(proposedRanks.map((l) => l.colour).toSet().length, 6);
    });
  });

  group('verification', () {
    test('where a profile stands, and its latest request', () {
      final v = parseVerificationInfo(verificationRow(verified: true, via: 'review', request: requestRow(state: 'approved')))!;
      expect([v.verified, v.via, v.orgRun, v.request!.state, v.request!.isWaiting, v.request!.wasTurnedDown], [true, 'review', false, 'approved', false, false]);
      final w = parseVerificationInfo(verificationRow(request: requestRow()))!;
      expect([w.verified, w.request!.isWaiting, w.request!.note, w.request!.createdAt!.toUtc()], [false, true, 'I am a radio host.', DateTime.utc(2026, 11, 2, 10)]);
      expect(parseVerificationInfo(verificationRow(orgRun: true, verified: true, via: 'business'))!.orgRun, isTrue);
      expect(parseVerificationInfo(verificationRow())!.request, isNull);
    });

    test('a turned-down request carries why and when to ask again', () {
      final r = parseVerificationInfo(verificationRow(request: requestRow(state: 'rejected', reason: 'We could not confirm who you are.', retryOn: '2026-12-02')))!.request!;
      expect([r.wasTurnedDown, r.reason, r.retryOn], [true, 'We could not confirm who you are.', DateTime(2026, 12, 2)]);
      expect(parseVerificationInfo(verificationRow(request: requestRow(state: 'revoked')))!.request!.wasTurnedDown, isTrue);
    });

    test('a request that cannot be read is nothing, and so is an answer that cannot', () {
      expect(parseVerificationInfo(verificationRow(request: {'state': 'requested'}))!.request, isNull);
      expect(parseVerificationInfo(verificationRow(request: {'id': 'x'}))!.request, isNull);
      expect(parseVerificationInfo(null), isNull);
      expect(parseVerificationInfo('x'), isNull);
    });
  });

  group('rank status', () {
    test('is read with the step to take', () {
      final s = parseRankStatus(rankStatusRow(target: {'key': 'elite', 'name': 'Elite', 'min_followers': 100000, 'colour': '#2E9E5B'}))!;
      expect([s.verified, s.followers, s.rank, s.next!.key, s.next!.minFollowers, s.target!.name, s.canRequest, s.isWaiting], [true, 120000, 'verified', 'elite', 100000, 'Elite', true, false]);
    });

    test('waiting for a review, and a refusal with its date', () {
      final w = parseRankStatus(rankStatusRow(canRequest: false, pending: {'id': 'r1', 'level': 'elite', 'created_at': '2026-11-02T10:00:00Z'}))!;
      expect([w.isWaiting, w.pendingLevel, w.canRequest], [true, 'elite', false]);
      final r = parseRankStatus(rankStatusRow(canRequest: false, rejected: {'level': 'elite', 'reason': 'Some followers look bought.', 'retry_on': '2026-12-02'}))!;
      expect([r.rejectedReason, r.rejectedRetryOn], ['Some followers look bought.', DateTime(2026, 12, 2)]);
    });

    test('nothing to ask for when there is no next step, and an unreadable answer is nothing', () {
      final s = parseRankStatus({'verified': true, 'followers': 3, 'rank': 'immortal', 'next': null, 'target': null, 'can_request': false, 'pending': null, 'rejected': null})!;
      expect([s.next, s.target, s.canRequest, s.rank], [null, null, false, 'immortal']);
      expect(parseRankStatus({'verified': true}), isNull);
      expect(parseRankStatus(null), isNull);
      expect(parseRankStatus(rankStatusRow(next: {'key': 'elite'}))!.next, isNull);
      expect(parseRankStatus(rankStatusRow(next: {'key': 'elite', 'name': 'Elite', 'min_followers': 1, 'colour': 'nope'}))!.next, isNull);
    });
  });

  group('awards and plaques', () {
    test('awards are read, an unreadable one is dropped', () {
      final a = parseAwards([awardRow(level: 'icon', name: 'Icon', colour: '#7E57C2', plaque: true), awardRow(id: 'aw2'), {'id': 'x'}, 'y', awardRow(id: 'aw3', colour: 'nope')]);
      expect(a.map((x) => x.id), ['aw1', 'aw2']);
      expect([a[0].level, a[0].name, a[0].colour, a[0].plaque, a[0].awardedAt!.toUtc()], ['icon', 'Icon', 0xFF7E57C2, true, DateTime.utc(2026, 11, 3, 10)]);
      expect(a[1].plaque, isFalse);
      expect(parseAwards(null), isEmpty);
    });

    test('a plaque\'s address is in the order of a parcel', () {
      final p = parsePlaque(plaqueRow())!;
      expect(p.address, ['Ann Lee', '1 King St W', 'Unit 4', 'Toronto, ON M5V 1A1', 'Canada']);
      expect([p.state, p.levelName, p.isOpen, p.isOnItsWay, p.isDelivered, p.isCancelled, p.addressRemoved], ['requested', 'Icon', true, false, false, false, false]);
    });

    test('...and gone once it has been removed', () {
      final p = parsePlaque(plaqueRow(state: 'delivered', removed: true, carrier: 'Canada Post', tracking: 'AB123'))!;
      expect([p.address, p.addressRemoved, p.carrier, p.tracking, p.isDelivered], [<String>[], true, 'Canada Post', 'AB123', true]);
      expect(parsePlaque(plaqueRow(state: 'shipped'))!.isOnItsWay, isTrue);
      expect(parsePlaque(plaqueRow(state: 'cancelled'))!.isCancelled, isTrue);
    });

    test('a plaque that cannot be read is dropped', () {
      for (final key in ['id', 'award', 'level', 'state']) {
        expect(parsePlaque(plaqueRow()..remove(key)), isNull, reason: key);
      }
      expect(parsePlaque(null), isNull);
      expect(parsePlaques([plaqueRow(), 'x', plaqueRow(id: 'pq2')]).map((x) => x.id), ['pq1', 'pq2']);
      expect(parsePlaques(null), isEmpty);
      expect(parsePlaque(plaqueRow()..['level_name'] = null)!.levelName, 'icon');
      final onlyCity = parsePlaque({...plaqueRow(), 'region': null, 'postal': null, 'line2': null})!;
      expect(onlyCity.address, ['Ann Lee', '1 King St W', 'Toronto', 'Canada']);
    });
  });
}
