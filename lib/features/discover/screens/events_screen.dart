import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/site_event.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/event_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/event_card.dart';

/// Events (the first tab): the events still to come, read from the website's published events, with a search and the categories they have. Tapping one opens its page, where the
/// ticket types are.
class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key, this.scrollController, this.onOpenEvent, DateTime? now}) : _now = now;

  final ScrollController? scrollController;

  /// Where tapping an event goes. The app opens the event page; tests give their own.
  final void Function(BuildContext context, SiteEvent event)? onOpenEvent;
  final DateTime? _now;

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final _search = TextEditingController();
  String? _category;
  DateFilter _when = DateFilter.any;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(SiteEvent e) => (widget.onOpenEvent ?? (c, ev) => c.push('/events/${ev.id}'))(context, e);

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(upcomingEventsProvider);
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: events.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(
          message: error is SiteException ? error.message : loadFailedMessage('events'),
          onRetry: () => ref.invalidate(upcomingEventsProvider),
        ),
        data: (all) {
          final shown = filterEventsByDate(filterEvents(all, query: _search.text, category: _category), _when, widget._now ?? DateTime.now());
          final categories = categoriesOf(all);
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(upcomingEventsProvider);
              await ref.read(upcomingEventsProvider.future).catchError((_) => <SiteEvent>[]);
            },
            child: ListView(
              key: const Key('events-list'),
              controller: widget.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                Text('Events', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('events-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search events, venues, artists',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            key: const Key('events-search-clear'),
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _search.clear()),
                          ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(key: const Key('when-any'), label: const Text('Any date'), selected: _when == DateFilter.any, onSelected: (_) => setState(() => _when = DateFilter.any)),
                    ChoiceChip(key: const Key('when-tonight'), label: const Text('Tonight'), selected: _when == DateFilter.tonight, onSelected: (_) => setState(() => _when = DateFilter.tonight)),
                    ChoiceChip(key: const Key('when-weekend'), label: const Text('This weekend'), selected: _when == DateFilter.weekend, onSelected: (_) => setState(() => _when = DateFilter.weekend)),
                  ],
                ),
                if (categories.length > 1) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(key: const Key('category-all'), label: const Text('All'), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
                        ),
                        for (final c in categories)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(key: Key('category-$c'), label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = _category == c ? null : c)),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                if (all.isEmpty)
                  const SizedBox(height: 360, child: EmptyState(icon: Icons.event_outlined, title: 'No events right now', text: 'New events appear here as soon as they are announced.'))
                else if (shown.isEmpty)
                  const SizedBox(height: 300, child: EmptyState(icon: Icons.search_off, title: 'Nothing matches', text: 'Try a different word, or clear the search.'))
                else
                  for (final e in shown) EventCard(event: e, onTap: () => _open(e)),
              ],
            ),
          );
        },
      ),
    );
  }
}
