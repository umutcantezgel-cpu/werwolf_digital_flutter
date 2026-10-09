# P0-KUND-05 · Raumvorlagen

Commit: `64d415f` (`git -C /home/user/werwolf_digital_flutter rev-parse --short HEAD`), Branch `claude/pensive-gates-ajtp7x`. Die untersuchten Quellen sind zwischen `ef8aac4` und `64d415f` unverändert (`git diff --stat ef8aac4 HEAD` für `packages/burgstadt_core` und `welt_geometrie.dart` leer). Im Arbeitsbaum liegt zusätzlich ein reiner Zähler in `packages/burgstadt_core/lib/src/zufall.dart` (`static int aufrufe`, `_x` unverändert); die Erzeugung bleibt gleich.

Alle Pfade relativ zu `/home/user/werwolf_digital_flutter/`. Kürzel: `haeuser.json`, `fallorte.json` = `packages/burgstadt_core/data/innenraeume/`; `burg.dart`, `bereich.dart`, `stadtgenerator.dart`, `oberstadt.dart` = `packages/burgstadt_core/lib/src/welt/`; `welt_geometrie.dart` = `packages/burgstadt_spiel/lib/src/`. Die Häuserliste `packages/burgstadt_core/data/stadt/haeuser.json` ist nicht im Auftrag genannt, wird aber vom Generator gelesen (`packages/burgstadt_spiel/lib/burgstadt_spiel_io.dart:26-32`, `packages/burgstadt_core/lib/src/welt/burg.dart:219-226`) und deshalb mitgezählt.

Zahlen: Raumvorlagen **42** (haeuser.json 30, fallorte.json 12). Formwerte **27** (Daten + burg.dart: 25; nur im Generator zusätzlich `garten`, `laube`). Zählung über die Laufzeit-Welt (`zaehle.dart`), Gegenprobe der 42 Vorlagen in Python (`pruefe_wand.py`): Wandkanten und Möbel stimmen überein.

Begriffe: **Dinge** sind zusammenhängende Rechtecke gleicher Zeichen (`bereich.dart:222-254`). Eine Möbelgruppe, die kein Rechteck bildet, zählt mehrfach (hof `turm×3` bei einem Wendeltreppenturm, `burg.dart:201`). **Wandkante** = Wandkachel (`#`) mit begehbarer Nachbarkachel (Boden, Marke oder Station), Länge 0,5 m. **Frei** = an der Wandkachel liegt in der 4er-Nachbarschaft (außer in Richtung der begehbaren Kachel) keine Tür und kein Objekt. Fenster: keine Vorlage hat eine Fenster-Kachel, Fenster-Form oder Fenster-Legende.

## 1. Formen-Inventar

Vorkommen = Legende-Einträge mit dieser `form` (nicht Kartenkacheln). Daten: 274 Objekt- und Station-Einträge in 42 Vorlagen, dazu 42 Tür-Einträge ohne `form`. Typische Höhe = Median aller Legende-Werte aus Daten und burg.dart, Spanne in Klammern.

| form | Daten: Legende-Einträge (Art) | burg.dart: Zeilen | Generator-Code und Stadt-Dinge | typ. Höhe in m (Median, Spanne) | Zeichnung in welt_geometrie.dart |
|---|---|---|---|---|---|
| bank | 16 (objekt) | – | – | 0,45 (0,45–0,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| bett | 5 (objekt) | – | – | 0,6 (0,6–1,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| boden | 12 (station) | 5 (burg.dart:75, burg.dart:76, burg.dart:77, burg.dart:106, burg.dart:171) | – | 0,05 (0,05–0,05) | nicht gezeichnet, Stationen sind keine Objekte (welt_geometrie.dart:238) |
| brunnen | 1 (objekt) | 1 (burg.dart:203) | stadtgenerator.dart:129, oberstadt.dart:86 (0,9 m); Stadt: 1 | 0,9 (0,9–0,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| fass | 6 (objekt) | 1 (burg.dart:78) | – | 0,9 (0,9–1,1) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| garten | – | – | stadtgenerator.dart:246 (Gartenmauer, 1,2 m); Stadt: 1054 | 1,2 | Quader je 32-Kachel-Block gebündelt, Oberseite Wiese (welt_geometrie.dart:239-245) |
| haus | – | 1 (burg.dart:204) | stadtgenerator.dart:134 (Kirchenburg, 12 m), :323 (Häuser 6,5–8,9 m), oberstadt.dart:53 (12 Häuser, 7–10 m); Stadt: 156 | 4,5 (4,5–4,5) | eigene Geometrie: Giebelhaus mit Fenstern und Satteldach (welt_geometrie.dart:261-262, _haus :56-134) |
| kamin | 4 (objekt) | 1 (burg.dart:47) | – | 1,6 (1,4–1,6) | Quader + warmes Glutfeld (welt_geometrie.dart:274-277) |
| kasten | 27 (objekt) | 1 (burg.dart:105) | – | 1,75 (0,8–2,2) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| kessel | 4 (objekt) | 1 (burg.dart:48) | – | 0,9 (0,8–0,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| kiste | 38 (objekt) | 1 (burg.dart:79) | stadtgenerator.dart:152 (Grabsteine, 0,8 m); Stadt: 14 | 0,4 (0,4–1,4) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| laube | – | – | stadtgenerator.dart:161 (Holztreppe, Station, 2,6 m); Stadt: 1 | 2,6 | eigene Geometrie: Laubengang mit Pfosten und Dach (welt_geometrie.dart:234-236, _laube :289-313) |
| nische | – | 1 (burg.dart:50) | – | 1,2 (1,2–1,2) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| ofen | 13 (objekt) | – | – | 2,0 (1,1–2,1) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| raureif | – | 1 (burg.dart:205) | – | 0,05 (0,05–0,05) | nur heller Bodenbelag, kein Objekt (welt_geometrie.dart:172-176) |
| regal | 31 (objekt) | 2 (burg.dart:74, burg.dart:81) | – | 1,9 (1,2–2,1) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| ruestung | – | 1 (burg.dart:127) | – | 1,9 (1,9–1,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| saeule | 4 (objekt) | – | – | 2,9 (2,6–3,2) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| stuhl | 21 (objekt) | – | – | 0,5 (0,4–1,0) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| theke | 8 (objekt) | – | – | 1,0 (1,0–1,05) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| tisch | 44 (objekt) | 1 (burg.dart:49) | – | 0,8 (0,6–1,1) | eigene Geometrie: Platte + 4 Beine (welt_geometrie.dart:251-255) |
| truhe | 19 (objekt) | 2 (burg.dart:80, burg.dart:107) | – | 0,7 (0,7–0,9) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| tuerdeko | 1 (objekt) | 1 (burg.dart:150) | – | 2,2 (2,2–2,2) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| turm | – | 1 (burg.dart:201) | stadtgenerator.dart:113 (Uhrturm, 20 m), oberstadt.dart:74 (18 m); Stadt: 1 | 9,0 (9,0–9,0) | eigene Geometrie: Quader + Spitzhelm (welt_geometrie.dart:263-273) |
| vitrine | 3 (objekt) | 1 (burg.dart:149) | – | 1,3 (1,2–1,3) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| wand | 17 (objekt) | 1 (burg.dart:51) | – | 2,2 (1,8–2,4) | Quader, Standard-Zweig (welt_geometrie.dart:278-279) |
| zinnen | – | 1 (burg.dart:168) | – | 1,3 (1,3–1,3) | eigene Geometrie: Mauerstück + Zinnen (welt_geometrie.dart:256-260) |

Hinweise: Notleuchten (Namen „Notleuchte“ bzw. „Notdienstlampe“, `lichtKalt` 0,35–0,5) stehen in den Daten mit `form` `kiste` oder `wand` und zählen in der Tabelle als Möbel. `zinnen`, `nische`, `ruestung` und `raureif` kommen nur in burg.dart vor, `garten` und `laube` nur im Generator.

## 2. Tabelle je Vorlage

Reihenfolge: 30 Innenräume aus haeuser.json, 12 Fall-Orte aus fallorte.json, danach 5 Burgräume, Wehrgang (außen), Hof (außen) und das Gangnetz. Vorlagen-Zeilen: Werte aus `Bereich.ausJson` der JSON-Datei (die Vorlage selbst, nicht die Stadt-Kopie). Burg-Zeilen: Werte aus dem Laufzeit-`Bereich` (`burg.dart`).

Stichprobe (Zeilen gegen die Quelle nachgelesen): innen-wohnstube-1 (`haeuser.json:5`, Karte 10 Zeilen × max. 14 Zeichen = 14×10 → 7,0×5,0 m; 25 Wandkanten, 23 frei, von Hand über Rand und Türkachel `D` nachgerechnet); innen-kirche (`fallorte.json:903`, Karte 20 Zeilen × 24 Zeichen = 24×20 → 12,0×10,0 m; Möbel `bankx10`, `saeulex4`, `tischx3`); gewoelbe (`burg.dart:27-41`, 14 Zeilen × 28 Zeichen → 14,0×7,0 m); speisekammer (`burg.dart:61-69`, 8 Zeilen × 10 Zeichen → 5,0×4,0 m); gaenge (`stadtgenerator.dart:432`, `gb = 120`, `gt = 80` → 60,0×40,0 m).

| id | Quelle Datei:Zeile | Name | Raumart | Größe (Kacheln B×T, Meter) | Raumhöhe | Wand/Boden/Decke-Textur | Möbel (form×Anzahl) | Stationen | Türen | Fenster (vorhanden? wie dargestellt?) | freie Wandlänge (m, grob) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| innen-wohnstube-1 | haeuser.json:5 | Wohnküche mit Herd | Wohnstube | 14×10 = 7,0×5,0 m | 2,8 m | putzCreme / holzDielen / holzBohlen | bank×1, fass×1, kasten×1, ofen×1, regal×1, stuhl×2, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 11,5 m (23 von 25 Kanten) |
| innen-wohnstube-2 | haeuser.json:98 | Stube mit Kachelofen | Wohnstube | 12×11 = 6,0×5,5 m | 2,8 m | putzOcker / holzDielen / holzBohlen | bank×1, ofen×1, regal×1, stuhl×2, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 9,5 m (19 von 21 Kanten) |
| innen-wohnstube-3 | haeuser.json:178 | Schlafkammer | Wohnstube | 10×12 = 5,0×6,0 m | 2,6 m | putzTaubenblau / holzDielen / holzBohlen | bett×1, kasten×1, kiste×1, stuhl×1, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 11,0 m (22 von 24 Kanten) |
| innen-wohnstube-4 | haeuser.json:259 | Dachstube unter Gauben | Wohnstube | 12×10 = 6,0×5,0 m | 2,4 m | holzVertaefelung / holzDielen / holzBohlen | bank×1, bett×1, ofen×1, regal×1, stuhl×2, tisch×1, truhe×1 | – | 1× Treppentür → stadt | nein | 9,5 m (19 von 21 Kanten) |
| innen-wohnstube-5 | haeuser.json:345 | Eckstube mit Erker | Wohnstube | 14×12 = 7,0×6,0 m | 2,9 m | putzSandstein / holzDielen / holzBohlen | bank×1, kamin×1, kasten×1, regal×1, stuhl×2, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 13,0 m (26 von 28 Kanten) |
| innen-wohnstube-6 | haeuser.json:433 | Kinderkammer | Wohnstube | 10×10 = 5,0×5,0 m | 2,6 m | putzAltrosa / holzDielen / holzBohlen | bank×1, bett×1, kiste×2, regal×1, stuhl×2, tisch×1 | – | 1× Haustür → stadt | nein | 8,5 m (17 von 19 Kanten) |
| innen-wohnstube-7 | haeuser.json:526 | Nähstube | Wohnstube | 12×12 = 6,0×6,0 m | 2,8 m | tapeteStreifen / holzDielen / holzBohlen | kasten×1, regal×1, stuhl×2, tisch×1, truhe×2 | – | 1× Haustür → stadt | nein | 15,0 m (30 von 32 Kanten) |
| innen-wohnstube-8 | haeuser.json:605 | Stube mit Schrankbett | Wohnstube | 12×10 = 6,0×5,0 m | 2,7 m | putzKalkweiss / holzDielen / holzBohlen | bank×1, bett×1, ofen×1, stuhl×2, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 10,0 m (20 von 22 Kanten) |
| innen-wohnstube-9 | haeuser.json:684 | Lesestube | Wohnstube | 13×11 = 6,5×5,5 m | 2,9 m | fachwerkPutz / holzDielen / holzBohlen | kasten×1, ofen×1, regal×1, stuhl×1, tisch×2, truhe×1 | – | 1× Haustür → stadt | nein | 13,5 m (27 von 29 Kanten) |
| innen-wohnstube-10 | haeuser.json:771 | Stube mit Spinnrad | Wohnstube | 14×10 = 7,0×5,0 m | 2,8 m | putzInnenWarm / holzDielen / holzBohlen | bank×1, kasten×2, ofen×1, stuhl×2, tisch×1, truhe×1 | – | 1× Haustür → stadt | nein | 12,0 m (24 von 26 Kanten) |
| innen-werkstatt-1 | haeuser.json:857 | Schmiede ohne Feuer | Werkstatt | 16×12 = 8,0×6,0 m | 3,2 m | bruchsteinMauer / schieferPlatten / holzBohlen | fass×1, kamin×1, kasten×1, kiste×2, regal×1, tisch×2 | – | 1× Schmiedetür → stadt | nein | 14,0 m (28 von 30 Kanten) |
| innen-werkstatt-2 | haeuser.json:952 | Seilerei | Werkstatt | 20×10 = 10,0×5,0 m | 3,0 m | bruchsteinMauer / holzDielen / holzBohlen | kasten×1, kiste×3, ofen×1, regal×1, tisch×1, wand×1 | – | 1× Seilereitür → stadt | nein | 11,5 m (23 von 25 Kanten) |
| innen-werkstatt-3 | haeuser.json:1038 | Töpferei | Werkstatt | 12×12 = 6,0×6,0 m | 3,0 m | putzSandstein / schieferPlatten / holzBohlen | kessel×1, kiste×2, ofen×1, regal×1, stuhl×1, tisch×2 | – | 1× Werkstatttür → stadt | nein | 13,5 m (27 von 29 Kanten) |
| innen-werkstatt-4 | haeuser.json:1133 | Uhrmacherstube | Werkstatt | 10×12 = 5,0×6,0 m | 3,0 m | putzKalkweiss / holzDielen / holzBohlen | kasten×1, kiste×1, regal×1, stuhl×1, tisch×1, truhe×1, vitrine×1 | – | 1× Werkstatttür → stadt | nein | 9,0 m (18 von 20 Kanten) |
| innen-werkstatt-5 | haeuser.json:1221 | Buchbinderei | Werkstatt | 14×10 = 7,0×5,0 m | 3,0 m | putzOcker / holzDielen / holzBohlen | kasten×1, kessel×1, kiste×2, regal×1, stuhl×1, tisch×1 | – | 1× Buchbindertür → stadt | nein | 12,5 m (25 von 27 Kanten) |
| innen-werkstatt-6 | haeuser.json:1307 | Schusterwerkstatt | Werkstatt | 12×10 = 6,0×5,0 m | 3,0 m | putzAltrosa / holzDielen / holzBohlen | kiste×1, regal×2, stuhl×1, tisch×1, truhe×1 | – | 1× Werkstatttür → stadt | nein | 8,5 m (17 von 19 Kanten) |
| innen-laden-1 | haeuser.json:1386 | Krämerladen | Laden | 14×12 = 7,0×6,0 m | 3,0 m | putzOcker / holzDielen / holzBohlen | fass×1, kasten×1, kiste×2, regal×1, theke×1, truhe×1 | – | 1× Ladentür → stadt | nein | 12,0 m (24 von 26 Kanten) |
| innen-laden-2 | haeuser.json:1474 | Gemüseladen | Laden | 16×12 = 8,0×6,0 m | 3,0 m | putzCreme / holzDielen / holzBohlen | fass×1, kasten×1, kiste×3, regal×1, theke×1 | – | 1× Ladentür → stadt | nein | 17,0 m (34 von 36 Kanten) |
| innen-laden-3 | haeuser.json:1555 | Papierladen | Laden | 12×12 = 6,0×6,0 m | 3,0 m | putzSandstein / holzDielen / holzBohlen | kasten×1, kiste×2, regal×2, theke×1 | – | 1× Ladentür → stadt | nein | 9,5 m (19 von 21 Kanten) |
| innen-laden-4 | haeuser.json:1636 | Tuchhandlung | Laden | 16×10 = 8,0×5,0 m | 3,0 m | putzAltrosa / holzDielen / holzBohlen | kiste×2, regal×1, stuhl×1, tisch×1, truhe×1, wand×1 | – | 1× Ladentür → stadt | nein | 11,0 m (22 von 24 Kanten) |
| innen-laden-5 | haeuser.json:1722 | Kerzenzieherei | Laden | 12×12 = 6,0×6,0 m | 3,0 m | putzKalkweiss / schieferPlatten / holzBohlen | kessel×1, kiste×2, regal×2, theke×1 | – | 1× Ladentür → stadt | nein | 13,0 m (26 von 27 Kanten) |
| innen-laden-6 | haeuser.json:1803 | Spielzeugladen | Laden | 14×10 = 7,0×5,0 m | 3,0 m | putzTaubenblau / holzDielen / holzBohlen | kasten×2, kiste×2, regal×1, theke×1, vitrine×1 | – | 1× Ladentür → stadt | nein | 12,5 m (25 von 27 Kanten) |
| innen-speicher-1 | haeuser.json:1889 | Kornspeicher | Speicher | 12×14 = 6,0×7,0 m | 3,4 m | bruchsteinMauer / holzDielen / holzBohlen | bank×1, fass×1, kasten×1, kiste×2, saeule×1 | – | 1× Speichertür → stadt | nein | 15,0 m (30 von 32 Kanten) |
| innen-speicher-2 | haeuser.json:1972 | Holzlager | Speicher | 14×12 = 7,0×6,0 m | 3,2 m | fachwerkPutz / holzDielen / holzBohlen | bank×1, kasten×1, kiste×2, regal×1 | – | 1× Holztor → stadt | nein | 12,5 m (25 von 26 Kanten) |
| innen-speicher-3 | haeuser.json:2044 | Dachboden | Speicher | 14×10 = 7,0×5,0 m | 2,8 m | holzVertaefelung / holzBohlen / holzBohlen | kasten×2, kiste×2, saeule×2, truhe×1 | – | 1× Bodenluke → stadt | nein | 14,0 m (28 von 30 Kanten) |
| innen-speicher-4 | haeuser.json:2121 | Gewölbekeller | Speicher (Name: Gewölbekeller) | 12×12 = 6,0×6,0 m | 2,6 m | quaderMauer / erde / gewoelbeDecke | brunnen×1, fass×2, kiste×2, regal×1, stuhl×1, tisch×1 | – | 1× Kellertür → stadt | nein | 11,5 m (23 von 24 Kanten) |
| innen-zunftstube-1 | haeuser.json:2209 | Zunftstube der Tuchmacher | Zunftstube | 20×14 = 10,0×7,0 m | 3,4 m | holzVertaefelung / holzDielen / holzBohlen | bank×2, kasten×1, kiste×1, ofen×1, tisch×1, truhe×1, wand×1 | – | 1× Zunfttür → stadt | nein | 17,0 m (34 von 36 Kanten) |
| innen-zunftstube-2 | haeuser.json:2301 | Zunftstube der Maurer | Zunftstube | 16×12 = 8,0×6,0 m | 3,2 m | bruchsteinMauer / schieferPlatten / holzBohlen | bank×2, kamin×1, kasten×1, kiste×1, stuhl×1, tisch×1, wand×1 | – | 1× Zunfttür → stadt | nein | 15,0 m (30 von 32 Kanten) |
| innen-zunftstube-3 | haeuser.json:2391 | Zunftstube der Schneider | Zunftstube | 18×12 = 9,0×6,0 m | 3,3 m | tapeteStreifen / holzDielen / holzBohlen | bank×2, kiste×1, ofen×1, regal×1, tisch×1, truhe×1, wand×1 | – | 1× Zunfttür → stadt | nein | 15,5 m (31 von 33 Kanten) |
| innen-zunftstube-4 | haeuser.json:2481 | Zunftstube der Gerber | Zunftstube | 14×14 = 7,0×7,0 m | 3,2 m | burgBruchstein / holzDielen / holzBohlen | bank×2, kamin×1, kasten×1, kiste×1, stuhl×1, tisch×1, truhe×1, wand×1 | – | 1× Zunfttür → stadt | nein | 10,0 m (20 von 22 Kanten) |
| innen-uhrturm | fallorte.json:5 | Uhrwerk-Kammer im Uhrturm | Fall-Ort | 14×12 = 7,0×6,0 m | 3,2 m | burgBruchstein / holzDielen / gewoelbeDecke | kasten×1, saeule×1, tisch×1, wand×3 | ORT-01 (Station, boden) | 1× Turmtür zum Marktplatz → stadt | nein | 12,5 m (25 von 29 Kanten) |
| innen-museum | fallorte.json:93 | Stadtmuseum am Marktplatz | Fall-Ort | 20×14 = 10,0×7,0 m | 3,0 m | putzCreme / schieferPlatten / holzBohlen | regal×1, tisch×1, vitrine×4, wand×1 | ORT-02 (Station, boden) | 1× Museumstür zum Marktplatz → stadt | nein | 25,0 m (50 von 54 Kanten) |
| innen-pension | fallorte.json:169 | Pension „Zum Uhrturm“ | Fall-Ort | 22×16 = 11,0×8,0 m | 2,6 m | putzOcker / holzDielen / holzBohlen | bank×1, bett×1, regal×1, stuhl×1, tisch×2, tuerdeko×1 | ORT-03 (Station, boden) | 1× Haustür zum Marktplatz → stadt | nein | 37,5 m (75 von 79 Kanten) |
| innen-schreinerei | fallorte.json:268 | Schreinerei an der Mauergasse | Fall-Ort | 18×12 = 9,0×6,0 m | 2,7 m | putzSandstein / holzDielen / holzBohlen | kasten×1, tisch×3 | ORT-04 (Station, boden) | 1× Werkstatttür zur Mauergasse → stadt | nein | 22,0 m (44 von 46 Kanten) |
| innen-fundus | fallorte.json:340 | Kostümfundus der Volksbühne | Fall-Ort | 22×14 = 11,0×7,0 m | 3,0 m | putzInnenWarm / holzDielen / holzBohlen | regal×2, tisch×1, truhe×2, wand×1 | ORT-05 (Station, boden) | 1× Fundustür zur Gasse → stadt | nein | 29,0 m (58 von 60 Kanten) |
| innen-stromhaus | fallorte.json:414 | Stromhaus am Obertor | Fall-Ort | 14×12 = 7,0×6,0 m | 2,8 m | putzKalkweiss / schieferPlatten / holzBohlen | kasten×2, tisch×1, wand×2 | ORT-06 (Station, boden) | 1× Tür zum Obertor → stadt | nein | 14,0 m (28 von 32 Kanten) |
| innen-teestube | fallorte.json:488 | Teestube „Zur Laterne“ | Fall-Ort | 20×14 = 10,0×7,0 m | 2,9 m | fachwerkPutz / holzDielen / holzBohlen | bank×1, kessel×1, ofen×1, theke×2, tisch×5 | ORT-07 (Station, boden) | 1× Tür zum Marktplatz → stadt | nein | 24,0 m (48 von 50 Kanten) |
| innen-baeckerei | fallorte.json:578 | Bäckerei am Untertor | Fall-Ort | 20×14 = 10,0×7,0 m | 2,8 m | putzCreme / holzDielen / holzBohlen | kiste×1, ofen×1, regal×1, theke×1, tisch×1 | ORT-08 (Station, boden) | 1× Ladentür zum Untertor → stadt | nein | 38,0 m (76 von 80 Kanten) |
| innen-rathaus | fallorte.json:659 | Ratssaal im Rathaus | Fall-Ort | 24×16 = 12,0×8,0 m | 3,3 m | putzOcker / teppichRot / holzVertaefelung | ofen×1, stuhl×10, tisch×3, wand×2 | ORT-09 (Station, boden) | 1× Tür zum Marktplatz → stadt | nein | 29,0 m (58 von 64 Kanten) |
| innen-bibliothek | fallorte.json:753 | Bibliothek mit Archiv | Fall-Ort | 20×16 = 10,0×8,0 m | 3,2 m | putzSandstein / holzDielen / gewoelbeDecke | kasten×1, regal×3, tisch×2, wand×1 | ORT-10 (Station, boden) | 1× Eingangstür zur Gasse → stadt | nein | 27,0 m (54 von 58 Kanten) |
| innen-apotheke | fallorte.json:838 | Apotheke | Fall-Ort | 16×12 = 8,0×6,0 m | 2,5 m | putzKalkweiss / schieferPlatten / holzBohlen | regal×2, theke×1, wand×1 | ORT-11 (Station, boden) | 1× Apothekentür zur Gasse → stadt | nein | 12,0 m (24 von 28 Kanten) |
| innen-kirche | fallorte.json:903 | Kirchenburg | Fall-Ort | 24×20 = 12,0×10,0 m | 3,4 m | bruchsteinMauer / schieferPlatten / gewoelbeDecke | bank×10, saeule×4, tisch×3 | ORT-12 (Station, boden) | 1× Portal zum Friedhof → stadt | nein | 38,5 m (77 von 79 Kanten) |
| gewoelbe | burg.dart:21 | Kamin-Gewölbe | Gewölbe | 28×14 = 14,0×7,0 m | 3,4 m | burgBruchstein / schieferPlatten / gewoelbeDecke | kamin×1, kessel×1, nische×1, tisch×1, wand×1 | BS-08 (Objekt, nische); BS-12 (Objekt, wand) | 3 Türen: Turmtür → turmfuss; alte Eichentür → speisekammer; Kellerhals → hof | nein | 25,5 m (51 von 55 Kanten) |
| speisekammer | burg.dart:55 | Speisekammer | Burg | 10×8 = 5,0×4,0 m | 2,6 m | burgBruchstein / schieferPlatten / gewoelbeDecke | fass×1, kiste×1, regal×2, truhe×1 | BS-05 (Objekt, regal); BS-01 (Station, boden); BS-03 (Station, boden); BS-09 (Station, boden) | 2 Türen: Eisentür (quietscht) → turmfuss; alte Eichentür → gewoelbe | nein | 5,0 m (10 von 13 Kanten) |
| turmfuss | burg.dart:85 | Turm-Fuß | Burg | 10×10 = 5,0×5,0 m | 3,0 m | burgBruchstein / schieferPlatten / gewoelbeDecke | kasten×1, truhe×1 | BS-04 (Station, boden); BS-06 (Objekt, truhe) | 3 Türen: Wendeltreppe hinauf → absatz; Turmtür → gewoelbe; Eisentür (quietscht) → speisekammer | nein | 7,0 m (14 von 22 Kanten) |
| absatz | burg.dart:111 | Erster Turmabsatz | Burg | 8×7 = 4,0×3,5 m | 3,0 m | burgBruchstein / schieferPlatten / gewoelbeDecke | ruestung×1 | Kunibert (Objekt, ruestung) | 2 Türen: Wendeltreppe hinauf → hofebene; Wendeltreppe hinab → turmfuss | nein | 5,0 m (10 von 16 Kanten) |
| hofebene | burg.dart:131 | Hofebene des Turms | Burg | 10×8 = 5,0×4,0 m | 3,0 m | burgBruchstein / schieferPlatten / gewoelbeDecke | tuerdeko×1, vitrine×1 | Vitrine (Objekt, vitrine) | 3 Türen: Wendeltreppe hinauf zum Wehrgang → wehrgang; Hoftür → hof; Wendeltreppe hinab → absatz | nein | 5,0 m (10 von 18 Kanten) |
| wehrgang | burg.dart:154 | Wehrgang (außen, innen: false) | Burg (außen) | 36×4 = 18,0×2,0 m | 1,1 m | bruchsteinMauer / holzBohlen / gewoelbeDecke | zinnen×1 | Zinne3 (Station, boden) | 3 Türen (Dinge): Turmpforte ×2 → hof [verschlossen]; Wendeltreppe hinab → hofebene | nein | 15,0 m (30 von 32 Kanten) |
| hof | burg.dart:175 | Burghof (außen, innen: false) | Burg (Hof, außen) | 32×16 = 16,0×8,0 m | 7,0 m | burgBruchstein / pflasterGross / gewoelbeDecke | brunnen×1, haus×1, turm×3 | BS-11 (Station, raureif) | 3 Türen: Hoftür → hofebene; Kellerhals → gewoelbe; Burgtor zur Oberstadt → stadt [verschlossen bis Phase 2] | nein | 33,5 m (67 von 71 Kanten) |
| gaenge | stadtgenerator.dart:466 | Gewölbegänge unter der Stadt | Gang | 120×80 = 60,0×40,0 m | 2,4 m | bruchsteinMauer / erde / gewoelbeDecke | – | – | 5 Türen: Treppe hinauf → stadt (Marken gang-0 bis gang-4) | nein | 248,5 m (497 von 503 Kanten) |

## 3. Raumarten-Zählung

Vorlagen je Raumart (aus Name bzw. ID; `innen-speicher-4` heißt „Gewölbekeller“, id-Präfix `speicher`, siehe Offene Fragen):

| Raumart | Vorlagen | erzeugte Innen-Bereiche in der Stadt (Summe) | Anzahl je Vorlage (id:Anzahl) |
|---|---|---|---|
| Wohnstube | 10 | 6 | 1:1 2:1 3:1 4:1 5:1 6:1 7:0 8:0 9:0 10:0 |
| Zunftstube | 4 | 0 | 1:0 2:0 3:0 4:0 |
| Werkstatt | 6 | 7 | 1:2 2:1 3:1 4:1 5:1 6:1 |
| Speicher | 4 | 16 | 1:4 2:4 3:4 4:4 |
| Laden | 6 | 12 | 1:2 2:2 3:2 4:2 5:2 6:2 |
| Fall-Ort | 12 | 12 | apotheke:1 baeckerei:1 bibliothek:1 fundus:1 kirche:1 museum:1 pension:1 rathaus:1 schreinerei:1 stromhaus:1 teestube:1 uhrturm:1 |
| **Summe** | **42** | **53** | 34 Vorlagen werden genutzt, 8 nie |

Festdefiniert, keine Vorlagen: Burg-Räume `gewoelbe` (Gewölbe), `speisekammer`, `turmfuss`, `absatz`, `hofebene` (Burg), Wehrgang und Hof (außen) in `burg.dart`, Gangnetz `gaenge` (Gang) in `stadtgenerator.dart:465-466`.

Erzeugte Innen-Bereiche in der Stadt: 53 (51 aus Häusern, davon 10 Fall-Orte; plus `innen-uhrturm` und `innen-kirche` als Wahrzeichen) plus `gaenge`. Häuser: 160 in haeuser.json, 54 betretbar. Auf der Karte stehen 157 Haus-Marken (`vor-…`, `stadtgenerator.dart:328`): 155 Gebäude mit Fußabdruck und die zwei Wahrzeichen-Marken für H-026 und H-106. Ohne Marke: H-158, H-159, H-160.

H-026 und H-106 sind bewusst übersprungen (ORT-01 und ORT-12, `stadtgenerator.dart:366-367`; Wahrzeichen Uhrturm und Kirchenburg). **H-159 ist betretbar (Laden) und bekommt keinen Innenraum**, weil der Generator bei H-158 abbricht (`stadtgenerator.dart:370-373`, `if (i < 0) break;`, kein freier Fußabdruck mehr). Die letzten drei Häuser der Liste (H-158 bis H-160) haben deshalb keinen Fußabdruck.

Ungenutzte Vorlagen: innen-wohnstube-7, innen-wohnstube-8, innen-wohnstube-9, innen-wohnstube-10, innen-zunftstube-1, innen-zunftstube-2, innen-zunftstube-3, innen-zunftstube-4. Ursache: Der Rundlauf je Typ (`stadtgenerator.dart:309-310`, `l[n % l.length]`) verteilt die Häuser eines Typs auf die ersten Vorlagen dieses Typs. Gibt es weniger Häuser als Vorlagen, bleiben die letzten ungenutzt. Der Wohnstube-Typ hat 6 Häuser, der Zunftstube-Typ 0 (Zuordnung `stadtgenerator.dart:304` nur für Innenraum-Werte wie „Amtsstube“ oder „Museum“; in haeuser.json kommen diese Werte nur bei Fall-Orten vor, dort greift die ORT-Zuordnung).

Gangnetz: 1 Bereich `gaenge`, 503 Wandkanten, 497 frei (≈ 248,5 m).

## 4. Vorlagen-ID beim Verteilen (Generator)

Die Vorlagen-ID wird **überschrieben**, außer bei Fall-Orten und Wahrzeichen.

- Auswahl: `vorlageFuer(h)` (`stadtgenerator.dart:296-311`). Zuerst die Fall-Ort-Zuordnung `ortVorlage` nach Feld `ort` (`:277-288`, 11 Einträge ORT-02 bis ORT-12; H-106 mit ORT-12 wird übersprungen, `:367`). Sonst Typ aus `innenraum` (`:299-306`): werkstatt/schreinerei → werkstatt; laden/bäckerei/apotheke/teestube → laden; speicher/archiv/schaltraum/uhrwerk → speicher; amtsstube/bibliothek/museum/kirche/fundus/pension → zunftstube; sonst wohnstube. Typ-Listen entstehen aus den Vorlagen-IDs mit Regex `^innen-([a-z]+)` (`:291-294`).
- Rundlauf je Typ: `l[n % l.length]` mit Zähler `typZaehler` (`:295`, `:307-310`).
- Überschreiben: `zielId = istFall ? v : 'haus-$id'` (`stadtgenerator.dart:333-334`), dann `json['id'] = zielId` (`:336-337`). Jede Nicht-Fall-Kopie heißt also `haus-H-xxx`, die Vorlagen-ID bleibt nicht erhalten. Der Name wird auf den Hausnamen gesetzt (`:338`). Fall-Orte behalten Vorlagen-ID und -Namen.
- Fall-Orte: `istFall` gilt nur beim ersten Mal (`:333`, `!genutzteFallVorlagen.contains(v)`). In den Daten kommt jede Fall-Vorlage einmal vor.
- Wahrzeichen ohne Kopie: `innen-uhrturm` (`stadtgenerator.dart:115-125`) und `innen-kirche` (`:136-146`) behalten ihre ID.
- Türen: Ziel `stadt` wird auf `tuer-$zielId` umgestellt (`:343`) und die Marke im Stadtbereich gesetzt (`:348-349`). Die Haustür der Stadt zeigt auf die Marke `t` des Innenraums (`:355-356`). Alle 42 Vorlagen haben eine Marke `t` (Dart-Ausgabe, Feld `marken`).
- Gegenstück ohne Überschreiben: `baueMarktplatz` in `oberstadt.dart:30-43` nennt 12 feste Innenraum-IDs (`innen:`). Dieser Pfad läuft nur ohne `haeuser` (`burg.dart:241-247`) und lässt die IDs unverändert. Die Laufzeit nutzt `haeuser` (`burgstadt_spiel_io.dart:26-32`); dort ersetzt der Generator den Marktplatz (`burg.dart:227`).

## 5. Gangnetz (Stadt-Anbindung)

- Erzeugung in `stadtgenerator.dart:424-480`: Gitter 120×80 (`:432`), Hauptgang Zeilen 38–41 (`:444`), Kammern (`:445-448`), 5 Abgänge (`:425-431`).
- Abgang in der Stadt: `Kellerabgang zu den Gewölbegängen` mit ziel `gaenge`, Marke `abgang-k` (`:455-459`). Treppe im Gang: ziel `stadt`, Marke `gang-k` (`:460-463`). Alle 5 Abgänge sind platziert.
- `gaenge` ist ein fester Bereich mit der ID `gaenge` (`:465-466`). Es gibt keine Vorlage und kein Überschreiben.

## 6. SELBSTPRÜFUNG

Pflicht-Suchmuster, je Muster einzeln gesucht (Trefferzahl):

| Muster | Fundstelle | Trefferzahl |
|---|---|---|
| `"form"` | haeuser.json / fallorte.json | 203 / 71 |
| `"art": "objekt"` | haeuser.json / fallorte.json | 203 / 59 |
| `"art": "station"` | haeuser.json / fallorte.json | 0 / 12 |
| `"art": "tuer"` | haeuser.json / fallorte.json | 30 / 12 |
| `"ziel": "stadt"` | haeuser.json / fallorte.json | 30 / 12 |
| `"id": "innen-` | haeuser.json / fallorte.json | 30 / 12 (zusammen 42) |
| `"marken"` | haeuser.json / fallorte.json | 0 / 0 |
| `"raumHoehe"` | haeuser.json / fallorte.json | 30 / 12 |
| `fenster` (ohne Groß-/Kleinschreibung) | haeuser.json / fallorte.json | 4 / 2: Textur `fensterDunkel` an Vitrinen und Spiegeln (Objekte), `Fensterbank` nur als Name einer Bank (haeuser.json:379); keine Fenster-Kachel |
| `switch (l.form)` | welt_geometrie.dart | 1 (Zeile 250) |
| `case '` | welt_geometrie.dart | 5 (251, 256, 261, 263, 274) |
| `default:` | welt_geometrie.dart | 1 (Zeile 278) |
| `form` | burg.dart | 5 Zeilen (10, 11, 13, 14, 205) |
| `form: '` | stadtgenerator.dart / oberstadt.dart / burg.dart | 7 / 3 / 1 |
| `gaenge` | stadtgenerator.dart | 9 Zeilen (Bereichs-ID :466) |
| `innen-` | stadtgenerator.dart | 21 Zeilen |
| `innen: '` | oberstadt.dart | 12 |
| `betretbar` | stadtgenerator.dart | 1 (Zeile 330) |
| `enum KachelArt` | bereich.dart | 1 (Zeile 10) |

Weitere Prüfungen:
- Vorlagen je Datei: haeuser.json 30, fallorte.json 12, zusammen 42. Dart-Ladung ebenfalls 42, IDs eindeutig.
- `Welt.pruefe()` nach dem Aufbau: 0 Fehler.
- Gegenprobe in Python (`pruefe_wand.py`) zu allen 42 Vorlagen: Wandkanten gesamt, frei und Möbel-Dinge stimmen mit der Dart-Ausgabe überein.
- Stichprobe von 5 Zeilen (Abschnitt 2) gegen die Quellen nachgelesen.
- Skripte (nur im Scratch-Ordner): `/tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/kund05/zaehle.dart` (Lauf: `/opt/flutter/bin/dart --packages=packages/burgstadt_core/.dart_tool/package_config.json zaehle.dart`, Ausgabe `ausgabe.txt`), `pruefe_wand.py` (Ausgabe `gegenprobe.tsv`), `baue_md.py` (dieses Dokument).
- Repo: Nur diese Datei geschrieben. Vorhandene Änderungen anderer Stränge (u. a. `zufall.dart`, `layout_pruefsumme.dart`) nicht angefasst. Keine Tests ausgeführt, nichts committet, nichts gepusht.

## 7. OFFENE FRAGEN

1. **Definition „freie Wandlänge“**: gewählt ist die 4er-Nachbarschaft. Belegt heißt: Tür oder Objekt liegt direkt an der Wandkachel (z. B. die Notleuchte in der Wandreihe, `uhrturm` Kachel (13,5)). Mit 8er-Nachbarschaft fielen die Werte niedriger aus. Bitte festlegen.
2. **H-159 ohne Innenraum**: der betretbare Laden im Burgberg bekommt keinen Fußabdruck, weil der Generator bei H-158 abbricht (`stadtgenerator.dart:373`). Ist das gewollt? Der Stadttest verlangt ≥ 40 Innenräume (`packages/burgstadt_core/test/stadt_test.dart:27`); erzeugt werden 53.
3. **Ungenutzte Vorlagen**: 8 Vorlagen werden nie erzeugt (innen-wohnstube-7 bis -10, innen-zunftstube-1 bis -4). Die Zunftstube-Vorlagen sind dadurch ohne Verwendung. Gewollt?
4. **Raumart `innen-speicher-4`**: id-Präfix „speicher“, Name „Gewölbekeller“, Legende mit `Zisterne` (form brunnen). Bitte als Speicher oder Gewölbe führen.
5. **Ergänzt, nicht im Auftrag**: Wehrgang (`burg.dart:154`, innen false) und die Häuserliste `stadt/haeuser.json` sind aufgenommen. Der Marktplatz `stadt` (`oberstadt.dart:16`) ist nicht in der Tabelle; im Laufzeitpfad wird er durch die Oberstadt ersetzt.
6. **Fenster**: In keinem Innenraum gibt es eine Fenster-Kachel oder -Form. Außenfenster existieren nur am Giebelhaus (`welt_geometrie.dart:61-83`). Sollen Innenräume Fenster bekommen?
7. **Möbel-Zählung**: gezählt werden Dinge (Rechtecke), nicht Möbelstücke. Eine L-förmige Gruppe zählt mehrfach (hof `turm×3`). Soll künftig nach Legende-Fläche gezählt werden?
8. **Stationen mit form `boden`** (12 in Daten, 5 in burg.dart) werden nicht gezeichnet (`welt_geometrie.dart:238`); `raureif` ist nur ein Bodenbelag. Ist das gewollt?

ENDE PAKET P0-KUND-05
