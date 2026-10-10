#!/usr/bin/env bash
# BOLLWERK · langes Tor abgekoppelt starten (Befund F-2 Teil 1, Lichtung L-9).
# Bash-Hintergrundbefehle enden nach höchstens 2 h; Tore phase/nacht/ziel laufen deshalb mit setsid nohup.
# Aufruf: bash tool/bollwerk/tor_start.sh <modus> [<baum>] [--gruppe <k>]
#   <baum> Standard /home/user/bw-arbeit/tor. Gibt PID und Logpfad aus (beides in den PRUEFPUNKT).
# Warten (Wartebefehl): timeout 590 bash -c 'until grep -qE "^BOLLWERK (GRÜN|ROT)" <log>; do sleep 30; done'
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
MODUS="${1:?modus}"; shift
BAUM=/home/user/bw-arbeit/tor
if [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; then BAUM="$1"; shift; fi
EXTRA=("$@")
case "$MODUS" in schnell|phase|nacht|ziel) ;; *) echo "Unbekannter Modus: $MODUS"; exit 2 ;; esac
SHA="$(git -C "$BAUM" rev-parse HEAD)"
mkdir -p /home/user/bw-logs
LOG="/home/user/bw-logs/tor-$MODUS-${SHA:0:7}${EXTRA[1]:+-g${EXTRA[1]}}.log"
cd "$BAUM"
setsid nohup flock /tmp/bw-schwer.lock dart run tool/bollwerk/bollwerk.dart "$MODUS" "${EXTRA[@]}" > "$LOG" 2>&1 < /dev/null &
echo "TOR $MODUS · SHA $SHA · PID $! (setsid) · Log $LOG"
