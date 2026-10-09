ABNAHME F3-BAUMEISTER-02 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 1 · Inhalt 1 · Grenzen 2 · Summe 8/10 · Farbe und Farbname durch ORCH korrigiert (E-028)

# Bericht F3-BAUMEISTER-02

## Ergebnis F3-BAUMEISTER-02
- Geänderte Dateien (alle neu, keine fremden Dateien berührt):
  - /home/user/werwolf_digital_flutter/content/party/farbnamen.json
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/bildprompts.json (erzeugt)
  - /home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/bildprompts.dart
  - /home/user/werwolf_digital_flutter/packages/mordakte_core/bin/party_prompts.dart
  - /home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/bildprompt_test.dart
- Analyse: No issues found!
- Tests: 00:00 +10: All tests passed!
- Zahl der Prompts: 23 / 7 / 12 (Personen / Räume / Beweise, gesamt 42). Personen: 22 Figuren, der Detektiv zweimal (m und w).
- Beispielprompt (Schneider):

> cinematic documentary film still, 35mm, natural dramatic lighting, real-life texture, no CGI, no cartoon. portrait of an early-sixties man, thin grey hair with a bald patch, broad build, wearing waxed jacket over coarse grey roll-neck sweater, sturdy work boots in dark green, glasses, large jangling bunch of keys on right belt loop, clipboard with receipt pad, broad, slightly stooped, tapping his wristwatch, in a vaulted castle cellar at night, warm candle light. no text, no letters, no logos, no brand names, no real people, no celebrities, no alcohol, no wine, no beer, no bottles, no bar counter, no barrels, no cigarettes, no smoke from pipes, no vape, no blood, no injuries

## OFFENE FRAGEN
1. **Farbtabelle nicht aus JSON geladen.** Die Signatur `bildprompts(kanon, bild)` hat keinen Zugang zu `content/party/farbnamen.json`. Der Kanon lädt nur Falldateien, und `lib` bleibt ohne `dart:io`. Umgesetzt: Konstante `farbnamenTabelle` in `bildprompts.dart` als Spiegel der JSON-Datei; der Test prüft die Gleichheit. Entscheidung nötig: Tabelle aus der JSON-Datei laden (dann zusätzlicher Parameter oder zweiter Leser für `content/party/`) oder die Konstante behalten.
2. **Textregeln gegen feste Negativliste.** Die Negativliste enthält „no bar counter“ und „no vape“. „bar“ und „vape“ stehen in `textregeln.json` unter verboten. Umgesetzt: Die Verbotsprüfung läuft nur am Motiv; Stilanker und Negativliste sind ausgenommen, die Negativliste bleibt wortgleich. Entscheidung: bestätigen oder für englische Prompts eine eigene Liste anlegen.
3. **Widerspruch in bild.json (Tim).** Die Kleidung lautet „black checked flannel shirt“, `colorCode` #992222 („Karorot“) wird zu „in dark red“. Der Prompt enthält beides im selben Satz. bild.json ist nicht geändert. Entscheidung: „red checked“ in bild.json oder die Farbe prüfen.
4. **Kopfhörer bei Baran.** bild.json beschreibt „large headphones on his head“, `look.kopf` ist „none“. Der Prompt übernimmt die Kopfhörer aus bild.json. Entscheidung: ob der Kanon Kopfhörer im `look` führen soll.
5. **Barrel-Export fehlt.** `bildprompts.dart` ist noch nicht in `mordakte_core.dart` exportiert. CLI und Test importieren `src/party/bildprompts.dart` direkt. Orchestrator: `export 'src/party/bildprompts.dart';`.

Hinweise (keine Fragen):
- Spuren: bild.json deckt genau die 12 Beweisspuren des Kanons ab (Rollen schluesselbeweis, fundort, zusatzindiz). Die 24 übrigen Spuren aus gegenstaende.json haben keinen Bildprompt.
- Detektiv: figuren.json hat kein `age`, „late twenties“ kommt aus bild.json. Für alle anderen prüft der Test, dass bild.json und `age` übereinstimmen.
- Abweichungen von der Vorlage: Artikel „an“ vor Vokal („an early-sixties man“), Alter mit Bindestrich („late-twenties“). `<kopf>` kommt aus bild.json; der Test prüft, dass der Begriff aus `look.kopf` (headscarf, hat, cap, bun) im Prompt steht. Farbabstand: CIEDE2000 (`deltaE2000Lab`) auf den Werten von `labAusHex`.
- Rot-Probe: Der Test mit `BILD_JSON=<Kopie>` gegen eine Kopie der bild.json mit gekürzter Negativliste ist rot (Stil-, Textregel- und Aktualitätstest schlagen an). Die Repo-bild.json ist unverändert.
- CLI: `dart run bin/party_prompts.dart` schreibt die Datei, `--pruefen` vergleicht. Ergebnis: „Bildprompts: aktuell (42 Prompts)“, Exitcode 0.

=== ENDE F3-BAUMEISTER-02 · BEREIT ZUR RÜCKGABE ===
