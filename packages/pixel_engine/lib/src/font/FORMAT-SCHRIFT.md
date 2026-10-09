# Schrift-Format (eingefroren 08.10.)

Eine Schrift ist ein Dart-Rohtext (`const String kSchrift… = r'''…''';`), Zeile für Zeile:

```
hoehe 11
oberlinie 2
x-hoehe 4
grundlinie 8
abstand 1
zeichen A
.....
.....
..#..
.#.#.
#...#
#...#
#####
#...#
#...#
.....
.....
zeichen leer
...
(11 Zeilen)
```

- Kopf: `hoehe` (Zeilen je Glyphe, 11), `oberlinie` (erste Zeile der Großbuchstaben, 2), `x-hoehe` (erste Zeile der Kleinbuchstaben ohne Oberlänge, 4), `grundlinie` (letzte Zeile über der Grundlinie, 8), `abstand` (Pixel zwischen Glyphen, 1).
- `zeichen X` – genau ein Zeichen; Leerzeichen heißt `zeichen leer`. Danach genau `hoehe` Zeilen aus `.` (leer) und `#` (Tinte), alle gleich breit (1–9).
- Zeilen 0–1: nur Akzente/Umlautpunkte über Großbuchstaben (Ä Ö Ü É Ó Ć Ş Ž) und Zeichen wie `^`, `'`, `"`.
- Zeilen 2–8: Großbuchstaben und Ziffern (7 Zeilen hoch). Kleinbuchstaben: x-Höhe Zeilen 4–8 (5 Zeilen), Oberlängen (b d f h k l t) ab Zeile 2, Umlautpunkte der Kleinbuchstaben in Zeile 2 oder 3.
- Zeilen 9–10: Unterlängen (g j p q y ç ş ğ und `,` `;`).
- Zeilen mit `#!` sind Kommentare.
- Prüfung: `BitmapFont.parse(src).validate()` muss eine leere Liste liefern (`test/font_test.dart`).
