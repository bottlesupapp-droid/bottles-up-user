import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/event_filter_bottom_sheet.dart';
import '../widgets/event_category_chips.dart';

class EventDiscoveryScreen extends ConsumerStatefulWidget {
  const EventDiscoveryScreen({super.key});

  @override
  ConsumerState<EventDiscoveryScreen> createState() => _EventDiscoveryScreenState();
}

class EventDiscoveryScreenInternal extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const EventDiscoveryScreenInternal({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<EventDiscoveryScreenInternal> createState() =>
      _EventDiscoveryScreenInternalState();
}

class _EventDiscoveryScreenState extends ConsumerState<EventDiscoveryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return EventDiscoveryScreenInternal(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _EventDiscoveryScreenInternalState
    extends ConsumerState<EventDiscoveryScreenInternal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGenre = 'All';
  String _selectedCity = 'All Cities';
  final List<String> _genres = [
    'All',
    'EDM',
    'Hip-Hop',
    'House',
    'Techno',
    'Afrobeats',
    'R&B',
    'Luxury',
  ];

  final List<String> _cities = [
    'All Cities',
    'New York',
    'Los Angeles',
    'Miami',
    'Las Vegas',
    'Chicago',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventFilterBottomSheet(
        onApplyFilters: (filters) {
          // Apply filters using EventSearch provider
          ref.read(eventSearchProvider.notifier).search(
            query: _searchQuery.isNotEmpty ? _searchQuery : null,
            genre: _selectedGenre != 'All' ? _selectedGenre : null,
            city: _selectedCity != 'All Cities' ? _selectedCity : null,
          );
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Fetch events from Supabase
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: eventsAsync.when(
        loading: () => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: primaryColor,
            size: 50,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const Gap(16),
              Text(
                'Failed to load events',
                style: theme.textTheme.titleLarge,
              ),
              const Gap(8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              FilledButton.icon(
                onPressed: () => ref.invalidate(eventsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (events) {
          // Apply local filtering
          var filteredEvents = events;

          // Filter by search query
          if (_searchQuery.isNotEmpty) {
            filteredEvents = filteredEvents.where((event) {
              return event.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                     (event.clubName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
            }).toList();
          }

          // Filter by genre
          if (_selectedGenre != 'All') {
            filteredEvents = filteredEvents.where((event) {
              return event.categoryName?.toLowerCase() == _selectedGenre.toLowerCase();
            }).toList();
          }

          // Filter by city (assuming club location contains city name)
          if (_selectedCity != 'All Cities') {
            filteredEvents = filteredEvents.where((event) {
              return event.clubLocation?.contains(_selectedCity) ?? false;
            }).toList();
          }

          return CustomScrollView(
            controller: widget.scrollController,
            slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text(
                'Discover Events',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: const Icon(Iconsax.filter),
                  tooltip: 'Filters',
                ),
              ],
            ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search events, venues, DJs...',
                    prefixIcon: Icon(Iconsax.search_normal_1, color: primaryColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Genre Chips
          SliverToBoxAdapter(
            child: EventCategoryChips(
              genres: _genres,
              selectedGenre: _selectedGenre,
              onGenreSelected: (genre) {
                setState(() => _selectedGenre = genre);
              },
            ),
          ),

          // City Filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _cities.length + 1, // +1 for the location icon
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // First item is the location icon
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Center(
                        child: Icon(Iconsax.location, size: 18, color: primaryColor),
                      ),
                    );
                  }

                  final cityIndex = index - 1;
                  final city = _cities[cityIndex];
                  final isSelected = city == _selectedCity;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(city),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCity = city);
                        }
                      },
                      backgroundColor: theme.colorScheme.surface,
                      selectedColor: primaryColor.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? primaryColor
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Section: Featured Events
          if (filteredEvents.where((e) => e.isFeatured).isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    Icon(Iconsax.star_1, color: primaryColor, size: 20),
                    const Gap(8),
                    Text(
                      'Featured Events',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredEvents.where((e) => e.isFeatured).length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents.where((e) => e.isFeatured).elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 280,
                        child: EventCard(
                          event: event,
                          isFeatured: true,
                          onTap: () {
                            context.push('/events/${event.id}');
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // Section: Upcoming Events
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.calendar_1, color: primaryColor, size: 20),
                      const Gap(8),
                      Text(
                        'Upcoming Events',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Show all events
                    },
                    child: Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          // Event List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = filteredEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EventCard(
                      event: event,
                      onTap: () {
                        context.push('/events/${event.id}');
                      },
                    ),
                  );
                },
                childCount: filteredEvents.length,
              ),
            ),
          ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: Gap(100),
            ),
          ],
          );
        },
      ),
    );
  }
}
