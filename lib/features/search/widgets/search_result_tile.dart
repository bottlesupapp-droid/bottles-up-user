import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../models/search_result.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
  });

  IconData _getIconForType(SearchResultType type) {
    switch (type) {
      case SearchResultType.bottle:
        return Iconsax.cup;
      case SearchResultType.event:
        return Iconsax.calendar;
      case SearchResultType.user:
        return Iconsax.profile_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: result.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(result.imageUrl!),
              radius: 24,
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                _getIconForType(result.type),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
      title: Text(
        result.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        result.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
} 