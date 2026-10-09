# Lizenzliste neuer Abhängigkeiten

| Paket | Wofür | Lizenz | Begründung | Eingeführt in |
|---|---|---|---|---|
| `pdf` (pub.dev) | PDF-Satz je Fall-Code | Apache-2.0 | verbreitet, gepflegt, reines Dart, läuft in CLI und Web | F5 (geplant) |
| `playwright` 1.56.1 (npm, nur Entwicklung, `tool/e2e/`) | automatisierte Durchläufe, Bildschirmfotos, Konsolen- und Netzprüfung | Apache-2.0 | Standardwerkzeug; nutzt das vorinstallierte Chromium, kein Browser-Download | F1 (Karten-Probelauf) |
| `crypto` 3.0.7 (pub.dev, nur Entwicklung in `mordakte_core`) | Prüfsumme des lokalen Rohchats im Quellabgleich-Test | BSD-3-Clause | war schon transitiv über `test` vorhanden, jetzt direkt benannt | F1 |

Keine weiteren neuen Abhängigkeiten. Die Sprachausgabe nutzt die Web Speech API des Browsers über `dart:js_interop`, ohne zusätzliches Paket.
