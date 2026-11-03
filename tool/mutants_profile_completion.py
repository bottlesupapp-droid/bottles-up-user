#!/usr/bin/env python3
"""Mutation check of the profile-completion code (the Complete your profile screen, its gate, service and date field): break the code on purpose, one change at a time, and
confirm the tests fail. Run it in an ISOLATED copy of the customer app (a git worktree with ../../packages and ../bottles-up-website-main linked), never in the folder someone
builds from: it edits lib/ files in place and puts them back.

  APP_DIR=<worktree>/apps/bottles-up-user python3 tool/mutants_profile_completion.py
  ONLY='6 digits|back button' APP_DIR=... python3 tool/mutants_profile_completion.py     (just the mutants whose names contain one of these)

Known equivalent (cannot be told apart by any test): "dob: time of day counts". The birth date is already cut to a plain date before it is compared, so comparing it with
"now" instead of "today" gives the same answer for every input. It is reported as SURVIVED and is not a gap.
"""
import os, sys, subprocess, signal, hashlib, shutil

APP = os.environ['APP_DIR']
LOGIC = 'lib/features/profile/logic/profile_completion.dart'
GATE = 'lib/routing/profile_gate.dart'
SERVICE = 'lib/site/services/profile_completion_service.dart'
SCREEN = 'lib/features/profile/screens/complete_profile_screen.dart'
FIELD = 'lib/features/profile/widgets/date_of_birth_field.dart'
TESTS = ['test/profile', 'test/screens/complete_profile_screen_test.dart', 'test/screens/date_of_birth_field_test.dart']

ONLY = [x for x in os.environ.get('ONLY', '').split('|') if x]
M = [
 (LOGIC, 'minimum age raised', "const minimumAge = 18;", "const minimumAge = 19;"),
 (LOGIC, 'minimum age lowered', "const minimumAge = 18;", "const minimumAge = 17;"),
 (LOGIC, 'age: year difference added', "var years = today.year - dateOfBirth.year;", "var years = today.year + dateOfBirth.year;"),
 (LOGIC, 'age: month compared with <=', "if (today.month < dateOfBirth.month ||", "if (today.month <= dateOfBirth.month ||"),
 (LOGIC, 'age: day compared with <=', "today.day < dateOfBirth.day)) years--;", "today.day <= dateOfBirth.day)) years--;"),
 (LOGIC, 'age: birthday never subtracted', " years--;", " years;"),
 (LOGIC, 'dob: missing date allowed', "if (dateOfBirth == null) return 'Choose your date of birth';", "if (dateOfBirth == null) return null;"),
 (LOGIC, 'dob: future allowed', "if (dob.isAfter(dateOnly(today))) return", "if (false) return"),
 (LOGIC, 'dob: time of day counts', "if (dob.isAfter(dateOnly(today))) return", "if (dob.isAfter(today)) return"),
 (LOGIC, 'dob: year limit lowered', "dob.year < 1900", "dob.year < 1800"),
 (LOGIC, 'dob: year limit raised', "dob.year < 1900", "dob.year < 1901"),
 (LOGIC, 'dob: exactly 18 refused', "ageOn(dob, today) < minimumAge", "ageOn(dob, today) <= minimumAge"),
 (LOGIC, 'dob: 17 allowed', "ageOn(dob, today) < minimumAge", "ageOn(dob, today) < minimumAge - 1"),
 (LOGIC, 'email: empty allowed', "if (v.isEmpty) return 'Enter your e-mail address';", ""),
 (LOGIC, 'email: not trimmed', "final v = value?.trim() ?? '';", "final v = value ?? '';"),
 (LOGIC, 'email: shape not checked', "if (!_emailShape.hasMatch(v)) return", "if (false) return"),
 (LOGIC, 'email: dot after @ not needed', r"r'^[^@\s]+@[^@\s]+\.[^@\s]+$'", r"r'^[^@\s]+@[^@\s]+$'"),
 (LOGIC, 'phone: empty allowed', "if (digits.isEmpty) return 'Enter your phone number';", ""),
 (LOGIC, 'phone: 6 digits allowed', "digits.length < 7", "digits.length < 6"),
 (LOGIC, 'phone: 8 digits needed', "digits.length < 7", "digits.length < 8"),
 (LOGIC, 'phone: 16 digits allowed', "digits.length > 15", "digits.length > 16"),
 (LOGIC, 'phone: 14 digits at most', "digits.length > 15", "digits.length > 14"),
 (LOGIC, 'phone stored with separators', "'${country.phoneCode}${digitsOf(typed)}'", "'${country.phoneCode}$typed'"),
 (LOGIC, 'split: shortest code wins', "digitsOf(best.phoneCode).length)) best = c;", "digitsOf(best.phoneCode).length)) best = best ?? c;"),
 (LOGIC, 'split: no + still read as international', "if (!text.startsWith('+')) return", "if (false) return"),
 (LOGIC, 'split: fallback not preferred for +1', "final chosen = best.phoneCode == fallback.phoneCode ? fallback : best;", "final chosen = best;"),
 (LOGIC, 'iso: month not padded', "d.month.toString().padLeft(2, '0')", "d.month.toString()"),
 (LOGIC, 'iso: day not padded', "d.day.toString().padLeft(2, '0')", "d.day.toString()"),
 (LOGIC, 'from iso: any text accepted', "if (value is! String || value.length < 10) return null;", "if (value is! String) return null;"),
 (LOGIC, 'known e-mail: sign-in first', "for (final candidate in [email, sessionEmail]) {", "for (final candidate in [sessionEmail, email]) {"),
 (LOGIC, 'known e-mail: blank accepted', "if (v != null && v.isNotEmpty) return v;", "if (v != null) return v;"),
 (LOGIC, 'gaps: phone not checked', "phone: phoneProblem(details.phone) != null,", "phone: false,"),
 (LOGIC, 'gaps: date not checked', "dateOfBirth: dateOfBirthProblem(details.dateOfBirth, today) != null,", "dateOfBirth: false,"),
 (LOGIC, 'gaps: e-mail not checked', "email: emailProblem(details.knownEmail) != null,", "email: false,"),
 (LOGIC, 'complete: any one is enough', "bool get complete => !email && !phone && !dateOfBirth;", "bool get complete => !email || !phone || !dateOfBirth;"),
 (GATE, 'redirect: not signed in is sent too', "if (!loggedIn) return null;", ""),
 (GATE, 'redirect: complete still redirected', "  if (state == ProfileGateState.complete) return null;\n  return '$completeProfilePath", "  return '$completeProfilePath"),
 (GATE, 'redirect: incomplete let through', "  if (state == ProfileGateState.complete) return null;\n  return '$completeProfilePath", "  if (state != ProfileGateState.failed) return null;\n  return '$completeProfilePath"),
 (GATE, 'redirect: failed let through', "  if (state == ProfileGateState.complete) return null;\n  return '$completeProfilePath", "  if (state != ProfileGateState.incomplete) return null;\n  return '$completeProfilePath"),
 (GATE, 'redirect: form left when incomplete', "return state == ProfileGateState.complete ? (safeReturnPath(uri.queryParameters['redirect']) ?? '/home') : null;", "return (safeReturnPath(uri.queryParameters['redirect']) ?? '/home');"),
 (GATE, 'redirect: destination forgotten', "?redirect=${Uri.encodeComponent(uri.toString())}'", "'"),
 (GATE, 'return path: other sites allowed', "!value.startsWith('/') || value.startsWith('//')", "false"),
 (GATE, 'return path: // allowed', "|| value.startsWith('//')) return null;", ") return null;"),
 (GATE, 'return path: loop through the form allowed', "path == completeProfilePath || path == '/login'", "path == '/login'"),
 (GATE, 'return path: login allowed', "|| path == '/login' ||", "||"),
 (GATE, 'return path: home allowed as "/"', "path == null || path == '/' ||", "path == null ||"),
 (GATE, 'gate: same person reread on every event', "    if (uid == _uid) return;\n", ""),
 (GATE, 'gate: stale answer used', "      if (round != _round || uid != _uid) return;\n      _state = complete", "      _state = complete"),
 (GATE, 'gate: stale failure used', "    } catch (_) {\n      if (round != _round || uid != _uid) return;", "    } catch (_) {"),
 (GATE, 'gate: marking complete with nobody in', "    if (_uid == null) return;\n    _round++;", "    _round++;"),
 (GATE, 'gate: marking complete leaves a read running', "    _round++;\n    _state = ProfileGateState.complete;", "    _state = ProfileGateState.complete;"),
 (GATE, 'gate: recheck without reading', "    notifyListeners();\n    _check(uid);\n  }", "    notifyListeners();\n  }"),
 (GATE, 'gate: failure reported as incomplete', "_state = ProfileGateState.failed;", "_state = ProfileGateState.incomplete;"),
 (GATE, 'gate: failure reported as complete', "_state = ProfileGateState.failed;", "_state = ProfileGateState.complete;"),
 (SERVICE, 'service: always inserts', "if (current.exists) {", "if (false) {"),
 (SERVICE, 'service: e-mail always written', "if ((current.email ?? '').trim().isEmpty) values['email'] = wanted;", "values['email'] = wanted;"),
 (SERVICE, 'service: e-mail never written', "if ((current.email ?? '').trim().isEmpty) values['email'] = wanted;", ""),
 (SERVICE, 'service: typed e-mail beats sign-in', "final wanted = current.knownEmail ?? email.trim();", "final wanted = email.trim();"),
 (SERVICE, 'service: typed e-mail not trimmed', "final wanted = current.knownEmail ?? email.trim();", "final wanted = current.knownEmail ?? email;"),
 (SERVICE, 'service: age not sent', "      'age': ageOn(dateOfBirth, clock.now()),\n", ""),
 (SERVICE, 'service: age from a fixed day', "ageOn(dateOfBirth, clock.now())", "ageOn(dateOfBirth, DateTime(2026, 1, 1))"),
 (SERVICE, 'service: date written with time', "'date_of_birth': dateToIso(dateOfBirth),", "'date_of_birth': dateOfBirth.toIso8601String(),"),
 (SERVICE, 'service: quiet no-op accepted', "if (saved.isEmpty) throw StateError('The profile could not be updated');", ""),
 (SERVICE, 'service: duplicate e-mail not recognised', "if (e.code == '23505') throw const EmailTakenException();", ""),
 (SERVICE, 'service: every refusal called a duplicate', "if (e.code == '23505') throw const EmailTakenException();", "throw const EmailTakenException();"),
 (SERVICE, 'service: update everyone\'s row', ".update(values).eq('id', user.id)", ".update(values)"),
 (SERVICE, 'service: read everyone\'s row', ".eq('id', user.id).maybeSingle()", ".maybeSingle()"),
 (SERVICE, 'service: insert without the person\'s id', "          'id': user.id,\n", ""),
 (SCREEN, 'screen: save without checking the form', "if (!(_form.currentState?.validate() ?? false)) return;", ""),
 (SCREEN, 'screen: saved but not marked complete', "    ref.read(profileGateProvider).markComplete();\n", ""),
 (SCREEN, 'screen: unsafe return address used', "safeReturnPath(widget.redirectTo) ?? '/home'", "widget.redirectTo ?? '/home'"),
 (SCREEN, 'screen: already complete not recognised', "if (profileGaps(details, clock.now()).complete) {", "if (false) {"),
 (SCREEN, 'screen: sign-in e-mail left editable', "_emailKnown = known != null && emailProblem(known) == null;", "_emailKnown = false;"),
 (SCREEN, 'screen: phone typed without country', "phoneFor(_country, _phone.text)", "digitsOf(_phone.text)"),
 (SCREEN, 'screen: duplicate e-mail message lost', "} on EmailTakenException {", "} on FormatException {"),
 (SCREEN, 'screen: back button leaves the form', "canPop: false,", "canPop: true,"),
 (FIELD, 'field: date not checked', "validator: (value) => dateOfBirthProblem(value, clock.now()),", "validator: (value) => null,"),
 (FIELD, 'field: stale error stays', "autovalidateMode: AutovalidateMode.onUserInteraction,", "autovalidateMode: AutovalidateMode.disabled,"),
 (FIELD, 'field: future days offered', "final last = dateOnly(today);", "final last = DateTime(today.year + 5);"),
 (SERVICE, 'service: age refusal not recognised', "      if (e.code == '23514' && e.message.contains('profiles_age_check')) throw const UnderAgeException();\n", ""),
 (SERVICE, 'service: any check refusal called an age one', "if (e.code == '23514' && e.message.contains('profiles_age_check'))", "if (e.code == '23514')"),
 (SCREEN, 'screen: age refusal message lost', "} on UnderAgeException {", "} on FormatException {"),
 (FIELD, 'field: age not shown', "helper: value == null ? null : Text('Age: ${ageOn(value, today)}'", "helper: value == null ? null : Text('Age: ${ageOn(value, today) + 1}'"),
]

def sha(p): return hashlib.sha256(open(p, 'rb').read()).hexdigest()
files = sorted({f for f, *_ in M})
orig = {f: open(os.path.join(APP, f)).read() for f in files}
before = {f: sha(os.path.join(APP, f)) for f in files}

def run():
    p = subprocess.Popen(['flutter', 'test', '--concurrency=3', *TESTS], cwd=APP, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, start_new_session=True)
    try:
        out, _ = p.communicate(timeout=420)
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, signal.SIGKILL); return 'timeout'
    return 'passes' if p.returncode == 0 else ('compile error' if 'Error:' in out and 'Compilation failed' in out else 'killed')

try:
    base = run(); print('baseline:', base, flush=True)
    if base != 'passes': sys.exit(1)
    survivors = []
    for f, name, old, new in M:
        if ONLY and not any(o in name for o in ONLY): continue
        src = orig[f]
        if src.count(old) != 1:
            print(f'  ?? {name}: pattern found {src.count(old)} times, skipped', flush=True); survivors.append(name + ' (pattern)'); continue
        open(os.path.join(APP, f), 'w').write(src.replace(old, new))
        r = run()
        open(os.path.join(APP, f), 'w').write(src)
        print(f'  {("SURVIVED" if r == "passes" else r):14s} {name}', flush=True)
        if r in ('passes', 'timeout'): survivors.append(name)
finally:
    for f in files: open(os.path.join(APP, f), 'w').write(orig[f])
    assert all(sha(os.path.join(APP, f)) == before[f] for f in files), 'a file was not restored!'
print('survivors:', len(survivors), survivors)
