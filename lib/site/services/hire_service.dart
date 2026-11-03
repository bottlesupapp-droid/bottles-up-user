import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/hire.dart';
import '../site_error.dart';

String _day(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// Venue hire, the event workspace and teams, through the website's functions. The website decides who may do what; this service carries the asks and the answers and turns a
/// refusal into the sentence it came with.
class HireService {
  HireService(this._db);

  final SupabaseClient _db;

  Future<T> _rpc<T>(String name, Map<String, dynamic> params, T Function(Object? answer) read, String generic) async {
    final Object? answer;
    try {
      answer = await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
    return read(answer);
  }

  Hire _hire(Object? a, HireSide side) => parseHire(a, side) ?? (throw const SiteException('We could not read the answer. Look at your hires before trying again.'));

  // ---- teams
  Future<TeamInfo> team(String actor) => _rpc('team_list', {'p_actor': actor}, (a) => parseTeamInfo(a) ?? (throw const SiteException('We could not read the team.')), loadFailedMessage('the team'));

  Future<TeamMember> invite({required String actor, required String handle, required TeamRole role, Set<String>? permissions}) => _rpc(
        'team_invite',
        {'p_actor': actor, 'p_handle': handle.trim().toLowerCase().replaceFirst('@', ''), 'p_role': role.wire, 'p_permissions': role == TeamRole.custom ? (permissions ?? <String>{}).toList() : null},
        (a) => parseTeamMember(a) ?? (throw const SiteException('We could not read the answer. Look at the team before trying again.')),
        'The invitation was not sent. Check your connection and try again.',
      );

  Future<TeamMember> answerInvitation({required String team, required bool accept}) => _rpc(
        'team_answer',
        {'p_team': team, 'p_accept': accept},
        (a) => parseTeamMember(a) ?? (throw const SiteException('We could not read the answer. Look at your invitations before trying again.')),
        actionFailedMessage,
      );

  Future<void> revoke({required String actor, required String team}) => _rpc('team_revoke', {'p_actor': actor, 'p_team': team}, (_) {}, actionFailedMessage);

  Future<void> leave(String team) => _rpc('team_leave', {'p_team': team}, (_) {}, actionFailedMessage);

  Future<TeamMember> setRole({required String actor, required String team, required TeamRole role, Set<String>? permissions}) => _rpc(
        'team_set_role',
        {'p_actor': actor, 'p_team': team, 'p_role': role.wire, 'p_permissions': role == TeamRole.custom ? (permissions ?? <String>{}).toList() : null},
        (a) => parseTeamMember(a) ?? (throw const SiteException('We could not read the answer. Look at the team before trying again.')),
        actionFailedMessage,
      );

  Future<List<TeamInvitation>> invitations() => _rpc('team_invitations_mine', const {}, parseTeamInvitations, loadFailedMessage('your invitations'));

  Future<ProfileAccess> access(String profile) => _rpc('team_my_access', {'p_profile': profile}, (a) => parseProfileAccess(a) ?? const ProfileAccess(owner: false, permissions: {}), loadFailedMessage('your role'));

  // ---- hires
  Future<Hire> request({
    required String actor,
    required String venue,
    required DateTime date,
    required String eventType,
    String? hours,
    int? attendance,
    String? space,
    String? equipment,
    String? staffing,
    int? budgetCents,
    String? notes,
  }) =>
      _rpc(
        'hire_request',
        {
          'p_actor': actor,
          'p_venue': venue,
          'p_date': _day(date),
          'p_hours': _blank(hours),
          'p_type': eventType.trim(),
          'p_attendance': attendance,
          'p_space': _blank(space),
          'p_equipment': _blank(equipment),
          'p_staffing': _blank(staffing),
          'p_budget_cents': budgetCents,
          'p_notes': _blank(notes),
        },
        (a) => _hire(a, HireSide.organizer),
        'Your request was not sent. Check your connection and try again.',
      );

  Future<List<Hire>> hiresMine(String actor) => _rpc('hires_mine', {'p_actor': actor}, (a) => parseHires(a, HireSide.organizer), loadFailedMessage('your hires'));

  Future<List<Hire>> hiresFor(String actor) => _rpc('hires_for', {'p_actor': actor}, (a) => parseHires(a, HireSide.venue), loadFailedMessage('the requests'));

  Future<Hire> hire({required String actor, required String hire, required HireSide side}) => _rpc('hire_get', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, side), loadFailedMessage('this hire'));

  Future<Hire> sendOffer({
    required String actor,
    required String hire,
    required int rentalCents,
    required int depositCents,
    required int minSalesCents,
    required int barShareBps,
    required HireControl control,
    String? staffing,
    String? equipment,
    String? cancellation,
    String? notes,
    required int validDays,
  }) =>
      _rpc(
        'hire_offer_send',
        {
          'p_actor': actor,
          'p_hire': hire,
          'p_rental_cents': rentalCents,
          'p_deposit_cents': depositCents,
          'p_min_sales_cents': minSalesCents,
          'p_bar_share_bps': barShareBps,
          'p_control': control.wire,
          'p_staffing': _blank(staffing),
          'p_equipment': _blank(equipment),
          'p_cancellation': _blank(cancellation),
          'p_notes': _blank(notes),
          'p_valid_days': validDays,
        },
        (a) => _hire(a, HireSide.venue),
        'The offer was not sent. Check your connection and try again.',
      );

  Future<Hire> withdrawOffer({required String actor, required String hire}) => _rpc('hire_offer_withdraw', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.venue), actionFailedMessage);

  Future<Hire> declineOffer({required String actor, required String hire}) => _rpc('hire_offer_decline', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.organizer), actionFailedMessage);

  Future<Hire> decline({required String actor, required String hire, String? note}) => _rpc('hire_decline', {'p_actor': actor, 'p_hire': hire, 'p_note': _blank(note)}, (a) => _hire(a, HireSide.venue), actionFailedMessage);

  Future<Hire> withdraw({required String actor, required String hire}) => _rpc('hire_withdraw', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.organizer), actionFailedMessage);

  Future<Hire> agree({required String actor, required String hire}) => _rpc('hire_agree', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.organizer), 'The offer was not agreed. Check your connection and try again.');

  Future<Hire> confirm({required String actor, required String hire}) => _rpc('hire_confirm', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.venue), 'The date was not confirmed. Check your connection and try again.');

  Future<Hire> cancel({required String actor, required String hire, required HireSide side, String? reason}) =>
      _rpc('hire_cancel', {'p_actor': actor, 'p_hire': hire, 'p_reason': _blank(reason)}, (a) => _hire(a, side), 'The hire was not cancelled. Check your connection and try again.');

  // ---- the workspace
  Future<Workspace> workspace({required String actor, required String hire}) =>
      _rpc('hire_workspace', {'p_actor': actor, 'p_hire': hire}, (a) => parseWorkspace(a) ?? (throw const SiteException('We could not read the workspace.')), loadFailedMessage('the workspace'));

  Future<HireItem> addItem({required String actor, required String hire, required bool schedule, required String title, String? atTime, DateTime? dueOn}) => _rpc(
        'hire_item_add',
        {'p_actor': actor, 'p_hire': hire, 'p_kind': schedule ? 'schedule' : 'task', 'p_title': title.trim(), 'p_at': schedule ? atTime : null, 'p_due': !schedule && dueOn != null ? _day(dueOn) : null},
        (a) => parseHireItem(a) ?? (throw const SiteException('We could not read the answer. Look at the workspace before trying again.')),
        'That was not added. Check your connection and try again.',
      );

  Future<HireItem> setItem({required String actor, required String item, String? title, bool? done}) => _rpc(
        'hire_item_set',
        {'p_actor': actor, 'p_item': item, 'p_title': title?.trim(), 'p_done': done},
        (a) => parseHireItem(a) ?? (throw const SiteException('We could not read the answer. Look at the workspace before trying again.')),
        actionFailedMessage,
      );

  Future<void> removeItem({required String actor, required String item}) => _rpc('hire_item_remove', {'p_actor': actor, 'p_item': item}, (_) {}, actionFailedMessage);

  Future<void> attachBooking({required String actor, required String hire, required String booking}) => _rpc('hire_attach_booking', {'p_actor': actor, 'p_hire': hire, 'p_booking': booking}, (_) {}, actionFailedMessage);

  Future<void> detachBooking({required String actor, required String hire, required String booking}) => _rpc('hire_detach_booking', {'p_actor': actor, 'p_hire': hire, 'p_booking': booking}, (_) {}, actionFailedMessage);

  Future<List<LinkableEvent>> linkableEvents({required String actor, required String hire}) =>
      _rpc('hire_events_linkable', {'p_actor': actor, 'p_hire': hire}, parseLinkableEvents, loadFailedMessage('your events'));

  Future<Hire> linkEvent({required String actor, required String hire, required String event}) => _rpc('hire_link_event', {'p_actor': actor, 'p_hire': hire, 'p_event': event}, (a) => _hire(a, HireSide.organizer), actionFailedMessage);

  Future<Hire> unlinkEvent({required String actor, required String hire}) => _rpc('hire_unlink_event', {'p_actor': actor, 'p_hire': hire}, (a) => _hire(a, HireSide.organizer), actionFailedMessage);
}
