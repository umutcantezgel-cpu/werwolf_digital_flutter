HEAD 2e459d4

# Gegenprüfung Inhalt · Auftrag A-702k (Runde 10)

Geprüfter Stand: `HEAD 2e459d4`, nach `git merge --ff-only nachtlauf/burgstadt` (fb0ec24..2e459d4, Fast-forward). Worktree danach sauber. Keine Berichte aus `nachtlauf/auftraege/A-702/` gelesen (nur Verzeichnisnamen gesehen).

## 1. Vorgehen und Abnahme

- **Testbefehl:** `dart` ist nicht im PATH; genutzt wurde `/opt/flutter/bin/cache/dart-sdk/bin/dart` (3.13.5). `pub get --offline`: ok. `bin/leitplanken.dart --burgstadt`: **Geprüfte Dateien 119 · 0 Treffer · 0 Fehler · 0 Warnungen · Exit 0.** Der Scanner findet keine Andeutungen; die folgende Lesung ist die eigentliche Prüfung.
- **Vollständig gelesen (Texte und IDs):**
  - `stadt/bewohner.json`: B01–B44 (Texte, Nachtpläne, Gerede).
  - `stadt/haeuser.json`: H-001–H-160 (Inschriften, Geschichten, Bewohner).
  - `innenraeume/fallorte.json`, `innenraeume/haeuser.json`: Raum-, Objekt- und Stationsnamen, Türziele. Textur-, Licht- und Maßwerte nur auf Auffälligkeiten gesichtet.
  - `rollen/faehigkeiten.json`: R01–R20 (Wirkung, Sichtschicht, Quellen).
  - `burgstadt_spiel/data/texte/erzaehler.json`, `tutorial.json`: vollständig.
  - `pixel_engine/data/figuren/karten.json` (66), `rollen.json` (21), `teile_kleidung.json` (35), `teile_koepfe.json` (38): alle Texte, Namen, Teil-IDs. Zahlenwerte (Größe, Palette, Geometrie) nicht inhaltlich geprüft, nur auf Kanon-Merkmale abgeglichen.
  - `nachtlauf/kanon/ANPASSUNG.md`: vollständig (158 Zeilen).
  - Kanon `krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: **alle O-Zeilen** (Maßstab; K1 56, K2 48, K3 36, K5 22, K6 4, K7 7, K8 22, K9 28) sowie ANPASSUNG-O-Zeilen. L- und G-Zeilen nur gezielt (Widerspruchs- und Herkunftsprüfung), nicht zitiert.
  - `nachtlauf/ENTSCHEIDUNGSLOG.md`: E23, E27, E29, E31, E33, E34, E35, E37, E38 (Zeilen 147–339).
- Keine Daten geändert; kein Commit, kein Push, kein Build. Zwischenextrakte nur im Scratchpad.

## 2. Bereits entschiedene Abwägungen (9a)

- **E23** (BW-ZUSTAND „bewusstlos“ → Overlay „benommen“): akzeptiert. Kein „bewusstlos“ in Daten oder Spielcode außer im Test `kanon_test.dart`. R06 sagt „kurz benommen“.
- **E27** (M5 Kanon-Spuren; H1 R03 „Spur verwischen“ nur für R03; M2 Teile im Code; G3 „Einspruch!“; G4 Kopftuch; H2 LISTE-ORTE nur Farbe): akzeptiert. G4 geprüft: `kopf-kopftuch` wird von keiner Figur genutzt. Zu `frisur-afro` siehe B-10.
- **E29** (B1 benommen; B2 Angst-Sätze; B3 LISTE-ZEITEN; B9 Lederhut/Filzhut R17): akzeptiert.
- **E31** (B38 ohne Saum, B35 „früh am Morgen“): akzeptiert, Texte bestätigt.
- **E33** (Schuhmacher ohne Sohle/Absatz, Seiler ohne Strick, „Stollen“→„Schacht“, Laternen als Kerzenlaternen): akzeptiert. In Stadttexten keine Sohle, kein Absatz, kein Stollen mehr.
- **E34** (B-1 Uhrzeiten als Kanon-Lücke, B-2 Altersgruppen auf konkrete Personen, Korrektur H-059, B02 eigene Taschenuhr): akzeptiert. Zu B-07 siehe unten.
- **E35** (B09 „Der Hund wollte heute nur nicht allein sein.“, Gemüsefass, Wehrgang): akzeptiert.
- **E37** (B2, B3, B4, H5, H6; offen B1 Kameragurt R19, B5 Kopfhörer R02): akzeptiert. B1 und B5 sind inzwischen in `karten.json` enthalten.
- **E38** (B1 Familienfelder per Overlay; Großmutter, Biike, Masuren bleiben; B2 Wanderstiefel aus zwei Teilen; Erzählertipp „geräteneutral“; H-045; Talg): Overlay-Zählung bestätigt: 12 nichtdeutsche Rollen mit benanntem Fest, Speise oder Instrument (R01, R05–R09, R12–R16, R19). Offen blieben R02, R11, R18, R20 ohne benanntes Element. Das Feld „Familie“ wird im Code nicht gelesen (kein Zugriff in `burgstadt_core`). Widerspruch nur bei B-02 und B-08, jeweils mit neuem Grund.

## 3. Befunde

**Hoch: 0 · Mittel: 0 · Gering: 11**

**B-01 · gering** · `stadt/haeuser.json` H-137 ↔ `stadt/bewohner.json` B02
- Stelle: H-137 „… der erste Laib gehört dem Uhrturmwärter, der ihn von der Stiege aus abholt.“ B02 (Uhrturmwärter) ist laut Nachtplan 03:00–04:30 „am Uhrwerk“ und 04:30–05:30 „auf dem Sofa“.
- Regel: Stationshinweise und Nachtpläne müssen zusammenpassen (Logik E27/M3).
- Vorschlag: Abholzeit benennen und B02-Plan so anpassen, dass die Abholung in eine Lücke fällt.

**B-02 · gering** · `burgstadt_spiel/data/texte/erzaehler.json` laden[0] ↔ `tutorial.json` T02
- Zitat: „Tipp: Rennen bringt dich schneller über den Hof …“. T02 touch: „Linker Daumen laufen, rechter Daumen umsehen.“ (kein Rennen).
- Regel: Konsistenz Spieltext/Steuerung. E38 nennt den Tipp „geräteneutral“, für Touch bleibt er aber falsch.
- Vorschlag: Tipp nur für Tastatur/Gamepad ausgeben oder für Touch umformulieren.

**B-03 · gering** · `stadt/haeuser.json` H-108; `stadt/bewohner.json` B29 (gerede)
- Zitat H-108: „… die Schublade mit den Knöpfen wurde seit dem Tod des Gründers nicht geöffnet. Die Krämerin fischt die Knöpfe trotzdem aus der Ritze.“ B29: „… der Nebelriese kaufe nur Knöpfe, und die Krämerin hat ihm gerade drei geschenkt.“
- Regel: Stadttexte „nur Farbe“ (LISTE-ORTE; ANPASSUNG Zeile 9). „Knopf“ steht weder in LISTE-GEGENSTÄNDE noch im Kanon. Kanon-Stelle nur H-S10 (O, Farbe: Schneiderin näht Knöpfe) und dessen L-Gegenstück. E27/M4 hat den Saum-Hinweis gestrichen und durch den Knopf ersetzt.
- Befund: Keine Leitplanken-Verletzung, aber ein Spur-Echo ohne Kanon-Grundlage.
- Vorschlag: Schublade-Satz streichen oder auf Laden-Alltag reduzieren; B29-Gerede um die Knöpfe kürzen.

**B-04 · gering** · `stadt/haeuser.json` H-136, H-047, H-143, H-140
- Zitat H-136: „Der Hausherr hat ihn nach einer Nacht mit dem Spaten versetzt.“ H-047: „… die Grube ist mit Brettern abgedeckt, und der Gießer hält sie für zu flach, um hineinzufallen.“ H-143: „… über einem zugemauerten Schachteingang …“ H-140: „… ein Klopfen, das nicht vom Haus kommt.“
- Regel: Ton „Gänsehaut mit Humor“. Keine Leitplanke betroffen (kein Opfer, kein Blut, keine Leiche). Kein Kanonbezug.
- Befund: Mehrere Grab- und Versteck-Anmutungen in den Stadtdaten; H-136 und H-047 lesen sich wie Verstecke.
- Vorschlag: H-136 auf Tageslicht umschreiben, letzten Satz von H-047 streichen.

**B-05 · gering** · `stadt/haeuser.json` H-034
- Zitat: „… man kann auf ihm vom dritten Stock bis zum Pflaster hinabgleiten.“
- Regel: Seil steht nicht in LISTE-GEGENSTÄNDE; Fluchtbild ohne Kanonbezug. E38 hat das Seil-Motiv ausgedünnt, dieser Satz blieb.
- Vorschlag: Satz streichen.

**B-06 · gering** · `stadt/haeuser.json` H-027
- Zitat: „Die Kustodin hat die Karte seither nicht mehr angefasst.“
- Regel: Stadttext ohne Kanonbezug. Der Verdacht trifft hier nur eine weibliche Stadtfigur (zusammen mit B-03). Keine Täterin-Nähe.
- Vorschlag: Satz streichen oder neutral formulieren.

**B-07 · gering** · `stadt/bewohner.json` B16 und B33 (gerede)
- Zitat B16: „… sie ruft jeden, der nicht pünktlich zum Kaffee kommt.“ B33: „… sie hat nur die Nachbarn zur Kuchenrunde gerufen.“
- Regel: Klischees über Altersgruppen (E34/B-2). E34 hat vier Stellen auf konkrete Personen umgestellt. Diese beiden Gerede-Zeilen folgen dem gleichen Muster (ältere Frau = Kaffee und Kuchen) und sind nicht erfasst.
- Vorschlag: Tätigkeit ändern, z. B. „… hat nur die Nachbarn in den Hof gerufen.“

**B-08 · gering** · `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md` (R18-STAMM, O) mit Parallele zu ANPASSUNG R05 und R13
- Zitat R18-STAMM [O] (nicht überlagert): „Die Großmutter wohnt mit im Haus, schlichtet jeden Familienstreit ‚wie ein Gericht‘ und fragt jeden Sonntag beim Tee, wann Elif endlich Richterin wird.“ Parallel ANPASSUNG R05: „Die Großmutter Halina wohnt mit im Haus …“, R13: „Die Großmutter Nermin wohnt im selben Haus …“.
- Regel: E38 (Großmutter-Motive bewusst belassen, Gegenbeleg R10 Inge). Neuer Grund gegen die E38-Begründung: Der einzige Gegenbeleg R10 (Inge) wohnt nicht im Haushalt. Das Muster „Großmutter wohnt im Haus, führt das Haus oder die Familie“ tritt nur bei nichtdeutschen Familien auf (R05, R13, R18). R18 fiel durch den E38-Overlay, weil kein benanntes Fest oder Gericht vorkommt.
- Befund: Klischee-Risiko (Schlichterin und Hüterin in Migrantenfamilien). Kein eindeutiger Verstoß.
- Vorschlag: R18-Szene auf eine andere Person verlagern oder individualisieren; „beim Tee“ streichen; die Haushaltsgroßmutter nicht weiter ausbauen.

**B-09 · gering** · `stadt/haeuser.json` H-066; Kanon BSO-04 (O)
- Zitat H-066: „Heute stehen dort Einmachgläser mit Deckeln in einer einzigen Handschrift.“ BSO-04 (O): Code-Zettel „in zwei verschiedenen Handschriften beschrieben“.
- Regel: Stadttexte dürfen keine Beweisstück-Echos erzeugen.
- Vorschlag: „mit gleichen Deckeln“ oder ähnlich neutral formulieren.

**B-10 · gering** · `pixel_engine/data/figuren/teile_koepfe.json` (IDs `frisur-afro`, `kopf-kopftuch`)
- Befund: Beide Teile liegen im Bestand und werden von keiner Figur in `karten.json` genutzt. E27/G4 hat `kopf-kopftuch` geprüft. `frisur-afro` ist dort nicht behandelt.
- Regel: Klischee-Leitplanke bei künftiger Verwendung.
- Vorschlag: `frisur-afro` aus dem Bestand nehmen oder eine Verwendungsregel dokumentieren. `kopf-kopftuch` wie in E27 belassen.

**B-11 · gering** · `pixel_engine/data/figuren/karten.json` gegen K2/K9 (O)
- Befund: Teil-IDs weichen bei sechs Figuren von der Kanon-Kleidung ab: R01 `kopf-wollmuetze-bommel` (Kanon: graue Strickmütze); R05 `oberteil-uniformjacke` (Cordblazer); R06 `oberteil-arbeitsjacke` (Funktionsjacke); R07 `oberteil-arbeitsjacke` (Lederjacke); R11 `oberteil-arbeitsjacke` (Daunenjacke); R15 `oberteil-hemdkragen` (schwarzes Shirt). `figuren/rollen.json` nennt die Kanon-Kleidung korrekt.
- Regel: Kanontreu (Kleidung, O).
- Vorschlag: im Sichtprüfer-Lauf gegenprüfen und Teil-IDs bei sichtbarem Unterschied anpassen. Die R17-Hutfrage (E29/B9) bleibt bewusst.

## 4. Geprüft ohne Befund

- **Alkohol, Drogen, Rausch:** keine Treffer. Teestube („Tee gibt es hier, mehr nicht“), Punsch „alkoholfrei“, Kräuter und Erkältungstee ohne Drogenbezug.
- **Blut, Verletzung, Opfer:** nur „Beule“, „benommen“, „Kühlpack“, „keine offene Wunde“. Keine Leiche. Der Burgwart überlebt in allen Texten.
- **Herkunft:** keine Herkunft als Motiv, Indiz oder Pointe. G- und L-Zeilen mit Herkunftsbezug geprüft: keine Motivnutzung (Treffer nur Wortteile wie „Türknarren“).
- **Hexen, Walpurgis, Teufel, Film-Vampire:** keine.
- **Overlay-Vollständigkeit:** Brockengespenst, Harz-Varianten, Silberhauer, Nationalpark und „bewusstlos“ erscheinen in Daten und Spielcode nicht als Spieltext. Die öffentlichen Zeilen sind nach dem Overlay konsistent (GL-03, GL-06, GL-15, K-008, LA-01, LF-BW, LF-R03, LF-R19).
- **Täterin-Nähe in Stadttexten:** keine direkte Verweisung. Keine Sohle, kein Absatz, kein Stollen (B32), kein Bienenwachs (Stadt nur Talg), keine Torte, kein Track, keine Kamera, kein Schlüsselbund, keine Heißluftpistole.
- **Kanon-Fakten in Stadttexten:** Stadttore 22:00, Uhrturm 00:25 / 01:30 / 03:00 / 04:30, Ofen 03:00, Strom erst am Morgen, Ersatzsicherungen passen nicht, Schaden 3.800 € bzw. höchstens 600 €, Notdienst der Apotheke, Schaltplan am Hauptverteiler. Konsistent.
- **Figuren:** Kameragurt (R19), Kopfhörer (R02), Wanderstiefel R03/R04 aus zwei Teilen, Kühlpack (Tiefkühlerbsen) – konsistent mit K2/K9.
- **Plagiat:** keine erkennbare Übernahme aus Filmen, Serien, Spielen, Büchern oder Liedern. Namen sind generisch. „Einspruch!“ bleibt ein Gerichtswort (E27/G3). Track-Titel „Geisterstunde“ ist allgemein.

## 5. Grenzen der Prüfung

- Keine externe Plagiatsrecherche; Urteil beruht auf Lesung und Wissen.
- Zahlenwerte in `karten.json`, `rollen.json` und den Teil-Dateien (Größe, Palette, Geometrie) nicht inhaltlich geprüft.
- L- und G-Zeilen nur gezielt (Widerspruchs- und Herkunftsprüfung), nicht zitiert.

## 6. Urteil

Hoch 0, mittel 0, gering 11. Die Leitplanken (Alkohol, Drogen, Blut, Herkunft, Hexen, Klischee im engeren Sinn) sind eingehalten. B-08 ist ein Klischee-Risiko, kein eindeutiger Verstoß. Die Kanon-Texte sind nach dem Overlay konsistent, Befunde betreffen Stil, Nebenmotive und Konsistenz. Keine Kopien erkannt.

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja
