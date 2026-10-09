HEAD 04d68a9

# Gegenprüfung Inhalt gegenpruefer_inhalt_22 · Auftrag A-702r · Punkt 16 (Schwerpunkt Kanon-Änderung)

**Stand:** HEAD 04d68a9 (Ausgabe von `git rev-parse --short HEAD` nach `git merge --ff-only nachtlauf/burgstadt`; vorher d92a675, fast-forward ohne Konflikt). Worktree `/home/user/werwolf_digital_flutter/.claude/worktrees/wf_31d81172-639-4`. Keine Datenänderung, kein Commit, kein Push, kein Build. `dart pub get --offline` lief ohne Änderung an `pubspec.lock`; `git status` ist sauber. Frühere Berichte in `nachtlauf/auftraege/A-702/` wurden nicht gelesen.

**Werkzeug:** `dart run bin/leitplanken.dart --burgstadt` (Dart aus dem Flutter-SDK unter `/opt/flutter/bin/cache/dart-sdk/bin/`, `dart` ist nicht im PATH): 119 Dateien geprüft, 0 Treffer, 0 Fehler, 0 Warnungen. Der Scanner liest die Rohdateien (K*.md ohne FORMAT.md, ANPASSUNG.md, Daten und Spieltexte) und wendet die ERSETZE-Regeln nicht an. Seine Wortliste enthält weder „Punsch“, noch „Herkunft“, noch „bewusstlos“ (Quelle: `packages/burgstadt_core/lib/src/pruef/leitplanken.dart`, Kategorien ab Zeile 128).

## Abdeckung

- **Vollständig gelesen:** Auftrag A-702r; `nachtlauf/kanon/ANPASSUNG.md`; `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`; `10_kanon/VERSION.md`; `nachtlauf/ENTSCHEIDUNGSLOG.md` E23, E27, E29, E31, E33, E34, E35, E37 bis E45; der gesamte Kanon-Diff `659d3ed..HEAD` für K1 bis K9 (459 geänderte Zeilen: 29 mit [O], 75 mit [G], 58 mit [L], 297 ohne Tag aus Prosa, Tabellen und Kopfzeilen); `packages/burgstadt_spiel/data/texte/erzaehler.json`; die Figurendaten R03 und R04 in `packages/pixel_engine/data/figuren/rollen.json`.
- **Stichprobe:** `stadt/bewohner.json` (Zeilen 1 bis 60 und 2380 bis 2440), `stadt/haeuser.json` (Pension und Stichwörter), `innenraeume/fallorte.json` (Station der Pension), `rollen/faehigkeiten.json` (R01-Beruf, Zeile 142).
- **Nur Wortlisten-Scan, keine Vollsicht:** `innenraeume/haeuser.json`, `texte/tutorial.json`, `figuren/karten.json`, `teile_kleidung.json`, `teile_koepfe.json` sowie die übrigen Teile von `bewohner.json`, `haeuser.json` und `faehigkeiten.json`.
- **Abnahme-Punkt 10 (alle genannten Dateien vollständig gelesen) ist nicht vollständig erfüllt.** Die Urteile zu Leitplanken und Plagiat stützen sich für die nur gescannten und stichprobenartig gelesenen Dateien auf den Scanner, den Wortlisten-Scan und die Stichprobe.

**Wortlisten-Scan (Daten und ANPASSUNG):** Alkohol nur als „Punsch“, „Punschkessel“ und „alkoholfrei“, dazu „Kater“ als Haustier (in LEITPLANKEN-AUSNAHMEN gelistet). Keine Drogenbegriffe. Blut nur „benommen“, „Wunde“ (keine offene Wunde), „Wunder“ und die ERSETZE-Quelle „bewusstlos“. Hexen und Teufel keine (das Gespenst ist Thema, erlaubt). Herkunftsbegriffe nur in Abschnittsüberschriften und in FM-1 der ANPASSUNG; „Harz“ nur als ERSETZE-Quelle; „kopftuch“ nur im ungenutzten Teil `kopf-kopftuch`. Keine Kopie-Begriffe (Sherlock, Holmes, Hogwarts u. a.); „Tatort“ nur als Gattungswort. „Knochen“ ist ein JSON-Schlüssel der Figurenteile.

## Befunde

### 1. hoch · FM-1 in der Kanon-Quelle (neu in v1.0, Lösungsdatensatz [L])

- **Datei:** `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 80.
- **Zitat:** „Funktionsmatrix Herkunft: deutsch – Täterin (R03) und Hauptverdächtiger mit echtem Vergehen (R04); bosnisch – Hauptverdächtiger ohne Vergehen (R01); kurdisch – Hauptzeugin (R02); polnisch und türkisch – keine belastete Funktion … Herkunft ist nie Motiv, Indiz oder Pointe.“
- **Regel:** Leitplanke „Herkunft ist nie Motiv, Indiz oder Pointe“, Verbot von Klischees über Gruppen.
- **Einordnung:** Der Datensatz ist L und damit nach Punkt 17 kein Spieltext; das Spieltext-Urteil bleibt „ja“. Er ordnet aber Tat- und Verdachtsfunktionen nach Herkunftsgruppen zu und begründet das mit der Herkunft selbst. Damit widerspricht er seinem eigenen Schlusssatz.
- **Neuer Grund gegen E43 und E45:** Die Overlay-Fassung in ANPASSUNG (FM-1) ersetzt nur die Herkunftsbegriffe durch Rollen-IDs. Die Verteilung bleibt identisch: R01 falsche Hauptverdächtige, R02 Zeugin, R03 Täterin, R04 echtes Vergehen. Die herkunftsbezogene Anlage des Falls bleibt im wirksamen Kanon erhalten, nur unsichtbar.
- **Vorschlag:** FM-1 aus K1 streichen, oder die Verteilung ohne Herkunftsbezug begründen (Verdacht und Schuld nur aus Gegenständen, Zeiten und Aussagen). Die Entscheidung liegt beim Nutzer (Punkt 17, E45).

### 2. mittel · Nachname als einziger Eigentumshinweis auf einem sichtbaren Beweisstück (Grenzfall)

- **Datei:** `K1-GRUNDWAHRHEIT.md`, Zeile 198 (`@BSO-03 [O]`, Phase 1). Wiederholt in K1 (Zeilen 28, 86, 100, 185), `K2-ROLLEN-KERN.md:9`, `K3-HINWEISE.md:48`, `K5-ENTSCHEIDUNGEN-P1.md:6`, `K5-ENTSCHEIDUNGEN-DETEKTIV.md:8` und `K8-STILBLATT.md:123` (Schreibweise).
- **Zitat BSO-03:** „Schwarze Stablampe mit Klebeband „HODŽIĆ VT · 3“, Schalter auf AN …“. DW1-1 [L]: „Es ist Adnans Lampe … sie zeigt auf Adnan.“
- **Ausgangslage:** R01 heißt Adnan Hodžić (`rollen.json`, `karten.json`). K2 nennt „Wurzeln: bosnisch“, und FM-1 führt R01 als falsche Hauptverdächtige.
- **Begründung:** Der Nachname ist das einzige Eigentumsmerkmal auf einem sichtbaren Beweisstück. Er zeigt auf die Person, die der Kanon als bosnischen Verdacht ohne Schuld führt. Die Kette braucht den Nachnamen nicht: „deine Lampe 3“ (H-204 [G]) und „Adnans Lampe 3“ (H-332 [G]) ordnen die Lampe bereits zu. Das ist ein neuer Grund gegen die Abwägung in E43 und E44 („Eigentumsmarke mit dem Nachnamen … kein Herkunftsindiz“).
- **Vorschlag:** Kennung auf „VT · 3“ kürzen. Das geht über eine ERSETZE-Zeile in ANPASSUNG, ohne die Kanon-Dateien zu ändern. Die Kanon-Autoren sind zu informieren.

### 3. gering · „Herkunft des Schreis“ im Spieltext, neu in v1.0

- **Dateien:** `K2-ROLLEN-KERN.md:22` (R02-LÜGE [G]: „einschließlich der Herkunft des Schreis („Die Box spinnt“)“) und `K7-LUEGENREGEL.md:11` (LR-7 [L]: „samt Herkunft des Schreis“).
- **Einordnung:** Kein Personenmerkmal, daher kein Verstoß. Das Wort ist aber das Leitplanken-Schlüsselwort. E45 hat es in `faehigkeiten.json` bereits durch „Quelle“ ersetzt. Der Overlay erfasst die G-Zeile nicht.
- **Vorschlag:** ERSETZE-Zeile „Herkunft des Schreis“ → „Quelle des Schreis“ in ANPASSUNG (Begriffsersetzungen, [O]).

### 4. gering · „Punsch“ ohne ausdrückliches „alkoholfrei“ an mehreren Stellen

- **Stellen:** `ANPASSUNG.md:69` (LISTE-ORTE [O]: „Punschkessel“) und `K2-ROLLEN-13-20.md:44` („Am Punschkessel erzählt er …“).
- **Inhaltlich alkoholfrei:** K8 Zeilen 118 und 129 („warmer, alkoholfreier Apfel-Zimt-Punsch“), `erzaehler.json:119` („Der Punsch im Gewölbe ist warm und alkoholfrei“), `packages/burgstadt_core/lib/src/welt/burg.dart:48` („Punschkessel (warm, alkoholfrei)“). Das Leitplanken-Urteil bleibt deshalb „ja“.
- **Lücke:** ERSETZE-19 bis -21 erfassen nur „Becher Punsch“. Der Scanner führt „Punsch“ nicht.
- **Vorschlag:** Warnregel „Punsch“ ohne „alkoholfrei“ im selben Datensatz. Bei Trinkszenen „alkoholfrei“ ausschreiben.

### 5. gering · Wortliste des Scanners lässt drei Leitplanken-Begriffe aus

- „bewusstlos“ (Auftrag Punkt 4: Verletzung nur „Beule“, „benommen“, „Kühlpack“) steht roh in K1 (PF-3 [L]) und als Quelle in ANPASSUNG (ERSETZE-17). Der Scanner meldet es nicht, obwohl es in den Rohdateien steht. „Punsch“ und „Herkunft“ fehlen ebenfalls.
- **Vorschlag:** „bewusstlos“ und „Herkunft“ auf die Wortliste (Warnung), ERSETZE-Quellen über LEITPLANKEN-AUSNAHMEN freigeben.

## Beobachtungen ohne Befund

- **Auffinden des Burgwarts (E44):** K1 LISTE-ZEITEN [O] nennt „00:01“, das Overlay „kurz nach Mitternacht“. Im wirksamen Kanon ist das konsistent (laut E44 OA-20 etwa 00:01:30; die L-Daten 00:00:25 und 00:00:50). Die Kanon-Autoren sollten die Zeit festlegen. Kein Befund, weil E44 die Abwägung getroffen hat.
- **Ungenutztes Kopftuch-Teil** `kopf-kopftuch` in `teile_koepfe.json:190` (E27 G4, E39 B-10): kein Befund. Empfehlung: entfernen, damit es nicht versehentlich zugewiesen wird.
- **Nebel:** nur im Tal und auf dem unteren Burgweg (K-002, `erzaehler.json:117`, `bewohner.json:280`). Im Stadtdatenbestand steht Nebel nur als Legende oder bedingt („Bei Nebel soll er nach Tannenholz riechen“, `haeuser.json:1838`). Mit E43 konsistent.
- **Herkunftsfelder** „Wurzeln“ und „Familie“ in den O-Steckbriefen: nicht im Spiel angezeigt (E38), kein Motiv, Indiz oder Pointe. Keine Klischees in den Familienfeldern.
- **Stilblatt-Beispiele** (K8: „Streichholzbriefchen“, „Beispielfigur“): in den Spieldaten nicht vorhanden.

## Geprüft und unauffällig (Punkt 15 und Stadtdaten)

- **Pension und Wäsche:** `haeuser.json:364` (blauer Stempel mit Namen); `fallorte.json`, Station ORT-03 „am Wäscheschrank“. Konsistent mit ORT-03 und E42.
- **Laken „Schartenfels 7“** (Z-2140, BS-02): in den Stadtdaten nicht vorhanden, daher kein Konflikt.
- **Phasenbeginn 00:30:** alle 44 Nachtpläne in `bewohner.json` setzen 00:30; „00:25“ kommt in den Daten nicht vor. Konsistent mit STADT-05 und LISTE-ZEITEN.
- **Harz, Osterode, Brockengespenst:** in den Spieldaten nicht vorhanden (nur in Tests). ERSETZE-04 bis -18 greifen.
- **R03 und R04 gegen `rollen.json`:** R03 hat Strickjacke mit Zopfmuster, weiße Bluse, Jeans (blau, Rampe 6 Stufe 4) und kein Notizbuch (`zubehoer: []`). R04 hat Pullover, kariertes Hemd, Jeans, Wanderstiefel und Uhr. Das passt zu K9 LF-R03/LF-R04 und K2 R04-STAMM. Die Farbstufen habe ich nicht gegen die Paletten geprüft.
- **„kurz benommen, kurz nach Mitternacht“** (`faehigkeiten.json:142`) entspricht dem Overlay.
- **R02-WISSEN „dir das Handy“** wird durch ERSETZE-22 korrekt zu „ihr“.
- **Codewort „Brockengespenst“** (GL-21 [O] in K8, G1-06 [G] in K4) wird durch ERSETZE-09 zu „Nebelriese“.

## Entscheidungslog (Punkt 9a)

Gelesen: E23, E27, E29, E31, E33, E34, E35 und E37 bis E45. Als Befund gezählt habe ich nur die Punkte mit neuem Grund: FM-1 (Befund 1; die Verteilung bleibt nach dem Overlay identisch) und BSO-03 (Befund 2; die Kette braucht den Nachnamen nicht). Die übrigen Entscheidungen habe ich nicht neu bewertet, darunter die Kanon-Spuren auf die Täterin (E27 M5), „Einspruch!“ (E27 G3), die Fähigkeit von R03 (E27 H1), die Wanderstiefel (E38) und die Familienfelder (E38, E39, E43).

## Plagiat

Keine erkennbaren Kopien. Figuren, Orte und Namen sind eigenständig; der Stichwortscan ergab keine Treffer. Ein vollständiger Plagiatsabgleich braucht externe Textkorpora und war in diesem Lauf nicht möglich.

## Urteil

Die v1.0-Änderungen sind im Spieltext überwiegend korrekt im Overlay umgesetzt. Offen sind Befund 3 (Herkunftswort im G-Text, vom Overlay nicht erfasst) und Befund 4 (Punsch-Stellen ohne Zusatz). Befund 1 liegt in der Kanon-Quelle und ist nach Punkt 17 eine Nutzerentscheidung. Befund 2 ist ein Grenzfall mit klarer Empfehlung.

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
