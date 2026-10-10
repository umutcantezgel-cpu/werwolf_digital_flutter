Du bist Sichtprüfer (Stimme 3 von 3) im Projekt „Burgstadt HD“. Paket **P0-SICHT-03 · Eichlauf** (HZ-04).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/SICHTPRUEFER.md und /home/user/werwolf_digital_flutter/hd/STILBLATT.md.

## Regeln dieses Eichlaufs (streng)
- Du darfst NUR diese Dateien öffnen: die beiden oben genannten Markdown-Dateien und die 18 Bilder /home/user/werwolf_digital_flutter/hd/eichung/bilder/eich_01.png … eich_18.png (mit dem Read-Werkzeug, je Bild einzeln ansehen).
- Öffne KEINE andere Datei, keinen Quellcode, keine Ordnerliste außerhalb von hd/eichung/bilder, keinen Scratch-Ordner. Führe keine Befehle aus außer dem Ansehen der Bilder und dem Schreiben deiner Ausgabedatei. Andernfalls ist die Eichung wertlos.
- Du arbeitest unabhängig; es gibt keine anderen Stimmen für dich.

## Aufgabe
Die Bilder sind Pixelgrafik aus einem nächtlichen 2,5D-Spiel (Texturkacheln oder Spielszenen). Jedes Bild hat entweder KEINEN Fehler oder GENAU EINEN der folgenden Fehler:
- **Rauschen** – Flächen mit zufällig verstreuten Einzelpixeln/Körnung statt ruhiger Pixelmuster
- **Moiré** – Interferenzmuster/Flimmerbänder in fein gemusterten Flächen, meist zur Ferne hin
- **Stilbruch** – Verstoß gegen das Stilblatt: z. B. weicher Airbrush-Verlauf, Licht von der falschen Seite (Stilblatt: Licht oben links), Fugen in der dunkelsten Stufe / zu dünn
- **Fremdfarbe** – grelle Farbfläche, die nicht zur gedeckten Nachtpalette passt
- **Abgeschnitten** – Inhalt (Text, Panel, Kacheln) am Bildrand unvollständig abgeschnitten

## Ausgabe
Schreibe /home/user/werwolf_digital_flutter/hd/sicht/P0-SICHT-03.md mit einer Tabelle
`| Bild | Urteil (fehlerfrei / Rauschen / Moiré / Stilbruch / Fremdfarbe / Abgeschnitten) | Sicherheit (hoch/mittel/niedrig) | Ort im Bild | Begründung (1 Satz) |`
für alle 18 Bilder, danach die Zeile `ENDE PAKET P0-SICHT-03`.
Antworte am Ende nur mit „fertig“ und dem Dateipfad.
