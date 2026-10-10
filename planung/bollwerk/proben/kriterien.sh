#!/usr/bin/env bash
# Schriftprüfung der Z-Kriterien: jede Zeile "| Z-nn |" braucht einen Befehl in Backticks,
# eine Schwelle mit Zahl oder Vergleich und einen Belegpfad. Ausgabe: Mängel je Zeile, Summe.
set -uo pipefail
f=${1:-planung/bollwerk/MASTER-PROMPT.md}
maengel=0; n=0
while IFS= read -r z; do
  n=$((n+1)); id=$(echo "$z" | cut -d'|' -f2 | tr -d ' ')
  methode=$(echo "$z" | awk -F'|' '{print $4}'); schwelle=$(echo "$z" | awk -F'|' '{print $5}'); beleg=$(echo "$z" | awk -F'|' '{print $6}')
  m=""
  echo "$methode" | grep -q '`[^`]\+`' || m="$m befehl"
  echo "$schwelle" | grep -qE '[0-9]|≤|≥|=|<|>|bytegleich' || m="$m schwelle"
  echo "$beleg" | grep -qE '`?[A-Za-z0-9_./-]+\.(txt|md|json)`?|belege/' || m="$m beleg"
  if [ -n "$m" ]; then maengel=$((maengel+1)); echo "MANGEL $id:$m"; fi
done < <(grep -E '^\| Z-[0-9]+ ' "$f")
echo "KRITERIEN $n · Mängel $maengel"
[ "$maengel" -eq 0 ]
