import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'paper.dart';

/// Code-gezeichnetes Logo „MORDAKTE“: Schreibmaschinen-Titel, Lupe, roter Stempel.
class MordakteLogo extends StatelessWidget {
  const MordakteLogo({super.key, this.size = 48, this.subtitle});

  final double size;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: size * 0.9, height: 1, color: Noir.brass.withValues(alpha: 0.6)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.2),
              child: SizedBox.square(dimension: size * 0.42, child: const CustomPaint(painter: _LensPainter())),
            ),
            Container(width: size * 0.9, height: 1, color: Noir.brass.withValues(alpha: 0.6)),
          ],
        ),
        SizedBox(height: size * 0.14),
        Stack(
          clipBehavior: Clip.none,
          children: [
            ShaderMask(
              shaderCallback: (r) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Noir.cream, Color(0xFFCFC4AE)],
              ).createShader(r),
              child: Text(
                'MORDAKTE',
                style: Noir.title(size, color: Colors.white, spacing: size * 0.16).copyWith(
                  shadows: const [Shadow(color: Color(0xCC000000), blurRadius: 18, offset: Offset(0, 4))],
                ),
              ),
            ),
            Positioned(
              right: -size * 0.25,
              bottom: -size * 0.5,
              child: Stamp(text: 'Ungelöst', fontSize: size * 0.3, angle: -0.16),
            ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: size * 0.42),
          Text(
            subtitle!.toUpperCase(),
            style: Noir.label(size * 0.24, color: Noir.smoke, spacing: size * 0.08, weight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

class _LensPainter extends CustomPainter {
  const _LensPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final ring = Paint()
      ..color = Noir.brass
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.11;
    final c = Offset(s * 0.42, s * 0.42);
    canvas.drawCircle(c, s * 0.3, Paint()..color = Noir.brass.withValues(alpha: 0.12));
    canvas.drawCircle(c, s * 0.3, ring);
    canvas.drawLine(
      Offset(s * 0.65, s * 0.65),
      Offset(s * 0.95, s * 0.95),
      Paint()
        ..color = Noir.brass
        ..strokeWidth = s * 0.16
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: s * 0.19),
      3.6,
      1.2,
      false,
      Paint()
        ..color = Noir.brassLight.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.05
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LensPainter oldDelegate) => false;
}
