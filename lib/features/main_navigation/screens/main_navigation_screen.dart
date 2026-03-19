import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../home/screens/home_screen.dart';
import '../../events/screens/event_discovery_screen.dart';
import '../../bookings/screens/my_bookings_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../messaging/screens/conversations_screen.dart';

// Replace the above import with Ionicons
import 'package:ionicons/ionicons.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isBottomNavVisible = true;
  
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  final List<ScrollController> _scrollControllers = [
    ScrollController(), // Feed
    ScrollController(), // Discover
    ScrollController(), // Book
    ScrollController(), // Messages
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
    if (index != _currentIndex) return;
    
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
    }
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreenWrapper(scrollController: _scrollControllers[0]); // Feed
      case 1:
        return SearchScreenWrapper(scrollController: _scrollControllers[1]); // Discover
      case 2:
        return BookingsScreenWrapper(scrollController: _scrollControllers[2]); // Book
      case 3:
        return MessagingScreenWrapper(scrollController: _scrollControllers[3]); // Messages
      case 4:
        return ProfileScreenWrapper(scrollController: _scrollControllers[4]); // Profile
      default:
        return HomeScreenWrapper(scrollController: _scrollControllers[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildScreen(0),
              _buildScreen(1),
              _buildScreen(2),
              _buildScreen(3),
              _buildScreen(4),
            ],
          ),
          // Custom Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildCustomBottomNavBar(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 10,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Ionicons.film_outline,
                activeIcon: Ionicons.film,
                label: 'Feed',
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Ionicons.compass_outline,
                activeIcon: Ionicons.compass,
                label: 'Discover',
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Ionicons.ticket_outline,
                activeIcon: Ionicons.ticket,
                label: 'Book',
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Ionicons.chatbubble_outline,
                activeIcon: Ionicons.chatbubble,
                label: 'Messages',
              ),
              _buildNavItem(
                context,
                index: 4,
                icon: Ionicons.person_outline,
                activeIcon: Ionicons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected 
                      ? colorScheme.primary 
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenWrapper extends StatelessWidget {
  final ScrollController scrollController;
  
  const HomeScreenWrapper({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return HomeScreenInternal(scrollController: scrollController);
  }
}

class SearchScreenWrapper extends StatelessWidget {
  final ScrollController scrollController;

  const SearchScreenWrapper({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return EventDiscoveryScreenInternal(scrollController: scrollController);
  }
}

class BookingsScreenWrapper extends StatelessWidget {
  final ScrollController scrollController;

  const BookingsScreenWrapper({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return MyBookingsScreenInternal(scrollController: scrollController);
  }
}

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

class MessagingScreenWrapper extends StatelessWidget {
  final ScrollController scrollController;

  const MessagingScreenWrapper({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ConversationsScreen(scrollController: scrollController);
  }
}