import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../mordakte_game.dart';

/// Runder Aktionsknopf (88 px). Reagiert auf rohe Pointer-Events, damit er
/// gleichzeitig mit dem Joystick bedient werden kann.
class ActionButton extends StatefulWidget {
  const ActionButton({super.key, required this.game, this.size = 88});

  final MordakteGame game;
  final double size;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return ValueListenableBuilder<ActionTarget?>(
      valueListenable: game.target,
      builder: (context, target, _) {
        final enabled = target != null;
        final accent = game.palette.accent;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) {
            if (!enabled) return;
            game.triggerAction();
            setState(() => _pressed = true);
          },
          onPointerUp: (_) => setState(() => _pressed = false),
          onPointerCancel: (_) => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.9 : 1,
            duration: const Duration(milliseconds: 90),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _ButtonPainter(
                  enabled: enabled,
                  kind: target?.kind ?? '',
                  accent: accent,
                  progress: game.channelProgress,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 34),
                    child: Text(
                      target?.label ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: (target?.label.length ?? 0) > 12 ? 10 : 11.5,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: enabled ? const Color(0xFFF3E9DC) : const Color(0x66F3E9DC),
                        shadows: const [Shadow(color: Color(0xAA000000), blurRadius: 2)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ButtonPainter extends CustomPainter {
  final bool enabled;
  final String kind;
  final Color accent;
  final ValueNotifier<double> progress;

  _ButtonPainter({required this.enabled, required this.kind, required this.accent, required this.progress}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawCircle(c.translate(0, 2), r, Paint()..color = const Color(0x66000000));
    canvas.drawCircle(
      c,
      r - 1,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: enabled
              ? [Color.lerp(const Color(0xFF2A2230), accent, 0.25)!, const Color(0xFF120E16)]
              : [const Color(0xFF26242A), const Color(0xFF141317)],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(c, r - 2, Paint()
      ..color = enabled ? accent.withValues(alpha: 0.9) : const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = enabled ? 2.4 : 1.4);
    final p = progress.value;
    if (enabled && kind == 'cancel' && p > 0) {
      canvas.drawArc(Rect.fromCircle(center: c, radius: r - 6), -math.pi / 2, math.pi * 2 * p.clamp(0.0, 1.0), false, Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round);
    }
    final ic = c.translate(0, -12);
    final ink = Paint()
      ..color = enabled ? const Color(0xFFF3E9DC) : const Color(0x55F3E9DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = ink.color;
    switch (kind) {
      case 'search':
      case 'body':
      case 'blood':
      case 'trace':
        canvas.drawCircle(ic.translate(-3, -3), 8, ink);
        canvas.drawLine(ic.translate(3, 3), ic.translate(9, 9), ink..strokeWidth = 3.4);
        if (kind == 'trace') canvas.drawCircle(ic.translate(-3, -3), 2.5, Paint()..color = const Color(0xFFE04050));
      case 'lab':
        final flask = Path()
          ..moveTo(ic.dx - 3, ic.dy - 10)
          ..lineTo(ic.dx - 3, ic.dy - 3)
          ..lineTo(ic.dx - 9, ic.dy + 8)
          ..lineTo(ic.dx + 9, ic.dy + 8)
          ..lineTo(ic.dx + 3, ic.dy - 3)
          ..lineTo(ic.dx + 3, ic.dy - 10);
        canvas.drawPath(flask, ink);
        canvas.drawLine(ic.translate(-5, -10), ic.translate(5, -10), ink);
        canvas.drawCircle(ic.translate(-2, 4), 1.6, fill);
        canvas.drawCircle(ic.translate(3, 2), 1.2, fill);
      case 'hide':
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: ic, width: 16, height: 21), const Radius.circular(2)), ink);
        canvas.drawLine(ic.translate(0, -10), ic.translate(0, 10), ink);
        canvas.drawCircle(ic.translate(-2.5, 1), 1.2, fill);
        canvas.drawCircle(ic.translate(2.5, 1), 1.2, fill);
      case 'npc':
        final b = RRect.fromRectAndRadius(Rect.fromCenter(center: ic.translate(0, -2), width: 22, height: 15), const Radius.circular(6));
        canvas.drawRRect(b, ink);
        canvas.drawLine(ic.translate(-4, 5.5), ic.translate(-7, 10), ink);
        for (final dx in [-5.0, 0.0, 5.0]) {
          canvas.drawCircle(ic.translate(dx, -2), 1.4, fill);
        }
      case 'item':
        canvas.drawLine(ic.translate(0, -10), ic.translate(0, 4), ink);
        canvas.drawLine(ic.translate(-5, -1), ic.translate(0, 4), ink);
        canvas.drawLine(ic.translate(5, -1), ic.translate(0, 4), ink);
        canvas.drawLine(ic.translate(-9, 9), ic.translate(9, 9), ink);
      case 'revive':
        final heart = Path()
          ..moveTo(ic.dx, ic.dy + 9)
          ..cubicTo(ic.dx - 14, ic.dy - 1, ic.dx - 7, ic.dy - 12, ic.dx, ic.dy - 5)
          ..cubicTo(ic.dx + 7, ic.dy - 12, ic.dx + 14, ic.dy - 1, ic.dx, ic.dy + 9)
          ..close();
        canvas.drawPath(heart, Paint()..color = const Color(0xFFD8384A));
        canvas.drawLine(ic.translate(-4, -1), ic.translate(4, -1), ink..strokeWidth = 2);
        canvas.drawLine(ic.translate(0, -5), ic.translate(0, 3), ink);
      case 'cancel':
        canvas.drawLine(ic.translate(-7, -7), ic.translate(7, 7), ink);
        canvas.drawLine(ic.translate(7, -7), ic.translate(-7, 7), ink);
      default:
        // Hand (nichts in Reichweite)
        final hand = RRect.fromRectAndRadius(Rect.fromCenter(center: ic.translate(0, 3), width: 14, height: 12), const Radius.circular(4));
        canvas.drawRRect(hand, ink);
        for (final dx in [-4.5, -1.5, 1.5, 4.5]) {
          canvas.drawLine(ic.translate(dx, -3), ic.translate(dx, -9 + dx.abs() * 0.4), ink..strokeWidth = 2.2);
        }
    }
  }

  @override
  bool shouldRepaint(_ButtonPainter old) => old.enabled != enabled || old.kind != kind || old.accent != accent;
}
