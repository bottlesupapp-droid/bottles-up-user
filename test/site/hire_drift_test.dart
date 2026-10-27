import 'package:bottles_up_user/site/models/hire.dart';
import 'package:bottles_up_user/site/rules/hire_rules.dart';
import 'package:bottles_up_user/site/services/hire_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/hire_fixtures.dart';
import '../support/website_files.dart';

/// The app against the website's venue-hire and teams migration (and the profile one, which holds the team table).
void main() {
  group('venue hire and teams against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    late String profiles;
    setUpAll(() {
      sql = migrationCode('venue_hire_teams');
      profiles = migrationCode('social_profiles');
    });

    String bodyOf(String fn) {
      final start = sql.indexOf('create function public.$fn(');
      expect(start, greaterThanOrEqualTo(0), reason: fn);
      final end = sql.indexOf('\ncreate function', start + 10);
      return sql.substring(start, end == -1 ? sql.length : end);
    }

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final s = HireService(site.client);
      site.rpcs['team_list'] = (_) => ok(teamInfoRow());
      for (final f in ['team_invite', 'team_answer', 'team_revoke', 'team_leave', 'team_set_role']) {
        site.rpcs[f] = (_) => ok(teamMemberRow());
      }
      site.rpcs['team_invitations_mine'] = (_) => ok(<Object>[]);
      site.rpcs['team_my_access'] = (_) => ok({'owner': true, 'permissions': <String>[]});
      for (final f in ['hire_request', 'hire_get', 'hire_offer_send', 'hire_offer_withdraw', 'hire_offer_decline', 'hire_decline', 'hire_withdraw', 'hire_agree', 'hire_confirm', 'hire_cancel', 'hire_link_event', 'hire_unlink_event']) {
        site.rpcs[f] = (_) => ok(hireRow());
      }
      site.rpcs['hires_mine'] = (_) => ok(<Object>[]);
      site.rpcs['hires_for'] = (_) => ok(<Object>[]);
      site.rpcs['hire_workspace'] = (_) => ok(workspaceRow());
      site.rpcs['hire_item_add'] = (_) => ok(hireItemRow());
      site.rpcs['hire_item_set'] = (_) => ok(hireItemRow());
      site.rpcs['hire_item_remove'] = (_) => ok(null);
      site.rpcs['hire_attach_booking'] = (_) => ok(<String, Object>{});
      site.rpcs['hire_detach_booking'] = (_) => ok(null);
      site.rpcs['hire_events_linkable'] = (_) => ok(<Object>[]);

      await s.team('p');
      await s.invite(actor: 'p', handle: 'a', role: TeamRole.custom, permissions: {'content'});
      await s.answerInvitation(team: 't', accept: true);
      await s.revoke(actor: 'p', team: 't');
      await s.leave('t');
      await s.setRole(actor: 'p', team: 't', role: TeamRole.custom, permissions: {'content'});
      await s.invitations();
      await s.access('p');
      await s.request(actor: 'g', venue: 'v', date: DateTime(2099), eventType: 'abc', hours: 'h', attendance: 1, space: 's', equipment: 'e', staffing: 'f', budgetCents: 1, notes: 'n');
      await s.hiresMine('g');
      await s.hiresFor('v');
      await s.hire(actor: 'g', hire: 'h', side: HireSide.organizer);
      await s.sendOffer(actor: 'v', hire: 'h', rentalCents: 1, depositCents: 1, minSalesCents: 0, barShareBps: 0, control: HireControl.venue, staffing: 's', equipment: 'e', cancellation: 'c', notes: 'n', validDays: 1);
      await s.withdrawOffer(actor: 'v', hire: 'h');
      await s.declineOffer(actor: 'g', hire: 'h');
      await s.decline(actor: 'v', hire: 'h', note: 'n');
      await s.withdraw(actor: 'g', hire: 'h');
      await s.agree(actor: 'g', hire: 'h');
      await s.confirm(actor: 'v', hire: 'h');
      await s.cancel(actor: 'g', hire: 'h', side: HireSide.organizer, reason: 'r');
      await s.workspace(actor: 'g', hire: 'h');
      await s.addItem(actor: 'g', hire: 'h', schedule: true, title: 'abc', atTime: '21:00');
      await s.setItem(actor: 'g', item: 'i', title: 'abc', done: true);
      await s.removeItem(actor: 'g', item: 'i');
      await s.attachBooking(actor: 'g', hire: 'h', booking: 'b');
      await s.detachBooking(actor: 'g', hire: 'h', booking: 'b');
      await s.linkableEvents(actor: 'g', hire: 'h');
      await s.linkEvent(actor: 'g', hire: 'h', event: 'e');
      await s.unlinkEvent(actor: 'g', hire: 'h');
      expect(site.rpcRequests.length, 29);
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('a person can call what a person calls, and the helpers are not for them', () {
      final people = RegExp(r'grant execute on function([\s\S]*?)to authenticated;', caseSensitive: false).allMatches(sql).map((m) => m.group(1)!).join('\n');
      for (final f in [
        'team_invite', 'team_answer', 'team_revoke', 'team_leave', 'team_set_role', 'team_list', 'team_invitations_mine', 'team_my_access', 'hire_request', 'hire_offer_send', 'hire_offer_withdraw',
        'hire_offer_decline', 'hire_decline', 'hire_withdraw', 'hire_agree', 'hire_confirm', 'hire_cancel', 'hire_get', 'hires_mine', 'hires_for', 'hire_item_add', 'hire_item_set',
        'hire_item_remove', 'hire_attach_booking', 'hire_detach_booking', 'hire_link_event', 'hire_unlink_event', 'hire_events_linkable', 'hire_workspace',
      ]) {
        expect(people, contains('public.$f('), reason: f);
      }
      for (final f in ['team_require_on', 'hire_require_on', 'chat_link_ensure', 'chat_link_join', 'chat_link_leave', 'hire_state', 'hire_side', 'hire_json', 'team_require_owner']) {
        expect(people, isNot(contains('public.$f(')), reason: '$f is internal');
      }
    });

    test('the roles the app knows carry what the website says they carry', () {
      final fn = bodyOf('team_role_permissions');
      for (final r in TeamRole.values) {
        if (r == TeamRole.custom) continue;
        final m = RegExp("when '${r.wire}' then array\\[([^\\]]*)\\]").firstMatch(fn);
        expect(m, isNotNull, reason: r.wire);
        final got = {for (final x in RegExp("'([a-z]+)'").allMatches(m!.group(1)!)) x.group(1)!};
        expect(got, r.permissions, reason: r.wire);
      }
      expect(sqlWordsAfter(profiles, "role text not null check (role in"), {for (final r in TeamRole.values) r.wire});
      expect(sqlWordsInBrackets(profiles, 'permissions <@'), teamPermissionLabels.keys.toSet());
    });

    test('the states, the controls and the item kinds the app knows are the website\'s', () {
      final state = bodyOf('hire_state');
      final words = {for (final m in RegExp(r"then '([a-z_]+)'").allMatches(state)) m.group(1)!, 'requested', 'offered', 'agreed', 'confirmed', 'declined', 'withdrawn', 'cancelled'};
      expect(words, {for (final s in HireState.values) s.wire});
      expect(sqlWordsAfter(sql, "status text not null default 'requested' check (status in"), {'requested', 'offered', 'agreed', 'confirmed', 'declined', 'withdrawn', 'cancelled'});
      expect(sqlWordsAfter(sql, 'control text not null check (control in'), {for (final c in HireControl.values) c.wire});
      expect(sqlWordsAfter(sql, 'kind text not null check (kind in (\'task\''), {'task', 'schedule'});
    });

    test('the fields the app reads of a hire, an offer, an item and the workspace are the ones the website writes', () {
      final hire = bodyOf('hire_json');
      for (final k in ['id', 'state', 'event_date', 'hours', 'event_type', 'attendance', 'space', 'equipment', 'staffing', 'budget_cents', 'notes', 'decline_note', 'cancelled_by', 'cancel_reason', 'event_id', 'confirmed_at', 'created_at', 'organizer', 'venue', 'requested_by', 'offer']) {
        expect(hire, contains("'$k'"), reason: 'hire.$k');
      }
      final offer = bodyOf('hire_offer_json');
      for (final k in ['id', 'rental_cents', 'deposit_cents', 'min_sales_cents', 'bar_share_bps', 'control', 'staffing', 'equipment', 'cancellation', 'notes', 'valid_until', 'status']) {
        expect(offer, contains("'$k'"), reason: 'offer.$k');
      }
      final item = bodyOf('hire_item_json');
      for (final k in ['id', 'kind', 'title', 'at_time', 'due_on', 'done', 'side']) {
        expect(item, contains("'$k'"), reason: 'item.$k');
      }
      final ws = bodyOf('hire_workspace');
      for (final k in ['hire', 'side', 'open', 'items', 'bookings', 'event', 'pending', 'hire_chat', 'event_chat', 'confirmed', 'provider', 'tickets_sold', 'tickets_capacity', 'start_date']) {
        expect(ws, contains("'$k'"), reason: 'workspace.$k');
      }
      final team = bodyOf('team_member_json');
      for (final k in ['id', 'role', 'permissions', 'status', 'invited_at', 'person']) {
        expect(team, contains("'$k'"), reason: 'member.$k');
      }
      final list = bodyOf('team_list');
      for (final k in ['can_manage', 'owner', 'members', 'chat', 'chat_profile']) {
        expect(list, contains("'$k'"), reason: 'team.$k');
      }
      final inv = bodyOf('team_invitations_mine');
      for (final k in ['id', 'role', 'permissions', 'invited_at', 'profile']) {
        expect(inv, contains("'$k'"), reason: 'invitation.$k');
      }
      final access = bodyOf('team_my_access');
      for (final k in ['owner', 'permissions']) {
        expect(access, contains("'$k'"), reason: 'access.$k');
      }
    });

    test('the limits the app checks first are the website\'s', () {
      final request = bodyOf('hire_request');
      expect(request, contains('p_date <= current_date or p_date > current_date + 730'));
      expect(request, contains("raise exception 'Say what kind of event it is in $minEventTypeLength to $maxEventTypeLength characters.'"));
      expect(request, contains("raise exception 'Choose an expected attendance between 1 and 100,000.'"));
      expect(request, contains('p_budget_cents > $maxHireCents'));
      expect(request, contains('>= 5 then raise exception'));
      final offer = bodyOf('hire_offer_send');
      expect(offer, contains("raise exception 'An offer can stay open for 1 to $maxOfferDays days.'"));
      expect(offer, contains('p_bar_share_bps > 10000'));
      expect(offer, contains('p_rental_cents > $maxHireCents'));
      expect(offer, contains("'venue', 'organizer', 'shared'"));
      expect(bodyOf('hire_item_add'), contains(">= $maxWorkspaceItems then raise exception 'A workspace holds up to $maxWorkspaceItems items.'"));
      expect(bodyOf('hire_item_add'), contains("raise exception 'Give it a title of $minItemTitleLength to $maxItemTitleLength characters.'"));
      expect(bodyOf('team_invite'), contains(">= $maxTeamSize then raise exception 'A team can have up to $maxTeamSize people.'"));
      expect(bodyOf('hire_cancel'), contains('h.event_date <= current_date'));
    });
  });
}
