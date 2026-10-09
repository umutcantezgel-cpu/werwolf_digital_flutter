# BESTAND · Messbasis vor dem ersten Eingriff (09.10.2026)

## Git und Remote
- origin: `umutcantezgel-cpu/werwolf_digital_flutter` über den Git-Proxy der Umgebung.
- **origin/main = `d92a675`**. Das ist der Bezugspunkt für F-17: Dieser Commit muss am Ende Vorfahr von main sein.
- Arbeitsbranch `finalisierung-schlosskeller` ab `d92a675`, Upstream abgekoppelt (E-010). Arbeitsbaum zu Beginn sauber.
- Branch-Schutz: aus dem Container nicht abfragbar. Er zeigt sich beim ersten Push (E-003).
- CI: keine (`.github/workflows` fehlt). Deploy-Konfigurationen `netlify.toml`, `vercel.json`, `railway.toml` werden nicht angefasst.

## Technik und Engine
- **App:** Mordakte, Flutter 3.47.6 / Dart 3.13.5, Flame 1.38.
  - 2.5D-Iso-Renderer, komplett im Code gezeichnet (`lib/game/`).
  - go_router, Provider, shared_preferences, web_socket_channel.
- **`packages/mordakte_core`:** reines Dart.
  - Szenario-Modell, Validator, Fall-Generator (Seed `mulberry32`, `Rng`), Engine, Schatten-KI, Bots, Enden, Protokoll, RoomRuntime.
- **`server/`:** Dart-WebSocket-Server, eine RoomRuntime je Raum.
- **Bausteine für den Partymodus** (Bericht `berichte/F0-KUNDSCHAFTER-01.md`):
  - Unabhängig wiederverwendbar: `Iso`, `IsoPen`, `WallPainter`, `MarkerPainter`, `WeatherSystem`, `JoystickState/Painter`, `FigurePainter.standing/lying`, `SceneLight/GlowLight/LightMode`, `ScenePalette`-Helfer.
  - `StaticScene.build(ScenarioDef)` braucht ein `ScenarioDef` mit `map` (ASCII-Raster, Räume, Props) und `theme`. Der Partymodus erzeugt dafür ein Karten-`ScenarioDef` aus dem Raumgraph.
  - `MordakteGame` hängt an `GameSession` (WorldSnapshot, CaseView). Eine eigene Sitzung, die synthetische Snapshots liefert, kann den ganzen Renderer samt Kamera, Joystick und Interaktion nutzen. Vorlage: `ScenarioPreviewSession` (`lib/game/dev/scenario_preview_session.dart`).
  - Fehlt: Fog-of-War je Raum, Licht mit eigener Farbe je Objekt, Ruhe-Animationen, Figuren-Merkmale (Kopftuch, Brille, Schal, Pfeife), Prop-Typen Rüstung, Vitrine, Bank, Teekocher, Sicherungskasten, Jackenständer, Treppe. Die Prop-Liste ist geschlossen; der Validator lehnt unbekannte Typen ab.
- **Web** (Bericht `berichte/F0-KUNDSCHAFTER-02.md`):
  - Der Standard-Build lädt CanvasKit von `www.gstatic.com`. Mit `--no-web-resources-cdn` bleibt CanvasKit lokal.
  - Schriften sind lokal (Inter, SpecialElite); kein `google_fonts`. Der Schrift-Fallback des Browsers für fehlende Zeichen wird im E2E-Netztest geprüft.
  - Browser-Interop nach dem Muster `dart:js_interop` mit `@JS` und `extension type` (`lib/session/token_store_web.dart`), bedingter Export in `token_store.dart`.

## Datenformat der Fälle
- Mordakte-Szenarien: `content/scenarios/*.json`, Format `content/SCHEMA.md`, `ScenarioDef`, Validator `validator.dart`. Sie werden automatisch geladen (Asset-Ordner).
- Partymodus: neuer Kanon unter `content/party/schlosskeller/` (E-002). Mordakte-Szenarien bleiben unverändert.
- Werkstatt und Gemeindesaal: nicht vorhanden (E-006).

## Teststand, Build und Ladegröße (Messbasis)
Befehle mit `source .werkzeug/env.sh`. Log: `.werkzeug/logs/messbasis.log` (lokal).

| Prüfung | Befehl | Ergebnis |
|---|---|---|
| Analyse (App, Kern, Server) | `flutter analyze` (Root, nach `pub get` aller Pakete) | No issues found |
| Analyse Kern | `cd packages/mordakte_core && dart analyze` | No issues found |
| Analyse Server | `cd server && dart analyze` | No issues found |
| Kern-Tests | `cd packages/mordakte_core && dart test` | 22 Tests, All tests passed |
| Szenario-Validator | `dart run bin/validate.dart` | 4 × OK (sample 11 Hinweise / 12 Varianten; nachtexpress, blue_palm, ravensmoor je 20 Hinweise / 24 Varianten) |
| Simulator | `dart run bin/simulate.dart alle 4 2` | 16 Läufe, alle Urteile `perfect`, Ø 15 Min. |
| Server-Smoke | `cd server && dart run tool/smoke.dart` | alle OK |
| Web-Build | `flutter build web --release` | erfolgreich, 1:20 Min. |
| Ladegröße Web | `du -sh build/web` | **43 MB** (davon CanvasKit 37 MB), 46 Dateien |

Hinweis: Ein Root-`flutter analyze` vor `dart pub get` in `packages/mordakte_core` meldet 79 scheinbare Fehler (Paket `test` nicht aufgelöst). Das ist kein Befund im Code. Reihenfolge in `tool/pruefen.sh`: zuerst alle `pub get`.

## Werkzeugkette (repo-lokal, gitignored)
```bash
mkdir -p .werkzeug/flutter .werkzeug/pub-cache
curl -sSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.6-stable.tar.xz \
  | tar -xJ -C .werkzeug/flutter --strip-components=1
# env.sh (FLUTTER_ROOT, PUB_CACHE, PATH) wie in .werkzeug/env.sh
```
Node 22 (`/opt/node22`) und Chromium (`/opt/pw-browsers`) sind in der Umgebung vorhanden.

## Frühere Läufe
- **`krimidinner/spuk-im-gewoelbe/`:** Kanon v1.0 mit fester Täterin (Merle), 204 Pakete geplant, 0 produziert, Tag 2 von 14. Er stammt aus einem anderen Master-Prompt und ist nicht mit der App verbunden.
  - Übernommen werden Methode und Regeln: Lügenregel, Verdächtigenkreis nur Kernrollen, Endmatrix EM-1..4, Stilblatt, Look-Bibel, Alkohol-Stoppliste, Funktionsmatrix.
  - Der Ordner bleibt unverändert. Offene Kriterien dieses Laufs gelten nicht für den neuen Auftrag.
- **Station A** (Teamchat): Die Standardannahmen gelten weiter, außer bei Personenzahl und Enden (Master-Prompt §1). Sie sind in BRUCHLISTE und TON-LEITFADEN eingearbeitet.
