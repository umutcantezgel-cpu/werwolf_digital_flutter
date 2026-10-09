#!/usr/bin/env bash
# Gesamtprüfung des Repos. Aufruf: tool/pruefen.sh [schnell|alles|e2e]
#   schnell: Pakete auflösen, Analyse, Kern-Tests (Kanon, Logik, Partymodus)
#   alles:   dazu Szenario-Validator, Server-Smoke, Flutter-Tests, Web-Build ohne CDN
#   e2e:     dazu automatisierte Durchläufe (tool/e2e) gegen den Web-Build
# Zum Schluss läuft immer der Secret-Scan.
set -euo pipefail
cd "$(dirname "$0")/.."
STUFE="${1:-alles}"
if [ -f .werkzeug/env.sh ]; then
  # shellcheck disable=SC1091
  source .werkzeug/env.sh
fi

schritt() { printf '\n== %s\n' "$*"; }

# Reihenfolge wichtig: Erst alle Pakete auflösen, sonst meldet die Analyse
# im Wurzelordner fehlende Test-Pakete in packages/mordakte_core.
schritt "Pakete auflösen"
flutter pub get
(cd packages/mordakte_core && dart pub get)
(cd server && dart pub get)

schritt "Analyse"
flutter analyze
(cd server && dart analyze)

schritt "Kern-Tests (mordakte_core, inkl. Partymodus)"
(cd packages/mordakte_core && dart test)

if [ "$STUFE" != "schnell" ]; then
  schritt "Szenario-Validator (Bestand)"
  (cd packages/mordakte_core && dart run bin/validate.dart)
  schritt "Partymodus: Plausibilität, Story-Bibel, Simulator"
  (cd packages/mordakte_core && dart run bin/party_pruefen.dart && dart run bin/party_bibel.dart --pruefen && dart run bin/party_simulate.dart --pruefen)
  schritt "Server-Smoke (Bestand)"
  (cd server && dart run tool/smoke.dart)
  if [ -d test ]; then
    schritt "Flutter-Tests"
    flutter test
  fi
  schritt "Web-Build ohne CDN"
  # Build-Cache leeren: Nach einem Build ohne „-o“ (tool/alle_tests.sh, build.sh) schreibt
  # Flutter sonst AssetManifest/FontManifest nicht neu (Nachtlauf E52).
  rm -rf .dart_tool/flutter_build
  flutter build web --release --no-web-resources-cdn -o build/web
fi

if [ "$STUFE" = "e2e" ]; then
  schritt "Automatisierte Durchläufe"
  (cd tool/e2e && npm test)
fi

schritt "Secret-Scan"
tool/secret_scan.sh
printf '\nAlle Prüfungen bestanden (%s).\n' "$STUFE"
