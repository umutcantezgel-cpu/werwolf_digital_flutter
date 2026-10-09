import 'dart:math';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../besetzung.dart';
import '../texte.dart';
import 'modell.dart';
import 'satz.dart';
import 'satz_stil.dart';

// Rollenhefte, versiegelte Fassungen der Kernrollen, Stimmkarten (F5-BAUMEISTER-02, Master 7.11, 7.14, G-1).
// Texte kommen aus Bausteinen `ui.druck.*` oder aus den Daten des Satzes. Außen stehen nur Codes.

/// Stimmkarte: 90 × 60 mm, längs gefaltet, acht je Blatt.
const _kartenBreite = PdfPageFormat.mm * 90;
const _kartenHoehe = PdfPageFormat.mm * 60;

void rollenhefte(pw.Document doc, DruckKontext k) {
  for (final rolle in k.satz.besetzt) {
    doc.addPage(_deckblatt(k, rolle));
    doc.addPage(pw.MultiPage(
      pageFormat: DruckStil.format,
      margin: DruckStil.rand,
      footer: (c) => k.stil.fuss(c, k.fallTitel),
      build: (c) => _heft(k, rolle),
    ));
  }
}

void fassungen(pw.Document doc, DruckKontext k) {
  int seitenVon(Fassung f) {
    final probe = k.stil.neuesDokument('Fassung');
    _fassung(probe, k, f);
    return probe.document.pdfPageList.pages.length;
  }

  // Alle vier Fassungen gleich lang: die kürzeren bekommen Notizseiten.
  final laengen = [for (final f in k.satz.fassungen) seitenVon(f)];
  final ziel = laengen.reduce(max);
  for (var i = 0; i < k.satz.fassungen.length; i++) {
    _fassung(doc, k, k.satz.fassungen[i]);
    for (var n = laengen[i]; n < ziel; n++) {
      doc.addPage(_notizen(k));
    }
  }
}

void stimmkarten(pw.Document doc, DruckKontext k) {
  // Reihenfolge: nach Runde, dann Besetzungsreihenfolge, A vor B.
  final karten = [
    for (var r = 1; r <= 3; r++)
      for (final rolle in k.satz.besetzt)
        for (final a in [true, false]) k.satz.stimmkarten.singleWhere((s) => s.rolle == rolle && s.runde == r && s.a == a),
  ];
  final schrift = _kartenSchrift(k, karten);
  for (var i = 0; i < karten.length; i += 8) {
    final blatt = karten.sublist(i, min(i + 8, karten.length));
    doc.addPage(pw.Page(
      pageFormat: DruckStil.format,
      margin: pw.EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      build: (c) => pw.Column(
        children: [
          for (var z = 0; z < 4; z++)
            pw.Row(
              children: [
                for (var s = 0; s < 2; s++)
                  if (z * 2 + s < blatt.length)
                    _karte(k, blatt[z * 2 + s], schrift)
                  else
                    pw.SizedBox(width: _kartenBreite, height: _kartenHoehe),
              ],
            ),
        ],
      ),
    ));
  }
}

// ---------------------------------------------------------------- Rollenheft

pw.Page _deckblatt(DruckKontext k, String rolle) {
  final farbe = PdfColor.fromHex(k.kanon.figur(rolle)!['colorCode'] as String);
  return pw.Page(
    pageFormat: DruckStil.format,
    margin: DruckStil.rand,
    build: (c) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(k.fallTitel, style: k.stil.marke()),
        pw.Spacer(flex: 2),
        pw.Container(
          width: DruckStil.breite,
          height: 18,
          decoration: pw.BoxDecoration(color: farbe, border: pw.Border.all(color: DruckStil.linie, width: 0.6)),
        ),
        pw.SizedBox(height: 26),
        pw.Text(k.ui('ui.druck.rollen.heft'), style: k.stil.marke(10)),
        pw.SizedBox(height: 8),
        pw.Text(k.figurName(rolle), style: k.stil.titel(44)),
        pw.SizedBox(height: 6),
        pw.Text(k.figurTitel(rolle), style: k.stil.ueberschrift(16)),
        pw.Spacer(flex: 3),
        pw.Container(
          width: DruckStil.breite,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: DruckStil.tinte, width: 1.2)),
          child: pw.Text(k.ui('ui.druck.rollen.nurfuerdich'), style: k.stil.text(14)),
        ),
        pw.Spacer(flex: 4),
        k.stil.fuss(c, k.fallTitel),
      ],
    ),
  );
}

/// Hält einen Block zusammen: Passt er nicht mehr auf die Seite, beginnt er auf der nächsten.
List<pw.Widget> _zusammen(DruckKontext k, pw.Widget Function() bauen) => [
      pw.NewPage(freeSpace: k.stil.hoehe(bauen(), DruckStil.breite)),
      bauen(),
    ];

List<pw.Widget> _heft(DruckKontext k, String rolle) {
  final d = k.satz.rollenhefte[rolle]!;
  final w = <pw.Widget>[k.stil.kopf(k.ui('ui.druck.rollen.heft'), k.figurName(rolle))];
  final fassung = _fassungVon(k, rolle);
  w.addAll(_zusammen(k, () => k.stil.abschnitt(k.ui('ui.druck.rollen.wer'), [d.wer])));
  // Kernrollen: Das Ziel hängt am Pfad (Täterziel) und steht deshalb im
  // versiegelten Umschlag; die vier Kernhefte sehen gleich aus (E-033).
  if (fassung == null) w.addAll(_zusammen(k, () => k.stil.abschnitt(k.ui('ui.druck.rollen.ziel'), [d.ziel])));
  for (var r = 1; r <= 3; r++) {
    w.addAll(_zusammen(k, () => _gespraechRunde(k, d, r, kopf: r == 1)));
  }
  w.addAll(_zusammen(k, () => k.stil.abschnitt(k.ui('ui.druck.rollen.besetzung'), [d.besetzung])));
  if (fassung != null) {
    // Kernrollen: Was ich weiß, verberge und wähle steht im versiegelten Umschlag.
    w.addAll(_zusammen(k, () => _umschlag(k, fassung.code)));
  } else {
    w
      ..addAll(_weissUndVerberge(k, d))
      ..addAll(_rundenwahl(k, d));
  }
  return w;
}

/// Pflichtgespräche einer Runde; die erste Runde trägt die Überschrift des Abschnitts.
pw.Widget _gespraechRunde(DruckKontext k, Dossier d, int r, {bool kopf = false}) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (kopf) ...[
            pw.Text(k.ui('ui.druck.rollen.gespraeche'), style: k.stil.ueberschrift(12.5)),
            pw.SizedBox(height: 4),
          ],
          pw.Text(k.ui('ui.druck.rollen.runde', {'nr': '$r'}), style: k.stil.ueberschrift(11)),
          pw.SizedBox(height: 3),
          for (final (g, partner) in d.gespraeche[r] ?? const <(Gespraech, String)>[]) ...[
            _feld(k, k.ui('ui.druck.rollen.partner'), _partner(k, partner)),
            _feld(k, k.ui('ui.druck.rollen.thema'), g.thema),
            _feld(k, k.ui('ui.druck.rollen.gespraechsziel'), g.ziel),
            _feld(k, k.ui('ui.druck.rollen.anfang'), '„${g.text}“'),
            pw.SizedBox(height: 5),
          ],
        ],
      ),
    );

List<pw.Widget> _weissUndVerberge(DruckKontext k, Dossier d) => [
      ..._zusammen(k, () => k.stil.abschnitt(k.ui('ui.druck.rollen.weiss'), [for (final z in d.weiss) z.text])),
      ..._zusammen(
        k,
        () => k.stil.abschnitt(k.ui('ui.druck.rollen.verberge'), [
          for (final z in d.verbirgt)
            if (z.behauptung != null) ...[
              k.ui('ui.druck.rollen.behauptet', {'behauptung': z.behauptung!}),
              k.ui('ui.druck.rollen.wahrheit', {'wahrheit': z.text}),
            ] else
              z.text,
        ]),
      ),
    ];

List<pw.Widget> _rundenwahl(DruckKontext k, Dossier d) => [
      for (var r = 1; r <= 3; r++)
        if (d.wahlen[r] != null) ..._zusammen(k, () => _wahlBlock(k, r, d.wahlen[r]!, kopf: r == 1)),
    ];

/// Die beiden Wahlen einer Runde; die erste Runde trägt die Überschrift des Abschnitts.
pw.Widget _wahlBlock(DruckKontext k, int r, WahlText w, {bool kopf = false}) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (kopf) ...[
            pw.Text(k.ui('ui.druck.rollen.wahl'), style: k.stil.ueberschrift(12.5)),
            pw.SizedBox(height: 4),
          ],
          pw.Text(k.ui('ui.druck.rollen.runde', {'nr': '$r'}), style: k.stil.ueberschrift(11)),
          pw.SizedBox(height: 3),
          _wahlZeile(k, 'A', w.a),
          if (w.sabotage != null)
            _wahlZeile(k, k.ui('ui.druck.fassung.sabotage'), w.sabotage!)
          else
            _wahlZeile(k, 'B', w.b),
        ],
      ),
    );

pw.Widget _wahlZeile(DruckKontext k, String kennzeichen, String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(kennzeichen, style: k.stil.klein()),
          pw.Text(text, style: k.stil.text()),
        ],
      ),
    );

pw.Widget _feld(DruckKontext k, String bezeichnung, String wert) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 118, child: pw.Text(bezeichnung, style: k.stil.klein())),
          pw.Expanded(child: pw.Text(wert, style: k.stil.text())),
        ],
      ),
    );

String _partner(DruckKontext k, String id) => id == Besetzung.detektiv ? k.ui('ui.druck.rollen.detektiv') : k.figurName(id);

pw.Widget _umschlag(DruckKontext k, String code) => pw.Container(
      width: DruckStil.breite,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: DruckStil.tinte, width: 1)),
      child: pw.Text(k.ui('ui.druck.rollen.umschlag', {'code': code}), style: k.stil.text()),
    );

Fassung? _fassungVon(DruckKontext k, String rolle) {
  for (final f in k.satz.fassungen) {
    if (f.rolle == rolle) return f;
  }
  return null;
}

// ---------------------------------------------------------------- Fassungen

void _fassung(pw.Document doc, DruckKontext k, Fassung f) {
  final name = k.figurName(f.rolle);
  doc.addPage(pw.Page(
    pageFormat: DruckStil.format,
    margin: DruckStil.rand,
    build: (c) => k.stil.aussenseite(f.code, k.ui('ui.druck.fassung.aussen', {'name': name})),
  ));
  doc.addPage(pw.MultiPage(
    pageFormat: DruckStil.format,
    margin: DruckStil.rand,
    footer: (c) => k.stil.fuss(c, k.fallTitel),
    build: (c) => _innen(k, f),
  ));
}

List<pw.Widget> _innen(DruckKontext k, Fassung f) {
  final d = f.dossier;
  return [
    k.stil.kopf(k.ui('ui.druck.fassung.marke'), k.figurName(f.rolle)),
    if (d.taeter) ..._zusammen(k, () => _tafel(k, d)),
    ..._zusammen(k, () => k.stil.abschnitt(k.ui('ui.druck.rollen.ziel'), [d.ziel])),
    ..._weissUndVerberge(k, d),
    ..._rundenwahl(k, d),
  ];
}

/// Nur in der Täterfassung: die Tarnung für die anderen und das wahre Geschehen.
pw.Widget _tafel(DruckKontext k, Dossier d) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: DruckStil.breite,
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: DruckStil.tinte, width: 1.2)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(k.ui('ui.druck.fassung.tafel'), style: k.stil.titel(17)),
              pw.SizedBox(height: 10),
              k.stil.abschnitt(k.ui('ui.druck.fassung.tarnung'), [d.tarnung!]),
              k.stil.abschnitt(k.ui('ui.druck.fassung.tatwissen'), [for (final z in d.tatwissen) z.text]),
            ],
          ),
        ),
        pw.SizedBox(height: 14),
      ],
    );

pw.Page _notizen(DruckKontext k) => pw.Page(
      pageFormat: DruckStil.format,
      margin: DruckStil.rand,
      build: (c) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          k.stil.kopf(k.ui('ui.druck.fassung.marke'), k.ui('ui.druck.fassung.notizen')),
          for (var i = 0; i < 26; i++)
            pw.Container(
              width: DruckStil.breite,
              height: 24,
              decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: DruckStil.linie, width: 0.5))),
            ),
          pw.Spacer(),
          k.stil.fuss(c, k.fallTitel),
        ],
      ),
    );

// ---------------------------------------------------------------- Stimmkarten

/// Eine Schriftgröße für alle Karten: die kleinste, die jede Vorderseite passend fasst.
/// Gemessen wird die ganze Vorderseite (Kopfzeile und Kartentext), nicht nur der Text.
double _kartenSchrift(DruckKontext k, List<Stimmkarte> karten) {
  var schrift = 11.0;
  for (final s in karten) {
    final g = k.stil.passendeGroesse(
      (groesse) => _vorderseite(k, s, groesse),
      _kartenBreite,
      _kartenHoehe / 2,
      wo: 'Stimmkarte ${s.rolle} Runde ${s.runde}',
    );
    schrift = min(schrift, g);
  }
  return schrift;
}

/// Vorderseite (obere Hälfte): Name, Figur, Runde, A oder B und der Text der Karte.
/// Ohne feste Höhe, damit die Messung die echte Höhe liefert.
pw.Widget _vorderseite(DruckKontext k, Stimmkarte s, double schrift) => pw.Container(
      width: _kartenBreite,
      padding: const pw.EdgeInsets.fromLTRB(9, 7, 9, 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text(k.figurName(s.rolle), style: k.stil.ueberschrift(10)),
              pw.Text('  ·  ', style: k.stil.klein()),
              pw.Text(k.ui('ui.druck.stimme.runde', {'nr': '${s.runde}'}), style: k.stil.klein()),
              pw.Spacer(),
              pw.Text(k.ui('ui.druck.stimme.name'), style: k.stil.klein()),
              pw.SizedBox(width: 6),
              pw.Container(
                width: 70,
                height: 10,
                decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: DruckStil.linie, width: 0.6))),
              ),
              pw.SizedBox(width: 8),
              pw.Text(s.a ? 'A' : 'B', style: k.stil.ueberschrift(12)),
            ],
          ),
          pw.SizedBox(height: 5),
          // Kartentext eng gesetzt (kein Zeilenabstand über der Schrift), damit vier Zeilen bei 9 pt passen.
          pw.Text(s.text, style: pw.TextStyle(font: k.stil.normal, fontSize: schrift, color: DruckStil.tinte, lineSpacing: 0.5)),
        ],
      ),
    );

pw.Widget _karte(DruckKontext k, Stimmkarte s, double schrift) {
  final wert = switch (s.wert) {
    1 => '+1',
    0 => '0',
    _ => '−1',
  };
  return pw.Container(
    width: _kartenBreite,
    height: _kartenHoehe,
    decoration: k.stil.schnitt(),
    child: pw.Column(
      children: [
        // Vorderseite: obere Hälfte.
        pw.SizedBox(width: _kartenBreite, height: _kartenHoehe / 2, child: _vorderseite(k, s, schrift)),
        // Rückseite: untere Hälfte, nach der Faltlinie umgeknickt.
        pw.Container(
          width: _kartenBreite,
          height: _kartenHoehe / 2,
          padding: const pw.EdgeInsets.fromLTRB(9, 6, 9, 6),
          decoration: pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: DruckStil.linie, width: 0.6, style: pw.BorderStyle.dotted)),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(k.ui('ui.druck.stimme.wert', {'wert': wert}), style: k.stil.ueberschrift(12)),
              pw.SizedBox(height: 4),
              pw.Text(k.ui('ui.druck.stimme.falz'), style: k.stil.klein(), textAlign: pw.TextAlign.center),
            ],
          ),
        ),
      ],
    ),
  );
}
