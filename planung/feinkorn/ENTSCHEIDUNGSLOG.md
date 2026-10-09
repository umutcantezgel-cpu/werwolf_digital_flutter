# FEINKORN · ENTSCHEIDUNGSLOG

Jede Entscheidung nach dem Denkprotokoll (Master-Prompt §5): Ziel/Messgröße · Wege · Bewertung · Umkehrprobe · Folgen · Entscheidung. Belege liegen in `planung/feinkorn/messbasis/` und `planung/feinkorn/bilder/k0/`.

## E-F001 · Burgstadt HD pausiert
Der Nutzer hat entschieden: Burgstadt HD pausieren, FEINKORN bekommt alle vier Plätze (2026-10-09). Burgstadt HD ist auf `claude/pensive-gates-ajtp7x` gesichert (caf1d61, unfertige Arbeit als Patch in `hd/wip/`).

## E-F002 · Arbeitsordner und Branch
- Ziel: eigener Ordner, nie der Ordner des Finalisierungs-Laufs.
- Befund: Im Hauptordner ist `claude/pensive-gates-ajtp7x` ausgecheckt, nicht `finalisierung-schlosskeller` → Halte-Ausnahme aus §2 greift nicht.
- Entscheidung: Worktree `/home/user/feinkorn`, Branch `kern-feinkorn` von origin/main e7e4219, ohne Upstream (kein versehentlicher Push auf main).

## E-F003 · Quellmaterial und Kanon-Quelle
- `quellen/schlosskeller-teamchat.txt` fehlt (nie committet, .gitignore). Der Kanon liegt auf main: `content/party/schlosskeller/` (kanonVersion 1.0.0, F1-Tor bestanden); neuere Stände kommen von origin/finalisierung-schlosskeller (6c09b33).
- NICHT Kanon dieses Falls: `krimidinner/spuk-im-gewoelbe/10_kanon/` (anderer Fall, Burgstadt) und `planung/finalisierung-schlosskeller/KANON-ENTWURF.md` (veraltet).
- Entscheidung: Kanon-Quelle ist `content/party/schlosskeller/` in seiner jeweils hereingemergten Fassung. Das Quellmaterial wird nur benötigt, wo der Kanon schweigt; dann gelten Zusatzwerte (E-F013).

## E-F004 · Wo die Pixel-Bausteine liegen (K-01)
1. Ziel: klar getrennter Teil, Konventionen des Projekts, keine neue Abhängigkeit, wiederverwendbar.
2. Wege: (a) neues Paket `packages/feinkorn` (neuer Pfad-Eintrag in pubspec = neue Abhängigkeit der App, pubspec gehört dem Finalisierungs-Lauf); (b) eigene Bibliothek im vorhandenen Paket `pixel_engine` (`package:pixel_engine/feinkorn.dart`, Code in `lib/src/feinkorn/`); (c) Code direkt in `lib/` der App (nicht wiederverwendbar, mischt Spiel und Bausteine).
3. Bewertung: (b) erfüllt alle Ziele; pixel_engine ist reines Dart ohne Abhängigkeiten und schon Abhängigkeit der App.
4. Umkehrprobe: Falsch wäre (b), wenn pixel_engine Spielinhalt erzwingt oder spätere Spiele das Paket nicht nutzen könnten – beides nicht der Fall; die Trennungsprüfung (Test) hält feinkorn frei von Spielinhalt und von Importen aus burgstadt/mordakte.
5. Folgen: Store-App unverändert in ihren Abhängigkeiten; spätere Ausgliederung in ein eigenes Paket bleibt einfach.
6. Entscheidung: (b). Fünf Bereiche `daten/`, `darstellung/`, `physik/`, `bewegung/`, `werkzeuge/`. App-Anschluss in `lib/game/feinkorn/`.

## E-F005 · Darstellungsweg (K-03, K-04)
1. Ziel: feine Blöcke räumlich mit Licht, Bildrate je Klasse (hoch 60, mittel/einfach 30), Ruhemodus, Akku.
2. Wege, gemessen im Testraum 10 × 10 × 4 m (2,85 Mio. Blöcke, 377 316 sichtbare Flächen) in Flutter-Web, Headless-Chromium ohne GPU (Software-WebGL, gleiche Bedingungen wie die Messbasis):
   - **A – Block-Sprites:** Blockkörper per Splatting in die Iso-Projektion gebacken (Seitenlicht, Schattenkarte, Fugen-/Eckverdunklung, Streuung), je Bild nur `drawImageRect`. hoch 60 B/s (p99 16,8 ms), mittel 22 B/s; Backen 1,5 s (hoch) / 6,2 s (mittel, 4× gedrosselt), Dart-VM 0,4 s.
   - **B – pixel_engine-Software-Rasterer:** Bild je Bild auf der CPU; gemessen in Burgstadt mit demselben Rasterer: ≈ 52 ns/Pixel, 12 ms je 640 × 360-Bild auf diesem Rechner, palettengebunden (160 Farben) und perspektivisch statt isometrisch.
   - **C – drawVertices je Bild:** 754 632 Dreiecke; hoch 5 B/s, mittel 2,8 B/s.
   - Messbasis (heutige Canvas-Darstellung der Vorschau): hoch 6–8 B/s, mittel 3–4 B/s.
3. Bewertung: A ist am schnellsten (≈ 10 × Bestand), im Ruhezustand fast kostenlos (nur Blitten), passt in die vorhandene Tiefensortierung, Cutaway und Lichtschicht von MordakteGame. B kostet Akku je Bild und passt nicht zur Iso-Kamera. C ist für Handys zu schwer.
4. Umkehrprobe: A wäre falsch, wenn Backzeit oder Bildspeicher die Budgets sprengen. Gegenmaßnahmen: Backen nur sichtbarer Räume (Nebel des Krieges), Backen im Isolate (nativ) bzw. in Scheiben über Bilder (Web), Backskala je Klasse, Rezepte statt Modelle, Freigabe unsichtbarer Räume. Backzeit wird an jedem Tor gemessen.
5. Folgen: Bewegte Körper und Figuren werden als kleine Sprites je Bild/Animationsbild gebacken; Licht für Ruhendes ist vorberechnet (E-F006).
6. Entscheidung: Weg A.

## E-F006 · Licht
- Ruhendes Licht wird gebacken: Licht aus 45° Höhe von links (Oberseiten hell, linke Seiten mittel, rechte dunkel), Schattenkarte aus Lichtsicht (Schattenwurf aus der Form), Fugen- und Eckverdunklung aus Nachbarblöcken, Materialstreuung, Eigenleuchten.
- Dynamisches Licht (Flackern der Kerzen, Taschenlampenkegel, Stromausfall, Nebel des Krieges mit Aufblende) bleibt in der vorhandenen Lichtschicht von MordakteGame (`LightingRenderer`) bzw. der F4-Schnittstelle `RaumSicht` des Finalisierungs-Laufs; Lichtwechsel (Stromausfall) backen betroffene Räume neu.
- Grenze: echte Schattenwürfe bewegter Lichter (Taschenlampe) auf gebackene Flächen sind in der Canvas-Technik nur genähert (Schattenmaske der Figur im Kegel); Vermerk unter FÜR DEN NUTZER, Prüfung in K5.

## E-F007 · Physik
- Rate 120 Hz fest (gemessen: 147 µs je Schritt mit 1 116 Kontaktpunkten und 168 Partikeln; Fallzeit 1 m 0,34 % Abweichung; gleicher Endzustand bei 30/60/120 B/s und bei Wiederholung).
- Determinismus: eigener Zufall (lineare Kongruenz, exakt in doppelter Genauigkeit), feste Reihenfolge, keine trigonometrischen Funktionen in der Simulation.
- Offene Bausteine für K2: Körper-gegen-Körper-Stöße (Stapel), Bruch je Material, Ablagerung als Blöcke der Welt, Schüttgut.

## E-F008 · Gelenkweg (K-06)
- Gemessen (Gangzyklus, 8 Bilder, 1-cm-Blöcke, ≈ 99 000 Blöcke): Vorwärtsabbildung „starr“: 0 von 8 Bildern geschlossen, 30–41 Nadellöcher, bis 11 abgerissene Teile, 10 ms/Bild; Rückabtastung + Gelenkkugeln „rück“: 8 von 8 geschlossen, 0 Nadellöcher, 1 Teil, 19 ms/Bild (VM).
- Entscheidung: Neuaufbau je Bild per Rückabtastung der Teilmodelle mit Gelenkkugeln. Animationsbilder werden je Blickrichtung und Zustand vorgebacken und zwischengespeichert (LRU), live nur für nahe Figuren; bei mittel 2-cm-Blöcke (≈ 1/8 Aufwand).

## E-F009 · Blockgrößen je Geräteklasse
Startwerte bleiben: hoch 2,5 / 1 / 0,5 cm; mittel 5 / 2 / 1 cm; einfach 5 / 2 / 1 cm mit halber Backskala – oder automatisch die bisherige Darstellung, wenn Backzeit oder Bildrate das Budget verfehlen. Figuren nie gröber als 2 cm (Lesbarkeit geht vor).

## E-F010 · Messverfahren und Grenzen der Umgebung
- Keine Geräte, kein Android-SDK, kein Xcode, keine GPU. Gemessen wird: Dart-VM (Thread-CPU), AOT-Exe, Flutter-Web in Headless-Chromium mit CPU-Drosselung 1×/4×/6× als Näherung hoch/mittel/einfach (`tool/feinkorn/messen.mjs`).
- Die Browserwerte vergleichen Wege untereinander und gegen die Messbasis; absolute Handywerte liefert der Testplan unter FÜR DEN NUTZER.

## E-F011 · Backen nach Bedarf
Räume werden gebacken, wenn sie sichtbar werden (die Aufblende von 0,4 s deckt das erste Bild), und freigegeben, wenn sie lange im Nebel liegen. Backen nativ im Isolate (`dart:isolate`, keine Abhängigkeit), im Web in Scheiben über mehrere Bilder.

## E-F012 · Anschluss an die App
Ein kleiner optionaler Haken in `lib/game/mordakte_game.dart` (Muster wie der F4-Entwurf: `session is …`), alles andere in eigenen Dateien `lib/game/feinkorn/**`. Schalter „Darstellung: Bisherig | Feinkorn“ über das vorhandene shared_preferences (`lib/meta/meta_store.dart`), Standard bis K7 „Bisherig“. Eigene Vorschau `lib/game/dev/feinkorn_vorschau_main.dart`; Prüfstand und Modellschau als eigene Einstiegspunkte in `lib/game/dev/` (nie im Release-`main.dart`). Dateien des Finalisierungs-Laufs (pubspec, main, router, hub, preview_main, figure_painter, content/party, mordakte_core/party …) bleiben unberührt.

## E-F013 · Kanon-Lücken und Zusatzwerte
Fehlende Werte stehen in `lib/game/feinkorn/kanon_zusatz.dart`, verknüpft über Kanon-Kennungen; Wunschliste unter FÜR DEN NUTZER:
- Raumhöhen (Kanon nennt keine): Gewölbekeller 2,6 m Kämpfer, Scheitel 3,4 m; Turmgang 2,4 m; Windfang 2,4 m.
- Figurengrößen nach Statur: klein 1,62 m, schlank/normal 1,74 m, breit 1,76 m, groß 1,88 m; Frauen −0,08 m; Detektiv nach gewähltem Geschlecht.
- Toiletten oben im Turm (Ort `wc`), fünf Sandsteinstufen am Eingang à 0,17 m, Schlossfassade nach Setting, Wendeltreppe statt Platzhalter, Eiseimer und Handykorb als Objekte an ihren Orten.
- Ruhe-Animationen kommen aus `visualSpecs.idleAnimation`; die Beispiele im Master-Prompt weichen ab (Ahmet dreht laut Kanon am Lanyard) – es gilt der Kanon (Vorrang 4 vor Stil).

## E-F014 · Klang
Zur Laufzeit synthetisierte Klänge je Klangfamilie (scheppern, poltern, klirren …) über das vorhandene audioplayers, abgespielt aus Bytes; keine neuen Asset-Ordner (pubspec gehört dem Finalisierungs-Lauf). Trägt eine Plattform das nicht, Rückfall in den schon angemeldeten Ordner. Prüfung in K2.

## E-F015 · Budgettabelle je Geräteklasse
Siehe `BUDGET.md` (gemeinsamer Wert, nur Opus).

## E-F016 · Flimmerschwelle
Sprites werden in Bildpixeln gebacken und an ganzzahligen Bildpixeln gezeichnet (keine Umrechnung → kein Flimmern beim Schwenken). Messung: Schwenk um 0,5 logische Pixel ohne Szenenbewegung; Anteil der Pixel mit Helligkeitssprung > 10 % (Luma) gegenüber dem um denselben Versatz verschobenen Vorbild ≤ 2 %. Zoomwechsel über Detailstufen mit Überblendung.

## E-F017 · Zahl der Figurenmodelle
K-07 zählt 20 Rollen, den Detektiv in m- und w-Fassung und Herrn Schneider: 23 Modelle.

## E-F018 · Zielbildzeit und Helligkeit
- Zielbildzeit = 1 / Ziel-Bildrate (hoch 16,7 ms, mittel/einfach 33,3 ms); 99. Perzentil ≤ 2 × Zielbildzeit. K-04 misst im bewegten Spiel.
- Helligkeit (K-09): mittlere Luma Y′ (Rec. 709, 0..1) aller Weltpixel des Raums im Spielbild, ohne Bedienelemente; Soll 0,20–0,25.

## E-F019 · Offene Fragen der K0-Berichte
- ABNAHME-Entwurf: Schwellen festgelegt in E-F016, E-F018, BUDGET.md; Fallformel t = √(2h/g) mit g = 9,81; Stapel-Drift gemessen am Schwerpunkt der obersten Kiste; Speicher-Schwankung bezogen auf das Mittel der Durchquerung; „gedimmtes Licht“ = Lichtvorlage Stromausfall; Detail-Bezugszoom = Standardzoom der Szene.
- Kanon-Auszug: Detektiv-Name aus `title`, Geschlecht wählbar (E-F017); Toilette und Außenraum als Zusatzwerte (E-F013).
- Bildbestand: Der Schlosskeller läuft heute nur in der Vorschau – FEINKORN zeigt ihn dort und in der F4-Partysitzung, sobald sie hereingemergt ist; Vorlagenreste und fehlende Zeichnungen sind Sache des Finalisierungs-Laufs (FÜR DEN NUTZER).
