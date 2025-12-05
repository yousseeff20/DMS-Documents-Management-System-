#!/bin/bash
set -euo pipefail
SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
DOCS="$SCRIPTDIR/docs"
USERS_FILE="$SCRIPTDIR/users.txt"
mkdir -p "$DOCS"

log() { bash "$SCRIPTDIR/logger.sh" "$1" "$2" "$3" "${4:-}"; }

get_role() {
    local u="$1"
    grep -E "^${u}:" "$USERS_FILE" 2>/dev/null | cut -d':' -f3 || echo ""
}

cmd="${1:-}"
arg="${2:-}"
USERNAME="${3:-$(whoami)}"

case "$cmd" in
    upload)
        role=$(get_role "$USERNAME")
        if [ -z "$role" ]; then echo "Unknown user."; exit 1; fi
        if [ "$role" != "admin" ] && [ "$role" != "staff" ]; then
            echo "Permission denied: cannot upload"; log UPLOAD "$USERNAME" DENIED; exit 1
        fi
        if [ -z "$arg" ]; then echo "Usage: $0 upload /path/to/file <username>"; exit 2; fi
        if [ ! -f "$arg" ]; then echo "Source not found"; log UPLOAD "$arg" FAILED source-not-found; exit 3; fi
        base=$(basename "$arg")
        dest="$DOCS/$base"
        cp "$arg" "$dest"
        chmod 640 "$dest"
        log UPLOAD "$dest" SUCCESS "$USERNAME"
        echo "Uploaded to $dest"
        ;;
    delete)
        role=$(get_role "$USERNAME")
        if [ -z "$role" ]; then echo "Unknown user."; exit 1; fi
        if [ "$role" != "admin" ] && [ "$role" != "staff" ]; then
            echo "Permission denied: cannot delete"; log DELETE "$USERNAME" DENIED; exit 1
        fi
        if [ -z "$arg" ]; then echo "Usage: $0 delete relative_name <username>"; exit 2; fi
        target="$DOCS/$arg"
        if [ ! -e "$target" ]; then echo "Not found"; log DELETE "$target" FAILED not-found; exit 3; fi
        rm -f "$target"
        log DELETE "$target" SUCCESS "$USERNAME"
        echo "Deleted $target"
        ;;
    list)
        ls -la "$DOCS"
        log LIST "$DOCS" SUCCESS "$USERNAME"
        ;;
    view)
        role=$(get_role "$USERNAME")
        if [ -z "$role" ]; then
            echo "Unknown user."
            exit 1
        fi

        if [ -z "$arg" ]; then
            echo "Usage: $0 view filename <username>"
            exit 2
        fi

        file="$DOCS/$arg"

        if [ ! -f "$file" ]; then
            echo "File not found."
            log VIEW "$file" FAILED not-found
            exit 3
        fi

        # --- Read-Only OPEN ---
        echo "Opening read-only view of '$arg'..."

        if command -v less >/dev/null 2>&1; then
            less -R "$file"
        elif command -v cat >/dev/null 2>&1; then
            cat "$file"
        else
            echo "Error: No viewer available."
            exit 4
        fi
        
        log VIEW "$file" SUCCESS "$USERNAME"
        ;;
    *)
        echo "Usage: $0 {upload|delete|list} args..."; exit 2
        ;;
esac
