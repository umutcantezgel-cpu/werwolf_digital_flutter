Du bist Autor im Projekt „Burgstadt HD“. Paket **P1-AUTOR-01 · texturen_test v2** (HZ-04). Prüfregel-Änderung „A-302a v2“ (mit FREIGABE angenommen).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md, /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§2, §3, §4) und /home/user/werwolf_digital_flutter/hd/eichung/AUSWERTUNG.md (E-047: Lichtrichtung und Streupixel werden strukturell gemessen).

## Hintergrund
- Palette v2: 10 Rampen × 16 Stufen; Hilfen `rampeVon`, `stufeVon`, `Ramp.at16`, Luma über `paletteR/G/B` (`packages/pixel_engine/lib/src/palette.dart`).
- Textur-Register (`packages/pixel_engine/lib/src/kit/texturen.dart`): `texturEintrag(id)` liefert `TexturEintrag(bauer, dichte)`; `dichte` = 32 (Bestand) oder 64 (HD-Fassung, später in `kit/texturen/<name>.dart`).
- Heute sind alle 36 Texturen Bestand (dichte 32). HD-Fassungen kommen ab P1-AUTOR-04.

## Auftrag: `packages/pixel_engine/test/texturen_test.dart` auf v2 umbauen (nur diese Datei)
Regeln je Textur abhängig von `texturEintrag(id).dichte`:
1. **Katalog:** `TexturId.values.length` ≥ 36 und gleich der Länge von `baueAlleTexturen()`; Index = `TexturId.index` (die feste Zahl 36 entfällt).
2. **Größe:** Bestand (32): 32 oder 64; HD (64): 64 oder 128. Quadratisch.
3. **Palette:** alle Mip-Stufen nur Indizes < `paletteRgb.length`, keine Transparenz (wie bisher).
4. **Kachelbar:** wie bisher (≥ 60 % Randpaare gleich oder benachbart; benachbart = gleiche Rampe, |stufeVon| ≤ 2).
5. **Stufen:** Bestand: höchstens 5 verschiedene Indizes (wie bisher). HD: je Rampe höchstens 8 verschiedene Stufen, höchstens 3 Rampen, insgesamt höchstens 14 Indizes.
6. **Grünregel:** wie bisher mit `rampeVon(c) == Ramp.green` (erlaubt nur `wiese`, `dachBiberschwanzMoos`, `bruchsteinMauer`). Zusätzlich: keine Textur außer diesen drei nutzt Rampe 9 (Türkis) mit Stufen < 4 in mehr als 30 % der Pixel? – NEIN, diese Zusatzregel NICHT einbauen (Türkis ist erlaubt).
7. **Streupixel (neu, E-047):** Anteil der Pixel, deren vier Nachbarn (mit Umbruch) alle einen anderen Index haben. HD: ≤ 8 %. Bestand: nur messen und als Testbeschreibung ausgeben (`printOnFailure` nicht nötig – einfach `print('<name> Streupixel x,x %')` in einem eigenen Test „Bestand-Bericht“), nicht prüfen.
8. **Lichtkante (neu, E-047):** L(p) = Luma des Pixels. „Oberkante“ = Pixel p, dessen oberer Nachbar um ≥ 12 Luma dunkler ist; „Unterkante“ = Pixel p, dessen unterer Nachbar um ≥ 12 Luma dunkler ist; ebenso „Linkskante“/„Rechtskante“ mit linkem/rechtem Nachbarn. M_oben = mittlere Luma der Oberkanten-Pixel usw. Licht von oben links heißt: M_oben ≥ M_unten und M_links ≥ M_rechts. Prüfe das für HD-Texturen mit jeweils ≥ 20 Kantenpixeln je Seite; Bestand nur im Bericht ausgeben.
9. **Determinismus:** wie bisher.
10. **Mip:** HD-Texturen haben mindestens 5 Mip-Stufen (Renderer nutzt bis Stufe 4).

Selbstprobe für Regel 7 und 8 (Pflicht, im Test): Baue in einem Test drei kleine Prüftexturen mit `Tex` und `Lcg` aus `package:pixel_engine/pixel_engine.dart` (Werkzeugkasten): (a) Steine mit Licht oben links (`steine(...)` aus dem Werkzeugkasten, 64×64) → Lichtkante bestanden; (b) dieselbe Textur um 180° gedreht (Pixel (x,y) → (n−1−x, n−1−y)) → Lichtkante NICHT bestanden; (c) 30 % zufällig gesetzte Pixel einer Rampe → Streupixel > 8 %. So ist belegt, dass die Messungen wirken.

## Pflichtläufe
- `cd /home/user/werwolf_digital_flutter/packages/pixel_engine && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test test/texturen_test.dart` grün; Bestand-Bericht (Streupixel, Lichtkante je Textur) wörtlich in die Rückgabe.
- `/opt/flutter/bin/dart test` im ganzen Paket grün.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P1-AUTOR-01`.
