STAND · Bauphase F4 von F7 · Abnahme 9 von 17 · Brüche offen 0 · Aufträge 130 von 175 · Agenten aktiv 1 · nächster Schritt: E2E-Gerüst (F4-BAUMEISTER-07) abnehmen, dann 84 E2E-Läufe, Spiel- und Sichtprüfung, Hub-Kachel nach origin, F4-Tor

# STATUS

## Tagesbericht
| Datum | Stand | Zielabstand | Offene Brüche | Plananpassung |
|---|---|---|---|---|
| 09.10.2026 | F0 läuft: Branch `finalisierung-schlosskeller` ab `d92a675`, Werkzeugkette repo-lokal, Messbasis grün, Planungsordner angelegt | 0 / 17 | 49 (B-01..B-17, V-01..V-32) | – |
| 09.10.2026, 11:10 | F0-Commit `918cb38` gepusht; Plan-Schleife Runde 1 entschieden (E-013), Runde 2 läuft; F1-Entwürfe: raeume, fall, setting, figuren | 0 / 17 | 81 (B, V, A) | Namensbalance verfeinert (E-014 folgt) |
| 09.10.2026, Nachmittag | F0-Tor bestanden; F1: Kanon (13 Dateien), Tatmatrix, Plausibilitätsprüfer 0 Verstöße, Beweisprüfung, Schemas, 24 Tests grün, Karten-Probelauf mit Fotos | 0 / 17 | 81 (Entscheidung in F1-ORCH-03) | E-014 bis E-017 |
| 09.10.2026, Abend | F1-Tor bestanden: 83 Brüche entschieden, Quellabgleich 542 Einträge, 6 Prüfberichte abgenommen (je 10/10), 49 Party-Tests grün, PDF-Probeseite | 5 / 17 | 0 | E-018 bis E-023 |
| 09.10.2026, später Abend | F2-Tor bestanden: Entscheidungsmodell (E-024), 36 Hinweise, Gruppenwahl-Gerüst, Simulator 0,3 s, 142 Party-Tests; Gegenprüfung eingearbeitet (E-025: Qualität verborgen, Überführung braucht Fundort, Optionen gemischt) | 6 / 17 | 0 | E-024, E-025 |
| 09.10.2026, Nacht | F3: Welle 1 (Dossiers, Täter, Detektiv, Intro) und Welle 2a (180 Gespräche, Runden, Auflösung) abgenommen; Gesprächsplan mit Höchstlast; Fundtexte und Kern-Wahltexte gewählt; main (Burgstadt-Strang) zurückgemergt | 6 / 17 | 0 | E-026 bis E-028 |
| 09.10.2026, später Abend nach Neustart | F3-Tor bestanden: 10 KONT- und 5 SENS-Berichte abgenommen, Nachbesserung II der Gespräche (133 von 180) und der 16 Finaltexte (Ausgangsregel), F3-TEST-01 (Dossier, Erzähler, Spoiler über Pfadmengen); 228 Party-Tests, 250 Kern-Tests, `tool/pruefen.sh alles` grün | 9 / 17 | 0 | E-029 |
| 09.10.2026, Nacht | F4: Karte, Sitzung, Renderer-Erweiterung (E-030); 8 Bildschirme, 2 Testaufträge abgenommen (E-031); Party-Requisiten, Seifenblasen, Gags; Dossier in der Du-Form, Rückblende nach Uhr (E-032); Druckmodell F5 vorgezogen; ganze Abende im Browser mit Fotos, 0 Fehler | 9 / 17 | 0 | E-030 bis E-032 |

## Nutzerwünsche (gelten dauerhaft)
- **Bilder immer im Chat zeigen:** Jedes erzeugte Bild (Bildschirmfotos aus E2E- und Probeläufen, gerenderte Karten, PDF-Seiten als Bild) wird sofort mit SendUserFile im Chat gezeigt (Nachricht vom 09.10.2026, 11:10).

## Phasentore
| Tor | Kriterien | Stand |
|---|---|---|
| F0 | Planungsordner vollständig, Plan-Schleife durch, Commit, Push | bestanden (2 Runden, E-013/E-014; Push auf origin) |
| F1 | F-01..F-05 | bestanden (E-021..E-023; ABNAHME F-01..F-05) |
| F2 | F-07; F-06, F-08 mit Platzhaltern | bestanden (E-024, E-025; F-06/F-08 vorläufig) |
| F3 | F-06, F-08, F-10, F-11, F-15 | bestanden (E-029; F-10 Druckteil in F5, F-11 E2E in F4) |
| F4 | F-12, F-13 | offen |
| F5 | F-09, F-14 | offen |
| F6 | F-16; alle erneut | offen |
| F7 | F-17 | offen |

## Fehlerstatistik je Rolle (Regelkreis Lernen)
| Rolle | Abnahmen | Ø Punkte | Nachbesserungen | Häufigster Mangel |
|---|---|---|---|---|
| KONT (Haiku) | 16 (F0 2, F1 4, F3 10) | 9,6 | 0 | liest Kanon während laufender Änderungen; einzelne Fehlleser (KONT-06 D) |
| TEST (Haiku, F2) | 4 | 10 | 0 | – (Rot-Proben vorbildlich) |
| FALL (Haiku) | 1 | 10 | 0 | – |
| GEGEN (Haiku) | 6 | 9,8 | 1 (03a/03b geteilt, E-017) | zu breite Aufträge sprengen die Ausgabelänge |
| SENS (Haiku) | 6 (F1 1, F3 5) | 9,4 | 0 | übersieht, dass Unschuldsfassungen nur im fremden Pfad gelten (SENS-01 Nr. 1–3) |
| BAUMEISTER/TEST (Haiku) | 14 (F4 10) | 9,3 | 0 | Worktree vom falschen Commit (L-03); Spoilerprüfung zu grob (Fünf-Wort-Folgen ohne Pfadmenge) |
| AUTOR (Haiku, F3) | 40 | 9,3 | 2 Wellen (P-2 bis P-4, Ausgangsregel) | Fehler, die erst über viele Dateien sichtbar werden (Last, Partnername, Bund-Fund) |
