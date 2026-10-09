#!/usr/bin/env bash
# Burgstadt HD: Migrationsbeleg (E-035). Rendert einen festen Bildsatz – jeden Bereich in
# zwei Formaten, Belegfotos, Bildschirme, Oberstadt-Ansichten, Figuren, Porträts, Texturen –
# nach <ordner>. Zwei Bildsätze vergleicht `bash tool/hd_migbeleg.sh --vergleiche <a> <b>`:
# gleiche PNG-Bytes heißen gleiche Pixel (der PNG-Schreiber ist deterministisch).
# Aufruf: bash tool/hd_migbeleg.sh <ordner> | --vergleiche <ordner-a> <ordner-b>
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH=/opt/flutter/bin:$PATH
filter() { grep -a -v -E 'Woah|superuser|running flutter as root|📎|^  /$' || true; }

if [ "${1:-}" = "--vergleiche" ]; then
  A="$2"; B="$3"
  gesamt=0; gleich=0; anders=0; fehlt=0
  while IFS= read -r f; do
    rel="${f#"$A"/}"
    gesamt=$((gesamt + 1))
    if [ ! -f "$B/$rel" ]; then
      fehlt=$((fehlt + 1)); echo "FEHLT  $rel"
    elif cmp -s "$f" "$B/$rel"; then
      gleich=$((gleich + 1))
    else
      anders=$((anders + 1)); echo "ANDERS $rel"
    fi
  done < <(find "$A" -name '*.png' | sort)
  echo "MIGRATIONSBELEG · Bilder $gesamt · gleich $gleich · anders $anders · fehlt $fehlt"
  [ "$anders" = 0 ] && [ "$fehlt" = 0 ] && [ "$gesamt" -gt 0 ]
  exit $?
fi

OUT="$(mkdir -p "$1" && cd "$1" && pwd)"
cd "$ROOT/packages/burgstadt_spiel"
for g in "1280 720" "1080 2400"; do
  set -- $g
  d="$OUT/${1}x${2}"
  mkdir -p "$d/bereiche" "$d/beleg" "$d/schirme" "$d/stadt"
  dart run bin/bereichsfotos.dart "$d/bereiche" "$1" "$2" 2>&1 | filter | tail -1
  dart run bin/belegfotos.dart "$d/beleg" "$1" "$2" 2>&1 | filter | grep -E "BELEGFOTOS"
  dart run bin/bildschirmfoto.dart "$d/schirme" "$1" "$2" 2>&1 | filter | tail -1
  dart run bin/stadtfotos.dart "$d/stadt" "$1" "$2" 2>&1 | filter | tail -1
done
cd "$ROOT/packages/pixel_engine"
mkdir -p "$OUT/figuren"
dart run bin/aufstellung.dart "$OUT/figuren/aufstellung.png" 2>&1 | filter | tail -1
dart run bin/portraetprobe.dart "$OUT/figuren/portraets.png" 2>&1 | filter | tail -1
dart run bin/figurenprobe.dart "$OUT/figuren/figurenprobe.png" 2>&1 | filter | tail -1
dart run bin/teile_koepfe_probe.dart "$OUT/figuren/teile_koepfe.png" 2>&1 | filter | tail -1
dart run bin/teile_kleidung_probe.dart "$OUT/figuren/teile_kleidung.png" 2>&1 | filter | tail -1
dart run bin/texturprobe.dart "$OUT/figuren/texturen.png" 2>&1 | filter | tail -1
echo "BILDSATZ $(find "$OUT" -name '*.png' | wc -l) Bilder in $OUT"
