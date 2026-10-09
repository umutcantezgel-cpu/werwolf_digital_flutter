F3-AUTOR-76 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Arbeite die Prüfbefunde in die 36 Pflichtgespräche der Rollen Lejla (leyla), Emine (emine), Tim (tim), Joanna (johanna) ein (drei Runden).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
Die Kanon-Tatsachen deiner Rollen stehen in content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 7 Beobachtungen) und in texte/dossiers-b2.json (wer, weiss). Was alle wissen: texte/erzaehler-intro.json, Eintrag intro.start.

SCHNITTSTELLEN:
Deine drei Dateien: content/party/schlosskeller/texte/gespraeche-r1-b2.json, content/party/schlosskeller/texte/gespraeche-r2-b2.json, content/party/schlosskeller/texte/gespraeche-r3-b2.json. Die Felder id, rolle, runde, nr, partner und preisgabe bleiben unverändert. Du änderst NUR thema, ziel und text.
Regeln P-1 bis P-4 und Sichtbarkeit: texte/SCHLUESSEL.md. Kurz:
- P-2: Ein ersetzbarer Partner (nicht ahmet, fatma, olli, can, detective) wird nicht genannt, und ihm wird nichts zugeschrieben.
- P-3: nur eigenes Wissen und die eigene preisgabe.
- P-4: Abwechslung, jede Runde nach ihrer Frage.

ENTSCHEIDUNGEN DES ORCHESTRATORS ZU DEN BEFUNDEN (verbindlich, E-029):
- Übernehmen: alle Befunde unten mit ihrer kleinsten Korrektur, außer den hier genannten Ausnahmen. Prüfe jede Korrektur vor dem Einsetzen gegen P-2 und P-3. Verletzt der Vorschlag eine Regel, formuliere selbst eine regelkonforme Fassung mit derselben Absicht.
- NICHT übernehmen:
  - KONT-06 Zeile D (Pawel „zahlt kleine Schäden oft selbst“). Der Kanon ist geändert: Am Tisch sagt Pawel nur noch „Herr Schneider muss jeden Schaden der Stiftung melden. Darum ist er beim Geld so streng.“ Schneiders Geldsorgen verbirgt er.
  - SENS-03 Zeile 9 (Torte „Wenigstens die ist heil“). Tugba weiß das nicht sicher (P-3).
- Systemisch, KONT-07 Zeile 13 und P-4 für Runde 2: Jeder Runde-2-Text deiner Rollen prüft eine Behauptung oder fragt nach einem Widerspruch.
  - Beispiele: „Passt das zu dem, was du vorhin gesagt hast?“, „Stimmt das wirklich?“, „Da passt etwas nicht zusammen: …“.
  - Er stellt nicht wieder die Alibi-Frage aus Runde 1. Ändere dafür so wenig wie möglich, meist nur den Fragesatz.
- Systemisch, SENS-03 Zeile 4 und KONT-08 Zeile 7: In Runde 3 höchstens ein Text je Rolle mit „Klarheit“, „klar“, „ehrlich“ oder „Wahrheit“. Ein Text wiederholt nicht fast wörtlich einen Text derselben Rolle aus einer anderen Runde; dieselbe Preisgabe bekommt neue Worte.
- Amtssprache (SENS-03 Zeile 5): kein „nach eigener Auskunft“ und keine „Angabe“ oder „Angaben“; der Kanon sagt jetzt „wo die Leute angeblich gerade sind“.
- Lüge Can (SENS-03 Zeile 6): Die Behauptung lautet wörtlich „Welche Maske? Ich hab keine Maske.“
- Geschlecht des Detektivs (KONT-08 Zeile 2): nie „der Detektiv“ oder „die Detektivin“ in der Anrede; neutral, z. B. „Du ermittelst heute“.
- Familie als Deckung (SENS-03 Zeile 2): Verwandtschaft nicht als Grund zum Zusammenhalten in den Text schreiben (auch nicht „du bist mein Bruder“).

BEFUNDE ZU DEINEN ROLLEN (aus den Berichten F3-KONT-06, -07, -08 und F3-SENS-03; Spalten: Nr | Fundstelle | Prüfpunkt | Zitat Text | Zitat Kanon | Schwere | kleinste Korrektur):
[F3-KONT-06] | C | gespraeche-r1-b2.json#g_johanna_1_1, text und thema („Die Fotos vom Abend“) | P-3: nichts Verborgenes (Grenzfall); P-4: Runde 1 fragt hier nicht nach dem Alibi | „Frag mich ruhig nach den Bildern.“ | beobachtungen.json#b_joanna_foto: kanal „verborgen“, grundVerborgen „Ahmet hat sie gebeten, das Foto zu löschen.“; Hinweis dort: verborgen „erreicht den Detektiv nur über eine Entscheidung oder den Bonus-Hinweis“ | mittel | text: „Du, ich bin die Fotografin des Abends. Und wo stecktest du beim Knall?“; thema: „Der Ost-Saal beim Knall“ |
[F3-KONT-06] | G | gespraeche-r1-b2.json#g_johanna_1_3, text; gespraeche-r1-b5.json#g_enes_1_2, text | P-2: Beobachtung des ersetzbaren Partners vorausgesetzt | an Baran: „Was hast du beim Knall aus Richtung Theke gehört?“; an Serkan: „Hast du beim Knall jemanden an der Theke gesehen?“ | beobachtungen.json#b_baran_rufe (Barans eigene Beobachtung; besetzung.json#ersatzpartner.baran: ["tugba","meryem"]); figuren.json#serkan.blackoutAlibi: „Stand im Windfang am Außentor …“ | leicht | an Baran: „Was hast du beim Knall mitbekommen? Erzähl mal.“; an Serkan: „Hast du beim Knall jemanden gesehen? Erzähl mal, was dir aufgefallen ist.“ |
[F3-KONT-06] | H | thema „Wo warst du beim Knall?“ in b1#g_ahmet_1_1, b2#g_tim_1_1, b4#g_serkan_1_1, b5#g_enes_1_1; weitere Themen-Dubletten: „Was hast du im Dunkeln gesehen?“ (b1#g_can_1_1, b2#g_emine_1_2), „Was hast du gehört?“ (b4#g_serkan_1_3, b5#g_enes_1_3), „Wer stand an der Theke?“ (b1#g_fatma_1_3, b5#g_enes_1_2); Ziel-Dublette b1#g_fatma_1_3 und b2#g_leyla_1_2 | P-4: Abwechslung (Thema und Ziel sind am Tisch sichtbar) | thema „Wo warst du beim Knall?“ (viermal gleich) | SCHLUESSEL P-4: „Kein Text wiederholt einen anderen wortgleich.“ | leicht | b4#g_serkan_1_1 thema: „Am Außentor beim Knall“; b5#g_enes_1_1 thema: „Die Theke um drei vor zwölf“; b2#g_tim_1_1 thema: „Ahmets Platz beim Knall“; b2#g_emine_1_2 thema: „Was im Dunkeln passierte“; b5#g_enes_1_3 thema: „Richtung des Knalls“; b5#g_enes_1_2 thema: „Wer war an der Theke?“; b2#g_leyla_1_2 ziel: „Ich will wissen, wer sich beim Knall an der Theke aufhielt.“ |
[F3-KONT-06] | I | Sätze: b2#g_emine_1_1 und b4#g_dilara_1_1 („Dort bin ich geblieben, bis das Licht anging.“); b2#g_johanna_1_2 und b4#g_aylin_1_2 („Ich frag ja nur.“, wortgleich); b3#g_murat_1_1 und b5#g_hakan_1_2 („Wo warst du da?“); b1#g_fatma_1_1 und b2#g_emine_1_1 („Und du, wo warst du?“); b1#g_ahmet_1_3 und b2#g_tim_1_2 („Was hast du mitbekommen?“); Gesichtssatz b3#g_zeynep_1_1 und b3#g_murat_1_1 | P-4 | „Ich frag ja nur.“ (zweimal wortgleich) | beobachtungen.json#b_emine_versteck und #b_azra_versteck haben denselben Kanon-Satzteil „blieb dort, bis das Licht anging“ | leicht | b4#g_aylin_1_2 text: „Du, sag mal, wo warst du in der Zeit? Ich will es nur wissen.“; b5#g_hakan_1_2 text: „Lass uns kurz ruhig über den Knall reden. Wo warst du denn?“; b2#g_emine_1_1 text: letzter Satz „Und du, wo stecktest du?“; b2#g_tim_1_2 text: „Und bei dir? Was hast du gehört?“; b3#g_zeynep_1_1 text: „Aus dem Durchgang kam im Dunkeln ein leuchtendes Gesicht an mir vorbei in den Kaminsaal. Hast du das auch gesehen, und wo warst du da?“ (Dilara-Satz durch F gelöst) |
[F3-KONT-07] | 7 | b2 · g_tim_2_1 · text (Partner murat, ersetzbar) | P-4 (R1-Wiederholung), P-2 | „Am Sicherungskasten sah ich ein leuchtendes Gesicht. Es huschte im Dunkeln an mir vorbei. Wohin ist es gelaufen?“ | R1 g_tim_1_2: „Ich war am Sicherungskasten. Dann huschte im Dunkeln ein leuchtendes Gesicht an mir vorbei.“ (gleiche Preisgabe, auch R3 g_tim_3_3). beobachtungen.json, b_tim_gesicht. „Wohin ist es gelaufen?“ setzt Murats Beobachtung voraus (b_marek_gesicht) | mittel | „Am Sicherungskasten ist mir im Dunkeln ein leuchtendes Gesicht begegnet. Ist dir dabei irgendwas aufgefallen?“ |
[F3-KONT-07] | 8 | b2 · g_emine_2_1 · text | P-4 (R1-Wiederholung) | „Beim Knall hab ich mich hinter dem linken Buffettisch geduckt. Dort blieb ich, bis das Licht anging.“ | R1 g_emine_1_1: „Fatma, beim Knall hab ich mich hinter den linken Buffettisch geduckt. Dort bin ich geblieben, bis das Licht anging.“ beobachtungen.json, b_emine_versteck: „…blieb dort, bis das Licht anging.“ | mittel | „Beim Knall hab ich mich hinter dem linken Buffettisch geduckt, bis das Licht anging. Ist dir in der Zeit etwas aufgefallen?“ |
[F3-KONT-07] | 13 | Systemisch, 30 Texte: b1 g_fatma_2_1, g_fatma_2_3, g_olli_2_3, g_can_2_1, g_can_2_2; b2 g_leyla_2_2, g_leyla_2_3, g_emine_2_2, g_tim_2_2, g_tim_2_3; b3 g_murat_2_2, g_murat_2_3, g_zeynep_2_1, g_zeynep_2_2, g_baran_2_2, g_baran_2_3; b4 g_serkan_2_2, g_serkan_2_3, g_aylin_2_2, g_aylin_2_3, g_kaan_2_1, g_dilara_2_1, g_dilara_2_2; b5 g_enes_2_1, g_enes_2_2, g_selin_2_1, g_selin_2_2, g_hakan_2_1, g_tugba_2_1, g_tugba_2_3 | P-4 (Rundenfrage) | Beispiel g_murat_2_2: „Can, wo warst du eigentlich um kurz vor zwölf? Erzähl mal genau, nicht nur grob.“ | texte/erzaehler-runden.json, runde.2.start: „Trennt das eine vom anderen.“ Auftrag P-4 nennt R2 „Widersprüche“. R1 ist „Das Alibi-Geflecht“. | mittel | „Im Dunkeln ist mir ein leuchtendes Gesicht durch den Durchgang gelaufen. Wo warst du da wirklich, Can?“ (Murats eigene Beobachtung b_marek_gesicht) |
[F3-KONT-07] | 14 | b1 g_ahmet_2_2, g_fatma_2_2, g_olli_2_1; b2 g_leyla_2_1; b4 g_serkan_2_2; b5 g_hakan_2_3 (Partner ersetzbar) | P-2 (Vorannahme), Lügen-Wortlaut | „Was genau hast du dazu mitbekommen?“ · „Hast du das auch gesehen?“ · „Hast du an meiner Tasche was Auffälliges bemerkt?“ · „Erzähl mal genau, was du da gemacht hast.“ · „Ist dir an der Theke jemand auffällig vorgekommen?“ · „Ich saß am Tisch im Ost-Saal, sonst nirgends.“ | Kein Kanon für diese Wahrnehmung beim Partner. luege_olli_tafel (figuren.json, olli.luegen): „Ich saß die ganze Zeit am Tisch im Ost-Saal.“ | leicht | Ahmet: „Das Geld war für die Miete, hundertfünfzig Euro. Ist dir dazu etwas aufgefallen?“ · Leyla: „Ist dir das auch aufgefallen?“ · Fatma: „Ist dir an meiner Tasche etwas aufgefallen?“ · Serkan: „Und du? Was hast du in der Zeit gemacht?“ · Hakan: „Ist dir an der Theke etwas aufgefallen?“ · Olli: „Ich saß die ganze Zeit am Tisch im Ost-Saal. Ist dir dabei etwas anders in Erinnerung?“ |
[F3-KONT-07] | 15 | b1 g_ahmet_2_3 und b4 g_serkan_2_1; b1 g_can_2_1 und b2 g_tim_2_3 | Abwechslung (P-4) innerhalb R2 | thema „Auffälliges im Dunkeln“ (beide); „Ist dir im Dunkeln was Komisches aufgefallen?“ (beide); thema „Wo warst du im Dunkeln?“ (beide) | Doppelung im selben Set, Kanon nicht betroffen | leicht | g_serkan_2_1 thema „Wer wollte raus?“; g_tim_2_3 thema „Wer war bei dir?“ |
[F3-KONT-08] | 5 | b2#g_leyla_3_3, text | Satzzahl | Vier Sätze; letzter: „Es fällt mir nicht leicht.“ | SCHLUESSEL.md: „`text`: ein bis drei Sätze, mit denen die Rolle das Gespräch eröffnet.“ | leicht | Satz „Es fällt mir nicht leicht.“ streichen. |

EIGENE DATEIEN: content/party/schlosskeller/texte/gespraeche-r1-b2.json, content/party/schlosskeller/texte/gespraeche-r2-b2.json, content/party/schlosskeller/texte/gespraeche-r3-b2.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies SCHLUESSEL.md (Pflichtgespräche), TON-LEITFADEN §1 bis §4 und deine drei Dateien.
2. Setze jeden Befund um, wie oben entschieden. Wende danach die systemischen Regeln auf alle 36 Gespräche an.
3. Prüfe:
   - python3 -m json.tool für alle drei Dateien.
   - dart test test/party/texte_test.dart: muss ganz grün sein.
   - dart run bin/party_texte.dart 2>&1 | grep -E "gespraeche-r[123]-b2" muss leer sein.
   - Mit einem kleinen python3-Skript: kein Text deiner Dateien ist wortgleich mit einem anderen Text in allen 15 Gesprächsdateien.

ABNAHMEKRITERIEN UND TESTWEG: Alle Befunde erledigt oder mit Grund abgelehnt; id, rolle, runde, nr, partner und preisgabe unverändert; texte_test grün; Textprüfer ohne Befund für deine Dateien.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-76
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Erledigte Befunde: <Liste Nr und Kennung>
- Abgelehnte Befunde mit Grund: <Liste oder „keine“>
- Geänderte Runde-2-Texte (Widerspruch): <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-76 · BEREIT ZUR RÜCKGABE ===
