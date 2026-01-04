import 'package:flutter/material.dart';

class EventCategoryChips extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;

  const EventCategoryChips({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genre == selectedGenre;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onGenreSelected(genre);
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: primaryColor.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? primaryColor
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
