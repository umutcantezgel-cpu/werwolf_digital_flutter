# Lizenzliste neuer Abhängigkeiten

| Paket | Wofür | Lizenz | Begründung | Eingeführt in |
|---|---|---|---|---|
| `pdf` 3.13.1 (pub.dev, in `mordakte_core`) | PDF-Satz je Fall-Code | Apache-2.0 | verbreitet, gepflegt, reines Dart, läuft in CLI und Web | F1 (Probeseite), F5 (Satz) |
| Transitiv über `pdf`: `archive`, `image`, `xml`, `bidi`, `posix` (MIT), `barcode` (Apache-2.0), `qr`, `path_parsing`, `petitparser`, `vector_math`, `ffi` (BSD/MIT) | Teile des PDF-Pakets | MIT, BSD-3-Clause, Apache-2.0 | kommen nur über `pdf`, keine eigene Nutzung | F1 |
| `playwright` 1.56.1 (npm, nur Entwicklung, `tool/e2e/`) | automatisierte Durchläufe, Bildschirmfotos, Konsolen- und Netzprüfung | Apache-2.0 | Standardwerkzeug; nutzt das vorinstallierte Chromium, kein Browser-Download | F1 (Karten-Probelauf) |
| `crypto` 3.0.7 (pub.dev, nur Entwicklung in `mordakte_core`) | Prüfsumme des lokalen Rohchats im Quellabgleich-Test | BSD-3-Clause | war schon transitiv über `test` vorhanden, jetzt direkt benannt | F1 |
| `flutter_test` (Flutter-SDK, nur Entwicklung in der App), transitiv `boolean_selector`, `leak_tracker*`, `matcher`, `test_api`, `stack_trace`, `vm_service`, `fake_async` | Widget-Tests der Party-Bildschirme | BSD-3-Clause | Teil des Flutter-SDK, Standard für Widget-Tests | F4 |

Keine weiteren neuen Abhängigkeiten. Die Sprachausgabe nutzt die Web Speech API des Browsers über `dart:js_interop`, ohne zusätzliches Paket.

Geprüft am 10.10.2026 (F6, F-16): Gegenüber `origin/main` fügt der Branch in `pubspec.lock` der App nur `flutter_test` mit `boolean_selector`, `fake_async`, `leak_tracker`, `leak_tracker_flutter_testing`, `leak_tracker_testing`, `matcher`, `stack_trace`, `test_api` und `vm_service` hinzu (alle BSD-3-Clause, Flutter- und Dart-Team). In `packages/mordakte_core/pubspec.lock` kommt nichts hinzu, was nicht oben steht. `tool/e2e/package.json` nennt nur `playwright` 1.56.1. Die Schriften in `assets/fonts` (Inter, Special Elite) waren schon im Bestand.
