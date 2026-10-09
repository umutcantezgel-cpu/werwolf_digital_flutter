import 'dart:async';

import 'package:gamepads/gamepads.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Gamepad über das Paket `gamepads` (normalisierte Tasten/Achsen, alle Plattformen).
/// Linker Stick gehen, rechter Stick umsehen; A bestätigen/Aktion, B zurück,
/// X Licht, Y Detektivblick, Start Menü, Select Fallakte, Steuerkreuz Menüs,
/// linker Stick drücken/LB rennen, RB Karte.
class GamepadEingabe {
  StreamSubscription<NormalizedGamepadEvent>? _abo;
  double _lx = 0, _ly = 0, _rx = 0, _ry = 0;
  final Map<GamepadButton, bool> _tasten = {};
  final List<(Taste, bool)> _ereignisse = [];

  bool get aktiv => _abo != null;

  void starte() {
    try {
      _abo = Gamepads.normalizedEvents.listen(_ereignis, onError: (_) {});
    } catch (_) {
      _abo = null;
    }
  }

  void _ereignis(NormalizedGamepadEvent e) {
    final a = e.axis;
    if (a != null) {
      switch (a) {
        case GamepadAxis.leftStickX:
          _lx = e.value;
        case GamepadAxis.leftStickY:
          _ly = e.value;
        case GamepadAxis.rightStickX:
          _rx = e.value;
        case GamepadAxis.rightStickY:
          _ry = e.value;
        default:
      }
      return;
    }
    final b = e.button;
    if (b == null) return;
    final unten = e.value > 0.5;
    if ((_tasten[b] ?? false) == unten) return;
    _tasten[b] = unten;
    for (final t in _taste(b)) {
      _ereignisse.add((t, unten));
    }
  }

  static List<Taste> _taste(GamepadButton b) => switch (b) {
        GamepadButton.a => const [Taste.bestaetigen, Taste.aktion],
        GamepadButton.b => const [Taste.zurueck],
        GamepadButton.x => const [Taste.licht],
        GamepadButton.y => const [Taste.blick],
        GamepadButton.start => const [Taste.menue],
        GamepadButton.back => const [Taste.akte],
        GamepadButton.dpadUp => const [Taste.hoch],
        GamepadButton.dpadDown => const [Taste.runter],
        GamepadButton.dpadLeft => const [Taste.links],
        GamepadButton.dpadRight => const [Taste.rechts],
        GamepadButton.leftStick || GamepadButton.leftBumper => const [Taste.rennen],
        GamepadButton.rightBumper => const [Taste.karte],
        _ => const [],
      };

  static double _tot(double v) => v.abs() < 0.18 ? 0 : (v - 0.18 * v.sign) / 0.82;

  /// Überträgt den Zustand in [e] (einmal je Bild vor dem Spiel-Takt).
  void anwenden(Eingabe e, double dt) {
    for (final (t, unten) in _ereignisse) {
      unten ? e.tasteRunter(t) : e.tasteHoch(t);
    }
    _ereignisse.clear();
    e.gehenX = _tot(_lx);
    e.gehenY = _tot(_ly);
    e.blickDx += _tot(_rx) * 2.4 * dt;
    e.blickDy += -_tot(_ry) * 1.6 * dt;
  }

  void dispose() => _abo?.cancel();
}
