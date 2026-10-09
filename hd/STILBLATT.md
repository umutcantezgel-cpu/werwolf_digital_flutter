<!-- Burgstadt HD · Stilblatt v2 · verbindlich für Texturen, Bauteile, Formen, Deko, Figuren, Oberfläche -->

# Stilblatt v2

Die lauffähigen Musterdateien (Textur, Bauteil, Form, Test) entstehen in P1-OPUS-12. Bis dahin gilt dieser Text. Danach gelten Text und Muster gemeinsam; bei Widerspruch gewinnt das Muster.

## 1 Pixelgesetz
- Abtastung nearest, keine Glättung, kein Alpha-Verlauf. Jedes Pixel ist ein Palettenindex 0–159; 255 heißt transparent.
- Vergrößerung nur ganzzahlig (kWelt, kUi). Kein Element darf zwischen zwei Pixelgrößen liegen.
- Silhouette entsteht durch Geometrie, Oberfläche durch Textur. Wird eine Kante im Bild wichtig, gehört sie ins Mesh.

## 2 Palette v2
- 10 Rampen × 16 Stufen, Index = Rampe·16 + Stufe. Stufe 0 ist am dunkelsten, Stufe 15 am hellsten.
- Die alten 64 Farben liegen exakt auf den ungeraden Stufen (alte Stufe s → neue Stufe 2s+1). Die geraden Stufen sind OKLab-Mitten (Stufe 0 ist eine tiefere Variante).
- Rampen 0–7 sind die Bestandsrampen (Namen und Rollen siehe `palette.dart`). Neu sind Rampe 8 **Altrosa** und Rampe 9 **Türkis** (blauseitig, kein Grün).
- Im Code: `Ramp.at(r, s)` mit alter 8er-Stufe, `Ramp.at16(r, s)` mit neuer 16er-Stufe, `Pal.*` für benannte Farben. Zahlenliterale für Farben sind verboten.

## 3 Texturen
- Größe 64×64 (1 m) oder 128×128 (2 m); Spuren 32 oder 64. Dichte 64 Texel/m.
- Höchstens 8 der 16 Stufen je Textur, nur aus den Rampen des Materials.
- Streupixel (Pixel ohne gleichfarbigen 4-Nachbarn) höchstens 8 %. Keine Rauschflächen, keine reinen Zufallsmuster.
- Fugen und Ritzen 1–2 Stufen dunkler als der Körper, nie die dunkelste Stufe der Rampe.
- Licht kommt von oben links: Lichtkante oben und links, Schattenkante unten und rechts, je 1 Texel (bei 128er-Texturen bis 2).
- Kachelbar ohne sichtbare Naht. Abwechslung entsteht über Varianten und `hashTeil`, nicht über Rauschen.
- In Mip 1 (halbe Größe) muss die Struktur noch lesbar sein: Fugen mindestens 2 Texel breit, Elemente mindestens 6 Texel groß.
- Zufall nur über `Lcg` aus dem Werkzeugkasten mit festem Seed oder `hashTeil(id, teil)`, nie `dart:math Random`.

## 4 Grünregel (E-025)
Grün (Rampe Grün) nur in `wiese`, `dachBiberschwanzMoos` und `bruchsteinMauer`. Keine neue grüne Textur, keine grüne Deko, keine grüne Kleidung außerhalb des Kanons.

## 5 Farben der Viertel (siebenbürgisch)
| Viertel | Fassaden | Akzent |
|---|---|---|
| Marktviertel | Ocker, Altrosa, Taubenblau | Läden rotbraun |
| Handwerkergasse | Sandstein, Fachwerk dunkel auf Kalkputz | Zunftschilder Eisen |
| Kirchhügel | Kalkweiß, Grau | Schiefer |
| Untere Stadt | Türkis, Creme | Läden braun |
| Mauerviertel | Bruchstein, Quaderstein | Holz der Wehrgänge |
| Burgberg | Quaderstein, Bruchstein | Eisen |

## 6 Bauteilmaße (Meter)
| Teil | Maß |
|---|---|
| Laibung | Tiefe 0,15 |
| Sims | 0,06 hoch × 0,08 vor |
| Fensterladen | 0,45 × 1,1 je Flügel |
| Traufe | Überstand 0,35 |
| Ortgang | Überstand 0,15 |
| Fledermausgaube | 0,9 breit × 0,35 hoch |
| Schornstein | 0,5 × 0,5, 1,0 über First |
| Sockel | 0,6 hoch |
| Tür | 2,2 hoch |
| Fenster | 0,9 × 1,1 |
| Stockwerk | 3,0 |

Vorsprünge: unter 2,3 m Höhe höchstens 0,10 m und nie in Tür- oder Wegkacheln; darüber bis 0,6 m.

## 7 Licht (Kanon: Strom in der Oberstadt aus)
- Kein elektrisches Licht, Laternen sind dunkel (Glas dunkel, keine Lichtgruppe).
- Erlaubt: Kerzenfenster, Öfen, Handylicht, Mond, Notleuchten laut Daten, Lichter von Silberhau im Tal.
- Bestandslichter (Burg-Kamin, Punschkessel, Geleucht) bleiben, neue Lichtquellen gibt es nicht.

## 8 Formen und Deko
- Möbelformen ersetzen Quader mit gleicher Grundfläche und Höhe (Kollision bleibt). Mindestens 3 Teilkörper je Form, Kanten 1 Stufe heller oder dunkler.
- Deko ist reine Darstellung: blockiert nicht, hat keine Texte, keine Lichtfelder.
- Anker nur an Wand, Decke, auf blockierenden Möbeln oder flach am Boden (höchstens 0,02 m), nie auf Tür-, Stations- oder Markenkacheln.
- Kanon-Bildregeln K-013 gelten (Positiv- und Verbotsliste je Raumart in `hd/kundschaft/P0-KUND-04.md`).

## 9 Figuren und Porträts
- Figuren in zwei Dichten: 32 (48×80) und 64 (96×160). Augen bei 64 mindestens 2×2 Pixel.
- Kontur 1 Pixel, Innenlinien 1–2 Stufen dunkler, nie Schwarz außer Pupille.
- Porträt 128×128, 4 Ausdrücke, Gesichtsmuster relativ zur Kopfhöhe.

## 10 Oberfläche
- Knöpfe und Panels mit Lichtkante oben links und Schattenkante unten rechts; Zustände normal, gedrückt, gesperrt.
- Texte bleiben unverändert (textPfade), nur Optik ändert sich.
