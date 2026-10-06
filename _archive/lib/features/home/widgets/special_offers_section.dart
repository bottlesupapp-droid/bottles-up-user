import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOffersSection extends StatelessWidget {
  final CarouselSliderController carouselController;
  final int currentIndex;
  final Function(int) onPageChanged;

  const SpecialOffersSection({
    super.key,
    required this.carouselController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Special Offers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const Gap(16),

        // Offers Carousel
        SizedBox(
          height: 160,
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: 160,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: false,
              viewportFraction: 0.85,
              onPageChanged: (index, reason) => onPageChanged(index),
            ),
            items: [
              _buildOfferCard(context, 'Weekend Offers', 'Get Special Offer', 'Up to 30%'),
              _buildOfferCard(context, 'Happy Hour', 'Drink Special', 'Up to 50%'),
              _buildOfferCard(context, 'VIP Night', 'Premium Access', 'Up to 25%'),
            ],
          ),
        ),

        const Gap(12),

        // Carousel Indicators
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: 3,
            effect: WormEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(BuildContext context, String title, String subtitle, String discount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const Gap(8),
                Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 