import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import 'game_context.dart';

/// Einfache Draufsicht: Raster aus dem Szenario + Positionen aus dem Snapshot.
/// Im großen Modus markiert ein Tipp einen Ort (Ping).
class MiniMap extends StatelessWidget {
  const MiniMap({super.key, required this.g, required this.width, this.interactive = false, this.onPinged});

  final GameCtx g;
  final double width;
  final bool interactive;
  final VoidCallback? onPinged;

  @override
  Widget build(BuildContext context) {
    final s = g.scenario;
    if (s == null) return const SizedBox.shrink();
    final mw = s.map.width;
    final mh = s.map.height;
    final cell = width / mw;
    final height = cell * mh;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xE60B0D18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: g.accent.withValues(alpha: 0.45)),
        boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 12)],
      ),
      child: GestureDetector(
        onTapUp: interactive
            ? (d) {
                if (g.cv.pingsLeft <= 0) return;
                final x = (d.localPosition.dx / cell).clamp(0, mw - 0.01).toDouble();
                final y = (d.localPosition.dy / cell).clamp(0, mh - 0.01).toDouble();
                HapticFeedback.mediumImpact();
                g.send(Signal(kind: 'ping', value: 'ping', x: x, y: y));
                onPinged?.call();
              }
            : null,
        child: ValueListenableBuilder<WorldSnapshot?>(
          valueListenable: g.session.world,
          builder: (context, w, _) => CustomPaint(
            size: Size(width, height),
            painter: _MapPainter(scenario: s, cv: g.cv, world: w, me: g.me, accent: g.accent),
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.scenario, required this.cv, required this.world, required this.me, required this.accent});

  final ScenarioDef scenario;
  final CaseView cv;
  final WorldSnapshot? world;
  final String me;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final map = scenario.map;
    final cell = size.width / map.width;
    final open = {
      for (final d in cv.openDoors)
        if (d.length == 2) '${d[0]},${d[1]}',
    };
    final wall = Paint()..color = const Color(0xFF3A3F5C);
    final floor = Paint()..color = const Color(0xFF1C2034);
    final lit = Paint()..color = const Color(0xFF3A3220);
    final outdoor = Paint()..color = const Color(0xFF16261C);
    final door = Paint()..color = const Color(0xFF7A6A44);
    final locked = Paint()..color = Noir.bloodBright;
    for (var y = 0; y < map.height; y++) {
      for (var x = 0; x < map.width; x++) {
        final c = map.charAt(x, y);
        final r = Rect.fromLTWH(x * cell, y * cell, cell + 0.4, cell + 0.4);
        switch (c) {
          case TileChar.wall:
          case TileChar.window:
            canvas.drawRect(r, wall);
          case TileChar.floor:
            final room = map.roomAt(x, y);
            canvas.drawRect(r, room?.lit == true ? lit : (room?.outdoor == true ? outdoor : floor));
          case TileChar.door:
            canvas.drawRect(r, door);
          case TileChar.lockedDoor:
            canvas.drawRect(r, open.contains('$x,$y') ? door : locked);
        }
      }
    }
    // Hotspots, die für mich noch etwas haben
    for (final e in cv.hotspots.entries) {
      if (e.value != HotspotState.fresh) continue;
      final h = scenario.hotspotById[e.key];
      if (h == null) continue;
      canvas.drawCircle(
        Offset((h.x + 0.5) * cell, (h.y + 0.5) * cell),
        math.max(1.6, cell * 0.28),
        Paint()..color = accent.withValues(alpha: 0.85),
      );
    }
    final w = world;
    if (w == null) return;
    final t = w.t;
    // Pings
    for (final s in w.signals) {
      if (s.kind != 'ping' || s.x == null || s.y == null) continue;
      final phase = (t % 1000) / 1000;
      final o = Offset(s.x! * cell, s.y! * cell);
      canvas.drawCircle(
        o,
        cell * (0.8 + phase * 1.6),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = accent.withValues(alpha: 1 - phase),
      );
      canvas.drawCircle(o, math.max(2, cell * 0.35), Paint()..color = accent);
    }
    // NPCs
    for (final n in w.npcs) {
      final o = Offset(n.x * cell, n.y * cell);
      if (n.alive) {
        canvas.drawCircle(o, math.max(1.8, cell * 0.3), Paint()..color = const Color(0xFFB5B0A6));
      } else {
        final p = Paint()
          ..color = Noir.bloodBright
          ..strokeWidth = 1.4;
        final k = math.max(2.0, cell * 0.3);
        canvas.drawLine(o - Offset(k, k), o + Offset(k, k), p);
        canvas.drawLine(o + Offset(-k, k), o + Offset(k, -k), p);
      }
    }
    // Schatten
    final sh = w.shadow;
    if (sh != null) {
      canvas.drawCircle(
        Offset(sh.x * cell, sh.y * cell),
        math.max(3, cell * 0.5),
        Paint()..color = Noir.bloodBright.withValues(alpha: 0.85),
      );
    }
    // Detektive
    for (final d in w.detectives) {
      final o = Offset(d.x * cell, d.y * cell);
      final col = coatColor(d.coat).withValues(alpha: d.life == LifeState.ghost ? 0.4 : 1);
      final rad = math.max(2.4, cell * (d.id == me ? 0.5 : 0.38));
      if (d.id == me) {
        canvas.drawCircle(o, rad + 2, Paint()..color = Colors.white);
        final dir = Offset(math.cos(d.facing), math.sin(d.facing)) * (rad + 4);
        canvas.drawLine(
          o,
          o + dir,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 1.5,
        );
      }
      canvas.drawCircle(o, rad, Paint()..color = col);
      if (d.life == LifeState.downed) {
        canvas.drawCircle(
          o,
          rad + 3,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Noir.bloodBright
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => true;
}
