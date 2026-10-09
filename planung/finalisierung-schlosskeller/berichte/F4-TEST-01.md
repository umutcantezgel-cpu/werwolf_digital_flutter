ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Ersatzregel D2/D3 bestätigt; Querverweise in D3 nicht nötig)

# Bericht F4-TEST-01

## Ergebnis F4-TEST-01
- DATEIEN:
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/figuren_konsistenz_test.dart` (287 Zeilen, neu). Sonst keine Datei geändert. Rot-Proben laufen über Umgebungsvariablen (`FIGUREN_JSON`, `SZENARIO_JSON`, `TEXTE_ORDNER`, `BILDPROMPTS_JSON`, siehe Dateikopf) auf Kopien unter `/tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f4-test-01/`.
- UMGESETZT:
  1. Renderer: je Person eine Kennung aus `partyNpcKennungen`, genau 21 Einträge. Gruppe „Renderer“: Anzahl, Name, Mantelfarbe, Haut/Haar, Statur/Schnitt, Position (floor).
  2. Detektiv: `renderLook` mit coat = colorCode und `fedora` bei `detektivhut`. Gruppe „Renderer“.
  3. Kopftuch: `headColor` nur bei `kopftuchFarbe`, sonst keine. Gruppe „Renderer“.
  4. Bildprompt: B1 prüft die Signatur exakt an der Kleidung (E-028, `{farbe}` aus bild.json). B2 prüft, dass ein fremder Farbname aus demselben Startraum nur vorkommt, wenn er im Quelltext der Figur steht.
  5. Farbname: C1 nicht leer, C2 verschieden bei anderem colorCode.
  6. Dossier (Ersatzregel, siehe OFFENE FRAGEN): D1 die 20 Rollen haben je genau ein Dossier, D2 jede Dossierrolle hat einen Farbnamen, D3 eindeutige Farbwörter eines Farbnamens stehen in keinem fremden Dossier oder keiner Täterfassung.
- TESTS: 15 (Renderer 8, Bildprompt 2, Farbname 2, Dossier 3). Letzte Zeile von `dart test`: `00:00 +15: All tests passed!` (mordakte_core ist reines Dart).
- ANALYSE: `dart analyze test` im Paket (ganzer Testordner): `No issues found!`
- ROT-PROBEN (Basis ohne Änderung: 15 grün):
  - A, Renderer-Szenario: Name tim, Mantelfarbe murat, Haut johanna, Statur baran, Schnitt dilara, x hakan, headColor von fatma entfernt und bei zeynep gesetzt, Zusatzeintrag. Rot: die sieben Renderer-Tests Anzahl, Name, Mantelfarbe, Haut/Haar, Statur/Schnitt, Position, Kopftuch.
  - C, figuren.json: colorCode olli auf #808080, farbname aylin auf „Türkis“, farbname tugba leer, Detektiv-kopf auf none. Rot: B1, A-Detektiv, C1, C2, D2. Der Renderer-Test Mantelfarbe bleibt grün, weil der Renderer dem geänderten Kanon folgt.
  - D, texte: Tugba-Eintrag aus dossiers-b5 entfernt, Leylas „türkise“ durch „olivgrünen“ ersetzt. Rot: D1 und D3.
  - E, bildprompts.json: „teal“ an den fatma-Prompt angehängt. Rot: B2.
  - Alle 15 Tests sind in mindestens einer Probe rot. Repo unverändert.

## OFFENE FRAGEN
- Stammregel (Schritt 6) ist nicht sauber prüfbar. „schwarz“ und „weiß“ gehören Ahmet und Damir. Emines „schwarze Stiefel“ und Olli's „grauer Kapuzenpulli“ sind Kleidung ohne Bezug zum Farbnamen. Fatmas „roten Wollmantel“ steht zum Farbnamen „Beerenrot“ nur über einen Wortteil. Gewählt wurde die Ersatzregel (D2, D3). D3 erfasst nur eindeutige Farbwörter wie olivgrün oder türkis, nicht Wortteile in Komposita. Bitte bestätigen.
- Querverweise (`ref` auf Beobachtungen, Lügen, Nebendelikte, Spuren, Gegenstände) sind nicht in D3, weil die Aufgabe nur wer, weiss und verbirgt nennt. Ein Scan über 84 Quellen fand keinen Verstoß. Ein Fehlalarm ist „goldgelber Messingabrieb“ in silberring_fatma (Materialfarbe). Aufnehmen?
- B2 erlaubt Farbwörter, die schon im Quelltext der Figur stehen (z. B. „black boots“ bei Emine). Sonst würden Haar- und Kleidungsangaben fälschlich rot.
- B1 ist strenger als der bestehende Test figuren_konsistenz in bildprompt_test.dart, der nur „irgendwo nach wearing“ prüft. Die Verschärfung ist bewusst, damit Rot-Probe C greift. Dadurch gibt es teilweise Überlappung.
- Reine Kanonänderungen lassen die Renderer-Tests grün, das ist gewollt. Abweichungen erkennen B1, C und D.
- Im aktuellen Kanon, Renderer, Bildprompts und Dossiers wurde keine Abweichung gefunden. Andere Dateien im Testordner (dossier_test, spoiler_test, texte_test) sind von anderen Agenten geändert und nicht bewertet.

=== ENDE F4-TEST-01 · BEREIT ZUR RÜCKGABE ===
