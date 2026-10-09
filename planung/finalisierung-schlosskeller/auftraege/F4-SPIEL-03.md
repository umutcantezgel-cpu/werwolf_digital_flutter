F4-SPIEL-03 · Spieltester · Bauphase F4 · Kanon v1.0 · Schwierigkeit 2

## Spieltester
- **Aufgabe:** spielt automatisiert durch, macht Bildschirmfotos und liest wie ein Gast am Tisch.
- **Gute Arbeit:** jeder Befund mit Bildschirmfoto, Schritt und erwartetem Verhalten; prüft Sackgassen, Fehlermeldungen, Verständlichkeit.
- **Häufigste Fehler:** 1) nur den Glücksweg testen, 2) Befunde ohne Wiederholungsweg, 3) Geschmack als Fehler melden.

AUFGABE IN EINEM SATZ: Prüfe die Korrekturen aus E-037 auf den neuen Fotos und lies die Fotos, die beim ersten Mal ungelesen blieben, wie ein Gast am Tisch.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Nur lesen. Fotos mit dem Read-Werkzeug ansehen (PNG). Bericht der E2E-Läufe: /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/bericht.md und bericht.json. Fotos je Lauf mit Fotos: /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/<pfad>_<ende>_n7/<nnn>_<fotostelle>.png (Fotostellen in der Reihenfolge des Abends: titel, einrichtung, rollen, dossier, intro, gespraeche_r1, ziel_e1_1, endgueltig_e1_1, fund_e1_1, …, entscheidungen_fertig_r1, wahl_verdeckt_r1, gruppenwahl_r1, bonus_r1, resuemee_r1, … , anklage, finale, rueckblende_1..3, aufloesung_r3, ende). Raumfotos: /home/user/werwolf_digital_flutter/tool/e2e/fotos/raeume/*.png. Bild-Checkliste: /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/BILD-CHECKLISTE.md (B1 bis B9). Kanon zum Nachschlagen (nur lesen): /home/user/werwolf_digital_flutter/content/party/schlosskeller/ (figuren.json: Namen, colorCode, look; raeume.json; fall.json: runden mit uhrzeit; texte/).
Die Rollen am Tisch heißen wie ihre Figuren (keine Spielernamen eingetragen). Das Skript wählt automatisch; Entscheidungen: best = immer die richtige Option, schlecht = eine falsche; Gruppe a = alle kooperativ, b = alle eigennützig; Anklage richtig/falsch. Enden: ende_meister (richtig, 7–9 Punkte), ende_teilerfolg (richtig, 0–6), ende_justizirrtum (falsch, 4–9), ende_eskalation (falsch, 0–3).
GRENZEN: Nichts ändern, keine Befehle mit Schreibwirkung, keine Git-Befehle außer git status. Höchstens 1.800 Wörter. Geschmack ist kein Befund; ein Befund braucht Foto, Stelle und erwartetes Verhalten.
SCHWERE: schwer = Spoiler vor dem Finale, Sackgasse, falsches Ende, Text abgeschnitten oder unlesbar, Inhaltsregel verletzt; mittel = verwirrend, uneinheitlich, schlecht erkennbar; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Nachprüfung nach E-037 (ENTSCHEIDUNGSLOG.md, letzter Eintrag; Berichte berichte/F4-SPIEL-01/02 und F4-SICHT-01/02). Die Fotos stammen aus einer neuen Matrix auf Commit 17173e2. Prüfe gezielt, ob diese Korrekturen auf den Fotos stimmen: (1) Rückblende: keine zwei Figuren genau übereinander, der Ring sitzt auf der Täterfigur (z. B. ahmet_*_n7/052–055); Uhr immer hh:mm:ss; (2) Einrichtung: Platzhalter „Name (optional)“ vollständig; (3) Rahmen: bei längeren Texten Scrollleiste und unten ein Pfeil-Hinweis, nichts wirkt abgeschnitten; Finale: Erzähltext beginnt über der Fußleiste; (4) Fundkarte steht unter ihrer eigenen Entscheidung (fund_e1_1 zeigt „ENTSCHEIDUNG 1 VON 9“); (5) Rundenkopf ohne den Satz „Bei gutem Spiel …“; (6) Knöpfe „Aus einer Liste wählen“ und „Notizbuch“ als Knöpfe erkennbar; (7) Farbpunkte mit hellem Rand, Ahmets Punkt sichtbar; (8) Rollenliste ohne doppelten Namen; (9) Ende mit Knopf „Zurück ins Hauptmenü“; (10) Tugba in Rostorange, Fatmas Kopftuch taubengrau und im Dunkeln erkennbar (Raumfotos). E-037 nennt auch, was bewusst kein Befund ist (Bonus-Hinweise mit Namen, pfadgleiches Gästewissen, Restmenge als Schluss des Detektivs, Kamera folgt dem Täter): melde dazu nur, wenn du einen neuen Grund findest.
2. Lies danach die beim ersten Mal ungelesenen Stellen: fatma_ende_meister_n7 und fatma_ende_justizirrtum_n7 vollständig vom Titel bis zum Ende (B8 im fatma-Pfad), dazu in olli_ende_meister_n7 die Stellen wahl_verdeckt_r1..r3, gruppenwahl_r2/r3, bonus_r3, entscheidungen_fertig_r1..r3 und die Fotos der Entscheidungen 2 bis 9 (ziel_*, endgueltig_*, fund_*).
3. Prüfe je Lauf: Ende und Punkte, Uhrzeit je Runde, kein Täterhinweis außerhalb der verdeckten Ansichten vor dem Finale (mit den Ausnahmen aus E-037), Sackgassen, Verständlichkeit.
4. Schreibe den Bericht.

AUSGABEFORMULAR (die gesamte Rückgabe in EINER letzten Nachricht, Markdown):
## Bericht F4-SPIEL-03
- GEPRÜFT: Läufe und Fotos (Anzahl, welche)
- ERGEBNIS JE PRÜFPUNKT: Tabelle Punkt | erfüllt/verletzt/nicht prüfbar | Fundstellen
- BEFUNDE: nummeriert, je Befund: Schwere · Foto (Pfad) · Stelle · was zu sehen ist · was erwartet war · kleinste Änderung
- GESAMTURTEIL: freigabefähig ja/nein mit einem Satz
## OFFENE FRAGEN
- (oder „keine“)
SELBSTPRÜFUNG: Jeder Prüfpunkt bewertet? Jeder Befund mit Foto und Stelle? Nur Sichtbares beurteilt?
Letzte Zeile exakt: === ENDE F4-SPIEL-03 · BEREIT ZUR RÜCKGABE ===
