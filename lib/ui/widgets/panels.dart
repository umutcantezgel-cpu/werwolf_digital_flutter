import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Dunkles, leicht transparentes Panel mit feinem Rand.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.accent,
    this.radius = 6,
    this.opacity = 0.82,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accent;
  final double radius;
  final double opacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Noir.night2.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: accent?.withValues(alpha: 0.55) ?? const Color(0x2EE8E0D0)),
        boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: child,
    );
    if (onTap == null) return body;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: body),
    );
  }
}

/// Zentriert und begrenzt die Breite (Querformat/Tablet).
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 560});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
      );
}

/// Schwierigkeit als Lupen-Reihe.
class DifficultyDots extends StatelessWidget {
  const DifficultyDots({super.key, required this.value, this.max = 3, this.color = Noir.ink, this.size = 15});

  final int value;
  final int max;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < max; i++)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(Icons.search_rounded, size: size, color: i < value ? color : color.withValues(alpha: 0.22)),
            ),
        ],
      );
}

/// Zeigt eine kurze Meldung unten an.
void showNoirSnack(BuildContext context, String text, {IconData icon = Icons.info_outline_rounded, Color color = Noir.brass}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Noir.text(14))),
        ]),
        duration: const Duration(milliseconds: 2600),
      ),
    );
}
