#!/bin/bash
set -euo pipefail
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
DOCS="$SCRIPTDIR/docs"
BACKUPS="$SCRIPTDIR/backups"
USERS_FILE="$SCRIPTDIR/users.txt"
USERNAME="${1:-$(whoami)}"
role=$(grep -E "^${USERNAME}:" "$USERS_FILE" 2>/dev/null | cut -d':' -f3 || echo "")
if [ "$role" != "admin" ]; then echo "Permission denied: only admin can restore"; exit 1; fi
mkdir -p "$BACKUPS"
echo "Available backups:"
ls -1 "$BACKUPS"
read -p "Enter backup filename to restore: " BACK
if [ ! -f "$BACKUPS/$BACK" ]; then echo "Backup not found"; exit 1; fi
rm -rf "$DOCS"/*
tar -xzf "$BACKUPS/$BACK" -C "$DOCS"
bash "$SCRIPTDIR/logger.sh" RESTORE "$BACK" SUCCESS "$USERNAME"
echo "Restore complete"
