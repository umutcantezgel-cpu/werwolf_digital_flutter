# Gegenprüfung Inhalt, sechste unabhängige Runde · Auftrag A-702g

Stand: Worktree `agent-abbebfe589929a044`, HEAD `793bb1e` (Schritt 0 `git merge --ff-only nachtlauf/burgstadt` ausgeführt). Keine Daten geändert, kein Commit, kein Push, kein Build. Einzige angelegte Datei ist dieser Bericht.

## Ergebnis in Kürze

- Harte Leitplanken (Alkohol, Drogen, Herkunft, Verletzung, Hexen/Teufel/Walpurgis, Film- und Serienfiguren, Täterinnen-Hinweis) sind eingehalten. Ein Klischee-Befund über Altersgruppen (B-2, gering) verletzt die Leitplanke „keine Klischees über … irgendeine andere Gruppe“. Deshalb Leitplanken: nein.
- Die Spieltexte geben die öffentlichen Kanon-Fakten (O) inhaltlich korrekt wieder. Die geschlossene Liste LISTE-ZEITEN erfasst aber nicht alle Uhrzeiten aus den O-Zeilen (B-1, mittel). Deshalb Kanontreu: nein.
- Plagiat: keine Befunde. Plagiatsfrei: ja.
- Befunde: hoch 0 · mittel 1 · gering 1. Zusätzlich neun Hinweise ohne Regelverstoß (Abschnitt „Hinweise“).

## Befunde

### B-1 · mittel · Uhrzeiten außerhalb der geschlossenen Liste LISTE-ZEITEN

- Hauptstelle: `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-05-12.md`, Zeile 44 (R09-ÖFFENTLICH), und `packages/burgstadt_core/data/rollen/faehigkeiten.json`, Zeile 193 (R08: „Die Antwort kommt aus R09-ÖFFENTLICH“).
  - Zitat (O): „Um 23:50 geht er nach der Torte sehen, kommt um 23:51 auffällig schweigsam zurück“.
- Weitere Stellen mit Uhrzeiten außerhalb der Liste (alle O):
  - `K3-HINWEISE.md`, Zeile 43 (H-23, Schadenszettel, Erzähler): „Handschlag 23:30“. `K2-ROLLEN-KERN.md`, Zeile 57 (BW-AUSSAGE-2): „Erledigt, mit Handschlag, halb zwölf.“
  - `K3-HINWEISE.md`, Zeile 27 (H-07, Rückseite des Code-Zettels, nach BSO-04 öffentlich lesbar): „23:57 Track ▶ · 23:58 Hebel … 0:02 Licht + Torte“.
  - `K2-ROLLEN-13-20.md`, Zeile 53 (R18-ÖFFENTLICH): „Um 23:40 hält sie Adnan einen Vortrag“. Zeile 62 (R19-ÖFFENTLICH): „um 23:52“. Zeile 35 (R16-ÖFFENTLICH): „Um zwölf nach zwölf“.
  - `K2-ROLLEN-KERN.md`, Zeile 26 (R03-ÖFFENTLICH, Alibi): „um zehn vor zwölf“.
  - `K1-GRUNDWAHRHEIT.md`, Zeile 64 (K-010): „die Aushilfe ist um 18:00 gegangen“.
  - `K1-GRUNDWAHRHEIT.md`, Zeilen 33–61 (OA-Zeilen, Feld „Zeit:“): 16:30, 17:35, 19:00, 21:00, 21:20, 22:05, 23:52, 23:56, 23:58, 00:01 bis 00:20 u. a.
- Umfang: rund 25 verschiedene Uhrzeiten außerhalb der Liste. LISTE-ZEITEN enthält nur 14 Uhrzeiten (17:40, 20:30, 21:15, 21:35, 22:00, 22:45, 23:00, 23:35, 23:48, 23:54, 00:25, 01:30, 03:00, 04:30; `K1-GRUNDWAHRHEIT.md` Zeile 29 und `ANPASSUNG.md` Zeile 65).
- Regel: `FORMAT.md`, Abschnitt K1: LISTE-ZEITEN ist eine „geschlossene Liste“. „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen.“
- Einordnung: Das ist keine Übertragungsfehler des Spiels, sondern eine Lücke im Kanon, denn die O-Zeilen selbst nennen die Zeiten. E29 (B3) hat LISTE-ZEITEN nur um die Stadtzeiten ergänzt. Die Kanonzeiten behandelt keine der Entscheidungen E23 bis E33. Offen ist nur die Auslegung, ob behauptete Alibi-Zeiten als Aussagen gelten. FORMAT sagt das nicht ausdrücklich.
- Vorschlag: LISTE-ZEITEN per Overlay um alle O-Uhrzeiten ergänzen, oder FORMAT ausdrücklich klarstellen, dass Zeiten in behaupteten Alibis und Beweisstück-Texten Aussagen sind und zulässig bleiben. Danach die Zeitangaben in den Spieltexten erneut prüfen.

### B-2 · gering · Klischee über Altersgruppen

- Stellen:
  - `packages/burgstadt_core/data/stadt/haeuser.json`, Zeile 246 (H-019 „Haus zum Lindenbaum“): „die alten Leute reden dort seit Jahren über das Wetter“.
  - `packages/burgstadt_core/data/stadt/haeuser.json`, Zeile 1910 (H-152 „Haus zur Steinbank“): „auf der die Alten abends sitzen … Sie reden über das Wetter und die alte Zeit, mehr nicht.“
  - `packages/burgstadt_core/data/stadt/bewohner.json`, Zeile 915 (B15 Vera Kessler, saetze): „Wenn du mit einer Alten sprichst, sprich langsam und laut. Die Ohren sind alt, das Gedächtnis manchmal jung.“
  - `packages/burgstadt_core/data/stadt/bewohner.json`, Zeile 789 (B13 Rosa Teutsch, saetze): „Die Jugend rennt heute, als hätte sie Eile, und keiner weiß wohin.“
- Regel: Auftrag Punkt 4: „keine Klischees über … irgendeine andere Gruppe“. Die Stellen verallgemeinern über Altersgruppen (Alte: schwerhörig, vergesslich, reden über das Wetter; Jugend: hektisch).
- Vorschlag: Als konkrete Personen formulieren (z. B. „Die beiden Nachbarn auf der Bank …“). B15 als persönliche Eigenheit einer Figur. B13 auf eine konkrete Person beziehen.
- Abgrenzung: Kein Befund zu Herkunft oder Geschlecht (siehe Hinweis H-1).

## Hinweise (keine Befunde, kein Regelverstoß)

- H-1 · Geschlechtermuster bei Klatsch-Merkmalen. Bei einer groben Stichwortzählung (neugierig, laut, klatsch, tratsch, redselig, erzählt jedem) tragen 8 von 21 Bewohnerinnen, aber 4 von 23 Bewohnern solche Merkmale (`bewohner.json`, Felder wesen, saetze, gerede, tut). Einzelstellen: B16 (wesen: „Neugierig und ein wenig laut …“; gerede: „sie ruft jeden, der nicht pünktlich zum Kaffee kommt“), B05 (saetze: „frag laut und deutlich“). Das sind Einzelfiguren ohne Gruppenaussage, deshalb kein Befund. Empfehlung: Merkmale zwischen den Geschlechtern ausgewogener verteilen, wie E29 (B2) es für die Angst-Sätze getan hat.
- H-2 · Entscheidung E33 nicht umgesetzt. E33 meldet „H-059 ohne Zinnen-Zählmotiv“. In `stadt/haeuser.json`, Zeile 766, steht aber weiterhin: „Die Hausfrau zählt sie jeden Morgen beim Kaffee“ (die Zinnen). Das ist ein Anklang an die einzige Empfangsstelle der Burg (K-002, „dritte Zinne“). Text oder Log korrigieren.
- H-3 · Angst-Motiv, Anklang an die öffentliche Angst im Dunkeln (R03-ÖFFENTLICH). `bewohner.json`, Zeile 554 (B09): „Der Hund hatte nur Angst vor dem Dunkel.“ `stadt/haeuser.json`, Zeile 826 (H-064): „weil sie das Dunkel fürchtet“. `stadt/haeuser.json`, Zeilen 1541/1542 (H-122): „Der Hase hat Angst …“ und in derselben Beschreibung „Die Bewohnerin sagt …“ (Bewohnerin B41). E29 hat B09 bewusst belassen. Die Kombination Angst-Motto und Bewohnerin in H-122 wirkt nach der Logik von E29 (B2) unglücklich.
- H-4 · Strick-Anklang. `stadt/haeuser.json`, Zeile 439 (H-034, Inschrift): „Ein Strang hält, wo zwei sich lösen“ spielt mit dem Doppelsinn „Strang“ (Strick). E33 hat bei B44 eine „Strick“-Anspielung entfernt. `bewohner.json` B44 (saetze) bleibt bei „Seil“ und „Knoten“. Empfehlung: die Inschrift von H-034 angleichen.
- H-5 · Doppeldeutige Wörter. `stadt/haeuser.json`, Zeile 814 (H-063): „aus einer Brennerei am Mauerweg“ meint eine Ziegelbrennerei. Im Kontext eindeutig, aber „Brennerei“ hat im Deutschen auch die Bedeutung Schnapsbrennerei. Empfehlung: „Ziegelbrennerei“. Zeile 1468 (H-116): „Herberge für Bergleute“ ist eine historische Gaststätten-Form mit Übernachtung, ohne Alkoholbezug. Kein Befund.
- H-6 · Zeitangabe im Erzählertext. `bewohner.json`, Zeile 1262 (B21): „Sie schläft seit elf im Bett“. Das Feld `tut` wird als Erzählertext ausgegeben (`packages/burgstadt_core/lib/src/fall/simulation.dart`, Zeilen 218–219). 23:00 steht in LISTE-ZEITEN, daher formal knapp zulässig. Empfehlung: zusammen mit B-1 lösen oder „seit dem Glockenschlag“ schreiben.
- H-7 · Uhr-Requisit. `bewohner.json`, Zeile 82 (zubehoer) und Zeile 113 (tut, B02): „die Taschenuhr auf dem Bauch“. E27 (M1) hat eine erfundene Taschenuhr bei R04 entfernt, weil der Kanon keine solche Uhr nennt. Konsistenz prüfen.
- H-8 · Signaturstück R17 nicht dargestellt. O-Zeile R17-STAMM (`K2-ROLLEN-13-20.md`) nennt einen „brauner Lederhut mit einer blau gebänderten Eichelhäherfeder“. `figuren/karten.json`, Zeile 20: R17 trägt `kopf-filzhut`, keine Feder. E29 (B9) hat nur den Hutstoff als 2,5D-nicht unterscheidbar bewertet, die fehlende Feder nicht. Entscheidung dokumentieren.
- H-9 · „den Rest erzählt mir heute niemand“ (`ANPASSUNG.md`, Zeile 134, H-S22, O). Im Kontext keine Andeutung weiterer Verletzungen, aber der Doppelsinn zu „Verletzung nur Beule“ lässt sich leicht vermeiden.

## Geprüft ohne Befund

- Scanner: `dart pub get --offline` erfolgreich. `dart run bin/leitplanken.dart --burgstadt`: „Geprüfte Dateien: 119 · Summe: 0 Treffer · 0 Fehler · 0 Warnungen“, Exit 0. Der Scanner findet keine Andeutungen, Herkunftsbezüge oder Zeitpunkte. Diese Punkte habe ich von Hand geprüft.
- Alkohol und Drogen (auch Andeutung): keine Treffer für Bier, Wein, Schnaps, Likör, Glühwein, Sekt, Met, Kneipe, Schenke, Wirt. Gläser, Krüge und Fässer enthalten Wasser, Tee, Öl, Regenwasser oder Vorräte. Punsch ist überall alkoholfrei (`erzaehler.json`; K1 OA-04; K8 GL-14; K9 LA-02). Gaststätten sind Teestube, Bäckerei und Apotheke.
- Verletzung: nur „Beule“, „benommen“, „Kühlpack“. ERSETZE-17 (bewusstlos→benommen) greift im Spiel. Keine Vorkommen von „bewusstlos“ außerhalb der Ersetzung. Keine Wunde, kein Blut, keine Leiche. Das Entwicklerfeld von R06 ist ohne Bewusstlosigkeit formuliert.
- Hexen, Teufel, Walpurgis, Film-Vampire: keine Treffer (u. a. Hexe, Teufel, Dämon, Zauber, Spuk, Vampir, Nosferatu, Dracula, Orlok).
- Herkunft: Die Wurzel-Angaben der Rollen (K2) erscheinen im Spieltext nicht. Namen wie „HODŽIĆ VT · 3“ sind Name und Betriebsaufschrift (BSO-03), kein Herkunftsindiz. Keine Herkunftsklischees. Das Kopftuch-Teil (`teile_koepfe.json`) ist von keiner Figur verwendet (E27-G4 bestätigt).
- Täterinnen-Hinweis: Stadt- und Spieltexte enthalten keine Merkmale der Lösungsrolle als Hinweis (keine Stiefel, Stollen, Strickjacke oder Haarspange, keine Verirrungs-Echos; E27-G10 hat sie entfernt). Anklänge stehen unter H-3. Die Lösungsrolle wurde nur aus dem L-Teil zur Widerspruchsprüfung herangezogen und nicht zitiert.
- Plagiat: Stichprobe von rund 60 Namen und Begriffen aus Film, Serie, Spiel und Buch (u. a. Holmes, Watson, Harker, Frankenstein, Dracula, Hogwarts, Gandalf, Sherlock, Poirot). Keine Treffer, keine bekannten Zitate. Brauchtum wie „Glück auf“, „Geleucht“ oder der Track-Name „Geisterstunde“ ist kein Kopierfall.
- Figuren (`pixel_engine/data/figuren`): `karten.json` mit 66 Karten (BW, DET, R01–R20, B01–B44), `rollen.json` mit 21 Figuren. Namen, Alter und Geschlecht stimmen mit den O-Zeilen überein. Die Teiledateien enthalten keinen Freitext. Die Kombination `schuhe-stiefel` plus `schuhe-arbeitsschuhe` ist im Test als Wanderstiefel definiert (`packages/pixel_engine/test/karten_test.dart`, Zeile 13), also kein Befund.
- Stadt-Kanon: Tore 22:00, Uhrturm 00:25/01:30/03:00/04:30, Bäckerei ab 03:00, Stromausfall-Kette, Ersatzsicherungen, Stadtwerk aus Silberhau, Pension mit Zimmer 7 und Wäschezeichen, Schreinerei mit 600 €, Stadtmuseum-Leihgabe, dunkle Laterne der Teestube, Kühlpacks vorn in der Apotheke. Alles konsistent mit O.
- Begriffsersetzungen aus `ANPASSUNG.md` (Brockengespenst, Harz, Silberhauer, Nationalpark, bewusstlos): keine Reste in den Spieldaten. Einziger Fund ist das Entwicklerfeld „Gespenst“ in R07, das laut Kanon zulässig ist.
- Innenräume (`innenraeume/fallorte.json`, `innenraeume/haeuser.json`): nur Namen und Objekte, keine Stationen und keine Hinweise.
- Entscheidungslog E23, E27, E29, E31, E33: Die dort als entschieden genannten Punkte habe ich nicht als Befund gewertet (u. a. Kanon-Spuren, Fähigkeit R03, Teile im Code, „Einspruch!“, Stadtnamen in LISTE-ORTE). Ausnahmen sind die Abweichungen H-2 und H-4.

## Abnahme (Auftrag Punkt 10)

- Vollständig gelesen: `nachtlauf/kanon/ANPASSUNG.md` (141 Zeilen), `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`, `krimidinner/spuk-im-gewoelbe/10_kanon/FORMAT.md`, alle [O]-Zeilen aus K1, K2 (drei Dateien), K3-HINWEISE.md, K5 (DETEKTIV, MECHANIK), K6, K7, K8 und K9. `nachtlauf/ENTSCHEIDUNGSLOG.md`, E23 bis E33. Scanner-Quelltext (`lib/src/pruef/leitplanken.dart`, Regeln, Ausnahmen, Dateiauswahl).
- Spieldaten: `rollen/faehigkeiten.json` (20 Rollen), `innenraeume/fallorte.json` (12 Bereiche, vollständig), `innenraeume/haeuser.json` (30 Bereiche, Namen und Legenden; die Zeichenraster nicht einzeln), `stadt/bewohner.json` (44 Einträge, alle Felder), `stadt/haeuser.json` (160 Häuser, alle Felder), `packages/burgstadt_spiel/data/texte/erzaehler.json`, `tutorial.json`, `pixel_engine/data/figuren/karten.json`, `rollen.json`, `teile_kleidung.json`, `teile_koepfe.json` (Struktur und alle Zeichenketten; Geometriezahlen nicht einzeln).
- Nicht als Maßstab gelesen: K3-HINWEISE-KERN und K3-HINWEISE-P1 bis P3, K4-Dateien und K5-ENTSCHEIDUNGEN-Dateien. Sie enthalten nur G- und L-Zeilen. L-Zeilen habe ich nur zur Widerspruchsprüfung herangezogen und nicht zitiert.
- Frühere Berichte unter `nachtlauf/auftraege/A-702/` nicht gelesen (nur Existenz des Ordners festgestellt).

## Urteil

Die Leitplanken sind bei allen harten Verboten eingehalten. Der Klischee-Befund B-2 ist gering, aber ein Regelverstoß und behebbar. Der Kanon ist inhaltlich korrekt wiedergegeben, verletzt aber die eigene Regel zur geschlossenen Zeitliste (B-1). Plagiatsfrei.

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
