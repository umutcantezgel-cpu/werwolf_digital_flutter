import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../meta/progression.dart';

/// XP-Balken des aktuellen Rangs.
class XpBar extends StatelessWidget {
  const XpBar({super.key, required this.xp, this.height = 8, this.showLabel = true, this.color = Noir.brass});

  final int xp;
  final double height;
  final bool showLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final next = nextRankXp(xp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: rankProgress(xp)),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => _Bar(value: v, height: height, color: color),
        ),
        if (showLabel) ...[
          const SizedBox(height: 5),
          Text(
            next == null ? l.hub_rank_max : l.hub_rank_progress(xp, next),
            style: Noir.label(11, color: Noir.smoke, spacing: 0.6, weight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.height, required this.color});

  final double value;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Noir.shade,
        borderRadius: BorderRadius.circular(height),
        border: Border.all(color: Noir.lineSoft),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              gradient: LinearGradient(
                colors: [Color.lerp(color, Colors.black, 0.25)!, color, Color.lerp(color, Colors.white, 0.3)!],
              ),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 6)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rangabzeichen (Stern im Messingkreis mit Rang-Nummer).
class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank, this.size = 44});

  final int rank;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _RankPainter(rank)),
  );
}

class _RankPainter extends CustomPainter {
  _RankPainter(this.rank);

  final int rank;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final metal = rank >= 5 ? Noir.brassLight : (rank >= 3 ? Noir.brass : Noir.bronze);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.4),
          colors: [Color.lerp(metal, Colors.white, 0.4)!, metal, Color.lerp(metal, Colors.black, 0.5)!],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(c, r * 0.8, Paint()..color = Noir.night2);
    canvas.drawCircle(
      c,
      r * 0.8,
      Paint()
        ..color = metal.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    // Stern
    final star = Path();
    for (var i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final rr = i.isEven ? r * 0.56 : r * 0.24;
      final p = c + Offset(math.cos(a) * rr, math.sin(a) * rr);
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = metal);
    // Rang-Punkte
    final dots = rank.clamp(0, 5);
    for (var i = 0; i < dots; i++) {
      final a = math.pi * 0.62 + (i - (dots - 1) / 2) * 0.28;
      canvas.drawCircle(
        c + Offset(math.cos(a - math.pi * 0.12) * r * 0.9, math.sin(a - math.pi * 0.12) * r * 0.9),
        r * 0.07,
        Paint()..color = Noir.night,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RankPainter old) => old.rank != rank;
}

/// Beweisstärke als Skala mit Markierungen für „überführt“ und „lückenlos“.
class StrengthMeter extends StatelessWidget {
  const StrengthMeter({
    super.key,
    required this.value,
    this.max = 7,
    this.solid = 3,
    this.perfect = 5,
    this.dark = false,
  });

  final int value;
  final int max;
  final int solid;
  final int perfect;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= max; i++)
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250 + i * 60),
              height: i == solid || i == perfect ? 16 : 11,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: i <= value
                    ? (i >= perfect ? Noir.brass : (i >= solid ? Noir.buff : Noir.warning))
                    : (dark ? Noir.shadeFaint : Noir.lineSoft),
                border: Border.all(
                  color: i == solid || i == perfect
                      ? (dark ? Noir.inkSoft : Noir.smoke).withValues(alpha: 0.7)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
