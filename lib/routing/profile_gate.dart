import 'dart:async';

import 'package:bottles_up_user/features/profile/logic/profile_completion.dart';
import 'package:bottles_up_user/site/services/profile_completion_service.dart';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Where the signed-in person's profile stands.
enum ProfileGateState {
  /// Not looked at yet (or being looked at).
  unknown,

  /// E-mail, phone number and date of birth are all there.
  complete,

  /// At least one is missing: the person is sent to the "Complete your profile" screen before anything else.
  incomplete,

  /// The profile could not be read (no connection). The same screen is shown, with a way to try again, instead of letting the person in unchecked.
  failed,
}

/// Remembers whether the signed-in person's profile is complete, so the router can ask without a network call on every screen change. It looks again whenever a different person signs in.
class ProfileGate extends ChangeNotifier {
  ProfileGate({required String? Function() currentUserId, required Stream<Object?> authChanges, required Future<bool> Function() isComplete})
      : _currentUserId = currentUserId,
        _isComplete = isComplete {
    _sub = authChanges.listen((_) => _sync());
    _sync();
  }

  final String? Function() _currentUserId;
  final Future<bool> Function() _isComplete;
  late final StreamSubscription<Object?> _sub;
  String? _uid;
  ProfileGateState _state = ProfileGateState.unknown;
  int _round = 0;

  ProfileGateState get state => _state;

  void _sync() {
    final uid = _currentUserId();
    if (uid == _uid) return;
    _uid = uid;
    _state = ProfileGateState.unknown;
    notifyListeners();
    if (uid != null) _check(uid);
  }

  Future<void> _check(String uid) async {
    final round = ++_round;
    try {
      final complete = await _isComplete();
      if (round != _round || uid != _uid) return;
      _state = complete ? ProfileGateState.complete : ProfileGateState.incomplete;
    } catch (_) {
      if (round != _round || uid != _uid) return;
      _state = ProfileGateState.failed;
    }
    notifyListeners();
  }

  /// Look again (the "Try again" button after a failed read).
  void recheck() {
    final uid = _uid;
    if (uid == null) return;
    _state = ProfileGateState.unknown;
    notifyListeners();
    _check(uid);
  }

  /// The person just saved their details.
  void markComplete() {
    if (_uid == null) return;
    _round++;
    _state = ProfileGateState.complete;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// The one the app uses, made the first time the router asks for it (Supabase is started by then).
final profileGate = ProfileGate(
  currentUserId: () => Supabase.instance.client.auth.currentUser?.id,
  authChanges: Supabase.instance.client.auth.onAuthStateChange,
  isComplete: () async => profileGaps(await ProfileCompletionService(Supabase.instance.client).load(), clock.now()).complete,
);

/// For screens that need to tell the gate something. A plain provider: the gate belongs to the app, not to whoever reads it, so nothing here disposes it.
final profileGateProvider = Provider<ProfileGate>((ref) => profileGate);

const completeProfilePath = '/complete-profile';

/// A place inside the app to return to, or null: only a path of our own (never another site, and never a screen that would send the person round in a circle).
String? safeReturnPath(String? value) {
  if (value == null || !value.startsWith('/') || value.startsWith('//')) return null;
  final path = Uri.tryParse(value)?.path;
  if (path == null || path == '/' || path == completeProfilePath || path == '/login' || path == '/signup' || path == '/phone-login') return null;
  return value;
}

/// The profile rule for the router: a signed-in person whose profile is not complete cannot reach any screen but the one that completes it; one whose profile is complete never sees it.
/// [uri] is the full address being opened. Returns where to go instead, or null to stay. (The sign-in screens, the password reset and the splash are the router's own business and are not asked about here.)
String? profileGateRedirect({required bool loggedIn, required Uri uri, required ProfileGateState state}) {
  if (!loggedIn) return null;
  final path = uri.path;
  if (path == completeProfilePath) {
    return state == ProfileGateState.complete ? (safeReturnPath(uri.queryParameters['redirect']) ?? '/home') : null;
  }
  if (state == ProfileGateState.complete) return null;
  return '$completeProfilePath?redirect=${Uri.encodeComponent(uri.toString())}';
}
