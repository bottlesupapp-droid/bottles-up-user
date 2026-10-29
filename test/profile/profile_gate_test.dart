import 'dart:async';

import 'package:bottles_up_user/routing/profile_gate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('where the router sends a person', () {
    String? go(String location, {bool loggedIn = true, ProfileGateState state = ProfileGateState.incomplete}) =>
        profileGateRedirect(loggedIn: loggedIn, uri: Uri.parse(location), state: state);

    test('a signed-in person with an incomplete profile is sent to complete it, remembering where they were going', () {
      expect(go('/home'), '/complete-profile?redirect=%2Fhome');
      expect(go('/events/e1?tab=tickets'), '/complete-profile?redirect=${Uri.encodeComponent('/events/e1?tab=tickets')}');
    });

    test('so is one whose profile has not been read yet, or could not be read', () {
      expect(go('/home', state: ProfileGateState.unknown), startsWith('/complete-profile'));
      expect(go('/home', state: ProfileGateState.failed), startsWith('/complete-profile'));
    });

    test('a complete profile goes anywhere', () {
      expect(go('/home', state: ProfileGateState.complete), isNull);
      expect(go('/bookings/b1', state: ProfileGateState.complete), isNull);
    });

    test('the completion screen itself stays put while there is something to complete', () {
      for (final s in [ProfileGateState.unknown, ProfileGateState.incomplete, ProfileGateState.failed]) {
        expect(go('/complete-profile?redirect=%2Fhome', state: s), isNull, reason: '$s');
      }
    });

    test('once complete, the completion screen sends the person on to where they were heading, or home', () {
      expect(go('/complete-profile?redirect=${Uri.encodeComponent('/events/e1?tab=tickets')}', state: ProfileGateState.complete), '/events/e1?tab=tickets');
      expect(go('/complete-profile', state: ProfileGateState.complete), '/home');
    });

    test('nobody signed out is touched (that is the login rule\'s business)', () {
      expect(go('/home', loggedIn: false), isNull);
      expect(go('/complete-profile', loggedIn: false, state: ProfileGateState.complete), isNull);
    });
  });

  group('a place to return to', () {
    test('only a path inside the app, never another site or a screen that goes round in a circle', () {
      expect(safeReturnPath('/events/e1'), '/events/e1');
      expect(safeReturnPath('/events/e1?tab=x'), '/events/e1?tab=x');
      for (final bad in [null, '', 'home', 'https://evil.example/', '//evil.example/path', '/', '/login', '/login?redirect=%2Fhome', '/signup', '/phone-login', '/complete-profile', '/complete-profile?redirect=%2Fx']) {
        expect(safeReturnPath(bad), isNull, reason: '$bad');
      }
    });

    test('a hostile redirect value is dropped when the profile is complete', () {
      expect(profileGateRedirect(loggedIn: true, uri: Uri.parse('/complete-profile?redirect=${Uri.encodeComponent('https://evil.example/')}'), state: ProfileGateState.complete), '/home');
    });
  });

  group('the gate remembers where the profile stands', () {
    late StreamController<Object?> auth;
    late String? uid;
    late List<Completer<bool>> asked;
    late ProfileGate gate;
    late int notified;

    setUp(() {
      auth = StreamController<Object?>.broadcast();
      uid = null;
      asked = [];
      gate = ProfileGate(
        currentUserId: () => uid,
        authChanges: auth.stream,
        isComplete: () {
          final c = Completer<bool>();
          asked.add(c);
          return c.future;
        },
      );
      notified = 0;
      gate.addListener(() => notified++);
    });

    tearDown(() async {
      gate.dispose();
      await auth.close();
    });

    Future<void> signIn(String id) async {
      uid = id;
      auth.add('signedIn');
      await pumpEventQueue();
    }

    test('nobody signed in: nothing is read', () async {
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.unknown);
      expect(asked, isEmpty);
    });

    test('signing in reads the profile once; an incomplete one is reported as such', () async {
      await signIn('u1');
      expect(asked, hasLength(1));
      expect(gate.state, ProfileGateState.unknown);
      asked.single.complete(false);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.incomplete);
    });

    test('a complete one is reported as complete, and the router is told to look again', () async {
      await signIn('u1');
      final before = notified;
      asked.single.complete(true);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.complete);
      expect(notified, greaterThan(before));
    });

    test('the same person\'s session being renewed does not read the profile again', () async {
      await signIn('u1');
      asked.single.complete(true);
      await pumpEventQueue();
      auth.add('tokenRefreshed');
      await pumpEventQueue();
      expect(asked, hasLength(1));
      expect(gate.state, ProfileGateState.complete);
    });

    test('a read that fails is reported as failed, and trying again reads again', () async {
      await signIn('u1');
      asked.single.completeError(StateError('offline'));
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.failed);
      gate.recheck();
      expect(gate.state, ProfileGateState.unknown);
      expect(asked, hasLength(2));
      asked.last.complete(true);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.complete);
    });

    test('saving the details marks the profile complete at once', () async {
      await signIn('u1');
      asked.single.complete(false);
      await pumpEventQueue();
      gate.markComplete();
      expect(gate.state, ProfileGateState.complete);
    });

    test('an answer that arrives after the person signed out is thrown away', () async {
      await signIn('u1');
      uid = null;
      auth.add('signedOut');
      await pumpEventQueue();
      asked.single.complete(true);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.unknown);
    });

    test('a failure that arrives after the person signed out is thrown away too', () async {
      await signIn('u1');
      uid = null;
      auth.add('signedOut');
      await pumpEventQueue();
      asked.single.completeError(StateError('offline'));
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.unknown);
    });

    test('saving the details wins over a read that was still on its way, whatever it says', () async {
      await signIn('u1');
      gate.markComplete();
      asked.single.complete(false);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.complete);

      await signIn('u2');
      gate.markComplete();
      asked.last.completeError(StateError('offline'));
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.complete);
    });

    test('a different person signing in is looked at afresh, and the first person\'s late answer is ignored', () async {
      await signIn('u1');
      await signIn('u2');
      expect(asked, hasLength(2));
      asked.first.complete(true); // u1's, too late
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.unknown);
      asked.last.complete(false);
      await pumpEventQueue();
      expect(gate.state, ProfileGateState.incomplete);
    });

    test('marking complete with nobody signed in does nothing', () {
      gate.markComplete();
      expect(gate.state, ProfileGateState.unknown);
    });
  });
}
