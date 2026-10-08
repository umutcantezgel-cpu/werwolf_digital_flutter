import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Zentrale Haptik. Im Web blockiert der Browser `navigator.vibrate`, bis der Nutzer die Seite
/// berührt oder eine Taste gedrückt hat (und meldet jeden blockierten Aufruf als Konsolenfehler).
/// Deshalb schweigt die Haptik dort bis zur ersten Nutzergeste.
abstract final class Haptics {
  static bool _active = !kIsWeb;
  static bool _installed = false;

  /// Einmal nach `WidgetsFlutterBinding.ensureInitialized()` aufrufen.
  static void install() {
    if (_installed || _active) return;
    _installed = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  static void _onPointer(PointerEvent e) {
    // Touch zählt im Browser erst beim Loslassen als Nutzeraktivierung, Maus schon beim Drücken.
    if (e is PointerUpEvent || (e is PointerDownEvent && e.kind == PointerDeviceKind.mouse)) _activate();
  }

  static bool _onKey(KeyEvent e) {
    if (e is KeyDownEvent && e.logicalKey != LogicalKeyboardKey.escape) _activate();
    return false;
  }

  static void _activate() {
    if (_active) return;
    _active = true;
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    HardwareKeyboard.instance.removeHandler(_onKey);
  }

  static void light() {
    if (_active) HapticFeedback.lightImpact();
  }

  static void medium() {
    if (_active) HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (_active) HapticFeedback.heavyImpact();
  }

  static void selection() {
    if (_active) HapticFeedback.selectionClick();
  }
}
