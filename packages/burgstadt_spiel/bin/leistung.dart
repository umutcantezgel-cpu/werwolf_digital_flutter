import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Ebene 7 (Z-09): Leistung auf der Dart-VM, hochgerechnet auf einen vierfach langsameren
/// Prozessor (Faktor 4 – eine Näherung, keine Handy-Messung; die Browser-Messung mit
/// CPU-Drosselung steht im Geräte-Test).
///
/// 1. Spiellogik je Bild (ohne Zeichnen): Fallsitzung mit 20 Rollen, Bewohner, Detektiv
///    geht durch die Oberstadt. Grenze: Mittel × 4 ≤ 4 ms.
/// 2. Nachladespitzen: längster Back-Schritt der Figuren je Bild und längster
///    Bereichswechsel während der Erkundung (Geometrie ist beim Laden gebaut). Grenze: × 4 ≤ 50 ms.
/// 3. Speicher: 20 Spielminuten Erkundung mit Zeichnen, Wechsel durch alle Bereiche;
///    Wachstum des Prozess-Speichers von Minute 1 bis 20 ≤ 10 %.
/// 4. Budget je Ansicht: gezeichnete Meshes ≤ 300, Dreiecke ≤ 14 000.
///
/// `dart run bin/leistung.dart [minuten]`
void main(List<String> args) {
  const faktor = 4;
  final minuten = args.isEmpty ? 20 : int.parse(args.first);
  final spiel = Spiel()..groesse(1280, 720);
  ladeAusRepo(spiel);
  spiel.besetzung = 20;
  var fehler = 0;

  // ---------------------------------------------------------------- Laden
  // ladeAusRepo hat die Geometrie aller Bereiche schon gebaut (Ladezeit); hier noch einmal gemessen
  final u0 = Stopwatch()..start();
  for (final id in spiel.stadt.bereiche.keys) {
    BereichGeometrie(spiel.stadt.bereiche[id]!);
  }
  final ladeMs = u0.elapsedMicroseconds / 1000;
  stdout.writeln('Laden: Geometrie aller ${spiel.stadt.bereiche.length} Bereiche ${ladeMs.toStringAsFixed(0)} ms (beim Start, nicht im Spiel)');
  final s = spiel.starteFall()!;
  final erk = Erkundung(sitzung: s);
  spiel.wechsle(erk);
  final e = Eingabe();
  // Aufwärmen (JIT der VM; im App-Build vorab übersetzt): ein paar Bilder, eine Figur backen
  for (var i = 0; i < 60; i++) {
    spiel.tick(1 / 30, e);
  }

  // ---------------------------------------------------------------- 1. Spiellogik
  // Phase 2: Oberstadt offen, Bewohner unterwegs; Detektiv läuft eine Runde über den Marktplatz
  s.fall.phase = 2;
  s.fall.uhr = 100;
  final stadt = spiel.stadt.bereiche['stadt']!;
  final (bx, bz) = stadt.markePos('b');
  erk
    ..ort = 'stadt'
    ..x = bx
    ..z = bz + 1;
  erk.betreten(spiel);
  final logik = <double>[];
  e.tasteRunter(Taste.hoch);
  for (var i = 0; i < 30 * 60; i++) {
    if (i % 90 == 0) erk.yaw += 0.7;
    final u = Stopwatch()..start();
    s.tick(1 / 30);
    logik.add(u.elapsedMicroseconds / 1000);
  }
  e.tasteHoch(Taste.hoch);
  logik.sort();
  final mittel = logik.reduce((a, b) => a + b) / logik.length;
  final p99 = logik[(logik.length * 0.99).floor()];
  final okLogik = mittel * faktor <= 4;
  if (!okLogik) fehler++;
  stdout.writeln('Spiellogik je Bild (20 Rollen, ${s.sim.bewohner.length} Bewohner, 1800 Bilder): Mittel ${mittel.toStringAsFixed(3)} ms, '
      '99 % ${p99.toStringAsFixed(3)} ms · × $faktor = ${(mittel * faktor).toStringAsFixed(2)} ms · Grenze 4 ms · ${okLogik ? 'OK' : 'ÜBER DER GRENZE'}');

  // ---------------------------------------------------------------- 3./4. Speicher + Budget
  final bereiche = spiel.stadt.bereiche.keys.toList()..sort();
  var maxMeshes = 0, maxDreiecke = 0;
  final bildzeiten = <double>[];
  var spitzeWechsel = 0.0;
  s.figuren.maxBackMs = 0; // erst ab hier (nach dem Aufwärmen) zählen
  s.figuren.backVerteilung.fillRange(0, 64, 0);
  int? rssStart;
  var rssMax = 0;
  const bilderJeMinute = 30 * 60;
  for (var m = 0; m < minuten; m++) {
    for (var i = 0; i < bilderJeMinute; i++) {
      // alle 20 s ein anderer Bereich (an seiner ersten Marke), dazwischen gehen und drehen
      if (i % (30 * 20) == 0) {
        final id = bereiche[(m * 3 + i ~/ (30 * 20)) % bereiche.length];
        final b = spiel.stadt.bereiche[id]!;
        if (b.marken.isNotEmpty) {
          final (mx, mz) = b.markePos(b.marken.keys.first);
          erk
            ..ort = id
            ..x = mx
            ..z = mz;
          final uw = Stopwatch()..start();
          erk.betreten(spiel);
          spitzeWechsel = math.max(spitzeWechsel, uw.elapsedMicroseconds / 1000);
        }
      }
      e.tasteRunter(Taste.hoch);
      if (i % 45 == 0) erk.yaw += 0.9;
      final ub = Stopwatch()..start();
      spiel.tick(1 / 30, e);
      bildzeiten.add(ub.elapsedMicroseconds / 1000);
      final st = spiel.renderer.stats;
      maxMeshes = math.max(maxMeshes, st.meshesDrawn);
      maxDreiecke = math.max(maxDreiecke, st.trianglesDrawn);
    }
    final rss = ProcessInfo.currentRss;
    if (m == 0) rssStart = rss;
    rssMax = math.max(rssMax, rss);
  }
  final wachstum = (rssMax - rssStart!) / rssStart;
  final okSpeicher = wachstum <= 0.10;
  if (!okSpeicher) fehler++;
  stdout.writeln('Speicher: $minuten Spielminuten Erkundung (${bereiche.length} Bereiche, gezeichnet): '
      'nach Minute 1 ${(rssStart / 1048576).toStringAsFixed(0)} MB, höchstens ${(rssMax / 1048576).toStringAsFixed(0)} MB · '
      'Wachstum ${(wachstum * 100).toStringAsFixed(1)} % · Grenze 10 % · ${okSpeicher ? 'OK' : 'ÜBER DER GRENZE'}');
  bildzeiten.sort();
  final spitze = math.max(s.figuren.maxBackMs, spitzeWechsel);
  final okNachladen = spitze * faktor <= 50;
  if (!okNachladen) fehler++;
  stdout.writeln('Nachladespitzen: Figuren backen je Bild höchstens ${s.figuren.maxBackMs.toStringAsFixed(1)} ms, Bereichswechsel höchstens '
      '${spitzeWechsel.toStringAsFixed(1)} ms · × $faktor = ${(spitze * faktor).toStringAsFixed(1)} ms · Grenze 50 ms · ${okNachladen ? 'OK' : 'ÜBER DER GRENZE'}');
  final vt = s.figuren.backVerteilung;
  final backAufrufe = vt.reduce((a, b) => a + b);
  final grenzeMs = (50 / faktor).ceil(); // 13 ms
  final ueber = vt.skip(grenzeMs).reduce((a, b) => a + b);
  stdout.writeln('  Back-Aufrufe mit Arbeit: $backAufrufe, davon ≥ $grenzeMs ms: $ueber '
      '(Eimer ≥ $grenzeMs ms: ${[for (var i = grenzeMs; i < 64; i++) if (vt[i] > 0) '$i ms×${vt[i]}'].join(', ')})');
  stdout.writeln('Zur Information – Bildzeit mit Zeichnen (VM, 320×180): Mittel '
      '${(bildzeiten.reduce((a, b) => a + b) / bildzeiten.length).toStringAsFixed(1)} ms, 99 % ${bildzeiten[(bildzeiten.length * 0.99).floor()].toStringAsFixed(1)} ms, '
      'größte ${bildzeiten.last.toStringAsFixed(1)} ms (Browser-Messung mit Drosselung: Geräte-Test)');
  final okBudget = maxMeshes <= 300 && maxDreiecke <= 14000;
  if (!okBudget) fehler++;
  stdout.writeln('Budget je Ansicht: höchstens $maxMeshes Meshes (≤ 300), $maxDreiecke Dreiecke (≤ 14 000) · ${okBudget ? 'OK' : 'ÜBER DEM BUDGET'}');
  stdout.writeln(fehler == 0 ? 'LEISTUNG OK' : 'LEISTUNG FEHLER ($fehler)');
  exitCode = fehler == 0 ? 0 : 1;
}
