import 'package:feinkorn/feinkorn.dart';
import 'package:test/test.dart';

/// Tests der Blockdaten (Blockkoerper, Farbtafel, Materialtabelle).
/// Erwartungswerte sind aus Volumen, Abschnittsgrößen (32³) und dem Doku-Kommentar hergeleitet,
/// nicht aus dem Code abgelesen. Ein voller Abschnitt belegt 32·32·32 = 32768 Byte.
const _abschnittVoll = 32 * 32 * 32;

const _namen = [
  'Sandstein', 'Kalkmörtel', 'Eiche', 'Eisen', 'Messing', 'Glas', 'Wachs',
  'Stoff', 'Leder', 'Porzellan', 'Papier', 'Ruß', 'Staub', 'Erde',
];

Blockkoerper _koerper(int breite, int tiefe, int hoehe) =>
    Blockkoerper(blockgroesse: 0.1, breite: breite, tiefe: tiefe, hoehe: hoehe);

/// Zählt belegte Blöcke durch Abtasten jeder Zelle des Körpers (unabhängig von bloecke und jederBlock).
int _abgetastetBelegt(Blockkoerper k) {
  var n = 0;
  for (var z = 0; z < k.hoehe; z++) {
    for (var y = 0; y < k.tiefe; y++) {
      for (var x = 0; x < k.breite; x++) {
        if (k.wert(x, y, z) != 0) n++;
      }
    }
  }
  return n;
}

/// Gemischter Körper 40 × 40 × 70 Blöcke mit Ergebnis 67073 belegten Blöcken:
/// Abschnitt (0,0,0) einheitlich (32768), Abschnitt (0,0,1) einheitlich (32768),
/// Abschnitt (1,1,1) teilweise voll (1536 von 2048 Zellen, Lücken wo (x+y+z)%4 == 0),
/// ein Einzelblock am Rand in Abschnitt (1,0,2), alle übrigen Abschnitte leer.
Blockkoerper _gemischt() {
  final k = _koerper(40, 40, 70);
  k.fuelle(0, 0, 0, 32, 32, 32, 2);
  k.fuelle(0, 0, 32, 32, 32, 64, 6);
  for (var z = 32; z < 64; z++) {
    for (var y = 32; y < 40; y++) {
      for (var x = 32; x < 40; x++) {
        k.setze(x, y, z, (x + y + z) % 4);
      }
    }
  }
  k.setze(35, 3, 66, 4);
  return k;
}

int _zyxSchluessel((int, int, int) p) => (p.$3 * 1024 + p.$2) * 1024 + p.$1;

void main() {
  group('Blockkoerper: leerer Körper', () {
    test('bloecke ist 0', () {
      expect(_koerper(40, 33, 70).bloecke, 0);
    });

    test('wert ist 0 überall im Körper und außerhalb', () {
      final k = _koerper(40, 33, 70);
      expect(_abgetastetBelegt(k), 0);
      const ausserhalb = <(int, int, int)>[
        (-1, 0, 0), (0, -1, 0), (0, 0, -1), (40, 0, 0), (0, 33, 0), (0, 0, 70), (40, 33, 70), (-100, 5000, 7),
      ];
      for (final p in ausserhalb) {
        expect(k.wert(p.$1, p.$2, p.$3), 0, reason: 'Punkt $p');
      }
    });

    test('jederBlock besucht keinen Block', () {
      var besuche = 0;
      _koerper(40, 33, 70).jederBlock((x, y, z, w) {
        besuche++;
      });
      expect(besuche, 0);
    });

    test('leer: nur 1 Byte Kopf je Abschnitt (E-F019, Befund K0-TESTSCHREIBER-01)', () {
      // 64³ Körper = 8 Abschnitte, alle leer. Der Code zählt je Abschnitt 1 Byte (Einheitlich-Feld).
      expect(_koerper(64, 64, 64).speicherBytes, 8);
    });
  });

  group('Blockkoerper: setze und wert', () {
    // Körper 70 × 70 × 70: Abschnitte 0..31, 32..63, 64..69. Pro Achse die Grenzen 0, 31, 32, 33 und den Rand 69.
    const grenzen = [0, 31, 32, 33, 69];

    test('Rundreise an Ecken, Abschnittsgrenzen (31/32/33) und Rand liefert den gesetzten Wert', () {
      final k = _koerper(70, 70, 70);
      final erwartet = <(int, int, int), int>{};
      var n = 0;
      for (final z in grenzen) {
        for (final y in grenzen) {
          for (final x in grenzen) {
            n++; // 5³ = 125 Positionen, Werte 1..125 (alle ≤ 255)
            erwartet[(x, y, z)] = n;
            k.setze(x, y, z, n);
          }
        }
      }
      for (final e in erwartet.entries) {
        expect(k.wert(e.key.$1, e.key.$2, e.key.$3), e.value, reason: 'Block ${e.key}');
      }
      expect(k.bloecke, 125, reason: '5 × 5 × 5 gesetzte Blöcke, sonst nichts');
    });

    test('Überschreiben ersetzt den Wert, 0 räumt den Block', () {
      final k = _koerper(70, 70, 70);
      k.setze(5, 5, 5, 7);
      k.setze(5, 5, 5, 9);
      expect(k.wert(5, 5, 5), 9);
      expect(k.bloecke, 1);
      k.setze(5, 5, 5, 0);
      expect(k.wert(5, 5, 5), 0);
      expect(k.bloecke, 0);
    });

    test('setze außerhalb des Körpers hat keine Wirkung', () {
      final k = _koerper(70, 70, 70);
      k.setze(-1, 0, 0, 5);
      k.setze(0, -1, 0, 5);
      k.setze(0, 0, -1, 5);
      k.setze(70, 0, 0, 5);
      k.setze(0, 70, 0, 5);
      k.setze(0, 0, 70, 5);
      expect(k.bloecke, 0);
      expect(_abgetastetBelegt(k), 0);
    });
  });

  group('Blockkoerper: fuelle', () {
    test('ganze Abschnitte sind einheitlich: bloecke = Volumen, speicherBytes nur das Einheitlich-Feld', () {
      final k = _koerper(64, 64, 64); // 2 × 2 × 2 Abschnitte
      k.fuelle(0, 0, 0, 64, 64, 64, 3);
      expect(k.bloecke, 64 * 64 * 64);
      expect(k.speicherBytes, 8, reason: '8 einheitliche Abschnitte zu je 1 Byte, kein voller Abschnitt');
      expect(k.wert(0, 0, 0), 3);
      expect(k.wert(32, 31, 63), 3);
      expect(k.wert(63, 63, 63), 3);
    });

    test('Teilabschnitte werden voll: Quader 40³ in 64³ hat genau 40³ Blöcke', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 40, 40, 40, 5);
      expect(k.bloecke, 40 * 40 * 40);
      expect(_abgetastetBelegt(k), 40 * 40 * 40);
      // 1 ganz im Quader liegender Abschnitt (einheitlich), 7 Teilabschnitte (voll), 8 Einheitlich-Felder
      expect(k.speicherBytes, 7 * _abschnittVoll + 8);
    });

    test('Quader ist halboffen: x1, y1, z1 gehören nicht dazu', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 40, 40, 40, 5);
      expect(k.wert(0, 0, 0), 5);
      expect(k.wert(39, 39, 39), 5);
      expect(k.wert(40, 0, 0), 0);
      expect(k.wert(0, 40, 0), 0);
      expect(k.wert(0, 0, 40), 0);
    });

    test('Quader über den Körperrand wird auf den Körper beschnitten', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(-10, -10, -10, 10, 10, 10, 2); // im Körper liegt nur [0,10)³
      expect(k.bloecke, 1000);
      expect(k.wert(0, 0, 0), 2);
      expect(k.wert(9, 9, 9), 2);
      expect(k.wert(10, 0, 0), 0);
    });

    test('leerer Quader (x1 <= x0) ändert nichts', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(10, 10, 10, 10, 20, 20, 5);
      k.fuelle(20, 0, 0, 10, 5, 5, 5);
      expect(k.bloecke, 0);
    });

    test('Überlappendes Füllen: Teilabschnitt wird voll, Volumen bleibt exakt', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 64, 64, 64, 3);
      k.fuelle(10, 10, 10, 20, 20, 20, 4);
      expect(k.bloecke, 64 * 64 * 64);
      expect(k.wert(15, 15, 15), 4);
      expect(k.wert(9, 9, 9), 3);
      expect(k.wert(20, 20, 20), 3);
      expect(k.speicherBytes, _abschnittVoll + 8,
          reason: '1 voller Abschnitt (Abschnitt 0,0,0) + 7 einheitliche, 8 Einheitlich-Felder');
    });

    test('Füllen mit 0 räumt den Quader wieder', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 64, 64, 64, 3);
      k.fuelle(0, 0, 0, 64, 64, 64, 0);
      expect(k.bloecke, 0);
    });
  });

  group('Blockkoerper: Körperrand (Breite 40, zweiter Abschnitt in x nur teilweise im Körper)', () {
    test('ganzer Körper gefüllt: bloecke zählt nur die Blöcke im Körper', () {
      final k = _koerper(40, 32, 32);
      k.fuelle(0, 0, 0, 40, 32, 32, 7);
      expect(k.bloecke, 40 * 32 * 32); // 40960, nicht 64 × 32 × 32
      expect(_abgetastetBelegt(k), 40 * 32 * 32);
      expect(k.wert(39, 31, 31), 7);
      expect(k.wert(40, 0, 0), 0);
      // Abschnitt x 0..31 einheitlich, Randabschnitt x 32..39 ebenfalls einheitlich (im Körper ganz gefüllt): 2 Byte
      expect(k.speicherBytes, 2);
    });

    test('Randabschnitt mit 8 Spalten: bloecke = 8 × 32 × 32', () {
      final k = _koerper(40, 32, 32);
      k.fuelle(32, 0, 0, 40, 32, 32, 7);
      expect(k.bloecke, 8 * 32 * 32);
      expect(k.wert(31, 0, 0), 0);
      expect(k.wert(32, 0, 0), 7);
    });
  });

  group('Blockkoerper: setze in einheitlichen Abschnitt', () {
    test('wandelt ihn in einen vollen Abschnitt um, der Rest bleibt gleich', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 32, 32, 32, 3); // Abschnitt (0,0,0) einheitlich
      expect(k.speicherBytes, 8);
      k.setze(5, 5, 5, 9);
      expect(k.wert(5, 5, 5), 9);
      var abweichend = 0;
      for (var z = 0; z < 32; z++) {
        for (var y = 0; y < 32; y++) {
          for (var x = 0; x < 32; x++) {
            if ((x, y, z) != (5, 5, 5) && k.wert(x, y, z) != 3) abweichend++;
          }
        }
      }
      expect(abweichend, 0, reason: 'alle übrigen 32767 Blöcke des Abschnitts bleiben 3');
      expect(k.wert(32, 0, 0), 0, reason: 'Nachbarabschnitt unberührt');
      expect(k.bloecke, 32 * 32 * 32);
      expect(k.speicherBytes, _abschnittVoll + 8);
    });

    test('setze mit dem Einheitswert ändert den Inhalt nicht', () {
      final k = _koerper(64, 64, 64);
      k.fuelle(0, 0, 0, 32, 32, 32, 3);
      k.setze(1, 1, 1, 3);
      expect(k.wert(1, 1, 1), 3);
      expect(k.bloecke, 32 * 32 * 32);
    });
  });

  group('Blockkoerper: jederBlock', () {
    test('bloecke stimmt mit der Abtastung überein und ergibt 67073', () {
      final k = _gemischt();
      expect(k.bloecke, 67073, reason: '2 × 32768 (einheitlich) + 1536 (Muster) + 1 (Einzelblock)');
      expect(k.bloecke, _abgetastetBelegt(k));
    });

    test('besucht genau die belegten Blöcke, jeden einmal, mit dem richtigen Wert', () {
      final k = _gemischt();
      final besucht = <(int, int, int), int>{};
      var mehrfach = 0;
      k.jederBlock((x, y, z, w) {
        if (besucht.containsKey((x, y, z))) mehrfach++;
        besucht[(x, y, z)] = w;
      });
      expect(mehrfach, 0, reason: 'kein Block mehrfach');
      expect(besucht.length, 67073);

      var falscherWert = 0;
      for (final e in besucht.entries) {
        if (k.wert(e.key.$1, e.key.$2, e.key.$3) != e.value) falscherWert++;
      }
      expect(falscherWert, 0, reason: 'jeder besuchte Block trägt den Wert aus wert()');

      final fehlend = <(int, int, int)>[];
      for (var z = 0; z < k.hoehe; z++) {
        for (var y = 0; y < k.tiefe; y++) {
          for (var x = 0; x < k.breite; x++) {
            if (k.wert(x, y, z) != 0 && !besucht.containsKey((x, y, z))) fehlend.add((x, y, z));
          }
        }
      }
      expect(fehlend, isEmpty, reason: 'kein belegter Block ausgelassen');
    });

    test('Reihenfolge je Abschnitt z, y, x; Abschnitte werden nicht verschachtelt', () {
      final k = _gemischt();
      final folge = <(int, int, int)>[];
      k.jederBlock((x, y, z, w) {
        folge.add((x, y, z));
      });
      final gesehen = <int>{};
      int? letzterAbschnitt;
      (int, int, int)? letzter;
      var verschachtelt = 0;
      var unsortiert = 0;
      for (final p in folge) {
        final abschnitt = (p.$3 >> 5) * 1000000 + (p.$2 >> 5) * 1000 + (p.$1 >> 5);
        if (abschnitt != letzterAbschnitt) {
          if (!gesehen.add(abschnitt)) verschachtelt++;
          letzterAbschnitt = abschnitt;
        } else if (_zyxSchluessel(p) <= _zyxSchluessel(letzter!)) {
          unsortiert++;
        }
        letzter = p;
      }
      expect(verschachtelt, 0, reason: 'ein Abschnitt wird am Stück besucht');
      expect(unsortiert, 0, reason: 'innerhalb eines Abschnitts in z, y, x aufsteigend');
    });
  });

  group('Farbtafel', () {
    test('Index 0 ist Luft: die Tafel beginnt mit leerem Eintrag', () {
      final k = _koerper(8, 8, 8);
      expect(kLuft, 0);
      expect(k.tafel, hasLength(1));
      expect(k.tafel.first, isNull);
    });

    test('gleicher Eintrag ergibt gleichen Index, neue Einträge werden fortlaufend nummeriert', () {
      final k = _koerper(8, 8, 8);
      expect(k.eintrag(Farbeintrag.material(1)), 1);
      expect(k.eintrag(Farbeintrag.material(1)), 1, reason: 'gleicher Eintrag');
      expect(k.eintrag(const Farbeintrag(1, 0x123456)), 2,
          reason: 'gleiches Material, andere Farbe ist ein neuer Eintrag');
      expect(k.eintrag(Farbeintrag.material(3)), 3);
      expect(k.eintrag(const Farbeintrag(1, 0x9C8A6E)), 1, reason: 'Material 1 hat Grundfarbe 0x9C8A6E');
      expect(k.eintrag(const Farbeintrag(1, 0x123456)), 2);
      expect(k.tafel, hasLength(4));
    });

    test('Farbeintrag.material übernimmt Material und Grundfarbe', () {
      expect(Farbeintrag.material(3).material, 3);
      expect(Farbeintrag.material(3).farbe, 0x6B4A2E); // Eiche
      expect(Farbeintrag.material(3), const Farbeintrag(3, 0x6B4A2E));
    });

    test('255 Einträge sind erlaubt, der 256. wirft StateError', () {
      final k = _koerper(8, 8, 8);
      for (var n = 0; n < 255; n++) {
        expect(k.eintrag(Farbeintrag(1, n)), n + 1);
      }
      expect(k.tafel, hasLength(256));
      expect(() => k.eintrag(const Farbeintrag(1, 255)), throwsStateError);
      expect(k.tafel, hasLength(256), reason: 'der abgelehnte Eintrag wird nicht angelegt');
      expect(k.eintrag(const Farbeintrag(1, 254)), 255,
          reason: 'ein bekannter Eintrag bleibt auch bei voller Tafel nutzbar');
    });
  });

  group('Materialtabelle', () {
    test('14 Materialien mit Kennungen 1..14 in Reihenfolge', () {
      expect(kMaterialien, hasLength(14));
      expect([for (final m in kMaterialien) m.id], [for (var i = 1; i <= 14; i++) i]);
    });

    test('Namen in Reihenfolge', () {
      expect([for (final m in kMaterialien) m.name], _namen);
    });

    test('materialVon: Kennung 1..14 liefert das Material, 0 und Unbekanntes liefern null', () {
      for (var id = 1; id <= 14; id++) {
        expect(materialVon(id)?.name, _namen[id - 1]);
      }
      expect(materialVon(0), isNull);
      expect(materialVon(15), isNull);
      expect(materialVon(-1), isNull);
    });

    test('Zahlenwerte liegen in gültigen Bereichen (0..1, Dichte > 0, Farbe 0xRRGGBB)', () {
      // Doku: „Werte ohne Einheit liegen in 0..1“; Dichte in kg/m³ muss positiv sein.
      final verletzt = <String>[];
      for (final m in kMaterialien) {
        final felder = <String, double>{
          'streuung': m.streuung,
          'rauheit': m.rauheit,
          'haerte': m.haerte,
          'abprall': m.abprall,
          'reibung': m.reibung,
          'leuchten': m.leuchten,
        };
        for (final e in felder.entries) {
          if (!(e.value >= 0 && e.value <= 1)) verletzt.add('${m.name}.${e.key} = ${e.value}');
        }
        if (!(m.dichte > 0)) verletzt.add('${m.name}.dichte = ${m.dichte}');
        if (m.farbe < 0 || m.farbe > 0xFFFFFF) verletzt.add('${m.name}.farbe = ${m.farbe}');
      }
      expect(verletzt, isEmpty);
    });

    test('Schüttgut (Bruch koerner oder kruemel) hat boeschungGrad > 0', () {
      final schuettgut = kMaterialien
          .where((m) => m.bruch == Bruchmuster.koerner || m.bruch == Bruchmuster.kruemel)
          .toList();
      expect(schuettgut, isNotEmpty);
      expect([for (final m in schuettgut) if (!(m.boeschungGrad > 0)) m.name], isEmpty);
    });
  });

  group('Blockkoerper: einheitlicher Randabschnitt wird voll (Befund K1-OPUS-01)', () {
    test('setze in einheitlichen Randabschnitt: außerhalb des Körpers bleibt Luft, bloecke stimmt', () {
      final k = _koerper(40, 32, 4);
      k.fuelle(0, 0, 0, 40, 32, 4, 7);
      expect(k.bloecke, 40 * 32 * 4);
      k.setze(35, 3, 2, 0);
      expect(k.bloecke, 40 * 32 * 4 - 1);
      var n = 0;
      k.jederBlock((x, y, z, w) => n++);
      expect(n, 40 * 32 * 4 - 1);
    });
  });
}
