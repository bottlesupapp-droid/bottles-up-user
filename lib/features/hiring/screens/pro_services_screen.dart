import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/hiring_widgets.dart';

/// A professional's side of hiring: the services they offer, and the days they are not free. Customers see the services on the profile and cannot ask for a day marked busy.
class ProServicesScreen extends ConsumerWidget {
  const ProServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = 'My services';
    if (!ref.watch(featureOnProvider(Feature.marketplace))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Hiring professionals is not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!isProfessional(actor)) {
          return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.work_outline, title: 'Switch to a professional profile', text: 'Services belong to a professional profile (a DJ, a photographer, an event group): switch to yours from the Profile tab.'));
        }
        return _ServicesBody(actor: actor.id);
      },
    );
  }
}

class _ServicesBody extends ConsumerStatefulWidget {
  const _ServicesBody({required this.actor});

  final String actor;

  @override
  ConsumerState<_ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends ConsumerState<_ServicesBody> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _guard(Future<void> Function() action, {String? done}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (done != null && mounted) _say(done);
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit([ProService? existing]) async {
    final saved = await showModalBottomSheet<_ServiceValues>(context: context, isScrollControlled: true, builder: (_) => _ServiceSheet(existing: existing));
    if (saved == null || !mounted) return;
    await _guard(() async {
      await ref.read(hiringServiceProvider).saveService(actor: widget.actor, id: existing?.id, title: saved.title, description: saved.description, fromCents: saved.fromCents, priceNote: saved.note, active: saved.active);
      ref.invalidate(proServicesProvider(widget.actor));
    }, done: existing == null ? 'Service added.' : 'Service saved.');
  }

  Future<void> _remove(ProService s) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Remove "${s.title}"?'),
        content: const Text('Requests and bookings you already have for it are not affected.'),
        actions: [
          TextButton(key: const Key('service-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('service-remove-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Remove')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _guard(() async {
      await ref.read(hiringServiceProvider).removeService(actor: widget.actor, id: s.id);
      ref.invalidate(proServicesProvider(widget.actor));
    }, done: 'Service removed.');
  }

  Future<void> _addBusy() async {
    final today = clock.now();
    final first = DateTime(today.year, today.month, today.day);
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: DateTime(first.year, first.month, first.day + 730), initial: first);
    if (picked == null || !mounted) return;
    await _guard(() async {
      await ref.read(hiringServiceProvider).setBusy(actor: widget.actor, day: picked, busy: true);
      ref.invalidate(proBusyDaysProvider(widget.actor));
    }, done: '${dayText(picked)} is marked as busy.');
  }

  Future<void> _free(DateTime day) => _guard(() async {
        await ref.read(hiringServiceProvider).setBusy(actor: widget.actor, day: day, busy: false);
        ref.invalidate(proBusyDaysProvider(widget.actor));
        final left = await ref.read(proBusyDaysProvider(widget.actor).future);
        if (!mounted) return;
        // A day with a booking stays busy whatever is marked.
        _say(left.any((d) => d.year == day.year && d.month == day.month && d.day == day.day) ? '${dayText(day)} has a booking, so it stays busy.' : '${dayText(day)} is free again.');
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final services = ref.watch(proServicesProvider(widget.actor));
    final busy = ref.watch(proBusyDaysProvider(widget.actor));
    return Scaffold(
      appBar: AppBar(title: const Text('My services')),
      floatingActionButton: services.hasValue && services.requireValue.length < maxServices ? FloatingActionButton.extended(key: const Key('service-add'), onPressed: _busy ? null : () => _edit(), icon: const Icon(Icons.add), label: const Text('Add a service')) : null,
      body: services.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your services'), onRetry: () => ref.invalidate(proServicesProvider(widget.actor))),
        data: (list) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(proServicesProvider(widget.actor));
            ref.invalidate(proBusyDaysProvider(widget.actor));
          },
          child: ListView(key: const Key('services-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(0, 8, 0, 96), children: [
            if (list.isEmpty) const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('Add what you offer, with a price to start from. Customers see it on your profile and ask you for a quote.', key: Key('services-empty'))),
            for (final s in list)
              ListTile(
                key: Key('service-${s.id}'),
                title: Text(s.title),
                subtitle: Text([if (s.fromCents != null) 'From ${cents(s.fromCents!)}${s.priceNote == null ? '' : ' ${s.priceNote}'}', if (!s.active) 'Hidden from your profile'].join(' · ')),
                onTap: _busy ? null : () => _edit(s),
                trailing: IconButton(key: Key('service-remove-${s.id}'), tooltip: 'Remove', icon: const Icon(Icons.delete_outline), onPressed: _busy ? null : () => _remove(s)),
              ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(child: Text('Days you are busy', style: theme.textTheme.titleMedium)),
                TextButton.icon(key: const Key('busy-add'), onPressed: _busy ? null : _addBusy, icon: const Icon(Icons.event_busy_outlined), label: const Text('Add a day')),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: busy.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(e is SiteException ? e.message : loadFailedMessage('the days'), key: const Key('busy-error')),
                data: (days) => days.isEmpty
                    ? const Text('No busy days. Customers can ask you for any day. A day you have a booking is busy by itself.', key: Key('busy-empty'))
                    : Wrap(spacing: 8, runSpacing: 4, children: [for (final d in days) InputChip(key: Key('busy-${d.year}-${d.month}-${d.day}'), label: Text(dayText(d)), onDeleted: _busy ? null : () => _free(d))]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

typedef _ServiceValues = ({String title, String description, int? fromCents, String note, bool active});

/// The form for one service. It owns its boxes, so they outlive the sheet's closing animation.
class _ServiceSheet extends StatefulWidget {
  const _ServiceSheet({this.existing});

  final ProService? existing;

  @override
  State<_ServiceSheet> createState() => _ServiceSheetState();
}

class _ServiceSheetState extends State<_ServiceSheet> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _description = TextEditingController(text: widget.existing?.description ?? '');
  late final _price = TextEditingController(text: widget.existing?.fromCents == null ? '' : (widget.existing!.fromCents! / 100).toStringAsFixed(2));
  late final _note = TextEditingController(text: widget.existing?.priceNote ?? '');
  late bool _active = widget.existing?.active ?? true;
  String? _wrong;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    final cents = _price.text.trim().isEmpty ? null : parseAmountCents(_price.text);
    if (_price.text.trim().isNotEmpty && cents == null) return setState(() => _wrong = 'Type the price as a number, for example 150 or 150.50.');
    final wrong = checkService(title: _title.text, description: _description.text, fromCents: cents, priceNote: _note.text);
    if (wrong != null) return setState(() => _wrong = wrong);
    Navigator.pop<_ServiceValues>(context, (title: _title.text, description: _description.text, fromCents: cents, note: _note.text, active: _active));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        key: const Key('service-sheet'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.existing == null ? 'Add a service' : 'Change this service', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(key: const Key('service-title'), controller: _title, maxLength: maxTitleLength, decoration: const InputDecoration(labelText: 'Name (for example, Wedding DJ set)')),
          TextField(key: const Key('service-description'), controller: _description, minLines: 2, maxLines: 6, maxLength: maxDescriptionLength, decoration: const InputDecoration(labelText: 'What it includes (optional)', alignLabelWithHint: true)),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: TextField(key: const Key('service-price'), controller: _price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Price from (optional)', prefixText: '\$ '))),
            const SizedBox(width: 12),
            Expanded(child: TextField(key: const Key('service-note'), controller: _note, maxLength: maxPriceNoteLength, decoration: const InputDecoration(labelText: 'Price note (optional)', hintText: 'per hour'))),
          ]),
          SwitchListTile(key: const Key('service-active'), contentPadding: EdgeInsets.zero, title: const Text('Show it on my profile'), value: _active, onChanged: (v) => setState(() => _active = v)),
          if (_wrong != null) Text(_wrong!, key: const Key('service-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          FilledButton(key: const Key('service-save'), onPressed: _save, child: const Text('Save')),
        ]),
      ),
    );
  }
}
