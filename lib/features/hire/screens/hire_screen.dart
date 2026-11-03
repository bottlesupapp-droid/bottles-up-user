import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/hire.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hire_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../hiring/widgets/hiring_dialogs.dart';
import '../../hiring/widgets/hiring_widgets.dart';
import '../widgets/hire_widgets.dart';
import '../widgets/item_dialog.dart';
import '../widgets/offer_sheet.dart';

/// One venue hire from either side: what was asked, the venue's offer, the steps that are open, and (once it is agreed) the private workspace: the schedule and tasks, the lineup, the
/// public event and what is still pending. A request, an offer and an agreement are never called a booking: only the venue's confirmation is.
/// [actorId] is the profile this is opened as (the group's or the venue's): the lists pass it so a person with several profiles does not have to switch first.
class HireScreen extends ConsumerStatefulWidget {
  const HireScreen({super.key, required this.hireId, this.actorId});

  final String hireId;
  final String? actorId;

  @override
  ConsumerState<HireScreen> createState() => _HireScreenState();
}

class _HireScreenState extends ConsumerState<HireScreen> {
  bool _busy = false;

  String? get _actor => widget.actorId ?? ref.read(actorProfileProvider)?.id;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  void _refresh() {
    final actor = _actor;
    if (actor == null) return;
    ref.invalidate(hireWorkspaceProvider((actor: actor, hire: widget.hireId)));
    ref.invalidate(hiresMineProvider(actor));
    ref.invalidate(hiresForProvider(actor));
  }

  Future<void> _act(Future<Object?> Function(String actor) action, {String? done}) async {
    final actor = _actor;
    if (_busy || actor == null) return;
    setState(() => _busy = true);
    try {
      await action(actor);
      if (done != null && mounted) _say(done);
      _refresh();
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
      _refresh();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _ask(String title, String text, {String yes = 'Yes', String no = 'Not yet'}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(key: const Key('ask-no'), onPressed: () => Navigator.pop(c, false), child: Text(no)),
          FilledButton(key: const Key('ask-yes'), onPressed: () => Navigator.pop(c, true), child: Text(yes)),
        ],
      ),
    );
    return result == true && mounted;
  }

  Future<void> _agree(Hire h) async {
    final o = h.offer!;
    final ok = await _ask(
      'Agree to this offer?',
      'You agree to the terms as they stand: rental ${cents(o.rentalCents)}, deposit ${cents(o.depositCents)}, minimum sales ${cents(o.minSalesCents)} and a bar share of ${o.barShareText}. '
      'The venue still has to confirm the date, and the money is settled with the venue: BottlesUp does not take it.',
      yes: 'Agree',
    );
    if (ok) await _act((a) => ref.read(hireServiceProvider).agree(actor: a, hire: h.id));
  }

  Future<void> _decline(Hire h) async {
    final note = await showTextDialog(
      context,
      title: 'Decline this request?',
      label: 'A note for the group (optional)',
      confirmText: 'Decline',
      keepText: 'Keep it',
      fieldKey: const Key('decline-note'),
      confirmKey: const Key('decline-confirm'),
      keepKey: const Key('decline-keep'),
    );
    if (note == null || !mounted) return;
    await _act((a) => ref.read(hireServiceProvider).decline(actor: a, hire: h.id, note: note), done: 'The request is declined.');
  }

  Future<void> _cancel(Hire h) async {
    final reason = await showTextDialog(
      context,
      title: 'Cancel this hire?',
      intro: 'The other side is told. Nothing was paid through BottlesUp, so there is nothing to pay back here; settle anything you paid between yourselves.',
      introKey: const Key('cancel-intro'),
      label: 'Why? (optional)',
      confirmText: 'Cancel the hire',
      keepText: 'Keep it',
      fieldKey: const Key('cancel-reason'),
      confirmKey: const Key('cancel-confirm'),
      keepKey: const Key('cancel-keep'),
    );
    if (reason == null || !mounted) return;
    await _act((a) => ref.read(hireServiceProvider).cancel(actor: a, hire: h.id, side: h.side, reason: reason), done: 'The hire is cancelled.');
  }

  Future<void> _offer(Hire h) async {
    final actor = _actor;
    if (actor == null) return;
    final sent = await showOfferSheet(context, hire: h, actor: actor);
    if (sent == null || !mounted) return;
    _refresh();
    _say('Your offer was sent.');
  }

  Future<void> _addItem(bool schedule) async {
    final item = await showItemDialog(context, schedule: schedule);
    if (item == null || !mounted) return;
    await _act((a) => ref.read(hireServiceProvider).addItem(actor: a, hire: widget.hireId, schedule: item.schedule, title: item.title, atTime: item.atTime, dueOn: item.dueOn));
  }

  Future<void> _attach(Workspace w) async {
    List<ProRequest> mine;
    try {
      // The list is empty until the website's switches are known, so wait for them.
      await ref.read(featuresProvider.future);
      mine = await ref.read(myProRequestsProvider.future);
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
      return;
    }
    if (!mounted) return;
    final taken = {for (final l in w.lineup) l.bookingId};
    final options = [
      for (final r in mine)
        if (r.booking != null && !r.booking!.state.isClosed && _sameDay(r.booking!.eventDate, w.hire.eventDate) && !taken.contains(r.booking!.id)) r.booking!,
    ];
    if (options.isEmpty) {
      _say('You have no booking with a professional for ${dayText(w.hire.eventDate)} to attach. Hire a professional first.');
      return;
    }
    final pick = await showModalBottomSheet<ProBooking>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(key: const Key('attach-sheet'), mainAxisSize: MainAxisSize.min, children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('Attach a professional')),
          for (final b in options) ListTile(key: Key('attach-${b.id}'), title: Text(b.provider?.displayName ?? 'A professional'), subtitle: Text(b.title), onTap: () => Navigator.pop(c, b)),
        ]),
      ),
    );
    if (pick == null || !mounted) return;
    await _act((a) => ref.read(hireServiceProvider).attachBooking(actor: a, hire: widget.hireId, booking: pick.id), done: 'Added to the lineup.');
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _linkEvent() async {
    final actor = _actor;
    if (actor == null) return;
    try {
      final events = await ref.read(hireServiceProvider).linkableEvents(actor: actor, hire: widget.hireId);
      if (!mounted) return;
      if (events.isEmpty) {
        _say('You have no published event near this day to link. Create it in BottlesUp Business first.');
        return;
      }
      final pick = await showModalBottomSheet<LinkableEvent>(
        context: context,
        builder: (c) => SafeArea(
          child: Column(key: const Key('link-sheet'), mainAxisSize: MainAxisSize.min, children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('Link your public event')),
            for (final e in events) ListTile(key: Key('link-${e.id}'), title: Text(e.title), subtitle: e.startDate == null ? null : Text(formatWhen(e.startDate!)), onTap: () => Navigator.pop(c, e)),
          ]),
        ),
      );
      if (pick == null || !mounted) return;
      await _act((a) => ref.read(hireServiceProvider).linkEvent(actor: a, hire: widget.hireId, event: pick.id), done: 'The event is linked.');
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    }
  }

  void _openChat(String? conversation) {
    final actor = _actor;
    if (conversation == null || actor == null) return;
    // A conversation is read by the profile that is in it: switch to that one.
    ref.read(selectedProfileIdProvider.notifier).state = actor;
    context.push('/inbox/$conversation');
  }

  @override
  Widget build(BuildContext context) {
    final actor = _actor;
    if (actor == null) return Scaffold(appBar: AppBar(title: const Text('Hire')), body: const EmptyState(icon: Icons.person_outline, title: 'Choose a profile', text: 'Open this as the group or the venue it is for.'));
    final ws = ref.watch(hireWorkspaceProvider((actor: actor, hire: widget.hireId)));
    return Scaffold(
      appBar: AppBar(title: const Text('Hire')),
      body: ws.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this hire'), onRetry: () => ref.invalidate(hireWorkspaceProvider((actor: actor, hire: widget.hireId)))),
        data: _body,
      ),
    );
  }

  Widget _body(Workspace w) {
    final theme = Theme.of(context);
    final h = w.hire;
    final organizer = w.side == HireSide.organizer;
    final today = clock.now();
    final showWorkspace = h.state == HireState.agreed || h.state == HireState.confirmed || h.state == HireState.completed;
    return RefreshIndicator(
      onRefresh: () async {
        _refresh();
        await ref.read(hireWorkspaceProvider((actor: _actor!, hire: widget.hireId)).future).catchError((_) => w);
      },
      child: ListView(key: const Key('hire-detail'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
        Text(h.eventType, key: const Key('hire-title'), style: theme.textTheme.titleLarge),
        Text(organizer ? 'At ${h.venue?.displayName ?? 'a venue'}' : 'From ${h.organizer?.displayName ?? 'a group'}', key: const Key('hire-who')),
        const SizedBox(height: 8),
        HireChip(hire: h),
        const SizedBox(height: 4),
        Text(_stateLine(h), key: const Key('hire-state-line'), style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        InfoLine('Day', dayText(h.eventDate)),
        if (h.hours != null) InfoLine('Hours', h.hours!),
        if (h.attendance != null) InfoLine('Expected', '${h.attendance} people'),
        if (h.space != null) InfoLine('Space', h.space!),
        if (h.equipment != null) InfoLine('Equipment', h.equipment!),
        if (h.staffing != null) InfoLine('Staffing', h.staffing!),
        if (h.budgetCents != null) InfoLine('Budget', cents(h.budgetCents!)),
        if (!organizer && h.requestedBy != null) InfoLine('Asked by', h.requestedBy!.name),
        if (h.notes != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(h.notes!, key: const Key('hire-notes'))),
        if (h.declineNote != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Note: ${h.declineNote}', key: const Key('hire-decline-note'), style: theme.textTheme.bodySmall)),
        if (h.state == HireState.cancelled) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Cancelled by ${h.cancelledBy == (organizer ? 'organizer' : 'venue') ? 'you' : 'the other side'}${h.cancelReason == null ? '' : ': ${h.cancelReason}'}', key: const Key('hire-cancel-note'), style: theme.textTheme.bodySmall)),
        if (h.offer != null) _offerCard(h.offer!),
        const SizedBox(height: 16),
        ..._actions(h, organizer, today),
        if (showWorkspace) ..._workspace(w, organizer),
        const SizedBox(height: 8),
        if (w.hireChat != null) TextButton.icon(key: const Key('hire-open-chat'), onPressed: () => _openChat(w.hireChat), icon: const Icon(Icons.chat_bubble_outline), label: Text(organizer ? 'Message the venue' : 'Message the group')),
        if (w.eventChat != null) TextButton.icon(key: const Key('hire-open-event-chat'), onPressed: () => _openChat(w.eventChat), icon: const Icon(Icons.groups_outlined), label: const Text('Event chat')),
      ]),
    );
  }

  String _stateLine(Hire h) => switch (h.state) {
        HireState.requested => h.side == HireSide.venue ? 'This is a request. Make an offer or decline.' : 'This is only a request. The venue has not answered yet.',
        HireState.offered => h.side == HireSide.venue ? 'You made an offer. The group has not answered yet.' : 'The venue made an offer. Nothing is booked until you agree and the venue confirms.',
        HireState.offerExpired => 'The offer ran out. The venue can make a new one.',
        HireState.agreed => 'Agreed, but the date is NOT booked until the venue confirms it.',
        HireState.confirmed => 'The venue has confirmed the date.',
        HireState.declined => 'The venue declined.',
        HireState.withdrawn => 'The request was withdrawn.',
        HireState.cancelled => 'This hire was cancelled.',
        HireState.lapsed => 'The day came before it was agreed.',
        HireState.completed => 'The night has passed.',
      };

  Widget _offerCard(HireOffer o) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('hire-offer'),
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(o.isAccepted ? 'The agreed terms' : 'The venue\'s offer', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          InfoLine('Rental', cents(o.rentalCents), bold: true),
          InfoLine('Deposit', cents(o.depositCents)),
          InfoLine('Minimum sales', cents(o.minSalesCents)),
          InfoLine('Bar share', o.barShareText),
          InfoLine('Tickets and tables', o.control.label),
          if (o.staffing != null) InfoLine('Staffing', o.staffing!),
          if (o.equipment != null) InfoLine('Equipment', o.equipment!),
          if (o.cancellation != null) InfoLine('Cancelling', o.cancellation!),
          if (o.notes != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(o.notes!)),
          const SizedBox(height: 4),
          Text(o.status == 'sent' ? 'Open until ${formatWhen(o.validUntil)}.' : (o.status == 'expired' ? 'This offer has run out.' : ''), key: const Key('offer-validity'), style: theme.textTheme.bodySmall),
          Text('The money is settled between the group and the venue. BottlesUp does not take it.', style: theme.textTheme.bodySmall),
        ]),
      ),
    );
  }

  List<Widget> _actions(Hire h, bool organizer, DateTime today) {
    final busy = _busy;
    return [
      if (organizer && h.hasLiveOffer) ...[
        FilledButton(key: const Key('hire-agree'), onPressed: busy ? null : () => _agree(h), child: const Text('Agree to this offer')),
        TextButton(key: const Key('hire-turn-down'), onPressed: busy ? null : () => _act((a) => ref.read(hireServiceProvider).declineOffer(actor: a, hire: h.id), done: 'You turned the offer down.'), child: const Text('Turn it down')),
      ],
      if (organizer && isHireOpen(h)) TextButton(key: const Key('hire-withdraw'), onPressed: busy ? null : () => _act((a) => ref.read(hireServiceProvider).withdraw(actor: a, hire: h.id), done: 'Your request was withdrawn.'), child: const Text('Withdraw my request')),
      if (!organizer && (h.state == HireState.requested || h.state == HireState.offerExpired || h.state == HireState.offered))
        FilledButton(key: const Key('hire-offer-button'), onPressed: busy ? null : () => _offer(h), child: Text(h.offer == null ? 'Make an offer' : 'Change the offer')),
      if (!organizer && h.state == HireState.offered)
        TextButton(key: const Key('hire-take-back'), onPressed: busy ? null : () => _act((a) => ref.read(hireServiceProvider).withdrawOffer(actor: a, hire: h.id), done: 'The offer was taken back.'), child: const Text('Take the offer back')),
      if (!organizer && isHireOpen(h)) TextButton(key: const Key('hire-decline'), onPressed: busy ? null : () => _decline(h), child: const Text('Decline')),
      if (!organizer && h.state == HireState.agreed)
        FilledButton(
          key: const Key('hire-confirm'),
          onPressed: busy
              ? null
              : () async {
                  final ok = await _ask('Confirm the date?', 'This books ${dayText(h.eventDate)} for ${h.organizer?.displayName ?? 'the group'}. Only now is it a booked hire.', yes: 'Confirm');
                  if (ok) await _act((a) => ref.read(hireServiceProvider).confirm(actor: a, hire: h.id), done: 'The date is confirmed.');
                },
          child: const Text('Confirm the date'),
        ),
      if (canCancelHire(h, today)) TextButton(key: const Key('hire-cancel'), onPressed: busy ? null : () => _cancel(h), child: const Text('Cancel the hire')),
    ];
  }

  List<Widget> _workspace(Workspace w, bool organizer) {
    final theme = Theme.of(context);
    final h = w.hire;
    final schedule = [for (final i in w.items) if (i.isSchedule) i];
    final tasks = [for (final i in w.items) if (!i.isSchedule) i];
    return [
      const Divider(height: 32),
      Text('Workspace', style: theme.textTheme.titleMedium),
      const SizedBox(height: 4),
      if (w.pending.isEmpty) const Text('Nothing is pending.', key: Key('pending-none')) else ...[
        Text('Still pending', style: theme.textTheme.titleSmall),
        for (final p in w.pending) Padding(key: Key('pending-$p'), padding: const EdgeInsets.symmetric(vertical: 2), child: Text('• $p')),
      ],
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Text('Schedule', style: theme.textTheme.titleSmall)),
        if (w.open) TextButton.icon(key: const Key('add-schedule'), onPressed: _busy ? null : () => _addItem(true), icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (schedule.isEmpty) const Text('Nothing scheduled yet.', key: Key('schedule-none')),
      for (final i in schedule) _item(i, w.open),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Text('Tasks', style: theme.textTheme.titleSmall)),
        if (w.open) TextButton.icon(key: const Key('add-task'), onPressed: _busy ? null : () => _addItem(false), icon: const Icon(Icons.add), label: const Text('Add')),
      ]),
      if (tasks.isEmpty) const Text('No tasks yet.', key: Key('tasks-none')),
      for (final i in tasks) _item(i, w.open),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Text('Lineup', style: theme.textTheme.titleSmall)),
        if (organizer && h.state == HireState.confirmed && w.open) TextButton.icon(key: const Key('attach-booking'), onPressed: _busy ? null : () => _attach(w), icon: const Icon(Icons.add), label: const Text('Attach')),
      ]),
      if (w.lineup.isEmpty) const Text('No professionals attached.', key: Key('lineup-none')),
      for (final l in w.lineup)
        ListTile(
          key: Key('lineup-${l.bookingId}'),
          contentPadding: EdgeInsets.zero,
          title: Text(l.provider?.displayName ?? 'A professional'),
          subtitle: Text(l.confirmed ? 'Confirmed: their deposit is in' : 'Not confirmed yet'),
          trailing: organizer ? IconButton(key: Key('detach-${l.bookingId}'), tooltip: 'Take off', icon: const Icon(Icons.close), onPressed: _busy ? null : () => _act((a) => ref.read(hireServiceProvider).detachBooking(actor: a, hire: h.id, booking: l.bookingId))) : null,
        ),
      const SizedBox(height: 12),
      Text('Public event', style: theme.textTheme.titleSmall),
      if (w.event == null) const Text('No public event is linked.', key: Key('event-none')) else ...[
        ListTile(key: const Key('linked-event'), contentPadding: EdgeInsets.zero, title: Text(w.event!.title), subtitle: Text('${w.event!.ticketsSold} of ${w.event!.ticketsCapacity} tickets sold')),
        if (organizer) TextButton(key: const Key('unlink-event'), onPressed: _busy ? null : () => _act((a) => ref.read(hireServiceProvider).unlinkEvent(actor: a, hire: h.id), done: 'The event is unlinked.'), child: const Text('Unlink the event')),
      ],
      if (organizer && h.state == HireState.confirmed && w.event == null) OutlinedButton(key: const Key('link-event'), onPressed: _busy ? null : _linkEvent, child: const Text('Link your public event')),
    ];
  }

  Widget _item(HireItem i, bool open) {
    return ListTile(
      key: Key('item-${i.id}'),
      contentPadding: EdgeInsets.zero,
      leading: i.isSchedule
          ? const Icon(Icons.schedule)
          : Checkbox(key: Key('tick-${i.id}'), value: i.done, onChanged: !open || _busy ? null : (v) => _act((a) => ref.read(hireServiceProvider).setItem(actor: a, item: i.id, done: v ?? false))),
      title: Text(i.isSchedule ? '${scheduleTime(i.atTime)}  ${i.title}' : i.title, style: i.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null),
      subtitle: Text('${i.side == HireSide.organizer ? 'The group' : 'The venue'}${i.dueOn == null ? '' : ' · due ${dayText(i.dueOn!)}'}'),
      trailing: open ? IconButton(key: Key('remove-${i.id}'), tooltip: 'Remove', icon: const Icon(Icons.delete_outline), onPressed: _busy ? null : () => _act((a) => ref.read(hireServiceProvider).removeItem(actor: a, item: i.id))) : null,
    );
  }
}
