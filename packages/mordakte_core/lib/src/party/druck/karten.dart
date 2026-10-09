import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'modell.dart';
import 'satz.dart';
import 'satz_stil.dart';

// Indizkarten und Hinweis-Umschläge (F5-BAUMEISTER-03, Master 7.9, 7.14).
// Außen stehen nur der Code und ein neutraler Hinweis. Innen stehen die Funde
// wortgleich aus dem Satz, die Ankreuzhilfen für den Ermittlungsbogen bzw. die
// Texte des Umschlags. Die Innenseite wird vor dem Satz gemessen: Überlauf ist ein Fehler.

/// Eine Indizkarte ist A5 quer und längs gefaltet: links außen der Code, rechts innen die Funde.
final _karte = PdfPageFormat.a5.landscape;

/// Abstand des Innenteils zum Rand und zur Faltlinie (pt).
const _innenRand = 22.0;

/// Rand der Innenseite eines Umschlags: seitlich wie das Seitenmaß, oben und unten knapper.
final _umschlagRand = pw.EdgeInsets.fromLTRB(DruckStil.rand.left, 34, DruckStil.rand.right, 30);

/// Gestrichelte Faltlinie.
const _falz = pw.BorderSide(color: DruckStil.linie, width: 0.6, style: pw.BorderStyle.dashed);

void indizkarten(pw.Document doc, DruckKontext k) {
  final karten = k.satz.indizkarten;
  for (var i = 0; i < karten.length; i += 2) {
    final seite = karten.skip(i).take(2).toList();
    doc.addPage(pw.Page(
      pageFormat: DruckStil.format,
      margin: pw.EdgeInsets.zero,
      build: (c) => pw.Column(children: [for (final x in seite) _indizkarte(k, x)]),
    ));
  }
}

void umschlaege(pw.Document doc, DruckKontext k) {
  final halb = DruckStil.format.height / 2;
  for (final u in k.satz.umschlaege) {
    final g = k.stil.passendeGroesse(
      (g) => _umschlagInnen(k, u, g),
      DruckStil.breite,
      halb - _umschlagRand.top - _umschlagRand.bottom,
      start: 16,
      wo: 'Umschlag ${u.code}',
    );
    doc.addPage(pw.Page(
      pageFormat: DruckStil.format,
      margin: pw.EdgeInsets.zero,
      build: (c) => pw.Column(children: [
        pw.Container(
          width: DruckStil.format.width,
          height: halb,
          decoration: pw.BoxDecoration(border: pw.Border(bottom: _falz)),
          child: pw.Center(child: k.stil.aussenseite(u.code, k.ui('ui.druck.umschlag.aussen'))),
        ),
        pw.Container(
          width: DruckStil.format.width,
          height: halb,
          padding: _umschlagRand,
          child: _umschlagInnen(k, u, g),
        ),
      ]),
    ));
  }
}

/// Eine Indizkarte: links außen der Code, rechts innen Ziel, Funde und Kreuze.
pw.Widget _indizkarte(DruckKontext k, Indizkarte x) {
  final halb = _karte.width / 2;
  final g = k.stil.passendeGroesse(
    (g) => _innen(k, x, g),
    halb - 2 * _innenRand,
    _karte.height - 2 * _innenRand,
    start: 14,
    wo: 'Indizkarte ${x.code}',
  );
  return pw.Container(
    width: _karte.width,
    height: _karte.height,
    decoration: k.stil.schnitt(),
    child: pw.Row(children: [
      pw.Container(
        width: halb,
        height: _karte.height,
        decoration: pw.BoxDecoration(border: pw.Border(right: _falz)),
        child: pw.Center(child: k.stil.aussenseite(x.code, k.ui('ui.druck.karte.aussen'))),
      ),
      pw.Container(
        width: halb,
        height: _karte.height,
        padding: const pw.EdgeInsets.all(_innenRand),
        child: _innen(k, x, g, setzen: true),
      ),
    ]),
  );
}

/// Innenseite einer Indizkarte: Ziel als Überschrift, die Funde wortgleich, unten die Ankreuzhilfen.
/// Gesetzt wird die Lücke bis zum unteren Rand ([setzen]); gemessen wird mit einem kleinen Abstand,
/// weil ein dehnbarer Platz beim Messen keine feste Höhe hat.
pw.Widget _innen(DruckKontext k, Indizkarte x, double g, {bool setzen = false}) {
  final s = k.stil;
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(x.ziel, style: s.titel(18)),
      pw.SizedBox(height: 6),
      pw.Container(height: 0.8, color: DruckStil.linie),
      pw.SizedBox(height: 10),
      if (x.unbesetztePerson) ...[
        pw.Text(k.ui('ui.druck.karte.unbesetzt'), style: s.text(g)),
        pw.SizedBox(height: 10),
      ],
      s.abschnitt(k.ui('ui.druck.karte.fund'), x.funde, groesse: g),
      if (setzen) pw.Expanded(child: pw.SizedBox()) else pw.SizedBox(height: 14),
      pw.Text(k.ui('ui.druck.karte.bogen'), style: s.ueberschrift(12.5)),
      pw.SizedBox(height: 4),
      if (x.kreuze.isEmpty)
        pw.Text(k.ui('ui.druck.karte.keine_kreuze'), style: s.text(g))
      else
        for (final kreuz in x.kreuze)
          pw.Text('${k.figurName(kreuz.person)} – ${k.ui('ui.druck.bogen.typ.${kreuz.typ}')}', style: s.text(g)),
    ],
  );
}

/// Innenseite eines Umschlags: darüber „Vorlesen“, dann die Texte wortgleich.
pw.Widget _umschlagInnen(DruckKontext k, HinweisUmschlag u, double g) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [k.stil.abschnitt(k.ui('ui.druck.umschlag.vorlesen'), u.texte, groesse: g)],
    );
