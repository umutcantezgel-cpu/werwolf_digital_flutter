# L3-TEILORTE · Kundschafter-Bericht

Welle V1 · Kern 1.0 · Umfang 1 Bericht · Schwierigkeit 1 · Stand 2026-10-10
Fall: Spuk im Schlosskeller (settingId `spuk_im_schlosskeller`) · Maßstab 1 Kachel = 1 m · x nach Osten, y nach Süden
Quelle: `/home/user/bw-varianten/V1/kanon/` · maßgeblich `raeume.json` · Abgleich `A-3-KANON-AUSZUG.md`, `entscheidungen.json`, `gegenstaende.json`, `figuren.json`
Zeilen sind 1-basiert. Kürzel: **R** = raeume.json, **E** = entscheidungen.json, **G** = gegenstaende.json, **F** = figuren.json, **A3** = A-3-KANON-AUSZUG.md. Alle Zahlen stammen aus den Befehlen unter „Befehle“.

## Kurzfazit

- 7 Räume, 43 Orte (alle 43 innerhalb ihres Raums), 53 Einrichtungsstücke, 8 Türen, 19 Ziele aus 9 Entscheidungen.
- **X3-Basis mit Zählfilter: 42.** Prognose 43, Abweichung −1. Ursache: `wc` (R 937) und `wendeltreppe_fuss` (R 930) liegen auf derselben Koordinate (2.5, 1.5) im Turmgang. Nach der Dublettenregel (gleicher Raum, Abstand unter 1 Kachel) entfällt eines der beiden; `wc` wird entfernt.
- Alle 19 Ziele sind zugeordnet (10 Personen, 6 Gegenstände, 3 Raum-Ziele). Die 16 Ort-Ziele zeigen auf 14 verschiedene Orte, alle bereits in der Orte-Liste.
- Status **teil**: Prognose weicht ab, vier offene Fragen (wc, zusatzweg, Definition X3, Dublettenschwelle).

## Struktur

### Schlüssel von raeume.json (Befehl S)

| Schlüssel | Zeile | Inhalt |
|---|---|---|
| settingId | 2 | spuk_im_schlosskeller |
| massstab | 3 | 1 Kachel = 1 Meter; x nach Osten, y nach Süden; Rechtecke als Bodenkacheln (x, y, b, l) |
| raster | 4 | breite 27, hoehe 23 |
| rooms | 8 | 7 Räume |
| tueren | 145 | 8 Türen |
| einrichtung | 281 | 53 Stücke |
| orte | 718 | 43 Orte |
| lichtquellen | 1022 | 10 Einträge |
| luftzug | 1176 | 1 Eintrag (ab 23:30, Weg thekensaal → durchgang → west_saal) |
| geraeusch | 1187 | regel, nachbarn (6 Paare), geschlossen (1 Paar: thekensaal–windfang) |

### Felder und Koordinatenform

- **rooms[].rechteck = {x, y, b, l}**: ganzzahlige Kachelindizes. Der Raum umfasst die Kacheln x … x+b−1 und y … y+l−1. b ist die Breite in x-Richtung, l die Länge in y-Richtung. Beleg: thekensaal `widthMeters` 8 (R 13) = b (R 14).
- **orte[].x, y**: Kachelmitten, halbzahlig (14.5 = Kachel 14). Kachel = floor(x), floor(y). Innen-Test: x0 ≤ x < x0+b und y0 ≤ y < y0+l.
- **einrichtung[].x, y**: ganzzahliger Kachelindex (Kachel x…x+1).
- **tueren[].kacheln**: Liste von [x, y]-Kachelindizes auf der Wandkachel zwischen zwei Räumen oder außen.

Beispiele je Liste:
- **rooms**, `thekensaal` (R 10): Felder `id`, `name`, `anzeigename` („Buffetsaal“), `widthMeters` (nur hier, R 13), `rechteck` (R 14: x 11, y 7, b 8, l 12), `boden`, `features`, `beschreibung`.
- **orte**, `vor_vorratstuer` (R 720): `raum` thekensaal, `x` 14.5, `y` 7.5, `name` „vor der Vorratsraumtür“. Felder: `id`, `raum`, `x`, `y`, `name`. Nur `wc` (R 937) hat zusätzlich `zusatzweg` 10 (R 941).
- **einrichtung**, `spuele` (R 283): `x` 12, `y` 7, `blockiert` true, `darstellung` „sink“. Felder: `id`, `name`, `typ`, `x`, `y`, `blockiert`; `darstellung` optional.
- **tueren**, `vorrat_tuer` (R 184): `von` thekensaal, `nach` vorratsraum, `kacheln` [[14, 6]]. Felder: `id`, `name`, `von`, `nach`, `kacheln`, `art`, `schliesst`, `schluessel` (nur Außentüren), `zustand`, `quietscht`.

### Räume (rooms.rechteck)

| Raum | Anzeigename | x | y | b | l | Kacheln x / y | R (rechteck) |
|---|---|---|---|---|---|---|---|
| thekensaal | Buffetsaal | 11 | 7 | 8 | 12 | 11–18 / 7–18 | 14 |
| vorratsraum | Vorratsraum | 13 | 2 | 3 | 4 | 13–15 / 2–5 | 37 |
| durchgang | Durchgang | 8 | 8 | 2 | 2 | 8–9 / 8–9 | 55 |
| west_saal | Kaminsaal | 1 | 8 | 6 | 12 | 1–6 / 8–19 | 71 |
| turmgang | Turmgang | 1 | 1 | 3 | 6 | 1–3 / 1–6 | 92 |
| ost_saal | Ostsaal | 20 | 7 | 6 | 12 | 20–25 / 7–18 | 111 |
| windfang | Windfang | 14 | 20 | 2 | 2 | 14–15 / 20–21 | 131 |

Abgleich mit A3 (Befehl A3): 7 Räume (A3 Z. 5–14) und 43 Orte (A3 Z. 16–61) stimmen mit R überein (Kennung, Raum, Name), 0 Abweichungen.

### Raumgraph (Türen als Kanten, Befehl T)

| Tür (id) | Verbindung | Kacheln | Zustand (R) | Schloss | R |
|---|---|---|---|---|---|
| windfang_tuer (Innentür) | thekensaal – windfang | (14, 19) | zu (Zugluft) | keines | 168 |
| vorrat_tuer | thekensaal – vorratsraum | (14, 6) | angelehnt | keines | 184 |
| durchgang_ost | thekensaal – durchgang | (10, 9) | offen | keines | 200 |
| durchgang_west (Bogen) | durchgang – west_saal | (7, 9) | offen | keines | 216 |
| ost_tuer | thekensaal – ost_saal | (19, 9) | offen | keines | 232 |
| bogentuer | west_saal – turmgang | (2, 7) | offen | keines | 248 |
| aussentor (Außentür) | windfang – draussen | (14, 22), (15, 22) | verschlossen ab 18:50 | bund_schneider | 147 |
| hoftuer (Außentür) | turmgang – draussen | (2, 0) | verschlossen ab 18:50 | bund_schneider | 264 |

- Die sechs Innentüren verbinden die sieben Räume ohne Kreis (7 Knoten, 6 Kanten). thekensaal ist der Mittelpunkt mit vier Türen. Alle Räume sind über offene oder unverschlossene Türen erreichbar.
- Die sechs Innentür-Paare sind identisch mit `geraeusch.nachbarn` (R 1187). Alle acht Türen (zusammen neun Kacheln) liegen zwischen den genannten Räumen bzw. außen (Befehl T).
- Außentor und Hoftür sind verschlossen (A3 Z. 116: „niemand geht hinaus“). Ziele außerhalb der Räume gibt es nicht.

## Zählung (mit Befehlen)

| Zahl | Wert | Befehl | Beleg (Ausgabe) |
|---|---|---|---|
| Räume | 7 | Z | Z1 `Raeume=7` |
| Orte in R | 43 | Z | Z1 `Orte=43` |
| Einrichtungsstücke | 53 | Z | Z1 `Einrichtung=53` |
| Einrichtung je Raum | thekensaal 19, vorratsraum 3, durchgang 1, west_saal 15, turmgang 3, ost_saal 12, windfang 0 | Z | Z3 (windfang hat keinen Eintrag, also 0) |
| Einrichtung blockiert / frei | 50 / 3 | Z | Z3 `blockiert=true: 50 … false: 3` |
| Türen | 8 | Z | Z1 `Tueren=8` |
| Ziele (Optionen) | 19 (person 10, gegenstand 6, raum 3) | Z | Z1 `Ziele=19`, Z7 |
| Orte innerhalb / außerhalb | 43 / 0 | Z | Z2 |
| Randkacheln (Abstand 0.5) | 21 | Z | Z2 `rand=0.5 → 21` |
| Orte an einer Türkachel (4-Nachbar) | 13 | P | Spalte „Tür“ (13 Zeilen) |
| Orte auf blockierter Kachel | 0 | P | Spalte „blk“ (43× nein) |
| Dubletten (< 1 Kachel, selber Raum) | 1 | Z | Z5 `wendeltreppe_fuss – wc, 0.0` |
| Grenzfälle (genau 1.0, keine Dublette) | 2 | Z | Z5 `hinter_theke_west – theke_klappe`, `ost_tafel_ost – am_handykorb` |
| Orte nach Dublettenfilter | 42 | Z | Z6 `42, entfernt: ['wc']` |
| Ort-Ziele, distinkt | 14 (aus 16 Ort-Zielen) | Z | Z7 `distinkte Ort-Ziele: 14`, neu gegenüber Liste: 0 |
| X3-Basis | 42 | Z | Z8 `X3-Basis=42 … Delta=-1` |
| Raum-Ziele (separat, keine Orte) | 3 | Z | Z10 `turmgang, ost_saal, thekensaal` |
| A3-Räume / A3-Orte | 7 / 43 | A3 | `A3 Raeume-Zeilen: 7 \| A3 Orte-Zeilen: 43` |
| Figuren mit Ermittlungsort = Koordinate, innen | 20 von 20 | F | `F-Check … 20 von 20` |
| Innentür-Paare = geraeusch.nachbarn | 6, gleich | T | `Innentuer-Paare: 6 \| == geraeusch.nachbarn: True` |

### Orte je Raum vor und nach dem Filter (Z3, Z4, Z9)

| Raum | Orte vor Filter | Dublette entfernt | Orte nach Filter | Einrichtung |
|---|---|---|---|---|
| thekensaal | 16 | – | 16 | 19 |
| vorratsraum | 2 | – | 2 | 3 |
| durchgang | 2 | – | 2 | 1 |
| west_saal | 8 | – | 8 | 15 |
| turmgang | 4 | wc | 3 | 3 |
| ost_saal | 9 | – | 9 | 12 |
| windfang | 2 | – | 2 | 0 |
| **Summe** | **43** | **1** | **42** | **53** |

### Zählfilter (Schritt für Schritt)

1. Liste: `R orte` mit 43 Einträgen (Z1).
2. Dublettenregel: Zwei Orte im selben Raum mit einem Abstand der Kachelmitten unter 1 Kachel zählen als Dublette, einer entfällt. Ein Paar (Z5): `wendeltreppe_fuss` (R 930) und `wc` (R 937), Abstand 0.0. Entfernt wird `wc` (zweiter Eintrag, Name „oben im Turm“). Das Ergebnis 42 bleibt gleich, wenn stattdessen `wendeltreppe_fuss` entfällt.
3. Ort-Ziele aus E: 16 Ziele zeigen auf 14 verschiedene Orte (am_kamin 2×, am_linken_buffet 2×). Alle 14 stehen schon in der Liste aus Schritt 2; neue Orte: 0.
4. Raum-Ziele (turmgang, ost_saal, thekensaal) und die 7 Räume sind keine Orte und zählen nicht in die Basis; sie stehen separat.
5. Ergebnis: 43 − 1 + 0 = **42**.

## Prüfung innerhalb

Kriterium: Die Kachelmitte des Ortes liegt im Rechteck seines Raums laut R (x0 ≤ x < x0+b, y0 ≤ y < y0+l). Abstand zum Rand = kleinster Abstand des Ortspunkts zu einer Raumkante, in Kacheln (= m); 0.5 ist die Randkachel. Kante: N, O, S, W. Tür = Türkachel direkt angrenzend (4-Nachbar). Blockiert = Einrichtung mit `blockiert: true` auf derselben Kachel. Alle 43 Orte in Raumreihenfolge, Befehl P.

| Nr | Ort | Raum | Koordinate (x, y) | Kachel | innerhalb | Abstand zum Rand (Kacheln) | Rand / Tür / Bemerkung | R |
|---|---|---|---|---|---|---|---|---|
| 1 | vor_vorratstuer | thekensaal | (14.5, 7.5) | (14, 7) | ja | 0.5 | Randkachel N; Tür N: vorrat_tuer | 720 |
| 2 | an_anrichte | thekensaal | (13.5, 8.5) | (13, 8) | ja | 1.5 | – | 727 |
| 3 | hinter_theke_west | thekensaal | (11.5, 8.5) | (11, 8) | ja | 0.5 | Randkachel W | 734 |
| 4 | hinter_theke_mitte | thekensaal | (15.5, 8.5) | (15, 8) | ja | 1.5 | – | 741 |
| 5 | hinter_theke_ost | thekensaal | (17.5, 8.5) | (17, 8) | ja | 1.5 | – | 748 |
| 6 | theke_klappe | thekensaal | (11.5, 9.5) | (11, 9) | ja | 0.5 | Randkachel W; Tür W: durchgang_ost | 755 |
| 7 | theke_ostende | thekensaal | (18.5, 9.5) | (18, 9) | ja | 0.5 | Randkachel O; Tür O: ost_tuer | 762 |
| 8 | vor_theke | thekensaal | (14.5, 10.5) | (14, 10) | ja | 3.5 | – | 769 |
| 9 | vor_theke_west | thekensaal | (12.5, 10.5) | (12, 10) | ja | 1.5 | – | 776 |
| 10 | am_eiskuebel | thekensaal | (17.5, 10.5) | (17, 10) | ja | 1.5 | – | 783 |
| 11 | am_linken_buffet | thekensaal | (13.5, 13.5) | (13, 13) | ja | 2.5 | – | 790 |
| 12 | hinter_linkem_buffet | thekensaal | (11.5, 13.5) | (11, 13) | ja | 0.5 | Randkachel W | 797 |
| 13 | am_rechten_buffet | thekensaal | (16.5, 13.5) | (16, 13) | ja | 2.5 | – | 804 |
| 14 | hinter_rechtem_buffet | thekensaal | (18.5, 13.5) | (18, 13) | ja | 0.5 | Randkachel O | 811 |
| 15 | saalmitte | thekensaal | (14.5, 14.5) | (14, 14) | ja | 3.5 | – | 818 |
| 16 | unter_notausgang | thekensaal | (14.5, 18.5) | (14, 18) | ja | 0.5 | Randkachel S; Tür S: windfang_tuer | 825 |
| 17 | vorrat_innen | vorratsraum | (14.5, 5.5) | (14, 5) | ja | 0.5 | Randkachel S; Tür S: vorrat_tuer | 832 |
| 18 | vorrat_mitte | vorratsraum | (14.5, 3.5) | (14, 3) | ja | 1.5 | – | 839 |
| 19 | bei_den_kisten | durchgang | (9.5, 8.5) | (9, 8) | ja | 0.5 | Randecke NO | 846 |
| 20 | durchgang_mitte | durchgang | (8.5, 9.5) | (8, 9) | ja | 0.5 | Randecke SW; Tür W: durchgang_west | 853 |
| 21 | west_bogen | west_saal | (6.5, 9.5) | (6, 9) | ja | 0.5 | Randkachel O; Tür O: durchgang_west | 860 |
| 22 | am_sicherungskasten | west_saal | (6.5, 11.5) | (6, 11) | ja | 0.5 | Randkachel O | 867 |
| 23 | am_kamin | west_saal | (2.5, 13.5) | (2, 13) | ja | 1.5 | – | 874 |
| 24 | west_bank_nord | west_saal | (4.5, 8.5) | (4, 8) | ja | 0.5 | Randkachel N | 881 |
| 25 | west_bank_west | west_saal | (1.5, 10.5) | (1, 10) | ja | 0.5 | Randkachel W | 888 |
| 26 | vor_bogentuer | west_saal | (2.5, 8.5) | (2, 8) | ja | 0.5 | Randkachel N; Tür N: bogentuer | 895 |
| 27 | west_tafel_sued | west_saal | (5.5, 15.5) | (5, 15) | ja | 1.5 | – | 902 |
| 28 | west_bank_sued | west_saal | (3.5, 18.5) | (3, 18) | ja | 1.5 | – | 909 |
| 29 | an_der_ruestung | turmgang | (2.5, 5.5) | (2, 5) | ja | 1.5 | – | 916 |
| 30 | an_der_vitrine | turmgang | (2.5, 3.5) | (2, 3) | ja | 1.5 | – | 923 |
| 31 | wendeltreppe_fuss | turmgang | (2.5, 1.5) | (2, 1) | ja | 0.5 | Randkachel N; Tür N: hoftuer (verschlossen ab 18:50); Dublettenpaar mit wc | 930 |
| 32 | wc | turmgang | (2.5, 1.5) | (2, 1) | ja | 0.5 | Randkachel N; Tür N: hoftuer; Dublette zu wendeltreppe_fuss, entfernt; zusatzweg 10 (R 941) | 937 |
| 33 | ost_eingang | ost_saal | (20.5, 9.5) | (20, 9) | ja | 0.5 | Randkachel W; Tür W: ost_tuer | 945 |
| 34 | am_jackenstaender | ost_saal | (21.5, 8.5) | (21, 8) | ja | 1.5 | – | 952 |
| 35 | ost_tafel_kopf | ost_saal | (22.5, 10.5) | (22, 10) | ja | 2.5 | – | 959 |
| 36 | ost_tafel_west | ost_saal | (21.5, 13.5) | (21, 13) | ja | 1.5 | – | 966 |
| 37 | ost_tafel_ost | ost_saal | (24.5, 13.5) | (24, 13) | ja | 1.5 | – | 973 |
| 38 | am_handykorb | ost_saal | (24.5, 12.5) | (24, 12) | ja | 1.5 | – | 980 |
| 39 | an_der_wandtafel | ost_saal | (24.5, 10.5) | (24, 10) | ja | 1.5 | – | 987 |
| 40 | ost_bank | ost_saal | (25.5, 15.5) | (25, 15) | ja | 0.5 | Randkachel O | 994 |
| 41 | geburtstagsplatz | ost_saal | (24.5, 16.5) | (24, 16) | ja | 1.5 | – | 1001 |
| 42 | im_windfang | windfang | (14.5, 20.5) | (14, 20) | ja | 0.5 | Randecke NW; Tür N: windfang_tuer | 1008 |
| 43 | am_aussentor | windfang | (15.5, 21.5) | (15, 21) | ja | 0.5 | Randecke OS; Tür S: aussentor (verschlossen ab 18:50) | 1015 |

Ergebnis: 43 von 43 innerhalb. Keiner der 43 Orte liegt auf einer blockierten Kachel. 21 Orte sind Randkacheln (Abstand 0.5), 13 liegen direkt an einer Türkachel. Jede Kennung steht genau einmal in R (Befehl P, Zeile „eindeutig“: 43 von 43).

Hinweise (kein Fehler, nur zur Kenntnis):
- hinter_theke_ost (17, 8) liegt diagonal zur Kaffeemaschine (16, 7) und direkt vor anrichte_ost (17, 7).
- vorrat_mitte (14, 3) liegt diagonal zum Regal mit der Torte (13, 2).
- A3 Z. 91–104 (Gegenstände) kürzt die Spalte „Lage“ ab. Maßgeblich ist G.

## Ziele der Entscheidungen

Herleitung (Befehl Zi): Personen-Ziel → `F ermittlungsOrt` (Platz während der Ermittlungsrunden; F-Check 20 von 20 gleich Koordinate). Gegenstand-Ziel → `G lage.ort`; hat der Gegenstand einen Träger (`lage.traeger`), dann der Ermittlungsort des Trägers. Raum-Ziel → Raum direkt. Die Spalte „Zeilen“ nennt E (Zeile des `ziel`-Schlüssels), F, G und R.

| Entsch. | Option (id) · Text | Ziel (Typ · ID) | Ort | Raum | Herleitung | Zeilen |
|---|---|---|---|---|---|---|
| e1_1 | e1_1_joanna · „Joanna befragen“ | Person johanna (Joanna) | am_handykorb | ost_saal | F ermittlungsOrt | E 329 · F 504 · R 980 |
| e1_1 | e1_1_damir · „Damir befragen“ | Person enes (Damir) | hinter_theke_west | thekensaal | F ermittlungsOrt | E 339 · F 921 · R 734 |
| e1_2 | e1_2_emine · „Emine befragen“ | Person emine | hinter_linkem_buffet | thekensaal | F ermittlungsOrt | E 374 · F 409 · R 797 |
| e1_2 | e1_2_tugba · „Tugba nach ihrem Notizbuch fragen“ | Person tugba | an_der_wandtafel | ost_saal | F ermittlungsOrt | E 385 · F 1055 · R 987 |
| e1_3 | e1_3_tim · „Tim zum Stromausfall befragen“ | Person tim | am_sicherungskasten | west_saal | F ermittlungsOrt | E 419 · F 455 · R 867 |
| e1_3 | e1_3_azra · „Azra befragen“ | Person dilara (Azra) | am_rechten_buffet | thekensaal | F ermittlungsOrt | E 429 · F 874 · R 804 |
| e2_1 | e2_1_ascheneimer · „Den Ascheneimer am Kamin durchsuchen“ | Gegenstand umschlag_mietgeld | am_kamin | west_saal | G lage.ort (Einrichtung ascheneimer, Kachel 1, 14) | E 464 · G 128 · R 874 |
| e2_1 | e2_1_bauchtasche · „Cans Bauchtasche untersuchen“ | Gegenstand leuchtmaske | west_bank_west | west_saal | G lage.traeger = can → F ermittlungsOrt von can | E 475 · G 204 · F 292 · R 888 |
| e2_2 | e2_2_vitrine · „Die Vitrine im Turmgang untersuchen“ | Gegenstand vitrine | an_der_vitrine | turmgang | G lage.ort (Einrichtung vitrine, Kachel 3, 3) | E 536 · G 564 · R 923 |
| e2_2 | e2_2_tasche · „Fatmas Tasche untersuchen“ | Gegenstand muenzschatulle | am_linken_buffet | thekensaal | G lage.traeger = fatma → F ermittlungsOrt von fatma | E 546 · G 165 · F 161 · R 790 |
| e2_3 | e2_3_olli · „Olli und seine Weste untersuchen“ | Person olli | ost_tafel_kopf | ost_saal | F ermittlungsOrt | E 602 · F 230 · R 959 |
| e2_3 | e2_3_kamin · „Die Kamin-Nische untersuchen“ | Gegenstand arbeitshandschuh_olli | am_kamin | west_saal | G lage.ort | E 613 · G 434 · R 874 |
| e3_1 | e3_1_turmgang · „Im Turmgang bei der Rüstung suchen“ | Raum turmgang | – | turmgang | Raum direkt | E 671 · R 89 |
| e3_1 | e3_1_ostsaal · „Im Ost-Saal mit dem Jackenständer suchen“ | Raum ost_saal | – | ost_saal | Raum direkt | E 681 · R 108 |
| e3_1 | e3_1_buffetsaal · „Im Buffetsaal an Theke und Buffettischen suchen“ | Raum thekensaal | – | thekensaal | Raum direkt | E 691 · R 10 |
| e3_2 | e3_2_fatma · „Fatmas Hände und ihren Ring untersuchen“ | Person fatma | am_linken_buffet | thekensaal | F ermittlungsOrt | E 754 · F 161 · R 790 |
| e3_2 | e3_2_kerzenstaender · „Den Kerzenständer genau untersuchen“ | Gegenstand kerzenstaender | vor_vorratstuer | thekensaal | G lage.ort | E 764 · G 9 · R 720 |
| e3_3 | e3_3_zeynep · „Zeynep befragen“ | Person zeynep | west_bogen | west_saal | F ermittlungsOrt | E 824 · F 598 · R 860 |
| e3_3 | e3_3_aylin · „Aylin nach ihrem Beleg fragen“ | Person aylin | ost_tafel_west | ost_saal | F ermittlungsOrt | E 834 · F 776 · R 966 |

Ergebnis: 19 von 19 Zielen zugeordnet (Typen: person 10, gegenstand 6, raum 3). Keine OFFENE FRAGE nötig. 16 Ort-Ziele ergeben 14 distinkte Orte, alle in der Orte-Liste.

Schlüsselbund-Prüfung (Befehl SB, G 240): Die drei Raum-Ziele von e3_1 decken alle vier möglichen Verstecke ab: ahmet → am_jackenstaender (ost_saal), fatma → hinter_linkem_buffet (thekensaal), olli → am_eiskuebel (thekensaal), can → an_der_ruestung (turmgang).

## X3-Basis

- Definition: Anzahl begehbarer Orte innerhalb der 7 Räume nach dem Zählfilter (Schritte 1–5 oben): Orte-Liste, Dublettenregel „< 1 Kachel, selber Raum“, Vereinigung mit den Ort-Zielen. Räume und Raum-Ziele zählen nicht mit.
- **Messwert X3-Basis = 42** (Befehl Z, Z8). Prognose 43 (Auftrag; deckt sich mit A3 Z. 16 „Orte (43)“). Abweichung −1 = `wc`.
- Je Raum nach Filter (Z9): thekensaal 16 · west_saal 8 · ost_saal 9 · turmgang 3 · durchgang 2 · vorratsraum 2 · windfang 2 = 42.
- Stellschrauben (berechnet):
  - `wc` als eigener Ort gezählt (keine Dublette): **43** = Prognose.
  - `wc` nicht im Kellerraum, sondern oben im Turm: 42.
  - Schwelle „≤ 1“ statt „< 1“: 40 (zusätzlich entfallen `theke_klappe` und `am_handykorb`; das Ziel johanna (Ort `am_handykorb`) zählt dann am verbleibenden Nachbarort `ost_tafel_ost`; sonst würde derselbe Platz doppelt gezählt).
  - Raum-Ziele mitgezählt: 45.
- Zusatzprüfung: 0 Orte auf blockierter Kachel; alle 7 Räume sind erreichbar (Raumgraph, Befehl T).

## Offene Fragen

1. **wc (Turmgang)**: Der Name lautet „auf der Toilette oben im Turm“ (R 937; A3 Z. 50; STORY-BIBEL.md Z. 153). Die Koordinate (2.5, 1.5) ist mit `wendeltreppe_fuss` (R 930) identisch. Die Raumdaten kennen keine Ebene; der Turmgang ist ein Rechteck im Grundriss. Gezählt als Dublette, Ergebnis 42. Frage: Ist `wc` ein eigener Ort (dann 43 = Prognose) oder entfällt er (42)?
2. **zusatzweg = 10 bei `wc`** (R 941): Einheit und Bedeutung (z. B. Nachtminuten oder Kacheln) sind im Kanon nicht definiert. `grep -rn zusatzweg` über den Kanon findet nur diese Zeile. Nicht in die Zählung eingeflossen.
3. **Umfangsachse X3 und Prognose 43**: Die Definition steht nicht im Kanon (`grep -rn -E "X3|Umfang|Prognose"` ohne Treffer). Die Basis stammt aus dem Auftrag. Frage: Gilt 42 (gefiltert) oder 43 (roh)? Zählen die drei Raum-Ziele mit (dann 45)?
4. **Dublettenschwelle**: Zwei Paare liegen genau bei 1.0 Kachel (`hinter_theke_west` – `theke_klappe`; `ost_tafel_ost` – `am_handykorb`). Nach „< 1“ sind sie keine Dubletten. Bei „≤ 1“ ergibt sich 40. Bitte die Schwelle bestätigen.

## Selbstprüfung

- (a) 7 Räume gefunden: ja (Z1; A3 hat 7 Zeilen).
- (b) Jeder Ort hat eine Zeile in der Prüfung: 43 von 43 (Befehl P).
- (c) Jede Zahl hat einen Befehl: ja (Spalte „Befehl“ in der Zählung).
- (d) Jedes Ziel ist zugeordnet oder OFFENE FRAGE: 19 von 19 zugeordnet (Befehl Zi).
- (e) X3-Basis mit Filter genannt: ja (42; Zählfilter Schritte 1–5).

Ergebnis: 5/5.

## Befehle

Alle Befehle sind mit `python3 -I` oder `grep` ausgeführt und lesen nur unter `/home/user/bw-varianten/V1/kanon/`.

**S (Struktur)**
```
python3 -I -c 'import json
d=json.load(open("/home/user/bw-varianten/V1/kanon/raeume.json",encoding="utf-8"))
print("TOP-LEVEL TYPE:", type(d).__name__)
if isinstance(d,dict):
    print("TOP-LEVEL KEYS:", len(d.keys()))
    for k,v in d.items():
        ln = len(v) if hasattr(v,"__len__") else ""
        print(repr(k), type(v).__name__, "len=", ln)
'
```

**Z (Zählung, Z1–Z10)**
```
python3 -I -c 'import json, math
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
E=json.load(open(K+"entscheidungen.json",encoding="utf-8"))
G=json.load(open(K+"gegenstaende.json",encoding="utf-8"))["gegenstaende"]
F=json.load(open(K+"figuren.json",encoding="utf-8"))["figuren"]
rooms={r["id"]:r for r in R["rooms"]}
orte={o["id"]:o for o in R["orte"]}
fig={f["id"]:f for f in F}
geg={g["id"]:g for g in G}
def rec(rid): return rooms[rid]["rechteck"]
def inside(x,y,rid):
    c=rec(rid); return c["x"]<=x<c["x"]+c["b"] and c["y"]<=y<c["y"]+c["l"]
def rand(x,y,rid):
    c=rec(rid); return min(x-c["x"], c["x"]+c["b"]-x, y-c["y"], c["y"]+c["l"]-y)
print("Z1 Raeume=%d Orte=%d Einrichtung=%d Tueren=%d Ziele=%d" % (len(R["rooms"]),len(R["orte"]),len(R["einrichtung"]),len(R["tueren"]),sum(len(e["optionen"]) for e in E["entscheidungen"])))
print("Z2 Orte innerhalb=%d ausserhalb=%d Randkacheln(rand=0.5)=%d" % (sum(inside(o["x"],o["y"],o["raum"]) for o in R["orte"]), sum(not inside(o["x"],o["y"],o["raum"]) for o in R["orte"]), sum(rand(o["x"],o["y"],o["raum"])==0.5 for o in R["orte"])))
ein={}
for e in R["einrichtung"]:
    h=[k for k in rooms if inside(e["x"],e["y"],k)]
    key=h[0] if len(h)==1 else "NICHT-EINDEUTIG"
    ein[key]=ein.get(key,0)+1
print("Z3 Einrichtung je Raum:", ein, "| blockiert=true:", sum(1 for e in R["einrichtung"] if e.get("blockiert")), "| blockiert=false:", sum(1 for e in R["einrichtung"] if not e.get("blockiert")))
pre={}
for o in R["orte"]: pre[o["raum"]]=pre.get(o["raum"],0)+1
print("Z4 Orte je Raum vor Filter:", pre)
o=R["orte"]; pairs=[]; grenz=[]
for i in range(len(o)):
    for j in range(i+1,len(o)):
        a,b=o[i],o[j]
        if a["raum"]!=b["raum"]: continue
        dd=math.hypot(a["x"]-b["x"],a["y"]-b["y"])
        if dd<1: pairs.append((a["id"],b["id"],round(dd,2)))
        elif abs(dd-1)<1e-9: grenz.append((a["id"],b["id"]))
print("Z5 Dubletten (<1 Kachel, selber Raum):", pairs, "| Grenzfall (=1.0, keine Dublette):", grenz)
dup=set(j for _,j,_ in pairs)
rest=[x["id"] for x in o if x["id"] not in dup]
print("Z6 Orte nach Dublettenfilter:", len(rest), "| entfernt:", sorted(dup))
zo=set(); typen={}
for e in E["entscheidungen"]:
    for op in e["optionen"]:
        (t,z)=list(op["ziel"].items())[0]
        typen[t]=typen.get(t,0)+1
        if t=="person": zo.add(fig[z]["ermittlungsOrt"])
        elif t=="gegenstand":
            l=geg[z]["lage"]
            zo.add(l["ort"] if "ort" in l else fig[l["traeger"]]["ermittlungsOrt"])
print("Z7 Ziele nach Typ:", typen, "| distinkte Ort-Ziele:", len(zo), "| nicht in Orte:", sum(1 for x in zo if x not in orte), "| neu gegenueber Filter:", sum(1 for x in zo if x not in rest))
base=set(rest)|zo
print("Z8 X3-Basis=%d Prognose=43 Delta=%d" % (len(base), len(base)-43))
after={}
for x in base: after[orte[x]["raum"]]=after.get(orte[x]["raum"],0)+1
print("Z9 Orte je Raum nach Filter:", after, "| Summe:", sum(after.values()))
rz=[list(op["ziel"].values())[0] for e in E["entscheidungen"] for op in e["optionen"] if "raum" in op["ziel"]]
print("Z10 Raum-Ziele (separat):", len(rz), rz)
'
```

**P (Prüfung je Ort, Tabelle oben)**
```
python3 -I -c 'import json, math
K="/home/user/bw-varianten/V1/kanon/"
raw=open(K+"raeume.json",encoding="utf-8").read()
R=json.loads(raw)
lines=raw.splitlines()
rooms={r["id"]:r for r in R["rooms"]}
blk=set((e["x"],e["y"]) for e in R["einrichtung"] if e.get("blockiert"))
tuer={}
for t in R["tueren"]:
    for k in t["kacheln"]: tuer[(k[0],k[1])]=t["id"]
eindeutig=0
for n,o in enumerate(R["orte"],1):
    c=rooms[o["raum"]]["rechteck"]
    x0,y0,b,l=c["x"],c["y"],c["b"],c["l"]
    X,Y=o["x"],o["y"]
    ins=(x0<=X<x0+b) and (y0<=Y<y0+l)
    d={"W":X-x0,"O":x0+b-X,"N":Y-y0,"S":y0+l-Y}
    m=min(d.values())
    kante="".join(k for k in ["N","O","S","W"] if d[k]==m and m<=0.5) or "-"
    tx,ty=int(X//1),int(Y//1)
    tn=",".join(lab+":"+tuer[(tx+dx,ty+dy)] for dx,dy,lab in [(-1,0,"W"),(1,0,"O"),(0,-1,"N"),(0,1,"S")] if (tx+dx,ty+dy) in tuer) or "-"
    zeilen=[i+1 for i,ln in enumerate(lines) if ("\"id\": \"%s\"" % o["id"]) in ln]
    if len(zeilen)==1: eindeutig+=1
    print("{:>2}|{}|{}|({},{})|({},{})|{}|{}|{}|{}|{}|Z{}".format(n,o["id"],o["raum"],X,Y,tx,ty,"ja" if ins else "NEIN",m,kante,tn,"nein" if (tx,ty) not in blk else "JA",zeilen[0] if zeilen else "?"))
print("Orte-Kennungen mit genau einer id-Zeile in raeume.json:", eindeutig, "von", len(R["orte"]))
'
```

**Zi (Ziele-Zuordnung)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
E=json.load(open(K+"entscheidungen.json",encoding="utf-8"))
G=json.load(open(K+"gegenstaende.json",encoding="utf-8"))["gegenstaende"]
F=json.load(open(K+"figuren.json",encoding="utf-8"))["figuren"]
orte={o["id"]:o for o in R["orte"]}
fig={f["id"]:f for f in F}
geg={g["id"]:g for g in G}
ein={e["id"]:e for e in R["einrichtung"]}
rows=[]
for e in E["entscheidungen"]:
    for o in e["optionen"]:
        (typ,zid)=list(o["ziel"].items())[0]
        if typ=="person":
            ort=fig[zid]["ermittlungsOrt"]; raum=orte[ort]["raum"]; how="figuren.ermittlungsOrt"
        elif typ=="gegenstand":
            lage=geg[zid]["lage"]
            if "ort" in lage:
                ort=lage["ort"]; how="gegenstaende.lage.ort"
            elif "traeger" in lage:
                tr=lage["traeger"]; ort=fig[tr]["ermittlungsOrt"]; how="gegenstaende.lage.traeger=%s -> figuren.ermittlungsOrt" % tr
            else:
                ort=None; how="OFFENE FRAGE"
            raum=orte[ort]["raum"] if ort else None
            if "einrichtung" in lage: how += " (einrichtung=%s, Tile %s,%s)" % (lage["einrichtung"], ein[lage["einrichtung"]]["x"], ein[lage["einrichtung"]]["y"])
        else:
            ort=None; raum=zid; how="ziel.raum direkt"
        rows.append((e["id"],o["id"],typ,zid,ort,raum,how,o["text"]))
for r in rows: print("{:<6}|{:<20}|{:<10}|{:<22}|{:<22}|{:<12}|{}".format(r[0],r[1],r[2],r[3],str(r[4]),str(r[5]),r[6]))
from collections import Counter
print("ZIELE gesamt:", len(rows))
print("nach Typ:", dict(Counter(r[2] for r in rows)))
ortz=[r[4] for r in rows if r[4]]
print("Ort-Ziele (Anzahl Ziele mit Ort):", len(ortz), " distinkte Orte:", len(set(ortz)))
print("Orte mehrfach referenziert:", {k:v for k,v in Counter(ortz).items() if v>1})
print("distinkte Orte ausserhalb der 43 Orte:", [x for x in set(ortz) if x not in orte])
print("Raum-Ziele:", [r[3] for r in rows if r[2]=="raum"])
print("Ziele ohne Zuordnung (OFFENE FRAGE):", [r[1] for r in rows if r[4] is None and r[2]!="raum"])
'
```

**F (Figuren-Abgleich)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
F=json.load(open(K+"figuren.json",encoding="utf-8"))["figuren"]
orte={o["id"]:o for o in R["orte"]}
rooms={r["id"]:r["rechteck"] for r in R["rooms"]}
ok=0; bad=[]
for f in F:
    o=orte.get(f["ermittlungsOrt"]); c=f["coordinates"]
    if o is None: bad.append((f["id"],"ort fehlt")); continue
    rc=rooms[o["raum"]]
    same=(c["x"]==o["x"] and c["y"]==o["y"])
    innen=(rc["x"]<=o["x"]<rc["x"]+rc["b"] and rc["y"]<=o["y"]<rc["y"]+rc["l"])
    if same and innen: ok+=1
    else: bad.append((f["id"],"abweichung"))
print("F-Check Figuren (ermittlungsOrt == coordinates == orte, innen):", ok, "von", len(F), "| Abweichungen:", bad)
'
```

**T (Türen und Raumgraph)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
rooms={r["id"]:r for r in R["rooms"]}
def room_of(x,y):
    for rid,r in rooms.items():
        rc=r["rechteck"]
        if rc["x"]<=x<rc["x"]+rc["b"] and rc["y"]<=y<rc["y"]+rc["l"]: return rid
    return None
pairs=set()
for t in R["tueren"]:
    sides=set()
    for (kx,ky) in t["kacheln"]:
        for (nx,ny) in [(kx-1,ky),(kx+1,ky),(kx,ky-1),(kx,ky+1)]:
            rid=room_of(nx,ny)
            if rid: sides.add(rid)
    ok=(sides=={t["von"],t["nach"]}) if t["nach"]!="draussen" else (t["von"] in sides and len(sides)==1)
    print("T", t["id"], t["von"], t["nach"], t["kacheln"], sorted(sides), "ok" if ok else "NEIN")
    if t["nach"]!="draussen": pairs.add(frozenset([t["von"],t["nach"]]))
nb=set(frozenset(p) for p in R["geraeusch"]["nachbarn"])
print("T Innentuer-Paare:", len(pairs), "| == geraeusch.nachbarn:", pairs==nb)
'
```

**A3 (Abgleich Kern-Auszug)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
lines=open(K+"A-3-KANON-AUSZUG.md",encoding="utf-8").read().splitlines()
def table_rows(start_marker, end_marker):
    rows=[]; on=False
    for ln in lines:
        if ln.startswith(start_marker): on=True; continue
        if on and ln.startswith(end_marker): break
        if on and ln.startswith("|") and not ln.startswith("|---"):
            rows.append([c.strip() for c in ln.strip().strip("|").split("|")])
    return rows
raum_rows=[c for c in table_rows("## Räume (7)","## Orte (43)") if c[0]!="Kennung"]
orte_rows=[c for c in table_rows("## Orte (43)","## Personen") if c[0]!="Kennung"]
rooms={r["id"]:r for r in R["rooms"]}
print("A3 Raeume-Zeilen:", len(raum_rows), "| A3 Orte-Zeilen:", len(orte_rows))
print("A3 Raum-Abweichungen:", [k for k,an in raum_rows if k not in rooms or rooms[k]["anzeigename"]!=an])
oi={o["id"]:o for o in R["orte"]}
print("A3 Orte-Abweichungen:", [k for k,raum,name in orte_rows if k not in oi or oi[k]["raum"]!=raum or oi[k]["name"]!=name])
'
```

**SB (Schlüsselbund-Verstecke)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
R=json.load(open(K+"raeume.json",encoding="utf-8"))
G=json.load(open(K+"gegenstaende.json",encoding="utf-8"))["gegenstaende"]
orte={o["id"]:o for o in R["orte"]}
b=[g for g in G if g["id"]=="bund_schneider"][0]
print("bund_schneider lage:", b["lage"])
for pfad,v in b["versteckJePfad"].items():
    o=orte[v["ort"]]
    print("  Pfad", pfad, "-> ort", v["ort"], "raum", o["raum"], "einrichtung", v.get("einrichtung"), "stelle:", v.get("stelle"))
'
```

**L1 (Zeilen-Gegenprobe mit grep)**
```
cd /home/user/bw-varianten/V1/kanon
grep -n -E '"id": "(wc|wendeltreppe_fuss|am_kamin|vor_vorratstuer|thekensaal|turmgang)"' raeume.json
grep -n -E '"id": "(e1_1_joanna|e3_3_aylin)"|"id": "(johanna|aylin)"' entscheidungen.json figuren.json
grep -n -E 'Orte \(43\)|Räume \(7\)|Außentor und Hoftür|^\| wc \|' A-3-KANON-AUSZUG.md
grep -rn -E "X3|Umfang|Prognose|zusatzweg" /home/user/bw-varianten/V1/kanon/
```

**L2 (Zeilen aller zitierten Einträge: R = Ort-Zeile, E = Option und ziel-Zeile, F = Figur-Zeile und ermittlungsOrt-Zeile, G = Gegenstand-Zeile und lage-Zeile)**
```
python3 -I -c 'import json
K="/home/user/bw-varianten/V1/kanon/"
def lines(p): return open(K+p,encoding="utf-8").read().splitlines()
def nach(L,start,pat):
    for i in range(start,len(L)):
        if pat in L[i]: return i+1
    return None
RL=lines("raeume.json"); R=json.load(open(K+"raeume.json",encoding="utf-8"))
EL=lines("entscheidungen.json"); E=json.load(open(K+"entscheidungen.json",encoding="utf-8"))
FL=lines("figuren.json"); F=json.load(open(K+"figuren.json",encoding="utf-8"))["figuren"]
GL=lines("gegenstaende.json"); G=json.load(open(K+"gegenstaende.json",encoding="utf-8"))["gegenstaende"]
for o in R["orte"]:
    print("R", o["id"], nach(RL,0,"\"id\": \"%s\"" % o["id"]))
for e in E["entscheidungen"]:
    for o in e["optionen"]:
        l1=nach(EL,0,"\"id\": \"%s\"" % o["id"])
        print("E", o["id"], l1, nach(EL,l1-1,"\"ziel\""))
for f in F:
    l1=nach(FL,0,"\"id\": \"%s\"" % f["id"])
    print("F", f["id"], l1, nach(FL,l1-1,"\"ermittlungsOrt\""))
for g in G:
    l1=nach(GL,0,"\"id\": \"%s\"" % g["id"])
    print("G", g["id"], l1, nach(GL,l1-1,"\"lage\""))
'
```

=== ENDE L3-TEILORTE · BEREIT ZUR RÜCKGABE ===
