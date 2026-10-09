ABNAHME F3-BAUMEISTER-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-027)

# Bericht F3-BAUMEISTER-01

## Ergebnis F3-BAUMEISTER-01
- Geänderte Dateien (alle neu, sonst nichts angefasst; Barrel-Export nicht gemacht):
  - `/home/user/werwolf_digital_flutter/content/party/textregeln.json`
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/textpruefer.dart`
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/bin/party_texte.dart`
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/textpruefer_test.dart`
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/textlint_test.dart`
- Analyse: `No issues found!` (dart analyze lib bin test)
- Tests: `00:00 +30: All tests passed!` (die zwei Textdateien); gesamte Paketsuite: `00:11 +201: All tests passed!`
- Rot-Proben: je Regel in einer Kopie im Scratchpad abgeschaltet (Sitzungsregel statt System-Temp), Tests liefen rot, Kopie danach wiederhergestellt, Repo unverändert.
  - Satzlänge: 1 Test rot (25/26-Wort-Grenze)
  - Mittelwert: 1 (14/15-Grenze)
  - Fachwort: 1
  - Alkohol: 2 (Wortanfang; Kater nur als Katze)
  - Drogen: 1 (nur ganze Wörter)
  - Rauchen: 3 (ganze Wörter; Rauch/Qualm nur im Kamin; Kamin-Ausnahme gilt nicht fürs Rauchen)
  - Ausnahmen gesamt: 4
  - Abkürzungen (Vorlesen): 2
  - Klammern (Vorlesen): 1
  - Ziffern (Vorlesen): 1
  - Satztrennung: 2 (Abkürzungen und Anführung; Auslassungspunkte)
  - Uhrzeit (Textlint): 2
  - Raumwort (Textlint): 2
  - Altname (Textlint): 1
- CLI auf dem heutigen Korpus (Stand 14:09:33): 372 geprüfte Texte, 8 Befunde, Exitcode 1. F3-AUTOR schreibt parallel in `texte/` (zuletzt `dossiers-b1`, `dossiers-b2`, `taeter-ahmet`, `taeter-fatma`), deshalb am Tor neu laufen lassen. Alle Bereichsmittel liegen unter 14 Wörtern je Satz.
  - `gegenstaende.json#spur_notiz_fehlende.zeigt` | Satzlänge | 29 Wörter (höchstens 25)
  - `texte/dossiers-b1.json#dossier.olli.weiss[0]` | Raumwort | „Turm“
  - `texte/dossiers-b1.json#dossier.can.wer` | Raumwort | „Gang“ (hier „federnden Gang“, also Gangart)
  - `texte/dossiers-b1.json#dossier.can.verbirgt[1]` | Raumwort | „Turm“
  - `beobachtungen.json#b_wojtek_vorbei` | Raumwort | „Turm“
  - `entscheidungen.json#e3_1.begruendung.can` | Raumwort | „Turm“
  - `figuren.json#luege_can_toilette.behauptung` | Raumwort | „Turm“
  - `figuren.json#luege_can_toilette.wahrheit` | Raumwort | „Turm“
- Zusatzdiagnose außerhalb des Umfangs (nicht im Gate, im Scratchpad ermittelt): 101 Texte, 16 Befunde (1 Satzlänge, 15 Raumwort), siehe OFFENE FRAGEN 4 und 5.

## OFFENE FRAGEN
1. **Schnittstelle `textLint`:** Die Signatur lautet `textLint(kanon, quellen, {required regeln})` und nicht mit zwei Parametern. Grund: `raumwortEndungen` und `raumAusnahmen` liegen in `textregeln.json`, nicht im Kanon. `TextQuelle` und `TextBefund` haben benannte Konstruktorparameter. Alle übrigen Signaturen entsprechen dem Auftrag. Bitte bestätigen oder den Kanon-Lader um `textregeln.json` erweitern; das ist nicht meine Datei.
2. **„Turm“ als Ortsangabe:** Sechs Stellen in Kanon und Texten nennen „Turm“ als Ort („in den Turm“, „auf der Toilette im Turm“). Entscheidung nötig: Autoren schreiben „Turmgang“ oder „Toilette oben“ um, oder „Turm“ wird Ausnahme. Ich habe keine Ausnahme ergänzt.
3. **Meine Vorschläge in `textregeln.json`, bitte bestätigen:**
   - `raumAusnahmen`: Keller, Schlosskeller, Gewölbekeller und Schlossturm (Schauplatz in `setting.json`) sowie Schlosshof (Außenort, Entscheidungen B-07 und A-04).
   - `ausnahmen` als Fehlalarme des Alkoholstamms: alkoholfrei, weinrot, bargeld, weinen, weint, weiner, baran (Figur), barsch, bart, barfuß, barriere, barock, baron, fasse, fasst, fassung, fassade, sektor, sekte, sektion, bierernst, katerchen.
   - Kontext-Ausnahmen in der Form `wort:kontext` (das ganze Wort, mit Kontextwort im selben Satz): `kater:katze`, `rauch:kamin`, `qualm:kamin` und Zusammensetzungen mit Kamin. Ohne diese Form ließe sich §6 („Kater nur die Katze“, „Rauch nur Kamin“) nicht prüfen. Die Form ist meine Festlegung innerhalb der Schnittstelle.
4. **Raumwortregel trifft Gemeinwörter:** Gang (Gangart), Zugang, Eingang, Raum, Vorraum, Gemeinschaftssaal, Gewölbesaal. Umformulieren oder die Liste ergänzen? Die letzten fünf stehen in `raeume.json`-Beschreibungen, außerhalb des Umfangs.
5. **Umfang:** Der Auftrag nennt die Kanon-Felder. Nicht geprüft werden u. a. `figuren.*.motiveAndConflict`, `blackoutAlibi`, `roleSecret`, `innocentProfile`, `killerProfile`, `detektiv.auftrag`, `detektiv.tatnacht`, `opfer.*`, `gegenstaende.beschreibung` und `raeume.beschreibung`. Die Diagnose fand dort Befunde, z. B. „Turm“ in `figuren.json#olli.motiveAndConflict` und `figuren.json#can.blackoutAlibi`. Umfang erweitern?
6. **Nicht umgesetzt:** §6 verlangt „alkoholfrei“ beim ersten Nennen von Apfelpunsch je Text. Das ist eine Regel über mehrere Sätze und stand nicht im Auftrag. Ebenfalls nicht automatisierbar: §3, §7 und §10 (Sensibilitätsleser). In Vorlesetexten erkennt der Prüfer Ziffern, aber kein Eurozeichen ohne Ziffer.
7. **Fachwörter:** „Sicherungsautomat“ → „Sicherung“ und „FI-Schalter“ → „Hauptsicherung“, da die Tabelle beide Ersätze gemeinsam nennt. „Bar“ erzeugt zwei Befunde (Fachwort und Alkohol) und trifft auch das Adjektiv „bar bezahlt“. Bitte bestätigen.
8. **Stand des Korpus:** Die CLI-Zahlen sind ein Schnappschuss um 14:09:33 und ändern sich mit den parallelen Textarbeiten.
9. **Verweise:** `ref`-Punkte in Dossiers und Täterfassungen löse ich nicht auf. Die Kanon-Felder werden direkt geprüft, damit nichts doppelt gezählt wird.

=== ENDE F3-BAUMEISTER-01 · BEREIT ZUR RÜCKGABE ===
