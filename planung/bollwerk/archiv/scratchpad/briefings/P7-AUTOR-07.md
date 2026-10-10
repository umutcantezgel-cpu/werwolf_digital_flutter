Du bist Autor im Projekt „Burgstadt HD“. Paket **P7-AUTOR-07 · Kompass v2** (HZ-11).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md, /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§1, §2, §10) und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/P7-KOPF.md.

## Gegenstand
`packages/burgstadt_spiel/lib/src/kompass.dart`, Funktion `zeichneKompass` (nur diese Funktion und neue private Hilfen in derselben Datei; `kompassMarken` bleibt unverändert, weil Tests sie nutzen).

## Gestaltung (verbindlich, gleiche Rechteck-Maße r)
- Hintergrund: Streifen in `UiFarbe.grundDunkel`, oberste Innenzeile 1 px `Ramp.at16(Ramp.blue, 4)`, unterste Innenzeile 1 px `Ramp.at16(Ramp.blue, 1)` (leichte Wölbung).
- Rand wie Panel: 1 px `UiFarbe.rand`, Ecken frei.
- Striche: 15°-Striche 2 px hoch in `Ramp.at16(Ramp.stone, 9)`, 45°-Striche 4 px hoch in `UiFarbe.randHell`, N/O/S/W-Striche 5 px hoch.
- Buchstaben wie bisher; der Buchstabe nahe der Mitte in `UiFarbe.akzent`, „N“ immer in `Ramp.at16(Ramp.red, 11)` (Nordmarke), sonst `UiFarbe.text`.
- Mittelmarke: kleines Dreieck (3 px breit, 2 px hoch) an der Oberkante in der Mitte in `UiFarbe.akzent`, darunter 1 px Linie bis zur Strichzone.
- Ränder links und rechts: je 6 px weich abgeblendet durch Raster (jedes zweite Pixel der Striche/Buchstaben in diesen 6 px nicht zeichnen – Schachbrett), damit der Streifen nicht hart abgeschnitten wirkt.

## Belege
Vorher/Nachher wie in P7-KOPF.md für `erkundung` (1280×720 und 1080×2400). Zusätzlich ein Ausschnitt nur des Kompasses vergrößert ×4 (mit PIL/Python im Scratch erlaubt) nach `hd/bilder/proben/P7-AUTOR-07_kompass_nachher_x4.png` und dasselbe vorher.
Pflicht: `packages/burgstadt_spiel/test/stadtkarte_test.dart` (Kompass-Test) grün.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P7-AUTOR-07`.
