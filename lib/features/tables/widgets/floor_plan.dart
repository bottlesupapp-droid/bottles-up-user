import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../site/models/venue.dart';
import '../../../site/rules/table_rules.dart';

/// A floor's plan picture with a spot on it for every table that has one. A spot is green when the table can be booked, grey when it is taken (or no date and time are chosen yet).
/// The spots are placed as percentages of the picture, so they are shown only once the picture has loaded.
class FloorPlan extends StatelessWidget {
  const FloorPlan({super.key, required this.floor, required this.tables, required this.unavailable, required this.canPick, required this.onPick, this.picture});

  final Floor floor;

  /// The tables with a spot on this floor.
  final List<TableType> tables;
  final Set<String> unavailable;

  /// False until a date and time are chosen.
  final bool canPick;
  final void Function(TableType table) onPick;

  /// Stands in for the picture from the internet (tests give a plain box). It counts as loaded.
  final Widget? picture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget overlay() => Positioned.fill(
          child: LayoutBuilder(
            builder: (context, box) {
              final size = Size(box.maxWidth, box.maxHeight);
              return Stack(
                children: [
                  for (final t in tables)
                    Positioned.fromRect(
                      rect: hotspotRect(t, size),
                      child: _Spot(
                        key: Key('spot-${t.id}'),
                        table: t,
                        taken: canPick && unavailable.contains(t.id),
                        enabled: canPick && !unavailable.contains(t.id),
                        onTap: () => onPick(t),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              );
            },
          ),
        );
    final Widget plan = picture != null
        ? Stack(children: [picture!, overlay()])
        : Image(
            image: CachedNetworkImageProvider(floor.imageUrl),
            width: double.infinity,
            fit: BoxFit.fitWidth,
            // The spots are percentages of the picture, so they appear only once it is there.
            frameBuilder: (context, child, frame, sync) => frame == null ? const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())) : Stack(children: [child, overlay()]),
            errorBuilder: (context, error, stack) => const SizedBox(height: 120, child: Center(child: Text('The floor plan could not be loaded.', key: Key('floor-plan-failed')))),
          );
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: plan);
  }
}

class _Spot extends StatelessWidget {
  const _Spot({super.key, required this.table, required this.taken, required this.enabled, required this.onTap, required this.color});

  final TableType table;
  final bool taken;
  final bool enabled;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final border = taken ? Colors.grey.shade600 : (enabled ? color : Colors.grey.shade400);
    return Tooltip(
      message: '${table.name} · up to ${table.maxGuests} guests · ${tablePriceLabel(table)}',
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: taken ? Colors.grey.shade800.withValues(alpha: 0.7) : (enabled ? color.withValues(alpha: 0.28) : Colors.grey.shade700.withValues(alpha: 0.4)),
            border: Border.all(color: border, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(table.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}
