import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';

/// Ebene 3/4: Durchspiel mit Bots für N = 4…20 (mit und ohne Teilen).
void main(List<String> args) {
  final w = findeRepoWurzel()!;
  final d = ladeFallDaten(w);
  var fehler = 0;
  var summeMit = 0, summeOhne = 0, ungeloestOhne = 0;
  for (final n in [4, 6, 8, 10, 12, 14, 16, 18, 20]) {
    final mit = spieleDurch(d, n, seed: n);
    final ohne = spieleDurch(d, n, seed: n, teilen: false);
    stdout.writeln('mit Teilen  $mit');
    stdout.writeln('ohne Teilen $ohne');
    if (mit.geloestBei == null || mit.ende != 'EM-1') fehler++;
    summeMit += mit.geloestBei ?? 999;
    if (ohne.geloestBei == null) {
      ungeloestOhne++;
      summeOhne += 2 * (mit.geloestBei ?? 999);
    } else {
      summeOhne += ohne.geloestBei!;
    }
  }
  final ersparnis = 1 - summeMit / summeOhne;
  stdout.writeln('Teilen-Nutzen: ${(ersparnis * 100).toStringAsFixed(0)} % weniger Schritte bis zur Lösung'
      ' (ohne Teilen $ungeloestOhne von 9 Läufen gar nicht gelöst; ungelöst zählt doppelt)');
  stdout.writeln(fehler == 0 ? 'DURCHSPIEL OK' : 'DURCHSPIEL FEHLER: $fehler Läufe ohne Meisterdetektiv-Ende');
  exitCode = fehler == 0 ? 0 : 1;
}
