import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EventFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const EventFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<EventFilterBottomSheet> createState() => _EventFilterBottomSheetState();
}

class _EventFilterBottomSheetState extends State<EventFilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 200);
  String? _selectedDressCode;
  String? _selectedAgeRestriction;
  String? _selectedCrowdType;
  bool _verifiedVenuesOnly = false;
  bool _guestlistAvailable = false;

  final List<String> _dressCodes = [
    'Any',
    'Casual',
    'Smart Casual',
    'Formal',
    'Black Tie',
  ];

  final List<String> _ageRestrictions = [
    'Any',
    '18+',
    '19+',
    '21+',
  ];

  final List<String> _crowdTypes = [
    'Any',
    'Student',
    'Luxury',
    'Afrobeats',
    'EDM',
    'Hip-Hop',
    'Mixed',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range
                    _buildSectionTitle('Price Range', Iconsax.money),
                    const Gap(12),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 200,
                      divisions: 20,
                      labels: RangeLabels(
                        '\$${_priceRange.start.toInt()}',
                        '\$${_priceRange.end.toInt()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() => _priceRange = values);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_priceRange.start.toInt()}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${_priceRange.end.toInt()}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const Gap(24),

                    // Dress Code
                    _buildSectionTitle('Dress Code', Iconsax.tag),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dressCodes.map((code) {
                        final isSelected = code == _selectedDressCode;
                        return FilterChip(
                          label: Text(code),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDressCode = selected ? code : null;
                            });
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? primaryColor
                                : theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        );
                      }).toList(),
                    ),

                    const Gap(24),

                    // Age Restriction
                    _buildSectionTitle('Age Restriction', Iconsax.user),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _ageRestrictions.map((age) {
                        final isSelected = age == _selectedAgeRestriction;
                        return FilterChip(
                          label: Text(age),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedAgeRestriction = selected ? age : null;
                            });
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? primaryColor
                                : theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        );
                      }).toList(),
                    ),

                    const Gap(24),

                    // Crowd Type
                    _buildSectionTitle('Crowd Type', Iconsax.people),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _crowdTypes.map((type) {
                        final isSelected = type == _selectedCrowdType;
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCrowdType = selected ? type : null;
                            });
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? primaryColor
                                : theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        );
                      }).toList(),
                    ),

                    const Gap(24),

                    // Additional Filters
                    _buildSectionTitle('Additional', Iconsax.setting_2),
                    const Gap(12),
                    CheckboxListTile(
                      title: const Text('Verified Venues Only'),
                      subtitle: const Text('Only show events at verified venues'),
                      value: _verifiedVenuesOnly,
                      onChanged: (value) {
                        setState(() => _verifiedVenuesOnly = value ?? false);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: primaryColor,
                    ),
                    CheckboxListTile(
                      title: const Text('Free Guestlist Available'),
                      subtitle: const Text('Show events with free entry before certain time'),
                      value: _guestlistAvailable,
                      onChanged: (value) {
                        setState(() => _guestlistAvailable = value ?? false);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: primaryColor,
                    ),

                    const Gap(24),
                  ],
                ),
              ),
            ),

            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _applyFilters,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 18, color: primaryColor),
        const Gap(8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 200);
      _selectedDressCode = null;
      _selectedAgeRestriction = null;
      _selectedCrowdType = null;
      _verifiedVenuesOnly = false;
      _guestlistAvailable = false;
    });
  }

  void _applyFilters() {
    final filters = {
      'priceMin': _priceRange.start,
      'priceMax': _priceRange.end,
      'dressCode': _selectedDressCode,
      'ageRestriction': _selectedAgeRestriction,
      'crowdType': _selectedCrowdType,
      'verifiedOnly': _verifiedVenuesOnly,
      'guestlistAvailable': _guestlistAvailable,
    };

    widget.onApplyFilters(filters);
  }
}
