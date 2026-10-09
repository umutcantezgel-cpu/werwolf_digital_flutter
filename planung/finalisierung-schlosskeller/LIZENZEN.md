# Lizenzliste neuer Abhängigkeiten

| Paket | Wofür | Lizenz | Begründung | Eingeführt in |
|---|---|---|---|---|
| `pdf` (pub.dev) | PDF-Satz je Fall-Code | Apache-2.0 | verbreitet, gepflegt, reines Dart, läuft in CLI und Web | F5 (geplant) |
| `playwright` (npm, nur Entwicklung, `tool/e2e/`) | automatisierte Durchläufe, Bildschirmfotos, Konsolen- und Netzprüfung | Apache-2.0 | Standardwerkzeug; nutzt das vorinstallierte Chromium, kein Browser-Download | F4 (geplant) |

Keine weiteren neuen Abhängigkeiten. Die Sprachausgabe nutzt die Web Speech API des Browsers über `dart:js_interop`, ohne zusätzliches Paket.
