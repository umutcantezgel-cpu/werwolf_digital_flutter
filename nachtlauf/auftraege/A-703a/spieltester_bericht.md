# Spieltester-Bericht A-703a: Bildschirme auf drei Geräteprofilen

Basis: Branch des Worktrees per `git merge --ff-only nachtlauf/burgstadt` auf `dbba552`. Alle Bildpfade sind relativ zu `nachtlauf/bilder/`.

## Umfang und Maßstab

- Geprüft: 62 PNG-Bilder (`z02/quer` 26, `z02/hoch` 26, `phase6` 4, `geraete` 6). `geraete/bericht.txt` enthält nur Leistungswerte; daraus wurden keine Befunde abgeleitet.
- Geräteprofile (Annahme aus Auftragstitel, Ordnernamen und Bildmaßen):
  - Desktop: `z02/quer/`, `phase6/*_quer.png`, `geraete/desktop_*.png` (1280×720)
  - Handy hoch: `z02/hoch/`, `phase6/*_hoch.png`, `geraete/handy-hoch_*.png` (1080×2400, entspricht 360×800 CSS-Pixel bei Faktor 3)
  - Handy quer: `geraete/handy-quer_*.png` (2400×1080, entspricht 800×360 CSS-Pixel bei Faktor 3)
- 7-mm-Regel nur für Handy: Bei 6 Zoll entsprechen 1080×2400 bzw. 2400×1080 Bildpixeln ca. 17,3 px/mm, also 7 mm ≈ 121 px. Knopfhöhen sind äußere Rahmenmaße, mit PIL an den Originalen gemessen.
- Kontrast nach WCAG-Formel (relative Luminanz). Richtwert 4,5:1 für kleine Schrift.
- Schwere:
  - hoch: Inhalt wird abgeschnitten oder überdeckt; Schrift oder Bedienelement ist nicht sicher lesbar oder bedienbar.
  - mittel: bedienbar und lesbar, aber deutlich erschwert (Knopf 4 bis 7 mm, Kontrast unter 2,5:1 bei wichtiger Information, Rückweg oder Bedienhinweis fehlt).
  - gering: Nebeninformation knapp unter dem Richtwert oder kleiner Layoutmangel.
- Zählung: Jede Zeile ist ein Fehler. Dieselbe Ursache auf mehreren Bildern ist eine Zeile mit allen betroffenen Bildern.
- Annahme mit Wirkung: `z02/quer` (1280×720) ist als Desktop bewertet. Sollte es ein Handy im Querformat zeigen, haben dessen Knöpfe 37 px Höhe, also ca. 3,8 mm bei 6 Zoll. Dann würde H6 auch für `z02/quer` gelten.

## Fehler

| Nr | Bild | Stelle | Problem | Schwere | Vorschlag |
|---|---|---|---|---|---|
| H1 | z02/hoch/03_erkundung_tutorial.png; z02/quer/03_erkundung_tutorial.png | Fallakte-Box 2, oben links | Der Text endet mitten im Satz mit „…hatte den Funkbereich des“. Der Rest fehlt, die Box zeigt kein Weiterlesen. | hoch | Box auf die Textlänge auslegen oder den Text scrollbar machen. Sätze nicht abschneiden. |
| H2 | z02/hoch/03_erkundung_tutorial.png; geraete/handy-hoch_start.png; geraete/handy-hoch_spiel.png | Tutorial-Feld unten links über der HUD-Spalte | Das Feld überdeckt die linke Hälfte von „Aktion“ bzw. „Ansehen“, „Licht“ und „Blick“. Lesbar bleiben nur „…tion“ bzw. „…ehen“, „…cht“, „…ck“. Die Knöpfe sind solange nicht lesbar und nicht sicher treffbar. | hoch | Tutorial-Feld links der HUD-Spalte halten (rechter Rand höchstens bei x ≈ 760 px), HUD-Spalte freihalten, Tutorial per Tippen schließbar machen. |
| H3 | geraete/handy-quer_spiel.png; geraete/handy-hoch_spiel.png | Sprechblasen, Bildmitte bis rechter Rand | Im Querformat liegen vier Sprechblasen übereinander, im Hochformat drei. Jede folgende verdeckt den Text der vorigen („…zwölf mit ihm gek…“, „…unten am T…“, „…es gekn…“). Die letzte läuft am rechten Bildrand ab („…dreitausendac…“, „…Wie st…“). | hoch | Blasen an feste Plätze verteilen oder nacheinander zeigen. Die Position am Bildrand begrenzen, überlagerte Blasen ausblenden oder in den Verlauf verschieben. |
| H4 | geraete/handy-quer_start.png; geraete/handy-hoch_start.png | Sprechblasen | Der Text endet mitten im Satz: quer „…Für was Kleines, eine“; hoch „…aber kurz vor dem Schrei stand“ und „…Da verwechselst du“. Der Rest fehlt. | hoch | Blasengröße an den Text anpassen oder den Text auf mehrere Blasen verteilen. Nie abschneiden. |
| H5 | phase6/stadtkarte_hoch.png; phase6/stadtkarte_quer.png | Ortsnamen auf der Karte: Kirchhügel, Marktviertel, Handwerkergasse, Untere Stadt, Burgberg | Cremefarbene Schrift (233/220/192) liegt auf hellgrauen Straßen und Plätzen (173/166/156). Kontrast 1,8:1. Die Namen sind kaum lesbar und laufen über Straßenlinien. „Mauerviertel“ ragt über den Kartenrand. | hoch | Namen mit dunkler Plakette oder dunklerer Schrift setzen (mindestens 4,5:1). Namen nur auf dunklen Flächen platzieren und innerhalb des Kartenrands halten. |
| H6 | Systemisch, alle Handy-Bilder mit Knöpfen: z02/hoch/* (26), phase6/*_hoch.png (2), geraete/handy-hoch_*.png (2), geraete/handy-quer_*.png (2) | Menü-, Panel- und HUD-Knöpfe | Die Knöpfe sind außen 48 bis 60 px hoch (ca. 2,8 bis 3,5 mm), die Abstände 9 bis 18 px (ca. 0,5 bis 1 mm). Beispiele: `01_hauptmenue` 60 px; `02_optionen` 54 px; `04_pausenmenue` 60 px; `fallakte`: Reiter 45 px, „Faden ziehen“ 48 px; `eingrenzung` und `ende` 57 px; HUD Aktion/Licht/Blick/Akte/Menü je 54 px; `wlan_wahl_hoch`: „Partie eröffnen“ 54 px, „Zurück“ 48 px; `stadtkarte_hoch`: „Zurück“ 48 px; `handy-quer` HUD 54 px. Mindestmaß sind 7 mm, also 121 px. | hoch | Gemeinsamen Knopf-Stil auf mindestens 40 CSS-Pixel (120 Bildpixel bei Faktor 3, ca. 7 mm) Höhe und mindestens 2 mm (ca. 35 px) Abstand setzen. Die HUD-Spalte zuerst, weil dort im Spiel die Hauptbedienung liegt. |
| M1 | z02/hoch/fallakte.png; z02/quer/fallakte.png | Liste der Fallakte, linke Spalte | Jeder Eintrag ist mitten im Wort mit „…“ abgeschnitten („geöf…“, „Kl…“, „Mi…“, „Ha…“). Im Querformat sind nur etwa 45 Zeichen sichtbar. Der volle Text erscheint erst nach Auswahl. | mittel | Eintrag am Wortende kürzen oder zweizeilig umbrechen. Im Querformat die Liste breiter machen; die Detailspalte ist dort fast leer. |
| M2 | z02/hoch/viertel_untere_stadt.png; z02/quer/viertel_untere_stadt.png | Ortsanzeige oben rechts „Oberstadt Schartenfels“ | Die Schrift steht auf der orangen Mauer. Kontrast 2,1:1 (hoch: nur die letzten Buchstaben betroffen; quer: die ganze Anzeige, gemessen 2,25:1). Der Ortsname steht unten Mitte noch einmal, Information geht also nicht verloren. | mittel | Ortsanzeige mit dunkler, halbtransparenter Hinterlegung versehen. Schrift auf Bildflächen mindestens 4,5:1 halten. |
| M3 | z02/hoch/eingrenzung.png; z02/quer/eingrenzung.png; z02/hoch/lagerunde_phase1.png bis _phase3.png; z02/quer/lagerunde_phase1.png bis _phase3.png | Entscheidungsbildschirme (Anklage, Lagerunde D1 bis D3) | Es gibt keinen Knopf „Zurück“, „Abbrechen“ oder „Menü“. In der Eingrenzung ist kein Bestätigungsschritt vor der Anklage zu sehen. | mittel | Soll die Entscheidung nicht abbrechbar sein, eine Rückfrage mit „Abbrechen“ vor der endgültigen Wahl zeigen. Sonst einen Rückweg zum Menü oder zur Akte anbieten. |
| M4 | z02/hoch/lagerunde_phase1.png; z02/hoch/lagerunde_phase2.png; z02/hoch/lagerunde_phase3.png | Antwortknöpfe A, B, C | Die Knöpfe sind außen 99 px hoch (ca. 5,7 mm) mit 9 px Abstand. Sie sind die größten Knöpfe im Spiel, erreichen aber die 7-mm-Grenze nicht. | mittel | Höhe auf mindestens 121 px (7 mm) bzw. 40 CSS-Pixel setzen, Abstand auf mindestens 2 mm. |
| M5 | z02/hoch/03_erkundung_tutorial.png; geraete/handy-hoch_start.png (Tastatur und Gamepad); geraete/handy-hoch_spiel.png; geraete/handy-quer_spiel.png (Daumen, dort auch „Umschalt“) | Tutorial „Erste Schritte“ bzw. „Gehen und Schauen“ | Der Text wechselt je nach Bild. Im Hochformat erklärt er Tastatur und Gamepad (WASD, Pfeile, Esc, Stick), nicht die Bedienung mit dem Finger. In den Daumen-Texten steht „Umschalt“, eine Taste, die auf dem Handy fehlt. In keinem Erkundungsbild ist auf dem Handy ein Steuerelement zum Gehen oder Umsehen sichtbar. | mittel | Tutorial je Gerät trennen: Handy mit Tipp- und Daumen-Anleitung, Tastatur nur am Desktop. Sichtbare Steuerelemente für Gehen und Umsehen auf dem Handy prüfen oder im Tutorial benennen. |
| M6 | z02/hoch/lagerunde_phase1.png | Tutorial „Die Fallakte“, unten | Der Text verweist auf „Tab für Akte“ bzw. „Select für Akte“. Auf dem Handy-Hochformat ist kein Akte-Knopf sichtbar, die Anleitung ist dort nicht umsetzbar. | mittel | Akte-Knopf auch in der Lagerunde einblenden oder den Text auf dem Handy anpassen. |
| G1 | z02/hoch/03_erkundung_tutorial.png (Kamin-Gewölbe, 3,9:1); z02/quer/viertel_burgberg.png (3,3 bis 4,0:1); z02/quer/innen_haus_h_085.png (3,6 bis 4,6:1); geraete/handy-hoch_start.png und geraete/handy-quer_start.png (Kamin-Gewölbe, 3,0 bis 4,4:1) | Ortsanzeige oben rechts, grau (138/132/124) | Lesbar, an mehreren Stellen aber unter 4,5:1 auf Mauerwerk oder braunem Grund. | gering | Schrift heller setzen (ca. 200/195/185) oder dunkle Hinterlegung wie bei M2. |
| G2 | z02/hoch/viertel_burgberg.png; z02/hoch/viertel_handwerkergasse.png; z02/hoch/viertel_kirchhuegel.png; z02/hoch/viertel_marktviertel.png; z02/hoch/viertel_mauerviertel.png; z02/hoch/viertel_untere_stadt.png | Kompass unten Mitte | Die Buchstaben sind nur etwa 12 bis 14 px hoch (ca. 0,8 mm). Die Leiste zeigt je Bild nur zwei oder drei Richtungen. | gering | Buchstaben auf mindestens 2 mm (ca. 35 px) vergrößern und alle vier Himmelsrichtungen zeigen. |
| G3 | z02/hoch/01_hauptmenue.png | Hinweis unten: „Tippen, klicken oder Pfeiltasten + Eingabe“ | Grauer Text (ca. 4,3:1) auf dem Mauermuster. Der Hinweis nennt Pfeiltasten, die auf dem Handy fehlen. | gering | Hinweis je Gerät anpassen, z. B. „Tippen zum Auswählen“. Hintergrund unter dem Hinweis abdunkeln. |
| G4 | z02/hoch/fallakte.png | Tutorial-Feld unten | Das Feld liegt über dem unteren Teil des Detailbereichs. Auf dem Bild ist nichts verdeckt; bei längeren Einträgen würde Text verschwinden. | gering | Tutorial im Fallakte-Bildschirm nicht einblenden oder unter den Detailtext legen. |
| G5 | phase6/stadtkarte_hoch.png | Legende unten | Die Legende bricht mitten im Satz um: „…Tippen auf“ endet die Zeile, „Gold: Schnellreise“ folgt darunter. Die Zuordnung ist schwer zu lesen. | gering | Legende zeilenweise mit fester Zuordnung aufteilen, z. B. „Tippen auf Ort: Schnellreise“. |

Fehler hoch 6 · mittel 6 · gering 5

## Hinweise (keine Fehler, Geschmacksfragen)

- Große leere Flächen unter dem Inhalt in Optionen, Pause, Eingrenzung, Lagerunde, Ende, WLAN und Fallakte-Liste. Inhalte zusammenziehen oder Schrift vergrößern.
- Innenräume und Nachtszenen sind sehr dunkel, z. B. `z02/hoch/innen_haus_h_145.png`, `z02/hoch/innen_innen_stromhaus.png`, `z02/hoch/innen_innen_apotheke.png`. Gegenstände sind kaum zu erkennen; Helligkeit oder Lichtkreis prüfen.
- `z02/hoch/eingrenzung.png` und `z02/quer/eingrenzung.png`: Der Satz „Den Schlüsselhinweis klar: …“ ist unvollständig (fehlendes Wort).
- `z02/quer/ende.png`: Zeilen mit ca. 190 Zeichen am Desktop, im Hochformat eine dichte Textwand. Zeilenlänge begrenzen.
- `z02/hoch/02_optionen.png`: Werte wie „Bild: mittel“ zeigen nicht, wie man sie ändert.
- Die Aktion heißt in der Erkundung „Aktion“, im Gespräch „Ansehen“ (`geraete/handy-quer_spiel.png`). Die Bezeichnung wechselt.
- Der Ortsname steht doppelt, oben rechts und unten Mitte.

## Grenzen der Prüfung

- Nur Standbilder: Bewegung, Touch-Verhalten und Übergänge sind nicht geprüft.
- Ob die Entscheidungsbildschirme (M3) absichtlich ohne Rückweg sind, lässt sich aus den Bildern nicht erkennen.
