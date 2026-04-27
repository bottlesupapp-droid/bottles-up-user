import 'package:flutter/material.dart';
import '../models/search_filter.dart';

class SearchFilterSheet extends StatefulWidget {
  final SearchFilter? currentFilter;
  final Function(SearchFilter) onApply;

  const SearchFilterSheet({
    super.key,
    this.currentFilter,
    required this.onApply,
  });

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late List<String> _selectedCategories;
  late RangeValues _priceRange;
  late double _maxDistance;
  late List<String> _selectedNeighborhoods;
  late List<String> _selectedAmenities;
  late bool _hasAvailability;
  late bool _bottleService;
  late bool _verifiedOnly;
  late String _sortBy;

  DateTimeRange? _dateRange;

  final List<String> _allCategories = [
    'Nightclub',
    'Lounge',
    'Rooftop',
    'Pool Party',
    'Day Club',
    'Concert',
    'Festival',
    'Private Event',
  ];

  final List<String> _allNeighborhoods = [
    'Downtown',
    'Hollywood',
    'West Hollywood',
    'Beverly Hills',
    'Santa Monica',
    'Venice Beach',
  ];

  final List<String> _allAmenities = [
    'Bottle Service',
    'VIP Tables',
    'Outdoor Area',
    'Rooftop',
    'Dance Floor',
    'Live DJ',
    'Food Service',
    'Parking',
  ];

  final List<String> _sortOptions = [
    'relevance',
    'price_low',
    'price_high',
    'rating',
    'distance',
    'date',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.currentFilter?.categories ?? [];
    _priceRange = RangeValues(
      widget.currentFilter?.priceRange?.min ?? 0,
      widget.currentFilter?.priceRange?.max ?? 1000,
    );
    _maxDistance = widget.currentFilter?.maxDistance ?? 50;
    _selectedNeighborhoods = widget.currentFilter?.neighborhoods ?? [];
    _selectedAmenities = widget.currentFilter?.amenities ?? [];
    _hasAvailability = widget.currentFilter?.hasAvailability ?? false;
    _bottleService = widget.currentFilter?.mustHaveBottleService ?? false;
    _verifiedOnly = widget.currentFilter?.verifiedVenuesOnly ?? false;
    _sortBy = widget.currentFilter?.sortBy ?? 'relevance';
  }

  void _applyFilters() {
    final filter = SearchFilter(
      categories: _selectedCategories.isEmpty ? null : _selectedCategories,
      dateRange: _dateRange,
      priceRange: PriceRange(min: _priceRange.start, max: _priceRange.end),
      maxDistance: _maxDistance,
      neighborhoods: _selectedNeighborhoods.isEmpty ? null : _selectedNeighborhoods,
      amenities: _selectedAmenities.isEmpty ? null : _selectedAmenities,
      hasAvailability: _hasAvailability,
      mustHaveBottleService: _bottleService,
      verifiedVenuesOnly: _verifiedOnly,
      sortBy: _sortBy,
    );

    widget.onApply(filter);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories = [];
      _priceRange = const RangeValues(0, 1000);
      _maxDistance = 50;
      _selectedNeighborhoods = [];
      _selectedAmenities = [];
      _hasAvailability = false;
      _bottleService = false;
      _verifiedOnly = false;
      _sortBy = 'relevance';
      _dateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text('Reset'),
                    ),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilledButton(
                      onPressed: _applyFilters,
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Categories
                    _buildSection(
                      'Categories',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allCategories.map((category) {
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
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price Range
                    _buildSection(
                      'Price Range',
                      Column(
                        children: [
                          RangeSlider(
                            values: _priceRange,
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            labels: RangeLabels(
                              '\$${_priceRange.start.round()}',
                              '\$${_priceRange.end.round()}',
                            ),
                            onChanged: (values) {
                              setState(() => _priceRange = values);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$${_priceRange.start.round()}'),
                              Text('\$${_priceRange.end.round()}+'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Distance
                    _buildSection(
                      'Maximum Distance',
                      Column(
                        children: [
                          Slider(
                            value: _maxDistance,
                            min: 1,
                            max: 100,
                            divisions: 20,
                            label: '${_maxDistance.round()} km',
                            onChanged: (value) {
                              setState(() => _maxDistance = value);
                            },
                          ),
                          Text('${_maxDistance.round()} km'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Neighborhoods
                    _buildSection(
                      'Neighborhoods',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allNeighborhoods.map((neighborhood) {
                          final isSelected = _selectedNeighborhoods.contains(neighborhood);
                          return FilterChip(
                            label: Text(neighborhood),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedNeighborhoods.add(neighborhood);
                                } else {
                                  _selectedNeighborhoods.remove(neighborhood);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Amenities
                    _buildSection(
                      'Amenities',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allAmenities.map((amenity) {
                          final isSelected = _selectedAmenities.contains(amenity);
                          return FilterChip(
                            label: Text(amenity),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAmenities.add(amenity);
                                } else {
                                  _selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle options
                    _buildSection(
                      'Options',
                      Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Has Availability'),
                            value: _hasAvailability,
                            onChanged: (value) {
                              setState(() => _hasAvailability = value);
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Bottle Service Required'),
                            value: _bottleService,
                            onChanged: (value) {
                              setState(() => _bottleService = value);
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Verified Venues Only'),
                            value: _verifiedOnly,
                            onChanged: (value) {
                              setState(() => _verifiedOnly = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sort by
                    _buildSection(
                      'Sort By',
                      DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                          const DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                          const DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                          const DropdownMenuItem(value: 'rating', child: Text('Rating')),
                          const DropdownMenuItem(value: 'distance', child: Text('Distance')),
                          const DropdownMenuItem(value: 'date', child: Text('Date')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
