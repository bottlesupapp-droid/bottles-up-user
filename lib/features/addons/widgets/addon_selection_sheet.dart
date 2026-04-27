import 'package:flutter/material.dart';
import '../models/addon.dart';
import '../services/addon_service.dart';

class AddonSelectionSheet extends StatefulWidget {
  final String bookingId;
  final Function(List<BookingAddon>) onAddonsSelected;

  const AddonSelectionSheet({
    super.key,
    required this.bookingId,
    required this.onAddonsSelected,
  });

  @override
  State<AddonSelectionSheet> createState() => _AddonSelectionSheetState();
}

class _AddonSelectionSheetState extends State<AddonSelectionSheet> {
  final _addonService = AddonService();

  List<Addon> _addons = [];
  Map<String, int> _selectedQuantities = {};
  bool _isLoading = true;
  AddonCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadAddons();
  }

  Future<void> _loadAddons() async {
    setState(() => _isLoading = true);
    try {
      final addons = await _addonService.getAvailableAddons();
      setState(() {
        _addons = addons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Addon> get _filteredAddons {
    if (_selectedCategory == null) return _addons;
    return _addons.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Category filters
          _buildCategoryFilters(),

          // Addons list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildAddonsList(),
          ),

          // Add button
          if (_selectedQuantities.isNotEmpty) _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Add Extras',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(null, 'All'),
          ...AddonCategory.values.map((category) {
            return _buildCategoryChip(category, _getCategoryName(category));
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(AddonCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedCategory = selected ? category : null);
        },
      ),
    );
  }

  Widget _buildAddonsList() {
    if (_filteredAddons.isEmpty) {
      return const Center(
        child: Text('No add-ons available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAddons.length,
      itemBuilder: (context, index) {
        final addon = _filteredAddons[index];
        return _buildAddonCard(addon);
      },
    );
  }

  Widget _buildAddonCard(Addon addon) {
    final quantity = _selectedQuantities[addon.id] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (addon.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  addon.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(_getCategoryIcon(addon.category)),
                    );
                  },
                ),
              ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addon.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    addon.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (addon.includedItems != null &&
                      addon.includedItems!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: addon.includedItems!.take(3).map((item) {
                        return Chip(
                          label: Text(
                            item,
                            style: const TextStyle(fontSize: 10),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${addon.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (quantity == 0)
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedQuantities[addon.id] = 1;
                            });
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    _selectedQuantities[addon.id] = quantity - 1;
                                  } else {
                                    _selectedQuantities.remove(addon.id);
                                  }
                                });
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  _selectedQuantities[addon.id] = quantity + 1;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    final total = _addons
        .where((addon) => _selectedQuantities.containsKey(addon.id))
        .fold<double>(
          0.0,
          (sum, addon) => sum + (addon.price * (_selectedQuantities[addon.id] ?? 0)),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: FilledButton(
        onPressed: _addSelectedAddons,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 0),
        ),
        child: Text(
          'Add ${_selectedQuantities.length} items - \$${total.toStringAsFixed(0)}',
        ),
      ),
    );
  }

  Future<void> _addSelectedAddons() async {
    try {
      final bookingAddons = <BookingAddon>[];

      for (final entry in _selectedQuantities.entries) {
        final addonId = entry.key;
        final quantity = entry.value;

        final bookingAddon = await _addonService.addAddonToBooking(
          bookingId: widget.bookingId,
          addonId: addonId,
          quantity: quantity,
        );

        bookingAddons.add(bookingAddon);
      }

      widget.onAddonsSelected(bookingAddons);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _getCategoryName(AddonCategory category) {
    switch (category) {
      case AddonCategory.hookah:
        return 'Hookah';
      case AddonCategory.decoration:
        return 'Decoration';
      case AddonCategory.sparklers:
        return 'Sparklers';
      case AddonCategory.photography:
        return 'Photography';
      case AddonCategory.entertainment:
        return 'Entertainment';
      case AddonCategory.food:
        return 'Food';
      case AddonCategory.other:
        return 'Other';
    }
  }

  IconData _getCategoryIcon(AddonCategory category) {
    switch (category) {
      case AddonCategory.hookah:
        return Icons.smoke_free;
      case AddonCategory.decoration:
        return Icons.celebration;
      case AddonCategory.sparklers:
        return Icons.auto_awesome;
      case AddonCategory.photography:
        return Icons.camera_alt;
      case AddonCategory.entertainment:
        return Icons.music_note;
      case AddonCategory.food:
        return Icons.restaurant;
      case AddonCategory.other:
        return Icons.add_circle;
    }
  }
}
