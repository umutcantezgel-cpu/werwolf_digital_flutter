HEAD e95840f

# Gegenprüfung Inhalt A-702q, Punkt 16 (Schwerpunkt Kanon-Änderung)

- Prüfer: gegenpruefer_inhalt_20 · Worktree: /home/user/werwolf_digital_flutter/.claude/worktrees/wf_4a04ea1a-b87-2
- Stand: e95840f (Schritt 0: `git merge --ff-only nachtlauf/burgstadt`, d92a675..e95840f, Fast-Forward)
- Kanon-Vergleich: 659d3ed..HEAD, K1 bis K9 (158 geänderte, 4 neue, 1049 unveränderte Datensätze)

## 1. Vorgehen und Umfang

- Vollständig gelesen: Auftrag A-702q; `nachtlauf/kanon/ANPASSUNG.md` (175 Zeilen); `10_kanon/FORMAT.md`, `10_kanon/VERSION.md`; `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`; `nachtlauf/ENTSCHEIDUNGSLOG.md` E23 bis E44 (Zeilen 147 bis 470); Scanner-Quelle `packages/burgstadt_core/lib/src/pruef/leitplanken.dart`.
- Kanon-Änderung: Feldvergleich je Datensatz aller K-Dateien (Hilfsskript im Scratch-Ordner), dazu alle Zeilen ohne Kennung. Geändert: 29 O-, 75 G-, 54 L-Datensätze; neu: 4 L-Datensätze. Jede O-Änderung gegen ANPASSUNG, Stadtdaten und Figuren geprüft; G- und L-Änderungen auf Zeitketten, Orte und Gegenstände geprüft.
- Spieltexte: `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json` vollständig; `packages/pixel_engine/data/figuren/rollen.json` (R02, R03, R04, R14 vollständig), `karten.json` (R03, R04), `teile_kleidung.json` (Kennungen); `packages/burgstadt_core/data/rollen/faehigkeiten.json` (R01, R02, R03, R04, R06, R11, R14, R19 auf Zeit-, Kleidungs- und Ortsangaben); `stadt/bewohner.json` (44 Datensätze, 140 Nachtplan-Einträge), `stadt/haeuser.json` und `innenraeume/*.json` (Suche und Stichprobe).
- Leitplanken-Scanner: `dart` ist im Container nicht installiert, der Originalbefehl konnte daher nicht laufen. Ersatz: Nachbau der Regeln aus `leitplanken.dart` in Python (Verbotsregeln, Ausnahmen, Unicode-Escapes, Dart-Maskierung), gleicher Umfang wie `spieltextBestand` mit `--burgstadt` (119 Dateien). Validierung mit einem Testtext: alle Regeln, Ausnahmen, Escapes, Dart-Strings und Kommentare verhalten sich wie im Original. Ergebnis: 12 Rohtreffer (7 Fehler, 5 Warnungen), alle 12 durch `LEITPLANKEN-AUSNAHMEN.md` gedeckt; nach Ausnahmen 0 Treffer.
- Nicht ausgeführt: kein Build, kein Commit, kein Push, keine Datenänderung. Frühere Berichte in `nachtlauf/auftraege/A-702/` nicht gelesen. Hilfsdateien nur im Scratch-Ordner des Prüfers.

## 2. Befunde

### 1 · hoch · Herkunftsmatrix in der Kanon-Quelle (Leitplanke Herkunft)

- Datei und Stelle: `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 80, `@FM-1 [L]`, neu in v1.0.
- Zitat: „Funktionsmatrix Herkunft: deutsch – Täterin (R03) und Hauptverdächtiger mit echtem Vergehen (R04); bosnisch – Hauptverdächtiger ohne Vergehen (R01); kurdisch – Hauptzeugin (R02); polnisch und türkisch – keine belastete Funktion …“ Begründung: „… Herkunft ist nie Motiv, Indiz oder Pointe.“
- Regel: Leitplanke „Herkunft ist nie Motiv, Indiz oder Pointe“ und „keine Klischees … über irgendeine andere Gruppe“ (A-702q, Punkt 4). Die Overlay-Begründung in `nachtlauf/kanon/ANPASSUNG.md` Zeile 98 nennt zusätzlich „Ordnungsmerkmal der Lösung“ als Ausschlussgrund.
- Bewertung: Die Zeile ordnet Tatfunktionen nach Herkunftsgruppen; ihre eigene Begründung widerspricht dem Inhalt (R02 ist Hauptzeugin und lügt über den Streich, vgl. E43). Im wirksamen Spielbestand ist das Feld entfernt: `ANPASSUNG.md` Zeile 98 (`Löschen: Funktionsmatrix Herkunft`), umgesetzt in `packages/burgstadt_core/lib/src/kanon/kanon.dart` (Löschen ab Zeile 130), geladen über `packages/burgstadt_core/lib/src/io/repo.dart` Zeile 35. Die Quelldatei bleibt unverändert, und E41 (Zeile 400) erklärt die Kanon-Dateien ausdrücklich zum Spieltext (Z-12).
- Entscheidungslog: E42 (Zeile 420) und E43 (Zeile 439) halten die Zeile, weil sie „im Spiel nirgends sichtbar“ sei. Neuer Grund gegen diese Abwägung: Die Quelle ist nach E41 Spieltext, die fehlende Sichtbarkeit im Spiel entlastet sie also nicht. Außerdem verknüpft die Quelle die Herkunft „bosnisch“ mit der falschen Fährte über die Lampe „HODŽIĆ VT · 3“ (K1 Zeile 28, DW1-1 in K5, GL-19). Die Lampenmarke ist damit Teil einer Herkunftszuordnung und nicht nur ein Eigentumsmerkmal.
- Vorschlag: In Kanon v1.1 (Kanon-Verantwortung, mit Protokoll) die Zeile streichen oder die Matrix ohne Herkunft nach Rollen-IDs fassen, wie der Overlay es bereits tut. Die Lampenkennung neutral gestalten (Vorschlag aus E44). Bis dahin bleibt der Befund offen; das Spiel selbst ist durch den Overlay bereinigt.

### 2 · mittel · Ort „Wäschekorb neben der Toilette“ fehlt in den geschlossenen Listen (neu in v1.0)

- Stellen: `K1-GRUNDWAHRHEIT.md` Zeile 93 (`@Z-2140 [L]`, „Ort: Hofebene (Wäschekorb neben der Toilette)“); Zeile 184 (`@BS-02 [L]`, „… das Laken stammt aus dem Wäschekorb neben der Toilette, Z-2140“); `K2-ROLLEN-KERN.md` Zeile 19 (`@R02-WISSEN [G]`, „21:40 … aus dem Wäschekorb neben der Toilette …“).
- Regel: FORMAT (K1): Zeitleisten-Orte müssen aus LISTE-ORTE stammen; „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen.“ LISTE-ORTE (`K1` Zeile 27, `ANPASSUNG.md` Zeile 69) führt „Hofebene (Hoftür, Schauvitrine, Toilette)“, nicht den Wäschekorb. Das Laken selbst steht korrekt in LISTE-GEGENSTÄNDE (`K1` Zeile 28), der Ort nicht.
- Spielbestand: Kein Wäschekorb-Objekt gefunden (Suche in `packages/burgstadt_core/data`, `packages/burgstadt_spiel/data`, `packages/pixel_engine/data/figuren`, `packages/burgstadt_spiel/lib`, `lib/burgstadt`). Die Herkunft des Gespensterlakens ist damit im Spiel nicht verortet, und die R02-Erinnerung nennt einen Ort, den die Liste nicht kennt.
- Vorschlag: In `ANPASSUNG.md` unter LISTE-ORTE („Hofebene“) „Wäschekorb neben der Toilette“ aufnehmen (als Lösungsort), oder die Kanon-Autoren bitten, die Liste in v1.1 zu ergänzen; Z-2140 am Listenwort ausrichten.

### 3 · mittel · Ort „Freibad“ außerhalb der Liste (Altbestand, in v1.0 erweitert)

- Stellen, neu in v1.0: `K2-ROLLEN-KERN.md` Zeile 40 (`@R04-LÜGE [G]`, „Kamils Beobachtung aus dem Freibad“; Protokoll P-44, `PROTOKOLL.md` Zeile 61); `K7-LUEGENREGEL.md` Zeile 11 (`@LR-7 [L]`, „Kamils Freibad-Beobachtung“).
- Stellen, Altbestand (unverändert seit 659d3ed): `K3-HINWEISE-P1.md` Zeile 86 (`@H-159 [G]`, „Selin sah Jonas … im Freibad statt bei der Arbeit“); `K3-HINWEISE-P2.md` Zeile 78 (`@H-255 [G]`); `K3-HINWEISE-P3.md` Zeile 78 (`@H-355 [G]`); `K2-ROLLEN-13-20.md` Zeilen 10 und 11 (`@R13-WISSEN`, `@R13-VERBINDUNGEN`); `K4-GESPRAECHE-P2.md` Zeile 42 (`@G2-42`, Antwort); `K4-GESPRAECHE-P3.md` Zeile 39 (`@G3-42`, Antwort); `K5-ENTSCHEIDUNGEN-P2.md` Zeile 25 (`@E2-14`); `K5-ENTSCHEIDUNGEN-P3.md` Zeile 25 (`@E3-14`).
- Regel: LISTE-ORTE ist geschlossen. „Freibad“ ist ein Ort und dient als Lösungshinweis (Jonas’ Lüge über seine Arbeit). Das FORMAT erlaubt G-Wissen Uhrzeiten außerhalb LISTE-ZEITEN, für Orte gibt es keine vergleichbare Ausnahme.
- Spielbestand: Der Ort kommt in keiner Liste und in keinem Stadtdatensatz vor. Die Antworten aus K4 (G2-42, G3-42) werden über den Kanon-Parser ausgegeben, sind also im Spiel sichtbar. P-44 führt die Formulierung als Gegenbeweis auf, die Listenfrage ist dort nicht behandelt.
- Einordnung: Die Zeitangabe „Dienstagvormittag im September“ liegt in derselben Klasse; sie gehört in die Abstimmung mit den Kanon-Autoren.
- Vorschlag: „Freibad (außerhalb der Burgstadt; nur Lösung)“ in `ANPASSUNG.md` unter LISTE-ORTE aufnehmen, wie „Silberhau“ (E42). Alternativ die Ortsangabe in den Gesprächen verallgemeinern.

### 4 · gering · Overlay ersetzt die öffentliche Zeit 00:01 durch „kurz nach Mitternacht“ (E44)

- Stellen: `K1-GRUNDWAHRHEIT.md` Zeile 52 (`@OA-20 [O]`, „Zeit: 00:01 … Nach einer halben Minute kommt er zu sich“); Zeile 29 (`@LISTE-ZEITEN [O]`, „00:01 der Burgwart wird … gefunden“); `ANPASSUNG.md` Zeile 70 („kurz nach Mitternacht wird der Burgwart … gefunden“).
- Regel: `VERSION.md` Zeile 12: „bestehende Tatsachen ändern sich nur über ÄNDERUNG und Protokoll.“
- Bewertung: E44 (Zeile 460) begründet die Änderung mit „OA-20 sagt etwa 00:01:30“. Genauer: OA-20 nennt 00:01, danach kommt er „nach einer halben Minute“ zu sich; PF-3 [L] nennt 00:00:50. Die Entscheidung bleibt vertretbar, weil „kurz nach Mitternacht“ beide Angaben deckt. Der Befund betrifft das Verfahren: Eine öffentliche Zeit ist eine Tatsache und gehört in ÄNDERUNG und Protokoll der Kanon-Autoren, nicht in den Overlay.
- Vorschlag: Die Kanon-Autoren legen die öffentliche Zeit in v1.1 mit Protokoll fest. Bis dahin die Overlay-Formulierung beibehalten.

### 5 · gering · R04 im Bild: der olivgrüne Strickpullover ist nicht als Strick erkennbar

- Daten: `packages/pixel_engine/data/figuren/rollen.json` (R04: Oberteil `pullover`, Rampe 5, Stufe 4; darunter `hemd`; Schuhe `wanderstiefel`; Zubehör `uhr`) und `karten.json` (R04-Teile: `oberteil-hemdkragen`, `schuhe-stiefel`, `schuhe-arbeitsschuhe`, `frisur-kurz`) entsprechen dem Kanon v1.0 (K2 R04-STAMM, K9 LF-R04). Kein Befund in den Daten.
- Umsetzung: `packages/burgstadt_spiel/lib/src/figuren_lager.dart` Zeilen 68 bis 69 ordnet „pullover über hemd“ nur dem Teil `oberteil-hemdkragen` zu (`packages/pixel_engine/lib/src/figur/teile_basis.dart` Zeile 51: Körper nur am Halsausschnitt, Material „darunter“). Der Torso ist der Basiskörper mit Material „oberteil“ (`packages/pixel_engine/lib/src/figur/figur.dart` Zeile 166): olivfarben, ohne Strickstruktur und ohne Rollkragen; das karierte Hemd ist nur am Kragen zu sehen.
- Vorhanden: Das Teil `oberteil-strickpulli-rolli` (`packages/pixel_engine/data/figuren/teile_kleidung.json`) wird für Bewohner mit „Pullover“ genutzt (`packages/pixel_engine/lib/src/figur/bewohner_karten.dart` Zeile 251).
- Vorschlag: Für R04 ein Strickpullover-Teil verwenden (Form und Rollkragen prüfen), oder in der nächsten Sichtprüfung ausdrücklich bestätigen lassen, dass der Olivtorso mit Hemdkragen dem Kanon genügt.

## 3. Geprüft ohne Befund (Auszug)

- Zeitkette des Gewölbes (v1.0) ist in allen Schichten konsistent: 23:52 Adnan reißt die Turmtür auf, Merle geht zum Klo, Jonas nach oben (LISTE-ZEITEN, R01, R03, R19, H-107, H-176, E1-19, E2-19); 23:53 Jonas auf der Treppe (R04, Z-2353b, HW-26); 23:54 Jonas und Merle auf dem Wehrgang (R03, R04, R11); 23:56:40 bis 23:58:10 Telefonat (R04, E3-01); 23:57 Track, 23:58 Hebel und Knall, 23:58:22 Schlag (R02, Z-2358a, BS-01, HW-143); 23:59:40 Merle am Kamin von der Turmtür-Seite (R01, R06, H-110); 00:00 Schrei; 00:03 „Mein Bund!“ (R11, BW-AUSSAGE-0); 00:07 Tor zu, Raureif mit Spuren des Burgwarts (D2-2, R04, PF-7, H-02).
- Nachtpläne (`bewohner.json`): 44 Bewohner, 140 Einträge, Beginn 00:30 (E42), Ende 05:30. Kein Eintrag mit Ort „Burg“; keine Bewegung zur Burg nach 23:00 (K-010).
- Overlay: alle 22 ERSETZE-Zeilen auf alle K-Dateien angewandt. Danach keine Reste von Harz, Brocken, Osterode, Silberhauer, Nationalpark oder „bewusstlos“ in O-, G- oder L-Zeilen. Punsch ist im Kanon alkoholfrei gesetzt (K8 GL-14 „alkoholfreier Apfel-Zimt-Punsch“; ERSETZE-19 bis 21 für OA-23, BW-ZUSTAND, K8); der Scanner findet keinen Alkoholbegriff.
- Stadt und Overlay: Pension (`haeuser.json` Zeile 364, „blauer Stempel mit ihrem Namen“) entspricht HW-S05, ORT-03 und E42. Schreinerei (`haeuser.json` Zeile 754, „sechshundert, höchstens“) entspricht HW-S07, ORT-04 und R14 (`faehigkeiten.json`). Stromhaus, Torordnung 22:00, Bäckerin 03:00 und Uhrturm (00:30, 01:30, 03:00, 04:30) stimmen mit STADT-02, -04, -05 und LISTE-ZEITEN überein. Eisnebel nur im Tal, Nebelriese nur als Legende und Sprüche (E43 bestätigt, Stichprobe).
- R03 und R04 gegen `rollen.json`: R03 Strickjacke mit Zopfmuster (Rampe 5/2) über weißer Bluse, Jeans blau (E41), Wanderstiefel, kein Notizbuch. R04 Strickpullover, kariertes Hemd, Jeans, Wanderstiefel, Armbanduhr (Darstellung siehe Befund 5).
- Familienfelder (ANPASSUNG Zeilen 72 bis 92): unverändert nach v1.0, außer den im Datensatz selbst geänderten R04-Feldern.
- Kanon-Spuren (BSO-01, H-06 und H-15 zum fehlenden Stollen; H-14 und BW-AUSSAGE-3 zum Gestrickten; Gespensterlaken): bewusst so nach 9a (E23, E27). Kein neuer Grund.
- Spieltexte stichprobenhaft: `erzaehler.json` und `tutorial.json` vollständig gelesen. Keine Verstöße gegen Leitplanken oder Kanon. Das Burgtor öffnet sich zu Phase 2 (Erzähler und T14) wie in STADT-03.

## 4. Entscheidungslog (9a)

- Keine Abwägung aus E23 bis E44 wird ohne neuen Grund aufgehoben. Zwei Punkte widerspreche ich mit neuem Grund: FM-1 (Befund 1: E41 erklärt die Kanon-Dateien zum Spieltext, und die Lampen-Verknüpfung) und die Auffinden-Zeit (Befund 4: VERSION.md-Regel).
- E44 nennt OA-20 mit „etwa 00:01:30“; der O-Text lautet „Zeit: 00:01“. Die Schlussfolgerung bleibt, die Begründung sollte präziser sein.

## 5. Grenzen

- Kein Dart-SDK: Der Scanner ist ein Python-Nachbau, nicht der Originalbefehl. „0 Treffer nach Ausnahmen“ gilt für den Nachbau.
- Kein Web-Abgleich für Plagiate. Die neuen v1.0-Sätze sind generische Formulierungen; „Brockengespenst“ ist ein Naturphänomen und durch den Overlay ersetzt. Das Plagiatsurteil stützt sich auf Lesart und Stichprobe.
- Die Pixel-Darstellung ist nur über den Code gelesen, nicht über eine Bildausgabe geprüft.
- Die Burg-Räume (Speisekammer, Hofebene, Wehrgang) liegen nicht in den gelesenen Datendateien; ihre Ortsdaten sind nicht geprüft.
- Das Zeitmodell ZM-1 bis ZM-4 (Krimidinner-Taktung) ist nicht als App-Zahlenwerk geprüft.

## Urteil

Leitplanken nein wegen Befund 1 (Quelle; im Spiel ausgeblendet). Kanontreu ja (Maßstab sind die O-Zeilen und der O-Overlay; die Listenlücken aus Befund 2 und 3 betreffen G- und L-Texte). Plagiatsfrei ja (ohne Web-Abgleich).

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
