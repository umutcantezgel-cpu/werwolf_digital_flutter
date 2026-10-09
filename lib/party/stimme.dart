import 'stimme_stub.dart' if (dart.library.js_interop) 'stimme_web.dart';

export 'stimme_stub.dart' if (dart.library.js_interop) 'stimme_web.dart';

/// Erzählerstimme (Master 7.12): liest Bausteine mit einer lokalen Stimme vor,
/// wenn das Gerät eine deutsche hat. Sonst bleibt es beim Bildschirmtext.
abstract class Stimme {
  /// Gibt es auf diesem Gerät eine lokale deutsche Stimme?
  bool get verfuegbar;

  /// Liest [text] vor. `true`, wenn der Vortrag zu Ende ging.
  Future<bool> sprich(String text);

  /// Bricht das laufende Vorlesen ab.
  void stopp();

  /// Die Stimme dieses Geräts (Browser oder Stub ohne Stimme).
  static Stimme erzeugen() => erzeugeStimme();
}
