Du bist Autor im Projekt „Burgstadt HD“. Paket **P0-AUTOR-03 · Flimmer- und Banding-Messung** (HZ-02, HZ-03).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und halte dich an die Regeln.

## Ziel
Zwei Messwerkzeuge mit festen, reproduzierbaren Zahlen, gegen die Burgstadt HD später verglichen wird:
- **Flimmern** (Moiré/Texel-Schwimmen beim Gehen): Anteil der Bodenpixel, die sich bei einer kleinen Vorwärtsbewegung ändern, obwohl die Szene ruhig ist.
- **Banding** (harte Lichtstufen): radiales Helligkeitsprofil des Handylichts auf einer glatten Wand.

## Auftrag
1. **Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel/bin/flimmer.dart`. Aufruf `dart run bin/flimmer.dart [breite höhe]` (Standard 1280 720), optional `--qualitaet <name>` (Wert eines `Qualitaet`-Enums aus `lib/src/skalierung.dart` per Name; Standard `mittel`).
   - Welt über `ladeAusRepo(spiel)` (siehe `bin/bereichsfotos.dart`), `spiel.groesse(b, h)`.
   - 3 feste Szenen (Bereich, x, z, yaw; pitch 0, Kamerahöhe 1,62): (A) Oberstadt `stadt` an der Marke `b` mit Blick die längste freie Richtung entlang (nutze die Logik `sichtweite` aus `bin/belegfotos.dart` – kopiere die Funktion, ändere belegfotos nicht), (B) ein großer Innenraum mit Steinboden (wähle den Bereich mit der größten begehbaren Fläche unter `innen == true`), (C) Burghof `hofebene`. Die gewählten Koordinaten druckst du aus.
   - Je Szene: Bild bei Position p und bei p + 0,1 m in Blickrichtung rendern (`spiel.zeichneBereich(id)` nach Setzen von `spiel.renderer.camera` x/y/z/yaw – sieh dir an, wie `lib/src/bildschirme/erkundung.dart` die Kamera setzt, und mache es genauso, ohne Figuren, Handylicht aus). Zusätzlich die Tiefen-Puffer beider Bilder holen.
   - **Bodenpixel**: Pixel unterhalb des Horizonts (y > camera.cy), deren Tiefe zu einem Weltpunkt mit Höhe < 0,05 m gehört (rechne aus Bildzeile, Tiefe 1/z und Kamerahöhe die Höhe: `hy = camY + (cy - (y+0.5))/focal * z`).
   - **Flimmerwert** = Anteil der Bodenpixel (die in beiden Bildern Boden sind), deren Palettenindex sich ändert, nachdem man das zweite Bild um die erwartete Bildverschiebung NICHT korrigiert (einfacher Vergleich gleicher Pixel) – zusätzlich ein zweiter Wert nur für Bodenpixel mit z > 6 m (Ferne, wo Moiré entsteht). Ausgabe je Szene: `FLIMMERN <szene> · Boden <n> Pixel · Änderung <p,ppp> · Ferne <p,ppp>`; am Ende `FLIMMERN MITTEL <p,ppp> · FERNE <p,ppp>`.
2. **Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel/bin/banding.dart`. Aufruf `dart run bin/banding.dart [breite höhe] [--qualitaet name]`.
   - Szene: ein Innenraum, Kamera 2,0 m vor einer langen, glatten Wand, senkrecht darauf blickend (suche einen Bereich und eine Position, an der der Mittelstrahl nach 1,8–2,5 m eine Wand trifft und ± 30° frei ist; drucke die Wahl aus). Raumlicht wie im Spiel, Handylicht an: `renderer.flashStrength = 1` (prüfe in `erkundung.dart`, welcher Wert im Spiel beim Einschalten gilt, und nimm diesen).
   - Profil: entlang der Bildzeile durch die Bildmitte (y = höhe/2) von der Mitte nach rechts bis zum Rand: Helligkeit je Pixel = Luma der Palettenfarbe (0,2126 R + 0,7152 G + 0,0722 B). Mittelung über 8 Zeilen um die Mitte.
   - Kennzahlen: Anzahl verschiedener Palettenindizes im Profil (**Stufen**), größter Helligkeitssprung zwischen benachbarten Mittelwerten in Luma und in „Stufen der eigenen Rampe“ (Palettenindex & 7 bei der heutigen Palette mit 8 Stufen je Rampe – schreibe das als Funktion `stufeVon(int index)` mit Kommentar, damit sie später auf 16 Stufen umgestellt werden kann), Anzahl Sprünge > 1 Stufe.
   - Ausgabe `BANDING · Stufen <n> · größter Sprung <luma> Luma / <s> Stufen · Sprünge>1 <n>` und eine CSV `x;luma;index` nach dem optionalen Argument `--csv <pfad>`.
3. Beide Werkzeuge müssen deterministisch sein (zweimal laufen = gleiche Zahlen; prüfe das).
4. `cd packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün.
5. Proben: Speichere je Werkzeug ein PNG der Messszene (Flimmern: Szene A Bild 1; Banding: die Wandszene) nach `/home/user/werwolf_digital_flutter/hd/bilder/proben/P0-AUTOR-03_flimmer_A.png` und `.../P0-AUTOR-03_banding.png` (PNG wie in `bin/bildschirmfoto.dart`; Welt-Puffer in RGBA über `PixelBuffer.toRgbaBytes`). Ansehen mit Read und in einem Satz beschreiben.

## Rückgabe
Rückgabeformular laut AUTOR.md; unter PROBE die Ausgabezeilen beider Werkzeuge (Standardgröße, mittel) wörtlich. Letzte Zeile `ENDE PAKET P0-AUTOR-03`.
