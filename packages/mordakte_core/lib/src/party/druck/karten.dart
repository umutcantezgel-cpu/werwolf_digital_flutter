import 'package:pdf/widgets.dart' as pw;

import 'satz.dart';
import 'satz_stil.dart';

// Indizkarten und Hinweis-Umschläge (F5-BAUMEISTER-03).
// Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.

void indizkarten(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'indizkarten')));
}

void umschlaege(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'umschlaege')));
}
