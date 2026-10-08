#!/usr/bin/env bash
# Gesamt-Testlauf aller Ebenen (Nachtlauf). Bricht beim ersten Fehler ab.
# Aufruf: bash tool/alle_tests.sh [schnell]
set -euo pipefail
export PATH=/opt/flutter/bin:$PATH
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
filter() { grep -v -E 'running flutter as root|superuser|Woah|📎|^  /$' || true; }
step() { echo; echo "== $*"; }

step "Ebene 11 · Bestand: mordakte_core"
(cd packages/mordakte_core && dart analyze 2>&1 | filter | tail -1 && dart test 2>&1 | filter | tail -1 && dart run bin/validate.dart 2>&1 | filter | grep -E "OK|FEHLER")

for p in pixel_engine burgstadt_core burgstadt_spiel room_host; do
  if [ -d "packages/$p" ]; then
    step "Paket $p: analyze + test"
    (cd "packages/$p" && dart pub get >/dev/null 2>&1 && dart analyze --fatal-infos 2>&1 | filter | tail -1 && { [ -d test ] && dart test 2>&1 | filter | tail -1 || echo "keine Tests"; })
  fi
done

if [ -f packages/burgstadt_core/bin/leitplanken.dart ]; then
  step "Ebene 10 · Leitplanken (alle Spieltexte: Burgstadt + Klassische Fälle)"
  (cd packages/burgstadt_core && dart run bin/leitplanken.dart 2>&1 | filter | tail -1)
fi

if [ -f packages/burgstadt_core/bin/kanon.dart ]; then
  step "Ebene 1/10 · Kanon-Abgleich + Leitplanken"
  (cd packages/burgstadt_core && dart run bin/kanon.dart --pruefe 2>&1 | filter | tail -5)
fi
if [ -f packages/burgstadt_core/bin/durchspiel.dart ]; then
  step "Ebene 3/4 · Durchspiel 4…20 mit Bots, Teilen-Nutzen"
  (cd packages/burgstadt_core && dart run bin/durchspiel.dart 2>&1 | filter | grep -E "Teilen-Nutzen|DURCHSPIEL")
fi
for t in fairness teilen_nutzen erkundung leistung; do
  if [ -f "packages/burgstadt_core/bin/$t.dart" ] && [ "${1:-}" != "schnell" ]; then
    step "burgstadt_core: $t"
    (cd packages/burgstadt_core && dart run "bin/$t.dart" 2>&1 | filter | tail -8)
  fi
done

if [ -d packages/burgstadt_spiel ]; then
  step "Ebene 5 · Pixel: alle Bildschirme headless (Palette + Blocktest)"
  FOTOS="$(mktemp -d)"
  (cd packages/burgstadt_spiel && dart run bin/bildschirmfoto.dart "$FOTOS" 1280 720 2>&1 | filter | tee /dev/stderr | grep -q FEHLER && exit 1 || true)
  (cd packages/burgstadt_spiel && dart run bin/bildschirmfoto.dart "$FOTOS" 2401 1081 2>&1 | filter | tee /dev/stderr | grep -q FEHLER && exit 1 || true)
fi

step "Kanon-Werkzeug (Original): kanon.py pruefe"
python3 krimidinner/spuk-im-gewoelbe/90_werkzeug/kanon.py pruefe 2>&1 | tail -1

step "Flutter analyze (App)"
flutter analyze 2>&1 | filter | tail -1

if [ "${1:-}" != "schnell" ]; then
  step "Ebene 11 · Server-Smoke"
  (cd server && dart pub get >/dev/null 2>&1 && timeout 300 dart run tool/smoke.dart 2>&1 | filter | tail -1)
  step "Ebene 9 · Geräte: Web-Build + Playwright (desktop, handy-quer, handy-hoch)"
  flutter build web --release --no-web-resources-cdn 2>&1 | filter | tail -1
  GER="$(mktemp -d)"
  timeout 600 node tool/browser/geraete.js build/web "$GER"
  for f in "$GER"/*.png; do
    case "$f" in *desktop*) k=2 ;; *) k=3 ;; esac
    (cd packages/pixel_engine && dart run bin/pixel_pruef.dart "$f" "$k" 2>&1 | filter)
  done
  step "Ebene 11 · Mordakte simulate"
  (cd packages/mordakte_core && dart run bin/simulate.dart alle 1 2 2>&1 | filter | grep "Σ")
fi
echo; echo "ALLE TESTS GRÜN"
