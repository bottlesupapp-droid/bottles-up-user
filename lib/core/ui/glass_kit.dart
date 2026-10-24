import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// ── Brand palette ─────────────────────────────────────────────────────────────
const Color _kOrange = Color(0xFFFF6B00);
const Color _kOrangeGlow = Color(0x33FF6B00); // 20 % orange
const Color _kGlassBorder = Color(0x26FFFFFF); // 15 % white

// ── GlassCard ─────────────────────────────────────────────────────────────────
/// Frosted-glass container. Drop-in replacement for Card / Container.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final Color? tintColor;
  final bool showBorder;
  final bool showGlow;
  final Color? glowColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.blur = 20,
    this.tintColor,
    this.showBorder = true,
    this.showGlow = false,
    this.glowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tint = tintColor ?? Theme.of(context).colorScheme.surface.withValues(alpha: 0.35);
    final glow = glowColor ?? _kOrangeGlow;

    Widget card = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                tint,
              ],
            ),
            borderRadius: borderRadius,
            border: showBorder
                ? Border.all(color: _kGlassBorder, width: 0.8)
                : null,
            boxShadow: showGlow
                ? [
                    BoxShadow(
                      color: glow,
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ── GlassButton ───────────────────────────────────────────────────────────────
class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool primary;
  final EdgeInsetsGeometry padding;

  const GlassButton({
    super.key,
    required this.child,
    this.onPressed,
    this.primary = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: widget.primary
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _kOrange.withValues(alpha: 0.85),
                          _kOrange.withValues(alpha: 0.65),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.primary
                      ? _kOrange.withValues(alpha: 0.6)
                      : _kGlassBorder,
                  width: 0.8,
                ),
                boxShadow: widget.primary
                    ? [
                        BoxShadow(
                          color: _kOrange.withValues(alpha: 0.35),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: widget.primary ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── GlassBottomNavBar ─────────────────────────────────────────────────────────
/// Floating pill-shaped bottom nav with Liquid Glass effect.
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassNavItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, bottom: bottom + 14, top: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  const Color(0xFF171214).withValues(alpha: 0.70),
                ],
              ),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: _kGlassBorder,
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: _kOrange.withValues(alpha: 0.08),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                return _GlassNavItemWidget(
                  item: items[i],
                  isSelected: i == currentIndex,
                  onTap: () => onTap(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassNavItemWidget extends StatelessWidget {
  final GlassNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _GlassNavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kOrange.withValues(alpha: 0.30),
                      _kOrange.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _kOrange.withValues(alpha: 0.45),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _kOrange.withValues(alpha: 0.25),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  color: isSelected ? _kOrange : Colors.white.withValues(alpha: 0.55),
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? _kOrange : Colors.white.withValues(alpha: 0.50),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const GlassNavItem(
      {required this.icon,
      required this.activeIcon,
      required this.label});
}

// ── GlassAppBar ───────────────────────────────────────────────────────────────
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBlur;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBlur = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: showBlur
            ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.07),
                const Color(0xFF171214).withValues(alpha: 0.60),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: _kGlassBorder,
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            leading: leading,
            actions: actions,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }
}

// ── AmbientGlowBackground ─────────────────────────────────────────────────────
/// Animated background with soft, slowly-drifting glow orbs — orange + purple.
class AmbientGlowBackground extends StatefulWidget {
  final Widget child;
  final bool animate;

  const AmbientGlowBackground({
    super.key,
    required this.child,
    this.animate = true,
  });

  @override
  State<AmbientGlowBackground> createState() => _AmbientGlowBackgroundState();
}

class _AmbientGlowBackgroundState extends State<AmbientGlowBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (widget.animate) _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base background
        Container(color: const Color(0xFF171214)),

        // Animated orbs
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final t = _ctrl.value;
            return CustomPaint(
              painter: _GlowOrbPainter(t),
              child: const SizedBox.expand(),
            );
          },
        ),

        // Global noise / grain tint
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [
                Colors.white.withValues(alpha: 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),

        widget.child,
      ],
    );
  }
}

class _GlowOrbPainter extends CustomPainter {
  final double t;
  _GlowOrbPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Orb 1 — orange, top-right, drifts slowly
    final x1 = w * (0.65 + 0.12 * math.sin(t * math.pi));
    final y1 = h * (0.15 + 0.08 * math.cos(t * math.pi));
    _drawOrb(canvas, Offset(x1, y1), w * 0.55,
        const Color(0x26FF6B00), const Color(0x00FF6B00));

    // Orb 2 — deep purple, bottom-left
    final x2 = w * (0.20 - 0.10 * math.sin(t * math.pi + 1.0));
    final y2 = h * (0.70 + 0.10 * math.cos(t * math.pi + 1.0));
    _drawOrb(canvas, Offset(x2, y2), w * 0.50,
        const Color(0x1A9B59B6), const Color(0x009B59B6));

    // Orb 3 — subtle warm white, centre
    final x3 = w * (0.50 + 0.06 * math.sin(t * math.pi * 2));
    final y3 = h * (0.40 + 0.06 * math.cos(t * math.pi * 2));
    _drawOrb(canvas, Offset(x3, y3), w * 0.35,
        const Color(0x0DFFFFFF), const Color(0x00FFFFFF));
  }

  void _drawOrb(Canvas canvas, Offset center, double radius,
      Color inner, Color outer) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [inner, outer])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GlowOrbPainter old) => old.t != t;
}

// ── GlassSheet ────────────────────────────────────────────────────────────────
/// Bottom sheet with Liquid Glass look. Use with showModalBottomSheet.
class GlassSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final double maxHeightFraction;

  const GlassSheet({
    super.key,
    required this.child,
    this.title,
    this.maxHeightFraction = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: mq.size.height * maxHeightFraction,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.10),
                const Color(0xFF171214).withValues(alpha: 0.80),
              ],
            ),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: const Border(
              top: BorderSide(color: _kGlassBorder, width: 0.8),
              left: BorderSide(color: _kGlassBorder, width: 0.5),
              right: BorderSide(color: _kGlassBorder, width: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: 16),
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                    color: Colors.white.withValues(alpha: 0.10),
                    height: 24),
              ] else
                const SizedBox(height: 8),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

// ── GlassChip ─────────────────────────────────────────────────────────────────
class GlassChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const GlassChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? [
                        _kOrange.withValues(alpha: 0.40),
                        _kOrange.withValues(alpha: 0.20),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.03),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? _kOrange.withValues(alpha: 0.55)
                    : _kGlassBorder,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14,
                      color: selected ? _kOrange : Colors.white70),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? _kOrange : Colors.white70,
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Thin orange glow divider
class GlowDivider extends StatelessWidget {
  final double opacity;
  const GlowDivider({super.key, this.opacity = 0.3});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.transparent,
          _kOrange.withValues(alpha: opacity),
          Colors.transparent,
        ]),
        boxShadow: [
          BoxShadow(
            color: _kOrange.withValues(alpha: opacity * 0.5),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}

/// Orange ambient glow badge (e.g. on icons)
class GlowBadge extends StatelessWidget {
  final Widget child;
  final Color color;
  const GlowBadge(
      {super.key, required this.child, this.color = _kOrange});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
