HEAD 063be37

# Gegenprüfung Inhalt · gegenpruefer_inhalt_18 · Auftrag A-702p, Punkt 16 (Schwerpunkt Kanon-Änderung)

- **Geprüfter Stand:** HEAD 063be37 (`git merge --ff-only nachtlauf/burgstadt`, Fast-Forward von d92a675). Der Worktree war vor und nach der Prüfung sauber.
- **Unabhängigkeit:** Keine früheren Berichte in nachtlauf/auftraege/A-702/ gelesen oder durchsucht. Keine Daten geändert, kein Commit, kein Push, kein Build.
- **Urteil:** Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
- **Befunde:** hoch 0 · mittel 2 · gering 4

## Vorgehen

1. **Kanon-Diff vollständig gelesen:** `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md` (22 Dateien, 670 Diff-Zeilen, dazu 216 neue und 212 entfernte Inhaltszeilen). Maßstab waren die [O]-Zeilen; [G] und [L] wurden nur auf Widersprüche geprüft.
2. **ANPASSUNG.md vollständig gelesen** (170 Zeilen).
3. **Overlay mechanisch angewendet** (Feld-Merge und ERSETZE-Regeln, Hilfsskript im Scratchpad): 1211 Kanon-Datensätze, 95 Overlay-Einträge (65 neue IDs für STADT, ORT, H-S und HW-S; 30 bestehende Kanon-IDs mit Feldänderung), 22 ERSETZE-Regeln. Die effektiven O-Zeilen sind auf Verbotsbegriffe, Nebel, Zeitangaben und Herkunftsmarker durchsucht. Querverweise: 1276 definierte IDs, keine toten Verweise.
4. **Spieltexte und Stadtdaten:** Alle Strings aus `packages/burgstadt_core/data/**`, `packages/burgstadt_spiel/data/texte/*.json` und `packages/pixel_engine/data/figuren/*.json` extrahiert und gezielt durchsucht. `erzaehler.json` vollständig gelesen, `tutorial.json` gezielt. Alle Nachtplan-Zeitfenster geprüft.
5. **Scanner:** `dart` liegt nicht im PATH, benutzt wurde `/opt/flutter/bin/dart`. In `packages/burgstadt_core`: `dart pub get --offline`, dann `dart run bin/leitplanken.dart --burgstadt`. Ergebnis: Geprüfte Dateien 119 · Summe 0 Treffer · 0 Fehler · 0 Warnungen. Laut Auftrag findet der Scanner keine Andeutungen; deshalb die manuelle Prüfung oben.
6. **Abwägungen 9a:** E23 bis E43 vollständig gelesen und einzeln bewertet (Abschnitt unten).

## Befunde

### 1 · mittel · Nebel um die Burg (LA-01) widerspricht K-002 v1.0

- **Datei/Stelle:** `nachtlauf/kanon/ANPASSUNG.md`, Zeile 53, `@LA-01 [O]`, Feld „Anker (EN)“.
- **Zitat:** „… a gatehouse with a heavy arched wooden gate, fir forest and drifting night fog around it“
- **Regel:** Maßstab Kanon (O gegen O). K-002 [O] in `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 19: „Über der Burg ist der Himmel klar … Im Tal um Silberhau und auf dem unteren Burgweg liegt dichter Eisnebel.“ E43 hat den Nebel aus der Oberstadt entfernt, LA-01 aber nicht erfasst.
- **Vorschlag:** Im Anker den Nebel streichen oder ins Tal verlegen, etwa „… fir forest and clear frosty night air above it, valley mist far below“. Die Änderung betrifft nur den Overlay, keine Kanon-Datei.

### 2 · mittel · Auffinden und Erwachen des Burgwarts: O-Zeilen untereinander und gegen G/L widersprüchlich

- **Datei/Stelle:** `K1-GRUNDWAHRHEIT.md` (LISTE-ZEITEN, Zeile 29; OA-20; Z-0000d, Z-0000e, PF-3), `ANPASSUNG.md` Zeile 70 (LISTE-ZEITEN-Overlay), `K2-ROLLEN-KERN.md` Zeile 10 (R01-WISSEN).
- **Zitate:** LISTE-ZEITEN [O]: „00:01 der Burgwart wird in der Speisekammer gefunden und kommt zu sich“. OA-20 [O]: „Zeit: 00:01 … Nach einer halben Minute kommt er zu sich“, also etwa 00:01:30. R01-WISSEN [G]: „00:00:25 der Burgwart bewusstlos“. Z-0000d [L]: „Zeit: 00:00:25 … Der Burgwart liegt benommen“. Z-0000e [L] und PF-3 [L]: Erwachen um 00:00:50.
- **Regel:** Maßstab Kanon. Die beiden O-Zeilen widersprechen sich (00:01 gegen etwa 00:01:30). G und L setzen das Auffinden auf 00:00:25 und das Erwachen auf 00:00:50. LISTE-ZEITEN wird dem Spiel über die Fähigkeit von R04 wörtlich ausgegeben (`faehigkeiten.json`: „Die Antwort kommt aus LISTE-ZEITEN“), und das Rollenwissen von R01 ist dem Spieler sichtbar. E42 hat die Abweichung als „Kanon-Wortlaut“ festgehalten. Neuer Grund gegen diese Abwägung: der O-O-Widerspruch und die sichtbare Abweichung zum Rollenwissen.
- **Vorschlag:** Die Kanon-Autoren legen eine Zeit fest (ÄNDERUNG im PROTOKOLL.md) und gleichen LISTE-ZEITEN, OA-20 und die Rollenzeiten an. Ein reiner Overlay-Eingriff ist hier nicht der richtige Weg, weil es um Kanon-Tatsachen geht.

### 3 · gering · Familienfeld-Overlay geht über die beschriebene Änderung hinaus; Dokumentation und Protokoll fehlen

- **Datei/Stelle:** `ANPASSUNG.md` Zeilen 72–74 („für den wirksamen Kanon wird nur dieser eine Satzteil herkunftsneutral gefasst … Name, Wurzeln, Eltern, Geschwister und alle anderen Felder bleiben“), Zeilen 76–88.
- **Befund:** Der Wortvergleich Overlay gegen Basis zeigt mehr als einen Satzteil:
  - R05: Großmutter „wohnt zwei Straßen weiter“ (vorher im Haus), Kreuzworträtsel statt Pierogi, Bruder-Detail geändert.
  - R13: Großmutter „wohnt zwei Straßen weiter“, Haushaltsbuch statt Revani.
  - R18: „wohnt mit im Haus“ und „schlichtet … wie ein Gericht“ entfallen, die Richterin-Frage ist gestrichen.
  - R14: Gedeck für einen unerwarteten Gast wird zu einem Stuhl mehr am Tisch.
  - R01: Telefonate entfallen, „Adnan repariert danach …“ kommt dazu.
  - R12: Džezva-Kaffee wird zur Abkürzungsdiskussion.
  - R06, R07, R08, R09, R15, R16, R19: Festtag, Instrument oder Speise ersetzt.
  - Wurzeln, Eltern und Geschwister sind unverändert.
- **Regel:** `VERSION.md` (ab v1.0): „bestehende Tatsachen ändern sich nur über ÄNDERUNG und Protokoll.“ `PROTOKOLL.md` (63 Zeilen) enthält dazu keinen Eintrag.
- **Vorschlag:** Die Begründung im ANPASSUNG-Abschnitt auf die tatsächlichen Änderungen umstellen (einschließlich Wohnort der Großmutter und R18-Charakter) und im PROTOKOLL.md als Overlay-Eintrag mit Grund festhalten.

### 4 · gering · Stadt-Gerede nennt Nebel in der Unteren Stadt

- **Datei/Stelle:** `packages/burgstadt_core/data/stadt/bewohner.json`, `.bewohner[2].gerede`: „… der Nebelriese habe sich vor der Backstube gezeigt, aber wahrscheinlich wollte nur der Nebel ein Brötchen.“
- **Regel:** K-002 v1.0 und E43 („Nebel steht nur noch unten im Tal“). Die Untere Stadt gehört laut LISTE-ORTE zur Oberstadt.
- **Vorschlag:** z. B. „… wollte nur der Frost ein Brötchen.“ Die Nebelriesen-Legende selbst bleibt zulässig.

### 5 · gering · Ersatzmotive folgen dem Muster „Herkunft → Speise / Sparsamkeit“

- **R09** (Wurzeln polnisch, `faehigkeiten.json`): Beruf „Koch, stellvertretender Küchenchef“, am Wochenende „backt er Torten“; im Familienfeld „die Mutter kocht an Feiertagen für die ganze Familie“. Das Festmerkmal ist weg, das Essen bleibt Familienmerkmal.
- **R13** (Wurzeln türkisch): „führt seit fünfzig Jahren ein Haushaltsbuch; … jede Ausgabe aufzuschreiben“. Das Ersatzmotiv bringt Sparsamkeit in eine Familie mit türkischen Namen.
- Einzeln sind beide Stellen nicht verboten, E38 fragt aber gerade nach diesem Muster. **Vorschlag:** R13 auf ein neutrales Motiv umstellen (z. B. Gartenkalender); im R09-Familiensatz das Essen als Merkmal streichen.

### 6 · gering · Kommentar im Code nennt falsche Phasendauer

- **Datei/Stelle:** `packages/burgstadt_core/lib/src/fall/simulation.dart`, Zeile 48: „(Phase 1 = 65 Spielminuten)“.
- **Regel:** STADT-05 (Phase 1 von 00:30 bis 01:30) und E42 (60 statt 65 Minuten).
- **Vorschlag:** Kommentar korrigieren. Keine Auswirkung auf den Spieltext.

## Geprüft ohne Befund

- **Punkt 15, Kanon-Diff:** Alle geänderten Zeilen der 22 K-Dateien gelesen. Mit ANPASSUNG und den Stadtdaten konsistent sind unter anderem K-004, KOMIK-2, Z-2120 bis Z-2358a, BW-AUSSAGE-2/3, DET-B3/B6, H-02, H-06, H-09, H-11, H-14, H-17, H-25, H-49, H-50, HW-02, HW-06, HW-11, HW-14, D1-2, D2-2, D3-2, die K8-Tabelle und K9 (LF-R03, LF-R04). Die Wachs- und Stollenzeiten, die Trackzeiten (23:57 bis 00:00), der Phasenbeginn 00:30 (kein 00:25 mehr in den Daten) und die Teestube B07 (01:20, 02:50, 03:00) passen zusammen.
- **R03 und R04 gegen `packages/pixel_engine/data/figuren/rollen.json`:** R03 ohne Notizbuch (`zubehoer` leer), Strickjacke mit Zopfmuster dunkelgrün über weißer Bluse, Jeans blau [6,4], braune Wanderstiefel. R04: Typ `pullover` (olivgrün), kariertes Hemd, Jeans, Wanderstiefel, Armbanduhr mit großem Ziffernblatt. Beides entspricht K2, K9 und E41. Der R04-Beruf in `faehigkeiten.json` entspricht K2 ohne „(so erzählt er es)“.
- **Verbotsbegriffe:** Keine Hexen, Walpurgis, Teufel, kein Blut. Verletzungen nur als „benommen“, „Beule“ und „keine offene Wunde“. Alkohol nur als „alkoholfrei“ (Punsch), Teestube statt Kneipe. Keine Drogen und keine Andeutungen (Scan auf Rausch, Fahne, verkatert u. a. ohne echten Treffer). Harz, Osterode, Brocken und Silberhauer kommen in Spieltexten nicht mehr vor.
- **Täterhinweise in Stadtdaten:** keine. Die Fall-Spuren zur Täterin (H-14 „Ärmel, was Gestricktes, Wolle“, H-06 Stollenprofil) stehen nur in O-Datensätzen des Kanons.
- **Fleece und Notizbuch:** keine Reste in den Figurendaten (0 Treffer für „fleece“, kein Buch-Teil in der R03-Karte).
- **Erzählertexte:** `erzaehler.json` vollständig gelesen, keine Befunde. Nebel nur als „Unten im Tal steht der Nebel dicht“. „Gassen ohne Laternen“ passt zu STADT-02.
- **Plagiat:** Stichprobe ohne erkennbare Kopie aus Film, Serie, Spiel, Buch oder Lied. Ein externer Abgleich war offline nicht möglich.

## Zu den Abwägungen nach Punkt 9a

- **Ohne Einwand:** E23, E29 (ERSETZE-17 „benommen“), E31, E33, E35, E37, E39, E40. E38 Wanderstiefel aus zwei Teilen: die Kombination ist durch Sichtprüfer 13 bestätigt.
- **E41:** Der Abgleich der v1.0-Änderungen mit dem Overlay stimmt für LISTE-ZEITEN und FM-1 (Feldkonflikte richtig gelöst), für die R-STAMM-Familienfelder (im Kanon unverändert) und für die ERSETZE-Regeln. Übersehen wurde der semantische Konflikt bei LA-01 (Befund 1).
- **E27, Täterin-Spuren (M5):** Die Auslegung, dass die Leitplanke nur für unsere Zusatztexte gilt, ist plausibel, weil Fair-Play-Spuren zum Rätsel gehören. Kein neuer Grund zum Widerspruch. Hinweis: Diese Auslegung sollte im Leitplanken-Text oder im Kanon-Protokoll festgehalten werden.
- **E34 und E42 (Uhrzeiten außerhalb LISTE-ZEITEN):** Der Kanon-Satz „Andere Uhrzeiten nennen nur Rollenkarten, Hinweise und Beweisstücke.“ widerspricht den eigenen O-Zeilen OA-04 bis OA-27 mit öffentlichen Zeiten. Die Overlay-Ergänzung ist vertretbar; die Kanon-Autoren sollten den Satz korrigieren. Kein Befund.
- **E42, 00:01 gegen PF-3:** nicht ausreichend abgewogen, siehe Befund 2.
- **E43, Himmel:** richtig ausgerichtet, aber unvollständig (Befund 1 und Befund 4).
- **E43, FM-1 ohne Herkunft:** nachvollzogen. R02 legt den Hebel um und lügt über den Streich; die Begründung „Mehrheitsgruppe trägt die Schuld“ trägt nicht. Kein Befund.
- **E43, „HODŽIĆ VT · 3“:** nachvollzogen, weil die Marke den Besitzer nennt und die Fährte am Gegenstand hängt. Hinweis: Der Nachname ist die einzige Verbindung zur Herkunft. Die Kanon-Verantwortlichen sollten prüfen, ob eine neutrale Marke genügt. Kein Befund.
- **E38 Familienfelder:** Herkunftskern akzeptiert. Umfang und Dokumentation sind Befund 3, die Ersatzmotive Befund 5.

## Hinweise (keine Befunde, nicht bewertet)

- **Zeitmodell ZM-1, ZM-2, ZM-4 und IF-5 (v1.0):** Gesprächsfenster 20 bis 35 Minuten je Rollenzahl, Lagerunde 5 bis 12 Minuten, Gong alle 5 Minuten. Das E-Log erwähnt diese Änderung nicht, und die Werte stehen nicht in den geprüften Daten. Ob der Code sie umsetzt, habe ich nicht geprüft.
- **FM-1 (L):** Die Kanon-Datei behält die Herkunftsmatrix; wirksam ist die Overlay-Fassung (wie E43).
- **GESAMT-KANON.md** (generiert) hat 1211 Datensätze wie die Einzeldateien. Der Inhalt ist nicht Wort für Wort abgeglichen; die Datei ist kein Maßstab.
- **Strick-Hinweis:** Mit dem Strickpullover bei R04 zeigt H-14 („Ärmel, was Gestricktes, Wolle“) auf zwei Rollen (R03 und R04). Der Kanon sagt das selbst (HW-14). Kein Befund, aber eine Folge für die Kanon-Autoren.

## Grenzen

- `bewohner.json` und `haeuser.json` (je über 80 KB) habe ich nicht Zeile für Zeile gelesen, sondern systematisch durchsucht und stichprobenartig gelesen. Vollständig gelesen wurden Kanon, ANPASSUNG und `erzaehler.json`; Figuren- und Fähigkeitsdaten wurden gezielt geprüft (R03, R04, Notizbuch, Fleece, R04-Beruf, R09 und R13).
- Hilfsdateien liegen im Scratchpad (`gegenpruefer_inhalt_18/`), nicht im Repo.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
