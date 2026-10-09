#!/usr/bin/env bash
# Werkzeug-Audit der Hintergrund-Agenten (nur lesend). Zählt echte tool_use-Aufrufe je Agent
# aus den Agentenprotokollen und meldet jeden Aufruf außerhalb der Erlaubnisliste.
# Aufruf: bash werkzeug_audit.sh [protokollordner]   (Standard: alle subagents-Ordner der Sitzung)
set -uo pipefail
erlaubt='^(Read|Grep|Glob|Write|Edit|Bash|SubagentHandback)$'
dirs=${1:-$(ls -d ~/.claude/projects/*/*/subagents 2>/dev/null)}
verstoss=0; agenten=0
for d in $dirs; do for f in "$d"/agent-*.jsonl; do
  [ -f "$f" ] || continue; agenten=$((agenten+1))
  modell=$(grep -o '"model":"[^"]*"' "$f" | sort -u | tr '\n' ' ')
  namen=$(jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use") | .name' "$f" 2>/dev/null)
  fremd=$(echo "$namen" | grep -vE "$erlaubt" | grep . | sort | uniq -c | tr '\n' ' ')
  if [ -n "$fremd" ]; then verstoss=$((verstoss+1)); echo "VERSTOSS $(basename "$f") · $modell· $fremd"; fi
done; done
echo "AUDIT agenten=$agenten verstoesse=$verstoss"
[ "$verstoss" -eq 0 ]
