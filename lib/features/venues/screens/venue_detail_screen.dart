import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/venue_provider.dart';

class VenueDetailScreen extends ConsumerWidget {
  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueAsync = ref.watch(venueDetailProvider(venueId));
    final ratingsAsync = ref.watch(venueRatingsProvider(venueId));

    return Scaffold(
      body: venueAsync.when(
        data: (venue) => CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  venue.name,
                  style: const TextStyle(
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
                background: venue.imageUrl != null
                    ? Image.network(venue.imageUrl!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[800]),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),

            // Venue Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating and Reviews
                    if (venue.averageRating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const Gap(8),
                          Text(
                            venue.averageRating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            ' (${venue.reviewCount} reviews)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    const Gap(16),

                    // Quick Info
                    _InfoRow(
                      icon: Icons.location_on,
                      text: '${venue.address}, ${venue.city}, ${venue.state}',
                    ),
                    const Gap(8),
                    _InfoRow(
                      icon: Icons.people,
                      text: 'Capacity: ${venue.capacity} guests',
                    ),
                    const Gap(8),
                    _InfoRow(
                      icon: Icons.attach_money,
                      text: '\$${venue.pricePerHour.toStringAsFixed(0)}/hour',
                    ),
                    const Gap(24),

                    // Description
                    if (venue.description != null) ...[
                      Text('About', style: Theme.of(context).textTheme.titleLarge),
                      const Gap(8),
                      Text(venue.description!),
                      const Gap(24),
                    ],

                    // Amenities
                    if (venue.amenities.isNotEmpty) ...[
                      Text('Amenities', style: Theme.of(context).textTheme.titleLarge),
                      const Gap(12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: venue.amenities.map((amenity) {
                          return Chip(label: Text(amenity));
                        }).toList(),
                      ),
                      const Gap(24),
                    ],

                    // Contact Info
                    Text('Contact', style: Theme.of(context).textTheme.titleLarge),
                    const Gap(12),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(venue.contactEmail),
                      onTap: () => _launchUrl('mailto:${venue.contactEmail}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(venue.contactPhone),
                      onTap: () => _launchUrl('tel:${venue.contactPhone}'),
                    ),
                    if (venue.website != null)
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Website'),
                        onTap: () => _launchUrl(venue.website!),
                      ),
                    const Gap(24),

                    // Reviews Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reviews', style: Theme.of(context).textTheme.titleLarge),
                        TextButton(
                          onPressed: () => _showRatingDialog(context, ref),
                          child: const Text('Write Review'),
                        ),
                      ],
                    ),
                    const Gap(12),
                  ],
                ),
              ),
            ),

            // Reviews List
            ratingsAsync.when(
              data: (ratings) {
                if (ratings.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('No reviews yet')),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final rating = ratings[index];
                      return _ReviewCard(rating: rating);
                    },
                    childCount: ratings.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to inquiry screen
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Send Inquiry'),
                  content: const Text('Inquiry form coming soon!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Send Inquiry'),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showRatingDialog(BuildContext context, WidgetRef ref) {
    double rating = 5.0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Write a Review'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Rating'),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 8,
                  label: rating.toStringAsFixed(1),
                  onChanged: (value) => setState(() => rating = value),
                ),
                Text('${rating.toStringAsFixed(1)} stars'),
                const Gap(16),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Your Review',
                    hintText: 'Share your experience...',
                  ),
                  maxLines: 4,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (reviewController.text.isNotEmpty) {
                    await ref.read(venueRatingsProvider(venueId).notifier).submitRating(
                          venueId: venueId,
                          rating: rating,
                          review: reviewController.text,
                        );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const Gap(8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final dynamic rating;

  const _ReviewCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (rating.userAvatar != null)
                  CircleAvatar(backgroundImage: NetworkImage(rating.userAvatar!))
                else
                  const CircleAvatar(child: Icon(Icons.person)),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.userName ?? 'Anonymous',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.rating ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(12),
            Text(rating.review),
          ],
        ),
      ),
    );
  }
}
