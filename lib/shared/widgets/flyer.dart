import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'site_widgets.dart';

// An event's flyer is a poster: names, dates, prices and logos are printed on it, usually on a tall sheet. Drawing it as a wide band cropped to fit (BoxFit.cover) cuts exactly those off.
// These widgets never crop a flyer. The event page shows it whole, in its own proportions, and a tap opens it full screen to read and zoom; a list card shows the whole flyer too,
// on a blurred copy of itself so the bars either side do not look empty.

/// The flyer on the event page: the whole picture at the page's width, in its own proportions (a very tall flyer is held to [maxHeightFraction] of the screen and shown whole inside
/// that, with bars either side, instead of pushing the rest of the page off the screen). Tap it to see it full screen.
class FlyerImage extends StatelessWidget {
  const FlyerImage({super.key, required this.url, this.maxHeightFraction = 0.6});

  final String? url;

  /// The most of the screen's height the flyer may take on the page.
  final double maxHeightFraction;

  /// What a flyer that is still loading holds the room open with, so the page does not jump when it arrives. A flyer is usually tall, so the room is too.
  static const double loadingHeight = 280;

  /// What an event with no flyer shows (a quiet band, as before).
  static const double emptyHeight = 220;

  @override
  Widget build(BuildContext context) {
    final u = url;
    if (u == null) return const NetworkPicture(url: null, height: emptyHeight, width: double.infinity, radius: 0);
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFraction;
    return Semantics(
      button: true,
      label: 'Event flyer. Double tap to view it full screen.',
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        child: InkWell(
          key: const Key('flyer'),
          onTap: () => showFlyer(context, u),
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Center(
                  heightFactor: 1,
                  child: NetworkPicture(url: u, width: double.infinity, radius: 0, fit: BoxFit.contain, placeholderHeight: loadingHeight),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: IgnorePointer(
                  child: Container(
                    key: const Key('flyer-hint'),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.zoom_out_map, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The flyer on a list card: the whole picture inside a band [height] tall, over a blurred, darkened copy of itself. Never cropped.
class FlyerThumb extends StatelessWidget {
  const FlyerThumb({super.key, required this.url, this.height = 190});

  final String? url;
  final double height;

  @override
  Widget build(BuildContext context) {
    final u = url;
    if (u == null) return NetworkPicture(url: null, height: height, width: double.infinity, radius: 0);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: NetworkPicture(url: u, width: double.infinity, height: height, radius: 0, fit: BoxFit.cover),
          ),
          const ColoredBox(color: Colors.black45),
          NetworkPicture(key: const Key('flyer-thumb-whole'), url: u, width: double.infinity, height: height, radius: 0, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

/// Opens the flyer full screen.
Future<void> showFlyer(BuildContext context, String url) => Navigator.of(context).push<void>(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => FlyerViewerScreen(url: url)));

/// The flyer on a black screen, as large as it will go without being cropped; pinch to zoom in and drag to look around. The cross (or the back gesture) closes it.
class FlyerViewerScreen extends StatelessWidget {
  const FlyerViewerScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('flyer-viewer'),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(key: const Key('flyer-close'), icon: const Icon(Icons.close), tooltip: 'Close', onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: SafeArea(
        child: Semantics(
          label: 'Event flyer. Pinch to zoom.',
          child: InteractiveViewer(
            key: const Key('flyer-zoom'),
            minScale: 1,
            maxScale: 5,
            child: SizedBox.expand(child: NetworkPicture(url: url, width: double.infinity, height: double.infinity, radius: 0, fit: BoxFit.contain)),
          ),
        ),
      ),
    );
  }
}
