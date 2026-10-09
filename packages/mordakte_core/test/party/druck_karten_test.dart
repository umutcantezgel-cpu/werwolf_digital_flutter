// F5-BAUMEISTER-03: Indizkarten, Hinweis-Umschläge und das versiegelte Auflösungsheft im Druck.
// Prüft Format und Seitenzahlen, Codes, Funde und Umschlagtexte wortgleich, Außenseiten nur mit
// Code und neutralem Hinweis (F-14, Master 7.14), das Auflösungsheft mit Täter, Enden, Finaltexten
// und Codeliste sowie den Lauf aller Pfade mit 4 und 20 Personen ohne Überlauf (E-008).
import 'dart:io';
import 'dart:typed_data';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/party/druck/aufloesung.dart';
import 'package:mordakte_core/src/party/druck/karten.dart';
import 'package:mordakte_core/src/party/druck/modell.dart';
import 'package:mordakte_core/src/party/druck/satz.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test/test.dart';

import 'druck_hilfe.dart';
import 'kanon_hilfe.dart';

typedef _Teil = void Function(pw.Document doc, DruckKontext k);

/// Die drei Teile dieses Baumeisters, je unter dem Namen ihrer Datei.
final _teile = <String, _Teil>{
  '20-indizkarten.pdf': indizkarten,
  '21-umschlaege.pdf': umschlaege,
  '90-aufloesung-versiegelt.pdf': aufloesungsheft,
};

/// Ein Teil als PDF, so wie druckDateien es setzt.
Future<Uint8List> _pdf(DruckKontext k, _Teil teil) {
  final doc = k.stil.neuesDokument('${k.fallTitel} · Test');
  teil(doc, k);
  return doc.save();
}

/// Text je Seite in Reihenfolge des PDFs (Außenseite vor Innenseite), ohne Spaltenumbruch.
List<String> _seiten(Uint8List bytes) {
  final dir = Directory.systemTemp.createTempSync('karten_test');
  try {
    final f = File('${dir.path}/satz.pdf')..writeAsBytesSync(bytes);
    final roh = Process.runSync('pdftotext', ['-raw', f.path, '-']).stdout as String;
    final seiten = roh.split('\f');
    if (seiten.last.trim().isEmpty) seiten.removeLast();
    return [for (final s in seiten) flach(s)];
  } finally {
    dir.deleteSync(recursive: true);
  }
}

/// Die ersten 50 Zeichen eines Textes nach flach(): so wird Wortgleichheit geprüft.
String _kopf(String text, [int n = 50]) {
  final f = flach(text);
  return f.length <= n ? f : f.substring(0, n);
}

/// Der Text einer Karte auf ihrer Seite: vom eigenen Code bis zum Code der anderen Karte derselben Seite.
String _karteAuf(String seite, String code, List<String> aufDerSeite) {
  final von = seite.indexOf(code);
  expect(von, greaterThanOrEqualTo(0), reason: 'Code $code fehlt auf der Seite');
  var bis = seite.length;
  for (final andere in aufDerSeite) {
    if (andere == code) continue;
    final i = seite.indexOf(andere);
    if (i > von && i < bis) bis = i;
  }
  return seite.substring(von, bis);
}

/// Text einer Indizkarte (zwei Karten je Seite).
String _kartenText(List<String> seiten, List<Indizkarte> karten, int i) {
  final p = i ~/ 2;
  final paar = [karten[2 * p].code, if (2 * p + 1 < karten.length) karten[2 * p + 1].code];
  return _karteAuf(seiten[p], karten[i].code, paar);
}

final _buchstabe = RegExp(r'\p{L}', unicode: true);

/// Kommt [wort] als ganzes Wort vor, ohne Groß- und Kleinschreibung?
bool _ganzesWort(String text, String wort) {
  final t = text.toLowerCase();
  final w = wort.toLowerCase();
  bool buchstabe(String c) => _buchstabe.hasMatch(c);
  var i = t.indexOf(w);
  while (i >= 0) {
    final vor = i > 0 ? t[i - 1] : ' ';
    final nach = i + w.length < t.length ? t[i + w.length] : ' ';
    if (!buchstabe(vor) && !buchstabe(nach)) return true;
    i = t.indexOf(w, i + 1);
  }
  return false;
}

void main() {
  late DruckKontext k;
  setUpAll(() => k = druckKontext());

  test('alle drei Teile sind A4 und nicht leer', () async {
    for (final e in _teile.entries) {
      final befund = pdfPruefen(await _pdf(k, e.value));
      expect(befund.a4, isTrue, reason: e.key);
      expect(befund.seiten, greaterThan(0), reason: e.key);
    }
  });

  test('Indizkarten: genau ceil(Karten / 2) Seiten', () async {
    expect(k.satz.indizkarten, isNotEmpty);
    final befund = pdfPruefen(await _pdf(k, indizkarten));
    expect(befund.seiten, (k.satz.indizkarten.length / 2).ceil());
  });

  test('Umschläge: genau eine Seite je Hinweis-Umschlag', () async {
    final befund = pdfPruefen(await _pdf(k, umschlaege));
    expect(befund.seiten, k.satz.umschlaege.length);
  });

  test('jede Indizkarte zeigt ihren Code und ihr Ziel auf ihrer Seite', () async {
    final seiten = _seiten(await _pdf(k, indizkarten));
    final karten = k.satz.indizkarten;
    for (var i = 0; i < karten.length; i++) {
      final text = _kartenText(seiten, karten, i);
      expect(text, startsWith(karten[i].code), reason: karten[i].code);
      expect(text, contains(flach(karten[i].ziel)), reason: '${karten[i].code} · ${karten[i].ziel}');
    }
  });

  test('jeder Fund jeder Indizkarte steht wortgleich auf ihrer Karte (erste 50 Zeichen)', () async {
    final seiten = _seiten(await _pdf(k, indizkarten));
    final karten = k.satz.indizkarten;
    for (var i = 0; i < karten.length; i++) {
      for (final fund in karten[i].funde) {
        expect(_kartenText(seiten, karten, i), contains(_kopf(fund)), reason: '${karten[i].code}: $fund');
      }
    }
  });

  test('unbesetzte Personen tragen den Hinweis auf der Karte, besetzte nicht', () async {
    final seiten = _seiten(await _pdf(k, indizkarten));
    final karten = k.satz.indizkarten;
    final hinweis = flach(k.ui('ui.druck.karte.unbesetzt'));
    for (var i = 0; i < karten.length; i++) {
      expect(_kartenText(seiten, karten, i).contains(hinweis), karten[i].unbesetztePerson, reason: karten[i].code);
    }
    expect(karten.any((x) => x.unbesetztePerson), isTrue, reason: 'Testfall ohne unbesetzte Person');
  });

  test('jede Indizkarte nennt ihre Ankreuzhilfen: Name – Faktart oder „Nichts anzukreuzen“', () async {
    final seiten = _seiten(await _pdf(k, indizkarten));
    final karten = k.satz.indizkarten;
    for (var i = 0; i < karten.length; i++) {
      final text = _kartenText(seiten, karten, i);
      expect(text, contains(flach(k.ui('ui.druck.karte.bogen'))), reason: karten[i].code);
      if (karten[i].kreuze.isEmpty) {
        expect(text, contains(flach(k.ui('ui.druck.karte.keine_kreuze'))), reason: karten[i].code);
      }
      for (final kreuz in karten[i].kreuze) {
        final zeile = '${k.figurName(kreuz.person)} – ${k.ui('ui.druck.bogen.typ.${kreuz.typ}')}';
        expect(text, contains(zeile), reason: karten[i].code);
      }
    }
  });

  test('Außen nur Code und neutraler Hinweis: Indizkarten und Umschläge', () async {
    final karten = k.satz.indizkarten;
    final seitenK = _seiten(await _pdf(k, indizkarten));
    for (var i = 0; i < karten.length; i++) {
      final text = _kartenText(seitenK, karten, i);
      final aussen = '${karten[i].code} ${flach(k.ui('ui.druck.karte.aussen'))}';
      expect(text, startsWith(aussen), reason: karten[i].code);
    }
    final seitenU = _seiten(await _pdf(k, umschlaege));
    for (var i = 0; i < k.satz.umschlaege.length; i++) {
      final u = k.satz.umschlaege[i];
      final aussen = '${u.code} ${flach(k.ui('ui.druck.umschlag.aussen'))}';
      final vorlesen = seitenU[i].indexOf(flach(k.ui('ui.druck.umschlag.vorlesen')));
      expect(seitenU[i], startsWith(aussen), reason: u.code);
      expect(seitenU[i].substring(0, vorlesen), isNot(contains('Runde')), reason: 'Außen steht keine Runde: ${u.code}');
    }
  });

  test('Indizkarten und Umschläge nennen auf keiner Seite wahr, neutral, falsch, Täter oder ein Ende (alle Pfade)', () async {
    for (final pfad in kanon.pfade) {
      final kx = druckKontext(pfad: pfad);
      final seiten = [
        ..._seiten(await _pdf(kx, indizkarten)),
        ..._seiten(await _pdf(kx, umschlaege)),
      ];
      for (final s in seiten) {
        for (final verboten in ['wahr', 'neutral', 'falsch', 'Täter']) {
          expect(_ganzesWort(s, verboten), isFalse, reason: '$pfad: „$verboten“ auf Karte oder Umschlag');
        }
        for (final e in kx.satz.aufloesung.endentabelle) {
          expect(_ganzesWort(s, e.name), isFalse, reason: '$pfad: Ende „${e.name}“ auf Karte oder Umschlag');
        }
      }
    }
  });

  test('jeder Umschlag-Text steht wortgleich auf der Seite seines Umschlags', () async {
    final seiten = _seiten(await _pdf(k, umschlaege));
    final umschl = k.satz.umschlaege;
    for (var i = 0; i < umschl.length; i++) {
      expect(seiten[i], contains(flach(umschl[i].code)), reason: umschl[i].code);
      for (final text in umschl[i].texte) {
        expect(seiten[i], contains(_kopf(text)), reason: '${umschl[i].code}: $text');
      }
    }
  });

  test('Auflösung: Deckblatt mit Siegel, Falltitel und Fall-Code', () async {
    final bytes = await _pdf(k, aufloesungsheft);
    expect(pdfPruefen(bytes).a4, isTrue);
    final deckblatt = _seiten(bytes).first;
    expect(deckblatt, contains(flach(k.ui('ui.druck.aufloesung.siegel'))));
    expect(deckblatt, contains(flach(k.fallTitel)));
    expect(deckblatt, contains(k.satz.code.code));
  });

  test('Auflösung: nennt den Täter, jeden Ende-Namen und die richtige Karte jeder Entscheidung', () async {
    final alles = _seiten(await _pdf(k, aufloesungsheft)).join(' ');
    expect(alles, contains(k.figurName(k.satz.aufloesung.taeter)));
    for (final e in k.satz.aufloesung.endentabelle) {
      expect(alles, contains(e.name), reason: e.id);
    }
    for (final code in k.satz.aufloesung.richtig.values) {
      expect(alles, contains(code), reason: 'richtige Karte $code');
    }
  });

  test('Auflösung: jeder finale-Baustein und jede Rückblende steht wortgleich (erste 50 Zeichen)', () async {
    final alles = _seiten(await _pdf(k, aufloesungsheft)).join(' ');
    for (final e in k.satz.aufloesung.endentabelle) {
      for (final baustein in k.satz.aufloesung.finale[e.id]!) {
        expect(alles, contains(_kopf(k.text(baustein))), reason: baustein);
      }
    }
  });

  test('Auflösung: Zusammenhalt-Umschläge, Gruppen-Texte und Rollen-Texte stehen wortgleich', () async {
    final alles = _seiten(await _pdf(k, aufloesungsheft)).join(' ');
    for (final u in k.satz.umschlaege.where((u) => u.qualitaet == Qualitaet.wahr)) {
      expect(alles, contains(u.code), reason: 'Zusammenhalt ${u.code}');
    }
    for (final gruppe in k.satz.aufloesung.gruppe.values) {
      expect(alles, contains(_kopf(k.text(gruppe))), reason: gruppe);
    }
    for (final rolle in k.satz.aufloesung.rollen) {
      expect(alles, contains(_kopf(k.text(rolle))), reason: rolle);
      expect(alles, contains(k.figurName(rolle.split('.')[1])), reason: rolle);
    }
  });

  test('Auflösung: die Codeliste nennt jeden Code aus Karten, Umschlägen und Fassungen', () async {
    final alles = _seiten(await _pdf(k, aufloesungsheft)).join(' ');
    final codes = [
      for (final x in k.satz.indizkarten) x.code,
      for (final u in k.satz.umschlaege) u.code,
      for (final f in k.satz.fassungen) f.code,
    ];
    expect(k.satz.aufloesung.codes.keys.toSet(), codes.toSet());
    for (final c in codes) {
      expect(alles, contains(c), reason: 'Code $c in der Codeliste');
    }
  });

  test('ohne Überlauf: alle vier Pfade mit 4 und mit 20 Personen', () async {
    for (final pfad in kanon.pfade) {
      for (final n in [4, 20]) {
        final kx = druckKontext(pfad: pfad, n: n);
        for (final e in _teile.entries) {
          final befund = pdfPruefen(await _pdf(kx, e.value));
          expect(befund.a4, isTrue, reason: '$pfad n=$n ${e.key}');
          expect(befund.seiten, greaterThan(0), reason: '$pfad n=$n ${e.key}');
        }
      }
    }
  });
}
