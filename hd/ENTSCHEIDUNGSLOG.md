<!-- Burgstadt HD · erzeugt aus dem freigegebenen Gesamtplan v4 (Kern v1.0) · Quelle der Wahrheit ab jetzt diese Datei -->

# Burgstadt HD – ENTSCHEIDUNGSLOG

| ID | Entscheidung |
|---|---|
| E-001 | Gegenstand ist der Burgstadt-Pixelrenderer (Sichtung, deine Antwort) |
| E-002 | Stufe „scharf“ mit doppelter linearer Auflösung (360 Zeilen auf 720p/1080p) und automatischer Wahl; „sparsam“ und „mittel“ unverändert (deine Wahl) |
| E-003 | Palette 10 × 16, Altfarben auf 2s+1, `Ramp.at` mit 8er-Bedeutung (deine Wahl plus Gegenprüfung) |
| E-004 | Arbeitsbranch auf Burgstadt vorgespult; täglicher Merge (deine Wahl) |
| E-005 | 64 Texel/m für die Welt. Weil die Brennweite sich verdoppelt, bleibt tpp gleich; Flimmern wird über Mip v2 gelöst, nicht über die Dichte |
| E-006 | Skalierung „scharf“ = UI-Raster von „mittel“ mit kWelt = kUi (Welt 2× mittel, UI identisch, monoton); andere Stufen unverändert; Blocktest-k aus kUi je Profil |
| E-007 | Silhouette durch Geometrie, Oberfläche durch Textur |
| E-008 | Zufall für Details nur über `hashTeil` |
| E-009 | Ausstattung als darstellende Daten außerhalb der textPfade, ohne Texte, nicht blockierend |
| E-010 | Register nach Name; Enum bleibt die Namensquelle |
| E-011 | Figuren in zwei Dichten; Vergleicher auf 32 |
| E-012 | Porträts werden im Spiel eingebunden |
| E-013 | Leistung: Spannen, Sortierung nach Überdeckungsmessung, Nebel je Zeile, direkte RGBA-Ausgabe, Himmel nur in leeren Tiefen, Sprite-Spannen |
| E-014 | Budget „scharf“ nach L-07, Festlegung in P3-OPUS-02 vor allen Bauteilen |
| E-015 | Lichttabelle 12×12×6×160, einmal statisch gebaut |
| E-016 | In `nachtlauf/` kommen nur neue Dateien nach A-605 (N-HD-02); HD-Dokumente liegen in `hd/`; `tool/abnahme.dart` bekommt nur die Z-13-Zeile |
| E-017 | Formate versioniert ändern (v2 mit Diff) |
| E-018 | Haiku als Arbeitsmodell; Stufe 3 übernimmt Opus (29 Pakete) mit höchstens 2 je Schicht |
| E-019 | Galerie als Artifact |
| E-020 | Flutter nach `/opt/flutter` |
| E-021 | Jedes Bild sofort im Chat (dein Wunsch) |
| E-022 | „hoch“ entfällt und wird zu `auto`; bis P1-OPUS-10 gilt `auto` = mittel, danach ist `auto` Standard |
| E-023 | Mip-Formel mit tpp, Start s = 2 (= Ausgang), Boden-Anisotropie, Cap mit der Dichte verschoben |
| E-024 | HD-Figurendetails in `data/figuren_hd` (textPfade bleiben unberührt) |
| E-025 | Grünregel bleibt |
| E-026 | Strom aus: keine neuen Lichtquellen, Laternen dunkel, Silberhau-Lichter erlaubt |
| E-027 | HZ-07 misst Formenvielfalt (≥ 4 Deko-Formen) statt Elementzahl, über alle Innen-Bereiche aus `baueWelt()` |
| E-028 | Sichtprüfer werden zuerst geeicht; an Toren 3 Stimmen |
| E-029 | Z-13 um eine Zeile erweitert und A-605-Berichte (deine Wahl „Mitführen“) |
| E-030 | Eigener Commit-Weg über `hd_commit.sh` |
| E-031 | Kanon-Bildregeln K-013 |
| E-032 | Gangnetz zählt zu den Innen-Bereichen; die Zahl kommt aus `baueWelt()` (Ausgang laut Z-04: 59) |
| E-033 | Feinplan und Schichtplan werden per Skript aus einer Paketliste erzeugt |
| E-034 | Durchstich-Tor vor der Massenproduktion; Planfrist 12 Tage (11 Produktionstage plus T12 als Puffer) |
| E-035 | Migrationsbelege (RGB-identisch nach Palette v2 und Dichte v2) statt eines dauerhaften Kompatibilitätsmodus |
| E-036 | Ausstattung als eigene Liste am Bereich, Feld `vorlage`, nur Wand-, Decken- oder Möbelanker oder flach |
| E-037 | Kerzenleuchter nur im Kamin-Gewölbe nach LA-02 (deine Wahl): Wandhalter, mehrarmig, nicht aufnehmbar, klar anders als die Tatwaffe; Kanon-Gegenprüfer prüft das (P4-AUTOR-50, P4-GEGEN-01) |
| E-038 | Rüstung „Kunibert“ in HD nur mit Kanon-Merkmalen und Kanon-Blick |
| E-039 | A-605-Berichte mit Zusatzzeile „Figurenstand <hash>“. Der Hash wird über die sortierte `git ls-files`-Liste aus `karten.json`, `rollen.json`, `teile_*.json`, `figuren_hd/` und `figur/*.dart` gebildet (10 Zeichen, P0-AUTOR-06). `hd_abnahme` prüft ihn; Z-03 zählt für HZ-13 nur zusammen mit dieser Prüfung. `abnahme.dart` bleibt bis auf die Z-13-Zeile unverändert |
| E-040 | Z-12 bleibt eine Lücke des Nachtlaufs, die nicht von HD kommt; HD verschlechtert sie nicht (textPfade unberührt) |
| E-041 | Uhren ohne Zeiger überall; Uhrturm zeigt die Spielzeit |
| E-042 | „scharf“ nur bei kUi ≥ 2 und ≤ 380.000 Weltpixeln, sonst = „mittel“ |
| E-043 | Ausstattung wird in `burgstadt_spiel` geladen und an `baueWelt()` übergeben; eigener Renderschritt (P4-OPUS-02) |

## Änderungen aus der Gegenprüfung (L0 Runde 1: 59 · Runde 2: 13 · Runde 3: 5 schwere Befunde; Schleife nach 3 Runden abgeschlossen)

| Thema | Änderung |
|---|---|
| Zählungen | Pakete, Texturen (95) und Innen-Bereiche (aus `baueWelt()`, Ausgang 59) aus der Liste bzw. dem Code abgeleitet; Opus mit 29 Paketen und eigener Kapazität |
| Schichtplan | per Skript erzeugt: höchstens 12 + 2 je Schicht; keine Abhängigkeit innerhalb derselben Schicht; Tore jeweils nach den geprüften Paketen; keine Doppelungen |
| Skalierungsformel und Mip-Formel | festgeschrieben; Größen passen zu den Werkzeugen (2401×1081 ergibt 801×361) |
| Palette | Aufrufkonvention, Regex-Audit, `Pal`-Konstanten, `blickFilter`, Wächter und Golden |
| Leistung | Ausgang in der Spielszene statt in der Demo-Szene; gelieferte Bilder/s; RGBA, Himmel, Sprites und Blickfilter einbezogen; Überdeckung gemessen |
| Abnahme | Z-13 und Z-03 nach deiner Entscheidung („Mitführen“); textPfade gesichert |
| Kanon | keine Kerzenleuchter, kein Taler-Sockel, keine neue Rüstung, keine neuen Lichter (Strom aus) |
| **Runde 3** | Zielformulierung „doppelte lineare Auflösung“ statt fester 360 Zeilen, Obergrenze und Schwellen-Testgrößen; Figurenstand-Hash festgelegt (P0-AUTOR-06) und an HZ-13 gekoppelt; Ausstattungs-Lader und -Renderschritt als P4-OPUS-02; Form-Muster schon in P1-OPUS-01; Deko nach ihren Texturen; Sichtprüfer auf die Durchstich-Bilder (P1-SICHT-03); Kerzenleuchter nach deiner Wahl (P4-AUTOR-50); Lichtungen L-01…L-07 benannt |
| **Runde 2** | Skalierung „scharf“ monoton (= UI-Raster von „mittel“); Migrationsbelege statt Kompatibilitätsmodus; Mip s = 2; `Pal` als generierte Literale; `hashTeil` dart2js-sicher; Ausstattungsanbindung mit Feld `vorlage`; Positiv-/Verbotsliste für alle Räume, formbasiert; K9 §8; Uhren ohne Zeiger; Rüstung mit Kanon-Merkmalen; Bauteile und Wandaufbau nach ihren Texturen; Tor-Gegenprüfer P1, P5, P7; 3 Stimmen an allen Toren; Basis der textPfade festgelegt; Z-12 als Nachtlauf-Lücke ausgewiesen; Go/No-Go mit Formel |
| Vollständigkeit | Gangnetz, Anklage, WLAN, Tutorial, Fledermäuse, Gärten, Hof und Wehrgang ergänzt; `bildschirmfoto` und `bereichsfotos` erhalten `--qualitaet` |
| Werkzeuge | Werkzeugkasten (öffentliche Helfer, `hashTeil`); Register nach Name; Ausstattung je Datei; Muster-Dateien |
| Messgrößen und Begriffe | Messbarkeit von HZ-07/08/12/14 geschärft; Begriffe Belegfoto und Gerätefoto getrennt; `schnell` ohne Bindestriche |
| Reihenfolge | L-06 vor P6-OPUS-01; L-07 und E-014 vor den Bauteilen; Go/No-Go vor P2 und P3 |

## Entscheidungen in der Produktion

| ID | Datum | Entscheidung | Anlass |
|---|---|---|---|
| E-044 | T1/S1 | Kanon-Konflikte aus P0-KUND-04 aufgelöst: (1) LED/Kabel/Papierstreifen in K8 M-17…M-19 sind Aufbauhinweise des Live-Krimidinners, nicht Spielbild – im Spiel gilt Strom aus (ANPASSUNG). (2) „Nur Farbe“ gilt für Oberstadt-Straßen, Gangnetz und Wohnhäuser; Fall-Orte sind Hinweisräume mit Positivliste. (3) „Holztruhe nur am Turmfuß“ gilt für NEUE Ausstattung; Bestands-Truhen in den Daten bleiben. (4) Bestandslichter in den Daten (86) sind alle Ausnahmen der Lichtregel; neu kommt keine Lichtquelle dazu. (5) Kamin-Kandelaber ist durch K9:55 gedeckt (stützt E-037). | P0-KUND-04 §7 |
| E-045 | T1/S1 | HZ-07 bleibt ungesenkt. In den Burg-Hinweisräumen, in denen die Positivliste alle Gegenstands-Kategorien verbietet, werden die ≥ 4 Deko-Formen durch reine **Bauzier** erfüllt, die keinem Gegenstand gleicht: Konsolstein, Mauerring (leer), Gewölberippe/Gurtbogen, Schießscharte/Lichtschlitz (dunkel), Wappenstein ohne Schrift. Neues Paket im Vorrat V-07 (Bauzier Burg), Prüfung durch Kanon-Gegenprüfer P4-GEGEN-01. | P0-KUND-04 Konflikt 13 |
| E-046 | T1/S1 | Skalierung „scharf“ hat nach K-011 immer kUi ≥ 2 (UI-Raster von „mittel“, Obergrenze). Die Befunde aus P0-KUND-03 zu kUi = 1 (Blocktest wirkungslos, Touch-Grenze in spiel_test) treffen „scharf“ daher nicht; P1-OPUS-02 prüft das mit einem Test. | P0-KUND-03 Nr. 04, 08 |
