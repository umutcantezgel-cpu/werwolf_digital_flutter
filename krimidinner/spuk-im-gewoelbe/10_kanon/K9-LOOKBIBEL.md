# K9 · LOOK-BIBEL · Spuk im Gewölbe
Sichtklasse des ganzen Dokuments: O (öffentlich). Bildprompts verraten nie die Lösung: Kein Bild zeigt eine Tat, einen Täter oder eine lösungsrelevante Zuordnung (wer trägt welchen Stoff, wer hält welchen Gegenstand).

## 1. Bildstil
- Halbrealistische, malerische Illustration mit filmischem Licht: Graphic Novel trifft klassisches Ölgemälde. Warme Pinselstruktur, klare Silhouetten, leicht stilisierte Gesichter mit ausdrucksstarker, freundlicher Mimik.
- Ton: gemütlicher Grusel mit Augenzwinkern. Schatten dürfen unheimlich sein; Menschen wirken sympathisch, nie bedrohlich oder entstellt.
- Englischer Stilsatz, der in jedem Prompt wortgleich vorkommt (Stilanker):
  `semi-realistic painterly illustration, cinematic lighting, warm graphic-novel style with oil-painting texture, cozy-spooky mood, friendly expressive faces`

## 2. Licht
- Hauptlicht: Kerzenlicht und Kaminglut (sehr warm, Bernstein und Orange), weiches Flackern, tiefe Schatten auf Bruchstein.
- Gegenlicht: kühles Mondlicht durch Schießscharten und im Hof (Nachtblau), feine Lichtkanten an Haaren und Schultern.
- Szenen nach dem Stromausfall: einzelne Handytaschenlampen-Kegel (kaltweiß) im Dunkeln, Staub im Lichtkegel, nie grell.
- Gesichter bleiben immer lesbar (kein vollständiges Gegenlicht auf Figurenporträts).

## 3. Farbpalette (feste Werte)
| Name | Hex | Einsatz |
|---|---|---|
| Bruchstein | #6B6660 | Mauern, Gewölbe |
| Eisenschwarz | #22201E | Schatten, Eisenbeschläge, Rüstung |
| Kerzenbernstein | #E8A33D | Hauptlicht, Kerzen, Fenster |
| Glutorange | #C8642B | Kamin, Akzente |
| Punschbraun | #9C4A23 | Punsch, Holz, Truhen |
| Nachtblau | #1E2A3A | Nachthimmel, Hof, Gegenlicht |
| Moosgrün | #4A5A3C | Hof, Brunnen, Harzwald |
| Pergament | #E9DCC0 | Karten, Zettel, Lageplan |
| Spukcyan (sparsam) | #A9D6D9 | nur für Geisterschimmer, Nebel |

## 4. Kamerasprache
- Figurenporträts: Halbtotale bis Brust, Dreiviertelansicht, Augenhöhe, Brennweite wie 50 mm, Hintergrund unscharf (Gewölbe mit Kerzen).
- Stationen: Weitwinkel-Establishing-Shot, leichte Untersicht, Brennweite wie 24–28 mm, eine Lichtquelle als Blickführung.
- Beweisstücke: Nahaufnahme, 45° von oben oder Draufsicht, auf dunklem Holz oder Bruchstein, geringe Schärfentiefe.
- Titelbild und Einladung: Totale der Burg oder des Gewölbes mit Festtafel, Blick von außen nach innen oder durch einen Torbogen.
- Keine schiefen Horizonte, außer bei einem ausdrücklich komischen Schreckmoment.

## 5. Formate
| Motiv | Seitenverhältnis | Hinweis |
|---|---|---|
| Titelbild | 2:3 (Plakat) und 16:9 (App) | zwei getrennte Prompts |
| Einladung | 3:2 (Postkarte A6 quer) | Freiraum links oder oben für späteren Text |
| Figurenporträt | 4:5 | Kopf im oberen Drittel |
| Station | 16:9 | |
| Beweisstück | 1:1 | |
| Kartenrückseite / Kartenvorderseite (Rahmen) | 5:7 (63 × 88 mm) | Rahmen mit leerer Mitte |
| Lageplan | 4:3 | Draufsicht, Pergamentkarte, ohne Beschriftung |

## 6. Ausschlüsse (in jedem Prompt als Negativliste)
Englischer Negativ-Anker, wortgleich in jedem Prompt:
`no text, no letters, no logos, no watermark, no blood, no wounds, no gore, no weapons in use, no alcohol, no wine, no beer, no goblets, no tankards, no bottles, no glasses with drinks, no cigarettes, no real people, no celebrities, no witches, no pentagrams, no skulls`

Pflichtformulierung für den Punsch: `a large copper cauldron of warm non-alcoholic apple-cinnamon punch with ceramic mugs`.

## 7. Konsistenzanker je Ort
(wird mit dem Kanon-Kern ergänzt: Abschnitt 7a)

## 8. Konsistenzanker je Figur
(wird nach K2 ergänzt: Abschnitt 8a; je Figur Haare, Gesichtszug, Signaturstück der Kleidung, Farbe – ohne lösungsrelevante Merkmale)

## 9. Aufbau eines Bildprompt-Eintrags (verbindlich)
    BILD-ID: <Kennung, z. B. BILD-FIG-R07>
    Motiv: <Deutsch, 1 Satz>
    Prompt (EN): <60–110 Wörter: Motiv, Ort-/Figurenanker, Licht, Palette, Kamera, Stilanker>
    Negativ (EN): <Negativ-Anker aus Abschnitt 6, wortgleich>
    Format: <Seitenverhältnis aus Abschnitt 5>
    Zweck und Einsatz (DE): <20–40 Wörter>
