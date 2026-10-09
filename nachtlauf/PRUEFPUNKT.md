# PRÜFPUNKT (für eine Fortsetzung nach Unterbrechung)
- Stand 03:55: Branch `nachtlauf/burgstadt`, letzter grüner Commit siehe `git log -1`; Sicherung auf origin/nachtlauf/burgstadt.
- Commits nur über `bash tool/commit_gruen.sh "<Nachricht>"` (Gesamttest „schnell“, seit E28 ohne verschluckte rote Tests). Während des Laufs nichts im Baum ändern.
- Abnahme ausschließlich mit `dart run tool/abnahme.dart` (läuft `tool/alle_tests.sh` vollständig; Protokoll in belege/alle_tests_voll.txt, Ergebnis in belege/abnahme.txt).
- Offene Prüfer: Sichtprüfer 9 und 10 (A-605i, Berichte nachtlauf/auftraege/A-605/sichtpruefer_9|10_bericht.md mit Schlusszeile ERGEBNIS · Paare · Verstöße · Karten <stand>), Gegenprüfer Inhalt 3 (A-702d, Bericht A-702/gegenpruefer_inhalt_3_bericht.md). Ergebnis aus dem jeweiligen Worktree unter .claude/worktrees/agent-* übernehmen.
- Ändert sich karten.json, gelten Sichtprüfer-Berichte nicht mehr (Kartenstand); ändern sich Spieltexte, gilt der Gegenprüfer-Bericht nicht mehr (Commit-Zeit).
- Morgenbericht 07:00 Europe/Berlin nach nachtlauf/MORGENBERICHT.md (Bildschirmfotos: nachtlauf/bilder/z02/, Figuren: nachtlauf/bilder/phase3/figuren_aufstellung.png), danach weiterarbeiten.
- Stündlich NACHTPROTOKOLL ergänzen (echte Uhrzeit: `TZ=Europe/Berlin date +%H:%M`).
