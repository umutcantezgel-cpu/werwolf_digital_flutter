/// Unterschiede zwischen Original und wirksamem Kanon, für die Prüfung des Overlays.
library;

import 'kanon.dart';

/// Je geändertem Feld eine Zeile `ID · Feld: alt → neu`, neue Datensätze als `+ ID`,
/// entfallene als `- ID`. Fehlende oder leere Werte stehen als `–`.
List<String> overlayDiff(Kanon alt, Kanon neu) {
  final zeilen = <String>[];
  for (final d in neu.datensaetze.values) {
    final a = alt.datensaetze[d.id];
    if (a == null) {
      zeilen.add('+ ${d.id}');
      continue;
    }
    final namen = {...d.felder.keys, ...a.felder.keys};
    for (final name in namen) {
      final vorher = a.felder[name];
      final nachher = d.felder[name];
      if ((vorher ?? '') == (nachher ?? '')) continue;
      zeilen.add('${d.id} · $name: ${_zeige(vorher)} → ${_zeige(nachher)}');
    }
  }
  for (final a in alt.datensaetze.values) {
    if (!neu.datensaetze.containsKey(a.id)) zeilen.add('- ${a.id}');
  }
  return zeilen;
}

String _zeige(String? wert) => (wert == null || wert.isEmpty) ? '–' : wert;
