import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Gemeinsamer Satzstil aller Druckteile (F5): A4 hoch, Inter für Text,
/// Special Elite für Titel, ruhige Graustufen, damit Schwarzweißdruck reicht.
/// Schriften kommen als Bytes herein (CLI und App laden sie aus
/// `assets/fonts`), damit der Kern ohne `dart:io` bleibt.
class DruckStil {
  DruckStil({required Uint8List regular, required Uint8List fett, required Uint8List schreibmaschine})
      : normal = pw.Font.ttf(ByteData.sublistView(regular)),
        stark = pw.Font.ttf(ByteData.sublistView(fett)),
        titelSchrift = pw.Font.ttf(ByteData.sublistView(schreibmaschine));

  final pw.Font normal, stark, titelSchrift;

  static const format = PdfPageFormat.a4;
  static const rand = pw.EdgeInsets.fromLTRB(46, 42, 46, 42);

  /// Nutzbare Breite einer Seite.
  static double get breite => format.width - rand.left - rand.right;

  /// Kleinste erlaubte Schriftgröße (gut lesbar, Master 7.14).
  static const minGroesse = 9.0;

  static const tinte = PdfColors.grey900;
  static const leise = PdfColors.grey700;
  static const linie = PdfColors.grey500;

  pw.ThemeData get theme => pw.ThemeData.withFont(base: normal, bold: stark);

  pw.TextStyle titel([double g = 24]) => pw.TextStyle(font: titelSchrift, fontSize: g, color: tinte);
  pw.TextStyle ueberschrift([double g = 14]) => pw.TextStyle(font: stark, fontSize: g, color: tinte);
  pw.TextStyle text([double g = 11]) => pw.TextStyle(font: normal, fontSize: g, color: tinte, lineSpacing: 2);
  pw.TextStyle klein([double g = 9]) => pw.TextStyle(font: normal, fontSize: g, color: leise);
  pw.TextStyle marke([double g = 8.5]) => pw.TextStyle(font: stark, fontSize: g, color: leise, letterSpacing: 1.1);

  /// Großer neutraler Code (Außenseite von Karten und Umschlägen).
  pw.TextStyle code([double g = 40]) => pw.TextStyle(font: stark, fontSize: g, color: tinte, letterSpacing: 3);

  pw.Document neuesDokument(String titel) => pw.Document(theme: theme, title: titel, author: 'Mordakte Partymodus');

  /// Höhe von [w] bei [breite] (pt). Für Karten mit fester Größe: vor dem
  /// Satz messen, damit kein Text abgeschnitten wird.
  double hoehe(pw.Widget w, double breite) {
    final doc = neuesDokument('Messung');
    final ctx = pw.Context(document: doc.document).inheritFromAll([doc.theme!]);
    w.layout(ctx, pw.BoxConstraints(maxWidth: breite), parentUsesSize: true);
    return w.box!.height;
  }

  /// Größte Schriftgröße von [start] abwärts bis [minGroesse], bei der
  /// [bauen] in [breite] × [hoeheMax] passt; sonst ein [StateError] (Überlauf
  /// ist ein Fehler, F-14).
  double passendeGroesse(pw.Widget Function(double groesse) bauen, double breite, double hoeheMax, {double start = 11, String wo = ''}) {
    for (var g = start; g >= minGroesse - 1e-9; g -= 0.5) {
      if (hoehe(bauen(g), breite) <= hoeheMax) return g;
    }
    throw StateError('Überlauf: $wo passt auch in ${minGroesse}pt nicht in ${breite.toStringAsFixed(0)} × ${hoeheMax.toStringAsFixed(0)} pt');
  }

  /// Kopf einer Seite: Marke (z. B. „Spielleitungsheft“), Titel, Linie.
  pw.Widget kopf(String marke, String titel) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(marke.toUpperCase(), style: this.marke()),
          pw.SizedBox(height: 3),
          pw.Text(titel, style: this.titel()),
          pw.SizedBox(height: 6),
          pw.Container(height: 0.8, color: linie),
          pw.SizedBox(height: 12),
        ],
      );

  /// Fuß einer Seite: Falltitel links, Seitenzahl rechts. Nie ein Pfad.
  pw.Widget fuss(pw.Context ctx, String links) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(links, style: klein(8)),
          pw.Text('${ctx.pageNumber} / ${ctx.pagesCount}', style: klein(8)),
        ],
      );

  /// Abschnitt mit Überschrift und Absätzen.
  pw.Widget abschnitt(String ueberschrift, List<String> absaetze, {double groesse = 11}) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(ueberschrift, style: this.ueberschrift(12.5)),
          pw.SizedBox(height: 4),
          for (final a in absaetze) pw.Padding(padding: const pw.EdgeInsets.only(bottom: 5), child: pw.Text(a, style: text(groesse))),
          pw.SizedBox(height: 8),
        ],
      );

  /// Gestrichelte Schnittlinie um eine Karte.
  pw.BoxDecoration schnitt() => pw.BoxDecoration(
        border: pw.Border.all(color: linie, width: 0.6, style: pw.BorderStyle.dashed),
      );

  /// Umschlag-Außenseite: Code groß, Hinweis klein.
  pw.Widget aussenseite(String code, String hinweis) => pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(code, style: this.code()),
          pw.SizedBox(height: 10),
          pw.Text(hinweis, style: klein(10), textAlign: pw.TextAlign.center),
        ],
      );
}
