F6-SICHT-04 · Sichtprüfer · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Sichtprüfer
- **Aufgabe:** prüft Bildschirmfotos gegen die Bild-Checkliste.
- **Gute Arbeit:** Punkt für Punkt der Checkliste, je Foto, mit Koordinaten oder Ausschnittbeschreibung.
- **Häufigste Fehler:** 1) Checkliste nicht vollständig abarbeiten, 2) Annahmen über nicht sichtbare Dinge, 3) Farbnamen statt beobachteter Unterschiede.

AUFGABE IN EINEM SATZ: Prüfe in den frischen E2E-Fotos die Täteransicht und die Rückblende nach E-039: verdeckt, vollständig lesbar, Uhr nicht verdeckt.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit 081e258 im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SICHT-04/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SICHT-04/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 081e258, frisch): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix/*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-040). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status (auch kein git log, L-06), kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Lies E-039 (Abschnitte SPIEL-01 Nr. 1 und 2) im Entscheidungslog und die Bild-Checkliste.
2. Sieh in /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/ für jeden Pfad (ahmet, fatma, olli, can) den Lauf <pfad>_ende_meister_n7 an: Fotostellen dossier, dossier_taeter, wahl_verdeckt_r1, wahl_taeter_r1 bis r3. Ist die Täteransicht vollständig lesbar (Scrollhinweis bei langem Text), steht „Nur für dich“ oder eine gleichwertige Verdeckt-Marke da, und ist B in der Täterwahl als harmlos klingende Handlung formuliert?
3. Vergleiche dossier (eine Gastrolle) und dossier_taeter: Verrät der Aufbau (Überschriften, Länge, Farbe) auf einen Blick, wer Täter ist, wenn jemand über die Schulter schaut?
4. Sieh in denselben vier Läufen die Fotos finale und rueckblende_1 bis 3 an: Ist die Zeile mit der Uhrzeit (hh:mm:ss) in jedem Foto ganz lesbar, und malt die Szene nicht in die Kopfzeile?
5. Sieh im Pfad can die Rückblende genau an: Erscheint Ahmet kurz vor dem Scheppern auf dem Weg in den Ost-Saal? Ist das Bild stimmig zur Uhr?
6. Sieh das Foto ende jedes Laufs an und prüfe, dass Ende, Punkte und Fall-Code lesbar sind.

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-SICHT-04“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-SICHT-04 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
