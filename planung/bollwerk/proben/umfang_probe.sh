#!/usr/bin/env bash
# Umfangsmaß-Probe des Meta-Laufs (MESSBASIS-PROGNOSE, nie Basis). Zählt die Indexachsen X1–X6
# in einem Baum. Die verbindliche Basis zählt der Nachtlauf in BW0 an K mit tool/bollwerk/umfang.dart.
# Aufruf: bash umfang_probe.sh <baum> [dart-env.sh]
set -euo pipefail
B=${1:?Baum fehlt}; K=$B/content/party/schlosskeller
[ -n "${2:-}" ] && source "$2"
x1=$(jq '.entscheidungen | length' $K/entscheidungen.json)                       # wertende + Folge + Abstecher (Schicht: content/runden)
if [ -d $B/content/runden/schlosskeller ]; then
  x1=$((x1 + $(cat $B/content/runden/schlosskeller/*entscheidung*.json 2>/dev/null | jq -s '[.[].eintraege[]?] | length')))
fi
x2=$(cd $B/packages/mordakte_core && dart run bin/party_texte.dart 2>/dev/null | sed -n 's/^Geprüfte Texte: \([0-9]*\)$/\1/p')
x3=$(jq '.orte | length' $K/raeume.json)
x4=$(jq '.lacher | length' $K/setting.json)
x5=0   # Weißlisten-Zusatzfunde: am Stand fin gibt es keinen Zusatzfund-Mechanismus (Anhang C4 = Kandidaten)
x6=$(grep -c "math.sin(walk) \* moveAmt" $B/lib/game/scene/figure_painter.dart)  # sichtbare Aktionsarten mit Animation: nur „gehen“
echo "BAUM $(cd $B && git rev-parse HEAD 2>/dev/null || echo unbekannt)"
echo "X1 Entscheidungen inkl. Folge/Abstecher: $x1"
echo "X2 Spieltexte (party_texte.dart): $x2"
echo "X3 Orte in den 7 Räumen: $x3"
echo "X4 Gags (setting.json lacher): $x4"
echo "X5 Weißlisten-Zusatzfunde: $x5"
echo "X6 sichtbare Aktionsarten mit Animation: $x6"
