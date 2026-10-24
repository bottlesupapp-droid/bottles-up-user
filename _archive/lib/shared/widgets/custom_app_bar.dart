import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? backButtonColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleColor,
    this.backButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  color: backButtonColor ?? Theme.of(context).colorScheme.primary,
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 