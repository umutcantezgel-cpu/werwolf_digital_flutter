Du bist Autor im Projekt „Burgstadt HD“. Paket **P1-AUTOR-03 · Option --qualitaet für die Fotowerkzeuge** (HZ-01).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md.

## Hintergrund
Seit Skalierung v2 (`packages/burgstadt_spiel/lib/src/skalierung.dart`) gibt es die Qualitätsstufen `sparsam`, `mittel`, `scharf`, `auto` (Enum `Qualitaet`, Hilfe `Qualitaet.ausName(name)`). Die Fotowerkzeuge rendern heute immer mit der Standardstufe der `Optionen` (mittel). Für alle Belege von „scharf“ brauchen sie eine Option.

## Auftrag
Ergänze in diesen vier Werkzeugen unter `packages/burgstadt_spiel/bin/` die Option `--qualitaet <name>` (an beliebiger Stelle der Argumente; Standard `mittel`; unbekannter Name → Meldung und Exit 2):
- `belegfotos.dart`, `stadtfotos.dart`, `bildschirmfoto.dart`, `bereichsfotos.dart`
Umsetzung je Werkzeug: Option aus `args` herauslösen (die übrigen Positionsargumente bleiben wie bisher: `<ordner> [breite höhe]`), dann `Spiel(optionen: Optionen()..qualitaet = q)` statt `Spiel()`. Alles andere (Dateinamen, Ausgabezeilen, Paletten- und Blocktest mit `spiel.skala!.kUi`) bleibt gleich – ohne Option müssen die Bilder byte-gleich zu vorher sein.
Gemeinsame Hilfsfunktion `(Qualitaet, List<String>) qualitaetAusArgs(List<String> args)` in einer NEUEN Datei `packages/burgstadt_spiel/bin/mess/qualitaet_arg.dart` (nur du legst sie an), in allen vier Werkzeugen per `import 'mess/qualitaet_arg.dart';` verwendet.

## Prüfung (Pflicht, Ausgaben in die Rückgabe)
1. `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` (Befunde in fremden Dateien nur nennen)
2. Byte-Gleichheit ohne Option: vorher (`git stash` ist VERBOTEN – stattdessen) die Bilder mit dem unveränderten Stand erzeugen, BEVOR du etwas änderst: `dart run bin/bildschirmfoto.dart /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/p1a03/vorher 1280 720`; nach der Änderung dasselbe nach `.../nachher` und mit `cmp` vergleichen (alle gleich). Dasselbe für `bereichsfotos.dart` (nur Ordner, Standardgröße).
3. Mit Option: `dart run bin/belegfotos.dart <scratch>/p1a03/scharf_quer 1280 720 --qualitaet scharf` und `... 1080 2400 --qualitaet scharf`, `dart run bin/stadtfotos.dart <scratch>/p1a03/scharf_stadt --qualitaet scharf`, `dart run bin/bildschirmfoto.dart <scratch>/p1a03/scharf_schirme 1280 720 --qualitaet scharf`, `dart run bin/bereichsfotos.dart <scratch>/p1a03/scharf_bereiche --qualitaet scharf` – alle mit „Palette OK“ und Blocktest 100 % (Zeilen wörtlich, gekürzt auf die Schlusszeilen).
4. Zwei Bilder aus 3 mit Read ansehen und je einen Satz schreiben.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P1-AUTOR-03`.
