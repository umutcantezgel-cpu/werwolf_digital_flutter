K0-KUNDSCHAFTER-02 · Kundschafter · Bauphase K0 · Version 1 · Schwierigkeit 1

## Rollenbriefing (Kundschafter)
- Aufgabe: Code und Daten lesen und belastbar berichten, mit Datei:Zeile zu jeder Aussage.
- Gute Arbeit: vollständig, nachprüfbar, knapp; Werte wörtlich aus der Quelle.
- Häufige Fehler: (1) Werte umformulieren statt zitieren, (2) Felder auslassen, (3) Entwurf (KANON-ENTWURF.md) statt Kanon (JSON) benutzen.
- Unsicherheit: OFFENE FRAGE notieren, nicht raten.

## Aufgabe
Ziehe aus dem Kanon des Schlosskellers einen vollständigen, wörtlichen Auszug je Figur und je Raum als Eingabe für Figuren- und Architektur-Baukasten.

## Das Projekt in fünf Sätzen
FEINKORN ist der Ausbau einer bestehenden iOS- und Android-App: Figuren, Gebäude und Gegenstände bestehen aus winzigen Pixel-Blöcken mit Material statt aus Bildern. Jeder Block erfüllt eine Funktion – er bestimmt, wie etwas aussieht, Licht annimmt, klingt, sich bewegt und zerbricht –, und abgelöste Blöcke fliegen als Dreck, Splitter oder Krümel und bleiben liegen. Figuren aus Pixel-Blöcken bewegen sich lebendig mit Skelett, Ruhe-Animationen und nachschwingender Kleidung. Alles baut auf der vorhandenen Technik auf, ändert sie nicht und läuft schonend auf Handys. Erstes Werkstück ist der Schlosskeller des Murder-Mystery-Spiels; jede Arbeit wird gemessen, nach Checkliste geprüft und nur vom Orchestrator integriert.

## Auszug Szenenvertrag/Kanon
Kanon: /home/user/feinkorn/content/party/schlosskeller/{figuren.json, raeume.json, gegenstaende.json, setting.json, zeitleiste.json} (Kanon v1.0.0). NICHT benutzen: planung/finalisierung-schlosskeller/KANON-ENTWURF.md (veraltet).

## Schnittstellen
Keine (Bericht).

## Eigene Dateien
Nur: /home/user/feinkorn/planung/feinkorn/KANON-AUSZUG.md (neu).

## Grenzen (Bestandsschutz)
Keine andere Datei ändern; nichts committen, pushen, installieren; keine Sitzungs-, Agenten- oder Remote-Werkzeuge; nur im Ordner /home/user/feinkorn arbeiten; content/party/** nur lesen.

## Arbeitsschritte
1. Figuren: Für detektiv, schneider und alle 20 Rollen eine Tabelle bzw. Abschnitt mit ALLEN Feldern aus figuren.json, die das Aussehen oder die Bewegung betreffen, wörtlich: id, name (Anzeigename), age, geschlecht, colorCode, farbname, look-Block vollständig (Haut, Haar, Kopf, Statur, Schnitt usw. – alle Unterfelder mit Hex-Werten), visualSpecs (silhouette, outfit, distinguishingFeature, idleAnimation), startRoom, ermittlungsOrt, coordinates. Jede Zeile mit Datei:Zeile.
2. Räume: Für jeden Raum aus raeume.json: id, Anzeigename, Rechteck (x, y, b, l), Höhe falls vorhanden, alle Türen mit Lage und Eigenschaften, alle einrichtung-Einträge des Raums (id, name, typ, x, y, blockiert, darstellung, weitere Felder), alle orte des Raums, alle lichtquellen mit Raumbezug (id, art, name, Farbe, Radius, Flackern, Zeiten). Mit Datei:Zeile.
3. Gegenstände/Indizien: Für alle Einträge aus gegenstaende.json: id, name, Lage je Pfad (falls pfadabhängig), Aussehen/Material-Hinweise wörtlich. Mit Datei:Zeile.
4. Setting: Bau- und Materialbeschreibungen aus setting.json und zeitleiste.json wörtlich (Sandstein, Gewölbe, Stufen, Fassade, Türen, Licht), mit Datei:Zeile.
5. Lücken: Liste, was für ein Modell fehlt (z. B. Raumhöhe, Größe in cm, Toiletten, Fassade, Stufen).

## Abnahmekriterien und Testweg
22 Figuren vollständig; 7 Räume mit allen Einrichtungseinträgen (Orchestrator zählt per Skript nach); jede Zeile mit Fundstelle; Werte wörtlich.

## Ausgabeformular
ÄNDERUNGEN · ERGEBNIS (Zahlen: Figuren, Räume, Einrichtung, Orte, Lichter, Gegenstände, Lücken) · OFFENE FRAGEN · SELBSTPRÜFUNG.

## Selbstprüfung
Alle Figuren? Alle Räume? Wörtlich? Fundstellen? Nur KANON-AUSZUG.md neu?

=== ENDE K0-KUNDSCHAFTER-02 · BEREIT ZUR RÜCKGABE ===
