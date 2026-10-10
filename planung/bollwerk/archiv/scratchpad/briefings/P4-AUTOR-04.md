Du bist Autor im Projekt „Burgstadt HD“. Paket **P4-AUTOR-04 · Form tisch v2** (HZ-07). Lies zuerst /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/FORM-KOPF.md und halte dich daran.

## Gegenstand
Datei `packages/burgstadt_spiel/lib/src/bau/formen/tisch.dart` (heute die Muster-Form v1: Platte + 4 Beine), Klasse `TischForm`, `name` = `'tisch'`. Du ersetzt sie durch v2.
Bestand (Legende, 37 Arten): „Tisch mit Kerze“ 0,75–0,9 m holzDielen, „Lange Tafel mit Kerzen“ 0,8 holzBohlen, „Lesepult mit Kerze“ 1,0 holzVertaefelung, „Nachttisch mit Kerze“ 0,6, „Kindertisch mit Kerze“ 0,6, „Nähtisch mit Kerze“ 0,8, „Beistelltisch“ 0,6, „Werkbank“ 0,9 holzBohlen, „Spinnbock“ 0,9 u. a. Größte: „Festtafel“ 7 × 1 m.

## Gestaltung
- **Platte** 0,05 m dick mit 0,03 m Überstand über die Zarge; Oberseite etwas heller.
- **Zarge** (Rahmen unter der Platte) 0,08 m hoch, 0,03 m dick, umlaufend, 0,03 m eingerückt.
- **Beine** 0,07 × 0,07 m an den Ecken unter der Zarge; bei Tischen länger als 2,2 m zusätzlich Beinpaare alle ≤ 2 m; bei `o.hash(0) % 3 == 0` statt vier Beinen **zwei Wangen mit Fußkufe** (Bauerntisch: je Ende eine Brettwange 0,05 m und unten eine Kufe 0,08 × 0,08 über die Tiefe) und ein Längssteg auf 0,15 m Höhe.
- **Lesepult** (hoehe ≥ 1,0 und Grundfläche ≤ 1,0 m): eine geneigte Pultplatte (schräges Quad, 15° zur `rueckseite` hin ansteigend), darunter ein Mittelfuß 0,12 × 0,12 m und ein Kreuzfuß.
- **Kerze:** NUR wenn `o.ding.legende.lichtWarm > 0` (das Ding ist schon eine Lichtquelle des Bestands): ein **einzelner Wachsstumpf** (0,05 × 0,05 m, 0,10 m hoch, Textur `TexturId.putzCreme`, warm 1,0) auf einer **flachen Tonschale** (0,12 × 0,12 m, 0,02 m hoch, `TexturId.ziegelKamin` falls vorhanden, sonst `o.textur`), Flamme als kleiner Quader 0,02 × 0,04 × 0,02 m mit Textur `TexturId.fensterKerze` und `warm: 1, cold: 0`. Lage: auf der Platte, 0,15 m von der Ecke an `rueckseite` und links davon, Variante über `o.hash(1)`. **Kein Ständer, kein Leuchter, keine Arme, kein Eisen** – das wäre die Tatwaffe (Kanon). Bei „Kerzen“ (Plural im Namen ist egal) bleibt es bei EINER Kerze je 2 m Tischlänge, höchstens 3.
- Kein Geschirr, keine Becher, Krüge oder Flaschen (Kanon).
- **Budget:** ≤ 60 Dreiecke + 24 je weiterem Beinpaar + 30 je Kerze.

## Testgrundflächen
1,92 × 0,92 × 0,8 (lichtWarm 0,6); 6,92 × 0,92 × 0,78; 0,92 × 0,92 × 1,0 (Lesepult); 0,42 × 0,42 × 0,6. Erlaubte Texturen: o.textur, putzCreme, ziegelKamin, fensterKerze. Zusatztest: ohne lichtWarm keine fensterKerze-Dreiecke; mit lichtWarm genau 1 Flamme bei 1,92 m Länge.

Probe: `hd/bilder/proben/P4-AUTOR-04.png`. Letzte Zeile der Rückgabe `ENDE PAKET P4-AUTOR-04`.
