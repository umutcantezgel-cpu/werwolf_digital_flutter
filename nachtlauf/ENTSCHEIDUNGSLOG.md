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

## E37 · 09.10. 06:40 · Inhaltsrunde 8 (A-702i): Texte umgesetzt, Figurenteile folgen
- **Umgesetzt:**
  - B2: weitere Altersgruppen-Verallgemeinerungen jetzt an konkrete Personen gebunden (Paul, Frau Lang, Frau Teutsch).
  - B3: „Glockenhaus der Gießerei“; „vom Untertor her“.
  - B4: Stationsnamen passen zu den Objekten im Raum (Backofen, Wappen, Lesepult).
  - H5: B35 und „Gebetsstreifen“ umformuliert.
  - H6: B29 widerspricht nicht mehr ihrem eigenen Nachtplan.
- **Offen, wird eingebaut:**
  - B1: der rote Kameragurt von R19 (Signaturstück im Kanon).
  - B5: der Kopfhörer um den Hals von R02.
  - Beide sind in 2,5D darstellbar und kommen als Teile dazu. Danach braucht es eine neue Sichtprüfung (Kartenstand ändert sich) und eine neue Inhaltsrunde.
- **Hinweis H1 (kleine Kanon-Details):** Multitool, Haarspange, Kugelschreiber, Anstecker, Ohrringe, Bleistift und Ähnliches sind kleiner als ein Pixel der Figur und werden nicht gezeichnet; sie bleiben im Text der Rollen.

## E38 · 09.10. 07:19 · Inhaltsrunde 9 (A-702j) und Sichtprüfung 13/14 (A-605k/l)
- **B1 Herkunft in den Familienfeldern (umgesetzt per Overlay):**
  - Befund: Bei 12 Rollen mit nichtdeutschen Wurzeln war ein benanntes Fest, eine Speise oder ein Instrument das Familienmerkmal (Pita, Pierogi, Newroz, Bağlama, Bajram/Tufahije, Wigilia, Džezva, Revani, Menemen, Sevdalinke); bei den Rollen mit deutschen Wurzeln kaum. Einzeln liebevoll, als Muster aber eine Zuordnung „Herkunft → Folklore“.
  - Das Spiel zeigt das Feld Familie nirgends an (geprüft: `Rolle` liest nur Name, Aussprache, Geschlecht, Alter, Beruf, Kleidung, Sprechweise, Alibi und Beziehung zum Burgwart).
  - Trotzdem gilt der wirksame Kanon als Spieltext-Bestand. Deshalb ersetzt `kanon/ANPASSUNG.md` (Abschnitt „Familienfelder“) bei R01, R05–R09, R12–R16 und R19 nur den einen Satzteil durch ein herkunftsneutrales, persönliches Detail. Beispiele: Kreuzworträtsel statt Pierogi, Haushaltsbuch der Großmutter statt Revani, Gartentreffen im Frühjahr statt Newroz.
  - Unverändert bleiben Wurzeln, Eltern, Geschwister, Berufe und die Gefühlsfunktion des Satzes. Die Dateien in `krimidinner/` sind unverändert.
  - Bewusst bleiben: Großmutter-Motive (kommen bei deutschen wie nichtdeutschen Wurzeln vor, z. B. R10 Inge), R10 Biikebrennen (regional) und R20 Masurische Seen (Wohnort der Großeltern, kein Brauch).
  - Kopplung Herkunft → Beruf: Die Berufe der Rollen und ihrer Eltern sind breit gestreut (Lokführer, Lehrerin, Vermessung, Apotheke, Statik, Bank, Jura). Kein Muster, keine Änderung.
  - In `LEITPLANKEN-AUSNAHMEN.md` steht „Kater“ (Haustier Paşa) jetzt auch für die Overlay-Zeile.
- **B2 Wanderstiefel R03/R04 (bewusst so):**
  - Die Wanderstiefel bestehen seit Phase 2 aus zwei Teilen: `schuhe-stiefel` für den Schaft und `schuhe-arbeitsschuhe` für die dicke Sohle. Der Kanon („braune Wanderstiefel“) ist damit im Bild erfüllt.
  - Sichtprüfer 13 bestätigt: „braune Schaftstiefel mit dicker Sohle, nur R03 und R04“. `karten_test` prüft genau diese Kombination.
  - Angeglichen: Der Ersatzpfad in `figuren_lager.dart` (Karte aus `rollen.json`, falls `karten.json` fehlt) setzt jetzt ebenfalls beide Teile.
- **Hinweise aus Runde 9:**
  - Erzählertipp „Mit Umschalt rennst du“ ist jetzt geräteneutral (Touch hat kein Rennen).
  - H-045: Die Gerberei steht still (einzige Bewohnerin ist B29, Auszubildende).
  - H-046: „Die Grafikerin“ passt jetzt zu B27.
  - Seil- und Knotenmotiv ausgedünnt: Inschrift H-034 „Was gedreht ist, hält zusammen“; B44 spleißt Brunnenseile; „Du kannst daran ziehen“ ist entfernt.
  - „Hausfrau“ ist überall durch „Hausherrin“ ersetzt (15 Stellen).
  - Talg bleibt: Kerzen der Stadt sind aus Talg, Bienenwachs gibt es nur von R17s Bienen. Das schärft den Kanon-Hinweis auf das Bienenwachs, statt ihn zu verwischen.
- **Sichtprüfung 13/14 (Kartenstand 0e9ec58e33):**
  - Prüfer 14: 0 Paare, 0 Verstöße. Prüfer 13: 0 Paare, 1 Verstoß.
  - Verstoß: B13 „Haube fehlt“. Die Haube war gezeichnet, aber in Rot [3,5]; sie las sich wie rotes Haar, und das weiße Haar aus dem Datensatz war nicht zu sehen. Jetzt ist die Haube weiß [0,7].
  - Grenzfälle von Prüfer 14 mitgenommen: B34 kleiner (1,74), B43 größer (1,67), B28 mit brauner statt grauer Mütze. Gegen die neue Nähe B13/B33 trägt B33 eine blaue Haube.
  - Ausprobiert und verworfen: R16 mit anderer Hosenfarbe. Jede Variante erzeugte in `karten_test` ein neues enges Paar (R05, R01 oder R19); R16 bleibt.
  - Der neue Kartenstand braucht zwei neue Sichtprüfungen (A-605m) und eine neue Inhaltsrunde (A-702k).

## E39 · 09.10. 07:45 · Inhaltsrunde 10 (A-702k): Urteil ja · ja · ja, geringe Befunde trotzdem umgesetzt
- **Urteil:** Leitplanken ja, Kanontreu ja, Plagiatsfrei ja; Befunde hoch 0, mittel 0, gering 11.
- **Umgesetzt**, weil jeder Punkt klein und berechtigt ist. Die Texte ändern sich dadurch; deshalb folgt Runde 11, damit der Beleg für Z-12 zum letzten Textstand passt.
  - B-01: In H-137 wird der erste Laib für den Turmwärter zurückgelegt; das passt zu seinem Nachtplan am Uhrwerk.
  - B-02: Der Ladetipp nennt kein Rennen mehr (Touch hat keins): „Wer langsam geht, hört selbst mehr.“
  - B-03: Die Knöpfe beim Krämer (H-108, B29) sind entfernt. Knöpfe bleiben nur im Kostümfundus (H-S10, Farbe).
  - B-04: H-136 ohne Spaten in der Nacht, H-047 ohne abgedeckte Grube. H-140 und H-143 bleiben; Klopfen und kalte Dielen sind Gänsehaut ohne Versteck-Bild.
  - B-05: H-034 ohne Hinabgleiten am Seil.
  - B-06: H-027 ohne Verdacht gegen die Kustodin.
  - B-07: B16 und B33 ohne „die Alte“ und ohne Kaffee und Kuchen (Katze, die nie kommt; Schal für den Briefträger).
  - B-09: H-066 ohne „Handschrift“ (Echo des Code-Zettels BSO-04).
  - B-08 (Widerspruch zu E38 mit neuem Grund, angenommen): Der Gegenbeleg R10 trug nicht, weil Inge nicht im Haushalt lebt. Die Großmutter, die im Haushalt lebt und die Familie lenkt, gab es nur bei R05, R13 und R18. Im Overlay wohnt sie bei R13 jetzt zwei Straßen weiter; bei R18 ruft sie sonntags an und lässt sich Elifs Woche „wie einen Fall“ vortragen, der Bezug zum Jurastudium bleibt. R05 bleibt, weil ein einzelner Fall kein Muster ist.
- **Bewusst so:**
  - B-10: `frisur-afro` und `kopf-kopftuch` liegen ungenutzt in der Teile-Bibliothek. Eine Frisur ist kein Klischee. Regel: Ein Teil wird nur benutzt, wenn der Datensatz der Figur es nennt (wie bisher für alle Teile). Keine Figur nennt diese beiden.
  - B-11: Teil-Kennungen sind Formen, keine Kleidungsnamen. Cordblazer und Sakko nutzen die Form `oberteil-uniformjacke` (kurze, gerade Jacke mit Revers), Funktions-, Leder- und Daunenjacke die Form `oberteil-arbeitsjacke`. Den Stoff unterscheidet die Farbe aus `rollen.json`. R01s graue Strickmütze ist eine Strickmütze (mit Bommel; der Kanon schließt ihn nicht aus). R15 trägt das schwarze Shirt unter dem Blazer; `oberteil-hemdkragen` zeichnet nur den dunklen Ausschnitt. Ob die Figuren im Bild zum Kanon passen, prüfen die Sichtprüfer (Regeln in A-605m: Kleidung nach Datensatz).
- **Sichtprüfer 15 (A-605m, Kartenstand e4624201af):** 1 Paar, R06/R08 (Größenunterschied 6 px, dunkelblaues Oberteil, braune Hose). Zuvor war das bei anderen Prüfern ein Grenzfall.
  - Die Hose von R08 ist erfunden. Jede andere Hosenfarbe erzeugte in `karten_test` neue enge Paare (R11, R13, R18, R20, B20).
  - Deshalb ist R08 jetzt kleiner: 1,55 statt 1,63 m (Größe erfunden). In der Aufstellung sind es 108 statt 116 px gegen 122 px bei R06 (Δ 14). Zu R11 (106 px) trennt die Hose: braun gegen hellgraue Jeans.
  - Neuer Kartenstand 901192c463. Er braucht zwei neue Sichtprüfungen (A-605o/p); Sichtprüfer 16 prüft noch den alten Stand.

## E40 · 09.10. 08:45 · Figuren: Maßstab 5a im Generator; Politur nach Inhaltsrunde 11
- **Lage:**
  - Sichtprüfer 16 (Stand e4624201af): 0 Paare. Er sah bei B14, B34 und B39 keine Mütze, sondern Haar, weil die Kopfbedeckungen in Haarfarben gefärbt waren.
  - Sichtprüfer 17 (Stand 901192c463): 2 Paare, BW/B12 und DET/B24, beide bei früheren Prüfern Grenzfälle.
  - Sichtprüfer 18 (gleicher Stand): 0 Paare.
  - Muster: Was knapp an der Schwelle liegt, wertet jeder Prüfer anders. Einzelne Handkorrekturen verschoben das Problem nur zum nächsten Nachbarn.
- **Lösung:** Der Maßstab 5a steckt jetzt im Figurenvergleich selbst, und der Generator verteilt die Bewohner danach neu.
  - **Verwechselbar** (`vergleiche`) ist zusätzlich jedes Paar mit gleicher Farbfamilie an Rumpf und Beinen, Größenunterschied bis 5 Sprite-Pixel (in der Aufstellung bis 10 Bildpixel, die Prüfer trennen erst ab 8) und gleichem Kopf (beide mit oder beide ohne Kopfbedeckung).
  - **Farbfamilie** wie bei den Prüfern (`farbFamilie`): Die zwei dunkelsten Stufen jeder Rampe sind „dunkel“, neutral und stein sind „grau“, sonst zählt die Rampe. Gemessen wird über die volle Breite, ohne Umriss und Haut.
  - **Kopfbedeckungen der Bewohner** sind nie in Haarfarben (Holz, Rot, Bernstein) und nie in der Rampe des eigenen Haars; die rote Haube ist entfernt. `karten_test` prüft das (`kopfbedeckungLesbar`).
  - **Generator** (`bin/bewohnerkarten.dart`): Die geprüfte Karte aus der Datei ist Kandidat 0, solange sie die Regeln erfüllt. Er hat bis zu 10 Durchgänge; dieser Lauf kam nach 6 zur Ruhe. Er hat 14 Bewohner umgefärbt (Datensatz in `bewohner.json` angepasst) und die erfundenen Hosenfarben von R02, R03, R04, R07, R08 und R09 gewählt (R03: Jeans hellgrau, der Kanon nennt nur „Jeans“).
  - **Von Hand, nur erfundene Werte:** R05 Jeans ocker und 1,82 m, R14 Hose dunkelrot, R16 1,88 m (1,93 besteht die Sprite-Prüfung nicht), B11 1,50 m, B15 1,52 m, B40 1,60 m.
  - **Gegenprobe:** Eine unabhängige Näherung direkt auf der Aufstellung (`tool/mass5a.py`, gleiche Familienregel, Höhe in Bildpixeln) findet unter 10 px Größenunterschied 0 Kandidaten, unter 12 px noch 4. `karten_test` ist ohne Paar.
  - Neuer Kartenstand fc94af9295; zwei neue Sichtprüfer (A-605q/r).
- **Politur nach Inhaltsrunde 11** (Urteil ja · ja · ja, 7 geringe Befunde):
  - G1/G2/G3/G5: Bei B16 und B33 entfällt „Witwe“ als Beruf; sie sind jetzt „Nachbarin, früher Standesbeamtin“ bzw. „Rentnerin, früher Weberin“. Entfernt sind auch die Katzen- und Kuchenpointe, die Häkelbilder, „Stimme wie Honig“, „die alte Schöning“, „langsam im Gang“, „ältere Dame“ (H-088), „niemand widerspricht ihr“ (H-115) und „Witwe“ (H-110).
  - G4: „die Reinigungskraft“ statt „die Putzfrau“.
  - G6: H-134 ohne nächtliche Tätigkeit des Pflasterers.
  - G7: „Gabentisch mit Kerzen“ statt „Opfertisch“.
  - Selbst gefunden: Drei Bewohner sprachen die spielende Person als „Junge“ bzw. „junger Mann“ an, obwohl ihr Geschlecht offen ist (B16, B33 und ein weiterer). Die Anrede ist jetzt neutral.
  - Bewusst offen: Dutt-Frisur bei mehreren älteren Bewohnerinnen. Sie kommt aus dem Datensatz (`frisur: dutt`); eine Änderung braucht eine neue Sichtprüfung und steht in FÜR DEN NUTZER.
- **Abbruchregel für die Inhaltsprüfung:** Runde 12 prüft diesen Stand. Hat sie das Urteil ja · ja · ja, werden ihre geringen Befunde gesammelt (FÜR DEN NUTZER) statt weiter gedreht; nur ein „nein“ führt zu einer weiteren Runde.

## E41 · 09.10. 11:34 · Alles auf main (Nutzerentscheidung N-01), Kanon v1.0 eingearbeitet
- **Nutzerentscheidung N-01:** „Stelle sicher, dass der gesamte Stand auf Main zusammengeführt wurde … dass du keine Arbeiten nur lokal hast.“ Das hebt die Nachtlauf-Regel „kein Push außer `nachtlauf/burgstadt`“ für `main` und den Sitzungs-Branch `claude/nifty-gauss-s82y27` ausdrücklich auf. Weiter gilt: keine PRs, kein Force-Push, keine Geschichte umschreiben. Z-13 im Abnahmewerkzeug lässt deshalb genau diese zwei Ziele zusätzlich zu.
- **main war weitergelaufen** (d92a675):
  - Kanon-Commits 9770268 und a4b4c67 („Kanon v1.0“, P-15..P-45) per PR #42.
  - Jules-PR #41 per „ours“, ohne Änderung am Dateistand.
  - `nachtlauf/burgstadt` hatte den Kanon nur bis 659d3ed. Der Merge (b1dfbaf) war konfliktfrei, weil der Nachtlauf `krimidinner/` nie geändert hat; main hatte außerhalb von `krimidinner/` nichts geändert.
- **Abgleich Overlay gegen Kanon v1.0** (Skript: jedes Overlay-Feld gegen die Kanonänderung 659d3ed..main):
  - Datensätze: 1211 statt 1207 (+4 L-Datensätze), `kanon.py pruefe` 0 Befunde. Die Zählungen in `kanon_test` sind nachgezogen.
  - Feldkonflikt nur bei `LISTE-ZEITEN`: Kanon v1.0 nennt jetzt mehr Uhrzeiten (23:52, 23:56, 00:01 …). Das Overlay hätte sie mit der alten Liste überdeckt. Es übernimmt jetzt den neuen Wortlaut und hängt nur die Stadt-Ergänzung an (Tore 22:00, Uhrturm, Ofen 03:00, Zeitangaben in O-Datensätzen).
  - Die R??-STAMM-Familienfelder (E38/E39) sind im Kanon unverändert; kein Konflikt.
  - Alle ERSETZE-Begriffe greifen weiter („bewusstlos“ jetzt an 8 statt 7 Stellen). „Silberhau“ ist der erfundene Talort des Kanons (GL-02), kein Harz-Rest.
- **Aussehen aus Kanon v1.0:**
  - R04 trägt statt der Fleecejacke einen olivgrünen groben Strickpullover über dem karierten Hemd: `rollen.json` Typ `pullover`, Karte `oberteil-hemdkragen` statt `oberteil-fleece`; der Ersatzpfad in `figuren_lager.dart` setzt den Hemdkragen bei Pullover über Hemd.
  - R03: Das Notizbuch ist aus dem Look-Anker gestrichen (LF-R03) und fällt aus Karte und `rollen.json`. Sichtprüfer 19 hatte es als hellen Gegenstand in der Hand bemerkt; K9 §8 verbietet sichtbare Zettel.
  - Ohne Notizbuch rückte R03 an R11 heran. R03s erfundene Jeansfarbe ist jetzt blau [6,4] statt hellgrau; `karten_test` und die Näherung `tool/mass5a.py` sind ohne Paar.
  - Neuer Kartenstand db8e0a6155: Z-03 braucht zwei neue Sichtprüfer (A-605s/t).
- **Z-12:** Die Kanon-Dateien (`krimidinner/spuk-im-gewoelbe/10_kanon`) sind Spieltext. Das Abnahmewerkzeug zählt sie jetzt zu den Textpfaden; nach dem Merge braucht es eine neue Inhaltsrunde (A-702n).
- **Nichts nur lokal:** `tool/mass5a.py` (die Bild-Näherung aus E40) liegt jetzt im Repo. Die Agent-Worktrees werden nach dem Abgleich ihrer Dateien entfernt.

## E42 · 09.10. 12:26 · Inhaltsrunden 13/14 (A-702n) nach Kanon v1.0: umgesetzt und abgewogen
- **Urteil beider Prüfer:** Leitplanken ja, Kanontreu **nein**, Plagiatsfrei ja. Runde 13: mittel 3, gering 2. Runde 14: hoch 1, mittel 2, gering 5. Sichtprüfer 21 und 22 (Kartenstand db8e0a6155): je 0 Paare, 0 Verstöße. Z-03 ist damit erfüllt.
- **Umgesetzt:**
  - **Laken (R14-1, hoch):** Kanon v1.0 sagt neu (Z-2140), das Gespensterlaken ist ein ausgemustertes Burglaken mit dem roten Wäschezeichen „Schartenfels 7“. Unser Overlay (aus Phase 0, E4) machte das Zeichen zur Pensionswäsche; das widersprach jetzt dem Kanon.
    - H-S05, HW-S05, HW-S09, ORT-03, ORT-05 und die Pension in `haeuser.json` sind angepasst. Die Pension stempelt ihre Bettwäsche blau mit ihrem Namen. „Schartenfels 7“ bleibt das Zeichen der Burgwäsche.
    - Einstufung jetzt „Farbe“; kein Stadt-Hinweis stützt eine Schlussfolgerung.
  - **Phasenbeginn (R13 M-1):** Der Kanon setzt den Beginn der Ermittlung (Phase 1) auf 00:30 (Z-0030; stand schon im alten Kanon und wurde bisher übersehen). Das Spiel begann um 00:25.
    - Jetzt beginnt Phase 1 um 00:30, nach dem Auftrag des Burgwarts um 00:25 (OA-29).
    - Geändert: `FallZustand.phasenStart`, alle 44 Nachtpläne, STADT-05, die Stadtzeiten in LISTE-ZEITEN und die Tests.
    - Phase 1 dauert damit 60 statt 65 Spielminuten.
  - **R04-Beruf (R13 G-1):** Kanon v1.0 hat den Zusatz „(so erzählt er es)“ gestrichen; `faehigkeiten.json` ist angeglichen.
    - Der Vorschlagstest aus A-402a, der das gemeldet hätte, läuft jetzt dauerhaft als `test/faehigkeiten_daten_test.dart`.
  - **Silberhau (R14-4):** in LISTE-ORTE ergänzt (Bergstädtchen im Tal, außerhalb, nur Farbe).
  - **Leihgabe des Talers (R14-6):** HW-S03 jetzt „Farbe“ statt „bestätigend“.
  - **Selbst gefunden beim Umsetzen:** „Osterode“ (eine echte Harzstadt) stand noch im Kanon und im Overlay (K-010, BW-STAMM). Neue Ersetzung ERSETZE-18 „in Osterode“ → „unten im Tal“, wie bei den 16 Harz-Bezügen.
  - **R18-Familie (R13 G-2):** Die Großmutter fragt nicht mehr, „wann sie endlich Richterin wird“. Sie „spricht am Ende ihr Urteil, das fast immer Freispruch lautet“. Das ist der juristische Witz ohne Erwartungsdruck.
- **Abgewogen, bleibt:**
  - **FM-1 (R13 M-2, R14-3):** Die Funktionsmatrix ist ein [L]-Datensatz des Kanons, im Spiel nirgends sichtbar. Sie ist die Besetzungsprüfung der Kanon-Autoren: Täterin und Hauptverdächtiger mit echtem Vergehen haben deutsche Wurzeln, keine andere Gruppe trägt eine belastete Funktion. Das ist eine Vorsichtsmaßnahme gegen Klischees und kein Klischee.
    - Im Spiel ist Herkunft kein Indiz: Der Verdacht gegen R01 beruht auf Lampe und Code-Zettel; „HODŽIĆ VT · 3“ ist eine Eigentumsmarke.
    - Die Kanon-Dateien ändern wir nicht. Die Anregung, die Matrix nach Rollen-IDs statt nach Herkunft zu ordnen, steht in FÜR DEN NUTZER.
  - **„verwischt“ (R13 M-3):** Das Gegenspiel der Täterin fordert der Master-Prompt; „verwischt“ ist eine der 7 Spurenarten von Z-05. Fähigkeiten sind geheim: Keine andere Rolle erfährt, wer verwischen kann (E27 H1). Die Spur sagt „hier hat jemand eine Spur verwischt“, nicht wer.
    - Eine zweite, unschuldige Rolle mit derselben Fähigkeit wäre eine falsche Fährte ohne Kanon-Grundlage. Das entscheidet die Kanon-Verantwortung, nicht der Nachtlauf.
  - **OA-Zeiten außerhalb LISTE-ZEITEN (R14-2):** Der neue Kanon-Satz „Andere Uhrzeiten nennen nur Rollenkarten, Hinweise und Beweisstücke“ deckt die OA-Aussagen der Rollen. Unsere Ergänzung führt Zeitangaben in O-Datensätzen ausdrücklich als Aussagen (E34 B-1). Keine Änderung.
  - **„00:01 … kommt zu sich“ gegen PF-3 (R14-5):** Das ist Kanon-Wortlaut von v1.0 (LISTE-ZEITEN, PF-3), kein Overlay-Text. Steht als Hinweis für die Kanon-Autoren in FÜR DEN NUTZER.
  - **OA-27 (R14-7):** „die Serpentinen rauf … Bis zum Morgengrauen“ ist Ortsanpassung seit Phase 0 (d577d12). Die Burgstadt liegt am Berg, und das Spiel läuft bis zum Morgengrauen, nicht bis zum Nachtisch.
  - **R15 „Von Papa nehmen sie nichts an“ (R13 G-2):** Das ist Kanon-Wortlaut (Zwillinge, Vater Mathelehrer), Teenager-Humor ohne Herkunftsbezug. Keine Änderung.
- Neue Inhaltsrunde A-702o (zwei Prüfer) auf diesem Stand. Die Karten sind unverändert (db8e0a6155), Z-03 bleibt gültig.

## E43 · 09.10. 13:12 · Inhaltsrunden 15/16 (A-702o): Himmel klar, Teestube offen, FM-1 ohne Herkunft
- **Urteile:** Prüfer 15: Leitplanken ja, Kanontreu ja, Plagiatsfrei ja (mittel 1, gering 6). Prüfer 16: Kanontreu **nein** (mittel 3, gering 5). Ein „nein“ wird nicht übergangen, auch wenn der andere Bericht für Z-12 genügen würde.
- **Umgesetzt:**
  - **Himmel (R16 M1):** K-002 sagt seit jeher „klarer Himmel“, Raureif auf dem Hof. Neu in v1.0: Eisnebel nur im Tal um Silberhau und auf dem unteren Burgweg (Inversionswetterlage). Unsere Stadttexte hatten Nebel in der Oberstadt, ein Widerspruch seit Phase 3.
    - Jetzt liegen 18 Stellen in `bewohner.json`, die Kirchenburg in `haeuser.json`, zwei Erzählerzeilen und H-S24/HW-S24 im Kanon-Wetter: Raureif, Mondlicht, Frost, Dunkelheit. Nebel steht nur noch unten im Tal („das Nebelmeer im Tal“, „der Eisnebel da unten“).
    - Bleiben dürfen die Legende vom Nebelriesen, allgemeine Sprüche („Wer im Nebel steht, folgt dem Seil“, „Bei Nebel soll er nach Tannenholz riechen“) und OA-27 (Eisnebel auf den Serpentinen, also der untere Burgweg).
    - Der Renderer blendet die Ferne nach Dunkelblau (Nachthimmel), nicht in weißen Nebel; das Bild passt.
  - **Teestube (R16 M2):** H-S13 (Phase 2) zeigt die Teestube offen, die Inhaberin B07 schlief aber bis 02:50. Ihr Nachtplan ist jetzt: Fenster bis 01:20, Teestube ab 01:20, um drei Uhr kurz vor die Tür zum Uhrturm, danach wieder Teestube.
  - **FM-1 (R16 M3, R15 M1 im Zusammenhang):** Prüfer 16 zeigt, dass die Begründung in FM-1 dem Kanon selbst widerspricht. „Keine Minderheitsgruppe mit Schuld oder Betrug“ stimmt nicht: R02 legt den Hebel um und lügt über den Streich. Damit fällt die Abwägung aus E42. Im wirksamen Kanon steht FM-1 jetzt nach Rollen-IDs, ohne Herkunft und mit der Begründung „Verdacht, Schuld und Entlastung folgen nur aus Gegenständen, Zeiten und Aussagen“. Die Kanon-Datei ist unverändert.
  - **Familienfelder (R16 G1, G5):**
    - R05: Die Großmutter wohnt zwei Straßen weiter, wie bei R13.
    - R18: Die Großmutter ruft an und lässt sich die Woche erzählen; Urteil und Richterin-Witz sind gestrichen.
    - R12: kein Kaffee-Ritual mehr; stattdessen die Familiendiskussion über die beste Abkürzung durch die Stadt.
  - **Wärter B06 (R16 G2):** Die Torhaus-Sicherungen kennt er vom Burgwart. Das Torhaus ist bis Phase 2 zu.
  - **Punsch (R15 G1):** Neue Ersetzungen ERSETZE-19..21 machen „Punsch“ in OA-23, BW-ZUSTAND und K8 ausdrücklich alkoholfrei.
  - **R02-Anrede (R16 G3):** ERSETZE-22 „fällt dir das Handy“ → „fällt ihr das Handy“; R02-WISSEN ist sonst in der dritten Person geschrieben.
  - **B13/B33 (R15 G2):** Beide hießen „Rentnerin, früher Weberin“. B13 ist jetzt „früher Handarbeitslehrerin“ (Strickzeug); B33 bleibt Weberin (Webstuhl im Haus).
- **Abgewogen, bleibt:**
  - **„HODŽIĆ VT · 3“ (R15 M1):** Das ist eine Eigentumsmarke mit dem Nachnamen, wie sie Veranstaltungstechniker auf ihre Geräte kleben. Der Name ist kein Herkunftsindiz; die Fährte läuft über das Gerät, nicht über die Herkunft. Prüfer 15 urteilt trotzdem „Leitplanken ja“. Eine Änderung der Lösungskette (DW1-1, GL-19) gehört zur Kanon-Verantwortung.
  - **G3-23 (R16 G4):** „Zurückgeben hab ich sie ihn nicht sehen“ ist korrektes umgangssprachliches Deutsch („Ich hab sie ihn nicht zurückgeben sehen“); keine Änderung.
  - **Harz-Reste in Kanon-Fließtext ohne @ (R15 G3):** GM-08, M-06, M-12 und die Palette in K9 sind keine Datensätze und erscheinen nicht im Spiel (Parser und Scanner lesen nur @-Zeilen bzw. Spieltexte).
  - **Ziffern in vorlesbaren Texten (R15 G4):** Die Stilblatt-Regel gilt für das Vorlesen beim Krimidinner. Das Spiel zeigt Texte an und liest nicht vor.
  - **R04-Uhr (R15 G6):** Kleinteile unter einem Figurenpixel werden nicht gezeichnet (E37 H1).
- **R05-Frisur (R15 G5), umgesetzt:** Die Karte zeigte schon den Bob aus LF-R05 (`frisur-bob`); nur das Feld in `rollen.json` sagte „schulterlang“. Es heißt jetzt „bob“; Ersatzpfad und Datentest kennen den Wert. Das Bild bleibt gleich (Kartenstand unverändert).

## E44 · 09.10. 13:46 · Inhaltsrunden 17/18 (A-702p)
- **Urteile:** Prüfer 17: ja · ja · ja (mittel 2, gering 5). Prüfer 18: Kanontreu **nein** (mittel 2, gering 4). Das „nein“ wird umgesetzt, nicht übergangen.
- **Umgesetzt:**
  - **LA-01 (R18-1):** Der Bild-Anker im Overlay sprach noch von „drifting night fog around it“. Jetzt heißt es „under a clear frosty night sky, valley mist far below“, passend zu K-002.
  - **Auffinden des Burgwarts (R18-2):** Die öffentliche Liste sagte „00:01 … gefunden und kommt zu sich“. OA-20 sagt etwa 00:01:30, Rollenwissen und Lösung sagen 00:00:25 und 00:00:50. Unsere Kopie von LISTE-ZEITEN sagt jetzt „kurz nach Mitternacht“; das ist mit allen Quellen vereinbar und wird über R04s Fähigkeit wörtlich ausgegeben. OA-20 und die genaue Festlegung bleiben Sache der Kanon-Autoren (FÜR DEN NUTZER).
  - **Familienfelder (R18-3):** Die Beschreibung im Overlay-Abschnitt nennt jetzt alle tatsächlichen Änderungen statt „nur ein Satzteil“. Die Kanon-Dateien und ihr PROTOKOLL.md bleiben unberührt; unsere Anpassungen stehen im Overlay und in diesem Log.
  - **B03 (R18-4):** „wollte nur der Frost ein Brötchen“ statt Nebel.
  - **R13 (R18-5):** Statt Haushaltsbuch (Sparsamkeits-Anklang) der Gartenkalender der Großmutter.
  - **Code-Kommentar (R18-6):** Phase 1 = 60 Spielminuten.
  - **B35 (R17 B2):** Die Reinigungskraft ist keine Wisch- und Schweigefigur mehr. Sie ist fröhlich, kennt jeden Namen und jede knarrende Stufe und war um die Zeit schon zu Hause.
- **Bewusst so:**
  - **R09 (R18-5):** „bei ihr hat Tomasz kochen gelernt“ erklärt seinen Beruf (Koch, Kanon); das Fest ist schon gestrichen (E38).
  - **„HODŽIĆ VT · 3“ (R17 B1, wie R15 M1):** Beide Prüfer urteilen „Leitplanken ja“. Die Eigentumsmarke mit Nachnamen ist Kanon-Lösungskette (BSO-03, H-28, DW1-1, GL-19). Ein Umbau gehört zur Kanon-Verantwortung; der Vorschlag (neutrale Kennung) steht in FÜR DEN NUTZER.
  - **Geringe Befunde R17 G1–G5** (Geschlechterrollen in Dienstberufen, Bock-Inschriften, Besen des Schornsteinfegers, Name „Kunibert“, Handschuhe bei B34): nach der Abbruchregel (E40) in FÜR DEN NUTZER.

## E45 · 09.10. 14:14 · Inhaltsrunden 19/20 (A-702q): R04-Pullover sichtbar, Ortsliste, FM-1 in der Quelle
- **Urteile:** Prüfer 19: Kanontreu **nein** (R04-Pullover im Bild nicht als Strick erkennbar). Prüfer 20: Leitplanken **nein** (FM-1 in der Kanon-Quelldatei). Beide werden behandelt, nicht übergangen.
- **Umgesetzt:**
  - **R04 (R19 M1, R20-5):** Der Pullover war nur die grün gefärbte Grundform. Jetzt trägt R04 das neue Teil `oberteil-strickpulli`: Rumpf und Bund wie beim Strickpulli der Bewohnerinnen und Bewohner, aber ohne Rollkragen, damit das Hemd darunter nicht verdeckt wird. Der Bund ist eine Stufe dunkler im selben Grün.
    - Der Ersatzpfad nimmt bei Pullover über Hemd dieses Teil plus Hemdkragen, sonst den Rollkragen (R08).
    - `karten_test` und `tool/mass5a.py` sind ohne Paar. Neuer Kartenstand b60891cc2b; zwei neue Sichtprüfer (A-605u/v).
  - **Ortsliste (R20-2, R20-3):** In LISTE-ORTE (Overlay) stehen jetzt „Wäschekorb neben der Toilette“ (Hofebene, neu in v1.0, Z-2140) und „Freibad (außerhalb, in einer anderen Jahreszeit; nur Rollenwissen und Lösung)“.
  - **Wortwahl (R19 G2):** „Herkunft“ kommt in `faehigkeiten.json` nicht mehr vor (Wachs: „Art“, Schrei: „Quelle“).
- **FM-1 in der Kanon-Quelle (R20-1, hoch): bleibt in der Quelle, Entscheidung beim Nutzer.**
  - FM-1 setzt eine Regel aus dem Grobplan des Krimidinners um (00_steuerung/GROBPLAN.md: „Herkunft und Schuld: Funktionsmatrix, damit keine Minderheitsgruppe eine belastete Funktion mit Schuld trägt“, präzisiert in F-07). Sie ist eine Vorgabe des Kanon-Projekts gegen Klischees. Der Nachtlauf überschreibt keine Projektregel eines anderen Arbeitsstrangs.
  - Im Spiel wirkt FM-1 nicht: Das Spiel zeigt keine [L]-Datensätze an, und im wirksamen Kanon steht FM-1 nach Rollen-IDs ohne Herkunft (E43).
  - **Klarstellung zu E41:** Dort stand „Die Kanon-Dateien sind Spieltext“. Gemeint und richtig ist: Spieltext sind die O- und G-Datensätze des wirksamen Kanons (das Spiel zeigt sie an). L-Datensätze sind Lösungsdaten; sie werden auf Widersprüche geprüft, wie es der Prüfauftrag von Anfang an sagt („L-Zeilen nur zur Widerspruchsprüfung“). Der Kanon-Ordner gehört zu den Textpfaden des Abnahmewerkzeugs, weil jede Kanon-Änderung eine neue Prüfung auslösen soll; das bleibt.
  - Die Kritik der Prüfer an FM-1 und der Vorschlag (FM-1 nach Rollen-IDs wie im Overlay) stehen in FÜR DEN NUTZER.
- **Bewusst so:**
  - „HODŽIĆ VT · 3“ (R19 M2): wie E43/E44, Kanon-Verantwortung.
  - „Schatten im Nebel. Physik.“ (R19 G1): Das ist R20s Erklärung der Nebelriesen-Legende (Schatten auf einer Nebelwand), keine Wetterangabe.
  - „Burgweg“ für zwei Abschnitte (R19 G3): Das ist Kanon-Wortlaut ohne Widerspruch.
  - Texte der „Klassischen Fälle“ (R19 G4): Bestand außerhalb der Burgstadt (E14a).
  - „kurz nach Mitternacht“ (R20-4): bleibt, E44.

## E46 · 09.10. 15:13 · Prüfrunde nach E45 (A-605u/v, A-702r): Lampenmarke ohne Nachnamen
- **Urteile:**
  - Sichtprüfer 23 und 24 melden am Kartenstand b60891cc2b je Paare 0 und Verstöße 0; damit ist Z-03 erfüllt.
  - Inhaltsprüfer 21: Leitplanken **nein**, Kanontreu ja, Plagiatsfrei ja.
  - Inhaltsprüfer 22: ja · ja · ja.
- **Umgesetzt:**
  - **Lampenmarke (R21 M-1, R22-2):** „HODŽIĆ VT · 3“ wird im Spiel zu „VT · 3“ (ERSETZE-23), die Aussprache in GL-19 zu „fau-te drei“ (ERSETZE-24).
    - Neuer Grund gegenüber E43–E45: Der Nachname ist das einzige Eigentumsmerkmal auf dem Beweisstück. Für die Zuordnung zu R01 braucht man ihn nicht, denn „VT“ steht für R01s Firma (Beruf in R01-STAMM), und die Rollentexte sagen „deine Lampe 3“ bzw. „Adnans Lampe 3“.
    - Vier Prüfer haben das angeregt, einer mit „nein“. Die Änderung kostet eine Overlay-Zeile.
    - H-28 trägt keine notwendige Schlussfolgerung (S-1…S-7) und ist die falsche Fährte (DW1-1). Inhalt und Spielwirkung bleiben gleich: Die Lampe zeigt auf R01.
    - `kanon_test` prüft, dass H-28 sich nur in der Marke vom Original unterscheidet und kein „HODŽIĆ VT“ mehr im wirksamen Kanon steht. Die Kanon-Dateien bleiben unverändert; der Hinweis an die Kanon-Autoren steht in FÜR DEN NUTZER.
  - **„Herkunft des Schreis“ (R22-3):** im Spiel „Quelle des Schreis“ (ERSETZE-25; R02-LÜGE, LR-7), wie schon in `faehigkeiten.json` (E45).
- **Bewusst so:**
  - **Herkunft auf der R01-Karte (R21 M-1, Teil 2):** Das Spiel liest aus den Stammdaten nur Name, Aussprache, Geschlecht, Alter, Beruf, Kleidung und Sprechweise (`fall_daten.dart`). „Wurzeln“ und „Familie“ zeigt es nirgends an. Herkunft ist im Spiel also weder sichtbar noch Teil einer Spur.
  - **Ziffern in vorgelesenen Texten (R21 M-2, K8 §5):** Die Regel des Stilblatts gilt für Texte, die die Spielleitung beim Krimidinner vorliest. Die App liest nichts vor, sie zeigt alle Texte als Karten an, und für Karten erlaubt K8 §5 Ziffern. Eine Ersetzung von Uhrzeiten in Worte würde zudem die Zeitprüfungen gegen LISTE-ZEITEN umgehen. Für die Kanon-Autoren steht der Punkt in FÜR DEN NUTZER.
  - **FM-1 (R22-1, hoch, [L]):** wie E45, Nutzerentscheidung. Dass die Verteilung der Funktionen im Overlay gleich bleibt, ist gewollt: Sie ist der Fall selbst (Täterin, Hauptverdächtiger, Zeugin). Ohne Herkunftsangabe und ohne sichtbare Herkunft im Spiel ist sie kein Herkunftsmuster mehr.
  - **„in einem der Abdruck“ (R21 G-1):** Ellipse („in einem [der Spritzer] der Abdruck“), grammatisch richtig, Kanon-Wortlaut.
  - **Gleiche Familienangaben bei R06 und R18, Sonntagsmotiv (R21 G-2):** Das steht so im Kanon (Eltern in Celle, Vater Lokführer; „sonntags“ bei R05, R09, R12, R15, R18). Das Overlay ändert Familienfelder nur aus Leitplanken-Gründen (E38). Hinweis an die Kanon-Autoren in FÜR DEN NUTZER.
  - **Lüftungsschacht nur in G-Daten (R21 G-3):** ein Bauteil, kein Ort und kein Lösungsgegenstand; kein Widerspruch zu den O-Zeilen. Kanon-Verantwortung, in FÜR DEN NUTZER.
  - **„Punschkessel“ ohne „alkoholfrei“ (R22-4):** Der Kessel ist im Kanon öffentlich als alkoholfrei festgelegt (OA-04, GL-14). Wo im Spieltext jemand Punsch trinkt, steht „alkoholfrei“ (ERSETZE-19…21).
  - **Wortliste des Scanners (R22-5):** „bewusstlos“ und „Herkunft“ stehen in den Rohdateien rechtmäßig, als ERSETZE-Quelle bzw. in L-Daten. Den wirksamen Kanon prüft `kanon_test` darauf (kein „bewusstlos“ über ERSETZE-17, kein „Herkunft des Schreis“, keine Lampenmarke mit Nachnamen).
- Neue Inhaltsrunde A-702s (Prüfer 23 und 24), weil sich der Textpfad `nachtlauf/kanon` geändert hat. Die Figuren sind unverändert; Z-03 bleibt erfüllt.

## E47 · 09.10. 15:40 · Inhaltsrunde A-702s: Färbungen, Firmenname, Punsch; Herkunftsverteilung als Nutzerentscheidung
- **Urteile:** Prüfer 23 und Prüfer 24: Leitplanken **nein**, Kanontreu ja, Plagiatsfrei ja. Beide begründen es vor allem mit der Verteilung der Fallfunktionen auf Rollen mit Herkunftsangabe. Prüfer 23 nennt dazu die Geld-Färbungen.
- **Umgesetzt (Overlay, Kanon-Dateien unverändert):**
  - **Färbungen R13 und R15 (R23-2):** „wirkt dadurch kalt und berechnend“ heißt jetzt „wirkt dadurch unnachgiebig“ (ERSETZE-27). „wirkt, als denke sie nur in Beträgen“ heißt jetzt „wirkt dabei seltsam ungerührt“ (ERSETZE-28).
    - Grund: Diese beiden Adjektive verbinden zwei türkischstämmige Frauen in Finanzberufen mit Geldgier und Kälte; das ist ein bekanntes Klischee.
    - Die Färbung selbst bleibt (Geld zurückfordern, über Schäden reden); sie folgt aus Beruf und Lage der Figur.
  - **Firmenname (R24-2):** R01s Beruf lautet im Spiel „(eine Ein-Mann-Firma mit Transporter)“ ohne „Hodžić Veranstaltungstechnik“ (ERSETZE-26, `faehigkeiten.json`). „VT · 3“ führt damit über den Beruf (Veranstaltungstechniker) zu R01, nicht über den Nachnamen.
  - **Punsch (R24-3):** Z-0005 und das Detektiv-Ergebnis DW1-3 sagen jetzt „alkoholfrei“ (ERSETZE-29/30). Neuer Test: In jedem angezeigten Datensatz (O, G, DW) steht bei „Punsch“ im selben Feld „alkoholfrei“; die Gegenprobe ohne ERSETZE-30 wird rot.
  - **K-010 im Overlay (R23-5):** Das Overlay sagt jetzt selbst „unten im Tal“ statt „Osterode“. Wirksam war das schon über ERSETZE-18.
- **Berichtigung zu E45:** Nicht alle L-Datensätze sind ungesehen. Die Ergebnistexte der Detektiv-Entscheidungen (DW…, Felder „Ergebnis A/B/C“) zeigt das Spiel nach einer Entscheidung an (`fall_daten.dart`). Sie zählen deshalb zum Spieltext.
- **Nicht im Nachtlauf lösbar, Nutzerentscheidung (R23-1, R24-1):** Die Verteilung der Funktionen im Fall.
  - Täterin R03 und Mietbetrug R04 haben deutsche Wurzeln. Die falsche Fährte R01 hat bosnische, die Hauptzeugin mit dem Streich R02 kurdische Wurzeln. 16 der 20 Rollen haben nichtdeutsche Wurzeln.
  - Das ist die Anlage des Falls nach FM-1 und GROBPLAN F-07. Es zu ändern hieße, den Fall neu zu besetzen, oder die Herkunftsangaben aus den Spieldaten zu nehmen. Beides entscheidet der Nutzer, nicht der Nachtlauf.
  - Die Optionen stehen in FÜR DEN NUTZER. **Z-12 bleibt offen**, bis das entschieden ist; danach folgt eine neue Inhaltsrunde.
- **Bewusst so:**
  - **Übernachtung in der Pension (R23-3):** K-010 betrifft die Burg; die Pension liegt in der Stadt.
  - **„KI-Erzähler liest vor“ (R23-4):** FÜNF-SÄTZE beschreibt das Krimidinner, nicht die App; E46 bleibt richtig.
  - **Einstufung H-S05/H-S09 (R23-6):** Die Hinweise entlasten Pension und Volksbühne nur als Ortsfarbe, keine Rolle; „Farbe“ bleibt.
  - **Ersatzsicherungen (R23-7):** OA-21 sagt nur, wo der Ersatz liegt, nicht, dass er passt; dass der Strom bis zum Morgen aus bleibt, ist die Spielnacht.
  - **R04 `weste` (R23-8):** Das ist das Material des Bunds am Strickpullover (E45), kein Datenrest.
  - **„Geisterstunde“ (R23-9):** ein gebräuchliches Wort, kein Werktitel.
  - **Übrige Färbungen (R23-2):** R05 (Ärger über das Mietgeld), R14 (Groll für Adnan), R06 (Wissen aus dem Sanitäterberuf) und R16 (Jonas' Kreditanfrage) folgen aus Lage und Beruf der Figur, nicht aus ihrer Herkunft.

## E49 · 09.10. 16:21 · Strang „Finalisierung Schlosskeller“ in den Nachtlauf-Stand gemergt (N-02)
- **Nutzerentscheidung N-02:** Der Branch `finalisierung-schlosskeller` wird jetzt in `main` zusammengeführt. Er gehört zu einem anderen Arbeitsstrang mit eigenem Master-Prompt, Plan und Entscheidungslog unter `planung/finalisierung-schlosskeller/`, und die Sitzung dort arbeitet weiter. Gemergt ist der Stand f5190ac. Spätere Commits auf dem Branch sind nicht in `main`, bis sie erneut zusammengeführt werden.
- **Merge:** Ein normaler Merge-Commit; die Geschichte bleibt unverändert. Konflikte gab es nur in zwei Dateien:
  - `pubspec.yaml`: In der Asset-Liste stehen jetzt beide Blöcke, die Burgstadt-Assets und `content/party/schlosskeller/` mit `tatmatrix/`.
  - `pubspec.lock`: nicht von Hand aufgelöst, sondern mit `flutter pub get` neu erzeugt. Das Ergebnis ist genau die Vereinigung beider Lock-Dateien; keine Paketversion weicht von einer der beiden Seiten ab.
- **Neue Abhängigkeit:** `pdf` 3.13.1 (Apache-2.0) in `mordakte_core`, dazu transitive Pakete unter MIT, BSD-3-Clause und Apache-2.0. Begründet ist das im Strang selbst (`planung/finalisierung-schlosskeller/LIZENZEN.md`, Entscheidungslog dort): PDF-Satz je Fall-Code, verbreitet, gepflegt, reines Dart. Das Burgstadt-Spiel nutzt es nicht.
- **Prüfung:** Grün sein müssen unser Gesamttest `tool/alle_tests.sh` und das Prüfskript des Strangs `tool/pruefen.sh alles` (Analyse, Kern- und Partymodus-Tests, Validator, Server-Smoke, Flutter-Tests, Web-Build ohne CDN, Secret-Scan).
- **Befund beim Merge:** Unser Leitplanken-Scanner (Ebene 10, alle Texte unter `content/`) fand in den Partydaten sechsmal „Weinrot“ (Farbe der Figur Fatma). Der Ton-Leitfaden des Strangs verbietet „Wein“ selbst („so benannt, dass niemand an Alkohol denkt“). Es ist also ein echter Befund und kein Fehlalarm.
  - Im Merge-Commit heißt die Farbe deshalb „Beerenrot“ (`figuren.json`, `gegenstaende.json`). Die STORY-BIBEL ist mit dem Generator des Strangs neu geschrieben (`party_bibel.dart`, nur diese drei Zeilen).
  - Danach sind die Partytests (170), die Plausibilität, der Simulator und der Scanner grün.
  - Die Auftragsdateien des Strangs (`planung/…/auftraege/F3-AUTOR-*.md`) nennen noch „Weinrot“; der Hinweis an den Strang steht in FÜR DEN NUTZER. Dort steht auch der Farbname „Bordeaux mit Gold“, den der Scanner nicht meldet, der aber ebenfalls ein Weinname ist.
- **Abgrenzung:** Die Abnahme Z-01 bis Z-14 gilt für den Nachtlauf. Die Partytexte des Schlosskellers prüft der eigene Strang (seine Abnahme F-01…F-17); sie gehören nicht zu den Textpfaden von Z-12.

## E48 · 09.10. 16:31 · Herkunft ist nicht Teil der Spieldaten (Nutzerentscheidung N-02)
- **Anlass:** Die Inhaltsrunde 23/24 urteilte „Leitplanken nein“, weil die Fallfunktionen mit der Herkunft der Rollen zusammenfallen (E47). Der Nutzer hat entschieden: Die Herkunftsangaben kommen aus den Spieldaten heraus, der Kanon des Krimidinners bleibt unverändert.
- **Umgesetzt (Overlay, Abschnitt Familienfelder):**
  - Das Feld „Wurzeln“ ist bei allen 20 Rollen gelöscht (`Löschen: Wurzeln`). Für R02, R03, R04, R10, R11 und R17 gibt es dafür eigene Zeilen; bei R20 steht es in einer neuen Familienzeile.
  - Die Familienfelder nennen keine Herkunftsorte mehr: R01, R05 und R16 beginnen mit „Die Eltern leben in …“ (Salzgitter, Gifhorn, Wolfsburg), bei R20 fährt die Familie „an einen See“ statt an die Masurischen Seen. Der Rest jedes Feldes bleibt wörtlich.
  - Namen und Aussprache bleiben, denn sie sind die Identität der Figuren, keine Herkunftsangabe. Die Burgwart-Angabe „Herkunft: Schartenfels, Bergland“ bleibt; sie ist ein Ort der Spielwelt.
- **Belegt:**
  - Neuer Test in `kanon_test`: Kein Rollen-Steckbrief im wirksamen Kanon hat „Wurzeln“, der Kanon selbst hat sie weiterhin. Kein angezeigter Text (O, G, DW-Ergebnisse) nennt bosnisch, kurdisch, türkisch, polnisch, Tuzla, Opole, Zenica oder Masur.
  - Gegenprobe: Ohne die Löschzeile für R02 oder mit „Tuzla“ wird der Test rot.
  - `kanon.dart --pruefe`: 0 Befunde, 1276 Datensätze.
- **Wirkung im Spiel:** keine sichtbare. Das Spiel liest „Wurzeln“ und „Familie“ nicht (`fall_daten.dart`). Die Verteilung der Fallfunktionen bleibt die des Kanons, ist aber im Spiel an kein Herkunftsmerkmal mehr gebunden.
- **Zurücknehmen:** Die `Löschen: Wurzeln`-Angaben und die vier Ortsänderungen im Overlay entfernen.
- Neue Inhaltsrunde A-702t mit drei Prüfern (25 gesamter Spieltext, 26 wirksamer Kanon, 27 Herkunft und Klischee).

