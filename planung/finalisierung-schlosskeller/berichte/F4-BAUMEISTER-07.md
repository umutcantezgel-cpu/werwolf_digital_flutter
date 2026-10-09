ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10 (Takt 400 für Semantik-Läufe bestätigt, E-034; Chromium-Pfad fest verdrahtet wie in probe.mjs; flutter test lief im ORCH-Lauf grün)

# Bericht F4-BAUMEISTER-07

## Ergebnis F4-BAUMEISTER-07

**DATEIEN**
- `/home/user/werwolf_digital_flutter/tool/e2e/e2e.mjs`: 452 Zeilen (neu)
- `/home/user/werwolf_digital_flutter/tool/e2e/laeufe.mjs`: 52 Zeilen (neu)
- `/home/user/werwolf_digital_flutter/tool/e2e/README.md`: 47 Zeilen (neu)
- Ausgaben, gitignored: `/home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.json` und `bericht.md`, Fotos unter `fotos/e2e/<pfad>_<ende>_n<n>/`

`git status` zeigt nur diese drei Dateien.

**UMGESETZT**
1. Laufliste in `laeufe.mjs`: 80 Läufe (Pfad × Ende × n, fotos = n === 7) und 4 Semantik-Läufe. Exporte `LAEUFE`, `SEMANTIK_LAEUFE`, `alleLaeufe()`.
2. Gerüst in `e2e.mjs`: Server aus `server.mjs`, ein headless Chromium, je Lauf ein eigener Kontext mit 1280×800, höchstens 2 Seiten (`--parallel`), Zeitlimit 6 min mit Fotos, 3 min ohne.
3. Prüfungen a bis e in `pruefe()`: `PARTY fertig`, pfad, ende und rollen, Phasenfolge (Titel optional), Reihenfolge der Fotostellen, Konsolenfehler, pageerror, `PARTY fehler`, fremde Hosts.
4. Fotos in `pruefe`-Reihenfolge: 200 ms nach der Meldung, nacheinander, Dateiname `NNN_<name>.png`.
5. Semantik in `pruefeSemantik()`: Uhrzeit und Erzählertext an `gespraeche_r1` bis `r3`. Vor `finale` (ohne `dossier` und `wahl_verdeckt_*`) weder „Nur für dich“ noch die ersten 40 Zeichen der Täterfassung.
6. Bericht: `bericht.json` und `bericht.md`. Rückgabe 0 nur bei allen bestandenen Läufen.
7. Filter `--nur feld=wert,…` mit den Feldern pfad, ende, n, skript, fotos, semantik. `--parallel 1|2`. `--negativtest` prüft eine Kopie des ersten Laufs mit vertauschter Ende-Erwartung.
8. `README.md` mit Voraussetzungen, Aufrufen und Ausgabeorten.
9. Probeläufe, Negativtest und Selbsttests siehe unten.

**TESTS**
- `flutter test`: nicht ausführbar. Auf dieser Maschine ist kein Flutter-SDK installiert, weder im PATH noch unter üblichen Pfaden. Letzte Zeile: nicht vorhanden. Die Dart-Dateien sind unverändert.
- `node --check e2e.mjs`: OK. `node --check laeufe.mjs`: OK.
- Browser-Läufe in der Abschlussfassung: 11, alle wie erwartet. Dazu 12 Selbsttests der Prüflogik außerhalb des Repos.
- Fehlerpfade ohne Browser (`--nur` mit unbekanntem Feld, ohne Treffer, `--parallel 3`, unbekannte Option): jeweils Exit 2.

**PROBELÄUFE**
- ahmet, ende_meister, n=4: OK (88,8 s)
- ahmet, ende_teilerfolg, n=4: OK (88,1 s)
- ahmet, ende_justizirrtum, n=4: OK (95,1 s)
- ahmet, ende_eskalation, n=4: OK (96,3 s)
- can, ende_eskalation, n=7 mit Fotos: OK (169,2 s), 57 Fotos. Das Foto `021_gespraeche_r2.png` zeigt „RUNDE 2 VON 3“ mit 01:15 und dem Erzählertext.
- olli, ende_meister, n=7, semantik: OK (100,1 s)
- Alle vier Semantik-Läufe gleichzeitig auf 2 Seiten: ahmet OK (126,1 s), fatma OK (119,2 s), olli OK (124,6 s), can OK (128,4 s)
- Negativtest ahmet, n=4, Erwartung vertauscht: „Fehler erkannt“ mit der Meldung „ende: erwartet ende_teilerfolg, ist ende_meister“. Der Lauf steht im `bericht.md`.
- Selbsttest der Prüflogik: Täterfassung, „Nur für dich“ und falsche Uhrzeit vor dem Finale werden gemeldet. Dossier und Finale bleiben erlaubt. Falsches Ende, fehlende Phase, fremde Anfrage und Konsolenfehler werden gemeldet.

**ABWEICHUNG (bitte bestätigen)**
Semantik-Läufe laufen mit takt=400 statt 40, fotos=0 und zeitraffer=240 wie vorgesehen. Bei takt=40 lag der gelesene Bildschirm eine Fotostelle zurück. Ein Probelauf meldete „Uhrzeit 01:15 fehlt an gespraeche_r2 (+4)“. Der Titel ist beim Lesen leer, weil er vor dem ersten Bild gemeldet wird. Er wird bei der Täterprüfung nicht bewertet.

## OFFENE FRAGEN
1. Takt 400 statt 40 für die Semantik-Läufe bitte bestätigen oder die Vorgabe ändern.
2. `flutter test` und `flutter analyze` bitte im Orchestrator-Lauf ausführen. Hier fehlt das SDK.
3. Die Semantik-Prüfung hängt von der Zeit ab. Schlägt eine Prüfung an `gespraeche_r1` bis `r3` fehl, zuerst mit `--parallel 1` wiederholen.
4. Während des 350-ms-Übergangs enthält der Bildschirmtext noch den Vorbildschirm. Bei n=7 kann das keinen Fehlalarm auslösen, weil das Dossier des letzten Platzes (tim) kein Täter ist. Bei anderen Personenzahlen müsste man das neu prüfen.
5. Die volle Suite dauert bei zwei Seiten geschätzt 60 bis 70 Minuten.
6. `bericht.md` zeigt nach den Probeläufen nur den Negativtest. Der Gesamtlauf überschreibt ihn.

=== ENDE F4-BAUMEISTER-07 · BEREIT ZUR RÜCKGABE ===
