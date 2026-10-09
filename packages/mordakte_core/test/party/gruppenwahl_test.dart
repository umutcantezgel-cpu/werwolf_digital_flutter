// F-08: Gruppenwahl – Struktur der Wahlen, Schwellen an den Grenzen 4 bis 20 Rollen, 36 Bonus-Hinweise.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Von Hand aus der Regel gerechnet: wahr ab 5·A ≥ 3·N, neutral ab 5·A ≥ 2·N.
/// Schlüssel N (Rollen); Wert (kleinste Stimmenzahl für neutral, kleinste für wahr).
const schwellenTabelle = <int, (int, int)>{
  4: (2, 3),
  5: (2, 3),
  6: (3, 4),
  7: (3, 5),
  8: (4, 5),
  9: (4, 6),
  10: (4, 6),
  11: (5, 7),
  12: (5, 8),
  13: (6, 8),
  14: (6, 9),
  15: (6, 9),
  16: (7, 10),
  17: (7, 11),
  18: (8, 11),
  19: (8, 12),
  20: (8, 12),
};

/// Abweichungen der Qualitätsstufen von der Tabelle an den Grenzen: die kleinste
/// Stimmenzahl erreicht die Stufe, eine Stimme weniger erreicht sie nicht.
List<String> schwellenAbweichungen(Gruppenwahl g, Map<int, (int, int)> tabelle) {
  final f = <String>[];
  for (final e in tabelle.entries) {
    final n = e.key;
    final (neutral, wahr) = e.value;
    final pruefungen = <(int, Qualitaet)>[
      (wahr, Qualitaet.wahr),
      (wahr - 1, Qualitaet.neutral),
      (neutral, Qualitaet.neutral),
      (neutral - 1, Qualitaet.falsch),
    ];
    for (final (stimmen, erwartet) in pruefungen) {
      final ist = g.qualitaet(stimmen, n);
      if (ist != erwartet) f.add('$n Rollen, $stimmen Stimmen: erwartet ${erwartet.name}, ist ${ist.name}');
    }
  }
  return f;
}

/// Gibt es eine Stimmverteilung (N aus der Tabelle, 0 bis N−1 kooperative Stimmen,
/// Täter wählt A oder B), die [q] ergibt?
bool erreichbar(Gruppenwahl g, Qualitaet q) {
  for (final n in schwellenTabelle.keys) {
    for (var k = 0; k < n; k++) {
      for (final sabotiert in [false, true]) {
        if (g.auswerten(rollen: n, kooperativ: k, taeterSabotiert: sabotiert) == q) return true;
      }
    }
  }
  return false;
}

void main() {
  late Gruppenwahl gruppe;
  setUpAll(() => gruppe = Gruppenwahl(kanon));

  group('Wahlen', () {
    test('je Figur und Runde genau eine Wahl mit Optionen a und b, insgesamt 60', () {
      expect(kanon.figuren, hasLength(20));
      expect(gruppe.wahlen, hasLength(60));
      for (final f in kanon.figuren) {
        for (var r = 1; r <= 3; r++) {
          final treffer = gruppe.wahlen.where((w) => w['rolle'] == f['id'] && w['runde'] == r).toList();
          expect(treffer, hasLength(1), reason: '${f['id']}, Runde $r');
          expect(treffer.single['a'], isA<Map>(), reason: '${f['id']}, Runde $r: Option a');
          expect(treffer.single['b'], isA<Map>(), reason: '${f['id']}, Runde $r: Option b');
        }
      }
    });

    test('quelle ist geheimnis oder loyalitaet', () {
      for (final w in gruppe.wahlen) {
        expect(w['quelle'], isIn(['geheimnis', 'loyalitaet']), reason: '${w['id']}');
      }
    });

    test('quelle loyalitaet kommt nur bei Figuren mit loyalitaet.zu vor', () {
      final loyal = gruppe.wahlen.where((w) => w['quelle'] == 'loyalitaet').toList();
      expect(loyal, isNotEmpty);
      for (final w in loyal) {
        final zu = (kanon.figur(w['rolle'] as String)?['loyalitaet'] as Map?)?['zu'];
        expect(zu, isNotNull, reason: '${w['id']}: Figur ${w['rolle']} hat kein loyalitaet.zu');
      }
    });

    test('genau die vier Kernrollen haben bTaeter mit art sabotage, alle anderen keinen', () {
      final kern = kanon.kernverdaechtige;
      expect(kern, hasLength(4));
      expect(gruppe.wahlen.where((w) => kern.contains(w['rolle'])), hasLength(12));
      for (final w in gruppe.wahlen) {
        if (kern.contains(w['rolle'])) {
          final t = w['bTaeter'] as Map?;
          expect(t, isNotNull, reason: '${w['id']}: bTaeter fehlt');
          expect(t?['art'], 'sabotage', reason: '${w['id']}');
        } else {
          expect(w['bTaeter'], isNull, reason: '${w['id']}: bTaeter ohne Kernrolle');
        }
      }
    });
  });

  group('Schwellen', () {
    test('Tabelle 4 bis 20 Rollen: an der Grenze erreicht A die Stufe, bei A−1 nicht', () {
      expect(schwellenTabelle.keys.toList(), [for (var n = 4; n <= 20; n++) n]);
      final abweichungen = schwellenAbweichungen(gruppe, schwellenTabelle);
      expect(abweichungen, isEmpty, reason: abweichungen.join('\n'));
    });

    test('0 kooperative Stimmen ergeben falsch, alle Stimmen ergeben wahr, bei jeder Rollenzahl', () {
      for (final n in schwellenTabelle.keys) {
        expect(gruppe.qualitaet(0, n), Qualitaet.falsch, reason: '$n Rollen, 0 Stimmen');
        expect(gruppe.qualitaet(n, n), Qualitaet.wahr, reason: '$n Rollen, $n Stimmen');
      }
    });

    test('Sabotage der Täterrolle zählt netto −1 und senkt die Stufe an der Grenze', () {
      // 4 Rollen, 2 kooperative Stimmen: Täter wählt A ergibt 3 (wahr), Sabotage ergibt 1 (falsch).
      expect(gruppe.auswerten(rollen: 4, kooperativ: 2, taeterSabotiert: false), Qualitaet.wahr);
      expect(gruppe.auswerten(rollen: 4, kooperativ: 2, taeterSabotiert: true), Qualitaet.falsch);
      // 10 Rollen, 6 kooperative Stimmen: Täter wählt A ergibt 7 (wahr), Sabotage ergibt 5 (neutral).
      expect(gruppe.auswerten(rollen: 10, kooperativ: 6, taeterSabotiert: false), Qualitaet.wahr);
      expect(gruppe.auswerten(rollen: 10, kooperativ: 6, taeterSabotiert: true), Qualitaet.neutral);
    });

    test('wirksame Stimmen werden bei Sabotage nie negativ', () {
      expect(Gruppenwahl.wirksam(kooperativ: 0, sabotage: true), 0);
      expect(Gruppenwahl.wirksam(kooperativ: 1, sabotage: true), 0);
    });

    test('Rot-Probe: erkennt veränderte Schwelle (wahr gegen 4), qualitaet(3, 5) ist dann nicht wahr', () {
      final veraendert = Kanon.lade((p) {
        final j = leseJson('$repoWurzel/content/party/schlosskeller/$p');
        if (p == 'fall.json') {
          final wahr = (j['schwellen'] as Map)['wahr'] as Map;
          wahr['gegen'] = 4;
        }
        return j;
      });
      final g = Gruppenwahl(veraendert);
      expect(g.qualitaet(3, 5), isNot(Qualitaet.wahr));
      expect(Gruppenwahl(kanon).qualitaet(3, 5), Qualitaet.wahr);
      expect(schwellenAbweichungen(g, schwellenTabelle), isNotEmpty);
    });
  });

  group('Bonus-Hinweise', () {
    test('36 Hinweise: je Pfad, Runde und Qualität genau einer', () {
      expect(gruppe.hinweise, hasLength(36));
      for (final p in kanon.pfade) {
        for (var r = 1; r <= 3; r++) {
          for (final q in Qualitaet.values) {
            final treffer = gruppe.hinweise
                .where((h) => h['pfad'] == p && h['runde'] == r && h['qualitaet'] == q.name)
                .toList();
            expect(treffer, hasLength(1), reason: '$p, Runde $r, ${q.name}');
            expect(gruppe.hinweis(p, r, q)['id'], treffer.single['id']);
          }
        }
      }
    });

    test('jeder Hinweis ist über eine Stimmverteilung erreichbar', () {
      for (final h in gruppe.hinweise) {
        final q = Qualitaet.values.byName(h['qualitaet'] as String);
        expect(erreichbar(gruppe, q), isTrue, reason: '${h['id']}: ${q.name} nicht erreichbar');
      }
    });

    test('sichtbar ist nur, ob die Gruppe zusammengehalten hat: nur wahr ergibt true', () {
      expect(Gruppenwahl.zusammengehalten(Qualitaet.wahr), isTrue);
      expect(Gruppenwahl.zusammengehalten(Qualitaet.neutral), isFalse);
      expect(Gruppenwahl.zusammengehalten(Qualitaet.falsch), isFalse);
    });

    test('Wirkung ist maschinenlesbar: belastet und entlastet nennen eine Kernperson, neutral keine', () {
      final kern = kanon.kernverdaechtige;
      for (final h in gruppe.hinweise) {
        final w = h['wirkung'];
        expect(w, isA<Map>(), reason: '${h['id']}: Wirkung fehlt');
        final m = w as Map;
        final art = m['art'];
        expect(art, isIn(['belastet', 'entlastet', 'neutral']), reason: '${h['id']}: art');
        if (art == 'neutral') {
          expect(m.containsKey('person'), isFalse, reason: '${h['id']}: neutral mit Person');
        } else {
          expect(kern, contains(m['person']), reason: '${h['id']}: keine Kernperson');
        }
      }
    });
  });
}
