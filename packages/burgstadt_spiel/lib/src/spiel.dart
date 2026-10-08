import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'bildschirme/hauptmenue.dart';
import 'optionen.dart';
import 'skalierung.dart';
import 'ton.dart';
import 'fallsitzung.dart';
import 'figuren_lager.dart';
import 'spuren_geometrie.dart';
import 'welt_geometrie.dart';

/// Ein Bildschirm des Spiels (Hauptmenü, Erkundung, Fallakte …).
abstract class Bildschirm {
  /// Zeigt der Bildschirm die 3D-Welt im Hintergrund?
  bool get zeigtWelt => true;

  /// Menü-Navigation per Pfeiltasten/Gamepad (im Spiel-HUD aus, dort steuern die Tasten das Gehen).
  bool get menueNavigation => true;
  void tick(Spiel spiel, double dt, Eingabe e) {}

  /// Beim Wechsel auf diesen Bildschirm (Musik, Umgebungston).
  void betreten(Spiel spiel) {}
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

  /// Die Welt (Burg-Komplex; Stadt folgt) und ihre Geometrie je Bereich.
  Welt stadt = Welt(baueBurg());

  /// Welt aus Daten setzen (Burg + Innenräume + Marktplatz); Geometrie wird neu gebaut.
  void setzeWelt(Map<String, Bereich> bereiche) {
    stadt = Welt(bereiche);
    _geometrie.clear();
    spuren = burgSpuren(stadt.bereiche);
    _spurMeshes.clear();
  }
  final Map<String, BereichGeometrie> _geometrie = {};
  late final List<IndexedTexture> texturen = [...baueAlleTexturen(), ...baueSpurTexturen()];

  /// Spuren der Sichtschichten (Detektivblick) und ihre Meshes je Bereich/Phase.
  late List<Spur> spuren = burgSpuren(stadt.bereiche);
  final Map<String, Mesh?> _spurMeshes = {};

  /// Falldaten (Kanon), Figurenteile und -karten – setzt die App-Hülle bzw. das Werkzeug.
  FallDaten? fallDaten;
  final Map<String, Teil> teile = {...kTeileBasis};
  final Map<String, Figurenkarte> karten = {};
  int besetzung = 4;

  /// Neue Solo-Fallsitzung (Detektiv = Spieler, Rollen = Bots).
  Fallsitzung? starteFall({int seed = 7, double tempo = 65 / 480}) {
    final d = fallDaten;
    if (d == null) return null;
    return Fallsitzung.starte(d, stadt, besetzung, teile, karten, seed: seed, tempo: tempo);
  }

  BereichGeometrie geometrie(String id) => _geometrie.putIfAbsent(id, () => BereichGeometrie(stadt.bereiche[id]!));

  /// Tonausgabe (App-Hülle setzt die echte).
  Tonausgabe ton = MerkendeTonausgabe();

  /// Wird bei Aktionen gerufen, die die App-Hülle ausführt: `klassisch`, `beenden`.
  void Function(String aktion)? beiAktion;

  double zeit = 0;
  int bilder = 0;

  Spiel({Optionen? optionen}) : optionen = optionen ?? Optionen() {
    bildschirm = Hauptmenue();
  }

  /// Startet Ton des aktuellen Bildschirms (nach dem Setzen von [ton]).
  void starteTon() {
    ton.gesamt(optionen.lautstaerke / 10);
    bildschirm.betreten(this);
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
    _renderer = Renderer(welt, licht, texturen);
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
    b.betreten(this);
  }

  void oeffne(Bildschirm b) {
    _stapel.add(bildschirm);
    bildschirm = b;
    b.betreten(this);
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
    final unten = _stapel.isEmpty ? null : _stapel.last;
    if (b.zeigtWelt) {
      bildschirm.zeichneWelt(this);
    } else if (unten != null && unten.zeigtWelt) {
      unten.zeichneWelt(this); // Menü über dem Spiel: Welt bleibt sichtbar
    } else {
      welt.clear(Pal.black);
    }
    bildschirm.zeichneUi(this, pixelUi);
    if (pixelUi.ausgeloestImBild > 0) ton.spiele('ui_klick', lautstaerke: 0.6);
    e.bildEnde();
  }

  /// Zeichnet den Bereich [id] aus der aktuellen Kamera (Himmel nur draußen),
  /// dazu die Figuren der Sitzung [s] in diesem Bereich (außer dem Detektiv).
  void zeichneBereich(String id, {Fallsitzung? s, bool blick = false}) {
    final r = renderer;
    final b = stadt.bereiche[id]!;
    final g = geometrie(id);
    if (b.innen) {
      r.fogStart = 3;
      r.fogEnd = 20;
      r.groundFog = 0;
    } else {
      r.fogStart = 8;
      r.fogEnd = 46;
      r.groundFog = 0.25;
    }
    r.begin();
    if (b.innen) {
      welt.clear(Pal.black);
    } else {
      r.drawSky();
    }
    for (final m in g.meshes) {
      r.drawMesh(m);
    }
    if (s != null) {
      final c = r.camera;
      for (final f in s.sim.figuren.values) {
        if (f.id == 'DET' || f.bereich != id) continue;
        final richtung = FigurenLager.richtung(f.yaw, f.x, f.z, c.x, c.z);
        final bild = s.figuren.bild(f.id, f.animation, f.animZeit, richtung);
        if (bild == null) continue;
        final (w, k) = g.licht(f.x, 1.0, f.z);
        r.drawSprite(bild, f.x, 0, f.z, warm: w, cold: k);
      }
    }
    if (blick) {
      // Detektivblick: Welt entsättigen, dann Spuren leuchtend darüber (mit Tiefentest)
      final c = welt.color;
      for (var i = 0; i < c.length; i++) {
        c[i] = blickFilter[c[i]];
      }
      final phase = s?.fall.phase ?? 1;
      final m = _spurMeshes.putIfAbsent('$id|$phase', () => baueSpurenMesh(spuren, id, phase, 'detektiv', TexturId.values.length));
      if (m != null) {
        final alt = r.ambientCold;
        r.ambientCold = 0.6;
        r.drawMesh(m);
        r.ambientCold = alt;
      }
    }
  }
}
