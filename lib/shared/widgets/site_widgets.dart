import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A list or page that could not be loaded: the sentence and a way to try again.
class LoadFailed extends StatelessWidget {
  const LoadFailed({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40),
            const SizedBox(height: 12),
            Text(message, key: const Key('load-failed-message'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            OutlinedButton(key: const Key('load-failed-retry'), onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

/// Nothing to show yet, said kindly.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(title, key: const Key('empty-title'), style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(text, key: const Key('empty-text'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// A picture from the internet with a quiet placeholder while it loads and when it cannot be shown.
class NetworkPicture extends StatelessWidget {
  const NetworkPicture({super.key, required this.url, this.height, this.width, this.radius = 12, this.fit = BoxFit.cover});

  final String? url;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  /// Tests put their own picture here: the real one keeps a cache on the phone's disk, which a test phone does not have.
  @visibleForTesting
  static Widget Function(String url, BoxFit fit, double? width, double? height)? imageOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(radius)),
      child: Icon(Icons.nightlife_outlined, color: theme.colorScheme.onSurfaceVariant),
    );
    final u = url;
    if (u == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageOverride?.call(u, fit, width, height) ?? CachedNetworkImage(imageUrl: u, height: height, width: width, fit: fit, placeholder: (_, __) => placeholder, errorWidget: (_, __, ___) => placeholder),
    );
  }
}
