# Gegenproben zur Inhaltsrunde A-702t (E50)

Zu jedem Befund „hoch“ oder „mittel“ der Prüfer 25, 26 und 27 hat ein unabhängiger Prüfer versucht, ihn mit Belegen zu widerlegen. Er hatte nur Lesezugriff auf den Stand c54fe9c und den wirksamen Kanon. Das Urteil der Berichte selbst bleibt unverändert; die Gegenproben dienen der Auswertung (E50).

## gegenpruefer_inhalt_25
Endmeldung: AUFTRAG A-702t FERTIG · /home/user/werwolf_digital_flutter/.claude/worktrees/wf_853e074c-b91-1/nachtlauf/auftraege/A-702/gegenpruefer_inhalt_25_bericht.md · Befunde: hoch 1 / mittel 1 / gering 5 · Leitplanken nein · Kanontreu ja · Plagiatsfrei ja

### hoch · DW3-3 Ergebnis C nennt die Täterin vor der Auflösung
- Stelle: wirksamer Kanon @DW3-3 [L], Feld 'Ergebnis C' (Quelle krimidinner/spuk-im-gewoelbe/10_kanon/K5-ENTSCHEIDUNGEN-DETEKTIV.md), ausgelöst durch @D3-3 (Phase 3)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E27 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Das Zitat stimmt. wirksam3.txt Z. 1052, @DW3-3 [L], Ergebnis C: „… aber nur an Merles linkem Absatz fehlt ein Stollen, genau wie im Wachs. Der Abdruck stammt von Merle.“ Ausgelöst wird es durch @D3-3 [O] (Phase 3, Option C „mit allen vier Sohlenkarten, Stollen für Stollen | Begründbar durch: H-06, H-15“).

2) Es ist Spieltext. Laut E47 („Berichtigung zu E45“) zeigt das Spiel DW-Ergebnisse nach einer Entscheidung an (fall_daten.dart:259).

3) Der Punkt ist schon in E27 M5 abgewogen. Dort steht: „Die Leitplanke ‚kein Text, der die Täterin nahelegt‘ gilt für unsere zusätzlichen Texte (Stadt, Bewohner, Häuser), nicht für die Spuren des Falls.“ Der Grund dort ist „das Rätsel selbst“. Ob ein Text ein O- oder ein L-Datensatz ist, spielt dafür keine Rolle. Ergebnis C ist kein Zusatztext, sondern genau der Schluss, den der Fall verlangt. Der Prüfer stützt sich auf E47 (DW zählt als Spieltext), aber das ändert nichts an diesem Grund. Ein neuer Grund liegt also nicht vor.

4) Der Befund ist nicht haltbar. Ergebnis C sagt nichts, was nicht schon in den O-Hinweisen dieser Phase steht:
- @H-06 [O], Phase 1: „Am Absatzrand fehlt ein Stollen …“
- @H-15 [O], Phase 3: „bei Merle fehlt am linken Absatz ein Stollen, bei Jonas sind alle Stollen heil.“

Wer beide Hinweise kennt, zieht denselben Schluss. Wäre Ergebnis C ein Verstoß, dann wäre auch H-15 einer, und den deckt E27 M5 ausdrücklich ab. Der Schluss ist außerdem die notwendige Schlussfolgerung @S-5 („Das Gespenst war Merle: Stiefel mit fehlendem Stollen …“, Hinweise H-06, H-15, H-14). Er ist Lohn einer richtigen Detektiv-Entscheidung („Echte Spur: C“), also Teil des Rätsels und kein Vorgriff auf die Auflösung.

Der Vorschlag des Prüfers, Ergebnis C auf die Spur zu beschränken, würde die Lösungskette S-5 und die Fairness schwächen, ohne etwas zu verbergen, denn H-15 nennt die Zuordnung ohnehin. Dazu kommt: Ergebnis C ordnet nur den Abdruck zu, die Täterschaft am Schlag nicht. Dafür braucht es weiter S-1…S-7 und die Anklage.
- Vorschlag: Keine Änderung. Höchstens eine Zeile in E27 M5 ergänzen: Die Ausnahme gilt auch für die DW-Ergebnisse, weil sie Schlüsse aus O-Hinweisen des Falls sind (hier H-06 + H-15 → S-5).

### mittel · Punschkessel ohne Alkoholfrei-Zusatz in zehn Zeilen
- Stelle: wirksamer Kanon: @LISTE-ORTE (ANPASSUNG Z.77), @LISTE-GEGENSTÄNDE, @OA-03, @R05-ÖFFENTLICH, @R01-ÖFFENTLICH, @R17-ÖFFENTLICH, @D1-3 (O); @R12-WISSEN, @R12-LÜGE, @E1-12 (G)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E46 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Das Zitat stimmt. wirksam3.txt @OA-03 [O]: „Adnan rammt mit dem Wagen samt Punschkessel die alte Eichentür zur Speisekammer.“ @D1-3 [O]: „Option B: den Punschkessel“. „Punschkessel“ ohne Zusatz steht außerdem in @LISTE-ORTE, @LISTE-GEGENSTÄNDE, @R01-ÖFFENTLICH („Punschkessel-Wagen“), @R17-ÖFFENTLICH („Am Punschkessel erzählt er“), @R12-WISSEN, @R12-LÜGE und @E1-12. Für @R05-ÖFFENTLICH zeigt der Auszug in den ersten 400 Zeichen nur den Türschaden. Das ändert aber nichts am Ergebnis.
2) Es ist Spieltext, denn das sind O- und G-Datensätze des wirksamen Kanons.
3) Der Punkt ist schon entschieden. ENTSCHEIDUNGSLOG E46 (R22-4) sagt wörtlich: „‚Punschkessel‘ ohne ‚alkoholfrei‘: Der Kessel ist im Kanon öffentlich als alkoholfrei festgelegt (OA-04, GL-14). Wo im Spieltext jemand Punsch trinkt, steht ‚alkoholfrei‘ (ERSETZE-19…21).“ Danach hat E47 die Regel ausgeweitet: Jedes angezeigte „Punsch“ (O, G, DW) muss im selben Feld „alkoholfrei“ haben. Das Kompositum ist dabei bewusst ausgenommen (packages/burgstadt_core/test/kanon_test.dart:279: `replaceAll('Punschkessel', '')`). Der Prüfer stützt sich darauf, dass der Auftrag diese Einschränkung nicht kennt. Das ist nur eine andere Auslegung derselben Regel, die E46 schon abgewogen hat. Neue Belege bringt er nicht.
4) Der Befund ist nicht haltbar. Die Leitplanke „Punsch immer alkoholfrei“ betrifft das Getränk, und das ist überall alkoholfrei. Öffentlich legt das @OA-04 [O] fest („ein Kessel warmer, alkoholfreier Apfel-Zimt-Punsch“), ebenso @GL-14 [O] („der warme, alkoholfreie Apfel-Zimt-Punsch“) und @FÜNF-SÄTZE. Auch die zitierte Stelle D1-3 löst sich selbst auf: Wer Option B wählt, bekommt das Ergebnis @DW1-3 B „Der alkoholfreie Punsch ist noch warm und duftet nach Zimt.“ Das Objekt in der Spielwelt heißt „Punschkessel (warm, alkoholfrei)“ (packages/burgstadt_core/lib/src/welt/burg.dart:48). In keiner der zehn Zeilen wird getrunken oder ein Getränk beschrieben. Das Wort steht dort nur für ein Gerät, einen Ort oder eine elektrische Last, und nichts darin deutet auf Alkohol hin. Ein Pauschal-Ersatz zu „alkoholfreier Punschkessel“ würde außerdem holprige Formen erzeugen, etwa „alkoholfreier Punschkessel-Wagen“ oder „Am alkoholfreier Punschkessel“.
- Vorschlag: Keine Änderung nötig. Die Entscheidung E46 und der Test aus E47, der „Punschkessel“ ausnimmt, bleiben. Falls doch etwas geschehen soll: E46 könnte ausdrücklich sagen, dass „Punschkessel“ als Gerätebezeichnung gemeint ist und das Getränk in OA-04 und GL-14 öffentlich als alkoholfrei feststeht.

## gegenpruefer_inhalt_26
Endmeldung: AUFTRAG A-702t/26 FERTIG · /home/user/werwolf_digital_flutter/.claude/worktrees/wf_853e074c-b91-2/nachtlauf/auftraege/A-702/gegenpruefer_inhalt_26_bericht.md · Befunde: hoch 1 / mittel 2 / gering 3 · Leitplanken nein · Kanontreu nein · Plagiatsfrei ja

### hoch · Täterin vor dem Morgengrauen benannt (DW2-3 B, DW3-3 C)
- Stelle: krimidinner/spuk-im-gewoelbe/10_kanon/K5-ENTSCHEIDUNGEN-DETEKTIV.md, Zeile 24 (@DW2-3 [L], Ergebnis B) und Zeile 34 (@DW3-3 [L], Ergebnis C)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E27 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Das Zitat stimmt. In wirksam3.txt und in K5-ENTSCHEIDUNGEN-DETEKTIV.md (Z. 24 und 34) steht es so. @DW2-3 Ergebnis B: „… Wer ihn kurz nach dem Knall in die Dose warf, wurde gepackt. Und wer ihn hatte, hatte einen Grund, ihn heimlich zurückzubringen.“ @DW3-3 Ergebnis C: „… nur an Merles linkem Absatz fehlt ein Stollen, genau wie im Wachs. Der Abdruck stammt von Merle.“ Das Overlay ändert daran nichts.

2) Es ist Spieltext. Nach E47 (Berichtigung zu E45) und Auftrag Punkt 17 zählen die DW-Ergebnisse als Spieltext. fallsitzung.dart Z. 191–195 liefert den Ergebnistext direkt nach der Entscheidung in der laufenden Phase, Z. 325 legt ihn als letztesErgebnis ab.

3) Der Punkt ist schon abgewogen, ein neuer Grund fehlt. E27 M5 („Kanon-Spuren zeigen auf die Täterin“) sagt: Das ist „das Rätsel selbst“, und die Leitplanke „kein Text, der die Täterin nahelegt“ gilt für „unsere zusätzlichen Texte (Stadt, Bewohner, Häuser), nicht für die Spuren des Falls“. Die DW-Ergebnisse sind Kanon-Fallinhalt, kein Overlay-Text. Laut K5-Kopfzeile liefert der Ergebnistext, „was der Detektiv durch die Wahl erfährt“, und Phase 3 hat den Schwerpunkt „Alibis und Zeitleiste“. E47 macht die DW-Texte zu Spieltext, damit sie den inhaltlichen Leitplanken unterliegen (Punsch, Herkunft). Die Ausnahme in M5 hebt E47 nicht auf: M5 betrifft den Fallinhalt, egal in welchem Datensatztyp er steht. Das Argument des Prüfers, der Auftrag formuliere „ohne Ausnahme“, ist nur ein Widerspruch zur Auslegung in E27 und kein neuer Grund. Das Problem bestand schon, als E27 entschieden wurde.

4) Der Befund ist nicht haltbar. DW3-3 C ist die Belohnung für die richtige Spur (+1). Sie schließt die Kette DW1-1 B → DW3-3 C: „Wer zuschlug … merk dir die Lücke im Profil“. Ein Detektivspiel, dessen richtige Schlüsse nie auf die Täterin zeigen dürfen, wäre nicht lösbar. Mit „vor der Auflösung“ ist die Anklage im Morgengrauen gemeint, und die setzt genau diese Schlüsse voraus. DW2-3 B nennt keine Täterin. Der Text stellt nur Talerbesitz und Grund zur heimlichen Rückgabe fest; ein Motiv für den Schlag nennt er nicht. Der Vorschlag würde die Lösungskette des verbindlichen Kanons umbauen (K5 v1.0). Das gehört nach E44/E45 (Lösungskette, z. B. DW1-1) zur Verantwortung der Kanon-Autoren und nicht zum Nachtlauf (Auftrag Punkt 18).

Am Rand: HEAD im Repo ist 74a76b0. c54fe9c existiert als Commit.
- Vorschlag: Keine Änderung. Höchstens als Hinweis für die Kanon-Autoren in FUER-DEN-NUTZER.md vermerken (z. B. „in Phase 3 bestätigen, Name erst in K6“) und in E50 kurz klarstellen, dass E27 M5 auch für die DW-Ergebnisse gilt.

### mittel · Übernachtung der Clique in der Pension widerspricht K-010
- Stelle: nachtlauf/kanon/ANPASSUNG.md, Zeile 67 (@ORT-03 [O]) und Zeile 136 (@HW-S06 [L]); Gegenstelle krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md, Zeile 64 (@K-010 [O])
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E47 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Die Zitate stimmen. ANPASSUNG.md Z. 67 @ORT-03 [O] lautet „Rolle im Fall: Farbe (Übernachtung der Clique; die Pension stempelt ihre Wäsche blau mit ihrem Namen)“. Z. 136 @HW-S06 [L] lautet „Die Pension „Zum Uhrturm“ ist die Übernachtung der Clique (ORT-03)“. Beide Zeilen stehen gleich im wirksamen Kanon (wirksam3.txt Z. 1219 und 1240). K-010 steht in K1-GRUNDWAHRHEIT.md Z. 64 so wie zitiert. Der Befund zitiert aber die Kanonfassung. Wirksam ist eine andere Fassung (wirksam3.txt Z. 42): „… Gerda ist bei ihrer Schwester unten im Tal; … In den Häusern der Oberstadt schlafen oder wachen einige Bewohner; in die Burg kommt seit 23:00 niemand von ihnen, denn das Burgtor ist abgeschlossen.“

2) ORT-03 ist ein O-Datensatz und damit Spieltext. HW-S06 ist ein L-Datensatz und damit kein Spieltext; er zählt nur bei der Prüfung auf Widersprüche.

3) Der Punkt ist schon abgewogen. ENTSCHEIDUNGSLOG E47 führt ihn unter „Bewusst so“: „Übernachtung in der Pension (R23-3): K-010 betrifft die Burg; die Pension liegt in der Stadt.“ Der Befund bringt keinen neuen Grund. Er liest denselben K-010-Satz nur anders: Die Festgesellschaft sei in dieser Nacht in der Burg. Dieses Verhältnis von K-010 zur Pension hat E47 schon gegen K-010 abgewogen.

4) Der Befund ist nicht haltbar, denn die Lesart des Prüfers widerspricht dem wirksamen Kanon selbst:
- K-010 sagt, wer sich in der Burg aufhält: keine Außenstehenden. Dass die Festgesellschaft die ganze Nacht in der Burg bleibt, sagt K-010 nicht. Der wirksame Zusatz grenzt die Aussage ausdrücklich auf Bewohner ein, die von außen in die Burg kommen.
- @STADT-03 [O] lässt die Festgesellschaft ab Phase 2 in die Oberstadt: „Sucht meinetwegen in der ganzen Oberstadt – aber vor dem Morgengrauen kommt hier keiner raus.“ Auch LISTE-ORTE nennt die Oberstadt „ab Phase 2“ samt Pension. Die Clique ist in dieser Nacht also ohnehin nicht nur in der Burg.
- „Übernachtung der Clique“ meint das gebuchte Quartier, nicht einen Aufenthalt in der Nacht. Dazu passen @H-S05 [O] („Zimmer sieben, Bettwäsche frisch bezogen“), also ein unbenutztes Zimmer, und @H-S06 [O] („Betten gewärmt“).
- Kein O-, G- oder L-Datensatz sagt, die Clique schlafe in der Burg oder sei schon in die Pension gegangen. Die Suche nach Schlafsack, Quartier, gebucht und Zimmer ergab nichts Widersprechendes.

Einen Widerspruch zu K-010 gibt es damit nicht.
- Vorschlag: Keine Änderung nötig. Rein kosmetisch und optional ginge in ORT-03: „Übernachtung der Clique“ wird zu „gebuchtes Quartier der Clique für nach der Feier“. Den Kern trägt das nicht.

### mittel · Geld- und Kälte-Färbung bei R13 und R15
- Stelle: krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN-13-20.md, Zeile 9 (R13-GEHEIM) und Zeile 27 (R15-GEHEIM); wirksam durch ERSETZE-27/28
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E47 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Zitat: Es steht so im wirksamen Kanon (wirksam3.txt). @R13-GEHEIM [G]: „Scheinbare Färbung: Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“ @R15-GEHEIM [G]: „Sie redet ständig über Geld, Schäden und Versicherungen, sogar über Kunibert, und wirkt dabei seltsam ungerührt.“ Wirksam wird es über ANPASSUNG.md ERSETZE-27/28 (Z. 38/39). In der Kanon-Datei selbst stehen noch die alten Wendungen „kalt und berechnend“ bzw. „als denke sie nur in Beträgen“.
2) Spieltext: Es sind G-Datensätze, also ja.
3) Schon entschieden: E47 (ENTSCHEIDUNGSLOG Z. 517–519) hat genau diese Kombination abgewogen. Die Kälte-Adjektive wurden ersetzt, und es heißt dort ausdrücklich: „Die Färbung selbst bleibt (Geld zurückfordern, über Schäden reden); sie folgt aus Beruf und Lage der Figur.“ Die Namen hat E48 (Z. 555) geregelt: „Namen und Aussprache bleiben, denn sie sind die Identität der Figuren, keine Herkunftsangabe.“ Das Speise-/Folklore-Muster ist in E43/E44 behandelt (Revani → Gartenkalender, ANPASSUNG Z. 87/101).
4) Die Begründung trägt nicht:
- Die Behauptung „genau diese beiden Figuren tragen die Geld-Färbung“ ist falsch. Alle vier Rollen R13–R16 haben im PLOT „Funktion: Geldverflechtung“. Auch R05 ist geldgefärbt („ärgert sich lautstark über Jonas und das Mietgeld und wirkt dabei rachsüchtig“), ebenso R14 („der Burgwart wolle Adnan abzocken“) und R16 (Kreditanfrage über dreitausend Euro). E47 Z. 535 hat diese Färbungen ausdrücklich gebilligt.
- Bei R15 folgt die Färbung aus dem Beruf: @R15-STAMM [O] „Beruf: Versicherungskauffrau im Außendienst“, Sprechweise „Das ist abgedeckt.“ „Seltsam ungerührt“ ist die von E47 gewählte Ersatzformulierung. Dass sie trotzdem „Kälte“ sei, ist eine Geschmacksfrage und kein neuer Grund.
- Nach E48 nennt kein angezeigter Text mehr eine Herkunft (Wurzeln gelöscht). Die Zuordnung liefe also nur über die Nachnamen, und die bleiben nach E48 bewusst.
- Das Café ist im wirksamen Kanon kein Herkunftsmotiv. Revani ist entfernt, @R13-STAMM nennt nur „Gartenkalender“ und „Backen“, und „Rezepte ihrer Großmutter“ ist herkunftsneutral. Cafés sind laut Leitplanke 4 sogar die vorgesehene Gaststättenform.
Ergebnis: Der Befund bringt gegenüber E47/E48 keinen neuen Grund und ist nicht haltbar.
- Vorschlag: Keine Änderung. Die Punkte sind in E47 (Färbung R13/R15), E48 (Namen) und E43/E44 (Speisemotiv) abgewogen.

## gegenpruefer_inhalt_27
Endmeldung: AUFTRAG A-702t/27 FERTIG · /home/user/werwolf_digital_flutter/.claude/worktrees/wf_853e074c-b91-3/nachtlauf/auftraege/A-702/gegenpruefer_inhalt_27_bericht.md · Befunde: hoch 1 / mittel 4 / gering 5 · Leitplanken nein · Kanontreu ja · Plagiatsfrei ja

### hoch · Haarfarbe folgt der Namensgruppe: dunkel bei türkisch, bosnisch oder kurdisch klingenden Namen, hell bei den übrigen
- Stelle: wirksamer Kanon @LF-R01 bis @LF-R20 (O); packages/pixel_engine/data/figuren/rollen.json (Haarfelder)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: – · neuer Grund ja · **haltbar nein**
- Begründung: 1) Das Zitat stimmt. In wirksam3.txt steht @LF-R01 "short dark brown hair" (Adnan Hodžić), @LF-R02 "long dark curly hair" (Rojda Baran), @LF-R06 "short black hair" (Diyar Kaya), @LF-R11 "long straight black hair" (Berfin Demir), @LF-R18 "dark curly hair" (Elif Şahin). Dagegen stehen @LF-R03 "light brown hair", @LF-R04 "short blond hair", @LF-R10 "platinum blonde pixie cut" und @LF-R17 "sandy hair". rollen.json folgt dem: Die zwölf Rollen R01, R02, R06, R07, R08, R11, R12, R13, R15, R16, R18 und R19 haben Haar-Rampe 0 oder 2 mit Stufe 0–2, also dunkel.

Der Befund ist allerdings unvollständig. Die vier polnisch klingenden Namen fehlen: R05 "dark blonde bob", R09 "short reddish-brown hair", R14 "short light brown hair", R20 "long light brown braid". Das Muster steht damit 12 zu 8 und nicht 12 zu 4.

2) Es ist Spieltext. LF-R01 bis LF-R20 sind O-Datensätze (englische Bildanker). rollen.json gehört zu den Figurendaten und bestimmt, wie die Figuren gezeichnet werden.

3) Der Punkt ist nicht abgewogen. Weder in E23–E49 noch sonst im Log taucht die Haarfarbe im Bezug auf Namen oder Herkunft auf. Der Log behandelt Haar nur technisch: Kopfbedeckungen nicht in Haarfarben, weißes Haar Stufe 6, R05-Bob. E48 hält nur fest, dass Namen keine Herkunftsangabe sind.

4) Der Befund ist als Leitplankenverstoß (hoch) nicht haltbar:
a) Die Haarfarben sind nicht im Nachtlauf erfunden. Sie kommen aus der Look-Bibel des Kanons (krimidinner/spuk-im-gewoelbe/10_kanon/K9-LOOKBIBEL.md). In rollen.json nennt das Feld "quelle" @LF-Rxx, und "erfunden" führt bei R01–R20 nur "Hautton". Nur beim Burgwart ist "Haar (Farbe, Frisur)" erfunden. Eine Änderung würde vom Kanon abweichen und nimmt den Kanon-Autoren eine Entscheidung ab, wie bei FM-1 (E45).
b) Haarfarbe ist ein wertfreies Körpermerkmal. Sie ist nirgends Motiv, Indiz oder Pointe. Außerhalb von LF-R und der Steckbrief-Zeile von R03 kommt Haar/hair im wirksamen Kanon in keinem O-, G- oder DW-Text vor. Keine Spur und keine Zeugenaussage hängt am Haar.
c) Herkunft zeigt das Spiel nach N-02/E48 gar nicht mehr an. Namen gelten ausdrücklich nicht als Herkunftsangabe (A-702t Punkt 19). Ein Klischee im Sinne der Leitplanke wäre eine abwertende oder typisierende Zuschreibung von Eigenschaften. Eine realistische Haarfarbe ist das nicht.
d) Innerhalb beider Gruppen gibt es Vielfalt (schwarz, dunkelbraun, lockig, glatt, wellig, Dutt, Pferdeschwanz gegenüber platinblond, rotbraun, sandfarben, hellbraun). Der Hautton (erfunden) ist über die Gruppen gemischt: haut 2 bei R09, R14 und R19, haut 6 bei R05, R10, R17 und R20.

Bleibt ein Restpunkt: Die lückenlose Deckung 12 zu 8 ist ein Besetzungsmuster. Das gehört als geringer Hinweis an die Kanon-Autoren beziehungsweise den Nutzer, ist aber kein Verstoß und kein Befund der Schwere hoch. Hinweis zum Stand: HEAD ist 74a76b0, ein Protokoll-Commit direkt nach c54fe9c.
- Vorschlag: Die Daten bleiben unverändert. Höchstens kommt ein geringer Hinweis in nachtlauf/FUER-DEN-NUTZER.md: In K9-LOOKBIBEL (LF-R01 bis LF-R20) deckt sich die Haarfarbe ganz mit dem Namensklang. Ob einzelne Look-Anker gemischt werden, zum Beispiel ein heller Ton bei einer der zwölf Figuren und ein dunkler bei einer der übrigen acht, entscheiden die Kanon-Autoren. Folgt eine Änderung, dann rollen.json nachziehen und die Sichtprüfung nach A-605 machen.

### mittel · Geld-Färbungen bei den drei Frauen mit nichtdeutschen Namen und Geldberuf
- Stelle: wirksamer Kanon @R05-GEHEIM, @R13-GEHEIM, @R15-GEHEIM (G); Berufe in @R05-STAMM, @R13-STAMM, @R15-STAMM (O)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E47 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Alle drei Zitate stehen wörtlich in wirksam3.txt: @R05-GEHEIM [G] „Scheinbare Färbung: Sie ärgert sich lautstark über Jonas und das Mietgeld und wirkt dabei rachsüchtig.“, @R13-GEHEIM [G] „Sie drängt hart auf ihr Geld und wirkt dadurch unnachgiebig.“, @R15-GEHEIM [G] „Sie redet ständig über Geld, Schäden und Versicherungen, sogar über Kunibert, und wirkt dabei seltsam ungerührt.“ Die Berufe stehen in @R05-, @R13- und @R15-STAMM [O]. 2) Es sind G-Datensätze, also Spieltext. 3) E47 hat den Punkt schon abgewogen, und zwar auch nach Geschlecht. Dort heißt es: „Grund: Diese beiden Adjektive verbinden zwei türkischstämmige Frauen in Finanzberufen mit Geldgier und Kälte … Die Färbung selbst bleibt (Geld zurückfordern, über Schäden reden); sie folgt aus Beruf und Lage der Figur.“ R05 steht ausdrücklich unter „Übrige Färbungen (R23-2): R05 (Ärger über das Mietgeld) … folgen aus Lage und Beruf der Figur“. Die Begründung „Geschlechterbezug, in E47 nicht geprüft“ trifft also nicht zu, und einen neuen Grund gibt es nicht. 4) In der Sache trägt der Befund ebenfalls nicht. a) Die „nichtdeutschen Namen“ sind laut A-702t Punkt 19 (E48) keine Herkunftsangabe, und das Feld „Wurzeln“ ist gelöscht. b) Geld-Färbungen sind nicht an Frauen gebunden. Der einzige Mann mit kaufmännischem Beruf, R16 (Immobilienkaufmann), hat ebenfalls eine Geld-Färbung („Durch ihn wird Jonas' Geldnot greifbar (die Kreditanfrage über dreitausend Euro)“), und R14 (Tischler, männlich) eine weitere („grummelt laut, der Burgwart wolle Adnan abzocken“). c) Jede der drei Färbungen hat einen Grund in der Lage der Figur und wird durch ihr Geheimnis aufgehoben. R13 hat Jonas 800 Euro geliehen („@R13-WISSEN: im Sommer leiht sie Jonas 800 Euro; er hat bis heute nichts zurückgezahlt“), und das Geld ist ihr Erspartes für ein Café („deshalb drängt sie so“). R05 ärgert sich wegen des echten Mietbetrugs von Jonas (K-012). R15 hat die Feier großzügig aus eigener Tasche bezahlt und redet nicht darüber. Damit widerlegt der Text das Klischee „geldgierig/kalt“, statt es zu bestätigen. Bei R15 ist das Reden über Schäden und Versicherungen eine Berufsfärbung (Sprechweise „Das ist abgedeckt.“), keine Gruppenzuschreibung. d) E47 hat die abwertenden Adjektive („kalt und berechnend“, „denke nur in Beträgen“) bereits ersetzt. Was übrig ist („unnachgiebig“, „ungerührt“, „rachsüchtig“ wegen eines echten Betrugs), ist situativ und beschreibt keine Gruppe.
- Vorschlag: Keine Änderung nötig. Wer es trotzdem will: Bei R05 könnte „rachsüchtig“ durch „nachtragend“ ersetzt werden. Das ist rein kosmetisch und kein Leitplankenverstoß.

### mittel · Der stärkste falsche Verdacht trifft die Figuren mit nichtdeutschen Namen (Widerspruch zu E47/E48 mit neuem Grund)
- Stelle: wirksamer Kanon @R01-GEHEIM, @R02-GEHEIM, @R03-GEHEIM, @R04-GEHEIM (G)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E47/E48 · neuer Grund ja · **haltbar nein**
- Begründung: 1) Das Zitat stimmt. In wirksam3.txt steht @R01-GEHEIM [G] „Motiv: scheinbar – 3.800 Euro Türschaden bis Mitternacht, ‚sonst bleibt das Tor zu‘; sein Zettel lag am Sicherungskasten, seine Lampe am Tatort, und er war als Erster in der Speisekammer.“ @R02-GEHEIM [G] lautet „Motiv: keines. Scheinbarer Verdacht: Sie stand im Dunkeln direkt neben der Eisentür, hat den Strom abgeschaltet und weiß alles über den Streich.“ @R03-GEHEIM [G] lautet „Motiv: echt – …“.

2) Es ist Spieltext, denn es sind G-Datensätze.

3) Der Punkt ist schon abgewogen. E47 sagt wörtlich: „Täterin R03 und Mietbetrug R04 haben deutsche Wurzeln. Die falsche Fährte R01 hat bosnische, die Hauptzeugin mit dem Streich R02 kurdische Wurzeln … Beides entscheidet der Nutzer.“ E48 setzt die Nutzerentscheidung N-02 um: Herkunft kommt aus den Daten heraus, der Kanon bleibt unverändert, und Namen bleiben ausdrücklich. Formal ist der Bildbezug ein neuer Grund, weil E47/E48 das Aussehen nicht prüfen. Er ist aber nur eine Folge von H-1 desselben Prüfers (Haarfarbe in @LF-Rxx/rollen.json) und gehört dorthin.

4) Der Befund ist nicht haltbar, weil seine Grundannahme falsch ist. Der Kanon nennt als die beiden Hauptverdächtigen R01 und R04, nicht R01 und R02:
- @VK-1: „Täterin, Hauptzeugin und die beiden Hauptverdächtigen“
- @R01-PLOT: „Funktion: Hauptverdächtiger“
- @R04-PLOT: „Funktion: Hauptverdächtiger, Organisator“
- @R02-PLOT: „Funktion: Hauptzeugin“

R04 Jonas Brinkmann hat einen deutschen Namen und ist im Bild blond (@LF-R04 „short blond hair“; rollen.json haar rampe 4/stufe 6). Er trägt den am stärksten an die Tatindizien gebundenen falschen Verdacht. Laut @R04-GEHEIM ist das der „grüne Strickpullover (‚was Grünes an der Vitrine‘), die gleichen Stiefel wie Merle und dass er im Turm war und Kunibert kennt“. Der falsche Hauptverdacht verteilt sich also auf je eine Figur beider Namensgruppen.

Auch die Annahme, die Gruppe sei im Bild sichtbar, trägt nur teilweise. In rollen.json haben R02 (Verdacht) und R03 (Täterin) dieselbe Hautstufe „haut“: 5. R01 hat 3, R04 hat 4.

Außerdem hängt der Verdacht schon jetzt an Gegenständen und Zeiten: Zettel, Lampe, Türschaden, Position am Kasten. Das verlangt @FM-1: „Verdacht, Schuld und Entlastung folgen nur aus Gegenständen, Zeiten und Aussagen.“ Nichts davon knüpft an Name oder Aussehen an. Der zweite Teil des Vorschlags ist damit bereits erfüllt. Was bleibt, ist höchstens das Haarfarben-Muster aus H-1, und das ist ein eigener Befund.
- Vorschlag: Nicht als eigener Befund zählen. Wenn überhaupt, unter H-1 (Haarfarben über die Namensgruppen mischen) behandeln. Die Verteilung der Fallfunktionen bleibt Nutzerentscheidung nach E47/E48. R04 ist als zweiter Hauptverdächtiger (@VK-1, @R04-PLOT) mit deutschem Namen und blondem Haar besetzt.

### mittel · Altersbild: alte Frau mit Dutt, Haube, Lehnstuhl und Erinnerungen; alter Mann als Griesgram mit Glatze
- Stelle: packages/burgstadt_core/data/stadt/bewohner.json (B01, B05, B08, B13, B14, B15, B18, B28, B33, B35, B38, B40, B43); haeuser.json (H-139); wirksamer Kanon @BW-STAMM und Rollen-Gerede
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E40 (Dutt), E34/E37 B-2 (Hörschwäche) · neuer Grund ja · **haltbar nein**
- Begründung: 1) Die Zitate stimmen fast alle. In bewohner.json tragen sieben Bewohnerinnen einen Dutt (`frisur: dutt`): B01 (66), B05 (74), B13 (88), B33 (79), B35 (58), B38 (73) und B43 (85). Weitere Wortlaute:
- B13 sagt: „Ich bin achtundachtzig. Ich sehe nur Mondlicht und Erinnerungen.“ Im Gerede steht: „Man erzählt, die alte Rosa habe den Nebelriesen am Fenster gezählt …“
- B15 sagt: „Frau Lang im zweiten Stock hört schlecht, sprich bei ihr langsam.“
- In den Wesen-Feldern stehen „Brummig und treu“ (B08), „Brummelig und gutmütig“ (B14) und „Grummelig und stolz“ (B28).
- Eine Glatze haben nur B08 (81), B14 (70), B18 (66), B28 (84) und B40 (68).

Falsch ist nur die Haube als Altersmerkmal: Auch B03 (51, Bäckerin) trägt `kopf: haube`. Der Lehnstuhl kommt auch bei B16 und bei einem Mann vor (B22, 71). Der wirksame Kanon trägt zum Befund nichts bei. @BW-STAMM („stur, grantig, gerecht, mit überraschender Wärme“) und „der Alte“ bzw. „brummt“ für den Burgwart sind Kanon-Wortlaut, und den ändert der Nachtlauf nicht (vgl. E42).

2) Das ist Spieltext, denn alle Stellen stehen in packages/burgstadt_core/data/stadt/bewohner.json.

3) Zwei Teile sind schon abgewogen:
- **Dutt:** E40 sagt „Bewusst offen: Dutt-Frisur bei mehreren älteren Bewohnerinnen …“, und FUER-DEN-NUTZER.md:31 hält fest, dass die Prüfung das „ein mögliches Altersbild“ nannte. Der Klischee-Punkt ist also bekannt und liegt beim Nutzer. Ein neuer Grund fehlt.
- **Hörschwäche:** Der Satz ist selbst die Korrektur aus E34 B-2 (Commit b458a8d). Sie ersetzte „Wenn du mit einer Alten sprichst, sprich langsam und laut. Die Ohren sind alt …“, bindet die Aussage an eine konkrete Person und lobt deren Gedächtnis. Ein neuer Grund fehlt.

Neu ist nur ein Rest zu E40: Dieselbe Gerede-Formel wie die dort entfernte „die alte Schöning“ steht noch dreimal da: „die alte Rosa“ (B13), „der alte Lenz“ und „der alte Thalheim“ (B28).

4) Der Befund ist als „mittel“ und Gruppenklischee nicht haltbar:
- **Brummig/grummelig:** Das trifft 3 von 7 Männern ab 65 (B08, B14, B28). B22 (71) ist dagegen „Eitel mit einem freundlichen Lächeln“, B26 (68) „Gemächlich und höflich“. Jedes der drei Wesen ist mit einem warmen Zug gepaart (treu; gutmütig, Kreisel für jedes Kind; stolz). Es spiegelt den Kanon-Burgwart (71, grantig mit Wärme).
- **Glatze im Alter** ist ein realistisches Erscheinungsbild und keine Abwertung.
- **B13** ist individuell gezeichnet („Klein, zäh und ein wenig eigensinnig“, frühere Handarbeitslehrerin). Ihr Satz ist eine Selbstironie, keine Aussage über alte Menschen.

Haltbar bleibt höchstens als „gering“ die Formel „die/der alte + Name“. Das betrifft drei Gerede-Stellen, die mit E40 nicht übereinstimmen.
- Vorschlag: Höchstens als geringer Befund und Nachtrag zu E40: In bewohner.json bei den drei Gerede-Stellen „die alte Rosa“ → „Rosa Teutsch“, „der alte Lenz“ → „Lenz“ mit Vornamen oder vollem Namen und „der alte Thalheim“ → „Egon Thalheim“ ändern. Dutt (E40, FÜR DEN NUTZER) und Frau Lang (E34 B-2) bleiben, ebenso Glatze und brummig.

### mittel · Pflege, Reinigung, Verkauf und Bedienung sind nur mit Frauen besetzt
- Stelle: packages/burgstadt_core/data/stadt/bewohner.json (B15, B21, B25, B35, B38, B41)
- Ergebnis: Zitat gefunden ja · Spieltext ja · schon entschieden: E44 · neuer Grund nein · **haltbar nein**
- Begründung: 1) Das Zitat fasst zusammen und ist kein Wortlaut, stimmt aber in der Sache. In bewohner.json stehen: B15 „Pflegekraft“ (w), B21 „Friseurin“ (w), B25 „Verkäuferin“ (w), B35 „Reinigungskraft im Rathaus“ (w), B38 „Schneiderin“ (w), B41 „Bedienung in der Teestube“ (w). Insgesamt sind es 44 Bewohner, 23 m und 21 w. Der Teil „unter den 23 Männern kein solcher Beruf“ stimmt nur teilweise. Pflege, Reinigung, Bedienung und Friseur haben je genau eine Figur, und die ist eine Frau. Neben der Schneiderin stehen aber männliche Bekleidungshandwerker: B18 „Kürschner“, B22 „Hutmacher im Ruhestand“, B32 „Schuhmacher“. Männliche Dienstberufe gibt es ebenfalls: B20 „Nachtpförtner im Rathaus“, B24 „Ratsdiener“, B26 „Briefträger im Ruhestand“, B34 „Lagerarbeiter“, B42 „Verwaltungsangestellter im Rathaus“. 2) Es ist Spieltext, denn das Spiel zeigt den Beruf an: erkundung.dart:320 `'${b.name} (${b.beruf})'`. 3) Der Punkt ist schon abgewogen. In E44 unter „Bewusst so“ steht: „Geringe Befunde R17 G1–G5 (Geschlechterrollen in Dienstberufen …): nach der Abbruchregel (E40) in FÜR DEN NUTZER.“ FUER-DEN-NUTZER.md Z. 51 sagt: „Dienstberufe sind bei den Bewohnerinnen häufiger (8 von 21 Frauen, 3 von 23 Männern) … Ausgleichen ist eine Datenänderung plus neue Prüfung.“ R17 G1 (gegenpruefer_inhalt_17_bericht.md Z. 33–35) nannte schon B15, B21, B25, B35 und B41 mit Zählung. Der Befund bringt keinen neuen Grund. „Nicht entschieden, nur weitergereicht“ beschreibt genau die Entscheidung in E44 (Nutzerpunkt). Neu ist nur B38, und gerade dort gibt es männliche Gegenstücke (Kürschner, Hutmacher, Schuhmacher). Dass der Befund jetzt „mittel“ statt „gering“ heißt, ist kein neuer Sachgrund. 4) Als neuer Befund ist er nicht haltbar. Leitplanke 4 (A-702t) verbietet „Klischees über … irgendeine andere Gruppe“. Hier steht aber kein abwertender oder klischeehafter Text über Frauen. Es geht um eine Verteilung über Einzelbesetzungen (n=1 je Kategorie), und Frauen haben auch Berufe wie Tierärztin (B09), Grafikerin (B27) und Museumskustodin (B23) sowie die Inhaberinnen B01 und B07. Die Schieflage ist echt, aber sie ist bekannt und liegt dokumentiert beim Nutzer.
- Vorschlag: Keine Änderung im Nachtlauf. Der Punkt bleibt beim Nutzer (FUER-DEN-NUTZER.md Z. 51). Wenn er ausgeglichen werden soll, genügt der Tausch eines Geschlechts bei einer Figur, z. B. B41 oder B35 männlich mit neuem Namen, oder ein Berufstausch, z. B. B34 und B35. Danach sind karten_test und eine neue Sichtprüfung nötig.
