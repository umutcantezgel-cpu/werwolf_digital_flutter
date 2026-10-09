# P0-KUND-04 · Kanon-Bildregeln

Commit: `c54fe9c` (HEAD, nicht neu committet, nichts gepusht). Stand: nur gelesen, geändert wurde ausschließlich diese Datei.

Alle Pfade relativ zu `/home/user/werwolf_digital_flutter/`. Abkürzungen (Quellenschlüssel):

| Kürzel | Datei |
|---|---|
| K1 | `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md` |
| K3 | `krimidinner/spuk-im-gewoelbe/10_kanon/K3-HINWEISE.md` (Grundnetz, H-01 bis HW-52) |
| K3-P1, K3-P2, K3-P3 | `krimidinner/spuk-im-gewoelbe/10_kanon/K3-HINWEISE-P1.md` (bzw. P2, P3) |
| K8 | `krimidinner/spuk-im-gewoelbe/10_kanon/K8-STILBLATT.md` (M-17 bis M-23 gelesen) |
| K9 | `krimidinner/spuk-im-gewoelbe/10_kanon/K9-LOOKBIBEL.md` |
| REQ | `krimidinner/spuk-im-gewoelbe/20_vorlagen/REQ-RAUM.md` |
| AP | `nachtlauf/kanon/ANPASSUNG.md` |
| NK | `nachtlauf/KANON.md` |
| BW | `packages/burgstadt_core/lib/src/welt/burg.dart` |
| OS | `packages/burgstadt_core/lib/src/welt/oberstadt.dart` |
| SG | `packages/burgstadt_core/lib/src/welt/stadtgenerator.dart` |
| FB | `packages/burgstadt_core/lib/src/welt/FORMAT-BEREICHE.md` |
| FO | `packages/burgstadt_core/data/innenraeume/fallorte.json` (Zeile = Legende-Schlüssel) |
| HA | `packages/burgstadt_core/data/innenraeume/haeuser.json` (Zeile = Legende-Schlüssel) |
| T-HA, T-FO, T-KA | `packages/burgstadt_core/test/innenraeume_haeuser_test.dart`, `innenraeume_fallorte_test.dart`, `kanon_test.dart` |
| KERN, STIL, ENT, PLAN | `hd/KERN.md`, `hd/STILBLATT.md`, `hd/ENTSCHEIDUNGSLOG.md`, `hd/PLAN.md` |

Die Zeile eines Bereichs ist die Zeile seiner `id`; die Zeile eines Gegenstands ist die Zeile seines Legende-Schlüssels (z. B. `FO:83` = Schlüssel `S`).

---

## 0. Zählwerte

- Raumarten im Code: **26** (davon 5 Burg-Innen, 2 Burg-Außen, 12 Fall-Orte, 5 Wohnhaus-Typen, 1 Gangnetz, 1 Oberstadt). Dazu 3 Orte nur im Kanon ohne Bereich (Burgweg, Silberhau, Freibad). Räume gesamt: 51.
- Verbote: **18 global** (Projekt-Liste mit 15 Gegenständen, dazu Uhren-Zeiger, Laternen/Strom und Grünregel) plus **1 Kanon-Negativgruppe** (K9 §6 und Testwortlisten) plus **20 ortsgebundene Gruppen** (Abschnitt 4c).
- Bestandslichter (Ausnahmen): **86** Legende-Einträge mit Licht (Burg 4, Fall-Orte 21, Wohnhäuser 61).
- Offene Konflikte und Fragen: **16** (Abschnitt 7).

---

## 1. Raumarten

| Nr | Raumart | Bereiche / Vorlagen (Datei:Zeile) | Markierung | Räume |
|---|---|---|---|---|
| 1 | Kamin-Gewölbe (`gewoelbe`) | BW:20 (id BW:21) | Burg · Hinweisraum (BS-08 Nische, BS-12 Fotowand) | 1 |
| 2 | Speisekammer (`speisekammer`) | BW:54 (id BW:55) | Burg · Tatort | 1 |
| 3 | Turm-Fuß (`turmfuss`) | BW:84 (id BW:85) | Burg · Wendeltreppenturm · Hinweisraum (BS-04, BS-06) | 1 |
| 4 | Erster Turmabsatz (`absatz`) | BW:110 (id BW:111) | Burg · Wendeltreppenturm · Rüstung Kunibert | 1 |
| 5 | Hofebene des Turms (`hofebene`) | BW:130 (id BW:131) | Burg · Wendeltreppenturm · Schauvitrine | 1 |
| 6 | Wehrgang (`wehrgang`, innen false) | BW:153 (id BW:154) | Burg · Außen · Zinne 3 (Handyempfang) | 1 |
| 7 | Burghof (`hof`, innen false) | BW:174 (id BW:175) | Burg · Außen · Raureif, Geleucht | 1 |
| 8 | Uhrwerk-Kammer (`innen-uhrturm`) | FO:5 (Station FO:83) | Fall-Ort ORT-01 | 1 |
| 9 | Stadtmuseum (`innen-museum`) | FO:93 (Station FO:150) | Fall-Ort ORT-02 | 1 |
| 10 | Pension „Zum Uhrturm“ (`innen-pension`) | FO:169 (Station FO:258) | Fall-Ort ORT-03 | 1 |
| 11 | Schreinerei (`innen-schreinerei`) | FO:268 (Station FO:330) | Fall-Ort ORT-04 | 1 |
| 12 | Kostümfundus (`innen-fundus`) | FO:340 (Station FO:388) | Fall-Ort ORT-05 | 1 |
| 13 | Stromhaus (`innen-stromhaus`) | FO:414 (Station FO:453) | Fall-Ort ORT-06 | 1 |
| 14 | Teestube „Zur Laterne“ (`innen-teestube`) | FO:488 (Station FO:568) | Fall-Ort ORT-07 | 1 |
| 15 | Bäckerei (`innen-baeckerei`) | FO:578 (Station FO:649) | Fall-Ort ORT-08 | 1 |
| 16 | Rathaus (`innen-rathaus`) | FO:659 (Station FO:743) | Fall-Ort ORT-09 | 1 |
| 17 | Bibliothek mit Archiv (`innen-bibliothek`) | FO:753 (Station FO:828) | Fall-Ort ORT-10 | 1 |
| 18 | Apotheke (`innen-apotheke`) | FO:838 (Station FO:893) | Fall-Ort ORT-11 | 1 |
| 19 | Kirchenburg (`innen-kirche`) | FO:903 (Station FO:982) | Fall-Ort ORT-12 | 1 |
| 20 | Wohnstube (Vorlagentyp `wohnstube`) | HA:5, 98, 178, 259, 345, 433, 526, 605, 684, 771 | Wohnhaus · nur Farbe | 10 |
| 21 | Werkstatt (`werkstatt`) | HA:857, 952, 1038, 1133, 1221, 1307 | Werkstatt · nur Farbe | 6 |
| 22 | Laden (`laden`) | HA:1386, 1474, 1555, 1636, 1722, 1803 | Laden · nur Farbe | 6 |
| 23 | Speicher (`speicher`) | HA:1889, 1972, 2044, 2121 | Speicher · nur Farbe | 4 |
| 24 | Zunftstube (`zunftstube`) | HA:2209, 2301, 2391, 2481 | Zunfthaus · nur Farbe | 4 |
| 25 | Gewölbegänge unter der Stadt (`gaenge`) | SG:465-467 | Gangnetz · nur Farbe | 1 |
| 26 | Oberstadt: Marktplatz bzw. Gassen (`stadt`) | OS:98 (Marktplatz); SG:484-486 (Oberstadt Schartenfels) | Oberstadt · Außen · nur Farbe | 1 |

Nur im Kanon, kein Bereich im Code: Burgweg (K1:27, Zufahrt, außerhalb), Silberhau (K1:27; AP:77, „nur Farbe“), Freibad (AP:77, „nur Rollenwissen und Lösung“).

Hinweis zu Zeile 26: Im Code gibt es zwei Varianten. `OS` (Marktplatz der Oberstadt, Fallback in `baueBurg`, BW:212-213) und `SG` (generierte Oberstadt, `plan.stadt`, übernommen in `baueWelt` bei BW:227). Beide sind eine Raumart.

Hinweis zu Zeile 20 bis 24: Die Vorlagentypen ergeben sich aus `SG:290-310` (`RegExp('^innen-([a-z]+)')`; `werkstatt`/`schreinerei` → Werkstatt; `laden`/`bäckerei`/`apotheke`/`teestube` → Laden; `speicher`/`archiv`/`schaltraum`/`uhrwerk` → Speicher; `amtsstube`/`bibliothek`/`museum`/`kirche`/`fundus`/`pension` → Zunftstube; sonst Wohnstube). Die Fall-Orte werden über `ortVorlage` (SG:277-288) zugewiesen; Häuser nahe am Marktplatz kommen zuerst (SG:266).

---

## 2. Hinweis-Gegenstände und Ortsbindungen

Lösungsrelevant oder Hinweis-Träger. Nicht lösungsrelevant sind nur die mit „nein“ markierten Zeilen. Stadt-Hinweise (AP) sind Farbe, entlastend oder bestätigend, aber keine notwendigen Schlussfolgerungen (AP:9).

| Gegenstand | Hinweis/lösungsrelevant? | gebunden an Ort | Quelle Datei:Zeile |
|---|---|---|---|
| Eiserner Kerzenständer mit drei Kerzen (Tatwaffe) | ja, BS-09, H-21 | Speisekammer. Widerspruch: „auf dem Fass“ (K1:21, K1:110) gegen „am Boden“ (K1:204, BW:77) | K1:21, K1:110, K1:191, K1:204; K3:41; BW:77 |
| Blechdose des Burgwarts (Taler-Dose) | ja, BS-05, H-20 | Speisekammer, Regal rechts neben der Eisentür (BW:74 Station BS-05) | K1:21, K1:187, K1:200; K3:40 |
| Ausbeutetaler (Silberhauer, im Kanon ersetzt durch Schartenfelser) | ja, Tatobjekt | Schauvitrine Hofebene (BW:149 Station „Vitrine“), danach Blechdose | K1:25, K1:187; BW:149; AP:12-13 (ERSETZE-01/02) |
| Schlüsselbund mit Karabiner | ja, BS-07, H-03, PF-2 | Gürtel des Burgwarts (K1:24); ab 23:58:50 im Helm der Rüstung Kunibert (K1:139, K1:202) | K1:24, K1:139, K1:175, K1:202; K3:23 |
| Rüstung „Kunibert“ (Panzerhandschuh, Visier) | ja, BS-02, H-27 | Erster Turmabsatz (BW:127 Station „Kunibert“) | K1:22, K1:184; K3:47; BW:127 |
| Bluetooth-Box (Track „Geisterstunde“) | ja, BS-08 | Kamin-Gewölbe, Nische neben der Eichentür (BW:50 Station BS-08) | K1:28, K1:190, K1:203; BW:50 |
| Sicherungskasten mit Hauptschalter und Zahlenschloss | ja, BS-04 | Turm-Fuß (BW:105; Station BS-04 BW:106) | K1:22, K1:186, K1:199; K3:44 |
| Code-Zettel (zwei Handschriften) | ja, BS-04, H-07, H-24 | Turm-Fuß, unter dem Sicherungskasten | K1:186, K1:199; K3:27, K3:44 |
| Stablampe „HODŽIĆ VT · 3“ | ja, BS-03, H-28 | Speisekammer, unter dem Regal (BW:76) | K1:185, K1:198; K3:48 |
| Weißes Bettlaken mit Wäschezeichen „Schartenfels 7“ | ja, BS-06, BS-02, H-13 | Holztruhe am Turm-Fuß (K1:201); Streifen am Panzerhandschuh (K1:184); Herkunft Wäschekorb Hofebene (K1:93) | K1:93, K1:184, K1:188, K1:201; K3:33 |
| Holztruhe (alte Holztruhe, Versteck des Lakens) | ja, BS-06 | Turm-Fuß (K1:22, K1:27; BW:107 Station BS-06) | K1:22, K1:27, K1:188; BW:107 |
| Wäschekorb neben der Toilette | ja, Quelle des Lakens (Z-2140) | Hofebene. Im Code kein Korb-Objekt (BW:130-152) | K1:93 |
| Schadenszettel des Burgwarts | ja, BS-10, H-23 | Westentasche des Burgwarts | K1:192, K1:205; K3:43 |
| Punschkessel (alkoholfrei) | ja als Sachschaden-Ding (STRANG-d); Lichtquelle | Kamin-Gewölbe (K1:27, K1:28; BW:48) | K1:27, K1:28, K1:72, K1:85; BW:48 |
| Heißluftpistole | Tatumstand (KOMIK-4), kein Hinweis-Station | Kamin-Gewölbe | K1:28, K1:78; K3-P1:98 |
| Wanderstiefel (Merle, Jonas) und Sohlenkarten | ja, BS-13, H-15 | Figuren, keine Raumbindung; Sohlenkarten bei der Spielleitung | K1:28, K1:84, K1:195, K1:208; K3:35 |
| Sofortbild der Burgführung (21:20) | ja, BS-12, H-18 | Fotowand im Kamin-Gewölbe (BW:51 Station BS-12) | K1:194, K1:207; K3:38 |
| Raureif auf dem Hof (Stiefelspuren) | ja, BS-11, H-02 | Burghof (BW:205 Station BS-11) | K1:193, K1:206; K3:22 |
| Wachsspritzer mit Teilabdruck | ja, BS-01, H-06 | Speisekammer, neben der Eisentür (BW:75 Station BS-01) | K1:183, K1:196; K3:26 |
| Eichentür mit Verkeil-Balken (Staub, Spinnweben am Balken) | ja, H-04, H-05, HW-04 | Eichentür der Speisekammer (BW:73) bzw. Gewölbe-Seite (BW:45); nur von innen lösbar | K3:24, K3:25, K3:55; K3-P1:90 |
| Kühlpack (Tiefkühlerbsen) und Wolldecke | nein, Gegenstand der Szene | Bank am Kamin (K1:155); Tiefkühltruhe Speisekammer (BW:80) | K1:55, K1:155; BW:80 |
| Geburtstagstorte | nein, Gegenstand der Szene | Speisekammer-Regal (BW:81) | K1:99; BW:81 |
| Strick: grüne Strickjacke (Merle), grüner Strickpullover (Jonas), gestrickter Ärmel | ja, H-14, HW-14 | Figuren. Wolle und Strick nicht als Deko | K3:34, K3:65; K9:64 |
| Kostenvoranschlag „sechshundert, höchstens“ (Eichentür) | Stadt-Hinweis, entlastend | Schreinerei, Schaufenster (FO:330 Station ORT-04) | AP:139-140 |
| Schaltplan an der Wand, Schalttafel, Ersatzsicherungs-Zettel | Stadt-Hinweis, bestätigend | Stromhaus (FO:446 Station ORT-06; AP:151-154) | FO:446-453; AP:151-154 |
| Katalogkarte (Taler als Leihgabe) | Stadt-Hinweis, Farbe | Stadtmuseum (Bereich FO:93; Station FO:150) | AP:127-128 |
| Silbererz unter Glas, Schild „Glück auf!“ | Stadt-Hinweis, Farbe | Stadtmuseum | AP:129-130 |
| Wäschebuch der Pension (blauer Stempel) | Stadt-Hinweis, Farbe | Pension (Station FO:258) | AP:133-134 |
| Uhrturm-Inschrift „Ich zähle die Stunden, nicht die Schuld.“ | Stadt-Hinweis, Farbe | Uhrwerk-Kammer, Marktplatz (FO:83 Station ORT-01; OS:74) | AP:121-122 |
| Thermoskanne, Zählen der Schläge | Stadt-Hinweis, Farbe | Marktplatz (ORT-01) | AP:123-124 |
| Kanne Kräutertee | Stadt-Hinweis, Farbe | Teestube (FO:568 Station ORT-07) | AP:159-160 |
| Tafel mit allen Bürgermeistern, Spruch „Recht ist Recht“ | Stadt-Hinweis, Farbe | Rathaus (FO:743 Station ORT-09) | AP:169-172 |
| Chronik der Oberstadt (Torordnung), Pergament-Inschriften | Stadt-Hinweis, Farbe | Bibliothek (FO:828 Station ORT-10) | AP:175-178 |
| Kühlpacks und Pflaster (Apotheke) | Stadt-Hinweis, Farbe | Apotheke (FO:893 Station ORT-11) | AP:181-182 |
| Marzipan-Kunibert auf der Geburtstagstorte (Muster M-17) | Muster, „Keine Spur“ | Speisekammer-Station (K8:229, K8:234) | K8:227-235 |
| Papierstreifen mit Stiefelspuren als Raureif (Muster M-18) | Nachbildung von BS-11 | Station Hof (K8:238, K8:240) | K8:237-242 |

---

## 3. Positivliste je Raumart

### 3.1 Regeln

- **Entscheidungsregel:** In Hinweis-Räumen (Burg, Fall-Orte) ist eine Kategorie nur dann erlaubt, wenn sie nicht mit einem Hinweis verwechselbar ist. Im Zweifel gilt „verboten“. Dies ist ein Vorsichtsprinzip, das ich aus K3/K1 abgeleitet habe; der Projektwortlaut sagt es nicht ausdrücklich (KERN:184 nennt nur „nie Ort eines Hinweises“).
- **Modus „nur Farbe“:** Wohnhäuser, Gangnetz und Oberstadt (KERN:184, „nie Ort eines Hinweises oder eines lösungsrelevanten Gegenstands“).
- **Fall-Orte:** Sie tragen nach AP Stadt-Hinweise (Farbe, entlastend, bestätigend). Sie werden deshalb wie Hinweis-Räume behandelt. Siehe Konflikt 3.
- **Global gilt in jedem Raum:** Kerzenleuchter nur im Kamin-Gewölbe (KERN:192, ENT:43); Uhren nur ohne Zeiger (KERN:188, ENT:47); keine grüne Deko (STIL:29, ENT:31).
- **Deko ist reine Darstellung:** ohne Text, ohne Lichtfeld, ohne Blockade (STIL:65). Anker nur an Wand, Decke, auf blockierenden Möbeln oder flach am Boden (höchstens 0,02 m), nie auf Tür-, Stations- oder Markenkacheln (STIL:66).

Legende der Zellen: **E** erlaubt · **E+** erlaubt mit Auflage · **V** verboten.

Auflagen für E+:
- **W** (wandbild): keine Schrift, kein Foto, keine Tafel und kein Motiv eines Hinweises (K9:49 „no text“; K1:194; AP:121, 169, 177).
- **U** (wanduhr): nur Zifferblatt ohne Zeiger (KERN:188; ENT:47).
- **Vh** (vorhang): nie weiß oder aus Leinen (Laken-Verbot, KERN:186).
- **Te** (teppich): flach am Boden, nie auf Stations- oder Markenkacheln (STIL:66).
- **G** (geschirr): kein Becher- oder Dosen-Stapel an Stationen (K1:21, K1:155).
- **K** (kistenstapel): keine Truhen-Anmutung, nicht an Türen oder Stationen (K1:22, K1:188).
- **Sp** (spinnweben): nie an Türen, Abgängen oder Stationen, weil „unberührte“ Spinnweben ein Hinweis sind (K3:24, K3:55).
- **Db** (deckenbalken): nur Architektur, kein Verschluss-Balken an einer Tür (K3-P1:90).
- **Ko** (korb) und **Kr** (krug): kein Wäschekorb-Bezug (K1:93), kein Punsch- oder Kannen-Bezug (K1:28, AP:159).
- **Wk** (wandkandelaber): nur im Kamin-Gewölbe (KERN:192; ENT:43).

### 3.2 Matrix

Spalten: W wandbild · U wanduhr (ohne Zeiger) · R wandregal · S spiegel · Vh vorhang · Te teppich · G geschirr · B buecherstapel · Z werkzeugwand · K kistenstapel · Sp spinnweben · Db deckenbalken · Ko korb · Kr krug · Wk wandkandelaber.

| Nr | Raumart | Modus | W | U | R | S | Vh | Te | G | B | Z | K | Sp | Db | Ko | Kr | Wk |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Kamin-Gewölbe | Burg · Hinweisraum | E+ | V | V | V | V | V | E+ | V | V | V | V | V | V | V | E |
| 2 | Speisekammer | Burg · Tatort | V | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 3 | Turm-Fuß | Burg · Hinweisraum | E+ | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 4 | Erster Turmabsatz | Burg · Hinweisraum | V | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 5 | Hofebene des Turms | Burg · Hinweisraum | E+ | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 6 | Wehrgang | Burg · Außen | V | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 7 | Burghof | Burg · Außen | V | V | V | V | V | V | V | V | V | V | V | V | V | V | V |
| 8 | Uhrwerk-Kammer | Fall-Ort ORT-01 | E+ | V | E | E | E+ | E+ | E | E | E+ | E+ | V | E+ | E | E | V |
| 9 | Stadtmuseum | Fall-Ort ORT-02 | E+ | E+ | E | E | E+ | E+ | E | V | V | E+ | V | E+ | E | E | V |
| 10 | Pension | Fall-Ort ORT-03 | E+ | V | E | E | V | E+ | E | V | V | E+ | V | E+ | V | E | V |
| 11 | Schreinerei | Fall-Ort ORT-04 | E+ | E+ | E | E | E+ | E+ | E | E | E | E+ | V | E+ | E | E | V |
| 12 | Kostümfundus | Fall-Ort ORT-05 | E+ | E+ | E | E | E+ | E+ | E | E | V | V | V | E+ | E | E | V |
| 13 | Stromhaus | Fall-Ort ORT-06 | E+ | E+ | E | E | E+ | E+ | E | E | V | V | V | E+ | E | E | V |
| 14 | Teestube | Fall-Ort ORT-07 | E+ | E+ | E | E | E+ | E+ | E+ | E | V | E+ | V | E+ | E+ | V | V |
| 15 | Bäckerei | Fall-Ort ORT-08 | E+ | E+ | E | E | E+ | E+ | E | E | V | E+ | V | E+ | E | E | V |
| 16 | Rathaus | Fall-Ort ORT-09 | E+ | E+ | E | E | E+ | E+ | E | E | V | E+ | V | E+ | E | E | V |
| 17 | Bibliothek mit Archiv | Fall-Ort ORT-10 | E+ | E+ | E | E | E+ | E+ | E | V | V | E+ | V | E+ | E | E | V |
| 18 | Apotheke | Fall-Ort ORT-11 | E+ | E+ | E | E | E+ | E+ | E | E | V | E+ | V | E+ | E | E | V |
| 19 | Kirchenburg | Fall-Ort ORT-12 | E+ | E+ | E | E | E+ | E+ | E | E | V | E+ | V | E+ | E | E | V |
| 20 | Wohnstube (10) | nur Farbe | E | E+ | E | E | E+ | E | E | E | V | E+ | E+ | E | E | E | V |
| 21 | Werkstatt (6) | nur Farbe | E | E+ | E | E | E+ | E | E | E | E | E | E+ | E | E | E | V |
| 22 | Laden (6) | nur Farbe | E | E+ | E | E | E+ | E | E | E | V | E | E+ | E | E | E | V |
| 23 | Speicher (4) | nur Farbe | E | E+ | E | E | E+ | E | E | E | E | E | E+ | E | E | E | V |
| 24 | Zunftstube (4) | nur Farbe | E | E+ | E | E | E+ | E | E | E | V | E+ | E+ | E | E | E | V |
| 25 | Gewölbegänge (Gangnetz) | nur Farbe | E+ | V | E+ | E+ | E+ | E+ | V | V | V | E+ | E+ | E+ | E+ | E+ | V |
| 26 | Oberstadt (Marktplatz, Gassen) | nur Farbe, außen | E+ | V | V | V | V | V | V | V | V | E+ | V | V | E+ | E+ | V |

### 3.3 Begründungen je Raumart (nur die Verbote und Auflagen mit Quelle)

**Burg (Zeilen 1 bis 7).** Die Burg ist Hinweis-Raum. Erlaubt ist nur, was der Kanon dort belegt oder was keinem Hinweis gleicht.
- **1 Kamin-Gewölbe:** W E+ (keine Schrift, Fotowand BS-12 bleibt das einzige Foto, BW:51, K1:194). G E+ (Festtafel mit Keramikbechern, K9:51, K9:55). Wk E (einziger Ort für Wandkandelaber, KERN:192). Verboten: Krug, weil der Punschkessel dort liegt (K1:28, BW:48). Korb, weil Wäschekorb-Anmutung (K1:93). Spinnweben, weil die Eichentür im Gewölbe liegt (BW:45, K3:24). Vorhang, Teppich und Truhen-Anmutung ohne Kanon-Beleg.
- **2 Speisekammer:** Alles verboten. Tatort mit Stationen BS-01, BS-03, BS-05, BS-09 (BW:74 bis 77). Konserven und Dose (K1:21), Spinnweben und Balken (K3:24), Teppich auf Stationskacheln (STIL:66).
- **3 Turm-Fuß:** W E+ als Vorschlag für eine Mauerfläche ohne Motiv, nicht am Sicherungskasten (BW:105) und nicht an der Holztruhe (BW:107). Sonst verboten: Kasten- und Truhen-Anmutung (K1:22), Verkeil-Balken (K3-P1:90).
- **4 Erster Turmabsatz:** Alles verboten. Station Rüstung Kunibert (BW:127); Stoffrest am Panzerhandschuh (K1:184); Visier und Helm (K1:139).
- **5 Hofebene:** W E+ als Vorschlag, nicht bei Vitrine (BW:149) und Toilette (BW:150). Korb verboten (Wäschekorb, K1:93).
- **6 Wehrgang, 7 Burghof:** Außenbereiche ohne Kanon-Beleg für Deko. Zinne 3 (BW:171) und Raureif (BW:205) sind Hinweise.

**Fall-Orte (Zeilen 8 bis 19).** Standard ist „erlaubt mit Auflage“. Verboten ist, was den Stadt-Hinweis des Fall-Ortes nachbildet oder verwechselbar macht.
- **8 Uhrwerk-Kammer:** U verboten. Der Uhrturm ist die einzige Zeitquelle (KERN:188, AP:52). Sp verboten (H-04-Logik). Wk verboten (nur Kamin-Gewölbe).
- **9 Stadtmuseum:** B verboten, weil die Katalogkarte ein Hinweis ist (AP:127-128). Z verboten (thematisch). Sp und Wk verboten.
- **10 Pension:** U verboten, weil H-S06 den Blick auf den Uhrturm mit „Zeiger zählen“ beschreibt (AP:135). Vh verboten, weil weiße Bettwäsche wie ein Laken wirkt (K1:188, AP:133-134). B verboten (Wäschebuch, AP:133). Ko verboten (Wäschekorb, K1:93). Z und Sp verboten.
- **11 Schreinerei:** Z erlaubt (Hobelbank Bestand, FO:300-309). Sp verboten. Der Kostenvoranschlag bleibt am Schaufenster (AP:139), er wird nicht nachgebildet.
- **12 Kostümfundus:** K verboten, weil die bemalte Truhe Station ORT-05 ist (FO:381-388). Vh E+ nur dunkel (H-S09, AP:145-146). Z und Sp verboten.
- **13 Stromhaus:** Z und K verboten (Sicherungs- und Ersatzteil-Anmutung, AP:151-153). W E+ ohne Schaltplan-Motiv (FO:446). Sp verboten.
- **14 Teestube:** Kr verboten (Kanne Kräutertee, AP:159-160). G E+ nur als Tassen, nicht als Teekessel-Nachbildung (FO:531). Ko E+.
- **15 Bäckerei, 18 Apotheke, 19 Kirchenburg:** Z verboten. Sp verboten. Wk verboten (nur Kamin-Gewölbe, KERN:192). Apotheke: Kühlpack-Anmutung (AP:181) beachten.
- **16 Rathaus:** W E+ ohne Bürgermeister-Tafel-Motiv (AP:169). Z verboten.
- **17 Bibliothek mit Archiv:** B verboten (Chronik, AP:175; Pergament, AP:177). W E+ ohne Schrift.

**Wohnhaus, Werkstatt, Laden, Speicher, Zunftstube (Zeilen 20 bis 24, nur Farbe).** Standard ist erlaubt.
- **U (E+, nur ohne Zeiger):** Werkstatt-4 (Uhrmacherstube) hat Standuhr, Uhrenvitrine und Uhrenregal (HA:1176, 1183, 1190). Ob diese Zeiger haben, steht in den Daten nicht. Offen, siehe Konflikt 5.
- **Vh (E+):** nie weiß oder aus Leinen (KERN:186).
- **Z verboten** in Wohnstube, Laden und Zunftstube (kein Themenbezug). In Werkstatt und Speicher erlaubt.
- **K (E+):** in Wohnstube und Zunftstube, wegen der Truhen (HA:88, 168, 226, 296, 423, 595, 674, 738, 847, 2275, 2455, 2554). Konflikt 4.
- **Sp (E+):** nicht an Türen oder Abgängen (K3:24, K3:55).
- **Wk verboten** in allen Räumen außer dem Kamin-Gewölbe. Die Kamine in Zunftstube-2 und -4 (HA:2356, 2538) sind Bestand, ändern aber nichts daran (KERN:192).

**Gangnetz (Zeile 25).** Nur Farbe. Verboten sind U (keine Uhr im Gang, Zeitquelle nur der Uhrturm), G, B und Z (kein Bezug), Wk. Sp und Te nicht am Kellerabgang (SG:457-463) und nicht an der Treppe (SG:462).

**Oberstadt (Zeile 26).** Nur Farbe, außen. W E+ als Fassadenmalerei ohne Schrift (K9:49). K, Ko und Kr E+ als Marktware, ohne Kanne- oder Punsch-Bezug (AP:159). Verboten sind U (Uhrturm ist allein Zeitquelle), R, S, Vh, Te, G, B, Z, Sp, Db und Wk.

### 3.4 Verwechslungsrisiken (Positivliste gegen Hinweise)

| Kategorie | verwechselbar mit | Quelle |
|---|---|---|
| krug | Punschkessel (Kamin-Gewölbe); Kanne Kräutertee (Teestube) | K1:28; BW:48; AP:159 |
| buecherstapel | Chronik (Bibliothek), Katalogkarte (Museum), Wäschebuch (Pension), Pergament | AP:127, 133, 175, 177 |
| geschirr | Blechdose und Konserven (Speisekammer); Becher mit Punsch | K1:21; K1:155; K9:51 |
| kistenstapel | Holztruhe (Versteck des Lakens); Ersatzsicherungs-Lager | K1:22; K1:188; AP:153 |
| spinnweben | „unberührt“-Hinweis am Balken der Eichentür | K3:24; K3:55 |
| deckenbalken | Verkeil-Balken der Eichentür | K3-P1:90 |
| korb | Wäschekorb Hofebene (Laken-Quelle) | K1:93 |
| vorhang | Laken und Leinen (Projekt-Verbot); Bettwäsche | KERN:186; K1:188 |
| teppich | Wachsspritzer und Stationsboden | K1:183; STIL:66 |
| wandbild | Fotowand und Sofortbild; Tafeln mit Inschrift | K1:194; BW:51; AP:121, 169, 177 |
| wanduhr | Zifferblatt des Uhrturms (einzige Zeitquelle) | KERN:188; AP:135 |
| wandkandelaber | Tatwaffen-Kerzenständer (freistehend) | K1:28, K1:191; ENT:43 |
| werkzeugwand | Heißluftpistole (Kamin); Sicherungswerkzeug (Stromhaus) | K1:28, K1:78; AP:151-153 |
| strick- und garn-Deko (nicht auf der Liste) | grüne Strickjacke und Strickpullover | K3:34; K3:65 |

---

## 4. Verbotsliste

### 4a Global (Projekt-Liste, alle Räume)

| Nr | Verbot als neue Ausstattung | Quelle |
|---|---|---|
| 1 | Taler | KERN:186 |
| 2 | Schlüssel | KERN:186 |
| 3 | Schlüsselbund | KERN:186 |
| 4 | Kerzenständer (freistehend) | KERN:186; K1:21 (Tatwaffe) |
| 5 | Kerzenleuchter außerhalb des Kamin-Gewölbes | KERN:186, KERN:192; ENT:43 |
| 6 | Lampe | KERN:186; T-FO:38-40 |
| 7 | Taschen- oder Stablampe | KERN:186; K1:185; T-FO:39 |
| 8 | Batterie | KERN:186; T-HA:27-35 |
| 9 | Laken | KERN:186; K1:188 |
| 10 | Leinen | KERN:186 |
| 11 | Zettel | KERN:186; K1:186 |
| 12 | Wanderstiefel | KERN:186; K1:84 |
| 13 | Ruß | KERN:186; K1:78 |
| 14 | neue Rüstungen | KERN:187 |
| 15 | neue Lichtquellen | KERN:187; KERN:57 |
| 16 | Uhren mit Zeiger; nur der Uhrturm zeigt die Spielzeit | KERN:188; ENT:47 |
| 17 | elektrisches Licht, Laternen dunkel | KERN:100; AP:49; FB:36 |
| 18 | grüne Deko (Grünregel) | STIL:28-29; ENT:31 |

### 4b Kanon-Negativgruppe (Text und Figuren)

- Bildprompts ohne Text, Waffen, Alkohol, Wein, Bier, Gläser mit Getränk, Becher, Krüge, Flaschen, Zigaretten, Totenköpfe, Blut, Wunden (K9:49).
- Testwortliste der Leitplanken: „Wein … Clan“ und die Gegenstandsnamen Taler, Schlüsselbund, Laken, Kerzenständer, Zettel, Stablampe, Batterie, Gespenst sowie die Figurennamen Merle, Jonas, Adnan, Rojda (T-HA:27-35; T-FO:38-40).
- Punsch ist überall alkoholfrei (T-KA:275-281; K9:51).

### 4c Ortsgebunden (nicht als Deko, nicht als Nachbildung)

| Nr | Verbot | gebunden an | Quelle |
|---|---|---|---|
| 1 | Punschkessel oder Kessel-Nachbildung | nur Kamin-Gewölbe | K1:27-28; BW:48; KERN:183 |
| 2 | Holztruhe oder Truhen-Nachbildung | nur Turm-Fuß. Konflikt 4 | K1:22, K1:27; BW:107; KERN:183 |
| 3 | Blechdose oder Konservendose (Taler-Dose) | Speisekammer, Regal neben Eisentür | K1:21, K1:200; K3:40; BW:74 |
| 4 | Taler, Münze oder Taler-Sockel in der Vitrine | Schauvitrine Hofebene. Die Vitrine bleibt ohne Sockel | K1:25; KERN:190; BW:149 |
| 5 | Kunibert-Nachbildung, Panzerhandschuh, Helm | Erster Turmabsatz | K1:22; KERN:191; K3:47; BW:127 |
| 6 | Lautsprecher oder Bluetooth-Box-Nachbildung | Kamin-Nische neben der Eichentür | K1:28, K1:203; BW:50 |
| 7 | Sicherungskasten, Zahlenschloss oder Code-Zettel-Nachbildung | Turm-Fuß | K1:22, K1:199; K3:44; BW:105-106 |
| 8 | Stablampe-Nachbildung und Batterie-Anmutung | Speisekammer, unter dem Regal | K1:198; K3:48; BW:76 |
| 9 | Laken oder Stoff mit Wäschezeichen „Schartenfels 7“; Wäschekorb | Hofebene, Turm-Fuß | K1:93, K1:184, K1:201; BW:107 |
| 10 | Kerzenständer-Nachbildung (Tatwaffe) | Speisekammer. Konflikt 8 | K1:21, K1:191, K1:204; BW:77 |
| 11 | Wachsspritzer oder Stollen-Abdruck | Speisekammer, neben der Eisentür | K1:183, K1:196; K3:26; BW:75 |
| 12 | Fotowand- oder Sofortbild-Nachbildung | Kamin-Gewölbe | K1:194, K1:207; K3:38; BW:51 |
| 13 | Raureif- oder Stiefelspuren-Imitat | Burghof. Konflikt 12 | K1:193, K1:206; BW:205; K8:240 |
| 14 | Spinnweben und Verkeil-Balken an einer Eichentür | Speisekammer und Gewölbe-Eichentür | K3:24, K3:55; K3-P1:90; BW:45, BW:73 |
| 15 | Heißluftpistole oder Werkzeug-Nachbildung | Kamin-Gewölbe | K1:28, K1:78; K3-P1:98 |
| 16 | Wanderstiefel- oder Sohlen-Nachbildung | Figuren, keine Raumbindung | K1:84, K1:195; K3:35 |
| 17 | Katalogkarte (Taler-Leihgabe) | Stadtmuseum | AP:127-128 |
| 18 | Wäschebuch, Chronik, Pergament-Inschriften, Tafel der Bürgermeister, Kanne, Schaltplan, Kostenvoranschlag, Kühlpack-Karte | je zugehöriger Fall-Ort | AP:133, 175-178, 169, 159, 151, 139, 181 |
| 19 | Uhrturm-Inschrift und Zifferblatt mit Zeiger | Uhrwerk-Kammer, Marktplatz | AP:121; KERN:188 |
| 20 | Marzipan-Kunibert auf der Torte | Speisekammer. Konflikt 11 | K8:228-234 |

---

## 5. Lichtregel

### 5.1 Regel

- Strom in der Oberstadt ist aus. Kein elektrisches Licht, Laternen sind dunkel (KERN:100; ENT:32; STIL:59).
- Erlaubt sind Kerzenfenster, Öfen, Handylicht, Mond, Notleuchten laut Daten, Lichter von Silberhau im Tal (KERN:101; STIL:60).
- Strom aus steht auch in AP: „Es leuchten nur Kerzen, Handylichter, Notleuchten mit Batterie, das Geleucht im Burghof und der Mond“ (AP:49). Die Ersatzsicherungen passen nicht, der Strom kommt erst am Morgen wieder (AP:51).
- Die Oberstadt hat „keine Straßenlaternen, keine Fenster, kein Licht am Uhrturm“ (AP:49).
- Im Code: Strom ist aus (Kanon STADT-02), Licht nur von Kerzen, Glut, Öfen, Notleuchten und Mond (FB:36).

### 5.2 Ausnahmeliste: Bestandslichter (Datei:Zeile = Legende-Schlüssel)

Die Projektliste nennt nur drei Ausnahmen (Burg-Kamin, Punschkessel, Geleucht; KERN:193). Der Bestand enthält mehr. Die vollständige Liste:

**Burg (BW, 4 Einträge):**
- Kamin `K` BW:47 (warm 0,95; 7 m)
- Punschkessel `P` BW:48 (warm 0,35; 2,5 m)
- Festtafel `F` BW:49 (warm 0,45; 4,5 m)
- Brunnen mit „Geleucht“ `Q` BW:203 (kalt 0,55; 6 m)

**Fall-Orte (FO, 21 Einträge):**
- ORT-01 Uhrwerk: Werkbank mit Kerze FO:65 · Notleuchte FO:74
- ORT-02 Museum: Pult mit Kerze FO:141 · Notleuchte FO:157
- ORT-03 Pension: Empfangstheke mit Kerze FO:205 · Nachttisch mit Kerze FO:228
- ORT-04 Schreinerei: Hobelbank mit Kerze FO:307
- ORT-05 Fundus: Schminktisch mit Kerzen FO:402
- ORT-06 Stromhaus: Notleuchte FO:467 · Tisch mit Kerze FO:476
- ORT-07 Teestube: Kachelofen FO:536 · Tisch mit Kerze FO:552
- ORT-08 Bäckerei: Backofen FO:612
- ORT-09 Rathaus: Ratstisch mit Kerzen FO:702 · Kachelofen FO:725 · Notleuchte FO:734
- ORT-10 Bibliothek: Lesepult mit Kerze FO:810 · Notleuchte FO:819
- ORT-11 Apotheke: Notdienstlampe FO:884 (Konflikt 7)
- ORT-12 Kirche: Gabentisch mit Kerzen FO:957 · Altar mit Kerzen FO:966

**Wohnhäuser (HA, 61 Einträge):**
- Wohnstube-1 (HA:5): Herd HA:35 · Tisch mit Kerze HA:65
- Wohnstube-2 (HA:98): Kachelofen HA:129 · Tisch mit Kerze HA:152
- Wohnstube-3 (HA:178): Nachttisch mit Kerze HA:217 · Notleuchte HA:247
- Wohnstube-4 (HA:259): Tisch mit Kerze HA:310 · Eisenofen HA:333
- Wohnstube-5 (HA:345): Tisch mit Kerze HA:384 · Kamin HA:414
- Wohnstube-6 (HA:433): Kindertisch mit Kerze HA:491 · Notleuchte HA:514
- Wohnstube-7 (HA:526): Nähtisch mit Kerze HA:558
- Wohnstube-8 (HA:605): Kachelofen HA:642 · Tisch mit Kerze HA:651
- Wohnstube-9 (HA:684): Lesepult mit Kerze HA:722 · Kachelofen HA:752
- Wohnstube-10 (HA:771): Kachelofen HA:822 · Tisch mit Kerze HA:831
- Werkstatt-1 (HA:857): Tisch mit Kerze HA:931 · Notleuchte HA:940
- Werkstatt-2 (HA:952): Kanonenofen HA:1017 · Notleuchte HA:1026
- Werkstatt-3 (HA:1038): Arbeitstisch mit Kerze HA:1105 · Notleuchte HA:1121
- Werkstatt-4 (HA:1133): Werktisch mit Kerze HA:1165 · Notleuchte HA:1209
- Werkstatt-5 (HA:1221): Arbeitstisch mit Kerze HA:1265 · Notleuchte HA:1295
- Werkstatt-6 (HA:1307): Schusterbank mit Kerze HA:1337 · Notleuchte HA:1374
- Laden-1 (HA:1386): Ladentheke mit Kerze HA:1439 · Notleuchte HA:1462
- Laden-2 (HA:1474): Verkaufstisch mit Kerze HA:1527 · Notleuchte HA:1543
- Laden-3 (HA:1555): Ladentheke mit Kerze HA:1601 · Notleuchte HA:1624
- Laden-4 (HA:1636): Schneidetisch mit Kerze HA:1673 · Notleuchte HA:1710
- Laden-5 (HA:1722): Verkaufstheke mit Kerze HA:1775 · Notleuchte HA:1791
- Laden-6 (HA:1803): Ladentisch mit Kerze HA:1861 · Notleuchte HA:1877
- Speicher-1 (HA:1889): Kornkasten mit Kerze HA:1923 · Notleuchte HA:1960
- Speicher-2 (HA:1972): Notleuchte HA:2032
- Speicher-3 (HA:2044): Notleuchte HA:2109
- Speicher-4 (HA:2121): Kellertisch mit Kerze HA:2174 · Notleuchte HA:2197
- Zunftstube-1 (HA:2209): Lange Tafel mit Kerzen HA:2257 · Kachelofen HA:2266 · Notleuchte HA:2289
- Zunftstube-2 (HA:2301): Lange Tafel HA:2333 · Kamin HA:2356 · Notleuchte HA:2379
- Zunftstube-3 (HA:2391): Lange Tafel mit Kerzen HA:2437 · Kachelofen HA:2446 · Notleuchte HA:2469
- Zunftstube-4 (HA:2481): Lange Tafel mit Kerzen HA:2529 · Kamin HA:2538 · Notleuchte HA:2568

### 5.3 Lücken der Lichtregel

- **Speisekammer ohne Lichtquelle:** Der Kanon lässt dort drei Kerzen brennen und ausblasen (K1:110, K1:121, K1:183). BW:55-83 hat aber kein Objekt mit Licht. Konflikt 9.
- **Kandelaber fehlt:** K9:55 beschreibt „many candles in iron candelabras“ im Kamin-Gewölbe. BW:27-53 hat kein Kandelaber-Objekt. Konflikt 10.
- **„Tisch mit Kerze“:** Dieser Typ hat lichtWarm 0,3. STIL:60 erlaubt nur „Kerzenfenster“. Ob Tischkerzen darunter fallen, ist offen. Konflikt 6.

---

## 6. Uhrturm und Spielzeit

- **ANPASSUNG STADT-05 (AP:52):** „Der Uhrturm am Marktplatz schlägt die Nacht: Phase 1 beginnt nach dem Auftrag des Burgwarts (00:25) um 00:30 und endet mit dem Schlag um 01:30, Phase 2 endet um 03:00, Phase 3 um 04:30. Die Auflösung folgt im Morgengrauen.“
- **STADT-02 (AP:49):** „keine Straßenlaternen, keine Fenster, kein Licht am Uhrturm … Der Uhrturm schlägt mechanisch weiter.“
- **LISTE-ZEITEN (AP:78):** „der Uhrturm schlägt die Nacht um 00:30, 01:30, 03:00 und 04:30“.
- **HW-S01 (AP:122):** „Das Uhrwerk läuft mechanisch und ohne Strom; es schlägt die Phasen weiter.“
- **H-S06 (AP:135):** „Von der Pension aus siehst du den Uhrturm so nah, dass du die Zeiger zählen kannst.“ Das setzt Zeiger am Uhrturm voraus.
- **Zeigerregel (nur Projekt):** „Uhren haben überall ein Zifferblatt ohne Zeiger. Der Uhrturm zeigt die Spielzeit (Abgleich mit ANPASSUNG STADT-05)“ (KERN:188; ENT:47). Die ANPASSUNG sagt zur Zeigerfrage selbst nichts. Sie beschreibt nur den Schlag.
- **Code:** Uhrturm als Objekt `OS:74` und `SG:113` („schlägt mechanisch weiter“). Ort ORT-01 `SG:120`. Im Bestand stehen Uhren ohne erkennbaren Zeigerstatus: Uhrenvitrine HA:1176, Standuhr HA:1183, Uhrenregal HA:1190 (Konflikt 5).
- **M-23 (K8:265-267):** Das Muster ist ein Prüfbefund zu Uhrzeiten (Nummern „[A-ZEIT]“), keine Deko-Regel. Ergebnis: keine Uhr-Regel aus M-23.

---

## 7. OFFENE FRAGEN UND KONFLIKTE

Konflikte zwischen Quellen sind mit „Konflikt“ markiert. Die Punkte 1 bis 4 gehen gegen Projektregeln.

1. **Konflikt, LED-Licht gegen Strom aus.** M-18 nennt „eine LED-Laterne als Geleucht“ und „Kabel abkleben“ (K8:240-241). M-19 nennt „alle LED-Kerzen an“ und „LED-Kerzen … aus“ (K8:245-246). K9 nennt im Kamin-Gewölbe „LED-style flicker“ (K9:55). Gegen steht KERN:100 (kein elektrisches Licht) und REQ:14 (Verbot „LED-Kerzen statt Flammen“). Vorschlag: kein LED im Spiel. Das Geleucht bleibt Solar (BW:203, K1:23).
2. **Konflikt im Wortlaut „Laternen dunkel“.** KERN:100 kennt keine Ausnahme. Das Geleucht leuchtet aber (AP:49; K1:49). KERN:193 nimmt das Geleucht als Ausnahme auf. Vorschlag: KERN:100 um die Ausnahme ergänzen.
3. **Konflikt, „nur Farbe“ gegen Fall-Orte mit Hinweisen.** KERN:184 verlangt für Oberstadt, Gangnetz und Wohnhäuser „nie Ort eines Hinweises“. AP legt 24 Stadt-Hinweise in die Fall-Orte, darunter ORT-01 am Marktplatz (AP:121-124). Vorschlag: Fall-Orte als eigene Raumart mit Hinweis-Modus führen, Marktplatz bleibt „nur Farbe“. Entscheidung nötig.
4. **Konflikt, Holztruhe nur am Turm-Fuß gegen Truhen-Bestand.** KERN:183 nennt die Holztruhe als Ortsbindung. Im Bestand stehen 17 Truhen in Wohnhäusern (HA:88, 168, 226, 296, 423, 574, 595, 674, 738, 847, 1195, 1432, 1689, 2074, 2275, 2455, 2554) und eine bemalte Truhe im Fundus (FO:381). Entscheidung: nur die Laken-Truhe am Turm-Fuß ist gebunden, oder alle Truhenformen sind tabu.
5. **Offen, Zeiger der Bestandsuhren.** KERN:188 verlangt Zifferblätter ohne Zeiger überall. Die Daten nennen Uhrenvitrine (HA:1176), Standuhr (HA:1183) und Uhrenregal (HA:1190), aber keinen Zeigerstatus. Prüfung in der Szene nötig.
6. **Konflikt, Ausnahmeliste zu eng.** KERN:193 nennt nur drei Ausnahmen. Der Bestand hat 86 Lichtobjekte (Abschnitt 5.2). Offen ist, ob Tischkerzen (HA: „Tisch mit Kerze“, lichtWarm 0,3) unter „Kerzenfenster“ (STIL:60) fallen.
7. **Konflikt, Lampe und Batterie gegen Bestand.** KERN:186 verbietet „Lampe“ und „Batterie“ als neue Ausstattung. Die Apotheke hat „Notdienstlampe“ (FO:884). T-FO:243 lässt diesen Begriff ausdrücklich zu. AP:49 nennt „Notleuchten mit Batterie“. Vorschlag: Bestand bleibt, neue Stücke sind verboten.
8. **Konflikt, Ort des Kerzenständers.** K1:21 und K1:110 sagen „auf dem Fass“. K1:204 und BW:77 sagen „am Boden“. K1:148 sagt „daneben“. Entscheidung nötig, weil BW:77 die Position des Hinweis-Objekts setzt.
9. **Konflikt, Code gegen Kanon bei Speisekammer-Licht.** K1:110, K1:121 und K1:183 lassen dort Kerzen brennen und ausgehen. BW:55-83 hat kein Licht-Objekt. Lichtquelle nachtragen oder Kanon anpassen.
10. **Offen, Kandelaber fehlt im Code.** K9:55 nennt „iron candelabras“ im Kamin-Gewölbe. BW:27-53 hat keinen Kandelaber. Der Wandkandelaber aus der Positivliste (KERN:192, ENT:43) ist also neu zu bauen. Er muss sich vom Tatwaffen-Kerzenständer deutlich unterscheiden (ENT:43).
11. **Konflikt, M-17 gegen Verbote.** Die Muster-Bauanleitung legt einen Marzipan-Kunibert auf die Torte in der Speisekammer (K8:228-234). Das widerspricht dem Verbot der Kunibert-Nachbildung (K1:22; KERN:191) und dem Tatort-Verbot. M-17 ist als „nur Muster“ gekennzeichnet. Vorschlag: aus REQ/M-17 streichen oder ausdrücklich sperren.
12. **Konflikt, M-18 gegen BS-11 und Projektregeln.** M-18 legt auf den Boden „einen Streifen weißes Papier mit Stiefelspuren als Raureif“ (K8:240). Das ist Zettel-ähnlich (KERN:186) und ein Nachbau von BS-11 (K1:193, BW:205). Außerdem sagt M-18 „Ecke am Fenster oder an der Balkontür“ (K8:238). Der Burghof hat weder Fenster noch Balkon (BW:174-209). Die Station-Hof-Vorlage passt nicht.
13. **Offen, Burg-Lücke bei der Deko.** Speisekammer, Erster Turmabsatz und Turm-Fuß haben fast keine erlaubten Kategorien. Die Projektregel verlangt Deko in allen Innenräumen (KERN:182, STIL:65). HZ-07 verlangt mindestens 4 Deko-Formen über alle Innen-Bereiche (ENT:33). Vorschlag: die E+-Felder W in Turm-Fuß und Hofebene bestätigen. Für die Speisekammer ist „keine Zusatzdeko“ zu entscheiden.
14. **Offen, Wanderstiefel-Anmutung im Bestand.** Schuhregal (HA:1355) und Lederkiste (HA:1362) in der Schusterwerkstatt. KERN:186 verbietet Wanderstiefel als neue Ausstattung. Der Bestand ist nicht neu, aber die Sohlen-Spur ist Lösungsbeweis (K1:195).
15. **Offen, Kessel-Form gegen Punschkessel-Ortsbindung.** Die Form „kessel“ kommt außerhalb des Kamin-Gewölbes vor: Teekessel (FO:531), Leimkessel (HA:1276), Talgkessel (HA:1763). Die Ortsbindung gilt dem Punschkessel (K1:27). Die Namen unterscheiden sich, ob das verwechselbar ist, entscheidet der Kanon-Gegenprüfer (ENT:43).
16. **Offen, Projektregel für Stadt-Hinweise am Marktplatz.** Die Hinweise H-S01 und H-S02 liegen auf dem Marktplatz (AP:121-124). Ob der Marktplatz „nur Farbe“ bleibt, steht im Konflikt mit KERN:184. Das ist dieselbe Frage wie Konflikt 3.

---

## 8. SELBSTPRÜFUNG

Gelesen und geprüft (vollständig, wenn nicht anders vermerkt):
- `hd/rollen/KOPF.md` (Paketkopf)
- K1 vollständig (214 Zeilen)
- K9 vollständig (93 Zeilen), dazu Abschnitte §1-§8
- K3: `K3-HINWEISE.md` vollständig; `K3-HINWEISE-KERN.md` vollständig; `K3-HINWEISE-P1.md`, `K3-HINWEISE-P2.md`, `K3-HINWEISE-P3.md` nur per Stichwort-Grep auf Gegenstände (Buch, Krug, Balken, Vorhang, Spiegel, Uhr, Kerze, Heißluft, Wachs, Foto u. a.), nicht vollständig gelesen
- K8: §5 (Uhrzeiten), M-17 bis M-23 (K8:227-267). Der übrige Stilblatt-Text ist nicht ausgewertet
- `REQ-RAUM.md` vollständig
- `GESAMT-KANON.md` M-18 verglichen (identisch)
- AP vollständig; `nachtlauf/KANON.md` per Stichwort-Grep (Uhr, Strom, Licht, Deko)
- `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md` vollständig (nur Verbotswörter, keine Deko- oder Lichtregel)
- Grep auf M-18 und M-23 in `nachtlauf/` (kein Treffer) und in `krimidinner/` (Treffer in K8 und GESAMT-KANON; Vorlagen verweisen nur darauf)
- Tests: `innenraeume_haeuser_test.dart` (Zeilen 18-40, 189-219), `innenraeume_fallorte_test.dart` (Zeilen 1-45, 240-275), `kanon_test.dart` (Stichwort-Grep, Punsch-Test 275)
- Code: `burg.dart` vollständig; `oberstadt.dart` (Häuser, Uhrturm, Marktplatz); `stadtgenerator.dart` (Zeilen 262-340, 424-480; Stichwort-Grep übrige Zeilen); `bereich.dart:33` (Stichwort); `FORMAT-BEREICHE.md:36`; `spuren.dart:50-53` (Stichwort)
- Daten: `fallorte.json` und `haeuser.json` über einen Zeilen-Parser (alle Legende-Schlüssel mit Zeile; Lichtwerte; Objektnamen)
- Projektlog: `hd/KERN.md` (57, 99-101, 176-193), `hd/STILBLATT.md` (28-29, 58-67), `hd/ENTSCHEIDUNGSLOG.md` (31-47, 61), `hd/PLAN.md` (71)

Nicht gelesen oder nicht ausgewertet: `erkunder.dart`, `navigation.dart`, K2, K4, K5, K6, K7 (nicht im Auftrag), `hd/` übrige Dateien.

Nicht ausgeführt: keine Tests und kein Dart-Lauf (nur Lesen). Der Test-Scanner A-406 wurde nicht ausgeführt.

Geänderte Dateien: nur `hd/kundschaft/P0-KUND-04.md` (neu). Kein Commit, kein Push.

ENDE PAKET P0-KUND-04
