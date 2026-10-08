import 'dart:ui' as dui;

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'frame_sink.dart';
import 'tasten.dart';

/// Vollbild-Pixelansicht des Spiels: Takt, Bildausgabe (ganzzahlig skaliert in
/// physischen Pixeln, ohne Glättung) und Eingabe (Touch, Maus, Tastatur).
class BurgstadtAnsicht extends StatefulWidget {
  const BurgstadtAnsicht({super.key, this.beiAktion, this.start});

  final void Function(String aktion)? beiAktion;

  /// Entwickler-Einstieg: `erkundung` springt direkt ins Spiel.
  final String? start;

  @override
  State<BurgstadtAnsicht> createState() => _BurgstadtAnsichtState();
}

class _BurgstadtAnsichtState extends State<BurgstadtAnsicht> with SingleTickerProviderStateMixin {
  final Spiel spiel = Spiel();
  final Eingabe eingabe = Eingabe();
  final FrameSink _welt = FrameSink(), _ui = FrameSink();
  final FocusNode _fokus = FocusNode(debugLabel: 'burgstadt');
  late final Ticker _ticker;
  Duration? _letzte;
  Size _logisch = Size.zero;
  double _dpr = 1;
  Uint8List? _weltRgba, _uiRgba;
  int _version = 0;

  // Messung (Entwickler: `?bsmess=1` schreibt Mittelwerte in die Konsole)
  final Stopwatch _uhr = Stopwatch()..start();
  double _sumSpiel = 0, _sumRgba = 0;
  int _messBilder = 0;
  static final bool _messen = () {
    try {
      return Uri.base.queryParameters.containsKey('bsmess');
    } catch (_) {
      return false;
    }
  }();

  @override
  void initState() {
    super.initState();
    spiel.beiAktion = (a) => widget.beiAktion?.call(a);
    if (widget.start == 'erkundung') spiel.wechsle(Erkundung());
    _ticker = createTicker(_takt)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _welt.dispose();
    _ui.dispose();
    _fokus.dispose();
    super.dispose();
  }

  void _takt(Duration jetzt) {
    final dt = _letzte == null ? 1 / 60 : (jetzt - _letzte!).inMicroseconds / 1e6;
    _letzte = jetzt;
    if (_logisch.isEmpty) return;
    // Physische Größe wie die Engine sie nutzt (bei gebrochenem Pixelverhältnis gerundet).
    final pw = (_logisch.width * _dpr).round(), ph = (_logisch.height * _dpr).round();
    spiel.groesse(pw, ph);
    final t0 = _uhr.elapsedMicroseconds;
    spiel.tick(dt, eingabe);
    final t1 = _uhr.elapsedMicroseconds;
    final s = spiel.skala!;
    final w = spiel.welt, u = spiel.ui;
    if (_weltRgba?.length != w.width * w.height * 4) _weltRgba = Uint8List(w.width * w.height * 4);
    if (_uiRgba?.length != u.width * u.height * 4) _uiRgba = Uint8List(u.width * u.height * 4);
    w.toRgba(_weltRgba!);
    u.toRgba(_uiRgba!);
    _welt.liefere(_weltRgba!, s.weltW, s.weltH, _neu);
    _ui.liefere(_uiRgba!, s.uiW, s.uiH, _neu);
    if (_messen) {
      final t2 = _uhr.elapsedMicroseconds;
      _sumSpiel += (t1 - t0) / 1000;
      _sumRgba += (t2 - t1) / 1000;
      if (++_messBilder == 120) {
        debugPrint('BSMESS $s · Spiel ${(_sumSpiel / 120).toStringAsFixed(2)} ms · RGBA+Übergabe '
            '${(_sumRgba / 120).toStringAsFixed(2)} ms · Weg ${_welt.weg} · verworfen ${_welt.verworfen}');
        _sumSpiel = _sumRgba = 0;
        _messBilder = 0;
      }
    }
  }

  void _neu() {
    if (mounted) setState(() => _version++);
  }

  // ------------------------------------------------------------ Eingabe

  Offset _uiPunkt(Offset logisch) {
    final k = spiel.skala?.kUi ?? 1;
    return logisch * _dpr / k.toDouble();
  }

  void _zeiger(PointerEvent e, ZeigerArt art) {
    final p = _uiPunkt(e.localPosition);
    eingabe.zeiger.add(ZeigerEreignis(e.pointer, art, p.dx, p.dy, maus: e.kind == PointerDeviceKind.mouse));
  }

  KeyEventResult _taste(FocusNode node, KeyEvent e) {
    final tasten = tastenFuer(e.logicalKey);
    if (tasten.isEmpty) return KeyEventResult.ignored;
    for (final t in tasten) {
      if (e is KeyDownEvent) eingabe.tasteRunter(t);
      if (e is KeyUpEvent) eingabe.tasteHoch(t);
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    _dpr = MediaQuery.devicePixelRatioOf(context);
    return ColoredBox(
      color: Colors.black,
      child: Focus(
        focusNode: _fokus,
        autofocus: true,
        onKeyEvent: _taste,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) {
            _fokus.requestFocus();
            _zeiger(e, ZeigerArt.runter);
          },
          onPointerMove: (e) => _zeiger(e, ZeigerArt.bewegt),
          onPointerUp: (e) => _zeiger(e, ZeigerArt.hoch),
          onPointerCancel: (e) => _zeiger(e, ZeigerArt.abbruch),
          onPointerSignal: (e) {
            if (e is PointerScrollEvent) eingabe.rad += e.scrollDelta.dy;
          },
          child: LayoutBuilder(builder: (context, c) {
            _logisch = c.biggest;
            return CustomPaint(
              size: c.biggest,
              painter: _Maler(_welt.bild, _ui.bild, spiel.skala, _dpr, _version),
            );
          }),
        ),
      ),
    );
  }
}

class _Maler extends CustomPainter {
  _Maler(this.welt, this.oben, this.skala, this.dpr, this.version);
  final dui.Image? welt, oben;
  final Skalierung? skala;
  final double dpr;
  final int version;

  @override
  void paint(Canvas canvas, Size size) {
    final s = skala;
    if (s == null) return;
    canvas.save();
    canvas.scale(1 / dpr);
    final p = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;
    void zeichne(dui.Image? b, int k) {
      if (b == null) return;
      canvas.drawImageRect(
        b,
        Rect.fromLTWH(0, 0, b.width.toDouble(), b.height.toDouble()),
        Rect.fromLTWH(0, 0, (b.width * k).toDouble(), (b.height * k).toDouble()),
        p,
      );
    }

    zeichne(welt, s.kWelt);
    zeichne(oben, s.kUi);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_Maler old) => old.version != version;
}
