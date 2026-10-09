import 'dart:io';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';

/// Option `--qualitaet <name>` der Fotowerkzeuge (Burgstadt HD, P1-AUTOR-03).
///
/// Die Option darf an beliebiger Stelle der Argumente stehen. Sie wird herausgelöst; die übrigen
/// Argumente behalten ihre Reihenfolge. Ohne Option gilt `mittel` (Standard der [Optionen]).
/// Unbekannter Name oder fehlender Wert: Meldung auf stderr und Exit 2.
(Qualitaet, List<String>) qualitaetAusArgs(List<String> args) {
  var qualitaet = Qualitaet.mittel;
  final rest = <String>[];
  for (var i = 0; i < args.length; i++) {
    if (args[i] != '--qualitaet') {
      rest.add(args[i]);
      continue;
    }
    if (i + 1 >= args.length) _abbruch('--qualitaet braucht einen Namen (sparsam, mittel, scharf, auto)');
    final name = args[++i];
    final gewaehlt = Qualitaet.ausName(name);
    if (gewaehlt == null) _abbruch('unbekannte Qualität „$name“ (sparsam, mittel, scharf, auto)');
    qualitaet = gewaehlt;
  }
  return (qualitaet, rest);
}

Never _abbruch(String meldung) {
  stderr.writeln(meldung);
  exit(2);
}
