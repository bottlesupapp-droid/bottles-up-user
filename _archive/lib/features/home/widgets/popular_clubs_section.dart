import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';
import '../models/club.dart';
import 'club_list_item.dart';

class PopularClubsSection extends StatelessWidget {
  final List<Club> clubs;

  const PopularClubsSection({
    super.key,
    required this.clubs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Clubs',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Gap(20),

        // Filter Pills
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildFilterPill(context, 'Categories', true),
              _buildFilterPill(context, 'Nearest', false),
              _buildFilterPill(context, 'Great Offers', false),
              _buildFilterPill(context, 'Ratings 4.5+', false),
            ],
          ),
        ),

        const Gap(24),

        // Clubs List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(
              clubs.length,
              (index) => ClubListItem(club: clubs[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(BuildContext context, String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                : Colors.white.withOpacity(0.2),
            isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                : Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border(
          left: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
          top: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
} 