import 'package:bottles_up_user/site/models/hire.dart';
import 'package:bottles_up_user/site/services/hire_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/hire_fixtures.dart';

void main() {
  late FakeWebsite site;
  late HireService service;

  setUp(() {
    site = FakeWebsite();
    service = HireService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  group('teams', () {
    test('the team is read for a profile', () async {
      site.rpcs['team_list'] = (_) => ok(teamInfoRow(chat: 'c1'));
      final t = await service.team('p-dj');
      expect([t.canManage, t.members.length, t.chat], [true, 1, 'c1']);
      expect(site.forRpc('team_list').single.body, {'p_actor': 'p-dj'});
    });

    test('an unreadable team is an error, a refusal is its sentence', () async {
      site.rpcs['team_list'] = (_) => ok('nonsense');
      await expectLater(service.team('p'), throwsA(isA<SiteException>()));
      site.rpcs['team_list'] = (_) => raised('You cannot act as this profile.');
      await expectLater(service.team('p'), sentence('You cannot act as this profile.'));
    });

    test('inviting sends the username without the @ and in lower case, and the role; only a custom role sends its pick', () async {
      site.rpcs['team_invite'] = (_) => ok(teamMemberRow(status: 'invited'));
      await service.invite(actor: 'p-dj', handle: ' @AnnTeam ', role: TeamRole.bookingAgent, permissions: {'content'});
      expect(site.forRpc('team_invite').single.body, {'p_actor': 'p-dj', 'p_handle': 'annteam', 'p_role': 'booking_agent', 'p_permissions': null});
      await service.invite(actor: 'p-dj', handle: 'bobteam', role: TeamRole.custom, permissions: {'finance', 'bookings'});
      final sent = site.forRpc('team_invite').last.body;
      expect([sent['p_role'], (sent['p_permissions'] as List).toSet()], ['custom', {'finance', 'bookings'}]);
      await service.invite(actor: 'p-dj', handle: 'bobteam', role: TeamRole.custom);
      expect(site.forRpc('team_invite').last.body['p_permissions'], <String>[]);
    });

    test('a refused invitation is its sentence', () async {
      site.rpcs['team_invite'] = (_) => raised('No one has that username.');
      await expectLater(service.invite(actor: 'p', handle: 'x', role: TeamRole.manager), sentence('No one has that username.'));
      site.rpcs['team_invite'] = (_) => ok(null);
      await expectLater(service.invite(actor: 'p', handle: 'x', role: TeamRole.manager), throwsA(isA<SiteException>()));
    });

    test('answering, revoking, leaving and changing a role name what they act on', () async {
      site.rpcs['team_answer'] = (_) => ok(teamMemberRow());
      site.rpcs['team_revoke'] = (_) => ok(teamMemberRow(status: 'revoked'));
      site.rpcs['team_leave'] = (_) => ok(teamMemberRow(status: 'left'));
      site.rpcs['team_set_role'] = (_) => ok(teamMemberRow(role: 'manager'));
      await service.answerInvitation(team: 'tm1', accept: false);
      expect(site.forRpc('team_answer').single.body, {'p_team': 'tm1', 'p_accept': false});
      await service.revoke(actor: 'p-dj', team: 'tm1');
      expect(site.forRpc('team_revoke').single.body, {'p_actor': 'p-dj', 'p_team': 'tm1'});
      await service.leave('tm1');
      expect(site.forRpc('team_leave').single.body, {'p_team': 'tm1'});
      final m = await service.setRole(actor: 'p-dj', team: 'tm1', role: TeamRole.manager, permissions: {'content'});
      expect(m.role, TeamRole.manager);
      expect(site.forRpc('team_set_role').single.body, {'p_actor': 'p-dj', 'p_team': 'tm1', 'p_role': 'manager', 'p_permissions': null});
      await service.setRole(actor: 'p-dj', team: 'tm1', role: TeamRole.custom, permissions: {'content'});
      expect(site.forRpc('team_set_role').last.body['p_permissions'], ['content']);
    });

    test('invitations and a profile\'s access are read', () async {
      site.rpcs['team_invitations_mine'] = (_) => ok([teamInvitationRow()]);
      site.rpcs['team_my_access'] = (_) => ok({'owner': false, 'permissions': ['bookings']});
      expect((await service.invitations()).single.role, TeamRole.contentManager);
      expect(site.forRpc('team_invitations_mine').single.body, isEmpty);
      final a = await service.access('p-dj');
      expect([a.owner, a.permissions], [false, {'bookings'}]);
      expect(site.forRpc('team_my_access').single.body, {'p_profile': 'p-dj'});
      site.rpcs['team_my_access'] = (_) => ok('nonsense');
      final none = await service.access('p-dj');
      expect([none.owner, none.permissions], [false, isEmpty]);
    });
  });

  group('asking a venue', () {
    test('sends the day, the words trimmed, blanks as nothing, and answers the hire for the group', () async {
      site.rpcs['hire_request'] = (_) => ok(hireRow());
      final h = await service.request(actor: 'grp', venue: 'club', date: DateTime(2099, 11, 8, 23, 59), eventType: ' Themed night ', hours: ' 9pm to 3am ', attendance: 400, space: '  ', equipment: null, staffing: 'Two bartenders', budgetCents: 500000, notes: ' Low lights ');
      expect([h.id, h.side], ['hr1', HireSide.organizer]);
      expect(site.forRpc('hire_request').single.body, {
        'p_actor': 'grp',
        'p_venue': 'club',
        'p_date': '2099-11-08',
        'p_hours': '9pm to 3am',
        'p_type': 'Themed night',
        'p_attendance': 400,
        'p_space': null,
        'p_equipment': null,
        'p_staffing': 'Two bartenders',
        'p_budget_cents': 500000,
        'p_notes': 'Low lights',
      });
    });

    test('a refusal is its sentence, an unreadable answer is an error', () async {
      site.rpcs['hire_request'] = (_) => raised('This venue is not available.');
      await expectLater(service.request(actor: 'g', venue: 'c', date: DateTime(2099), eventType: 'abc'), sentence('This venue is not available.'));
      site.rpcs['hire_request'] = (_) => ok({'oops': 1});
      await expectLater(service.request(actor: 'g', venue: 'c', date: DateTime(2099), eventType: 'abc'), throwsA(isA<SiteException>().having((e) => e.message, 'm', contains('Look at your hires'))));
    });

    test('the lists are read for the right side', () async {
      site.rpcs['hires_mine'] = (_) => ok([hireRow()]);
      site.rpcs['hires_for'] = (_) => ok([hireRow(asker: {'name': 'Gus', 'handle': 'gus'})]);
      expect((await service.hiresMine('grp')).single.side, HireSide.organizer);
      expect((await service.hiresFor('club')).single.side, HireSide.venue);
      expect((await service.hiresFor('club')).single.requestedBy?.name, 'Gus');
      expect(site.forRpc('hires_mine').single.body, {'p_actor': 'grp'});
      expect(site.forRpc('hires_for').first.body, {'p_actor': 'club'});
    });

    test('one hire is read for the side the caller is on', () async {
      site.rpcs['hire_get'] = (_) => ok(hireRow());
      final h = await service.hire(actor: 'club', hire: 'hr1', side: HireSide.venue);
      expect(h.side, HireSide.venue);
      expect(site.forRpc('hire_get').single.body, {'p_actor': 'club', 'p_hire': 'hr1'});
    });
  });

  group('offers and answers', () {
    test('an offer sends the terms, blanks as nothing, and the days it stays open', () async {
      site.rpcs['hire_offer_send'] = (_) => ok(hireRow(state: 'offered', offer: hireOfferRow()));
      final h = await service.sendOffer(
        actor: 'club',
        hire: 'hr1',
        rentalCents: 450000,
        depositCents: 100000,
        minSalesCents: 300000,
        barShareBps: 2000,
        control: HireControl.shared,
        staffing: ' Two bartenders ',
        equipment: '',
        cancellation: ' Lose the deposit ',
        notes: null,
        validDays: 7,
      );
      expect([h.state, h.side], [HireState.offered, HireSide.venue]);
      expect(site.forRpc('hire_offer_send').single.body, {
        'p_actor': 'club',
        'p_hire': 'hr1',
        'p_rental_cents': 450000,
        'p_deposit_cents': 100000,
        'p_min_sales_cents': 300000,
        'p_bar_share_bps': 2000,
        'p_control': 'shared',
        'p_staffing': 'Two bartenders',
        'p_equipment': null,
        'p_cancellation': 'Lose the deposit',
        'p_notes': null,
        'p_valid_days': 7,
      });
    });

    test('each answer asks the right function, as the right profile, and reads the hire for the right side', () async {
      for (final f in ['hire_offer_withdraw', 'hire_offer_decline', 'hire_decline', 'hire_withdraw', 'hire_agree', 'hire_confirm', 'hire_cancel']) {
        site.rpcs[f] = (_) => ok(hireRow());
      }
      expect((await service.withdrawOffer(actor: 'club', hire: 'hr1')).side, HireSide.venue);
      expect((await service.declineOffer(actor: 'grp', hire: 'hr1')).side, HireSide.organizer);
      expect((await service.decline(actor: 'club', hire: 'hr1', note: ' Booked out ')).side, HireSide.venue);
      expect((await service.withdraw(actor: 'grp', hire: 'hr1')).side, HireSide.organizer);
      expect((await service.agree(actor: 'grp', hire: 'hr1')).side, HireSide.organizer);
      expect((await service.confirm(actor: 'club', hire: 'hr1')).side, HireSide.venue);
      expect((await service.cancel(actor: 'grp', hire: 'hr1', side: HireSide.organizer, reason: ' Changed my mind ')).side, HireSide.organizer);
      expect((await service.cancel(actor: 'club', hire: 'hr1', side: HireSide.venue)).side, HireSide.venue);
      expect(site.forRpc('hire_decline').single.body, {'p_actor': 'club', 'p_hire': 'hr1', 'p_note': 'Booked out'});
      expect(site.forRpc('hire_cancel').first.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_reason': 'Changed my mind'});
      expect(site.forRpc('hire_cancel').last.body['p_reason'], null);
      for (final f in ['hire_offer_withdraw', 'hire_offer_decline', 'hire_withdraw', 'hire_agree', 'hire_confirm']) {
        expect(site.forRpc(f).single.body.keys.toSet(), {'p_actor', 'p_hire'}, reason: f);
      }
    });

    test('a refusal is its sentence', () async {
      site.rpcs['hire_agree'] = (_) => raised('This offer has expired. Ask the venue for a new one.');
      await expectLater(service.agree(actor: 'g', hire: 'h'), sentence('This offer has expired. Ask the venue for a new one.'));
      site.rpcs['hire_confirm'] = (_) => raised('This venue is already booked for a hire that day.');
      await expectLater(service.confirm(actor: 'c', hire: 'h'), sentence('This venue is already booked for a hire that day.'));
    });
  });

  group('the workspace', () {
    test('is read for the actor', () async {
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow(items: [hireItemRow()], event: linkedEventRow()));
      final w = await service.workspace(actor: 'grp', hire: 'hr1');
      expect([w.items.length, w.event?.title], [1, 'Themed night']);
      expect(site.forRpc('hire_workspace').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
      site.rpcs['hire_workspace'] = (_) => ok('nonsense');
      await expectLater(service.workspace(actor: 'grp', hire: 'hr1'), throwsA(isA<SiteException>()));
    });

    test('adding a task sends its day, adding a schedule item sends its time, never both', () async {
      site.rpcs['hire_item_add'] = (_) => ok(hireItemRow());
      await service.addItem(actor: 'grp', hire: 'hr1', schedule: false, title: ' Send the lineup ', atTime: '21:00', dueOn: DateTime(2099, 11, 1, 23));
      expect(site.forRpc('hire_item_add').last.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_kind': 'task', 'p_title': 'Send the lineup', 'p_at': null, 'p_due': '2099-11-01'});
      await service.addItem(actor: 'grp', hire: 'hr1', schedule: true, title: 'Doors open', atTime: '21:00', dueOn: DateTime(2099, 11, 1));
      expect(site.forRpc('hire_item_add').last.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_kind': 'schedule', 'p_title': 'Doors open', 'p_at': '21:00', 'p_due': null});
      await service.addItem(actor: 'grp', hire: 'hr1', schedule: false, title: 'No day');
      expect(site.forRpc('hire_item_add').last.body['p_due'], null);
    });

    test('ticking, renaming and removing an item name it', () async {
      site.rpcs['hire_item_set'] = (_) => ok(hireItemRow(done: true));
      site.rpcs['hire_item_remove'] = (_) => ok(null);
      expect((await service.setItem(actor: 'grp', item: 'it1', done: true)).done, isTrue);
      expect(site.forRpc('hire_item_set').single.body, {'p_actor': 'grp', 'p_item': 'it1', 'p_title': null, 'p_done': true});
      await service.setItem(actor: 'grp', item: 'it1', title: ' New title ');
      expect(site.forRpc('hire_item_set').last.body, {'p_actor': 'grp', 'p_item': 'it1', 'p_title': 'New title', 'p_done': null});
      await service.removeItem(actor: 'grp', item: 'it1');
      expect(site.forRpc('hire_item_remove').single.body, {'p_actor': 'grp', 'p_item': 'it1'});
    });

    test('attaching and taking off a professional name the booking', () async {
      site.rpcs['hire_attach_booking'] = (_) => ok({'attached': true});
      site.rpcs['hire_detach_booking'] = (_) => ok(null);
      await service.attachBooking(actor: 'grp', hire: 'hr1', booking: 'pb1');
      await service.detachBooking(actor: 'grp', hire: 'hr1', booking: 'pb1');
      expect(site.forRpc('hire_attach_booking').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_booking': 'pb1'});
      expect(site.forRpc('hire_detach_booking').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_booking': 'pb1'});
    });

    test('the events that could be linked are listed, linked and unlinked', () async {
      site.rpcs['hire_events_linkable'] = (_) => ok([
            {'id': 'ev1', 'title': 'Themed night', 'start_date': '2099-11-08T21:00:00Z'}
          ]);
      site.rpcs['hire_link_event'] = (_) => ok(hireRow(state: 'confirmed', eventId: 'ev1'));
      site.rpcs['hire_unlink_event'] = (_) => ok(hireRow(state: 'confirmed'));
      expect((await service.linkableEvents(actor: 'grp', hire: 'hr1')).single.title, 'Themed night');
      expect((await service.linkEvent(actor: 'grp', hire: 'hr1', event: 'ev1')).eventId, 'ev1');
      expect((await service.unlinkEvent(actor: 'grp', hire: 'hr1')).eventId, isNull);
      expect(site.forRpc('hire_events_linkable').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
      expect(site.forRpc('hire_link_event').single.body, {'p_actor': 'grp', 'p_hire': 'hr1', 'p_event': 'ev1'});
      expect(site.forRpc('hire_unlink_event').single.body, {'p_actor': 'grp', 'p_hire': 'hr1'});
    });
  });
}
