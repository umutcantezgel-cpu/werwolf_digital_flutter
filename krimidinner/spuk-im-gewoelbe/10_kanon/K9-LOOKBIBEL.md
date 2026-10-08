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

## 7. Konsistenzanker je Ort (englische Ankersätze, wortgleich verwenden)
@LA-01 [O] | Ort: Burg außen | Anker (EN): a compact medieval hilltop castle of dark grey rubble stone above a small mining town in the Harz mountains, one round stair tower with a crenellated wall walk, a gatehouse with a heavy arched wooden gate, fir forest and drifting night fog around it
@LA-02 [O] | Ort: Kamin-Gewölbe | Anker (EN): a vaulted cellar hall of rough grey rubble stone, long heavy oak tables with massive benches, many candles in iron candelabras (LED-style flicker), a large open stone fireplace, platters of flatbread and dips, a large copper cauldron of warm non-alcoholic apple-cinnamon punch with ceramic mugs, a small wobbly bluetooth speaker in a wall niche next to an old split oak door
@LA-03 [O] | Ort: Speisekammer | Anker (EN): a small windowless pantry vault with stone floor, wooden shelves of canned goods, potato crates, a wooden barrel in the middle, an old chest freezer, a heavy iron door on the far side and an old oak door with a split panel and a wooden beam wedged against it
@LA-04 [O] | Ort: Wendeltreppenturm | Anker (EN): a narrow stone spiral staircase lit only by a few candles, a heavy squeaking iron door at the bottom next to an old wooden chest and a grey fuse box, a full suit of medieval armor standing on the first landing with one gauntlet bent forward, arrow slits letting in cold blue moonlight
@LA-05 [O] | Ort: Wehrgang | Anker (EN): a narrow crenellated wall walk on top of the tower, frost on the stone, wind, a wide view over dark fir forest and distant town lights
@LA-06 [O] | Ort: Hof | Anker (EN): a small cobbled castle courtyard covered in glittering hoarfrost, an old stone well with a small solar lantern, a gatehouse with a locked arched gate, a cellar stairway glowing with warm amber light
@LA-07 [O] | Ort: Lageplan | Anker (EN): top-down hand-drawn parchment map of a small castle: courtyard with well, gatehouse and gate, round tower, cellar hall with fireplace, adjoining small pantry with two doors, no labels, no letters
Konsistenzregel: Die Rüstung heißt im Bild immer „a full suit of medieval armor“, nie mit Namen. Die Bluetooth-Box ist klein und unscheinbar. Kerzen sind immer warm leuchtend, nie mit sichtbarem Rauch.

## 8. Konsistenzanker je Figur (Brustbild, ohne Lösungsbezug)
Kein Porträt zeigt Taler, Schlüsselbund, Laken, Lampe, Kerzenständer, Code-Zettel, Wanderstiefel oder Ruß. Jede Figur hält höchstens ihr Signaturstück. Grün tragen im Bild nur Merle (Strickjacke) und Jonas (Fleecejacke), so wie im öffentlichen Steckbrief.
@LF-BW [O] | Figur: Eckehard Lüddecke, Burgwart | Anker (EN): a sturdy 71-year-old man from the Harz mountains, weathered face, bushy white eyebrows, short white beard, reading glasses pushed up on his forehead, corduroy trousers, knitted waistcoat with many pockets, warm grumpy smile
@LF-R01 [O] | Figur: Adnan Hodžić | Anker (EN): a 33-year-old man with short dark brown hair and a neatly trimmed beard, calm practical look, grey knitted beanie, black work jacket with many pockets, a multitool on his belt
@LF-R02 [O] | Figur: Rojda Baran | Anker (EN): a 29-year-old woman with long dark curly hair, lively dark eyes, black hoodie, large headphones around her neck, mid-sentence expression
@LF-R03 [O] | Figur: Merle Hartwig | Anker (EN): a 28-year-old woman with shoulder-length light brown hair held by a hair clip, freckles, curious friendly eyes, dark green cable-knit cardigan over a white blouse, holding a small notebook
@LF-R04 [O] | Figur: Jonas Brinkmann | Anker (EN): a 34-year-old man with short blond hair and a salesman smile, olive green fleece jacket over a checked shirt, big-faced wristwatch, both hands raised as if presenting something
@LF-R05 [O] | Figur: Paulina Zielińska | Anker (EN): a 31-year-old woman with a dark blonde bob and slim glasses, dark blue corduroy blazer with a pen tucked in the lapel, skeptical raised eyebrow
@LF-R06 [O] | Figur: Diyar Kaya | Anker (EN): a 34-year-old man with short black hair and stubble, calm attentive look, dark blue functional jacket, dark red neckerchief
@LF-R07 [O] | Figur: Emre Kaplan | Anker (EN): a 30-year-old man with wavy dark hair, worn brown leather jacket covered in small theatre pins, slightly sulky smile
@LF-R08 [O] | Figur: Lejla Mehmedović | Anker (EN): a 27-year-old woman with dark hair in a low bun, small ladybug earrings, dark blue cotton sweater, thoughtful teacher look
@LF-R09 [O] | Figur: Tomasz Wróbel | Anker (EN): a 36-year-old man with short reddish-brown hair and a broad friendly face, dark blue cotton chef apron without pockets, nervous happy expression
@LF-R10 [O] | Figur: Annika Thielemann | Anker (EN): a 30-year-old woman with a short platinum blonde pixie cut, mustard yellow dungarees, a pencil behind her ear, secretive smile
@LF-R11 [O] | Figur: Berfin Demir | Anker (EN): a 26-year-old woman with long straight black hair, dark blue down jacket with a small embroidered Saturn patch, a red-light headlamp around her neck, dreamy gaze upward
@LF-R12 [O] | Figur: Dino Begović | Anker (EN): a 32-year-old tall man with short dark hair and glasses, anthracite quilted vest with a folding ruler in the side pocket, knocking on a stone wall with one knuckle
@LF-R13 [O] | Figur: Selin Aksoy | Anker (EN): a 33-year-old woman with dark hair in a sleek ponytail, navy blue trouser suit, a red enamel pomegranate brooch, composed businesslike look
@LF-R14 [O] | Figur: Kamil Nowak | Anker (EN): a 35-year-old man with short light brown hair and a full beard, dark blue corduroy waistcoat over a grey t-shirt, a flat carpenter pencil behind his right ear, grumbling expression
@LF-R15 [O] | Figur: Derya Öztürk | Anker (EN): a 29-year-old woman with long dark brown wavy hair, bordeaux red blazer with a folded pocket square, black shirt, reassuring smile
@LF-R16 [O] | Figur: Amar Softić | Anker (EN): a 37-year-old man with slicked-back dark hair and a short grey-flecked beard, anthracite jacket, dark shirt, small house-shaped cufflinks, confident host gesture
@LF-R17 [O] | Figur: Henrik Vogt | Anker (EN): a 38-year-old man with sandy hair and a short beard, rust red softshell jacket, brown leather hat with a blue-banded jay feather, calm outdoorsy look
@LF-R18 [O] | Figur: Elif Şahin | Anker (EN): a 25-year-old woman with dark curly hair to the shoulders, dark blue shirt dress, a round button pin on the collar, eager raised hand
@LF-R19 [O] | Figur: Azad Tekin | Anker (EN): a 31-year-old man with short black hair and a goatee, black leather jacket, a wide red camera strap across his chest, squinting as if framing a shot
@LF-R20 [O] | Figur: Zofia Lis | Anker (EN): a 28-year-old woman with a long light brown braid, dark blue down vest over a grey hoodie, orange neckerchief with small fox silhouettes, amused storyteller grin

## 9. Aufbau eines Bildprompt-Eintrags (verbindlich)
    BILD-ID: <Kennung, z. B. BILD-FIG-R07>
    Motiv: <Deutsch, 1 Satz>
    Prompt (EN): <60–110 Wörter: Motiv, Ort-/Figurenanker, Licht, Palette, Kamera, Stilanker>
    Negativ (EN): <Negativ-Anker aus Abschnitt 6, wortgleich>
    Format: <Seitenverhältnis aus Abschnitt 5>
    Zweck und Einsatz (DE): <20–40 Wörter>
