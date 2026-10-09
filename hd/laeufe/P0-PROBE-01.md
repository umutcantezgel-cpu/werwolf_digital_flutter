# P0-PROBE-01 · Ausgang einfrieren (HZ-13)

Probeläufer, Projekt „Burgstadt HD“. Datum 2026-10-09. Läufe zwischen 15:06 und 15:38 UTC.
Auftrag: `scratchpad/briefings/P0-PROBE-01.md`. Regeln: `hd/rollen/KOPF.md`, `hd/rollen/PROBELAEUFER.md`.

## 1. Ausgangsstand

| Größe | Wert | Beleg |
|---|---|---|
| Commit des Ausgangs (`git rev-parse HEAD` beim Start, 15:04 bis 15:06) | `6ca419c57c052712598b4a6de883f1e77c604f79` | `git log` (Commit „Burgstadt HD T1/S2: Layout-Prüfsumme …“) |
| merge-base HEAD ↔ origin/nachtlauf/burgstadt | `c54fe9c2996408c53b03327b8d40962c3b5509f0` | `git merge-base` |
| origin/nachtlauf/burgstadt | vor dem Fetch `c54fe9c`, nach dem Fetch `74a76b0` (siehe Abschnitt 7) | `git fetch origin nachtlauf/burgstadt` |
| merge-base 6ca419c ↔ 74a76b0 | `c54fe9c2996408c53b03327b8d40962c3b5509f0` (unverändert) | `git merge-base` |

## 2. Gültigkeit: Repo-Stand war während der Läufe nicht eingefroren

Im Repo landeten während des Gesamtlaufs fremde Commits auf demselben Branch (Reflog des Repos):

- `0ac2248` um 15:08:36 (Kontaktbogen-Werkzeug, P0-AUTOR-02)
- `a389b3d` um 15:09:32 (Abschluss T1/S1, P0-KUND-05 und P0-KUND-06)

Außerdem lagen im Arbeitsbaum gestagte und ungetrackte Dateien anderer Agenten (`packages/burgstadt_spiel/bin/eichbilder.dart`, `packages/burgstadt_spiel/bin/szenen_mess.dart`, `hd/bilder/proben/P0-AUTOR-04_markt_640.png`; gestaged `banding.dart`, `flimmer.dart`; modifiziert `tool/hd_commit.sh`).

Deshalb gelten die Ausgangswerte nur aus einer sauberen, lokalen Kopie des Commits `6ca419c` (Pfad `scratchpad/probe01/ausgang`, Arbeitsbaum leer). Die Läufe im Repo sind unten als solche gekennzeichnet.

Einrichtung der Kopie vor den gemessenen Läufen (nicht versioniert, nicht in der Zeit enthalten): `flutter pub get` im Wurzelpaket, `dart pub get` in `packages/mordakte_core`, `tool/ton` und `server`. Im Repo liegen diese Caches bereits vor. Ohne sie scheiterte der erste Kopie-Versuch wörtlich mit `704 issues found.` (Ebene 11, mordakte_core) und danach mit 46 Befunden `uri_does_not_exist` in `tool/ton/test/ton_test.dart`.

## 3. Läufe

Befehle: `bash tool/alle_tests.sh` (voll), `bash tool/alle_tests.sh schnell`, `dart run tool/abnahme.dart`. Zeitmessung mit `date +%s` vor und nach dem Lauf, Zeitstempel je Ausgabezeile in `scratchpad/laeufe/*_stempel.txt`.

| Lauf | Dauer (s) | Ergebnis | Schlusszeile |
|---|---|---|---|
| voll, Repo (Start auf 6ca419c, Stand während des Laufs geändert) | 587 | Exit 0 | `ALLE TESTS GRÜN` |
| voll, Ausgang-Kopie 6ca419c (sauber) | 671 (wie Abnahme, siehe unten) | Exit 0 (intern) | `ALLE TESTS GRÜN` |
| schnell, Repo (HEAD a389b3d) | 37 | Exit 1, gescheitert in burgstadt_spiel analyze | `1 issue found.` |
| schnell, Ausgang-Kopie 6ca419c (sauber) | 224 | Exit 0 | `ALLE TESTS GRÜN` |
| abnahme, Ausgang-Kopie 6ca419c (sauber) | 671 | Exit 1 (Ziel nicht erreicht) | `ZIEL NICHT ERREICHT · offen: Z-12` |

Der interne voll-Lauf der Abnahme ist nicht separat gemessen. Die 671 s sind die Gesamtzeit von `dart run tool/abnahme.dart`, die den vollständigen `alle_tests.sh`-Lauf einschließt.

Repo-schnell (Dateien: `scratchpad/laeufe/schnell_ausgang2.txt`), letzte Zeilen wörtlich:

```
== Paket burgstadt_spiel: analyze + test
1 issue found.
```

Der Befund, wörtlich aus `dart analyze --fatal-infos` im Repo (nur lesend ausgeführt): `info - bin/eichbilder.dart:36:91 - Unnecessary braces in a string interpolation. Try removing the braces. - unnecessary_brace_in_string_interps`. Die Datei ist ungetrackt und stammt nicht vom Ausgang (siehe Abschnitt 2). Im Ausgang-Lauf ist dieselbe Stufe grün (`No issues found!`).

## 4. Ergebniszeilen alle_tests voll (Ausgang-Kopie 6ca419c, sauber)

Quelle: `scratchpad/laeufe/voll_ausgang_sauber.txt` (Protokoll der Kopie). Gefiltert nach Ergebniszeilen, wörtlich.

**Ebene 11 · Bestand: mordakte_core**
```
No issues found!
00:12 +170 ~1: All tests passed!
  OK – 11 Hinweise, 3 Verdächtige, 12 Fall-Varianten
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
  OK – 20 Hinweise, 5 Verdächtige, 24 Fall-Varianten
```

**Paket pixel_engine:** `No issues found!` · `00:11 +275: All tests passed!`
**Paket burgstadt_core:** `No issues found!` · `00:09 +261: All tests passed!`
**Paket burgstadt_spiel:** `No issues found!` · `00:23 +47: All tests passed!`
**Paket room_host:** `No issues found!` · `00:00 +5: All tests passed!`

**Ebene 10 · Leitplanken:** `Summe: 0 Treffer · 0 Fehler · 0 Warnungen`

**Ebene 1/10 · Kanon-Abgleich + Leitplanken:** `== absicherung: 0 Befunde` · `== zeit: 0 Befunde` · `== d: 0 Befunde` · `== e: 0 Befunde` · `== SUMME: 0 Befunde · 1276 Datensätze`

**Burgstadt HD · Layout-Prüfsumme:** `LAYOUT 35a1b855fb2fd753 · Bereiche 62 · Kacheln 103856 · Dinge 1885 · Zufallsaufrufe 9849` · `LAYOUT GLEICH`

**Ebene 6 · Welt:** `Türen 134/134 erreicht` · `Nicht erreicht: 0` · `Steckenbleiber: 0`

**Ebene 8 · Mehrspieler:**
```
Teilnehmer 4 · Rollen 4 (Bots 1) · Ende EM-2 · geteilt an Einzelne 18, an die Akte 12 · Latenz max 36 ms, Mittel 20 ms · Abweichungen 0 · 21.717 s
Teilnehmer 8 · Rollen 8 (Bots 1) · Ende EM-2 · geteilt an Einzelne 44, an die Akte 36 · Latenz max 36 ms, Mittel 19 ms · Abweichungen 0 · 21.708 s
Teilnehmer 20 · Rollen 20 (Bots 1) · Ende EM-2 · geteilt an Einzelne 99, an die Akte 103 · Latenz max 47 ms, Mittel 26 ms · Abweichungen 0 · 21.841 s
MP-SIM OK
```

**Ebene 3/4 · Durchspiel:** `Teilen-Nutzen: 83 % weniger Schritte bis zur Lösung (ohne Teilen 0 von 9 Läufen gar nicht gelöst; ungelöst zählt doppelt)` · `DURCHSPIEL OK`
**Ebene 2 · Fairness:** `FAIRNESS OK`

**Ebene 5 · Pixel: alle Bildschirme:**
```
hauptmenue: Welt 320x180 ×4 · UI 640x360 ×2 · Palette OK · Block 230400/230400 Blöcke einfarbig (100.00 %)
optionen: Welt 320x180 ×4 · UI 640x360 ×2 · Palette OK · Block 230400/230400 Blöcke einfarbig (100.00 %)
erkundung: Welt 320x180 ×4 · UI 640x360 ×2 · Palette OK · Block 230400/230400 Blöcke einfarbig (100.00 %)
hauptmenue: Welt 401x181 ×6 · UI 801x361 ×3 · Palette OK · Block 288000/288000 Blöcke einfarbig (100.00 %)
optionen: Welt 401x181 ×6 · UI 801x361 ×3 · Palette OK · Block 288000/288000 Blöcke einfarbig (100.00 %)
erkundung: Welt 401x181 ×6 · UI 801x361 ×3 · Palette OK · Block 288000/288000 Blöcke einfarbig (100.00 %)
```

**Ebene 3/5 · Spieltest:** `Ende: EM-1 · angeklagt R03 · Punkte 9 · Fallakte 46 · Detektiv weiß 15 · Gespräche 48` · `SPIELTEST OK` (zweimal)
**Ebene 5 · Pixel (Z-02): Belegfotos:** `BELEGFOTOS OK (26 Bilder)` (zweimal)

**Ebene 5 · Oberstadt-Ansichten:**
```
burgtor_hauptgasse: 9.29 ms · Meshes 109/374 · Dreiecke 6324/10906 · Sprites 3 · Pixel 100646 · Palette OK · Block 100.0 %
marktplatz: 5.55 ms · Meshes 118/374 · Dreiecke 6136/12226 · Sprites 1 · Pixel 66293 · Palette OK · Block 100.0 %
kirchhuegel: 6.30 ms · Meshes 95/374 · Dreiecke 4673/9524 · Sprites 2 · Pixel 104925 · Palette OK · Block 100.0 %
gasse_ost: 4.29 ms · Meshes 60/374 · Dreiecke 3479/6760 · Sprites 0 · Pixel 90135 · Palette OK · Block 100.0 %
untere_stadt: 5.43 ms · Meshes 35/374 · Dreiecke 1870/3630 · Sprites 0 · Pixel 114781 · Palette OK · Block 100.0 %
```

**Kanon-Werkzeug (Original):** `== SUMME: 0 Befunde · 1211 Datensätze`
**Flutter analyze (App):** `No issues found! (ran in 3.6s)`
**Ebene 11 · Server-Smoke:** `63 OK, 0 FAIL`

**Ebene 9 · Geräte:**
```
✓ Built build/web
desktop · 1280x720 @1 · Drosselung 1× · Bildrate Start 17.6 / Spiel 17.3 · Konsole 0 · fremde Abrufe 0 · Gamepad wirkt
  BSMESS Welt 320x180 ×4 · UI 640x360 ×2 · Spiel 28.31 ms · RGBA+Übergabe 1.35 ms · Weg asynchron · verworfen 6
handy-quer · 800x360 @3 · Drosselung 1× · Bildrate Start 6.2 / Spiel 5.7 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 400x180 ×6 · UI 800x360 ×3 · Spiel 42.71 ms · RGBA+Übergabe 2.69 ms · Weg asynchron · verworfen 1
handy-hoch · 360x800 @3 · Drosselung 1× · Bildrate Start 5.2 / Spiel 10.2 · Konsole 0 · fremde Abrufe 0
  BSMESS Welt 180x400 ×6 · UI 360x800 ×3 · Spiel 46.35 ms · RGBA+Übergabe 2.42 ms · Weg asynchron · verworfen 5
```

**Ebene 7 · Leistung (Z-09):**
```
Spiellogik je Bild (20 Rollen, 44 Bewohner, 1800 Bilder): Mittel 0.044 ms, 99 % 0.245 ms · × 4 = 0.18 ms · Grenze 4 ms · OK
Speicher: 20 Spielminuten Erkundung (62 Bereiche, gezeichnet): nach Minute 1 76 MB, höchstens 79 MB · Wachstum 4.6 % · Grenze 10 % · OK
Nachladespitzen: Figuren backen je Bild höchstens 5.4 ms Prozessorzeit, Bereichswechsel höchstens 0.0 ms · × 4 = 21.5 ms · Grenze 50 ms · OK
Budget je Ansicht: höchstens 117 Meshes (≤ 300), 9658 Dreiecke (≤ 14 000) · OK
LEISTUNG OK
```

**Ebene 11 · Mordakte simulate:** vier Zeilen `Σ Urteile {perfect: 1} · Teams {all: 1} …` (Ø Min 15.0 / 15.1 / 15.1 / 15.1).

**Schlusszeile:** `ALLE TESTS GRÜN`

Bildpfade: Playwright-Fotos liegen in temporären Ordnern des Testlaufs (Ausgang-Kopie: `/tmp/tmp.6UHQWiV0lr/*.png`, sechs Dateien; Repo-Lauf: `/tmp/tmp.TWcKRRQuxL/*.png`). Es wurden keine Belegbilder nach `hd/bilder/` kopiert.

### Dauer je Ebene (Repo-Lauf, Zeitstempel, auf 1 s gerundet)

Quelle: `scratchpad/laeufe/voll_stempel.txt`. Der Repo-Lauf stand nicht auf einem eingefrorenen Commit (Abschnitt 2), die Zeiten sind deshalb nur Richtwerte.

| Ebene / Paket | s | Ebene / Paket | s |
|---|---|---|---|
| Ebene 11 · mordakte_core | 15 | Ebene 3/5 · Spieltest | 33 |
| Paket pixel_engine | 12 | Ebene 5 · Belegfotos (Z-02) | 36 |
| Paket burgstadt_core | 9 | Ebene 5 · Oberstadt | 4 |
| Paket burgstadt_spiel | 19 | Kanon-Werkzeug (Original) | 0 |
| Paket room_host | 2 | Flutter analyze (App) | 4 |
| Ebene 10 · Leitplanken | 3 | Ebene 11 · Server-Smoke | 16 |
| Ebene 1/10 · Kanon | 1 | Ebene 9 · Geräte (Web-Build, Playwright) | 179 |
| Layout-Prüfsumme | 2 | Ebene 7 · Leistung (Z-09) | 172 |
| Ebene 6 · Welt | 1 | Ebene 11 · Mordakte simulate | 3 |
| Ebene 8 · Mehrspieler | 67 | Ebene 3/4 · Durchspiel | 2 |
| Ebene 2 · Fairness | 2 | Ebene 5 · Pixel alle Bildschirme | 5 |

Summe 587 s, Start 15:06:07, Ende 15:15:54.

## 5. Abnahme (Ausgang-Kopie 6ca419c, sauber)

Befehl: `dart run tool/abnahme.dart` in der Kopie (ohne `--log`, daher interner voll-Lauf). Quelle: `scratchpad/laeufe/abnahme_ausgang.txt`. Start 15:26:43, Ende 15:37:54, 671 s.

```
Abnahme · Stand 6ca419c57c05 · 2026-10-09T15:37
Gesamtlauf aller Ebenen: ALLE TESTS GRÜN
Z-01 · erfüllt · Gesamtlauf grün; Bestand: Core-Tests, validate, Server-Smoke, simulate gelaufen; Ausgangswerte phase0_ausgangstests.txt
Z-02 · erfüllt · Belegfotos (6 Viertel, 10 Innenräume, alle Menüs; Palette + Blocktest): 2 Formate OK (26 + 26 Bilder); Browser-Fotos pixel_pruef im Gesamtlauf; gleiche Pixeldichte: karten_test
Z-03 · erfüllt · 20 Rollen, 44 Stadtbewohner (Grenze 20 / 40); Sprite-Prüfung und Porträts (4 Ausdrücke) in den Tests; Sichtprüfer ohne Paare und Verstöße am Kartenstand b60891cc2b: 2 (Grenze 2) – sichtpruefer_23_bericht.md, sichtpruefer_24_bericht.md
Z-04 · erfüllt · 6 Viertel, 160 Gebäude (≥ 150), 59 betretbare Innenräume (≥ 40), 12 Fall-Orte (12), Keller/Gänge 1, Wehrgang ja; Erkundungsbots: Türen 134/134, nicht erreicht 0, Steckenbleiber 0
Z-05 · erfüllt · Detektivblick: 7 Spurenarten (≥ 7: fussspur, wachs, faser, staub, fingerabdruck, schleifspur, verwischt); 20 von 20 Rollen mit eigener Sichtschicht/Fähigkeit; Sichtregeln je Rolle: faehigkeiten_test, burgstadt_raum_test
Z-06 · erfüllt · Teilen an Einzelne und an die Akte im Mehrspielertest; Latenz max 36 / 36 / 47 ms (Grenze 1000); Teilen-Nutzen 83 % weniger Schritte (Grenze 30)
Z-07 · erfüllt · Löser: FAIRNESS OK für N = 4…20; Durchspiel OK (Endmatrix, Punkte); Spieltest über die echten Bildschirme bis zum Ende: 2× OK
Z-08 · erfüllt · Solo mit Bots: Spieltest OK; Mehrspieler: 4 Teilnehmer (Bots 1, Abweichungen 0), 8 Teilnehmer (Bots 1, Abweichungen 0), 20 Teilnehmer (Bots 1, Abweichungen 0); MP-SIM OK
Z-09 · erfüllt · AOT, Faktor 4 (Näherung): Spiellogik 0.18 ms (≤ 4), Nachladespitze 21.5 ms (≤ 50), Speicherwachstum 4.6 % (≤ 10), Budget je Ansicht im Rahmen; LEISTUNG OK
Z-10 · erfüllt · Playwright-Durchläufe: desktop, handy-quer, handy-hoch (3 Profile); Touch-Wischen, Tastatur + Maus, Gamepad-Simulation (wirkt); Fotos bestehen pixel_pruef
Z-11 · erfüllt · Konsolenfehler/-warnungen in allen Durchläufen: 0; Speichern und Fortsetzen: spielstand_test
Z-12 · OFFEN   · Leitplanken-Scanner: 0 Treffer; Gegenprüfer-Bericht mit „Leitplanken ja · Kanontreu ja · Plagiatsfrei ja“, jünger als die letzte Textänderung: keiner
Z-13 · erfüllt · Remotes: origin; Pushes seit Beginn nur auf nachtlauf/burgstadt, main, claude/nifty-gauss-s82y27 (N-00, N-01) und claude/pensive-gates-ajtp7x (N-HD-01); fremde Abrufe im Browser: 0 (Web-Build ohne CDN)
Z-14 · erfüllt · Dokumente: alle vorhanden; Abschlussbericht mit Bildschirmfotos und Figuren-Aufstellung: ja
ZIEL NICHT ERREICHT · offen: Z-12
```

**Summe: 13 von 14 erfüllt** (Z-01 bis Z-11, Z-13, Z-14). Offen: Z-12.

Das versionierte Nachtlauf-Protokoll `nachtlauf/belege/abnahme.txt` (Stand `5b3cbb975400`, 2026-10-09T13:53, Abruf über `git show 6ca419c…:nachtlauf/belege/abnahme.txt`) zeigt dasselbe Muster: 13 erfüllt, Z-12 offen.

## 6. Bereiche (Ausgang-Kopie 6ca419c)

- Bereiche gesamt: **62**
- `innen == true`: **59**
- außen (`innen == false`): **3**: `hof`, `stadt`, `wehrgang`
- Je id-Präfix (Text vor dem ersten `-`): `haus` 41, `innen` 12, ohne Präfix 9 (`absatz`, `gaenge`, `gewoelbe`, `hof`, `hofebene`, `speisekammer`, `stadt`, `turmfuss`, `wehrgang`). Summe 62.

Methode: `scratchpad/probe01/zaehle.dart`, baut die Welt wie `packages/burgstadt_core/bin/erkundung.dart:26` (`baueWelt(innen, haeuser: haeuser)`). Die Paketauflösung aus dem Scratch-Ordner schlug fehl. Deshalb lag die Datei nur in der Wegwerf-Kopie unter `packages/burgstadt_core/bin/_zaehle_tmp.dart`, wurde ausgeführt und sofort gelöscht. Das Repo wurde dafür nicht verändert. Bestätigung der Zahl: Ergebniszeile `LAYOUT … · Bereiche 62 …` (Abschnitt 4).

Das Zählen im Repo selbst (Auftragsschritt 5 mit Pfad im Repo) wurde nicht ausgeführt, weil das Repo-Werkzeug nur einen veränderlichen Stand liefern würde. Die Daten `packages/burgstadt_core/data` und `packages/burgstadt_core/lib` sind zwischen `6ca419c` und dem HEAD bei der letzten Prüfung (`920a863`) unverändert (`git diff --stat` leer). Der Branch wird von anderen Agenten weiter committet; `920a863` ist deshalb nur der Stand dieser Prüfung.

## 7. Abweichungen von der Erwartung

1. **Abnahme 13/14 statt der erwarteten 12/14.** Die Ausgangsmessung und das versionierte Nachtlauf-Protokoll sind sich einig (13 erfüllt, Z-12 offen). Welche Erwartung „12 von 14“ gemeint war, ist nicht belegt (siehe OFFENE FRAGEN).
2. **Repo-voll nicht auf einem eingefrorenen Commit.** Commits `0ac2248` (15:08:36) und `a389b3d` (15:09:32) landeten während des Laufs. Die gültige Ausgangsmessung ist die Kopie (Abschnitt 4 und 5).
3. **Repo-schnell rot (Exit 1).** Ursache: `packages/burgstadt_spiel/bin/eichbilder.dart:36:91`, ungetrackt, nicht Teil des Ausgangs. Die Datei wurde nicht angefasst.
4. **Abnahme nicht im Repo ausgeführt.** `tool/abnahme.dart` schreibt jeden Lauf nach `nachtlauf/belege/abnahme.txt` (`tool/abnahme.dart:255`) und ohne gültiges `--log` zusätzlich nach `nachtlauf/belege/alle_tests_voll.txt` (`tool/abnahme.dart:60`). Beide Dateien sind versioniert, und `hd/rollen/KOPF.md:12` verbietet Änderungen an `nachtlauf/`. Deshalb lief das Werkzeug in der Kopie.
5. **Git-Ref geändert.** `git fetch origin nachtlauf/burgstadt` setzte den Remote-Tracking-Ref `origin/nachtlauf/burgstadt` von `c54fe9c` auf `74a76b0`. Es wurde keine Arbeitsbaum-Datei geändert. Die merge-base bleibt `c54fe9c`.
6. **Build-Artefakte im Repo.** Die Repo-Läufe haben `build/web` erzeugt (`scratchpad/laeufe/voll_ausgang.txt`, Zeile „✓ Built build/web“). Das Verzeichnis ist laut `.gitignore:33` (`/build/`) nicht versioniert.
7. **Nicht versionierte Caches in der Kopie** (Abschnitt 2) wurden vor den gemessenen Läufen nachgezogen.

## 8. Befehle und Dateien

- Hilfsskript: `scratchpad/probe01/lauf.sh` (Zeitmessung, Zeitstempel je Zeile).
- Protokolle: `scratchpad/laeufe/voll_ausgang.txt` (Repo), `voll_ausgang_sauber.txt` (Kopie), `schnell_ausgang2.txt` (Repo, rot), `ausgang_schnell_ausgang.txt` (Kopie, grün), `abnahme_ausgang.txt` (Kopie).
- Repo-Dateien: nur diese Ausgabedatei neu angelegt. `git status nachtlauf` leer.

## 9. OFFENE FRAGEN

1. Woher stammt die Erwartung „12 von 14“? Die versionierte Nachtlauf-Abnahme und die Messung im Ausgang zeigen 13 von 14 mit Z-12 offen. Ob die Erwartung sich auf einen anderen Stand bezieht, ist nicht belegt.
2. Welcher Commit gilt als eingefrorener Ausgang? Das Protokoll nimmt `6ca419c`, der Branch ist seither weitergelaufen (`a389b3d`). Die Entscheidung liegt beim Orchestrator.
3. Der neue Stand `origin/nachtlauf/burgstadt` (`74a76b0`) wurde nicht inhaltlich geprüft.

ENDE PAKET P0-PROBE-01
