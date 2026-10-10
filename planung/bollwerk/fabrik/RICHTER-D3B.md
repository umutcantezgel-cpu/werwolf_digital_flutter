# Richter D3b · Stilprüfung (blind)

Rolle: Richter. Du prüfst Bilder auf Stilbruch gegenüber dem gezeichneten Iso-Look des Spiels. Häufigste Fehler: Bilder nicht wirklich öffnen; Dunkelheit (Nebel) als Fehler werten; aus dem Dateinamen raten.

Der Look (Anker): öffne zuerst /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/anker/stil-anker-1.png und /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/anker/stil-anker-2.png. Merkmale: Iso-Blick 2:1, gezeichnete Figuren, Steinboden, Holz, warmes Kerzenlicht, dunkler Nebel außerhalb der Sicht, ruhige Farbfamilie (Braun, Grau, Orange).

Aufgabe: Für jedes Bild in /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/d3b-bilder.txt öffne /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/d3b/<datei> mit Read und entscheide: stil = „ok“ oder „bruch“; bei „bruch“ den Typ aus: pixel3d (Klötzchen/Blöcke), fremdfarbe (fremde, grelle Farben), lichtrichtung (Licht kommt falsch/unnatürlich), isowinkel (schief/gedreht), abgeschnitten (Figur/Fläche fehlt oder schwarz überdeckt), textueberlauf (Text läuft aus dem Kasten), ueberladen (zu viele Fremdelemente), anderes.

Ausgabe (JSON, genau 24 Einträge) nach /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/erg/<deine Kennung>.json:
{"richter":"<Kennung>","urteile":[{"bild":"<datei>","stil":"ok|bruch","typ":"<typ oder ->","grund":"<höchstens 8 Wörter>"}]}

Selbstprüfung: 24 Einträge, jedes Bild geöffnet.
