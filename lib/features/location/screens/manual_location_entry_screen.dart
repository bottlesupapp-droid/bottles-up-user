import 'package:bottles_up_user/common_widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';

class ManualLocationEntryScreen extends ConsumerStatefulWidget {
  const ManualLocationEntryScreen({super.key});

  @override
  ConsumerState<ManualLocationEntryScreen> createState() => _ManualLocationEntryScreenState();
}

class _ManualLocationEntryScreenState extends ConsumerState<ManualLocationEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<String> _searchResults = [];
  bool _isSearching = false;
  
  // Sample search results - you can replace this with actual API
  final List<String> _sampleLocations = [
    'Golden Avenue, 8502 Preston Rd, Inglewood, CA 90301',
    'Golden Gate Bridge, San Francisco, CA',
    'Golden Gate Park, San Francisco, CA',
    'Golden State Warriors Chase Center, San Francisco, CA',
    'Golden Beach, Miami, FL',
    'Golden Valley, Minneapolis, MN',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate API search with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchController.text.trim() == query) {
        setState(() {
          _searchResults = _sampleLocations
              .where((location) => 
                  location.toLowerCase().contains(query.toLowerCase()))
              .toList();
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _selectLocation(String location) async {
    try {
      await ref.read(locationProvider.notifier).setManualLocation(location);
      
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final hasPermission = await locationService.hasLocationPermission();
      
      if (!hasPermission) {
        final granted = await locationService.requestLocationPermission();
        if (granted == LocationPermissionResult.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission is required'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }
      
      await ref.read(locationProvider.notifier).getCurrentLocation();
      
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get current location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/location-permission');
        }
      },
      child: Scaffold(
      appBar:DefaultAppBar(
        title: 'Enter Your Location',
      
        onBackPressed: () {
          context.go('/location-permission');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
            ),
            
            const Gap(16),
            
            // Use Current Location
            InkWell(
              onTap: _useCurrentLocation,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const Gap(12),
                    Text(
                      'Use my current location',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_searchController.text.isNotEmpty) ...[
              const Gap(24),
              
              // Search Results Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SEARCH RESULT',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              const Gap(8),
              
              // Search Results
              Expanded(
                child: _isSearching
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'No locations found',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final location = _searchResults[index];
                              final parts = location.split(',');
                              final mainLocation = parts.isNotEmpty ? parts[0].trim() : location;
                              final address = parts.length > 1 
                                  ? parts.sublist(1).join(',').trim() 
                                  : '';
                              
                              return ListTile(
                                leading: Icon(
                                  Iconsax.location,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                title: Text(
                                  mainLocation,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: address.isNotEmpty
                                    ? Text(
                                        address,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      )
                                    : null,
                                onTap: () => _selectLocation(location),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                              );
                            },
                          ),
              ),
            ] else ...[
              // Empty state
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.search_normal_1,
                        size: 64,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const Gap(16),
                      Text(
                        'Start typing to search for locations',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }
} 