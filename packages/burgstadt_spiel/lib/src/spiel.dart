import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import 'bildschirme/hauptmenue.dart';
import 'optionen.dart';
import 'skalierung.dart';

/// Ein Bildschirm des Spiels (Hauptmenü, Erkundung, Fallakte …).
abstract class Bildschirm {
  /// Zeigt der Bildschirm die 3D-Welt im Hintergrund?
  bool get zeigtWelt => true;

  /// Menü-Navigation per Pfeiltasten/Gamepad (im Spiel-HUD aus, dort steuern die Tasten das Gehen).
  bool get menueNavigation => true;
  void tick(Spiel spiel, double dt, Eingabe e) {}
  void zeichneWelt(Spiel spiel) {}
  void zeichneUi(Spiel spiel, PixelUi ui);
}

/// Herz der Pixel-Darstellung: Größe, Bildschirme, Welt- und UI-Puffer.
/// Flutter-frei; die App-Hülle ruft [groesse] und [tick] und zeigt [welt]/[ui].
class Spiel {
  final Optionen optionen;
  final BitmapFont font = BitmapFont.parse(kSchriftNormal);
  late final PixelUi pixelUi = PixelUi(font);
  final LightTable licht = LightTable.night();

  Skalierung? skala;
  PixelBuffer welt = PixelBuffer(1, 1);
  PixelBuffer ui = PixelBuffer(1, 1);
  Renderer? _renderer;
  late Bildschirm bildschirm;
  final List<Bildschirm> _stapel = [];

  /// Prüfszene, bis die echte Welt (Phase 2) steht.
  late final DemoScene szene = DemoScene.build();

  /// Wird bei Aktionen gerufen, die die App-Hülle ausführt: `klassisch`, `beenden`.
  void Function(String aktion)? beiAktion;

  double zeit = 0;
  int bilder = 0;

  Spiel({Optionen? optionen}) : optionen = optionen ?? Optionen() {
    bildschirm = Hauptmenue();
  }

  Renderer get renderer => _renderer!;

  /// Physische Bildgröße (Gerätepixel) setzen; legt Puffer neu an, wenn nötig.
  void groesse(int physW, int physH) {
    final s = Skalierung.fuer(physW, physH, optionen.qualitaet);
    final alt = skala;
    if (alt != null && alt.weltW == s.weltW && alt.weltH == s.weltH && alt.uiW == s.uiW && alt.uiH == s.uiH) {
      skala = s;
      return;
    }
    skala = s;
    welt = PixelBuffer(s.weltW, s.weltH);
    ui = PixelBuffer(s.uiW, s.uiH);
    _renderer = Renderer(welt, licht, szene.textures);
    _sichtfeld();
  }

  void _sichtfeld() {
    final s = skala;
    if (s == null || _renderer == null) return;
    final fovX = optionen.sichtfeldGrad * math.pi / 180 * 1.25;
    final aspect = s.weltW / s.weltH;
    var fovY = optionen.sichtfeldGrad * math.pi / 180;
    // Hochkant: waagrechtes Sichtfeld halten, senkrechtes begrenzen.
    final ausX = 2 * math.atan(math.tan(fovX / 2) / aspect);
    if (ausX > fovY) fovY = math.min(ausX, 100 * math.pi / 180);
    renderer.camera.fovY = fovY;
  }

  void qualitaetSetzen(Qualitaet q) {
    optionen.qualitaet = q;
    final s = skala;
    if (s != null) {
      skala = null;
      groesse(s.physW, s.physH);
    }
  }

  void sichtfeldAktualisieren() => _sichtfeld();

  // ------------------------------------------------------------ Bildschirme

  void wechsle(Bildschirm b) {
    _stapel.clear();
    bildschirm = b;
  }

  void oeffne(Bildschirm b) {
    _stapel.add(bildschirm);
    bildschirm = b;
  }

  void schliesse() {
    if (_stapel.isNotEmpty) bildschirm = _stapel.removeLast();
  }

  // ------------------------------------------------------------ Bild

  /// Ein Bild: Eingabe auswerten, Welt und UI zeichnen. Leert die Einmal-Ereignisse.
  void tick(double dt, Eingabe e) {
    if (skala == null) return;
    dt = dt.clamp(0.0, 0.1);
    zeit += dt;
    bilder++;
    final b = bildschirm;
    pixelUi.navigation = b.menueNavigation;
    pixelUi.beginne(ui, e);
    b.tick(this, dt, e);
    if (b.zeigtWelt) {
      bildschirm.zeichneWelt(this);
    } else {
      welt.clear(Pal.black);
    }
    bildschirm.zeichneUi(this, pixelUi);
    e.bildEnde();
  }

  /// Standard-Welt: Himmel + Szene aus der aktuellen Kamera.
  void zeichneSzene({List<Mesh>? meshes}) {
    final r = renderer;
    r.begin();
    r.drawSky();
    for (final m in meshes ?? szene.meshes) {
      r.drawMesh(m);
    }
  }
}
