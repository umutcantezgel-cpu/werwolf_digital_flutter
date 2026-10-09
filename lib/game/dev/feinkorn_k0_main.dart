// FEINKORN K0 · Prototyp-Bühne (nur Entwicklungsbuild, nie im Release-Einstieg): backt den Testraum aus
// Pixel-Blöcken und zeichnet ihn je Bild mit Kameraschwenk – Weg A (Block-Sprites, drawImageRect) oder
// Weg C (alle Blockflächen als Dreiecksnetz, drawVertices).
// Bauen: flutter build web -t lib/game/dev/feinkorn_k0_main.dart · Aufruf: ?weg=a|c&skala=2
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pixel_engine/feinkorn.dart';

void main() => runApp(const _Buehne());

class _Buehne extends StatefulWidget {
  const _Buehne();

  @override
  State<_Buehne> createState() => _BuehneZustand();
}

class _Sprite {
  _Sprite(this.bild, this.links, this.oben, this.skala);
  final ui.Image bild;
  final double links, oben, skala;
}

class _BuehneZustand extends State<_Buehne> with SingleTickerProviderStateMixin {
  final _sprites = <_Sprite>[];
  ui.Vertices? _netz;
  late final Ticker _ticker;
  double _zeit = 0;
  String _info = 'backe …';

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((d) => setState(() => _zeit = d.inMicroseconds / 1e6))..start();
    _lade();
  }

  Future<void> _lade() async {
    final q = Uri.base.queryParameters;
    final weg = q['weg'] ?? 'a';
    final skala = double.tryParse(q['skala'] ?? '') ?? 2;
    final sw = Stopwatch()..start();
    final raum = Testraum();
    final alle = raum.alle;
    final karte = Schattenkarte.bau(alle, const Backlicht().richtung);
    final ansicht = IsoAnsicht(skala: skala);
    if (weg == 'c') {
      // Alle Flächen sammeln, hinten nach vorn sortieren (drawVertices hat keinen Tiefentest)
      final f = <(double, Float32List, int)>[];
      for (final p in alle) {
        backe(p, ansicht, schatten: karte, flaecheAus: (px, py, e1x, e1y, e2x, e2y, t, argb) {
          final x = px / skala, y = py / skala, ax = e1x / skala, ay = e1y / skala, bx = e2x / skala, by = e2y / skala;
          f.add((t, Float32List.fromList([x, y, x + ax, y + ay, x + ax + bx, y + ay + by, x, y, x + ax + bx, y + ay + by, x + bx, y + by]), argb));
        });
      }
      f.sort((a, b) => a.$1.compareTo(b.$1));
      final pos = Float32List(f.length * 12);
      final farben = Int32List(f.length * 6);
      for (var i = 0; i < f.length; i++) {
        pos.setRange(i * 12, i * 12 + 12, f[i].$2);
        farben.fillRange(i * 6, i * 6 + 6, f[i].$3);
      }
      _netz = ui.Vertices.raw(ui.VertexMode.triangles, pos, colors: farben);
      _info = 'Weg C · Flächen ${f.length} · Dreiecke ${f.length * 2} · Aufbau ${sw.elapsedMilliseconds} ms';
    } else {
      for (final p in alle) {
        final b = backe(p, ansicht, schatten: karte);
        final fertig = await _bild(b);
        _sprites.add(_Sprite(fertig, b.links, b.oben, b.skala));
      }
      _info = 'Weg A · Sprites ${_sprites.length} · Backen ${sw.elapsedMilliseconds} ms';
    }
    // Für die Messung (messen.mjs liest die Konsole nicht; der Titel trägt den Stand)
    debugPrint('FEINKORN_K0 $_info');
    if (mounted) setState(() {});
  }

  Future<ui.Image> _bild(IsoBild b) {
    final fertig = Completer<ui.Image>();
    ui.decodeImageFromPixels(b.rgba, b.breite, b.hoehe, ui.PixelFormat.rgba8888, fertig.complete);
    return fertig.future;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _Maler(_sprites, _netz, _zeit))),
          Positioned(left: 8, top: 8, child: Text(_info, style: const TextStyle(color: Color(0xFFE0D8C8), fontSize: 12))),
        ]),
      );
}

class _Maler extends CustomPainter {
  _Maler(this.sprites, this.netz, this.zeit);
  final List<_Sprite> sprites;
  final ui.Vertices? netz;
  final double zeit;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0C0D12));
    canvas.save();
    // Kameraschwenk: langsame Kreisbewegung um die Raummitte (5, 5)
    final mx = (5 - 5) * 32.0, my = (5 + 5) * 16.0 - 40;
    canvas.translate(size.width / 2 - mx + 60 * _sin(zeit * 0.7),
        size.height / 2 - my + 30 * _sin(zeit * 0.5 + 1));
    final n = netz;
    if (n != null) {
      canvas.drawVertices(n, BlendMode.dst, Paint());
    } else {
      final p = Paint()..filterQuality = FilterQuality.none;
      for (final s in sprites) {
        final quelle = Rect.fromLTWH(0, 0, s.bild.width.toDouble(), s.bild.height.toDouble());
        final ziel = Rect.fromLTWH(s.links, s.oben, s.bild.width / s.skala, s.bild.height / s.skala);
        canvas.drawImageRect(s.bild, quelle, ziel, p);
      }
    }
    canvas.restore();
  }

  static double _sin(double x) {
    // kleine Sinusnäherung ohne dart:math-Import-Aufwand
    x = x.remainder(6.283185307);
    if (x > 3.14159265) x -= 6.283185307;
    return x * (1.27323954 - 0.405284735 * x.abs());
  }

  @override
  bool shouldRepaint(_Maler alt) => true;
}
