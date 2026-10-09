HEAD c54fe9c

# Gegenprüfung Inhalt · gegenpruefer_inhalt_26 · Auftrag A-702t/26

Schwerpunkt: wirksamer Kanon (Punkte 15, 18, 19), Entscheidungslog E23 bis E49 (Punkt 9a), Spieltext-Definition (Punkt 17).

**Urteil:** Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
**Befunde:** hoch 1 · mittel 2 · gering 3

## 1. Stand und Vorgehen

- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` im Worktree, Fast-Forward dc205b0..c54fe9c. `git rev-parse --short HEAD` ergibt c54fe9c. Der Worktree war danach sauber.
- Werkzeuge, alle nur lesend (Ausgaben im Scratchpad-Unterordner gp26):
  - `dart run bin/kanon.dart --wirksam`: 1276 Datensätze, davon 264 mit [O], 559 mit [G], 453 mit [L] und 9 DW-Ergebnisse.
  - `dart run bin/kanon.dart --pruefe`: Original 1211, wirksam 1276 Datensätze (65 neu, 78 geändert, 30 ERSETZE), 0 Befunde in allen Proben.
  - `dart run bin/kanon.dart --diff`: Overlay-Diff, 169 Zeilen.
  - `dart run bin/leitplanken.dart --burgstadt`: 119 Dateien, 0 Treffer. Der Testbefehl mit `dart pub get --offline` lief durch.
  - `git diff 659d3ed HEAD -- krimidinner/spuk-im-gewoelbe/10_kanon/K*.md`: 1175 Zeilen, davon 58 Zeilen mit [O] (alte und neue Fassung); die 29 neuen O-Zeilen wurden gelesen.
- Vollständig gelesen: `nachtlauf/kanon/ANPASSUNG.md` (190 Zeilen), `10_kanon/FORMAT.md`, Entscheidungslog E23 bis E49 (Zeilen 147 bis 563), das Overlay-Diff (169 Zeilen), alle neun DW-Datensätze, alle Färbungszeilen R05 bis R20, die Stamm- und Geheimdaten von R13, R15 und R18, D3-3 sowie die Ortsdatensätze ORT-01 bis ORT-12. Außerdem `packages/burgstadt_spiel/data/texte/erzaehler.json` und `tutorial.json`.
- Stichprobe und Schlüsselwort-Suche: übrige O-Zeilen, übrige G-Zeilen, L-Zeilen (nur auf Widersprüche zu Zeiten, Orten und Pension), `packages/burgstadt_core/data/**` (stadt/bewohner.json, stadt/haeuser.json, innenraeume, rollen/faehigkeiten.json), `packages/pixel_engine/data/figuren/*.json`.
- Nicht gelesen: Prüfberichte anderer Prüfer und der Ordner `nachtlauf/auftraege/A-702/` (außer dem Anlegen dieser einen Berichtsdatei).
- Keine Datenänderung, kein Commit, kein Push, kein Build.

## 2. Befunde

### Befund 1 · hoch · Täterin vor dem Morgengrauen benannt (DW2-3 B, DW3-3 C)

- **Stelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K5-ENTSCHEIDUNGEN-DETEKTIV.md`, Zeile 24 (`@DW2-3 [L]`, Ergebnis B) und Zeile 34 (`@DW3-3 [L]`, Ergebnis C). Im wirksamen Kanon unverändert.
- **Zitat:** DW2-3 B: „Ja, sie hat den Taler in der Hand gehabt … Und wer ihn hatte, hatte einen Grund, ihn heimlich zurückzubringen.“ DW3-3 C: „Merle und Jonas tragen dasselbe Stiefelmodell, aber nur an Merles linkem Absatz fehlt ein Stollen, genau wie im Wachs. Der Abdruck stammt von Merle.“ Die Täterin ist nach `@K-090 [L]` Merle Hartwig (R03). Die richtige Option in D3-3 („mit allen vier Sohlenkarten“) führt zu C.
- **Regel:** Auftrag Punkt 4 (verbindlich): kein Text, der vor der Auflösung die Täterin nahelegt. Die Auflösung ist das Morgengrauen (erzaehler.json: „Jetzt wird aufgelöst …“). Nach Punkt 17 und E47 zählen DW-Ergebnisse zum Spieltext.
- **Begründung:** E27 (M5) nimmt die Leitplanke für „Spuren des Falls“ aus, weil die O-Hinweise das Rätsel selbst sind. Der Auftrag formuliert die Leitplanke aber ohne Ausnahme für Kanon-Texte. Die beiden Ergebnisse sind keine Spuren, sondern Feststellungen über die Täterin: Besitz des Talers mit Rückgabemotiv und Herkunft des Abdrucks am Tatort. Sie erscheinen in Phase 2 bzw. 3, also vor dem Morgengrauen. E47 hat die DW-Ergebnisse später zum Spieltext erklärt, ohne sie gegen diese Leitplanke zu prüfen. Das ist ein neuer Grund gegen die Abwägung in 9a.
- **Vorschlag:** Die Zuordnung zu einer Person der Auflösung (K6) vorbehalten. In Phase 2 und 3 die Spur nur bestätigen, aber weder Taler-Besitz mit Motiv noch Namen der Abdruck-Eigentümerin nennen. Bei DW3-3 C etwa: „Der Abdruck passt zu einem der Stiefelmodelle.“

### Befund 2 · mittel · Kanontreu · Übernachtung der Clique in der Pension widerspricht K-010

- **Stelle:** `nachtlauf/kanon/ANPASSUNG.md`, Zeile 67 (`@ORT-03 [O]`, „Rolle im Fall: Farbe (Übernachtung der Clique …)“) und Zeile 136 (`@HW-S06 [L]`, „Die Pension „Zum Uhrturm“ ist die Übernachtung der Clique (ORT-03) …“).
- **Zitat der Gegenstelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md`, Zeile 64 (`@K-010 [O]`): „In der Burg sind in dieser Nacht nur die Festgesellschaft (alle besetzten Rollen und das Geburtstagskind) und der Burgwart.“ Ergänzend OA-25 und STADT-03: Ohne Bund kommt niemand aus Burg oder Oberstadt.
- **Regel:** Maßstab Kanon sind die O-Zeilen (Auftrag Punkt 5). Die O-Zeilen müssen untereinander widerspruchsfrei sein.
- **Begründung:** E47 („Bewusst so“) begründet die Pension mit „K-010 betrifft die Burg; die Pension liegt in der Stadt.“ Das trägt nicht: K-010 verortet die Festgesellschaft in dieser Nacht in der Burg. Eine Übernachtung der Clique in der Pension widerspricht dem. Neuer Grund gegen 9a (E47).
- **Vorschlag:** „Übernachtung der Clique“ in ORT-03 und HW-S06 streichen. Die Pension bleibt Ortsfarbe über H-S05 (Wäschebuch) und H-S06.

### Befund 3 · mittel · Leitplanke 4 · Geld- und Kälte-Färbung bei R13 und R15

- **Stelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md`, Zeile 9 (R13-GEHEIM) und Zeile 27 (R15-GEHEIM). Im wirksamen Kanon durch ERSETZE-27 und ERSETZE-28 (`ANPASSUNG.md`, Abschnitt Begriffsersetzungen) geändert.
- **Zitat (wirksam):** R13-GEHEIM: „Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“ R15-GEHEIM: „Sie redet ständig über Geld, Schäden und Versicherungen, sogar über Kunibert, und wirkt dabei seltsam ungerührt.“
- **Kontext:** R13 heißt Selin Aksoy (Bankkauffrau, Beraterin für Privatkredite), R15 heißt Derya Öztürk (Versicherungskauffrau im Außendienst); Zeilen 7 und 25 derselben Quelle. Keine andere Färbung verbindet bei der Figur selbst Geld mit Geldgier oder Kälte.
- **Regel:** Leitplanke 4: keine Klischees über irgendeine Gruppe. E47 benennt genau diese Kombination als bekanntes Klischee („Geldgier und Kälte“ bei türkischstämmigen Frauen in Finanzberufen).
- **Begründung:** Die Abwägung in E47 („folgt aus Beruf und Lage der Figur“) trägt nicht vollständig:
  - a) Die Kälte bleibt bei R15 („seltsam ungerührt“). Es wurde nur das Wort getauscht.
  - b) Bei R15 folgt die Färbung nicht aus der Lage. Ihr Geheimnis (Zeile 27) ist, dass sie den größeren Teil von Essen und Deko aus eigener Tasche bezahlt hat. Die Geld-Färbung ist damit eine falsche Fährte über Geldgier.
  - c) E48 hat die Herkunft aus den Daten entfernt, nicht die Färbung. Nach Punkt 19 sind Namen keine Herkunftsangabe. Die Färbung wirkt trotzdem über die Namen, weil genau diese beiden Figuren mit Geld-Färbung und türkischen Nachnamen auftreten.
  - d) R13-GEHEIM (Zeile 9) gibt ihr ein Café „mit den Rezepten ihrer Großmutter“. Das ist ein kulinarisches Herkunftsmotiv, das E38 sonst aus den Familienfeldern entfernt hat.
- **Vorschlag:** Die Färbung beider Figuren auf eine nicht finanzielle Eigenart umstellen, etwa R13 „wirkt dadurch ungeduldig“ und R15 „wirkt dabei fahrig, weil sie an alles denkt“, über ERSETZE-27 und -28. Das Café-Motiv durch eine andere Geschäftsidee ersetzen. Wer Namen nach Punkt 19 nicht als Bezug zählt, kann diesen Befund als gering werten. Das Urteil „Leitplanken nein“ hängt dann allein an Befund 1.

### Befund 4 · gering · Zeitliste · Zeitangabe 23:58:30 im Ergebnis DW3-1 C

- **Stelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K5-ENTSCHEIDUNGEN-DETEKTIV.md`, Zeile 28 (`@DW3-1 [L]`, Ergebnis C).
- **Zitat:** „… alles vor den Ketten um eine halbe Minute nach zwei vor zwölf.“ Die Zeit steht nur in L- und G-Datensätzen (HW-111; `K3-HINWEISE-KERN.md`, Zeile 76, `@H-302 [G]`, nur für R01). LISTE-ZEITEN nennt nur „23:58 Knall und Stromausfall“.
- **Regel:** LISTE-ZEITEN (ANPASSUNG): „Andere Uhrzeiten nennen nur Rollenkarten, Hinweise und Beweisstücke.“ FORMAT K1: Was nicht in einer Liste steht, darf in Spieltexten nicht als Zeitpunkt auftauchen. E47 macht DW-Ergebnisse zu Spieltext.
- **Einschränkung:** „Viertel vor zwölf“ (23:45) in D3-1, Option A, ist O-belegt und deshalb kein Befund. `kanon.dart --pruefe` meldet hier nichts.
- **Vorschlag:** „kurz nach dem Knall, gegen zwei vor zwölf“ schreiben, oder die DW-Ergebnisse ausdrücklich an LISTE-ZEITEN binden.

### Befund 5 · gering · Stadt-Hinweis · Einstufung von HW-S09 „Farbe“ passt nicht

- **Stelle:** `nachtlauf/kanon/ANPASSUNG.md`, Zeile 146 (`@HW-S09 [L]`); Gegenstück Zeile 145 (`@H-S09 [O]`).
- **Zitat:** „Wahrheit: Farbe. Im Fundus fehlt kein Laken; das Gespensterlaken stammt nicht aus der Volksbühne …, sondern aus der Burgwäsche (Z-2140).“ Einstufung: Farbe.
- **Regel:** Kopf von ANPASSUNG.md: Neue Stadt-Hinweise tragen nur die Einstufung Farbe, entlastend oder bestätigend. Der Text legt die Herkunft des Lakens fest (BS-02, Z-2140), also ein Lösungsmerkmal. Das ist bestätigend bzw. entlastend, nicht Farbe.
- **Vorschlag:** Einstufung auf „bestätigend“ setzen oder den Satz auf die Ortsfarbe kürzen.

### Befund 6 · gering · Färbung · „Besserwisserin“ bei R18

- **Stelle:** `krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md`, Zeile 54 (`@R18-GEHEIM [G]`), im wirksamen Kanon unverändert.
- **Zitat:** „Sie zitiert Paragrafen, die nicht ganz stimmen, und wirkt dadurch wie eine Besserwisserin, auf deren Worte man sich nicht verlassen kann.“
- **Regel:** Leitplanke 4 gilt auch für Klischees über Gruppen. Geschlechter-Klischees sind Punkt 20 (Prüfer 27) zugeordnet. Allein kein Verstoß, aber ein geschlechtscodiertes Label.
- **Vorschlag:** Färbung ohne Geschlechtslabel formulieren, etwa „wirkt dadurch, als sei sie sich ihrer Paragrafen zu sicher“, per Overlay.

## 3. Geprüft ohne Befund

- **Punkt 18, ERSETZE-23 bis -30:** Alle Ersetzungen wirken in O-, G- und DW-Zeilen. „HODŽIĆ“ fehlt in allen Lampenmarken; „VT · 3“, „fau-te drei“, „Quelle des Schreis“, die R01-Firma ohne Nachnamen, die R13/R15-Adjektive und der alkoholfreie Punsch (OA-23, BW-ZUSTAND, Z-0005, DW1-3, Erzählertexte) sind belegt. „Hodžić“ bleibt als Name in R01-STAMM und LF-R01; nach Punkt 19 zulässig.
- **Punkt 15, v1.0-Übernahme:** Im wirksamen Kanon konsistent: Phasenbeginn 00:30 (STADT-05, LISTE-ZEITEN), Stadttore 22:00, Uhrturm 00:30/01:30/03:00/04:30, Eisnebel nur im Tal (K-002), Wäschekorb (LISTE-ORTE), R04-Strickpullover (BW-AUSSAGE-3), R03 ohne Notizbuch. Keine Reste von „bewusstlos“, Harz, Oberharz, Osterode, Brockengespenst, Silberhauer oder Nationalpark.
- **Punkt 19, Herkunft:** Keine Wurzeln, keine Herkunftsattribute (türkisch, kurdisch, bosnisch, polnisch) und keine Folklore-Begriffe (Newroz, Bajram, Wigilia, Pita, Pierogi, Revani, Menemen, Sevdalinke, Džezva, Tufahije, Bağlama) in O-, G- und DW-Zeilen oder in Stadt-, Innenraum- und Figurendaten. „Herkunft: Schartenfels, Bergland“ (BW-STAMM) bleibt nach E48.
- **FM-1 (L):** Kein Spieltext. Die Verteilung der Fallfunktionen ist nach E45, E47 und E48 entschieden.
- **Alkohol, Drogen, Blut, Hexen, Walpurgis, Teufel, Vampire, Schimpfwörter:** keine Treffer im wirksamen Kanon, in Stadt-, Text- und Figurendaten. Gastronomie kommt nur als Teestube („Zur Laterne“) und Bäckerei vor.
- **Lösungsbegriffe in den Stadtdaten** (Laken, Taler, Stablampe, Sicherungskasten, Stollen, Wanderstiefel, Rollennamen): keine Treffer in bewohner.json, haeuser.json, innenraeume, erzaehler.json und tutorial.json.
- **Nebel:** In den Stadtdaten nur „Nebelmeer unten im Tal“ und als Legende; konsistent mit K-002.
- **Hinweise in DW1-1, DW1-2, DW3-1 C und DW3-2:** keine Namensnennung der Täterin; kein Befund.
- **Plagiat:** Stichprobe ohne Treffer bei bekannten Figuren, Namen oder Sätzen. „Hab ich dich“, „Glück auf“ und „Im Reif lügt keiner“ sind allgemeine Wendungen; „Kunibert“ und „Nebelriese“ sind nicht erkennbar übernommen. Ein Abgleich mit externen Quellen fand nicht statt.

Leitplanken eingehalten: nein · Kanontreu: nein · Plagiatsfrei: ja
