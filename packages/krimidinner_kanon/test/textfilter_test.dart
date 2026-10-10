// Textfilter F1–F6: kürzt nur, formuliert nie um (echte Fälle aus dem Kanon).
import 'package:krimidinner_kanon/krimidinner_kanon.dart';
import 'package:test/test.dart';

import 'hilfe.dart';

/// Ist [aus] durch reines Weglassen aus [ein] entstanden (Zeichen-Teilfolge)?
bool istGekuerzt(String aus, String ein) {
  final quelle = ein.runes.toList();
  var i = 0;
  for (final c in aus.runes) {
    while (i < quelle.length && quelle[i] != c) {
      i++;
    }
    if (i == quelle.length) return false;
    i++;
  }
  return true;
}

String feld(String id, String name) => echterKanon.datensaetze[id]!.feld(name)!;

String vorname(int nr) =>
    feld('R${nr.toString().padLeft(2, '0')}-STAMM', 'Name').split(' ').first;

List<Verbindung> verbindungen(String id, int n) => filtereVerbindungen(
  feld(id, 'Verbindungen'),
  n,
  name: vorname,
  geburtstagskind: 'das Geburtstagskind',
  burgwart: 'der Burgwart',
);

void main() {
  group('F1 Ersatzmarker', () {
    test('„[NUR WENN ROLLE 06 NICHT BESETZT]“ fällt weg (G1-06)', () {
      final roh = feld('G1-06', 'Ersatz-Bedingung');
      expect(roh, startsWith('[NUR WENN ROLLE 06 NICHT BESETZT] '));
      final aus = ohneErsatzMarker(roh);
      expect(aus, 'Rojda nennt Merle leise das Codewort „Brockengespenst“.');
      expect(filtereText(roh, 5), aus);
      expect(istGekuerzt(aus, roh), isTrue);
    });
  });

  group('F2 Listen mit „(nur wenn Rolle nn besetzt)“', () {
    test('R02-WISSEN: 22:30 fehlt bei N=8, steht ohne Marker bei N=9', () {
      final roh = feld('R02-WISSEN', 'Wissen');
      expect(
        roh,
        contains('22:30 (nur wenn Rolle 09 besetzt) bittet sie Tomasz'),
      );
      final acht = filtereListe(roh, 8);
      final neun = filtereListe(roh, 9);
      expect(acht.where((p) => p.startsWith('22:30')), isEmpty);
      expect(
        neun.where((p) => p.startsWith('22:30')).single,
        '22:30 bittet sie Tomasz, die Torte um zwei nach zwölf bereitzuhalten',
      );
      expect(neun.length, acht.length + 1);
      expect(neun.first, '18:30 Zettel und Lampe von Adnan');
      for (final p in neun) {
        expect(p, isNot(contains('besetzt')));
        expect(istGekuerzt(p, roh), isTrue, reason: p);
      }
    });
  });

  group('F3 Besetzungsklammern', () {
    test('R03-WISSEN „(ist Rolle 08 besetzt, …)“ bei N=7 und N=8', () {
      final roh = feld('R03-WISSEN', 'Wissen');
      String punkt(int n) =>
          filtereListe(roh, n).firstWhere((p) => p.startsWith('22:55'));
      expect(punkt(7), '22:55 zurück ins Gewölbe, blass');
      expect(
        punkt(8),
        '22:55 zurück ins Gewölbe, blass (sagt sie leise zu Lejla: '
        '„Wenn mich einer anzeigt, ist alles aus.“)',
      );
      expect(istGekuerzt(punkt(8), roh), isTrue);
      expect(istGekuerzt(punkt(7), roh), isTrue);
    });

    test('„(ist Rolle nn nicht besetzt, X)“ umgekehrt', () {
      const roh =
          'Sie wartet am Tor (ist Rolle 12 nicht besetzt, allein) und friert.';
      expect(
        besetzungsKlammern(roh, 11),
        'Sie wartet am Tor (allein) und friert.',
      );
      expect(besetzungsKlammern(roh, 12), 'Sie wartet am Tor und friert.');
      expect(filtereText(roh, 20), 'Sie wartet am Tor und friert.');
    });
  });

  group('F4 Produktionskennungen', () {
    test('einzelne Kennung in Klammern (G1-14 „(H-17)“)', () {
      final roh = feld('G1-14', 'Bedingung');
      expect(roh, contains('(H-17)'));
      final aus = ohneKennungen(roh);
      expect(aus, isNot(contains('H-17')));
      expect(aus, contains('ihre eigene Darstellung und fragt'));
      expect(istGekuerzt(aus, roh), isTrue);
    });

    test('Listen mit „und“ (G3-34 „(H-24 und H-07)“)', () {
      final roh = feld('G3-34', 'Bedingung');
      final aus = ohneKennungen(roh);
      expect(aus, isNot(matches(RegExp(r'H-\d'))));
      expect(aus, contains('Vorder- und Rückseite und entschuldigt'));
    });

    test(
      '„(Hinweis H-121)“, „(Hinweise H-105 und H-107)“, „(R10)“ und Kommalisten',
      () {
        expect(
          ohneKennungen('was du weißt (Hinweis H-121); die Spielleitung'),
          'was du weißt; die Spielleitung',
        );
        expect(
          ohneKennungen('über die Lampe (Hinweise H-105 und H-107).'),
          'über die Lampe.',
        );
        expect(
          ohneKennungen('Karten (H-01, H-02 und BS-03) liegen'),
          'Karten liegen',
        );
        expect(
          ohneKennungen('Spannweite (H-121 bis H-176) hier'),
          'Spannweite hier',
        );
        final roh = feld('R09-GEHEIM', 'Geheimnis');
        expect(roh, contains('Annika (R10) verlobt'));
        expect(ohneKennungen(roh), contains('Annika verlobt'));
      },
    );

    test(
      'Querverweise auf Regelkennungen (ZM-3 „nach ZM-2“, LR-3 „(LR-8)“)',
      () {
        final ablauf = ohneKennungen(feld('ZM-3', 'Ablauf'));
        expect(ablauf, isNot(contains('ZM-2')));
        expect(
          ablauf,
          contains('Gesprächsfenster, Rollen-Entscheidungen 3, Lagerunde,'),
        );
        final lr3 = ohneKennungen(feld('LR-3', 'Regel'));
        expect(lr3, endsWith('weiter so, wie sie stehen.'));
      },
    );

    test('Klammern mit Text bleiben stehen', () {
      const roh =
          'Burg Schartenfels (SCHAR-ten-fels) im Oberharz (Inversionswetterlage).';
      expect(ohneKennungen(roh), roh);
    });
  });

  group('F5 Verbindungen', () {
    test(
      'R05: Rnn wird Vorname, DET und BW werden benannt, R10 fällt bei N=9 weg',
      () {
        final neun = verbindungen('R05-VERBINDUNGEN', 9);
        expect(neun.map((v) => v.name), [
          'Jonas',
          'das Geburtstagskind',
          'der Burgwart',
        ]);
        expect(
          neun.first.erlaeuterung,
          startsWith('hat ihm 55 Euro „Miete“ gezahlt'),
        );
        expect(neun[1].erlaeuterung, 'Steuererklärung gegen Abendessen');
        expect(neun[2].erlaeuterung, 'Respekt für seine Ordnung');
        final elf = verbindungen('R05-VERBINDUNGEN', 11);
        expect(elf.map((v) => v.name), [
          'Jonas',
          'Annika',
          'Berfin',
          'das Geburtstagskind',
          'der Burgwart',
        ]);
      },
    );

    test('Sammelverweis fällt weg, BW ohne Klammer bleibt als Name', () {
      final r02 = verbindungen('R02-VERBINDUNGEN', 20);
      expect(r02.map((v) => v.name), [
        'Merle',
        'Adnan',
        'Jonas',
        'das Geburtstagskind',
        'der Burgwart',
      ]);
      expect(r02.last.erlaeuterung, isNull);
      expect(r02.any((v) => v.name.contains('Erweiterungsrollen')), isFalse);
    });

    test('Erläuterungen bleiben wörtlich', () {
      for (var r = 1; r <= 20; r++) {
        final id = 'R${r.toString().padLeft(2, '0')}-VERBINDUNGEN';
        for (final v in verbindungen(id, 20)) {
          if (v.erlaeuterung != null) {
            expect(
              feld(id, 'Verbindungen'),
              contains(v.erlaeuterung),
              reason: id,
            );
          }
        }
      }
    });
  });

  group('F6 Glätten', () {
    test('Leerzeichen und Satzzeichen', () {
      expect(glaetten('  a   b ,  c .  '), 'a b, c.');
      expect(glaetten('Wort ( ) Rest'), 'Wort Rest');
      expect(glaetten('(  innen )'), '(innen)');
    });
  });

  test(
    'alle angezeigten Kanontexte sind nur gekürzt, nie umformuliert (N 4–20)',
    () {
      final felder = <String, List<String>>{
        for (var r = 1; r <= 20; r++) ...{
          'R${r.toString().padLeft(2, '0')}-STAMM': [
            'Beruf',
            'Familie',
            'Kleidung',
            'Sprechweise',
          ],
          'R${r.toString().padLeft(2, '0')}-ÖFFENTLICH': [
            'Behauptetes Alibi',
            'Comedy-Beteiligung (sichtbar)',
          ],
          'R${r.toString().padLeft(2, '0')}-GEHEIM': [
            'Geheimnis',
            'Motiv',
            'Wahres Alibi',
          ],
          'R${r.toString().padLeft(2, '0')}-LÜGE': [
            'Darf lügen über',
            'Muss wahr sagen über',
          ],
        },
        for (final (_, g) in gespraeche(echterKanon))
          g.id: [
            'Bedingung',
            'Frage',
            'Antwort',
            'Ersatz-Bedingung',
            'Ersatz-Frage',
            'Ersatz-Antwort',
          ],
      };
      for (final MapEntry(key: id, value: namen) in felder.entries) {
        for (final name in namen) {
          final roh = echterKanon.datensaetze[id]!.feld(name) ?? '';
          for (final n in [4, 8, 9, 12, 17, 20]) {
            final aus = filtereText(roh, n);
            expect(istGekuerzt(aus, roh), isTrue, reason: '$id.$name N=$n');
          }
        }
      }
      for (var r = 1; r <= 20; r++) {
        final roh = feld('R${r.toString().padLeft(2, '0')}-WISSEN', 'Wissen');
        for (final n in [4, 8, 9, 20]) {
          for (final p in filtereListe(roh, n)) {
            expect(istGekuerzt(p, roh), isTrue, reason: 'R$r N=$n $p');
          }
        }
      }
    },
  );

  group('F7 Sätze mit Namen', () {
    test('teilt an Satzenden, nie innerhalb von „…“', () {
      expect(
        saetze('Er kam. Sie ging! Wer? „Psst! Ich bin nicht hier.“ Dann'),
        ['Er kam.', 'Sie ging!', 'Wer?', '„Psst! Ich bin nicht hier.“', 'Dann'],
      );
      expect(saetze('um 23.50 Uhr. danach'), ['um 23.50 Uhr. danach']);
    });

    test('lässt nur Sätze mit dem Namen weg', () {
      const t =
          'Er erzählt. Zofia ruft: „Gespenster sind Physik!“ Seitdem sagt er: „Im Reif lügt keiner.“';
      expect(
        ohneSaetzeMit(t, ['Zofia']),
        'Er erzählt. Seitdem sagt er: „Im Reif lügt keiner.“',
      );
      expect(ohneSaetzeMit(t, ['Elif']), t);
      expect(ohneSaetzeMit(t, const []), t);
      expect(ohneSaetzeMit('Zofias Hut.', ['Zofia']), 'Zofias Hut.');
      expect(ohneSaetzeMit('Nur Zofia.', ['Zofia']), 'Nur Zofia.');
    });

    test(
      'R17-ÖFFENTLICH: der Zofia-Satz fällt bei N 17–19 weg, sonst nichts',
      () {
        final roh = feld('R17-ÖFFENTLICH', 'Comedy-Beteiligung (sichtbar)');
        final ohne = ohneSaetzeMit(roh, ['Zofia']);
        expect(ohne, isNot(contains('Zofia')));
        expect(ohne, contains('Brockengespenst'));
        expect(ohne, contains('„Im Reif lügt keiner.“'));
        expect(istGekuerzt(ohne, roh), isTrue);
      },
    );
  });

  test('Hilfen: nummerierte Zeilen und Uhrzeit vorne', () {
    expect(nummerierteZeilen('1) eins 2) zwei („Ja.“) 3) drei'), [
      '1) eins',
      '2) zwei („Ja.“)',
      '3) drei',
    ]);
    expect(nummerierteZeilen('ohne Nummern'), ['ohne Nummern']);
    expect(uhrzeitVorne('23:56:40 am Turm-Fuß'), ('23:56:40', 'am Turm-Fuß'));
    expect(uhrzeitVorne('21:15–21:35 bei der Führung'), (
      '21:15–21:35',
      'bei der Führung',
    ));
    expect(uhrzeitVorne('kurz vor zwölf'), (null, 'kurz vor zwölf'));
  });
}
