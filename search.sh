#!/bin/bash
set -euo pipefail

SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
DOCS="$SCRIPTDIR/docs"
USERS_FILE="$SCRIPTDIR/users.txt"

term="${1:-}"
USERNAME="${2:-$(whoami)}"

if [ -z "$term" ]; then
    echo "Usage: $0 \"search-term\" [username]"
    exit 2
fi

# Get role properly
role=$(grep -E "^${USERNAME}:" "$USERS_FILE" 2>/dev/null | cut -d':' -f3)

if [ -z "$role" ]; then
    echo "Unknown user."
    exit 1
fi

# Search filenames only
results=$(find "$DOCS" -type f -iname "*$term*" 2>/dev/null)

if [ -n "$results" ]; then
    echo "$results"
    bash "$SCRIPTDIR/logger.sh" SEARCH "$term" FOUND "$USERNAME"
else
    echo "No matching filenames."
    bash "$SCRIPTDIR/logger.sh" SEARCH "$term" NOT_FOUND "$USERNAME"
fi
