# PRÜFPUNKT (für eine Fortsetzung nach Unterbrechung)
- Stand 07:24: Branch `nachtlauf/burgstadt`, letzter grüner Commit siehe `git log -1`; Sicherung auf origin/nachtlauf/burgstadt.
- Commits nur über `bash tool/commit_gruen.sh "<Nachricht>"` (Gesamttest „schnell“, seit E28 ohne verschluckte rote Tests). Während des Laufs nichts im Baum ändern.
- Abnahme ausschließlich mit `dart run tool/abnahme.dart` (läuft `tool/alle_tests.sh` vollständig; Protokoll in belege/alle_tests_voll.txt, Ergebnis in belege/abnahme.txt).
- Offene Prüfer: Sichtprüfer 15 und 16 (A-605m/n, Berichte nachtlauf/auftraege/A-605/sichtpruefer_15|16_bericht.md, Kartenstand e4624201af), Gegenprüfer Inhalt Runde 10 (A-702k, Bericht A-702/gegenpruefer_inhalt_10_bericht.md mit HEAD-Stempel). Ergebnis aus dem jeweiligen Worktree unter .claude/worktrees/agent-* übernehmen. Ein vollständiger Abnahmelauf läuft, gestartet nach Commit 2e459d4 (Protokoll belege/alle_tests_voll.txt); danach reicht `dart run tool/abnahme.dart --log nachtlauf/belege/alle_tests_voll.txt`, solange sich außerhalb von nachtlauf/ nichts ändert.
- Ändert sich karten.json, gelten Sichtprüfer-Berichte nicht mehr (Kartenstand); ändern sich Spieltexte, gilt der Gegenprüfer-Bericht nicht mehr (Commit-Zeit).
- Morgenbericht 07:00 ist geschrieben (nachtlauf/MORGENBERICHT.md). Weiter bis „ZIEL ERREICHT“ aus tool/abnahme.dart, dann Abschlussbericht fertigstellen.
- Stündlich NACHTPROTOKOLL ergänzen (echte Uhrzeit: `TZ=Europe/Berlin date +%H:%M`).
