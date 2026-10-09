import 'package:pdf/widgets.dart' as pw;

import 'satz.dart';
import 'satz_stil.dart';

// Versiegeltes Auflösungsheft mit Endentabelle (F5-BAUMEISTER-03).
// Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.

void aufloesungsheft(pw.Document doc, DruckKontext k) {
  doc.addPage(pw.Page(pageFormat: DruckStil.format, build: (c) => k.stil.kopf(k.fallTitel, 'aufloesungsheft')));
}
