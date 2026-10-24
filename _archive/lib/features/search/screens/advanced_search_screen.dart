import 'package:flutter/material.dart';
import '../models/search_filter.dart';

class AdvancedSearchScreen extends StatefulWidget {
  final SearchFilter? initialFilter;

  const AdvancedSearchScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  late SearchFilter _filter;

  final List<String> _selectedCategories = [];
  final List<String> _selectedAmenities = [];
  double _minPrice = 0;
  double _maxPrice = 500;
  double _minRating = 0;
  int _maxDistance = 50;
  bool _openNow = false;
  bool _hasTableService = false;
  bool _hasBottleService = false;
  SortBy _sortBy = SortBy.relevance;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? const SearchFilter();
    _initializeFromFilter();
  }

  void _initializeFromFilter() {
    if (_filter.categories != null) {
      _selectedCategories.addAll(_filter.categories!);
    }
    if (_filter.amenities != null) {
      _selectedAmenities.addAll(_filter.amenities!);
    }
    _minPrice = _filter.minPrice ?? 0;
    _maxPrice = _filter.maxPrice ?? 500;
    _minRating = _filter.minRating ?? 0;
    _maxDistance = _filter.maxDistance ?? 50;
    _openNow = _filter.openNow ?? false;
    _hasTableService = _filter.hasTableService ?? false;
    _hasBottleService = _filter.hasBottleService ?? false;
    _sortBy = _filter.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoriesSection(),
          const SizedBox(height: 24),
          _buildPriceRangeSection(),
          const SizedBox(height: 24),
          _buildRatingSection(),
          const SizedBox(height: 24),
          _buildDistanceSection(),
          const SizedBox(height: 24),
          _buildAmenitiesSection(),
          const SizedBox(height: 24),
          _buildServicesSection(),
          const SizedBox(height: 24),
          _buildSortBySection(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Filters'),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      'Nightclub',
      'Lounge',
      'Bar',
      'Rooftop',
      'Restaurant',
      'Live Music',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
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
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_minPrice.toInt()}',
            '\$${_maxPrice.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0', style: TextStyle(color: Colors.grey[600])),
              Text('\$1000+', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Minimum Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  _minRating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: _minRating,
          min: 0,
          max: 5,
          divisions: 10,
          label: _minRating.toStringAsFixed(1),
          onChanged: (value) {
            setState(() => _minRating = value);
          },
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Max Distance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_maxDistance km',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: _maxDistance.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          label: '$_maxDistance km',
          onChanged: (value) {
            setState(() => _maxDistance = value.toInt());
          },
        ),
        SwitchListTile(
          title: const Text('Open Now'),
          subtitle: const Text('Show only venues currently open'),
          value: _openNow,
          onChanged: (value) {
            setState(() => _openNow = value);
          },
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    final amenities = [
      {'name': 'VIP Section', 'icon': Icons.stars},
      {'name': 'Outdoor Seating', 'icon': Icons.deck},
      {'name': 'Parking', 'icon': Icons.local_parking},
      {'name': 'Live Music', 'icon': Icons.music_note},
      {'name': 'Dance Floor', 'icon': Icons.nightlife},
      {'name': 'Food Available', 'icon': Icons.restaurant},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            final name = amenity['name'] as String;
            final icon = amenity['icon'] as IconData;
            final isSelected = _selectedAmenities.contains(name);

            return FilterChip(
              avatar: Icon(icon, size: 18),
              label: Text(name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(name);
                  } else {
                    _selectedAmenities.remove(name);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Table Service'),
          subtitle: const Text('Reserved table with dedicated service'),
          value: _hasTableService,
          onChanged: (value) {
            setState(() => _hasTableService = value ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text('Bottle Service'),
          subtitle: const Text('Premium bottle service available'),
          value: _hasBottleService,
          onChanged: (value) {
            setState(() => _hasBottleService = value ?? false);
          },
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...SortBy.values.map((sortBy) {
          return RadioListTile<SortBy>(
            title: Text(_getSortByLabel(sortBy)),
            value: sortBy,
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() => _sortBy = value!);
            },
          );
        }),
      ],
    );
  }

  String _getSortByLabel(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.relevance:
        return 'Relevance';
      case SortBy.priceHighToLow:
        return 'Price: High to Low';
      case SortBy.priceLowToHigh:
        return 'Price: Low to High';
      case SortBy.rating:
        return 'Highest Rated';
      case SortBy.distance:
        return 'Nearest First';
      case SortBy.popularity:
        return 'Most Popular';
      case SortBy.newest:
        return 'Newest';
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedAmenities.clear();
      _minPrice = 0;
      _maxPrice = 500;
      _minRating = 0;
      _maxDistance = 50;
      _openNow = false;
      _hasTableService = false;
      _hasBottleService = false;
      _sortBy = SortBy.relevance;
    });
  }

  void _applyFilters() {
    final filter = SearchFilter(
      categories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
      amenities: _selectedAmenities.isNotEmpty ? _selectedAmenities : null,
      minPrice: _minPrice > 0 ? _minPrice : null,
      maxPrice: _maxPrice < 1000 ? _maxPrice : null,
      minRating: _minRating > 0 ? _minRating : null,
      maxDistance: _maxDistance,
      openNow: _openNow ? true : null,
      hasTableService: _hasTableService ? true : null,
      hasBottleService: _hasBottleService ? true : null,
      sortBy: _sortBy,
    );

    Navigator.pop(context, filter);
  }
}
