# Entscheidungslog – Nachtlauf „Spuk im Gewölbe – Burgstadt“

Format: ID · Datum/Uhrzeit (Europe/Berlin) · Entscheidung · Wege · Bewertung · Umkehrprobe · Folgen · Begründung

## N-00 · 08.10. 23:10 · Sicherung per Push auf eigenen Branch (Nutzerentscheidung)
- Entscheidung: Commits werden auf `origin/nachtlauf/burgstadt` gepusht. Kein main, kein PR, kein Deployment, keine neuen Remotes.
- Grund: Die Sitzung läuft in einem flüchtigen Cloud-Container; ohne Push ginge die Nachtarbeit verloren. Der Nutzer hat diese Abweichung von „Push: nein“ vor Start ausdrücklich gewählt.
- Folge: Z-13 wird belegt als „kein Push außer auf den Sicherungs-Branch, keine Laufzeitabrufe fremder Server“.

## N-01 · 08.10. 23:10 · Kanon-Branch lokal eingemergt (Nutzerentscheidung)
- `origin/claude/ecstatic-cerf-7kzi1c` (Ordner `krimidinner/`) wurde in `nachtlauf/burgstadt` gemergt. Die Dateien dort bleiben unverändert; alle Anpassungen laufen über das Overlay `nachtlauf/kanon/ANPASSUNG.md`, damit der andere Branch weiter konfliktfrei mergebar bleibt.

## E1 · Darstellung: Software-Rasterer in reinem Dart mit indizierten Farben
- Ziel/Messgröße: Ich-Perspektive, Palette exakt, Blocktest exakt, ≥30 fps Mittelklasse, headless testbar.
- Wege: (a) GPU `drawVertices` + Paletten-Shader, (b) Gitter-Raycaster (Wolf3D/Build-lite), (c) Software-Rasterer mit Z-Puffer, Colormaps, Bayer-Dithering.
- Bewertung: Spielgefühl a≈c>b (b kann keine Dächer, Hügel, Wehrgang über Gassen); Pixeltreue c>b>a (a nur über Nachquantisierung, Painter-Sortierfehler); Leistung b>a>c; Fairness neutral; Wartbarkeit/Testbarkeit c>b>a (c rendert in `dart test` ohne GPU).
- Umkehrprobe: c ist falsch, wenn 320×180 auf Mittelklasse-Hardware <30 fps bzw. im Web unspielbar. Prüfung per Go/No-Go-Benchmark in Phase 1 (nativ VM/AOT, dart2js, wasm, Chrome 4× gedrosselt).
- Folgen: Nebel begrenzt Sichtweite (~45 m), Zellen-Culling, Qualitätsstufen; Schnellpfade für senkrechte Wände/waagrechte Böden; ggf. eigener Isolate (nativ).
- Begründung: Einzige Variante, bei der Palette- und Blocktest konstruktionsbedingt halten und alle Bilder headless prüfbar sind; dieselbe Pipeline brennt die Figuren.

## E2 · Oberfläche als Pixel-UI im Puffer
- Wege: (a) Flutter-Widgets mit Pixelschrift, (b) CustomPainter auf ganzzahligem Raster, (c) eigene Pixel-UI im indizierten Puffer.
- Gewählt: c, als zweite Ebene in doppelter Weltauflösung (lange Kanon-Texte, Hochkant-Handys). Texteingabe über verstecktes `TextField`.
- Umkehrprobe: falsch, wenn Bedienung/Lesbarkeit leidet → UI-Skalierung als Option, Schriftgrößen 2 Stufen.
- Bestand: Mordakte-Oberfläche bleibt unverändert als „Klassische Fälle“.

## E3 · Paketstruktur
- `packages/pixel_engine` (Palette, Colormaps, Rasterer, Sprites, Schrift, Pixel-UI), `packages/burgstadt_core` (Kanon, Fall-Engine, Stadt, Bots, Löser, Runtime), `packages/room_host` (modusneutrale Raumschicht, später), App-Code unter `lib/burgstadt/`.
- Bestand `mordakte_core`, `server/`, `lib/` alt bleiben unverändert lauffähig.

## E4 · Kanon-Anpassung per Overlay
- Siehe `nachtlauf/KANON.md` und `nachtlauf/kanon/ANPASSUNG.md`. Feldweises Mergen, Ersetzungstabelle, neue Datensätze für Stadtorte. Die notwendigen Schlussfolgerungen S-1…S-7 bleiben unverändert; neue Stadt-Hinweise sind nur Farbe, entlastend oder bestätigend.

## E5 · Figuren prozedural gebrannt, alle 8 Richtungen echt
- Wege: (a) Hand-Pixelraster je Richtung/Bild, (b) 3D-Mini-Modelle gerendert, (c) parametrisches Pixel-Rig mit Teile-Bibliotheken (Text-Raster).
- Gewählt: c mit Echtbrennen aller 8 Richtungen (kein Spiegeln, damit Licht von links oben stimmt).

## E6 · Stadt: Generator mit festem Seed + Handbau der Fall-Orte
## E7 · Mehrspieler: maßgeblicher Host im WLAN, Beitritt per Code/QR, Solo = lokaler Host + Bots
## E8 · Ton: prozedural erzeugte WAVs, Wiedergabe über `audioplayers`
## E9 · Abhängigkeiten (Begründung je Paket wird beim Einbau ergänzt)

## E4a · 08.10. 23:20 · Burg bleibt verschlossener Raum in Phase 1, Oberstadt ab Phase 2
- Ziel: Kanon-Logik S-1 („Täter noch in der Burg“) unverändert lassen und trotzdem eine begehbare, verschlossene Burgstadt bieten.
- Wege: (a) ganze Oberstadt als „verschlossener Raum“ (Bewohner würden Verdächtige → S-1 bricht), (b) Burgtor nur verriegelt statt verschlossen (H-01/PF-7 müssten geändert werden), (c) Burg bleibt bis Phase 2 verschlossen; der Bund (H-03) öffnet zu Phase 2 das Burgtor zur Oberstadt, die Stadttore bleiben zu.
- Gewählt: (c). Keine Änderung an H-01…H-29, S-1…S-10, PF-1…PF-7 nötig; die Stadt wird ab Phase 2 erkundbar, Phase 1 bleibt das klassische Gewölbe-Rätsel mit Blick vom Wehrgang über die dunkle Stadt.
- Umkehrprobe: falsch, wenn Phase 1 zu eng wirkt → Wehrgang begehbar mit Blick über die Stadt; Stadtorte tragen erst ab Phase 2 Zusatzspuren. Folgen: Durchstich (Phase 2 des Nachtlaufs) zeigt Burg + Marktplatz; im Fall ist der Marktplatz ab Fall-Phase 2 betretbar.

## E1-Go · 08.10. 23:41 · Software-Rasterer bestanden (Go)
- Messung `packages/pixel_engine/bin/web_bench.dart` (Prüfszene: 285 Meshes, ~3000 Dreiecke, Himmel, Handylicht, RGBA-Wandlung), Headless-Chrome, CPU-Drosselung per CDP – Näherung, keine Handy-Messung:
  - dart2js: 240×135 = 13,3 ms · 320×180 = 18,7 ms · 384×216 = 27,4 ms je Bild bei 4× Drosselung (ungedrosselt 3,3 / 4,4 / 5,7 ms).
  - wasm: 20,8 / 33,8 / 45,6 ms bei 4× (ungedrosselt 4,6 / 7,0 / 8,8 ms) – im Browser langsamer als dart2js, daher Web-Build mit dart2js.
  - Dart-VM: 320×180 = 2,4–2,7 ms.
- Entscheidung: Go. Standardstufe 320×180 (Mittel), 240×135 (Sparsam), 384×216 (Hoch). Budget für Logik + Figuren ≈ 10 ms bei 4× Drosselung.
- Umkehrprobe: falsch, wenn die echte Stadt (≥150 Gebäude) das Budget sprengt → Zellen-Culling, Nebelgrenze, LOD für Häuser in > 20 m (Quader statt Details).

## E10 · 08.10. 23:40 · Einheitliche Texel-Dichte 32 Texel/m
- Ziel: Figuren mit lesbaren Gesichtern, Welt und Figuren mit gleicher Pixelgröße (keine „Mixels“).
- Wege: 16 Texel/m (Figur 28 px, Gesicht 4 px – zu grob), 32 Texel/m (Figur ~56 px, wie klassische Ego-Spiele), 64 Texel/m (zu feine Texturen, mehr Flimmern).
- Gewählt: 32 Texel/m für Wände, Böden und Figuren (`kTexelsPerMeter`). Mip-Stufen nach Tiefe sorgen dafür, dass in der Ferne nicht flimmert.
- Umkehrprobe: falsch, wenn Nahsicht zu „matschig“ wirkt → Detailtexturen für Hinweis-Objekte mit 64 Texel/m erlaubt, aber nur für kleine Gegenstände.

## E11 · 08.10. 23:38 · Licht: quadratische Stufen, farbtontreue Colormaps, gedämpftes Dithering
- Befund am ersten Bild: volles Bayer-Dithering erzeugte ein Schachbrettmuster, weil benachbarte Lichtstufen in andere Farbrampen sprangen.
- Lösung: Lichtstufen quadratisch verteilt (mehr Stufen im Dunkeln), Farbsuche bevorzugt die eigene Rampe (Faktor 1,6 für fremde Rampen), Dithering-Stärke 0,5 (schmale Übergangsbänder statt Flächen-Raster). Bild: `nachtlauf/bilder/phase1/rasterer_320.png`.

## E12 · 09.10. 00:10 · Bildausgabe: gerade Welt-Skalierung, UI = halbe Skalierung, physische Pixel
- Ziel: Blocktest 100 % für das zusammengesetzte Bild (Welt + Oberfläche) auf jedem Gerät.
- Wege: Welt und UI mit unabhängigen ganzzahligen Faktoren (Mischkanten verletzen den Blocktest, z. B. ×3/×2), UI = Weltauflösung (zu grobe Schrift), Welt-Faktor immer gerade und UI = Hälfte.
- Gewählt: `Skalierung.fuer`: gerader Faktor, dessen kurze Weltseite der Qualitätsstufe am nächsten liegt; UI-Faktor = Hälfte. Hülle zeichnet in physischen Pixeln (`canvas.scale(1/dpr)`, `FilterQuality.none`). Bildweg: nativ `decodeImageFromPixelsSync` (Impeller), sonst asynchron mit Verwerfen statt Rückstau.
- Beleg: Browser-Fotos Desktop 1280×720, Handy quer 2400×1080, Handy hoch 1080×2400: Palette OK, Blocktest 100 % (`nachtlauf/bilder/phase1/geraete/`).
- Grenze: Im Browser mit gebrochenem Pixelverhältnis (z. B. 2,625) skaliert der Compositor die Leinwand um Bruchteile nach → Blocktest dort nur ~60 %. Native App nicht betroffen. → FÜR DEN NUTZER.

## E13 · 09.10. 00:10 · Kanon-Parser webtauglich, Dateizugriff getrennt
- `package:burgstadt_core/burgstadt_core.dart` ohne `dart:io` (Kanon, Proben, Overlay-Diff); `burgstadt_core_io.dart` für VM-Werkzeuge (Kanon aus Dateien, Repo-Wurzel, Leitplanken-Scan).
- Overlay: Genus-Korrektur für „Nebelriese“ (männlich) über ERSETZE-04…08 vor der allgemeinen Ersetzung; Test verhindert „das/dem Nebelriese“.

## E14 · 09.10. 00:10 · Leitplanken-Scanner: Geltungsbereich und Bestand
- Burgstadt-Texte (Kanon, Overlay, Stadtdaten, App- und Spieltexte): 0 Treffer, Prüfung in `tool/alle_tests.sh` (Ebene 10).
- Ausnahmen nur für Regelzitate/Negativ-Anweisungen in K8/K9 und den Kater als Tier (`nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`).
- Bestand „Klassische Fälle“ (`content/`): 28 Fehler (Wein, Portwein, Brandy, Gin, Bar, Bier, Blut-Details). §3 gilt für das ausgelieferte Spiel → Auftrag A-702a: Texte leitplankenkonform umschreiben (Vorratskeller statt Weinkeller, Tee/Kakao/Limonade statt Alkohol, Diner-Theke statt Bar, keine Blutdetails), Mordfälle bleiben Mordfälle (Bestand), `validate`/`simulate` bleiben grün. Begründete Ersetzung im Sinne von §3 „Bestand schützen“.

## E9a · 09.10. 00:16 · Abhängigkeit audioplayers (MIT)
- Zweck: Klänge und Musik (eigene, prozedural erzeugte WAVs in `assets/burgstadt/ton/`, Werkzeug `tool/ton/`). Verbreitet, gepflegt, MIT-Lizenz, unterstützt Android, iOS, Web und Desktop. Keine Netzabrufe (nur gebündelte Dateien).
- Im Spiel abstrakt (`Tonausgabe`), headless/Test über `MerkendeTonausgabe`.

## E5a · 09.10. 00:45 · Figuren: Gliederpuppe aus Grundkörpern, Strahlwurf-Brenner
- Ziel: 20 Rollen + Burgwart + ≥40 Bewohner mit 8 Richtungen und allen Animationen, einheitlicher Pixeldichte, Kontur und lesbaren Silhouetten – über Nacht und reproduzierbar.
- Wege: (a) handgepixelte Raster je Richtung und Bild (≈100 Bilder je Figur – nicht machbar, uneinheitlich), (b) 2D-Teile mit Spiegeln (Licht/Details falsch, Plan E5 ursprünglich), (c) 3D-Gliederpuppe aus analytischen Grundkörpern (Ellipsoid, Quader, Zylinder), per Strahlwurf orthografisch gebrannt, Schattierung in der Materialrampe, automatische Kontur und Innenlinien.
- Gewählt: (c). 104 Bilder je Figur in ~0,1 s (Dart-VM) – Brennen zur Laufzeit beim Laden möglich, keine Asset-Last. Stilisierung (Kopf ×1,24, Glieder ×1,3) für Lesbarkeit bei ~56 px. Bodenkontakt automatisch. Augen nur auf sichtbarer Gesichtshaut.
- Umkehrprobe: falsch, wenn die Figuren „klumpig“ wirken → Teile feiner (mehr Grundkörper), Kontur-Regeln anpassen; Porträts (64×64) bekommen eigenes, höher aufgelöstes Brennen mit Ausdrücken.
