// Druck-HTML: eigenständig, escaped, A4, Karten ohne Umbruch, Mappen mit Deckblatt.
import 'package:krimidinner_kanon/krimidinner_kanon.dart';
import 'package:test/test.dart';

import 'hilfe.dart';

int anzahl(String text, String teil) => teil.allMatches(text).length;

void main() {
  late Gewoelbe g;
  setUpAll(() => g = gewoelbe);

  test(
    'Steckbrief-HTML: doctype, utf-8, ein body, A4 mit 14 mm, Systemschriften',
    () {
      final html = steckbriefeHtml(g, 8);
      expect(html, startsWith('<!doctype html>'));
      expect(html, contains('<meta charset="utf-8">'));
      expect(html, contains('<html lang="de">'));
      expect(anzahl(html, '<body>'), 1);
      expect(anzahl(html, '</body>'), 1);
      expect(html, contains('@page { size: A4; margin: 14mm; }'));
      expect(html, contains('system-ui'));
      expect(html, contains('break-inside: avoid'));
      expect(html, isNot(contains('http://')));
      expect(html, isNot(contains('https://')));
      expect(html, isNot(contains('<script')));
    },
  );

  test(
    'Steckbrief-HTML enthält N Rollenkarten plus Geburtstagskind und Burgwart',
    () {
      for (var n = 4; n <= 20; n++) {
        final html = steckbriefeHtml(g, n);
        expect(anzahl(html, 'class="karte rolle"'), n, reason: 'N=$n');
        expect(anzahl(html, 'class="karte"'), 2, reason: 'N=$n');
        expect(
          html,
          contains('$n Rollen und das Geburtstagskind – ${n + 1} Personen'),
        );
      }
    },
  );

  test('alle Texte sind escaped (<, &, Anführungszeichen)', () {
    expect(
      htmlText('a < b & c > d "e" \'f\''),
      'a &lt; b &amp; c &gt; d &quot;e&quot; &#39;f&#39;',
    );
    expect(htmlText('eins\nzwei'), 'eins<br>zwei');
    final html = mappeHtml(
      const Mappe(
        schluessel: 'R01',
        nummer: 1,
        name: 'Test <b>&',
        anrede: 'Test',
        abschnitte: [
          Abschnitt(
            titel: '<script>alert(1)</script>',
            eintraege: [Eintrag('x & y < z', label: 'L&L')],
          ),
        ],
      ),
    );
    expect(html, isNot(contains('<script>')));
    expect(html, contains('&lt;script&gt;alert(1)&lt;/script&gt;'));
    expect(html, contains('x &amp; y &lt; z'));
    expect(html, contains('Test &lt;b&gt;&amp;'));
    final echt = steckbriefeHtml(g, 20);
    final body = echt.substring(echt.indexOf('<body>'));
    final ohneTags = body.replaceAll(RegExp(r'<[^>]*>'), '');
    expect(ohneTags, isNot(contains('<')));
    expect(ohneTags, isNot(contains('>')));
    expect(RegExp(r'&(?!amp;|lt;|gt;|quot;|#39;)').hasMatch(ohneTags), isFalse);
  });

  test('Steckbrief-HTML zeigt die Texte der Karten wörtlich', () {
    final html = ohneHtml(steckbriefeHtml(g, 4));
    final alibi = echterKanon.datensaetze['R01-ÖFFENTLICH']!.feld(
      'Behauptetes Alibi',
    )!;
    expect(normal(html), contains(normal(alibi)));
    expect(normal(html), contains('Eckehard Lüddecke'));
    expect(normal(html), contains('Das Geburtstagskind'));
  });

  test('Steckbrief-HTML enthält keinen G- oder L-Wert', () {
    final k = echterKanon;
    final oWerte = [
      for (final d in k.datensaetze.values)
        if (d.sicht == Sicht.o) ...d.felder.values.map(normal),
    ];
    final verboten = {
      for (final d in k.datensaetze.values)
        if (d.sicht != Sicht.o)
          for (final v in d.felder.values.map(normal))
            if (v.length >= 25 && !oWerte.any((o) => o.contains(v))) v,
    };
    for (final n in [4, 9, 20]) {
      final text = normal(ohneHtml(steckbriefeHtml(g, n)));
      final treffer = verboten.where(text.contains).toList();
      expect(treffer, isEmpty, reason: 'N=$n');
    }
  });

  test(
    'Mappe: Deckblatt „Rollenmappe · Nur für {Name}“ und Seitenumbruch je Phase',
    () {
      final m = g.mappe('R02', 8);
      final html = mappeHtml(m);
      expect(html, startsWith('<!doctype html>'));
      expect(anzahl(html, '<body>'), 1);
      expect(html, contains('class="deckblatt"'));
      expect(html, contains('Rollenmappe · Nur für Rojda Baran'));
      expect(html, contains('break-after: page'));
      expect(anzahl(html, 'class="abschnitt neue-seite"'), 3);
      final ohne = normal(ohneHtml(html));
      final geheimnis = echterKanon.datensaetze['R02-GEHEIM']!.feld(
        'Geheimnis',
      )!;
      expect(ohne, contains(normal(geheimnis)));
      expect(ohne.indexOf('Phase 1'), lessThan(ohne.indexOf('Phase 2')));
      expect(ohne.indexOf('Phase 2'), lessThan(ohne.indexOf('Phase 3')));
    },
  );

  test(
    'Detektiv-Mappe: Deckblatt für das Geburtstagskind, Entscheidungen auf neuer Seite',
    () {
      final html = mappeHtml(g.detektivMappe());
      expect(html, contains('Rollenmappe · Nur für das Geburtstagskind'));
      expect(anzahl(html, 'neue-seite"'), 1);
      expect(
        ohneHtml(html),
        contains('Was deine Wahl ergibt, erfährst du am Abend.'),
      );
    },
  );

  test('Dateinamen nur mit Zahl', () {
    expect(GewoelbeTexte.dateiSteckbriefe(12), 'gewoelbe-steckbriefe-12.html');
    expect(GewoelbeTexte.dateiMappe(0), 'gewoelbe-mappe-00.html');
    expect(GewoelbeTexte.dateiMappe(7), 'gewoelbe-mappe-07.html');
    expect(GewoelbeTexte.dateiMappe(20), 'gewoelbe-mappe-20.html');
  });
}
