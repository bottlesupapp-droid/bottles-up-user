import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomAppBar2 extends StatelessWidget {
  final ScrollController scrollController;
  final double scrollOffset;
  final VoidCallback onNotificationTap;
  const CustomAppBar2({
    super.key,
    required this.scrollController,
    required this.scrollOffset,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on scroll offset
    final opacity = (scrollOffset / 350).clamp(0.0, 1.0);

    return Container(
      height: kToolbarHeight + 10 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: opacity * 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - App Logo
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/app_logo.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bottles Up',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),

          // Right side - Action buttons
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(
                      Iconsax.notification,
                      color: Colors.white,
                    ),
                  ),
                  // Notification badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
