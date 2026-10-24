import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:ui';
import '../models/category.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
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
                'Categories',
                style: Theme.of(context).textTheme.headlineMedium,
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

        // Categories Pills
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category.name == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.9)
                          : Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3)
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
                          category.name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
