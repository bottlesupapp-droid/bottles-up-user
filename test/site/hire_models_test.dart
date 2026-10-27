import 'package:bottles_up_user/site/models/hire.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/hire_fixtures.dart';

void main() {
  group('the state of a hire', () {
    test('every state the website names is known, and says whether it is booked or over', () {
      for (final s in ['requested', 'offered', 'offer_expired', 'agreed', 'confirmed', 'declined', 'withdrawn', 'cancelled', 'lapsed', 'completed']) {
        expect(HireState.fromWire(s)?.wire, s);
      }
      expect(HireState.fromWire('booked'), isNull);
      expect(HireState.fromWire(null), isNull);
      expect([for (final s in HireState.values) if (s.isBooked) s.wire], ['confirmed', 'completed']);
      expect([for (final s in HireState.values) if (s.isClosed) s.wire], ['declined', 'withdrawn', 'cancelled', 'lapsed', 'completed']);
    });

    test('an agreement is not a booking, in the words', () {
      expect(HireState.agreed.label, contains('waiting for the venue'));
      expect(HireState.requested.label, 'Waiting for an offer');
      expect(HireState.offerExpired.label, 'Offer ran out');
    });

    test('who controls sales is one of three', () {
      expect([for (final c in HireControl.values) c.wire], ['venue', 'organizer', 'shared']);
      expect(HireControl.fromWire('shared'), HireControl.shared);
      expect(HireControl.fromWire('nobody'), isNull);
      expect([for (final c in HireControl.values) c.label], ['The venue', 'The group', 'Shared']);
    });
  });

  group('an offer', () {
    test('is read in full', () {
      final o = parseHireOffer(hireOfferRow())!;
      expect([o.id, o.rentalCents, o.depositCents, o.minSalesCents, o.barShareBps, o.control, o.status, o.isLive, o.isAccepted], ['of1', 450000, 100000, 300000, 2000, HireControl.shared, 'sent', true, false]);
      expect([o.staffing, o.equipment, o.cancellation, o.notes], ['Two bartenders included', 'House sound', 'Lose the deposit within 14 days', null]);
      expect(o.validUntil.toUtc(), DateTime.utc(2099, 10, 30, 12));
    });

    test('says the bar share as a percentage', () {
      expect(parseHireOffer(hireOfferRow(barShare: 2000))!.barShareText, '20%');
      expect(parseHireOffer(hireOfferRow(barShare: 1250))!.barShareText, '12.5%');
      expect(parseHireOffer(hireOfferRow(barShare: 0))!.barShareText, '0%');
      expect(parseHireOffer(hireOfferRow(barShare: 10000))!.barShareText, '100%');
    });

    test('knows an accepted one from a live one', () {
      expect(parseHireOffer(hireOfferRow(status: 'accepted'))!.isAccepted, isTrue);
      expect(parseHireOffer(hireOfferRow(status: 'accepted'))!.isLive, isFalse);
      expect(parseHireOffer(hireOfferRow(status: 'expired'))!.isLive, isFalse);
    });

    test('defaults the optional numbers and drops what cannot be read', () {
      final bare = hireOfferRow()..remove('min_sales_cents')..remove('bar_share_bps');
      final o = parseHireOffer(bare)!;
      expect([o.minSalesCents, o.barShareBps], [0, 0]);
      expect(parseHireOffer(hireOfferRow(deposit: 450000)), isNotNull, reason: 'the whole rental as the deposit is fine');
      expect(parseHireOffer(hireOfferRow(deposit: 450001)), isNull, reason: 'a deposit above the rental cost is not an offer');
      expect(parseHireOffer(hireOfferRow(rental: -1)), isNull);
      expect(parseHireOffer(hireOfferRow(deposit: -1)), isNull);
      expect(parseHireOffer(hireOfferRow(control: 'nobody')), isNull);
      expect(parseHireOffer(hireOfferRow(valid: 'soon')), isNull);
      expect(parseHireOffer({...hireOfferRow(), 'id': null}), isNull);
      expect(parseHireOffer({...hireOfferRow(), 'status': null}), isNull);
      expect(parseHireOffer('x'), isNull);
      expect(parseHireOffer(null), isNull);
    });
  });

  group('a hire', () {
    test('is read in full, for the group', () {
      final h = parseHire(hireRow(offer: hireOfferRow()), HireSide.organizer)!;
      expect([h.id, h.state, h.eventType, h.hours, h.attendance, h.space, h.equipment, h.staffing, h.budgetCents, h.notes], ['hr1', HireState.requested, 'Themed night', '9pm to 3am', 400, 'Main room', 'Own DJ booth', 'Two bartenders', 500000, 'Please keep the lights low']);
      expect([h.eventDate, h.side, h.organizer?.displayName, h.venue?.displayName, h.requestedBy, h.offer?.id], [DateTime(2099, 11, 8), HireSide.organizer, 'EONICS', 'Club X', null, 'of1']);
      expect(h.createdAt.toUtc(), DateTime.utc(2099, 10, 24, 12));
    });

    test('shows the venue who asked', () {
      final h = parseHire(hireRow(asker: {'name': 'Gus Group', 'handle': 'gus'}), HireSide.venue)!;
      expect([h.requestedBy?.name, h.requestedBy?.handle, h.side], ['Gus Group', 'gus', HireSide.venue]);
    });

    test('knows the other side and its own', () {
      final g = parseHire(hireRow(), HireSide.organizer)!;
      expect([g.other?.displayName, g.mine?.displayName], ['Club X', 'EONICS']);
      final v = parseHire(hireRow(), HireSide.venue)!;
      expect([v.other?.displayName, v.mine?.displayName], ['EONICS', 'Club X']);
    });

    test('has a live offer only while offered and the offer is still sent', () {
      expect(parseHire(hireRow(state: 'offered', offer: hireOfferRow()), HireSide.organizer)!.hasLiveOffer, isTrue);
      expect(parseHire(hireRow(state: 'requested', offer: hireOfferRow()), HireSide.organizer)!.hasLiveOffer, isFalse);
      expect(parseHire(hireRow(state: 'offered', offer: hireOfferRow(status: 'expired')), HireSide.organizer)!.hasLiveOffer, isFalse);
      expect(parseHire(hireRow(state: 'offered'), HireSide.organizer)!.hasLiveOffer, isFalse);
      expect(parseHire(hireRow(state: 'offer_expired', offer: hireOfferRow(status: 'expired')), HireSide.organizer)!.hasLiveOffer, isFalse);
    });

    test('carries what happened when it ended', () {
      final h = parseHire(hireRow(state: 'cancelled', cancelledBy: 'venue', cancelReason: 'Flood in the cellar', declineNote: 'x', eventId: 'ev1'), HireSide.organizer)!;
      expect([h.cancelledBy, h.cancelReason, h.declineNote, h.eventId], ['venue', 'Flood in the cellar', 'x', 'ev1']);
      expect(parseHire(hireRow(state: 'confirmed'), HireSide.organizer)!.confirmedAt?.toUtc(), DateTime.utc(2099, 10, 26, 12));
    });

    test('drops what cannot be read', () {
      for (final bad in [
        {...hireRow(), 'id': null},
        {...hireRow(), 'state': 'booked'},
        {...hireRow(), 'event_date': 'tomorrow'},
        {...hireRow(), 'event_type': null},
        {...hireRow(), 'created_at': 'then'},
      ]) {
        expect(parseHire(bad, HireSide.organizer), isNull);
      }
      expect(parseHire('x', HireSide.organizer), isNull);
      expect(parseHires([hireRow(), {'id': 'bad'}, hireRow(id: 'hr2')], HireSide.venue).map((h) => h.id).toList(), ['hr1', 'hr2']);
      expect(parseHires(null, HireSide.venue), isEmpty);
    });
  });

  group('the workspace', () {
    test('is read in full', () {
      final w = parseWorkspace(workspaceRow(
        side: 'venue',
        items: [hireItemRow(kind: 'schedule', title: 'Doors open', at: '21:00', side: 'venue'), hireItemRow(due: '2099-11-01')],
        bookings: [lineupRow(), lineupRow(id: 'pb2', title: 'Photos', confirmed: true, state: 'paid')],
        event: linkedEventRow(),
        pending: ['No public event is linked yet.', '1 open task.'],
        hireChat: 'c1',
        eventChat: 'c2',
      ))!;
      expect([w.side, w.open, w.hire.state, w.hire.side], [HireSide.venue, true, HireState.confirmed, HireSide.venue]);
      expect([for (final i in w.items) '${i.isSchedule}/${i.title}/${i.atTime}/${i.side.name}/${i.done}'], ['true/Doors open/21:00/venue/false', 'false/Send the lineup/null/organizer/false']);
      expect(w.items.last.dueOn, DateTime(2099, 11, 1));
      expect([for (final b in w.lineup) '${b.bookingId}/${b.title}/${b.confirmed}/${b.state?.wire}/${b.provider?.displayName}'], ['pb1/DJ set/false/awaiting_deposit/DJ Dee', 'pb2/Photos/true/paid/DJ Dee']);
      expect([w.event?.id, w.event?.title, w.event?.ticketsSold, w.event?.ticketsCapacity], ['ev1', 'Themed night', 130, 350]);
      expect(w.pending, ['No public event is linked yet.', '1 open task.']);
      expect([w.hireChat, w.eventChat], ['c1', 'c2']);
    });

    test('is empty where nothing is attached, and not open when the website says so', () {
      final w = parseWorkspace(workspaceRow(open: false))!;
      expect([w.open, w.items, w.lineup, w.pending, w.event, w.hireChat, w.eventChat], [false, isEmpty, isEmpty, isEmpty, null, null, null]);
    });

    test('is dropped when the side or the hire cannot be read', () {
      expect(parseWorkspace({...workspaceRow(), 'side': 'nobody'}), isNull);
      expect(parseWorkspace({...workspaceRow(), 'hire': 'x'}), isNull);
      expect(parseWorkspace(null), isNull);
    });

    test('drops items and lineup entries that cannot be read', () {
      final w = parseWorkspace(workspaceRow(
        items: [hireItemRow(kind: 'schedule', at: null), hireItemRow(kind: 'note'), hireItemRow(title: ''), hireItemRow(side: 'both'), hireItemRow(id: 'ok')],
        bookings: [{'title': 'no id'}, lineupRow()],
        pending: ['', 'one'],
      ))!;
      expect(w.items.map((i) => i.id).toList(), ['ok']);
      expect(w.lineup.length, 1);
      expect(w.pending, ['one']);
    });

    test('an item knows a done task from an open one', () {
      expect(parseHireItem(hireItemRow(done: true))!.done, isTrue);
      expect(parseHireItem(hireItemRow())!.done, isFalse);
      expect(parseHireItem(hireItemRow(kind: 'schedule', at: '09:30'))!.atTime, '09:30');
    });

    test('a linked event with no numbers has none', () {
      final e = parseLinkedEvent({'id': 'e', 'title': 't'})!;
      expect([e.ticketsSold, e.ticketsCapacity, e.startDate], [0, 0, null]);
      expect(parseLinkedEvent({'id': 'e'}), isNull);
      expect(parseLinkedEvent('x'), isNull);
    });

    test('the events that could be linked are read, and bad rows dropped', () {
      final l = parseLinkableEvents([
        {'id': 'e1', 'title': 'One', 'start_date': '2099-11-08T21:00:00Z'},
        {'id': 'e2'},
        {'title': 'No id'},
        'x',
        {'id': 'e3', 'title': 'Three'}
      ]);
      expect(l.map((e) => e.id).toList(), ['e1', 'e3']);
      expect(l.first.startDate?.toUtc(), DateTime.utc(2099, 11, 8, 21));
      expect(parseLinkableEvents(null), isEmpty);
    });
  });

  group('teams', () {
    test('a role knows what it may do, mirroring the website', () {
      expect(TeamRole.manager.permissions, {'bookings', 'content', 'finance'});
      expect(TeamRole.bookingAgent.permissions, {'bookings'});
      expect(TeamRole.contentManager.permissions, {'content'});
      expect(TeamRole.financeAssistant.permissions, {'finance'});
      expect(TeamRole.doorStaff.permissions, isEmpty);
      expect([for (final r in TeamRole.values) r.wire], ['manager', 'booking_agent', 'content_manager', 'finance_assistant', 'door_staff', 'custom']);
      expect(TeamRole.fromWire('boss'), isNull);
      expect(teamPermissionLabels.keys, ['bookings', 'content', 'finance']);
    });

    test('a member is read, with their person', () {
      final m = parseTeamMember(teamMemberRow(role: 'manager', permissions: ['bookings', 'content', 'finance']))!;
      expect([m.id, m.role, m.permissions, m.status, m.isActive, m.person?.name, m.person?.handle], ['tm1', TeamRole.manager, {'bookings', 'content', 'finance'}, 'active', true, 'Ann Lee', 'annteam']);
      expect(parseTeamMember(teamMemberRow(status: 'invited'))!.isActive, isFalse);
      expect(parseTeamMember(teamMemberRow(role: 'boss')), isNull);
      expect(parseTeamMember({...teamMemberRow(), 'id': null}), isNull);
      expect(parseTeamMember({...teamMemberRow(), 'status': null}), isNull);
      expect(parseTeamMember(null), isNull);
    });

    test('the team is read, with who may manage it and its chat', () {
      final t = parseTeamInfo(teamInfoRow(members: [teamMemberRow(), teamMemberRow(id: 'tm2', status: 'invited'), {'id': 'bad'}], chat: 'c1', chatProfile: 'p1'))!;
      expect([t.canManage, t.owner?.name, t.members.map((m) => m.id).toList(), t.chat, t.chatProfile], [true, 'Dee Dee', ['tm1', 'tm2'], 'c1', 'p1']);
      expect(parseTeamInfo(teamInfoRow(canManage: false))!.canManage, isFalse);
      expect(parseTeamInfo({'members': 'x'})!.members, isEmpty);
      expect(parseTeamInfo(null), isNull);
    });

    test('an invitation is read with the profile it is for', () {
      final i = parseTeamInvitations([teamInvitationRow(), {'id': 'x'}, teamInvitationRow(id: 'tm10', role: 'boss')]);
      expect(i.length, 1);
      expect([i.first.id, i.first.role, i.first.permissions, i.first.profile.displayName], ['tm9', TeamRole.contentManager, {'content'}, 'DJ Dee']);
      expect(parseTeamInvitations(null), isEmpty);
    });

    test('access: the owner may do everything, a member only what the role carries', () {
      final owner = parseProfileAccess({'owner': true, 'permissions': ['bookings', 'content', 'finance']})!;
      expect([owner.can('bookings'), owner.can('content'), owner.can('finance'), owner.can('anything')], [true, true, true, true]);
      final agent = parseProfileAccess({'owner': false, 'permissions': ['bookings']})!;
      expect([agent.can('bookings'), agent.can('content'), agent.can('finance')], [true, false, false]);
      expect(parseProfileAccess({'owner': false, 'permissions': []})!.can('bookings'), isFalse);
      expect(parseProfileAccess(null), isNull);
    });
  });
}
