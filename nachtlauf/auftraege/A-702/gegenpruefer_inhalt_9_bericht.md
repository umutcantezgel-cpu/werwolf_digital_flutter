HEAD bf22e49

# Gegenprüfung Inhalt, Runde 9 (A-702j)

Geprüfter Stand: `HEAD bf22e49` (nach Schritt 0: Fast-Forward von fb0ec24 auf nachtlauf/burgstadt). Keine Daten geändert, kein Commit, kein Push, kein Build. Frühere Berichte unter nachtlauf/auftraege/A-702/ nicht gelesen.

## Urteil

- Leitplanken eingehalten: **nein** (Befund B1, mittel)
- Kanontreu: **nein** (Befund B2, gering)
- Plagiatsfrei: **ja** (keine konkrete Kopie gefunden; Hinweise 6 bis 8)
- Befunde: hoch 0 / mittel 1 / gering 1. Hinweise: 17.

Der Scanner (`dart run bin/leitplanken.dart --burgstadt`, 119 Dateien inklusive K-Dateien und ANPASSUNG) meldet 0 Treffer. Er erkennt keine Herkunftsklischees in Sätzen und keine Andeutungen. Die Befunde stammen aus der manuellen Lektüre.

## Befunde

### B1 · mittel · Leitplanke „keine Klischees über … irgendeine andere Gruppe“ · Herkunfts-Folklore als Muster

- **Datei und Stellen** (öffentliche O-Datensätze, Feld Familie): `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-KERN.md` Z. 7 (R01); `K2-ROLLEN-05-12.md` Z. 7 (R05), 16 (R06), 25 (R07), 34 (R08), 43 (R09), 70 (R12); `K2-ROLLEN-13-20.md` Z. 7 (R13), 16 (R14), 25 (R15), 34 (R16), 52 (R18), 61 (R19).
- **Zitate:** R01 „sonntags gibt es bei den Eltern Pita und lange Telefonate mit der Verwandtschaft“ · R05 „sonntags falten die drei Frauen am Küchentisch Pierogi“ · R06 „Zum Newroz-Fest im März trifft sich die ganze Familie“ · R07 „Vom Großvater, der abends auf der Bağlama spielte“ · R08 „Zum Bajram kocht die Großmutter für die halbe Verwandtschaft“ · R09 „die Mutter kocht an Heiligabend für die Wigilia die zwölf traditionellen Gerichte“ · R12 „Sonntags gibt es bei den Eltern Kaffee aus der Džezva“ · R13 „Die Großmutter Nermin … backt jeden Freitag Revani für die halbe Straße“ · R14 „An Wigilia, dem Heiligabend, lässt die Familie ein Gedeck frei“ · R15 „Sonntags macht der Vater zum Frühstück Menemen“ · R16 „Bei Familienfesten singt seine Großmutter alte Sevdalinke“ · R18 „schlichtet jeden Familienstreit „wie ein Gericht““ · R19 „Zu Newroz im März fährt die ganze Familie zum Fest“.
- **Muster:** 12 Rollen nichtdeutscher Wurzeln haben ein benanntes Fest, eine Speise, ein Instrument oder Gericht als Familienmerkmal (R01, R05–R09, R12–R16, R19). 3 weitere haben ein Großmutter- oder Familienfest-Motiv (R02, R18, R20). Nur R11 hat keinen Marker. Die vier Rollen deutscher Wurzeln (R03, R04, R10, R17) haben kein benanntes Herkunftsmotiv; R10 nennt nur den regionalen Brauch „Biikebrennen“ (K2-ROLLEN-05-12.md Z. 52).
- **Regel:** keine Klischees über Gruppen. Die Einzelangaben sind nicht herabsetzend und individuell formuliert. Die Zuordnung „nichtdeutsche Wurzeln → Fest, Speise, Großmutter, große Verwandtschaft“ wiederholt sich aber systematisch; das ist Folklorisierung im Sinn des Klischees. Nach dem Maßstab von E29 (B2: ein einseitiges Muster „Angst nur bei Frauen“ war dort ein Befund) zählt das Muster als Verstoß. Das Entscheidungslog enthält zu Herkunft und Familie keine Abwägung (Suche nach Wurzeln, Familie, Klischee, Herkunft). E27 G4 betrifft nur das Kopftuchteil, E34 B-2 nur Altersgruppen.
- **Vorschlag:** Familienfelder der betroffenen Rollen ohne herkunftsgebundene Speisen, Feste, Instrumente, Großmutter-Autorität und „halbe Verwandtschaft/Straße“ neu fassen; das Feld „Wurzeln“ als Datum belassen. Der Kanon ist verbindlich. Die Änderung geht nur per ANPASSUNG-Overlay (gleiche ID, Feld Familie ersetzen) oder durch die Kanon-Verantwortlichen. Zusätzlich die Kopplung Herkunft → Beruf prüfen (Polen: Koch R09, Tischler R14; Bosnien: Veranstaltungstechnik R01, Statik R12; Türkei: Bankberatung R13, Versicherung R15, Jura R18).

### B2 · gering · Kanontreu · Schuhteile R03 und R04

- **Datei:** `packages/pixel_engine/data/figuren/karten.json`, Einträge R03 und R04, Feld `teile`: je `schuhe-stiefel` und `schuhe-arbeitsschuhe`.
- **Kanon:** `K2-ROLLEN-KERN.md` Z. 25 (R03) und Z. 34 (R04), Feld Kleidung [O]: „braune Wanderstiefel (Sonderangebot)“. `rollen.json` führt für beide `"typ": "wanderstiefel"`. Die Laufzeit lädt `karten.json` (`burgstadt_spiel_io.dart`). Die Übergangslogik in `figuren_lager.dart` setzt für Wanderstiefel nur `schuhe-stiefel`.
- **Regel:** Kanontreu (Kleidung nach O-Datensatz).
- **Vorschlag:** `schuhe-arbeitsschuhe` bei R03 und R04 entfernen. Die Teil-Geometrie liegt im Dart-Code und wurde nicht gerendert; daher nur „gering“.

## Hinweise (kein Befund)

1. **Seil- und Knoten-Motiv:** B44 Seiler (`bewohner.json` Z. 2695–2700: „Ein Seil für die Wäscheleine?“, „bindet einen Knoten“, „Du kannst daran ziehen“); H-034 („Ein Knoten hält, wo zwei sich lösen“, Z. 439–440; Seilerschaft vom dritten Stock); H-087 (Z. 1103); H-124 (Z. 1567); Innenräume „Seilerei“, „Seilwinde“, „Hakenwand“. Kein Text zu Strangulation, nur Anklang. E34 hat nur das Wort „Strang“ geändert. Empfehlung: Motiv ausdünnen.
2. **Gerücht gegen eine Frau:** B09 `gerede` (Z. 558): „das liege an der Tierärztin“. Falsche Fährte gegen Unschuldige; keine Täterinnen-Nahelegung, weil das Merkmal der Täterin (R03) nicht übernommen ist.
3. **Schornstein-Scherz:** B17 `gerede` (Z. 1038): „durch einen Kamin passt höchstens ein Schornsteinfeger, und der ist ja hier“; dazu Kehrbesen als Zubehör. Hexenbild-Anklang, kein Hexenbezug.
4. **Kräuter „beruhigt“:** B31 Z. 1874 „Nimm Melisse, die beruhigt.“ Kein Drogenbezug.
5. **Doppelsinn:** B33 Z. 1994 „Er vermisst den Schuss“ (Webfachbegriff); H-040 Z. 519 „Schuss und Kette“.
6. **Liedtitel als Hausname:** H-019 „Haus zum Lindenbaum“ (Z. 244); B15 `gerede` (Z. 918) „Heimtür vom Lindenbaum“. Generischer Hausname, kein Liedzitat.
7. **„Einspruch!“:** `rollen.json` Z. 369 (Anstecker R18) und K2-ROLLEN-13-20.md Z. 52 (R18 Sprechweise, Ausruf). E27 G3 bleibt bestehen. Die Nähe zu einer bekannten Anwaltsserien-Formel ist ein Anklang; allgemeines Gerichtswort mit Kanonwortlaut, daher kein Kopierbefund.
8. **Marke im Spiel:** R11 „Saturn-Aufnäher“ (`rollen.json` Z. 236; Kanon LF-R11). Keine Kopie, aber ein Markenname.
9. **Kleidungstyp gegen Teil (2,5D):** karten.json: R05 (Cordblazer), R13 (Hosenanzug-Jacke), R15 (Blazer), R16 (Sakko) → `oberteil-uniformjacke`; R06 (Funktionsjacke), R07 und R19 (Lederjacke), R11 (Daunenjacke) → `oberteil-arbeitsjacke`; R17 (Lederhut) → `kopf-filzhut` (E29 B9 bleibt). Renderprobe empfohlen.
10. **Frisur:** R10 „Pixie-Schnitt“ (LF-R10) gegen `frisur-kurz-wuschel` in karten.json.
11. **Strickjacke:** R03 trägt laut Kanon eine grüne Strickjacke; die Spur „Strickjackentasche“ steht in einer O-Zeile. karten.json gibt neun Bewohnern `oberteil-strickjacke` (B08, B09, B17, B20, B23, B28, B29, B30, B31). Nur die Farbe unterscheidet; Materialfarbe nicht geprüft.
12. **Rollenwort „Hausfrau“:** H-054, H-059, H-083, H-113, H-117, H-125, H-127 (Feld `geschichte`). Geschlechter-Anklang, kein Befund.
13. **Geräte-Tipp:** `erzaehler.json` Z. 109 „Tipp: Mit Umschalt rennst du.“ steht im geräteneutralen Tippspeicher. Analog zu E34 (T02) prüfen.
14. **Wachs:** „Kerzen aus Talg“ (H-108, Z. 1368), „Talglichter“ (H-125, Z. 1580), „Talgkessel“ (innenraeume/haeuser.json, innen-laden-5, Kerzenzieherei) neben dem Bienenwachs-Hinweis (K-004, BSO-09, R17). Abstimmen.
15. **Konsistenz Häuser:** H-045 spricht von „Die Gerberin“ (Z. 584), einziger Bewohner ist B29. H-046 nennt „Der Maler“ (Z. 598), Bewohner B27 ist Grafikerin.
16. **Ungenutztes Teil:** `kopf-kopftuch` (teile_koepfe.json) wird von keiner Karte benutzt (E27 G4 bestätigt). Nicht einsetzen.
17. **bewusstlos:** ERSETZE-17 erfasst die öffentlichen Zeilen K1 OA-20 (Z. 52) und K2 BW-ZUSTAND (Z. 54). Weitere Vorkommen sind Lösungs- oder Geheimzeilen bzw. Entwürfe (`10_kanon/entwuerfe/`), nicht im Spieltext-Bestand. Keine Schreibvarianten (Großschreibung, „Bewusstlosigkeit“) in Spieltexten gefunden.

## Bestätigte Abwägungen (kein Befund)

- E23 und E27 M5 (Kanon-Spuren zur Täterin): bestätigt; die Zusatztexte enthalten keine Täterinnen-Nahelegung (Hinweis 2).
- E27 H1 (R03 „Spur verwischen“ nur für R03 sichtbar): bestätigt.
- E27 M2 (Teile im Code): bestätigt; `karten_test` prüft die Teile.
- E27 G3 („Einspruch!“): bestätigt (Hinweis 7). E27 G4 (Kopftuch): bestätigt (Hinweis 16).
- E29 B1 (ERSETZE-17) und B9 (Lederhut): bestätigt (Hinweise 9, 17).
- E33 (Stollen, Absatz, Sohle): im Bestand nicht mehr vorhanden (geprüft).
- E34 B-1 (Zeitangaben in O-Aussagen gehören zu LISTE-ZEITEN): bestätigt. B-2 (Altersgruppen): keine Gruppenaussage mehr gefunden.
- E35 (B09 „Der Hund wollte heute nur nicht allein sein.“, Z. 554): verifiziert.
- E37 (Kleinteile H1; Kameragurt und Kopfhörer als Teile): verifiziert (karten.json R19 `kamera`, `kameragurt`; R02 `kopfhoerer`).
- Kanon-Konsistenz geprüft: Uhrzeiten (LISTE-ZEITEN), Orte (LISTE-ORTE), Alkohol (Punsch durchweg alkoholfrei), Stadttore (22:00), Strom (erst am Morgen), Alter, Geschlecht und Namen der Rollen, Summen (3.800 Euro bei OA-03, höchstens 600 Euro bei ORT-04), Zustand des Burgwarts.

## Prüfumfang

- Vollständig gelesen (alle Einträge): `packages/burgstadt_core/data/stadt/bewohner.json` (44 Bewohner, 2703 Zeilen), `stadt/haeuser.json` (160 Häuser, 2013 Zeilen), `rollen/faehigkeiten.json` (R01–R20), `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json`, `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `nachtlauf/kanon/ANPASSUNG.md`, `krimidinner/spuk-im-gewoelbe/10_kanon/FORMAT.md`, ENTSCHEIDUNGSLOG E23, E27, E29, E31, E33, E34, E35, E37.
- Alle Textfelder per jq geprüft: `innenraeume/haeuser.json` und `fallorte.json` (Namen, Stationen, Objektlegenden; ASCII-Raumkarten und Maße ohne Textinhalt), `karten.json` (Namen, Teile), `teile_kleidung.json` und `teile_koepfe.json` (Kennungen, ohne Textinhalt).
- Kanon-Maßstab: alle O-Zeilen der Figuren (STAMM, ÖFFENTLICH, LF), K8- und K9-O sowie die von den Spieltexten referenzierten OA-, BSO-, K-, LA-, GL- und LR-Zeilen. Nicht vollständig gelesen: K3-Hinweistexte (O), K5-Entscheidungen und K6. Diese nur gezielt auf referenzierte Kennungen und Widersprüche geprüft. L-Zeilen wurden nicht zitiert.
- Plagiat: Musterprüfung auf Liedtitel, Filmfiguren, Catchphrases und Marken; keine externe Recherche.
- Nicht geprüft: Build, Laufzeit, Renderbild.

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
