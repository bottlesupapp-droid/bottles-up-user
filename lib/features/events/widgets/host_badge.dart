import 'package:flutter/material.dart';

class HostBadge extends StatelessWidget {
  final bool isPrimary;
  final VoidCallback? onTap;

  const HostBadge({
    super.key,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPrimary
                ? [
                    const Color(0xFFFF6B00),
                    const Color(0xFFFF8C00),
                  ]
                : [
                    Colors.grey.shade600,
                    Colors.grey.shade700,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isPrimary ? const Color(0xFFFF6B00) : Colors.grey)
                  .withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPrimary ? Icons.star : Icons.admin_panel_settings,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              isPrimary ? 'HOST' : 'CO-HOST',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
