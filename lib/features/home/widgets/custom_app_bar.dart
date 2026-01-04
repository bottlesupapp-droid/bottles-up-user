import 'package:bottles_up_user/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final double scrollOffset;
  final String currentLocation;
  final bool isLoadingLocation;
  final VoidCallback? onLocationTap;

  const CustomAppBar({
    super.key,
    required this.searchController,
    required this.scrollOffset,
    required this.currentLocation,
    required this.isLoadingLocation,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const locationSectionHeight = 85.0;
    const searchSectionHeight = 65.0;

    // Calculate scroll ratios for smooth animations
    final locationScrollRatio =
        (scrollOffset / locationSectionHeight).clamp(0.0, 1.0);
    final appBarOpacity = (scrollOffset / 50).clamp(0.0, 1.0);

    return Container(
      // Height shrinks as user scrolls, causing search bar to "stick" at top
      height: statusBarHeight +
          locationSectionHeight +
          searchSectionHeight -
          (locationSectionHeight * locationScrollRatio),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: appBarOpacity > 0.3
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Location Section (slides up and fades out)
          Positioned(
            top: statusBarHeight - (locationSectionHeight * locationScrollRatio),
            left: 0,
            right: 0,
            height: locationSectionHeight,
            child: Opacity(
              opacity: 1 - locationScrollRatio,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(8),

                    // Top Bar with Location and Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    // Location with Dropdown
                    GestureDetector(
                      onTap: onLocationTap,
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.location,
                            color: Colors.white,
                            size: 20,
                          ),
                          const Gap(4),
                          Expanded(
                            child: isLoadingLocation
                                ? Row(
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: LoadingIndicator()
                                      ),
                                      const Gap(8),
                                      Text(
                                        'Getting location...',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    currentLocation,
                                    style: Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          const Gap(4),
                          const Icon(
                            Iconsax.arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Section (stays at the bottom of the shrinking container)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: searchSectionHeight,
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(36),
                     
                      ),
                      child: TextField(
                        controller: searchController,
                        
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),

                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Iconsax.search_normal_1,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 18,
                          ),
                          border: InputBorder.none
                          ,
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  //Filter button
                  const Gap(16),
                  
                  // Filter Button with Glassmorphic Design
                  GestureDetector(
                    onTap: () => _showFilterBottomSheet(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _priceRange = 50;
  String _selectedDistance = '5 km';
  String _selectedRating = '4.0+';
  final List<String> _selectedCategories = [];

  final List<String> _distances = ['1 km', '5 km', '10 km', '25 km', '50 km'];
  final List<String> _ratings = ['3.0+', '3.5+', '4.0+', '4.5+', '5.0'];
  final List<String> _categories = ['Nightclub', 'Bar', 'Lounge', 'Rooftop', 'Restaurant'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Options',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () => _resetFilters(),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildFilterSection(
                    'Price Range',
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Theme.of(context).colorScheme.primary,
                            inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                            thumbColor: Theme.of(context).colorScheme.primary,
                            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            valueIndicatorColor: Theme.of(context).colorScheme.primary,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Slider(
                            value: _priceRange,
                            min: 0,
                            max: 200,
                            divisions: 20,
                            label: '\$${_priceRange.round()}',
                            onChanged: (value) {
                              setState(() {
                                _priceRange = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$0', 
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              '\$200+', 
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Distance
                  _buildFilterSection(
                    'Distance',
                    Wrap(
                      spacing: 8,
                      children: _distances.map((distance) {
                        final isSelected = _selectedDistance == distance;
                        return FilterChip(
                          label: Text(distance),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDistance = distance;
                            });
                          },
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected 
                              ? Colors.white 
                              : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected 
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(24),

                  // Rating
                  _buildFilterSection(
                    'Minimum Rating',
                    Wrap(
                      spacing: 8,
                      children: _ratings.map((rating) {
                        final isSelected = _selectedRating == rating;
                        return FilterChip(
                          label: Text(rating),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRating = rating;
                            });
                          },
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected 
                              ? Colors.white 
                              : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected 
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(24),

                  // Categories
                  _buildFilterSection(
                    'Categories',
                    Wrap(
                      spacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                            });
                          },
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected 
                              ? Colors.white 
                              : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected 
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(100), // Bottom padding
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _applyFilters(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Gap(12),
        content,
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = 50;
      _selectedDistance = '5 km';
      _selectedRating = '4.0+';
      _selectedCategories.clear();
    });
  }

  void _applyFilters() {
    // Apply filters logic here
    Navigator.pop(context);
    
    // You can pass the filter data back to the parent widget
    // or use a state management solution like Riverpod
  }
} 