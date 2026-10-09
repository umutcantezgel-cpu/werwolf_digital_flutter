Du bist Gegenprüfer im Projekt „Burgstadt HD“. Paket **P0-GEGEN-01 · Angriff auf die Messwerkzeuge** (HZ-02, HZ-03, HZ-12).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/GEGENPRUEFER.md, /home/user/werwolf_digital_flutter/hd/ZIELFORMEL.md (HZ-02, HZ-03, HZ-12) und /home/user/werwolf_digital_flutter/hd/KERN.md (K-011: Stufe „scharf“ = doppelte lineare Auflösung, Dichte 64 Texel/m, Mip-Formel).

## Gegenstand
Drei neue Messwerkzeuge, gegen die das ganze HD-Projekt gemessen wird:
- `packages/burgstadt_spiel/bin/flimmer.dart` (Flimmerwert; HZ-03 verlangt später „≤ 50 % des Ausgangs“)
- `packages/burgstadt_spiel/bin/banding.dart` (Banding; HZ-02 verlangt „Sprung ≤ 1 Stufe, ≥ 10 Stufen im Profil“)
- `packages/burgstadt_spiel/bin/szenen_mess.dart` (Kosten je Weltpixel; HZ-12 verlangt „≥ 35 % unter Ausgang“ und Go/No-Go für „scharf“)
Ausgangswerte (Rückgaben der Autoren): Flimmern MITTEL 0,542 · FERNE 0,393 (Szenen stadt/innen-kirche/hofebene); Banding 5 Stufen, größter Sprung 1 Stufe; Szenen 320×180 Mittel 3,53 ms, 61,3 ns/Pixel; 640×360 Mittel 12,14 ms, 52,7 ns/Pixel.

## Auftrag – greife an, mit Beleg
Lies alle drei Werkzeuge vollständig und beantworte je Werkzeug:
1. **Misst es das Richtige?** Z. B. Flimmern: Der Wert vergleicht zwei Bilder bei 0,1 m Fahrt ohne Bewegungsausgleich – misst das Moiré/Texelflimmern oder einfach die Bewegung? Wie verhält sich der Wert, wenn die Weltauflösung verdoppelt wird (gleiche 0,1 m Fahrt, doppelt so viele Pixel je Texel-Wechsel)? Ist „≤ 50 % des Ausgangs“ damit überhaupt fair erreichbar oder unmöglich/trivial? Schlage eine Messung vor, die auflösungsunabhängig ist (z. B. zeitliche Oszillation: Anteil Pixel, die in N kleinen Schritten mehrfach hin- und herwechseln; oder Vergleich gegen eine Referenz mit Supersampling).
2. **Banding:** Ist „Stufen = Anzahl verschiedener Indizes in der Mittelzeile“ robust (Dither erzeugt Indizes doppelt)? Ist die Wand repräsentativ? Was passiert mit `stufeVon` bei 16 Stufen?
3. **Szenenmessung:** Wanduhr-Zeit unter Last (andere Prozesse) – wie stark streut sie (lauf das Werkzeug 3× und zitiere die Zahlen)? Sollte Prozessorzeit des Threads gemessen werden (siehe `packages/burgstadt_spiel/bin/leistung.dart`, Funktion mit clock_gettime)? Sind die Szenen repräsentativ (Figuren nur in der Oberstadt)? Stimmt die Regression?
4. **Reproduzierbarkeit:** Läuft jedes Werkzeug zweimal mit gleicher Ausgabe (flimmer, banding)? Prüfe selbst.
5. **Szenenwahl:** flimmer Szene C nutzt `hofebene` (laut burg.dart ein Innenraum „Hofebene des Turms“), gemeint war der Burghof `hof` – Folgen?

Führe die Werkzeuge aus (aus `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel` mit `/opt/flutter/bin/dart run bin/<werkzeug>.dart`), aber ändere KEINE Datei im Repo außer deiner Ausgabe. Eigene Versuchsskripte nur im Scratch-Ordner `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/gegen01/`.

## Ausgabe
`/home/user/werwolf_digital_flutter/hd/gegen/P0-GEGEN-01.md`: Befunde nummeriert, je mit Schwere (schwer/mittel/leicht), Beleg (Datei:Zeile, Zahl, Lauf), Folge für HZ-02/03/12 und konkretem Änderungsvorschlag (was genau soll das Werkzeug stattdessen messen). Letzte Zeile `ENDE PAKET P0-GEGEN-01`.
Antworte am Ende knapp mit der Befundzahl je Schwere.
