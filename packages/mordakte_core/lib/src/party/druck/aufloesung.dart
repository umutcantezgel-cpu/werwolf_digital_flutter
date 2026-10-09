import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../gruppenwahl.dart';
import 'satz.dart';
import 'satz_stil.dart';

// Versiegeltes Auflösungsheft mit Endentabelle (F5-BAUMEISTER-03, Master 7.9, 7.14).
// Nur die Spielleitung öffnet es, und erst nach der Anklage. Texte kommen aus
// `ui.druck.aufloesung.*`, aus den Daten des Satzes oder wortgleich aus den Bausteinen.

void aufloesungsheft(pw.Document doc, DruckKontext k) {
  final enden = k.satz.aufloesung.endentabelle;
  doc.addPage(pw.MultiPage(
    pageFormat: DruckStil.format,
    margin: DruckStil.rand,
    maxPages: 40,
    footer: (c) => _fuss(k, c),
    build: (c) => [
      ..._deckblatt(k),
      pw.NewPage(),
      ..._taeterUndPunkte(k),
      pw.NewPage(),
      ..._endentabelle(k),
      for (var i = 0; i < enden.length; i++) ...[
        pw.NewPage(),
        ..._abschnitt(k, i),
      ],
      pw.NewPage(),
      ..._fuerAlle(k),
      pw.NewPage(),
      ..._codeliste(k),
    ],
  ));
}

/// Deckblatt: Siegel, Falltitel und Fall-Code.
List<pw.Widget> _deckblatt(DruckKontext k) {
  final s = k.stil;
  return [
    pw.SizedBox(height: 120),
    pw.Text(k.ui('ui.druck.aufloesung.marke').toUpperCase(), style: s.marke(10)),
    pw.SizedBox(height: 8),
    pw.Text(k.fallTitel, style: s.titel(30)),
    pw.SizedBox(height: 44),
    pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: DruckStil.tinte, width: 1.6)),
      child: pw.Text(k.ui('ui.druck.aufloesung.siegel'), style: s.titel(18)),
    ),
    pw.SizedBox(height: 44),
    pw.Text(k.ui('ui.druck.aufloesung.fall_code'), style: s.marke(10)),
    pw.SizedBox(height: 6),
    pw.Text(k.satz.code.code, style: s.code(30)),
    pw.SizedBox(height: 40),
    pw.Text(k.ui('ui.druck.aufloesung.deckhinweis'), style: s.text(12)),
  ];
}

/// Wer es war, und die Tabelle der neun Entscheidungen mit der richtigen Karte und dem Ankreuzfeld.
List<pw.Widget> _taeterUndPunkte(DruckKontext k) {
  final s = k.stil;
  final a = k.satz.aufloesung;
  return [
    ..._kopf(k, k.ui('ui.druck.aufloesung.marke'), k.ui('ui.druck.aufloesung.taeter')),
    pw.Text(k.figurName(a.taeter), style: s.titel(26)),
    pw.SizedBox(height: 28),
    pw.Text(k.ui('ui.druck.aufloesung.punkte'), style: s.ueberschrift(14)),
    pw.SizedBox(height: 4),
    pw.Text(k.ui('ui.druck.aufloesung.punkte_hinweis'), style: s.text(11)),
    pw.SizedBox(height: 10),
    pw.Table(
      border: pw.TableBorder.all(color: DruckStil.linie, width: 0.5),
      columnWidths: {
        0: pw.FixedColumnWidth(120),
        1: pw.FlexColumnWidth(),
        2: pw.FixedColumnWidth(100),
        3: pw.FixedColumnWidth(70),
      },
      children: [
        _kopfzeile(s, [
          k.ui('ui.druck.aufloesung.spalte.entscheidung'),
          k.ui('ui.druck.aufloesung.spalte.frage'),
          k.ui('ui.druck.aufloesung.spalte.karte'),
          k.ui('ui.druck.aufloesung.spalte.feld'),
        ]),
        for (final b in k.satz.detektivbogen)
          pw.TableRow(children: [
            _zelle(s, k.ui('ui.druck.aufloesung.entscheidung', {'runde': '${b.runde}', 'nr': '${b.nr}'})),
            _zelle(s, _kurz(b.frage)),
            _zelle(s, a.richtig[b.id]!, fett: true),
            _feld(),
          ]),
        pw.TableRow(children: [
          _zelle(s, ''),
          _zelle(s, k.ui('ui.druck.aufloesung.summe'), fett: true),
          _zelle(s, ''),
          _feld(),
        ]),
      ],
    ),
  ];
}

/// Endentabelle: Anklage und Punkte ergeben das Ende, mit Verweis auf den Abschnitt.
List<pw.Widget> _endentabelle(DruckKontext k) {
  final s = k.stil;
  final enden = k.satz.aufloesung.endentabelle;
  return [
    ..._kopf(k, k.ui('ui.druck.aufloesung.marke'), k.ui('ui.druck.aufloesung.endentabelle')),
    pw.Text(k.ui('ui.druck.aufloesung.endentabelle_hinweis'), style: s.text(11)),
    pw.SizedBox(height: 10),
    pw.Table(
      border: pw.TableBorder.all(color: DruckStil.linie, width: 0.5),
      columnWidths: {
        0: pw.FixedColumnWidth(130),
        1: pw.FixedColumnWidth(120),
        2: pw.FlexColumnWidth(),
        3: pw.FixedColumnWidth(90),
      },
      children: [
        _kopfzeile(s, [
          k.ui('ui.druck.aufloesung.spalte.anklage'),
          k.ui('ui.druck.aufloesung.spalte.punkte'),
          k.ui('ui.druck.aufloesung.spalte.ende'),
          k.ui('ui.druck.aufloesung.spalte.abschnitt'),
        ]),
        for (var i = 0; i < enden.length; i++)
          pw.TableRow(children: [
            _zelle(s, k.ui(enden[i].richtig ? 'ui.druck.aufloesung.anklage.richtig' : 'ui.druck.aufloesung.anklage.falsch')),
            _zelle(s, k.ui('ui.druck.aufloesung.punkte_von_bis', {'von': '${enden[i].punkteVon}', 'bis': '${enden[i].punkteBis}'})),
            _zelle(s, enden[i].name, fett: true),
            _zelle(s, k.ui('ui.druck.aufloesung.abschnitt', {'nr': '${i + 1}'})),
          ]),
      ],
    ),
  ];
}

/// Ein Ende: Finaltext, dann die Rückblende (wortgleich aus den Bausteinen).
List<pw.Widget> _abschnitt(DruckKontext k, int i) {
  final s = k.stil;
  final e = k.satz.aufloesung.endentabelle[i];
  final bausteine = k.satz.aufloesung.finale[e.id]!;
  return [
    ..._kopf(k, k.ui('ui.druck.aufloesung.abschnitt', {'nr': '${i + 1}'}), e.name),
    for (var j = 0; j < bausteine.length; j++) ...[
      if (j > 0 && j == bausteine.length - 1) ...[
        pw.SizedBox(height: 6),
        pw.Text(k.ui('ui.druck.aufloesung.rueckblende'), style: s.ueberschrift(12.5)),
        pw.SizedBox(height: 4),
      ],
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Text(k.text(bausteine[j]), style: s.text(13)),
      ),
    ],
  ];
}

/// Auflösung für alle: die Runden mit Zusammenhalt, die Gruppe je Zahl, dann die Rollen.
List<pw.Widget> _fuerAlle(DruckKontext k) {
  final s = k.stil;
  final a = k.satz.aufloesung;
  final zusammenhalt = [for (final u in k.satz.umschlaege) if (u.qualitaet == Qualitaet.wahr) u]..sort((x, y) => x.runde.compareTo(y.runde));
  return [
    ..._kopf(k, k.ui('ui.druck.aufloesung.marke'), k.ui('ui.druck.aufloesung.alle')),
    pw.Text(k.ui('ui.druck.aufloesung.zusammenhalt'), style: s.ueberschrift(12.5)),
    pw.SizedBox(height: 4),
    pw.Text(k.ui('ui.druck.aufloesung.zusammenhalt_hinweis'), style: s.text(11)),
    pw.SizedBox(height: 8),
    pw.Table(
      border: pw.TableBorder.all(color: DruckStil.linie, width: 0.5),
      columnWidths: {
        0: pw.FixedColumnWidth(120),
        1: pw.FlexColumnWidth(),
      },
      children: [
        for (final u in zusammenhalt)
          pw.TableRow(children: [
            _zelle(s, k.ui('ui.druck.aufloesung.runde', {'nr': '${u.runde}'})),
            _zelle(s, k.ui('ui.druck.aufloesung.umschlag', {'code': u.code}), fett: true),
          ]),
      ],
    ),
    pw.SizedBox(height: 16),
    for (var n = 0; n <= 3; n++) ...[
      pw.Text(k.ui('ui.druck.aufloesung.gruppe', {'nr': '$n'}), style: s.ueberschrift(12.5)),
      pw.SizedBox(height: 4),
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Text(k.text(a.gruppe[n]!), style: s.text(11)),
      ),
    ],
    pw.Text(k.ui('ui.druck.aufloesung.rollen'), style: s.ueberschrift(12.5)),
    pw.SizedBox(height: 6),
    // Name und Text bleiben zusammen: keine Überschrift allein am Seitenende.
    for (final baustein in a.rollen)
      pw.Inseparable(
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(k.figurName(baustein.split('.')[1]), style: s.ueberschrift(11)),
            pw.SizedBox(height: 2),
            pw.Text(k.text(baustein), style: s.text(11)),
          ]),
        ),
      ),
  ];
}

/// Codeliste: jeder Code mit seiner Bedeutung, sortiert nach Code.
List<pw.Widget> _codeliste(DruckKontext k) {
  final s = k.stil;
  final codes = [...k.satz.aufloesung.codes.keys]..sort();
  return [
    ..._kopf(k, k.ui('ui.druck.aufloesung.marke'), k.ui('ui.druck.aufloesung.codes')),
    pw.Text(k.ui('ui.druck.aufloesung.codes_hinweis'), style: s.text(11)),
    pw.SizedBox(height: 10),
    pw.Table(
      border: pw.TableBorder.all(color: DruckStil.linie, width: 0.5),
      columnWidths: {
        0: pw.FixedColumnWidth(70),
        1: pw.FlexColumnWidth(),
      },
      children: [
        _kopfzeile(s, [k.ui('ui.druck.aufloesung.spalte.code'), k.ui('ui.druck.aufloesung.spalte.bedeutung')]),
        for (final c in codes) pw.TableRow(children: [_zelle(s, c, fett: true), _zelle(s, _bedeutung(k, c))]),
      ],
    ),
  ];
}

/// Bedeutung eines Codes aus den Daten des Satzes: Entscheidung, Hinweis oder Fassung.
String _bedeutung(DruckKontext k, String code) {
  final satz = k.satz;
  for (final b in satz.detektivbogen) {
    for (final o in b.optionen) {
      if (o.karte == code) {
        return k.ui('ui.druck.aufloesung.code.indizkarte', {'runde': '${b.runde}', 'nr': '${b.nr}', 'text': o.text});
      }
    }
  }
  for (final u in satz.umschlaege) {
    if (u.code == code) {
      return k.ui('ui.druck.aufloesung.code.umschlag', {'runde': '${u.runde}', 'qualitaet': k.ui('ui.druck.aufloesung.qualitaet.${u.qualitaet.name}')});
    }
  }
  for (final f in satz.fassungen) {
    if (f.code == code) {
      return k.ui(f.dossier.taeter ? 'ui.druck.aufloesung.code.taeterfassung' : 'ui.druck.aufloesung.code.fassung', {'name': k.figurName(f.rolle)});
    }
  }
  throw StateError('Code $code ohne Bedeutung im Satz');
}

/// Frage gekürzt auf höchstens [hoechstens] Zeichen, am Wortende mit „…“.
String _kurz(String s, [int hoechstens = 60]) {
  if (s.length <= hoechstens) return s;
  final vorn = s.substring(0, hoechstens);
  final leer = vorn.lastIndexOf(' ');
  return '${(leer > 0 ? vorn.substring(0, leer) : vorn).trimRight()}…';
}

/// Kopf einer Seite des Auflösungsheftes. Die Marke steht mit mindestens 9 pt (Master 7.14, F-14).
List<pw.Widget> _kopf(DruckKontext k, String marke, String titel) => [
      pw.Text(marke.toUpperCase(), style: k.stil.marke(9)),
      pw.SizedBox(height: 3),
      pw.Text(titel, style: k.stil.titel()),
      pw.SizedBox(height: 6),
      pw.Container(height: 0.8, color: DruckStil.linie),
      pw.SizedBox(height: 12),
    ];

/// Fußzeile: Falltitel links, Seitenzahl rechts, beides mit 9 pt.
pw.Widget _fuss(DruckKontext k, pw.Context c) => pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(k.fallTitel, style: k.stil.klein()),
        pw.Text('${c.pageNumber} / ${c.pagesCount}', style: k.stil.klein()),
      ],
    );

pw.Widget _zelle(DruckStil s, String text, {bool fett = false}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(text, style: fett ? s.ueberschrift(10.5) : s.text(10.5)),
    );

pw.TableRow _kopfzeile(DruckStil s, List<String> spalten) => pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey200),
      children: [for (final t in spalten) _zelle(s, t, fett: true)],
    );

/// Ankreuzfeld zum Eintragen der richtigen Entscheidungen.
pw.Widget _feld() => pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Container(
        width: 14,
        height: 14,
        decoration: pw.BoxDecoration(border: pw.Border.all(color: DruckStil.tinte, width: 0.8)),
      ),
    );
