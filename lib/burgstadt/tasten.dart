import 'package:flutter/services.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Tastaturbelegung (Deutsch/Englisch-Layout über logische Tasten).
List<Taste> tastenFuer(LogicalKeyboardKey k) {
  if (k == LogicalKeyboardKey.keyW) return [Taste.hoch];
  if (k == LogicalKeyboardKey.arrowUp) return [Taste.hoch];
  if (k == LogicalKeyboardKey.keyS || k == LogicalKeyboardKey.arrowDown) return [Taste.runter];
  if (k == LogicalKeyboardKey.keyA) return [Taste.links];
  if (k == LogicalKeyboardKey.keyD) return [Taste.rechts];
  if (k == LogicalKeyboardKey.arrowLeft) return [Taste.drehLinks];
  if (k == LogicalKeyboardKey.arrowRight) return [Taste.drehRechts];
  if (k == LogicalKeyboardKey.keyE) return [Taste.aktion];
  if (k == LogicalKeyboardKey.keyF || k == LogicalKeyboardKey.keyL) return [Taste.licht];
  if (k == LogicalKeyboardKey.keyQ) return [Taste.blick];
  if (k == LogicalKeyboardKey.tab) return [Taste.akte, Taste.tab];
  if (k == LogicalKeyboardKey.keyM) return [Taste.karte];
  if (k == LogicalKeyboardKey.escape || k == LogicalKeyboardKey.goBack) return [Taste.menue, Taste.zurueck];
  if (k == LogicalKeyboardKey.backspace) return [Taste.zurueck];
  if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) return [Taste.bestaetigen];
  if (k == LogicalKeyboardKey.space) return [Taste.bestaetigen, Taste.aktion];
  if (k == LogicalKeyboardKey.shiftLeft || k == LogicalKeyboardKey.shiftRight) return [Taste.rennen];
  return const [];
}
