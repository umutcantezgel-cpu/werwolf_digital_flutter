Du bist Probeläufer im Projekt „Burgstadt HD“. Paket **P0-PROBE-01 · Ausgang einfrieren** (HZ-13).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/PROBELAEUFER.md und halte dich an die Regeln.

## Ziel
Den Ausgangsstand messbar festhalten, gegen den Burgstadt HD geprüft wird.

## Auftrag (Repo `/home/user/werwolf_digital_flutter`, PATH mit `/opt/flutter/bin` voran)
1. Commit des Ausgangs: `git rev-parse HEAD` und `git merge-base HEAD origin/nachtlauf/burgstadt` notieren.
2. `bash tool/alle_tests.sh` (VOLL, ohne Argument) mit Zeitmessung (`date +%s` vorher/nachher), Ausgabe in `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/laeufe/voll_ausgang.txt`. Der Lauf kann 20–40 Minuten dauern (Web-Build, Browser, Leistung); starte ihn mit dem Bash-Werkzeug im Hintergrund (`run_in_background: true`, timeout 3600000) und warte auf die Meldung. Falls er abbricht: die letzten 30 Zeilen (ohne Zeilen mit „Woah“, „superuser“, „📎“) wörtlich festhalten – NICHT reparieren.
3. Danach `bash tool/alle_tests.sh schnell` mit Zeitmessung (Ausgabe nach `.../laeufe/schnell_ausgang2.txt`).
4. `dart run tool/abnahme.dart` aus der Repo-Wurzel (Zeitmessung). Erwartung laut Nachtlauf: 12 von 14 Kriterien erfüllt. Alle Z-Zeilen wörtlich übernehmen.
5. Zahl der Bereiche aus `baueWelt()`: schreibe ein kleines Dart-Skript NUR in den Scratch-Ordner `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/probe01/zaehle.dart`, das die Welt wie `packages/burgstadt_core/bin/erkundung.dart` baut und ausgibt: Anzahl Bereiche gesamt, davon `innen == true`, davon außen (ids nennen), Anzahl Bereiche je id-Präfix. Starte es mit `cd packages/burgstadt_core && dart run /tmp/.../probe01/zaehle.dart` (falls Paketauflösung fehlschlägt: Datei vorübergehend als `packages/burgstadt_core/bin/_zaehle_tmp.dart` anlegen, ausführen, und danach SOFORT wieder löschen; in der Rückgabe vermerken).
6. Schreibe `/home/user/werwolf_digital_flutter/hd/laeufe/P0-PROBE-01.md`:
   - Commit, merge-base, Datum
   - Tabelle `| Lauf | Dauer (s) | Ergebnis | Schlusszeile |` für voll, schnell, abnahme
   - je Ebene von alle_tests (voll) die Ergebniszeilen wörtlich (gefiltert), plus Dauer der Ebene, falls aus den Zeitstempeln ableitbar
   - Abnahme: alle Z-Zeilen wörtlich, Summe erfüllt/14
   - Bereiche: Zahlen aus Schritt 5
   - Abweichungen von der Erwartung (12/14) ausdrücklich
   - letzte Zeile `ENDE PAKET P0-PROBE-01`
Ändere keine Repo-Dateien außer der Ausgabedatei (und ggf. der sofort gelöschten Hilfsdatei).

## Rückgabe
Kurz: Laufzeiten, Ergebnis voll/schnell, Abnahme x/14, Zahl Innen-Bereiche, Pfad der Datei.
