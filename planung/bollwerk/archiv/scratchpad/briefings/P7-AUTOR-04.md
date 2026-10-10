Du bist Autor im Projekt „Burgstadt HD“. Paket **P7-AUTOR-04 · Sprechblasen-Layout und ui_test** (HZ-11).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md, /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§10), /home/user/werwolf_digital_flutter/hd/ZIELFORMEL.md (HZ-11) und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/P7-KOPF.md.

## Ziel (HZ-11)
„0 Überlappungen und 0 abgeschnittene Blasen in 1.000 Lagen.“ Heute ordnet `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart` (Abschnitt „Sprechblasen über Figuren“, ca. Zeilen 435–470) die Blasen direkt im Zeichencode an. Sie können HUD-Elemente verdecken (Knöpfe rechts, Kompass, Ortsplakette oben rechts, Zeitzeile oben links) und haben keinen Zipfel zum Sprecher.

## Auftrag
1. **Neue reine Funktion** in einer NEUEN Datei `packages/burgstadt_spiel/lib/src/blasen_layout.dart`:
   ```
   class BlasenWunsch { final double sx, sy; final int breite, hoehe; … }   // Kopfpunkt in UI-Pixeln, Blasenmaße
   List<Rechteck?> ordneBlasen(List<BlasenWunsch> wuensche, int w, int h, List<Rechteck> gesperrt)
   ```
   Regeln: Reihenfolge = Priorität (nächster Sprecher zuerst). Jede Blase vollständig im Bild mit 2 px Rand; keine Überlappung mit anderen Blasen (2 px Abstand) und mit `gesperrt` (HUD-Flächen); bevorzugt zentriert über dem Kopfpunkt, sonst Kandidaten in fester Reihenfolge: nach oben verschieben, links/rechts versetzt (±bw/2), unter den Kopf; kein Platz → `null` (Blase entfällt, wie heute). Deterministisch.
2. **Einbau** in erkundung.dart: Die Blasen werden über `ordneBlasen` angeordnet; `gesperrt` enthält die Rechtecke der HUD-Knöpfe rechts, des Kompasses, der Ortsplakette und der Zeitzeile (lies im Code, wo sie gezeichnet werden; berechne ihre Rechtecke vor den Blasen – die Knöpfe werden heute NACH den Blasen gezeichnet: ziehe die Rechteck-Berechnung der Knopfspalte vor, ohne die Zeichenreihenfolge der Knöpfe zu ändern). Texte, Zeilenumbruch (`_gekuerzt`, max. 5 Zeilen, 170 px) bleiben gleich.
3. **Zipfel:** Jede Blase bekommt einen 3 px hohen Zipfel (Dreieck, Grundfarbe der Blase, 1 px Randlinie) zur Kopf-x-Position, an der Kante, die dem Kopf zugewandt ist; nur wenn der Kopfpunkt horizontal innerhalb der Blase ±20 px liegt.
4. **Blasen-Panel v2:** `ui.panel(r, grund: UiFarbe.grundDunkel, fangen: false)` bleibt; keine neue Farbe.
5. **NEUER Test** `packages/burgstadt_spiel/test/ui_test.dart`: 1.000 zufällige Lagen (eigener LCG mit festem Seed, kein `dart:math Random`): je Lage 1–6 Wünsche mit zufälligen Kopfpunkten (auch am Rand und außerhalb), Maßen 40–180 × 14–60, Bildgrößen 640×360, 360×800, 801×361 (UI-Raster), `gesperrt` wie im Spiel für diese Größe. Prüfe: keine zwei platzierten Blasen überlappen, keine überlappt `gesperrt`, jede liegt vollständig im Bild. Zähle Überlappungen und Schnitte → beide 0. Zusätzlich: der nächste Sprecher (Index 0) bekommt immer einen Platz, wenn sein Kopfpunkt im Bild liegt und die Blase in eine freie Ecke passt.

## Pflichtläufe
- `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test` grün.
- Belege: ein Spielbild mit 3 sprechenden Figuren vorher/nachher. Erzeuge es mit einem Skript im Scratch-Ordner (Vorbild `bin/spieltest.dart` bzw. `bin/leistung.dart`: Fallsitzung starten, Figuren in den Bereich setzen und `sprechblase`/`blasenZeit` setzen – lies `packages/burgstadt_core/lib/src/fall/simulation.dart`, wie Sprechblasen gesetzt werden); Skript NUR vorübergehend unter `packages/burgstadt_spiel/bin/_tmp_blasen.dart` anlegen, ausführen, danach löschen. Bilder nach `hd/bilder/proben/P7-AUTOR-04_vorher.png` / `_nachher.png` (1280×720) und `_nachher_hoch.png` (1080×2400).

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P7-AUTOR-04`.
