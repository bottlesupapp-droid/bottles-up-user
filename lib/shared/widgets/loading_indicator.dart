import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 35,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: color ?? Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}

// Overlay loading indicator that shows on top of the screen with a semi-transparent background
class OverlayLoadingIndicator extends StatelessWidget {
  const OverlayLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: LoadingIndicator(
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
} 