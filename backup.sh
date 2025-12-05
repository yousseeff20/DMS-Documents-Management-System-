#!/bin/bash
set -euo pipefail
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
DOCS="$SCRIPTDIR/docs"
BACKUPS="$SCRIPTDIR/backups"
USERS_FILE="$SCRIPTDIR/users.txt"
USERNAME="${1:-$(whoami)}"
role=$(grep -E "^${USERNAME}:" "$USERS_FILE" 2>/dev/null | cut -d':' -f3 || echo "")
if [ "$role" != "admin" ]; then echo "Permission denied: only admin can backup"; exit 1; fi
mkdir -p "$BACKUPS"
ts=$(date +%Y%m%d_%H%M%S)
out="$BACKUPS/dms_backup_$ts.tar.gz"
tar -czf "$out" -C "$DOCS" .
bash "$SCRIPTDIR/logger.sh" BACKUP "$out" SUCCESS "$USERNAME"
echo "Backup created: $out"
