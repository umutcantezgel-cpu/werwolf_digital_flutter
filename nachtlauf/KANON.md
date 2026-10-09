# KANON – „Spuk im Gewölbe“ im Spiel „Burgstadt Schartenfels“

**Verbindliche Quelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K*.md` (1207 Datensätze, `kanon.py pruefe` = 0 Befunde).
**Spiel-Anpassung:** ausschließlich über das Overlay `nachtlauf/kanon/ANPASSUNG.md` (feldweise; Originaldateien bleiben unberührt).
**Wirksamer Kanon:** `dart run packages/burgstadt_core/bin/kanon.dart --wirksam` (ab Phase 2) gibt den zusammengeführten Kanon und den Diff aus.

## Kern (unverändert)
- Täterin R03 Merle Hartwig. Motiv Strang b (Taler aus der Schauvitrine, Rückgabeversuch, Panikschlag).
- Opfer: Burgwart Eckehard Lüddecke (BW). Er ist nur kurz bewusstlos und **überlebt**.
- Tatwaffe: eiserner Kerzenständer. Tatzeit 23:58:22; der Schrei um 00:00 kommt aus der Box.
- Notwendige Schlussfolgerungen S-1…S-7 mit Hinweisen H-01…H-29 sowie den Gesprächs-Hinweisen. Entlastend: S-8…S-10.
- Pflicht-Beweise:
  - Wachsabdruck BS-01 / H-06
  - Stofffetzen an der Rüstungshand BS-02 / H-12 (Leinen des Gespensterlakens, Wäschezeichen „Schartenfels 7“)
  - Taschenlampe mit leerer Batterie BS-03 / H-28
  - Zettel mit Sicherungskasten-Code BS-04 / H-24 (Rückseite H-07)
- **Ablauf:**
  - Einführung mit Steckbriefen.
  - 3 Phasen. Je Rolle 3 Gespräche (`@G{p}-nn`, mit Ersatz-Regel je Besetzung) und 1 Rollen-Entscheidung (`@E{p}-rr`).
  - Detektiv: 3 Entscheidungen je Phase (`@D`/`@DW`, echte Spur +1).
  - Punkte 0–9, Eingrenzung (VK/Tabelle in K5) vor der Anklage, Endmatrix EM-1…EM-4.
- **Besetzung:** Detektiv = Geburtstagskind (zusätzlicher Platz). Dazu N = 4…20 Rollen in fester Reihenfolge. R01–R04: Hauptverdächtiger Adnan, Hauptzeugin Rojda, Täterin Merle, Hauptverdächtiger Jonas.
- **Lügenregel K7:** Lügen nur dort, wo die Karte es erlaubt (LR-7). Rollen ab 5 lügen nie. Beweise sind immer echt; nach dem Gegenbeweis wird gestanden.

## Anpassung an die Burgstadt (Master-Prompt §7.1)
- **Ort:**
  - Burg Schartenfels ist die kleine Stadtburg am höchsten Punkt der erfundenen, ummauerten Oberstadt Schartenfels.
  - Bauweise im Stil siebenbürgischer Burgstädte, aber keinem Land zugeordnet.
  - Unten im Tal liegt das Bergstädtchen Silberhau.
  - Burg, Gewölbe, Speisekammer, Turm, Hof und Torhaus bleiben in Geometrie und Zeitleiste exakt wie im Kanon.
- **Stromausfall:** Der Sicherungskasten am Turm-Fuß ist der historische Hauptverteiler der Oberstadt. Der Knall um 23:58 legt die ganze Oberstadt lahm (Laternen, Fenster, Uhrturm-Beleuchtung).
- **Tore und Bund:** Am Bund hängen zusätzlich die Schlüssel der beiden Stadttore (Obertor, Untertor), die der Burgwart abends abschließt.
  - **Phase 1:** nur Burg und Burg-Wehrgang. Der Wehrgang ist Teil der Stadtmauer, die Turmpforten zur Stadt sind verschlossen. S-1 gilt unverändert.
  - **Zu Beginn von Phase 2** (BW-AUSSAGE-2, Bund in Kunibert) schließt der Burgwart das Burgtor zur Oberstadt auf: „Sucht meinetwegen in der ganzen Oberstadt – aber vor dem Morgengrauen kommt hier keiner raus.“
  - Die Stadttore bleiben zu: Bis zum Morgengrauen kommt niemand aus der Oberstadt.
- **Uhrzeiten:** Phase 1 von 00:25 bis 01:30, Phase 2 bis 03:00, Phase 3 bis 04:30. Der Uhrturm schlägt die Phasen an. Die Auflösung folgt im Morgengrauen.
- **Bewohner der Oberstadt:**
  - Sie waren nie in der Burg: Das Burgtor war seit 23:00 zu, der Raureif im Hof ist unberührt.
  - Sie liefern nur Farbe sowie entlastende oder bestätigende Hinweise, nie notwendige.
- **Motivstränge in der Stadt** (zusätzliche Orte, nur Farbe, entlastend oder bestätigend):
  - Strang a: Pension „Zum Uhrturm“ (Übernachtung; Paulinas Belege).
  - Strang b: Stadtmuseum am Marktplatz (Katalog des Talers).
  - Strang c: Kostümfundus der Volksbühne (Herkunft des Lakens bleibt Pensionswäsche „Schartenfels 7“; der Fundus zeigt nur, dass dort nichts fehlt).
  - Strang d: Schreinerei an der Mauergasse (Kostenvoranschlag für die Tür).
  - Stromhaus/Turm-Fuß: Hauptverteiler und Code.
- **Umbenennungen:**
  - Brockengespenst → Nebelriese (eigene Nebel-Legende: ein Riesenschatten im Nebel, der sich bewegt, wenn du dich bewegst).
  - Silberhauer Ausbeutetaler → Schartenfelser Ausbeutetaler.
  - Oberharz → Bergland.
  - Nationalpark Harz → Naturpark.
  - Harzwald → Bergwald.
  - Wohnorte der Familien (Goslar, Osterode, Wernigerode) bleiben; die Clique ist für das Wochenende angereist.
- **Leitplanken (VERBOTE-LEITPLANKEN + Master-Prompt §3):**
  - Kein Alkohol und keine Drogen. Punsch ist immer „warm, alkoholfrei“. In der Stadt gibt es Teestube, Café und Bäckerei.
  - Herkunft ist nie Motiv, Indiz oder Pointe.
  - Kein Blut. Das Opfer überlebt.
  - Keine Hexen, kein Walpurgis, kein Teufel.
  - Original statt Kopie, kein bekannter Film-Vampir.
  - Klischeefrei, auch gegenüber Menschen aus Rumänien und Roma.

## Figuren-Kanon für Sprites (K9 + O-Datensätze)
- Kleidung kommt nur aus O-Datensätzen. **Grün tragen nur Merle (dunkelgrüne Zopfstrick-Strickjacke) und Jonas (olivgrüner Fleece).**
- Gleiche Wanderstiefel bei Merle und Jonas. Rojda trägt glatte Sneaker, Adnan Arbeitsschuhe; Adnan ist ab 23:52 rußig.
- Porträts zeigen nie Taler, Bund, Laken, Stablampe, Kerzenständer, Zettel, Wanderstiefel oder Ruß (K9 §8).
- Der Detektiv ist nie sichtbar (Ich-Perspektive, nur Hand mit Handylicht).
