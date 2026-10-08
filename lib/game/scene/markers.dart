import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle, FontWeight, Shadow;

import '../iso_math.dart';
import 'palette.dart';

/// Gecachte Textlayouts (Namensschilder, Sprechblasen).
class TextCache {
  final Map<String, TextPainter> _cache = {};

  TextPainter get(String text, double size, Color color, {FontWeight weight = FontWeight.w600, bool shadow = false}) {
    // Deckkraft quantisieren, damit Überblendungen den Cache nicht fluten.
    color = color.withValues(alpha: (color.a * 10).round() / 10);
    final key = '$text|$size|${color.toARGB32()}|${weight.value}|$shadow';
    final hit = _cache[key];
    if (hit != null) return hit;
    if (_cache.length > 300) {
      for (final p in _cache.values) {
        p.dispose();
      }
      _cache.clear();
    }
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          height: 1.1,
          letterSpacing: 0.2,
          shadows: shadow ? const [Shadow(color: Color(0xCC000000), blurRadius: 3, offset: Offset(0, 1))] : null,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    _cache[key] = tp;
    return tp;
  }

  void dispose() {
    for (final p in _cache.values) {
      p.dispose();
    }
    _cache.clear();
  }
}

const emoteSymbols = <String, String>{
  'wave': '👋',
  'shock': '😱',
  'think': '🤔',
  'laugh': '😂',
  'scared': '😨',
  'thumbs': '👍',
};

/// Kleine Markierungen in der Szene.
class MarkerPainter {
  final ScenePalette pal;
  final TextCache text;

  MarkerPainter(this.pal, this.text);

  static const _white = Color(0xFFFFFFFF);
  static const _black = Color(0xFF000000);

  Path _star(double r, double inner) {
    final p = Path();
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4 - math.pi / 2;
      final rr = i.isEven ? r : inner;
      final o = Offset(math.cos(a) * rr, math.sin(a) * rr);
      if (i == 0) {
        p.moveTo(o.dx, o.dy);
      } else {
        p.lineTo(o.dx, o.dy);
      }
    }
    return p..close();
  }

  /// Funkeln über einem Hotspot (Welt-Bildschirm-Koordinaten).
  void hotspot(Canvas c, Offset p, String state, String kind, double t, int seed) {
    final col = switch (kind) {
      'lab' => const Color(0xFF7FD8E8),
      'hide' => const Color(0xFFB8A8FF),
      'blood' => mix(pal.danger, _white, 0.15),
      _ => mix(pal.accent, const Color(0xFFFFE8A0), 0.35),
    };
    if (state == 'searched') {
      c.drawCircle(p, 2.6, Paint()..color = withAlpha(const Color(0xFF9A9A9A), 0.45));
      c.drawCircle(
        p,
        4.5,
        Paint()
          ..color = withAlpha(const Color(0xFF9A9A9A), 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      return;
    }
    final fresh = state == 'fresh';
    final ph = t * 2.2 + seed * 0.7;
    final pulse = 0.5 + 0.5 * math.sin(ph);
    final bob = math.sin(t * 1.6 + seed) * 2;
    final o = p.translate(0, bob);
    final glowR = fresh ? 15.0 : 10.0;
    c.drawCircle(
      o,
      glowR,
      Paint()..shader = Gradient.radial(o, glowR, [withAlpha(col, fresh ? 0.45 : 0.28), withAlpha(col, 0)]),
    );
    c.save();
    c.translate(o.dx, o.dy);
    c.rotate(t * 0.6 + seed);
    final s = (fresh ? 7.5 : 5.5) * (0.8 + 0.3 * pulse);
    c.drawPath(_star(s, s * 0.28), Paint()..color = withAlpha(mix(col, _white, 0.55), 0.75 + 0.25 * pulse));
    c.restore();
    if (fresh) {
      for (var i = 0; i < 3; i++) {
        final a = t * 1.3 + i * math.pi * 2 / 3 + seed;
        final q = o + Offset(math.cos(a) * 11, math.sin(a) * 5 - 2);
        final tw = 0.5 + 0.5 * math.sin(t * 5 + i * 2);
        c.save();
        c.translate(q.dx, q.dy);
        c.drawPath(_star(2.6 * tw + 0.8, 0.6), Paint()..color = withAlpha(_white, 0.85 * tw));
        c.restore();
      }
    } else {
      // Ein kleiner Begleitfunke
      final tw = math.max(0.0, math.sin(t * 3.1 + seed * 1.3));
      c.save();
      c.translate(o.dx + 6, o.dy - 6);
      c.drawPath(_star(2.4 * tw + 0.3, 0.5), Paint()..color = withAlpha(_white, 0.8 * tw));
      c.restore();
    }
  }

  /// Item-Symbol, schwebend über dem Boden. [ground] = Bodenpunkt.
  void item(Canvas c, Offset ground, String type, double t, int seed) {
    if (type == 'trace') return; // eigener Painter
    final bob = math.sin(t * 2.4 + seed) * 2.2;
    final o = ground.translate(0, -15 + bob);
    c.drawOval(
      Rect.fromCenter(center: ground, width: 14 - bob, height: 5 - bob * 0.3),
      Paint()..color = withAlpha(_black, 0.35),
    );
    c.drawCircle(
      o,
      12,
      Paint()..shader = Gradient.radial(o, 12, [withAlpha(pal.light, 0.32), withAlpha(pal.light, 0)]),
    );
    c.save();
    c.translate(o.dx, o.dy);
    c.rotate(math.sin(t * 1.3 + seed) * 0.12);
    switch (type) {
      case 'coffee':
        _coffee(c, t);
      case 'battery':
        _battery(c);
      case 'salts':
        _salts(c);
      case 'antidote':
        _syringe(c);
      case 'medkit':
        _medkit(c);
      case 'flare':
        _flare(c, t);
      default:
        c.drawCircle(Offset.zero, 4, Paint()..color = pal.accent);
    }
    c.restore();
  }

  void _coffee(Canvas c, double t) {
    c.drawOval(
      Rect.fromCenter(center: const Offset(0, 5), width: 15, height: 4),
      Paint()..color = const Color(0xFFDAD4C6),
    );
    final cup = Path()
      ..moveTo(-5, -3)
      ..lineTo(5, -3)
      ..lineTo(4, 4)
      ..quadraticBezierTo(0, 5.5, -4, 4)
      ..close();
    c.drawPath(cup, Paint()..color = const Color(0xFFF2EEE4));
    c.drawOval(
      Rect.fromCenter(center: const Offset(0, -3), width: 10, height: 3),
      Paint()..color = const Color(0xFF4A2A18),
    );
    c.drawArc(
      Rect.fromCenter(center: const Offset(5.5, 0.5), width: 5, height: 5),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFFF2EEE4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    final steam = Paint()
      ..color = withAlpha(_white, 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final dx in [-2.0, 1.5]) {
      final ph = t * 2 + dx;
      final path = Path()
        ..moveTo(dx, -5)
        ..quadraticBezierTo(dx + 2 * math.sin(ph), -8, dx, -11)
        ..quadraticBezierTo(dx - 2 * math.sin(ph), -13, dx + 0.5, -15);
      c.drawPath(path, steam);
    }
  }

  void _battery(Canvas c) {
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(-4, -7, 4, 7), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFF26262C),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(-4, -7, 4, -1), const Radius.circular(1.5)),
      Paint()..color = const Color(0xFFE8B83A),
    );
    c.drawRect(const Rect.fromLTRB(-1.6, -9, 1.6, -7), Paint()..color = const Color(0xFFB8B8C0));
    final plus = Paint()
      ..color = const Color(0xFF26262C)
      ..strokeWidth = 1.2;
    c.drawLine(const Offset(-1.6, -4), const Offset(1.6, -4), plus);
    c.drawLine(const Offset(0, -5.6), const Offset(0, -2.4), plus);
    c.drawRect(const Rect.fromLTRB(-3, -6, -2, 6), Paint()..color = withAlpha(_white, 0.2));
  }

  void _salts(Canvas c) {
    final bottle = Path()
      ..moveTo(-4.5, 6)
      ..lineTo(-4.5, -1)
      ..quadraticBezierTo(-4.5, -4, -1.8, -4.5)
      ..lineTo(-1.8, -7)
      ..lineTo(1.8, -7)
      ..lineTo(1.8, -4.5)
      ..quadraticBezierTo(4.5, -4, 4.5, -1)
      ..lineTo(4.5, 6)
      ..close();
    c.drawPath(bottle, Paint()..color = const Color(0xCC4E8A6A));
    c.drawRect(const Rect.fromLTRB(-4.5, 0, 4.5, 4), Paint()..color = const Color(0xFFE8DFC8));
    c.drawRect(const Rect.fromLTRB(-2.2, -9.5, 2.2, -7), Paint()..color = const Color(0xFF8A5A3A));
    c.drawRect(const Rect.fromLTRB(-3.5, -1, -2.5, 5), Paint()..color = withAlpha(_white, 0.3));
  }

  void _syringe(Canvas c) {
    c.save();
    c.rotate(-0.7);
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(-2.4, -6, 2.4, 6), const Radius.circular(1)),
      Paint()..color = const Color(0xCCDDE8EE),
    );
    c.drawRect(const Rect.fromLTRB(-2.4, -1, 2.4, 6), Paint()..color = const Color(0xFF7ADF6A));
    c.drawRect(const Rect.fromLTRB(-3.8, -7, 3.8, -6), Paint()..color = const Color(0xFFB8B8C0));
    c.drawRect(const Rect.fromLTRB(-0.6, -11, 0.6, -7), Paint()..color = const Color(0xFFB8B8C0));
    c.drawRect(const Rect.fromLTRB(-2.4, -12, 2.4, -11), Paint()..color = const Color(0xFFB8B8C0));
    c.drawLine(
      const Offset(0, 6),
      const Offset(0, 11),
      Paint()
        ..color = const Color(0xFFE0E0E8)
        ..strokeWidth = 0.8,
    );
    c.restore();
  }

  void _medkit(Canvas c) {
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(-7, -5, 7, 6), const Radius.circular(2)),
      Paint()..color = const Color(0xFFF0ECE4),
    );
    c.drawRect(const Rect.fromLTRB(-7, -5, 7, -3), Paint()..color = const Color(0xFFD8D2C6));
    final red = Paint()..color = const Color(0xFFC8283A);
    c.drawRect(const Rect.fromLTRB(-1.4, -2.5, 1.4, 4.5), red);
    c.drawRect(const Rect.fromLTRB(-4.2, 0.4, 4.2, 1.6), red);
    c.drawArc(
      Rect.fromCenter(center: const Offset(0, -5), width: 6, height: 4),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF6A6A70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _flare(Canvas c, double t) {
    c.save();
    c.rotate(0.5);
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTRB(-2.2, -6, 2.2, 8), const Radius.circular(1)),
      Paint()..color = const Color(0xFFC8283A),
    );
    c.drawRect(const Rect.fromLTRB(-2.2, 2, 2.2, 4), Paint()..color = const Color(0xFFF0E4C0));
    c.drawRect(const Rect.fromLTRB(-2.4, -8, 2.4, -6), Paint()..color = const Color(0xFF2A2A2E));
    c.restore();
    final sp = 0.6 + 0.4 * math.sin(t * 11);
    final o = const Offset(-4.5, -8);
    c.drawCircle(o, 4 * sp, Paint()..color = withAlpha(const Color(0xFFFF9A3A), 0.5));
    c.drawCircle(o, 1.6, Paint()..color = const Color(0xFFFFF0C0));
  }

  /// Spur des Schattens: dunkelrot glimmende Abdrücke (Bodenebene).
  void traceGround(Canvas c, double wx, double wy, double t, int seed) {
    final o = Iso.toScreen(wx, wy);
    c.save();
    c.translate(o.dx, o.dy);
    Iso.applyGround(c);
    c.rotate(seed * 0.9);
    final glow = 0.55 + 0.25 * math.sin(t * 2 + seed);
    c.drawCircle(
      Offset.zero,
      0.5,
      Paint()
        ..shader = Gradient.radial(Offset.zero, 0.5, [
          withAlpha(const Color(0xFF8A0A14), 0.35 * glow),
          withAlpha(const Color(0xFF8A0A14), 0),
        ]),
    );
    final foot = Paint()..color = withAlpha(const Color(0xFF5A0610), 0.9);
    final rim = Paint()
      ..color = withAlpha(const Color(0xFFFF3A2A), 0.55 * glow)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.018;
    for (var i = 0; i < 3; i++) {
      final fx = -0.3 + i * 0.28;
      final fy = i.isEven ? -0.09 : 0.09;
      final r = Rect.fromCenter(center: Offset(fx, fy), width: 0.2, height: 0.09);
      c.drawOval(r, foot);
      c.drawOval(r, rim);
      for (var k = 0; k < 3; k++) {
        c.drawCircle(Offset(fx + 0.12, fy - 0.03 + k * 0.03), 0.017, foot);
      }
    }
    // Stofffetzen
    final rag = Path()
      ..moveTo(0.2, 0.2)
      ..lineTo(0.34, 0.15)
      ..lineTo(0.31, 0.27)
      ..lineTo(0.4, 0.33)
      ..lineTo(0.24, 0.32)
      ..close();
    c.drawPath(rag, Paint()..color = const Color(0xFF16101C));
    c.drawPath(rag, rim);
    c.restore();
  }

  /// Rauchfaden über der Spur (über der Dunkelheit gezeichnet).
  void traceSmoke(Canvas c, double wx, double wy, double t, int seed) {
    final o = Iso.toScreen(wx, wy);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 2; i++) {
      final ph = t * 0.8 + i * 1.7 + seed;
      final path = Path()..moveTo(o.dx, o.dy - 2);
      for (var k = 1; k <= 6; k++) {
        path.lineTo(o.dx + math.sin(ph + k * 0.9) * (2 + k * 0.8), o.dy - 2 - k * 5);
      }
      p
        ..color = withAlpha(const Color(0xFF6A1A2A), 0.35)
        ..strokeWidth = 2.2;
      c.drawPath(path, p);
    }
  }

  /// Rotes Glimmen der Spur (über der Dunkelheit).
  void traceGlow(Canvas c, double wx, double wy, double t, int seed) {
    final o = Iso.toScreen(wx, wy);
    final glow = 0.5 + 0.5 * math.sin(t * 2 + seed);
    c.drawCircle(
      o,
      9,
      Paint()
        ..shader = Gradient.radial(o, 9, [
          withAlpha(const Color(0xFFFF2A2A), 0.3 * glow + 0.1),
          withAlpha(const Color(0xFFFF2A2A), 0),
        ]),
    );
    c.drawCircle(o, 1.6, Paint()..color = withAlpha(const Color(0xFFFF6A50), 0.5 + 0.4 * glow));
  }

  /// Ping am Boden: pulsierende Ringe. [age] in Sekunden, [life] Gesamtdauer.
  void ping(Canvas c, double wx, double wy, double age, double life, Color col) {
    final fade = (1 - age / life).clamp(0.0, 1.0);
    final o = Iso.toScreen(wx, wy);
    c.save();
    c.translate(o.dx, o.dy);
    c.save();
    Iso.applyGround(c);
    for (var i = 0; i < 3; i++) {
      final ph = ((age * 0.9 + i / 3) % 1.0);
      c.drawCircle(
        Offset.zero,
        0.15 + ph * 0.9,
        Paint()
          ..color = withAlpha(col, (1 - ph) * 0.8 * fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.05,
      );
    }
    c.drawCircle(Offset.zero, 0.14, Paint()..color = withAlpha(col, 0.8 * fade));
    c.restore();
    // Stecknadel
    final bob = math.sin(age * 4) * 2;
    final top = Offset(0, -26 + bob);
    c.drawLine(
      Offset.zero,
      top.translate(0, 6),
      Paint()
        ..color = withAlpha(col, 0.7 * fade)
        ..strokeWidth = 1.5,
    );
    final pin = Path()
      ..moveTo(0, top.dy + 9)
      ..quadraticBezierTo(-7, top.dy + 1, -6, top.dy - 3)
      ..arcToPoint(Offset(6, top.dy - 3), radius: const Radius.circular(6))
      ..quadraticBezierTo(7, top.dy + 1, 0, top.dy + 9)
      ..close();
    c.drawPath(pin, Paint()..color = withAlpha(col, fade));
    c.drawCircle(top.translate(0, -2), 2.4, Paint()..color = withAlpha(_white, 0.9 * fade));
    c.restore();
  }

  /// Hervorhebung des Aktionsziels (Bodenring).
  void targetRing(Canvas c, double wx, double wy, double t) {
    final o = Iso.toScreen(wx, wy);
    final pulse = 0.5 + 0.5 * math.sin(t * 5);
    c.save();
    c.translate(o.dx, o.dy);
    Iso.applyGround(c);
    final r = 0.48 + 0.05 * pulse;
    c.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = withAlpha(pal.accent, 0.5 + 0.4 * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.045,
    );
    c.rotate(t * 0.8);
    final dash = Paint()
      ..color = withAlpha(mix(pal.accent, _white, 0.4), 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.07
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      c.drawArc(Rect.fromCircle(center: Offset.zero, radius: r + 0.1), i * math.pi / 2, math.pi / 5, false, dash);
    }
    c.restore();
  }

  /// Fortschrittsring (Bildschirm-Pixel).
  void channelRing(Canvas c, Offset center, double progress, Color col) {
    c.drawCircle(center, 11, Paint()..color = withAlpha(_black, 0.55));
    c.drawCircle(
      center,
      9,
      Paint()
        ..color = withAlpha(_white, 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    c.drawArc(
      Rect.fromCircle(center: center, radius: 9),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = col
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Namensschild (Bildschirm-Pixel, [anchor] = Unterkante Mitte).
  void nameTag(Canvas c, Offset anchor, String name, Color dot, {double alpha = 1}) {
    final tp = text.get(name, 11, withAlpha(pal.text, alpha));
    final w = tp.width + 18, h = tp.height + 5;
    final r = RRect.fromRectAndRadius(Rect.fromLTWH(anchor.dx - w / 2, anchor.dy - h, w, h), Radius.circular(h / 2));
    c.drawRRect(r, Paint()..color = withAlpha(const Color(0xFF0C0A10), 0.62 * alpha));
    c.drawCircle(Offset(r.left + 7, r.center.dy), 3, Paint()..color = withAlpha(dot, alpha));
    tp.paint(c, Offset(r.left + 13, r.top + 2.5));
  }

  /// Bildschirmfläche der Zielbeschriftung (inkl. Spitze), zum Entzerren anderer Schilder.
  Rect targetLabelRect(Offset anchor, String name) {
    final tp = text.get(name, 12, pal.text, weight: FontWeight.w700);
    final w = tp.width + 16, h = tp.height + 7;
    return Rect.fromLTWH(anchor.dx - w / 2, anchor.dy - h - 6, w, h + 6);
  }

  /// Beschriftung am Aktionsziel.
  void targetLabel(Canvas c, Offset anchor, String name, double alpha) {
    final tp = text.get(name, 12, withAlpha(pal.text, alpha), weight: FontWeight.w700);
    final w = tp.width + 16, h = tp.height + 7;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(anchor.dx - w / 2, anchor.dy - h - 6, w, h),
      const Radius.circular(6),
    );
    c.drawRRect(r, Paint()..color = withAlpha(const Color(0xFF0C0A10), 0.75 * alpha));
    c.drawRRect(
      r,
      Paint()
        ..color = withAlpha(pal.accent, 0.7 * alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final tri = Path()
      ..moveTo(anchor.dx - 5, r.bottom)
      ..lineTo(anchor.dx + 5, r.bottom)
      ..lineTo(anchor.dx, r.bottom + 5)
      ..close();
    c.drawPath(tri, Paint()..color = withAlpha(const Color(0xFF0C0A10), 0.75 * alpha));
    tp.paint(c, Offset(r.left + 8, r.top + 3.5));
  }

  /// Sprechblase mit Emote oder Schnellchat-Symbol (Bildschirm-Pixel).
  void bubble(Canvas c, Offset anchor, String kind, String value, double alpha, double scale) {
    c.save();
    c.translate(anchor.dx, anchor.dy);
    c.scale(scale);
    const w = 34.0, h = 28.0;
    final r = RRect.fromRectAndRadius(const Rect.fromLTWH(-w / 2, -h - 7, w, h), const Radius.circular(10));
    final bg = Paint()..color = withAlpha(const Color(0xFFF4EFE4), 0.95 * alpha);
    c.drawRRect(r, bg);
    final tail = Path()
      ..moveTo(-5, -7.5)
      ..lineTo(5, -7.5)
      ..lineTo(-1, 0)
      ..close();
    c.drawPath(tail, bg);
    final ctr = Offset(0, -7 - h / 2);
    if (kind == 'emote') {
      final sym = emoteSymbols[value] ?? '❔';
      final tp = text.get(sym, 17, withAlpha(_black, alpha), weight: FontWeight.w400);
      tp.paint(c, ctr - Offset(tp.width / 2, tp.height / 2));
    } else {
      _quickIcon(c, ctr, value, alpha);
    }
    c.restore();
  }

  void _quickIcon(Canvas c, Offset o, String id, double a) {
    final ink = Paint()
      ..color = withAlpha(const Color(0xFF2A2230), a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = withAlpha(const Color(0xFF2A2230), a);
    final red = Paint()..color = withAlpha(const Color(0xFFC8283A), a);
    switch (id) {
      case 'come_here':
        c.drawLine(o.translate(0, -7), o.translate(0, 6), ink);
        c.drawPath(
          Path()
            ..moveTo(o.dx - 5, o.dy + 1)
            ..lineTo(o.dx, o.dy + 6)
            ..lineTo(o.dx + 5, o.dy + 1),
          ink,
        );
      case 'found_clue':
        c.drawCircle(o.translate(-2, -2), 5, ink);
        c.drawLine(o.translate(1.8, 1.8), o.translate(6, 6), ink..strokeWidth = 3);
      case 'help':
        c.drawLine(o.translate(0, -7), o.translate(0, 2), ink..color = red.color);
        c.drawCircle(o.translate(0, 6), 1.6, red);
      case 'stay_together':
        c.drawCircle(o.translate(-4, -1), 3, fill);
        c.drawCircle(o.translate(4, -1), 3, fill);
        c.drawLine(o.translate(-7, 6), o.translate(7, 6), ink);
      case 'split_up':
        c.drawLine(o.translate(0, 6), o.translate(0, 0), ink);
        c.drawLine(o.translate(0, 0), o.translate(-6, -6), ink);
        c.drawLine(o.translate(0, 0), o.translate(6, -6), ink);
      case 'suspect':
        final tp = text.get('?', 18, withAlpha(const Color(0xFF2A2230), a), weight: FontWeight.w800);
        tp.paint(c, o - Offset(tp.width / 2, tp.height / 2));
      case 'danger':
        final tri = Path()
          ..moveTo(o.dx, o.dy - 8)
          ..lineTo(o.dx + 8, o.dy + 6)
          ..lineTo(o.dx - 8, o.dy + 6)
          ..close();
        c.drawPath(tri, Paint()..color = withAlpha(const Color(0xFFE8B83A), a));
        c.drawLine(o.translate(0, -3), o.translate(0, 1.5), ink..strokeWidth = 1.8);
        c.drawCircle(o.translate(0, 4), 1.1, fill);
      case 'thanks':
        final heart = Path()
          ..moveTo(o.dx, o.dy + 6)
          ..cubicTo(o.dx - 10, o.dy - 1, o.dx - 5, o.dy - 9, o.dx, o.dy - 3)
          ..cubicTo(o.dx + 5, o.dy - 9, o.dx + 10, o.dy - 1, o.dx, o.dy + 6)
          ..close();
        c.drawPath(heart, red);
      default:
        for (var i = -1; i <= 1; i++) {
          c.drawCircle(o.translate(i * 5.0, 0), 1.8, fill);
        }
    }
  }
}
