F3-AUTOR-65 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die englischen Bildbeschreibungen für alle Personen, Räume und die beweisrelevanten Spuren als Kanon-Datei bild.json.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "stilanker": "cinematic documentary film still, 35mm, natural dramatic lighting, real-life texture, no CGI, no cartoon",
 "negativliste": "no text, no letters, no logos, no brand names, no real people, no celebrities, no alcohol, no wine, no beer, no bottles, no bar counter, no barrels, no cigarettes, no smoke from pipes, no vape, no blood, no injuries",
 "personen": [
  {
   "id": "detective",
   "name": null,
   "title": "Der Detektiv / Die Detektivin (Geburtstagskind)",
   "geschlecht": null,
   "selectableGenders": [
    "m",
    "w"
   ],
   "age": null,
   "look": {
    "haut": "#d9a983",
    "haar": "#4a3222",
    "kopf": "detektivhut",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Mittelgroß, aufmerksame Haltung, Kopf leicht schief beim Zuhören",
    "baseOutfit": "Heller sandbeiger Trenchcoat über Alltagskleidung, schwarze Jeans, dunkle Turnschuhe",
    "accessories": [
     "Markante Brille",
     "Braun karierter Detektivhut",
     "Unangezündete Pfeife, aus der Seifenblasen steigen"
    ],
    "interactiveTool": "Handy in der Hand mit Taschenlampen-Lichtkegel",
    "idleAnimation": "Bläst mit der Pfeife ein paar Seifenblasen und tippt aufs Handy"
   },
   "colorCode": "#B8A48A",
   "farbname": "Sandbeige"
  },
  {
   "id": "schneider",
   "name": "Herr Schneider",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 61,
   "look": {
    "haut": "#e8c9b0",
    "haar": "#9a9a9a",
    "kopf": "none",
    "statur": "broad",
    "schnitt": "suit",
    "glatze": true
   },
   "visualSpecs": {
    "silhouette": "Breiter, leicht gebeugter Körperbau, Halbglatze, Brille, graues schütteres Haar",
    "outfit": "Dunkelgrüne Wachsjacke über grobem grauem Rollkragenpullover, derbe Arbeitsstiefel",
    "distinguishingFeature": "Großer klimpernder Schlüsselbund an der rechten Gürtelschlaufe, Klemmbrett mit Quittungsblock",
    "idleAnimation": "Tippt auf die Armbanduhr und hakt etwas auf dem Klemmbrett ab"
   },
   "colorCode": "#2E473B",
   "farbname": "Dunkelgrün"
  },
  {
   "id": "ahmet",
   "name": "Ahmet",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 27,
   "look": {
    "haut": "#d9a983",
    "haar": "#1a1412",
    "kopf": "none",
    "statur": "slim",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Schlank, aufrecht, sportliche Haltung, Brille, kurzer Bart",
    "outfit": "Schwarzer Strickpulli über weißem T-Shirt, dunkle Jeans, weiße Turnschuhe. Die schwarze Stoffjacke hängt ab 23:55 am Jackenständer im Ost-Saal.",
    "distinguishingFeature": "Blaues Schlüsselband aus der Hosentasche, Handy in der Hand (ab 0:05, vorher im Handykorb)",
    "idleAnimation": "Dreht das Schlüsselband um den Finger und streicht sich nervös durch den Bart"
   },
   "colorCode": "#1A1A1A",
   "farbname": "Schwarz und Weiß"
  },
  {
   "id": "fatma",
   "name": "Fatma",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 26,
   "look": {
    "haut": "#e6be9e",
    "haar": "#2b1d14",
    "kopf": "kopftuch",
    "statur": "slim",
    "schnitt": "dress",
    "kopftuchFarbe": "#3b3436"
   },
   "visualSpecs": {
    "silhouette": "Schlanke Statur, dunkles Kopftuch, knielanger Wollmantel",
    "outfit": "Weinroter Wollmantel, dunkler Rollkragen, schwarze Stoffhose, dunkles Kopftuch",
    "distinguishingFeature": "Schwere Umhängetasche aus Leder, breiter Silberring an der rechten Hand",
    "idleAnimation": "Nestelt am Reißverschluss ihrer Tasche und lächelt Emine zu"
   },
   "colorCode": "#6B1D2F",
   "farbname": "Weinrot"
  },
  {
   "id": "olli",
   "name": "Olli",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 28,
   "look": {
    "haut": "#f1d3bc",
    "haar": "#7a5638",
    "kopf": "none",
    "statur": "broad",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Breit gebaut, kräftige Schultern, leicht gebeugte Haltung",
    "outfit": "Grauer Kapuzenpulli, dunkelblaue Daunenweste, Khakihose mit Seitentaschen",
    "distinguishingFeature": "Holzsplitter und weißer Kalk an den Ärmeln des Pullis; der rechte Arbeitshandschuh hängt aus der Westentasche, der linke liegt seit 19:30 am Kamin",
    "idleAnimation": "Reibt sich den Nacken, wechselt das Standbein und schaut auf seine Hände"
   },
   "colorCode": "#1F3A52",
   "farbname": "Marineblau und Khaki"
  },
  {
   "id": "can",
   "name": "Can",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 25,
   "look": {
    "haut": "#c69270",
    "haar": "#1a1412",
    "kopf": "none",
    "statur": "slim",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Jugendlich, schlank, federnder Gang",
    "outfit": "Signalgelber weiter Kapuzenpulli, weite Jeans, bunte Turnschuhe",
    "distinguishingFeature": "Auffällige gelbe Kapuze, linke Hand tief in der Bauchtasche des Pullis (dort steckt die Maske)",
    "idleAnimation": "Zieht an den Kapuzenbändern und wippt auf den Zehenspitzen"
   },
   "colorCode": "#F5C400",
   "farbname": "Signalgelb"
  },
  {
   "id": "leyla",
   "name": "Lejla",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 25,
   "look": {
    "haut": "#e6be9e",
    "haar": "#2b1d14",
    "kopf": "bun",
    "statur": "small",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Zierlich, Haare zu einem straffen Dutt gebunden",
    "outfit": "Türkise Latzschürze über beigem Strickpulli, dunkle Leggings",
    "distinguishingFeature": "Abrechnungsblock in der Schürzentasche, Holzlöffel in der Hand",
    "idleAnimation": "Rückt Schüsseln gerade und rührt im Warmhaltebehälter"
   },
   "colorCode": "#178582",
   "farbname": "Türkis"
  },
  {
   "id": "emine",
   "name": "Emine",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 26,
   "look": {
    "haut": "#d9a983",
    "haar": "#2b1d14",
    "kopf": "kopftuch",
    "statur": "normal",
    "schnitt": "dress",
    "kopftuchFarbe": "#d8c6a5"
   },
   "visualSpecs": {
    "silhouette": "Mittelgroß, ruhige Haltung, beiges Kopftuch",
    "outfit": "Olivgrüner Steppmantel, beiges Kopftuch, dunkle Stoffhose, schwarze Stiefel",
    "distinguishingFeature": "Hält eine silberne Thermosflasche mit beiden Händen",
    "idleAnimation": "Dreht den Deckel der Thermosflasche auf und zu und schaut zu Fatma"
   },
   "colorCode": "#5E6E3A",
   "farbname": "Olivgrün"
  },
  {
   "id": "tim",
   "name": "Tim",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 27,
   "look": {
    "haut": "#e6be9e",
    "haar": "#4a3222",
    "kopf": "none",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Kräftig, mittelgroß, lockige Haare",
    "outfit": "Rot-schwarz kariertes Flanellhemd über dunklem Shirt, derbe Arbeitshose",
    "distinguishingFeature": "Spannungsprüfer-Schraubenzieher hinter dem Ohr, kleine Stirnlampe um den Hals",
    "idleAnimation": "Klopft prüfend gegen Kabelkanäle und schüttelt den Kopf"
   },
   "colorCode": "#992222",
   "farbname": "Karorot"
  },
  {
   "id": "johanna",
   "name": "Joanna",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 24,
   "look": {
    "haut": "#f1d3bc",
    "haar": "#c9a86a",
    "kopf": "none",
    "statur": "slim",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Schlank, aufrecht, schnelle Bewegungen",
    "outfit": "Violetter Cardigan über weißem Top, schwarze Stoffhose",
    "distinguishingFeature": "Handy auf einem kleinen Handyhalter mit Aufsteckleuchte",
    "idleAnimation": "Hebt das Handy, wischt durch Fotos und zoomt hinein"
   },
   "colorCode": "#6A3587",
   "farbname": "Violett"
  },
  {
   "id": "murat",
   "name": "Marek",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 28,
   "look": {
    "haut": "#d9a983",
    "haar": "#2b1d14",
    "kopf": "none",
    "statur": "broad",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Breitschultrig, sportlich, markante Gesichtszüge",
    "outfit": "Dunkelbraune Lederjacke, weißer Rollkragen, dunkle Jeans",
    "distinguishingFeature": "Lässt den Autoschlüssel mit glänzendem Anhänger um den Zeigefinger kreisen",
    "idleAnimation": "Zählt die Warmhaltebehälter durch und schaut auf die Uhr"
   },
   "colorCode": "#664229",
   "farbname": "Lederbraun"
  },
  {
   "id": "zeynep",
   "name": "Zeynep",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 23,
   "look": {
    "haut": "#c69270",
    "haar": "#2b1d14",
    "kopf": "cap",
    "statur": "small",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Zierlich, sportlich, lässiger Stil",
    "outfit": "Minzgrüner weiter Pulli, weite hellgraue Hose, Kappe verkehrt herum",
    "distinguishingFeature": "Weiße Kopfhörer locker um den Hals, kaut Kaugummi",
    "idleAnimation": "Kaut Kaugummi, wippt auf den Absätzen und behält Can im Blick"
   },
   "colorCode": "#3EB489",
   "farbname": "Minzgrün"
  },
  {
   "id": "baran",
   "name": "Baran",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 26,
   "look": {
    "haut": "#a87655",
    "haar": "#1a1412",
    "kopf": "none",
    "statur": "tall",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Groß, schlank, leicht nach vorn geneigt",
    "outfit": "Anthrazitfarbener Kapuzenpulli mit neongrünen Kordeln, schwarze Jogginghose",
    "distinguishingFeature": "Große Kopfhörer auf dem Kopf (in der Tatnacht trägt sie das Geburtstagskind), tragbare Musikbox unter dem Arm",
    "idleAnimation": "Wippt im Takt und dreht am Lautstärkerad der Box"
   },
   "colorCode": "#333333",
   "farbname": "Anthrazit mit Neongrün"
  },
  {
   "id": "meryem",
   "name": "Hana",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 25,
   "look": {
    "haut": "#f1d3bc",
    "haar": "#8a3b1e",
    "kopf": "none",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Mittelgroß, praktische Statur, hochgekrempelte Ärmel",
    "outfit": "Dunkelblaues Jeanshemd, feste Arbeitshose, Schnürstiefel",
    "distinguishingFeature": "Rußflecken auf der linken Wange und an den Händen, Schürhaken in der Hand",
    "idleAnimation": "Pustet sich eine Strähne aus der Stirn und wischt die Hände an einem alten Lappen ab"
   },
   "colorCode": "#2B4C7E",
   "farbname": "Jeansblau"
  },
  {
   "id": "serkan",
   "name": "Serkan",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 29,
   "look": {
    "haut": "#c69270",
    "haar": "#2b1d14",
    "kopf": "cap",
    "statur": "broad",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Kräftig, breite Statur, aufrechte Haltung",
    "outfit": "Stahlblaue Steppweste über grauem Sweatshirt, dunkle Kappe",
    "distinguishingFeature": "Klemmbrett mit Fahrzeiten, schwere Taschenlampe",
    "idleAnimation": "Rüttelt am Riegel des Außentors und leuchtet aufs Schloss"
   },
   "colorCode": "#3A506B",
   "farbname": "Stahlblau"
  },
  {
   "id": "aylin",
   "name": "Aylin",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 24,
   "look": {
    "haut": "#d9a983",
    "haar": "#1a1412",
    "kopf": "none",
    "statur": "slim",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Sehr gerade Haltung, sachlich",
    "outfit": "Taubenblauer Strickcardigan, weiße Bluse, schwarze Stoffhose",
    "distinguishingFeature": "Schwarze Ledermappe mit Belegen und Kugelschreiber, fest an die Brust gedrückt",
    "idleAnimation": "Klickt mit dem Kugelschreiber und sieht zu Ahmet hinüber"
   },
   "colorCode": "#3A6EA5",
   "farbname": "Taubenblau"
  },
  {
   "id": "kaan",
   "name": "Wojtek",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 27,
   "look": {
    "haut": "#e6be9e",
    "haar": "#c9a86a",
    "kopf": "none",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Schlank, ruhige Haltung, Brille",
    "outfit": "Aschgrauer Kapuzenpulli, schwarze Arbeitshose mit verstärkten Knien",
    "distinguishingFeature": "Zimmermannsbleistift hinter dem Ohr, Maßband am Hosenbund, ein Finger mit Pflaster",
    "idleAnimation": "Streicht mit dem Daumen über die Schramme an der Bogentür"
   },
   "colorCode": "#5C677D",
   "farbname": "Aschgrau"
  },
  {
   "id": "dilara",
   "name": "Azra",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 26,
   "look": {
    "haut": "#c69270",
    "haar": "#1a1412",
    "kopf": "kopftuch",
    "statur": "tall",
    "schnitt": "dress",
    "kopftuchFarbe": "#e8dcc4"
   },
   "visualSpecs": {
    "silhouette": "Groß, elegante Bewegungen, cremefarbenes Kopftuch",
    "outfit": "Pflaumenfarbenes Samtkleid, langer schwarzer Strickcardigan, cremefarbenes Kopftuch",
    "distinguishingFeature": "Kleine Lupe an einer Silberkette um den Hals, auffällige Ringe aus Holz und Stein",
    "idleAnimation": "Betrachtet ihre Ringe durch die Lupe und schaut zur Theke"
   },
   "colorCode": "#7A2E5C",
   "farbname": "Pflaume"
  },
  {
   "id": "enes",
   "name": "Damir",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 25,
   "look": {
    "haut": "#d9a983",
    "haar": "#4a3222",
    "kopf": "none",
    "statur": "slim",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Schlank, aufmerksam, flinke Hände",
    "outfit": "Weißes Hemd mit hochgekrempelten Ärmeln, schwarze Schürze",
    "distinguishingFeature": "Hält ein schmales Teeglas auf einer Untertasse",
    "idleAnimation": "Poliert Teegläser mit einem weißen Tuch und prüft den Teekocher"
   },
   "colorCode": "#E5E5E5",
   "farbname": "Weiß mit Schwarz"
  },
  {
   "id": "selin",
   "name": "Sibel",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 23,
   "look": {
    "haut": "#e6be9e",
    "haar": "#7a5638",
    "kopf": "none",
    "statur": "small",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Klein, zieht oft die Schultern hoch",
    "outfit": "Pastellrosa Strickpulli, helle Jeans, weißer Fransenschal",
    "distinguishingFeature": "Zieht den Fransenschal bis übers Kinn",
    "idleAnimation": "Schaut sich um und zuckt bei lauten Geräuschen zusammen"
   },
   "colorCode": "#D8A7B1",
   "farbname": "Pastellrosa"
  },
  {
   "id": "hakan",
   "name": "Pawel",
   "title": null,
   "geschlecht": "m",
   "selectableGenders": null,
   "age": 30,
   "look": {
    "haut": "#a87655",
    "haar": "#2b1d14",
    "kopf": "none",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Ruhig, aufrecht, gelassene Haltung",
    "outfit": "Schokobraune Steppjacke über beigem Rollkragen, Halbschuhe",
    "distinguishingFeature": "Dunkelbraune Ledertasche neben sich, Teetasse in der Hand",
    "idleAnimation": "Nimmt einen langsamen Schluck Tee und beobachtet die Gruppe"
   },
   "colorCode": "#4A3728",
   "farbname": "Schokobraun"
  },
  {
   "id": "tugba",
   "name": "Tugba",
   "title": null,
   "geschlecht": "w",
   "selectableGenders": null,
   "age": 27,
   "look": {
    "haut": "#d9a983",
    "haar": "#1a1412",
    "kopf": "none",
    "statur": "normal",
    "schnitt": "suit"
   },
   "visualSpecs": {
    "silhouette": "Organisiert, schwungvoll, geschäftsmäßig",
    "outfit": "Bordeauxroter Blazer über weißem Shirt, schmale Metallbrille",
    "distinguishingFeature": "Notizbuch mit goldenem Einband und Fineliner",
    "idleAnimation": "Blättert im Notizbuch, hakt Zeilen ab und schaut zur Wanduhr"
   },
   "colorCode": "#800020",
   "farbname": "Bordeaux mit Gold"
  }
 ],
 "raeume": [
  {
   "id": "thekensaal",
   "name": "Thekensaal (Zentrum)",
   "anzeigename": "Buffetsaal",
   "beschreibung": "Länglicher Gewölbesaal, Knotenpunkt des Kellers. Gegenüber dem Eingang steht die Buffettheke aus dunklem Holz, dahinter die Anrichte an der Nordwand. Links und rechts an den Längswänden die Buffettische.",
   "features": [
    "Buffettheke mit Anrichte",
    "Linker Buffettisch",
    "Rechter Buffettisch",
    "Großer Teekocher",
    "Kaffeemaschine",
    "Spüle",
    "Eiskübel",
    "Notausgangsschild"
   ],
   "boden": "stone"
  },
  {
   "id": "vorratsraum",
   "name": "Vorratsraum",
   "anzeigename": "Vorratsraum",
   "beschreibung": "Kleiner, kühler Raum ohne Fenster hinter der Buffettheke. Einziger Zugang ist die Tür neben der Anrichte.",
   "features": [
    "Regale",
    "Geburtstagstorte",
    "Notlaterne am Haken"
   ],
   "boden": "stone"
  },
  {
   "id": "durchgang",
   "name": "Durchgang",
   "anzeigename": "Durchgang",
   "beschreibung": "Kurzer, niedriger Gang zwischen West-Saal und Buffetsaal. Hier stehen die Getränkekisten.",
   "features": [
    "Getränkekisten"
   ],
   "boden": "stone"
  },
  {
   "id": "west_saal",
   "name": "West-Saal",
   "anzeigename": "Kaminsaal",
   "beschreibung": "Gemeinschaftssaal mit zwei langen Tafeln und Wandbänken. In der Westwand die Kamin-Nische, hoch in der Nordwand zwei Lichtschächte mit Klappen, in der Nordwestecke die geschnitzte Bogentür zum Turm.",
   "features": [
    "Lange Tafeln",
    "Wandbänke",
    "Kamin-Nische",
    "Sicherungskasten",
    "Lichtschächte mit Klappen",
    "Bogentür zum Turmgang"
   ],
   "boden": "stone"
  },
  {
   "id": "turmgang",
   "name": "Turmgang",
   "anzeigename": "Turmgang",
   "beschreibung": "Schmaler Gang im Fuß des Schlossturms. Hier stehen die alte Ritterrüstung und die Schauvitrine. Die Wendeltreppe führt hinauf zu den Toiletten; der Rest des Turms ist mit einem Vorhängeschloss abgesperrt.",
   "features": [
    "Ritterrüstung",
    "Schauvitrine",
    "Wendeltreppe zum WC",
    "Hoftür (verschlossen)"
   ],
   "boden": "stone"
  },
  {
   "id": "ost_saal",
   "name": "Ost-Saal",
   "anzeigename": "Ostsaal",
   "beschreibung": "Ruhiger Gemeinschaftssaal ohne weitere Außentür. Am Eingang steht der Jackenständer, an der Ostwand die Wandtafel mit dem Ablaufplan des Abends.",
   "features": [
    "Lange Tafeln",
    "Wandbänke",
    "Jackenständer",
    "Wandtafel mit Ablaufplan",
    "Handykorb"
   ],
   "boden": "stone"
  },
  {
   "id": "windfang",
   "name": "Windfang",
   "anzeigename": "Windfang",
   "beschreibung": "Kleiner Vorraum zwischen der Innentür des Buffetsaals und dem Außentor.",
   "features": [
    "Innentür",
    "Außentor"
   ],
   "boden": "stone"
  }
 ],
 "beweise": [
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_griff_papier",
   "rolle": {
    "ahmet": "schluesselbeweis"
   },
   "zeigt": "Im erstarrten Wachs am Griff klebt eine abgerissene Ecke braunes Umschlagpapier. Darauf steht „…keller“, in Ahmets Handschrift.",
   "harmlos": "Der Griff ist mit rotem Wachs verschmiert."
  },
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_griff_leuchtfarbe",
   "rolle": {
    "can": "schluesselbeweis"
   },
   "zeigt": "Um den Griff liegt der Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe, derselben Farbe wie auf der Maske.",
   "harmlos": "Der Griff ist mit rotem Wachs verschmiert."
  },
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_fuss_splitter",
   "rolle": {
    "olli": "schluesselbeweis"
   },
   "zeigt": "Im roten Wachs am Fuß, das inzwischen erstarrt ist, kleben feine Holzsplitter und weißer Kalk.",
   "harmlos": "Am Fuß klebt rotes Wachs."
  },
  {
   "gegenstand": "silberring_fatma",
   "spur": "spur_ring_messing",
   "rolle": {
    "fatma": "schluesselbeweis"
   },
   "zeigt": "Frischer goldgelber Messingabrieb in einer Kerbe des Rings.",
   "harmlos": "Nur feine Kratzer von der Glasscheibe der Vitrine, kein Messing."
  },
  {
   "gegenstand": "jacke_ahmet",
   "spur": "spur_jacke_bund",
   "rolle": {
    "ahmet": "fundort"
   },
   "zeigt": "In der Innentasche steckt Herrn Schneiders großer Schlüsselbund.",
   "harmlos": "Die Innentasche ist leer bis auf ein Kaugummipapier."
  },
  {
   "gegenstand": "umschlag_mietgeld",
   "spur": "spur_umschlag_wachs",
   "rolle": {
    "ahmet": "zusatzindiz"
   },
   "zeigt": "Drei erstarrte rote Wachstropfen. Eine Ecke des Umschlags ist abgerissen.",
   "harmlos": "Kein Wachs, nur ein Knick."
  },
  {
   "gegenstand": "muenzschatulle",
   "spur": "spur_schatulle_wachs",
   "rolle": {
    "fatma": "zusatzindiz"
   },
   "zeigt": "Auf dem Deckel kleben rote Wachstropfen.",
   "harmlos": "Der Deckel ist sauber."
  },
  {
   "gegenstand": "leuchtmaske",
   "spur": "spur_maske_wachs",
   "rolle": {
    "can": "zusatzindiz"
   },
   "zeigt": "Rote Wachstropfen auf der Stirn der Maske.",
   "harmlos": "Kein Wachs, nur Leuchtfarbe."
  },
  {
   "gegenstand": "eiskuebel",
   "spur": "spur_eiskuebel_bund",
   "rolle": {
    "olli": "fundort"
   },
   "zeigt": "Unter den Eiswürfeln liegt Herrn Schneiders Schlüsselbund.",
   "harmlos": "Nur Eis und Schmelzwasser."
  },
  {
   "gegenstand": "brottasche",
   "spur": "spur_brottasche_bund",
   "rolle": {
    "fatma": "fundort"
   },
   "zeigt": "Unter dem Brot liegt Herrn Schneiders Schlüsselbund.",
   "harmlos": "Nur Brot und Krümel."
  },
  {
   "gegenstand": "ruestungshelm",
   "spur": "spur_helm_bund",
   "rolle": {
    "can": "fundort"
   },
   "zeigt": "Im Helm klemmt Herrn Schneiders Schlüsselbund.",
   "harmlos": "Im Helm nur Staub und eine alte Spinnwebe."
  },
  {
   "gegenstand": "handschuh_weste_olli",
   "spur": "spur_weste_kerzenwachs",
   "rolle": {
    "olli": "zusatzindiz"
   },
   "zeigt": "Auf dem Handrücken kleben frische rote Kerzenwachstropfen.",
   "harmlos": "Kein rotes Wachs, nur Kalkstaub."
  }
 ]
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/bild.json (neu, nur du schreibst sie):
{"settingId":"spuk_im_schlosskeller","hinweis":"Englische Bildbeschreibungen für die Bildprompts (TON-LEITFADEN §9). Nur Kleidung, Farbe, Merkmal, Haltung, Alter, Haar; keine Herkunfts- oder Ethnienwörter.","stil":"<stilanker wortgleich>","negativ":"<negativliste wortgleich>",
 "personen":[{"id":"<id>","alter":"late twenties|…","kleidung":"…","merkmal":"…","haltung":"…","haar":"…","kopf":"…"}],
 "raeume":[{"id":"<raum-id>","beschreibung":"…"}],
 "beweise":[{"spur":"<spur-id>","beschreibung":"…"}]}
- personen: alle 22 Personen (Detektiv, Opfer, 20 Figuren) mit derselben id wie im Auszug; alter aus age (z. B. 27 → „late twenties“), beim Detektiv ohne Alter „late twenties“. Englisch, kurze Nominalphrasen. kleidung und merkmal aus visualSpecs übersetzt, OHNE Farbe des colorCode (die setzt der Generator dazu). Keine Herkunft, keine Religion, keine Ethnie, keine Hautfarbwörter. Kopftuch heißt „headscarf“. Die Pfeife des Detektivs: „an unlit bubble pipe blowing soap bubbles“. Keine Marken, keine Schrift auf Kleidung, kein Handy-Logo.
- raeume: alle Räume aus dem Auszug (id wie dort): Gewölbe, Licht, Möbel aus features, ohne Flaschen, ohne Theke mit Zapfhahn (die Buffettheke ist ein Holztresen mit Teekocher und Kaffeemaschine), ohne Rauch außer im Kaminsaal (kalter Kamin).
- beweise: alle Spuren aus dem Auszug (spur-id wie dort), Nahaufnahme des Fundes nach zeigt, ohne Blut, ohne Verletzung.

EIGENE DATEIEN: content/party/schlosskeller/bild.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN §9 und den Auszug.
2. Schreibe bild.json.
3. Prüfe mit python3 -m json.tool.

ABNAHMEKRITERIEN UND TESTWEG: 22 Personen, alle Räume, alle Spuren aus dem Auszug; Stil und Negativliste wortgleich; keine Herkunftswörter.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-65
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Personen/Räume/Beweise: <Zahlen>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-65 · BEREIT ZUR RÜCKGABE ===
