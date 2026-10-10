F6-SPIEL-02 · Spieltester · Bauphase F6 · Kanon v1.0 · Schwierigkeit 3

## Spieltester
- **Aufgabe:** spielt automatisiert durch, macht Bildschirmfotos und liest wie ein Gast am Tisch.
- **Gute Arbeit:** jeder Befund mit Bildschirmfoto, Schritt und erwartetem Verhalten; prüft Sackgassen, Fehlermeldungen, Verständlichkeit.
- **Häufigste Fehler:** 1) nur den Glücksweg testen, 2) Befunde ohne Wiederholungsweg, 3) Geschmack als Fehler melden.

AUFGABE IN EINEM SATZ: Spiele einen ganzen Abend auf Papier mit dem Druckspiel durch, als Spielleitung, Detektiv und Gäste zugleich.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit 095558c im Repo /home/user/werwolf_digital_flutter. Lesen ist überall erlaubt. Schreiben NUR in deinen eigenen Ordner /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SPIEL-02/ (anlegen mit mkdir -p). Vor jedem dart-Befehl: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; dann cd /home/user/werwolf_digital_flutter/packages/mordakte_core.
- Druckspiel erzeugen: dart run bin/party_druck.dart --pfad <ahmet|fatma|olli|can> --n <4..20> [--detektiv m|w] --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-SPIEL-02/<name> ; Text: pdftotext -layout <pdf> - ; Seiten als Bild: pdftoppm -r 60 -png <pdf> <präfix>
- Prüfwerkzeuge: dart run bin/party_simulate.dart --alle ; dart run bin/party_pruefen.dart ; dart run bin/party_texte.dart
- E2E-Fotos (Commit 17173e2 oder neuer): /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png, Bericht /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md, Raumfotos /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Fotos mit dem Read-Werkzeug ansehen.
- Kanon: /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (fall.json, figuren.json, raeume.json, entscheidungen.json, beobachtungen.json, tatmatrix-*.json, texte/*.json), Story-Bibel STORY-BIBEL.md, Bild-Checkliste /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md, Ton-Leitfaden /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/TON-LEITFADEN.md, Master /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (7.x).
- Bewusste Entscheidungen: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md (E-001 bis E-038). Was dort begründet entschieden ist, ist KEIN Befund, außer du findest einen neuen Grund, den das Log nicht bedenkt; dann nenne die E-Nummer.

GRENZEN: Keine Datei im Repo ändern, keine Git-Befehle außer git status, kein Netz. Geschmack ist kein Befund. Ein Befund braucht Fundstelle (Datei und Kennung, Seite oder Foto) und das erwartete Verhalten.
SCHWERE: schwer = Fall nicht lösbar oder über eine Abkürzung lösbar, Spoiler vor dem Finale oder im offenen Druck, falsches Ende, Inhaltsregel verletzt, Text abgeschnitten; mittel = verwirrend, uneinheitlich, Widerspruch zwischen Teilen; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Erzeuge in deinen Ordner das Druckspiel für Pfad can mit 9 Rollen und Detektiv m (party_druck --pfad can --n 9 --detektiv m). Lies alle acht Dateien als Text und sieh dir je Datei mindestens drei Seiten als Bild an.
2. Bereite vor wie im Spielleitungsheft beschrieben (Vorbereitung): Ist jeder Schritt ausführbar (falten, schneiden, sortieren nur nach Codes und Namen)?
3. Spiele den Abend nach Heft: Rollen und Fassungen (Codes nennen), Intro, drei Runden mit Entscheidungen (wähle in Runde 1 und 2 je eine falsche Karte, sonst die beste nach deinem Ermittlungsbogen), Gruppenwahl (lege für jede Rolle einen Streifen fest; die Kernrollen geben bei B den Streifen aus ihrer Fassung ab; zähle über die Codetabelle), Umschlag, Resümee mit Restmenge aus dem Bogen, Anklage, Auflösungsheft, Punkte, Ende.
4. Prüfe dabei: Findet die Spielleitung jeden Code, jeden Text und jede Zahl? Stimmt das Ende mit der Endentabelle? Gibt es Widersprüche zwischen Heft, Bogen, Karten, Fassungen und Auflösung? Ist die Detektiv-Fassung m durchgehend (der Detektiv, nicht die Detektivin)?
5. Schreibe den Bericht mit deinem gespielten Verlauf (gewählte Codes, Summen, Umschläge, Restmengen, Punkte, Ende).

RÜCKGABE: über das StructuredOutput-Werkzeug mit den Feldern bericht (der vollständige Bericht als Markdown, beginnend mit „## Bericht F6-SPIEL-02“: GEPRÜFT, ERGEBNIS JE PRÜFPUNKT als Tabelle, BEFUNDE, GESAMTURTEIL, OFFENE FRAGEN, letzte Zeile „=== ENDE F6-SPIEL-02 · BEREIT ZUR RÜCKGABE ===“), befunde (Liste: nr, schwere, ort, befund, erwartet, aenderung) und urteil (ein Satz). Jeder Befund aus dem Bericht steht auch in der Liste.
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Fundstelle? Entscheidungslog gegengelesen?
