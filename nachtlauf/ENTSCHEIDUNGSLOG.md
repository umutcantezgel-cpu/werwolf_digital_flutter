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

## E5a · 09.10. 00:24 · Figuren: Gliederpuppe aus Grundkörpern, Strahlwurf-Brenner
- Ziel: 20 Rollen + Burgwart + ≥40 Bewohner mit 8 Richtungen und allen Animationen, einheitlicher Pixeldichte, Kontur und lesbaren Silhouetten – über Nacht und reproduzierbar.
- Wege: (a) handgepixelte Raster je Richtung und Bild (≈100 Bilder je Figur – nicht machbar, uneinheitlich), (b) 2D-Teile mit Spiegeln (Licht/Details falsch, Plan E5 ursprünglich), (c) 3D-Gliederpuppe aus analytischen Grundkörpern (Ellipsoid, Quader, Zylinder), per Strahlwurf orthografisch gebrannt, Schattierung in der Materialrampe, automatische Kontur und Innenlinien.
- Gewählt: (c). 104 Bilder je Figur in ~0,1 s (Dart-VM) – Brennen zur Laufzeit beim Laden möglich, keine Asset-Last. Stilisierung (Kopf ×1,24, Glieder ×1,3) für Lesbarkeit bei ~56 px. Bodenkontakt automatisch. Augen nur auf sichtbarer Gesichtshaut.
- Umkehrprobe: falsch, wenn die Figuren „klumpig“ wirken → Teile feiner (mehr Grundkörper), Kontur-Regeln anpassen; Porträts (64×64) bekommen eigenes, höher aufgelöstes Brennen mit Ausdrücken.

## E9b · 09.10. 00:31 · Abhängigkeit gamepads (MIT)
- Zweck: Gamepad auf Android, iOS, Web, Desktop mit normalisierten Tasten/Achsen (Flame-Projekt, gepflegt). Belegt durch Gamepad-Simulation im Geräte-Test.

## E14a · 09.10. 00:31 · Klassische Fälle leitplankenkonform (A-702a umgesetzt)
- 49 Textstellen in den drei Szenarien + SCHEMA, Beispielszenario („Dunkle Spritzer“) und Oberflächentexte („verborgene Spuren“) geändert; Lösungen, IDs, validate/simulate unverändert grün. Leitplanken-Scanner prüft jetzt alle Spieltexte (Burgstadt + Klassische Fälle): 0 Fehler.

## E15 · 09.10. 00:46 · Fallsystem: maßgeblicher Fallzustand + Bots, Lösungsmaß wie kanon.py
- Fallzustand (`burgstadt_core/fall`): Phasen nach STADT-05, Wissen je Spieler, Fallakte mit Fäden, Teilen (Einzelne/Akte), Gespräche mit Ersatzregel und Zuhören (IF-1), Stationen (IF-2), Lagerunde mit Meldekarten (IF-5), Rollen-/Detektiv-Entscheidungen, Eingrenzung (AB-*), Endmatrix (EM-1…4), JSON-Speicherstand.
- Rollen-Entscheidungen: „öffentliche“ Folgen legen genannte Hinweise in die Fallakte (IF-8); verschwiegene Optionen („behältst“, „für dich“ …) nicht. Heuristik auf dem Folge-Text – Umkehrprobe: falsch, wenn eine Folge falsch eingeordnet wird → Overlay-Feld „Wirkung“ je Option (Regelsprache, Phase 4).
- Bots: Unschuldige teilen offen, die Täterin nur Entlastendes und wählt verschwiegene Optionen (K7). Lösungsmaß: je notwendiger Schlussfolgerung mindestens zwei bekannte Hinweise (Fairness-Regel aus kanon.py).
- Beleg Ebene 3/4 (`bin/durchspiel.dart`): N = 4…20 jeweils gelöst, Ende EM-1; Teilen spart 72 % Schritte; ohne Teilen bleibt der Fall lösbar (fair).

## E16 · 09.10. 01:24 · Stadtgenerator als Grundlage der Oberstadt; Stadt-Hinweise A-401a übernommen
- Oberstadt kommt aus `generiereStadt` (Seed 1752, deterministisch): ovale Mauer mit Toren, Gassen, Marktplatz mit Uhrturm, Kirchenburg, Laube, 156 Häuser aus `haeuser.json`, 53 Innenräume (12 Fall-Orte von Hand, Rest als Kopien der 30 Hausvorlagen). Umkehrprobe: falsch, wenn Türen ins Leere führen → `stadt_test` prüft jede Tür auf Erreichbarkeit (Ebene 6).
- Geometrie in 16-m-Blöcken (Boden/Decke) und 16-m-Wandblöcken, damit das Kegel-Culling greift: 35–118 von 374 Meshes je Ansicht, 3–5 ms je Bild auf der VM.
- Befund „Stadt zu dunkel“ war ein Messfehler: Die Foto-Werkzeuge knipsten mitten in der Einblendung (Schwarz-Bayer über der UI). Werkzeuge warten jetzt 0,4 s; die Phase-2-Belegbilder sind neu erzeugt.
- A-401a: 24 Stadt-Hinweise (H-S01…24, je Fall-Ort zwei, Phase 2/3, Min 4) in ANPASSUNG.md übernommen; 7 bestätigend, 1 entlastend (ORT-04 für Adnan, wie in ORT-04 festgelegt), 16 Farbe, Stützt nie S-1…S-7. Korrigiert: HW-S18 (Spruch statt Inschrift). Jeder Fall-Ort hat jetzt eine Station im Innenraum; FallDaten liest H-S-Kennungen und ordnet „Station ORT-nn“ zu. Kanon-Proben 0 Befunde, Leitplanken 0.

## E17 · 09.10. 01:38 · Bewohner-Figuren aus ihren Datensätzen neu erzeugt (Sichtprüfung A-605: Abnahme nein)
- Befund beider Sichtprüfer: Die Bewohnerkarten aus A-601b folgten nicht `bewohner.json` (18 Kleiderfarben falsch, Nachthemd-/Tunika-Vorlagen machten Gruppen gleich), braune Schaftstiefel bei 8 Figuren (Wanderstiefel-Anmutung, nur R03/R04 erlaubt), Laken-/Gespenst-Anmutung (B38, B37). Nach Fehlschlag übernimmt Opus.
- Neu: `bewohnerKarte` leitet jede Karte deterministisch aus dem Steckbrief ab; Kleidungsfarben exakt aus dem Datensatz (Test je Kleidungsstück). Frei (erfunden) sind nur Größe, Statur, Kopfgröße, Hautton, Varianten von Frisur/Kopfbedeckung/Jacke/Rock, Bart, Schuhe (nie Schaftstiefel, nie braun) und fehlende Hose/Hemd. `bin/bewohnerkarten.dart` brennt 32 Varianten je Bewohner (Rollen: 16 Varianten nur in Breite innerhalb der Statur-Klasse und Kopfgröße), verwirft Varianten mit Sprite-Prüfbefund und wählt je Figur die, die allen anderen am wenigsten ähnelt (Maß der Sichtprüfer: Silhouetten-IoU vorne/seitlich + Farbabstand in 5 Zonen).
- Erfunden geändert: Schuhe R11 (schwarz), R12/R17 (Halbschuhe grau/schwarz), R20 (Halbschuhe dunkelblau); Hose R11 blaue Jeans (vorher fast schwarz, verwechselbar mit R13). Daten: zwei Hosen „neutral 1“ (Augenfarbe) → „neutral 2“.
- Ergebnis Maß: 1 von 2080 Paaren über der Grenze (R03/R05, Kanon-Farben grün gegen dunkelblau, von beiden Prüfern nicht beanstandet; als begründete Ausnahme im Test). Zweite unabhängige Sichtprüfung folgt (Z-03 verlangt sie).

## E18 · 09.10. 01:57 · Rollen-Fähigkeiten und Sichtschichten (Z-05, aus A-402a)
- Daten `burgstadt_core/data/rollen/faehigkeiten.json` (Vorschlag A-402a, je Rolle ergänzt um einen maschinenlesbaren Auslöser): Station beim Untersuchen (R01, R02, R09, R11, R17, R19), Begegnung mit dem Gegenüber auf 1,6 m oder im Gespräch (R04 jede Rolle, R05→R01, R06/R07/R15/R16→Burgwart, R08→R09, R13→R04), erstes Betreten eines Bereichs (R10/R18 Hof, R12 Wehrgang, R14 Speisekammer, R20 Gewölbe), Werkzeug (R03 an BS-01).
- Wirkung: Ereignis „sicht“ nur an die Rolle, einmal je Rolle, nur für Rollen im Spiel. Inhalte nur aus öffentlichen Datensätzen (Prüfung A-402a: Quellen je Satz, Leitplanken 0). R19 zeigt nur die allgemeine Sichtschicht (Bildausschnitte), keine Deutung der Handhaltung – S-7 bleibt unberührt.
- Spurenarten der Sichtschichten: Fußspuren zusätzlich R11/R20, Wachs R17, Verwischt R03 (`spurenMitSichtschichten`).
- Gegenspiel der Täterin: R03 kann den Absatzabdruck bei BS-01 verwischen (Bot mit 70 % beim Untersuchen); der Abdruck bleibt im Detektivblick als Spurenart „verwischt“ sichtbar. Die Stationshinweise des Kanons bleiben unverändert – Fairness unberührt (Durchspiel 4…20 weiter gelöst).
- Korrektur zu E16/A-602a: Zwei meiner Textänderungen waren falsch und sind zurückgenommen – K-006 nennt den Brunnen mit der Solarlaterne „Geleucht“ im Hof, und der Kanon kennt einen Knall („Als es knallte …“). Bestehen bleibt: Das Stromhaus summt nicht (Stromausfall bis zum Morgen, STADT-04).

## E19 · 09.10. 02:22 · Figuren Runde 3 (Sichtprüfer 3/4: keine Regelverstöße mehr, aber Paare und Grenzfälle) + Porträts
- Befund: 7 starke Paare je Prüfer, fast alle durch gleiche Kleiderfarben im Bewohner-Datensatz; Grenzfälle K9 §8 (Gold am Gürtel wie Taler, Papier in der Hand wie Zettel, Licht in der Hand wie Stablampe); B37-Hemd unter dem Mantel unsichtbar; Blau 2 = Nebelfarbe verschwindet.
- Maß verschärft: verwechselbar auch bei ähnlicher Silhouette (IoU ≥ 0,80) mit ≥ 60 % gleichen Körperfarben (Histogramm Rampe × Helligkeit) – so werten Menschen „gleiche Kleidung, anderer Kopf“.
- Generator wählt jetzt auch Kleiderfarben der Bewohner (Datensatz ist eigene Erfindung, keine Kanon-Vorgabe; keine Farbe wird in Texten genannt) und erfundene Hosenfarben der Rollen (`rollen.json`, Feld „erfunden“); die Wahl wird in `bewohner.json`/`rollen.json` zurückgeschrieben, Daten und Figuren bleiben deckungsgleich. Kein Gold/Bernstein für Beiwerk, keine Papier-/Lichtgegenstände in Bewohnerhänden, Hemd-Ausschnitt unter Mantel/Jacke/Kittel, Hauben nicht haarfarben, keine Stoppelfrisur (wirkte kahl).
- Ergebnis Maß: 0 von 2080 Paaren verwechselbar (Test ohne Ausnahme). Aufstellung auf hellem Grund (Blau 2 bleibt sichtbar). Dritte Sichtprüfung folgt.
- Porträts (A-601c): 64×64, vier Ausdrücke, aus denselben Teilen; schmale helle Front-Leisten bleiben im Porträt weg (bei R03 wirkte die Blusenleiste wie ein Zettel).

## E20 · 09.10. 02:33 · Mehrspieler im lokalen Netz: room_host + BurgstadtRaum (Z-06, Z-08)
- Neues Paket `packages/room_host` (reines Dart, `dart:io`, keine neue Abhängigkeit): WebSocket unter `/raum`, Räume mit 4-Zeichen-Code ohne verwechselbare Zeichen, Wiederverbinden per Token (Ereignisse warten), Takt 30 Hz, Ereignisse sofort, Zustand alle 100 ms; Fehler im Spiel trennen keine Verbindung. Spielneutral über `RaumSpiel` (ohne `dart:io`). Der bestehende Mordakte-Server bleibt unberührt (Z-01).
- `BurgstadtRaum` (Kern, reines Dart, maßgeblich auf dem Host): Lobby (erster Teilnehmer = Gastgeber = Detektiv), N = 4…20 und mindestens Menschen − 1, Rollen R01… in Kanon-Reihenfolge, Bots für die übrigen Rollen. Befehle: Position, untersuchen, teilen an Einzelne/Akte, Fäden, verwischen, Gespräch führen (Hörweite 4 m), fragen, Rollen-/Detektiv-Entscheidungen, weiter, Anklage. Offene Rollen-Entscheidungen von Menschen trifft nach 90 s ein Bot.
- Spoilerschutz: Ereignisse nur an Betroffene (Funde an den Finder, Teilen an Empfänger, Sichtschichten an die Rolle, Akte/Phase/Ende an alle); Hinweistexte nur für Bekanntes und die Akte, fehlende Texte werden nachgeliefert. Interessenfilter: Figuren nur im eigenen Bereich. Fragt der Detektiv eine menschliche Rolle, kommt nur ihr öffentliches Alibi – teilen entscheidet der Mensch.
- Beleg Ebene 8 (`room_host/test/mp_sim.dart`, echte WebSockets): 4, 8 und 20 Teilnehmer spielen bis zum Ende; 0 Abweichungen zwischen jedem Client und dem Host (Phase, Abschnitt, Ende, Akte, Wissen, alle Texte); Teilen an Einzelne und an die Akte kommt nach höchstens 35 ms an (Grenze 1 s); je ein Bot füllt die freie Rolle.

## E21 · 09.10. 02:49 · Figuren Runde 4: Maß an den Sichtprüfern kalibriert
- Sichtprüfer 5/6 (Runde 3): 0 Regelverstöße; 5 bzw. 6 Paare, drei bei beiden (B15/B35, B38/B43, B22/B24) – gleiche Kleiderfarbe bei ähnlicher Form, unabhängig von der Körpergröße.
- Maß ergänzt: Form auf normierter Höhe (Silhouette unabhängig von der Größe), Körperfarben-Histogramm mit Grau = Neutral + Stein und drei Helligkeiten, gleiche Hauptfarbe als Druck in der Variantenwahl. Grenze kalibriert: verwechselbar, wenn Silhouette/Form ≥ 0,80 und ≥ 62 % gleiche Körperfarben (oder IoU ≥ 0,84 mit Farbabstand ≤ 46). Ein strengeres Kriterium (jede gleiche Hauptfarbe) hätte 32 Paare gemeldet, die kein Prüfer sah – verworfen.
- Ergebnis: alle 8 von Prüfern genannten Paare getrennt (Körperfarben-Überlappung jetzt 4–59 %); 1 Grenzfall im Maß (R01/R11, 63 %, Kanon-Oberkörper Schwarz/Dunkelblau, Köpfe klar verschieden) als begründete Ausnahme im Test. Vierte Sichtprüfung folgt.

## E22 · 09.10. 02:54 · Speichern und Fortsetzen (Z-11)
- Spielstand = Schema-Version + Fingerabdruck der Falldaten (Datensätze/Hinweise/Gespräche) + Seed/Tempo + Fallzustand (JSON, schon vorhanden) + Lage aller Fall-Figuren + eigene Lage + besuchte Orte + gezeigte Tutorial-Schritte. Bewohner folgen ihrem Plan (aus der Uhr ableitbar). Passt der Stand nicht (andere Version/Daten), wird er abgelehnt statt falsch geladen.
- Speichern: automatisch jede Minute und nach jedem Phasenwechsel, „Speichern“ im Pausenmenü, beim Gang ins Hauptmenü. „Fortsetzen“ im Hauptmenü, sobald ein Stand da ist. Ablage in der App über `shared_preferences` (schon Abhängigkeit des Bestands, keine neue), in Werkzeugen/Tests im Speicher.
- Nur der Host speichert (im WLAN-Spiel der Gastgeber).

## E23 · 09.10. 03:13 · Gegenprüfung Inhalt (A-702b) umgesetzt
- **Entscheidung:** Alle Befunde der Schwere hoch und mittel sind korrigiert, die geringen dort, wo sie Kanon oder Leitplanken berühren. Tabelle: `auftraege/A-702/gegenpruefer_inhalt_bericht.md`.
- **Grund für M5:** Der Kanon-Datensatz BW-ZUSTAND (O) sagt „bewusstlos“. Er bleibt unverändert, denn der Kanon ist verbindlich. Der Spieltext der Fähigkeit von R06 sagt „eine Weile benommen“ und hält sich damit an die Wortliste der Leitplanken. Dass das Opfer sich an die Sekunden vor dem Schlag nicht erinnert, ist für den Fall nötig: Der Burgwart kann die Täterin nicht nennen.
- **Gegenprobe:** Leitplanken-Scanner 0 Treffer, Kanon-Test und Stadt-Hinweis-Test grün.

## E24 · 09.10. 03:13 · Sichtprüfung 8 (A-605h) umgesetzt
- **B16:** Unter einem Mantel ist nur ein langer Rock sichtbar. Regel im Generator.
- **B08:** Weißes Haar wird mit Stufe 6 statt 7 gemalt. Ein reinweißer Haarkranz unter dem Hut wirkte wie ein Tuch oder Verband (K9 §8).
- **Generator neu gelaufen:** 0 verwechselbare Paare außer der dokumentierten Ausnahme R01|R11 (E21).

## E25 · 09.10. 03:38 · WLAN-Spiel in der App
- **Aufbau:**
  - Der Gastgeber eröffnet den Raum in der App. Dafür startet er `RaumHost` aus room_host, ein lokales Paket ohne neue Abhängigkeit, über `dart:io`, bevorzugt auf Port 47100.
  - Der Gastgeber tritt als erster Teilnehmer `H` bei und ist damit der Detektiv.
  - Gäste verbinden sich per WebSocket über `web_socket_channel`. Das ist eine Bestandsabhängigkeit, daher keine neue.
  - Im Browser ist Beitreten möglich, Eröffnen nicht. Dort wird ein Platzhalter-Import verwendet.
- **Sitzung:** `Fallsitzung` hat die Modi solo, gastgeber und gast.
  - Gastgeber: Fall und Simulation gehören dem Raum.
  - Gast: Ein lokaler Spiegel übernimmt den Zustand (Phase, Uhr, Wissen, Akte, Fäden, Detektiv-Wahlen, entschiedene Rollen-Entscheidungen ohne Option, Figuren im eigenen Bereich).
  - Aktionen gehen als Nachricht an den Raum.
- **Spoilerschutz:** Der Gast bekommt nur, was `BurgstadtRaum.sichtbar` erlaubt. Bei Rollen-Entscheidungen erfährt er nur, *dass* entschieden wurde, nicht welche Option gewählt wurde.
- **Detektiv-Figur:** Mitspieler müssen den Detektiv sehen. Er bekam deshalb eine erfundene Figurenkarte `DET`, denn der Kanon beschreibt das Geburtstagskind nicht, weil es der Mensch spielt. Die Karte zeigt einen steinfarbenen Mantel mit roter Bommelmütze und rotem Schal. Sie läuft durch dieselbe Prüfung auf Unterscheidbarkeit wie alle anderen.
- **Eingabe:**
  - Adresse und Code tippt man über eine Bildschirmtastatur in der Pixel-Oberfläche oder über die echte Tastatur.
  - Ein verstecktes Flutter-Textfeld entfällt.
  - Ohne Neustart bleibt der Pixel-Blocktest gültig.
- **Offen (FÜR DEN NUTZER):**
  - Test mit echten Geräten im WLAN.
  - iOS-Freigabe für das lokale Netz.
  - Wachhalten des Bildschirms (kein wakelock, keine neue Abhängigkeit).
  - Suche ohne Adresse (mDNS) fehlt.

## E26 · 09.10. 03:38 · `tool/abnahme.dart`
- **Aufgabe:** Das Werkzeug rechnet Z-01…Z-14 aus einem vollständigen Lauf von `tool/alle_tests.sh` nach, also aus allen elf Ebenen. Dazu kommen die Daten selbst und die Prüferberichte.
- **Prüferberichte:**
  - Z-03 zählt nur Sichtprüfer-Berichte mit der Schlusszeile `ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten <Stand>`, deren Kartenstand dem aktuellen `karten.json` entspricht.
  - Z-12 zählt nur einen Gegenprüfer-Bericht mit „ja · ja · ja“, der jünger ist als die letzte Textänderung.
- **Z-13:** Es gibt nur den Remote `origin`, und seit Beginn gingen keine Pushes außer auf `nachtlauf/burgstadt`. Belegt wird das über die Reflogs der Remote-Refs. Im Browser gab es keine fremden Abrufe.
- Nur dieses Werkzeug darf „ZIEL ERREICHT“ ausgeben.

## E27 · 09.10. 03:45 · Gegenprüfung Inhalt Runde 2 (A-702c): Umsetzung und Abwägungen
- **Umgesetzt:**
  - **M3:** Die Nachtpläne von B03, B07 und B10 passen jetzt zu den Stationshinweisen ihrer Phase. Die Bäckerin steht ab 02:00 in der Backstube. Die Inhaberin der Teestube zählt um 03:00 auf dem Marktplatz die Schläge und öffnet danach die Teestube. Der Schreinermeister hobelt ab 03:00.
  - **M4:** Die Saum-Andeutung ist gestrichen; es geht jetzt um einen Knopf.
  - **G1:** Das Apotheken-Umfeld ist entschärft: Kräutertee, Pflaster, Pfefferminzbonbons.
  - **G2:** „Blaues Faß“ heißt jetzt „Blaues Tuch“. Die Teestube ohne Schild ist jetzt eine Flickstube.
  - **G6:** „Stadtburg“.
  - **G8:** „Sitzungssaal“.
  - **G9:** Der Grabstein ohne Hinweischarakter.
  - **G10:** Drei „verlaufen/verirren“-Echos umformuliert.
  - **G12:** „Wirtin“ heißt jetzt „Inhaberin“ (wie in H-S14), „gelagert“ jetzt „aufbewahrt“. Beide Scanner-Ausnahmen für Spieltext sind entfernt.
  - **M1 (teilweise):** Die erfundene Taschenuhr bei R04 ist entfernt. Die Kanon-Armbanduhr ist bei 2,5D-Auflösung nicht darstellbar.
  - **H2:** `@LISTE-ORTE` im Overlay um die Häuser, Gassen und Inschriften der sechs Viertel erweitert, ausdrücklich nur als Farbe: nie Ort eines Hinweises oder lösungsrelevanten Gegenstands. Der Master-Prompt verlangt eine riesige Stadt mit Hausgeschichten; die Liste deckt sie jetzt ab.
- **Nicht umgesetzt, mit Begründung:**
  - **H1 (Fähigkeit von R03 „Spur verwischen“):** Das Gegenspiel des Täters ist im Master-Prompt verlangt (Phase 4). Fähigkeit und Sichtschicht sieht nur die Spielerin von R03; sie kennt ihr Geheimnis laut Kanon (@R03-GEHEIM [G]). Mitspieler bekommen das Ereignis nie (`BurgstadtRaum.sichtbar`: `sicht` nur an die Rolle). Den Gegenstand des Verwischens sieht der Detektiv nur als „verwischter Abdruck“, eine Spurenart. Das Feld `wirkung.details` ist Entwicklerbeschreibung und wird nicht angezeigt.
  - **M2 (Teil-IDs „nicht definiert“):** Die Teile stehen im Code (`kTeileBasis`, teile_basis.dart), nicht in den JSON-Dateien. `pruefeKarte` im karten_test belegt, dass jede Karte nur vorhandene Teile nutzt.
  - **M5 (Kanon-Spuren zeigen auf die Täterin):** Das sind die O-Hinweise des verbindlichen Kanons, also das Rätsel selbst; sie sind durch Gegenspuren ausgeglichen (Lügenregel, Ersatzziele, Fairness-Löser). Die Leitplanke „kein Text, der die Täterin nahelegt“ gilt für unsere zusätzlichen Texte (Stadt, Bewohner, Häuser), nicht für die Spuren des Falls.
  - **G3 („Einspruch!“ bei R18):** Wortlaut aus dem Kanon (K2-ROLLEN-13-20), ein allgemeines Gerichtswort.
  - **G4 (ungenutztes Kopftuch-Teil):** Wird von keiner Figur benutzt. Ein Kopftuch ist neutrale Kleidung; die Regel verbietet Klischees, nicht Kleidungsstücke.
  - **G5:** Kleidungstypen als Näherung, siehe E23/G12.
  - **G7:** Die Uhrzeiten der Nachtpläne werden nicht als Text ausgegeben.
  - **G11:** wie E23/M5.

## E28 · 09.10. 03:45 · Fehler im Gesamttest: rote Pakettests wurden verschluckt
- **Befund:** In `tool/alle_tests.sh` stand je Paket `{ [ -d test ] && dart test … || echo "keine Tests"; }`. Schlug `dart test` fehl, griff `|| echo` und der Lauf blieb grün. Die Bildschirmfoto-Zeile hatte dieselbe Lücke: Ein Absturz fiel in `|| true`.
- **Gefunden:** beim Einbau von A-702c. `stadtdaten_test` war seit Commit 02ab9b5 rot, weil zwei Bewohner-Sätze zu lang waren. `commit_gruen.sh` hatte trotzdem „ALLE TESTS GRÜN“ gemeldet.
- **Behoben:** `if [ -d test ]; then dart test …; else echo "keine Tests"; fi`. Die Bildschirmfotos laufen jetzt über eine Variable, damit ein Absturz mit `set -e` abbricht.
- **Aufarbeitung:** Ein Hintergrundlauf prüft jeden Nachtlauf-Commit einzeln (eigener Arbeitsbaum im Scratchpad). Das Ergebnis steht in `belege/historie_pakettests.txt`, und betroffene Commits werden im Abschlussbericht genannt. Die Geschichte wird nicht umgeschrieben.

## E29 · 09.10. 04:07 · Gegenprüfung Inhalt Runde 3 (A-702d) umgesetzt
- **B1 (Verletzung):** Der Prüfer widerspricht E23/M5 mit neuem Grund. Die öffentlichen Kanonzeilen (OA-20, BW-ZUSTAND) werden im Spiel angezeigt bzw. vom Erzähler gelesen, und E4 sieht ausdrücklich Ersetzungen im Overlay vor. Deshalb gibt es jetzt `@ERSETZE-17 | Von: bewusstlos | Nach: benommen`. Die K-Dateien bleiben unverändert, keine S-Zeile ist betroffen; der wirksame Kanon sagt „Kurz benommen …“.
- **B2 (Muster „Angst“ nur bei Frauen):**
  - Die Angst-Sätze von B15, B21, B38 und B41 sind ersetzt (Kälte, Docht, ruhige Nacht).
  - Der Saum bei H-S10/HW-S10 und H-104 ist gestrichen (Knöpfe).
  - „die Bewohnerin“ bei H-014 heißt jetzt „die Leute im Haus“.
  - B09 („Angst vor dem Dunkel“ beim Hund) bleibt.
- **B3 (Zeiten):** `@LISTE-ZEITEN` im Overlay um die öffentlichen Stadtzeiten ergänzt: Tore 22:00, Uhrturm 00:25/01:30/03:00/04:30, Ofen 03:00.
- **B4–B8:**
  - „Pensionsinhaberin“.
  - „Gasse am Untertor“ und „breite Gasse“.
  - „Obsthänge“.
  - „Der Bewohner“ (H-078).
  - Uhrzeiten in Worten (R04).
- **B9 (Lederhut gegen Filzhut bei R17):** Nur der interne Teilname ist betroffen. Im Bild ist es ein brauner Hut mit Krempe, in 2,5D-Auflösung nicht unterscheidbar. Keine Änderung.
- **Historie der Pakettests (E28):** belegt in `belege/historie_pakettests.txt`. Alle 40 Nachtlauf-Commits bis 7926f76 waren grün. 02ab9b5, d511fac und 7574641 hatten einen roten Datentest in burgstadt_core (zwei zu lange Bewohner-Sätze); grün ab ba66f50.

## E30 · 09.10. 04:26 · Sichtprüfung 9 und 10: Größen gespreizt, Körpermitte im Maß, Prüfmaßstab festgelegt
- **Befund:** Die beiden Prüfer werteten sehr verschieden.
  - Prüfer 9 fand 23 Paare. Bei ihm genügte eine gleiche Silhouettenklasse plus *ein* gleicher Farbblock, auch bei anderem Oberteil.
  - Prüfer 10 fand 9 Paare, nach gleicher Farbe der Körpermitte, auch bei klar verschiedenem Kopf, Hut oder Schirm.
  - Prüfer 7 und 8 fanden am vorigen Stand 0 Paare.
- **Zwei Punkte waren berechtigt:**
  1. Die erfundenen Größen der Rollen lagen eng beieinander (Frauen 1,65–1,71 m). Sie sind jetzt gespreizt: Frauen 1,54–1,84 m, Männer 1,68–1,93 m, bei ähnlicher Silhouette abwechselnd. R12 bleibt nach Kanon „groß“.
  2. Die Hose von B04 hatte die Farbe des Aufstellungsgrunds. Der Grund ist jetzt helles Stein (1,7), eine Farbe, die keine Figur trägt.
- **Maß des Generators:** Neu ist „gleiche Körpermitte“ als Druck: häufigste Farbe von Rumpf und Beinen, gleiche Rampe, Stufe ±1, Höhe ±3 Pixel. Danach blieben 3 von vorher deutlich mehr Fällen.
- **Erfundene Hosen:** R20 dunkelrot, R08 bleibt holzfarben. Ergebnis: 0 verwechselbare Paare nach dem Maß, alle Pixeltests grün.
- **Prüfmaßstab:** Die nächste Runde (A-605k) bekommt die Definition aus Z-03 ausdrücklich vorgegeben: verwechselbar ist ein Paar, das man im Spiel aus 5–8 m nicht sicher auseinanderhält, also gleiche Gesamtsilhouette *und* gleiche Hauptfarben. Ein deutlicher Unterschied am Kopf oder in einer großen Farbfläche trennt. Grenzfälle werden getrennt genannt. So messen beide Prüfer dasselbe.

## E31 · 09.10. 04:42 · Inhaltsprüfung Runde 4 (A-702e), abnahme.dart-Fehler, iOS
- **A-702e:** Leitplanken eingehalten, Plagiatsfrei; zwei Kanon-Reste umgesetzt. B38 näht keinen Saum mehr (Nachtplan) und fädelt statt Knopf. B35 sagt „früh am Morgen“ statt „um sieben“.
- **abnahme.dart:** Das Werkzeug endete still mit Code 0, ohne Ergebnis. Ursache: `asFuture()` an einem bereits beendeten Ausgabestrom erfüllt sich nie, also hatte die VM nichts mehr zu tun. Jetzt werden die Futures (`forEach`) vor dem Warten auf das Prozessende angelegt; mit einem Mini-Skript geprüft.
- **iOS:** `NSLocalNetworkUsageDescription` in Info.plist (Text auf Deutsch).

## E32 · 09.10. 04:54 · Sichtprüfung Endrunde (A-605k/l) und erster vollständiger Abnahmelauf
- **Sichtprüfer 11 und 12:** unabhängig, mit dem festen Maßstab aus Z-03. Beide fanden 0 Paare und 0 Verstöße am Kartenstand c44e0c1898. Als knappe Grenzfälle nennen sie BW/B12 (beide), B29/B41, R09/B12, R06/R08, B13/B43, B13/B33 und R02/R14. Sie zählen nicht als Paar. Die Figuren bleiben unverändert, weil jede Änderung beide Prüfungen ungültig machen würde. Die Grenzfälle stehen im Abschlussbericht.
- **Abnahmelauf (tool/abnahme.dart, Stand 3999fc9):** Alle elf Ebenen sind grün; 11 von 14 Kriterien sind erfüllt. Offen bei diesem Lauf: Z-03 (Berichte noch nicht übernommen), Z-12 (Inhaltsrunde 5 läuft) und Z-14 (Morgen- und Abschlussbericht).
- Die Zeitstempel in `belege/abnahme.txt` und `belege/alle_tests_voll.txt` sind in UTC (Uhr des Containers).

## E33 · 09.10. 05:22 · Inhaltsrunde 5 (A-702f) und Spieltester (A-703a) umgesetzt
- **A-702f:** Leitplanken eingehalten und plagiatsfrei. Offen war nur ein Kanon-Wort (R06: „eine Weile“ statt „kurz“ benommen), jetzt korrigiert. Aus den Hinweisen übernommen:
  - Schuhmacher B32 ohne Sohle, Absatz und „wo du gewesen bist“.
  - Seiler B44 ohne „Strick“-Anspielung.
  - „Stollen“ als Bergbauwort durch „Schacht“ ersetzt (Doppeldeutigkeit zum Sohlenprofil).
  - B16 ohne unbelegte „schnelle Schritte“, H-059 ohne Zinnen-Zählmotiv, H-139 mit passendem Bewohner, Entwicklerfeld ohne „Bewusstlosigkeit“.
  - Laternen als getragenes Licht bleiben; es sind Kerzenlaternen der Bewohner, im Rahmen von STADT-02.
- **A-703a (Spieltester, 6 hoch / 6 mittel / 5 gering):**
  - Hinweiskarten bis 6 Zeilen mit sichtbarem „…“ statt Schnitt mitten im Satz.
  - Sprechblasen bis 5 Zeilen, im Bild gehalten, ohne sich zu überdecken (die nächste Figur zuerst, eine Blase ohne Platz entfällt).
  - Tutorial im Hochformat links neben der Knopfspalte, auf Handys zuerst mit Touch-Text.
  - Kartennamen und Ortsanzeige auf dunkler Plakette.
  - Fallakte kürzt am Wortende.
  - HUD-Knöpfe im Hochformat 56×24 statt 48×17, Antwortknöpfe dreizeilig.
  - Anklage mit Bestätigung „Das ist endgültig“.
- **Offen (FÜR DEN NUTZER):** Die empfohlenen 7 mm Knopfhöhe erreichen die HUD-Knöpfe auf einem 6-Zoll-Handy noch nicht, sie liegen bei etwa 4,3 mm. Dafür bräuchte es ein eigenes Handy-Layout.

## E34 · 09.10. 05:46 · Inhaltsrunde 6 (A-702g) umgesetzt; Korrektur zu E33
- **B-1 (Uhrzeiten aus dem Kanon außerhalb von LISTE-ZEITEN):** Das ist eine Lücke im Kanon selbst, denn seine O-Zeilen nennen Zeiten in Alibis, Aussagen und Beweisstück-Texten. `@LISTE-ZEITEN` im Overlay sagt jetzt ausdrücklich, dass solche Zeitangaben Aussagen sind und zur Liste gehören.
- **B-2 (Klischees über Altersgruppen):** Die vier Stellen beziehen sich jetzt auf konkrete Personen: Enkel, Frau Lang, die Nachbarn vom Eckhaus, ein Ehepaar.
- **Hinweise übernommen:**
  - „Knoten“ statt „Strang“, „Ziegelei“ statt „Brennerei“.
  - Angst-Motive bei H-064 und H-122 entfernt.
  - B16 jetzt „aufmerksam und herzlich“ statt „neugierig und laut“, für eine ausgewogenere Verteilung.
  - H-S22 ohne „den Rest erzählt mir heute niemand“.
  - B21 ohne Uhrzeit.
- **Korrektur zu E33:** Dort stand „H-059 ohne Zinnen-Zählmotiv“. Tatsächlich war damals nur „eine mehr“ gestrichen, die Hausfrau zählte die Zinnen weiter. Jetzt ist es korrigiert: Sie gießt dort ihre Kräutertöpfe.
- **Tutorial T02:** Rennen steht nur noch in den Gerätetexten (Umschalt bzw. LB). Auf dem Handy erschien vorher „Mit Umschalt rennst du“.
- **Bewusst belassen:** B02 mit eigener Taschenuhr (ein Requisit des Bewohners, nicht aus dem Kanon). Die Feder am Hut von R17 ist in 2,5D nicht darstellbar.

## E35 · 09.10. 06:12 · Inhaltsrunde 7 (A-702h) umgesetzt
- **Ergebnis der Runde:** kanontreu ja, plagiatsfrei ja. Ein geringer Befund gegen die Täterinnen-Leitplanke.
- **Befund:** B09 „Der Hund hatte nur Angst vor dem Dunkel.“ wiederholte wörtlich das öffentliche Merkmal einer Rolle („Angst im Dunkeln“). Der neue Grund des Prüfers widerlegt die Abwägung aus E29/B2. Jetzt: „Der Hund wollte heute nur nicht allein sein.“
- **Hinweis übernommen:** „Krautfass“ heißt jetzt „Gemüsefass“ („Kraut“ ist auch Szeneslang).
- **Wehrgang:** Erwähnungen in der Stadt (B37, H-069, H-106) bleiben, denn die Stadtmauer mit Wehrgang steht in LISTE-ORTE und ist begehbar.

## E36 · 09.10. 06:26 · Z-09: Nachladespitze in Prozessorzeit des Spielthreads
- **Befund:** Ein Abnahmelauf (9097217) war rot. Unter 926 Back-Aufrufen dauerte einer 27 ms auf der Wanduhr, im selben Moment die Bildzeit 70 ms. Gleichzeitig arbeitete ein Prüfagent.
  - Das GC-Protokoll (`DART_VM_OPTIONS=--verbose_gc`) zeigt über 5 Spielminuten höchstens 6,6 ms Scavenge und 2,1 ms Mark-Sweep. Die Speicherbereinigung erklärt die Spitze also nicht; der Prozess wurde verdrängt.
- **Entscheidung:**
  - `bin/leistung.dart` misst die Back-Aufrufe zusätzlich in der Prozessorzeit des Spielthreads: `clock_gettime(CLOCK_THREAD_CPUTIME_ID)` über dart:ffi aus libc, ohne neue Abhängigkeit.
  - Maßgeblich für die Grenze von 50 ms (× 4) ist diese Prozessorzeit, also die Arbeit des Spiels. Die Wanduhr-Spitze steht als eigene Zeile im Beleg.
  - Ein erster Versuch mit `/proc/thread-self/schedstat` war zu grob (nur zum Scheduler-Tick aktualisiert) und wurde verworfen.
- **Zusätzlich:** Der Figuren-Baker verwendet seine Arbeitspuffer wieder (rund 100 KB weniger Müll je Bild, Bilder bitgleich). Das Back-Budget beträgt 3 ms je Bild.
- **Für den Nutzer:** Auf einem Handy mit Hintergrundlast kann es dennoch einzelne Ruckler geben; das bleibt ein Gerätetest.
