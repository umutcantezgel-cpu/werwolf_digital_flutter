F6-GEGEN-01 · Gegenprüfer · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Gegenprüfer
- **Aufgabe:** sucht gezielt Logiklöcher, Abkürzungen und Spoiler – greift Plan, Kanon und Mechanik an.
- **Gute Arbeit:** konkreter Angriff mit Beispielverlauf („Pfad Olli, Entscheidungen …, dann …“), Schwere und kleinstmöglicher Gegenmaßnahme; versucht wirklich, das Spiel zu brechen.
- **Häufigste Fehler:** 1) allgemeine Bedenken statt konkreter Verläufe, 2) nur einen Pfad prüfen, 3) Befunde ohne Schwere.

AUFGABE IN EINEM SATZ: Suche jeden Weg, den Fall anders als über die gewollten Beweise zu lösen, und jede Lücke in Mechanik und Endlogik.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit 095558c im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-01/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-01/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart --alle ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 17173e2 oder neuer): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix-*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-038). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status, kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Lies Master 7.6 bis 7.10, die Story-Bibel (Abschnitte Entscheidungen, Regeln, Enden) und die Entscheidungen E-024, E-025, E-030, E-035 bis E-037.
2. Lösbarkeit: Für jeden Pfad muss bestes Spiel genau über Schlüsselbeweis und Fundort zum Täter führen (Regel R-UEBERFUEHRT), und vor Runde 3 darf die Restmenge nie allein auf den Täter zeigen. Prüfe das mit party_simulate --alle und durch Nachrechnen an je einem Pfad.
3. Abkürzungen: Prüfe, ob sich der Täter vorher ableiten lässt aus Struktur statt Inhalt: Zahl und Reihenfolge der Optionen, Ziele (Person, Gegenstand, Raum), Länge oder Zahl der Funde, Bonus-Hinweise (Qualität verborgen?), Erzählerbausteine vor dem Finale (auch Gästewissen npc.*), Restmengen-Texte, Gesprächsthemen der Kernrollen, Rundenwahl-Texte, Rückblende erst nach dem Finale.
4. Mechanik: Gruppenwahl-Schwellen für jede Zahl 4 bis 20 (wahr wenn 5·A ≥ 3·N, neutral wenn 5·A ≥ 2·N), Wirkung der Sabotage (−1, nur Täterrolle), Ausschlussregeln, Endentabelle 0 bis 9 Punkte für richtige und falsche Anklage. Druck: Codetabelle und B-Streifen der Fassungen ergeben dieselbe Summe wie die App (siehe druck_modell_test).
5. Fall-Code: Gleicher Code ergibt denselben Abend (Determinismus); verschiedene Codes desselben Pfads unterscheiden sich nur in neutralen Dingen. Prüfe zwei Codes je Pfad mit party_druck oder dem Simulator.
6. Schreibe den Bericht.

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-GEGEN-01“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-GEGEN-01 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
