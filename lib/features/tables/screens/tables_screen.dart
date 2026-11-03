import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/review.dart';
import '../../../site/models/venue.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/venue_card.dart';

/// Tables (a tab): the venues that take VIP table bookings, with a search. Tapping one opens its page, where the date, time and table are chosen.
class TablesScreen extends ConsumerStatefulWidget {
  const TablesScreen({super.key, this.scrollController, this.onOpenVenue});

  final ScrollController? scrollController;

  /// Where tapping a venue goes. The app opens the venue page; tests give their own.
  final void Function(BuildContext context, Venue venue)? onOpenVenue;

  @override
  ConsumerState<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<TablesScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(Venue v) => (widget.onOpenVenue ?? (c, venue) => c.push('/venues/${venue.id}'))(context, v);

  @override
  Widget build(BuildContext context) {
    final venues = ref.watch(venuesProvider);
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: venues.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('venues'), onRetry: () => ref.invalidate(venuesProvider)),
        data: (all) {
          final shown = filterVenues(all, _search.text);
          final ratings = ref.watch(venueRatingsProvider([for (final v in shown) v.id].join(','))).valueOrNull ?? const <String, VenueRating>{};
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(venuesProvider);
              await ref.read(venuesProvider.future).catchError((_) => <Venue>[]);
            },
            child: ListView(
              key: const Key('tables-list'),
              controller: widget.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                Text('VIP tables', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Reserve a table, add bottles, skip the line.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('tables-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search venues or tables',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty ? null : IconButton(key: const Key('tables-search-clear'), icon: const Icon(Icons.close), onPressed: () => setState(() => _search.clear())),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 14),
                if (all.isEmpty)
                  const SizedBox(height: 360, child: EmptyState(icon: Icons.table_restaurant_outlined, title: 'No tables right now', text: 'Venues appear here as soon as they open table bookings.'))
                else if (shown.isEmpty)
                  const SizedBox(height: 300, child: EmptyState(icon: Icons.search_off, title: 'Nothing matches', text: 'Try a different word, or clear the search.'))
                else
                  for (final v in shown) VenueCard(venue: v, rating: ratings[v.id], onTap: () => _open(v)),
              ],
            ),
          );
        },
      ),
    );
  }
}
