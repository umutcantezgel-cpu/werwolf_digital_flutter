ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (7/7b getrennt: bei offenem Vorschlag ist niemand ansprechbar, gewollt; Ort test/party_widgets richtig)

# Bericht F4-TEST-02

## Ergebnis F4-TEST-02
- DATEIEN: `/home/user/werwolf_digital_flutter/test/party_widgets/karte_pfadgleich_test.dart` (neu, 187 Zeilen; der Stub existierte nicht). `git status` zeigt von mir nur diese Datei.
- UMGESETZT:
  1. Momentaufnahme in `_momentaufnahme`: Hotspots sortiert, NPC-Positionen, Licht (dunkel, taschenlampe, sortierte helleRaeume, Punkte mit `toARGB32`), `npcAktion` und `hotspotAktion` (alle Kennungen aus `sitzung.daten.szenario.hotspots`), `sichtbareRaeume` an allen Figurenorten, Kamera, Hervorhebung und `detektivAussehen` (coat, skin, hair, hat). Ergänzt um Stelle und laufende Entscheidung, beides pfadunabhängig.
  2. Spielverlauf in `_spieleEntscheidungen` und `_verlauf`: je Pfad neun Entscheidungen mit je drei Stellen (vor Vorschlag, mit Vorschlag, nach Bestätigung), also 27 Momentaufnahmen. Rundenwechsel über `spieleBis(..., runde: r)`. Feste Optionen in `_festeWahl`: erste bzw. letzte Option des Kanons.
  3. Tests 1 bis 6 in `main()`: n in {4, 12, 20} (Minimum, Mitte, Maximum) mal beide Optionslisten. Geprüft wird die Gleichheit aller vier Pfade an jeder der 27 Stellen. Zusätzlich prüft der Test, dass Licht, Figuren und Hotspots nicht leer verglichen werden.
  4. Test 7: Vor dem Vorschlag liefert jedes Ziel der laufenden Entscheidung einen nicht leeren Text, alle anderen Personen liefern `null`. Gezählt wird, dass jedes Ziel als ansprechbare Figur auf der Karte steht.
  5. Test 8: In Runde 2 (e2_1, Ascheneimer) steht der Hotspot vor dem Bestätigen auf `open` und danach auf `searched`, für alle vier Pfade.
  6. Test 9 (Gegenprobe): Rückblende für ahmet und can nach 300 ms. Kamera und Hervorhebung müssen sich unterscheiden. Das Ergebnis ist deterministisch, weil sich die Hervorhebung immer unterscheidet. Die Wartezeit ist die einzige Zeitabhängigkeit.
  7. Jede Session hat `addTearDown(k.dispose)`. Keine Zufallszahlen. Zusatz 7b: Während ein Vorschlag offen ist, ist niemand ansprechbar.
- TESTS: 10 (6 Vergleichstests, 7, 7b, 8, 9). Letzte Zeile: `00:01 +10: All tests passed!` (Laufzeit etwa 5,6 s).
- ANALYSE: `No issues found! (ran in 4.7s)`
- ROT-PROBEN (nur in der eigenen Datei; danach per `cmp` gegen die Sicherung zurückgespielt; `lib/` blieb unverändert, da andere Agenten parallel arbeiten):
  - A: Licht zeigt den Täterort (E-008-Verletzung): Tests 1 bis 6 rot, 7, 7b, 8, 9 grün.
  - B: Jede Person ist ansprechbar (`npcAktion` liefert „Befragen“): 7 und 7b rot (erwartet `null`, ist „Befragen“), Rest grün.
  - C: Bestätigung unterdrückt (`verwerfen` statt `bestaetigen`): 8 rot (erwartet `searched`, ist `open`).
  - D: Gegenprobe mit zwei gleichen Pfaden (ahmet/ahmet): 9 rot.

## OFFENE FRAGEN
- Test 7 in der Vorgabe („vor dem Bestätigen … Ziele … nicht leerer Text“) passt nur ohne offenen Vorschlag. Bei offenem Vorschlag liefert `npcAktion` in `lib/party/karte_session.dart` für alle Personen `null` (`sitzung.vorschlag != null`). Ich habe beide Zustände getrennt geprüft (7 und 7b). Bitte bestätigen, dass das so gewollt ist.
- Der Ort weicht ab: `planung/finalisierung-schlosskeller/PLAN.md` nennt `test/party/karte_pfadgleich_test.dart`, der Auftrag `test/party_widgets/karte_pfadgleich_test.dart`. Ich habe den Auftragsort genommen.

=== ENDE F4-TEST-02 · BEREIT ZUR RÜCKGABE ===
