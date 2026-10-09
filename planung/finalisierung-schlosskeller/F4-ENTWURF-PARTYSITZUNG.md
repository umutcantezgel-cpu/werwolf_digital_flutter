# F4-Entwurf · Party-Sitzung auf der Karte (F4-ORCH-01/02)

Stand: Entwurf während der F3-Prüfrunde (E-029). Aus diesem Entwurf wird erst nach dem F3-Tor Code.

## Neu verankern (drei Sätze)
- F4 macht aus dem geprüften Kanon und den Texten einen Abend, der im Browser vom Titel bis zur Auflösung läuft (F-12).
- Die neun Entscheidungen werden zu Handlungen auf der Karte: Ort betreten, Gegenstand untersuchen, Person befragen. Die Karte ist vor dem Finale in allen Pfaden gleich (E-008).
- Figuren, Dossiers und Bildprompts kommen aus denselben Kanon-Feldern (F-13). Jeder Lauf hinterlässt Bildschirmfotos, die dem Nutzer gezeigt werden.

## Bausteine

### 1. Kern (rein Dart, `packages/mordakte_core/lib/src/party/karte.dart`)
- `PartyKarte(kanon)` baut einmal das Renderer-Szenario aus `partySzenarioJson` (vorhanden, `szenario_export.dart`). Hinzu kommen **alle** Ziele aller neun Entscheidungen als Hotspots:
  - **Orte und Gegenstände:** Hotspot an der Kanon-Position (`raumgraph` / `gegenstaende.json` → `lage`).
  - **Personen:** Figur am `ermittlungsOrt`. Die Zuordnung Kanon-Kennung ↔ Renderer-Kennung bleibt erhalten, denn die ersten Figuren tragen Kennungen der Vorlage.
- `kartenZustand(Spiel s)` → sichtbare Marker. Vor dem Finale hängt er nur ab von:
  - laufender Entscheidung
  - gewählten Optionen
  - Phase
  
  Er hängt nie vom Pfad ab. Prüfbar über `karte_pfadgleich_test` (F4-TEST-02): Zwei Pfade mit derselben Eingabefolge ergeben vor dem Finale dieselbe Objektliste, dieselben Marker und dieselben Lichter.
- `rueckblende(pfad)` → Bildfolge aus `tatmatrix/<pfad>.json` in 15-Sekunden-Schritten. Es gibt sie erst nach dem Finale.

### 2. Sitzung (`lib/party/sitzung.dart`)
- `PartySitzung extends ChangeNotifier` hält:
  - `Kanon`, `Texte` und `Spiel` (Zustandsautomat aus `ablauf.dart`)
  - die Einstellungen (Rollenzahl, Detektiv m/w, Fall-Code, Rundendauer, Stimme an/aus)
  - die Spielernamen je Rolle
- Sie liefert Bildschirmdaten:
  - Bausteintext je Kennung (`Textsammlung.bausteine`, Hinweistexte aus `bonus.json`)
  - Dossier je Rolle (`Texte.dossier`)
  - Gesprächsplan (`Texte.gespraechsplan`)
  - Optionen in gemischter Reihenfolge (`Spiel.optionen`)
  - Fundtexte (`Aufdeckung.text`)
- Verdeckte Einzelansicht: Rollenkarte, Täterfassung und Wahl erscheinen nur nach „Ich bin <Name>, zeig her“. Nach dem Schließen ist der Bildschirm wieder neutral.

### 3. Karten-Session (`lib/party/karte_session.dart`)
- `PartyKartenSession implements GameSession` speist den vorhandenen Renderer (`lib/game/mordakte_game.dart`):
  - `world`: Detektiv als eigene Figur, alle Figuren an ihren Ermittlungsorten mit Ruhe-Pose.
  - `caseView.hotspots`: nur die Ziele der laufenden Entscheidung offen.
- `send(Interact(id))` wählt nicht direkt. Die Sitzung bekommt einen **Vorschlag** und zeigt die Bestätigung „Das ist endgültig“; erst dann ruft sie `Spiel.waehle` auf und zeigt die Fundtexte.
- Bestandsschutz: Der Renderer bekommt zwei **optionale** Schnittstellen. Keine bestehende Session muss etwas ändern.
  - `NpcFilter.ansprechbar(id)`: Nur Personen der laufenden Entscheidung sind ansprechbar, alle anderen bleiben sichtbar.
  - `RaumSicht.sichtbarkeit(raumId)`: Fog-of-War je Raum mit radialem Ausblenden in 0,4 s. Licht nach B-04: Kerzen an der Anrichte, Notausgangsschild, Taschenlampenkegel des Detektivs.
  - Mordakte prüft beide mit `session is …` und verhält sich ohne sie wie bisher.

### 4. Bildschirme (`lib/party/bildschirme/*`, je Datei ein Baumeister-Auftrag)

| Auftrag | Bildschirm |
|---|---|
| F4-BAUMEISTER-01 | Einrichtung |
| F4-BAUMEISTER-02 | Rollen und Dossier, verdeckt |
| F4-BAUMEISTER-03 | Rundenzentrale mit Uhr und Gesprächsplan |
| F4-BAUMEISTER-04 | Gruppenwahl reihum, verdeckt; nie eine Stimmenzahl |
| F4-BAUMEISTER-05 | Erzählerfeld und lokale Stimme (abschaltbar; Text wortgleich zum Baustein) |
| F4-BAUMEISTER-06 | Anklage, Finale, Auflösung |
| F4-BAUMEISTER-08 | Titel, Intro, Resümee |
| F4-BAUMEISTER-09 | NPC-Karte |

- Jeder Bildschirm bekommt nur `PartySitzung` und liest über die feste API oben. Kein Bildschirm erzeugt Text; alles kommt aus Bausteinen (F-11).

### 5. Einstieg
- Route `/party`, Kachel im Hub als letzter F4-Schritt nach dem Holen von origin; `main` und `hub` teilt sich der Burgstadt-Strang.
- Entwickler-Einstieg `?party=schlosskeller&code=…&n=…&skript=…&dauer=…`. Das Skript steuert Entscheidungen, Stimmen und Anklage für E2E-Läufe.

### 6. E2E (F4-BAUMEISTER-07)
- `tool/e2e`: Playwright gegen das vorhandene Chromium, Web-Build mit `--no-web-resources-cdn`.
- Fotos je Phase, Konsolen- und Netzprüfung (nur localhost).
- Läufe für jeden Pfad × jedes Ende × Rollenzahl {4, 7, 12, 16, 20}.
- Fotos gehen per SendUserFile an den Nutzer.

## Reihenfolge
1. ORCH: `karte.dart` mit Test, `sitzung.dart`, `karte_session.dart`, optionale Renderer-Schnittstellen, Route und Entwickler-Einstieg. Danach ein Probelauf mit Fotos.
2. Haiku, parallel und mit Dateihoheit: Bildschirme 01 bis 09, Test 02 (Karte pfadgleich, Widget-Tests), Test 01 (Figurenkonsistenz).
3. ORCH: Integration, Rückblende (F4-ORCH-03), Requisiten (F4-ORCH-06), Spielleitung (F4-ORCH-05).
4. Spieltester und Sichtprüfer, danach das Tor F-12 und F-13.

## Offene Punkte (Denkprotokoll beim Bau)
- Ruhe-Animationen: Der vorhandene `FigurePainter` kennt Gehen und Stehen. Ruhe-Posen kommen als kleine Pendelbewegung je Figur; Phase und Takt leiten sich aus der Figur-Kennung ab, damit sie deterministisch bleiben.
- Detektiv-Look: Hut „detektivhut“ wird als `fedora` gezeichnet (`renderLook`). Die Pfeife mit Seifenblasen kommt in F4-ORCH-06.
