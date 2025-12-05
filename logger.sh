#!/bin/bash
set -euo pipefail
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
LOGDIR="$SCRIPTDIR/logs"
LOGFILE="$LOGDIR/dms.log"
mkdir -p "$LOGDIR"
touch "$LOGFILE"
ACTION=${1:-UNKNOWN}
TARGET=${2:-N/A}
STATUS=${3:-N/A}
EXTRA=${4:-""}
USERNAME=${5:-${SUDO_USER:-${USER:-system}}}
printf "%s | User:%s | Action:%s | Target:%s | Status:%s %s\\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$USERNAME" "$ACTION" "$TARGET" "$STATUS" "$EXTRA" >> "$LOGFILE"
if [ "$ACTION" = "SHOW" ]; then
    echo "---- Last 200 lines ----"
    tail -n 200 "$LOGFILE"
fi
