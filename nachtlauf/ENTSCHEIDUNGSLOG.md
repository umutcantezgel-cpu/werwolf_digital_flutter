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

## E4a · 08.10. 23:45 · Burg bleibt verschlossener Raum in Phase 1, Oberstadt ab Phase 2
- Ziel: Kanon-Logik S-1 („Täter noch in der Burg“) unverändert lassen und trotzdem eine begehbare, verschlossene Burgstadt bieten.
- Wege: (a) ganze Oberstadt als „verschlossener Raum“ (Bewohner würden Verdächtige → S-1 bricht), (b) Burgtor nur verriegelt statt verschlossen (H-01/PF-7 müssten geändert werden), (c) Burg bleibt bis Phase 2 verschlossen; der Bund (H-03) öffnet zu Phase 2 das Burgtor zur Oberstadt, die Stadttore bleiben zu.
- Gewählt: (c). Keine Änderung an H-01…H-29, S-1…S-10, PF-1…PF-7 nötig; die Stadt wird ab Phase 2 erkundbar, Phase 1 bleibt das klassische Gewölbe-Rätsel mit Blick vom Wehrgang über die dunkle Stadt.
- Umkehrprobe: falsch, wenn Phase 1 zu eng wirkt → Wehrgang begehbar mit Blick über die Stadt; Stadtorte tragen erst ab Phase 2 Zusatzspuren. Folgen: Durchstich (Phase 2 des Nachtlaufs) zeigt Burg + Marktplatz; im Fall ist der Marktplatz ab Fall-Phase 2 betretbar.
