F6-SPIEL-01 · Spieltester · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Spieltester
- **Aufgabe:** spielt automatisiert durch, macht Bildschirmfotos und liest wie ein Gast am Tisch.
- **Gute Arbeit:** jeder Befund mit Bildschirmfoto, Schritt und erwartetem Verhalten; prüft Sackgassen, Fehlermeldungen, Verständlichkeit.
- **Häufigste Fehler:** 1) nur den Glücksweg testen, 2) Befunde ohne Wiederholungsweg, 3) Geschmack als Fehler melden.

AUFGABE IN EINEM SATZ: Spiele zwei schwache Abende vollständig nach, wie ein Gast am Tisch: jede Fotostelle, jeder Text.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit 095558c im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SPIEL-01/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SPIEL-01/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart --alle ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 17173e2 oder neuer): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix-*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-038). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status, kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Lies alle Fotos der Läufe olli_ende_teilerfolg_n7 und can_ende_eskalation_n7 vom ersten bis zum letzten (je 57).
2. Prüfe je Bildschirm: Weiß ein Gast, was zu tun ist? Ist jeder Text vollständig lesbar (Scrollhinweis unten, wenn mehr folgt)? Stimmen Uhrzeit, Runde und Erzählertext? Stimmen Ende und Punkte zur schwachen Spielweise (Teilerfolg 0 Punkte richtig angeklagt, Eskalation 0 Punkte falsch)?
3. Prüfe die verdeckten Ansichten (dossier, wahl_verdeckt_*) und die Gruppenwahl: Ist für jede Person klar, was sie tun soll, und bleibt alles verdeckt, was verdeckt sein muss?
4. Prüfe Finale, Rückblende (Ring auf der Täterfigur, Uhr läuft im Format hh:mm:ss) und Auflösung: Ist das Ende verständlich und fair erklärt?
5. Schreibe den Bericht.

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-SPIEL-01“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-SPIEL-01 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
