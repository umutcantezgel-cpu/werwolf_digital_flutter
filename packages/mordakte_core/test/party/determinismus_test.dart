// F-07: Determinismus: gleicher Fall-Code und gleiche Eingaben ergeben dasselbe Ende und dieselbe Bausteinfolge.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Ergebnis eines durchgespielten Abends.
typedef Abend = ({String ende, List<String> bausteine});

/// [anzahl] Fall-Codes aus einem Rng mit festem [startwert], in fester Reihenfolge.
List<FallCode> erzeugeCodes(int anzahl, int startwert) {
  final rng = Rng(startwert);
  return [for (var i = 0; i < anzahl; i++) FallCode.zufall(rng)];
}

/// Spielt einen Abend mit [code] von titel bis ende durch. Alle Wahlen (Optionen,
/// Stimmen, Anklage) kommen aus einem Rng mit festem Seed, der aus [eingabe] und
/// dem Code gebildet wird.
Abend spieleAbend(FallCode code, {int eingabe = 1}) {
  final s = Spiel(kanon)..weiter();
  s.einrichten(Einstellungen(rollen: 7, detektiv: 'w', code: code));
  final rng = Rng(Rng.hashString('eingaben:$eingabe:${code.code}'));
  final kern = kanon.kernverdaechtige;
  for (var schritt = 0; s.phase != PartyPhase.ende; schritt++) {
    if (schritt > 100) throw StateError('Abend bleibt in ${s.phase} hängen');
    switch (s.phase) {
      case PartyPhase.entscheidungen:
        for (final e in s.ermittlung.runde(s.runde)) {
          s.waehle(e.id, e.optionen[rng.nextInt(e.optionen.length)].id);
        }
      case PartyPhase.gruppenwahl:
        s.abstimmen(kooperativ: rng.nextInt(s.einstellungen.rollen), taeterSabotiert: rng.nextInt(2) == 1);
      case PartyPhase.anklage:
        s.anklagen(kern[rng.nextInt(kern.length)]);
      default:
        break;
    }
    s.weiter();
  }
  return (ende: s.ende.id, bausteine: List.of(s.bausteine));
}

bool gleicheListe(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void main() {
  test('gleicher Code, gleicher Pfad: 1.000 Codes geben zweimal denselben Seed und Pfad', () {
    for (final c in erzeugeCodes(1000, 20261009)) {
      final a = FallCode.lesen(c.code)!;
      final b = FallCode.lesen(c.code)!;
      expect(a.seed, c.seed, reason: c.code);
      expect(b.seed, a.seed, reason: c.code);
      expect(b.pfad(kanon.pfade), a.pfad(kanon.pfade), reason: c.code);
    }
  });

  test('Codes verteilen sich auf alle vier Pfade: je mindestens 150 von 1.000', () {
    final zaehl = {for (final p in kanon.pfade) p: 0};
    for (final c in erzeugeCodes(1000, 20261009)) {
      final p = c.pfad(kanon.pfade);
      zaehl[p] = zaehl[p]! + 1;
    }
    expect(zaehl.keys, unorderedEquals(kanon.pfade));
    for (final e in zaehl.entries) {
      expect(e.value, greaterThanOrEqualTo(150), reason: e.key);
    }
  });

  test('Eingabe wird normalisiert: Kleinbuchstaben, Leerzeichen und Bindestriche', () {
    final soll = FallCode.lesen('PRT3W')!;
    for (final eingabe in ['prt3w', ' PRT3W ', 'PRT-3W', 'p r t - 3 w', 'prt-3w']) {
      expect(FallCode.lesen(eingabe)?.code, soll.code, reason: '„$eingabe“');
    }
  });

  test('falsche Länge oder Zeichen außerhalb des Alphabets ergeben null', () {
    for (final eingabe in ['', 'PRT3', 'PRT3WX', 'PRT3W1']) {
      expect(FallCode.lesen(eingabe), isNull, reason: '„$eingabe“');
    }
    for (final z in '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_.'.split('')) {
      if (FallCode.alphabet.contains(z)) continue;
      expect(FallCode.lesen('PRT3$z'), isNull, reason: z);
      expect(FallCode.lesen('${z}RT3W'), isNull, reason: z);
      expect(FallCode.lesen('PRT3${z.toLowerCase()}'), isNull, reason: 'klein $z');
    }
  });

  test('fuerPfad trifft den Pfad: für alle vier Pfade ist fuerPfad(p).pfad == p', () {
    for (final p in kanon.pfade) {
      final code = FallCode.fuerPfad(p, kanon.pfade);
      expect(code.pfad(kanon.pfade), p, reason: p);
    }
  });

  test('1.000 Wiederholungen desselben Abends: gleiches Ende, gleiche Bausteinfolge', () {
    final code = FallCode.lesen('PRT3W')!;
    final erster = spieleAbend(code);
    expect(erster.bausteine.first, 'intro.start');
    expect(erster.bausteine, contains('anklage.start'));
    for (var lauf = 2; lauf <= 1000; lauf++) {
      final wieder = spieleAbend(code);
      expect(wieder.ende, erster.ende, reason: 'Lauf $lauf');
      expect(wieder.bausteine, erster.bausteine, reason: 'Lauf $lauf');
    }
  });

  test('200 verschiedene Codes: jeder Abend zweimal gespielt ergibt dasselbe Ergebnis', () {
    final liste = erzeugeCodes(200, 20261010);
    expect(liste.map((c) => c.code).toSet(), hasLength(200));
    for (final code in liste) {
      final a = spieleAbend(code);
      final b = spieleAbend(code);
      expect(b.ende, a.ende, reason: code.code);
      expect(b.bausteine, a.bausteine, reason: code.code);
    }
  });

  test('Rot-Probe: eine andere Eingabefolge ergibt andere Bausteine, der Vergleich kann scheitern', () {
    var verschieden = 0;
    for (final code in erzeugeCodes(200, 20261010)) {
      final mit1 = spieleAbend(code);
      final mit2 = spieleAbend(code, eingabe: 2);
      if (!gleicheListe(mit1.bausteine, mit2.bausteine)) verschieden++;
    }
    expect(verschieden, greaterThan(0), reason: 'bei keinem Code unterscheidet sich die Bausteinfolge');
  });
}
