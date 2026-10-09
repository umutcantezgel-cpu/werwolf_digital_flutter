HEAD c54fe9c

# Gegenprüfung Inhalt · Auftrag A-702t · gegenpruefer_inhalt_25

- Prüfer-ID: gegenpruefer_inhalt_25 (unabhängig; keine anderen Prüfberichte gelesen, Ordner A-702/ nicht durchsucht)
- Worktree: /home/user/werwolf_digital_flutter/.claude/worktrees/wf_853e074c-b91-1
- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` von dc205b0 auf c54fe9c (Fast-Forward)
- Keine Daten geändert, kein Commit, kein Push, kein Build. Einzige Datei im Worktree: dieser Bericht. Hilfsdateien nur im Scratchpad.

## 1. Ergebnis

| Maßstab | Urteil | Grund |
|---|---|---|
| Leitplanken | nein | B1 (hoch): Ergebnistext nennt die Täterin in Phase 3, vor der Auflösung. B2 (mittel): „Punsch“ ohne Alkoholfrei-Zusatz in zehn Zeilen |
| Kanontreu | ja | Die 29 geänderten O-Datensätze des Kanon-Diffs 659d3ed..HEAD sind im wirksamen Kanon und in den Figurendaten umgesetzt. Eine dokumentierte Abweichung (B7, gering) |
| Plagiatsfrei | ja | Keine Übernahmen erkennbar (Musterprüfung, kein externer Abgleich) |

Befunde: hoch 1 · mittel 1 · gering 5.

## 2. Prüfumfang und Lücken

Gelesen oder ausgewertet:
- Testbefehl `dart pub get --offline` und `dart run bin/leitplanken.dart --burgstadt`: 119 Dateien, 0 Treffer, 0 Fehler, 0 Warnungen. Die Befunde unten wurden von Hand ermittelt, weil der Scanner keine Andeutungen findet.
- `dart run bin/kanon.dart --wirksam`: 1276 Zeilen, davon 265 mit [O], 559 mit [G], 453 mit [L] (darin die 9 DW-Zeilen). Alle DW-Zeilen vollständig gelesen; O- und G-Zeilen musterweise geprüft.
- Kanon-Diff `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: alle 29 geänderten O-Datensätze gelesen; rund 75 geänderte G- und rund 58 geänderte L-Datensätze als Wortdiff auf Widersprüche geprüft.
- `nachtlauf/kanon/ANPASSUNG.md` (190 Zeilen) vollständig gelesen.
- `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json` vollständig gelesen.
- `packages/pixel_engine/data/figuren/rollen.json`: R03 und R04 gegen LF-R03 und LF-R04 geprüft. `karten.json` und die Teile-Dateien musterweise.
- Entscheidungslog E23, E27, E29, E31, E33, E34, E35, E37, E38, E39, E40, E41, E42, E43, E44, E45, E46, E47, E48, E49 gelesen.

Nicht vollständig gelesen (Lücke gegenüber Abnahme-Punkt 10):
- `packages/burgstadt_core/data/stadt/bewohner.json`, `stadt/haeuser.json`, `innenraeume/*.json`, `rollen/faehigkeiten.json` (zusammen rund 260 KB Text-JSON): vollständige Musterprüfung auf Leitplanken-, Herkunfts-, Täterinnen- und Plagiatsbegriffe, dazu Stichproben.
- Gesprächs- und Hinweisdatensätze G1–G3, H, E1–E3 sowie die übrigen R-Datensätze (rund 300 KB): Musterprüfung und Wortdiff der Änderungen, keine Zeile-für-Zeile-Lektüre.
Das Urteil zu diesen Teilen stützt sich auf die Musterprüfung und die Stichproben und ist entsprechend vorsichtig formuliert.

Geprüfte Muster: Alkohol und Gaststätten, Drogen, Verletzung und Blut, Okkultes (Hexe, Walpurgis, Teufel, Vampir, Fledermaus), Herkunftsbegriffe und Herkunftsorte, Klischee-Begriffe, direkte Täterinnen-Nennung, Merkmale der Täterin in Stadt- und Hinweisdaten, bekannte Werke (Figuren, Titel, Zitate).

## 3. Befunde

### B1 · hoch · DW3-3, Ergebnis C nennt die Täterin vor der Auflösung
- Stelle: wirksamer Kanon `@DW3-3 [L]`, Feld „Ergebnis C“ (Quelle `krimidinner/spuk-im-gewoelbe/10_kanon/K5-ENTSCHEIDUNGEN-DETEKTIV.md`). Ausgelöst durch `@D3-3 [O] | Phase: 3`.
- Zitat: „Der Abdruck stammt von Merle.“
- Regel: Auftrag Punkt 4, verbindlich: kein Text, der vor der Auflösung die Täterin nahelegt. Die Auflösung ist im Spiel auf das Morgengrauen gelegt: `packages/burgstadt_spiel/data/texte/erzaehler.json`, uhrturm/morgengrauen[0]: „Jetzt wird aufgelöst, was die Nacht verborgen hat.“ Ebenso ANPASSUNG STADT-05: „Die Auflösung folgt im Morgengrauen.“
- Begründung: Die Detektiv-Entscheidung D3-3 liegt in Phase 3 und damit vor der Anklage. Der Ergebnistext benennt die Täterin namentlich und zählt nach E47 als Spieltext. Die Ausnahme aus E27 M5 deckt Kanon-Spuren (O-Hinweise) mit Gegenspuren, nicht Schlussergebnisse mit Namensnennung. Neuer Grund gegen E27 M5: DW3-3 ist kein O-Hinweis, sondern das Ergebnis der Spurenauswertung, und nennt die Täterin direkt.
- Vorschlag: Ergebnis C per Overlay (feldweise, Kanon-Datei unberührt) auf die Spur beschränken, etwa „Der Abdruck passt zu einem Stiefel mit fehlendem Stollen“. Die Zuordnung zur Person erst in der Anklage bzw. im Morgengrauen zeigen.

### B2 · mittel · „Punschkessel“ ohne Alkoholfrei-Zusatz (zehn Zeilen)
- Stelle (wirksamer Kanon): `@LISTE-ORTE` (ANPASSUNG Zeile 77), `@LISTE-GEGENSTÄNDE`, `@OA-03`, `@R05-ÖFFENTLICH`, `@R01-ÖFFENTLICH`, `@R17-ÖFFENTLICH`, `@D1-3` (alle O); `@R12-WISSEN`, `@R12-LÜGE`, `@E1-12` (alle G).
- Zitate: „Adnan rammt mit dem Wagen samt Punschkessel die alte Eichentür“ (OA-03); „Option B: den Punschkessel“ (D1-3).
- Regel: Auftrag Punkt 4: „Punsch immer alkoholfrei“, ohne Einschränkung.
- Begründung: Die Ersetzungen ERSETZE-19 bis -21 sowie -29 und -30 machen nur die Wortfolgen „Becher Punsch“ und „warmer Punsch“ alkoholfrei. E46 begrenzt die Regel auf Stellen, an denen jemand Punsch trinkt. Der Auftrag kennt diese Einschränkung nicht. Der Kessel ist im Kanon zwar als alkoholfrei festgelegt (OA-04, GL-14), in diesen zehn Zeilen steht das Wort Punsch aber ohne den Zusatz. Der Scanner (0 Treffer) erfasst das nicht.
- Vorschlag: ERSETZE-Eintrag „Punschkessel“ → „alkoholfreier Punschkessel“, dazu ein Test, der jede Zeile mit dem Wortstamm „Punsch“ auf „alkoholfrei“ prüft.

### B3 · gering · Familienfeld R04 nennt einen Herkunftsort
- Stelle: `@R04-STAMM` (wirksamer Kanon). ANPASSUNG Zeile 92 ändert nur „Löschen: Wurzeln“.
- Zitat: „Familie: aus Salzgitter-Bad. Der Vater ist Schichtleiter im Stahlwerk …“
- Regel: ANPASSUNG Zeile 83 (E48, N-02): „die Familienfelder nennen keine Herkunftsorte mehr (R01, R05, R16: ‚Die Eltern leben in …‘)“.
- Begründung: R01, R05 und R16 beginnen laut E48 mit „Die Eltern leben in …“, R04 blieb unverändert. Das Overlay behauptet aber, dass keine Familienfelder mehr Herkunftsorte nennen. Das Feld wird im Spiel nicht angezeigt (E48), deshalb nur gering. Grenzfall: R10 „Familie: aufgewachsen in Husum“.
- Vorschlag: R04 per Overlay auf „Die Eltern leben in Salzgitter-Bad; …“ umstellen (Rest wörtlich), R10 entsprechend prüfen oder die Beschreibung in Zeile 83 korrigieren.

### B4 · gering · Feld „Herkunft“ im Burgwart-Datensatz
- Stelle: ANPASSUNG Zeile 56, `@BW-STAMM [O] | Herkunft: Schartenfels, Bergland`.
- Regel: N-02 „Herkunft ist nicht mehr Teil der Spieldaten“. E48 hat den Eintrag bewusst belassen.
- Begründung (neuer Grund gegen E48): Das Feld heißt „Herkunft“ und nennt die Herkunft einer Person. Das ist dieselbe Information wie das gelöschte Feld „Wurzeln“ der Rollen. Der Hinweis „Ort der Spielwelt“ ändert den Inhalt nicht.
- Vorschlag: Feld umbenennen (etwa „Wohnort“) oder entfernen. Zusätzlich in `kanon_test` festhalten, dass kein O-Datensatz ein Feld „Herkunft“ trägt.

### B5 · gering · Geld- und Härte-Färbungen bei Figuren mit nichtdeutsch klingenden Namen
- Stelle (wirksamer Kanon, „Scheinbare Färbung“): `@R13-GEHEIM`: „drängt hart auf ihr Geld und wirkt dadurch unnachgiebig“. `@R15-GEHEIM`: „redet ständig über Geld, Schäden und Versicherungen … wirkt dabei seltsam ungerührt“. `@R05-GEHEIM`: „ärgert sich lautstark über Jonas und das Mietgeld und wirkt dabei rachsüchtig“. `@R14-GEHEIM`: „der Burgwart wolle Adnan abzocken“. `@R16-GEHEIM`: „wirkt wie ein Tatmotiv“. `@R18-GEHEIM`: „wirkt dadurch wie eine Besserwisserin“.
- Regel: Leitplanke 4 (keine Klischees über Gruppen). Abwägung E47: „folgt aus Beruf und Lage der Figur“.
- Begründung (neuer Grund gegen E47): Die Berufe (Bankkauffrau, Versicherungskauffrau, Steuerfachangestellte, Immobilienkaufmann) erklären das Geldthema, nicht die negativen Eigenschaften. E47 hat nur die Adjektive von R13 und R15 getauscht. Es bleibt das Muster Geldthema plus Härte bei Figuren mit nichtdeutsch klingenden Namen. Nach Punkt 19 sind Namen keine Herkunftsangabe, deshalb nur gering und als Hinweis für die Prüfung 27.
- Vorschlag: Eigenschaftswörter neutralisieren, etwa „unnachgiebig“ → „hält auf ihrem Anspruch“, „ungerührt“ → „sachlich“, „rachsüchtig“ → „ärgert sich lautstark“ (ohne Wertung).

### B6 · gering · Weinname als Farbe („bordeauxroter Blazer“)
- Stelle: `@R15-STAMM` (Signaturstück), `@LF-R15` (Anker, EN: „bordeaux red blazer“), `packages/pixel_engine/data/figuren/rollen.json`, Zeile 312 („bordeauxroter Blazer“).
- Regel: Alkohol „auch nicht als Andeutung“. Maßstab aus E49 (Weinrot wurde zu Beerenrot).
- Begründung: Bordeaux ist ein Weinname. Als Kleidungsfarbe ist es dasselbe Muster, das E49 für „Weinrot“ korrigiert hat. Gering, weil es eine Farbbezeichnung ist.
- Vorschlag: „beerenroter Blazer“ im Overlay für R15-STAMM und LF-R15 sowie im Merkmal von rollen.json.

### B7 · gering · Öffentliche Uhrzeit des Auffindens durch das Overlay ersetzt
- Stelle: ANPASSUNG Zeile 78, `@LISTE-ZEITEN`: „kurz nach Mitternacht wird der Burgwart in der Speisekammer gefunden und kommt zu sich“. Kanon v1.0 (`krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 29): „00:01 der Burgwart wird in der Speisekammer gefunden und kommt zu sich“. Außerdem `@OA-20 [O] | Zeit: 00:01` (K1, Zeile 52).
- Regel: Kanontreu (Maßstab sind die O-Datensätze).
- Begründung (neuer Grund gegen E44): E41 hat den v1.0-Wortlaut der Zeitliste übernommen. E44 ersetzt die einzige öffentlich genannte Minute des Auffindens, obwohl OA-20 selbst 00:01 nennt. Das ist eine Abweichung vom Kanon, kein Widerspruch.
- Vorschlag: „00:01 … kommt zu sich“ wieder einsetzen. Die Lösungszeiten (00:00:25 und 00:00:50) bleiben unberührt.

## 4. Abwägungen E23 bis E49 (Punkt 9a)

Bestätigt, nicht als Befund gezählt (kein neuer Grund):
- E23 und E29 (bewusstlos → benommen, ERSETZE-17): der wirksame Kanon enthält kein „bewusstlos“. Verletzung bleibt „Beule“, „benommen“, „Kühlpack“.
- E27 M5 (Kanon-Spuren zeigen auf die Täterin): Die neuen O-Spuren dieser Runde (BSO-01 und H-06 mit der fehlenden Stollen-Lücke, BW-AUSSAGE-3 mit „Gestricktes, Wolle“, Strickjacke bei R03, Strickpullover bei R04) sind O-Spuren und werden nach E27 M5 gewertet. Nur der Ergebnistext DW3-3 (B1) fällt nicht darunter.
- E27 H1 (Fähigkeit von R03 nur für R03 sichtbar), E27 M2, G3, G4, G5, G7, G11, E37 H1 (Kleinteile), E38 (Wanderstiefel aus zwei Teilen, bei R03 und R04 gleich), E39 (ungenutzte Teile), E40 (Dutt-Frisur), E41 (R04-Pullover, Notizbuch bei R03 entfernt), E42 (FM-1 nur als [L], „verwischt“), E43 (Himmel klar, Eisnebel nur im Tal, Ziffern in Texten, umgangssprachliche Wendungen), E45 (FM-1 in der Quelle als Nutzerentscheidung, Ortsliste, „Schatten im Nebel. Physik.“), E46 (Lampenmarke „VT · 3“, „Quelle des Schreis“).
- E31, E33, E34, E35, E36: Inhaltsrunden und Technik, keine offenen Punkte gegen die aktuellen Texte.
- E47: Ergebnistexte als Spieltext bestätigt, daher B1. Firmenname und Punsch in DW1-3 geprüft. Die Färbungen siehe B5.
- E48: Wurzeln gelöscht und Familienfelder umgestellt. Geprüft, Lücke siehe B3. Burgwart-Herkunft siehe B4.
- E49: Der Schlosskeller (content/party) liegt außerhalb des Prüfumfangs und ist nicht geprüft.
- E44 (Zeitliste) siehe B7 mit neuem Grund. E46 (Punschkessel) siehe B2 mit neuem Grund.

## 5. Geprüft ohne Befund
- Alkohol: keine Gaststätte, Bar, Wein, Bier oder Schnaps. Teestube, Bäckerei, Apotheke, Kräutertee und alkoholfreier Punsch (OA-04, OA-23, BW-ZUSTAND, FÜNF-SÄTZE, DW1-3, GL-14, erzaehler.json). „Fass“ nur als Gefäß (Wasser-, Mehl-, Kornfass), „bar“ nur als Zahlungsart, „Kater“ als Tier (Ausnahme laut `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`).
- Drogen: keine Treffer. Die Fehlalarme waren Pupillen, Rauch und Pfeifen.
- Verletzungen: keine Blutdetails, keine offenen Wunden. Das Opfer ist nur benommen und wird wieder wach (BW-ZUSTAND, OA-23).
- Okkultes: keine Hexe, kein Walpurgis, kein Teufel, kein Vampir, keine Fledermaus. Gespenst und Nebelriese sind Streich und Kanon-Legende. Beobachtung: Der Besen des Schornsteinfegers (Bewohner 16) und die Haus-Inschriften „Der Bock stößt …“ (haeuser.json) sind Volkssprüche und Hausschmuck, keine Andeutung im Sinne der Leitplanke.
- Herkunft: keine Herkunft als Motiv, Indiz oder Pointe, keine Bezüge zu Rumänien oder Roma. Biikebrennen (regionaler Brauch) bleibt als Kanon-Element. Die Familienfelder mit „Die Eltern leben in …“ nennen Wohnorte.
- Täterinnen-Nennung: keine außer B1. Stadt-, Haus- und Hinweistexte enthalten keine Merkmale der Täterin (Stiefel, Stollen, Strickjacke, Laken, Taler). Die Figurendaten sind konsistent: R03 mit strickjacke-zopf, bluse, wanderstiefel; R04 mit pullover, hemd, wanderstiefel; LF-R03 und LF-R04 stimmen damit überein.
- Zeiten: 23:52, 23:54, 23:56, 23:58, 00:01 bis 00:03 und 00:30 stimmen zwischen LISTE-ZEITEN, STADT-02 und STADT-05 sowie den Aussagen von R03, R11 und R01 überein. In den Bewohner-Nachtplänen steht nur noch 00:30, kein 00:25 mehr.
- Wetter: Himmel klar über der Burg, Eisnebel nur im Tal und auf dem unteren Burgweg (K-002, OA-27, erzaehler.json: „Unten im Tal steht der Nebel dicht.“). Die Nebel-Stellen der Bewohnertexte sind stichprobenhaft Legende, Redensart oder Tal-Bezug.
- Bekannte Werke: keine Figuren, Titel oder Zitate aus bekannten Krimis, Märchen, Liedern, Filmen oder Spielen gefunden (Musterliste: Sherlock Holmes, Christie, Tatort-Figuren, Märchen, Kinderlieder, Film-Vampire). Der Track-Titel „Geisterstunde“ und das Gattungswort „Tatort“ sind kein Befund. Ein externer Abgleich fand nicht statt.

## 6. Hinweise, nicht gezählt
- FM-1 im Kanon-Quelltext (L) nennt Herkunftsgruppen (deutsch, bosnisch, kurdisch, polnisch, türkisch). Der Eintrag ist Lösungsdatensatz und nicht Spieltext (E45, Nutzerentscheidung). Die Verteilung der belasteten Funktionen (Täterin, falsche Fährte, Zeugin) folgt weiter den Rollen mit nichtdeutsch klingenden Namen. Nach Punkt 19 sind Namen keine Herkunftsangabe. Das ist Sache der Prüfung 27.

Leitplanken eingehalten: nein · Kanontreu: ja · Plagiatsfrei: ja
