# PRÜFPUNKT (für eine Fortsetzung nach Unterbrechung)
- Stand 15:55: Branch `nachtlauf/burgstadt`, letzter grüner Commit siehe `git log -1`; derselbe Stand liegt auf origin/main und origin/claude/nifty-gauss-s82y27 (N-01, E41).
- Commits nur über `bash tool/commit_gruen.sh "<Nachricht>"` (Gesamttest „schnell“, seit E28 ohne verschluckte rote Tests). Während des Laufs nichts im Baum ändern.
- Abnahme ausschließlich mit `dart run tool/abnahme.dart` (läuft `tool/alle_tests.sh` vollständig; Protokoll in belege/alle_tests_voll.txt, Ergebnis in belege/abnahme.txt).
- Keine offenen Prüfer. Abnahme 13 von 14 (belege/abnahme.txt, Stand 9a7e852). Z-03 gilt für Kartenstand b60891cc2b (Sichtprüfer 23/24). **Z-12 offen:** Inhaltsrunde 23/24 (A-702s) urteilt „Leitplanken nein“ wegen der Herkunftsverteilung der Fallfunktionen im Kanon. Das entscheidet der Nutzer (FÜR DEN NUTZER, E47); danach eine neue Inhaltsrunde nach Vorlage A-702s. Code-Änderungen außerhalb von nachtlauf/ verlangen einen neuen vollständigen Lauf (`dart run tool/abnahme.dart`).
- Ändert sich karten.json, gelten Sichtprüfer-Berichte nicht mehr (Kartenstand); ändern sich Spieltexte, gilt der Gegenprüfer-Bericht nicht mehr (Commit-Zeit).
- Morgenbericht 07:00 ist geschrieben (nachtlauf/MORGENBERICHT.md). Der Branch `finalisierung-schlosskeller` gehört zu einem anderen Arbeitsstrang (eigener Master-Prompt unter planung/) und ist nicht Teil dieses Nachtlaufs.
- Stündlich NACHTPROTOKOLL ergänzen (echte Uhrzeit: `TZ=Europe/Berlin date +%H:%M`).
