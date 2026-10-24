import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../providers/venue_provider.dart';

class VenueDiscoveryScreen extends ConsumerStatefulWidget {
  const VenueDiscoveryScreen({super.key});

  @override
  ConsumerState<VenueDiscoveryScreen> createState() => _VenueDiscoveryScreenState();
}

class _VenueDiscoveryScreenState extends ConsumerState<VenueDiscoveryScreen> {
  String? selectedCity;
  int? minCapacity;
  double? maxPrice;
  List<String> selectedAmenities = [];

  @override
  Widget build(BuildContext context) {
    final venuesAsync = ref.watch(venueListProvider(
      city: selectedCity,
      minCapacity: minCapacity,
      maxPrice: maxPrice,
      amenities: selectedAmenities.isEmpty ? null : selectedAmenities,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: venuesAsync.when(
        data: (venues) {
          if (venues.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place_outlined, size: 64, color: Colors.grey[400]),
                  const Gap(16),
                  Text(
                    'No venues found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(8),
                  const Text('Try adjusting your filters'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(venueListProvider(
                city: selectedCity,
                minCapacity: minCapacity,
                maxPrice: maxPrice,
                amenities: selectedAmenities.isEmpty ? null : selectedAmenities,
              ).future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return _VenueCard(venue: venue);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(24),

                    // City Filter
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      decoration: const InputDecoration(labelText: 'City'),
                      items: ['New York', 'Los Angeles', 'Chicago', 'Miami']
                          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedCity = value),
                    ),
                    const Gap(16),

                    // Capacity Filter
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Minimum Capacity',
                        hintText: 'e.g., 100',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => minCapacity = int.tryParse(value));
                      },
                    ),
                    const Gap(16),

                    // Price Filter
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Maximum Price (per hour)',
                        hintText: 'e.g., 500',
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => maxPrice = double.tryParse(value));
                      },
                    ),
                    const Gap(16),

                    // Amenities Filter
                    const Text('Amenities'),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      children: ['WiFi', 'Parking', 'Catering', 'AV Equipment', 'Bar']
                          .map((amenity) {
                        final isSelected = selectedAmenities.contains(amenity);
                        return FilterChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedAmenities.add(amenity);
                              } else {
                                selectedAmenities.remove(amenity);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const Gap(24),

                    // Apply Button
                    ElevatedButton(
                      onPressed: () {
                        this.setState(() {}); // Trigger rebuild of parent
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                    const Gap(8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCity = null;
                          minCapacity = null;
                          maxPrice = null;
                          selectedAmenities.clear();
                        });
                        this.setState(() {}); // Trigger rebuild of parent
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final dynamic venue;

  const _VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/venues/${venue.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Image
            if (venue.imageUrl != null)
              Image.network(
                venue.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.place, size: 64),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (venue.averageRating > 0) ...[
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const Gap(4),
                        Text(
                          venue.averageRating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ],
                  ),
                  const Gap(8),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          '${venue.city}, ${venue.state}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),

                  // Capacity and Price
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const Gap(4),
                      Text('Up to ${venue.capacity} guests'),
                      const Spacer(),
                      Text(
                        '\$${venue.pricePerHour.toStringAsFixed(0)}/hr',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Amenities
                  if (venue.amenities.isNotEmpty) ...[
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: venue.amenities.take(3).map<Widget>((amenity) {
                        return Chip(
                          label: Text(amenity, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
