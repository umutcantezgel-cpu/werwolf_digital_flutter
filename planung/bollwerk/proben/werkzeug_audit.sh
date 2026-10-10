#!/usr/bin/env bash
# Werkzeug-Audit der Hintergrund-Agenten (nur lesend). Zählt echte tool_use-Aufrufe je Agent
# aus den Agentenprotokollen und meldet:
#   1. jeden Aufruf außerhalb der Erlaubnisliste,
#   2. Bash-Befehle mit git-Schreibbefehlen (commit, push, reset, checkout, merge, rebase, tag, branch -d/-D, worktree),
#      Netzwerkzugriff (curl, wget), Installationen (pip, npm, pub global), flutter build, --update-goldens
#      oder Löschbefehlen außerhalb der Schreibwurzel,
#   3. Write/Edit außerhalb der Schreibwurzeln (Standard: Scratchpad, /home/user/bw-varianten/, /home/user/bw/01–06/,
#      /home/user/bw-arbeit/); jeder Write nach $BW ist damit rot. Im Nachtlauf: nur die agentIds der Welle aus FLUG.md prüfen.
# Zitierte Teile ('…', "…") werden vor dem Bash-Abgleich entfernt (grep-Muster sind keine Befehle).
# Aufruf: bash werkzeug_audit.sh [protokollordner] [schreibwurzel-regex]
# Exit 0 nur bei ≥ 1 geprüftem Agenten und 0 Verstößen. Mit SOLL=<n> (Zahl der Agenten laut FLUG.md) zusätzlich rot,
# wenn weniger Protokolle gefunden werden. Rot-Probe: bash werkzeug_audit.sh <ordner mit einem Protokoll, das ToolSearch ruft> → Exit 1.
set -uo pipefail
erlaubt='^(Read|Grep|Glob|Write|Edit|Bash|SubagentHandback)$'
dirs=${1:-$(ls -d ~/.claude/projects/*/*/subagents 2>/dev/null)}
wurzel=${2:-'^(/tmp/claude-[0-9]+/[^/]+/[^/]+/scratchpad/|/home/user/bw-arbeit/|/home/user/bw-varianten/|/home/user/bw/0[1-6]/)'}
bash_rot='(^|[;&|( ]) *git( +-[cC] +[^ ]+| +--[a-z-]+(=[^ ]+)?)* +(commit|push|reset|checkout|switch|merge|rebase|tag|worktree|update-ref|branch +-[dDmM])|(^|[;&|( ]) *(curl|wget|ssh|scp) +(-|https?:)|rm +-[a-zA-Z]*r[a-zA-Z]* +/(home/user/werwolf|root)|(^|[;&|( ]) *(pip3?|npm|pnpm|yarn) +(install|i |add)|pub +global|flutter +build|--update-goldens|(^|[;&|( ]) *gh +'
verstoss=0; agenten=0
for d in $dirs; do for f in "$d"/agent-*.jsonl; do
  [ -f "$f" ] || continue; agenten=$((agenten+1))
  modell=$(grep -o '"model":"[^"]*"' "$f" | sort -u | tr '\n' ' ')
  aufrufe=$(jq -c 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use") | {n:.name, c:(.input.command // ""), p:(.input.file_path // "")}' "$f" 2>/dev/null)
  fremd=$(echo "$aufrufe" | jq -r '.n' 2>/dev/null | grep -vE "$erlaubt" | grep . | sort | uniq -c | tr '\n' ' ')
  bashrot=$(echo "$aufrufe" | jq -r 'select(.n=="Bash") | .c' 2>/dev/null | sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g" | grep -E "$bash_rot" | head -3 | cut -c1-120 | tr '\n' ' ')
  bwrot=$(echo "$aufrufe" | jq -r 'select(.n=="Bash") | .c' 2>/dev/null | grep -E '/home/user/werwolf_digital_flutter' | head -1 | cut -c1-120)
  bashrot="$bashrot${bwrot:+ BW-Zugriff: $bwrot}"
  pfadrot=$(echo "$aufrufe" | jq -r 'select(.n=="Write" or .n=="Edit") | .p' 2>/dev/null | grep . | grep -vE "$wurzel" | sort -u | head -3 | tr '\n' ' ')
  if [ -n "$fremd$bashrot$pfadrot" ]; then
    verstoss=$((verstoss+1))
    echo "VERSTOSS $(basename "$f") · $modell· werkzeug: ${fremd:-–} · bash: ${bashrot:-–} · pfad: ${pfadrot:-–}"
  fi
done; done
echo "AUDIT agenten=$agenten verstoesse=$verstoss"
[ "$agenten" -ge 1 ] && [ "$verstoss" -eq 0 ] && [ "$agenten" -ge "${SOLL:-0}" ]
