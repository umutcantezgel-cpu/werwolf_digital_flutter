import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// WLAN-Spiel auf Sitzungsebene: Gastgeber-Sitzung (Fall gehört dem Raum) und Gast-Spiegel,
/// verbunden ohne Netz über denselben [BurgstadtRaum] wie im Raum-Host. Die Netzschicht
/// selbst (WebSocket, 4/8/20 Teilnehmer) prüft room_host/test/mp_sim.dart.
void main() {
  late Spiel spiel;
  late BurgstadtRaum raum;
  late Fallsitzung gastgeber, gast;

  /// Was der Raum-Host im Takt verschickt, kommt beim Gast an.
  void takt([int n = 1]) {
    for (var i = 0; i < n; i++) {
      raum.tick(1 / 30);
      final e = raum.ereignisseFuer('S1');
      if (e.isNotEmpty) gast.empfange({'t': 'ereignisse', 'liste': e});
      gast.empfange({'t': 'zustand', ...raum.zustandFuer('S1')});
    }
  }

  setUp(() {
    spiel = Spiel()..groesse(640, 360);
    ladeAusRepo(spiel);
    raum = BurgstadtRaum(spiel.fallDaten!, spiel.stadt, bewohner: spiel.bewohnerDaten, haeuser: spiel.haeuserDaten, tempo: 2);
    raum
      ..beitreten('H', 'Gastgeberin')
      ..verbunden('H', true)
      ..beitreten('S1', 'Gast')
      ..verbunden('S1', true)
      ..nachricht('H', {'art': 'start', 'n': 4});
    gastgeber = Fallsitzung.imRaum(raum, 'H', spiel.teile, spiel.karten);
    gast = Fallsitzung.alsGast(spiel.fallDaten!, spiel.stadt, raum.zustandFuer('S1'), spiel.teile, spiel.karten,
        bewohner: spiel.bewohnerDaten, haeuser: spiel.haeuserDaten)
      ..senden = (m) => raum.nachricht('S1', m);
  });

  test('Rollen: Gastgeber ist Detektiv, Gast hat eine Rolle; Detektiv ist für den Gast eine Figur', () {
    expect(gastgeber.ich, FallZustand.detektiv);
    expect(gastgeber.modus, Modus.gastgeber);
    expect(gast.ich, raum.rolleVon['S1']);
    expect(gast.ich, isNot(FallZustand.detektiv));
    expect(gast.figuren.karten.containsKey(FallZustand.detektiv), isTrue, reason: 'DET wird für Mitspieler gebacken');
    expect(gastgeber.figuren.karten.containsKey(FallZustand.detektiv), isFalse, reason: 'die eigene Figur nicht');
  });

  test('Untersuchen und Teilen gehen über den Raum; der Spiegel des Gastes stimmt mit dem Raum überein', () {
    takt(3);
    final f = raum.fall!;
    // Eine Station mit einem Hinweis der Phase 1 im Spiel suchen
    final st = f.daten.hinweise.values.firstWhere((h) => h.station != null && h.station != 'BW' && h.phase <= 1 && h.min <= 4).station!;
    expect(gast.untersuche(st), isEmpty, reason: 'im Netz kommen Funde als Ereignis');
    takt();
    expect(gast.fall.wissen[gast.ich], equals(f.wissen[gast.ich]));
    expect(gast.anzeige.where((e) => e.art == 'fund'), isNotEmpty);
    final h = gast.anzeige.firstWhere((e) => e.art == 'fund').hinweis!;
    // Gast teilt an den Detektiv: kommt beim Gastgeber an
    gast.teile(FallZustand.detektiv, h);
    takt();
    gastgeber.tick(1 / 30);
    expect(f.wissen[FallZustand.detektiv], contains(h));
    expect(gastgeber.anzeige.where((e) => e.art == 'teilen' && e.hinweis == h), isNotEmpty);
    // Gastgeber heftet an die Akte: Spiegel des Gastes zeigt sie
    gastgeber.teile('akte', h);
    takt();
    expect(gast.fall.akte, contains(h));
  });

  test('Lagerunde: Gast entscheidet seine Rolle, Detektiv wählt, nächste Phase kommt beim Gast an', () {
    final f = raum.fall!;
    var i = 0;
    while (f.abschnitt != Abschnitt.lagerunde && i++ < 30 * 60 * 10) {
      takt();
    }
    expect(f.abschnitt, Abschnitt.lagerunde);
    expect(gast.fall.abschnitt, Abschnitt.lagerunde);
    final meine = gast.fall.rollenEntscheidungen().where((e) => e.rolle == gast.ich).toList();
    for (final e in meine) {
      gast.waehleRolle(e.id, 0);
    }
    takt(2); // Bots entscheiden im Takt
    expect(f.rollenEntscheidungen(), isEmpty);
    for (final e in meine) {
      expect(f.rollenWahl[e.id], 0);
    }
    gastgeber.weiter();
    expect(f.abschnitt, Abschnitt.detektivWahl);
    for (final d in f.detektivEntscheidungen()) {
      expect(gastgeber.waehleDetektiv(d.id, 'A'), isNotEmpty);
    }
    final phase = f.phase;
    gastgeber.weiter();
    takt();
    expect(gast.fall.phase, phase + 1);
    expect(gast.fall.detektivWahl, equals(f.detektivWahl));
    expect(gast.fall.punkte, f.punkte);
  });

  test('Gast-Erkundung läuft im Spiel: zeichnet, sendet Position, sieht den Detektiv', () {
    final erk = Erkundung(sitzung: gast);
    spiel.wechsle(erk);
    final e = Eingabe();
    for (var n = 0; n < 60; n++) {
      spiel.tick(1 / 30, e);
      takt();
    }
    gast.figuren.alleBacken();
    final fig = raum.sim!.figuren[gast.ich]!;
    expect(fig.bereich, erk.ort, reason: 'die eigene Lage kommt beim Gastgeber an');
    // Der Detektiv steht im selben Bereich: im Spiegel sichtbar
    final det = raum.sim!.figuren[FallZustand.detektiv]!;
    if (det.bereich == erk.ort) expect(gast.sim.figuren[FallZustand.detektiv]!.bereich, erk.ort);
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    expect(countOffPalette(rgba), 0);
  });

  test('WLAN-Bildschirm: quer und hoch nur Palettenfarben und volle Pixelblöcke', () {
    for (final (w, h) in const [(1280, 720), (1080, 2400)]) {
      final sp = Spiel()..groesse(w, h);
      ladeAusRepo(sp);
      sp.wlan = _OhneNetz();
      sp.wechsle(WlanBildschirm());
      final e = Eingabe();
      for (var i = 0; i < 3; i++) {
        sp.tick(1 / 30, e);
      }
      final rgba = komponiere(sp.welt, sp.ui, sp.skala!);
      expect(countOffPalette(rgba), 0, reason: '${w}x$h');
      expect(blockTest(rgba, w, h, sp.skala!.kUi).ratio, 1.0, reason: '${w}x$h');
    }
  });
}

/// Anbindung ohne Netz (nur für den Bildtest).
class _OhneNetz implements WlanAnbindung {
  @override
  bool get kannGastgeben => true;
  @override
  Future<(String, List<String>, String)> eroeffne(BurgstadtRaum raum, String name) async => ('ABCD', ['192.168.1.5:47100'], 'H');
  @override
  Future<void> beitreten(String adresse, String code, String name,
      {required void Function(Map<String, Object?> nachricht) empfang, required void Function(String grund) getrennt}) async {}
  @override
  void senden(Map<String, Object?> nachricht) {}
  @override
  Future<void> schliessen() async {}
}
