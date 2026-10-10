# L4-WEISSLISTE · Kanonwächter · Variante V1

**Auftrag:** Jede Kandidatin der Weißliste (A-3, Zeilen 111–112) prüfen auf pfadgleich, Kettenfreiheit und Freiheit von Täter- und Tatzeit-Hinweisen. Dazu den neuen Kandidaten `spur_stirnlampe` prüfen und für herausgenommene Zeilen einen Ersatz aus dem Kanon suchen.

**Gelesen (nur lesend):** `/home/user/bw-varianten/V1/kanon/` mit A-3, A-4, `beobachtungen.json` (33 Beobachtungen), `gegenstaende.json` (28 Gegenstände, 36 Spuren), `entscheidungen.json`, `bonus.json` (12 neutrale Hinweise), `setting.json` (3 Lacher), `zeitleiste.json`, `tatmatrix/` (basis und vier Pfade), `fall.json`, `wahrnehmung.json`, `raeume.json` und `texte/`.

**Schreibweise:** Kennungen stehen wörtlich. Anzeigenamen stehen nur in Klammern: `b_hana_wachs` (wer: meryem = Hana), `b_pawel_schneider` (wer: hakan = Pawel), `lacher_ruestung` (wer: selin = Sibel), `lacher_kamin` (wer: meryem = Hana).

## Prüfregeln

- **pfadgleich:** Beobachtung mit `pfade: alle` bzw. Spur mit `entstehtWenn: immer`, und keine Pfaddatei (`tatmatrix/ahmet|fatma|olli|can.json`) ändert den Befund. Lacher haben in `setting.json` kein Feld `pfade`; sie gelten als pfadgleich, weil sie in keiner Pfaddatei vorkommen.
- **in Kette:** jede Nennung in `entscheidungen.json` · `begruendung.*.kette`, nicht nur `fakt:`-Quellen. Inhaltliche Nähe steht gesondert.
- **verrät Täter:** belastet, entlastet oder widerlegt eine Kernperson (ahmet, fatma, olli, can; `fall.json` · `kernverdaechtige`), oder der Text legt eine Kernperson als Täter nahe.
- **verrät Tatzeit:** eine absolute Uhrzeit oder Zeitspanne im Fenster 23:50–00:15 (Text oder Gegenstandsbeschreibung), die weder in `zeitleiste.json` steht noch schon in einem Pflichtgespräch- oder Dossier-Text. Relative Verweise auf öffentliche Ereignisse („kurz nach dem Scheppern“) zählen nicht.
- **A-4-Zusatz:** nicht verborgen (Kanal ≠ verborgen; Gegenstand `sichtbar: true`), keine Faktquelle (`fakten[].quelle`), kein Nebendelikt einer Kernperson, keine falsche Fährte.

## 1. Tabelle

| Kandidat | Fundstelle | pfadgleich | in Kette | verrät | Urteil |
|---|---|---|---|---|---|
| b_baran_rufe | beobachtungen.json · b_baran_rufe (Z. 369) | ja: pfade „alle“; die Rufe stehen in tatmatrix/basis.json · plaene.schneider (23:58:13, 23:58:30) | nein. Inhaltlich gleich wie das Kettenelement b_detektiv_gehoert (e1_1, e1_2, e1_3, alle) | Täter nein. Tatzeit nein: Text ohne Uhrzeit; Wortlaut schon in texte/gespraeche-r1-b3.json (Z. 87), r2-b3 (Z. 87), r3-b3 (Z. 109) | bleibt (Dublette zu Pflichtgespräch) |
| b_hana_wachs (wer: meryem = Hana) | beobachtungen.json · b_hana_wachs (Z. 321) | ja: pfade „alle“; ev_wachsgeruch in tatmatrix/basis.json · ereignisse (23:58:40) | nein. Thematisch nah an den Wachs-Indizien f_z_* (nicht identisch) | Täter nein („Richtung Theke“ nennt niemanden). Tatzeit nein: „kurz nach dem Scheppern“ ist relativ zum öffentlichen Schlag (zeitleiste z_schlag); Wortlaut schon in gespraeche-r1-b3 · g_meryem_1_1. Abhängig vom Luftzug aus lacher_kamin | bleibt (Abhängigkeit von lacher_kamin) |
| b_serkan_tor (wer: serkan) | beobachtungen.json · b_serkan_tor (Z. 397) | ja: pfade „alle“; tatmatrix/basis.json · plaene.serkan | nein | Täter nein („niemand ist hinaus“ ist öffentlich: zeitleiste z_forderung). Tatzeit: Grenzfall, nein. „von kurz vor zwölf bis nach zwölf“ steht schon in gespraeche-r1-b4 · g_serkan_1_1 (auch r2, r3) | bleibt (Dublette; im Bonus neutral, siehe Frage 7) |
| b_pawel_schneider (wer: hakan = Pawel) | beobachtungen.json · b_pawel_schneider (Z. 473) | ja: pfade „alle“ | nein | Täter nein. Tatzeit nein (keine Uhrzeit). Wortlaut schon in gespraeche-r1-b5 · g_hakan_1_1 (auch r2, r3) | bleibt (Dublette) |
| b_schneider_erinnerung (wer: schneider) | beobachtungen.json · b_schneider_erinnerung (Z. 551) | ja: pfade „alle“ | nein. Gesichts-Aussage wie in der Kette e2_1/can | Täter JA: belastet = ["can"]; der sehen-Beleg hat das Detail „erkannt“. Tatzeit nein (keine Uhrzeit im Text; Beleg 23:58:09–23:58:13) | fällt heraus (verrät Täter) |
| b_tim_gesicht (wer: tim) | beobachtungen.json · b_tim_gesicht (Z. 234) | ja: pfade „alle“; Can flieht in allen Pfaden (ev_can_losgerissen 23:58:28) | nein (Kennung). Inhaltlich eine der „vier Gäste“ in entscheidungen.json Z. 523 (e2_1/can), siehe Frage 11 | Täter JA: belastet = ["can"]; ein leuchtendes Gesicht ist die Maske von Can (wahrnehmung.json · licht · regel). Tatzeit nein | fällt heraus (verrät Täter; Teil der Kettenaussage) |
| spur_wachs_boden | gegenstaende.json · wachs_boden · spur_wachs_boden (Z. 654) | ja: entstehtWenn „immer“; rolle „alle: umgebung“ | nein. Nähe zu karte:kerzenstaender (e3_2), nicht identisch | nein (keine Uhrzeit, kein Name) | bleibt |
| spur_steckdose_verschmort | gegenstaende.json · mehrfachsteckdose_tim · spur_steckdose_verschmort (Z. 524) | ja: „immer“; „ausgangslage“ | nein | Täter nein (Tim ist nicht kernverdächtig, fall.json). Tatzeit nein: Ursache ist öffentlich (zeitleiste z_steckdose 23:57:50, z_ausfall 23:58). Hinweis: nebendelikt nd_kurzschluss ist Tims Geheimnis (texte/dossiers-b2.json · tim · verbirgt) | bleibt (Hinweis, Frage 8) |
| spur_laterne_unberuehrt | gegenstaende.json · notlaterne · spur_laterne_unberuehrt (Z. 548) | ja: „immer“; „umgebung“ | nein | Täter nein. Tatzeit nein: keine Uhrzeit; der Ablauf passt zu z_zusammenstoss (23:58:13) | bleibt |
| spur_torte | gegenstaende.json · torte · spur_torte (Z. 750) | ja: „immer“; „umgebung“; kein Pfadplan berührt die Torte | nein | nein | bleibt |
| lacher_verlaufen (20:15, wer: olli) | setting.json · lacher · lacher_verlaufen (Z. 31–37) | ja: setting; zeitleiste z_verlaufen pfade „alle“ | nein | Täter JA als falsche Fährte: traegt „Falsche Fährte: Olli kennt den Vorratsraum.“ Tatzeit nein (20:15) | fällt heraus (A-4 Abweichung 6; falsche Fährte) |
| lacher_ruestung (21:00, wer: selin = Sibel) | setting.json · lacher · lacher_ruestung (Z. 23–29) | ja: setting; zeitleiste z_ruestung pfade „alle“; texte/erzaehler-intro.json (besetzt/npc) | nein. Ort an_der_ruestung wie karte:ruestungshelm (e3_1/can), kein Kettenglied | Täter nein. Tatzeit nein (21:00). Hinweis: Vitrinenscheibe lose ab 21:00 (traegt) | bleibt |
| lacher_kamin (23:30, wer: meryem = Hana) | setting.json · lacher · lacher_kamin (Z. 39–45) | ja: setting; zeitleiste z_qualm pfade „alle“ | nein. Stützt die Zeugin von b_hana_umschlag (e2_1), selbst kein Kettenglied | Täter nein. Tatzeit nein (23:30). Hinweis: traegt „Gerüche wandern mit“ ist Voraussetzung für b_hana_wachs; Lichtschacht-Klappen (Frage 10) | bleibt |
| h_ahmet_1_neutral | bonus.json · h_ahmet_1_neutral · text („Beim Scheppern war Tim am Sicherungskasten im Kaminsaal.“), quelle b_tim_gesicht | ja: gleicher Wortlaut in h_fatma_1, h_olli_1, h_can_1 | nein | Täter nein. Tatzeit nein (Tims Standort steht schon in g_tim_1_2). Qualität neutral | fällt heraus (A-4 Abweichung 6) |
| h_fatma_1_neutral | bonus.json · h_fatma_1_neutral · text, Wortlaut wie h_ahmet_1 | ja (gleicher Wortlaut in allen vier Pfaden) | nein | wie h_ahmet_1_neutral | fällt heraus (A-4 Abweichung 6) |
| h_olli_1_neutral | bonus.json · h_olli_1_neutral · text, Wortlaut wie h_ahmet_1 | ja | nein | wie h_ahmet_1_neutral | fällt heraus (A-4 Abweichung 6) |
| h_can_1_neutral | bonus.json · h_can_1_neutral · text, Wortlaut wie h_ahmet_1 | ja | nein | wie h_ahmet_1_neutral | fällt heraus (A-4 Abweichung 6) |
| h_ahmet_2_neutral | bonus.json · h_ahmet_2_neutral · text („Tim hat trotz Warnung die alte Mehrfachsteckdose benutzt.“), quelle b_tim_kurzschluss | ja: gleicher Wortlaut in h_fatma_2, h_olli_2, h_can_2 | nein | Täter nein. Tatzeit nein (öffentlich: z_steckdose 23:57:50). Quelle ist verborgen (beobachtungen.json · b_tim_kurzschluss · kanal) | fällt heraus (A-4 Abweichung 6) |
| h_fatma_2_neutral | bonus.json · h_fatma_2_neutral · text, Wortlaut wie h_ahmet_2 | ja | nein | wie h_ahmet_2_neutral | fällt heraus (A-4 Abweichung 6) |
| h_olli_2_neutral | bonus.json · h_olli_2_neutral · text, Wortlaut wie h_ahmet_2 | ja | nein | wie h_ahmet_2_neutral | fällt heraus (A-4 Abweichung 6) |
| h_can_2_neutral | bonus.json · h_can_2_neutral · text, Wortlaut wie h_ahmet_2 | ja | nein | wie h_ahmet_2_neutral | fällt heraus (A-4 Abweichung 6) |
| h_ahmet_3_neutral | bonus.json · h_ahmet_3_neutral · text („Serkan stand die ganze Zeit am Außentor. Es war abgeschlossen, niemand ist hinaus.“), quelle b_serkan_tor | ja: gleicher Wortlaut in h_fatma_3, h_olli_3, h_can_3 | nein | Täter nein. Tatzeit nein (öffentlich: g_serkan_1_1) | fällt heraus (A-4 Abweichung 6) |
| h_fatma_3_neutral | bonus.json · h_fatma_3_neutral · text, Wortlaut wie h_ahmet_3 | ja | nein | wie h_ahmet_3_neutral | fällt heraus (A-4 Abweichung 6) |
| h_olli_3_neutral | bonus.json · h_olli_3_neutral · text, Wortlaut wie h_ahmet_3 | ja | nein | wie h_ahmet_3_neutral | fällt heraus (A-4 Abweichung 6) |
| h_can_3_neutral | bonus.json · h_can_3_neutral · text, Wortlaut wie h_ahmet_3 | ja | nein | wie h_ahmet_3_neutral | fällt heraus (A-4 Abweichung 6) |
| spur_stirnlampe (neuer Kandidat) | gegenstaende.json · stirnlampe_tim · beschreibung (Z. 765), sichtbar (Z. 770), spur_stirnlampe (Z. 773–781) | ja: „immer“; „ausgangslage“. Lichtplan in tatmatrix/basis.json · plaene.tim (23:59:40) gilt in allen Pfaden | nein | Täter nein (Tim nicht kernverdächtig). Tatzeit JA: 23:59:40 steht in der Beschreibung, nicht in zeitleiste.json. Verborgen JA: sichtbar false | fällt heraus (siehe Abschnitt 2) |
| spur_handykorb (Ersatz, nicht in A-3) | gegenstaende.json · handykorb · spur_handykorb (Z. 728); Beschreibung Z. 721; sichtbar Z. 725 | ja: „immer“; „ausgangslage“; kein Pfadplan berührt den Korb | nein | Täter nein. Tatzeit Grenzfall: die Beschreibung nennt „seit 23:50“ (Fensterbeginn, nicht in zeitleiste.json); „ab 23:55“ steht öffentlich in z_tortenplan. Fundtext (zeigt) ohne Uhrzeit | nur bedingt als Ersatz (Frage 2) |

## 2. spur_stirnlampe

- **Kennung vorhanden:** ja. `gegenstaende.json` · `stirnlampe_tim` · `spuren` (Z. 773–781). Alle Prüfungen aus Schritt 2 sind durchgeführt.
- **pfadgleich:** ja. `entstehtWenn: immer`, `rolle: alle: ausgangslage`. Der Lichtplan `tatmatrix/basis.json` · `plaene.tim` (Z. 390, `licht_stirnlampe` an 23:59:40) gilt in allen Pfaden.
- **in Kette:** nein. Keine Nennung in `entscheidungen.json`; keine Faktquelle.
- **verrät Täter:** nein. Tim ist nicht kernverdächtig (`fall.json` · `kernverdaechtige`).
- **verrät Tatzeit:** JA.
  - `gegenstaende.json` · `stirnlampe_tim` · `beschreibung` (Z. 765): „um 23:59:40 fand er sie auf dem Boden.“ Die Zeit liegt im Fenster und steht nicht in `zeitleiste.json`. Dieselbe Zeit steht in `raeume.json` · `licht_stirnlampe` · `an` (Z. 1131) und in `figuren.json` · `tim` · `blackoutAlibi` (Z. 467).
  - Der Fundtext (`zeigt`, Z. 778) lautet „Damit hat Tim um Mitternacht den Sicherungskasten gefunden.“ Die Mitternacht deckt sich mit `zeitleiste.json` · `z_licht` (00:00), ist also nicht neu. „Funktioniert“ ist neu, aber harmlos.
  - Ob die Gegenstandsbeschreibung dem Detektiv gezeigt wird, regelt `texte/SCHLUESSEL.md` (Fundtexte sind `zeigt` und `harmlos`). Der Ausschluss hängt aber nicht allein daran, siehe nächster Punkt.
- **verborgen:** JA. `sichtbar: false` (Z. 770). Der Gegenstand hängt am Hals des Trägers und liegt nicht offen. Das verletzt „nicht verborgen“ (A-4).
- **Urteil:** fällt heraus aus zwei unabhängigen Gründen: nicht sichtbar (A-4) und Tatzeit 23:59:40.
- **Ersatz:** keiner. Eine Fassung ohne Zeitangabe („Funktioniert.“) wäre eine neue Kanonzeile. Kanon 1.0 bleibt aber unverändert.
- **Was es zur Stirnlampe im Kanon gibt:** `raeume.json` · `licht_stirnlampe` (Z. 1123–1135); `gegenstaende.json` · `stirnlampe_tim` (Z. 762–784); `figuren.json` · `tim` · `distinguishingFeature` (Z. 463) und `blackoutAlibi` (Z. 467); `STORY-BIBEL.md` ab Z. 1149; `A-3-KANON-AUSZUG.md` Z. 120 führt sie als Werkzeug +1 in der Zugschicht.

## 3. Ergebnis und Ersatz

- **bleibt (10 aus A-3):** b_baran_rufe, b_hana_wachs, b_serkan_tor, b_pawel_schneider, spur_wachs_boden, spur_steckdose_verschmort, spur_laterne_unberuehrt, spur_torte, lacher_ruestung, lacher_kamin.
- **fällt heraus:**
  - b_schneider_erinnerung: verrät Täter (belastet can; Gesicht „erkannt“).
  - b_tim_gesicht: verrät Täter (belastet can); zugleich eine der „vier Gäste“ der Kette e2_1/can.
  - lacher_verlaufen: A-4 Abweichung 6; falsche Fährte gegen olli.
  - 12 neutrale Bonus-Hinweise: A-4 Abweichung 6 (siehe Tabelle).
  - spur_stirnlampe (neuer Kandidat): Tatzeit 23:59:40 und nicht sichtbar.
  - spur_handykorb (Ersatzvorschlag): Grenzfall, nur bedingt zulässig.
- **Zahl verbleibender pfadgleicher Zusatzfunde:** **10** (sicher). Mit dem bedingten Ersatz spur_handykorb: **11**.
- **Ersatz je herausgenommener Zeile:**
  - neutrale Bonus-Hinweise → **spur_handykorb** (bedingt). Beleg: `gegenstaende.json` · `spur_handykorb` · `zeigt` („Alle Handys liegen darin. Hinter den Mauern hat keines Empfang.“), `entstehtWenn: immer`, nicht in `entscheidungen.json`, in keinem Text verwendet.
  - lacher_verlaufen → kein Ersatz im Kanon. `setting.json` · `lacher` enthält nur drei Lacher; die anderen beiden stehen schon in der Liste.
  - b_tim_gesicht → kein Ersatz. Tim hat außer b_tim_gesicht nur b_tim_kurzschluss (Kanal verborgen, `beobachtungen.json`), den Gegenstand mit spur_steckdose_verschmort (schon in der Liste) und spur_stirnlampe (fällt durch).
  - b_schneider_erinnerung → kein Ersatz. Schneider hat keine weitere pfadgleiche Beobachtung. Seine Spuren fallen durch: spur_klemmbrett_tuer (belastet olli), spur_klemmbrett_miete (nebendelikt nd_mietgeld, ahmet), spur_fasern_kapuze (in A-3 ausgeschlossen).
- **Weitere geprüfte Ersatzkandidaten, verworfen:**
  - b_tugba_notiz: widerlegt die Lüge von Olli (`luege_olli_tafel`, STORY-BIBEL.md Z. 321): verrät Täter.
  - Nebendelikte von Kernpersonen als Spur (spur_jacke_namensliste, spur_umschlag_aufschrift, spur_mietgeld, spur_quittung, spur_schatulle_da, spur_maske_da, spur_mantel_glas, spur_tuer_beschlag, spur_weste_moebelwachs): ausgeschlossen (A-4).
  - Faktquellen: spur_vitrine_leer, spur_handschuh_russ, spur_foto_streit, spur_notiz_fehlende, spur_staender_verbogen: ausgeschlossen (A-4).
  - Verborgen oder pfadabhängig: spur_moebelwachs (sichtbar false), alle spur_*_bund, spur_*wachs (path-abhängig), spur_griff_*, spur_fuss_splitter, spur_ring_messing.
  - nd_parken (murat) und nd_schmiere (zeynep): kein Spur- und kein Beobachtungseintrag; nur Dossier-Geheimnisse (`texte/dossiers-b3.json`).
- **Zum Ziel 14 fehlen 4** (ohne Ersatz) bzw. **3** (mit spur_handykorb). Siehe OFFENE FRAGE 1.

## 4. Offene Fragen

1. **OFFENE FRAGE:** Es fehlen 4 pfadgleiche Zusatzfunde zum Ziel 14 (3, wenn spur_handykorb zählt). Geprüft wurden alle 33 Beobachtungen, alle 36 Spuren, die 3 Lacher und die 12 neutralen Hinweise. Außerhalb der Liste erfüllt kein Kandidat alle Kriterien. Das Ziel 14 ließe sich nur erreichen, wenn spur_handykorb zählt und zusätzlich die drei Verletzer b_tim_gesicht, b_schneider_erinnerung und spur_stirnlampe aufgenommen werden (10 + 1 + 3 = 14). Das verletzt die Täter- und Tatzeit-Regel. Ich empfehle, das Ziel als Teilerfüllung zu melden.
2. **spur_handykorb:** Zählt „seit 23:50“ in der Beschreibung als bloße Standangabe ohne Tatbezug? Wenn ja, ist der Kandidat pfadgleich und tatzeitfrei, und die Zahl wird 11. Entscheidung nötig.
3. **Tatzeit-Auslegung:** A-3 Z. 115 („Kein neues Wissen über 23:50–00:15“) wurde hier so gelesen: absolute Uhrzeiten im Fenster sind nur zulässig, wenn sie öffentlich sind (zeitleiste mit `pfade: alle` oder Pflichtgesprächstext). Relative Verweise auf öffentliche Ereignisse sind zulässig. Bitte bestätigen.
4. **„Abweichung 6“** steht nicht in `A-4-C4-WEISSLISTE.md`. Die Datei enthält nur „überholt“ (Z. 1) und die Liste „Herausgenommen“ (Z. 11). Ich habe die Vorgabe aus dem Auftrag übernommen. Quelle bitte prüfen.
5. **Veralteter Verweis:** A-3 Z. 112 verweist auf „Anhang C4“, den A-4 selbst als „überholt“ führt.
6. **Pflichtgesprächs-Dubletten:** b_baran_rufe, b_hana_wachs, b_serkan_tor, b_pawel_schneider und b_tim_gesicht stehen wörtlich in `texte/gespraeche-*.json` und zum Teil in den Dossiers (weiss). Soll ein Zusatzfund Wissen wiederholen, das am Tisch schon steht? b_schneider_erinnerung wird dagegen in keinem Text verwendet; ihre Verwendung ist unklar.
7. **Neutral eingestufter Inhalt:** Der Satz zu b_serkan_tor steht in `bonus.json` als „neutral“ („ohne neuen Wert“). Ähnlich verweist spur_handykorb auf öffentliche Inhalte (`setting.json` · `empfang`; `zeitleiste.json` · `z_tortenplan`). Zählen solche Zusatzfunde trotzdem?
8. **Geheimnis gegen Zeitleiste:** `texte/dossiers-b2.json` · `tim` · `verbirgt` nennt die Mehrfachsteckdose als Geheimnis von Tim. `zeitleiste.json` · `z_steckdose` (23:57:50, pfade alle) macht den Verstoß aber öffentlich. Dasselbe Muster gilt für nd_schmiere (`z_can_vorrat` öffentlich, `dossiers-b3` verbirgt). Vor der Aufnahme von spur_steckdose_verschmort klären.
9. **Abhängigkeit:** b_hana_wachs braucht den Luftzug aus lacher_kamin („Gerüche wandern mit“). Fällt lacher_kamin weg, fehlt der Grund für den Geruch aus Richtung Theke (`wahrnehmung.json` · `riechen`).
10. **Lichtschächte:** lacher_kamin lässt die Lichtschacht-Klappen aufreißen (`setting.json` · `lacher_kamin` · `was`). Die Feste Rahmen (A-3 Z. 116) regeln nur Außentor und Hoftür. Ob Lichtschächte als Abgang gelten, ist nicht geregelt. Das ist für die Täterfrage relevant.
11. **Kanon-Lücke bei den „vier Gästen“:** Der Kettentext e2_1/can (`entscheidungen.json` Z. 523) nennt „Vier Gäste sahen ein leuchtendes Gesicht“. Pfadgleiche Sichtungen dieser Art gibt es genau vier: b_marek_gesicht, b_selin_gesicht, b_tim_gesicht, b_zeynep_gesicht (Inferenz). Die Kette nennt nur b_marek_gesicht. A-4 nennt zudem b_zeynep_gesicht (Kette e3_3) nicht; ebenso fehlen b_wojtek_olli_satz (e3_1/olli) und b_hana_umschlag (e2_1) in der Ausschlussliste. Diese drei sind keine Kandidaten, sollten aber dokumentiert werden.
12. **Pfadgleichheit der Lacher:** `setting.json` hat kein Feld `pfade`. Ich habe sie aus dem Fehlen in `tatmatrix/*.json` abgeleitet.

## Selbstprüfung

- (a) Jeder A-3-Kandidat hat eine Zeile: ja (6 Beobachtungen, 4 Spuren, 3 Lacher, 12 neutrale Hinweise).
- (b) Jede Zeile hat eine Fundstelle: ja.
- (c) spur_stirnlampe ist beantwortet: ja (Abschnitt 2).
- (d) Zahl der verbleibenden Zusatzfunde ist genannt: 10 sicher, 11 mit bedingtem Ersatz.
- (e) Jeder Ersatzvorschlag hat einen Beleg: ja (spur_handykorb, `gegenstaende.json` · `spur_handykorb`).
- (f) Keine erfundene Kennung: ja, alle Kennungen sind gegen die Dateien geprüft.

Ergebnis: 6/6.

=== ENDE L4-WEISSLISTE · BEREIT ZUR RÜCKGABE ===
