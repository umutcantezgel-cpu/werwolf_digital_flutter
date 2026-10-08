import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Spielt den Fall headless wie ein Mensch über Eingaben durch (Detektiv solo,
/// Bots in allen Rollen), macht Bildschirmfotos aller Bildschirme und prüft
/// Palette und Blocktest. `dart run bin/spieltest.dart <ordner> [N] [breite höhe]`
void main(List<String> args) {
  final ordner = args.isEmpty ? '.' : args[0];
  final n = args.length > 1 ? int.parse(args[1]) : 4;
  final w = args.length > 3 ? int.parse(args[2]) : 1280, h = args.length > 3 ? int.parse(args[3]) : 720;
  Directory(ordner).createSync(recursive: true);
  final spiel = Spiel()..groesse(w, h);
  ladeAusRepo(spiel);
  spiel.besetzung = n;
  final e = Eingabe();
  var fehler = 0;
  void tick([int k = 1]) {
    for (var i = 0; i < k; i++) {
      spiel.tick(1 / 30, e);
    }
  }

  void foto(String name) {
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    File('$ordner/$name.png').writeAsBytesSync(encodePngRgba(w, h, rgba, zlib: zlib.encode));
    final pal = countOffPalette(rgba);
    final blk = blockTest(rgba, w, h, spiel.skala!.kUi, areaW: w ~/ spiel.skala!.kUi * spiel.skala!.kUi, areaH: h ~/ spiel.skala!.kUi * spiel.skala!.kUi);
    if (pal != 0 || blk.ratio != 1) fehler++;
    stdout.writeln('$name: ${spiel.bildschirm.runtimeType} · Palette ${pal == 0 ? 'OK' : 'FEHLER'} · Block ${(blk.ratio * 100).toStringAsFixed(1)} %');
  }

  void druecke(Taste t) {
    e.tasteRunter(t);
    tick();
    e.tasteHoch(t);
    tick();
  }

  // Hauptmenü → Allein spielen (Fokus sichtbar machen, bestätigen)
  tick(3);
  druecke(Taste.runter);
  druecke(Taste.bestaetigen);
  final erk = spiel.bildschirm as Erkundung;
  final s = erk.sitzung!;
  s.figuren.alleBacken();
  // Umsehen und zur Festtafel drehen, ein paar Schritte
  erk.yaw = -0.6;
  e.tasteRunter(Taste.hoch);
  tick(20);
  e.tasteHoch(Taste.hoch);
  tick(60);
  foto('01_gewoelbe');
  // Eine Rolle ansprechen: Detektiv vor die nächste Figur stellen
  final fig = s.sim.figuren.values.firstWhere((f) => f.id.startsWith('R') && f.bereich == 'gewoelbe');
  erk.x = fig.x - math.cos(0.0) * 1.2;
  erk.z = fig.z;
  erk.yaw = 0;
  tick();
  druecke(Taste.aktion);
  tick(10);
  foto('02_ansprechen');
  // Speisekammer: Station untersuchen
  final sk = spiel.stadt.bereiche['speisekammer']!;
  final wachs = sk.dinge.firstWhere((d) => d.legende.station == 'BS-01');
  erk.ort = 'speisekammer';
  erk.x = wachs.mitteX;
  erk.z = wachs.mitteZ + 0.9;
  erk.yaw = -math.pi / 2;
  erk.betreten(spiel);
  tick(12); // Einblendung abwarten
  druecke(Taste.aktion);
  tick(5);
  foto('03_station');
  // Detektivblick: Wachs und Absatzabdruck leuchten
  erk.pitch = -0.7;
  druecke(Taste.blick);
  tick(2);
  foto('03b_detektivblick');
  // Raureif im Hof
  final hof = spiel.stadt.bereiche['hof']!;
  final (kx, kz) = hof.markePos('k');
  erk.ort = 'hof';
  erk.x = kx;
  erk.z = kz;
  erk.yaw = 0.15;
  erk.pitch = -0.45;
  erk.betreten(spiel);
  tick(12); // Einblendung abwarten
  foto('03c_raureif');
  druecke(Taste.blick);
  erk.pitch = 0;
  // Fallakte öffnen
  druecke(Taste.akte);
  tick(2);
  foto('04_fallakte');
  druecke(Taste.zurueck);
  // Zeitraffer bis zur Lagerunde, jeweils Entscheidungen per Tippen auf den ersten Knopf
  s.sim.tempo = 65 / 20;
  var phasenFotos = 0;
  for (var schritt = 0; schritt < 20000 && s.fall.abschnitt != Abschnitt.ende; schritt++) {
    tick();
    final b = spiel.bildschirm;
    if (b is LagerundeBildschirm) {
      if (phasenFotos < 2) {
        foto('05_lagerunde_p${s.fall.phase}_${phasenFotos++}');
      }
      // Detektiv wählt die echte Spur, wenn er einen begründenden Hinweis kennt (wie ein aufmerksamer Spieler)
      if (b.aktuell != null && b.ergebnis == null) {
        final d = b.aktuell!;
        s.melde(s.fall.waehleDetektiv(d.id, s.sim.bots.detektivWahl(d)));
        b.ergebnis = 'gewählt';
      } else if (b.ergebnis != null) {
        b.ergebnis = null;
        b.aktuell = s.fall.detektivEntscheidungen().firstOrNull;
      } else {
        s.melde(s.fall.weiter());
        if (s.fall.abschnitt == Abschnitt.eingrenzung) {
          spiel.wechsle(AnklageBildschirm(s));
        } else {
          spiel.schliesse();
          phasenFotos = 0;
        }
      }
    } else if (b is AnklageBildschirm && s.fall.abschnitt == Abschnitt.eingrenzung) {
      tick();
      foto('06_eingrenzung');
      s.melde(s.fall.klageAn(s.sim.bots.anklage()));
    }
  }
  tick(2);
  foto('07_ende');
  stdout.writeln('Ende: ${s.fall.ende} · angeklagt ${s.fall.angeklagt} · Punkte ${s.fall.punkte} · Fallakte ${s.fall.akte.length} · '
      'Detektiv weiß ${s.fall.wissen['DET']!.length} · Gespräche ${s.fall.erledigt.length}');
  if (s.fall.abschnitt != Abschnitt.ende) fehler++;
  stdout.writeln(fehler == 0 ? 'SPIELTEST OK' : 'SPIELTEST FEHLER ($fehler)');
  exitCode = fehler == 0 ? 0 : 1;
}
