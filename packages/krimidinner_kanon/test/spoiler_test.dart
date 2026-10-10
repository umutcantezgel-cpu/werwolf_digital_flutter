// Spoiler-Test: Öffentliche Ansichten verraten nichts, Mappen nur das Eigene.
//
// Gemessene Kanonlücken stehen auf der Ausnahmeliste (Meldung an den Krimidinner-Lauf):
// R09-GEHEIM, R09-LÜGE und R09-WISSEN nennen Annika (R10) bei N=9;
// R17-ÖFFENTLICH nennt Zofia (R20) bei N=17–19.
import 'package:krimidinner_kanon/krimidinner_kanon.dart';
import 'package:test/test.dart';

import 'hilfe.dart';

String nr2(int n) => n.toString().padLeft(2, '0');

/// Wörter und Kennungen, die nie sichtbar sein dürfen.
final verboteneMuster = <String, RegExp>{
  'Täter': RegExp('Täter'),
  'Kernrolle': RegExp('Kernrolle'),
  'Hauptverdächtig': RegExp('Hauptverdächtig'),
  'H-Kennung': RegExp(r'\bH-\d'),
  'BS-Kennung': RegExp(r'\bBS-\d'),
  'G/E/D-Kennung': RegExp(r'\b[GED]\d-\d'),
  'Rollenkennung': RegExp(r'\bR\d\d\b'),
  'Ansage': RegExp(r'\bA-E\d'),
  'besetzt': RegExp(r'\bbesetzt\b'),
  '[NUR': RegExp(r'\[NUR'),
};

/// Erlaubte Namen unbesetzter Rollen je Ansicht und N (Ausnahmeliste).
/// Der Steckbrief von R17 steht öffentlich und in der eigenen Mappe.
bool ausnahme(String ansicht, int n, String vorname) => switch (ansicht) {
  'oeffentlich' || 'R17' => vorname == 'Zofia' && n >= 17 && n <= 19,
  'R09' => vorname == 'Annika' && n == 9,
  _ => false,
};

/// Schneller Teiltext-Index: alle Fenster fester Länge eines Texts.
class Korpus {
  Korpus(String text) : text = normal(text) {
    for (var i = 0; i + fenster <= this.text.length; i++) {
      _fenster.add(this.text.substring(i, i + fenster));
    }
  }

  static const fenster = 18;
  final String text;
  final _fenster = <String>{};

  bool enthaelt(String wert) {
    if (wert.length < fenster) return text.contains(wert);
    return _fenster.contains(wert.substring(0, fenster)) && text.contains(wert);
  }
}

late KrimiKanon k;
late Gewoelbe g;
late List<String> oWerte;
late Korpus oKorpus;

/// Normalisierte Werte (roh und ohne Kennungen) ab [min] Zeichen, die nicht in O-Texten stehen.
Set<String> werte(
  Iterable<KanonDatensatz> ds, {
  int min = 25,
  bool listen = false,
}) {
  final out = <String>{};
  for (final d in ds) {
    for (final v in d.felder.values) {
      final teile = listen ? [v, ...v.split(' ; ')] : [v];
      for (final t in teile) {
        for (final w in {normal(t), normal(ohneKennungen(t))}) {
          if (w.length >= min && !oKorpus.enthaelt(w)) out.add(w);
        }
      }
    }
  }
  return out;
}

/// Vornamen aller Rollen.
Map<int, String> get vornamen => {
  for (var r = 1; r <= 20; r++)
    r: k.datensaetze['R${nr2(r)}-STAMM']!.feld('Name')!.split(' ').first,
};

List<String> befunde(String text, int n, Set<String> verboten, String ansicht) {
  final korpus = Korpus(text);
  final out = <String>[
    for (final v in verboten)
      if (korpus.enthaelt(v)) 'WERT: ${v.length > 70 ? v.substring(0, 70) : v}',
    for (final e in verboteneMuster.entries)
      if (e.value.hasMatch(korpus.text))
        'MUSTER ${e.key}: ${e.value.firstMatch(korpus.text)![0]}',
  ];
  vornamen.forEach((nr, name) {
    if (nr <= n) return;
    if (RegExp('\\b${RegExp.escape(name)}\\b').hasMatch(korpus.text) &&
        !ausnahme(ansicht, n, name)) {
      out.add('NAME R${nr2(nr)} $name bei N=$n');
    }
  });
  return out;
}

String alleTexte(Iterable<Abschnitt> abschnitte) =>
    abschnitte.expand((a) => a.texte).join('\n');

void main() {
  late Set<String> lWerte;
  late Set<String> gWerte;

  setUpAll(() {
    k = echterKanon;
    g = gewoelbe;
    oWerte = [
      for (final d in k.datensaetze.values)
        if (d.sicht == Sicht.o) ...d.felder.values,
    ];
    oKorpus = Korpus(oWerte.join(' ¦ '));
    lWerte = werte(
      k.datensaetze.values.where((d) => d.sicht == Sicht.l),
      min: 20,
    );
    gWerte = werte(k.datensaetze.values.where((d) => d.sicht == Sicht.g));
  });

  test('die Verbotslisten sind gefüllt (Messgrundlage)', () {
    expect(lWerte.length, greaterThan(500));
    expect(gWerte.length, greaterThan(1000));
    expect(lWerte, contains(normal(k.datensaetze['K-090']!.feld('Tatsache')!)));
  });

  test('der Prüfer erkennt Lecks (Gegenprobe)', () {
    final geheim = k.datensaetze['R03-GEHEIM']!.feld('Motiv')!;
    expect(
      befunde('Vorspann $geheim Nachspann', 8, gWerte, 'oeffentlich'),
      isNotEmpty,
    );
    final loesung = k.datensaetze['K-090']!.feld('Tatsache')!;
    expect(befunde(loesung, 8, lWerte, 'oeffentlich'), isNotEmpty);
    expect(befunde('wie R05 sagt', 8, const {}, 'oeffentlich'), [
      'MUSTER Rollenkennung: R05',
    ]);
    expect(befunde('Karte (H-17)', 8, const {}, 'oeffentlich'), [
      'MUSTER H-Kennung: H-1',
    ]);
    expect(
      befunde('22:30 (nur wenn Rolle 09 besetzt)', 8, const {}, 'oeffentlich'),
      ['MUSTER besetzt: besetzt'],
    );
    expect(befunde('Zofia lacht', 8, const {}, 'oeffentlich'), [
      'NAME R20 Zofia bei N=8',
    ]);
    expect(befunde('Zofia lacht', 18, const {}, 'oeffentlich'), isEmpty);
    expect(
      befunde('alle besetzten Rollen', 8, const {}, 'oeffentlich'),
      isEmpty,
    );
  });

  test('Überblick, Besetzung, Steckbriefe und Steckbrief-HTML für N 4–20', () {
    final ueberblick = alleTexte(g.ueberblick);
    for (var n = 4; n <= 20; n++) {
      final text = [
        ueberblick,
        alleTexte(g.besetzung(n)),
        alleTexte(g.steckbriefe(n)),
        ohneHtml(steckbriefeHtml(g, n)),
      ].join('\n');
      expect(
        befunde(text, n, {...lWerte, ...gWerte}, 'oeffentlich'),
        isEmpty,
        reason: 'N=$n',
      );
    }
  });

  test(
    'Rollenmappe Rnn: kein L-Wert, nichts aus GEHEIM/WISSEN/VERBINDUNGEN/LÜGE anderer Rollen',
    () {
      for (var r = 1; r <= 20; r++) {
        final rolle = 'R${nr2(r)}';
        // Was die Rolle selbst sehen darf: O, eigene G-Datensätze und eigene Gespräche.
        final eigen = Korpus(
          [
            ...oWerte,
            for (final d in k.datensaetze.values)
              if (d.sicht == Sicht.g &&
                  (d.feld('Rolle') == rolle ||
                      (RegExp(r'^G\d-').hasMatch(d.id) &&
                          [
                            d.feld('Von'),
                            d.feld('Ziel'),
                            d.feld('Ersatz'),
                          ].contains(rolle))))
                ...d.felder.values,
          ].join(' ¦ '),
        );
        final fremd = werte([
          for (var a = 1; a <= 20; a++)
            if (a != r)
              for (final t in ['GEHEIM', 'WISSEN', 'VERBINDUNGEN', 'LÜGE'])
                k.datensaetze['R${nr2(a)}-$t']!,
        ], listen: true).where((w) => !eigen.enthaelt(w)).toSet();
        for (var n = r < 4 ? 4 : r; n <= 20; n++) {
          final m = g.mappe(rolle, n);
          final text = [...m.texte, ohneHtml(mappeHtml(m))].join('\n');
          final ansicht = rolle == 'R09' || rolle == 'R17' ? rolle : 'mappe';
          expect(
            befunde(text, n, {...lWerte, ...fremd}, ansicht),
            isEmpty,
            reason: '$rolle N=$n',
          );
        }
      }
    },
  );

  test(
    'Detektiv-Mappe: kein DW-, AB-, EM- oder sonstiger L-Wert, keine fremden Geheimnisse',
    () {
      final m = g.detektivMappe();
      final text = [...m.texte, ohneHtml(mappeHtml(m))].join('\n');
      final dwAbEm = werte(
        k.datensaetze.values.where(
          (d) => RegExp(r'^(DW|AB|EM)').hasMatch(d.id),
        ),
        min: 12,
      );
      expect(dwAbEm, isNotEmpty);
      final rollenGeheim = werte([
        for (var r = 1; r <= 20; r++)
          for (final t in ['GEHEIM', 'WISSEN', 'VERBINDUNGEN', 'LÜGE'])
            k.datensaetze['R${nr2(r)}-$t']!,
      ], listen: true);
      expect(
        befunde(text, 20, {...lWerte, ...dwAbEm, ...rollenGeheim}, 'det'),
        isEmpty,
      );
      expect(befunde(text, 4, const {}, 'det'), isEmpty);
    },
  );

  test('Sicht L ist unerreichbar: Gewoelbe liest keine Lösungsdatensätze', () {
    // Ein Kanon, in dem ein Pflichtsatz plötzlich L ist, wird abgewiesen.
    final dateien = kanonDateien();
    for (final id in ['FÜNF-SÄTZE', 'R03-GEHEIM', 'DET-B3', 'D3-1']) {
      final kaputt = {
        for (final e in dateien.entries)
          e.key: e.value.replaceFirstMapped(
            RegExp('^@${RegExp.escape(id)} \\[[OG]\\]', multiLine: true),
            (_) => '@$id [L]',
          ),
      };
      expect(
        () => Gewoelbe(KrimiKanon.ausText(kaputt)),
        throwsA(isA<GewoelbeFehler>()),
        reason: id,
      );
    }
  });
}
