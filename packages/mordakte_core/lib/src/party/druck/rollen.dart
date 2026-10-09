import 'package:pdf/widgets.dart' as pw;

import 'satz.dart';
import 'satz_stil.dart';

// Rollenhefte, versiegelte Fassungen der Kernrollen, Stimmkarten (F5-BAUMEISTER-02).
// Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.

void rollenhefte(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'rollenhefte')));
}

void fassungen(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'fassungen')));
}

void stimmkarten(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'stimmkarten')));
}
