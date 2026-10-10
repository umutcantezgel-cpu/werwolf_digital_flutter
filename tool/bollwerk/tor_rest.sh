#!/usr/bin/env bash
# BOLLWERK · nicht gemergten bw-tor-Stand sichern bzw. wiederherstellen (Befund F-2 Teil 2).
# Aufruf: bash tool/bollwerk/tor_rest.sh sichern <gen> <phase>
#           schreibt planung/bollwerk/tor-rest/G<gen>.patch und gibt die Zeile für den PRUEFPUNKT aus
#           (TOR-REST G<gen> · <phase> · <sha256>); committet wird über commit.sh als Zustands-Commit.
#         bash tool/bollwerk/tor_rest.sh anwenden <gen>
#           legt bei Bedarf den Tor-Worktree auf bw-tor an und wendet den Patch mit --index an.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
TOR=/home/user/bw-arbeit/tor
AKT="${1:?sichern|anwenden}"; GEN="${2:?gen}"
DATEI="$BW/planung/bollwerk/tor-rest/G$GEN.patch"
case "$AKT" in
  sichern)
    PHASE="${3:?phase}"
    mkdir -p "$(dirname "$DATEI")"
    git -C "$TOR" diff --binary bollwerk...bw-tor > "$DATEI"
    if [ ! -s "$DATEI" ]; then rm -f "$DATEI"; echo "bw-tor ohne Unterschied zu bollwerk – nichts zu sichern"; exit 0; fi
    S="$(sha256sum "$DATEI" | cut -d' ' -f1)"
    bash "$BW/tool/secret_scan.sh" | tail -1 | grep -q 'Secret-Scan: sauber'
    echo "TOR-REST G$GEN · $PHASE · $S"
    ;;
  anwenden)
    [ -f "$DATEI" ] || { echo "kein Tor-Rest G$GEN"; exit 1; }
    if [ ! -d "$TOR" ]; then
      git -C "$BW" worktree add -q -B bw-tor "$TOR" bollwerk
    fi
    git -C "$TOR" apply --index "$DATEI"
    echo "Tor-Rest G$GEN angewandt in $TOR (jetzt commit.sh --tor <modus>, dann das Tor starten)"
    ;;
  *) echo "Aufruf: tor_rest.sh sichern <gen> <phase> | anwenden <gen>"; exit 2 ;;
esac
