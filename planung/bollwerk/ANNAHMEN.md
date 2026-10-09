# ANNAHMEN · BOLLWERK (kippbar mit „A<n>: …“ über STEUERUNG.md)

Format: Entscheidung · Standard · Folge, wenn der Nutzer sie kippt.

| Nr | Entscheidung | Standard | Folge beim Kippen |
|---|---|---|---|
| A-01 | Design-Richtung | Beste Richtung aus der Design-Probe: R1 „weicher Nebelsaum + warmes Handylicht“ vor R2 „Staub im Licht“ (beide als Bogen `bilder/meta/m3-design-*.jpg`; Unterschied in der Probe noch gering, ΔE-Mittel ≤ 0,2) | Reihenfolge in BW3 tauscht; beide bleiben Kandidaten |
| A-02 | Lichtzustand der Runden | Kanon (Strom an ab 00:00, Kerzen aus, Handy-Licht) | Stromausfall-Look nur hinter Schalter |
| A-03 | Würfel und Kanon-Punkte | Würfel kostet nie Kanon-Punkte | bräche F-06 und §7.7; wird nicht umgesetzt ohne neuen Kanon |
| A-04 | neue Fälle | nur Schichten, keine neuen Fälle oder Täterpfade | eigener Lauf nötig |
| A-05 | Spieldauern | Abend Median ≤ 150 min, Runde am Gerät Median ≤ 6 min | Bänder in L4 ändern; Umfang zählt weiter nur ohne längere Abende |
| A-06 | Joystick | im Partymodus aus, sonst unverändert | Joystick bleibt als Zusatz im Partymodus |
| A-07 | WLAN-Host | Gerät des Detektivs | anderer Host wählbar; Geheimnisschutz neu prüfen |
| A-08 | Musik | keine | Musik-Erzeuger in `tool/ton/` (≤ 3 MB) |
| A-09 | Gewichte | g = 3, 2, 1, 1, 2 für X1, X2, X3, X4, X6 (X5 Pflichtziel) | U neu rechnen; Basis bleibt |
| A-10 | Design und Umfang | gleichrangig, Wellen abwechselnd | Reihenfolge der Wellen |
| A-11 | Zwischenziel je Nacht | ja, je Achse in Einheiten (PLAN §4) | nur Gesamtziel |
| A-12 | HD-Linie `caf1d61` | nur mergen, wenn die Burgstadt-Bilder bytegleich bleiben; sonst zurückgestellt bis „A12: ja“ | Merge mit sichtbarer Burgstadt-Änderung |
| A-13 | Sperrdatei mit Verboten (`.claude/settings.json`, nur `permissions.deny`) | keine; Werkzeugverbot über ToolSearch-Verbot und Audit (0 Verstöße in 32 Agenten nach Einführung) | Leitstand legt sie auf `bollwerk` an; technische Sperre statt Prompt-Regel |
| A-14 | Lösbarkeit | würfelbezogen: Faktenstand beim Öffnen = Lauf ohne Würfel; bei bestem Spiel jedes Kettenglied aufgedeckt (Kanon deckt `fakt:`-Glieder nur über die richtige Option auf) | „jedes Glied immer“ ginge nur mit Kanon-Änderung |
| A-15 | Befragen und Würfel | Befragen würfelt nie; nur Suchen | Würfel bei Befragungen nur, wenn er für alle Optionen einer Entscheidung gleich fällt (sonst Pfad-Leck) |
| A-16 | Helfer-Fachgebiete | kein Modifikator (läge auf falschen Karten) | Helfer nur als Darstellung |
| A-17 | Würfelschwellen | 2W6+Mod, 9 / 7–8 / ≤ 6; Bilderwürfel Gespenst/Handy/Lupe als Darstellung | andere Schwellen nur im Band (L4 prüft) |
| A-18 | Zählweise Wurfanteil | beide Lesarten im Band (alle Züge 38,6 %; ohne besetzte Befragungen 38,5–50,3 %) | – |
| A-19 | Umfangsachsen | Mindestbasis X4 = 10, X6 = 5; X5 Pflichtziel ≥ 14 statt Indexachse | Rohbasis würde X4 bei 300 Gags auf 100× treiben |
| A-20 | Zielfaktor | F = 10; realistische Prognose U 8,5–11 nach 6–7 Hauptlauf-Nächten | höheres F nur per STEUERUNG nach oben |
| A-21 | Partie-Überschneidung | Warnschwelle Jaccard-Median ≤ 0,45 | nur berichtet |
| A-22 | Bot-Anklagequote | Zielband 25–60 % für einfache Detektiv-Bots | nur berichtet; Lösbarkeit bleibt Beweis |
| A-23 | Weißliste | neutrale Bonus-Sätze und Lacher 20:15 heraus (Entwurf D); `spur_stirnlampe` als Kandidat | L-4 prüft am Kanon |
| A-24 | Generationsform | eine Generation je Nacht (≤ 12 h); Startnachricht verweist auf die Datei statt den Text mitzuschicken | Text in der Nachricht, wenn 60 KiB belegt ist |
| A-25 | Pech-Szenen an Bogentür und Rüstung | entfallen (Spurenträger, Bund-Versteck) | nur mit Kanon-Prüfung |
| A-26 | X2 zählt Stufentexte mit | X2 misst Lesebreite: alle Texte der Schicht, auch Stufentexte von X1-Einheiten (Basis zählt symmetrisch); Morgenbericht zeigt zusätzlich U_streng ohne sie (Skeptiker-Befund ROT-1b#2: Doppelzählung) | X2 nur eigenständige Texte; Planziel neu rechnen (U sinkt bei gleicher Arbeit, mehr Erzähltexte nötig) |
