F7-DOKU-01 · Dokumentar · Bauphase F7 · Kanon v1.0 · Schwierigkeit 2

## Dokumentar
- **Aufgabe:** schreibt Anleitung, Berichte und Übersichten aus freigegebenem Material.
- **Gute Arbeit:** kurze Schritte, die jemand ohne Vorwissen ausführen kann; jede Aussage mit Befehl oder Datei belegt.
- **Häufigste Fehler:** 1) Dinge beschreiben, die es nicht gibt, 2) Fachsprache ohne Erklärung, 3) veraltete Befehle.

AUFGABE IN EINEM SATZ: Schreibe die Anleitung zum Partyabend „Spuk im Schlosskeller“ für Gastgeber und für Entwickler, so dass beide ohne Rückfrage zurechtkommen.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Stand Commit f26f2de. Lies im Repo /home/user/werwolf_digital_flutter: lib/party/ (Bildschirme, sitzung.dart, skript.dart für den Entwickler-Einstieg), content/party/schlosskeller/texte/ui*.json (die Beschriftungen, wie Gäste sie sehen), packages/mordakte_core/bin/*.dart (Werkzeuge), tool/pruefen.sh, tool/e2e/README.md, /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/MASTER-PROMPT.md (Kapitel 7), /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md, /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/FUER-DEN-NUTZER.md, /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/F5-ENTWURF-DRUCK.md. Fotos zum Nachsehen: /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/fatma_ende_meister_n7/*.png. Befehle zum Nachprüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh; cd /home/user/werwolf_digital_flutter/packages/mordakte_core; dart run bin/party_druck.dart --pfad olli --n 7 --aus /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f7/druck (nur in /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f7/ schreiben).
EIGENE DATEI: /home/user/werwolf_digital_flutter/docs/partykrimi/ANLEITUNG.md (neu). Sonst nichts anlegen oder ändern; keine Git-Befehle außer git status (auch kein git log, L-06). Hinweise für Gastgeber aus FÜR-DEN-NUTZER (z. B. die drei Lacher vorher absprechen, Fassungen ungelesen falten) gehören in die Anleitung.

GRENZEN: Deutsch, kurze Sätze, keine Fachbegriffe im Teil für Gastgeber, keine Spoiler (nenne nie, wer in welchem Pfad Täter ist, und keine Lösungswege). Jede Angabe muss am Code oder an den Texten nachprüfbar sein: Beschriftungen wortgleich aus ui*.json, Befehle so, wie sie im Repo laufen. Keine erfundenen Funktionen.

ARBEITSSCHRITTE:
1. Teil 1 „Für Gastgeber“: Was der Abend ist (Personenzahl 4 bis 20 plus Geburtstagskind als Detektiv, Dauer: drei Runden à 30 Minuten plus Anfang und Ende), was man braucht (ein Bildschirm für alle, Browser; optional Drucker), Start im Hauptmenü („Partyabend“), Einrichtung (Personenzahl, Namen, Detektiv oder Detektivin, Fall-Code, Druck, Rundendauer), verdeckte Rollenvergabe (Gerät reihum, Zwischenstufe), Ablauf je Runde (Pflichtgespräche mit Uhr, Entscheidungen auf der Karte mit Joystick, Pfeiltasten oder Liste, Gruppenwahl reihum verdeckt, Hinweis, Zwischenresümee), Anklage, Finale mit Rückblende, Auflösung, Ende. Erzählerstimme an- und ausschalten. Was tun, wenn jemand ausfällt (Besetzung) und wie der Fall-Code wirkt (gleicher Code, gleicher Fall; ohne Code ein neuer).
2. Teil 2 „Druckspiel“: wann sinnvoll, wie man die acht Dateien bekommt (in der App bei eingestelltem Druck in der Rollenvergabe, oder per Befehl), einseitig drucken, nichts lesen, falten und sortieren wie im Spielleitungsheft, Rolle der Spielleitung, Stimmkarten mit Abreißstreifen und Codetabelle, Fassungen der vier Verdächtigen, versiegeltes Auflösungsheft. Bekannte Grenzen aus FÜR-DEN-NUTZER (Restrisiko beim Ausschneiden).
3. Teil 3 „Für Entwickler“: Werkzeugkette (Flutter 3.47.6 repo-lokal, .werkzeug/env.sh), Aufbau (content/party/schlosskeller als Kanon, packages/mordakte_core/lib/src/party als Logik, lib/party als App), Prüfwerkzeuge und was sie prüfen (dart test, party_texte, party_simulate --pruefen, party_pruefen, party_bibel --pruefen, party_prompts --pruefen, party_druck, tool/pruefen.sh schnell|alles|e2e, tool/e2e/e2e.mjs mit Parametern), Entwickler-Einstieg ?party=schlosskeller&… mit den Parametern aus skript.dart, wie man Texte ändert (texte/*.json, index.json, Textprüfer), Secret-Scan.
4. Prüfe jede Beschriftung und jeden Befehl nach (mindestens: party_druck einmal ausführen, ui-Texte nachschlagen). Schreibe die Datei.

RÜCKGABE (eine letzte Nachricht, Markdown):
## Ergebnis F7-DOKU-01
- DATEIEN: Pfad und Zeilenzahl
- UMGESETZT: je Arbeitsschritt eine Zeile
- NACHGEPRÜFT: welche Befehle ausgeführt, welche Beschriftungen nachgeschlagen
- OFFEN: was du nicht belegen konntest
## OFFENE FRAGEN
- (oder „keine“)
SELBSTPRÜFUNG: Keine Spoiler? Jede Beschriftung wortgleich? Jeder Befehl lauffähig?
Letzte Zeile exakt: === ENDE F7-DOKU-01 · BEREIT ZUR RÜCKGABE ===
