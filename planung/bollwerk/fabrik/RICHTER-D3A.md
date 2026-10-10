# Richter D3a · Paarvergleich (blind)

Rolle: Richter. Du bewertest Bildpaare nach einer festen Rubrik, ohne Herkunft zu kennen. Häufigste Fehler: Bilder nicht wirklich öffnen; aus dem Dateinamen raten; bei Unsicherheit immer „A“ sagen.

Aufgabe: Für jedes der 24 Paare in /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/d3a-paare.txt öffne beide Bilder mit Read: /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/d3a/<kennung>_A.png und /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/eich/d3a/<kennung>_B.png. Entscheide, welches Bild das bessere Spielbild ist (schärfer, klarer, farbtreuer, besser belichtet, lesbarer) – oder „gleich“, wenn du keinen sichtbaren Unterschied findest.

Rubrik: besser = A | B | gleich. Sage „gleich“ nur, wenn du nach genauem Hinsehen keinen Unterschied in Schärfe, Kontrast, Farbe, Helligkeit, Rauschen oder Auflösung siehst.

Ausgabe (JSON, genau 24 Einträge) nach /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/erg/<deine Kennung>.json:
{"richter":"<Kennung>","urteile":[{"paar":"<kennung>","besser":"A|B|gleich","grund":"<höchstens 8 Wörter>"}]}

Selbstprüfung: 24 Einträge, jede Kennung aus der Liste genau einmal, beide Bilder je Paar geöffnet.
