ABNAHME F0-GEGEN-03a · siehe Entscheidungen E-014 (Plan-Schleife Runde 2)

# Bericht F0-GEGEN-03a

## Stand der Befunde aus Runde 1

| Befund | Urteil | Fundstelle | Rest-Lücke |
|---|---|---|---|
| G1-1 Bonus-Abkürzung, nur Olli bleibt | teilweise | PLAN Z.24 (W-1); ABNAHME F-06 (Z.15) | „allein“ undefiniert; F-06 prüft nur 0 richtige, nicht 1–2 richtige plus wahre Hinweise. |
| G1-2 Anklage-Raten, 0 Punkte ergibt E2 | offen | E-013 G1-2 (T); B-12 unverändert; F-06 (Rate-Enden nur ausgewiesen) | E2 ohne Entscheidung bleibt im Spiel; die Regel „E2 nur mit Entscheidung“ fehlt. |
| G1-3 Ein oder zwei Restverdächtige | gelöst | PLAN Z.25; ABNAHME F-06 (Z.15) | Nur im Simulator belegt; MASTER 7.6 nicht gelesen. |
| G1-4 Spoiler im Resümee bei Restmenge 1 | gelöst | PLAN Z.25 (S-1); ABNAHME F-11 (spoiler_test) | Neutraler Restmengen-Baustein existiert nur als Beispielsatz in E-013. |
| G1-5 Fach „Lage im Pfad“ pfadabhängig | gelöst | PLAN Z.25 (S-1); ABNAHME F-11, F-12 | OFFENE FRAGE: Fällt „Lage im Pfad“ unter S-1 (nur Resümee-Fächer)? Nicht im PLAN benannt. |
| G1-6 Karte nach Pfad (Marker, Licht) | gelöst | ABNAHME F-12 (karte_pfadgleich_test); PLAN F4-TEST-02 | Sichtprüfer vergleicht Fotos weiter nur innerhalb eines Pfads. E-008 nicht geändert. |
| G1-7 Kanal der Pflichtgespräche | teilweise | PLAN Z.29; E-013 G1-7 (Variante a) | „Gemeinsame Beobachtungen“ lassen Pfadfakten zu; spoiler_test prüft nur Bausteine, keine Pflichtgespräch-Texte. |
| G1-8 Falsche Option deckt Schlüsselbeweis auf | gelöst | PLAN Z.26 (D-1); ABNAHME F-06; F2-TEST-03 (Z.77) | „Nebendelikt/Umgebungsfakt“ nicht als maschinenlesbares Feld definiert. |
| G1-9 Simulator unsound, Laufzeit (= G2-14) | teilweise | NEBELKARTE 16; E-013 G1-9; PLAN F2-ORCH-04 (Z.74) | Budget (5 min, 60 s) nur in NEBELKARTE/E-013, nicht in ABNAHME oder PLAN; nicht gerechnet. |
| G1-10 Gruppenwahl ohne Kosten (= G2-13) | teilweise | PLAN F2-TEST-04 (Z.79); ABNAHME F-08 (Z.17) | Test prüft nur, ob Kosten/Nutzen vorhanden sind; Gewichtung und Dominanz nicht getestet. |
| G1-11 Täter-Sabotage unmodelliert | teilweise | PLAN Z.27 (G-1); ABNAHME F-08; F2-TEST-04 | Sabotage fehlt im Auftrag F2-ORCH-02 (Z.72) und im Kanon-Feld. |
| G1-12 Intro-Lacher als Erzählerfakt, unbesetzte Rollen | teilweise | E-013 G1-12; ABNAHME F-09 (kein Verweis auf unbesetzte Rollen) | Lacher-Verbot nicht testbar; „Verlaufen“ nicht in PLAN F1; Intro-Varianten je Besetzung fehlen. |
| G1-13 Geburtstagskind im Tatraum | teilweise | E-013 G1-13 (ab 23:55 Ostsaal); ABNAHME F-04 (Z.13) | Position und Gerüchte-Regel fehlen in F1-ORCH-06; „verbundene Augen, Musik“ nur in E-013. |
| G1-14 Druckspiel ohne Restmengen-Ablesbarkeit | gelöst | PLAN F5-ORCH-01 (Z.136); ABNAHME F-14 (Ablesbarkeit) | OFFENE FRAGE: Pfadbezug und Sichtbarkeit der Ausschlussregeln im Ermittlungsbogen ungeklärt. |
| G1-15 Täterfassung in der Druckdatei | teilweise | ABNAHME F-14 (Z.23); PLAN F5-ORCH-01 (Z.136) | Datei enthält Täterfassung im Klartext; Vorbereiter sieht den Täter; Trennung der Dateien fehlt. |
| G1-16 Texte veralten nach Kanon-Änderung | teilweise | ABNAHME F-10 (textlint_test, Z.19); PLAN Z.90 | Regel „Kanon-Änderung nach F3 löst Neuprüfung aus“ fehlt in PLAN und ABNAHME. |
| G1-17 F-09 und Besetzung zu spät | gelöst | PLAN F1-ORCH-10 (Z.57); F2-ORCH-06 (Z.78) | Ausfall-Ursache für 4–5 Rollen: siehe G2-6. |
| G2-1 CanvasKit vom CDN | gelöst | PLAN F0-ORCH-04 (Z.43); F1-ORCH-11 (Z.58); ABNAHME F-16 (Z.25) | Fallback-Schriften zur Laufzeit ungeprüft (OFFENE FRAGE aus GEGEN-02; nur NEBELKARTE 13). |
| G2-2 SDK-Download per curl | teilweise | FÜR-DEN-NUTZER Z.11–13; E-013 G2-2 (T) | Umdeutung als „Paketinstallation“ widerspricht MASTER §3 laut Befund; kein Freigabe-Stopp im PLAN. |
| G2-3 Abkürzung über drei wahre Hinweise (= G1-1) | teilweise | PLAN Z.24; ABNAHME F-06 (Z.15) | Wie G1-1. |
| G2-4 Analyse-Reihenfolge ohne pub get | gelöst | PLAN F0-ORCH-04 (Z.43, pub get zuerst); ABNAHME F-16 (Z.25) | analysis_options.yaml schließt packages/ weiter nicht aus; Direktaufruf von analyze bleibt rot. |
| G2-5 Bestandsänderungen (E-001, Spike) | teilweise | E-013 G2-5 (behauptet Liste in E-001); E-001 unverändert; PLAN F1-ORCH-11 (Z.58) | Liste erlaubter Bestandsänderungen fehlt in E-001 und PLAN; standing()-Änderung in F4-ORCH-03 (Z.126) ungeregelt. |
| G2-6 Besetzungsreihenfolge, Ausfall-Ursache | teilweise | PLAN F1-ORCH-10 (Z.57); F2-ORCH-06 (Z.78) | Ausfall-Ursache Tim (Rolle 6, V-20) für 4–5 Rollen nirgends zugewiesen. |
| G2-7 Doppelte Quelle Kern-Rundenwahl | gelöst | PLAN F3-AUTOR-26..29 (Z.95, nur Blöcke 2–5); F3-AUTOR-57..64 (Z.104) | Nur Auftragsebene; kein Prüfpunkt in ABNAHME. |
| G2-8 Textschlüssel und Eigentümer | gelöst | PLAN F3-ORCH-00 (Z.89); Eigentümertabelle (Z.19) | Generierte Dateien (lib/l10n/gen/) nicht als Eigentum geregelt. |
| G2-9 Parallelität ohne Isolation | teilweise | PLAN Z.21 (E-013: worktree, Pfadliste, -o) | Worktrees erben das gitignorierte .werkzeug/ (SDK) nicht; E-009 unverändert „getrennte Dateihoheit“. |
| G2-10 Übergabe nach E-003 | teilweise | PLAN F0-ORCH-03 (Z.44); F4-ORCH-02 (Z.115); F7-ORCH-02 (Z.157); ABNAHME F-17 (Z.26) | F-17 verlangt „alle erfüllt“ mit main = origin/main; der PR-Ersatzweg widerspricht. Design-Agent-Regel fehlt. |
| G2-11 Playwright gegen Canvas | gelöst | PLAN F4-BAUMEISTER-07 (Z.122); F1-ORCH-11 (Z.58) | Karte nur per Skript gesteuert; Klickpfad auf der Karte ungetestet. |
| G2-12 Farbabstand schon verletzt | teilweise | PLAN F1-TEST-03 (Z.59); ABNAHME F-13 (Z.22) | Messung nur an Hex-Werten; Nachtlicht (darkness bis 0,97) ohne Zahlenschwelle; Sichtprüfung qualitativ. |
| G2-13 Gruppenwahl-Dominanz (= G1-10) | teilweise | PLAN F2-TEST-04 (Z.79) | Wie G1-10. |
| G2-14 Simulator nicht durchgerechnet (= G1-9) | teilweise | NEBELKARTE 16; E-013 G2-14 | Wie G1-9. |
| G2-15 Pflichtinhalte ohne Auftrag | gelöst | PLAN F4-BAUMEISTER-08, -09 (Z.123–124); F4-ORCH-05 (Z.125) | Titel, Pfeife, Gags ohne eigene Abnahme; F4-TEST-02 nur pauschal. |
| G2-16 Secret-Scan und Rohchat-Regel | teilweise | PLAN F0-ORCH-04 (Z.43, secret_scan.sh); E-013 G2-16 | planung/berichte bleibt im Commit; Bestandsberichte mit Zitaten unbereinigt; Schwelle für „längere Blöcke“ fehlt. |

## Zusammenfassung

- Gelöst: 13 (G1-3, G1-4, G1-5, G1-6, G1-8, G1-14, G1-17, G2-1, G2-4, G2-7, G2-8, G2-11, G2-15).
- Teilweise: 19. Offen: 1 (G1-2). Doppelte Befunde (G2-3, G2-13, G2-14) sind wie ihr Gegenstück beurteilt.
- Die drei wichtigsten Rest-Lücken:
  1. G1-2: Ein Detektiv mit 0 Punkten, der richtig rät, erhält weiter E2 ohne Entscheidung (B-12 unverändert). Der Simulator weist das nur aus, verhindert es aber nicht.
  2. G1-7: Die Regel „Preisgaben pfadneutral“ lässt „gemeinsame Beobachtungen“ zu, die Täterfakten sein können. Der spoiler_test prüft nur Bausteine, nicht die Pflichtgespräch-Texte.
  3. G1-15: Die Satz-Datei enthält die Täterfassung im Klartext. Versiegelt wird erst beim Druck, der Vorbereiter sieht den Täter.
- Weitere Auffälligkeiten: E-013 G2-5 behauptet eine Liste erlaubter Bestandsänderungen in E-001, die dort fehlt. E-013 G1-6 nennt E-008 „verschärft“, E-008 ist aber unverändert. F-17 kann nach dem PR-Ersatzweg nicht „alle erfüllt“ sein.
- OFFENE FRAGE: Nicht gelesen wurden MASTER, BRUCHLISTE, BESTAND, PRUEFPUNKT und AUFTRAGSVORLAGE. Behauptungen, die dort geprüft werden müssten (B-05, V-15, V-18, V-20, §3-Wortlaut, PRUEFPUNKT Schritt 3), sind hier nicht bestätigt.

Selbstprüfung: alle 33 Befunde (17 aus GEGEN-01, 16 aus GEGEN-02) sind beurteilt. Es wurde nur lesend gearbeitet.

=== ENDE F0-GEGEN-03a · BEREIT ZUR RÜCKGABE ===
