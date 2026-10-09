# PRÜFPUNKT (für eine Fortsetzung nach Unterbrechung)
- Stand 09:17: Branch `nachtlauf/burgstadt`, letzter grüner Commit siehe `git log -1`; Sicherung auf origin/nachtlauf/burgstadt.
- Commits nur über `bash tool/commit_gruen.sh "<Nachricht>"` (Gesamttest „schnell“, seit E28 ohne verschluckte rote Tests). Während des Laufs nichts im Baum ändern.
- Abnahme ausschließlich mit `dart run tool/abnahme.dart` (läuft `tool/alle_tests.sh` vollständig; Protokoll in belege/alle_tests_voll.txt, Ergebnis in belege/abnahme.txt).
- Keine offenen Prüfer. Abnahme 14 von 14 (belege/abnahme.txt). Gilt nur, solange sich weder Spieltexte (Z-12, Bericht A-702/gegenpruefer_inhalt_12_bericht.md, Stand a7f1985) noch karten.json (Z-03, Kartenstand fc94af9295) ändern; sonst neue Prüfrunden. Code-Änderungen außerhalb von nachtlauf/ verlangen einen neuen vollständigen Lauf (`dart run tool/abnahme.dart`).
- Ändert sich karten.json, gelten Sichtprüfer-Berichte nicht mehr (Kartenstand); ändern sich Spieltexte, gilt der Gegenprüfer-Bericht nicht mehr (Commit-Zeit).
- Morgenbericht 07:00 ist geschrieben (nachtlauf/MORGENBERICHT.md). Weiter bis „ZIEL ERREICHT“ aus tool/abnahme.dart, dann Abschlussbericht fertigstellen.
- Stündlich NACHTPROTOKOLL ergänzen (echte Uhrzeit: `TZ=Europe/Berlin date +%H:%M`).
