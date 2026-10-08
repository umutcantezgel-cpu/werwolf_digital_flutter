import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../haptics.dart';

/// Kachel im Bento-Grid: Druck-Animation + Haptik, optional hervorgehoben (Messing + Glow).
class BentoTile extends StatefulWidget {
  const BentoTile({
    super.key,
    required this.child,
    this.onTap,
    this.height,
    this.highlight = false,
    this.accent = Noir.brass,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final bool highlight;
  final Color accent;
  final EdgeInsetsGeometry padding;

  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.accent;
    final deco = widget.highlight
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.lerp(a, Colors.white, 0.22)!, a, Color.lerp(a, Colors.black, 0.35)!],
            ),
            border: Border.all(color: Color.lerp(a, Colors.white, 0.4)!),
            boxShadow: [
              BoxShadow(
                color: a.withValues(alpha: _down ? 0.65 : 0.42),
                blurRadius: _down ? 34 : 26,
                spreadRadius: 1,
              ),
              const BoxShadow(color: Noir.shadow, blurRadius: 12, offset: Offset(0, 6)),
            ],
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Noir.night2.withValues(alpha: 0.86),
            border: Border.all(color: _down ? a.withValues(alpha: 0.7) : Noir.lineSoft),
            boxShadow: const [BoxShadow(color: Noir.shadow, blurRadius: 14, offset: Offset(0, 6))],
          );
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _down = false);
              Haptics.selection();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _down ? 0.965 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: widget.height,
          padding: widget.padding,
          decoration: deco,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Symbol in einem runden Feld (für Kacheln).
class TileIcon extends StatelessWidget {
  const TileIcon(this.icon, {super.key, this.color = Noir.brass, this.onDark = true, this.size = 22});

  final IconData icon;
  final Color color;
  final bool onDark;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size * 1.75,
    height: size * 1.75,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: onDark ? color.withValues(alpha: 0.14) : Noir.night.withValues(alpha: 0.16),
      border: Border.all(color: onDark ? color.withValues(alpha: 0.45) : Noir.night.withValues(alpha: 0.25)),
    ),
    child: Icon(icon, size: size, color: onDark ? color : Noir.night),
  );
}
