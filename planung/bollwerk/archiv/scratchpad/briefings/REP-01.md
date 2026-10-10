Du bist Autor im Projekt „Burgstadt HD“. Paket **REP-01 · Flimmermessung v2** (HZ-03). Reparaturpaket zu P0-AUTOR-03 nach Gegenprüfung P0-GEGEN-01.

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und den Gegenprüfbericht /home/user/werwolf_digital_flutter/hd/gegen/P0-GEGEN-01.md (Befunde F-01…F-07).

## Problem
`packages/burgstadt_spiel/bin/flimmer.dart` vergleicht zwei Bilder bei 0,1 m Fahrt. Das misst vor allem Texelbewegung (F-03: flache Texturen 0,031 statt 0,542), hängt nicht von der Auflösung ab und an der Schrittweite (F-05). Szene C ist ein Innenraum statt des Burghofs (F-01), FERNE mittelt eine leere Szene als 0 mit (F-02).

## Neue Messdefinition (genau so umsetzen)
**Flimmerüberschuss** = wie viel mehr Pixelwechsel das Spielbild beim Gehen zeigt als eine überabgetastete Referenz derselben Szene. Damit fällt die normale Bewegung heraus, und jede Auflösung wird gegen ihre eigene Referenz gemessen.
- Je Szene eine Folge von K = 9 Bildern, Kamera rückt je Bild 0,025 m in Blickrichtung (insgesamt 0,2 m).
- **Testfolge:** normales Rendern in der Weltgröße der gewählten Qualität (bzw. `--welt BxH`).
- **Referenzfolge:** dieselbe Szene in 4-facher Breite und Höhe rendern (eigener `PixelBuffer(4B, 4H)` + `Renderer` mit denselben Texturen/Licht, gleiche Kamera, Sichtfeld wie im Spiel), dann je 4×4-Block den häufigsten Palettenindex nehmen (bei Gleichstand den kleineren Index) → Referenzbild in B×H.
- **Bodenmaske:** Pixel, deren Tiefe im Testbild zu einem Weltpunkt mit Höhe < 0,05 m gehört (wie bisher), in allen K Bildern Boden.
- Wechsel je Pixel: Zahl der Übergänge i→i+1 (i = 0…K−2), bei denen sich der Index ändert. Ct = Summe über Bodenpixel (Test), Cr = Summe (Referenz).
- **Überschuss = Ct / Cr − 1** (0 = so ruhig wie die Referenz). Zusätzlich dasselbe nur für Bodenpixel mit z > 6 m (**FERNE**). Szenen ohne Fernpixel (oder Cr = 0) gehen nicht in den FERNE-Mittelwert ein und werden als „–“ gedruckt.
- Mittelwerte **pixelgewichtet** (Summe Ct über alle Szenen / Summe Cr − 1), nicht Mittel der Szenenwerte.
- Szenen: A Oberstadt (Marke `b`, längste freie Richtung, wie bisher), B `innen-kirche` (wie bisher), C **Burghof `hof`** (innen == false, burg.dart „Burghof“), D zweite Oberstadt-Stelle mit langer Gasse (wähle eine Marke `vor-H-…` mit größter Sichtweite > 20 m). Koordinaten drucken.
- Ausgabe je Szene `FLIMMERN <szene> · Boden <n> · Wechsel Test <Ct> · Referenz <Cr> · Überschuss <x,xxx> · FERNE <x,xxx|–>`; am Ende `FLIMMERN v2 · Überschuss <x,xxx> · FERNE <x,xxx> · Welt BxH`.
- Optionen: `--qualitaet <name>`, `--welt BxH` (erzwingt Weltgröße wie in `bin/szenen_mess.dart`), `--png <ordner>` (schreibt je Szene Test- und Referenzbild 0 als PNG).
- Eichung im Code als Selbsttest `--selbsttest`: Mit allen Texturen durch `IndexedTexture.solid(Pal.grey)` ersetzt muss Ct == 0 und Cr == 0 sein (Szene A); drucke `SELBSTTEST OK` oder den Fehler.
- Deterministisch, kein `dart:math Random`.

## Dateien
- Ändere NUR `packages/burgstadt_spiel/bin/flimmer.dart` (darf wachsen bis 400 Zeilen). Gemeinsame Hilfen (Kamera setzen, Sichtweite, PNG, Weltgröße erzwingen) darfst du in eine NEUE Datei `packages/burgstadt_spiel/bin/mess/hilfen.dart` auslagern und per relativem Import `import 'mess/hilfen.dart';` nutzen. `lib/` nicht ändern.

## Pflichtläufe (Ausgaben wörtlich in die Rückgabe)
- `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün
- `dart run bin/flimmer.dart --selbsttest`
- `dart run bin/flimmer.dart` (1280×720, mittel → 320×180) und `dart run bin/flimmer.dart --welt 640x360`
- zweiter Lauf Standard: gleiche Zahlen (Determinismus)
- `--png /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/rep01` und je ein Test- und Referenzbild mit Read ansehen; ein Satz je Bild.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET REP-01`.
