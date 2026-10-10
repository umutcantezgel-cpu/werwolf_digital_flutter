K0-DOKUMENTAR-01 · Dokumentar · Bauphase K0 · Version 1 · Schwierigkeit 1

## Rollenbriefing (Dokumentar)
- Aufgabe: Vorgaben vollständig, wortgetreu und prüfbar in Dokumente überführen.
- Gute Arbeit: nichts weglassen, nichts erfinden, jede Schwelle als Zahl, jede Prüfmethode als ausführbarer Weg.
- Häufige Fehler: (1) Kriterien zusammenfassen und dabei Schwellen verlieren, (2) eigene Schwellen erfinden, (3) Prüfmethoden, die niemand ausführen kann.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Schreibe den Entwurf von planung/feinkorn/ABNAHME.md: die Kriterien K-01 bis K-16 aus dem Master-Prompt (unten wörtlich), je Unterpunkt eine Tabellenzeile mit Prüfmethode, Schwelle und Beleg-Spalte (leer) und Status (offen).

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug: Kriterien (Quelle, wörtlich)
Die Kriterien stehen in /home/user/feinkorn/planung/feinkorn/MASTER-PROMPT.md, Abschnitt „## 12. ABNAHMEKRITERIEN (messbar)“. Lies auch Abschnitt 8 (Prüfwerkzeuge) und 10 (Phasentore) dort.

## Umgebung (für die Prüfmethoden)
- Keine Handys, kein Android-SDK, kein Xcode. Verfügbar: Dart-VM, AOT (dart compile exe), flutter test, Flutter-Web-Build in Headless-Chromium (Playwright, CPU-Drosselung: hoch 1×, mittel 4×, einfach 6×; ohne GPU, Software-WebGL).
- Werkzeuge: tool/feinkorn/bestand.dart (Bestandsprüfung), tool/feinkorn/messen.mjs (Ladezeit, Bilder/s, p99, Rechenlast, Heap).
- Wo die Umgebung ein Kriterium nicht messen kann (Akku, Wärme, echte Geräte, iOS/Android-Läufe), schreibst du als Prüfmethode „Testplan echte Geräte (FÜR DEN NUTZER)“ plus den bestmöglichen Ersatzbeleg in der Umgebung, und markierst die Zeile mit „Grenze der Umgebung“.

## Schnittstellen
Keine.

## Eigene Dateien
Nur: /home/user/feinkorn/planung/feinkorn/ABNAHME.md (neu).

## Grenzen (Bestandsschutz)
Keine andere Datei ändern; nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn.

## Arbeitsschritte
1. Lies Abschnitt 12 vollständig. Übertrage JEDEN Unterpunkt von K-01 bis K-16 als eigene Zeile (Kennung K-01.1, K-01.2, …).
2. Spalten: Kennung · Kriterium (wörtlich) · Prüfmethode (konkreter Weg: Test/Werkzeug/Bildschirmfoto/Protokoll) · Schwelle (Zahl aus dem Text; fehlt eine, „siehe K0-Festlegung“) · Beleg (leer) · Status (offen).
3. Kopf: Zählregel „Abnahme a von 16“ (ein K gilt erst als erfüllt, wenn alle seine Zeilen belegt sind), Phasentore aus Abschnitt 10 je K.
4. Am Ende: Liste der Schwellen, die in K0 festzulegen sind (Flimmerschwelle, Budgettabelle, Größenbudget, Physikrate …).

## Abnahmekriterien und Testweg
Alle 16 Kriterien mit allen Unterpunkten (Orchestrator vergleicht mit Abschnitt 12); keine erfundene Schwelle.

## Ausgabeformular
ÄNDERUNGEN · ERGEBNIS (Zeilen je K) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Jeder Unterpunkt übertragen? Nichts erfunden? Nur ABNAHME.md neu?

=== ENDE K0-DOKUMENTAR-01 · BEREIT ZUR RÜCKGABE ===
