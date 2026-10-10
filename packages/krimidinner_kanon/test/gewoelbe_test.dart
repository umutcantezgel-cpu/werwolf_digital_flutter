// Zugriffsschicht Gewoelbe: Besetzung, Steckbriefe, Mappen, Sichtklassen, Pflichtkennungen.
import 'package:krimidinner_kanon/krimidinner_kanon.dart';
import 'package:test/test.dart';

import 'hilfe.dart';

String nr2(int n) => n.toString().padLeft(2, '0');

int zaehle(Iterable<Eintrag> e, String label) =>
    e.where((x) => x.label == label).length;

void main() {
  late Gewoelbe g;
  late KrimiKanon k;
  setUpAll(() {
    k = echterKanon;
    g = gewoelbe;
  });

  test('besetzung(N) ist R01 … RN in Kanonreihenfolge', () {
    for (var n = 4; n <= 20; n++) {
      final b = g.besetzung(n);
      expect(b.map((a) => a.schluessel), [
        for (var r = 1; r <= n; r++) 'R${nr2(r)}',
      ]);
      for (final a in b) {
        final st = k.datensaetze['${a.schluessel}-STAMM']!;
        expect(a.titel, st.feld('Name'));
        expect(a.untertitel, st.feld('Aussprache'));
        expect(a.kopfzeile, contains('${st.feld('Alter')} Jahre'));
        expect(
          a.kopfzeile,
          contains(st.feld('Geschlecht') == 'w' ? 'Frau' : 'Mann'),
        );
        expect(a.eintraege.single.text, st.feld('Beruf'));
      }
    }
  });

  test('steckbriefe(N): N Karten plus Geburtstagskind und Burgwart', () {
    for (var n = 4; n <= 20; n++) {
      final s = g.steckbriefe(n);
      expect(s.length, n + 2);
      expect(s[0].schluessel, 'DET');
      expect(s[1].schluessel, 'BW');
      expect(s.skip(2).map((a) => a.schluessel), [
        for (var r = 1; r <= n; r++) 'R${nr2(r)}',
      ]);
    }
    final adnan = g.steckbriefe(4)[2];
    expect(adnan.titel, 'Adnan Hodžić');
    expect(
      adnan.kopfzeile,
      startsWith(
        '33 Jahre · bosnisch · selbstständiger Veranstaltungstechniker',
      ),
    );
    final alibi = adnan.eintraege.firstWhere(
      (e) => e.label == 'Behauptetes Alibi',
    );
    expect(
      alibi.text,
      k.datensaetze['R01-ÖFFENTLICH']!.feld('Behauptetes Alibi'),
    );
    final sprechweise = adnan.eintraege.firstWhere(
      (e) => e.label == 'Sprechweise',
    );
    expect(sprechweise.text.split('\n'), hasLength(3));
  });

  test(
    'Steckbrief des Geburtstagskinds: Bezeichnung, Anrede, Rolle im Spiel',
    () {
      final d = g.detektivSteckbrief;
      expect(d.titel, 'Das Geburtstagskind');
      expect(d.eintraege.map((e) => e.label), ['Bezeichnung', 'Anrede']);
      expect(d.kopfzeile, k.datensaetze['DET-STAMM']!.feld('Rolle im Spiel'));
      expect(d.texte.join(' '), isNot(contains('nie genannt')));
    },
  );

  test('Steckbrief des Burgwarts aus BW-STAMM', () {
    final b = g.burgwartSteckbrief;
    expect(b.titel, 'Der Burgwart');
    expect(b.untertitel, 'Eckehard Lüddecke');
    expect(
      b.eintraege.map((e) => e.label),
      containsAll(['Aussprache', 'Leben', 'Art', 'Kleidung', 'Sprechweise']),
    );
  });

  test('Überblick: Abschnitte in Reihenfolge, Ablauf aus ZM-3', () {
    final u = g.ueberblick;
    expect(u.map((a) => a.titel), [
      'Die Geschichte',
      'Die Burg',
      'Wer in der Burg ist',
      'Der Burgwart',
      'Wer mitspielt',
      'Ablauf',
      'Dauer',
      'Gespräche',
      'Regeln zum Lügen',
    ]);
    expect(
      u[0].eintraege.single.text,
      k.datensaetze['FÜNF-SÄTZE']!.feld('Text'),
    );
    expect(u[1].aufklappbar, isTrue);
    expect(u[1].eintraege, hasLength(8));
    final ablauf = k.datensaetze['ZM-3']!.feld('Ablauf')!.split(' · ');
    expect(u[5].eintraege, hasLength(ablauf.length));
    expect(u[8].eintraege, hasLength(7));
    final alles = u.expand((a) => a.texte).join(' ');
    for (final id in ['K-009', 'K-011']) {
      expect(
        alles,
        isNot(contains(k.datensaetze[id]!.feld('Tatsache')!)),
        reason: id,
      );
    }
    for (final oa in k.mitPraefix('OA-')) {
      expect(
        alles,
        isNot(contains(oa.feld('Was alle erlebt haben')!)),
        reason: oa.id,
      );
    }
  });

  test(
    'mappe(Rnn, N): Geheimnis, 3 Aufträge je Phase, Antworten wie tatsaechliche()',
    () {
      for (var n = 4; n <= 20; n++) {
        for (var r = 1; r <= n; r++) {
          final rolle = 'R${nr2(r)}';
          final m = g.mappe(rolle, n);
          expect(m.nummer, r);
          expect(m.name, k.datensaetze['$rolle-STAMM']!.feld('Name'));
          final geheim = m.abschnitte.firstWhere(
            (a) => a.titel == 'Dein Geheimnis',
          );
          final rohGeheimnis = k.datensaetze['$rolle-GEHEIM']!.feld(
            'Geheimnis',
          )!;
          final angezeigt = geheim.eintraege.first.text.replaceAll('\n', ' ');
          expect(
            normal(angezeigt),
            normal(ohneKennungen(rohGeheimnis)),
            reason: '$rolle N=$n',
          );
          for (var p = 1; p <= 3; p++) {
            final a = m.abschnitte.firstWhere((x) => x.schluessel == 'P$p');
            expect(a.neueSeite, isTrue);
            final t = tatsaechliche(k, p, n);
            final auftraege = a.eintraege
                .where((e) => e.label?.startsWith('Frag ') ?? false)
                .length;
            expect(auftraege, 3, reason: '$rolle P$p N=$n');
            expect(zaehle(a.eintraege, 'Worum es geht'), 3);
            final antworten = t.where((x) => x.$2 == r).length;
            expect(
              zaehle(a.eintraege, 'Deine Antwort'),
              antworten,
              reason: '$rolle P$p N=$n',
            );
            expect(
              a.eintraege.where((e) => e.art == EintragArt.hinweis).length,
              antworten,
            );
          }
        }
      }
    },
  );

  test('Ersatzfall: Frage und Ziel aus den Ersatz-Feldern', () {
    final g103 = k.datensaetze['G1-03']!;
    final vier = g
        .mappe('R01', 4)
        .abschnitte
        .firstWhere((a) => a.schluessel == 'P1');
    final i = vier.eintraege.indexWhere(
      (e) => e.label == 'Frag Jonas' && e.text == g103.feld('Ersatz-Frage'),
    );
    expect(i, greaterThanOrEqualTo(0));
    expect(
      vier.eintraege[i + 1].text,
      'Adnan fragt Jonas nach dem eingesammelten Geld.',
    );
    final fuenf = g
        .mappe('R01', 5)
        .abschnitte
        .firstWhere((a) => a.schluessel == 'P1');
    expect(
      fuenf.eintraege.any(
        (e) => e.label == 'Frag Paulina' && e.text == g103.feld('Frage'),
      ),
      isTrue,
    );
    final jonas = g
        .mappe('R04', 4)
        .abschnitte
        .firstWhere((a) => a.schluessel == 'P1');
    final j = jonas.eintraege.indexWhere(
      (e) => e.label == 'Adnan fragt' && e.text == g103.feld('Ersatz-Frage'),
    );
    expect(jonas.eintraege[j + 1].text, g103.feld('Ersatz-Antwort'));
    expect(jonas.eintraege[j + 2].text, 'Weich hier aus.');
  });

  test(
    'detektivMappe: B1–B6, neun Entscheidungen mit je drei Optionen, Anklage',
    () {
      final m = g.detektivMappe();
      expect(m.schluessel, 'DET');
      expect(m.nummer, 0);
      final beob = m.abschnitte.firstWhere(
        (a) => a.titel == 'Was du beobachtet hast',
      );
      expect(beob.eintraege.map((e) => e.text), [
        for (var i = 1; i <= 6; i++)
          k.datensaetze['DET-B$i']!.feld('Beobachtung'),
      ]);
      final ent = m.abschnitte.firstWhere((a) => a.schluessel == 'D');
      expect(
        ent.eintraege.where((e) => e.label?.startsWith('Phase ') ?? false),
        hasLength(9),
      );
      for (final b in ['A', 'B', 'C']) {
        expect(zaehle(ent.eintraege, 'Option $b'), 9);
      }
      expect(
        ent.eintraege.first.text,
        'Was deine Wahl ergibt, erfährst du am Abend.',
      );
      final anklage = m.abschnitte.firstWhere(
        (a) => a.titel == 'So läuft die Anklage',
      );
      expect(anklage.eintraege, hasLength(4));
      expect(
        m.abschnitte.first.eintraege.map((e) => e.label),
        contains('Rolle im Spiel'),
      );
    },
  );

  test('N außerhalb 4–20 und unbesetzte Rollen werfen ArgumentError', () {
    for (final n in [3, 21, 0, -1]) {
      expect(() => g.besetzung(n), throwsArgumentError, reason: '$n');
      expect(() => g.steckbriefe(n), throwsArgumentError, reason: '$n');
      expect(() => g.mappe('R01', n), throwsArgumentError, reason: '$n');
    }
    expect(() => g.mappe('R09', 8), throwsArgumentError);
    expect(() => g.mappe('DET', 8), throwsArgumentError);
    expect(() => g.mappe('X', 8), throwsArgumentError);
    expect(g.mappeFuer('DET', 8).schluessel, 'DET');
    expect(g.mappenPersonen(5), ['DET', 'R01', 'R02', 'R03', 'R04', 'R05']);
  });

  test(
    'gekürzter Kanon ohne Pflichtkennung wirft GewoelbeFehler mit Liste',
    () {
      final dateien = kanonDateien();
      final ohneLuege = {
        for (final e in dateien.entries)
          e.key: e.value
              .split('\n')
              .where(
                (z) => !z.startsWith('@R07-LÜGE ') && !z.startsWith('@ZM-4 '),
              )
              .join('\n'),
      };
      expect(
        () => Gewoelbe(KrimiKanon.ausText(ohneLuege)),
        throwsA(
          isA<GewoelbeFehler>().having((f) => f.fehlend, 'fehlend', [
            'ZM-4',
            'R07-LÜGE',
          ]),
        ),
      );
      final klein = KrimiKanon.ausText({
        'K1-T.md': '@FÜNF-SÄTZE [L] | Text: x\n',
      });
      final fehler = Gewoelbe.pflichtBefunde(klein);
      expect(fehler, contains('FÜNF-SÄTZE (Sicht L statt O)'));
      expect(
        fehler,
        containsAll(['K-001', 'R20-LÜGE', 'D3-3', 'G1-*', 'G2-*', 'G3-*']),
      );
    },
  );

  test(
    'ein Pflichtsatz mit falscher Sicht wird gemeldet, statt später zu verraten',
    () {
      final dateien = kanonDateien();
      final umgestellt = {
        for (final e in dateien.entries)
          e.key: e.value.replaceFirst(
            '@R05-ÖFFENTLICH [O]',
            '@R05-ÖFFENTLICH [L]',
          ),
      };
      expect(
        () => Gewoelbe(KrimiKanon.ausText(umgestellt)),
        throwsA(
          isA<GewoelbeFehler>().having((f) => f.fehlend, 'fehlend', [
            'R05-ÖFFENTLICH (Sicht L statt O)',
          ]),
        ),
      );
    },
  );
}
