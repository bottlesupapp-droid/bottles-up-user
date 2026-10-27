import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/site_event.dart';
import '../../../site/models/venue.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/event_rules.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';
import '../../discover/widgets/event_card.dart';
import '../../tables/widgets/venue_card.dart';
import '../widgets/profile_widgets.dart';

/// Explore: what is hot, events you can narrow by when, price and what is still available, and one search for events, venues and people. People come from the social side and
/// need a profile; events and venues need nothing.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key, DateTime? now}) : _now = now;

  final DateTime? _now;

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _search = TextEditingController();
  String _query = '';
  DateFilter _when = DateFilter.any;
  PriceFilter _price = PriceFilter.any;
  bool _available = false;
  String? _category;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(upcomingEventsProvider);
    final venues = ref.watch(venuesProvider);
    final now = widget._now ?? DateTime.now();
    final searching = _query.trim().length >= 2;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('explore-search'),
          controller: _search,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(hintText: 'Search events, venues and people', border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [if (_search.text.isNotEmpty) IconButton(key: const Key('explore-clear'), icon: const Icon(Icons.close), onPressed: () => setState(() {
              _search.clear();
              _query = '';
            }))],
      ),
      body: events.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('events'), onRetry: () => ref.invalidate(upcomingEventsProvider)),
        data: (allEvents) {
          final allVenues = venues.valueOrNull ?? const <Venue>[];
          if (searching) return _results(context, allEvents, allVenues);
          var shown = filterEvents(allEvents, category: _category);
          shown = filterEventsByDate(shown, _when, now);
          shown = filterEventsByPrice(shown, _price);
          if (_available) shown = onlyAvailableEvents(shown);
          final hotVenues = inHotOrder<Venue>(allVenues, (v) => v.id, [for (final h in ref.watch(hotVenuesProvider).valueOrNull ?? const []) h.id]);
          final hotEvents = inHotOrder<SiteEvent>(allEvents, (e) => e.id, [for (final h in ref.watch(hotEventsProvider).valueOrNull ?? const []) h.id]);
          final categories = categoriesOf(allEvents);
          return ListView(
            key: const Key('explore-page'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              if (hotVenues.isNotEmpty) ...[
                const _Heading('Hot venues', key: Key('hot-venues-heading')),
                SizedBox(
                  height: 190,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    for (final v in hotVenues) _MiniCard(key: Key('hot-venue-${v.id}'), url: v.picture, title: v.name, subtitle: v.address ?? '', onTap: () => context.push('/venues/${v.id}')),
                  ]),
                ),
              ],
              if (hotEvents.isNotEmpty) ...[
                const _Heading('Hot events', key: Key('hot-events-heading')),
                SizedBox(
                  height: 190,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    for (final e in hotEvents) _MiniCard(key: Key('hot-event-${e.id}'), url: e.picture, title: e.title, subtitle: e.venueName, onTap: () => context.push('/events/${e.id}')),
                  ]),
                ),
              ],
              ListTile(
                key: const Key('open-professionals'),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.groups_2_outlined),
                title: const Text('DJs, photographers and more'),
                subtitle: const Text('Find a professional for your night'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/explore/professionals'),
              ),
              const _Heading('Events'),
              Wrap(spacing: 8, children: [
                for (final f in DateFilter.values)
                  ChoiceChip(key: Key('when-${f.name}'), label: Text(switch (f) { DateFilter.any => 'Any day', DateFilter.tonight => 'Tonight', DateFilter.weekend => 'This weekend' }), selected: _when == f, onSelected: (_) => setState(() => _when = f)),
              ]),
              Wrap(spacing: 8, children: [
                for (final f in PriceFilter.values)
                  ChoiceChip(key: Key('price-${f.name}'), label: Text(switch (f) { PriceFilter.any => 'Any price', PriceFilter.free => 'Free', PriceFilter.under30 => 'Under \$30' }), selected: _price == f, onSelected: (_) => setState(() => _price = f)),
                FilterChip(key: const Key('only-available'), label: const Text('Tickets left'), selected: _available, onSelected: (v) => setState(() => _available = v)),
              ]),
              if (categories.isNotEmpty)
                Wrap(spacing: 8, children: [
                  for (final c in categories) ChoiceChip(key: Key('category-$c'), label: Text(c), selected: _category == c, onSelected: (on) => setState(() => _category = on ? c : null)),
                ]),
              const SizedBox(height: 12),
              if (shown.isEmpty)
                const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No events match. Try loosening a filter.', key: Key('no-matching-events'))))
              else
                for (final e in shown) EventCard(event: e, now: now, onTap: () => context.push('/events/${e.id}')),
            ],
          );
        },
      ),
    );
  }

  Widget _results(BuildContext context, List<SiteEvent> allEvents, List<Venue> allVenues) {
    final q = _query.trim();
    final events = filterEvents(allEvents, query: q);
    final venues = filterVenues(allVenues, q);
    final actor = ref.watch(actorProfileProvider);
    final people = actor == null ? null : ref.watch(profileSearchProvider(SearchKey(actor: actor.id, query: q)));
    final peopleList = people?.valueOrNull ?? const [];
    final nothing = events.isEmpty && venues.isEmpty && peopleList.isEmpty && (people == null || !people.isLoading);
    return ListView(key: const Key('explore-results'), padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), children: [
      if (events.isNotEmpty) ...[
        const _Heading('Events'),
        for (final e in events) EventCard(event: e, now: widget._now, onTap: () => context.push('/events/${e.id}')),
      ],
      if (venues.isNotEmpty) ...[
        const _Heading('Venues'),
        for (final v in venues) VenueCard(venue: v, onTap: () => context.push('/venues/${v.id}')),
      ],
      if (peopleList.isNotEmpty) ...[
        const _Heading('People'),
        for (final p in peopleList) ProfileTile(profile: p, onTap: () => context.push('/u/${p.handle}')),
      ],
      if (nothing) Padding(padding: const EdgeInsets.all(24), child: Center(child: Text('Nothing matches "$q".', key: const Key('explore-nothing')))),
    ]);
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 8), child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)));
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({super.key, required this.url, required this.title, required this.subtitle, required this.onTap});

  final String? url;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            NetworkPicture(url: url, height: 110, width: 140, radius: 12),
            const SizedBox(height: 6),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}
