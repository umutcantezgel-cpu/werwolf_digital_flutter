HEAD 72df36b

# Gegenprüfung Inhalt, Runde 13 (A-702n) · gegenpruefer_inhalt_13

Geprüfter Stand: HEAD 72df36b (nachtlauf/burgstadt, Fast-Forward von d92a675; Worktree vor dem Bericht sauber).
Scanner: `dart run bin/leitplanken.dart --burgstadt` (Dart aus /opt/flutter/bin): 119 Dateien, 0 Treffer, Exit 0.

## Urteil

- Leitplanken eingehalten: ja (kein harter Verstoß; zwei Grenzfälle, M-2 und M-3)
- Kanontreu: nein (M-1 und G-1)
- Plagiatsfrei: ja (Stichwort- und Namensprüfung, keine Übernahme erkannt)
- Befunde: hoch 0 · mittel 3 · gering 2

## Befunde

### M-1 · mittel · Kanontreu · Phasenbeginn Phase 1

- Datei/Stelle: nachtlauf/kanon/ANPASSUNG.md, Zeile 39 (@STADT-05 [O]); Zeile 65 (Stadtzeiten in @LISTE-ZEITEN).
- Zitat: „Phase 1 beginnt um 00:25 und endet mit dem Schlag um 01:30“; „der Uhrturm schlägt die Nacht um 00:25, 01:30, 03:00 und 04:30“.
- Gegenlage: krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md, Zeile 163 (Z-0030, [L]) setzt den Beginn der Ermittlung (Phase 1) auf 00:30. Öffentlich: @LISTE-ZEITEN (K1 Zeile 29, [O]) „Beschluss zum Weiterfeiern (bis 00:30)“; @OA-29 (K1 Zeile 61, [O]) gibt den Auftrag des Burgwarts um 00:25.
- Regel: Kanon v1.0 (VERSION.md: bestehende Tatsachen ändern sich nur über ÄNDERUNG und Protokoll). Zeitangaben müssen zur Zeitleiste passen.
- Vorschlag: STADT-05 auf Phasenbeginn 00:30 setzen; der Uhrturmschlag um 00:25 wird als Ankündigung formuliert (Zeile 65 entsprechend). Alternativ Z-0030 per ÄNDERUNG klären. Entscheidung beim Kanonverantwortlichen.

### M-2 · mittel · Leitplanke Herkunft · Besetzungsmuster (Grenzfall)

- Datei/Stelle: K1-GRUNDWAHRHEIT.md, Datensatz @FM-1 [L] (Zeile 80). Der L-Datensatz wird hier nur paraphrasiert.
- Sachverhalt: FM-1 ordnet die Herkunftsgruppen Tatfunktionen zu. Die belastenden Rollen liegen bei der Mehrheitsgruppe; die einzige Figur mit bosnischen Wurzeln in einer Verdachtsrolle ist R01 (Hauptverdächtiger ohne Verbrechen). Den Verdacht gegen R01 trägt seine Stablampe „HODŽIĆ VT · 3“ (K1 Zeile 198, @BSO-03 [O]; K3-HINWEISE.md Zeile 48, @H-28 [O]). Das Klebeband trägt den Firmenkürzel des R01 (VT = Veranstaltungstechnik). Der Name ist damit eine Eigentumsmarkierung, kein Herkunftsindiz.
- Regel: Leitplanke 2 („Herkunft ist nie Motiv, Indiz oder Pointe“); K8-STILBLATT.md Zeile 24 (keine Witze über die Herkunft). Formal eingehalten; das Besetzungsmuster widerspricht aber dem Sinn der Regel.
- Neuer Grund gegen E38/E39: Dort wurden nur Familienfelder geprüft, nicht die Zuordnung von Herkunft zu Tatfunktionen.
- Vorschlag: FM-1 aus der Lösungsebene streichen oder so umbauen, dass der Fehlverdacht nicht an eine Herkunftsgruppe gebunden ist. Die Begründung gehört ins Protokoll.

### M-3 · mittel · Leitplanke „kein Text, der die Täterin nahelegt“ · eigene Mechanik (Grenzfall)

- Datei/Stelle: packages/burgstadt_core/data/rollen/faehigkeiten.json, rollen[2] (R03, Fähigkeit „Spur verwischen“), Feld wirkung.details (Entwicklertext). Spielwirkung nach E18 und E27 H1: Spurenart „verwischt“ im Detektivblick.
- Zitat (Entwicklertext): „bleibt für alle mit Detektivblick als verwischt erkennbar“.
- Regel: Leitplanke 4 (kein Text, der vor der Auflösung die Täterin nahelegt). Nach E27 M5 gilt sie für unsere Zusatztexte, nicht für Spuren des Kanons. Die Verwischen-Mechanik steht nicht im Kanon (das Wort „verwisch“ kommt in K1 bis K9 und in ANPASSUNG nicht vor). Sie ist ein Zusatz und fällt unter die Leitplanke.
- Neuer Grund gegen E27 H1: E27 hat geprüft, wer das Ereignis erfährt (nur R03). Nicht geprüft ist, dass der Zustand „verwischt“ für alle sichtbar ist und nur R03 ihn erzeugen kann. Nach Ausschluss zeigt der Marker auf R03.
- Vorschlag: Die Fähigkeit zusätzlich einer unverdächtigen Rolle geben (das Gegenspiel bleibt, der Marker zeigt nicht mehr auf R03), oder den Zustand nur R03 sichtbar machen. Der Kanon ist nicht betroffen.

### G-1 · gering · Kanontreu · Datenkopie Beruf R04

- Datei/Stelle: packages/burgstadt_core/data/rollen/faehigkeiten.json, rollen[3].beruf.
- Zitat: „Vertriebler für Medizintechnik (so erzählt er es)“.
- Gegenlage: K2-ROLLEN-KERN.md Zeile 34 (@R04-STAMM [O]): „Beruf: Vertriebler für Medizintechnik“; der Zusatz ist in v1.0 gestrichen. ANPASSUNG ändert dieses Feld nicht.
- Vorschlag: Zusatz streichen. Die Verhörzeile zu R04 (K2-ROLLEN-KERN.md Zeile 40) nennt den Steckbrief als „Fassade“; das bleibt konsistent, weil der Steckbrief die öffentliche Fassade ist.

### G-2 · gering · Leitplanke „keine Klischees über irgendeine andere Gruppe“ · Muster (Abwägung)

- Stellen: ANPASSUNG.md Zeile 80 (@R15-STAMM [O]): „lassen sich in Mathe nur von Derya helfen („Von Papa nehmen sie nichts an“)“. Zeile 82 (@R18-STAMM [O]): die Großmutter „fragt am Ende, wann sie endlich Richterin wird“. Zeile 72 (@R05-STAMM [O]): die Großmutter wohnt im Haus und führt das Sonntagsritual. K2-ROLLEN-13-20.md Zeile 9 (@R13-GEHEIM [G]): Café mit Großmutter-Rezepten; Angst vor den Eltern.
- Befund: In den vier Familien mit nichtdeutschen Wurzeln (R05, R13, R15, R18) steht ein Erwartungs- oder Autoritätskonflikt mit der älteren Generation bzw. dem Vater. Einzeln unauffällig; zusammen ein Muster, das den Klischee-Verdacht der Leitplanke trägt.
- Neuer Grund gegen E39 B-08: Dort wurde nur der Wohnort der Großmutter bewertet, nicht das Erwartungsmuster bei R15 und R18.
- Vorschlag: den R15-Satz und den R18-Richterinnen-Satz herkunftsneutral fassen (wie E38 bei den Familienfeldern) oder den Konflikt auf eine deutsche Familie verteilen.

## Hinweise ohne Befund

- Strickware: R01 trägt die graue Strickmütze, R03 die dunkelgrüne Strickjacke mit Zopfmuster, R04 den olivgrünen Strickpullover. Der Hinweis „Ärmel, was Gestricktes, Wolle“ (@BW-AUSSAGE-3, @H-14) passt damit auf mehrere Figuren; getrennt werden sie über die Stollen-Spur (H-15, BS-13). Das ist eine Fairness-Frage für den Kanon, kein Textfehler.
- E40 „Dutt-Frisur“ (bewusst offen): nicht gezählt, keine neue Begründung.
- Stablampe: siehe M-2.
- Lagerunde- und Gesprächsfenster-Zeiten (ZM-2) stehen nicht in den Datendateien; ihre Umsetzung im Code habe ich nicht geprüft.

## Kanon-Diff 659d3ed..HEAD und Overlay (Punkt 15)

- 29 geänderte [O]-Datensätze in K1 bis K9 gelesen (je alt und neu). GESAMT-KANON.md ist nicht Teil der Prüfung.
- LISTE-ZEITEN: der neue Wortlaut ist im Overlay übernommen, die Stadtzeiten sind angehängt (ANPASSUNG Zeile 65). Konsistent bis auf M-1.
- ERSETZE-17 wirkt: „bewusstlos“ ist in den Datendateien als „benommen“ geführt (rollen[5], Zustand des Burgwarts). Keine Reste ersetzter Begriffe (u. a. Pierogi, Newroz, Wigilia, Revani, Brockengespenst, Harz, Witwe, Putzfrau) in den Datendateien.
- Familienfelder: die Overlay-Fassungen R01 bis R20 sind mit den Datendateien konsistent. Die Abweichungen stehen in M-2, G-1 und G-2.
- R03 und R04 in rollen.json: Rampe 5 = grün, 6 = blau, 2 = holz (packages/pixel_engine/lib/src/figur/bewohner_karten.dart). R03: grüne Strickjacke, weiße Bluse, blaue Jeans, braune Wanderstiefel. R04: olivgrüner Pullover, braune Stiefel. Kein Notizbuch mehr (E41). Das stimmt mit K9 und K2 überein.

## Prüfumfang und Grenzen

- Vollständig gelesen: A-702n; nachtlauf/ENTSCHEIDUNGSLOG.md (E23 bis E41 geprüft); nachtlauf/kanon/ANPASSUNG.md; FORMAT.md, VERSION.md, LEITPLANKEN-AUSNAHMEN.md; alle 223 [O]-Zeilen der K1 bis K9; die Textwerte von bewohner.json, stadt/haeuser.json, innenraeume/haeuser.json, innenraeume/fallorte.json, rollen/faehigkeiten.json, texte/erzaehler.json, texte/tutorial.json, figuren/karten.json und figuren/rollen.json (rein ASCII-Kennungen wie Frisur-IDs nicht ausgegeben); teile_kleidung.json und teile_koepfe.json enthalten nur Kennungen; 78 Dart-Literale mit mindestens 25 Zeichen aus lib/burgstadt und packages/burgstadt_spiel/lib.
- Nicht Zeile für Zeile gelesen: die [G]-Zeilen (559) und [L]-Zeilen (429) der K-Dateien. Geprüft per Stichwortsuche (Alkohol, Drogen, Blut und Verletzung, Hexen und Teufel, Herkunft und Volksgruppen, Kulturzuschreibungen, Familienfelder, Täterinnen-Echos) mit Lesen aller Treffer. Die Vorgabe „alle Dateien vollständig gelesen“ ist damit nur teilweise erfüllt.
- Nur per Scanner geprüft: lib/ui, lib/game, lib/l10n.
- Plagiat: Figuren- und Werknamen (u. a. Sherlock, Potter, Dracula, Tolkien, Narnia, Winnetou) sowie Redewendungen gesucht; keine Übernahme. „Geisterstunde“ (Track-Titel) ist eine geläufige Wortverbindung. Keine Volltext-Websuche.
- Keine früheren Prüfberichte gelesen; der Berichtsordner A-702 wurde nicht durchsucht. Helfer-Dateien nur im Scratchpad-Unterordner gegenpruefer_inhalt_13.

## Git-Stand (Hinweis für den Orchestrator, kein Befund)

- Worktree: HEAD 72df36b = origin/nachtlauf/burgstadt. Vor dem Bericht sauber. Die Berichtsdatei ist die einzige neue, nicht getrackte Datei.
- origin/main steht auf d92a675 und ist Vorfahr von 72df36b: ein Fast-Forward um 95 Commits ist möglich. Der lokale Branch main (fb0ec24) liegt 13 hinter origin/main.
- Lokal: 63 Branches. Kein Commit liegt nur lokal (alle auf origin-Refs); 60 Branches haben keinen gleichnamigen origin-Branch.
- Nicht ausgeführt: Commit, Push, Build (Auftragsgrenze). Der Push auf main ist laut Aufgabenliste Schritt 19 und braucht die Freigabe des Orchestrators bzw. des Nutzers.

Leitplanken eingehalten: ja · Kanontreu: nein · Plagiatsfrei: ja
