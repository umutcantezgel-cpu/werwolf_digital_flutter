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
    # Achtung: kein „test && … || echo“ – das würde einen roten Testlauf als „keine Tests“ verschlucken
    (cd "packages/$p" && dart pub get >/dev/null 2>&1 && dart analyze --fatal-infos 2>&1 | filter | tail -1
     if [ -d test ]; then dart test 2>&1 | filter | tail -1; else echo "keine Tests"; fi)
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
if [ -f packages/burgstadt_core/bin/erkundung.dart ]; then
  step "Ebene 6 · Welt: Erkundungsbots laufen zu jeder Tür (Kollision wie der Spieler)"
  (cd packages/burgstadt_core && dart run bin/erkundung.dart 2>&1 | filter | grep -E "Türen|Nicht erreicht|Steckenbleiber")
fi

if [ -f packages/room_host/test/mp_sim.dart ]; then
  step "Ebene 8 · Mehrspieler: Host + 4/8/20 WebSocket-Clients (Teilen < 1 s, gleicher Stand, Bots füllen)"
  (cd packages/room_host && dart run test/mp_sim.dart 2>&1 | filter | grep -E "Teilnehmer|ABWEICHUNG|MP-SIM")
fi

if [ -f packages/burgstadt_core/bin/durchspiel.dart ]; then
  step "Ebene 3/4 · Durchspiel 4…20 mit Bots, Teilen-Nutzen"
  (cd packages/burgstadt_core && dart run bin/durchspiel.dart 2>&1 | filter | grep -E "Teilen-Nutzen|DURCHSPIEL")
fi
if [ -f packages/burgstadt_core/bin/fairness.dart ]; then
  step "Ebene 2 · Fairness: Löser für N = 4…20 (Absicherung S-1…S-7, Orte in der Welt)"
  (cd packages/burgstadt_core && dart run bin/fairness.dart 2>&1 | filter | grep -E "FAIRNESS|^  - ")
fi
for t in teilen_nutzen; do
  if [ -f "packages/burgstadt_core/bin/$t.dart" ] && [ "${1:-}" != "schnell" ]; then
    step "burgstadt_core: $t"
    (cd packages/burgstadt_core && dart run "bin/$t.dart" 2>&1 | filter | tail -8)
  fi
done

if [ -d packages/burgstadt_spiel ]; then
  step "Ebene 5 · Pixel: alle Bildschirme headless (Palette + Blocktest)"
  FOTOS="$(mktemp -d)"
  # Absturz bricht ab (set -e), „FEHLER“ in der Ausgabe ebenso
  BF="$(cd packages/burgstadt_spiel && dart run bin/bildschirmfoto.dart "$FOTOS" 1280 720 2>&1 | filter)"; echo "$BF"
  if echo "$BF" | grep -q FEHLER; then exit 1; fi
  # Absturz bricht ab (set -e), „FEHLER“ in der Ausgabe ebenso
  BF="$(cd packages/burgstadt_spiel && dart run bin/bildschirmfoto.dart "$FOTOS" 2401 1081 2>&1 | filter)"; echo "$BF"
  if echo "$BF" | grep -q FEHLER; then exit 1; fi
  step "Ebene 3/5 · Spieltest: Fall solo über die echten Bildschirme bis zum Ende (Fotos geprüft)"
  (cd packages/burgstadt_spiel && dart run bin/spieltest.dart "$FOTOS" 4 2>&1 | filter | grep -E "Ende:|SPIELTEST")
  (cd packages/burgstadt_spiel && dart run bin/spieltest.dart "$FOTOS" 12 1080 2400 2>&1 | filter | grep -E "SPIELTEST")
  step "Ebene 5 · Pixel (Z-02): Belegfotos – alle Menüs, sechs Viertel, zehn Innenräume, quer und hoch"
  (cd packages/burgstadt_spiel && dart run bin/belegfotos.dart "$FOTOS" 1280 720 2>&1 | filter | grep -E "BELEGFOTOS")
  (cd packages/burgstadt_spiel && dart run bin/belegfotos.dart "$FOTOS" 1080 2400 2>&1 | filter | grep -E "BELEGFOTOS")
  step "Ebene 5 · Pixel: Oberstadt-Ansichten (Generator, Palette + Blocktest, Bildzeit)"
  (cd packages/burgstadt_spiel && dart run bin/stadtfotos.dart "$FOTOS" 2>&1 | filter | tail -5)
fi

step "Kanon-Werkzeug (Original): kanon.py pruefe"
python3 krimidinner/spuk-im-gewoelbe/90_werkzeug/kanon.py pruefe 2>&1 | tail -1

step "Flutter analyze (App)"
flutter analyze 2>&1 | filter | tail -1

if [ "${1:-}" != "schnell" ]; then
  step "Ebene 11 · Server-Smoke"
  (cd server && dart pub get >/dev/null 2>&1 && timeout 300 dart run tool/smoke.dart 2>&1 | filter | tail -1)
  step "Ebene 9 · Geräte: Web-Build + Playwright (desktop, handy-quer, handy-hoch)"
  # Build-Cache leeren (E52): Wechselt die Aufrufform (mit/ohne „-o build/web“, z. B. nach
  # tool/pruefen.sh), hält das Flutter-Werkzeug die Asset-Ausgaben sonst für aktuell und schreibt
  # AssetManifest/FontManifest nicht neu in das geleerte build/web.
  rm -rf .dart_tool/flutter_build
  flutter build web --release --no-web-resources-cdn 2>&1 | filter | tail -1
  for m in AssetManifest.bin.json FontManifest.json; do
    [ -f "build/web/assets/$m" ] || { echo "Web-Build unvollständig: build/web/assets/$m fehlt"; exit 1; }
  done
  GER="$(mktemp -d)"
  timeout 600 node tool/browser/geraete.js build/web "$GER"
  for f in "$GER"/*.png; do
    case "$f" in *desktop*) k=2 ;; *) k=3 ;; esac
    (cd packages/pixel_engine && dart run bin/pixel_pruef.dart "$f" "$k" 2>&1 | filter)
  done
  step "Ebene 7 · Leistung (Z-09): AOT, 20 Spielminuten, Faktor 4"
  LEI="$(mktemp -d)"
  (cd packages/burgstadt_spiel && dart compile exe bin/leistung.dart -o "$LEI/leistung" 2>&1 | filter | tail -1 && "$LEI/leistung" 20 2>&1 | filter | tee "$LEI/ergebnis.txt" | grep -E "Nachladespitzen|Spiellogik|Speicher|Budget|LEISTUNG")
  step "Ebene 11 · Mordakte simulate"
  (cd packages/mordakte_core && dart run bin/simulate.dart alle 1 2 2>&1 | filter | grep "Σ")
fi
echo; echo "ALLE TESTS GRÜN"
