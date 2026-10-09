import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

void main() {
  final baker = FigurBaker(kTeileBasis);
  const karte = Figurenkarte(id: 'probe', name: 'Probe', groesse: 1.7, materialien: {
    'haut': Material(7, 5), 'haar': Material(2, 3), 'oberteil': Material(6, 4), 'darunter': Material(0, 7),
    'hose': Material(2, 3), 'schuhe': Material(0, 2),
  }, teile: ['frisur-kurz', 'oberteil-strickjacke', 'schuhe-stiefel']);

  test('Brenner: alle Animationen, 8 Richtungen, Sprite-Prüfung ohne Befund', () {
    final satz = baker.backe(karte);
    expect(satz.bilder.keys, containsAll(['stehen', 'gehen', 'sprechen', 'untersuchen', 'erschrecken', 'zeigen']));
    expect(satz.bilder['gehen']!.length, 4);
    final befunde = pruefeFigur(satz);
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('Alle Basisteile lassen sich brennen und bestehen die Prüfung', () {
    for (final t in kTeileBasis.values) {
      final k = Figurenkarte(id: t.id, name: t.id, materialien: karte.materialien, teile: [t.id]);
      expect(pruefeKarte(k, kTeileBasis), isEmpty);
      final satz = baker.backe(k, animationen: ['stehen']);
      expect(pruefeFigur(satz), isEmpty, reason: t.id);
    }
  });

  test('Größe wirkt: Kind kleiner als Erwachsener', () {
    int hoehe(double g) {
      final s = baker.backeEinzel(Figurenkarte(id: 'g', name: 'g', groesse: g, materialien: karte.materialien, teile: const []),
          kAnimationen['stehen']!.first, 0);
      for (var y = 0; y < s.height; y++) {
        for (var x = 0; x < s.width; x++) {
          if (s.pixels[y * s.width + x] != kTransparent) return s.footY - y;
        }
      }
      return 0;
    }

    expect(hoehe(1.75), greaterThan(hoehe(1.2) + 10));
    expect(hoehe(1.75), inInclusiveRange(54, 66));
  });

  test('Augen nur von vorne sichtbar', () {
    int augen(int r) {
      final s = baker.backeEinzel(karte, kAnimationen['stehen']!.first, r);
      var oben = 0;
      while (s.pixels.sublist(oben * s.width, (oben + 1) * s.width).every((c) => c == kTransparent)) {
        oben++;
      }
      // nur im Kopfbereich zählen (Schuhe nutzen dieselbe dunkle Stufe)
      return s.pixels.sublist(oben * s.width, (oben + 14) * s.width).where((c) => c == Ramp.at(Ramp.neutral, 1)).length;
    }

    expect(augen(0), greaterThanOrEqualTo(2));
    expect(augen(4), lessThan(augen(0)));
  });
}
