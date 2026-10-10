F6-GEGEN-05 · Druckprüfer · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Druckprüfer
- **Aufgabe:** prüft die PDFs (A4, Lesbarkeit, abgeschnittener Text, neutrale Codes, Spoiler).
- **Gute Arbeit:** Seite für Seite mit Seitenzahl und Befund; prüft gerenderte Seiten, nicht nur den Quelltext.
- **Häufigste Fehler:** 1) nur die erste Seite prüfen, 2) Spoiler auf Umschlägen oder Deckblättern übersehen, 3) Befund ohne Seitenangabe.

AUFGABE IN EINEM SATZ: Prüfe auf Commit f26f2de das Druckspiel nach den Änderungen aus E-039: Stimmen der Kernrollen nur über die Fassung, Hefttexte, Fassungsseiten, Enden.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit f26f2de im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-05/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-05/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart (ohne Schalter: erschöpfend über alle Folgen) ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 17173e2 oder neuer): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix/*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-039; E-039 beschreibt die Änderungen, die du nachprüfst). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status (auch kein git log; den Stand nennt dieser Auftrag, L-06), kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Lies E-039 im Entscheidungslog und die Berichte /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/berichte/F6-SPIEL-02.md und F6-GEGEN-02.md.
2. Erzeuge drei Sätze: Pfad can mit 4 Rollen, Pfad can mit 9 Rollen, Pfad ahmet mit 7 Rollen. Lies alle acht PDFs mit pdftotext; sieh Seite 3 einer Fassung und je eine Seite Stimmkarten als Bild an.
3. Spiele als Spielleitung die Gruppenwahl der drei Runden im Satz can/9 durch: Wähle für jede Rolle A oder B (die Täterrolle einmal B), sammle die passenden Streifen (Gäste von der Karte, Kernrollen aus der Fassung), zähle mit der Codetabelle, wähle den Umschlag. Kannst du als Spielleitung erkennen, welche Kernrolle wie gestimmt hat? Stimmen Heft, Karten und Fassung in der Anleitung überein?
4. Prüfe den Satz can/4: Gibt es Stimmkarten? Was sagt die Datei 12-stimmkarten.pdf? Funktioniert die Zählung nur mit Fassungsstreifen?
5. Prüfe im Spielleitungsheft: Vorlesemarke vor der Lage-Tabelle und im Anhang; Schritt „Auflösung für alle“ und „Die Rollen am Tisch“ nach der Anklage; Wort „Fassung“ statt „Umschlag“ für die versiegelten Fassungen; Hinweis „ohne hineinzusehen“ beim Falten. Prüfe im Detektivbogen die Erklärung von Knall und Scheppern.
6. Zähle die Wörter der vier Fassungs-Innenseiten (Seite 2, 6, 10, 14) in allen drei Sätzen und beschreibe, ob die Täterfassung auf einen Blick erkennbar ist.
7. Prüfe die Enden im Auflösungsheft: Die vier Meister-Enden setzen keinen Fund voraus, den der Detektiv nicht gemacht haben muss; alle acht Enden mit richtiger Anklage enden mit dem Ausgang am Morgen. Prüfe die Geständnisse (kein Schlagverb) und die Gruppenwahl-Texte (keine Verwandtschaft als Grund fürs Schweigen).

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-GEGEN-05“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-GEGEN-05 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
