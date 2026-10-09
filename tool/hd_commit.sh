#!/usr/bin/env bash
# Burgstadt HD: Commit nur bei grünem Schnelllauf, unveränderten Spieltexten und gleicher
# Layout-Prüfsumme. Nimmt nur die genannten Pfade auf (kein „git add -A“) und pusht auf den
# HD-Arbeitsbranch (N-HD-01, E-030).
# Aufruf: bash tool/hd_commit.sh "<Nachricht>" <pfad> [<pfad> …]
# Bestehen alle Pfade nur aus hd/ (Dokumente, Belege), entfällt der Schnelllauf.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
export PATH=/opt/flutter/bin:$PATH
BRANCH=claude/pensive-gates-ajtp7x
SITZUNG=https://claude.ai/code/session_01Aix28JmFAfTMVcF4Z8bgqP
filter() { grep -a -v -E 'Woah|superuser|running flutter as root|📎|^  /$' || true; }

if [ $# -lt 2 ]; then
  echo "Aufruf: bash tool/hd_commit.sh \"<Nachricht>\" <pfad> [<pfad> …]"
  exit 2
fi
NACHRICHT="$1"; shift
PFADE=("$@")

# 1 · richtiger Branch
AKTUELL="$(git rev-parse --abbrev-ref HEAD)"
if [ "$AKTUELL" != "$BRANCH" ]; then
  echo "FALSCHER BRANCH: $AKTUELL (erwartet $BRANCH) – kein Commit"
  exit 1
fi

# 2 · Spieltexte (textPfade aus Z-12) ohne Unterschied zum zuletzt eingemergten Nachtlauf
TEXTPFADE=(packages/burgstadt_core/data packages/burgstadt_spiel/data/texte packages/pixel_engine/data/figuren
  nachtlauf/kanon krimidinner/spuk-im-gewoelbe/10_kanon)
BASIS="$(git merge-base HEAD origin/nachtlauf/burgstadt)"
if ! git diff --quiet "$BASIS" -- "${TEXTPFADE[@]}" || [ -n "$(git status --porcelain -- "${TEXTPFADE[@]}")" ]; then
  echo "TEXTPFADE GEÄNDERT gegenüber ${BASIS:0:7} – kein Commit:"
  git diff --stat "$BASIS" -- "${TEXTPFADE[@]}"
  git status --porcelain -- "${TEXTPFADE[@]}"
  exit 1
fi

# 3 · nachtlauf/: nur neue Dateien unter nachtlauf/auftraege/A-605 (N-HD-02)
for p in "${PFADE[@]}"; do
  case "$p" in
    nachtlauf/auftraege/A-605/*)
      if git cat-file -e "HEAD:$p" 2>/dev/null; then
        echo "A-605-Bericht existiert schon: $p – nur neue Dateien erlaubt"
        exit 1
      fi ;;
    nachtlauf/*|krimidinner/*)
      echo "Pfad außerhalb des HD-Auftrags: $p – kein Commit"
      exit 1 ;;
  esac
done

# 4 · nur die genannten Pfade aufnehmen
git add -- "${PFADE[@]}" || exit 1
if git diff --cached --quiet; then
  echo "Nichts zu committen."
  exit 0
fi

# 5 · Schnelllauf in einem sauberen Arbeitsbaum, der genau HEAD + die aufgenommenen Pfade enthält
#     (parallele Pakete im Arbeitsbaum stören den Lauf nicht); entfällt, wenn nur hd/ betroffen ist
NUR_DOKU=1
for p in "${PFADE[@]}"; do
  case "$p" in hd|hd/*) ;; *) NUR_DOKU=0 ;; esac
done
if [ "$NUR_DOKU" = 0 ]; then
  SAUBER="$(mktemp -d)/baum"
  LOG="$(mktemp)"
  git worktree add --detach -q "$SAUBER" HEAD || exit 1
  aufraeumen() { git worktree remove --force "$SAUBER" >/dev/null 2>&1 || true; }
  if ! git diff --cached --binary | git -C "$SAUBER" apply --whitespace=nowarn; then
    echo "Übertragen in den sauberen Baum fehlgeschlagen – kein Commit"
    aufraeumen; git reset -q -- "${PFADE[@]}"; exit 1
  fi
  for d in .dart_tool packages/*/.dart_tool tool/ton/.dart_tool server/.dart_tool; do
    if [ -d "$d" ]; then mkdir -p "$SAUBER/$(dirname "$d")" && cp -a "$d" "$SAUBER/$d"; fi
  done
  (cd "$SAUBER" && bash tool/alle_tests.sh schnell) > "$LOG" 2>&1
  aufraeumen
  if ! grep -aq "ALLE TESTS GRÜN" "$LOG"; then
    echo "NICHT GRÜN – kein Commit. Letzte Zeilen:"
    filter < "$LOG" | tail -20
    git reset -q -- "${PFADE[@]}"
    exit 1
  fi
  echo "Schnelllauf grün (sauberer Baum)."
  grep -a "LAYOUT" "$LOG" | tail -2
fi

# 6 · Commit
git commit -q -F - <<MSG || exit 1
$NACHRICHT

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: $SITZUNG
MSG

# 7 · Push mit Exit-Code und Wiederholung bei Netzfehlern (2, 4, 8, 16 s)
warte=2
for versuch in 1 2 3 4 5; do
  if git push -q -u origin "HEAD:$BRANCH" 2>&1 | filter; [ "${PIPESTATUS[0]}" = 0 ]; then
    git log --oneline -1
    exit 0
  fi
  [ "$versuch" = 5 ] && break
  echo "Push fehlgeschlagen (Versuch $versuch) – neuer Versuch in ${warte}s"
  sleep "$warte"; warte=$((warte * 2))
done
echo "PUSH FEHLGESCHLAGEN – Commit liegt lokal: $(git log --oneline -1)"
exit 1
