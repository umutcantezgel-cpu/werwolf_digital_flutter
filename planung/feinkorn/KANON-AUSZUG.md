# KANON-AUSZUG · Schlosskeller (Kanon v1.0.0)

Auszug für den Figuren- und Architektur-Baukasten. Erstellt im Auftrag K0-KUNDSCHAFTER-02 (Kundschafter, Bauphase K0, Version 1). Nur Lesezugriff auf `content/party/schlosskeller/**`.

**Quelle (Kanon v1.0.0):** `content/party/schlosskeller/` mit `figuren.json`, `raeume.json`, `gegenstaende.json`, `setting.json`, `zeitleiste.json`. Versionsnachweis: `fall.json:3` (`"kanonVersion": "1.0.0"`).
**Nicht benutzt:** `planung/finalisierung-schlosskeller/KANON-ENTWURF.md` (veraltet).

**Konventionen**
- Fundstelle `Datei:Zeile` bezieht sich auf `content/party/schlosskeller/<Datei>`. Einzelwert: Zeile des Schlüssels bzw. des Listenelements. Objekt oder Liste: Zeilenspanne von der öffnenden bis zur schließenden Klammer.
- Werte sind wörtlich aus dem JSON übernommen: Texte unverändert, Zahlen sowie `true`/`false` wie in der Quelle. Beim Erzeugen wurde jeder Blattwert gegen seine Quellzeile geprüft.
- `—` bedeutet: Feld fehlt im Block. Die Fundstelle nennt dann den Block.
- Schlüssel, die nicht Aussehen, Bewegung oder Bau betreffen, sind nicht übernommen. Sie stehen je Block mit Zeile unter „Nicht übernommen“, damit nichts unbemerkt fehlt.

---

## 1. Figuren (22)

Quelle: `figuren.json`. Hinweis der Quelle (`figuren.json:3`): IDs bleiben Schlüssel, Anzeigenamen können wechseln (E-014). Koordinaten sind Meter auf dem Raster aus `raeume.json`. Positionen in der Tatnacht stehen in den Tatmatrix-Dateien.
Hinweis zu `look` (`figuren.json:1083`): Kopf-, Statur- und Schnitt-Werte sind Renderer-Kategorien.

### Übersicht

| Nr | id | Anzeigename (name bzw. title) | Rolle (roleTitle bzw. title) | colorCode | farbname | Block |
|---|---|---|---|---|---|---|
| 1 | detective | Der Detektiv / Die Detektivin (Geburtstagskind) | Der Detektiv / Die Detektivin (Geburtstagskind) | #B8A48A | Sandbeige | figuren.json:4–40 |
| 2 | schneider | Herr Schneider | Schlossverwalter | #2E473B | Dunkelgrün | figuren.json:41–77 |
| 3 | ahmet | Ahmet | Der Organisator | #1A1A1A | Schwarz und Weiß | figuren.json:79–145 |
| 4 | fatma | Fatma | Die Designstudentin | #6B1D2F | Beerenrot | figuren.json:146–213 |
| 5 | olli | Olli | Der Anpacker | #1F3A52 | Marineblau und Khaki | figuren.json:214–276 |
| 6 | can | Can | Der Spaßvogel | #F5C400 | Signalgelb | figuren.json:277–344 |
| 7 | leyla | Lejla | Die Buffet-Chefin | #178582 | Türkis | figuren.json:345–393 |
| 8 | emine | Emine | Die Grundschullehrerin | #5E6E3A | Olivgrün | figuren.json:394–439 |
| 9 | tim | Tim | Der Hobby-Elektriker | #992222 | Karorot | figuren.json:440–484 |
| 10 | johanna | Joanna | Die Fotografin des Abends | #6A3587 | Violett | figuren.json:485–533 |
| 11 | murat | Marek | Der Caterer | #664229 | Lederbraun | figuren.json:534–582 |
| 12 | zeynep | Zeynep | Die Fußballtrainerin | #3EB489 | Minzgrün | figuren.json:583–630 |
| 13 | baran | Baran | Der Mann für die Musik | #333333 | Anthrazit mit Neongrün | figuren.json:631–672 |
| 14 | meryem | Hana | Die Kamin-Heizerin | #2B4C7E | Jeansblau | figuren.json:673–718 |
| 15 | serkan | Serkan | Der Fahrdienst-Organisator | #3A506B | Stahlblau | figuren.json:719–760 |
| 16 | aylin | Aylin | Die Kassenprüferin | #3A6EA5 | Taubenblau | figuren.json:761–802 |
| 17 | kaan | Wojtek | Der Architekturstudent | #5C677D | Aschgrau | figuren.json:803–854 |
| 18 | dilara | Azra | Die Flohmarkt-Kennerin | #7A2E5C | Pflaume | figuren.json:855–901 |
| 19 | enes | Damir | Der Teemeister | #E5E5E5 | Weiß mit Schwarz | figuren.json:902–947 |
| 20 | selin | Sibel | Die Vorsichtige | #D8A7B1 | Pastellrosa | figuren.json:948–993 |
| 21 | hakan | Pawel | Der Vermittler | #4A3728 | Schokobraun | figuren.json:994–1039 |
| 22 | tugba | Tugba | Die Geburtstags-Planerin | #800020 | Karminrot mit Gold | figuren.json:1040–1081 |

### 1. detektiv · Der Detektiv / Die Detektivin (Geburtstagskind)

Block: `figuren.json:4–40`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | detective | figuren.json:5 |
| name | — | kein Feld im Block (figuren.json:4–40) |
| age | — | kein Feld im Block (figuren.json:4–40) |
| geschlecht | — | kein Feld im Block (figuren.json:4–40) |
| title | Der Detektiv / Die Detektivin (Geburtstagskind) | figuren.json:6 |
| colorCode | #B8A48A | figuren.json:11 |
| farbname | Sandbeige | figuren.json:12 |
| startRoom | ost_saal | figuren.json:13 |
| ermittlungsOrt | geburtstagsplatz | figuren.json:14 |
| coordinates.x | 24.5 | figuren.json:16 |
| coordinates.y | 16.5 | figuren.json:17 |
| look.haut | #d9a983 | figuren.json:34 |
| look.haar | #4a3222 | figuren.json:35 |
| look.kopf | detektivhut | figuren.json:36 |
| look.statur | normal | figuren.json:37 |
| look.schnitt | suit | figuren.json:38 |
| visualSpecs.silhouette | Mittelgroß, aufmerksame Haltung, Kopf leicht schief beim Zuhören | figuren.json:20 |
| visualSpecs.baseOutfit | Heller sandbeiger Trenchcoat über Alltagskleidung, schwarze Jeans, dunkle Turnschuhe | figuren.json:21 |
| visualSpecs.accessories[0] | Markante Brille | figuren.json:23 |
| visualSpecs.accessories[1] | Braun karierter Detektivhut | figuren.json:24 |
| visualSpecs.accessories[2] | Unangezündete Pfeife, aus der Seifenblasen steigen | figuren.json:25 |
| visualSpecs.interactiveTool | Handy in der Hand mit Taschenlampen-Lichtkegel | figuren.json:27 |
| visualSpecs.idleAnimation | Bläst mit der Pfeife ein paar Seifenblasen und tippt aufs Handy | figuren.json:28 |
| selectableGenders[0] | m | figuren.json:8 |
| selectableGenders[1] | w | figuren.json:9 |

Nicht übernommen: tatnacht (figuren.json:30), auftrag (figuren.json:31), nieVerdaechtig (figuren.json:32)

### 2. schneider · Herr Schneider (Opfer, NPC)

Block: `figuren.json:41–77`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | schneider | figuren.json:42 |
| name | Herr Schneider | figuren.json:43 |
| age | 61 | figuren.json:44 |
| geschlecht | m | figuren.json:45 |
| roleTitle | Schlossverwalter | figuren.json:46 |
| colorCode | #2E473B | figuren.json:48 |
| farbname | Dunkelgrün | figuren.json:49 |
| startRoom | thekensaal | figuren.json:50 |
| ermittlungsOrt | hinter_rechtem_buffet | figuren.json:51 |
| coordinates.x | 18.5 | figuren.json:53 |
| coordinates.y | 13.5 | figuren.json:54 |
| look.haut | #e8c9b0 | figuren.json:69 |
| look.haar | #9a9a9a | figuren.json:70 |
| look.kopf | none | figuren.json:71 |
| look.statur | broad | figuren.json:72 |
| look.schnitt | suit | figuren.json:73 |
| look.glatze | true | figuren.json:74 |
| visualSpecs.silhouette | Breiter, leicht gebeugter Körperbau, Halbglatze, Brille, graues schütteres Haar | figuren.json:58 |
| visualSpecs.outfit | Dunkelgrüne Wachsjacke über grobem grauem Rollkragenpullover, derbe Arbeitsstiefel | figuren.json:59 |
| visualSpecs.distinguishingFeature | Großer klimpernder Schlüsselbund an der rechten Gürtelschlaufe, Klemmbrett mit Quittungsblock | figuren.json:60 |
| visualSpecs.idleAnimation | Tippt auf die Armbanduhr und hakt etwas auf dem Klemmbrett ab | figuren.json:61 |
| schluesselbund | bund_schneider | figuren.json:66 |
| schluesselbundMaterial | Schlüssel aus dunklem Eisen an einem Stahlring, kein Messing. | figuren.json:76 |

Nicht übernommen: isNpc (figuren.json:47), status (figuren.json:56), motiveAndConflict (figuren.json:63), warmeSeite (figuren.json:64), erinnerung (figuren.json:65), gedaechtnisLueckeAb (figuren.json:67)

### 3. ahmet · Ahmet · Der Organisator

Block: `figuren.json:79–145`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | ahmet | figuren.json:80 |
| name | Ahmet | figuren.json:81 |
| age | 27 | figuren.json:83 |
| geschlecht | m | figuren.json:84 |
| roleTitle | Der Organisator | figuren.json:89 |
| colorCode | #1A1A1A | figuren.json:91 |
| farbname | Schwarz und Weiß | figuren.json:92 |
| startRoom | thekensaal | figuren.json:93 |
| ermittlungsOrt | vor_theke | figuren.json:94 |
| coordinates.x | 14.5 | figuren.json:96 |
| coordinates.y | 10.5 | figuren.json:97 |
| look.haut | #d9a983 | figuren.json:138 |
| look.haar | #1a1412 | figuren.json:139 |
| look.kopf | none | figuren.json:140 |
| look.statur | slim | figuren.json:141 |
| look.schnitt | suit | figuren.json:142 |
| visualSpecs.silhouette | Schlank, aufrecht, sportliche Haltung, Brille, kurzer Bart | figuren.json:100 |
| visualSpecs.outfit | Schwarzer Strickpulli über weißem T-Shirt, dunkle Jeans, weiße Turnschuhe. Die schwarze Stoffjacke hängt ab 23:55 am Jackenständer im Ost-Saal. | figuren.json:101 |
| visualSpecs.distinguishingFeature | Blaues Schlüsselband aus der Hosentasche, Handy in der Hand (ab 0:05, vorher im Handykorb) | figuren.json:102 |
| visualSpecs.idleAnimation | Dreht das Schlüsselband um den Finger und streicht sich nervös durch den Bart | figuren.json:103 |

Nicht übernommen: aussprache (figuren.json:82), herkunft (figuren.json:85), tier (figuren.json:86), besetzungsplatz (figuren.json:87), minPlayers (figuren.json:88), isPotentialKiller (figuren.json:90), motiveAndConflict (figuren.json:105), blackoutAlibi (figuren.json:106), roleSecret (figuren.json:107), persoenlichesZiel (figuren.json:108), nebendelikt (figuren.json:109), loyalitaet (figuren.json:113), luegen (figuren.json:117), innocentProfile (figuren.json:129), killerProfile (figuren.json:132), alltag (figuren.json:144)

### 4. fatma · Fatma · Die Designstudentin

Block: `figuren.json:146–213`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | fatma | figuren.json:147 |
| name | Fatma | figuren.json:148 |
| age | 26 | figuren.json:150 |
| geschlecht | w | figuren.json:151 |
| roleTitle | Die Designstudentin | figuren.json:156 |
| colorCode | #6B1D2F | figuren.json:158 |
| farbname | Beerenrot | figuren.json:159 |
| startRoom | thekensaal | figuren.json:160 |
| ermittlungsOrt | am_linken_buffet | figuren.json:161 |
| coordinates.x | 13.5 | figuren.json:163 |
| coordinates.y | 13.5 | figuren.json:164 |
| look.haut | #e6be9e | figuren.json:205 |
| look.haar | #2b1d14 | figuren.json:206 |
| look.kopf | kopftuch | figuren.json:207 |
| look.statur | slim | figuren.json:208 |
| look.schnitt | dress | figuren.json:209 |
| look.kopftuchFarbe | #3b3436 | figuren.json:210 |
| visualSpecs.silhouette | Schlanke Statur, dunkles Kopftuch, knielanger Wollmantel | figuren.json:167 |
| visualSpecs.outfit | Beerenroter Wollmantel, dunkler Rollkragen, schwarze Stoffhose, dunkles Kopftuch | figuren.json:168 |
| visualSpecs.distinguishingFeature | Schwere Umhängetasche aus Leder, breiter Silberring an der rechten Hand | figuren.json:169 |
| visualSpecs.idleAnimation | Nestelt am Reißverschluss ihrer Tasche und lächelt Emine zu | figuren.json:170 |

Nicht übernommen: aussprache (figuren.json:149), herkunft (figuren.json:152), tier (figuren.json:153), besetzungsplatz (figuren.json:154), minPlayers (figuren.json:155), isPotentialKiller (figuren.json:157), motiveAndConflict (figuren.json:172), blackoutAlibi (figuren.json:173), roleSecret (figuren.json:174), persoenlichesZiel (figuren.json:175), nebendelikt (figuren.json:176), loyalitaet (figuren.json:180), luegen (figuren.json:184), innocentProfile (figuren.json:196), killerProfile (figuren.json:199), alltag (figuren.json:212)

### 5. olli · Olli · Der Anpacker

Block: `figuren.json:214–276`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | olli | figuren.json:215 |
| name | Olli | figuren.json:216 |
| age | 28 | figuren.json:219 |
| geschlecht | m | figuren.json:220 |
| roleTitle | Der Anpacker | figuren.json:225 |
| colorCode | #1F3A52 | figuren.json:227 |
| farbname | Marineblau und Khaki | figuren.json:228 |
| startRoom | ost_saal | figuren.json:229 |
| ermittlungsOrt | ost_tafel_kopf | figuren.json:230 |
| coordinates.x | 22.5 | figuren.json:232 |
| coordinates.y | 10.5 | figuren.json:233 |
| look.haut | #f1d3bc | figuren.json:269 |
| look.haar | #7a5638 | figuren.json:270 |
| look.kopf | none | figuren.json:271 |
| look.statur | broad | figuren.json:272 |
| look.schnitt | suit | figuren.json:273 |
| visualSpecs.silhouette | Breit gebaut, kräftige Schultern, leicht gebeugte Haltung | figuren.json:236 |
| visualSpecs.outfit | Grauer Kapuzenpulli, dunkelblaue Daunenweste, Khakihose mit Seitentaschen | figuren.json:237 |
| visualSpecs.distinguishingFeature | Holzsplitter und weißer Kalk an den Ärmeln des Pullis; der rechte Arbeitshandschuh hängt aus der Westentasche, der linke liegt seit 19:30 am Kamin | figuren.json:238 |
| visualSpecs.idleAnimation | Reibt sich den Nacken, wechselt das Standbein und schaut auf seine Hände | figuren.json:239 |

Nicht übernommen: vollerName (figuren.json:217), aussprache (figuren.json:218), herkunft (figuren.json:221), tier (figuren.json:222), besetzungsplatz (figuren.json:223), minPlayers (figuren.json:224), isPotentialKiller (figuren.json:226), motiveAndConflict (figuren.json:241), blackoutAlibi (figuren.json:242), roleSecret (figuren.json:243), persoenlichesZiel (figuren.json:244), nebendelikt (figuren.json:245), loyalitaet (figuren.json:249), luegen (figuren.json:253), innocentProfile (figuren.json:260), killerProfile (figuren.json:263), alltag (figuren.json:275)

### 6. can · Can · Der Spaßvogel

Block: `figuren.json:277–344`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | can | figuren.json:278 |
| name | Can | figuren.json:279 |
| age | 25 | figuren.json:281 |
| geschlecht | m | figuren.json:282 |
| roleTitle | Der Spaßvogel | figuren.json:287 |
| colorCode | #F5C400 | figuren.json:289 |
| farbname | Signalgelb | figuren.json:290 |
| startRoom | west_saal | figuren.json:291 |
| ermittlungsOrt | west_bank_west | figuren.json:292 |
| coordinates.x | 1.5 | figuren.json:294 |
| coordinates.y | 10.5 | figuren.json:295 |
| look.haut | #c69270 | figuren.json:336 |
| look.haar | #1a1412 | figuren.json:337 |
| look.kopf | none | figuren.json:338 |
| look.statur | slim | figuren.json:339 |
| look.schnitt | suit | figuren.json:340 |
| visualSpecs.silhouette | Jugendlich, schlank, federnder Gang | figuren.json:298 |
| visualSpecs.outfit | Signalgelber weiter Kapuzenpulli, weite Jeans, bunte Turnschuhe | figuren.json:299 |
| visualSpecs.distinguishingFeature | Auffällige gelbe Kapuze, linke Hand tief in der Bauchtasche des Pullis (dort steckt die Maske) | figuren.json:300 |
| visualSpecs.idleAnimation | Zieht an den Kapuzenbändern und wippt auf den Zehenspitzen | figuren.json:301 |

Nicht übernommen: aussprache (figuren.json:280), herkunft (figuren.json:283), tier (figuren.json:284), besetzungsplatz (figuren.json:285), minPlayers (figuren.json:286), isPotentialKiller (figuren.json:288), motiveAndConflict (figuren.json:303), blackoutAlibi (figuren.json:304), roleSecret (figuren.json:305), persoenlichesZiel (figuren.json:306), nebendelikt (figuren.json:307), loyalitaet (figuren.json:311), luegen (figuren.json:315), innocentProfile (figuren.json:327), killerProfile (figuren.json:330), beweisFarbe (figuren.json:342), alltag (figuren.json:343)

### 7. leyla · Lejla · Die Buffet-Chefin

Block: `figuren.json:345–393`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | leyla | figuren.json:346 |
| name | Lejla | figuren.json:347 |
| age | 25 | figuren.json:353 |
| geschlecht | w | figuren.json:354 |
| roleTitle | Die Buffet-Chefin | figuren.json:359 |
| colorCode | #178582 | figuren.json:361 |
| farbname | Türkis | figuren.json:362 |
| startRoom | thekensaal | figuren.json:363 |
| ermittlungsOrt | hinter_theke_mitte | figuren.json:364 |
| coordinates.x | 15.5 | figuren.json:366 |
| coordinates.y | 8.5 | figuren.json:367 |
| look.haut | #e6be9e | figuren.json:386 |
| look.haar | #2b1d14 | figuren.json:387 |
| look.kopf | bun | figuren.json:388 |
| look.statur | small | figuren.json:389 |
| look.schnitt | suit | figuren.json:390 |
| visualSpecs.silhouette | Zierlich, Haare zu einem straffen Dutt gebunden | figuren.json:370 |
| visualSpecs.outfit | Türkise Latzschürze über beigem Strickpulli, dunkle Leggings | figuren.json:371 |
| visualSpecs.distinguishingFeature | Abrechnungsblock in der Schürzentasche, Holzlöffel in der Hand | figuren.json:372 |
| visualSpecs.idleAnimation | Rückt Schüsseln gerade und rührt im Warmhaltebehälter | figuren.json:373 |

Nicht übernommen: quelle (figuren.json:348), aussprache (figuren.json:352), herkunft (figuren.json:355), tier (figuren.json:356), besetzungsplatz (figuren.json:357), minPlayers (figuren.json:358), isPotentialKiller (figuren.json:360), motiveAndConflict (figuren.json:375), blackoutAlibi (figuren.json:376), roleSecret (figuren.json:377), persoenlichesZiel (figuren.json:378), nebendelikt (figuren.json:379), loyalitaet (figuren.json:380), luegen (figuren.json:384), alltag (figuren.json:392)

### 8. emine · Emine · Die Grundschullehrerin

Block: `figuren.json:394–439`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | emine | figuren.json:395 |
| name | Emine | figuren.json:396 |
| age | 26 | figuren.json:398 |
| geschlecht | w | figuren.json:399 |
| roleTitle | Die Grundschullehrerin | figuren.json:404 |
| colorCode | #5E6E3A | figuren.json:406 |
| farbname | Olivgrün | figuren.json:407 |
| startRoom | thekensaal | figuren.json:408 |
| ermittlungsOrt | hinter_linkem_buffet | figuren.json:409 |
| coordinates.x | 11.5 | figuren.json:411 |
| coordinates.y | 13.5 | figuren.json:412 |
| look.haut | #d9a983 | figuren.json:431 |
| look.haar | #2b1d14 | figuren.json:432 |
| look.kopf | kopftuch | figuren.json:433 |
| look.statur | normal | figuren.json:434 |
| look.schnitt | dress | figuren.json:435 |
| look.kopftuchFarbe | #d8c6a5 | figuren.json:436 |
| visualSpecs.silhouette | Mittelgroß, ruhige Haltung, beiges Kopftuch | figuren.json:415 |
| visualSpecs.outfit | Olivgrüner Steppmantel, beiges Kopftuch, dunkle Stoffhose, schwarze Stiefel | figuren.json:416 |
| visualSpecs.distinguishingFeature | Hält eine silberne Thermosflasche mit beiden Händen | figuren.json:417 |
| visualSpecs.idleAnimation | Dreht den Deckel der Thermosflasche auf und zu und schaut zu Fatma | figuren.json:418 |

Nicht übernommen: aussprache (figuren.json:397), herkunft (figuren.json:400), tier (figuren.json:401), besetzungsplatz (figuren.json:402), minPlayers (figuren.json:403), isPotentialKiller (figuren.json:405), motiveAndConflict (figuren.json:420), blackoutAlibi (figuren.json:421), roleSecret (figuren.json:422), persoenlichesZiel (figuren.json:423), nebendelikt (figuren.json:424), loyalitaet (figuren.json:425), luegen (figuren.json:429), alltag (figuren.json:438)

### 9. tim · Tim · Der Hobby-Elektriker

Block: `figuren.json:440–484`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | tim | figuren.json:441 |
| name | Tim | figuren.json:442 |
| age | 27 | figuren.json:444 |
| geschlecht | m | figuren.json:445 |
| roleTitle | Der Hobby-Elektriker | figuren.json:450 |
| colorCode | #992222 | figuren.json:452 |
| farbname | Karorot | figuren.json:453 |
| startRoom | west_saal | figuren.json:454 |
| ermittlungsOrt | am_sicherungskasten | figuren.json:455 |
| coordinates.x | 6.5 | figuren.json:457 |
| coordinates.y | 11.5 | figuren.json:458 |
| look.haut | #e6be9e | figuren.json:477 |
| look.haar | #4a3222 | figuren.json:478 |
| look.kopf | none | figuren.json:479 |
| look.statur | normal | figuren.json:480 |
| look.schnitt | suit | figuren.json:481 |
| visualSpecs.silhouette | Kräftig, mittelgroß, lockige Haare | figuren.json:461 |
| visualSpecs.outfit | Rot-schwarz kariertes Flanellhemd über dunklem Shirt, derbe Arbeitshose | figuren.json:462 |
| visualSpecs.distinguishingFeature | Spannungsprüfer-Schraubenzieher hinter dem Ohr, kleine Stirnlampe um den Hals | figuren.json:463 |
| visualSpecs.idleAnimation | Klopft prüfend gegen Kabelkanäle und schüttelt den Kopf | figuren.json:464 |

Nicht übernommen: aussprache (figuren.json:443), herkunft (figuren.json:446), tier (figuren.json:447), besetzungsplatz (figuren.json:448), minPlayers (figuren.json:449), isPotentialKiller (figuren.json:451), motiveAndConflict (figuren.json:466), blackoutAlibi (figuren.json:467), roleSecret (figuren.json:468), persoenlichesZiel (figuren.json:469), nebendelikt (figuren.json:470), loyalitaet (figuren.json:474), luegen (figuren.json:475), alltag (figuren.json:483)

### 10. johanna · Joanna · Die Fotografin des Abends

Block: `figuren.json:485–533`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | johanna | figuren.json:486 |
| name | Joanna | figuren.json:487 |
| age | 24 | figuren.json:493 |
| geschlecht | w | figuren.json:494 |
| roleTitle | Die Fotografin des Abends | figuren.json:499 |
| colorCode | #6A3587 | figuren.json:501 |
| farbname | Violett | figuren.json:502 |
| startRoom | ost_saal | figuren.json:503 |
| ermittlungsOrt | am_handykorb | figuren.json:504 |
| coordinates.x | 24.5 | figuren.json:506 |
| coordinates.y | 12.5 | figuren.json:507 |
| look.haut | #f1d3bc | figuren.json:526 |
| look.haar | #c9a86a | figuren.json:527 |
| look.kopf | none | figuren.json:528 |
| look.statur | slim | figuren.json:529 |
| look.schnitt | suit | figuren.json:530 |
| visualSpecs.silhouette | Schlank, aufrecht, schnelle Bewegungen | figuren.json:510 |
| visualSpecs.outfit | Violetter Cardigan über weißem Top, schwarze Stoffhose | figuren.json:511 |
| visualSpecs.distinguishingFeature | Handy auf einem kleinen Handyhalter mit Aufsteckleuchte | figuren.json:512 |
| visualSpecs.idleAnimation | Hebt das Handy, wischt durch Fotos und zoomt hinein | figuren.json:513 |

Nicht übernommen: quelle (figuren.json:488), aussprache (figuren.json:492), herkunft (figuren.json:495), tier (figuren.json:496), besetzungsplatz (figuren.json:497), minPlayers (figuren.json:498), isPotentialKiller (figuren.json:500), motiveAndConflict (figuren.json:515), blackoutAlibi (figuren.json:516), roleSecret (figuren.json:517), persoenlichesZiel (figuren.json:518), nebendelikt (figuren.json:519), loyalitaet (figuren.json:520), luegen (figuren.json:524), alltag (figuren.json:532)

### 11. murat · Marek · Der Caterer

Block: `figuren.json:534–582`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | murat | figuren.json:535 |
| name | Marek | figuren.json:536 |
| age | 28 | figuren.json:542 |
| geschlecht | m | figuren.json:543 |
| roleTitle | Der Caterer | figuren.json:548 |
| colorCode | #664229 | figuren.json:550 |
| farbname | Lederbraun | figuren.json:551 |
| startRoom | thekensaal | figuren.json:552 |
| ermittlungsOrt | unter_notausgang | figuren.json:553 |
| coordinates.x | 14.5 | figuren.json:555 |
| coordinates.y | 18.5 | figuren.json:556 |
| look.haut | #d9a983 | figuren.json:575 |
| look.haar | #2b1d14 | figuren.json:576 |
| look.kopf | none | figuren.json:577 |
| look.statur | broad | figuren.json:578 |
| look.schnitt | suit | figuren.json:579 |
| visualSpecs.silhouette | Breitschultrig, sportlich, markante Gesichtszüge | figuren.json:559 |
| visualSpecs.outfit | Dunkelbraune Lederjacke, weißer Rollkragen, dunkle Jeans | figuren.json:560 |
| visualSpecs.distinguishingFeature | Lässt den Autoschlüssel mit glänzendem Anhänger um den Zeigefinger kreisen | figuren.json:561 |
| visualSpecs.idleAnimation | Zählt die Warmhaltebehälter durch und schaut auf die Uhr | figuren.json:562 |

Nicht übernommen: quelle (figuren.json:537), aussprache (figuren.json:541), herkunft (figuren.json:544), tier (figuren.json:545), besetzungsplatz (figuren.json:546), minPlayers (figuren.json:547), isPotentialKiller (figuren.json:549), motiveAndConflict (figuren.json:564), blackoutAlibi (figuren.json:565), roleSecret (figuren.json:566), persoenlichesZiel (figuren.json:567), nebendelikt (figuren.json:568), loyalitaet (figuren.json:572), luegen (figuren.json:573), alltag (figuren.json:581)

### 12. zeynep · Zeynep · Die Fußballtrainerin

Block: `figuren.json:583–630`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | zeynep | figuren.json:584 |
| name | Zeynep | figuren.json:585 |
| age | 23 | figuren.json:587 |
| geschlecht | w | figuren.json:588 |
| roleTitle | Die Fußballtrainerin | figuren.json:593 |
| colorCode | #3EB489 | figuren.json:595 |
| farbname | Minzgrün | figuren.json:596 |
| startRoom | west_saal | figuren.json:597 |
| ermittlungsOrt | west_bogen | figuren.json:598 |
| coordinates.x | 6.5 | figuren.json:600 |
| coordinates.y | 9.5 | figuren.json:601 |
| look.haut | #c69270 | figuren.json:623 |
| look.haar | #2b1d14 | figuren.json:624 |
| look.kopf | cap | figuren.json:625 |
| look.statur | small | figuren.json:626 |
| look.schnitt | suit | figuren.json:627 |
| visualSpecs.silhouette | Zierlich, sportlich, lässiger Stil | figuren.json:604 |
| visualSpecs.outfit | Minzgrüner weiter Pulli, weite hellgraue Hose, Kappe verkehrt herum | figuren.json:605 |
| visualSpecs.distinguishingFeature | Weiße Kopfhörer locker um den Hals, kaut Kaugummi | figuren.json:606 |
| visualSpecs.idleAnimation | Kaut Kaugummi, wippt auf den Absätzen und behält Can im Blick | figuren.json:607 |

Nicht übernommen: aussprache (figuren.json:586), herkunft (figuren.json:589), tier (figuren.json:590), besetzungsplatz (figuren.json:591), minPlayers (figuren.json:592), isPotentialKiller (figuren.json:594), motiveAndConflict (figuren.json:609), blackoutAlibi (figuren.json:610), roleSecret (figuren.json:611), persoenlichesZiel (figuren.json:612), nebendelikt (figuren.json:613), loyalitaet (figuren.json:617), luegen (figuren.json:621), alltag (figuren.json:629)

### 13. baran · Baran · Der Mann für die Musik

Block: `figuren.json:631–672`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | baran | figuren.json:632 |
| name | Baran | figuren.json:633 |
| age | 26 | figuren.json:635 |
| geschlecht | m | figuren.json:636 |
| roleTitle | Der Mann für die Musik | figuren.json:641 |
| colorCode | #333333 | figuren.json:643 |
| farbname | Anthrazit mit Neongrün | figuren.json:644 |
| startRoom | ost_saal | figuren.json:645 |
| ermittlungsOrt | ost_bank | figuren.json:646 |
| coordinates.x | 25.5 | figuren.json:648 |
| coordinates.y | 15.5 | figuren.json:649 |
| look.haut | #a87655 | figuren.json:665 |
| look.haar | #1a1412 | figuren.json:666 |
| look.kopf | none | figuren.json:667 |
| look.statur | tall | figuren.json:668 |
| look.schnitt | suit | figuren.json:669 |
| visualSpecs.silhouette | Groß, schlank, leicht nach vorn geneigt | figuren.json:652 |
| visualSpecs.outfit | Anthrazitfarbener Kapuzenpulli mit neongrünen Kordeln, schwarze Jogginghose | figuren.json:653 |
| visualSpecs.distinguishingFeature | Große Kopfhörer auf dem Kopf (in der Tatnacht trägt sie das Geburtstagskind), tragbare Musikbox unter dem Arm | figuren.json:654 |
| visualSpecs.idleAnimation | Wippt im Takt und dreht am Lautstärkerad der Box | figuren.json:655 |

Nicht übernommen: aussprache (figuren.json:634), herkunft (figuren.json:637), tier (figuren.json:638), besetzungsplatz (figuren.json:639), minPlayers (figuren.json:640), isPotentialKiller (figuren.json:642), motiveAndConflict (figuren.json:657), blackoutAlibi (figuren.json:658), roleSecret (figuren.json:659), persoenlichesZiel (figuren.json:660), nebendelikt (figuren.json:661), loyalitaet (figuren.json:662), luegen (figuren.json:663), alltag (figuren.json:671)

### 14. meryem · Hana · Die Kamin-Heizerin

Block: `figuren.json:673–718`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | meryem | figuren.json:674 |
| name | Hana | figuren.json:675 |
| age | 25 | figuren.json:681 |
| geschlecht | w | figuren.json:682 |
| roleTitle | Die Kamin-Heizerin | figuren.json:687 |
| colorCode | #2B4C7E | figuren.json:689 |
| farbname | Jeansblau | figuren.json:690 |
| startRoom | west_saal | figuren.json:691 |
| ermittlungsOrt | am_kamin | figuren.json:692 |
| coordinates.x | 2.5 | figuren.json:694 |
| coordinates.y | 13.5 | figuren.json:695 |
| look.haut | #f1d3bc | figuren.json:711 |
| look.haar | #8a3b1e | figuren.json:712 |
| look.kopf | none | figuren.json:713 |
| look.statur | normal | figuren.json:714 |
| look.schnitt | suit | figuren.json:715 |
| visualSpecs.silhouette | Mittelgroß, praktische Statur, hochgekrempelte Ärmel | figuren.json:698 |
| visualSpecs.outfit | Dunkelblaues Jeanshemd, feste Arbeitshose, Schnürstiefel | figuren.json:699 |
| visualSpecs.distinguishingFeature | Rußflecken auf der linken Wange und an den Händen, Schürhaken in der Hand | figuren.json:700 |
| visualSpecs.idleAnimation | Pustet sich eine Strähne aus der Stirn und wischt die Hände an einem alten Lappen ab | figuren.json:701 |

Nicht übernommen: quelle (figuren.json:676), aussprache (figuren.json:680), herkunft (figuren.json:683), tier (figuren.json:684), besetzungsplatz (figuren.json:685), minPlayers (figuren.json:686), isPotentialKiller (figuren.json:688), motiveAndConflict (figuren.json:703), blackoutAlibi (figuren.json:704), roleSecret (figuren.json:705), persoenlichesZiel (figuren.json:706), nebendelikt (figuren.json:707), loyalitaet (figuren.json:708), luegen (figuren.json:709), alltag (figuren.json:717)

### 15. serkan · Serkan · Der Fahrdienst-Organisator

Block: `figuren.json:719–760`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | serkan | figuren.json:720 |
| name | Serkan | figuren.json:721 |
| age | 29 | figuren.json:723 |
| geschlecht | m | figuren.json:724 |
| roleTitle | Der Fahrdienst-Organisator | figuren.json:729 |
| colorCode | #3A506B | figuren.json:731 |
| farbname | Stahlblau | figuren.json:732 |
| startRoom | windfang | figuren.json:733 |
| ermittlungsOrt | im_windfang | figuren.json:734 |
| coordinates.x | 14.5 | figuren.json:736 |
| coordinates.y | 20.5 | figuren.json:737 |
| look.haut | #c69270 | figuren.json:753 |
| look.haar | #2b1d14 | figuren.json:754 |
| look.kopf | cap | figuren.json:755 |
| look.statur | broad | figuren.json:756 |
| look.schnitt | suit | figuren.json:757 |
| visualSpecs.silhouette | Kräftig, breite Statur, aufrechte Haltung | figuren.json:740 |
| visualSpecs.outfit | Stahlblaue Steppweste über grauem Sweatshirt, dunkle Kappe | figuren.json:741 |
| visualSpecs.distinguishingFeature | Klemmbrett mit Fahrzeiten, schwere Taschenlampe | figuren.json:742 |
| visualSpecs.idleAnimation | Rüttelt am Riegel des Außentors und leuchtet aufs Schloss | figuren.json:743 |

Nicht übernommen: aussprache (figuren.json:722), herkunft (figuren.json:725), tier (figuren.json:726), besetzungsplatz (figuren.json:727), minPlayers (figuren.json:728), isPotentialKiller (figuren.json:730), motiveAndConflict (figuren.json:745), blackoutAlibi (figuren.json:746), roleSecret (figuren.json:747), persoenlichesZiel (figuren.json:748), nebendelikt (figuren.json:749), loyalitaet (figuren.json:750), luegen (figuren.json:751), alltag (figuren.json:759)

### 16. aylin · Aylin · Die Kassenprüferin

Block: `figuren.json:761–802`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | aylin | figuren.json:762 |
| name | Aylin | figuren.json:763 |
| age | 24 | figuren.json:765 |
| geschlecht | w | figuren.json:766 |
| roleTitle | Die Kassenprüferin | figuren.json:771 |
| colorCode | #3A6EA5 | figuren.json:773 |
| farbname | Taubenblau | figuren.json:774 |
| startRoom | ost_saal | figuren.json:775 |
| ermittlungsOrt | ost_tafel_west | figuren.json:776 |
| coordinates.x | 21.5 | figuren.json:778 |
| coordinates.y | 13.5 | figuren.json:779 |
| look.haut | #d9a983 | figuren.json:795 |
| look.haar | #1a1412 | figuren.json:796 |
| look.kopf | none | figuren.json:797 |
| look.statur | slim | figuren.json:798 |
| look.schnitt | suit | figuren.json:799 |
| visualSpecs.silhouette | Sehr gerade Haltung, sachlich | figuren.json:782 |
| visualSpecs.outfit | Taubenblauer Strickcardigan, weiße Bluse, schwarze Stoffhose | figuren.json:783 |
| visualSpecs.distinguishingFeature | Schwarze Ledermappe mit Belegen und Kugelschreiber, fest an die Brust gedrückt | figuren.json:784 |
| visualSpecs.idleAnimation | Klickt mit dem Kugelschreiber und sieht zu Ahmet hinüber | figuren.json:785 |

Nicht übernommen: aussprache (figuren.json:764), herkunft (figuren.json:767), tier (figuren.json:768), besetzungsplatz (figuren.json:769), minPlayers (figuren.json:770), isPotentialKiller (figuren.json:772), motiveAndConflict (figuren.json:787), blackoutAlibi (figuren.json:788), roleSecret (figuren.json:789), persoenlichesZiel (figuren.json:790), nebendelikt (figuren.json:791), loyalitaet (figuren.json:792), luegen (figuren.json:793), alltag (figuren.json:801)

### 17. kaan · Wojtek · Der Architekturstudent

Block: `figuren.json:803–854`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | kaan | figuren.json:804 |
| name | Wojtek | figuren.json:805 |
| age | 27 | figuren.json:811 |
| geschlecht | m | figuren.json:812 |
| roleTitle | Der Architekturstudent | figuren.json:817 |
| colorCode | #5C677D | figuren.json:819 |
| farbname | Aschgrau | figuren.json:820 |
| startRoom | west_saal | figuren.json:821 |
| ermittlungsOrt | vor_bogentuer | figuren.json:822 |
| coordinates.x | 2.5 | figuren.json:824 |
| coordinates.y | 8.5 | figuren.json:825 |
| look.haut | #e6be9e | figuren.json:847 |
| look.haar | #c9a86a | figuren.json:848 |
| look.kopf | none | figuren.json:849 |
| look.statur | normal | figuren.json:850 |
| look.schnitt | suit | figuren.json:851 |
| visualSpecs.silhouette | Schlank, ruhige Haltung, Brille | figuren.json:828 |
| visualSpecs.outfit | Aschgrauer Kapuzenpulli, schwarze Arbeitshose mit verstärkten Knien | figuren.json:829 |
| visualSpecs.distinguishingFeature | Zimmermannsbleistift hinter dem Ohr, Maßband am Hosenbund, ein Finger mit Pflaster | figuren.json:830 |
| visualSpecs.idleAnimation | Streicht mit dem Daumen über die Schramme an der Bogentür | figuren.json:831 |

Nicht übernommen: quelle (figuren.json:806), aussprache (figuren.json:810), herkunft (figuren.json:813), tier (figuren.json:814), besetzungsplatz (figuren.json:815), minPlayers (figuren.json:816), isPotentialKiller (figuren.json:818), motiveAndConflict (figuren.json:833), blackoutAlibi (figuren.json:834), roleSecret (figuren.json:835), persoenlichesZiel (figuren.json:836), nebendelikt (figuren.json:837), loyalitaet (figuren.json:841), luegen (figuren.json:845), alltag (figuren.json:853)

### 18. dilara · Azra · Die Flohmarkt-Kennerin

Block: `figuren.json:855–901`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | dilara | figuren.json:856 |
| name | Azra | figuren.json:857 |
| age | 26 | figuren.json:863 |
| geschlecht | w | figuren.json:864 |
| roleTitle | Die Flohmarkt-Kennerin | figuren.json:869 |
| colorCode | #7A2E5C | figuren.json:871 |
| farbname | Pflaume | figuren.json:872 |
| startRoom | thekensaal | figuren.json:873 |
| ermittlungsOrt | am_rechten_buffet | figuren.json:874 |
| coordinates.x | 16.5 | figuren.json:876 |
| coordinates.y | 13.5 | figuren.json:877 |
| look.haut | #c69270 | figuren.json:893 |
| look.haar | #1a1412 | figuren.json:894 |
| look.kopf | kopftuch | figuren.json:895 |
| look.statur | tall | figuren.json:896 |
| look.schnitt | dress | figuren.json:897 |
| look.kopftuchFarbe | #e8dcc4 | figuren.json:898 |
| visualSpecs.silhouette | Groß, elegante Bewegungen, cremefarbenes Kopftuch | figuren.json:880 |
| visualSpecs.outfit | Pflaumenfarbenes Samtkleid, langer schwarzer Strickcardigan, cremefarbenes Kopftuch | figuren.json:881 |
| visualSpecs.distinguishingFeature | Kleine Lupe an einer Silberkette um den Hals, auffällige Ringe aus Holz und Stein | figuren.json:882 |
| visualSpecs.idleAnimation | Betrachtet ihre Ringe durch die Lupe und schaut zur Theke | figuren.json:883 |

Nicht übernommen: quelle (figuren.json:858), aussprache (figuren.json:862), herkunft (figuren.json:865), tier (figuren.json:866), besetzungsplatz (figuren.json:867), minPlayers (figuren.json:868), isPotentialKiller (figuren.json:870), motiveAndConflict (figuren.json:885), blackoutAlibi (figuren.json:886), roleSecret (figuren.json:887), persoenlichesZiel (figuren.json:888), nebendelikt (figuren.json:889), loyalitaet (figuren.json:890), luegen (figuren.json:891), alltag (figuren.json:900)

### 19. enes · Damir · Der Teemeister

Block: `figuren.json:902–947`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | enes | figuren.json:903 |
| name | Damir | figuren.json:904 |
| age | 25 | figuren.json:910 |
| geschlecht | m | figuren.json:911 |
| roleTitle | Der Teemeister | figuren.json:916 |
| colorCode | #E5E5E5 | figuren.json:918 |
| farbname | Weiß mit Schwarz | figuren.json:919 |
| startRoom | thekensaal | figuren.json:920 |
| ermittlungsOrt | hinter_theke_west | figuren.json:921 |
| coordinates.x | 11.5 | figuren.json:923 |
| coordinates.y | 8.5 | figuren.json:924 |
| look.haut | #d9a983 | figuren.json:940 |
| look.haar | #4a3222 | figuren.json:941 |
| look.kopf | none | figuren.json:942 |
| look.statur | slim | figuren.json:943 |
| look.schnitt | suit | figuren.json:944 |
| visualSpecs.silhouette | Schlank, aufmerksam, flinke Hände | figuren.json:927 |
| visualSpecs.outfit | Weißes Hemd mit hochgekrempelten Ärmeln, schwarze Schürze | figuren.json:928 |
| visualSpecs.distinguishingFeature | Hält ein schmales Teeglas auf einer Untertasse | figuren.json:929 |
| visualSpecs.idleAnimation | Poliert Teegläser mit einem weißen Tuch und prüft den Teekocher | figuren.json:930 |

Nicht übernommen: quelle (figuren.json:905), aussprache (figuren.json:909), herkunft (figuren.json:912), tier (figuren.json:913), besetzungsplatz (figuren.json:914), minPlayers (figuren.json:915), isPotentialKiller (figuren.json:917), motiveAndConflict (figuren.json:932), blackoutAlibi (figuren.json:933), roleSecret (figuren.json:934), persoenlichesZiel (figuren.json:935), nebendelikt (figuren.json:936), loyalitaet (figuren.json:937), luegen (figuren.json:938), alltag (figuren.json:946)

### 20. selin · Sibel · Die Vorsichtige

Block: `figuren.json:948–993`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | selin | figuren.json:949 |
| name | Sibel | figuren.json:950 |
| age | 23 | figuren.json:952 |
| geschlecht | w | figuren.json:953 |
| roleTitle | Die Vorsichtige | figuren.json:958 |
| colorCode | #D8A7B1 | figuren.json:960 |
| farbname | Pastellrosa | figuren.json:961 |
| startRoom | west_saal | figuren.json:962 |
| ermittlungsOrt | west_bank_sued | figuren.json:963 |
| coordinates.x | 3.5 | figuren.json:965 |
| coordinates.y | 18.5 | figuren.json:966 |
| look.haut | #e6be9e | figuren.json:982 |
| look.haar | #7a5638 | figuren.json:983 |
| look.kopf | none | figuren.json:984 |
| look.statur | small | figuren.json:985 |
| look.schnitt | suit | figuren.json:986 |
| visualSpecs.silhouette | Klein, zieht oft die Schultern hoch | figuren.json:969 |
| visualSpecs.outfit | Pastellrosa Strickpulli, helle Jeans, weißer Fransenschal | figuren.json:970 |
| visualSpecs.distinguishingFeature | Zieht den Fransenschal bis übers Kinn | figuren.json:971 |
| visualSpecs.idleAnimation | Schaut sich um und zuckt bei lauten Geräuschen zusammen | figuren.json:972 |

Nicht übernommen: aussprache (figuren.json:951), herkunft (figuren.json:954), tier (figuren.json:955), besetzungsplatz (figuren.json:956), minPlayers (figuren.json:957), isPotentialKiller (figuren.json:959), motiveAndConflict (figuren.json:974), blackoutAlibi (figuren.json:975), roleSecret (figuren.json:976), persoenlichesZiel (figuren.json:977), nebendelikt (figuren.json:978), loyalitaet (figuren.json:979), luegen (figuren.json:980), alltag (figuren.json:988), quelle (figuren.json:989)

### 21. hakan · Pawel · Der Vermittler

Block: `figuren.json:994–1039`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | hakan | figuren.json:995 |
| name | Pawel | figuren.json:996 |
| age | 30 | figuren.json:1002 |
| geschlecht | m | figuren.json:1003 |
| roleTitle | Der Vermittler | figuren.json:1008 |
| colorCode | #4A3728 | figuren.json:1010 |
| farbname | Schokobraun | figuren.json:1011 |
| startRoom | ost_saal | figuren.json:1012 |
| ermittlungsOrt | ost_tafel_ost | figuren.json:1013 |
| coordinates.x | 24.5 | figuren.json:1015 |
| coordinates.y | 13.5 | figuren.json:1016 |
| look.haut | #a87655 | figuren.json:1032 |
| look.haar | #2b1d14 | figuren.json:1033 |
| look.kopf | none | figuren.json:1034 |
| look.statur | normal | figuren.json:1035 |
| look.schnitt | suit | figuren.json:1036 |
| visualSpecs.silhouette | Ruhig, aufrecht, gelassene Haltung | figuren.json:1019 |
| visualSpecs.outfit | Schokobraune Steppjacke über beigem Rollkragen, Halbschuhe | figuren.json:1020 |
| visualSpecs.distinguishingFeature | Dunkelbraune Ledertasche neben sich, Teetasse in der Hand | figuren.json:1021 |
| visualSpecs.idleAnimation | Nimmt einen langsamen Schluck Tee und beobachtet die Gruppe | figuren.json:1022 |

Nicht übernommen: quelle (figuren.json:997), aussprache (figuren.json:1001), herkunft (figuren.json:1004), tier (figuren.json:1005), besetzungsplatz (figuren.json:1006), minPlayers (figuren.json:1007), isPotentialKiller (figuren.json:1009), motiveAndConflict (figuren.json:1024), blackoutAlibi (figuren.json:1025), roleSecret (figuren.json:1026), persoenlichesZiel (figuren.json:1027), nebendelikt (figuren.json:1028), loyalitaet (figuren.json:1029), luegen (figuren.json:1030), alltag (figuren.json:1038)

### 22. tugba · Tugba · Die Geburtstags-Planerin

Block: `figuren.json:1040–1081`

**Werte**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | tugba | figuren.json:1041 |
| name | Tugba | figuren.json:1042 |
| age | 27 | figuren.json:1044 |
| geschlecht | w | figuren.json:1045 |
| roleTitle | Die Geburtstags-Planerin | figuren.json:1050 |
| colorCode | #800020 | figuren.json:1052 |
| farbname | Karminrot mit Gold | figuren.json:1053 |
| startRoom | ost_saal | figuren.json:1054 |
| ermittlungsOrt | an_der_wandtafel | figuren.json:1055 |
| coordinates.x | 24.5 | figuren.json:1057 |
| coordinates.y | 10.5 | figuren.json:1058 |
| look.haut | #d9a983 | figuren.json:1074 |
| look.haar | #1a1412 | figuren.json:1075 |
| look.kopf | none | figuren.json:1076 |
| look.statur | normal | figuren.json:1077 |
| look.schnitt | suit | figuren.json:1078 |
| visualSpecs.silhouette | Organisiert, schwungvoll, geschäftsmäßig | figuren.json:1061 |
| visualSpecs.outfit | Karminroter Blazer über weißem Shirt, schmale Metallbrille | figuren.json:1062 |
| visualSpecs.distinguishingFeature | Notizbuch mit goldenem Einband und Fineliner | figuren.json:1063 |
| visualSpecs.idleAnimation | Blättert im Notizbuch, hakt Zeilen ab und schaut zur Wanduhr | figuren.json:1064 |

Nicht übernommen: aussprache (figuren.json:1043), herkunft (figuren.json:1046), tier (figuren.json:1047), besetzungsplatz (figuren.json:1048), minPlayers (figuren.json:1049), isPotentialKiller (figuren.json:1051), motiveAndConflict (figuren.json:1066), blackoutAlibi (figuren.json:1067), roleSecret (figuren.json:1068), persoenlichesZiel (figuren.json:1069), nebendelikt (figuren.json:1070), loyalitaet (figuren.json:1071), luegen (figuren.json:1072), alltag (figuren.json:1080)

---

## 2. Räume (7), Raster und Türen

Quelle: `raeume.json`. Einrichtungseinträge haben kein Raumfeld. Ihre Zuordnung zu einem Raum ist abgeleitet: Die Kachel `x`/`y` liegt im Rechteck `x … x+b−1` bzw. `y … y+l−1`. Die Zuordnung ist für alle 53 Einträge eindeutig (siehe Zählung unten).

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| massstab | 1 Kachel = 1 Meter; x nach Osten, y nach Süden; Rechtecke als Bodenkacheln (x, y, b, l) | raeume.json:3 |
| raster.breite | 27 | raeume.json:5 |
| raster.hoehe | 23 | raeume.json:6 |

### 2.1 thekensaal · Anzeigename „Buffetsaal“

Block: `raeume.json:9–32`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | thekensaal | raeume.json:10 |
| name | Thekensaal (Zentrum) | raeume.json:11 |
| anzeigename | Buffetsaal | raeume.json:12 |
| widthMeters | 8 | raeume.json:13 |
| rechteck.x | 11 | raeume.json:15 |
| rechteck.y | 7 | raeume.json:16 |
| rechteck.b | 8 | raeume.json:17 |
| rechteck.l | 12 | raeume.json:18 |
| boden | stone | raeume.json:20 |
| features[0] | Buffettheke mit Anrichte | raeume.json:22 |
| features[1] | Linker Buffettisch | raeume.json:23 |
| features[2] | Rechter Buffettisch | raeume.json:24 |
| features[3] | Großer Teekocher | raeume.json:25 |
| features[4] | Kaffeemaschine | raeume.json:26 |
| features[5] | Spüle | raeume.json:27 |
| features[6] | Eiskübel | raeume.json:28 |
| features[7] | Notausgangsschild | raeume.json:29 |
| beschreibung | Länglicher Gewölbesaal, Knotenpunkt des Kellers. Gegenüber dem Eingang steht die Buffettheke aus dunklem Holz, dahinter die Anrichte an der Nordwand. Links und rechts an den Längswänden die Buffettische. | raeume.json:31 |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:9–32) |

**Türen (4), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| windfang_tuer | Innentür | thekensaal | windfang | [[14, 19]] | schwere Holztür | keine | — | zu (Zugluft) | true | raeume.json:167–182 |
| vorrat_tuer | Vorratsraumtür | thekensaal | vorratsraum | [[14, 6]] | einfache Holztür | keine | — | angelehnt | false | raeume.json:183–198 |
| durchgang_ost | Tür zum Durchgang | thekensaal | durchgang | [[10, 9]] | Holztür neben der Theke (links) | keine | — | offen | true | raeume.json:199–214 |
| ost_tuer | Tür zum Ostsaal | thekensaal | ost_saal | [[19, 9]] | Holztür neben der Theke (rechts) | keine | — | offen | true | raeume.json:231–246 |

**Einrichtung (19)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| spuele | Spüle | counter | 12 | 7 | true | sink | raeume.json:282–290 |
| anrichte | Anrichte mit Messingkerzenständer | counter | 13 | 7 | true | candles | raeume.json:291–299 |
| teekocher | großer Teekocher | counter | 15 | 7 | true | stove | raeume.json:300–308 |
| kaffeemaschine | Kaffeemaschine an der alten Mehrfachsteckdose | counter | 16 | 7 | true | stove | raeume.json:309–317 |
| anrichte_ost | Anrichte mit Gläsern und Tassen | counter | 17 | 7 | true | counter | raeume.json:318–326 |
| theke_12 | Buffettheke | counter | 12 | 9 | true | — | raeume.json:327–334 |
| theke_13 | Buffettheke | counter | 13 | 9 | true | — | raeume.json:335–342 |
| theke_14 | Buffettheke | counter | 14 | 9 | true | — | raeume.json:343–350 |
| theke_15 | Buffettheke | counter | 15 | 9 | true | — | raeume.json:351–358 |
| theke_16 | Buffettheke | counter | 16 | 9 | true | — | raeume.json:359–366 |
| theke_17 | Buffettheke | counter | 17 | 9 | true | — | raeume.json:367–374 |
| linkes_buffet_12 | linker Buffettisch | table | 12 | 12 | true | — | raeume.json:375–382 |
| linkes_buffet_13 | linker Buffettisch | table | 12 | 13 | true | — | raeume.json:383–390 |
| linkes_buffet_14 | linker Buffettisch | table | 12 | 14 | true | — | raeume.json:391–398 |
| linkes_buffet_15 | linker Buffettisch | table | 12 | 15 | true | — | raeume.json:399–406 |
| rechtes_buffet_12 | rechter Buffettisch | table | 17 | 12 | true | — | raeume.json:407–414 |
| rechtes_buffet_13 | rechter Buffettisch | table | 17 | 13 | true | — | raeume.json:415–422 |
| rechtes_buffet_14 | rechter Buffettisch | table | 17 | 14 | true | — | raeume.json:423–430 |
| rechtes_buffet_15 | rechter Buffettisch | table | 17 | 15 | true | — | raeume.json:431–438 |

**Orte (16)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| vor_vorratstuer | vor der Vorratsraumtür | thekensaal | 14.5 | 7.5 | — | raeume.json:719–725 |
| an_anrichte | an der Anrichte neben der Vorratsraumtür | thekensaal | 13.5 | 8.5 | — | raeume.json:726–732 |
| hinter_theke_west | hinter der Theke, Westende | thekensaal | 11.5 | 8.5 | — | raeume.json:733–739 |
| hinter_theke_mitte | hinter der Theke, vor dem Teekocher | thekensaal | 15.5 | 8.5 | — | raeume.json:740–746 |
| hinter_theke_ost | hinter der Theke, vor der Kaffeemaschine | thekensaal | 17.5 | 8.5 | — | raeume.json:747–753 |
| theke_klappe | an der Theken-Klappe am Westende | thekensaal | 11.5 | 9.5 | — | raeume.json:754–760 |
| theke_ostende | am Ostende der Theke | thekensaal | 18.5 | 9.5 | — | raeume.json:761–767 |
| vor_theke | vor der Theke | thekensaal | 14.5 | 10.5 | — | raeume.json:768–774 |
| vor_theke_west | vor der Theke beim Westende | thekensaal | 12.5 | 10.5 | — | raeume.json:775–781 |
| am_eiskuebel | vor der Theke beim Eiskübel | thekensaal | 17.5 | 10.5 | — | raeume.json:782–788 |
| am_linken_buffet | am linken Buffettisch | thekensaal | 13.5 | 13.5 | — | raeume.json:789–795 |
| hinter_linkem_buffet | hinter dem linken Buffettisch | thekensaal | 11.5 | 13.5 | — | raeume.json:796–802 |
| am_rechten_buffet | am rechten Buffettisch | thekensaal | 16.5 | 13.5 | — | raeume.json:803–809 |
| hinter_rechtem_buffet | hinter dem rechten Buffettisch | thekensaal | 18.5 | 13.5 | — | raeume.json:810–816 |
| saalmitte | Mitte des Buffetsaals | thekensaal | 14.5 | 14.5 | — | raeume.json:817–823 |
| unter_notausgang | an der Innentür unter dem Notausgangsschild | thekensaal | 14.5 | 18.5 | — | raeume.json:824–830 |

**Lichtquellen mit Raumbezug (3)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |
| licht_kerzenstaender | kerze | drei rote Wachskerzen im Messingkerzenständer | ort: an_anrichte (raeume.json:1069) | über ort → orte.raum | #FF9329 | 2.0 | 0.4 | [["22:00", "23:58:40"]] | einzige echte Kerzen im Keller (Brandschutz im Denkmal); erlöschen beim Schlag | raeume.json:1065–1080 |
| licht_notausgang | notlicht | grünes Notausgangsschild mit Akku | ort: unter_notausgang (raeume.json:1085) | über ort → orte.raum | #2FBF5A | 1.5 | 0.0 | [["17:00", "07:00"]] | — | raeume.json:1081–1095 |

### 2.2 vorratsraum · Anzeigename „Vorratsraum“

Block: `raeume.json:33–50`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | vorratsraum | raeume.json:34 |
| name | Vorratsraum | raeume.json:35 |
| anzeigename | Vorratsraum | raeume.json:36 |
| rechteck.x | 13 | raeume.json:38 |
| rechteck.y | 2 | raeume.json:39 |
| rechteck.b | 3 | raeume.json:40 |
| rechteck.l | 4 | raeume.json:41 |
| boden | stone | raeume.json:43 |
| features[0] | Regale | raeume.json:45 |
| features[1] | Geburtstagstorte | raeume.json:46 |
| features[2] | Notlaterne am Haken | raeume.json:47 |
| beschreibung | Kleiner, kühler Raum ohne Fenster hinter der Buffettheke. Einziger Zugang ist die Tür neben der Anrichte. | raeume.json:49 |
| widthMeters | — | kein Feld im Block (raeume.json:33–50) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:33–50) |

**Türen (1), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| vorrat_tuer | Vorratsraumtür | thekensaal | vorratsraum | [[14, 6]] | einfache Holztür | keine | — | angelehnt | false | raeume.json:183–198 |

**Einrichtung (3)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| regal_torte | Regal mit der Geburtstagstorte | bookshelf | 13 | 2 | true | — | raeume.json:439–446 |
| regal_mitte | Regal mit Vorräten | bookshelf | 14 | 2 | true | — | raeume.json:447–454 |
| regal_ost | Regal mit Vorräten | bookshelf | 15 | 2 | true | — | raeume.json:455–462 |

**Orte (2)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| vorrat_innen | direkt hinter der Vorratsraumtür | vorratsraum | 14.5 | 5.5 | — | raeume.json:831–837 |
| vorrat_mitte | im Vorratsraum vor dem Regal mit der Torte | vorratsraum | 14.5 | 3.5 | — | raeume.json:838–844 |

**Lichtquellen mit Raumbezug (2)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_vorrat | elektrisch | Deckenlampe im Vorratsraum | raeume: ["vorratsraum"] | Feld raeume | — | — | — | [["17:00", "23:54:20"], ["00:00:18", "07:00"]] | Can schaltet sie um 23:54:20 aus, um im Dunkeln zu warten; Damir schaltet sie um 0:00:18 wieder ein. | raeume.json:1046–1064 |
| licht_notlaterne | lampe | Notlaterne am Haken im Vorratsraum | ort: vorrat_innen (raeume.json:1169) | über ort → orte.raum | #FFF1C9 | 3.0 | — | [] | Wird in der Tatnacht nie eingeschaltet; Herr Schneider erreicht sie nicht. | raeume.json:1165–1174 |

### 2.3 durchgang · Anzeigename „Durchgang“

Block: `raeume.json:51–66`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | durchgang | raeume.json:52 |
| name | Durchgang | raeume.json:53 |
| anzeigename | Durchgang | raeume.json:54 |
| rechteck.x | 8 | raeume.json:56 |
| rechteck.y | 8 | raeume.json:57 |
| rechteck.b | 2 | raeume.json:58 |
| rechteck.l | 2 | raeume.json:59 |
| boden | stone | raeume.json:61 |
| features[0] | Getränkekisten | raeume.json:63 |
| beschreibung | Kurzer, niedriger Gang zwischen West-Saal und Buffetsaal. Hier stehen die Getränkekisten. | raeume.json:65 |
| widthMeters | — | kein Feld im Block (raeume.json:51–66) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:51–66) |

**Türen (2), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| durchgang_ost | Tür zum Durchgang | thekensaal | durchgang | [[10, 9]] | Holztür neben der Theke (links) | keine | — | offen | true | raeume.json:199–214 |
| durchgang_west | Bogen zum Kaminsaal | durchgang | west_saal | [[7, 9]] | offener Steinbogen | keine | — | offen | false | raeume.json:215–230 |

**Einrichtung (1)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| getraenkekisten | Getränkekisten | crate | 8 | 8 | true | crate | raeume.json:463–471 |

**Orte (2)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| bei_den_kisten | bei den Getränkekisten | durchgang | 9.5 | 8.5 | — | raeume.json:845–851 |
| durchgang_mitte | im Durchgang | durchgang | 8.5 | 9.5 | — | raeume.json:852–858 |

**Lichtquellen mit Raumbezug (1)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |

### 2.4 west_saal · Anzeigename „Kaminsaal“

Block: `raeume.json:67–87`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | west_saal | raeume.json:68 |
| name | West-Saal | raeume.json:69 |
| anzeigename | Kaminsaal | raeume.json:70 |
| rechteck.x | 1 | raeume.json:72 |
| rechteck.y | 8 | raeume.json:73 |
| rechteck.b | 6 | raeume.json:74 |
| rechteck.l | 12 | raeume.json:75 |
| boden | stone | raeume.json:77 |
| features[0] | Lange Tafeln | raeume.json:79 |
| features[1] | Wandbänke | raeume.json:80 |
| features[2] | Kamin-Nische | raeume.json:81 |
| features[3] | Sicherungskasten | raeume.json:82 |
| features[4] | Lichtschächte mit Klappen | raeume.json:83 |
| features[5] | Bogentür zum Turmgang | raeume.json:84 |
| beschreibung | Gemeinschaftssaal mit zwei langen Tafeln und Wandbänken. In der Westwand die Kamin-Nische, hoch in der Nordwand zwei Lichtschächte mit Klappen, in der Nordwestecke die geschnitzte Bogentür zum Turm. | raeume.json:86 |
| widthMeters | — | kein Feld im Block (raeume.json:67–87) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:67–87) |

**Türen (2), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| durchgang_west | Bogen zum Kaminsaal | durchgang | west_saal | [[7, 9]] | offener Steinbogen | keine | — | offen | false | raeume.json:215–230 |
| bogentuer | Bogentür zum Turm | west_saal | turmgang | [[2, 7]] | jahrhundertealte, geschnitzte Bogentür aus Eiche, ein Beschlag herausgerissen | keine | — | offen | true | raeume.json:247–262 |

**Einrichtung (15)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| kamin | Kamin-Nische | fireplace | 1 | 13 | true | fireplace | raeume.json:472–480 |
| ascheneimer | Ascheneimer neben der Kamin-Nische | ascheneimer | 1 | 14 | false | — | raeume.json:481–488 |
| west_tafel_3_11 | lange Tafel | table | 3 | 11 | true | — | raeume.json:489–496 |
| west_tafel_3_12 | lange Tafel | table | 3 | 12 | true | — | raeume.json:497–504 |
| west_tafel_3_13 | lange Tafel | table | 3 | 13 | true | — | raeume.json:505–512 |
| west_tafel_3_14 | lange Tafel | table | 3 | 14 | true | — | raeume.json:513–520 |
| west_tafel_3_15 | lange Tafel | table | 3 | 15 | true | — | raeume.json:521–528 |
| west_tafel_3_16 | lange Tafel | table | 3 | 16 | true | — | raeume.json:529–536 |
| west_tafel_4_11 | lange Tafel | table | 4 | 11 | true | — | raeume.json:537–544 |
| west_tafel_4_12 | lange Tafel | table | 4 | 12 | true | — | raeume.json:545–552 |
| west_tafel_4_13 | lange Tafel | table | 4 | 13 | true | — | raeume.json:553–560 |
| west_tafel_4_14 | lange Tafel | table | 4 | 14 | true | — | raeume.json:561–568 |
| west_tafel_4_15 | lange Tafel | table | 4 | 15 | true | — | raeume.json:569–576 |
| west_tafel_4_16 | lange Tafel | table | 4 | 16 | true | — | raeume.json:577–584 |
| sicherungskasten | Sicherungskasten | sicherungskasten | 6 | 11 | false | — | raeume.json:585–592 |

**Orte (8)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| west_bogen | am Bogen zum Durchgang | west_saal | 6.5 | 9.5 | — | raeume.json:859–865 |
| am_sicherungskasten | am Sicherungskasten | west_saal | 6.5 | 11.5 | — | raeume.json:866–872 |
| am_kamin | an der Kamin-Nische | west_saal | 2.5 | 13.5 | — | raeume.json:873–879 |
| west_bank_nord | auf der Wandbank unter den Lichtschächten | west_saal | 4.5 | 8.5 | — | raeume.json:880–886 |
| west_bank_west | auf der Wandbank an der Westwand | west_saal | 1.5 | 10.5 | — | raeume.json:887–893 |
| vor_bogentuer | vor der Bogentür | west_saal | 2.5 | 8.5 | — | raeume.json:894–900 |
| west_tafel_sued | an der langen Tafel im Kaminsaal | west_saal | 5.5 | 15.5 | — | raeume.json:901–907 |
| west_bank_sued | auf der Wandbank an der Südwand | west_saal | 3.5 | 18.5 | — | raeume.json:908–914 |

**Lichtquellen mit Raumbezug (2)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |
| licht_kamin | feuer | Kaminfeuer | ort: am_kamin (raeume.json:1100) | über ort → orte.raum | #FF8A3A | 3.0 | 0.5 | [["23:20", "23:30"]] | nach dem Qualm gelöscht | raeume.json:1096–1111 |

### 2.5 turmgang · Anzeigename „Turmgang“

Block: `raeume.json:88–106`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | turmgang | raeume.json:89 |
| name | Turmgang | raeume.json:90 |
| anzeigename | Turmgang | raeume.json:91 |
| rechteck.x | 1 | raeume.json:93 |
| rechteck.y | 1 | raeume.json:94 |
| rechteck.b | 3 | raeume.json:95 |
| rechteck.l | 6 | raeume.json:96 |
| boden | stone | raeume.json:98 |
| features[0] | Ritterrüstung | raeume.json:100 |
| features[1] | Schauvitrine | raeume.json:101 |
| features[2] | Wendeltreppe zum WC | raeume.json:102 |
| features[3] | Hoftür (verschlossen) | raeume.json:103 |
| beschreibung | Schmaler Gang im Fuß des Schlossturms. Hier stehen die alte Ritterrüstung und die Schauvitrine. Die Wendeltreppe führt hinauf zu den Toiletten; der Rest des Turms ist mit einem Vorhängeschloss abgesperrt. | raeume.json:105 |
| widthMeters | — | kein Feld im Block (raeume.json:88–106) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:88–106) |

**Türen (2), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| bogentuer | Bogentür zum Turm | west_saal | turmgang | [[2, 7]] | jahrhundertealte, geschnitzte Bogentür aus Eiche, ein Beschlag herausgerissen | keine | — | offen | true | raeume.json:247–262 |
| hoftuer | Hoftür | turmgang | draussen | [[2, 0]] | schwere Turmtür zum Schlosshof | schluessel_beidseitig | bund_schneider | verschlossen ab 18:50 | true | raeume.json:263–279 |

**Einrichtung (3)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| ruestung | Ritterrüstung | ruestung | 1 | 5 | true | statue | raeume.json:593–601 |
| vitrine | Schauvitrine | vitrine | 3 | 3 | true | cabinet | raeume.json:602–610 |
| wendeltreppe | Wendeltreppe | treppe | 1 | 1 | true | bookshelf | raeume.json:611–619 |

**Orte (4)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| an_der_ruestung | bei der Ritterrüstung | turmgang | 2.5 | 5.5 | — | raeume.json:915–921 |
| an_der_vitrine | an der Schauvitrine | turmgang | 2.5 | 3.5 | — | raeume.json:922–928 |
| wendeltreppe_fuss | am Fuß der Wendeltreppe | turmgang | 2.5 | 1.5 | — | raeume.json:929–935 |
| wc | auf der Toilette oben im Turm | turmgang | 2.5 | 1.5 | 10 | raeume.json:936–943 |

**Lichtquellen mit Raumbezug (1)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |

### 2.6 ost_saal · Anzeigename „Ostsaal“

Block: `raeume.json:107–126`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | ost_saal | raeume.json:108 |
| name | Ost-Saal | raeume.json:109 |
| anzeigename | Ostsaal | raeume.json:110 |
| rechteck.x | 20 | raeume.json:112 |
| rechteck.y | 7 | raeume.json:113 |
| rechteck.b | 6 | raeume.json:114 |
| rechteck.l | 12 | raeume.json:115 |
| boden | stone | raeume.json:117 |
| features[0] | Lange Tafeln | raeume.json:119 |
| features[1] | Wandbänke | raeume.json:120 |
| features[2] | Jackenständer | raeume.json:121 |
| features[3] | Wandtafel mit Ablaufplan | raeume.json:122 |
| features[4] | Handykorb | raeume.json:123 |
| beschreibung | Ruhiger Gemeinschaftssaal ohne weitere Außentür. Am Eingang steht der Jackenständer, an der Ostwand die Wandtafel mit dem Ablaufplan des Abends. | raeume.json:125 |
| widthMeters | — | kein Feld im Block (raeume.json:107–126) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:107–126) |

**Türen (1), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| ost_tuer | Tür zum Ostsaal | thekensaal | ost_saal | [[19, 9]] | Holztür neben der Theke (rechts) | keine | — | offen | true | raeume.json:231–246 |

**Einrichtung (12)** (Raumzuordnung abgeleitet, siehe oben)

| id | name | typ | x | y | blockiert | darstellung | Datei:Zeile |
|---|---|---|---|---|---|---|---|
| jackenstaender | Jackenständer | jackenstaender | 20 | 8 | true | wardrobe | raeume.json:620–628 |
| ost_tafel_22_11 | lange Tafel | table | 22 | 11 | true | — | raeume.json:629–636 |
| ost_tafel_22_12 | lange Tafel | table | 22 | 12 | true | — | raeume.json:637–644 |
| ost_tafel_22_13 | lange Tafel | table | 22 | 13 | true | — | raeume.json:645–652 |
| ost_tafel_22_14 | lange Tafel | table | 22 | 14 | true | — | raeume.json:653–660 |
| ost_tafel_22_15 | lange Tafel | table | 22 | 15 | true | — | raeume.json:661–668 |
| ost_tafel_23_11 | lange Tafel | table | 23 | 11 | true | — | raeume.json:669–676 |
| ost_tafel_23_12 | lange Tafel | table | 23 | 12 | true | — | raeume.json:677–684 |
| ost_tafel_23_13 | lange Tafel | table | 23 | 13 | true | — | raeume.json:685–692 |
| ost_tafel_23_14 | lange Tafel | table | 23 | 14 | true | — | raeume.json:693–700 |
| ost_tafel_23_15 | lange Tafel | table | 23 | 15 | true | — | raeume.json:701–708 |
| wandtafel | Wandtafel mit dem Ablaufplan | wandtafel | 25 | 10 | false | — | raeume.json:709–716 |

**Orte (9)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| ost_eingang | am Eingang des Ostsaals | ost_saal | 20.5 | 9.5 | — | raeume.json:944–950 |
| am_jackenstaender | am Jackenständer | ost_saal | 21.5 | 8.5 | — | raeume.json:951–957 |
| ost_tafel_kopf | am Kopf der langen Tafel | ost_saal | 22.5 | 10.5 | — | raeume.json:958–964 |
| ost_tafel_west | an der langen Tafel, Westseite | ost_saal | 21.5 | 13.5 | — | raeume.json:965–971 |
| ost_tafel_ost | an der langen Tafel, Ostseite | ost_saal | 24.5 | 13.5 | — | raeume.json:972–978 |
| am_handykorb | beim Handykorb auf der Tafel | ost_saal | 24.5 | 12.5 | — | raeume.json:979–985 |
| an_der_wandtafel | an der Wandtafel mit dem Ablaufplan | ost_saal | 24.5 | 10.5 | — | raeume.json:986–992 |
| ost_bank | auf der Wandbank an der Ostwand | ost_saal | 25.5 | 15.5 | — | raeume.json:993–999 |
| geburtstagsplatz | auf dem Ehrenplatz des Geburtstagskinds | ost_saal | 24.5 | 16.5 | — | raeume.json:1000–1006 |

**Lichtquellen mit Raumbezug (2)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |
| licht_handys | lampe | Handy-Taschenlampen aus dem Handykorb | ort: am_handykorb (raeume.json:1140) | über ort → orte.raum | #FFFFFF | 3.0 | — | [["23:59:30", "00:00:30"]] | — | raeume.json:1136–1149 |

### 2.7 windfang · Anzeigename „Windfang“

Block: `raeume.json:127–143`

**Raum**

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| id | windfang | raeume.json:128 |
| name | Windfang | raeume.json:129 |
| anzeigename | Windfang | raeume.json:130 |
| rechteck.x | 14 | raeume.json:132 |
| rechteck.y | 20 | raeume.json:133 |
| rechteck.b | 2 | raeume.json:134 |
| rechteck.l | 2 | raeume.json:135 |
| boden | stone | raeume.json:137 |
| features[0] | Innentür | raeume.json:139 |
| features[1] | Außentor | raeume.json:140 |
| beschreibung | Kleiner Vorraum zwischen der Innentür des Buffetsaals und dem Außentor. | raeume.json:142 |
| widthMeters | — | kein Feld im Block (raeume.json:127–143) |
| Höhe | nicht vorhanden | kein Feld im Block (raeume.json:127–143) |

**Türen (2), die den Raum berühren** (Lage = `kacheln`)

| id | name | von | nach | kacheln (Lage) | art | schliesst | schluessel | zustand | quietscht | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| aussentor | Außentor | windfang | draussen | [[14, 22], [15, 22]] | zweiflügelige, eisenbeschlagene Eichentür mit Kastenschloss | schluessel_beidseitig | bund_schneider | verschlossen ab 18:50 | true | raeume.json:146–166 |
| windfang_tuer | Innentür | thekensaal | windfang | [[14, 19]] | schwere Holztür | keine | — | zu (Zugluft) | true | raeume.json:167–182 |

**Einrichtung (0)** (Raumzuordnung abgeleitet, siehe oben)

keine

**Orte (2)**

| id | name | raum | x | y | zusatzweg | Datei:Zeile |
|---|---|---|---|---|---|---|
| im_windfang | im Windfang | windfang | 14.5 | 20.5 | — | raeume.json:1007–1013 |
| am_aussentor | am Außentor | windfang | 15.5 | 21.5 | — | raeume.json:1014–1020 |

**Lichtquellen mit Raumbezug (2)**

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_strom | elektrisch | Deckenlicht und elektrische Deko-Kerzen | raeume: ["thekensaal", "durchgang", "west_saal", "turmgang", "ost_saal", "windfang"] | Feld raeume | — | — | — | [["17:00", "23:58:00"], ["00:00:00", "07:00"]] | — | raeume.json:1023–1045 |
| licht_serkan | lampe | Serkans LED-Taschenlampe | traeger: serkan | nur aus hinweis | #FFFFFF | 3.0 | — | [["23:56:00", "00:01:00"]] | im Windfang hinter geschlossener Innentür, erreicht den Saal nicht | raeume.json:1150–1164 |

### 2.8 Lichtquellen ohne Raumbezug (2)

| id | art | name | Ort / Träger / Räume (Quelle) | Raumbezug (Ableitung) | farbe | radius | flackern | an (Zeiten) | hinweis | Datei:Zeile |
|---|---|---|---|---|---|---|---|---|---|---|
| licht_maske | nachleuchten | nachleuchtende Farbe der Maske | traeger: can | kein Raumbezug (nur Träger) | #B8FFB0 | 0.4 | 0.0 | — | nur Umriss des Gesichts erkennbar, beleuchtet nichts | raeume.json:1112–1121 |
| licht_stirnlampe | lampe | Tims Stirnlampe | traeger: tim | kein Raumbezug (nur Träger) | #FFF4D6 | 3.0 | — | [["23:59:40", "07:00"]] | — | raeume.json:1122–1135 |

Tatmatrix- und Trägerpositionen liegen nicht in diesem Auszug (siehe `figuren.json:3`).

**Zählung Räume (Einrichtung, Orte, Lichter mit Raumbezug, Türen)**

| Raum | Einrichtung | Orte | Lichter (mit Raumbezug, Mehrfachzählung bei mehreren Räumen) | Türen (berühren den Raum) |
|---|---|---|---|---|
| thekensaal | 19 | 16 | 3 | 4 |
| vorratsraum | 3 | 2 | 2 | 1 |
| durchgang | 1 | 2 | 1 | 2 |
| west_saal | 15 | 8 | 2 | 2 |
| turmgang | 3 | 4 | 1 | 2 |
| ost_saal | 12 | 9 | 2 | 1 |
| windfang | 0 | 2 | 2 | 2 |
| **Summe** | **53** | **43** | **13** | **8** (gesamt; je Raum gezählt, eine Tür kann 2 Räume berühren) |

Hinweis: Einrichtung und Orte sind je Eintrag genau einem Raum zugeordnet (Einrichtung abgeleitet, Orte über das Feld `raum`). Summe Lichter mit Raumbezug ist eine Mehrfachzählung, weil `licht_strom` in 6 Räumen liegt. Die Türen zählen je Raum, wobei eine Tür zwei Räume berühren kann.

---

## 3. Gegenstände und Indizien (28)

Quelle: `gegenstaende.json`. Hinweis der Quelle (`gegenstaende.json:3`): Lage ist in allen Pfaden gleich, außer beim versteckten Schlüsselbund (`versteckJePfad`).

### 3.1 Gegenstände (Lage, Sichtbarkeit, Beschreibung, Pfad-Lage)

| Gegenstand | Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|---|
| kerzenstaender | id | kerzenstaender | gegenstaende.json:6 |
| kerzenstaender | name | Messingkerzenständer | gegenstaende.json:7 |
| kerzenstaender | beschreibung | Schwerer Kerzenständer aus Messing für drei rote Wachskerzen. Herr Schneider hat ihn selbst poliert. | gegenstaende.json:8 |
| kerzenstaender | lage.ort | vor_vorratstuer | gegenstaende.json:10 |
| kerzenstaender | lage.stelle | umgestoßen auf dem Steinboden vor der Vorratsraumtür; Tugba hat verboten, ihn anzufassen | gegenstaende.json:11 |
| kerzenstaender | sichtbar | true | gegenstaende.json:13 |
| silberring_fatma | id | silberring_fatma | gegenstaende.json:65 |
| silberring_fatma | name | Fatmas breiter Silberring | gegenstaende.json:66 |
| silberring_fatma | beschreibung | Ein breiter, glatter Silberring an Fatmas rechter Hand. | gegenstaende.json:67 |
| silberring_fatma | lage.traeger | fatma | gegenstaende.json:69 |
| silberring_fatma | sichtbar | false | gegenstaende.json:71 |
| jacke_ahmet | id | jacke_ahmet | gegenstaende.json:88 |
| jacke_ahmet | name | Ahmets schwarze Stoffjacke | gegenstaende.json:89 |
| jacke_ahmet | beschreibung | Ahmets Jacke hängt seit 23:55 am vordersten Haken des Jackenständers im Ost-Saal. | gegenstaende.json:90 |
| jacke_ahmet | lage.einrichtung | jackenstaender | gegenstaende.json:92 |
| jacke_ahmet | lage.ort | am_jackenstaender | gegenstaende.json:93 |
| jacke_ahmet | lage.stelle | vorderster Haken | gegenstaende.json:94 |
| jacke_ahmet | sichtbar | true | gegenstaende.json:96 |
| umschlag_mietgeld | id | umschlag_mietgeld | gegenstaende.json:125 |
| umschlag_mietgeld | name | Umschlag mit dem Mietgeld | gegenstaende.json:126 |
| umschlag_mietgeld | beschreibung | Ein brauner Umschlag mit Ahmets Handschrift: „Miete Schlosskeller“. Gegen 0:12 leert Ahmet ihn und wirft ihn in den Ascheneimer am Kamin. | gegenstaende.json:127 |
| umschlag_mietgeld | lage.einrichtung | ascheneimer | gegenstaende.json:129 |
| umschlag_mietgeld | lage.ort | am_kamin | gegenstaende.json:130 |
| umschlag_mietgeld | lage.stelle | leer im Ascheneimer neben der Kamin-Nische | gegenstaende.json:131 |
| umschlag_mietgeld | sichtbar | true | gegenstaende.json:133 |
| muenzschatulle | id | muenzschatulle | gegenstaende.json:162 |
| muenzschatulle | name | Münzschatulle aus der Turmvitrine | gegenstaende.json:163 |
| muenzschatulle | beschreibung | Kleine schwere Holzschatulle mit alten Schlossmünzen, Reliefs auf dem Deckel. | gegenstaende.json:164 |
| muenzschatulle | lage.traeger | fatma | gegenstaende.json:166 |
| muenzschatulle | lage.stelle | in Fatmas Umhängetasche | gegenstaende.json:167 |
| muenzschatulle | sichtbar | false | gegenstaende.json:169 |
| leuchtmaske | id | leuchtmaske | gegenstaende.json:201 |
| leuchtmaske | name | Leuchtmaske | gegenstaende.json:202 |
| leuchtmaske | beschreibung | Weiße Gespenstermaske aus Kunststoff, am Nachmittag mit nachleuchtender Farbe bemalt. | gegenstaende.json:203 |
| leuchtmaske | lage.traeger | can | gegenstaende.json:205 |
| leuchtmaske | lage.stelle | in der Bauchtasche von Cans Pulli | gegenstaende.json:206 |
| leuchtmaske | sichtbar | false | gegenstaende.json:208 |
| bund_schneider | id | bund_schneider | gegenstaende.json:240 |
| bund_schneider | name | Herrn Schneiders Schlüsselbund | gegenstaende.json:241 |
| bund_schneider | beschreibung | Großer Bund mit dem Schlüssel für das Außentor, die Hoftür und den Turm. | gegenstaende.json:242 |
| bund_schneider | lage.versteckt | true | gegenstaende.json:244 |
| bund_schneider | sichtbar | false | gegenstaende.json:246 |
| bund_schneider | versteckJePfad.ahmet.einrichtung | jackenstaender | gegenstaende.json:249 |
| bund_schneider | versteckJePfad.ahmet.ort | am_jackenstaender | gegenstaende.json:250 |
| bund_schneider | versteckJePfad.ahmet.stelle | in der Innentasche von Ahmets Jacke | gegenstaende.json:251 |
| bund_schneider | versteckJePfad.fatma.einrichtung | linkes_buffet_13 | gegenstaende.json:254 |
| bund_schneider | versteckJePfad.fatma.ort | hinter_linkem_buffet | gegenstaende.json:255 |
| bund_schneider | versteckJePfad.fatma.stelle | in der Brottasche auf dem linken Buffettisch | gegenstaende.json:256 |
| bund_schneider | versteckJePfad.olli.ort | am_eiskuebel | gegenstaende.json:259 |
| bund_schneider | versteckJePfad.olli.stelle | unter dem Eis im Eiskübel | gegenstaende.json:260 |
| bund_schneider | versteckJePfad.can.ort | an_der_ruestung | gegenstaende.json:263 |
| bund_schneider | versteckJePfad.can.stelle | im Helm der Ritterrüstung | gegenstaende.json:264 |
| eiskuebel | id | eiskuebel | gegenstaende.json:269 |
| eiskuebel | name | Eiskübel | gegenstaende.json:270 |
| eiskuebel | beschreibung | Metallkübel mit Eiswürfeln am Ostende der Theke. | gegenstaende.json:271 |
| eiskuebel | lage.ort | am_eiskuebel | gegenstaende.json:273 |
| eiskuebel | sichtbar | true | gegenstaende.json:275 |
| brottasche | id | brottasche | gegenstaende.json:292 |
| brottasche | name | Brottasche | gegenstaende.json:293 |
| brottasche | beschreibung | Leinentasche mit Fladenbrot und Baguette auf dem linken Buffettisch. | gegenstaende.json:294 |
| brottasche | lage.einrichtung | linkes_buffet_13 | gegenstaende.json:296 |
| brottasche | lage.ort | hinter_linkem_buffet | gegenstaende.json:297 |
| brottasche | sichtbar | true | gegenstaende.json:299 |
| ruestungshelm | id | ruestungshelm | gegenstaende.json:316 |
| ruestungshelm | name | Helm der Ritterrüstung | gegenstaende.json:317 |
| ruestungshelm | beschreibung | Der Helm der alten Ritterrüstung im Turmgang, das Visier klemmt. | gegenstaende.json:318 |
| ruestungshelm | lage.einrichtung | ruestung | gegenstaende.json:320 |
| ruestungshelm | lage.ort | an_der_ruestung | gegenstaende.json:321 |
| ruestungshelm | sichtbar | true | gegenstaende.json:323 |
| quittung_aylin | id | quittung_aylin | gegenstaende.json:340 |
| quittung_aylin | name | Quittungszettel „Miete: 0 Euro“ | gegenstaende.json:341 |
| quittung_aylin | beschreibung | Ein Zettel aus Herrn Schneiders Quittungsblock, um 22:30 für Aylin geschrieben und unterschrieben. | gegenstaende.json:342 |
| quittung_aylin | lage.traeger | aylin | gegenstaende.json:344 |
| quittung_aylin | lage.stelle | in Aylins Ledermappe | gegenstaende.json:345 |
| quittung_aylin | sichtbar | false | gegenstaende.json:347 |
| klemmbrett_schneider | id | klemmbrett_schneider | gegenstaende.json:367 |
| klemmbrett_schneider | name | Herrn Schneiders Klemmbrett mit Quittungsblock | gegenstaende.json:368 |
| klemmbrett_schneider | beschreibung | Klemmbrett mit Durchschlägen aller Quittungen des Abends. | gegenstaende.json:369 |
| klemmbrett_schneider | lage.traeger | schneider | gegenstaende.json:371 |
| klemmbrett_schneider | sichtbar | false | gegenstaende.json:373 |
| bogentuer_schaden | id | bogentuer_schaden | gegenstaende.json:407 |
| bogentuer_schaden | name | Schaden an der Bogentür | gegenstaende.json:408 |
| bogentuer_schaden | beschreibung | Die geschnitzte Bogentür zwischen Kaminsaal und Turmgang. | gegenstaende.json:409 |
| bogentuer_schaden | lage.ort | vor_bogentuer | gegenstaende.json:411 |
| bogentuer_schaden | lage.stelle | an der Bogentür | gegenstaende.json:412 |
| bogentuer_schaden | sichtbar | true | gegenstaende.json:414 |
| arbeitshandschuh_olli | id | arbeitshandschuh_olli | gegenstaende.json:431 |
| arbeitshandschuh_olli | name | Ollis linker Arbeitshandschuh | gegenstaende.json:432 |
| arbeitshandschuh_olli | beschreibung | Ollis linker Arbeitshandschuh. Er hat ihn um 19:30 beim Wärmen am Kamin liegen lassen. | gegenstaende.json:433 |
| arbeitshandschuh_olli | lage.ort | am_kamin | gegenstaende.json:435 |
| arbeitshandschuh_olli | lage.stelle | in der Kamin-Nische | gegenstaende.json:436 |
| arbeitshandschuh_olli | sichtbar | true | gegenstaende.json:438 |
| handschuh_weste_olli | id | handschuh_weste_olli | gegenstaende.json:454 |
| handschuh_weste_olli | name | Ollis rechter Arbeitshandschuh | gegenstaende.json:455 |
| handschuh_weste_olli | beschreibung | Der rechte Arbeitshandschuh hängt aus der Tasche von Ollis Daunenweste. | gegenstaende.json:456 |
| handschuh_weste_olli | lage.traeger | olli | gegenstaende.json:458 |
| handschuh_weste_olli | lage.stelle | hängt aus der Westentasche | gegenstaende.json:459 |
| handschuh_weste_olli | sichtbar | false | gegenstaende.json:461 |
| moebelwachs_dose | id | moebelwachs_dose | gegenstaende.json:490 |
| moebelwachs_dose | name | Dose mit braunem Möbelwachs | gegenstaende.json:491 |
| moebelwachs_dose | beschreibung | Aus Wojteks Werkzeugtasche. | gegenstaende.json:492 |
| moebelwachs_dose | lage.traeger | kaan | gegenstaende.json:494 |
| moebelwachs_dose | lage.stelle | in Wojteks Werkzeugtasche | gegenstaende.json:495 |
| moebelwachs_dose | sichtbar | false | gegenstaende.json:497 |
| mehrfachsteckdose_tim | id | mehrfachsteckdose_tim | gegenstaende.json:514 |
| mehrfachsteckdose_tim | name | Tims alte Mehrfachsteckdose | gegenstaende.json:515 |
| mehrfachsteckdose_tim | beschreibung | Eine alte Steckdosenleiste, an der die Kaffeemaschine hängt. | gegenstaende.json:516 |
| mehrfachsteckdose_tim | lage.ort | hinter_theke_ost | gegenstaende.json:518 |
| mehrfachsteckdose_tim | lage.stelle | auf dem Boden hinter der Theke beim Kaffeeautomaten | gegenstaende.json:519 |
| mehrfachsteckdose_tim | sichtbar | true | gegenstaende.json:521 |
| notlaterne | id | notlaterne | gegenstaende.json:538 |
| notlaterne | name | Notlaterne | gegenstaende.json:539 |
| notlaterne | beschreibung | Akkulaterne am Haken direkt hinter der Vorratsraumtür. | gegenstaende.json:540 |
| notlaterne | lage.ort | vorrat_innen | gegenstaende.json:542 |
| notlaterne | lage.stelle | am Haken neben der Tür | gegenstaende.json:543 |
| notlaterne | sichtbar | true | gegenstaende.json:545 |
| vitrine | id | vitrine | gegenstaende.json:561 |
| vitrine | name | Schauvitrine im Turmgang | gegenstaende.json:562 |
| vitrine | beschreibung | Alte Vitrine mit Holzrahmen ohne Messing; seit 21:00 hat die Scheibe einen Sprung. | gegenstaende.json:563 |
| vitrine | lage.einrichtung | vitrine | gegenstaende.json:565 |
| vitrine | lage.ort | an_der_vitrine | gegenstaende.json:566 |
| vitrine | sichtbar | true | gegenstaende.json:568 |
| glassplitter_mantel | id | glassplitter_mantel | gegenstaende.json:584 |
| glassplitter_mantel | name | Glassplitter an Fatmas Mantel | gegenstaende.json:585 |
| glassplitter_mantel | beschreibung | Winzige Glassplitter im Wollmantel. | gegenstaende.json:586 |
| glassplitter_mantel | lage.traeger | fatma | gegenstaende.json:588 |
| glassplitter_mantel | lage.stelle | am rechten Ärmel des beerenroten Mantels | gegenstaende.json:589 |
| glassplitter_mantel | sichtbar | false | gegenstaende.json:591 |
| gelbe_fasern | id | gelbe_fasern | gegenstaende.json:611 |
| gelbe_fasern | name | Gelbe Fasern | gegenstaende.json:612 |
| gelbe_fasern | beschreibung | Fasern zwischen Herrn Schneiders Fingern. | gegenstaende.json:613 |
| gelbe_fasern | lage.traeger | schneider | gegenstaende.json:615 |
| gelbe_fasern | lage.stelle | an der rechten Hand | gegenstaende.json:616 |
| gelbe_fasern | sichtbar | false | gegenstaende.json:618 |
| wachs_boden | id | wachs_boden | gegenstaende.json:644 |
| wachs_boden | name | Rotes Wachs auf dem Boden | gegenstaende.json:645 |
| wachs_boden | beschreibung | Spritzer von rotem Kerzenwachs. | gegenstaende.json:646 |
| wachs_boden | lage.ort | vor_vorratstuer | gegenstaende.json:648 |
| wachs_boden | lage.stelle | auf dem Steinboden vor der Vorratsraumtür | gegenstaende.json:649 |
| wachs_boden | sichtbar | true | gegenstaende.json:651 |
| foto_joanna | id | foto_joanna | gegenstaende.json:667 |
| foto_joanna | name | Joannas Foto von 23:51 | gegenstaende.json:668 |
| foto_joanna | beschreibung | Ein Foto auf Joannas Handy. | gegenstaende.json:669 |
| foto_joanna | lage.traeger | johanna | gegenstaende.json:671 |
| foto_joanna | lage.stelle | auf ihrem Handy | gegenstaende.json:672 |
| foto_joanna | sichtbar | false | gegenstaende.json:674 |
| notizbuch_tugba | id | notizbuch_tugba | gegenstaende.json:693 |
| notizbuch_tugba | name | Tugbas Notizbuch | gegenstaende.json:694 |
| notizbuch_tugba | beschreibung | Goldenes Notizbuch mit dem Ablaufplan. | gegenstaende.json:695 |
| notizbuch_tugba | lage.traeger | tugba | gegenstaende.json:697 |
| notizbuch_tugba | sichtbar | false | gegenstaende.json:699 |
| handykorb | id | handykorb | gegenstaende.json:719 |
| handykorb | name | Handykorb | gegenstaende.json:720 |
| handykorb | beschreibung | Korb für die Handys auf der Tafel im Ost-Saal. Er steht seit 23:50 dort; ab 23:55 kommen alle Handys hinein. | gegenstaende.json:721 |
| handykorb | lage.ort | am_handykorb | gegenstaende.json:723 |
| handykorb | sichtbar | true | gegenstaende.json:725 |
| torte | id | torte | gegenstaende.json:741 |
| torte | name | Geburtstagstorte | gegenstaende.json:742 |
| torte | beschreibung | Die Torte auf dem Regal im kühlen Vorratsraum. | gegenstaende.json:743 |
| torte | lage.ort | vorrat_mitte | gegenstaende.json:745 |
| torte | sichtbar | true | gegenstaende.json:747 |
| stirnlampe_tim | id | stirnlampe_tim | gegenstaende.json:763 |
| stirnlampe_tim | name | Tims Stirnlampe | gegenstaende.json:764 |
| stirnlampe_tim | beschreibung | Kleine Stirnlampe an einem Band um den Hals. Beim Tasten nach dem Hauptschalter rutschte sie ihm vom Hals; um 23:59:40 fand er sie auf dem Boden. | gegenstaende.json:765 |
| stirnlampe_tim | lage.traeger | tim | gegenstaende.json:767 |
| stirnlampe_tim | lage.stelle | um den Hals | gegenstaende.json:768 |
| stirnlampe_tim | sichtbar | false | gegenstaende.json:770 |
| mietgeld | id | mietgeld | gegenstaende.json:786 |
| mietgeld | name | Bündel mit dem Mietgeld | gegenstaende.json:787 |
| mietgeld | beschreibung | Neunzehnmal 150 €, zusammen 2.850 €. | gegenstaende.json:788 |
| mietgeld | lage.traeger | ahmet | gegenstaende.json:790 |
| mietgeld | lage.stelle | in Ahmets Hosentasche, seit 0:12 | gegenstaende.json:791 |
| mietgeld | sichtbar | false | gegenstaende.json:793 |

### 3.2 Spuren (Aussehen und Material der Spur, Pfadbedingung `entstehtWenn`) (36 Spuren)

| Gegenstand | Spur-id | Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|---|---|
| kerzenstaender | spur_staender_verbogen | stelle | Schaft | gegenstaende.json:17 |
| kerzenstaender | spur_staender_verbogen | entstehtWenn.immer | true | gegenstaende.json:19 |
| kerzenstaender | spur_staender_verbogen | zeigt | Der Schaft ist leicht verbogen, die drei roten Kerzen liegen daneben am Boden. | gegenstaende.json:21 |
| kerzenstaender | spur_griff_papier | stelle | Griff | gegenstaende.json:28 |
| kerzenstaender | spur_griff_papier | entstehtWenn.kerzenstaenderGegriffenVon | ahmet | gegenstaende.json:30 |
| kerzenstaender | spur_griff_papier | zeigt | Am Griff klebt im erstarrten Wachs eine abgerissene Ecke braunes Umschlagpapier. Darauf steht „…keller“, in Ahmets Handschrift. | gegenstaende.json:32 |
| kerzenstaender | spur_griff_papier | harmlos | Der Griff ist mit rotem Wachs verschmiert. | gegenstaende.json:33 |
| kerzenstaender | spur_griff_leuchtfarbe | stelle | Griff | gegenstaende.json:40 |
| kerzenstaender | spur_griff_leuchtfarbe | entstehtWenn.kerzenstaenderGegriffenVon | can | gegenstaende.json:42 |
| kerzenstaender | spur_griff_leuchtfarbe | zeigt | Um den Griff liegt der Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe. Es ist dieselbe Farbe wie auf der Maske. | gegenstaende.json:44 |
| kerzenstaender | spur_griff_leuchtfarbe | harmlos | Der Griff ist mit rotem Wachs verschmiert. | gegenstaende.json:45 |
| kerzenstaender | spur_fuss_splitter | stelle | Fuß | gegenstaende.json:52 |
| kerzenstaender | spur_fuss_splitter | entstehtWenn.kerzenstaenderGegriffenVon | olli | gegenstaende.json:54 |
| kerzenstaender | spur_fuss_splitter | zeigt | Im erstarrten roten Wachs am Fuß kleben feine Holzsplitter und weißer Kalk. | gegenstaende.json:56 |
| kerzenstaender | spur_fuss_splitter | harmlos | Am Fuß klebt rotes Wachs. | gegenstaende.json:57 |
| silberring_fatma | spur_ring_messing | stelle | Außenseite | gegenstaende.json:75 |
| silberring_fatma | spur_ring_messing | entstehtWenn.kerzenstaenderGegriffenVon | fatma | gegenstaende.json:77 |
| silberring_fatma | spur_ring_messing | zeigt | In einer Kerbe des Rings steckt frischer, goldgelber Messingabrieb. | gegenstaende.json:79 |
| silberring_fatma | spur_ring_messing | harmlos | In einer Kerbe des Rings sind feine Kratzer von der Glasscheibe der Vitrine. | gegenstaende.json:80 |
| jacke_ahmet | spur_jacke_namensliste | stelle | Brusttasche | gegenstaende.json:100 |
| jacke_ahmet | spur_jacke_namensliste | entstehtWenn.immer | true | gegenstaende.json:102 |
| jacke_ahmet | spur_jacke_namensliste | zeigt | Eine Liste mit allen Namen der Gäste, hinter jedem „150 € ✓“. | gegenstaende.json:104 |
| jacke_ahmet | spur_jacke_bund | stelle | Innentasche | gegenstaende.json:112 |
| jacke_ahmet | spur_jacke_bund | entstehtWenn.bundEndetBei | jackenstaender | gegenstaende.json:114 |
| jacke_ahmet | spur_jacke_bund | zeigt | In der Innentasche der Jacke steckt Herrn Schneiders großer Schlüsselbund. | gegenstaende.json:116 |
| jacke_ahmet | spur_jacke_bund | harmlos | In der Innentasche liegt ein Kaugummipapier. | gegenstaende.json:117 |
| umschlag_mietgeld | spur_umschlag_aufschrift | stelle | Vorderseite | gegenstaende.json:137 |
| umschlag_mietgeld | spur_umschlag_aufschrift | entstehtWenn.immer | true | gegenstaende.json:139 |
| umschlag_mietgeld | spur_umschlag_aufschrift | zeigt | „Miete Schlosskeller“ in Ahmets Handschrift. Der Umschlag ist leer. Darauf angesprochen gibt Ahmet zu: Er hat von allen 150 € Miete eingesammelt, obwohl der Keller nichts kostet. | gegenstaende.json:141 |
| umschlag_mietgeld | spur_umschlag_wachs | stelle | Rückseite | gegenstaende.json:149 |
| umschlag_mietgeld | spur_umschlag_wachs | entstehtWenn.kerzenstaenderGegriffenVon | ahmet | gegenstaende.json:151 |
| umschlag_mietgeld | spur_umschlag_wachs | zeigt | Auf dem Umschlag sind drei erstarrte rote Wachstropfen. Eine Ecke des Umschlags ist abgerissen. | gegenstaende.json:153 |
| umschlag_mietgeld | spur_umschlag_wachs | harmlos | Auf dem Umschlag ist ein Knick. | gegenstaende.json:154 |
| muenzschatulle | spur_schatulle_da | stelle | Tasche | gegenstaende.json:173 |
| muenzschatulle | spur_schatulle_da | entstehtWenn.immer | true | gegenstaende.json:175 |
| muenzschatulle | spur_schatulle_da | zeigt | Die Schatulle aus der Vitrine liegt in Fatmas Tasche, zwischen Skizzenblock und Stiften. Darauf angesprochen gibt Fatma zu: Sie hat die Schatulle um 23:40 aus der Vitrine genommen. | gegenstaende.json:177 |
| muenzschatulle | spur_schatulle_wachs | stelle | Deckel | gegenstaende.json:188 |
| muenzschatulle | spur_schatulle_wachs | entstehtWenn.kerzenstaenderGegriffenVon | fatma | gegenstaende.json:190 |
| muenzschatulle | spur_schatulle_wachs | zeigt | Auf dem Deckel der Münzschatulle kleben rote Wachstropfen. | gegenstaende.json:192 |
| muenzschatulle | spur_schatulle_wachs | harmlos | Der Deckel sieht unauffällig aus. | gegenstaende.json:193 |
| leuchtmaske | spur_maske_da | stelle | Bauchtasche | gegenstaende.json:212 |
| leuchtmaske | spur_maske_da | entstehtWenn.immer | true | gegenstaende.json:214 |
| leuchtmaske | spur_maske_da | zeigt | Die Maske steckt zusammengefaltet in Cans Bauchtasche. Die Farbe ist noch leicht klebrig. Darauf angesprochen gibt Can zu: Er hat im dunklen Vorratsraum gewartet, um das Geburtstagskind zu erschrecken. | gegenstaende.json:216 |
| leuchtmaske | spur_maske_wachs | stelle | Stirn der Maske | gegenstaende.json:227 |
| leuchtmaske | spur_maske_wachs | entstehtWenn.kerzenstaenderGegriffenVon | can | gegenstaende.json:229 |
| leuchtmaske | spur_maske_wachs | zeigt | Auf der Stirn der Maske kleben rote Wachstropfen. | gegenstaende.json:231 |
| leuchtmaske | spur_maske_wachs | harmlos | Auf der Stirn der Maske ist grünlich-weiße Leuchtfarbe. | gegenstaende.json:232 |
| eiskuebel | spur_eiskuebel_bund | stelle | unter dem Eis | gegenstaende.json:279 |
| eiskuebel | spur_eiskuebel_bund | entstehtWenn.bundEndetBei | am_eiskuebel | gegenstaende.json:281 |
| eiskuebel | spur_eiskuebel_bund | zeigt | Im Eiskübel liegt unter den Eiswürfeln Herrn Schneiders Schlüsselbund. | gegenstaende.json:283 |
| eiskuebel | spur_eiskuebel_bund | harmlos | Im Eiskübel sind Eiswürfel und Schmelzwasser. | gegenstaende.json:284 |
| brottasche | spur_brottasche_bund | stelle | unter dem Brot | gegenstaende.json:303 |
| brottasche | spur_brottasche_bund | entstehtWenn.bundEndetBei | linkes_buffet_13 | gegenstaende.json:305 |
| brottasche | spur_brottasche_bund | zeigt | In der Brottasche liegt unter dem Brot Herrn Schneiders Schlüsselbund. | gegenstaende.json:307 |
| brottasche | spur_brottasche_bund | harmlos | In der Brottasche liegen Brot und Krümel. | gegenstaende.json:308 |
| ruestungshelm | spur_helm_bund | stelle | im Helm | gegenstaende.json:327 |
| ruestungshelm | spur_helm_bund | entstehtWenn.bundEndetBei | an_der_ruestung | gegenstaende.json:329 |
| ruestungshelm | spur_helm_bund | zeigt | Im Helm klemmt Herrn Schneiders Schlüsselbund. | gegenstaende.json:331 |
| ruestungshelm | spur_helm_bund | harmlos | Im Helm sind Staub und eine alte Spinnwebe. | gegenstaende.json:332 |
| quittung_aylin | spur_quittung | stelle | Zettel | gegenstaende.json:351 |
| quittung_aylin | spur_quittung | entstehtWenn.immer | true | gegenstaende.json:353 |
| quittung_aylin | spur_quittung | zeigt | „Miete: 0 Euro. Schneider“. Aylin sagt: Ahmet hat trotzdem von allen 150 € eingesammelt. | gegenstaende.json:355 |
| klemmbrett_schneider | spur_klemmbrett_tuer | stelle | Durchschlag 18:50 | gegenstaende.json:377 |
| klemmbrett_schneider | spur_klemmbrett_tuer | entstehtWenn.immer | true | gegenstaende.json:379 |
| klemmbrett_schneider | spur_klemmbrett_tuer | zeigt | „Bogentür, Beschlag ausgerissen: 2.000 € Bargeld. Bis Mitternacht.“ | gegenstaende.json:381 |
| klemmbrett_schneider | spur_klemmbrett_tuer | belastet[0] | olli | gegenstaende.json:386 |
| klemmbrett_schneider | spur_klemmbrett_miete | stelle | Durchschlag 22:30 | gegenstaende.json:391 |
| klemmbrett_schneider | spur_klemmbrett_miete | entstehtWenn.immer | true | gegenstaende.json:393 |
| klemmbrett_schneider | spur_klemmbrett_miete | zeigt | „Miete: 0 Euro.“ | gegenstaende.json:395 |
| bogentuer_schaden | spur_tuer_beschlag | stelle | Türrahmen | gegenstaende.json:418 |
| bogentuer_schaden | spur_tuer_beschlag | entstehtWenn.immer | true | gegenstaende.json:420 |
| bogentuer_schaden | spur_tuer_beschlag | zeigt | Ein Beschlag ist ausgerissen, frische Holzsplitter, weißer Kalk vom Türbogen, darüber ein Rest braunes Möbelwachs. | gegenstaende.json:422 |
| arbeitshandschuh_olli | spur_handschuh_russ | stelle | Innenfläche | gegenstaende.json:442 |
| arbeitshandschuh_olli | spur_handschuh_russ | entstehtWenn.immer | true | gegenstaende.json:444 |
| arbeitshandschuh_olli | spur_handschuh_russ | zeigt | Ein linker Arbeitshandschuh, rußig vom Kamin. Kein Wachs daran. | gegenstaende.json:446 |
| handschuh_weste_olli | spur_weste_moebelwachs | stelle | Fingerkuppen | gegenstaende.json:465 |
| handschuh_weste_olli | spur_weste_moebelwachs | entstehtWenn.immer | true | gegenstaende.json:467 |
| handschuh_weste_olli | spur_weste_moebelwachs | zeigt | Braunes Möbelwachs und weißer Kalk an den Fingerkuppen. Darauf angesprochen gibt Olli zu: Er hat um 18:35 den Beschlag der Bogentür ausgerissen und die Schramme mit Wojteks Möbelwachs zugerieben. | gegenstaende.json:469 |
| handschuh_weste_olli | spur_weste_kerzenwachs | stelle | Handrücken | gegenstaende.json:477 |
| handschuh_weste_olli | spur_weste_kerzenwachs | entstehtWenn.kerzenstaenderGegriffenVon | olli | gegenstaende.json:479 |
| handschuh_weste_olli | spur_weste_kerzenwachs | zeigt | Auf dem Handrücken des Handschuhs kleben frische rote Kerzenwachstropfen. | gegenstaende.json:481 |
| handschuh_weste_olli | spur_weste_kerzenwachs | harmlos | Auf dem Handrücken des Handschuhs ist Kalkstaub. | gegenstaende.json:482 |
| moebelwachs_dose | spur_moebelwachs | stelle | Deckel | gegenstaende.json:501 |
| moebelwachs_dose | spur_moebelwachs | entstehtWenn.immer | true | gegenstaende.json:503 |
| moebelwachs_dose | spur_moebelwachs | zeigt | Halb leer, am Rand Holzstaub. | gegenstaende.json:505 |
| mehrfachsteckdose_tim | spur_steckdose_verschmort | stelle | Stecker | gegenstaende.json:525 |
| mehrfachsteckdose_tim | spur_steckdose_verschmort | entstehtWenn.immer | true | gegenstaende.json:527 |
| mehrfachsteckdose_tim | spur_steckdose_verschmort | zeigt | Ein Steckplatz ist schwarz verschmort. Hier kam der Kurzschluss her. | gegenstaende.json:529 |
| notlaterne | spur_laterne_unberuehrt | stelle | Haken | gegenstaende.json:549 |
| notlaterne | spur_laterne_unberuehrt | entstehtWenn.immer | true | gegenstaende.json:551 |
| notlaterne | spur_laterne_unberuehrt | zeigt | Die Laterne hängt unberührt am Haken neben der Tür. Herr Schneider hat sie nie in die Hand bekommen. | gegenstaende.json:553 |
| vitrine | spur_vitrine_leer | stelle | Samtbett | gegenstaende.json:572 |
| vitrine | spur_vitrine_leer | entstehtWenn.immer | true | gegenstaende.json:574 |
| vitrine | spur_vitrine_leer | zeigt | Die gesprungene Scheibe ist angehoben, Scherben am Boden, das Samtbett der Münzschatulle ist leer. | gegenstaende.json:576 |
| glassplitter_mantel | spur_mantel_glas | stelle | Ärmel | gegenstaende.json:595 |
| glassplitter_mantel | spur_mantel_glas | entstehtWenn.immer | true | gegenstaende.json:597 |
| glassplitter_mantel | spur_mantel_glas | zeigt | Feine Glassplitter, wie von der Vitrinenscheibe. | gegenstaende.json:599 |
| gelbe_fasern | spur_fasern_kapuze | stelle | rechte Hand | gegenstaende.json:622 |
| gelbe_fasern | spur_fasern_kapuze | entstehtWenn.immer | true | gegenstaende.json:624 |
| gelbe_fasern | spur_fasern_kapuze | zeigt | Knallgelbe Fasern, wie von einer Kapuze. | gegenstaende.json:626 |
| gelbe_fasern | spur_fasern_kapuze | belastet[0] | can | gegenstaende.json:634 |
| gelbe_fasern | spur_fasern_kapuze | widerlegtDurch | Herr Schneider hat Can im Dunkeln an der Kapuze gepackt, noch vor seiner Gedächtnislücke. Die Fasern zeigen den Griff, nicht den Schlag. | gegenstaende.json:636 |
| wachs_boden | spur_wachs_boden | stelle | Boden | gegenstaende.json:655 |
| wachs_boden | spur_wachs_boden | entstehtWenn.immer | true | gegenstaende.json:657 |
| wachs_boden | spur_wachs_boden | zeigt | Rote Wachsspritzer rund um die Stelle, an der der Kerzenständer liegt. | gegenstaende.json:659 |
| foto_joanna | spur_foto_streit | stelle | Galerie | gegenstaende.json:678 |
| foto_joanna | spur_foto_streit | entstehtWenn.immer | true | gegenstaende.json:680 |
| foto_joanna | spur_foto_streit | zeigt | 23:51: Herr Schneider und Ahmet streiten an der Theke, Ahmet hält einen dicken Umschlag. | gegenstaende.json:682 |
| foto_joanna | spur_foto_streit | belastet[0] | ahmet | gegenstaende.json:687 |
| notizbuch_tugba | spur_notiz_fehlende | stelle | Seite 23:57 | gegenstaende.json:703 |
| notizbuch_tugba | spur_notiz_fehlende | entstehtWenn.immer | true | gegenstaende.json:705 |
| notizbuch_tugba | spur_notiz_fehlende | zeigt | „Fehlen für die Torte: Ahmet (Theke, Servietten), Fatma (Theke), Olli (Eis), Can (?).“ Darunter: „Emine und Azra (Buffet), Damir und Tim (Kaffee), Marek (Saft), Zeynep, Hana, Wojtek, Sibel (Kaminsaal), Serkan (Auto).“ | gegenstaende.json:707 |
| handykorb | spur_handykorb | stelle | Korb | gegenstaende.json:729 |
| handykorb | spur_handykorb | entstehtWenn.immer | true | gegenstaende.json:731 |
| handykorb | spur_handykorb | zeigt | Alle Handys liegen darin. Hinter den Mauern hat keines Empfang. | gegenstaende.json:733 |
| torte | spur_torte | stelle | Regal | gegenstaende.json:751 |
| torte | spur_torte | entstehtWenn.immer | true | gegenstaende.json:753 |
| torte | spur_torte | zeigt | Unversehrt. Wenigstens etwas. | gegenstaende.json:755 |
| stirnlampe_tim | spur_stirnlampe | stelle | Lampe | gegenstaende.json:774 |
| stirnlampe_tim | spur_stirnlampe | entstehtWenn.immer | true | gegenstaende.json:776 |
| stirnlampe_tim | spur_stirnlampe | zeigt | Funktioniert. Damit hat Tim um Mitternacht den Sicherungskasten gefunden. | gegenstaende.json:778 |
| mietgeld | spur_mietgeld | stelle | Hosentasche | gegenstaende.json:797 |
| mietgeld | spur_mietgeld | entstehtWenn.immer | true | gegenstaende.json:799 |
| mietgeld | spur_mietgeld | zeigt | Ein dickes Bündel Scheine, 2.850 €. Ahmet hat nichts davon ausgegeben. | gegenstaende.json:801 |

Nicht übernommen in den Spuren (Beweislogik, kein Aussehen): kerzenstaender: spur_staender_verbogen.rolle (gegenstaende.json:22), spur_griff_papier.rolle (gegenstaende.json:34), spur_griff_leuchtfarbe.rolle (gegenstaende.json:46), spur_fuss_splitter.rolle (gegenstaende.json:58); silberring_fatma: spur_ring_messing.rolle (gegenstaende.json:81); jacke_ahmet: spur_jacke_namensliste.rolle (gegenstaende.json:105), spur_jacke_namensliste.nebendelikt (gegenstaende.json:108), spur_jacke_bund.rolle (gegenstaende.json:118); umschlag_mietgeld: spur_umschlag_aufschrift.rolle (gegenstaende.json:142), spur_umschlag_aufschrift.nebendelikt (gegenstaende.json:145), spur_umschlag_wachs.rolle (gegenstaende.json:155); muenzschatulle: spur_schatulle_da.rolle (gegenstaende.json:178), spur_schatulle_da.nebendelikt (gegenstaende.json:181), spur_schatulle_da.widerlegt (gegenstaende.json:182), spur_schatulle_wachs.rolle (gegenstaende.json:194); leuchtmaske: spur_maske_da.rolle (gegenstaende.json:217), spur_maske_da.nebendelikt (gegenstaende.json:220), spur_maske_da.widerlegt (gegenstaende.json:221), spur_maske_wachs.rolle (gegenstaende.json:233); eiskuebel: spur_eiskuebel_bund.rolle (gegenstaende.json:285); brottasche: spur_brottasche_bund.rolle (gegenstaende.json:309); ruestungshelm: spur_helm_bund.rolle (gegenstaende.json:333); quittung_aylin: spur_quittung.rolle (gegenstaende.json:356), spur_quittung.nebendelikt (gegenstaende.json:359), spur_quittung.widerlegt (gegenstaende.json:360); klemmbrett_schneider: spur_klemmbrett_tuer.rolle (gegenstaende.json:382), spur_klemmbrett_miete.rolle (gegenstaende.json:396), spur_klemmbrett_miete.nebendelikt (gegenstaende.json:399), spur_klemmbrett_miete.widerlegt (gegenstaende.json:400); bogentuer_schaden: spur_tuer_beschlag.rolle (gegenstaende.json:423), spur_tuer_beschlag.nebendelikt (gegenstaende.json:426); arbeitshandschuh_olli: spur_handschuh_russ.rolle (gegenstaende.json:447); handschuh_weste_olli: spur_weste_moebelwachs.rolle (gegenstaende.json:470), spur_weste_moebelwachs.nebendelikt (gegenstaende.json:473), spur_weste_kerzenwachs.rolle (gegenstaende.json:483); moebelwachs_dose: spur_moebelwachs.rolle (gegenstaende.json:506), spur_moebelwachs.nebendelikt (gegenstaende.json:509); mehrfachsteckdose_tim: spur_steckdose_verschmort.rolle (gegenstaende.json:530), spur_steckdose_verschmort.nebendelikt (gegenstaende.json:533); notlaterne: spur_laterne_unberuehrt.rolle (gegenstaende.json:554); vitrine: spur_vitrine_leer.rolle (gegenstaende.json:577); glassplitter_mantel: spur_mantel_glas.rolle (gegenstaende.json:600), spur_mantel_glas.nebendelikt (gegenstaende.json:603), spur_mantel_glas.widerlegt (gegenstaende.json:604); gelbe_fasern: spur_fasern_kapuze.rolle (gegenstaende.json:627), spur_fasern_kapuze.widerlegt (gegenstaende.json:637); wachs_boden: spur_wachs_boden.rolle (gegenstaende.json:660); foto_joanna: spur_foto_streit.rolle (gegenstaende.json:683); notizbuch_tugba: spur_notiz_fehlende.rolle (gegenstaende.json:708), spur_notiz_fehlende.widerlegt (gegenstaende.json:711); handykorb: spur_handykorb.rolle (gegenstaende.json:734); torte: spur_torte.rolle (gegenstaende.json:756); stirnlampe_tim: spur_stirnlampe.rolle (gegenstaende.json:779); mietgeld: spur_mietgeld.rolle (gegenstaende.json:802), spur_mietgeld.nebendelikt (gegenstaende.json:805), spur_mietgeld.widerlegt (gegenstaende.json:806).

Nicht übernommen: `nebendelikte` (gegenstaende.json:813–854, 8 Einträge, Beweis- und Erzähllogik).

---

## 4. Setting (Bau- und Materialbeschreibungen) und Zeitleiste

### 4.1 `setting.json` (vollständig, wörtlich)

| Feld | Wert (wörtlich) | Datei:Zeile |
|---|---|---|
| settingId | spuk_im_schlosskeller | setting.json:2 |
| schauplatz | Ein altes, etwas abgelegenes Schloss vor der Stadt. Gefeiert wird im großen Gewölbekeller unter dem Schlossturm. | setting.json:3 |
| anlass | Geburtstag. Ahmet hat den Keller über einen Gefallen organisiert: Er gestaltet umsonst das Programm des Adventsmarkts der Schlossstiftung. | setting.json:4 |
| datum | ein Samstag im November; draußen kalt und windig | setting.json:5 |
| essen | Offenes Buffet auf langen Holztischen: warmes Essen aus Warmhaltebehältern, frisches Brot, Dips und Gebäck. | setting.json:6 |
| getraenke[0] | schwarzer Tee aus dem großen Teekocher | setting.json:8 |
| getraenke[1] | Kaffee | setting.json:9 |
| getraenke[2] | warmer, alkoholfreier Apfelpunsch | setting.json:10 |
| getraenke[3] | Wasser | setting.json:11 |
| getraenke[4] | Säfte | setting.json:12 |
| empfang | Hinter den dicken Mauern gibt es keinen Handyempfang. Empfang gibt es erst draußen auf den Stufen zum Parkplatz. | setting.json:14 |
| atmosphaere[0] | Der Wind pfeift durch die Lichtschächte. | setting.json:16 |
| atmosphaere[1] | Schwere Holztüren quietschen im Luftzug. | setting.json:17 |
| atmosphaere[2] | Elektrische Kerzen flackern auf den Tafeln; echte Kerzen brennen nur im Messingkerzenständer an der Theke. | setting.json:18 |
| brandschutz | Im denkmalgeschützten Keller sind offene Flammen verboten. Erlaubt ist nur der Kerzenständer an der Theke, auf Schneiders Verantwortung, und der Kamin unter Aufsicht. | setting.json:20 |
| lacher[0].id | lacher_ruestung | setting.json:23 |
| lacher[0].zeit | 21:00 | setting.json:24 |
| lacher[0].wer | selin | setting.json:25 |
| lacher[0].ort | an_der_ruestung | setting.json:26 |
| lacher[0].was | Sibel hält die alte Ritterrüstung im Turmgang für einen Menschen, schreit auf und stolpert rückwärts gegen die Schauvitrine. Die Scheibe bekommt einen feinen Sprung. | setting.json:27 |
| lacher[0].traegt | Spur: Ab 21:00 ist die Vitrinenscheibe lose. | setting.json:28 |
| lacher[1].id | lacher_verlaufen | setting.json:31 |
| lacher[1].zeit | 20:15 | setting.json:32 |
| lacher[1].wer | olli | setting.json:33 |
| lacher[1].ort | vorrat_mitte | setting.json:34 |
| lacher[1].was | Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“ | setting.json:35 |
| lacher[1].traegt | Falsche Fährte: Olli kennt den Vorratsraum. | setting.json:36 |
| lacher[2].id | lacher_kamin | setting.json:39 |
| lacher[2].zeit | 23:30 | setting.json:40 |
| lacher[2].wer | meryem | setting.json:41 |
| lacher[2].ort | am_kamin | setting.json:42 |
| lacher[2].was | Hana feuert den Kamin an, ohne die Kaminklappe zu öffnen. Dichter Qualm füllt den Kaminsaal, alle husten, die Lichtschacht-Klappen werden aufgerissen, das Feuer wird gelöscht. | setting.json:43 |
| lacher[2].traegt | Spur: Seit 23:30 zieht Luft vom Buffetsaal in den Kaminsaal; Gerüche wandern mit. | setting.json:44 |
| ton | Grusel mit Humor: quietschende Türen, Zugluft, flackerndes Licht, verpatzte Streiche. Herr Schneider überlebt immer; der Schlag ist nur Schatten und Geräusch. | setting.json:47 |

### 4.2 `zeitleiste.json`: Einträge mit Bau- oder Materialwort (Stichwortsuche im Feld `text`)

| Eintrag | zeit | ort | text (wörtlich) | Treffer-Stichwort | Datei:Zeile |
|---|---|---|---|---|---|
| z_ankunft | 18:00 | im_windfang | Die Gäste kommen über die fünf Sandsteinstufen und das Außentor in den Keller. Herr Schneider begrüßt alle knapp und zeigt den Weg. | keller, sandstein, stufe, tor | zeitleiste.json:12 |
| z_lieferung | 18:30 | an_der_ruestung | Marek liefert das Essen über den Schlosshof und parkt auf Herrn Schneiders reserviertem Platz. Olli und Wojtek tragen die Warmhaltebehälter durch Hoftür, Turmgang und Bogentür. | schloss, turm, tür | zeitleiste.json:24 |
| z_tuerschaden | 18:35 | vor_bogentuer | Olli schrammt mit einem Warmhaltebehälter die geschnitzte Bogentür. Ein Beschlag reißt aus, Holzsplitter und weißer Kalk bleiben an seinen Pulli-Ärmeln. | beschlag, holz, kalk, tür | zeitleiste.json:35 |
| z_forderung | 18:50 | vor_bogentuer | Herr Schneider entdeckt den Schaden, verlangt 2.000 € Bargeld und schreibt es in seinen Quittungsblock. Er schließt Hoftür und Außentor ab: „Keiner geht, bevor das bezahlt ist.“ | tor, tür | zeitleiste.json:59 |
| z_handschuh | 19:30 | am_kamin | Olli wärmt sich am noch kalten Kamin die Hände und vergisst dort seinen linken Arbeitshandschuh. | kamin | zeitleiste.json:81 |
| z_verlaufen | 20:15 | vorrat_mitte | Lacher: Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“ | tür | zeitleiste.json:91 |
| z_ruestung | 21:00 | an_der_ruestung | Lacher: Sibel hält die Ritterrüstung für einen Menschen, schreit auf und stolpert gegen die Schauvitrine. Die Scheibe bekommt einen feinen Sprung. | rüstung, scheibe, vitrine | zeitleiste.json:102 |
| z_kerzen | 22:00 | an_anrichte | Herr Schneider zündet die drei roten Kerzen im Messingkerzenständer auf der Anrichte an. Es sind die einzigen echten Kerzen im Keller. | keller, kerze | zeitleiste.json:112 |
| z_kamin | 23:20 | am_kamin | Hana feuert den Kamin an, ohne die Kaminklappe zu öffnen. | kamin, klappe | zeitleiste.json:157 |
| z_qualm | 23:30 | am_kamin | Lacher: Dichter Qualm füllt den Kaminsaal, alle husten. Die Klappen der Lichtschächte werden aufgerissen, das Feuer wird gelöscht. Seitdem zieht Luft vom Buffetsaal in den Kaminsaal. | kamin, klappe, licht | zeitleiste.json:168 |
| z_vitrine_schatulle | 23:40 | an_der_vitrine | Fatma hebt die gesprungene Scheibe der Vitrine an und nimmt die Münzschatulle mit. Emine sieht es. | scheibe, vitrine | zeitleiste.json:180 |
| z_finger | 23:50 | vor_bogentuer | Wojtek klemmt sich an der Bogentür den Finger ein. | tür | zeitleiste.json:202 |
| z_foto_streit | 23:51 | vor_theke | Herr Schneider zu Ahmet an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“ Joanna fotografiert den Streit. | keller | zeitleiste.json:214 |
| z_vitrine_offen | 23:53 | an_der_vitrine | Herr Schneider entdeckt auf seiner Runde die offene Vitrine und die Scherben. | vitrine | zeitleiste.json:235 |
| z_can_vorrat | 23:54 | vorrat_mitte | Can schleicht über den Durchgang hinter die Theke in den Vorratsraum, macht dort das Licht aus und wartet mit der Leuchtmaske auf das Geburtstagskind. Zeynep steht am Bogen zum Durchgang Schmiere. | licht | zeitleiste.json:246 |
| z_serkan_tor | 23:56 | am_aussentor | Serkan will Decken aus dem Auto holen und findet das Außentor verschlossen. | schloss, tor | zeitleiste.json:281 |
| z_schatulle_entdeckt | 23:56 | am_linken_buffet | Herr Schneider sieht Glassplitter an Fatmas Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“ | glas | zeitleiste.json:294 |
| z_theke_2357 | 23:57 | vor_theke | Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“ | klappe | zeitleiste.json:310 |
| z_ausfall | 23:58 | hinter_theke_ost | Knall. Die Hauptsicherung fliegt raus, überall ist es dunkel. Nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten. | kerze | zeitleiste.json:332 |
| z_schlag | 23:58:40 | vor_vorratstuer | Ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden. Die Kerzen erlöschen. Herr Schneider stürzt in den Vorratsraum. Wer zugeschlagen hat, steht in der Tatmatrix des jeweiligen Pfads. | boden, kerze, metall, stein, tür | zeitleiste.json:355 |
| z_festgesetzt | 00:03 | unter_notausgang | Das Außentor ist zu, der Bund ist weg, hinter den Mauern gibt es keinen Empfang. Die Gruppe sitzt bis zum Morgen fest. | mauer, tor | zeitleiste.json:408 |
| z_umschlag | 00:12 | am_kamin | Ahmet leert den Umschlag mit dem Mietgeld und wirft ihn in den Ascheneimer am Kamin. Hana sieht es. | kamin | zeitleiste.json:428 |
| z_morgen | 07:00 | im_windfang | Herrn Schneiders Kollegin kommt mit dem Ersatzschlüssel und schließt das Außentor auf. | tor | zeitleiste.json:489 |

Von 44 Einträgen enthalten 23 ein Stichwort. Die übrigen sind Ereignisse ohne Bau- oder Materialbezug und sind nicht übernommen.

---

## 5. Lücken für das Modell

Geprüft gegen die fünf Kanon-Dateien. Stichwortsuche (ohne Groß-/Kleinschreibung) über alle fünf Dateien ergab die unten genannten Befunde.

1. **Raumhöhe:** Kein Höhenfeld in den 7 Raum-Blöcken (`raeume.json:9–143`). Nur `widthMeters` steht, und zwar im Thekensaal (`raeume.json:13`), in den übrigen 6 Räumen fehlt es.
2. **Größe in cm / Körpermaß:** Keine cm-Angaben (Treffer: 0). Maßstab ist `1 Kachel = 1 Meter` (`raeume.json:3`). Figuren haben nur die Kategorie `statur` (`figuren.json:141`, Erläuterung `figuren.json:1083`).
3. **Toiletten:** Die Toiletten oben im Turm sind genannt in `raeume.json:99` (Feature „Wendeltreppe zum WC“) und in der Turmgang-Beschreibung (`raeume.json:105`). Nur der Ort `wc` ist modelliert (`raeume.json:936–943`, `zusatzweg` 10). Er hat kein Rechteck und keinen eigenen Raum, und es gibt keine Einrichtung „Toilette“. Der Ort `wc` hat dieselben Koordinaten wie `wendeltreppe_fuss` (2.5 / 1.5, `raeume.json:929–935`), obwohl er oben im Turm liegt.
4. **Fassade:** Kein Eintrag. Treffer für „Fassade“ in den fünf Dateien: 0.
5. **Außenbereich:** Zwei Türen führen nach `draussen` (`raeume.json:150` und `raeume.json:267`). Dieses Ziel ist kein Raum und hat kein Rechteck.
6. **Stufen:** Nur als Text: „fünf Sandsteinstufen“ (`zeitleiste.json:12`) und „Stufen zum Parkplatz“ (`setting.json:14`). Keine Lage, Anzahl als Feld, Breite, Höhe.
7. **Gewölbe, Lichtschächte, Fenster:** Nur Text. Gewölbe in `setting.json:3`. Lichtschächte mit Klappen in `raeume.json:78` (features) sowie in der Beschreibung des Kaminsaals. Keine Position, keine Größe, keine Höhe.
8. **Türmaße:** Türen haben Lage (`kacheln`) und Artbeschreibung, aber keine Breite, Höhe oder Tiefe.
9. **Material:** Alle 7 Räume haben `boden` = `stone` (`raeume.json:20` für den Thekensaal). Eine nähere Materialangabe fehlt. „Sandstein“ kommt nur bei den Stufen vor.
10. **Skelett und Gelenke:** Kein Eintrag (Treffer: 0 für „Skelett“, 0 für „Gelenk“). Bewegung liegt nur als Freitext vor, z. B. `figuren.json:103` (idleAnimation von Ahmet).
11. **Kleidung, Stoff:** Nur Freitext in `outfit`/`baseOutfit`, keine Stoff- oder Physikparameter für das Nachschwingen.
12. **Gegenstände:** Keine Abmessungen. Die Beschreibungen sind Freitext (`gegenstaende.json`, Feld `beschreibung`).
13. **Lichtquellen:** `licht_maske` hat keine Zeiten `an` (`raeume.json:1112–1121`). `licht_maske` und `licht_stirnlampe` haben keinen Raumbezug, weil nur ein Träger angegeben ist. Bei `licht_serkan` steht der Raum nur im Hinweistext. `flackern` fehlt bei 6 von 10 Lichtquellen (Liste in Abschnitt 2).
14. **Windfang:** Keine Einrichtungseinträge (Zählung 0). Ausstattung ist nur als Namen in `features` genannt (`raeume.json:138`).
15. **Detektiv-Block:** Felder `name`, `age` und `geschlecht` fehlen. Stattdessen stehen `title` und `selectableGenders` (`figuren.json:4–40`).
16. **Tatnacht-Positionen:** Nicht in diesem Auszug. Die Quelle verweist auf die Tatmatrix-Dateien (`figuren.json:3`), die nicht Teil des Auftrags sind.

