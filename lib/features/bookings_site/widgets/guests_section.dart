import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/my_night.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

final RegExp _emailShape = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Who is coming with you: the guests on the booking, each with their own ticket sent to their own e-mail, up to what the table seats. The host is one of the table's guests, so a table
/// for six has five places to give out. A guest can be sent their ticket again until they have checked in.
class GuestsSection extends ConsumerStatefulWidget {
  const GuestsSection({super.key, required this.code});

  /// The booking's confirmation code, which is what the website acts on.
  final String code;

  @override
  ConsumerState<GuestsSection> createState() => _GuestsSectionState();
}

class _GuestsSectionState extends ConsumerState<GuestsSection> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _add(GuestRoster roster) async {
    if (_busy) return;
    final picked = await showModalBottomSheet<List<({String name, String email})>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddGuestsSheet(places: roster.remainingCapacity),
    );
    if (picked == null || picked.isEmpty || !mounted) return;
    setState(() => _busy = true);
    try {
      final results = await ref.read(guestPassesServiceProvider).add(widget.code, picked);
      if (!mounted) return;
      final unsent = [for (final r in results) if (!r.sent) r.name];
      _say(unsent.isEmpty
          ? (results.length == 1 ? '${results.first.name} will get their ticket by e-mail.' : '${results.length} guests will get their tickets by e-mail.')
          : 'Added, but the ticket for ${unsent.join(', ')} could not be e-mailed. Use Send again.');
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
      ref.invalidate(guestRosterProvider(widget.code));
    }
  }

  Future<void> _resend(GuestPass g) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(guestPassesServiceProvider).resend(widget.code, g.id);
      if (mounted) _say('Ticket sent again to ${g.name}.');
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
      ref.invalidate(guestRosterProvider(widget.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final roster = ref.watch(guestRosterProvider(widget.code));
    final theme = Theme.of(context);
    return roster.when(
      skipLoadingOnRefresh: true,
      loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
      error: (error, _) => Row(
        children: [
          Expanded(child: Text(error is SiteException ? error.message : loadFailedMessage('the guest list'), key: const Key('guests-failed'), style: TextStyle(color: theme.colorScheme.error))),
          TextButton(key: const Key('guests-retry'), onPressed: () => ref.invalidate(guestRosterProvider(widget.code)), child: const Text('Try again')),
        ],
      ),
      data: (r) {
        final places = r.maxGuests - 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(places <= 0 ? 'This table seats just you.' : '${r.guests.length} of $places guest places given out. Each guest gets their own ticket by e-mail.', key: const Key('guests-summary'), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            for (final g in r.guests)
              ListTile(
                key: Key('guest-${g.id}'),
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(g.name),
                subtitle: Text(g.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(g.status, key: Key('guest-status-${g.id}'), style: theme.textTheme.bodySmall),
                    if (!g.checkedIn) TextButton(key: Key('guest-resend-${g.id}'), onPressed: _busy ? null : () => _resend(g), child: const Text('Send again')),
                  ],
                ),
              ),
            if (places > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: r.canAdd
                    ? OutlinedButton.icon(key: const Key('guest-add'), onPressed: _busy ? null : () => _add(r), icon: const Icon(Icons.person_add_alt_1_outlined), label: const Text('Invite guests'))
                    : Text('Every guest place is taken.', key: const Key('guests-full'), style: theme.textTheme.bodySmall),
              ),
          ],
        );
      },
    );
  }
}

/// Asks for a name and an e-mail for each guest to invite, up to [places]. Gives back only complete, well-formed ones.
class _AddGuestsSheet extends StatefulWidget {
  const _AddGuestsSheet({required this.places});

  final int places;

  @override
  State<_AddGuestsSheet> createState() => _AddGuestsSheetState();
}

class _AddGuestsSheetState extends State<_AddGuestsSheet> {
  final List<(TextEditingController, TextEditingController)> _rows = [(TextEditingController(), TextEditingController())];
  String? _problem;

  @override
  void dispose() {
    for (final (n, e) in _rows) {
      n.dispose();
      e.dispose();
    }
    super.dispose();
  }

  void _send() {
    final out = <({String name, String email})>[];
    for (final (n, e) in _rows) {
      final name = n.text.trim(), email = e.text.trim();
      if (name.isEmpty && email.isEmpty) continue;
      if (name.isEmpty) return setState(() => _problem = 'Give each guest a name.');
      if (!_emailShape.hasMatch(email)) return setState(() => _problem = 'Enter a valid e-mail for $name.');
      out.add((name: name, email: email));
    }
    if (out.isEmpty) return setState(() => _problem = 'Add at least one guest.');
    final seen = <String>{};
    for (final g in out) {
      if (!seen.add(g.email.toLowerCase())) return setState(() => _problem = '${g.email} is listed twice.');
    }
    Navigator.of(context).pop(out);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invite guests', style: theme.textTheme.titleLarge),
            Text('${widget.places} ${widget.places == 1 ? 'place' : 'places'} left. Each guest gets their own ticket at the e-mail you give.', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            for (var i = 0; i < _rows.length; i++) ...[
              TextField(key: Key('guest-name-$i'), controller: _rows[i].$1, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(key: Key('guest-email-$i'), controller: _rows[i].$2, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder())),
              const SizedBox(height: 12),
            ],
            if (_rows.length < widget.places) TextButton.icon(key: const Key('guest-more'), onPressed: () => setState(() => _rows.add((TextEditingController(), TextEditingController()))), icon: const Icon(Icons.add), label: const Text('Another guest')),
            if (_problem != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_problem!, key: const Key('guest-problem'), style: TextStyle(color: theme.colorScheme.error))),
            SizedBox(width: double.infinity, child: FilledButton(key: const Key('guest-send'), onPressed: _send, child: const Text('Send tickets'))),
          ],
        ),
      ),
    );
  }
}
