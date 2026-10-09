# Kanon-Schemas für den Partymodus

Ein Schema je Kanon-Datei (fallneutral, gilt für jeden Fall unter `content/party/<fall>/`).
Geprüft wird mit dem eigenen Prüfer `SchemaPruefer` in `packages/mordakte_core/lib/src/party/kanon/schema.dart`
(Teilmenge von JSON Schema Draft 2020-12) im Test `test/party/kanon_schema_test.dart`.

| Datei | Schema |
|---|---|
| `fall.json` | `fall.schema.json` |
| `setting.json` | `setting.schema.json` |
| `raeume.json` | `raeume.schema.json` |
| `wahrnehmung.json` | `wahrnehmung.schema.json` |
| `figuren.json` | `figuren.schema.json` |
| `gegenstaende.json` | `gegenstaende.schema.json` |
| `zeitleiste.json` | `zeitleiste.schema.json` |
| `beobachtungen.json` | `beobachtungen.schema.json` |
| `tatmatrix/*.json` | `tatmatrix.schema.json` |

Querverweise (Orte, Personen, Lügen, Gegenstände, Zeitleiste) prüft zusätzlich `kanonVerweise()` in `party/kanon/verweise.dart`.
