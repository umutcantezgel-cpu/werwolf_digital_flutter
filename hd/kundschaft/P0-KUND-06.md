# P0-KUND-06 · Belegblicke

Commit (Basis, `git rev-parse --short HEAD`): `6ca419c` · Stand 2026-10-09 · Kundschafter · HZ-01, HZ-14

Die Werte stammen aus heutigen Werkzeugen. `belegfotos.dart` (quer 1280×720, hoch 1080×2400) gibt keine Positionen aus; deshalb liefen Kopien von `belegfotos.dart`, `bereichsfotos.dart` und ein Gangnetz-Lauf, die nur zusätzlich `marke x z yaw pitch` ausgeben. Kopien, Logs (`log_*.txt`) und Bilder liegen unter `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/kund06/` (Bilder nur als Pfad genannt). Jeder Lauf wurde zweimal ausgeführt, mit identischer Ausgabe. Während der Arbeit kamen Commits anderer Pakete dazu (HEAD zuletzt `6ca419c`): in `burgstadt_core/lib` eine neue Prüfsummen-Datei, ein Export und ein Zähler in `zufall.dart`. `burgstadt_core/data`, `burgstadt_spiel/bin`, `burgstadt_spiel/lib` und `pixel_engine/lib` sind unverändert (geprüft mit `git diff --name-only ef8aac4 6ca419c`). Im Repo habe ich nur diese Datei geschrieben.

## Verfahren heute (belegfotos.dart)

- Keine Zufallszahl im Werkzeug. Richtungen: 16 feste Richtungen `k / 8 * π` (belegfotos.dart:59-60).
- Bildfeld: sieben Bildstrahlen von −0,8 bis +0,8 rad (belegfotos.dart:22). Je Richtung wird die kleinste und mittlere freie Sicht über diese Strahlen gemessen (49-52). Ein Strahl misst in 0,1-m-Schritten bis 14 m, bis zur ersten nicht begehbaren Kachel (39-46).
- Richtungswahl (`besterBlick`, 57-67): verworfen, wenn die kleinste Sicht unter 2,5 m liegt (15-16) oder der Mittelstrahl unter 6 m (Stadt, Zeile 19; Innen ohne Mindestwert). Gewertet wird die mittlere Sicht plus 0,01 · cos(Richtung − bevorzugt) (63); der größte Wert gewinnt.
- Viertel (`stadtBlick`, 71-92): je Haustür-Marke `vor-H-…` des Viertels (Liste 274-281, sortiert nach ID). Die Kamera steht im 0,25-m-Raster 1 bis 2 m vor der Marke, auf der Seite weg von der Tür (74-83). Beste Marke = größte mittlere Sicht (86, 280).
- Innenräume (`innenBlick`, 96-116): Kamera im 0,25-m-Raster bis 2 m um die Ankunftsmarke `t`. Gewählt wird die Position mit dem kleinsten Abstand zur Marke, bei Gleichstand die größte mittlere Sicht, und nur mit freier Sicht ≥ 2,5 m (103-111). Tauglich sind Räume mit so einem Blick (307-316); zehn davon werden gleichmäßig verteilt (317-319).
- Blick setzen über `ortsansicht` (178-187): Pitch 0 (184), zwölf Bilder Wartezeit für die Einblendung aus Schwarz (186).
- Prüfung je Bild (167-169): bestanden bei Palette 0, Blocktest 100 % und Schwarzanteil ≤ 20 % (Grenze 12).
- Format: die Bildmaße setzen nur Pixelgröße und Test (140-144, 167); die Auswahl liest sie nicht. Die Läufe quer und hoch liefern deshalb identische Blicke.
- Zum Vergleich, nicht im Auftrag: `stadtfotos.dart` nutzt feste Koordinaten (19-25). `bereichsfotos.dart` setzt den Blick auf Marke `t`, sonst `b`, sonst den ersten Marken-Schlüssel (18), Pitch ±0,05 (24). Der Erkundungs-Blick zielt auf die Bereichsmitte (erkundung.dart:50-60, Yaw in 58).

## Belegblicke (Tabelle)

Werte aus den Logs übernommen (2 Nachkommastellen). Gruppen: Viertel 1–6, Fall-Ort 7–18, Gangnetz 19–23, Burg 24–29, Bildschirm 30–37, Tutorial 38; Zusatz 39–51 (nicht im Auftrag, aber heute fotografiert bzw. nötig für Vergleich). Bei Bildschirmen sind x, z, yaw, pitch nicht zutreffend (–).

| Nr | Gruppe (Viertel/Fall-Ort/Gangnetz/Burg/Bildschirm/Tutorial) | Name | Bereich-id | x | z | yaw | pitch | Format(e) | Herkunft (heutiges Werkzeug Datei:Zeile oder neu) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Viertel | Burgberg (Marke vor-H-155) | stadt | 16.50 | 94.00 | 0.79 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 2 | Viertel | Mauerviertel (Marke vor-H-069) | stadt | 12.25 | 68.00 | 0.00 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 3 | Viertel | Kirchhügel (Marke vor-H-106) | stadt | 32.75 | 64.25 | 0.79 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 4 | Viertel | Handwerkergasse (Marke vor-H-043) | stadt | 129.75 | 69.75 | 3.93 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 5 | Viertel | Untere Stadt (Marke vor-H-111) | stadt | 81.75 | 101.25 | 2.36 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 6 | Viertel | Marktviertel (Marke vor-H-016) | stadt | 93.00 | 79.00 | 3.93 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:71-92 (stadtBlick), Auswahl 274-281 |
| 7 | Fall-Ort | ORT-01 Uhrwerk-Kammer im Uhrturm | innen-uhrturm | 3.75 | 5.25 | -1.68 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 8 | Fall-Ort | ORT-02 Stadtmuseum am Marktplatz | innen-museum | 4.75 | 6.25 | -1.48 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 9 | Fall-Ort | ORT-03 Pension „Zum Uhrturm“ | innen-pension | 2.25 | 7.25 | -0.79 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 10 | Fall-Ort | ORT-04 Schreinerei an der Mauergasse | innen-schreinerei | 2.75 | 5.25 | -0.91 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 11 | Fall-Ort | ORT-05 Kostümfundus der Volksbühne | innen-fundus | 1.75 | 6.25 | -0.63 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 12 | Fall-Ort | ORT-06 Stromhaus am Obertor | innen-stromhaus | 3.25 | 5.25 | -1.46 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 13 | Fall-Ort | ORT-07 Teestube „Zur Laterne“ | innen-teestube | 4.75 | 6.25 | -1.48 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 14 | Fall-Ort | ORT-08 Bäckerei am Untertor | innen-baeckerei | 2.25 | 6.25 | -0.79 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 15 | Fall-Ort | ORT-09 Ratssaal im Rathaus | innen-rathaus | 5.75 | 7.25 | -1.49 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 16 | Fall-Ort | ORT-10 Bibliothek mit Archiv | innen-bibliothek | 1.75 | 7.25 | -0.79 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 17 | Fall-Ort | ORT-11 Apotheke | innen-apotheke | 3.75 | 5.25 | -1.46 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 18 | Fall-Ort | ORT-12 Kirchenburg | innen-kirche | 5.75 | 9.25 | -1.51 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t, Pitch 24); Blick erkundung.dart:56-58 |
| 19 | Gangnetz | Gangnetz unter der Stadt, abgang-0 | gaenge | 5.25 | 3.75 | 0.58 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke abgang-0) |
| 20 | Gangnetz | Gangnetz unter der Stadt, abgang-1 | gaenge | 15.25 | 28.75 | -0.54 | -0.05 | quer, hoch | neu (Methode bereichsfotos.dart:19-24, Marke abgang-1) |
| 21 | Gangnetz | Gangnetz unter der Stadt, abgang-2 | gaenge | 30.25 | 8.75 | 1.59 | -0.05 | quer, hoch | neu (Methode bereichsfotos.dart:19-24, Marke abgang-2) |
| 22 | Gangnetz | Gangnetz unter der Stadt, abgang-3 | gaenge | 45.25 | 28.75 | -2.62 | -0.05 | quer, hoch | neu (Methode bereichsfotos.dart:19-24, Marke abgang-3) |
| 23 | Gangnetz | Gangnetz unter der Stadt, abgang-4 | gaenge | 54.25 | 4.75 | 2.58 | -0.05 | quer, hoch | neu (Methode bereichsfotos.dart:19-24, Marke abgang-4) |
| 24 | Burg | Kamin-Gewölbe (Marke t) | gewoelbe | 12.25 | 0.75 | 2.66 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke t) |
| 25 | Burg | Speisekammer (Marke s) | speisekammer | 2.25 | 0.75 | 1.37 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke s) |
| 26 | Burg | Turm-Fuß (Marke a) | turmfuss | 1.75 | 0.75 | 1.17 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke a) |
| 27 | Burg | Erster Turmabsatz (Marke u) | absatz | 1.75 | 0.75 | 1.33 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke u) |
| 28 | Burg | Hofebene des Turms (Marke u) | hofebene | 1.75 | 0.75 | 1.03 | -0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke u) |
| 29 | Burg | Burghof (Marke b) | hof | 7.75 | 7.25 | -1.49 | 0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke b) |
| 30 | Bildschirm | Hauptmenü | – | – | – | – | – | quer, hoch | heute belegfotos.dart:190-191 (Startzustand, spiel.dart:147 Hauptmenue()) |
| 31 | Bildschirm | Optionen (über Hauptmenü) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:193-195 (spiel.oeffne(OptionenBildschirm()), Klasse optionen_bildschirm.dart:10) |
| 32 | Bildschirm | Erkundung (Fall-Start) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:200-205 (wechsle Erkundung(sitzung:), Foto 03; Blick wie Nr 38; Klasse erkundung.dart:18) |
| 33 | Bildschirm | Fallakte (drei Einträge) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:250-257 (drei Notizen geheftet 250-252, druecke(Taste.akte) 253; Öffnung erkundung.dart:211-213; Klasse fallakte.dart:10) |
| 34 | Bildschirm | Lagerunde (Phasen 1–3) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:218-220 (Fotos lagerunde_phase1 bis 3; geöffnet von erkundung.dart:205-209; Klasse lagerunde.dart:14) |
| 35 | Bildschirm | Stadtkarte | – | – | – | – | – | quer, hoch | neu: Taste.karte in der Erkundung (erkundung.dart:233), karteOeffnen 239-240 öffnet StadtkarteBildschirm (Klasse stadtkarte.dart:13); heute nicht fotografiert (0 Treffer in bin/) |
| 36 | Bildschirm | WLAN/Lobby (WlanBildschirm) | – | – | – | – | – | quer, hoch | neu: hauptmenue.dart:77 spiel.oeffne(WlanBildschirm()) (Klasse wlan.dart:37); heute nicht fotografiert (0 Treffer in bin/) |
| 37 | Bildschirm | Anklage (Eingrenzung) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:234 (wechsle AnklageBildschirm), Foto 239-245 „eingrenzung“; Klasse anklage.dart:11 |
| 38 | Tutorial | Tutorial-Karte beim Fall-Start (Erkundung) | gewoelbe | 3.25 | 4.75 | -0.32 | 0.00 | quer, hoch | heute belegfotos.dart:200-205 (Foto 03); Standard Marke m, erkundung.dart:44-45 |
| 39 | Zusatz Burg | Wehrgang (außen, nicht im Auftrag) | wehrgang | 6.25 | 1.25 | -0.09 | 0.05 | quer, hoch | heute bereichsfotos.dart:18-24 (Marke d); Bereich burg.dart:154-155 |
| 40 | Zusatz Innen | Haus am Schiefen Eck (Marke t) | haus-H-008 | 1.00 | 1.50 | 0.39 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116) |
| 41 | Zusatz Innen | Haus zur Harfe (Marke t) | haus-H-015 | 3.00 | 0.75 | 1.57 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116) |
| 42 | Zusatz Innen | Zunftturm der Schmiede (Marke t) | haus-H-061 | 0.75 | 4.75 | 5.50 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116) |
| 43 | Zusatz Innen | Pfarrhaus am Lindenplatz (Marke t) | haus-H-085 | 0.75 | 4.25 | 5.89 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116) |
| 44 | Zusatz Innen | Werkstatt am Hang (Marke t) | haus-H-145 | 4.75 | 5.25 | 3.93 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116) |
| 45 | Zusatz Innen | Apotheke (Marke t) | innen-apotheke | 3.75 | 5.25 | 4.71 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116); Doppel zu Nr 17 (Fall-Ort-Blick aus bereichsfotos) |
| 46 | Zusatz Innen | Kirchenburg (Marke t) | innen-kirche | 5.75 | 9.25 | 5.50 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116); Doppel zu Nr 18 (Fall-Ort-Blick aus bereichsfotos) |
| 47 | Zusatz Innen | Stadtmuseum am Marktplatz (Marke t) | innen-museum | 4.25 | 6.25 | 3.93 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116); Doppel zu Nr 8 (Fall-Ort-Blick aus bereichsfotos) |
| 48 | Zusatz Innen | Schreinerei an der Mauergasse (Marke t) | innen-schreinerei | 2.75 | 5.25 | 5.50 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116); Doppel zu Nr 10 (Fall-Ort-Blick aus bereichsfotos) |
| 49 | Zusatz Innen | Stromhaus am Obertor (Marke t) | innen-stromhaus | 3.25 | 5.25 | 5.50 | 0.00 | quer, hoch (Blick neu, s. Hinweis) | heute belegfotos.dart:296-327 (innenBlick 96-116); Doppel zu Nr 12 (Fall-Ort-Blick aus bereichsfotos) |
| 50 | Zusatz Bildschirm | Pausenmenü über Erkundung | – | – | – | – | – | quer, hoch | heute belegfotos.dart:207-208 (druecke(Taste.menue)); spiel.oeffne(_Pause(this)) erkundung.dart:232, Klasse erkundung.dart:558 |
| 51 | Zusatz Bildschirm | Ende (Morgengrauen) | – | – | – | – | – | quer, hoch | heute belegfotos.dart:264-266 (nach Fall-Ende, Schleife 215-259) |

## Hinweis 1080×2400 (hochkant)

- Beleg: Lauf quer und hoch liefern identische Blickzeilen, bei belegfotos und bei bereichsfotos (Diff der BLICK-Zeilen ohne Abweichung).
- Berechnet, nicht gemessen: Das Sichtfeld ist quer vertikal 62° (optionen.dart:11, Standard), horizontal etwa 94°. Hochkant wird der vertikale Winkel auf 100° begrenzt (spiel.dart:176-182), horizontal bleiben etwa 56°. Die Bildbreite ist also etwa 40 % schmaler, dafür sieht man vertikal mehr Decke und Boden.
- Anders wählen, Nr 1–6 (Viertel) und Nr 40–49 (Innenraum-Zusatz): Die Auswahl beruht auf den sieben Strahlen ±0,8 rad (belegfotos.dart:22, 49-52, 57-67). Hochkant liegt die Bildgrenze bei etwa ±0,49 rad; vier der sieben Strahlen (±0,53 und ±0,8 rad) liegen dann außerhalb des Bildes. Neu wählen mit Strahlen innerhalb ±0,49 rad, die Mindestsicht 2,5 m (15-16) und die Mittelsicht-Regel (19) bleiben.
- Erkundungs-Blicke (Nr 7–18, 19–23, 24–29, 38, 39 und die Erkundung in Nr 32): Im Werkzeug gibt es keine Sichtprüfung, der Blick zielt nur auf die Raummitte (erkundung.dart:56-58). Position und Blickrichtung bleiben, der Ausschnitt wird aber enger. Raumkanten und Wände können ins Bild rücken. Jeder Blick braucht eine Sichtprüfung.
- Bildschirme (Nr 30–37, 50–51): keine Kamera; nur das Layout ändert sich.

## OFFENE FRAGEN

1. **Commit:** Schritt 3 verlangt „+ Commit“, KOPF.md verbietet Commits („Nichts committen“). Umgesetzt: Basis-Hash im Kopf, kein Commit. Entscheidung beim Orchestrator.
2. **Stadtkarte (Nr 35) und WLAN/Lobby (Nr 36):** Kein heutiges Werkzeug fotografiert sie (0 Treffer in `bin/`). Neuer Schritt nötig: Stadtkarte über `Taste.karte` in der Erkundung (erkundung.dart:233, 239-240), WLAN über das Hauptmenü (hauptmenue.dart:77). Wer baut den Schritt?
3. **Burg:** `burg.dart` enthält 7 Bereiche. Fünf sind innen (gewoelbe, speisekammer, turmfuss, absatz, hofebene), `hof` ist außen, `wehrgang` ist außen und heißt „Wehrgang“ (burg.dart:154-155). Der Auftrag nennt 5 Räume + Hof; der Wehrgang steht als Zusatz Nr 39. Aufnehmen oder streichen?
4. **Fall-Orte:** Der heutige Blick zeigt den Raum von der Tür (Marke `t`) zur Raummitte, nicht die Station ORT-nn (Kachel `station` in fallorte.json). Soll ein Fall-Ort-Blick auf die Station zielen? Heute gibt es dafür kein Werkzeug.
5. **Doppelte Innen-Blicke:** Fünf Fall-Orte haben zwei heutige Blicke aus verschiedenen Werkzeugen: ORT-02 (Nr 8 und 47), ORT-04 (Nr 10 und 48), ORT-06 (Nr 12 und 49), ORT-11 (Nr 17 und 45), ORT-12 (Nr 18 und 46). Welcher gilt als Fall-Ort-Blick?
6. **Pitch-Konvention:** Viertel und Innenraum-Zusatz nutzen Pitch 0,00 (belegfotos.dart:184), Erkundungs-Blicke Pitch ±0,05 (bereichsfotos.dart:24). Für den Vorher/Nachher-Vergleich braucht es eine Konvention.
7. **Gangnetz:** Heute gibt es nur Abgang 0 (bereichsfotos.dart:19-24). Die Abgänge 1–4 (Nr 20–23) sind neu nach gleicher Methode, Blick zur Bereichsmitte. Ist die Blickrichtung für Gänge so gewollt?
8. **Tutorial:** Im Werkzeug ist nur die Karte beim Fall-Start erfasst (Foto 03, belegfotos.dart:200-205). Es gibt 13 Tutorial-Auslöser (z. B. `akte` erkundung.dart:212, `lagerunde` 208, `blick` 230); die übrigen Karten sind nicht als Blick fotografiert. Aufnehmen?
9. **Zielpaket:** KUNDSCHAFTER verlangt je Zeile ein Zielpaket, die Auftragstabelle hat keine Spalte dafür. Vorschlag aus hd/PLAN.md: Vorher P0-PROBE-02 (Ausgangs-Belegfotos, hd/PLAN.md:79), Nachher P9-PROBE-03 (HD-Belegfotos final, hd/PLAN.md:408), Paare P9-MONT-01 (6 Viertel, 12 Fall-Orte, hd/PLAN.md:410). Keiner dieser Pakete nennt P0-KUND-06 als Abhängigkeit. Ergänzen?

Hinweis zum Arbeitsbaum (nicht von mir): `hd/kundschaft/P0-KUND-01.md` war zu Beginn geändert; dieser Auftrag hat sie nicht angefasst.

## SELBSTPRÜFUNG

Suchmuster einzeln gesucht (Trefferzahl):

| Suchmuster | Ort | Treffer | Befund |
|---|---|---|---|
| `Kamerablick` | belegfotos.dart | 12 | Typ 26-30, Verwendung 71-116 und 275-327 |
| `sichtweite` | belegfotos.dart | 3 | Definition 39, Aufrufe 50 und 62 |
| `Auswahl` (ohne Groß/Klein) | belegfotos.dart | 2 | Zeile 32 (Kommentar) und 243 (Anklage-Auswahl); die Blickwahl steckt nicht im Wort, sondern in `besterBlick` (57-67) |
| `extends Bildschirm` | packages/burgstadt_spiel/lib/src/bildschirme | 9 | 8 Bildschirme (Hauptmenue, LagerundeBildschirm, StadtkarteBildschirm, FallakteBildschirm, Erkundung, WlanBildschirm, OptionenBildschirm, AnklageBildschirm) plus `_Pause` (erkundung.dart:558) |
| `WlanBildschirm` oder `StadtkarteBildschirm` | packages/burgstadt_spiel/bin | 0 | nicht fotografiert, siehe Frage 2 |
| `"art": "station"` | fallorte.json | 12 | ORT-01 bis ORT-12 |
| Viertel-Werte | haeuser.json | 6 | Burgberg, Handwerkergasse, Kirchhügel, Marktviertel, Mauerviertel, Untere Stadt |
| Bereiche (`id: '`) | burg.dart | 7 | gewoelbe, speisekammer, turmfuss, absatz, hofebene, wehrgang, hof |
| Gangnetz-Marken | Lauf `gaenge` | 5 | abgang-0 bis abgang-4 |

Pflichtstellen gefunden: ja. Die 41 Zeilen mit Positionswerten sind vollständig aus den Logs übernommen (keine Stichprobe); die Zeilen 30–37 und 50–51 haben keine Positionen (–). Die Läufe wurden zweimal wiederholt und stimmen überein.

Anzahl Blicke je Gruppe (Soll nach Auftrag):

- Viertel: 6 (Soll 6), heute 6.
- Fall-Ort: 12 (Soll 12), heute 12.
- Gangnetz: 5 (Soll mindestens 2), heute 1, neu 4.
- Burg: 6 (Soll 5 Räume + Hof), heute 6; Wehrgang als Zusatz 1.
- Bildschirm: 8 (Soll 8), heute 6, neu 2 (Stadtkarte, WLAN/Lobby).
- Tutorial: 1 (Soll 1), heute 1.
- Zusatz: 13 (Wehrgang 1, Innenraum 10, Pausenmenü und Ende 2).
- Gesamt: 51 Zeilen.

ENDE PAKET P0-KUND-06
