import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'palette.dart';

class _P {
  double x = 0, y = 0, v = 0, s = 0, ph = 0;
}

/// Wetter-Partikel in Bildschirmkoordinaten (≤ 200).
class WeatherSystem {
  final String kind;
  final ScenePalette pal;
  final math.Random _rnd = math.Random(7);
  final List<_P> _parts = [];
  final List<_P> _splash = [];
  double intensity = 0;
  Size _size = Size.zero;

  WeatherSystem(this.kind, this.pal);

  int get _count => switch (kind) {
        'rain' => 180,
        'snow' => 150,
        'dust' => 70,
        'neon' => 80,
        _ => 0,
      };

  void _spawn(_P p, {bool anywhere = true}) {
    final w = _size.width, h = _size.height;
    p.x = _rnd.nextDouble() * (w + 200) - 100;
    p.y = anywhere ? _rnd.nextDouble() * h : -20 - _rnd.nextDouble() * 60;
    switch (kind) {
      case 'rain':
      case 'neon':
        p.v = 620 + _rnd.nextDouble() * 320;
        p.s = 10 + _rnd.nextDouble() * 12;
      case 'snow':
        p.v = 28 + _rnd.nextDouble() * 46;
        p.s = 1 + _rnd.nextDouble() * 2.2;
      case 'dust':
        p.v = 4 + _rnd.nextDouble() * 10;
        p.s = 0.8 + _rnd.nextDouble() * 1.6;
    }
    p.ph = _rnd.nextDouble() * math.pi * 2;
  }

  /// [pan] = Kamerabewegung in Bildschirm-Pixeln seit dem letzten Frame.
  void update(double dt, Size size, double target, Offset pan) {
    if (_count == 0) return;
    if (size != _size) {
      _size = size;
      _parts.clear();
    }
    intensity += (target - intensity) * math.min(1.0, dt * 1.5);
    if (_parts.isEmpty) {
      for (var i = 0; i < _count; i++) {
        final p = _P();
        _spawn(p);
        _parts.add(p);
      }
    }
    final w = size.width, h = size.height;
    for (final p in _parts) {
      p.x -= pan.dx * 0.9;
      p.y -= pan.dy * 0.9;
      switch (kind) {
        case 'rain':
        case 'neon':
          p.y += p.v * dt;
          p.x -= p.v * 0.18 * dt;
        case 'snow':
          p.y += p.v * dt;
          p.ph += dt * 1.3;
          p.x += math.sin(p.ph) * 18 * dt - 6 * dt;
        case 'dust':
          p.ph += dt * 0.6;
          p.x += math.cos(p.ph) * p.v * dt + 3 * dt;
          p.y += math.sin(p.ph * 0.7) * p.v * dt - 1.5 * dt;
      }
      if (p.y > h + 30 || p.x < -120 || p.x > w + 120 || p.y < -100) {
        _spawn(p, anywhere: kind == 'dust');
        if (kind == 'dust') continue;
      }
    }
    if (kind == 'rain' && intensity > 0.3) {
      if (_splash.length < 22 && _rnd.nextDouble() < 0.9) {
        _splash.add(_P()
          ..x = _rnd.nextDouble() * w
          ..y = h * 0.15 + _rnd.nextDouble() * h * 0.85
          ..ph = 0);
      }
    }
    for (var i = _splash.length - 1; i >= 0; i--) {
      final s = _splash[i];
      s.ph += dt * 3.5;
      s.x -= pan.dx;
      s.y -= pan.dy;
      if (s.ph >= 1) _splash.removeAt(i);
    }
  }

  void render(Canvas c, Size size, double t) {
    if (_count == 0 || intensity < 0.01) return;
    switch (kind) {
      case 'rain':
        _rain(c, const Color(0xFFA8B8CC), 0.34);
        _splashes(c);
      case 'neon':
        _neonHaze(c, size, t);
        _rain(c, const Color(0xFFC8B8E8), 0.2);
      case 'snow':
        _snow(c);
      case 'dust':
        _dust(c, t);
    }
  }

  void _rain(Canvas c, Color col, double a) {
    final pts = Float32List(_parts.length * 4);
    var i = 0;
    for (final p in _parts) {
      pts[i++] = p.x;
      pts[i++] = p.y;
      pts[i++] = p.x + p.s * 0.18;
      pts[i++] = p.y - p.s;
    }
    c.drawRawPoints(
      PointMode.lines,
      pts,
      Paint()
        ..color = withAlpha(col, a * intensity)
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
  }

  void _splashes(Canvas c) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    for (final s in _splash) {
      p.color = withAlpha(const Color(0xFFC8D4E4), (1 - s.ph) * 0.45 * intensity);
      c.drawOval(Rect.fromCenter(center: Offset(s.x, s.y), width: 3 + s.ph * 9, height: 1.2 + s.ph * 3.5), p);
    }
  }

  void _snow(Canvas c) {
    for (final (lo, hi, w) in [(0.0, 1.6, 1.8), (1.6, 2.4, 2.8), (2.4, 9.0, 3.8)]) {
      final list = _parts.where((p) => p.s >= lo && p.s < hi).toList();
      if (list.isEmpty) continue;
      final pts = Float32List(list.length * 2);
      var i = 0;
      for (final p in list) {
        pts[i++] = p.x;
        pts[i++] = p.y;
      }
      c.drawRawPoints(
        PointMode.points,
        pts,
        Paint()
          ..color = withAlpha(const Color(0xFFF4F8FF), 0.8 * intensity)
          ..strokeWidth = w
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _dust(Canvas c, double t) {
    final pts = Float32List(_parts.length * 2);
    var i = 0;
    for (final p in _parts) {
      pts[i++] = p.x;
      pts[i++] = p.y;
    }
    c.drawRawPoints(
      PointMode.points,
      pts,
      Paint()
        ..color = withAlpha(mix(pal.light, const Color(0xFFFFFFFF), 0.4), (0.28 + 0.08 * math.sin(t * 1.3)) * intensity)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _neonHaze(Canvas c, Size size, double t) {
    final cols = [pal.accent, const Color(0xFFFF3FA0), const Color(0xFF3FD8FF)];
    for (var i = 0; i < 3; i++) {
      final cx = size.width * (0.5 + 0.45 * math.sin(t * 0.07 + i * 2.1));
      final cy = size.height * (0.5 + 0.4 * math.cos(t * 0.05 + i * 1.7));
      final r = size.shortestSide * (0.55 + 0.1 * i);
      final flick = 0.75 + 0.25 * math.sin(t * (1.1 + i) + i) + (math.sin(t * 19 + i * 5) > 0.97 ? -0.4 : 0);
      c.drawCircle(
        Offset(cx, cy),
        r,
        Paint()..shader = Gradient.radial(Offset(cx, cy), r, [withAlpha(cols[i], 0.13 * flick * intensity), withAlpha(cols[i], 0)]),
      );
    }
  }
}
