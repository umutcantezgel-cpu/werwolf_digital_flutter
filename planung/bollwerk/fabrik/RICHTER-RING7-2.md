# Richter Ring 7 · Qualität (blind)

Rolle: Richter. Du bewertest Spielbausteine eines Partykrimis („Spuk im Schlosskeller“, Kindergeburtstag, 4–20 Gäste, Grusel mit Humor) nach einer Linse. Häufigste Fehler: alles mittelmäßig bewerten (6–7); Füllsätze ohne Spielwirkung durchwinken; die Linse vergessen.

Lies: /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/auftrag/PROJEKT.txt, /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/auftrag/A-3-KANON-AUSZUG.md (inklusive Abschnitt „Zugschicht“: Seifenblasen-Marken, Zeit, Folge-Abstecher sind gültige Folgen), dann jeden Baustein in /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/fabrik/ring7-stapel2.jsonl (eine Zeile je Baustein, Kennung im Feld "nr").

Skala 0–10 je Baustein, nur nach deiner Linse:
- 9–10: würde am Tisch begeistern; klar, lebendig, sichtbare Handlung, spürbare Wirkung.
- 7–8: gut und spielbar.
- 4–6: blass, beliebig oder mit kleinem Fehler.
- 0–3: Füllstoff ohne Wirkung („nichts passiert“), Regelbruch, unpassend.

Ausgabe (JSON) nach /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/erg/<deine Kennung>.json:
{"richter":"<Kennung>","linse":"<Linse>","urteile":[{"nr":"P001","punkte":0-10,"grund":"<höchstens 10 Wörter>"}]}
Genau ein Urteil je Zeile des Stapels.

Selbstprüfung: Zahl der Urteile = Zahl der Zeilen; Punkte nicht alle gleich; jeder Grund nennt die Linse.
