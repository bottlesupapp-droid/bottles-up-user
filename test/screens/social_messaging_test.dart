import 'package:bottles_up_user/features/bookings_site/screens/table_booking_detail_screen.dart';
import 'package:bottles_up_user/features/social/widgets/message_venue_button.dart';
import 'package:bottles_up_user/features/social/widgets/social_entry_card.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 0});
    site.rpcs['notifications_unread'] = (_) => ok(0);
    site.rpcs['dm_conversation'] = (_) => ok(convRow(id: 'd1'));
    site.rpcs['dm_messages'] = (_) => ok(<Object>[]);
    site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
  });

  const on = {'social': true, 'inbox': true};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  /// Types in a search box and waits out the half-second pause before the search runs.
  Future<void> searchFor(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
  }

  group('a new message', () {
    testWidgets('finds people by what is typed, and tapping one opens the conversation', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')]);
      site.rpcs['dm_start_direct'] = (_) => ok({'id': 'd1'});
      final router = await openSocial(tester, site, '/inbox/new', features: on);
      expect(find.text('Type at least 2 letters.'), findsOneWidget);
      await searchFor(tester, 'person-search', 'sa');
      expect(site.forRpc('profile_search').single.body, {'p_actor': 'me', 'p_query': 'sa', 'p_limit': 20});
      await tester.tap(find.byKey(const Key('profile-sam')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_start_direct').single.body, {'p_actor': 'me', 'p_other': 'u-sam'});
      expect(path(router), '/inbox/d1');
    });

    testWidgets('one letter is not a search; nobody found says so', (tester) async {
      site.rpcs['profile_search'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/inbox/new', features: on);
      await searchFor(tester, 'person-search', 's');
      expect(site.forRpc('profile_search'), isEmpty);
      await searchFor(tester, 'person-search', 'zzzz');
      expect(find.byKey(const Key('no-people')), findsOneWidget);
    });

    testWidgets('a refusal is shown under the box and nothing opens', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')]);
      site.rpcs['dm_start_direct'] = (_) => raised('You can\'t message this person.');
      final router = await openSocial(tester, site, '/inbox/new', features: on);
      await searchFor(tester, 'person-search', 'sam');
      await tester.tap(find.byKey(const Key('profile-sam')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('new-message-problem')), findsOneWidget);
      expect(find.text('You can\'t message this person.'), findsOneWidget);
      expect(path(router), '/inbox/new');
    });

    testWidgets('a group needs a name and someone to add; then it is made', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park'), profileRow(id: 'u-ann', handle: 'ann', name: 'Ann Lee')]);
      site.rpcs['dm_start_group'] = (_) => ok({'id': 'g1'});
      site.rpcs['dm_conversation'] = (_) => ok(convRow(id: 'g1', kind: 'group', title: 'Crew'));
      final router = await openSocial(tester, site, '/inbox/new', features: on);
      await tester.tap(find.byKey(const Key('new-group')));
      await tester.pumpAndSettle();
      expect(path(router), '/inbox/new-group');
      await tester.ensureVisible(find.byKey(const Key('create-group')));
      await tester.tap(find.byKey(const Key('create-group')));
      await tester.pumpAndSettle();
      expect(find.text('Give the group a name.'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('group-name')), '  Crew ');
      await tester.ensureVisible(find.byKey(const Key('create-group')));
      await tester.tap(find.byKey(const Key('create-group')));
      await tester.pumpAndSettle();
      expect(find.text('Choose at least one person to add.'), findsOneWidget);
      await searchFor(tester, 'person-search', 'a');
      await searchFor(tester, 'person-search', 'an');
      await tester.tap(find.byKey(const Key('pick-sam')));
      await tester.tap(find.byKey(const Key('pick-ann')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('chosen-sam')), findsOneWidget);
      await tester.tap(find.byKey(const Key('pick-ann')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('chosen-ann')), findsNothing, reason: 'unticking takes the person off');
      await tester.ensureVisible(find.byKey(const Key('create-group')));
      await tester.tap(find.byKey(const Key('create-group')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_start_group').single.body, {'p_actor': 'me', 'p_title': 'Crew', 'p_members': ['u-sam']});
      expect(path(router), '/inbox/g1');
    });

    testWidgets('a refused group says why', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')]);
      site.rpcs['dm_start_group'] = (_) => raised('A group can have 50 people at most.');
      await openSocial(tester, site, '/inbox/new-group', features: on);
      await tester.enterText(find.byKey(const Key('group-name')), 'Crew');
      await searchFor(tester, 'person-search', 'sam');
      await tester.tap(find.byKey(const Key('pick-sam')));
      await tester.ensureVisible(find.byKey(const Key('create-group')));
      await tester.tap(find.byKey(const Key('create-group')));
      await tester.pumpAndSettle();
      expect(find.text('A group can have 50 people at most.'), findsOneWidget);
    });
  });

  group('group details', () {
    Map<String, dynamic> person(String id, String handle, {String role = 'member', String status = 'active'}) => {...profileRow(id: id, handle: handle, name: handle.toUpperCase()), 'role': role, 'status': status};

    late List<Map<String, dynamic>> people;
    late Map<String, dynamic> head;

    setUp(() {
      head = convRow(id: 'g1', kind: 'group', title: 'Crew', members: 3);
      people = [person('me', 'dana', role: 'admin'), person('u-sam', 'sam'), person('u-ann', 'ann', status: 'request')];
      site.rpcs['dm_conversation'] = (_) => ok(head);
      site.rpcs['dm_people'] = (_) => ok(people);
    });

    testWidgets('lists the people, who is an admin and who is only invited', (tester) async {
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      expect(find.text('Group details'), findsOneWidget);
      expect(tester.widget<ListTile>(find.byKey(const Key('group-title'))).title, isA<Text>());
      expect(find.text('3 people'), findsOneWidget);
      expect(find.byKey(const Key('admin-chip')), findsOneWidget);
      expect(find.byKey(const Key('invited')), findsOneWidget);
      expect(site.forRpc('dm_people').single.body, {'p_actor': 'me', 'p_conversation': 'g1'});
    });

    testWidgets('an admin can rename, add and remove people', (tester) async {
      site.rpcs['dm_group_rename'] = (b) {
        head = convRow(id: 'g1', kind: 'group', title: b['p_title'] as String, members: 3);
        return ok({'ok': true});
      };
      site.rpcs['dm_group_remove'] = (_) {
        people = [person('me', 'dana', role: 'admin'), person('u-ann', 'ann', status: 'request')];
        return ok({'ok': true});
      };
      site.rpcs['dm_group_add'] = (_) => ok({'ok': true});
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-zed', handle: 'zed', name: 'Zed')]);
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      await tester.tap(find.byKey(const Key('rename-group')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('rename-field')), 'Weekend crew');
      await tester.tap(find.byKey(const Key('rename-save')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_group_rename').single.body, {'p_actor': 'me', 'p_conversation': 'g1', 'p_title': 'Weekend crew'});
      expect(find.text('Weekend crew'), findsOneWidget);

      await tester.tap(find.byKey(const Key('remove-sam')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_group_remove').single.body, {'p_actor': 'me', 'p_conversation': 'g1', 'p_member': 'u-sam'});
      expect(find.byKey(const Key('profile-sam')), findsNothing);
      expect(find.byKey(const Key('remove-dana')), findsNothing, reason: 'you do not remove yourself, you leave');

      await tester.tap(find.byKey(const Key('add-person')));
      await tester.pumpAndSettle();
      await searchFor(tester, 'add-search', 'zed');
      await tester.tap(find.byKey(const Key('profile-zed')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_group_add').single.body, {'p_actor': 'me', 'p_conversation': 'g1', 'p_member': 'u-zed'});
    });

    testWidgets('someone who is not an admin can only mute and leave', (tester) async {
      people = [person('me', 'dana'), person('u-sam', 'sam', role: 'admin')];
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      expect(find.byKey(const Key('rename-group')), findsNothing);
      expect(find.byKey(const Key('add-person')), findsNothing);
      expect(find.byKey(const Key('remove-sam')), findsNothing);
      expect(find.byKey(const Key('mute-switch')), findsOneWidget);
      expect(find.byKey(const Key('leave-group')), findsOneWidget);
    });

    testWidgets('muting asks the website and shows the new state', (tester) async {
      site.rpcs['dm_mute'] = (b) {
        head = convRow(id: 'g1', kind: 'group', title: 'Crew', members: 3, muted: b['p_muted'] as bool);
        return ok({'muted': b['p_muted']});
      };
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('mute-switch'))).value, isFalse);
      await tester.tap(find.byKey(const Key('mute-switch')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_mute').single.body, {'p_actor': 'me', 'p_conversation': 'g1', 'p_muted': true});
      expect(tester.widget<SwitchListTile>(find.byKey(const Key('mute-switch'))).value, isTrue);
    });

    testWidgets('leaving goes back to the inbox', (tester) async {
      site.rpcs['dm_leave'] = (_) => ok({'ok': true});
      final router = await openSocial(tester, site, '/inbox/g1/info', features: on);
      await tester.ensureVisible(find.byKey(const Key('leave-group')));
      await tester.tap(find.byKey(const Key('leave-group')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_leave').single.body, {'p_actor': 'me', 'p_conversation': 'g1'});
      expect(path(router), '/inbox');
    });

    testWidgets('a refused leave is shown and the person stays in the group screen', (tester) async {
      site.rpcs['dm_leave'] = (_) => raised('You are the only admin. Make someone else an admin first.');
      final router = await openSocial(tester, site, '/inbox/g1/info', features: on);
      await tester.ensureVisible(find.byKey(const Key('leave-group')));
      await tester.tap(find.byKey(const Key('leave-group')));
      await tester.pumpAndSettle();
      expect(find.text('You are the only admin. Make someone else an admin first.'), findsOneWidget);
      expect(path(router), '/inbox/g1/info');
    });

    testWidgets('a refusal is shown and the screen stays', (tester) async {
      site.rpcs['dm_group_remove'] = (_) => raised('Only an admin can remove people.');
      final router = await openSocial(tester, site, '/inbox/g1/info', features: on);
      await tester.tap(find.byKey(const Key('remove-sam')));
      await tester.pumpAndSettle();
      expect(find.text('Only an admin can remove people.'), findsOneWidget);
      expect(path(router), '/inbox/g1/info');
    });

    testWidgets('a direct conversation has the person and a mute switch, but no group controls', (tester) async {
      head = convRow(id: 'g1');
      people = [person('me', 'dana'), person('u-bob', 'bob')];
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      expect(find.text('Details'), findsWidgets);
      expect(find.byKey(const Key('group-title')), findsNothing);
      expect(find.byKey(const Key('leave-group')), findsNothing);
      expect(find.byKey(const Key('mute-switch')), findsOneWidget);
      expect(find.byKey(const Key('profile-bob')), findsOneWidget);
    });

    testWidgets('a conversation that cannot be read says so', (tester) async {
      site.rpcs['dm_conversation'] = (_) => raised('This conversation isn\'t available.');
      await openSocial(tester, site, '/inbox/g1/info', features: on);
      expect(find.text('This conversation isn\'t available.'), findsOneWidget);
    });
  });

  group('sending a post to someone', () {
    Future<void> openPost(WidgetTester tester, {Map<String, bool> features = on, String audience = 'public', String kind = 'post'}) async {
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1', audience: audience, kind: kind, author: profileRow(id: 'u-ann', handle: 'ann', name: 'Ann')));
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/post/p1', features: features);
    }

    testWidgets('the button is there for a public post when messages are on', (tester) async {
      await openPost(tester);
      expect(find.byKey(const Key('share-p1')), findsOneWidget);
    });

    testWidgets('and not when messages are off', (tester) async {
      await openPost(tester, features: const {'social': true});
      expect(find.byKey(const Key('share-p1')), findsNothing);
    });

    testWidgets('a followers-only post cannot be sent on', (tester) async {
      await openPost(tester, audience: 'followers');
      expect(find.byKey(const Key('post-p1')), findsOneWidget);
      expect(find.byKey(const Key('share-p1')), findsNothing);
    });

    testWidgets('send it to a recent conversation, with a note', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'c1')]);
      site.rpcs['dm_send'] = (_) => ok(dmRow(id: 'new', mine: true));
      await openPost(tester);
      await tester.tap(find.byKey(const Key('share-p1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_inbox').last.body['p_limit'], 10);
      await tester.enterText(find.byKey(const Key('share-note')), 'Look!');
      await tester.tap(find.byKey(const Key('conversation-c1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_body': 'Look!', 'p_client_key': null, 'p_ref_kind': 'post', 'p_ref_id': 'p1'});
      expect(find.text('Sent.'), findsOneWidget);
      expect(find.byKey(const Key('share-search')), findsNothing, reason: 'the sheet closes');
    });

    testWidgets('or search for a person: the conversation is found or made, then the post sent', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')]);
      site.rpcs['dm_start_direct'] = (_) => ok({'id': 'd9'});
      site.rpcs['dm_send'] = (_) => ok(dmRow(id: 'new', mine: true));
      await openPost(tester);
      await tester.tap(find.byKey(const Key('share-p1')));
      await tester.pumpAndSettle();
      await searchFor(tester, 'share-search', 'sam');
      await tester.tap(find.byKey(const Key('profile-sam')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_start_direct').single.body, {'p_actor': 'me', 'p_other': 'u-sam'});
      expect(site.forRpc('dm_send').single.body, containsPair('p_conversation', 'd9'));
      expect(site.forRpc('dm_send').single.body, containsPair('p_body', null));
      expect(find.text('Sent.'), findsOneWidget);
    });

    testWidgets('a refusal is shown in the sheet, which stays open', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'c1')]);
      site.rpcs['dm_send'] = (_) => raised('Wait for them to reply before sending more.');
      await openPost(tester);
      await tester.tap(find.byKey(const Key('share-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('conversation-c1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('share-problem')), findsOneWidget);
      expect(find.text('Wait for them to reply before sending more.'), findsOneWidget);
      expect(find.text('Sent.'), findsNothing);
    });

    testWidgets('the community rules come first, before anything is sent', (tester) async {
      var accepted = false;
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': accepted});
      site.rpcs['rules_accept'] = (_) {
        accepted = true;
        return ok({'version': 1, 'accepted': true});
      };
      site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'c1')]);
      site.rpcs['dm_send'] = (_) => ok(dmRow(id: 'new', mine: true));
      await openPost(tester);
      await tester.tap(find.byKey(const Key('share-p1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('conversation-c1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(site.forRpc('dm_send'), isEmpty);
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send'), hasLength(1));
    });

    testWidgets('with no conversations yet it suggests searching', (tester) async {
      await openPost(tester);
      await tester.tap(find.byKey(const Key('share-p1')));
      await tester.pumpAndSettle();
      expect(find.text('Search for someone to send it to.'), findsOneWidget);
    });
  });

  group('the Message button on a profile', () {
    setUp(() => site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')));

    testWidgets('starts a conversation and opens it', (tester) async {
      site.rpcs['dm_start_direct'] = (_) => ok({'id': 'd1'});
      final router = await openSocial(tester, site, '/u/sam', features: on);
      await tester.tap(find.byKey(const Key('message-button')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_start_direct').single.body, {'p_actor': 'me', 'p_other': 'u-sam'});
      expect(path(router), '/inbox/d1');
    });

    testWidgets('a refusal is shown on the profile', (tester) async {
      site.rpcs['dm_start_direct'] = (_) => raised('You can\'t message this person.');
      final router = await openSocial(tester, site, '/u/sam', features: on);
      await tester.tap(find.byKey(const Key('message-button')));
      await tester.pumpAndSettle();
      expect(find.text('You can\'t message this person.'), findsOneWidget);
      expect(path(router), '/u/sam');
    });

    testWidgets('is not there while messages are off', (tester) async {
      await openSocial(tester, site, '/u/sam', features: const {'social': true});
      expect(find.byKey(const Key('message-button')), findsNothing);
      expect(find.byKey(const Key('follow-button')), findsOneWidget);
    });

    testWidgets('own profile has no Message button', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'me', handle: 'dana', name: 'Dana Lee', mine: true));
      await openSocial(tester, site, '/u/dana', features: on);
      expect(find.byKey(const Key('message-button')), findsNothing);
    });
  });

  group('the Messages button on the profile tab', () {
    testWidgets('opens the inbox and counts what is waiting', (tester) async {
      site.rpcs['dm_unread'] = (_) => ok({'conversations': 2, 'requests': 1});
      final router = await openSocial(tester, site, '/', features: on, home: const SocialEntryCard());
      expect(find.descendant(of: find.byKey(const Key('open-inbox')), matching: find.text('3')), findsOneWidget);
      await tester.tap(find.byKey(const Key('open-inbox')));
      await tester.pumpAndSettle();
      expect(path(router), '/inbox');
    });

    testWidgets('no count when nothing waits; no button while messages are off', (tester) async {
      await openSocial(tester, site, '/', features: on, home: const SocialEntryCard());
      expect(find.byKey(const Key('open-inbox')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('open-inbox')), matching: find.byType(Badge)), findsOneWidget);
      expect(tester.widget<Badge>(find.descendant(of: find.byKey(const Key('open-inbox')), matching: find.byType(Badge))).isLabelVisible, isFalse);
    });

    testWidgets('hidden while messages are off', (tester) async {
      await openSocial(tester, site, '/', features: const {'social': true}, home: const SocialEntryCard());
      expect(find.byKey(const Key('open-inbox')), findsNothing);
      expect(find.byKey(const Key('open-feed')), findsOneWidget);
    });
  });

  group('Message the venue on a booking', () {
    testWidgets('opens the conversation about the booking', (tester) async {
      site.rpcs['dm_start_booking'] = (_) => ok({'id': 'b1'});
      site.rpcs['dm_conversation'] = (_) => ok(convRow(id: 'b1', kind: 'booking', title: 'Club A'));
      final router = await openSocial(tester, site, '/', features: on, home: const MessageVenueButton(bookingId: 'bk1'));
      await tester.tap(find.byKey(const Key('message-venue')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_start_booking').single.body, {'p_actor': 'me', 'p_booking': 'bk1'});
      expect(path(router), '/inbox/b1');
    });

    testWidgets('a refusal is shown', (tester) async {
      site.rpcs['dm_start_booking'] = (_) => raised('This venue is not taking messages yet.');
      final router = await openSocial(tester, site, '/', features: on, home: const MessageVenueButton(bookingId: 'bk1'));
      await tester.tap(find.byKey(const Key('message-venue')));
      await tester.pumpAndSettle();
      expect(find.text('This venue is not taking messages yet.'), findsOneWidget);
      expect(path(router), '/__home');
    });

    testWidgets('nothing shows while messages are off', (tester) async {
      await openSocial(tester, site, '/', features: const {'social': true}, home: const MessageVenueButton(bookingId: 'bk1'));
      expect(find.byKey(const Key('message-venue')), findsNothing);
    });

    testWidgets('a business profile does not message venues about a booking', (tester) async {
      await openSocial(tester, site, '/', features: on, mine: [myPersonal(), myBusiness()], overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')], home: const MessageVenueButton(bookingId: 'bk1'));
      expect(find.byKey(const Key('message-venue')), findsNothing);
    });

    group('on the booking page', () {
      setUp(() {
        site.tables['site_table_booking_bottles'] = [];
        site.tables['site_table_booking_club_payments'] = [];
        site.tables['site_table_booking_refunds'] = [];
        site.tables['site_table_booking_bottle_substitutions'] = [];
        site.functions['manage-guest-tickets'] = (b) => (status: 200, body: rosterAnswer());
        site.rpcs['public_venue_refund_policy'] = (b) => (status: 200, body: <Object>[]);
      });

      Future<void> openBooking(WidgetTester tester, {required Map<String, bool> features, String status = 'paid', List<Map<String, dynamic>>? mine, List<Override> overrides = const []}) async {
        site.tables['site_table_bookings'] = [bookingRow(status: status)];
        site.rpcs['site_features'] = (_) => ok(features);
        site.rpcs['profile_my_profiles'] = (_) => ok(mine ?? [myPersonal()]);
        await pumpSite(tester, TableBookingDetailScreen(bookingId: 'bk1', now: DateTime(2099, 11, 1)), site: site, settle: false, overrides: overrides);
        for (var i = 0; i < 3; i++) {
          await settleCalls(tester);
        }
      }

      testWidgets('a paid booking offers it when messages are on and there is a profile', (tester) async {
        await openBooking(tester, features: on);
        expect(find.byKey(const Key('section-messages')), findsOneWidget);
        expect(find.byKey(const Key('message-venue')), findsOneWidget);
      });

      testWidgets('not while messages are off', (tester) async {
        await openBooking(tester, features: const {'social': true});
        expect(find.byKey(const Key('section-messages')), findsNothing);
      });

      testWidgets('not without a profile', (tester) async {
        await openBooking(tester, features: on, mine: const []);
        expect(find.byKey(const Key('section-messages')), findsNothing);
      });

      testWidgets('not while acting as a business profile', (tester) async {
        await openBooking(tester, features: on, mine: [myPersonal(), myBusiness()], overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')]);
        expect(find.byKey(const Key('section-messages')), findsNothing);
      });

      testWidgets('not for a booking that was cancelled', (tester) async {
        await openBooking(tester, features: on, status: 'cancelled');
        expect(find.byKey(const Key('section-messages')), findsNothing);
      });
    });
  });
}
