import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../kanon/kanon.dart';

/// PDF-Probeseite (Spike F1-ORCH-11): Kopf eines Rollenhefts aus Kanon-Feldern
/// und ein versiegelter Umschlag mit neutralem Code. Schriften kommen als Bytes
/// herein (CLI und App laden sie aus `assets/fonts`), damit der Kern ohne
/// `dart:io` bleibt. Der eigentliche Drucksatz entsteht in F5.
Future<Uint8List> druckProbe(Kanon kanon, String figurId, {required Uint8List regular, required Uint8List fett}) async {
  final f = kanon.figur(figurId)!;
  final normal = pw.Font.ttf(ByteData.sublistView(regular));
  final stark = pw.Font.ttf(ByteData.sublistView(fett));
  final farbe = PdfColor.fromHex(f['colorCode'] as String);
  final titel = kanon.fall['titel'] as String;
  final doc = pw.Document(title: '$titel · Probeseite', author: 'Mordakte Partymodus');
  pw.TextStyle stil(double groesse, {bool fett = false, PdfColor? farbe}) =>
      pw.TextStyle(font: fett ? stark : normal, fontSize: groesse, color: farbe ?? PdfColors.grey900);
  pw.Widget feld(String name, Object? wert) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(name, style: stil(8.5, fett: true, farbe: PdfColors.grey700)),
          pw.Text('$wert', style: stil(11)),
        ]),
      );
  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(48, 44, 48, 44),
    build: (ctx) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(children: [
        pw.Container(width: 6, height: 38, color: farbe),
        pw.SizedBox(width: 10),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('$titel · Rollenheft', style: stil(10, farbe: PdfColors.grey600)),
          pw.Text('${f['name']} · ${f['roleTitle']}', style: stil(22, fett: true)),
        ]),
      ]),
      pw.SizedBox(height: 18),
      pw.Text('Wer du bist', style: stil(13, fett: true)),
      pw.SizedBox(height: 6),
      feld('Alter', f['age']),
      feld('Im Alltag', f['alltag']),
      feld('So siehst du aus', (f['visualSpecs'] as Map)['outfit']),
      feld('Woran man dich erkennt', (f['visualSpecs'] as Map)['distinguishingFeature']),
      feld('Dein Ziel heute Nacht', f['persoenlichesZiel']),
      pw.SizedBox(height: 14),
      pw.Text('Dein Abend', style: stil(13, fett: true)),
      pw.SizedBox(height: 6),
      pw.Text('${f['motiveAndConflict']}', style: stil(11)),
      pw.Spacer(),
      pw.Container(
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey600, width: 1.2), borderRadius: pw.BorderRadius.circular(6)),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Versiegelter Umschlag', style: stil(12, fett: true)),
            pw.Text('Erst öffnen, wenn die App oder die Spielleitung diesen Code nennt.', style: stil(9.5)),
          ]),
          pw.Text('7K', style: stil(28, fett: true, farbe: PdfColors.grey800)),
        ]),
      ),
      pw.SizedBox(height: 8),
      pw.Text('Probeseite aus dem Kanon (F1). Inhalt und Satz des Rollenhefts folgen in F3 und F5.', style: stil(8, farbe: PdfColors.grey500)),
    ]),
  ));
  return doc.save();
}
