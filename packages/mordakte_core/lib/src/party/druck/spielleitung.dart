import 'package:pdf/widgets.dart' as pw;

import 'satz.dart';
import 'satz_stil.dart';

// Spielleitungsheft (ohne Lösung) und Detektivbogen mit Ermittlungsbogen (F5-BAUMEISTER-01).
// Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.

void spielleitungsheft(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'spielleitungsheft')));
}

void detektivbogen(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'detektivbogen')));
}
