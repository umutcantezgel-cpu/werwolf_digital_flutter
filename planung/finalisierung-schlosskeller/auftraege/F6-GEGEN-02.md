F6-GEGEN-02 · Gegenprüfer · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Gegenprüfer
- **Aufgabe:** sucht gezielt Logiklöcher, Abkürzungen und Spoiler – greift Plan, Kanon und Mechanik an.
- **Gute Arbeit:** konkreter Angriff mit Beispielverlauf („Pfad Olli, Entscheidungen …, dann …“), Schwere und kleinstmöglicher Gegenmaßnahme; versucht wirklich, das Spiel zu brechen.
- **Häufigste Fehler:** 1) allgemeine Bedenken statt konkreter Verläufe, 2) nur einen Pfad prüfen, 3) Befunde ohne Schwere.

AUFGABE IN EINEM SATZ: Prüfe gegen alle Spoiler: gemeinsamer Bildschirm vor dem Finale, offene Druckteile und Erzähler, in allen vier Pfaden.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit 095558c im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-02/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-02/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart --alle ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 17173e2 oder neuer): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix-*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-038). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status, kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Lies E-008, E-025, E-033, E-035, E-036, E-037 und die Bild-Checkliste B8.
2. Bildschirm: Gehe die Fotos aller vier Pfade bei ende_meister_n7 und ende_eskalation_n7 vom Titel bis zur Anklage durch. Vergleiche gleiche Fotostellen zwischen den Pfaden: Was unterscheidet sich, und ist jeder Unterschied erlaubt (verdeckte Ansichten dossier und wahl_verdeckt_*, Fundkarten und Bonus-Hinweise nach S-1, Restmenge ohne Namen)?
3. Druck: Erzeuge je Pfad einen Satz mit 7 Rollen in deinen Ordner. Vergleiche 00-spielleitung, 01-detektivbogen, 10-rollenhefte (nur die vier Kernrollen-Hefte) und 12-stimmkarten über die Pfade, nachdem du Codes durch einen Platzhalter ersetzt hast (Codes: zwei Großbuchstaben und eine Ziffer aus 3, 4, 7, 9; Fall-Code fünf Zeichen). Erlaubt sind nur Codes, Reihenfolge der Optionen und Tabellenzeilen. Prüfe außerdem alle Außenseiten (Indizkarten links, Umschläge oben, Fassungen Seite 1, Auflösungsheft Seite 1) und ob die vier Fassungen gleich aufgebaut sind (Seiten, Überschriften).
4. Erzähler: Prüfe in den Texten (texte/erzaehler-*.json) jeden Baustein, der vor dem Finale gesprochen wird: gleicher Wortlaut in allen Pfaden, kein Täterbezug außer pfadgleichem Wissen.
5. Nebenkanäle: Dateinamen, Seitenzahlen, Reihenfolge der Druckseiten, Länge der Texte auf gemeinsamen Bildschirmen, Zeiten in der Rundenzentrale.
6. Schreibe den Bericht.

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-GEGEN-02“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-GEGEN-02 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
