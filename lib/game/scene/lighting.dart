import 'dart:math' as math;
import 'dart:ui';

import 'package:mordakte_core/mordakte_core.dart';

import '../iso_math.dart';
import 'palette.dart';

enum LightMode { day, council, night }

/// Eine Lichtquelle für den Dunkelheits-Layer.
class SceneLight {
  final double x, y;
  final double radius;

  /// Taschenlampe in Blickrichtung (Radiant), sonst `null`.
  final double? cone;
  final double strength;

  const SceneLight(this.x, this.y, this.radius, {this.cone, this.strength = 1});
}

/// Ein Licht-Prop mit warmem Schein.
class GlowLight {
  final double x, y, z;
  final double radius;
  final Color color;
  final double strength;

  const GlowLight(this.x, this.y, this.z, this.radius, this.color, this.strength);
}

/// Dunkelheit (eine saveLayer pro Frame) mit ausgeschnittenen Lichtern.
class LightingRenderer {
  final ScenePalette pal;

  LightingRenderer(this.pal);

  static const _black = Color(0xFF000000);

  void render(
    Canvas c,
    Rect view, {
    required LightMode mode,
    required double darkness,
    required List<SceneLight> lights,
    required List<RoomDef> litRooms,
    required List<GlowLight> glows,
    double flash = 0,
    double dayTint = 0.1,
  }) {
    if (mode == LightMode.day) {
      if (dayTint > 0.005) {
        c.drawRect(view, Paint()..color = withAlpha(mix(pal.fog, const Color(0xFF0A1020), 0.3), dayTint));
      }
      _glows(c, glows, 0.35);
      return;
    }
    final dark = mode == LightMode.night ? mix(pal.fog, const Color(0xFF02030A), 0.55) : mix(const Color(0xFF2A1506), pal.fog, 0.35);
    final a = (darkness * (1 - flash * 0.75)).clamp(0.0, 1.0);
    c.saveLayer(view, Paint());
    c.drawRect(view, Paint()..color = withAlpha(dark, a));
    final cut = Paint()..blendMode = BlendMode.dstOut;
    for (final r in litRooms) {
      _roomCut(c, r, cut);
    }
    for (final l in lights) {
      final o = Iso.toScreen(l.x, l.y);
      c.save();
      c.translate(o.dx, o.dy);
      Iso.applyGround(c);
      cut.shader = Gradient.radial(
        Offset.zero,
        l.radius,
        [withAlpha(_black, l.strength), withAlpha(_black, l.strength * 0.85), withAlpha(_black, 0)],
        const [0.0, 0.45, 1.0],
      );
      c.drawCircle(Offset.zero, l.radius, cut);
      if (l.cone != null) {
        final len = l.radius * 1.75;
        const half = 0.5;
        final path = Path()..moveTo(0, 0);
        for (var i = 0; i <= 10; i++) {
          final ang = l.cone! - half + i * (half * 2 / 10);
          path.lineTo(math.cos(ang) * len, math.sin(ang) * len);
        }
        path.close();
        cut.shader = Gradient.radial(
          Offset.zero,
          len,
          [withAlpha(_black, 0.95 * l.strength), withAlpha(_black, 0.75 * l.strength), withAlpha(_black, 0)],
          const [0.0, 0.55, 1.0],
        );
        c.drawPath(path, cut);
      }
      c.restore();
    }
    for (final g in glows) {
      final o = Iso.toScreen(g.x, g.y);
      c.save();
      c.translate(o.dx, o.dy);
      Iso.applyGround(c);
      final r = g.radius * (mode == LightMode.council ? 1.3 : 1.0);
      cut.shader = Gradient.radial(Offset.zero, r, [withAlpha(_black, 0.9 * g.strength), withAlpha(_black, 0.6 * g.strength), withAlpha(_black, 0)], const [0, 0.4, 1]);
      c.drawCircle(Offset.zero, r, cut);
      c.restore();
    }
    c.restore();
    _glows(c, glows, mode == LightMode.night ? 1.0 : 0.7);
    if (mode == LightMode.council) {
      c.drawRect(view, Paint()..color = withAlpha(pal.light, 0.05));
    }
  }

  void _roomCut(Canvas c, RoomDef r, Paint cut) {
    // Boden + hintere Wände (Hexagon-Silhouette), weich auslaufend.
    for (final (grow, alpha) in [(0.6, 0.25), (0.3, 0.35), (0.0, 0.9)]) {
      final x0 = r.x - 1 - grow, y0 = r.y - 1 - grow;
      final x1 = r.x + r.w + grow, y1 = r.y + r.h + grow;
      final h = 1.6 + grow;
      final pts = [
        Iso.toScreen(x0, y1, 0),
        Iso.toScreen(x0, y1, h),
        Iso.toScreen(x0, y0, h),
        Iso.toScreen(x1, y0, h),
        Iso.toScreen(x1, y0, 0),
        Iso.toScreen(x1, y1, 0),
      ];
      cut.shader = null;
      cut.color = withAlpha(_black, alpha);
      c.drawPath(Path()..addPolygon(pts, true), cut);
    }
    cut.color = _black;
  }

  void _glows(Canvas c, List<GlowLight> glows, double k) {
    if (glows.isEmpty) return;
    final p = Paint()..blendMode = BlendMode.plus;
    for (final g in glows) {
      final o = Iso.toScreen(g.x, g.y, g.z);
      final r = g.radius * 26;
      p.shader = Gradient.radial(o, r, [withAlpha(g.color, 0.32 * k * g.strength), withAlpha(g.color, 0.1 * k * g.strength), withAlpha(g.color, 0)], const [0, 0.35, 1]);
      c.drawCircle(o, r, p);
    }
  }
}
