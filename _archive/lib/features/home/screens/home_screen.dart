import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_app_bar2.dart';
import '../widgets/categories_section.dart';
import '../widgets/popular_clubs_section.dart';
import '../widgets/featured_clubs_carousel.dart';
import '../widgets/back_to_top_button.dart';
import '../widgets/events_section.dart';
import '../widgets/event_filter_bottom_sheet.dart';
import '../models/club.dart';
import '../services/location_service.dart';
import '../providers/home_provider.dart';
import '../providers/event_filter_provider.dart';
import '../../../../core/ui/glass_kit.dart';
import '../../../shared/widgets/shimmer_loading.dart';

/// HomeScreen now fetches real data from Supabase instead of using hardcoded data.
/// 
/// Integration includes:
/// - Categories from 'categories' table
/// - Clubs from 'clubs' table with category information
/// - Featured clubs based on ratings
/// - Proper error handling and loading states
/// - Fallback to default data if Supabase is unavailable
///
/// The UI remains completely unchanged - only the data source has been switched.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class HomeScreenInternal extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  
  const HomeScreenInternal({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<HomeScreenInternal> createState() => _HomeScreenInternalState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return HomeScreenInternal(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _HomeScreenInternalState extends ConsumerState<HomeScreenInternal> {
  final TextEditingController _searchController = TextEditingController();

  double _scrollOffset = 0.0;
  String _currentLocation = 'Nearby';
  bool _isLoadingLocation = false;
  bool _showBackToTop = false;
  DateTime _lastScrollUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final now = DateTime.now();
    final currentOffset = widget.scrollController.offset.clamp(0.0, double.infinity);
    final showBackToTop = currentOffset >= 500;

    // Throttle scroll updates to every 16ms (60fps) and only on meaningful changes
    if (now.difference(_lastScrollUpdate).inMilliseconds >= 16 &&
        ((currentOffset - _scrollOffset).abs() > 10 || showBackToTop != _showBackToTop)) {
      setState(() {
        _scrollOffset = currentOffset;
        _showBackToTop = showBackToTop;
      });
      _lastScrollUpdate = now;
    }

    // Pagination removed for now - can be re-implemented later if needed
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await LocationService.instance.getLocationWithFallback();
      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Nearby';
        _isLoadingLocation = false;
      });
    }
  }

  void _onLocationTap() {
    _loadCurrentLocation();
  }

  void _onCategorySelected(String category) {
    ref.read(selectedCategoryProvider.notifier).update(category);
  }

  @override
  Widget build(BuildContext context) {
    final heroSectionHeight = MediaQuery.of(context).size.height * 0.5;
    
    // Watch the providers
    final categoriesAsync = ref.watch(categoriesProvider);
    final clubsAsync = ref.watch(clubsProvider);
    final featuredClubsAsync = ref.watch(featuredClubsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final upcomingEventsAsync = ref.watch(upcomingEventsProvider);
    final liveEventsAsync = ref.watch(liveEventsProvider);

    return AmbientGlowBackground(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            controller: widget.scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: featuredClubsAsync.when(
                  data: (featuredClubs) {
                    final heroClub = featuredClubs.isNotEmpty 
                        ? featuredClubs[0] 
                        : const Club(
                            id: '1',
                            name: 'Welcome to Bottles Up',
                            imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop',
                            rating: 5.0,
                            location: 'Your City',
                            priceRange: '\$30-80',
                            description: 'Discover amazing nightlife',
                          );
                    
                    return Stack(
                      children: [
                        // Hero Image
                        Container(
                          height: heroSectionHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(heroClub.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        Container(
                          height: heroSectionHeight,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF171214),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                heroClub.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    heroClub.location,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => HeroShimmer(height: heroSectionHeight),
                  error: (error, stack) => Container(
                    height: heroSectionHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF171214),
                          Color(0xFF171214),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Welcome to Bottles Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Gap(32),

                    // Categories Section
                    categoriesAsync.when(
                      data: (categories) => CategoriesSection(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onCategorySelected: _onCategorySelected,
                      ),
                      loading: () => const CategoryShimmer(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),

                    const Gap(32),

                    // Live Events Section (if any)
                    liveEventsAsync.when(
                      data: (events) => events.isNotEmpty
                          ? Column(
                              children: [
                                EventsListSection(
                                  events: events,
                                  title: 'Live Now 🔴',
                                ),
                                const Gap(32),
                              ],
                            )
                          : const SizedBox.shrink(),
                      loading: () => const EventsShimmer(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),

                    // Upcoming Events Section with Filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                'Upcoming Events',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Spacer(),
                              Consumer(
                                builder: (context, ref, child) {
                                  final hasFilters = ref.watch(
                                    eventFilterStateProvider.select(
                                      (filter) => filter.genre != null ||
                                                 filter.date != null ||
                                                 filter.location != null,
                                    ),
                                  );

                                  return FilledButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const EventFilterBottomSheet(),
                                      );
                                    },
                                    icon: Icon(
                                      hasFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Filter'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      backgroundColor: hasFilters
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                                      foregroundColor: hasFilters
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        upcomingEventsAsync.when(
                          data: (events) => events.isNotEmpty
                              ? EventsSection(events: events)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                  child: Center(
                                    child: Text(
                                      'No events found matching your filters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                ),
                          loading: () => const EventsShimmer(),
                          error: (error, stack) => const SizedBox.shrink(),
                        ),
                        const Gap(32),
                      ],
                    ),

                    // Featured Clubs Carousel
                    featuredClubsAsync.when(
                      data: (clubs) => clubs.isNotEmpty
                          ? FeaturedClubsCarousel(clubs: clubs)
                          : const SizedBox.shrink(),
                      loading: () => const FeaturedClubShimmer(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),

                    const Gap(32),

                    // Popular Clubs Section
                    clubsAsync.when(
                      data: (clubs) {
                        if (clubs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'No clubs found for this category.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          );
                        }
                        return PopularClubsSection(clubs: clubs);
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ClubListShimmer(),
                      ),
                      error: (error, stack) => const Center(
                        child: Text(
                          'Error loading clubs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 20), // Bottom padding for navigation
                  ],
                ),
              ),
            ],
          ),

          // Custom App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar2(
              scrollController: widget.scrollController,
              scrollOffset: _scrollOffset,
              onNotificationTap: () {
                context.push('/notifications');
              },
            ),
          ),

          // Back to top button
          BackToTopButton(
            isVisible: _showBackToTop,
            onPressed: _scrollToTop,
          ),
        ],
      ),
    ),
    );
  }
}
