ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (ORCH: „Gespräch mit: {name}“, Sabotage-Beschriftung verständlicher)

# Bericht F4-BAUMEISTER-02

## Ergebnis F4-BAUMEISTER-02
- DATEIEN:
  - `lib/party/bildschirme/rollen.dart`: 310 Zeilen (Stub ersetzt)
  - `content/party/schlosskeller/texte/ui-rollen.json`: 107 Zeilen
  - `test/party_widgets/rollen_test.dart`: 187 Zeilen (neu)
- UMGESETZT:
  - 1. `RollenBildschirm` ist ein StatefulWidget mit gleicher Schnittstelle. Gesehene Rollen stehen lokal in `_gesehen` (rollen.dart).
  - 2. Neutrale Ansicht mit Erklärung und Liste über `_RollenZeile` (Farbpunkt, Spielername, Figur · Titel, Häkchen). Ein Tipp öffnet `_zwischenstufe`. `zeigeVerdeckt` wird erst beim Knopf aufgerufen.
  - 3. Verdeckte Ansicht `_verdeckt`: alle Abschnitte. Pflichtgespräche und Rundenwahl je Runde, Sabotage nur wenn vorhanden, Lügen als Behauptung und Wahrheit (`_zeile`).
  - 4. `_taeterTafel` nur bei `istTaeter` mit Tarnung, Akzent Keller.gefahr. Für andere Rollen kein Platzhalter.
  - 5. Fuß „Fertig, Bildschirm zudecken“ (`_schliessen`): verdecken, Häkchen setzen, Meldung 4 Sekunden. Der Timer wird in `dispose` abgebrochen.
  - 6. Weiter „Alle kennen ihre Rolle“ in den Aktionen der neutralen Ansicht, immer aktiv, ruft `weiter()`.
  - 7. `ui-rollen.json` mit 25 Bausteinen. Vorhandene `ui.allgemein.*` und `ui.verdeckt.*` werden wiederverwendet.
  - 8. 17 Tests, darunter alle Pflichtfälle aus Schritt 8. Vier davon sind Überlauf-Tests.
  - 9. Testweg grün (Analyse, Tests, Texte, Grep).
  - Abweichung: Das Erzählerfeld aus dem Stub ist entfernt. Im Abschnitt Rollen gibt der Erzähler nichts aus (`sitzung.erzaehler` ist leer), der Intro-Text kommt erst im Intro.
- UI-BAUSTEINE: 25, Präfix `ui.rollen.*`, alle Kennungen eindeutig.
- TESTS: 17. Letzte Zeile von `flutter test test/party_widgets/rollen_test.dart`: `00:04 +17: All tests passed!`
  - Zusätzlich `dart test test/party/texte_test.dart test/party/textpruefer_test.dart`: `All tests passed!`
- ANALYSE: `No issues found! (ran in 6.7s)` für rollen.dart und rollen_test.dart.
- TEXTE: `Texte: OK (1320 Texte)`
- GREP: keine Treffer (Exit 1). Im Code stehen nur Bausteinkennungen, Platzhalternamen, Datenarten wie `'luege'` und der Trenner ` · `.

Selbstprüfung: `git status` zeigt für meine drei Dateien genau die Änderungen. Andere Dateien habe ich nicht angefasst. Der Spoilerschutz ist eingehalten. Neutrale Ansicht und Zwischenstufe zeigen nur Namen und Figuren, die Täter-Tafel erscheint nur in der verdeckten Ansicht.

## OFFENE FRAGEN
- Ton: Der Auftrag sagt „Du-Form an die Gruppe“. TON-LEITFADEN §3 sagt, die Runde heiße „ihr“, und das Dossier spreche die einzelne Person mit „du“ an. Umgesetzt nach §3: Erklärung und Titel sprechen die Gruppe mit „ihr“ an, das Dossier mit „du“. Bitte bestätigen.
- Ohne eingetragenen Namen heißt das Geburtstagskind im Gespräch „Mit Geburtstagskind“ (Baustein `ui.rollen.gespraech_mit`). Das klingt ungrammatisch. Eine Lösung braucht einen eigenen Baustein oder eine Regel in `personAmTisch`. Beides liegt nicht in meinen Dateien, daher nicht geändert.

=== ENDE F4-BAUMEISTER-02 · BEREIT ZUR RÜCKGABE ===
