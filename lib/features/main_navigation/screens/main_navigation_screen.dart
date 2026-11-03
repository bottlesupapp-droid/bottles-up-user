import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../site/models/features.dart';
import '../../../site/providers/site_providers.dart';
import '../../discover/screens/events_screen.dart';
import '../../social/screens/explore_screen.dart';
import '../../social/screens/home_feed_screen.dart';
import '../../social/screens/inbox_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../tables/screens/tables_screen.dart';
import '../../bookings_site/screens/bookings_tab.dart';
import '../providers/nav_index_provider.dart';
import 'package:bottles_up_user/core/ui/glass_kit.dart';

// Replace the above import with Ionicons
import 'package:ionicons/ionicons.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isBottomNavVisible = true;

  /// Which layout is showing: the original Events / Tables / Bookings / Profile tabs, or (when BottlesUp has switched `social` on) Home / Explore / Create / Inbox / Profile.
  bool _social = false;

  /// The page in front in the social layout. (The original layout keeps its own place in [_currentIndex].)
  _Page _front = _Page.home;

  /// The pages of the social layout that have been opened. A page is built when first opened and then kept, so nothing loads until it is wanted.
  final Set<_Page> _opened = {_Page.home};
  
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  final List<ScrollController> _scrollControllers = [
    ScrollController(), // Events
    ScrollController(), // Tables
    ScrollController(), // My tickets
    ScrollController(), // Profile
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Listen to scroll events on all controllers
    for (int i = 0; i < _scrollControllers.length; i++) {
      _scrollControllers[i].addListener(() => _onScroll(i));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll(int index) {
    if (_social || index != _currentIndex) return;
    
    final controller = _scrollControllers[index];
    if (controller.hasClients) {
      final direction = controller.position.userScrollDirection;
      
      if (direction == ScrollDirection.forward && !_isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = true;
        });
        _animationController.forward();
      } else if (direction == ScrollDirection.reverse && _isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = false;
        });
        _animationController.reverse();
      }
    }
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // If tapping the same tab, scroll to top
      final controller = _scrollControllers[index];
      if (controller.hasClients) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
      ref.read(mainNavIndexProvider.notifier).state = index;
    }
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case MainTab.events:
        return EventsScreen(scrollController: _scrollControllers[MainTab.events]);
      case MainTab.tables:
        return TablesScreen(scrollController: _scrollControllers[MainTab.tables]);
      case MainTab.bookings:
        return BookingsTab(scrollController: _scrollControllers[MainTab.bookings]);
      default:
        return ProfileScreenWrapper(scrollController: _scrollControllers[MainTab.profile]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Which layout to show comes from BottlesUp's switches. Until they are known nothing is drawn, so the wrong layout is never flashed.
    final features = ref.watch(featuresProvider);
    if (!features.hasValue && !features.hasError) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(key: Key('shell-loading'))));
    }
    _social = ref.watch(featureOnProvider(Feature.social));
    return _social ? _socialShell(context) : _classicShell(context);
  }

  Widget _classicShell(BuildContext context) {
    // Listen to external tab-switch requests (e.g. from success dialogs)
    ref.listen<int>(mainNavIndexProvider, (previous, next) {
      if (!_social && next != _currentIndex) {
        setState(() => _currentIndex = next);
      }
    });

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildScreen(MainTab.events),
              _buildScreen(MainTab.tables),
              _buildScreen(MainTab.bookings),
              _buildScreen(MainTab.profile),
            ],
          ),
          // Floating glass nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: GlassBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                items: const [
                  GlassNavItem(
                    icon: Ionicons.compass_outline,
                    activeIcon: Ionicons.compass,
                    label: 'Events',
                  ),
                  GlassNavItem(
                    icon: Ionicons.wine_outline,
                    activeIcon: Ionicons.wine,
                    label: 'Tables',
                  ),
                  GlassNavItem(
                    icon: Ionicons.ticket_outline,
                    activeIcon: Ionicons.ticket,
                    label: 'Bookings',
                  ),
                  GlassNavItem(
                    icon: Ionicons.person_outline,
                    activeIcon: Ionicons.person,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The pages the social layout has, in order (Create is a button, not a page). Messages are a page only while they are switched on.
  List<_Page> _pages({required bool inbox}) => [_Page.home, _Page.explore, if (inbox) _Page.inbox, _Page.profile];

  Widget _socialPage(_Page page) {
    if (!_opened.contains(page)) return const SizedBox.shrink();
    return switch (page) {
      _Page.home => const HomeFeedScreen(),
      _Page.explore => const ExploreScreen(),
      _Page.inbox => const InboxScreen(),
      _Page.profile => ProfileScreenWrapper(scrollController: _scrollControllers[MainTab.profile]),
    };
  }

  Widget _socialShell(BuildContext context) {
    final inboxOn = ref.watch(featureOnProvider(Feature.inbox));
    final pages = _pages(inbox: inboxOn);
    // The switches are read again when the person signs in as someone else; if messages have gone while the Inbox is in front, Home is.
    if (!pages.contains(_front)) _front = _Page.home;
    final current = _front;
    final front = pages.indexOf(current);
    _opened.add(current);
    final actor = ref.watch(actorProfileProvider);
    // (The count is nothing while messages are switched off: inboxCountsProvider says so.)
    final badge = actor != null ? (ref.watch(inboxCountsProvider(actor.id)).valueOrNull?.badge ?? 0) : 0;
    // The navigation items: the pages in order, with Create as a button in the middle after Explore.
    final items = <({_Page? page, GlassNavItem item})>[
      (page: _Page.home, item: const GlassNavItem(icon: Ionicons.home_outline, activeIcon: Ionicons.home, label: 'Home')),
      (page: _Page.explore, item: const GlassNavItem(icon: Ionicons.compass_outline, activeIcon: Ionicons.compass, label: 'Explore')),
      (page: null, item: const GlassNavItem(icon: Ionicons.add, activeIcon: Ionicons.add, label: 'Create', isAction: true)),
      if (inboxOn) (page: _Page.inbox, item: GlassNavItem(icon: Ionicons.chatbubble_outline, activeIcon: Ionicons.chatbubble, label: 'Inbox', badge: badge)),
      (page: _Page.profile, item: const GlassNavItem(icon: Ionicons.person_outline, activeIcon: Ionicons.person, label: 'Profile')),
    ];
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            key: const Key('social-pages'),
            index: front,
            // IndexedStack keeps the pages behind the front one alive and running: switching their tickers off is what tells a page it is hidden (the inbox stops looking for news).
            children: [for (var i = 0; i < pages.length; i++) TickerMode(enabled: i == front, child: _socialPage(pages[i]))],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassBottomNavBar(
              currentIndex: items.indexWhere((e) => e.page == current),
              onTap: (i) {
                final page = items[i].page;
                if (page == null) {
                  context.push('/create');
                } else {
                  setState(() => _front = page);
                }
              },
              items: [for (final e in items) e.item],
            ),
          ),
        ],
      ),
    );
  }
}

enum _Page { home, explore, inbox, profile }

class ProfileScreenWrapper extends StatelessWidget {
  final ScrollController scrollController;

  const ProfileScreenWrapper({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileScreenInternal(scrollController: scrollController);
  }
}
