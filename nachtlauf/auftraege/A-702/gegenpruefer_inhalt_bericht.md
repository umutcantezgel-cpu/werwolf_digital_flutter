# A-702b · Gegenprüfer Inhalt (Z-12) – Bericht und Umsetzung

Der Agent durfte keine Bericht-Datei anlegen. Sein Bericht kam deshalb als Endmeldung; Opus hat ihn hier abgelegt und vermerkt, wie jeder Befund umgesetzt wurde.

**Geprüft wurden:**
- bewohner.json (44), haeuser.json (160), Innenräume (30 + 12 Fall-Orte)
- faehigkeiten.json (20), karten.json (65), rollen.json (21)
- tutorial.json (16), erzaehler.json (68), ANPASSUNG.md (139 Zeilen)
- Maßstab: alle O-Datensätze

**Scanner `bin/leitplanken.dart --burgstadt`:** 0 Treffer.

**Urteil des Agenten:**
- Leitplanken: nein (Grenzfälle M3, M5)
- Kanontreu: nein (H1, M1, M2)
- Plagiatsfrei: ja

## Befunde und Umsetzung

| # | Schwere | Befund | Umsetzung |
|---|---|---|---|
| H1 | hoch | B32 (Schuhmacher): „Die Sohle … gehört einer Frau, die viel zu früh loslaufen wollte“ – legt die Täterin nahe (Sohlen-Spur, vor IF-3) | Satz neutral ersetzt („… hat schon mehr Gassen gesehen als ich“); die beiden Tagesablauf-Zeilen über „eine Sohle“ entschärft |
| M1 | mittel | Laterne der Teestube: H-S13 „brennt mit Kerzenstummel“ gegen B07/B41 „nicht angezündet“; Erzähler „vor der Tür“ | H-S13 → „Die Laterne über der Theke ist dunkel, auf den Tischen brennen Kerzen.“ Erzähler ORT-07 angeglichen („über der Theke ist dunkel“) |
| M2 | mittel | B28: „Heute klingt nichts in dieser Stadt“ gegen STADT-02 (Uhrturm schlägt mechanisch) | „Die Kirchenglocken sind stumm … Nur der Uhrturm schlägt noch, der braucht keinen Strom.“ |
| M3 | mittel | Schank-Anklang: H-053/H-054 „Haus zur Kanne“ (Inschrift „… ein Hof voll Gäste“), H-133 „Haus zum Heidekrug“ | „Haus zur Teekanne“ mit Inschrift „Eine Kanne Tee, ein Hof voll Nachbarn“; „Haus zur Heideblüte“ (Krug → Vase) |
| M4 | mittel | H-099 Inschrift lehnt sich an „For whom the bell tolls“ an | „Die Glocke läutet, wenn der Hügel es verlangt“; Haus heißt jetzt „Haus zur Abendglocke“ (Glocke schlug zum Feierabend) |
| M5 | mittel | faehigkeiten.json R06: „kurz bewusstlos … Gedächtnislücke“ (Begriffe aus dem Kanon, aber über „Beule/benommen/Kühlpack“ hinaus) | Spieltext: „eine Weile benommen, … an die Sekunden vor dem Schlag erinnert er sich nicht“. Der Kanon-Datensatz selbst bleibt unverändert (Entscheidungslog E23) |
| G1 | gering | Bäckerei: „Ofen, der langsam abkühlt“ gegen „um drei Uhr angeheizt“ | kein Widerspruch: vor 03:00 kühlt der Ofen vom Vortag ab – bleibt |
| G2 | gering | Schulglocke: „seit dem letzten Lehrer“ gegen „seit dem Brand“ | H-091 angeglichen: „seit dem Brand im Dachstuhl“ |
| G3 | gering | H-035: „Der Drechsler wohnt im Obergeschoss“, laut Bewohnerliste die Buchbinderin | Text auf die Buchbinderin geändert |
| G4 | gering | „Haus zum Lindenbaum“ | gängiger Hausname, kein Zitat – bleibt |
| G5 | gering | B43: „Der Nebelriese … ist ein Bär mit Hut“ (Anklang an eine Kinderbuchfigur) | → „trägt eine Laterne aus Mondlicht“ |
| G6 | gering | Anstecker „Einspruch!“ (R18, O-Signaturstück) | Kanon-Gegenstand, generisch – bleibt |
| G7 | gering | „Hanf“ (Seiler) mehrdeutig | „Fasern“, „Ein gutes Seil …“, Innenraum „Faserballen für Seile“ |
| G8 | gering | „Kopf stößt“, „Gefühl in die Finger“ | keine Verletzungsbeschreibung – bleibt |
| G9 | gering | B07: „Trinken darfst du, solange …“ doppeldeutig | → „Davon darfst du so viel haben, wie die Kanne hergibt.“ |
| G10 | gering | Kanon-intern: K-002 „Klarer Himmel“ gegen OA-27 „Eisnebel“ | Kanon-Entscheidung, keine Stadtänderung – bleibt |
| G11 | gering | B09 vor 01:30 in der Unteren Stadt | kein Regelverstoß – bleibt |
| G12 | gering | Teil „oberteil-uniformjacke“ steht für mehrere Jackenarten | Näherung ohne Farbwiderspruch – bleibt |
| Werkzeug | – | Der Scanner erfasste burgstadt_spiel/data/texte und pixel_engine/data/figuren nicht | `spieltextBestand()` ergänzt (jetzt 112 Dateien, 0 Treffer) |
