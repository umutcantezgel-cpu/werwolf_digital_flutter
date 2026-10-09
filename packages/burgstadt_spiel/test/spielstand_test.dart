import 'dart:convert';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Z-11: Speichern und Fortsetzen – derselbe Fall, dieselbe Lage, und es geht weiter bis zum Ende.
void main() {
  test('Spielstand: speichern, im Hauptmenü fortsetzen, gleicher Stand, weiterspielen', () {
    final spiel = Spiel()..groesse(640, 360);
    ladeAusRepo(spiel);
    final ablage = SpielstandImSpeicher();
    spiel.spielstand = ablage;
    final s = spiel.starteFall(tempo: 2)!;
    final erk = Erkundung(sitzung: s);
    spiel.wechsle(erk);
    final e = Eingabe();
    for (var i = 0; i < 30 * 20; i++) {
      spiel.tick(1 / 30, e);
    }
    erk
      ..x += 0.3
      ..yaw = 1.2;
    s.fall.untersuche('DET', 'BS-01');
    erk.speichern(spiel);
    expect(ablage.inhalt, isNotNull);
    final vorher = jsonEncode(s.fall.zuJson());

    // Neues Spiel-Objekt (App neu gestartet): Stand aus der Ablage laden
    final spiel2 = Spiel()..groesse(640, 360);
    ladeAusRepo(spiel2);
    spiel2.letzterStand = ablage.inhalt;
    final weiter = Erkundung.fortsetzen(spiel2)!;
    expect(jsonEncode(weiter.sitzung!.fall.zuJson()), vorher);
    expect(weiter.ort, erk.ort);
    expect(weiter.x, closeTo(erk.x, 1e-9));
    expect(weiter.yaw, 1.2);
    expect(weiter.sitzung!.sim.figuren['R01']!.x, closeTo(s.sim.figuren['R01']!.x, 1e-9));
    // Weiterspielen: die Uhr läuft, der Fall bleibt konsistent
    spiel2.wechsle(weiter);
    final uhr = weiter.sitzung!.fall.uhr;
    for (var i = 0; i < 30 * 10; i++) {
      spiel2.tick(1 / 30, e);
    }
    expect(weiter.sitzung!.fall.uhr, greaterThan(uhr));
  });

  test('Fremder oder alter Stand wird abgelehnt statt falsch geladen', () {
    final spiel = Spiel()..groesse(640, 360);
    ladeAusRepo(spiel);
    spiel.letzterStand = jsonEncode({
      'sitzung': {'schema': 0, 'daten': 'x', 'seed': 1, 'tempo': 1, 'fall': {}, 'figuren': {}},
      'ort': 'gewoelbe', 'x': 1, 'z': 1, 'yaw': 0, 'besucht': [], 'tutorial': [],
    });
    expect(Erkundung.fortsetzen(spiel), isNull);
  });
}
