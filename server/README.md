# Mordakte-Server

WebSocket-Server für Online-Räume (1–6 Spieler). Die Spiellogik ist dieselbe
`RoomRuntime` aus `packages/mordakte_core` wie im Offline-Modus; der Server macht nur
Verbindungen, Raumcodes, Takt (20 Hz Tick, 10 Hz Snapshots) und Reconnect.

## Lokal starten

```bash
cd server
dart pub get
dart run bin/server.dart                 # http://localhost:8080/health, ws://localhost:8080/ws
INCLUDE_SAMPLE=1 dart run bin/server.dart  # zusätzlich das eingebaute Szenario "sample"
```

App dagegen starten: `flutter run --dart-define=MORDAKTE_SERVER=ws://localhost:8080/ws`
(Android-Emulator: `ws://10.0.2.2:8080/ws`).

Smoke-Test (Fake-Runtime + echte RoomRuntime, echte WebSocket-Clients):

```bash
dart run tool/smoke.dart            # -v: Server-Log zeigen, --fake-only / --real-only
```

## Umgebungsvariablen

| Variable         | Standard                                                        | Bedeutung                                   |
|------------------|-----------------------------------------------------------------|---------------------------------------------|
| `PORT`           | `8080`                                                          | HTTP-Port (Railway setzt ihn selbst)        |
| `SCENARIO_DIR`   | `/app/content/scenarios`, sonst `../content/scenarios`          | Alle `*.json` darin werden geladen          |
| `INCLUDE_SAMPLE` | –                                                               | `1` = Beispiel-Szenario `sample` dazuladen  |
| `TRUST_PROXY`    | `1`                                                             | `0` = Client-Adresse aus der TCP-Verbindung statt aus `X-Real-IP`/`X-Forwarded-For` (nur ohne Proxy davor) |

Ungültige Szenario-Dateien werden geloggt und übersprungen. Ist der Ordner leer, wird
`sample` geladen (wie in der App).

## Docker

Build-Kontext ist das **Repo-Root** (der Server braucht `packages/mordakte_core`):

```bash
docker build -f server/Dockerfile -t mordakte-server .
docker run --rm -p 8080:8080 mordakte-server
```

Das Image ist `FROM scratch` mit AOT-Binary und `content/scenarios` (~18 MB).

## Railway

1. Neuer Service aus dem GitHub-Repo.
2. **Root Directory leer lassen** (= Repo-Root) – sonst fehlt dem Build `packages/mordakte_core`.
   `railway.toml` im Root wählt `server/Dockerfile`, Healthcheck `/health`.
3. Networking → Domain erzeugen. Die App bekommt dann
   `--dart-define=MORDAKTE_SERVER=wss://<domain>/ws`.
4. Genau **eine** Instanz, kein „Serverless/Sleep“: Räume liegen im Speicher. Ein Deploy
   beendet laufende Partien (die Apps melden dann `room_not_found`).

## Protokoll-Details

Umschläge wie in `packages/mordakte_core/lib/src/protocol/messages.dart`, mit diesen Ergänzungen:

- **`w`**: `WorldSnapshot.toJson()` enthält selbst ein Feld `t` (Laufzeit), das mit dem Typ
  kollidiert. Die Laufzeit steht deshalb unter `wt`: `{"t":"w","wt":12345,"phase":…}`
  (`lib/wire.dart`, gelesen in `lib/session/online_session.dart`).
- Zusätzliche Fehler-Schlüssel: `server_error` (Ausnahme beim Erstellen/Beitreten),
  `server_full` (zu viele Räume).
- Close-Code `4000`: Eine neuere Verbindung mit demselben Token hat übernommen.
- Reconnect: `hello` mit bekanntem Token → gleiche Spieler-ID; war der Spieler in einem Raum,
  folgen sofort `room` und `c`. Nach 120 s ohne Reconnect → `leave`.
- `hello` mit `"resume": false` (erster Aufbau der App, danach kommt `create`/`join`): Die
  Mitgliedschaft im alten Raum bleibt, aber `room`/`c`/`w` dieses Raums kommen erst nach einem
  `join` mit seinem Code. Ohne das Feld wie oben.
- Ein zweites `hello` mit anderem Token auf demselben Socket → `err protocol`.
- Limits: 8 KB pro Nachricht (über 16 KB, auch fragmentiert, wird der Socket sofort getrennt),
  40 Nachrichten/s pro Socket (darüber verworfen), 1 `create` pro 2 s und Spieler (`err cooldown`),
  20 offene Sockets pro Client-Adresse, 10 000 insgesamt (darüber HTTP 503).
- Wer einen Raum verlässt, bekommt beim Wiederbeitritt keine alten Ereignisse nachgeliefert.
- Leere Lobbys schließen sofort; andere Räume 5 Min nach dem letzten verbundenen Spieler bzw.
  10 Min nach Spielende. Tokens ohne Raum verfallen nach 30 Min (nie in einem Raum: 2 Min).

## Aufbau

| Datei                | Inhalt                                                  |
|----------------------|---------------------------------------------------------|
| `bin/server.dart`    | Einstieg: Env, Szenarien, HTTP, SIGTERM                 |
| `lib/server.dart`    | Shelf-Handler: `/health`, `/ws`                         |
| `lib/connection.dart`| Eine WebSocket-Verbindung: Parsing, Limits              |
| `lib/rooms.dart`     | `RoomManager`, `Room` (Tick-/Snapshot-Schleife), Spieler |
| `lib/runtime.dart`   | `GameRuntime`-Interface + Adapter auf `RoomRuntime`     |
| `lib/codes.dart`     | Raumcodes (ohne 0/O/1/I), Spieler-IDs, Tokens           |
| `lib/wire.dart`      | JSON-Umschläge                                          |
| `lib/scenarios.dart` | Szenarien von Platte laden                              |
| `tool/smoke.dart`    | Smoke-Test                                              |
