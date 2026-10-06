import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/venue_provider.dart';

class VenueComparisonScreen extends ConsumerStatefulWidget {
  final List<String> venueIds;

  const VenueComparisonScreen({super.key, required this.venueIds});

  @override
  ConsumerState<VenueComparisonScreen> createState() => _VenueComparisonScreenState();
}

class _VenueComparisonScreenState extends ConsumerState<VenueComparisonScreen> {
  @override
  Widget build(BuildContext context) {
    final comparisonAsync = ref.watch(venueComparisonDetailProvider(widget.venueIds));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveComparison(context),
          ),
        ],
      ),
      body: comparisonAsync.when(
        data: (comparison) {
          final venues = comparison['venues'] as List;
          final priceComp = comparison['price_comparison'] as Map<String, dynamic>;
          final capacityComp = comparison['capacity_comparison'] as Map<String, dynamic>;
          final ratingComp = comparison['rating_comparison'] as Map<String, dynamic>;
          final amenitiesComp = comparison['amenities_comparison'] as Map<String, List<String>>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venues Header
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(16),
                    itemCount: venues.length,
                    itemBuilder: (context, index) {
                      final venue = venues[index];
                      return _VenueHeaderCard(venue: venue);
                    },
                  ),
                ),

                // Price Comparison
                _ComparisonSection(
                  title: 'Price Comparison',
                  icon: Icons.attach_money,
                  children: [
                    _MetricRow('Lowest', '\$${priceComp['lowest'].toStringAsFixed(0)}/hr'),
                    _MetricRow('Highest', '\$${priceComp['highest'].toStringAsFixed(0)}/hr'),
                    _MetricRow('Average', '\$${priceComp['average'].toStringAsFixed(0)}/hr'),
                  ],
                ),

                // Capacity Comparison
                _ComparisonSection(
                  title: 'Capacity Comparison',
                  icon: Icons.people,
                  children: [
                    _MetricRow('Smallest', '${capacityComp['smallest']} guests'),
                    _MetricRow('Largest', '${capacityComp['largest']} guests'),
                    _MetricRow('Average', '${capacityComp['average'].toStringAsFixed(0)} guests'),
                  ],
                ),

                // Rating Comparison
                _ComparisonSection(
                  title: 'Rating Comparison',
                  icon: Icons.star,
                  children: [
                    _MetricRow('Lowest', '${ratingComp['lowest'].toStringAsFixed(1)} ⭐'),
                    _MetricRow('Highest', '${ratingComp['highest'].toStringAsFixed(1)} ⭐'),
                    _MetricRow('Average', '${ratingComp['average'].toStringAsFixed(1)} ⭐'),
                  ],
                ),

                // Amenities Comparison
                _ComparisonSection(
                  title: 'Amenities Comparison',
                  icon: Icons.check_circle,
                  children: amenitiesComp.entries.map((entry) {
                    final amenity = entry.key;
                    final venuesWithAmenity = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(amenity, style: const TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Wrap(
                              spacing: 4,
                              children: List.generate(venues.length, (index) {
                                final venue = venues[index];
                                final hasAmenity = venuesWithAmenity.contains(venue.id);
                                return Icon(
                                  hasAmenity ? Icons.check_circle : Icons.cancel,
                                  size: 20,
                                  color: hasAmenity ? Colors.green : Colors.grey,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const Gap(80), // Space for FAB
              ],
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

  void _saveComparison(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Comparison'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Comparison Name',
            hintText: 'e.g., Birthday Venue Options',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await ref.read(venueComparisonsProvider.notifier).createComparison(
                      venueIds: widget.venueIds,
                      name: nameController.text,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comparison saved!')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _VenueHeaderCard extends StatelessWidget {
  final dynamic venue;

  const _VenueHeaderCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (venue.imageUrl != null)
              Image.network(
                venue.imageUrl!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.place),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const Gap(4),
                      Text(
                        venue.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
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
}

class _ComparisonSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ComparisonSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const Gap(8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Gap(12),
          ...children,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
