import 'package:bottles_up_user/features/hire/widgets/hire_section.dart';
import 'package:bottles_up_user/features/hire/widgets/team_invitations_card.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/hire_fixtures.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  final on = {'social': true, 'marketplace': true, 'venue_hire': true, 'inbox': true};
  final asDj = [selectedProfileIdProvider.overrideWith((ref) => 'biz')];

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['team_list'] = (_) => ok(teamInfoRow(members: [
          teamMemberRow(),
          teamMemberRow(id: 'tm2', role: 'custom', permissions: ['bookings', 'finance'], name: 'Bob Ray', handle: 'bobteam'),
          teamMemberRow(id: 'tm3', role: 'door_staff', permissions: [], status: 'invited', name: 'Cy Rus', handle: 'cyteam'),
        ]));
    site.rpcs['team_invitations_mine'] = (_) => ok(<Object>[]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<GoRouter> openTeam(WidgetTester tester, {List<Map<String, dynamic>>? mine, Map<String, bool>? features}) async {
    final router = await openSocial(tester, site, '/me/team', features: features ?? on, mine: mine ?? [myPersonal(), myBusiness()], overrides: asDj);
    await settleCalls(tester);
    return router;
  }

  group('the team of a professional', () {
    testWidgets('lists the owner and everyone on the team, with what each may do and who is still being asked', (tester) async {
      await openTeam(tester);
      expect(site.forRpc('team_list').first.body, {'p_actor': 'biz'});
      expect(find.text('Team of DJ Dana'), findsOneWidget);
      expect(find.text('Dee Dee'), findsOneWidget);
      expect(find.text('Owner: can do everything'), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('member-tm1')), matching: find.textContaining('Booking agent · Services, requests, quotes and hires')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('member-tm2')), matching: find.textContaining('Custom: Services, requests, quotes and hires, Earnings')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('member-tm3')), matching: find.textContaining('waiting for an answer')), findsOneWidget);
      expect(find.byKey(const Key('team-note')), findsOneWidget);
    });

    testWidgets('says what to do when nobody else has access', (tester) async {
      site.rpcs['team_list'] = (_) => ok(teamInfoRow(members: []));
      await openTeam(tester);
      expect(find.byKey(const Key('team-empty')), findsOneWidget);
    });

    testWidgets('inviting needs a username, and a custom role needs something to do', (tester) async {
      await openTeam(tester);
      await tap(tester, 'team-invite');
      await tester.pumpAndSettle();
      await tap(tester, 'role-save');
      expect(textOf(tester, 'role-problem'), 'Type their username.');
      await tester.enterText(find.byKey(const Key('invite-handle')), 'bobteam');
      await tap(tester, 'role-custom');
      await tap(tester, 'role-save');
      expect(textOf(tester, 'role-problem'), 'Choose at least one thing a custom role may do.');
      expect(site.forRpc('team_invite'), isEmpty);
    });

    testWidgets('sends the username, the role and (for a custom role) the pick, then reads the team again', (tester) async {
      site.rpcs['team_invite'] = (_) => ok(teamMemberRow(status: 'invited'));
      await openTeam(tester);
      await tap(tester, 'team-invite');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('invite-handle')), ' @Zedteam ');
      await tap(tester, 'role-custom');
      await tap(tester, 'allow-finance');
      await tap(tester, 'allow-bookings');
      await tap(tester, 'role-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final sent = site.forRpc('team_invite').single.body;
      expect([sent['p_actor'], sent['p_handle'], sent['p_role'], (sent['p_permissions'] as List).toSet()], ['biz', 'zedteam', 'custom', {'finance', 'bookings'}]);
      expect(find.text('The invitation was sent.'), findsOneWidget);
      expect(site.forRpc('team_list').length, 2);
    });

    testWidgets('a role that is not custom sends no pick', (tester) async {
      site.rpcs['team_invite'] = (_) => ok(teamMemberRow(status: 'invited'));
      await openTeam(tester);
      await tap(tester, 'team-invite');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('invite-handle')), 'zedteam');
      await tap(tester, 'role-manager');
      await tap(tester, 'role-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      final sent = site.forRpc('team_invite').single.body;
      expect([sent['p_role'], sent['p_permissions']], ['manager', null]);
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['team_invite'] = (_) => raised('No one has that username.');
      await openTeam(tester);
      await tap(tester, 'team-invite');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('invite-handle')), 'nobody');
      await tap(tester, 'role-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('No one has that username.'), findsOneWidget);
    });

    testWidgets('changing a role starts from the role they have', (tester) async {
      site.rpcs['team_set_role'] = (_) => ok(teamMemberRow(role: 'manager'));
      await openTeam(tester);
      await tap(tester, 'member-menu-tm2');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change the role'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('invite-handle')), findsNothing, reason: 'the person is already chosen');
      expect(tester.widget<CheckboxListTile>(find.byKey(const Key('allow-finance'))).value, isTrue);
      expect(tester.widget<CheckboxListTile>(find.byKey(const Key('allow-content'))).value, isFalse);
      await tap(tester, 'role-manager');
      await tap(tester, 'role-save');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('team_set_role').single.body, {'p_actor': 'biz', 'p_team': 'tm2', 'p_role': 'manager', 'p_permissions': null});
      expect(find.text('Their role was changed.'), findsOneWidget);
    });

    testWidgets('taking away access asks first and says it ends at once', (tester) async {
      site.rpcs['team_revoke'] = (_) => ok(teamMemberRow(status: 'revoked'));
      await openTeam(tester);
      await tap(tester, 'member-menu-tm1');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take away access'));
      await tester.pumpAndSettle();
      expect(find.textContaining('stop being able to act as this profile at once'), findsOneWidget);
      await tap(tester, 'revoke-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('team_revoke'), isEmpty);
      await tap(tester, 'member-menu-tm1');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take away access'));
      await tester.pumpAndSettle();
      await tap(tester, 'revoke-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('team_revoke').single.body, {'p_actor': 'biz', 'p_team': 'tm1'});
      expect(find.text('Their access is gone.'), findsOneWidget);
    });

    testWidgets('an invitation not yet answered is taken back, not "taken away"', (tester) async {
      site.rpcs['team_revoke'] = (_) => ok(teamMemberRow(status: 'revoked'));
      await openTeam(tester);
      await tap(tester, 'member-menu-tm3');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take back the invitation'));
      await tester.pumpAndSettle();
      expect(find.text('Take back the invitation?'), findsOneWidget);
      expect(find.text('They will not be able to accept it.'), findsOneWidget);
      await tap(tester, 'revoke-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('team_revoke').single.body['p_team'], 'tm3');
      expect(find.text('The invitation was taken back.'), findsOneWidget);
    });

    testWidgets('a member sees the team and can leave, but cannot change anything', (tester) async {
      site.rpcs['team_list'] = (_) => ok(teamInfoRow(canManage: false, members: [teamMemberRow(name: 'Dana Lee', handle: 'dana'), teamMemberRow(id: 'tm2', name: 'Bob Ray', handle: 'bobteam')]));
      site.rpcs['team_leave'] = (_) => ok(teamMemberRow(status: 'left'));
      final router = await openTeam(tester);
      expect(find.byKey(const Key('team-invite')), findsNothing);
      expect(find.byKey(const Key('member-menu-tm1')), findsNothing);
      expect(find.byKey(const Key('member-leave-tm2')), findsNothing);
      await tap(tester, 'member-leave-tm1');
      await tester.pumpAndSettle();
      await tap(tester, 'leave-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('team_leave'), isEmpty);
      await tap(tester, 'member-leave-tm1');
      await tester.pumpAndSettle();
      await tap(tester, 'leave-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('team_leave').single.body, {'p_team': 'tm1'});
      expect(path(router), '/me/team');
      final scope = ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));
      expect(scope.read(selectedProfileIdProvider), isNull, reason: 'the person goes back to acting as themselves');
      expect(site.forRpc('profile_my_profiles').length, greaterThanOrEqualTo(2), reason: 'the profiles they can act as are read again');
    });

    testWidgets('the team chat opens as the person, not as the profile', (tester) async {
      site.rpcs['team_list'] = (_) => ok(teamInfoRow(chat: 'c1', chatProfile: 'me'));
      site.rpcs['dm_conversation'] = (_) => ok({'id': 'c1', 'kind': 'group', 'title': 'Team: DJ Dana', 'members': <Object>[]});
      site.rpcs['dm_messages'] = (_) => ok(<Object>[]);
      final router = await openTeam(tester);
      await tap(tester, 'team-chat');
      await tester.pumpAndSettle();
      expect(path(router), '/inbox/c1');
      expect(ProviderScope.containerOf(tester.element(find.byType(Scaffold).first)).read(selectedProfileIdProvider), 'me');
    });

    testWidgets('has no chat button while there is no chat', (tester) async {
      await openTeam(tester);
      expect(find.byKey(const Key('team-chat')), findsNothing);
    });

    testWidgets('the owner can invite up to twenty people: the button goes at the limit', (tester) async {
      site.rpcs['team_list'] = (_) => ok(teamInfoRow(members: [for (var i = 0; i < 20; i++) teamMemberRow(id: 'm$i', name: 'Person $i', handle: 'person$i')]));
      await openTeam(tester);
      expect(find.byKey(const Key('team-invite')), findsNothing);
    });

    testWidgets('says why the team cannot be read, and reads it again', (tester) async {
      var fail = true;
      site.rpcs['team_list'] = (_) => fail ? raised('You cannot act as this profile.') : ok(teamInfoRow());
      await openTeam(tester);
      expect(find.text('You cannot act as this profile.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('team-list')), findsOneWidget);
    });

    testWidgets('a personal profile, a venue and an event group are each told a team belongs to a professional', (tester) async {
      await openSocial(tester, site, '/me/team', features: on, mine: [myPersonal()]);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), profileRow(id: 'biz', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue', mine: true)]);
      await openSocial(tester, site, '/me/team', features: on, overrides: asDj);
      await settleCalls(tester);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      expect(site.forRpc('team_list'), isEmpty, reason: 'nothing is asked for a profile that has no team');
    });

    testWidgets('says it is not open yet when neither switch is on, and opens with either', (tester) async {
      await openTeam(tester, features: {'social': true});
      expect(find.text('Teams are not open yet.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['site_features'] = (_) => ok({'social': true, 'venue_hire': true});
      await openTeam(tester, features: {'social': true, 'venue_hire': true});
      expect(find.byKey(const Key('team-list')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['site_features'] = (_) => ok({'social': true, 'marketplace': true});
      await openTeam(tester, features: {'social': true, 'marketplace': true});
      expect(find.byKey(const Key('team-list')), findsOneWidget);
    });
  });

  group('invitations on Home', () {
    testWidgets('shows who asked, as what, and what that allows', (tester) async {
      site.rpcs['team_invitations_mine'] = (_) => ok([teamInvitationRow(), teamInvitationRow(id: 'tm10', role: 'custom', permissions: ['finance'])]);
      await openSocial(tester, site, '/', features: on, home: const TeamInvitationsCard());
      await settleCalls(tester);
      expect(find.text('DJ Dee asked you to join their team'), findsNWidgets(2));
      expect(find.textContaining('As Content manager: Posts and the profile\'s details.'), findsOneWidget);
      expect(find.textContaining('As Custom: Earnings.'), findsOneWidget);
    });

    testWidgets('accepting joins, reads the invitations again, and adds the profile the person can act as', (tester) async {
      var accepted = false;
      site.rpcs['team_invitations_mine'] = (_) => ok(accepted ? <Object>[] : [teamInvitationRow()]);
      site.rpcs['team_answer'] = (_) {
        accepted = true;
        return ok(teamMemberRow());
      };
      // Home keeps the person's profiles in view, as the real Home does.
      await openSocial(tester, site, '/', features: on, home: Consumer(builder: (context, ref, _) {
        ref.watch(myProfilesProvider);
        return const TeamInvitationsCard();
      }));
      await settleCalls(tester);
      final before = site.forRpc('profile_my_profiles').length;
      await tap(tester, 'team-accept-tm9');
      await settleCalls(tester);
      expect(site.forRpc('team_answer').single.body, {'p_team': 'tm9', 'p_accept': true});
      expect(find.byKey(const Key('team-invitation-tm9')), findsNothing);
      expect(site.forRpc('profile_my_profiles').length, greaterThan(before), reason: 'the profile list is read again');
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('You joined the team of DJ Dee.'), findsOneWidget);
    });

    testWidgets('declining does not touch the profiles', (tester) async {
      var answered = false;
      site.rpcs['team_invitations_mine'] = (_) => ok(answered ? <Object>[] : [teamInvitationRow()]);
      site.rpcs['team_answer'] = (_) {
        answered = true;
        return ok(teamMemberRow(status: 'declined'));
      };
      await openSocial(tester, site, '/', features: on, home: const TeamInvitationsCard());
      await settleCalls(tester);
      final before = site.forRpc('profile_my_profiles').length;
      await tap(tester, 'team-decline-tm9');
      await settleCalls(tester);
      expect(site.forRpc('team_answer').single.body, {'p_team': 'tm9', 'p_accept': false});
      expect(site.forRpc('profile_my_profiles').length, before);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('You turned the invitation down.'), findsOneWidget);
    });

    testWidgets('a double tap on Accept answers once, and a refusal is shown', (tester) async {
      site.rpcs['team_answer'] = (_) => raised('This invitation has already been answered.');
      site.rpcs['team_invitations_mine'] = (_) => ok([teamInvitationRow()]);
      await openSocial(tester, site, '/', features: on, home: const TeamInvitationsCard());
      await settleCalls(tester);
      await tester.ensureVisible(find.byKey(const Key('team-accept-tm9')));
      await tester.tap(find.byKey(const Key('team-accept-tm9')));
      await tester.tap(find.byKey(const Key('team-accept-tm9')));
      await tester.pump();
      await settleCalls(tester);
      expect(site.forRpc('team_answer').length, 1);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('This invitation has already been answered.'), findsOneWidget);
    });

    testWidgets('shows nothing when there is none, or while teams are off', (tester) async {
      await openSocial(tester, site, '/', features: on, home: const TeamInvitationsCard());
      await settleCalls(tester);
      expect(find.byType(Card), findsNothing);
      expect(tester.getSize(find.byType(TeamInvitationsCard)), Size.zero, reason: 'not even a gap');
      await tester.pumpWidget(const SizedBox());
      site.rpcs['team_invitations_mine'] = (_) => ok([teamInvitationRow()]);
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, home: const TeamInvitationsCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('team-invitation-tm9')), findsNothing);
      expect(site.forRpc('team_invitations_mine').length, 1, reason: 'only the first, shown run asked');
    });
  });

  group('on a venue\'s profile', () {
    SocialProfile club({bool mine = false, bool blocked = false, String category = 'venue'}) => parseSocialProfile(profileRow(id: 'club', kind: 'business', handle: 'clubx', name: 'Club X', category: category, mine: mine, blocked: blocked))!;

    testWidgets('invites a group to host an event, and goes to the form', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: HireSection(profile: club()));
      await settleCalls(tester);
      expect(find.text('Host your event here'), findsNWidgets(2));
      await tap(tester, 'host-here-button');
      await tester.pumpAndSettle();
      expect(path(router), '/venues/club/host');
    });

    testWidgets('on the venue\'s own profile it leads to the requests it has had', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: HireSection(profile: club(mine: true)));
      await settleCalls(tester);
      expect(find.byKey(const Key('host-here')), findsNothing);
      await tap(tester, 'open-hire-requests');
      await tester.pumpAndSettle();
      expect(path(router), '/me/hire-requests');
    });

    testWidgets('shows nothing for a professional, an event group, a blocked venue, or while hiring a venue is off', (tester) async {
      for (final p in [club(category: 'dj'), club(category: 'event_group'), club(blocked: true)]) {
        await openSocial(tester, site, '/', features: on, home: HireSection(profile: p));
        await settleCalls(tester);
        expect(find.byKey(const Key('host-here')), findsNothing);
        expect(find.byKey(const Key('open-hire-requests')), findsNothing);
        await tester.pumpWidget(const SizedBox());
      }
      site.rpcs['site_features'] = (_) => ok({'social': true, 'marketplace': true});
      await openSocial(tester, site, '/', features: {'social': true, 'marketplace': true}, home: HireSection(profile: club()));
      await settleCalls(tester);
      expect(find.byKey(const Key('host-here')), findsNothing);
    });
  });

  group('the Profile tab', () {
    testWidgets('leads a professional to their team, a group to its hires and a venue to its requests', (tester) async {
      final router = await openSocial(tester, site, '/', features: on, mine: [myPersonal(), myBusiness()], overrides: asDj, home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-team')), findsOneWidget);
      expect(find.byKey(const Key('open-hires')), findsNothing);
      expect(find.byKey(const Key('open-hire-requests-link')), findsNothing);
      await tap(tester, 'open-team');
      await tester.pumpAndSettle();
      expect(path(router), '/me/team');
    });

    testWidgets('a group sees its hires', (tester) async {
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), groupProfile()]);
      final router = await openSocial(tester, site, '/', features: on, overrides: [selectedProfileIdProvider.overrideWith((ref) => 'grp')], home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-team')), findsNothing, reason: 'an event group is run from BottlesUp Business');
      await tap(tester, 'open-hires');
      await tester.pumpAndSettle();
      expect(path(router), '/me/hires');
    });

    testWidgets('a venue sees its requests', (tester) async {
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), {...clubProfile(), 'is_mine': true}]);
      final router = await openSocial(tester, site, '/', features: on, overrides: [selectedProfileIdProvider.overrideWith((ref) => 'club')], home: const SocialEntryCard());
      await settleCalls(tester);
      await tap(tester, 'open-hire-requests-link');
      await tester.pumpAndSettle();
      expect(path(router), '/me/hire-requests');
      expect(find.byKey(const Key('open-team')), findsNothing);
    });

    testWidgets('a group does not see its hires while hiring a venue is off', (tester) async {
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), groupProfile()]);
      site.rpcs['site_features'] = (_) => ok({'social': true, 'marketplace': true});
      await openSocial(tester, site, '/', features: {'social': true, 'marketplace': true}, overrides: [selectedProfileIdProvider.overrideWith((ref) => 'grp')], home: const SocialEntryCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('open-hires')), findsNothing);
    });

    testWidgets('shows none of these while teams and hiring a venue are off', (tester) async {
      site.rpcs['site_features'] = (_) => ok({'social': true});
      await openSocial(tester, site, '/', features: {'social': true}, mine: [myPersonal(), myBusiness()], overrides: asDj, home: const SocialEntryCard());
      await settleCalls(tester);
      expect([for (final k in ['open-team', 'open-hires', 'open-hire-requests-link']) find.byKey(Key(k)).evaluate().length], [0, 0, 0]);
    });
  });
}
