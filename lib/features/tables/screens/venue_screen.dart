import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/venue.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/floor_plan.dart';

/// Chooses a calendar day the venue takes bookings on. The app opens the phone's date picker; tests give their own.
typedef PickNight = Future<DateTime?> Function(BuildContext context, Venue venue, DateTime today);

Future<DateTime?> pickNightWithCalendar(BuildContext context, Venue venue, DateTime today) {
  final first = DateTime(today.year, today.month, today.day);
  final firstBookable = firstBookableNight(venue, today: today);
  if (firstBookable == null) return Future.value(null);
  final last = venue.bookingEnd ?? DateTime(first.year + 1, first.month, first.day);
  return showDatePicker(
    context: context,
    initialDate: firstBookable,
    firstDate: first,
    lastDate: last.isBefore(firstBookable) ? firstBookable : last,
    selectableDayPredicate: (d) => canBookNight(venue, d, today: today),
  );
}

/// One venue: what it is, then the date and time, which tables are free for that night, the floor plan if it has one, and the tables to book.
class VenueScreen extends ConsumerStatefulWidget {
  const VenueScreen({super.key, required this.venueId, this.onBook, this.pickNight = pickNightWithCalendar, DateTime? now}) : _now = now;

  final String venueId;

  /// Where booking a table goes. The app opens the booking; tests give their own.
  final void Function(BuildContext context, Venue venue, TableType table, DateTime night, TimeSlot slot)? onBook;
  final PickNight pickNight;
  final DateTime? _now;

  @override
  ConsumerState<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends ConsumerState<VenueScreen> {
  DateTime? _night;
  String? _slotId;
  String? _floorId;

  DateTime get _today => widget._now ?? DateTime.now();

  void _chooseNight(Venue venue, DateTime night) {
    final slots = slotsOn(venue, night);
    setState(() {
      _night = DateTime(night.year, night.month, night.day);
      // The first time of the day, as the website does; the guest can change it.
      _slotId = slots.isEmpty ? null : slots.first.id;
    });
  }

  Future<void> _more(Venue venue) async {
    final picked = await widget.pickNight(context, venue, _today);
    if (picked != null && mounted) _chooseNight(venue, picked);
  }

  void _book(Venue venue, TableType table, TimeSlot slot) {
    final night = _night!;
    (widget.onBook ?? (c, v, t, n, s) => c.push('/venues/${v.id}/tables/${t.id}/book?date=${dayKey(n)}&slot=${s.id}'))(context, venue, table, night, slot);
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(venueProvider(widget.venueId));
    return Scaffold(
      appBar: AppBar(title: Text(venue.valueOrNull?.name ?? 'Venue')),
      body: venue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this venue'), onRetry: () => ref.invalidate(venueProvider(widget.venueId))),
        data: (v) {
          if (v == null) {
            return const EmptyState(icon: Icons.storefront_outlined, title: 'This venue is no longer available', text: 'It may have been taken down. See what else is on.');
          }
          return _body(v);
        },
      ),
    );
  }

  Widget _body(Venue venue) {
    final theme = Theme.of(context);
    final night = _night;
    final slots = night == null ? <TimeSlot>[] : slotsOn(venue, night);
    TimeSlot? slot;
    for (final s in slots) {
      if (s.id == _slotId) slot = s;
    }
    final canPick = night != null && slot != null;
    final query = canPick ? AvailabilityQuery(venueId: venue.id, night: dayKey(night), slotId: slot.id) : null;
    final availability = query == null ? null : ref.watch(unavailableTablesProvider(query));
    final unavailable = availability?.valueOrNull ?? const <String>{};
    final nights = nextBookableNights(venue, today: _today);
    final note = canPick ? arrivalNote(night, slot) : null;
    final info = <(String, IconData, String)>[
      if (venue.address != null) ('venue-address', Icons.place_outlined, venue.address!),
      if (venue.hoursNote != null) ('venue-hours', Icons.schedule, venue.hoursNote!),
      if (venue.dressCode != null) ('venue-dress', Icons.checkroom_outlined, 'Dress code: ${venue.dressCode}'),
      if (venue.musicGenres != null) ('venue-music', Icons.music_note_outlined, venue.musicGenres!),
      if (venue.capacity != null) ('venue-capacity', Icons.groups_outlined, 'Capacity ${venue.capacity}'),
      if (venue.phone != null) ('venue-phone', Icons.phone_outlined, venue.phone!),
    ];
    final floors = venue.hasFloorPlan ? ref.watch(venueFloorsProvider(venue.id)).valueOrNull ?? const <Floor>[] : const <Floor>[];
    final floorsWithTables = [
      for (final f in floors)
        if (venue.tables.any((t) => t.hasSpot && t.floorId == f.id)) f,
    ];
    Floor? activeFloor;
    for (final f in floorsWithTables) {
      if (f.id == _floorId) activeFloor = f;
    }
    activeFloor ??= floorsWithTables.isEmpty ? null : floorsWithTables.first;

    return ListView(
      key: const Key('venue-page'),
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        NetworkPicture(url: venue.picture, height: 200, width: double.infinity, radius: 0),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (venue.category != null) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(venue.category!.toUpperCase(), style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, letterSpacing: 1.2))),
              Text(venue.name, key: const Key('venue-title'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              for (final (key, icon, text) in info)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18, color: theme.colorScheme.primary), const SizedBox(width: 10), Expanded(child: Text(text, key: Key(key)))]),
                ),
              if (venue.description != null) ...[
                const SizedBox(height: 12),
                Text(venue.description!, key: const Key('venue-description'), style: theme.textTheme.bodyLarge),
              ],
              const SizedBox(height: 20),
              Text('Pick a date and time', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (!venue.isBookable)
                Text('Table bookings are not open at this venue yet.', key: const Key('not-bookable'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))
              else ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final n in nights)
                      ChoiceChip(
                        key: Key('night-${dayKey(n)}'),
                        label: Text(DateFormat('EEE, MMM d').format(n)),
                        selected: night != null && dayKey(night) == dayKey(n),
                        onSelected: (_) => _chooseNight(venue, n),
                      ),
                    ActionChip(key: const Key('pick-date'), avatar: const Icon(Icons.calendar_month, size: 18), label: Text(night != null && !nights.any((n) => dayKey(n) == dayKey(night)) ? DateFormat('EEE, MMM d').format(night) : 'Other date'), onPressed: () => _more(venue)),
                  ],
                ),
                if (venue.bookingStart != null || venue.bookingEnd != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Bookings open ${venue.bookingStart == null ? 'now' : DateFormat('MMM d, yyyy').format(venue.bookingStart!)}${venue.bookingEnd == null ? '' : ' through ${DateFormat('MMM d, yyyy').format(venue.bookingEnd!)}'}.',
                      key: const Key('booking-window'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                if (night != null) ...[
                  const SizedBox(height: 12),
                  Text('Arrival time', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in slots) ChoiceChip(key: Key('slot-${s.id}'), label: Text(slotLabel(s)), selected: s.id == _slotId, onSelected: (_) => setState(() => _slotId = s.id)),
                    ],
                  ),
                  if (note != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(note, key: const Key('arrival-note'), style: TextStyle(color: theme.colorScheme.primary))),
                ],
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text('Tables', style: theme.textTheme.titleMedium)),
                  if (availability != null && availability.isLoading) const Text('Checking availability...', key: Key('checking')),
                ],
              ),
              if (!canPick && venue.isBookable) Padding(padding: const EdgeInsets.only(top: 4), child: Text('Pick a date and time to see which tables are free.', key: const Key('pick-first'), style: theme.textTheme.bodySmall)),
              if (availability != null && availability.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(availability.error is SiteException ? (availability.error as SiteException).message : 'We could not check which tables are free.', key: const Key('availability-error'), style: TextStyle(color: theme.colorScheme.error))),
                      TextButton(key: const Key('availability-retry'), onPressed: () => ref.invalidate(unavailableTablesProvider(query!)), child: const Text('Try again')),
                    ],
                  ),
                ),
              if (activeFloor != null) ...[
                const SizedBox(height: 12),
                if (floorsWithTables.length > 1)
                  Wrap(
                    spacing: 8,
                    children: [for (final f in floorsWithTables) ChoiceChip(key: Key('floor-${f.id}'), label: Text(f.label), selected: f.id == activeFloor.id, onSelected: (_) => setState(() => _floorId = f.id))],
                  ),
                const SizedBox(height: 8),
                FloorPlan(
                  key: const Key('floor-plan'),
                  floor: activeFloor,
                  tables: [for (final t in venue.tables) if (t.hasSpot && t.floorId == activeFloor.id) t],
                  unavailable: unavailable,
                  canPick: canPick,
                  onPick: (t) => _book(venue, t, slot!),
                ),
              ],
              const SizedBox(height: 8),
              for (final t in venue.tables)
                _TableTile(
                  table: t,
                  bookable: venue.isBookable,
                  canPick: canPick,
                  taken: canPick && unavailable.contains(t.id),
                  onBook: () => _book(venue, t, slot!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableTile extends StatelessWidget {
  const _TableTile({required this.table, required this.bookable, required this.canPick, required this.taken, required this.onBook});

  final TableType table;
  final bool bookable;
  final bool canPick;
  final bool taken;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = !bookable
        ? 'Coming soon'
        : taken
            ? 'Booked for this date'
            : canPick
                ? 'Book table'
                : 'Pick a date above';
    final extras = <String>[
      if (table.tableView != null) table.tableView!,
      if (table.seatingType != null) table.seatingType!,
      if (table.privacyLevel != null) table.privacyLevel!,
    ];
    return Card(
      key: Key('table-${table.id}'),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(table.name, key: Key('table-name-${table.id}'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                if (table.badgeLabel != null) Chip(label: Text(table.badgeLabel!), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: 4),
            Text('Up to ${table.maxGuests} guests', key: Key('table-guests-${table.id}')),
            if (table.description != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(table.description!, style: theme.textTheme.bodySmall)),
            if (extras.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 2), child: Text(extras.join(' · '), style: theme.textTheme.bodySmall)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(tablePriceLabel(table), key: Key('table-price-${table.id}'), style: theme.textTheme.titleSmall)),
                Text(table.isHourly ? '' : 'Deposit ${formatMoney(table.depositCents, currency: table.currency)}', key: Key('table-deposit-${table.id}'), style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: FilledButton(key: Key('book-${table.id}'), onPressed: bookable && canPick && !taken ? onBook : null, child: Text(label))),
          ],
        ),
      ),
    );
  }
}
