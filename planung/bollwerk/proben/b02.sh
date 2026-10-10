#!/usr/bin/env bash
# B-02-Probe (nur lesend). Prüft die Bedingungen, die der Leitstand für „B-02 ERFÜLLT“ anwendet
# (Master-Prompt Abschnitt 2.2). Maßgeblich bleibt allein der Eintrag in STEUERUNG.md.
# Aufruf: bash planung/bollwerk/proben/b02.sh [pr43=offen|gemergt|geschlossen]
set -uo pipefail
FIN=origin/finalisierung-schlosskeller
P=planung/finalisierung-schlosskeller
git fetch -q origin finalisierung-schlosskeller main nachtlauf/burgstadt bollwerk-leitstand 2>/dev/null
jetzt=$(date -u +%s); ok=0; n=0
pruefe() { n=$((n+1)); if [ "$2" = ja ]; then ok=$((ok+1)); echo "B02.$n ja   · $1"; else echo "B02.$n nein · $1"; fi; }

z=nein; for d in ABSCHLUSSBERICHT.md STATUS.md; do git show "$FIN:$P/$d" 2>/dev/null | grep -q 'ZIEL ERREICHT' && z=ja; done
pruefe "Finalisierung meldet ZIEL ERREICHT ($P/ABSCHLUSSBERICHT.md|STATUS.md)" $z
pruefe "Spitze $(git rev-parse --short $FIN) ist Vorfahr von origin/main" $(git merge-base --is-ancestor $FIN origin/main && echo ja || echo nein)
t=$(git log -1 --format=%ct $FIN); alt=$(( (jetzt - t) / 60 ))
pruefe "seit 60 min kein Commit auf $FIN (letzter vor $alt min)" $([ $alt -ge 60 ] && echo ja || echo nein)
seit=$(date -u -d @$((jetzt-3600)) +%FT%TZ)
treffer=$(git log --since="$seit" --format=%h origin/main origin/nachtlauf/burgstadt -- "$P" content/party lib/party packages/mordakte_core | sort -u | wc -l)
pruefe "0 Commits der letzten 60 min auf main/nachtlauf berühren fin-Pfade (gefunden: $treffer)" $([ "$treffer" -eq 0 ] && echo ja || echo nein)
pr=${1:-}; [ -z "$pr" ] && pr=unbekannt
pruefe "PR #43 gemergt oder geschlossen (Stand: $pr; lesend über GitHub prüfen)" $([ "$pr" = gemergt ] || [ "$pr" = geschlossen ] && echo ja || echo nein)
eintrag=$(git show origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md 2>/dev/null | grep -oE '(B-02 ERFÜLLT|FREIGABE BOLLWERK) · K=[0-9a-f]{40}' | tail -1)
echo "STEUERUNG: ${eintrag:-kein B-02-Eintrag}"
if [ -n "$eintrag" ]; then echo "B-02 ERFÜLLT laut STEUERUNG"; elif [ $ok -eq $n ]; then echo "B-02 vermutlich ($ok/$n) · Eintrag des Leitstands fehlt"; else echo "B-02 offen ($ok/$n)"; fi
