// F5-TEST-02: Gebündelter Drucktest über alle Pfade und Personenzahlen (F-14, Master 7.14): acht Dateien in fester Reihenfolge und A4, neutrale Karten und Umschläge, Fassungen ohne verräterische Überschrift, nur die Täterfassung mit Tarnung (E-035), kein Auflösungsbaustein im Heft oder Bogen, Funde der Indizkarten wortgleich im PDF.
// Geprüft wird das fertige PDF (pdfinfo, pdftotext) über die Testhilfe; die Sätze sind deterministisch (kein Zufall, keine Zeit).
import 'dart:io';
import 'dart:typed_data';

import 'package:mordakte_core/src/party/druck/karten.dart';
import 'package:mordakte_core/src/party/druck/rollen.dart';
import 'package:mordakte_core/src/party/druck/satz.dart';
import 'package:mordakte_core/src/party/druck/spielleitung.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test/test.dart';

import 'druck_hilfe.dart';
import 'kanon_hilfe.dart';

/// Dateinamen in der Reihenfolge, in der druckDateien sie liefert.
const _dateinamen = [
  '00-spielleitung.pdf',
  '01-detektivbogen.pdf',
  '10-rollenhefte.pdf',
  '11-fassungen.pdf',
  '12-stimmkarten.pdf',
  '20-indizkarten.pdf',
  '21-umschlaege.pdf',
  '90-aufloesung-versiegelt.pdf',
];

/// Personenzahlen, die der Drucksatz durchläuft (Spielgröße 4 bis 20).
const _personenzahlen = [4, 7, 12, 16, 20];

/// Wörter, die auf keiner Karten- oder Umschlagseite stehen dürfen.
const _verboten = ['Täter', 'Täterin', 'wahr', 'neutral', 'falsch', 'Gerücht'];

/// Bausteine, die weder im Spielleitungsheft noch im Detektivbogen stehen dürfen.
final _aufloesungsPraefix = RegExp(r'^(finale|rueckblende|aufloesung)\.');

final _buchstabe = RegExp(r'\p{L}', unicode: true);

/// Kommt [wort] als ganzes Wort in [text] vor (Groß- und Kleinschreibung egal)?
bool _ganzesWort(String text, String wort) {
  final t = text.toLowerCase();
  final w = wort.toLowerCase();
  var i = t.indexOf(w);
  while (i >= 0) {
    final vor = i > 0 ? t[i - 1] : ' ';
    final nach = i + w.length < t.length ? t[i + w.length] : ' ';
    if (!_buchstabe.hasMatch(vor) && !_buchstabe.hasMatch(nach)) return true;
    i = t.indexOf(w, i + 1);
  }
  return false;
}

/// Die ersten 50 Zeichen eines Textes nach flach(): so wird Wortgleichheit geprüft.
String _kopf(String text, [int n = 50]) {
  final f = flach(text);
  return f.length <= n ? f : f.substring(0, n);
}

/// Ein Teil als PDF-Bytes, so wie druckDateien es setzt.
Future<Uint8List> _bytes(DruckKontext k, void Function(pw.Document, DruckKontext) teil) async {
  final doc = k.stil.neuesDokument('${k.fallTitel} · Test');
  teil(doc, k);
  return doc.save();
}

/// Text eines PDFs in Zeichenfolge des Inhaltsstroms (ohne -layout), damit ein Satz zusammenhängt.
String _rohText(Uint8List bytes) {
  final dir = Directory.systemTemp.createTempSync('druck_test_roh');
  try {
    final f = File('${dir.path}/satz.pdf')..writeAsBytesSync(bytes);
    return Process.runSync('pdftotext', ['-raw', f.path, '-']).stdout as String;
  } finally {
    dir.deleteSync(recursive: true);
  }
}

typedef _Satz = ({String pfad, int n});

void main() {
  // Alle Sätze des Falls: jeder Pfad mit jeder Personenzahl.
  final saetze = <_Satz>[
    for (final p in kanon.pfade)
      for (final n in _personenzahlen) (pfad: p, n: n),
  ];

  // Namen und Kennungen aller Figuren und Pfade: kein Dateiname darf eines davon als Wort enthalten.
  final personenWoerter = <String>{
    for (final f in [...kanon.figuren, kanon.figurenJson['opfer'] as Map<String, Object?>])
      for (final w in (f['name'] as String).split(' ')) w.toLowerCase(),
    for (final f in kanon.figuren) (f['id'] as String).toLowerCase(),
    for (final p in kanon.pfade) p.toLowerCase(),
  };

  test('der Fall hat vier Pfade, also 20 Sätze aus vier Pfaden und fünf Personenzahlen', () {
    expect(kanon.pfade, hasLength(4));
    expect(saetze, hasLength(20));
  });

  for (final s in saetze) {
    test('Pfad ${s.pfad}, ${s.n} Personen: acht Dateien in fester Reihenfolge, alle A4, kein Personen- oder Pfadname im Dateinamen', () async {
      final k = druckKontext(pfad: s.pfad, n: s.n);
      final dateien = await druckDateien(k);
      expect([for (final d in dateien) d.name], _dateinamen);
      for (final d in dateien) {
        expect(pdfPruefen(d.bytes).a4, isTrue, reason: '${s.pfad}/${s.n} ${d.name}');
        final woerter = d.name.toLowerCase().split(RegExp(r'[-.]')).toSet();
        expect(woerter.intersection(personenWoerter), isEmpty, reason: '${s.pfad}/${s.n} ${d.name}');
      }
    });
  }

  test('Indizkarten und Umschläge nennen auf keiner Seite wahr, neutral, falsch, Gerücht, Täter oder ein Ende (alle Sätze)', () async {
    for (final s in saetze) {
      final k = druckKontext(pfad: s.pfad, n: s.n);
      final satz = '${s.pfad}/${s.n}';
      final seiten = [
        ...pdfPruefen(await _bytes(k, indizkarten)).seitenText,
        ...pdfPruefen(await _bytes(k, umschlaege)).seitenText,
      ];
      final verboten = [..._verboten, for (final e in k.satz.aufloesung.endentabelle) e.name];
      for (final seite in seiten) {
        for (final wort in verboten) {
          expect(_ganzesWort(seite, wort), isFalse, reason: '$satz: „$wort“ auf einer Karten- oder Umschlagseite');
        }
      }
    }
  });

  test('Fassungen: vier Fassungen, Seitenzahl durch 4 teilbar, jede Fassung beginnt mit ihrem Code (alle Sätze)', () async {
    for (final s in saetze) {
      final k = druckKontext(pfad: s.pfad, n: s.n);
      final satz = '${s.pfad}/${s.n}';
      expect(k.satz.fassungen, hasLength(4), reason: satz);
      final b = pdfPruefen(await _bytes(k, fassungen));
      expect(b.seiten % 4, 0, reason: satz);
      final l = b.seiten ~/ 4;
      for (var i = 0; i < 4; i++) {
        final f = k.satz.fassungen[i];
        expect(b.seitenText[i * l].trim(), startsWith(f.code), reason: '$satz ${f.rolle}');
      }
    }
  });

  test('Fassungen: nur die Täterfassung trägt die Tarnung, keine verrät sich durch „Nur für dich“ (alle Sätze)', () async {
    for (final s in saetze) {
      final k = druckKontext(pfad: s.pfad, n: s.n);
      final satz = '${s.pfad}/${s.n}';
      final taeter = k.satz.aufloesung.taeter;
      expect(k.satz.fassungen.map((f) => f.rolle), contains(taeter), reason: satz);
      final b = pdfPruefen(await _bytes(k, fassungen));
      final l = b.seiten ~/ 4;
      for (var i = 0; i < 4; i++) {
        final f = k.satz.fassungen[i];
        final block = flach(b.seitenText.sublist(i * l, (i + 1) * l).join(' '));
        final tarnung = f.dossier.tarnung;
        expect(tarnung != null && block.contains(flach(tarnung).substring(0, 40)), f.rolle == taeter, reason: '$satz ${f.rolle}');
        expect(block, isNot(contains('Nur für dich')), reason: '$satz ${f.rolle}');
      }
    }
  });

  test('Spielleitungsheft und Detektivbogen tragen keinen Finale-, Rückblende- oder Auflösungsbaustein (alle Sätze)', () async {
    final verboten = {
      for (final e in druckTexte.sammlung.bausteine.entries)
        if (_aufloesungsPraefix.hasMatch(e.key)) e.key: _kopf(e.value),
    };
    expect(verboten, isNotEmpty);
    for (final s in saetze) {
      final k = druckKontext(pfad: s.pfad, n: s.n);
      final satz = '${s.pfad}/${s.n}';
      for (final teil in <void Function(pw.Document, DruckKontext)>[spielleitungsheft, detektivbogen]) {
        final text = flach(_rohText(await _bytes(k, teil)));
        for (final e in verboten.entries) {
          expect(text, isNot(contains(e.value)), reason: '$satz: Baustein ${e.key}');
        }
      }
    }
  });

  for (final (pfad, n) in [('ahmet', 4), ('can', 20)]) {
    test('Indizkarten: jeder Fund jeder Karte steht wortgleich im PDF (Pfad $pfad, $n Personen)', () async {
      final k = druckKontext(pfad: pfad, n: n);
      final text = flach(_rohText(await _bytes(k, indizkarten)));
      expect(k.satz.indizkarten, isNotEmpty);
      expect([for (final karte in k.satz.indizkarten) ...karte.funde], isNotEmpty, reason: '$pfad/$n: keine Funde, Test wäre leer');
      for (final karte in k.satz.indizkarten) {
        for (final fund in karte.funde) {
          expect(text, contains(_kopf(fund)), reason: '${karte.code}: $fund');
        }
      }
    });
  }
}
